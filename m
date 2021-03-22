Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE6A344FB4
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 20:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhCVTQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 15:16:10 -0400
Received: from mail.skyhub.de ([5.9.137.197]:43944 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhCVTPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 15:15:41 -0400
Received: from zn.tnic (p200300ec2f066700d1873920611831f8.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:6700:d187:3920:6118:31f8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 565F61EC030E;
        Mon, 22 Mar 2021 20:15:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616440540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iJX3GF2CgIaOQc27uz5DRc8byMVlS9HWNPA5d8fZkIo=;
        b=ltFg2Gv+bV8xd96ltmseD8+Cag/9qRazqx2m9QiOIO39sZM9++/YnT+naK5uyi15xSQDSb
        5EHFoFX+MyhOXKQTlBd7K7A24f3AcS1M3lMZgdSiP3tfd3uaydumPdKuYqATgwtLK+KPUd
        6rZyWTa/A7M2jphlW/okYIgwfH27+g4=
Date:   Mon, 22 Mar 2021 20:15:40 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <20210322191540.GH6481@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic>
 <YFjoZQwB7e3oQW8l@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFjoZQwB7e3oQW8l@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 11:56:37AM -0700, Sean Christopherson wrote:
> Not necessarily.  This can only trigger in the host, and thus require a host
> reboot, if the host is also running enclaves.  If the CSP is not running
> enclaves, or is running its enclaves in a separate VM, then this path cannot be
> reached.

That's what I meant. Rebooting guests is a lot easier, ofc.

Or are you saying, this can trigger *only* when they're running enclaves
on the *host* too?

> EREMOVE can only fail if there's a kernel or hardware bug (or a VMM bug if
> running as a guest). 

We get those on a daily basis.

> IME, nearly every kernel/KVM bug that I introduced that led to EREMOVE
> failure was also quite fatal to SGX, i.e. this is just the canary in
> the coal mine.
>
> It's certainly possible to add more sophisticated error handling, e.g. through
> the pages onto a list and periodically try to recover them.  But, since the vast
> majority of bugs that cause EREMOVE failure are fatal to SGX, implementing
> sophisticated handling is quite low on the list of priorities.
> 
> Dave wanted the "page leaked" error message so that it's abundantly clear that
> the kernel is leaking pages on EREMOVE failure and that the WARN isn't "benign".

So this sounds to me like this should BUG too eventually.

Or is this one of those "this should never happen" things so no one
should worry?

Whatever it is, if an admin sees this message in dmesg and doesn't get a
lengthy explanation what she/he is supposed to do, I don't think she/he
will be as relaxed.

Hell, people open bugs for correctable ECCs and are asking whether they
need to replace their hardware.

So let's play this out: put yourself in an admin's shoes and tell me how
should an admin react when she/he sees that?

Should the kernel probably also say: "Don't worry, you have enough
memory and what's a 4K, who cares? You'll reboot eventually."

Or should the kernel say "You need to reboot ASAP."

And so on...

So what is the scenario here and what kind of reaction is that message
supposed to cause, recovery action, blabla, the whole spiel?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
