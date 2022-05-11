Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38CA523177
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239795AbiEKLZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237019AbiEKLZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:25:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D2DE2415E7
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hqVlDvCMcE/tiHufqNgKFkt8nO8gwuxe1+upIvX5Ak=;
        b=dpMcFkWfcNBZGmLZnXY/Bihu3uI0HGYP92H8ornxSLOzZkG9dmCGpyUj7QX6QMk642uM5Z
        4CD1UtVpoTGZJDt9iZqy0Rn6bGDLVPAaP9FzcGmLpuax3cgX+bcypxPrSmyS6zf5h4oLjU
        /VbpU0L2iD+2hvg5vBmmOLHNS69U4EI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-hvVlbODnP1-ixabgTo6srg-1; Wed, 11 May 2022 07:24:41 -0400
X-MC-Unique: hvVlbODnP1-ixabgTo6srg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE3D185A5A8;
        Wed, 11 May 2022 11:24:40 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA1822166B2F;
        Wed, 11 May 2022 11:24:38 +0000 (UTC)
Message-ID: <94cec439f345313c1a909f6a012665dd10686d47.camel@redhat.com>
Subject: Re: [PATCH v3 09/34] KVM: x86: hyper-v: Don't use
 sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:24:37 +0300
In-Reply-To: <20220414132013.1588929-10-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-10-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> Get rid of on-stack allocation of vcpu_mask and optimize kvm_hv_send_ipi()
> for a smaller number of vCPUs in the request. When Hyper-V TLB flush
> is in  use, HvSendSyntheticClusterIpi{,Ex} calls are not commonly used to
> send IPIs to a large number of vCPUs (and are rarely used in general).
> 
> Introduce hv_is_vp_in_sparse_set() to directly check if the specified
> VP_ID is present in sparse vCPU set.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 3cf68645a2e6..aebbb598ad1d 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1746,6 +1746,25 @@ static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
>  	}
>  }
>  
> +static bool hv_is_vp_in_sparse_set(u32 vp_id, u64 valid_bank_mask, u64 sparse_banks[])
> +{
> +	int bank, sbank = 0;
> +
> +	if (!test_bit(vp_id / HV_VCPUS_PER_SPARSE_BANK,
> +		      (unsigned long *)&valid_bank_mask))
> +		return false;
> +
> +	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
> +			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS) {
> +		if (bank == vp_id / HV_VCPUS_PER_SPARSE_BANK)
> +			break;
> +		sbank++;
> +	}
> +
> +	return test_bit(vp_id % HV_VCPUS_PER_SPARSE_BANK,
> +			(unsigned long *)&sparse_banks[sbank]);
> +}
> +
>  struct kvm_hv_hcall {
>  	u64 param;
>  	u64 ingpa;
> @@ -2089,8 +2108,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
>  }
>  
> -static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
> -				 unsigned long *vcpu_bitmap)
> +static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
> +				    u64 *sparse_banks, u64 valid_bank_mask)
I think the indentation is wrong here (was wrong before as well)


>  {
>  	struct kvm_lapic_irq irq = {
>  		.delivery_mode = APIC_DM_FIXED,
> @@ -2100,7 +2119,10 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
>  	unsigned long i;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
> +		if (sparse_banks &&
> +		    !hv_is_vp_in_sparse_set(kvm_hv_get_vpindex(vcpu),
> +					    valid_bank_mask,
> +					    sparse_banks))
>  			continue;
>  
>  		/* We fail only when APIC is disabled */
> @@ -2113,7 +2135,6 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	struct kvm *kvm = vcpu->kvm;
>  	struct hv_send_ipi_ex send_ipi_ex;
>  	struct hv_send_ipi send_ipi;
> -	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
>  	unsigned long valid_bank_mask;
>  	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>  	u32 vector;
> @@ -2175,13 +2196,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
>  		return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
> -	if (all_cpus) {
> -		kvm_send_ipi_to_many(kvm, vector, NULL);
> -	} else {
> -		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
> -
> -		kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
> -	}
> +	kvm_hv_send_ipi_to_many(kvm, vector, all_cpus ? NULL : sparse_banks, valid_bank_mask);
>  
>  ret_success:
>  	return HV_STATUS_SUCCESS;


Overall looks good to me, but I might have missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

