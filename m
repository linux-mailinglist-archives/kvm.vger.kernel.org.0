Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BF94BA4CD
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 16:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiBQPqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 10:46:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiBQPqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 10:46:48 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ABC1D301
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:46:31 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso9851036pjg.0
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R8nS4Mx2FHk1MUuQsgL8zH9kBiDqg58ofDKGwuFcemo=;
        b=tUPRDvgS4AVmwyqulVD1NDgkSAhVDYTNgzKpbGhpBbiIMIHbk+jluPOfTgFA3G+Fr3
         Gj77cKwnKySWVu21B/TWidDQbkOY1bj2g8GA7spzPxMxxSBeBv9oAeLQHv5nhpU8/afB
         xOO+tDCDw5N44Q7TlSqs2i80dddk4lHOrT0TfxJm6VMoFZsdXJoGen8EZ5HM9R6a3nmy
         MSzWLGdXNN0hSGOodvXAVQLQ5lAyWqCesriHYenwNfdRwB3bM3h8AO2AGiUGbgpOgFLJ
         YEgC/3Dk4YKmiX7s6fyU9v43XMXzz9KHkv02xQ85Ss8oXhjV85j9GxaMBhrMahm0Q/vh
         mvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R8nS4Mx2FHk1MUuQsgL8zH9kBiDqg58ofDKGwuFcemo=;
        b=B0WDnJ6gv3BIsXtdg63m1qHGTnQA0+398eIIoXU6G6LckP8ryjtM8g8oTM0bZwNKIh
         o4nRAZ3UQrSC4HnF4pvh8h30XPBnk0hXrmYvY01KSdhvbeTQd7iQnx+cALf0l7AtrI0x
         CFhnfDAO/trvURDnnTxowdHKmwSHZBraAVzJbE9Q/4BeY+NzzMx+Bsm0QRb/MDjc5O7a
         4LQFNpOepvDahTbRzYsWz0LLxLYdIexFT4RfuJMNGCTOMf32sSqtmh8Rn7adXQPa2PK9
         0hpeYFOXPYElPWbyBdzHrTrLxfT94sCtG2VpS18xJN3Ol7HhewnJkWVskkoqfAh+7z/V
         2Q8Q==
X-Gm-Message-State: AOAM530PnvpqlTkWAdVpxzbWhoDTZohKSTAwPqgJKl+c5tguWr16bzYC
        P8jnJ06EvqPMxNPqN9IqgnhCFQ==
X-Google-Smtp-Source: ABdhPJw0aucahcHgpIYhfz8KAXF+4TiftaBBzxl6Q6pMLUyxJ2nJrw22Chio8XxiycPIM0Ke5T4fAA==
X-Received: by 2002:a17:90a:6585:b0:1b9:75ee:dd14 with SMTP id k5-20020a17090a658500b001b975eedd14mr7896029pjj.102.1645112790556;
        Thu, 17 Feb 2022 07:46:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x7sm8194227pgr.87.2022.02.17.07.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 07:46:29 -0800 (PST)
Date:   Thu, 17 Feb 2022 15:46:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Dunn <daviddunn@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 2/3] KVM: selftests: Carve out helper to create
 "default" VM without vCPUs
Message-ID: <Yg5t0lnc/oAHmFrB@google.com>
References: <20220215014806.4102669-1-daviddunn@google.com>
 <20220215014806.4102669-3-daviddunn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215014806.4102669-3-daviddunn@google.com>
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

On Tue, Feb 15, 2022, David Dunn wrote:
> Carve out portion of vm_create_default so that selftests can modify
> a "default" VM prior to creating vcpus.
> 
> Signed-off-by: David Dunn <daviddunn@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++++++----
>  2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 4ed6aa049a91..f987cf7c0d2e 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -336,6 +336,9 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>  				    uint32_t num_percpu_pages, void *guest_code,
>  				    uint32_t vcpuids[]);
>  
> +/* Create a default VM without any vcpus. */
> +struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages);
> +
>  /*
>   * Adds a vCPU with reasonable defaults (e.g. a stack)
>   *
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index d8cf851ab119..5aea7734cfe3 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -362,6 +362,34 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  	return vm;
>  }
>  
> +/*
> + * Default VM creation without creating VCPUs
> + *
> + * Input Args:
> + *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
> + *   pages - pages of memory required for VM
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   Pointer to opaque structure that describes the created VM.
> + *
> + * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K).
> + */

I vote to omit this function comment.  Most of the existing comments in kvm_util.c
are a waste of space, and (no offence) this is no different.  And I'm planning on
deleting most of the existing boilerplate comments that don't provide any insight :-)

> +struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
> +{
> +	struct kvm_vm *vm;
> +
> +	vm = vm_create(mode, pages, O_RDWR);
> +
> +	kvm_vm_elf_load(vm, program_invocation_name);
> +
> +#ifdef __x86_64__
> +	vm_create_irqchip(vm);
> +#endif
> +	return vm;
> +}
> +
>  /*
>   * VM Create with customized parameters
>   *
> @@ -412,13 +440,8 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>  		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
>  
>  	pages = vm_adjust_num_guest_pages(mode, pages);
> -	vm = vm_create(mode, pages, O_RDWR);
> -
> -	kvm_vm_elf_load(vm, program_invocation_name);
>  
> -#ifdef __x86_64__
> -	vm_create_irqchip(vm);
> -#endif
> +	vm = vm_create_without_vcpus(mode, pages);
>  
>  	for (i = 0; i < nr_vcpus; ++i) {
>  		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
> -- 
> 2.35.1.265.g69c8d7142f-goog
> 
