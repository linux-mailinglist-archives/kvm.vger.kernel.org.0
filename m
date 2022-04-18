Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCCB504F32
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 13:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiDRLFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 07:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiDRLFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 07:05:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A25C71A051
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 04:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650279780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nfyC20li/WBHgH83pgVNfBHAw+SVDU5iVEtFvCRSQgA=;
        b=P4e2kAow7SNhfu3CGxJX6ojL4o6lhlfxSGfrIiR4xxoRkMA4CrO/x0HzfQ+Ru93p3oUwdF
        WJL3rEs1ZSLxWNOL1CvWMhu4UcwMBV93oAuv1nGNc6LQjjlBrOiVGhZGV6GrvW9kq+OSLN
        w/rXrWVG5Rc/B+ECERZaZ6/tLVPVwFQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-zcXAy2TyOdugN3c-IV-aQg-1; Mon, 18 Apr 2022 07:02:59 -0400
X-MC-Unique: zcXAy2TyOdugN3c-IV-aQg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83A25800B21;
        Mon, 18 Apr 2022 11:02:58 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CC38698CE9;
        Mon, 18 Apr 2022 11:02:56 +0000 (UTC)
Message-ID: <1e9ed17e6778b396927cfce5b3cdde889a61c305.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Introduce avic_kick_target_vcpus_fast()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 18 Apr 2022 14:02:55 +0300
In-Reply-To: <20220414051151.77710-2-suravee.suthikulpanit@amd.com>
References: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
         <20220414051151.77710-2-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 00:11 -0500, Suravee Suthikulpanit wrote:
> Currently, an AVIC-enabled VM suffers from performance bottleneck
> when scaling to large number of vCPUs for I/O intensive workloads.
> 
> In such case, a vCPU often executes halt instruction to get into idle state
> waiting for interrupts, in which KVM would de-schedule the vCPU from
> physical CPU.
> 
> When AVIC HW tries to deliver interrupt to the halting vCPU, it would
> result in AVIC incomplete IPI #vmexit to notify KVM to reschedule
> the target vCPU into running state.
> 
> Investigation has shown the main hotspot is in the kvm_apic_match_dest()
> in the following call stack where it tries to find target vCPUs
> corresponded to the information in the ICRH/ICRL registers.
> 
>   - handle_exit
>     - svm_invoke_exit_handler
>       - avic_incomplete_ipi_interception
>         - kvm_apic_match_dest
> 
> However, AVIC provides hints in the #vmexit info, which can be used to
> retrieve the destination guest physical APIC ID.
> 
> In addition, since QEMU defines guest physical APIC ID to be the same as
> vCPU ID, it can be used to quickly identify the target vCPU to deliver IPI,
> and avoid the overhead from searching through all vCPUs to match the target
> vCPU.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 91 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 87 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index abcf761c0c53..92d8e0de1fb4 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -351,11 +351,94 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
>  	put_cpu();
>  }
>  
> -static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
> -				   u32 icrl, u32 icrh)
> +/*
> + * A fast-path version of avic_kick_target_vcpus(), which attempts to match
> + * destination APIC ID to vCPU without looping through all vCPUs.
> + */
> +static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source,
> +				       u32 icrl, u32 icrh, u32 index)
>  {
> +	u32 dest, apic_id;
>  	struct kvm_vcpu *vcpu;
> +	int dest_mode = icrl & APIC_DEST_MASK;
> +	int shorthand = icrl & APIC_SHORT_MASK;
> +	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
> +	u32 *avic_logical_id_table = page_address(kvm_svm->avic_logical_id_table_page);
> +
> +	if (shorthand != APIC_DEST_NOSHORT)
> +		return -EINVAL;
> +
> +	/*
> +	 * The AVIC incomplete IPI #vmexit info provides index into
> +	 * the physical APIC ID table, which can be used to derive 
> +	 * guest physical APIC ID.
> +	 */
> +	if (dest_mode == APIC_DEST_PHYSICAL) {
> +		apic_id = index;
> +	} else {
> +		if (!apic_x2apic_mode(source)) {
> +			/* For xAPIC logical mode, the index is for logical APIC table. */
> +			apic_id = avic_logical_id_table[index] & 0x1ff;
> +		} else {
> +			/* For x2APIC logical mode, cannot leverage the index.
> +			 * Instead, calculate physical ID from logical ID in ICRH.
> +			 */
> +			int apic;
> +			int first = ffs(icrh & 0xffff);
> +			int last = fls(icrh & 0xffff);
> +			int cluster = (icrh & 0xffff0000) >> 16;
> +
> +			/*
> +			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0]) contains zero
> +			 * or more than 1 bits, we cannot match just one vcpu to kick for
> +			 * fast path.
> +			 */
> +			if (!first || (first != last))
> +				return -EINVAL;
> +
> +			apic = first - 1;
> +			if ((apic < 0) || (apic > 15) || (cluster >= 0xfffff))
> +				return -EINVAL;
> +			apic_id = (cluster << 4) + apic;
> +		}
> +	}
> +
> +	/*
> +	 * Assuming vcpu ID is the same as physical apic ID,
> +	 * and use it to retrieve the target vCPU.
> +	 */
> +	vcpu = kvm_get_vcpu_by_id(kvm, apic_id);
> +	if (!vcpu)
> +		return -EINVAL;
> +
> +	if (apic_x2apic_mode(vcpu->arch.apic))
> +		dest = icrh;
> +	else
> +		dest = GET_XAPIC_DEST_FIELD(icrh);
> +
> +	/*
> +	 * Try matching the destination APIC ID with the vCPU.
> +	 */
> +	if (kvm_apic_match_dest(vcpu, source, shorthand, dest, dest_mode)) {
> +		vcpu->arch.apic->irr_pending = true;
> +		svm_complete_interrupt_delivery(vcpu,
> +						icrl & APIC_MODE_MASK,
> +						icrl & APIC_INT_LEVELTRIG,
> +						icrl & APIC_VECTOR_MASK);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
> +				   u32 icrl, u32 icrh, u32 index)
> +{
>  	unsigned long i;
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!avic_kick_target_vcpus_fast(kvm, source, icrl, icrh, index))
> +		return;
>  
>  	/*
>  	 * Wake any target vCPUs that are blocking, i.e. waiting for a wake
> @@ -388,7 +471,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
>  	u32 icrl = svm->vmcb->control.exit_info_1;
>  	u32 id = svm->vmcb->control.exit_info_2 >> 32;
> -	u32 index = svm->vmcb->control.exit_info_2 & 0xFF;
> +	u32 index = svm->vmcb->control.exit_info_2 & 0x1FF;
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
>  	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
> @@ -415,7 +498,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  		 * set the appropriate IRR bits on the valid target
>  		 * vcpus. So, we just need to kick the appropriate vcpu.
>  		 */
> -		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
> +		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
>  		break;
>  	case AVIC_IPI_FAILURE_INVALID_TARGET:
>  		break;



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

