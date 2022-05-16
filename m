Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8362652828B
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 12:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242273AbiEPKt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 06:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237790AbiEPKt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 06:49:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A1C4275F3
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 03:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652698164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dF8ol8RqSgN1uVydLkEkOe/lSAk2b58yhc5X/QD6YNk=;
        b=P9xwGkfvZfJ5g6iCpZ+56XFi5++kra5Guei1/lr+wvriHPT575AugQbhijbV288aBgreGk
        hjEjuQgYBBqgBMO/Gajb39VRfRz+iy+l7CKp87tKDamsTdtFnwd2axN22ufEpSzbjPqf8G
        B0Fk3B5nWLd40n88Q0awNwAzK4/Y2vg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-xlB10UddPsy0UkfPdb0fYg-1; Mon, 16 May 2022 06:49:23 -0400
X-MC-Unique: xlB10UddPsy0UkfPdb0fYg-1
Received: by mail-wm1-f70.google.com with SMTP id m186-20020a1c26c3000000b003943e12185dso6575994wmm.7
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 03:49:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dF8ol8RqSgN1uVydLkEkOe/lSAk2b58yhc5X/QD6YNk=;
        b=NAf36m2rfxYIW9aTG/g5FxLUyi/M3kvaHRCmXezhcMBJrH7KEbInnqrv5czcncLmug
         U8VtaSoBNcynR91Ylrh7napqMwwCrHAVLZCyPTc4dvyF33YQKaooGtvyEMqnBk1hpWXS
         OdL4qkpPD42h/rLGrfNKhucIscegLuOG42bFLbYCS4VBSBmqOf6I+ruzcJWcA6KauHat
         Ie5R3F2wB+SjTT2xAeMt2l70ny5AyFbKuhxTqKGPtlFt8Q0/puRijk7FFMCTl1iebMZv
         T+V1zfljGvK4xxn5OjWZ+J3W+kd23TgmSN/OryvXkpRihdos8C22gA84AidPGgOHfrY6
         t/Cw==
X-Gm-Message-State: AOAM533RYFecIqZx8GbeYcSSsL6f/agp8kz/ztz8PLSat7FRJAvP69tb
        OOpNoLMIsDWfUPUDM1s+vrfjw/uS6jav9Ior4+as/soHvse+LsgJwmXN3REhkA0SU8Kt7PM6EfE
        BspHtu88j3hQR
X-Received: by 2002:a05:600c:354a:b0:394:8fa4:73bc with SMTP id i10-20020a05600c354a00b003948fa473bcmr26681003wmq.37.1652698162115;
        Mon, 16 May 2022 03:49:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKYhMbUOraZh9NG5nsuei6O6zPQnqkIRtO+I3S8ethr4MqOt5HH7CDzDs68WVWWGcgd3ZJ3A==
X-Received: by 2002:a05:600c:354a:b0:394:8fa4:73bc with SMTP id i10-20020a05600c354a00b003948fa473bcmr26680989wmq.37.1652698161931;
        Mon, 16 May 2022 03:49:21 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-178-142.web.vodafone.de. [109.43.178.142])
        by smtp.gmail.com with ESMTPSA id r7-20020adfab47000000b0020d0a57af5esm2122093wrc.79.2022.05.16.03.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 03:49:21 -0700 (PDT)
Message-ID: <68a5e0c8-2dd9-a8a2-0333-fef95b2e2dfc@redhat.com>
Date:   Mon, 16 May 2022 12:49:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 14/22] KVM: s390: mechanism to enable guest zPCI
 Interpretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-15-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220513191509.272897-15-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2022 21.15, Matthew Rosato wrote:
> The guest must have access to certain facilities in order to allow
> interpretive execution of zPCI instructions and adapter event
> notifications.  However, there are some cases where a guest might
> disable interpretation -- provide a mechanism via which we can defer
> enabling the associated zPCI interpretation facilities until the guest
> indicates it wishes to use them.
> 
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  4 ++++
>   arch/s390/kvm/kvm-s390.c         | 38 ++++++++++++++++++++++++++++++++
>   arch/s390/kvm/kvm-s390.h         | 10 +++++++++
>   3 files changed, 52 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index c1518a505060..8e381603b6a7 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -254,7 +254,10 @@ struct kvm_s390_sie_block {
>   #define ECB2_IEP	0x20
>   #define ECB2_PFMFI	0x08
>   #define ECB2_ESCA	0x04
> +#define ECB2_ZPCI_LSI	0x02
>   	__u8    ecb2;                   /* 0x0062 */
> +#define ECB3_AISI	0x20
> +#define ECB3_AISII	0x10
>   #define ECB3_DEA 0x08
>   #define ECB3_AES 0x04
>   #define ECB3_RI  0x01
> @@ -940,6 +943,7 @@ struct kvm_arch{
>   	int use_cmma;
>   	int use_pfmfi;
>   	int use_skf;
> +	int use_zpci_interp;
>   	int user_cpu_state_ctrl;
>   	int user_sigp;
>   	int user_stsi;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 5a0fbfd19c4a..0797661732cc 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1031,6 +1031,42 @@ static int kvm_s390_vm_set_crypto(struct kvm *kvm, struct kvm_device_attr *attr)
>   	return 0;
>   }
>   
> +static void kvm_s390_vcpu_pci_setup(struct kvm_vcpu *vcpu)
> +{
> +	/* Only set the ECB bits after guest requests zPCI interpretation */
> +	if (!vcpu->kvm->arch.use_zpci_interp)
> +		return;
> +
> +	vcpu->arch.sie_block->ecb2 |= ECB2_ZPCI_LSI;
> +	vcpu->arch.sie_block->ecb3 |= ECB3_AISII + ECB3_AISI;
> +}
> +
> +void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	lockdep_assert_held(&kvm->lock);
> +
> +	/*
> +	 * If host is configured for PCI and the necessary facilities are
> +	 * available, turn on interpretation for the life of this guest
> +	 */

I'd suggest to move the comment after the if-statement - it seems to fit 
better there.

> +	if (!kvm_s390_pci_interp_allowed())
> +		return;
> +
> +	kvm->arch.use_zpci_interp = 1;
> +
> +	kvm_s390_vcpu_block_all(kvm);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		kvm_s390_vcpu_pci_setup(vcpu);
> +		kvm_s390_sync_request(KVM_REQ_VSIE_RESTART, vcpu);
> +	}
> +
> +	kvm_s390_vcpu_unblock_all(kvm);
> +}

  Thomas

