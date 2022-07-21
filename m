Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906FB57D03C
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 17:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiGUPt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 11:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiGUPs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 11:48:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEC42B480
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 08:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658418532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+nImgMMtCWQDpksf0Q8VMWi1XHxli4GgXi12sbDxxsE=;
        b=FZYRdgweyMUFL5CfZ29IXPwFW6dF314Rk+xysh/AbxW7+8D1/P9j9z56kp/z0eFmF0m2eM
        9hfuEGiG/z8EB9tIy9G5mpXSuf6ljcgJzYmY3Ibuv4QFNEjZfrc5UWey+WSv6gj62cSFBc
        O3+tsEUNVaaTtArxGV/IjAyLDWfyjoA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-gFGjwVf3ODeDJWNzCjB2TQ-1; Thu, 21 Jul 2022 11:48:47 -0400
X-MC-Unique: gFGjwVf3ODeDJWNzCjB2TQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 879C51C05192;
        Thu, 21 Jul 2022 15:48:46 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CF50140EBE3;
        Thu, 21 Jul 2022 15:48:44 +0000 (UTC)
Message-ID: <dfcc309b1a9258efd2d8b97e0f6d795707941019.camel@redhat.com>
Subject: Re: [PATCHv2 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Shukla, Santosh" <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 Jul 2022 18:48:43 +0300
In-Reply-To: <a6b40519-e777-da9b-f5bf-4b65490d439a@amd.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
         <20220709134230.2397-4-santosh.shukla@amd.com>
         <641b171f53cb6a1e596e9591065a694fd2a59b69.camel@redhat.com>
         <6a1e7ce4-81af-ffb9-d193-a98375b632fd@amd.com>
         <d5df7e9e18528de56c41c24958901ace1e2d0aca.camel@redhat.com>
         <a6b40519-e777-da9b-f5bf-4b65490d439a@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 18:42 +0530, Shukla, Santosh wrote:
> 
> On 7/21/2022 5:31 PM, Maxim Levitsky wrote:
> > On Thu, 2022-07-21 at 15:04 +0530, Shukla, Santosh wrote:
> > > On 7/10/2022 9:45 PM, Maxim Levitsky wrote:
> > > > On Sat, 2022-07-09 at 19:12 +0530, Santosh Shukla wrote:
> > > > > VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
> > > > > NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
> > > > > read-only in the hypervisor and do not populate set accessors.
> > > > > 
> > > > > Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
> > > > > L2.
> > > > > 
> > > > > Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> > > > > ---
> > > > > v2:
> > > > > - Added get_vnmi_vmcb API to return vmcb for l1 and l2.
> > > > > - Use get_vnmi_vmcb to get correct vmcb in func -
> > > > >   is_vnmi_enabled/_mask_set()
> > > > > - removed vnmi check from is_vnmi_enabled() func.
> > > > > 
> > > > >  arch/x86/kvm/svm/svm.c | 12 ++++++++++--
> > > > >  arch/x86/kvm/svm/svm.h | 32 ++++++++++++++++++++++++++++++++
> > > > >  2 files changed, 42 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > index baaf35be36e5..3574e804d757 100644
> > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > @@ -198,7 +198,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
> > > > >  bool intercept_smi = true;
> > > > >  module_param(intercept_smi, bool, 0444);
> > > > >  
> > > > > -static bool vnmi;
> > > > > +bool vnmi = true;
> > > > >  module_param(vnmi, bool, 0444);
> > > > >  
> > > > >  static bool svm_gp_erratum_intercept = true;
> > > > > @@ -3503,13 +3503,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> > > > >  
> > > > >  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> > > > >  {
> > > > > -	return !!(vcpu->arch.hflags & HF_NMI_MASK);
> > > > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > > > +
> > > > > +	if (is_vnmi_enabled(svm))
> > > > > +		return is_vnmi_mask_set(svm);
> > > > > +	else
> > > > > +		return !!(vcpu->arch.hflags & HF_NMI_MASK);
> > > > >  }
> > > > >  
> > > > >  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> > > > >  {
> > > > >  	struct vcpu_svm *svm = to_svm(vcpu);
> > > > >  
> > > > > +	if (is_vnmi_enabled(svm))
> > > > > +		return;
> > > > > +
> > > > >  	if (masked) {
> > > > >  		vcpu->arch.hflags |= HF_NMI_MASK;
> > > > >  		if (!sev_es_guest(vcpu->kvm))
> > > > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > > > index 9223ac100ef5..f36e30df6202 100644
> > > > > --- a/arch/x86/kvm/svm/svm.h
> > > > > +++ b/arch/x86/kvm/svm/svm.h
> > > > > @@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
> > > > >  extern bool npt_enabled;
> > > > >  extern int vgif;
> > > > >  extern bool intercept_smi;
> > > > > +extern bool vnmi;
> > > > >  
> > > > >  /*
> > > > >   * Clean bits in VMCB.
> > > > > @@ -509,6 +510,37 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
> > > > >  	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > > >  }
> > > > >  
> > > > > +static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
> > > > > +{
> > > > > +	if (!vnmi)
> > > > > +		return NULL;
> > > > > +
> > > > > +	if (is_guest_mode(&svm->vcpu))
> > > > > +		return svm->nested.vmcb02.ptr;
> > > > > +	else
> > > > > +		return svm->vmcb01.ptr;
> > > > > +}
> > > > 
> > > > This is better but still not enough to support nesting:
> > > > 
> > > > 
> > > > Let me explain the cases that we need to cover:
> > > > 
> > > > 
> > > > 1. non nested case, vmcb01 has all the VNMI settings,
> > > > and I think it should work, but need to review the patches again.
> > > > 
> > > > 
> > > > 
> > > > 2. L1 uses vNMI, L2 doesn't use vNMI (nested_vnmi_enabled() == false).
> > > > 
> > > >   In this case, vNMI settings just need to be copied from vmcb01 to vmcb02
> > > >   and vise versa during nested entry and exit.
> > > > 
> > > > 
> > > >   This means that nested_vmcb02_prepare_control in this case should copy
> > > >   all 3 bits from vmcb01 to vmcb02, and vise versa nested_svm_vmexit
> > > >   should copy them back.
> > > > 
> > > >   Currently I see no indication of this being done in this patch series.
> > > > 
> > > 
> > > Yes, Thanks for pointing out, in v3 series.
> > > 
> > > >   vmcb02 should indeed be used to read vnmi bits (like done above).
> > > > 
> > > > 
> > > > 3. L1 uses vNMI, L2 uses vNMI:
> > > > 
> > > >   - First of all in this case all 3 vNMI bits should be copied from vmcb12
> > > >     to vmcb02 on nested entry and back on nested VM exit.
> > > > 
> > > >     I *think* this is done correctly in the patch 6, but I need to check again.
> > > > 
> > > >  
> > > >   - Second issue, depends on vNMI spec which we still don't have, and it
> > > >     relates to the fact on what to do if NMIs are not intercepted by
> > > >     the (nested) hypervisor, and L0 wants to inject an NMI
> > > > 
> > > >     (from L1 point of view it means that a 'real' NMI is about to be
> > > >     received while L2 is running).
> > > > 
> > > > 
> > > >     - If VNMI is not allowed to be enabled when NMIs are not intercepted,
> > > >       (vast majority of nested hypervisors will want to intercept real NMIs)
> > > >       then everything is fine -
> > > > 
> > > >       this means that if nested vNMI is enabled, then L1 will have
> > > >       to intercept 'real' NMIs, and thus L0 would be able to always
> > > >       inject 'real' NMIs while L2 is running by doing a VM exit to L1 without
> > > >       touching any vNMI state.
> > > > 
> > > Yes. Enabling NMI virtualization requires the NMI intercept bit to be set.
> > 
> > Those are very good news. 
> > 
> > What would happen though if the guest doesn't intercept NMI,
> > and still tries to enable vNMI? 
> > 
> > Failed VM entry or vNMI ignored?
> > 
> 
> VMEXIT_INVALID.

Perfect!
> 
> > This matters for nested because nested must work the same as real hardware.
> > 
> > In either of the cases some code is needed to emulate this correctly in the nested
> > virtualization code in KVM, but the patches have none.
> > 
> 
> Yes,. in v3.

Perfect!


Best regards,
	Maxim Levitsky

> 
> Thanks,
> Santosh
>  
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > > >     - If the vNMI spec states that if vNMI is enabled, real NMIs
> > > >       are not intercepted and a real NMI is arriving, then the CPU
> > > >       will use vNMI state to handle it (that is it will set the 'pending'
> > > >       bit, then check if 'masked' bit is set, and if not, move pending to masked
> > > >       and deliver NMI to L2, in this case, it is indeed right to use vmcb02
> > > >       and keep on using VNMI for NMIs that are directed to L1,
> > > >       but I highly doubt that this is the case.
> > > > 
> > > > 
> > > No.
> > > 
> > > >     - Most likely case - vNMI is allowed without NMI intercept,
> > > >       and real NMI does't consult the vNMI bits, but rather uses 'hosts'
> > > >       NMI masking. IRET doesn't affect host's NMI' masking as well.
> > > > 
> > > > 
> > > 
> > > No.
> > > 
> > > Thanks,
> > > Santosh
> > >  
> > > >       In this case, when L0 wants to inject NMI to a nested guest
> > > >       that has vNMI enabled, and doesn't intercept NMIs, it
> > > >       has to:
> > > > 
> > > >       - still consult the vNMI pending/masked bits of *vmcb01*,
> > > >         to know if it can inject a NMI
> > > > 
> > > >       - if it can inject it, it should update *manually* the pending/masked bits
> > > >         of vmcb01 as well, so that L1's vNMI the state remains consistent.
> > > > 
> > > >       - inject the NMI to L2, in the old fashioned way with EVENTINJ,
> > > > 	or open NMI window by intercepting IRET if NMI is masked.
> > > > 
> > > > 
> > > > Best regards,
> > > > 	Maxim Levitsky
> > > > 
> > > > 
> > > > 
> > > > 
> > > > > +
> > > > > +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
> > > > > +{
> > > > > +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > > > > +
> > > > > +	if (vmcb)
> > > > > +		return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
> > > > > +	else
> > > > > +		return false;
> > > > > +}
> > > > > +
> > > > > +static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
> > > > > +{
> > > > > +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > > > > +
> > > > > +	if (vmcb)
> > > > > +		return !!(vmcb->control.int_ctl & V_NMI_MASK);
> > > > > +	else
> > > > > +		return false;
> > > > > +}
> > > > > +
> > > > >  /* svm.c */
> > > > >  #define MSR_INVALID				0xffffffffU
> > > > >  


