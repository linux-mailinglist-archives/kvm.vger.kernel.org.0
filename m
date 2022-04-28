Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0525135BC
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 15:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347759AbiD1Nyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 09:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347761AbiD1NyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 09:54:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E0C55EBFB
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 06:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651153865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FuiynTfD1RLuR66vVTzTONoWwWN8fYgLX9NPTT/dKvI=;
        b=D5GypMdsdqqOwzmx0TGKngPWhUfT8VMf3II7n9vT7LoqvtBnWkeD1MRWR2+I0kkiLdgj3w
        KugxqaF90ftCEdxNPgq8u49ujyKWcxW+6PNlClRr2TGouEexCCGXDXniY16U4OhMO5ZSMc
        2WAJOIj01x53rHNx9HjC/P7dpNGka14=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-6Xz61OvZN1aEwojcas8hzQ-1; Thu, 28 Apr 2022 09:50:58 -0400
X-MC-Unique: 6Xz61OvZN1aEwojcas8hzQ-1
Received: by mail-wr1-f70.google.com with SMTP id w4-20020adfbac4000000b0020acba4b779so1964159wrg.22
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 06:50:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=FuiynTfD1RLuR66vVTzTONoWwWN8fYgLX9NPTT/dKvI=;
        b=MM6KhmZqJGXB2es6BoSmgTNfkSCyam4bL4QNc+UAkThvl+5Vomafz2aW3X91/b7tPH
         HlNbdyRu0/8GelFyDSYo67bpBfqvGRlX6S354wi2ux5tQ74jcvNgxYSuxcu96+jazr+5
         vKSSRbseROv+JYG1lqLki5VFxfH4TLuWUgpaaZlAdyDVTIkvSylr/CHHuWUvGOtSTL5b
         XWeX0fxr7oLrWA+QvqVmhCQg+9Lpq/kgBehDU2U5CyddrQMi5i6T5zpKRrxiBwjh4ffq
         yV4mvxso5l9leoZznh41HTnkIB05AiNw7SqeFpELoNIueqCnXmC5lLlLxziW/opQWffm
         FGyw==
X-Gm-Message-State: AOAM5333w4O96WPSqa/S1qBmLkgFxcWui7paFWeStYuNw4k1mRPU2x1m
        SxzPz/rkS/JI+G4qnr0n23VGAlmM6BNk2BiMne0v/2W08iZQrPAmX78EdGzc9I2bl02q+u+K84m
        CGvTZMBmUdMOD
X-Received: by 2002:a05:600c:190b:b0:392:95b8:5b18 with SMTP id j11-20020a05600c190b00b0039295b85b18mr39560234wmq.152.1651153857206;
        Thu, 28 Apr 2022 06:50:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeVPvVPpXXrRQLuvUge6iFuS32PuH9PMzyLJBTvWQmhu79zqAA4V53hn1tleu4LtR6OCxdgA==
X-Received: by 2002:a05:600c:190b:b0:392:95b8:5b18 with SMTP id j11-20020a05600c190b00b0039295b85b18mr39560218wmq.152.1651153856918;
        Thu, 28 Apr 2022 06:50:56 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:ef00:7443:a23c:26b8:b96? (p200300cbc708ef007443a23c26b80b96.dip0.t-ipconnect.de. [2003:cb:c708:ef00:7443:a23c:26b8:b96])
        by smtp.gmail.com with ESMTPSA id p18-20020adfa212000000b0020adf08d88asm8984368wra.116.2022.04.28.06.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 06:50:55 -0700 (PDT)
Message-ID: <22f7742e-c009-c53b-8f14-34156ea1d135@redhat.com>
Date:   Thu, 28 Apr 2022 15:50:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220420113430.11876-1-pmorel@linux.ibm.com>
 <20220420113430.11876-3-pmorel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v8 2/2] s390x: KVM: resetting the Topology-Change-Report
