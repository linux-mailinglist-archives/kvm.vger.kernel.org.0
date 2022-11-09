Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE53C622CB4
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 14:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiKINrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 08:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiKINrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 08:47:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81210D138
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 05:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668001607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/copwMj7IgI+0Z9Hfch0aP/1ldcqpVWftNlJZdONZ/4=;
        b=GfStDE7sxcvL7FGKqwmSAm27fjdHQ5Z4pHr2oO8iMj0EpSCys2kI1KgpfKZYa44AQSm/7B
        GIDMQNRvayNr/cPUJkV1tVWRuv66OBJWUTPFI6NZijbEq5PFu9LQvCwfSclKsCNgBYH+2r
        hbiQoef7JBSEapgLSvDsLcvX0fQIXlA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-219-Bx1kGp4TPyCCtHHanOT9Zg-1; Wed, 09 Nov 2022 08:46:46 -0500
X-MC-Unique: Bx1kGp4TPyCCtHHanOT9Zg-1
Received: by mail-wr1-f70.google.com with SMTP id j25-20020adfa559000000b0023d5d7f95a2so3453186wrb.21
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 05:46:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/copwMj7IgI+0Z9Hfch0aP/1ldcqpVWftNlJZdONZ/4=;
        b=aPFEk2W5SzupiiDiZkeLMTISgNSPBAAp/GOJYn12xbIPcym++O6B/2pHEczrdg8Mnj
         4Ewv8AZrkwgkLqpNVEmrfHZ1cvt3nbJxyRQc0s3zTbhkFx7TybX5sWGB5s3yobhKcmf+
         hHcJPeSg2/wt9WBeSvdiSTHGyHEXBvUV7a3bf/qB8RfEk8uBsVwg5K/lnkc0AKxAatUQ
         0HqUNDcDJIHVWJtQRsEV1Kd+0+u5VHBkaKIPqZVPXQhjMl1xtUGs5zt+Xf+E7RvBSq9b
         YWoJOF+hpstTQMrPa5ZnnBR1n+P/ilGmPiqy7UOWyB6ploLN0HaKIlmzB47EthwIcVx0
         iQmA==
X-Gm-Message-State: ACrzQf2FEYtqN8/PbYm1cRi+1RlrD6f+VRKZawhPBgmGy5e4L2UMan9N
        vO4BTU+Q4P1nmdJAAZki5gBbH2NAb9O5p4RzTL54BQdMBuvrxg72IOl1s1YOQElyTs7vjLSY/nJ
        QfYC47/rJcTtn
X-Received: by 2002:a05:600c:2314:b0:3cf:6b2a:7d93 with SMTP id 20-20020a05600c231400b003cf6b2a7d93mr36670786wmo.33.1668001605239;
        Wed, 09 Nov 2022 05:46:45 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6G44uwYHRldIvWFCJHFv/teUTPXKg3UAgUiUwSMnDKiFYib1nGTEhtAtV7PtqemY84GlKHAA==
X-Received: by 2002:a05:600c:2314:b0:3cf:6b2a:7d93 with SMTP id 20-20020a05600c231400b003cf6b2a7d93mr36670770wmo.33.1668001605000;
        Wed, 09 Nov 2022 05:46:45 -0800 (PST)
Received: from ovpn-194-83.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id az2-20020adfe182000000b00226dba960b4sm13744508wrb.3.2022.11.09.05.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 05:46:44 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
        pbonzini@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 5/6] KVM: selftests: Move hypercall() to hyper.h
In-Reply-To: <20221105045704.2315186-6-vipinsh@google.com>
References: <20221105045704.2315186-1-vipinsh@google.com>
 <20221105045704.2315186-6-vipinsh@google.com>
Date:   Wed, 09 Nov 2022 14:46:43 +0100
Message-ID: <877d04p7ek.fsf@ovpn-194-83.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vipin Sharma <vipinsh@google.com> writes:

> hypercall() can be used by other hyperv tests, move it to hyperv.h.
>

A similar patch is pending in my TLB flush series:

https://lore.kernel.org/kvm/20221101145426.251680-33-vkuznets@redhat.com/

> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  .../selftests/kvm/include/x86_64/hyperv.h       | 17 +++++++++++++++++
>  .../selftests/kvm/x86_64/hyperv_features.c      | 17 -----------------
>  2 files changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index 9d8c325af1d9..87d8d9e444f7 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -199,4 +199,21 @@ static inline uint64_t hv_linux_guest_id(void)
>  	       ((uint64_t)LINUX_VERSION_CODE << 16);
>  }
>  
> +static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
> +				vm_vaddr_t output_address, uint64_t *hv_status)
> +{
> +	uint8_t vector;
> +
> +	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
> +	asm volatile("mov %[output_address], %%r8\n\t"
> +		     KVM_ASM_SAFE("vmcall")
> +		     : "=a" (*hv_status),
> +		       "+c" (control), "+d" (input_address),
> +		       KVM_ASM_SAFE_OUTPUTS(vector)
> +		     : [output_address] "r"(output_address),
> +		       "a" (-EFAULT)
> +		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
> +	return vector;
> +}
> +
>  #endif /* !SELFTEST_KVM_HYPERV_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index b5a42cf1ad9d..31b22ee07dfb 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -13,23 +13,6 @@
>  #include "processor.h"
>  #include "hyperv.h"
>  
> -static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
> -				vm_vaddr_t output_address, uint64_t *hv_status)
> -{
> -	uint8_t vector;
> -
> -	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
> -	asm volatile("mov %[output_address], %%r8\n\t"
> -		     KVM_ASM_SAFE("vmcall")
> -		     : "=a" (*hv_status),
> -		       "+c" (control), "+d" (input_address),
> -		       KVM_ASM_SAFE_OUTPUTS(vector)
> -		     : [output_address] "r"(output_address),
> -		       "a" (-EFAULT)
> -		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
> -	return vector;
> -}
> -
>  struct msr_data {
>  	uint32_t idx;
>  	bool available;

-- 
Vitaly

