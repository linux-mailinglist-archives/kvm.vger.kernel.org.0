Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B9B56D001
	for <lists+kvm@lfdr.de>; Sun, 10 Jul 2022 18:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGJQP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 12:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJQPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 12:15:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFCA1641B
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 09:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657469723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=133XWo39tBHS9yD9g4gr4qHAW5X2q9Mng/lIiHA+9FM=;
        b=eCiCvkHIfPpi24r8+NLC6ZZ997Q5nic9uLU+CDxlp8yJKvf10ETCKavaqH3nqI+qcBjG6O
        Wt0L/J5US4JbJnCY8IP+7ntcocXnmroHYgNaEfjm35c5ugdc+LOw0T8JZKVPPRQM3n9E/Z
        SYUOXCFQp0uXNBJECgpakjt7Nh1XMUM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-tdNV6dv0PImJzydFmHnLMw-1; Sun, 10 Jul 2022 12:15:20 -0400
X-MC-Unique: tdNV6dv0PImJzydFmHnLMw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2644F2A59547;
        Sun, 10 Jul 2022 16:15:20 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D32442026D64;
        Sun, 10 Jul 2022 16:15:17 +0000 (UTC)
Message-ID: <641b171f53cb6a1e596e9591065a694fd2a59b69.camel@redhat.com>
Subject: Re: [PATCHv2 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 10 Jul 2022 19:15:16 +0300
In-Reply-To: <20220709134230.2397-4-santosh.shukla@amd.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
         <20220709134230.2397-4-santosh.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-07-09 at 19:12 +0530, Santosh Shukla wrote:
> VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
> NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
> read-only in the hypervisor and do not populate set accessors.
> 
> Adding API(get_vnmi_vmcb) in order to return the correct vmcb for L1 or
> L2.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
> v2:
> - Added get_vnmi_vmcb API to return vmcb for l1 and l2.
> - Use get_vnmi_vmcb to get correct vmcb in func -
>   is_vnmi_enabled/_mask_set()
> - removed vnmi check from is_vnmi_enabled() func.
> 
>  arch/x86/kvm/svm/svm.c | 12 ++++++++++--
>  arch/x86/kvm/svm/svm.h | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index baaf35be36e5..3574e804d757 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -198,7 +198,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
>  bool intercept_smi = true;
>  module_param(intercept_smi, bool, 0444);
>  
> -static bool vnmi;
> +bool vnmi = true;
>  module_param(vnmi, bool, 0444);
>  
>  static bool svm_gp_erratum_intercept = true;
> @@ -3503,13 +3503,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  
>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>  {
> -	return !!(vcpu->arch.hflags & HF_NMI_MASK);
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (is_vnmi_enabled(svm))
> +		return is_vnmi_mask_set(svm);
> +	else
> +		return !!(vcpu->arch.hflags & HF_NMI_MASK);
>  }
>  
>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	if (is_vnmi_enabled(svm))
> +		return;
> +
>  	if (masked) {
>  		vcpu->arch.hflags |= HF_NMI_MASK;
>  		if (!sev_es_guest(vcpu->kvm))
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9223ac100ef5..f36e30df6202 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -35,6 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
>  extern int vgif;
>  extern bool intercept_smi;
> +extern bool vnmi;
>  
>  /*
>   * Clean bits in VMCB.
> @@ -509,6 +510,37 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>  	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
>  }
>  
> +static inline struct vmcb *get_vnmi_vmcb(struct vcpu_svm *svm)
> +{
> +	if (!vnmi)
> +		return NULL;
> +
> +	if (is_guest_mode(&svm->vcpu))
> +		return svm->nested.vmcb02.ptr;
> +	else
> +		return svm->vmcb01.ptr;
> +}

This is better but still not enough to support nesting:


Let me explain the cases that we need to cover:


1. non nested case, vmcb01 has all the VNMI settings,
and I think it should work, but need to review the patches again.



2. L1 uses vNMI, L2 doesn't use vNMI (nested_vnmi_enabled() == false).

  In this case, vNMI settings just need to be copied from vmcb01 to vmcb02
  and vise versa during nested entry and exit.


  This means that nested_vmcb02_prepare_control in this case should copy
  all 3 bits from vmcb01 to vmcb02, and vise versa nested_svm_vmexit
  should copy them back.

  Currently I see no indication of this being done in this patch series.

  vmcb02 should indeed be used to read vnmi bits (like done above).


3. L1 uses vNMI, L2 uses vNMI:

  - First of all in this case all 3 vNMI bits should be copied from vmcb12
    to vmcb02 on nested entry and back on nested VM exit.

    I *think* this is done correctly in the patch 6, but I need to check again.

 
  - Second issue, depends on vNMI spec which we still don't have, and it
    relates to the fact on what to do if NMIs are not intercepted by
    the (nested) hypervisor, and L0 wants to inject an NMI

    (from L1 point of view it means that a 'real' NMI is about to be
    received while L2 is running).


    - If VNMI is not allowed to be enabled when NMIs are not intercepted,
      (vast majority of nested hypervisors will want to intercept real NMIs)
      then everything is fine -

      this means that if nested vNMI is enabled, then L1 will have
      to intercept 'real' NMIs, and thus L0 would be able to always
      inject 'real' NMIs while L2 is running by doing a VM exit to L1 without
      touching any vNMI state.

    - If the vNMI spec states that if vNMI is enabled, real NMIs
      are not intercepted and a real NMI is arriving, then the CPU
      will use vNMI state to handle it (that is it will set the 'pending'
      bit, then check if 'masked' bit is set, and if not, move pending to masked
      and deliver NMI to L2, in this case, it is indeed right to use vmcb02
      and keep on using VNMI for NMIs that are directed to L1,
      but I highly doubt that this is the case.


    - Most likely case - vNMI is allowed without NMI intercept,
      and real NMI does't consult the vNMI bits, but rather uses 'hosts'
      NMI masking. IRET doesn't affect host's NMI' masking as well.


      In this case, when L0 wants to inject NMI to a nested guest
      that has vNMI enabled, and doesn't intercept NMIs, it
      has to:

      - still consult the vNMI pending/masked bits of *vmcb01*,
        to know if it can inject a NMI

      - if it can inject it, it should update *manually* the pending/masked bits
        of vmcb01 as well, so that L1's vNMI the state remains consistent.

      - inject the NMI to L2, in the old fashioned way with EVENTINJ,
	or open NMI window by intercepting IRET if NMI is masked.


Best regards,
	Maxim Levitsky




> +
> +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> +
> +	if (vmcb)
> +		return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
> +	else
> +		return false;
> +}
> +
> +static inline bool is_vnmi_mask_set(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = get_vnmi_vmcb(svm);
> +
> +	if (vmcb)
> +		return !!(vmcb->control.int_ctl & V_NMI_MASK);
> +	else
> +		return false;
> +}
> +
>  /* svm.c */
>  #define MSR_INVALID				0xffffffffU
>  


