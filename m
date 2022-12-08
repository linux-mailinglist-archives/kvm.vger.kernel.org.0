Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920E864787D
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiLHWDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiLHWDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:03:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1956B79C86
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 14:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KD6jgeTDpPWYmI7JUWNNM6hM+PbZv6qouXuSkY1QVZg=;
        b=FoPu3HvriRo87QJftRXNaqBt9lnpLptA0izyBpiXZ6GzVXzGixhpkNQ5M/Rxx8vBfA5b7W
        +FB1ZFB2yUChhdU47EzS4Adjubhgro0JWtylM/3RwXA+C2iEBgAYy9joeGFXRsr2NWH/mm
        Mf+uiZ0WpGIPhugqff6GSv65cJxRZLI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-8xXv_ycgPL2bhTfTyNeePg-1; Thu, 08 Dec 2022 17:00:48 -0500
X-MC-Unique: 8xXv_ycgPL2bhTfTyNeePg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A03AE857F90;
        Thu,  8 Dec 2022 22:00:47 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36A8140C6EC2;
        Thu,  8 Dec 2022 22:00:46 +0000 (UTC)
Message-ID: <b7605a328b9462a7d3b42ba8c884bfaf993155d6.camel@redhat.com>
Subject: Re: [PATCH v4 29/32] KVM: SVM: Handle multiple logical targets in
 AVIC kick fastpath
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Fri, 09 Dec 2022 00:00:45 +0200
In-Reply-To: <20221001005915.2041642-30-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-30-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
> Iterate over all target logical IDs in the AVIC kick fastpath instead of
> bailing if there is more than one target.  Now that KVM inhibits AVIC if
> vCPUs aren't mapped 1:1 with logical IDs, each bit in the destination is
> guaranteed to match to at most one vCPU, i.e. iterating over the bitmap
> is guaranteed to kick each valid target exactly once.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 112 ++++++++++++++++++++++------------------
>  1 file changed, 63 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a9e4e09f83fc..17e64b056e4e 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -327,6 +327,50 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
>  					icrl & APIC_VECTOR_MASK);
>  }
>  
> +static void avic_kick_vcpu_by_physical_id(struct kvm *kvm, u32 physical_id,
> +					  u32 icrl)
> +{
> +	/*
> +	 * KVM inhibits AVIC if any vCPU ID diverges from the vCPUs APIC ID,
> +	 * i.e. APIC ID == vCPU ID.
> +	 */
> +	struct kvm_vcpu *target_vcpu = kvm_get_vcpu_by_id(kvm, physical_id);
> +
> +	/* Once again, nothing to do if the target vCPU doesn't exist. */
> +	if (unlikely(!target_vcpu))
> +		return;
> +
> +	avic_kick_vcpu(target_vcpu, icrl);
> +}
> +
> +static void avic_kick_vcpu_by_logical_id(struct kvm *kvm, u32 *avic_logical_id_table,
> +					 u32 logid_index, u32 icrl)
> +{
> +	u32 physical_id;
> +
> +	if (avic_logical_id_table) {
> +		u32 logid_entry = avic_logical_id_table[logid_index];
> +
> +		/* Nothing to do if the logical destination is invalid. */
> +		if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
> +			return;
> +
> +		physical_id = logid_entry &
> +			      AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
> +	} else {
> +		/*
> +		 * For x2APIC, the logical APIC ID is a read-only value that is
> +		 * derived from the x2APIC ID, thus the x2APIC ID can be found
> +		 * by reversing the calculation (stored in logid_index).  Note,
> +		 * bits 31:20 of the x2APIC ID aren't propagated to the logical
> +		 * ID, but KVM limits the x2APIC ID limited to KVM_MAX_VCPU_IDS.
> +		 */
> +		physical_id = logid_index;
> +	}
> +
> +	avic_kick_vcpu_by_physical_id(kvm, physical_id, icrl);
> +}
> +
>  /*
>   * A fast-path version of avic_kick_target_vcpus(), which attempts to match
>   * destination APIC ID to vCPU without looping through all vCPUs.
> @@ -334,11 +378,10 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
>  static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source,
>  				       u32 icrl, u32 icrh, u32 index)
>  {
> -	u32 l1_physical_id, dest;
> -	struct kvm_vcpu *target_vcpu;
>  	int dest_mode = icrl & APIC_DEST_MASK;
>  	int shorthand = icrl & APIC_SHORT_MASK;
>  	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
> +	u32 dest;
>  
>  	if (shorthand != APIC_DEST_NOSHORT)
>  		return -EINVAL;
> @@ -355,14 +398,14 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  		if (!apic_x2apic_mode(source) && dest == APIC_BROADCAST)
>  			return -EINVAL;
>  
> -		l1_physical_id = dest;
> -
> -		if (WARN_ON_ONCE(l1_physical_id != index))
> +		if (WARN_ON_ONCE(dest != index))
>  			return -EINVAL;
>  
> +		avic_kick_vcpu_by_physical_id(kvm, dest, icrl);
>  	} else {
> -		u32 bitmap, cluster;
> -		int logid_index;
> +		u32 *avic_logical_id_table;
> +		unsigned long bitmap, i;
> +		u32 cluster;
>  
>  		if (apic_x2apic_mode(source)) {
>  			/* 16 bit dest mask, 16 bit cluster id */
> @@ -382,50 +425,21 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  		if (unlikely(!bitmap))
>  			return 0;
>  
> -		if (!is_power_of_2(bitmap))
> -			/* multiple logical destinations, use slow path */
> -			return -EINVAL;
> -
> -		logid_index = cluster + __ffs(bitmap);
> -
> -		if (apic_x2apic_mode(source)) {
> -			/*
> -			 * For x2APIC, the logical APIC ID is a read-only value
> -			 * that is derived from the x2APIC ID, thus the x2APIC
> -			 * ID can be found by reversing the calculation (done
> -			 * above).  Note, bits 31:20 of the x2APIC ID are not
> -			 * propagated to the logical ID, but KVM limits the
> -			 * x2APIC ID limited to KVM_MAX_VCPU_IDS.
> -			 */
> -			l1_physical_id = logid_index;
> -		} else {
> -			u32 *avic_logical_id_table =
> -				page_address(kvm_svm->avic_logical_id_table_page);
> -
> -			u32 logid_entry = avic_logical_id_table[logid_index];
> -
> -			if (WARN_ON_ONCE(index != logid_index))
> -				return -EINVAL;
> -
> -			/* Nothing to do if the logical destination is invalid. */
> -			if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
> -				return 0;
> -
> -			l1_physical_id = logid_entry &
> -					 AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
> -		}
> +		if (apic_x2apic_mode(source))
> +			avic_logical_id_table = NULL;
> +		else
> +			avic_logical_id_table = page_address(kvm_svm->avic_logical_id_table_page);
> +
> +		/*
> +		 * AVIC is inhibited if vCPUs aren't mapped 1:1 with logical
> +		 * IDs, thus each bit in the destination is guaranteed to map
> +		 * to at most one vCPU.
> +		 */
> +		for_each_set_bit(i, &bitmap, 16)
> +			avic_kick_vcpu_by_logical_id(kvm, avic_logical_id_table,
> +						     cluster + i, icrl);
>  	}
>  
> -	/*
> -	 * KVM inhibits AVIC if any vCPU ID diverges from the vCPUs APIC ID,
> -	 * i.e. APIC ID == vCPU ID.  Once again, nothing to do if the target
> -	 * vCPU doesn't exist.
> -	 */
> -	target_vcpu = kvm_get_vcpu_by_id(kvm, l1_physical_id);
> -	if (unlikely(!target_vcpu))
> -		return 0;
> -
> -	avic_kick_vcpu(target_vcpu, icrl);
>  	return 0;
>  }
>  


Looks OK, but I might have missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky


