Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E655248F7
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352059AbiELJb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245428AbiELJb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:31:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F3C3612B0
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652347884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BL3CJGsqY/cqdqqI7zN3z8l2hVpezWWDtzBjCtMeqUg=;
        b=OXF1EdD8jFeB+hmkUpriJ/6Cws4uCCun+mg6TyM1izR2NWzZY/Tp+so0IdbCIdDYfsGML5
        Rtl5tq8T8Vo/StlpfxynWddM6JoXBWKrIPrLnpy6vRH9FVYsfPtKCZzgcAXFzKnwuQVBnq
        pYl13KVvT/UmIULbllxQiY0OZF2yjuk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-u8Z_AhCmM_eHHlzs9tCIQQ-1; Thu, 12 May 2022 05:31:21 -0400
X-MC-Unique: u8Z_AhCmM_eHHlzs9tCIQQ-1
Received: by mail-wr1-f69.google.com with SMTP id j21-20020adfa555000000b0020adb9ac14fso1842666wrb.13
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=BL3CJGsqY/cqdqqI7zN3z8l2hVpezWWDtzBjCtMeqUg=;
        b=dohV7PvrZWQ01DGxefCfHBeHNtwwve4LZD11ATArEySPKZh9Okb1lN7gOQ9DoLc4NW
         W4MewvpPWncDWmg2dxcWiDdnGr6+c9/emRCnax8mjftFlewET/AKR5pmZ/cQwCdQ/DrF
         UT6erLionXOt5uztlcDJlvvlpORVn9Ei/PathHyk62g6sHuADhP5FTkAj7oMqco0fSx5
         1duJRhjhipXpiHFR0bjRnyt/jD1gYxEoQdFbQhnORDisykH1qBGzu0tZwue++H+ihHAH
         d1SmkZ7u6gO/A8qNyDPx2vBo5ouLj4ev9z/IJHzHR/bDmUFtzP/fzlxwK9VjMW+6m6At
         PKdA==
X-Gm-Message-State: AOAM531bGaFQn0gWthk65+bGnkhPmvsOX1/PhcNaSuS1Pci67q78RA1n
        3/dl0fKu/hSt55Gm1/VevbLq/22f/eKXp1HuOubl4ei0RMi5/iPdns4RJvw9WofkpCfU4/rA7z5
        eLnBmuDsdLHWE
X-Received: by 2002:adf:fc42:0:b0:20a:c45d:3767 with SMTP id e2-20020adffc42000000b0020ac45d3767mr26462156wrs.486.1652347880721;
        Thu, 12 May 2022 02:31:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0UBVW7EQVs+UjMZICxFii2HRETE5UGdgxRAjQ7akuex9Vg2m4qZRuQs7QskMCy38QjmY7ZA==
X-Received: by 2002:adf:fc42:0:b0:20a:c45d:3767 with SMTP id e2-20020adffc42000000b0020ac45d3767mr26462123wrs.486.1652347880418;
        Thu, 12 May 2022 02:31:20 -0700 (PDT)
Received: from ?IPV6:2003:cb:c701:d200:ee5d:1275:f171:136d? (p200300cbc701d200ee5d1275f171136d.dip0.t-ipconnect.de. [2003:cb:c701:d200:ee5d:1275:f171:136d])
        by smtp.gmail.com with ESMTPSA id z14-20020a1c4c0e000000b003942a244ecfsm2143561wmf.20.2022.05.12.02.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 02:31:19 -0700 (PDT)
Message-ID: <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
Date:   Thu, 12 May 2022 11:31:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v9 3/3] s390x: KVM: resetting the Topology-Change-Report
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-4-pmorel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220506092403.47406-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.05.22 11:24, Pierre Morel wrote:
> During a subsystem reset the Topology-Change-Report is cleared.
> Let's give userland the possibility to clear the MTCR in the case
> of a subsystem reset.
> 
> To migrate the MTCR, let's give userland the possibility to
> query the MTCR state.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  arch/s390/include/uapi/asm/kvm.h |  5 ++
>  arch/s390/kvm/kvm-s390.c         | 79 ++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+)
> 
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index 7a6b14874d65..abdcf4069343 100644
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
> @@ -171,6 +172,10 @@ struct kvm_s390_vm_cpu_subfunc {
>  #define KVM_S390_VM_MIGRATION_START	1
>  #define KVM_S390_VM_MIGRATION_STATUS	2
>  
> +/* kvm attributes for cpu topology */
> +#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR	0
> +#define KVM_S390_VM_CPU_TOPO_MTR_SET	1
> +
>  /* for KVM_GET_REGS and KVM_SET_REGS */
>  struct kvm_regs {
>  	/* general purpose regs for s390 */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index c8bdce31464f..80a1244f0ead 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1731,6 +1731,76 @@ static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
>  	ipte_unlock(kvm);
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
> +static void kvm_s390_sca_clear_mtcr(struct kvm *kvm)
> +{
> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> +
> +	ipte_lock(kvm);
> +	sca->utility  &= ~SCA_UTILITY_MTCR;


One space too much.

sca->utility &= ~SCA_UTILITY_MTCR;

> +	ipte_unlock(kvm);
> +}
> +
> +static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	if (!test_kvm_facility(kvm, 11))
> +		return -ENXIO;
> +
> +	switch (attr->attr) {
> +	case KVM_S390_VM_CPU_TOPO_MTR_SET:
> +		kvm_s390_sca_set_mtcr(kvm);
> +		break;
> +	case KVM_S390_VM_CPU_TOPO_MTR_CLEAR:
> +		kvm_s390_sca_clear_mtcr(kvm);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +/**
> + * kvm_s390_sca_get_mtcr
> + * @kvm: guest KVM description
> + *
> + * Is only relevant if the topology facility is present,
> + * the caller should check KVM facility 11
> + *
> + * reports to QEMU the Multiprocessor Topology-Change-Report.
> + */
> +static int kvm_s390_sca_get_mtcr(struct kvm *kvm)
> +{
> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> +	int val;
> +
> +	ipte_lock(kvm);
> +	val = !!(sca->utility & SCA_UTILITY_MTCR);
> +	ipte_unlock(kvm);
> +
> +	return val;
> +}
> +
> +static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	int mtcr;

I think we prefer something like u16 when copying to user space.

> +
> +	if (!test_kvm_facility(kvm, 11))
> +		return -ENXIO;
> +
> +	mtcr = kvm_s390_sca_get_mtcr(kvm);
> +	if (copy_to_user((void __user *)attr->addr, &mtcr, sizeof(mtcr)))
> +		return -EFAULT;
> +
> +	return 0;
> +}

You should probably add documentation, and document that only the last
bit (0x1) has a meaning.

Apart from that LGTM.

-- 
Thanks,

David / dhildenb

