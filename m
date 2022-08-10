Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9195058F3C9
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 23:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbiHJVYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 17:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiHJVYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 17:24:32 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B40D71712;
        Wed, 10 Aug 2022 14:24:28 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1oLtBb-0001Cc-92; Wed, 10 Aug 2022 23:24:19 +0200
Message-ID: <bf9e8a9c-5172-b61a-be6e-87a919442fbd@maciej.szmigiero.name>
Date:   Wed, 10 Aug 2022 23:24:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com
References: <20220810061226.1286-1-santosh.shukla@amd.com>
 <20220810061226.1286-6-santosh.shukla@amd.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCHv3 5/8] KVM: SVM: Add VNMI support in inject_nmi
In-Reply-To: <20220810061226.1286-6-santosh.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.08.2022 08:12, Santosh Shukla wrote:
> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
> will clear V_NMI to acknowledge processing has started and will keep the
> V_NMI_MASK set until the processor is done with processing the NMI event.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
> v3:
> - Removed WARN_ON check.
> 
> v2:
> - Added WARN_ON check for vnmi pending.
> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
> 
>   arch/x86/kvm/svm/svm.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e260e8cb0c81..8c4098b8a63e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>   static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb *vmcb = NULL;
>   
> +	if (is_vnmi_enabled(svm)) {

I guess this should be "is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2"
since if nmi_l1_to_l2 is true then the NMI to be injected originally
comes from L1's VMCB12 EVENTINJ field.

As you said in the cover letter, this field has different semantics
than vNMI - specifically, it should allow injecting even if L2 is in
NMI blocking state (it's then up to L1 to keep track of NMI injectability
for its L2 guest - so L0 should be transparently injecting it when L1
wants so).

> +		vmcb = get_vnmi_vmcb(svm);
> +		vmcb->control.int_ctl |= V_NMI_PENDING;
> +		++vcpu->stat.nmi_injections;
> +		return;
> +	}
>   	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
>   
>   	if (svm->nmi_l1_to_l2)

Thanks,
Maciej