In-Reply-To: <20220420113430.11876-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.04.22 13:34, Pierre Morel wrote:
> During a subsystem reset the Topology-Change-Report is cleared.
> Let's give userland the possibility to clear the MTCR in the case
> of a subsystem reset.
> 
> To migrate the MTCR, let's give userland the possibility to
> query the MTCR state.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  arch/s390/include/uapi/asm/kvm.h |   9 +++
>  arch/s390/kvm/kvm-s390.c         | 103 +++++++++++++++++++++++++++++++
>  2 files changed, 112 insertions(+)
> 
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index 7a6b14874d65..bb3df6d49f27 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
>  #define KVM_S390_VM_CRYPTO		2
>  #define KVM_S390_VM_CPU_MODEL		3
>  #define KVM_S390_VM_MIGRATION		4
> +#define KVM_S390_VM_CPU_TOPOLOGY	5
>  
>  /* kvm attributes for mem_ctrl */
>  #define KVM_S390_VM_MEM_ENABLE_CMMA	0
> @@ -171,6 +172,14 @@ struct kvm_s390_vm_cpu_subfunc {
>  #define KVM_S390_VM_MIGRATION_START	1
>  #define KVM_S390_VM_MIGRATION_STATUS	2
>  
> +/* kvm attributes for cpu topology */
> +#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR	0
> +#define KVM_S390_VM_CPU_TOPO_MTR_SET	1
> +
> +struct kvm_s390_cpu_topology {
> +	__u16 mtcr;
> +};

Just wondering:

1) Do we really need a struct for that
2) Do we want to leave some room for later expansion?

> +
>  /* for KVM_GET_REGS and KVM_SET_REGS */
>  struct kvm_regs {
>  	/* general purpose regs for s390 */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 925ccc59f283..755f325c9e70 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1756,6 +1756,100 @@ static int kvm_s390_sca_set_mtcr(struct kvm *kvm)
>  	return 0;
>  }
>  
> +/**
> + * kvm_s390_sca_clear_mtcr
> + * @kvm: guest KVM description
> + *
> + * Is only relevant if the topology facility is present,
> + * the caller should check KVM facility 11
> + *
> + * Updates the Multiprocessor Topology-Change-Report to signal
> + * the guest with a topology change.
> + */
> +static int kvm_s390_sca_clear_mtcr(struct kvm *kvm)
> +{
> +	struct bsca_block *sca = kvm->arch.sca;
> +	struct kvm_vcpu *vcpu;
> +	int val;
> +
> +	vcpu = kvm_s390_get_first_vcpu(kvm);
> +	if (!vcpu)
> +		return -ENODEV;

It would be cleaner to have ipte_lock/ipte_unlock variants that are
independent of a vcpu.

Instead of checking for "vcpu->arch.sie_block->eca & ECA_SII" we might
just check for sclp.has_siif. Everything else that performs the
lock/unlock should be contained in "struct kvm" directly, unless I am
missing something.

[...]

> +
> +static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	struct kvm_s390_cpu_topology *topology;
> +	int ret = 0;
> +
> +	if (!test_kvm_facility(kvm, 11))
> +		return -ENXIO;
> +
> +	topology = kzalloc(sizeof(*topology), GFP_KERNEL);
> +	if (!topology)
> +		return -ENOMEM;

I'm confused. We're allocating a __u16 to then free it again below? Why
not simply use a value on the stack like in kvm_s390_vm_get_migration()?



u16 mtcr;
...
mtcr = kvm_s390_sca_get_mtcr(kvm);

if (copy_to_user((void __user *)attr->addr, &mtcr, sizeof(mtcr)))
	return -EFAULT;
return 0;



> +
> +	topology->mtcr =  kvm_s390_sca_get_mtcr(kvm);

s/  / /

> +	if (copy_to_user((void __user *)attr->addr, topology,
> +			 sizeof(struct kvm_s390_cpu_topology)))
> +		ret = -EFAULT;
> +
> +	kfree(topology);
> +	return ret;
> +}
> +


-- 
Thanks,

David / dhildenb

