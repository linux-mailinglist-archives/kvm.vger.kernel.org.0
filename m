Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E913275F528
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 13:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjGXLdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 07:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjGXLcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 07:32:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B4C10E4
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 04:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690198278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JfpT+mnZfrCac16v3aInlmHimudhY8zZWOx9+CfU5jI=;
        b=GQvO7aICKvu/RXr6lTBdWrb/116vxCs6mrf/5bYBz5vwKwvY/AxfKNDthtfRG1zQG0d6DK
        ni3e86mR04dyfhYH8CsKXIQTO2w/2brQtrvYHuMGhRTf8VWOzRebrWZ8W8EELvaGbShkaK
        QbcnXJIpuB3MOaCRHoqHytw8mDpjjBE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-j2RHxbGhMuSnBYyT3lF-fw-1; Mon, 24 Jul 2023 07:31:17 -0400
X-MC-Unique: j2RHxbGhMuSnBYyT3lF-fw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fbb0fdd060so26568465e9.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 04:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690198276; x=1690803076;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JfpT+mnZfrCac16v3aInlmHimudhY8zZWOx9+CfU5jI=;
        b=GUg7u464HSG46C9lxZqy1ZaITJXVX3Sqh+cLoED+cg9lUjkp4BjMHrdbR99mY1aOPT
         MyORNiaXUmN1ZoJxyTijTOCgLjXKKpaK4aRvdwMtkWsi2c/ilotX56kX3IxmiiZ0AK0j
         FV75n6F0sIY0XRXIbP7oD70JVB+XcnbGQVdCMhryzuqqQ78GVCINcOMZTAtDUCWvhJUF
         dYc+1k/mcm31LMwGmQpNr8i0nlMlwpfOwt6rQ+e8b0IgoHWuTv0/7+iKujfcWb+4K5yR
         ABVAmNCrO1u7Z4nVzT6e8c0/i4dO+DCkNV1OwKyobztJFylUawK1BxSHxS8s+EAZdcvG
         GyVA==
X-Gm-Message-State: ABy/qLZWTk7lNYHQcEUA9T0usECgaaQxtwbvyNe4uEvDYQzlQi+bsoLL
        hPX97MGHm91fsxGrknsiyKwJ32qkVAPdwLGnkerE7Am0/DyZTtmHgTOJimkqeVhh0phTE6exvMm
        kVbyJE14OeKQX
X-Received: by 2002:a05:600c:2242:b0:3fb:c990:3b2 with SMTP id a2-20020a05600c224200b003fbc99003b2mr7772963wmm.34.1690198276013;
        Mon, 24 Jul 2023 04:31:16 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGUPL3n/cnC/PIyIMNs1cuvjFmNfmTxRquxzSGXY0jphihcdCijrhdx91U2TwsjxeP5mV4SyQ==
X-Received: by 2002:a05:600c:2242:b0:3fb:c990:3b2 with SMTP id a2-20020a05600c224200b003fbc99003b2mr7772946wmm.34.1690198275671;
        Mon, 24 Jul 2023 04:31:15 -0700 (PDT)
Received: from ?IPV6:2003:cb:c73d:bb00:91a5:d1c:3a7e:4c77? (p200300cbc73dbb0091a50d1c3a7e4c77.dip0.t-ipconnect.de. [2003:cb:c73d:bb00:91a5:d1c:3a7e:4c77])
        by smtp.gmail.com with ESMTPSA id y19-20020a05600c20d300b003fd2d33f972sm5802964wmm.38.2023.07.24.04.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 04:31:15 -0700 (PDT)
Message-ID: <170e3285-2e01-840e-21bc-39dbad256542@redhat.com>
Date:   Mon, 24 Jul 2023 13:31:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 4/6] KVM: s390: interrupt: Fix single-stepping
 userspace-emulated instructions
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
 <20230724094716.91510-5-iii@linux.ibm.com>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230724094716.91510-5-iii@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.07.23 11:44, Ilya Leoshkevich wrote:
> Single-stepping a userspace-emulated instruction that generates an
> interrupt causes GDB to land on the instruction following it instead of
> the respective interrupt handler.
> 
> The reason is that after arranging a KVM_EXIT_S390_SIEIC exit,
> kvm_handle_sie_intercept() calls kvm_s390_handle_per_ifetch_icpt(),
> which sets KVM_GUESTDBG_EXIT_PENDING. This bit, however, is not
> processed immediately, but rather persists until the next ioctl(),
> causing a spurious single-step exit.
> 
> Fix by clearing this bit in ioctl().
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 23 ++++++++++++++++++++---
>   1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 0c6333b108ba..e6511608280c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5383,6 +5383,7 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>   {
>   	struct kvm_vcpu *vcpu = filp->private_data;
>   	void __user *argp = (void __user *)arg;
> +	int rc;
>   
>   	switch (ioctl) {
>   	case KVM_S390_IRQ: {
> @@ -5390,7 +5391,8 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>   
>   		if (copy_from_user(&s390irq, argp, sizeof(s390irq)))
>   			return -EFAULT;
> -		return kvm_s390_inject_vcpu(vcpu, &s390irq);
> +		rc = kvm_s390_inject_vcpu(vcpu, &s390irq);
> +		break;
>   	}
>   	case KVM_S390_INTERRUPT: {
>   		struct kvm_s390_interrupt s390int;
> @@ -5400,10 +5402,25 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>   			return -EFAULT;
>   		if (s390int_to_s390irq(&s390int, &s390irq))
>   			return -EINVAL;
> -		return kvm_s390_inject_vcpu(vcpu, &s390irq);
> +		rc = kvm_s390_inject_vcpu(vcpu, &s390irq);
> +		break;
>   	}
> +	default:
> +		rc = -ENOIOCTLCMD;
> +		break;
>   	}
> -	return -ENOIOCTLCMD;
> +
> +	/*
> +	 * To simplify single stepping of userspace-emulated instructions,
> +	 * KVM_EXIT_S390_SIEIC exit sets KVM_GUESTDBG_EXIT_PENDING (see
> +	 * should_handle_per_ifetch()). However, if userspace emulation injects
> +	 * an interrupt, it needs to be cleared, so that KVM_EXIT_DEBUG happens
> +	 * after (and not before) the interrupt delivery.
> +	 */
> +	if (!rc)
> +		vcpu->guest_debug &= ~KVM_GUESTDBG_EXIT_PENDING;
> +
> +	return rc;
>   }
>   
>   static int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu,

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

