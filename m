Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2760660F8CB
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 15:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiJ0NOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 09:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiJ0NOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 09:14:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622877C32B
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 06:13:45 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 21so2668191edv.3
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 06:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6jud7Ls3+0knS57eOkqU3aPXs8XYGaLsC/MSEs6EmMo=;
        b=coB5F5xlLS4ZGJBOq74G9Z7uo7MjBZy+xChFNFzoqe+qjUjBYjA4yG1TWEBHfNf4J1
         mcdzCmwZ0+4mnlL09NJuhBUcMzD/vWbDQ0eJak2pQOQ6rdEccapzTYCXSbCn6AAj6Qiq
         LNkUvDPQkbCCPKiXSonDd3/hYnygASrQyv1O1MR6gKEOmrBxy2KpnZWWbHDMZLUi/99d
         0VgU3srN3IvjP2tmS6krA4c6Lw0mFYaB8+J6sA/FfR3/G7B2S4THT6CQSwIaIerUdMrK
         AYrpNORcotEHf07jXdHVZLpktcyh0+MWOwlfTrhBESUzQ2kjXbTWRkBQAYcbtYUxMetE
         RBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jud7Ls3+0knS57eOkqU3aPXs8XYGaLsC/MSEs6EmMo=;
        b=uovSYCGB5YqyjLwlEatX7jPZ11iztl1QmJka00ta8LvY5Jlerllh/dyeTfDaMtwqKm
         L4jC48X2fdAkheubu0n4uWJ1mdYsthsi59qcAT5IEmW7BnFLwPjXIKlKf3vfPQjltbjw
         hqlafuWFGpUhERaAt1pPmWXelW0U7jtkzoTe/ob4owCmk6YkNX4A1eTRyA0uJmm1byxi
         GuY35A058bxoeF03soywWqFA1HNnO9RRaLtAhtLQw/a3fDgLrnqm72Op+Kl4r5rx1GIe
         FGSdoHbUX2SDhWoFncN8Xk8bw3LmnAsPuI+VzriNzitYrI6j80jorOkx24XOWFF1x+/V
         /ibw==
X-Gm-Message-State: ACrzQf29tVSbwmmh1nsg/ugpQ+caznuQEp/Hu2/xp9/g8g69nx2YVlvi
        LZwOUxswVy2CZTeLis610LFmYg==
X-Google-Smtp-Source: AMsMyM4WOdSgzl4SwTvaEe8U3ZIL/v1D5C65H+zxttEDUG8sVMzVnwecQoBMQyCHWGwQXYvykKJQfw==
X-Received: by 2002:a05:6402:4312:b0:45c:c1e9:9dc8 with SMTP id m18-20020a056402431200b0045cc1e99dc8mr45490978edc.154.1666876423719;
        Thu, 27 Oct 2022 06:13:43 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id qo14-20020a170907874e00b00773f3cb67ffsm810765ejc.28.2022.10.27.06.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 06:13:42 -0700 (PDT)
Date:   Thu, 27 Oct 2022 13:13:38 +0000
From:   Quentin Perret <qperret@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 20/25] KVM: arm64: Return guest memory from EL2 via
 dedicated teardown memcache
Message-ID: <Y1qEAokfFPcLaWiq@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-21-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020133827.5541-21-will@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday 20 Oct 2022 at 14:38:22 (+0100), Will Deacon wrote:
> +static void
> +teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
> +{
> +	size = PAGE_ALIGN(size);
> +	memset(addr, 0, size);
> +
> +	for (void *start = addr; start < addr + size; start += PAGE_SIZE)
> +		push_hyp_memcache(mc, start, hyp_virt_to_phys);
> +
> +	unmap_donated_memory_noclear(addr, size);
> +}
> +
>  int __pkvm_teardown_vm(pkvm_handle_t handle)
>  {
> +	struct kvm_hyp_memcache *mc;
>  	struct pkvm_hyp_vm *hyp_vm;
>  	unsigned int idx;
>  	size_t vm_size;
> @@ -552,7 +565,8 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
>  	hyp_spin_unlock(&vm_table_lock);
>  
>  	/* Reclaim guest pages (including page-table pages) */
> -	reclaim_guest_pages(hyp_vm);
> +	mc = &hyp_vm->host_kvm->arch.pkvm.teardown_mc;
> +	reclaim_guest_pages(hyp_vm, mc);
>  	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->nr_vcpus);
>  
>  	/* Push the metadata pages to the teardown memcache */
> @@ -561,11 +575,11 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
>  	for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
>  		struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
>  
> -		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
> +		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
>  	}
>  
>  	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
> -	unmap_donated_memory(hyp_vm, vm_size);
> +	teardown_donated_memory(mc, hyp_vm, vm_size);

We should move the unpinning of the host's kvm struct down here as 'mc'
here is part of it. Otherwise nothing prevents the host from unsharing
the pages and donating them, etc. Probably hard to exploit but still
worth fixing IMO.

Thanks,
Quentin

>  	return 0;
