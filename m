Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CB147E642
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 17:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349144AbhLWQRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 11:17:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244349AbhLWQRP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Dec 2021 11:17:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640276235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LGHYzwJFpl5d7o2k8SxIMF3wKZE8+ynpp2p5jw8mxzU=;
        b=O4b4dCmIMTNXiUxWoPDNjsuex629hvKC1flRrlCV5ctxhbZF5woxqTVknzdzW1iIiQ20Jm
        kor22FltuxQ4iLrN4qxf6+rVUjANW12pWRLbV+seMA6FBuEp7taEhikskbEQktWumVHsYL
        F1UrtCTGA8GrQbY4PvpfdFVCJTqNL5M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-BtFYh_9ePJqBqFYjYDy0gg-1; Thu, 23 Dec 2021 11:17:14 -0500
X-MC-Unique: BtFYh_9ePJqBqFYjYDy0gg-1
Received: by mail-ed1-f72.google.com with SMTP id o20-20020a056402439400b003f83cf1e472so4834823edc.18
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 08:17:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LGHYzwJFpl5d7o2k8SxIMF3wKZE8+ynpp2p5jw8mxzU=;
        b=YPsg9MvY/7evAk82LK/t1oZv8Y1Igtw4k7jCuPzlYUsuHSW6xdYurYAHHhBcOwXLAs
         hka/KAOGO3ZZjhcJaj7BhGpY+5X7G+sAR/PZeUYVQOlKCnRzhxK9xCCvk1ACMyrY2iMX
         FNUwmOi19MtGAu0huzflJIh5DskH6cOB0TuWfRbBNrZuynSmqXX6cM+r1FNYbQkpc0oE
         aFWAfe4nUTrdiCGXkqDOsIgnnOZqXA2gx4unZWfK9ePFfeTlqB8i6ZFaYl6INENJN5NM
         llzmJ3JUl8h0yaNlAcQHL9/zocDfed/g/1gpc6g1/go/U5JXM7/DWP/THTgGpfzb/IUN
         o/lw==
X-Gm-Message-State: AOAM531T83hldMgN/h4dYZMsteAASV32Mzl9xmXO7+9mwEbYKwWdWN6i
        q1uvMi5UFu25G3zBaYNkJCjrCL3f9pgHwoM8rdh2G48Cvtd2PQbOkeNLBb28Q2MMwuoOMAkIoS2
        /M9dgBmO/GExF
X-Received: by 2002:aa7:dd56:: with SMTP id o22mr2624454edw.73.1640276232960;
        Thu, 23 Dec 2021 08:17:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUPkJLnb1EUhOx+myvWcZIfjsLXUKVU1wzS4aV5TfG8x7KaiLf7iSrMJIF8BKFGDQyt6lFAw==
X-Received: by 2002:aa7:dd56:: with SMTP id o22mr2624436edw.73.1640276232745;
        Thu, 23 Dec 2021 08:17:12 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id eg12sm2118704edb.25.2021.12.23.08.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 08:17:12 -0800 (PST)
Date:   Thu, 23 Dec 2021 17:17:10 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH 3/5] KVM: selftests: arm64: Introduce a variable default
 IPA size
Message-ID: <20211223161710.ka3f2vjbmfuxp2op@gator.home>
References: <20211216123135.754114-1-maz@kernel.org>
 <20211216123135.754114-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216123135.754114-4-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16, 2021 at 12:31:33PM +0000, Marc Zyngier wrote:
> Contrary to popular belief, there is no such thing as a default
> IPA size on arm64. Anything goes, and implementations are the
> usual Wild West.
> 
> The selftest infrastructure default to 40bit IPA, which obviously
> doesn't work for some systems out there.
> 
> Turn VM_MODE_DEFAULT from a constant into a variable, and let
> guest_modes_append_default() populate it, depending on what
> the HW can do. In order to preserve the current behaviour, we
> still pick 40bits IPA as the default if it is available, and
> the largest supported IPA space otherwise.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  4 ++-
>  tools/testing/selftests/kvm/lib/guest_modes.c | 28 +++++++++++++++++--
>  2 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index c74241ddf8b1..d2ba830a1faf 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -53,7 +53,9 @@ enum vm_guest_mode {
>  
>  #if defined(__aarch64__)
>  
> -#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
> +extern enum vm_guest_mode vm_mode_default;
> +
> +#define VM_MODE_DEFAULT			vm_mode_default
>  #define MIN_PAGE_SHIFT			12U
>  #define ptes_per_page(page_size)	((page_size) / 8)
>  
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index c330f414ef96..fadc99bac69c 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -4,22 +4,46 @@
>   */
>  #include "guest_modes.h"
>  
> +#ifdef __aarch64__
> +enum vm_guest_mode vm_mode_default;
> +#endif
> +
>  struct guest_mode guest_modes[NUM_VM_MODES];
>  
>  void guest_modes_append_default(void)
>  {
> +#ifndef __aarch64__
>  	guest_mode_append(VM_MODE_DEFAULT, true, true);
> -
> +#endif
>  #ifdef __aarch64__
> -	guest_mode_append(VM_MODE_P40V48_64K, true, true);
>  	{
>  		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +		int i;
> +
> +		vm_mode_default = NUM_VM_MODES;
> +
>  		if (limit >= 52)
>  			guest_mode_append(VM_MODE_P52V48_64K, true, true);
>  		if (limit >= 48) {
>  			guest_mode_append(VM_MODE_P48V48_4K, true, true);
>  			guest_mode_append(VM_MODE_P48V48_64K, true, true);
>  		}
> +		if (limit >= 40) {
> +			guest_mode_append(VM_MODE_P40V48_4K, true, true);
> +			guest_mode_append(VM_MODE_P40V48_64K, true, true);
> +			vm_mode_default = VM_MODE_P40V48_4K;
> +		}
> +
> +		/* Pick the largest supported IPA size */

The guest_modes array isn't sorted from smallest to largest PA addresses,
although it could be.

> +		for (i = 0;
> +		     vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES;
> +		     i++) {

Feel free to put this on one line.

> +			if (guest_modes[i].supported)

A bit safer would be to check both .supported and .enabled.

> +				vm_mode_default = i;
> +		}
> +
> +		TEST_ASSERT(vm_mode_default != NUM_VM_MODES,
> +			    "No supported mode!");
>  	}
>  #endif
>  #ifdef __s390x__
> -- 
> 2.30.2
>

Thanks,
drew

