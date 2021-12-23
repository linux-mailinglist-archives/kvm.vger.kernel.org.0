Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B28947E659
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 17:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349181AbhLWQ0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 11:26:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244591AbhLWQ0f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Dec 2021 11:26:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640276794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QrlHmIY4mFoUxlNzEFbDzQmln3zBPSqJJI9vwL5pPpY=;
        b=ZGt2teeglGOxJOjY2gOGhzVn89SHlHFbPuUMxVFaj3pBKtvf57stwfDh6QJiBXDEKqRZSo
        DW9/zrFkfSoGqrqYNhGvOgGBOZA0Xbl1oH1olDwrAqt93th5DxGwaJ5nWAAHcGc+U978dD
        3GyBROWZzCtBl5KtRxWCLiRxjNW4aqs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-2d3yIVhWNWSp0FJSt9YXVg-1; Thu, 23 Dec 2021 11:26:33 -0500
X-MC-Unique: 2d3yIVhWNWSp0FJSt9YXVg-1
Received: by mail-ed1-f69.google.com with SMTP id d7-20020aa7ce07000000b003f84e9b9c2fso4846693edv.3
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 08:26:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QrlHmIY4mFoUxlNzEFbDzQmln3zBPSqJJI9vwL5pPpY=;
        b=Dp6t4g45Jf+0Vfsla57Ecpnosdj3zppbTxNjd4fDViqeoFDOBRt6hTipkdYA386ZOk
         jJL8FnbvdKKNVdpOiY1oOVqhy1KIqkuEIldW7UeAdf+bf8yvAYCW4c5UCG8ibLiBOn5K
         zY1/QPPNAL5lquQUkH8n/ATMMwecDOoRKoGXL75rBqU6EnREBCjOOOTF8u8yNo1imEpd
         fNBT6qbQA3EzKTob0hANVJBihBvHNeS0K+o26tjN9loNfBmXvjMKtL9k91hC7opbszN7
         nct3JIxuy/dM0fDntJLSH2AHdNcB6Uf7Zd6Hfq9VMSGfjPQU2VHwjiF1Aopj2IfdWmbm
         euAQ==
X-Gm-Message-State: AOAM532rht5Z0kziPORImvgoDJj4ZiW500WA6D/uW6285EVAc5tMpIpz
        SyqqbjG2kTl5/Soi6eBekZjsUPoe/nimpBjjcmL7afWxVuiTLLIr/jU3K1IdRNuxIT/ucWvE2RL
        f/2MT8ixS5A8q
X-Received: by 2002:a17:907:1c92:: with SMTP id nb18mr2489084ejc.249.1640276792287;
        Thu, 23 Dec 2021 08:26:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSub4/jrRZCW/Xw5IdU3TAQh4Ygh8ZQC1rVoHyx4sV8OkXGpQDqoKopfnZeSquQ1duYDmN7g==
X-Received: by 2002:a17:907:1c92:: with SMTP id nb18mr2488958ejc.249.1640276791776;
        Thu, 23 Dec 2021 08:26:31 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id k21sm2106368edo.87.2021.12.23.08.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 08:26:31 -0800 (PST)
Date:   Thu, 23 Dec 2021 17:26:29 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH 4/5] KVM: selftests: arm64: Check for supported page sizes
Message-ID: <20211223162629.cdbo5cxfmin5l4g6@gator.home>
References: <20211216123135.754114-1-maz@kernel.org>
 <20211216123135.754114-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216123135.754114-5-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16, 2021 at 12:31:34PM +0000, Marc Zyngier wrote:
> Just as arm64 implemenations don't necessary support all IPA
> ranges, they don't  all support the same page sizes either. Fun.
> 
> Create a dummy VM to snapshot the page sizes supported by the
> host, and filter the supported modes.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/lib/guest_modes.c | 51 ++++++++++++++++---
>  1 file changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index fadc99bac69c..8db9ea2c4032 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -5,7 +5,42 @@
>  #include "guest_modes.h"
>  
>  #ifdef __aarch64__
> +#include "processor.h"
>  enum vm_guest_mode vm_mode_default;
> +static void get_supported_psz(uint32_t ipa,
> +			      bool *ps4k, bool *ps16k, bool *ps64k)
> +{
> +	struct kvm_vcpu_init preferred_init;
> +	int kvm_fd, vm_fd, vcpu_fd, err;
> +	uint64_t val;
> +	struct kvm_one_reg reg = {
> +		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1),
> +		.addr	= (uint64_t)&val,
> +	};
> +
> +	kvm_fd = open_kvm_dev_path_or_exit();
> +	vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, ipa);
> +	TEST_ASSERT(vm_fd >= 0, "Can't create VM");
> +
> +	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
> +	TEST_ASSERT(vcpu_fd >= 0, "Can't create vcpu");
> +
> +	err = ioctl(vm_fd, KVM_ARM_PREFERRED_TARGET, &preferred_init);
> +	TEST_ASSERT(err == 0, "Can't get target");
> +	err = ioctl(vcpu_fd, KVM_ARM_VCPU_INIT, &preferred_init);
> +	TEST_ASSERT(err == 0, "Can't get init vcpu");
> +
> +	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
> +	TEST_ASSERT(err == 0, "Can't get MMFR0");
> +
> +	*ps4k = ((val >> 28) & 0xf) != 0xf;
> +	*ps64k = ((val >> 24) & 0xf) == 0;
> +	*ps16k = ((val >> 20) & 0xf) != 0;
> +
> +	close(vcpu_fd);
> +	close(vm_fd);
> +	close(kvm_fd);
> +}

I think I'd prefer stashing this function in lib/aarch64/processor.c and
naming it aarch64_get_supported_page_sizes.

>  #endif
>  
>  struct guest_mode guest_modes[NUM_VM_MODES];
> @@ -18,20 +53,24 @@ void guest_modes_append_default(void)
>  #ifdef __aarch64__
>  	{
>  		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +		bool ps4k, ps16k, ps64k;
>  		int i;
>  
> +		get_supported_psz(limit, &ps4k, &ps16k, &ps64k);
> +
>  		vm_mode_default = NUM_VM_MODES;
>  
>  		if (limit >= 52)
> -			guest_mode_append(VM_MODE_P52V48_64K, true, true);
> +			guest_mode_append(VM_MODE_P52V48_64K, ps64k, ps64k);
>  		if (limit >= 48) {
> -			guest_mode_append(VM_MODE_P48V48_4K, true, true);
> -			guest_mode_append(VM_MODE_P48V48_64K, true, true);
> +			guest_mode_append(VM_MODE_P48V48_4K, ps4k, ps4k);
> +			guest_mode_append(VM_MODE_P48V48_64K, ps64k, ps64k);
>  		}
>  		if (limit >= 40) {
> -			guest_mode_append(VM_MODE_P40V48_4K, true, true);
> -			guest_mode_append(VM_MODE_P40V48_64K, true, true);
> -			vm_mode_default = VM_MODE_P40V48_4K;
> +			guest_mode_append(VM_MODE_P40V48_4K, ps4k, ps4k);
> +			guest_mode_append(VM_MODE_P40V48_64K, ps64k, ps64k);
> +			if (ps4k)
> +				vm_mode_default = VM_MODE_P40V48_4K;
>  		}
>  
>  		/* Pick the largest supported IPA size */
> -- 
> 2.30.2
>

Thanks,
drew 

