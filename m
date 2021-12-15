Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04105476311
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 21:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbhLOUVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 15:21:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233601AbhLOUVH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 15:21:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639599666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/oU+MO6xSXAxFoQ6r9t9U2EPhK7g5y/gHx01nI9vvYg=;
        b=IMUPCwIuI1iJxpNpa3wnNzq9V3PSo01qQ8eTGNfXi9+Rope+81eerX86y3BANn2j6c5P6G
        Cq4x8R4YebvxDUvduFufkibr+VNz8Gk3ZfdoUbPSsnxsjZeaRTi9xmgd7/F6+TuN1bElj1
        PtrI82H4pUUMWm/6OzZOhwD7vApSENs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-hQj2QffeNGyg9DP_4LZZHg-1; Wed, 15 Dec 2021 15:21:02 -0500
X-MC-Unique: hQj2QffeNGyg9DP_4LZZHg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 609F01018F73;
        Wed, 15 Dec 2021 20:20:56 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA18A7A239;
        Wed, 15 Dec 2021 20:20:36 +0000 (UTC)
Message-ID: <5d608bd0c5964d620dc23bcf8847713115404b3b.camel@redhat.com>
Subject: Re: [PATCH 11/15] KVM: VMX: Update vmcs.GUEST_CR3 only when the
 guest CR3 is dirty
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date:   Wed, 15 Dec 2021 22:20:35 +0200
In-Reply-To: <604709fa-e8bd-4eb6-6b79-8bf031a785ce@linux.alibaba.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
         <20211108124407.12187-12-jiangshanlai@gmail.com>
         <0271da9d3a7494d9e7439d4b8d6d9c857c83a45e.camel@redhat.com>
         <604709fa-e8bd-4eb6-6b79-8bf031a785ce@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-16 at 00:31 +0800, Lai Jiangshan wrote:
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
> > >   
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
> > I just bisected this patch to break booting a VM with ept=1 but unrestricted_guest=0
> > (I needed to re-test unrestricted_guest=0 bug related to SMM, but didn't want
> > to boot without EPT. With ept=0,the VM boots with this patch applied).
> > 
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
>   	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>   		kvm_clear_async_pf_completion_queue(vcpu);
>   		kvm_async_pf_hash_reset(vcpu);
> +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>   	}
> 
>   	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
> 

Tested this patch and my guests boot. I didn't test more stuff like migration or so,
will do tomorrow.

Best regards,
	Maxim Levitsky

