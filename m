Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7DE622CBE
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 14:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiKINtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 08:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiKINtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 08:49:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3683313D47
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 05:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668001694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zW71t14jveGGZgaoQQW/oRTrMZaKQBZH55aeiywg1z4=;
        b=dKvFPCOvBhYm3UpH3D6IncNNePD05WRMXl0Xh2dUfihhpOqxbxa5HF27aifTtuTSOsv9L9
        Po4/WqvYPNQInXO+o76p/n60SN4M85tItpUvpS2RIQNMnEK7UhJ6sGUBdliJgnlNrTfMkM
        pyzW5s7YYHBsQ5r7coNJvyK4xG5jHO0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-483-GOCqfvjYPGO-2oAtKwyI_A-1; Wed, 09 Nov 2022 08:48:13 -0500
X-MC-Unique: GOCqfvjYPGO-2oAtKwyI_A-1
Received: by mail-wr1-f69.google.com with SMTP id j25-20020adfa559000000b0023d5d7f95a2so3454346wrb.21
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 05:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zW71t14jveGGZgaoQQW/oRTrMZaKQBZH55aeiywg1z4=;
        b=7PRu5rZ90aYK7LJHXYpZQGhokJ1g3W8s6R7fUJybaOAn/ceLjNhpWG/0C92Qf275gE
         UMw30j/YSQdL2d6qq/b4TFFDNy9MQ1axE5BxOyDtCnZ8ykaHB8+Bf/22+KzN9jyc3v3c
         7lLnDv6iGVoXppAYMuEGr+FOqLI2/m0lk4VBo1xwbuAGeZhX+rkNLFgHTT1c73ysFvZG
         PWpvHI6AkQW3mHqa+SrPCOZs3SQXN9mkqK4dYrEpPsA55VQA7yuFA/P7lWXlHvGsdcpY
         /wKWdhBHgpu1Fp3DCU5q4EPnPEXUHVA/IPVIcLvREuu00/YmWs7x1c+yZR3X2Ok36NE2
         L0Vw==
X-Gm-Message-State: ACrzQf37SifCb7r/CsRe7nJaGRa1USH+r02wtULL2hhFWtAXbdbS4ZtO
        7kyo4z8V25pTWqvuhGSjSghutdyzKOFw3p+W+7flCVLacxoKkP6CS/29wMHz2LpySAJvtyu376N
        dJVPfrTyqpsFz
X-Received: by 2002:a1c:4b0f:0:b0:3cf:7bdd:e00b with SMTP id y15-20020a1c4b0f000000b003cf7bdde00bmr32346333wma.110.1668001692151;
        Wed, 09 Nov 2022 05:48:12 -0800 (PST)
X-Google-Smtp-Source: AMsMyM78p2jb/ADj30WGIkRggDRp+A4tavN7K8n9FH6W+J9naIHHOt2dyB0ZdGpKfPgjZ2SFrm2Pag==
X-Received: by 2002:a1c:4b0f:0:b0:3cf:7bdd:e00b with SMTP id y15-20020a1c4b0f000000b003cf7bdde00bmr32346318wma.110.1668001691902;
        Wed, 09 Nov 2022 05:48:11 -0800 (PST)
Received: from ovpn-194-83.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m11-20020a5d4a0b000000b0022ca921dc67sm12874653wrq.88.2022.11.09.05.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 05:48:11 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
        pbonzini@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 4/6] KVM: selftests: Make Hyper-V guest OS ID common
In-Reply-To: <20221105045704.2315186-5-vipinsh@google.com>
References: <20221105045704.2315186-1-vipinsh@google.com>
 <20221105045704.2315186-5-vipinsh@google.com>
Date:   Wed, 09 Nov 2022 14:48:10 +0100
Message-ID: <874jv8p7c5.fsf@ovpn-194-83.brq.redhat.com>
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

> Make guest OS ID calculation common to all hyperv tests and similar to
> hv_generate_guest_id().

A similar (but without hv_linux_guest_id()) patch is present in my
Hyper-V TLB flush update:

https://lore.kernel.org/kvm/20221101145426.251680-32-vkuznets@redhat.com/

>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 10 ++++++++++
>  tools/testing/selftests/kvm/x86_64/hyperv_clock.c    |  2 +-
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c |  6 ++----
>  tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c |  2 +-
>  4 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index 075fd29071a6..9d8c325af1d9 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -9,6 +9,10 @@
>  #ifndef SELFTEST_KVM_HYPERV_H
>  #define SELFTEST_KVM_HYPERV_H
>  
> +#include <linux/version.h>
> +
> +#define HV_LINUX_VENDOR_ID			0x8100
> +
>  #define HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS	0x40000000
>  #define HYPERV_CPUID_INTERFACE			0x40000001
>  #define HYPERV_CPUID_VERSION			0x40000002
> @@ -189,4 +193,10 @@
>  /* hypercall options */
>  #define HV_HYPERCALL_FAST_BIT		BIT(16)
>  
> +static inline uint64_t hv_linux_guest_id(void)
> +{
> +	return ((uint64_t)HV_LINUX_VENDOR_ID << 48) |
> +	       ((uint64_t)LINUX_VERSION_CODE << 16);
> +}
> +
>  #endif /* !SELFTEST_KVM_HYPERV_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> index d576bc8ce823..f9112c5dc3f7 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> @@ -104,7 +104,7 @@ static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_
>  
>  	/* Set Guest OS id to enable Hyper-V emulation */
>  	GUEST_SYNC(1);
> -	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
>  	GUEST_SYNC(2);
>  
>  	check_tsc_msr_rdtsc();
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 6b443ce456b6..b5a42cf1ad9d 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -13,8 +13,6 @@
>  #include "processor.h"
>  #include "hyperv.h"
>  
> -#define LINUX_OS_ID ((u64)0x8100 << 48)
> -
>  static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
>  				vm_vaddr_t output_address, uint64_t *hv_status)
>  {
> @@ -71,7 +69,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
>  
>  	GUEST_ASSERT(hcall->control);
>  
> -	wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
>  	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
>  
>  	if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
> @@ -169,7 +167,7 @@ static void guest_test_msrs_access(void)
>  			 */
>  			msr->idx = HV_X64_MSR_GUEST_OS_ID;
>  			msr->write = 1;
> -			msr->write_val = LINUX_OS_ID;
> +			msr->write_val = hv_linux_guest_id();
>  			msr->available = 1;
>  			break;
>  		case 3:
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> index a380ad7bb9b3..2c13a144b04c 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> @@ -69,7 +69,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
>  
>  	GUEST_SYNC(1);
>  
> -	wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
>  
>  	GUEST_ASSERT(svm->vmcb_gpa);
>  	/* Prepare for L2 execution. */

-- 
Vitaly

