Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6AD575506
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 20:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbiGNSaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 14:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240688AbiGNSaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 14:30:23 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86876B741
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:30:22 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f11so2325586pgj.7
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4BAm5Ap7NEHod+fAr+PGt31kGD7Q/EnOAXwYki9v/5c=;
        b=BCA39DCEAsKOKGBaqJR+l3QYfsmgwCJi40VgRFZwur6EN97IC7Kg8h2PQiyvtVNJpo
         wVF+zEhTF4MR3XQFSuVQ1vLJFSdPbLxr6Ej2tyO+cP5ckyNqDiydQD1Zgm6BkMcWJ5LR
         Z0SFYl7hsMAIyo/CMkAvPa2fT8Q0KMiiQHHG3RaPXVfWzzvgvNeJQ4fk/9L2OMC8OZ8A
         3fBoWitDcLIJnYHWfjkdr+6Xz1c9CueCZ3sMoEWzA2CtVvQea+Ct6fEo6+yQop59R5RN
         /1sc7hXyTwlL25l9n279LRiby4xwLFS2vzgNvgAAK+/KsrBFdbROM7wDRqcIzsFnPqD5
         T4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4BAm5Ap7NEHod+fAr+PGt31kGD7Q/EnOAXwYki9v/5c=;
        b=4vCX8sT4gapck1abUgTdDoSogVv5FZV9zQKvyL+q/mFtMmN+dL4005jHK2SVzdiPpx
         wJJ0c10BCY/+X88/EYoxGCCQ7xI7R7YS7vbzIMW4wXCWSJQWVVldtg0z9JWbG2GAoAR0
         MmaS25cP5VoiMUt4nSsBe3G6PQblJ3J9LfRePlW2+3Esg9YAnASXaFF4XAoNq8kk9V16
         E6/NTaf1jKrktR2GT5PBuWI3o0nlNMhNi4qLnJGNM1tjwFvGrckhKaVpB7YNgsgx1Cdp
         M6iJNz5/RciZLXWWOKgFir/Th6bdMwhH88J2wVqKkgf4YriSo98Z0YpHGBqeQ112PDJi
         mmEQ==
X-Gm-Message-State: AJIora+AbZFje9IcaXWtyMN4ClkufnY921VGIYK6p4lEPp83p6228Nt2
        6kjYI8IFrk5nw8EY1GYyyIri+w==
X-Google-Smtp-Source: AGRyM1sjxrHT/mbe4M8hvqrXQIDM4yXuUm7dhZKaRkKzb3JLGDowQCkR2H1I24UmOaD7DJvIAA+U9Q==
X-Received: by 2002:a05:6a00:2481:b0:52a:d50e:e75e with SMTP id c1-20020a056a00248100b0052ad50ee75emr9845998pfv.43.1657823422034;
        Thu, 14 Jul 2022 11:30:22 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id 186-20020a6214c3000000b0052ae3bcb807sm2009028pfu.188.2022.07.14.11.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 11:30:21 -0700 (PDT)
Date:   Thu, 14 Jul 2022 11:30:17 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH] KVM: arm64: selftests: Add support for GICv2 on v3
Message-ID: <YtBgueWEevIcS3EO@google.com>
References: <20220714154108.3531213-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714154108.3531213-1-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Jul 14, 2022 at 04:41:08PM +0100, Marc Zyngier wrote:
> The current vgic_init test wrongly assumes that the host cannot
> multiple versions of the GIC architecture, while v2 emulation
> on v3 has almost always been supported (it was supported before
> the standalone v3 emulation).

Thanks for the fix. This was my mistake (also I was taking too long to
send the fix).

> 
> Tweak the test to support multiple GIC incarnations.
> 

Nit. You could add a fixes tag:

Fixes: 3f4db37e203b ("KVM: arm64: selftests: Make vgic_init gic version agnostic")

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 34379c98d2f4..21ba4002fc18 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -670,7 +670,7 @@ int test_kvm_device(uint32_t gic_dev_type)
>  
>  	if (!_kvm_create_device(v.vm, other, true, &fd)) {
>  		ret = _kvm_create_device(v.vm, other, false, &fd);
> -		TEST_ASSERT(ret && errno == EINVAL,
> +		TEST_ASSERT(ret && (errno == EINVAL || errno == EEXIST),
>  				"create GIC device while other version exists");
>  	}
>  
> @@ -698,6 +698,7 @@ int main(int ac, char **av)
>  {
>  	int ret;
>  	int pa_bits;
> +	int cnt_impl = 0;
>  
>  	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
>  	max_phys_size = 1ULL << pa_bits;
> @@ -706,17 +707,19 @@ int main(int ac, char **av)
>  	if (!ret) {
>  		pr_info("Running GIC_v3 tests.\n");
>  		run_tests(KVM_DEV_TYPE_ARM_VGIC_V3);
> -		return 0;
> +		cnt_impl++;
>  	}
>  
>  	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V2);
>  	if (!ret) {
>  		pr_info("Running GIC_v2 tests.\n");
>  		run_tests(KVM_DEV_TYPE_ARM_VGIC_V2);
> -		return 0;
> +		cnt_impl++;
>  	}
>  
> -	print_skip("No GICv2 nor GICv3 support");
> -	exit(KSFT_SKIP);
> +	if (!cnt_impl) {
> +		print_skip("No GICv2 nor GICv3 support");
> +		exit(KSFT_SKIP);
> +	}
>  	return 0;
>  }
> -- 
> 2.34.1
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>
