Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ECA45168A
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 22:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350231AbhKOVau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 16:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353253AbhKOUzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 15:55:31 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF651C061228
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 12:44:33 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k4so15432654plx.8
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 12:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uP+Lof00RnU5VBEUYBScBMyNkoI7IQLBQTmGTJ/E9Rw=;
        b=pbWfDpJPl5AyHiDoCWqO9J/bgN+rR+f2gXuBNdHaBgEQejt1l0KGMbin+Ev1u4jJNk
         uI/9/laZlfCeoa0GfKuEQQIkAymcTsrIdCSSEFgiz0678TwmLLrWr7D00ud+LWjMWP0t
         9oU/BN+vUYZ6/JXY1AdLXwuT/xdxL9uNmpZyxBQ9Wxsz/id4wQX3vuXsHRwbwREzg1tG
         Mk1ZsAlpUBhPJ/Ru4NTLbdeyvrFBT6+xMN2Ao2l5NNQxI7SQmwWU6S3gdL0zcrv7jR9j
         1+PzpNC2ePUu+upox6SrUB9jizv7tSp9BKB3yOOtanx8neWjdNi5plB9kAZft22XMZjn
         sCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uP+Lof00RnU5VBEUYBScBMyNkoI7IQLBQTmGTJ/E9Rw=;
        b=DwxRP1nUxPTogngb8EhVepE8fjuEBJWPwPR6HYh0I2GfrtT33tKwOCHg7BnAoEOKYB
         iMxP5Yj4vag8BGAVGM5IT+TxOr+sd1Mu35ddd6+cIuNOJLn/pEVZEZvF+78TYfZB99kA
         pdube5V4PvsY6ClV2ATtt6kLNSXKefoEyJv6wh5+0Oqwv9q/8pWV1OxoNt7kASOG/qsP
         lv1cImw5knBRJ0yT0jZWu4m+pDj/JewzjDYskeptuS5QFD12pcWyuV9gLijPDB1T8rfx
         nfB7F3GtWW+tsCIGlMhbjtp3Rb83hjBmVBUnl/RYAYS0l8rntKOgWFv2NCKV+mVPAtvf
         Cd7g==
X-Gm-Message-State: AOAM532XbvToMapvFzVW31BwokHd6mIbAb0PkgpOk9/yfzUWhhPZ3csU
        xr+U8Rag94loUP/hArSRkREyaQ==
X-Google-Smtp-Source: ABdhPJx9jnoVyBGCOVHNj+lzvW01Z0C3XfY+9KMcpiyGAXQrhnxN93AYMgU+mF6buDnXIRgFRzSM0A==
X-Received: by 2002:a17:903:24d:b0:143:beb5:b6b1 with SMTP id j13-20020a170903024d00b00143beb5b6b1mr20785825plh.54.1637009073040;
        Mon, 15 Nov 2021 12:44:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k5sm112928pgt.49.2021.11.15.12.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 12:44:32 -0800 (PST)
Date:   Mon, 15 Nov 2021 20:44:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 2/2] KVM: x86/mmu: include efer.lma in extended mmu
 role
Message-ID: <YZLGrFZtYhERjIcH@google.com>
References: <20211115131837.195527-1-mlevitsk@redhat.com>
 <20211115131837.195527-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115131837.195527-3-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021, Maxim Levitsky wrote:
> When the host is running with normal TDP mmu (EPT/NPT),
> and it is running a nested 32 bit guest, then after a migration,
> the host mmu (aka root_mmu) is first initialized with
> nested guest's IA32_EFER, due to the way userspace restores
> the nested state.

Please try to avoid unnecessary newlines, I find it quite difficult to read as
my eyeballs need to jump around more.  E.g. wrapping at 75 chars yields

  When the host is running with normal TDP mmu (EPT/NPT), and it is running
  a nested 32 bit guest, then after a migration, the host mmu (aka root_mmu)
  is first initialized with nested guest's IA32_EFER, due to the way
  userspace restores the nested state.

  When later, this is corrected on first nested VM exit to the host, when
  host EFER is loaded from vmcs12, the root_mmu is not reset, because the
  role.base.level in this case, reflects the level of the TDP mmu which is
  always 4 (or 5) on EPT, and usually 4 or even 5 on AMD (when we have
  64-bit host).

  Since most of the paging state is already captured in the extended mmu
  role, just add the EFER.LMA there to force that reset.

> When later, this is corrected on first nested VM exit to the host,
> when host EFER is loaded from vmcs12,
> the root_mmu is not reset, because the role.base.level
> in this case, reflects the level of the TDP mmu which is
> always 4 (or 5) on EPT, and usually 4 or even 5 on AMD
> (when we have 64 bit host).
>
> Since most of the paging state is already captured in
> the extended mmu role, just add the EFER.LMA there to
> force that reset.

Similar to patch 1, I'd like to word the changelog to make it very clear that this
fix is _necessary_, not just a hack to fudge around QEMU behavior.  I've spent far
too much time deciphering historical KVM changelogs along the lines of "QEMU does
XYZ, change KVM to handle that", and in more than one case the "fix" has been wrong
and/or incomplete.

  Incorporate EFER.LMA into kvm_mmu_extended_role, as it used to compute the
  guest root level and is not reflected in kvm_mmu_page_role.level when TDP
  is in use.  When simply running the guest, it is impossible for EFER.LMA
  and kvm_mmu.root_level to get out of sync, as the guest cannot transition
  from PAE paging to 64-bit paging without toggling CR0.PG, i.e. without
  first bouncing through a different MMU context.  And stuffing guest state
  via KVM_SET_SREGS{2} also ensures a full MMU context reset.

  However, if KVM_SET_SREGS{2} is followed by KVM_SET_NESTED_STATE, e.g. to
  set guest state when migrating the VM while L2 is active, the vCPU state
  will reflect L2, not L1.  If L1 is using TDP for L2, then root_mmu will
  have been configured using L2's state, despite not being used for L2.  If
  L2.EFER.LMA != L1.EFER.LMA, and L2 is using PAE paging, then root_mmu will
  be configured for guest PAE paging, but will match the mmu_role for 64-bit
  paging and cause KVM to not   reconfigured root_mmu on the next nested
  VM-Exit.

And after typing that up, it's probably also worth adding a blurb to call out (and
argue against) the alternative.

  Alternatively, the root_mmu's role could be invalidated after a successful
  KVM_SET_NESTED_STATE that yields vcpu->arch.mmu != vcpu->arch.root_mmu,
  i.e. that switches the active mmu to guest_mmu, but doing so would force
  KVM to reconfigure the root_mmu in the common case where L1 and L2 have
  the same EFER, e.g. are both 64-bit guests.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu/mmu.c          | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 88fce6ab4bbd7..a44b9eb7d4d6d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -364,6 +364,7 @@ union kvm_mmu_extended_role {
>  		unsigned int cr4_smap:1;
>  		unsigned int cr4_smep:1;
>  		unsigned int cr4_la57:1;
> +		unsigned int efer_lma:1;
>  	};
>  };
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 354d2ca92df4d..5c4a41697a717 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4682,6 +4682,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
>  		/* PKEY and LA57 are active iff long mode is active. */
>  		ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
>  		ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
> +		ext.efer_lma = ____is_efer_lma(regs);
>  	}
>  
>  	ext.valid = 1;
> -- 
> 2.26.3
> 
