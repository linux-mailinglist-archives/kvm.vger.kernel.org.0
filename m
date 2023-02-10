Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17AB6918BD
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 07:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjBJGv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 01:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjBJGvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 01:51:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870727B143
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 22:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676011846;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WD+3OeLC7t29z+AkjFsHSbpBEyTbf21Yip53a4Y1e6s=;
        b=jO3eJ8euWbmcqNvghzpHY50aafhYOtNdyu95rFBauKe9oRCvhNsVDcTjajeqH41u+fgl+q
        TOq4b0OG98Ni29Fhz+zYCR5qnzZ3kE/AOmAUsi5qNdlwt650Ene3tc6SKWxUEqzaaC0Xtf
        ekSpy8HlbSX7Vavq9ny6EEc6u4eYsz0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-MJecnObXPfi-s2wQ2kHIgg-1; Fri, 10 Feb 2023 01:50:41 -0500
X-MC-Unique: MJecnObXPfi-s2wQ2kHIgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64A4B101A52E;
        Fri, 10 Feb 2023 06:50:40 +0000 (UTC)
Received: from [10.64.54.63] (vpn2-54-63.bne.redhat.com [10.64.54.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE2D72026D4B;
        Fri, 10 Feb 2023 06:50:34 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Limit length in
 kvm_vm_ioctl_mte_copy_tags() to INT_MAX
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20230208140105.655814-1-thuth@redhat.com>
 <20230208140105.655814-5-thuth@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <49f2e0db-d0f3-d162-af37-201feefff2ba@redhat.com>
Date:   Fri, 10 Feb 2023 17:50:32 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230208140105.655814-5-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/23 1:01 AM, Thomas Huth wrote:
> In case of success, this function returns the amount of handled bytes.
> However, this does not work for large values: The function is called
> from kvm_arch_vm_ioctl() (which still returns a long), which in turn
> is called from kvm_vm_ioctl() in virt/kvm/kvm_main.c. And that function
> stores the return value in an "int r" variable. So the upper 32-bits
> of the "long" return value are lost there.
> 
> KVM ioctl functions should only return "int" values, so let's limit
> the amount of bytes that can be requested here to INT_MAX to avoid
> the problem with the truncated return value. We can then also change
> the return type of the function to "int" to make it clearer that it
> is not possible to return a "long" here.
> 
> Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   Documentation/virt/kvm/api.rst    | 3 ++-
>   arch/arm64/include/asm/kvm_host.h | 4 ++--
>   arch/arm64/kvm/guest.c            | 8 ++++++--
>   3 files changed, 10 insertions(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0a67cb738013..f184427931fa 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5553,7 +5553,8 @@ with the KVM_XEN_VCPU_GET_ATTR ioctl.
>     };
>   
>   Copies Memory Tagging Extension (MTE) tags to/from guest tag memory. The
> -``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned. The ``addr``
> +``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned.
> +``length`` must not be bigger than 2^31 - PAGE_SIZE bytes. The ``addr``
>   field must point to a buffer which the tags will be copied to or from.
>   
>   ``flags`` specifies the direction of copy, either ``KVM_ARM_TAGS_TO_GUEST`` or
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 35a159d131b5..b1a16343767f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -963,8 +963,8 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>   int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>   			       struct kvm_device_attr *attr);
>   
> -long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> -				struct kvm_arm_copy_mte_tags *copy_tags);
> +int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> +			       struct kvm_arm_copy_mte_tags *copy_tags);
>   
>   /* Guest/host FPSIMD coordination helpers */
>   int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index cf4c495a4321..cadef953046f 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1013,8 +1013,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>   	return ret;
>   }
>   
> -long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> -				struct kvm_arm_copy_mte_tags *copy_tags)
> +int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> +			       struct kvm_arm_copy_mte_tags *copy_tags)
>   {
>   	gpa_t guest_ipa = copy_tags->guest_ipa;
>   	size_t length = copy_tags->length;
> @@ -1035,6 +1035,10 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>   	if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
>   		return -EINVAL;
>   
> +	/* Lengths above INT_MAX cannot be represented in the return value */
> +	if (length > INT_MAX)
> +		return -EINVAL;
> +
>   	gfn = gpa_to_gfn(guest_ipa);
>   
>   	mutex_lock(&kvm->slots_lock);
> 

