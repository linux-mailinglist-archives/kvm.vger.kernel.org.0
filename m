Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD61345279
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 23:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhCVWiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 18:38:01 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45096 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230085AbhCVWh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 18:37:29 -0400
Received: from zn.tnic (p200300ec2f0667002652a408eb3f04d7.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:6700:2652:a408:eb3f:4d7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4154E1EC04CC;
        Mon, 22 Mar 2021 23:37:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616452647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=I5j1MrJxhYiK7aTHBv0DWa/0nzDcq41qkrI2RFK3e0g=;
        b=CrQWkEpbEGeGXpL6WYamSLHVQN9X3aQPxuy0u29xCCQopbdW6F63oetAPTxD6srynhR5Mf
        tHFyChN1PHJr4GILxf7FjGlvtiDo4LMoMHiLaUt4qBYM0d10hWPBSO32rPj+NogBxUkwud
        /jil8TqUQhTXBt4qZ/O5fnrvv/C0lN4=
Date:   Mon, 22 Mar 2021 23:37:26 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <20210322223726.GJ6481@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic>
 <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 11:06:43AM +1300, Kai Huang wrote:
> This path is called by host SGX driver only, so yes this leaking is done by
> host enclaves only.

Yes, so I was told.

> This patch is purpose is to break EREMOVE out of sgx_free_epc_page() so virtual
> EPC code can use sgx_free_epc_page(), and handle EREMOVE logic differently.
> This patch doesn't have intention to bring functional change.  I changed the
> error msg because Dave said it worth to give a message saying EPC page is
> leaked, and I thought this minor change won't break anything.

I read that already - you don't have to repeat it.

> btw, currently virtual EPC code (patch 5) handles in similar way: There's one
> EREMOVE error is expected and virtual EPC code can handle, but for other
> errors, it means kernel bug, and virtual EPC code gives a WARN(), and that EPC
> page is leaked too:
> 
> +		WARN_ONCE(ret != SGX_CHILD_PRESENT,
> +			  "EREMOVE (EPC page 0x%lx): unexpected error: %d\n",
> +			  sgx_get_epc_phys_addr(epc_page), ret);
> +		return ret;
> 
> So to me they are just WARN() to catch kernel bug.

You don't care about users, do you? Because when that error happens,
they won't come crying to you to fix it.

Lemme save you some trouble: we don't take half-baked code into the
kernel until stuff has been discussed and analyzed properly. So instead
of trying to downplay this, try answering my questions.

Here's another one: when does EREMOVE fail?

/me goes and looks it up

"The instruction fails if the operand is not properly aligned or does
not refer to an EPC page or the page is in use by another thread, or
other threads are running in the enclave to which the page belongs. In
addition the instruction fails if the operand refers to an SECS with
associations."

And I guess those conditions will become more in the future.

Now, let's play. I'm the cloud admin and you're cloud OS customer
support. I say:

"I got this scary error message while running enclaves on my server

"EREMOVE returned ... .  EPC page leaked.  Reboot required to retrieve leaked pages."

but I cannot reboot that machine because there are guests running on it
and I'm getting paid for those guests and I might get sued if I do?"

Your turn, go wild.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
