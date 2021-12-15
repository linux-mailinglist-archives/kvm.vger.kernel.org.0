Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256F8476316
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 21:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhLOUVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 15:21:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235574AbhLOUV3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 15:21:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639599689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TjjD1SZhZHIu7B5Lh8wBQg1AtQipX8EiH4MI+U2mPvc=;
        b=GQ975VDu+vby/1wXtQQJFcMm8dayP9dTjh2p5VQj/koWCgRAeHIhnhh7dwIMZYsa0aDlku
        33EHh7W65aZj/6eDSsmy4XgMcVw7t7ZPJqk23M/qdgznpalxwFAgPu//JCkwfRjAAc0ELy
        QPpum73m3vlqz/Ert2Srwg5tDgLuEOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-IFkWdT8hMoKP0BOxUNolMQ-1; Wed, 15 Dec 2021 15:21:25 -0500
X-MC-Unique: IFkWdT8hMoKP0BOxUNolMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F360D100D0D5;
        Wed, 15 Dec 2021 20:21:20 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDCE04E2CC;
        Wed, 15 Dec 2021 20:21:16 +0000 (UTC)
Message-ID: <9486365ab24b1b8e7e9c791f99c7664954866a11.camel@redhat.com>
Subject: Re: [PATCH 11/15] KVM: VMX: Update vmcs.GUEST_CR3 only when the
 guest CR3 is dirty
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date:   Wed, 15 Dec 2021 22:21:15 +0200
In-Reply-To: <YbobskOcbRWMFmwb@google.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
         <20211108124407.12187-12-jiangshanlai@gmail.com>
         <0271da9d3a7494d9e7439d4b8d6d9c857c83a45e.camel@redhat.com>
         <604709fa-e8bd-4eb6-6b79-8bf031a785ce@linux.alibaba.com>
         <YbobskOcbRWMFmwb@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-12-15 at 16:45 +0000, Sean Christopherson wrote:
> On Thu, Dec 16, 2021, Lai Jiangshan wrote:
> > 
> > On 2021/12/15 23:47, Maxim Levitsky wrote:
> > > On Mon, 2021-11-08 at 20:44 +0800, Lai Jiangshan wrote:
> > > > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > > > 
> > > > When vcpu->arch.cr3 is changed, it is marked dirty, so vmcs.GUEST_CR3
> > > > can be updated only when kvm_register_is_dirty(vcpu, VCPU_EXREG_CR3).
> > > > 
> > > > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > > > ---
> > > >   arch/x86/kvm/vmx/vmx.c | 4 ++--
> > > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > index d94e51e9c08f..38b65b97fb7b 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > @@ -3126,9 +3126,9 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > > >   		if (!enable_unrestricted_guest && !is_paging(vcpu))
> > > >   			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
> > > > -		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> > > > +		else if (kvm_register_is_dirty(vcpu, VCPU_EXREG_CR3))
> > > >   			guest_cr3 = vcpu->arch.cr3;
> > > > -		else /* vmcs01.GUEST_CR3 is already up-to-date. */
> > > > +		else /* vmcs.GUEST_CR3 is already up-to-date. */
> > > >   			update_guest_cr3 = false;
> > > >   		vmx_ept_load_pdptrs(vcpu);
> > > >   	} else {
> > > 
> > > I just bisected this patch to break booting a VM with ept=1 but unrestricted_guest=0
> > > (I needed to re-test unrestricted_guest=0 bug related to SMM, but didn't want
> > > to boot without EPT. With ept=0,the VM boots with this patch applied).
> > > 
> > 
> > Thanks for reporting.
> > 
> > Sorry, I never tested it with unrestricted_guest=0. I can't reproduce it now shortly
> > with unrestricted_guest=0.  Maybe it can be reproduced easily if I try more guests or
> > I write a piece of guest code to deliberate hit it if the following analyses is correct.
> > 
> > All the paths changing %cr3 are followed with kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3)
> > and GUEST_CR3 will be expected to be updated.
> > 
> > What I missed is the case of "if (!enable_unrestricted_guest && !is_paging(vcpu))"
> > in vmx_load_mmu_pgd() which doesn't load GUEST_CR3 but clears dirty of VCPU_EXREG_CR3
> > (when after next run).
> > 
> > So when CR0 !PG -> PG, VCPU_EXREG_CR3 dirty bit should be set.
> > 
> > Maybe adding the following patch on top of the original patch can work.
> > 
> > Thanks
> > Lai
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 85127b3e3690..55b45005ebb9 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -858,6 +858,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
> >  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
> >  		kvm_clear_async_pf_completion_queue(vcpu);
> >  		kvm_async_pf_hash_reset(vcpu);
> > +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> 
> The better place for this is the path in vmx_set_cr0() that handles EPT + !URG.
> I believe nested_vmx_restore_host_state(), which is used to restore host state if
> hardware detects a VM-Fail that KVM misses on nested VM-Enter, is also missing a
> call to mark CR3 dirty.
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2f6f465e575f..b0c3eb80f5d5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4426,7 +4426,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
> 
>         nested_ept_uninit_mmu_context(vcpu);
>         vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> -       kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
> +       kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> 
>         /*
>          * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 640f4719612c..1701cee96678 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3066,8 +3066,10 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>                 }
> 
>                 /* Note, vmx_set_cr4() consumes the new vcpu->arch.cr0. */
> -               if ((old_cr0_pg ^ cr0) & X86_CR0_PG)
> +               if ((old_cr0_pg ^ cr0) & X86_CR0_PG) {
>                         vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
> +                       kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> +               }
>         }
> 
>         /* depends on vcpu->arch.cr0 to be set to a new value */
> 

I tested this patch and my guests boot as well. I didn't test more stuff like migration or so,
will do tomorrow.

Best regards,
	Maxim Levitsky

