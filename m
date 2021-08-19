Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B223F1753
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 12:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbhHSKdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 06:33:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236149AbhHSKda (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 06:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629369174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bPjTLG6BnlhDR/yLVndhYDd5PxLKWVZhhC+KJM8dWd8=;
        b=PX3PbnMRCIdANhm0T54oMSqqvFLFBaXbJ30PfjM22/lTGwfBFfmqENNNiQr+DMK7VfSnmG
        nj2sVZ4T/PsPcT0b7EILoOx5AOklw05r+2CX8G0GRMKE8u89QlHfZrvRhy6V+MmWoKJiTj
        SL0ehqc2POOqptoul+IZA14xQEPOqEQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-zFZa0DEoNlmpjrrpO_KbrQ-1; Thu, 19 Aug 2021 06:32:52 -0400
X-MC-Unique: zFZa0DEoNlmpjrrpO_KbrQ-1
Received: by mail-ej1-f69.google.com with SMTP id j10-20020a17090686cab02905b86933b59dso2076035ejy.18
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 03:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bPjTLG6BnlhDR/yLVndhYDd5PxLKWVZhhC+KJM8dWd8=;
        b=CQaMzSX0Wh/iLTsftsUid4JRPphoNUKzjwoPrq9rRwiUuuljv/4LRLuesQ13Wt+R89
         2tKwWanFjHNR4W5VS/5KolT4Z2FsTt/ld2sAoX+jH8PSQj3x9iQ6ZS/8+ySbyIjFZkCg
         85wzvAMvUc33l/x7uyMnLA7P+r35rVWgJLrpunMkg/14SPw0prHz0vjUyz2UqVNgaU6e
         FNhCGfGoBhYyeH6SV+0s6iA4BRCCPWXlwlRmpvd23MR4rT7HwXDrP2Qz5NPkSDLcmeWc
         QDkgnhuw5Fa/iXUTNk1ycWKk+V85fyv6FubygUnyQawW6mV8/3mH9l3xZbho9ikHJMDe
         0czw==
X-Gm-Message-State: AOAM5329KBY+AZ9J/TXFsubDo6LQsmW4GYeaeeCCUyViJdo2S9/4ZXFI
        BDLZOu2YePiAN8cu4442/a1dUlJsH8Y0EiOqh2Exx0qbVQAjcz7nK2Bvs6nsPL/t9cQo8Talyvc
        7SB/xAmF83eMD
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr15674850edc.247.1629369171023;
        Thu, 19 Aug 2021 03:32:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR6IEWZyk9DeLg8lf82gXwmeVWOMXFyQatDgyWvCcITeJWw3vhfAeY3/pITKDuLrOs2mEb6A==
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr15674834edc.247.1629369170833;
        Thu, 19 Aug 2021 03:32:50 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id gw24sm1070469ejb.66.2021.08.19.03.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 03:32:50 -0700 (PDT)
Date:   Thu, 19 Aug 2021 12:32:47 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] selftests: KVM: Gracefully handle missing vCPU features
Message-ID: <20210819103247.ifawa4zoibw3mbah@gator.home>
References: <20210818212940.1382549-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818212940.1382549-1-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 09:29:40PM +0000, Oliver Upton wrote:
> An error of ENOENT for the KVM_ARM_VCPU_INIT ioctl indicates that one of
> the requested feature flags is not supported by the kernel/hardware.
> Detect the case when KVM doesn't support the requested features and skip
> the test rather than failing it.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
> Applies to 5.14-rc6. Tested by running all selftests on an Ampere Mt.
> Jade system.
> 
>  .../testing/selftests/kvm/lib/aarch64/processor.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 632b74d6b3ca..b1064a0c5e62 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -216,6 +216,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  {
>  	struct kvm_vcpu_init default_init = { .target = -1, };
>  	uint64_t sctlr_el1, tcr_el1;
> +	int ret;
>  
>  	if (!init)
>  		init = &default_init;
> @@ -226,7 +227,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
>  		init->target = preferred.target;
>  	}
>  
> -	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> +	ret = _vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
> +
> +	/*
> +	 * Missing kernel feature support should result in skipping the test,
> +	 * not failing it.
> +	 */
> +	if (ret && errno == ENOENT) {
> +		print_skip("requested vCPU features not supported; skipping test.");

", skipping test" will already be appended by print_skip().

> +		exit(KSFT_SKIP);
> +	}
> +
> +	TEST_ASSERT(!ret, "KVM_ARM_VCPU_INIT failed, rc: %i errno: %i (%s)",
> +		    ret, errno, strerror(errno));
>  
>  	/*
>  	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
> -- 
> 2.33.0.rc1.237.g0d66db33f3-goog
>

I think I'd rather try to keep exit(KSFT_SKIP)'s out of the lib code. It'd
be better if the test gets to decide whether to skip or not. How about
moving this check+skip into the test instead?

Thanks,
drew

