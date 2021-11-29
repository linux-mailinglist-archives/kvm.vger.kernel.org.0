Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C91462668
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbhK2Wvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbhK2WuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:50:16 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7F4C0619DA
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 11:26:06 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id iq11so13474663pjb.3
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 11:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ky2ZS0rUrPmY585Dnw4cMPE4BkawU8vET/uCfEt239E=;
        b=YlIBSVAlHKxAWW2JlEpHea8Gr9tdF6cQeOBvYJLs+MyyqPyMfTBdlqTEY8zblbwS+S
         mlhRjS3eTaFRnTlGb8NaXkIEoz76LSeWfXpYmZdkHtOsK2dxuYI/xByC3gRLn/vs+y9l
         vlEQ4+s/SsYv0WMJ0iQqzENGPo/1F2TvlYeevuv7yow+1SBXUjOs2qf+EB7YGiFVRLSy
         /gMtKUp2SzYhwMHjPBjyQaJFSQxLP/HyJkNZ0IFvk1TABDS6ELJ6ACVa8VskhLOqcox5
         bqxWa8SLXKXcYUzrNLUXoX1gf4biuOsIM2NkBo7rLLIl4KoG6KNezMdIgyecEnYBV/FP
         8fsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ky2ZS0rUrPmY585Dnw4cMPE4BkawU8vET/uCfEt239E=;
        b=bqYHVGCrVpWvVjx8I9bpnkUxcWFHlieUnmL9o9QV8IWRYhRaQYXOKHRjb4rgxqxUhQ
         l88rBOm1+GQhvoP82fyr8VJi7/ESOzuMCx3euewS3+1ptOWKlcuPFGVoHV5t2PjLvnwE
         O43Wv/2/DWPqqZAlPbwyE6TF2T+vfYXc8zel87nGxbGSEQl5TTG8/x75zTcu7KVmE4LE
         OjyfU7Y6JALhLz0nzD0KyoxnteNy3qSt1P71LW+T8e/3/nSIK2w+VL1aYBFU/vXLaBeN
         bFnwFNbLmzb4PJtnDF6mP/UED3oYb1OVW8UJ7mnxeRB+b7pnuss/StY6flx8bNMtPv9U
         0Kng==
X-Gm-Message-State: AOAM531F8F3iCEHXD4yvcQCJHAOMCbQd1GrfUsU2er+afd1GiO0FBTI8
        UAelA/1vBPf/faXC0X5WmQ9Lew==
X-Google-Smtp-Source: ABdhPJxVDBh0tLzBePzWon0Vy8jcnvH1HV/QCaCT1ju+uUCmJKWa8FAh7XpASXU12te0Ot4f+gd9wQ==
X-Received: by 2002:a17:90b:1a8b:: with SMTP id ng11mr55940pjb.3.1638213965571;
        Mon, 29 Nov 2021 11:26:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z10sm18325951pfh.106.2021.11.29.11.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:26:05 -0800 (PST)
Date:   Mon, 29 Nov 2021 19:26:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: nVMX: Emulate guest TLB flush on nested
 VM-Enter with new vpid12
Message-ID: <YaUpSeLfa2OejA81@google.com>
References: <20211125014944.536398-1-seanjc@google.com>
 <20211125014944.536398-3-seanjc@google.com>
 <CAJhGHyBC1C71wchvqE_YztCvtkNgnmTN9FbBAOSz0K6SA3+WAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyBC1C71wchvqE_YztCvtkNgnmTN9FbBAOSz0K6SA3+WAA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021, Lai Jiangshan wrote:
> On Thu, Nov 25, 2021 at 9:49 AM Sean Christopherson <seanjc@google.com> wrote:
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 2ef1d5562a54..dafe5881ae51 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -1162,29 +1162,26 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
> >         WARN_ON(!enable_vpid);
> >
> >         /*
> > -        * If VPID is enabled and used by vmc12, but L2 does not have a unique
> > -        * TLB tag (ASID), i.e. EPT is disabled and KVM was unable to allocate
> > -        * a VPID for L2, flush the current context as the effective ASID is
> > -        * common to both L1 and L2.
> > -        *
> > -        * Defer the flush so that it runs after vmcs02.EPTP has been set by
> > -        * KVM_REQ_LOAD_MMU_PGD (if nested EPT is enabled) and to avoid
> > -        * redundant flushes further down the nested pipeline.
> > -        *
> > -        * If a TLB flush isn't required due to any of the above, and vpid12 is
> > -        * changing then the new "virtual" VPID (vpid12) will reuse the same
> > -        * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
> > -        * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
> > -        * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
> > -        * guest-physical mappings, so there is no need to sync the nEPT MMU.
> > +        * VPID is enabled and in use by vmcs12.  If vpid12 is changing, then
> > +        * emulate a guest TLB flush as KVM does not track vpid12 history nor
> > +        * is the VPID incorporated into the MMU context.  I.e. KVM must assume
> > +        * that the new vpid12 has never been used and thus represents a new
> > +        * guest ASID that cannot have entries in the TLB.
> >          */
> > -       if (!nested_has_guest_tlb_tag(vcpu)) {
> > -               kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > -       } else if (is_vmenter &&
> > -                  vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> > +       if (is_vmenter && vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> >                 vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> 
> How about when vmx->nested.last_vpid == vmcs12->virtual_processor_id == 0?
> 
> I think KVM_REQ_TLB_FLUSH_GUEST is needed in this case too.

That's handled by code that's just out of sight in this diff.  The first check in
nested_vmx_transition_tlb_flush() is to see if vmcs12 has VPID enabled.  If the
code in this patch is reached, vmcs12->virtual_processor_id is guaranteed to be
non-zero as VM-Enter fails if VPID is enabled but VPID==0.

static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
					    struct vmcs12 *vmcs12,
					    bool is_vmenter)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);

	/*
	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
	 * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
	 * full TLB flush from the guest's perspective.  This is required even
	 * if VPID is disabled in the host as KVM may need to synchronize the
	 * MMU in response to the guest TLB flush.
	 *
	 * Note, using TLB_FLUSH_GUEST is correct even if nested EPT is in use.
	 * EPT is a special snowflake, as guest-physical mappings aren't
	 * flushed on VPID invalidations, including VM-Enter or VM-Exit with
	 * VPID disabled.  As a result, KVM _never_ needs to sync nEPT
	 * entries on VM-Enter because L1 can't rely on VM-Enter to flush
	 * those mappings.
	 */
	if (!nested_cpu_has_vpid(vmcs12)) {
		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
		return;
	}

	...
}
