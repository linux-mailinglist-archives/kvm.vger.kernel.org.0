Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18A345163
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 22:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhCVVGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 17:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhCVVGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 17:06:49 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DFBC061574;
        Mon, 22 Mar 2021 14:06:49 -0700 (PDT)
Received: from zn.tnic (p200300ec2f066700a9da971702d05058.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:6700:a9da:9717:2d0:5058])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9430D1EC0323;
        Mon, 22 Mar 2021 22:06:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616447205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YuK2eDJya8CI3xvbIn6u7GalLPqKeIu/0i/IqiekymU=;
        b=r9nMd+lvwSQdcd1zO23XG/JipVeyyxPjq78iPvi7/a9lC7W2TsQwq/T61pa6KJ+8Mg23Ll
        6hCGp0YTzbJwDhTZo9KwM3dFDNuojdEyOTDgknQWpkI8h9m2XDwMeJlEKOkD7mZqlW3dkh
        wko5QY7FjIGWSZ/0W0hmqydYp4MTVOE=
Date:   Mon, 22 Mar 2021 22:06:45 +0100
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
Message-ID: <20210322210645.GI6481@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic>
 <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFjx3vixDURClgcb@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 12:37:02PM -0700, Sean Christopherson wrote:
> Yes.  Note, it's still true if you strike out the "too", KVM support is completely
> orthogonal to this code.  The purpose of this patch is to separate out the EREMOVE
> path used for host enclaves (/dev/sgx_enclave), because EPC virtualization for
> KVM will have non-buggy scenarios where EREMOVE can fail.  But the virt EPC code
> is designed to handle that gracefully.

"gracefully" as it won't leak EPC pages which would require a host reboot? That
leaking is done by host enclaves only?

> Hmm.  I don't think it warrants BUG.  At worst, leaking EPC pages is fatal only
> to SGX.

Fatal how? If it keeps leaking, at some point it won't have any pages
for EPC pages anymore?

Btw, I probably have seen this and forgotten again so pls remind me,
is the amount of pages available for SGX use static and limited by,
I believe BIOS, or can a leakage in EPC pages cause system memory
shortage?

> If the underlying bug caused other fallout, e.g. didn't release a
> lock, then obviously that could be fatal to the kernel. But I don't
> think there's ever a case where SGX being unusuable would prevent the
> kernel from functioning.

This kinda replies my question above but still...

> Probably something in between.  Odds are good SGX will eventually become
> unusuable, e.g. either kernel SGX support is completely hosted, or it will soon
> leak the majority of EPC pages.  Something like this?
> 
>   "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become unusuable.  Reboot recommended to continue using SGX."

So all this handwaving I'm doing is to provoke a proper response from
you guys as to how a EPC page leaking is supposed to be handled by the
users of the technology:

1. Issue a warning message and forget about it, eventual reboot

2. Really scary message to make users reboot sooner

3. Detect when host enclaves are run while guest enclaves are running
and issue a warning then.

4. Fall on knees and pray to not get sued by customers because their
enclaves are not working anymore.

....

Btw, 4. needs to be considered properly so that people can cover asses.

Oh and whatever we end up deciding, we should document that in
Documentation/... somewhere and point users to it in that warning
message where a longer treatise is explaining the whole deal properly.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
