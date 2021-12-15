Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC0A475DC5
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 17:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244978AbhLOQpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 11:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbhLOQpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 11:45:43 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAAFC061574
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 08:45:43 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v23so17896123pjr.5
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 08:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2QsTnAGwhbeyvyVhIih9F/F790r+3SpkzVSDxtbzYJc=;
        b=QyFQ/TYd3d3vvB6fCZIamD/OSG127/cmx8pelvGZV1SO7KYI/qmhaSbByePVW5B51P
         K75v5a5NOVgsrkJAXuAwPc28375ZlF2LYoowKzPj4BHPJTxxV+LP43YPozUkJSFpVCqp
         ZHW7q66yT6zXx3bAg2OVkxYhEh+gtRveB490adGzrZusgPAhrs5iXY0kjaGg1B9w3pYk
         AwUctsOc8DVHRN6rrOe1NHfZu/IIyXW3KHD4HSyKBBZvq9JNAKqeXCArSXrRQM0KIcBJ
         sx+wvu218OoKYvXcaLqOL8x3xgJRi5U+uQQzEzfXMz53aji1DyeR76E1zeXWpj1z/gfv
         qolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2QsTnAGwhbeyvyVhIih9F/F790r+3SpkzVSDxtbzYJc=;
        b=jMxMqAxngDIdvFu+laX/1SpOvWBFQPUqDGia1J/c2/EXUbbXTbqROa4WWL467jrGoA
         lkXcNVUzyTBV/7Z7UxubHOb98vebm31CHmDFt1UhM/HIjDQ3dDbs+6bclnSbSnCTHofx
         /zvnVEtPWlb4eIaS2iJdg+QfZQvPdI9ct3gs12O4fujBdr/DDExVoO5KVRTEnUm5NbJv
         xWEofiXgC/HhcCNN7UixpmO38fHpIK/LunolAJwXFHpxkU59gtSzcGGK4ydu2o0cG73X
         N7H60/FG46AG75x6eLSWzLftqH9//kFAXegFwqHakq47gf92ktT6+V7riEpu4QDa2szY
         oy5Q==
X-Gm-Message-State: AOAM533609kovNwrk8wyOwuXvPmcpR3Yt9FV/F/HmZytCwl4vtgcyEGV
        QVJNZZHgXU2qwaUm6NajB4sAvg==
X-Google-Smtp-Source: ABdhPJxnWS01CdYYYSiboW0jBXINOB4fWgb3Gl3W1K5jdAFPZ2/RVt6+/sAfqgjtVh01M2kS3QrOuQ==
X-Received: by 2002:a17:90b:3a83:: with SMTP id om3mr719122pjb.0.1639586741980;
        Wed, 15 Dec 2021 08:45:41 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o2sm3483873pfu.206.2021.12.15.08.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:45:41 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:45:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 11/15] KVM: VMX: Update vmcs.GUEST_CR3 only when the
 guest CR3 is dirty
Message-ID: <YbobskOcbRWMFmwb@google.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-12-jiangshanlai@gmail.com>
 <0271da9d3a7494d9e7439d4b8d6d9c857c83a45e.camel@redhat.com>
 <604709fa-e8bd-4eb6-6b79-8bf031a785ce@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604709fa-e8bd-4eb6-6b79-8bf031a785ce@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16, 2021, Lai Jiangshan wrote:
> 
> 
> On 2021/12/15 23:47, Maxim Levitsky wrote:
> > On Mon, 2021-11-08 at 20:44 +0800, Lai Jiangshan wrote:
> > > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > > 
> > > When vcpu->arch.cr3 is changed, it is marked dirty, so vmcs.GUEST_CR3
> > > can be updated only when kvm_register_is_dirty(vcpu, VCPU_EXREG_CR3).
> > > 
> > > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > > ---
> > >   arch/x86/kvm/vmx/vmx.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index d94e51e9c08f..38b65b97fb7b 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -3126,9 +3126,9 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > >   		if (!enable_unrestricted_guest && !is_paging(vcpu))
> > >   			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
> > > -		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> > > +		else if (kvm_register_is_dirty(vcpu, VCPU_EXREG_CR3))
> > >   			guest_cr3 = vcpu->arch.cr3;
> > > -		else /* vmcs01.GUEST_CR3 is already up-to-date. */
> > > +		else /* vmcs.GUEST_CR3 is already up-to-date. */
> > >   			update_guest_cr3 = false;
> > >   		vmx_ept_load_pdptrs(vcpu);
> > >   	} else {
> > 
> > 
> > I just bisected this patch to break booting a VM with ept=1 but unrestricted_guest=0
> > (I needed to re-test unrestricted_guest=0 bug related to SMM, but didn't want
> > to boot without EPT. With ept=0,the VM boots with this patch applied).
> > 
> 
> 
> Thanks for reporting.
> 
> Sorry, I never tested it with unrestricted_guest=0. I can't reproduce it now shortly
> with unrestricted_guest=0.  Maybe it can be reproduced easily if I try more guests or
> I write a piece of guest code to deliberate hit it if the following analyses is correct.
> 
> All the paths changing %cr3 are followed with kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3)
> and GUEST_CR3 will be expected to be updated.
> 
> What I missed is the case of "if (!enable_unrestricted_guest && !is_paging(vcpu))"
> in vmx_load_mmu_pgd() which doesn't load GUEST_CR3 but clears dirty of VCPU_EXREG_CR3
> (when after next run).
> 
> So when CR0 !PG -> PG, VCPU_EXREG_CR3 dirty bit should be set.
> 
> Maybe adding the following patch on top of the original patch can work.
> 
> Thanks
> Lai
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 85127b3e3690..55b45005ebb9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -858,6 +858,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>  		kvm_clear_async_pf_completion_queue(vcpu);
>  		kvm_async_pf_hash_reset(vcpu);
> +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);

The better place for this is the path in vmx_set_cr0() that handles EPT + !URG.
I believe nested_vmx_restore_host_state(), which is used to restore host state if
hardware detects a VM-Fail that KVM misses on nested VM-Enter, is also missing a
call to mark CR3 dirty.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2f6f465e575f..b0c3eb80f5d5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4426,7 +4426,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)

        nested_ept_uninit_mmu_context(vcpu);
        vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-       kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
+       kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);

        /*
         * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 640f4719612c..1701cee96678 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3066,8 +3066,10 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
                }

                /* Note, vmx_set_cr4() consumes the new vcpu->arch.cr0. */
-               if ((old_cr0_pg ^ cr0) & X86_CR0_PG)
+               if ((old_cr0_pg ^ cr0) & X86_CR0_PG) {
                        vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
+                       kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+               }
        }

        /* depends on vcpu->arch.cr0 to be set to a new value */

