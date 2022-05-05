Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD55051B4C2
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 02:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiEEAkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 20:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbiEEAke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 20:40:34 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6726E13F6F
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 17:36:56 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p6so2422509plr.12
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 17:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6T4EzplBB1Bd3LCGANVBBNzS81kXg0U1JKLWTtRFK9I=;
        b=ttBZ0e7VV0aMeYQyiVe+Tjt9jjB3z7zGqjmgdH8riFd4fxOIhUrZbjt4eX5mNIZHU1
         to/s5PEL0G1lHQsiNzkcbYgo43wDw+i9U/mfKY/aaQGC7pZ39kBg/aJomRhjyv4qgdcC
         Vx4x877TWVfdmSf8pXc2v5l6TLlk0ziWS5bqWY/m51Pt65/em26QZzuj9LBaUj68/l8m
         JUmlCu+PtdtwjBRwM4+pUBMJxAeuRSp+hZTzvGbfNQIwCy+PG5VYDHNXOWYGY5FVIr/z
         8eV+uWeMikJ12jj/CPidhygYdFKr7nmFyvuB+4nHLYPAq30R8G4uQKSy+hVB0wMtZelr
         5jMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6T4EzplBB1Bd3LCGANVBBNzS81kXg0U1JKLWTtRFK9I=;
        b=nffr8uikCklPXkkv8Lh9SuUzjWz/+U59gaZEadvgRWDOsB/IiAZwJ5VLDVAbWbmK4u
         NuhIYLzJi7rTtVsBhMj3mv9S/pAJjkRJ6SxIqynroyttkdNvnP7+DcE6g1SAeGDZ7Xv6
         wi1nBOZ7ybvT8aVgs/F/64V/o4iPQGSixqoXSGSf7TeP1oZ+W12xGOTltMnLITIMB7Yh
         QGYcfICqrEMXAbDpYmcc6abzxrECbQTOLPQeAi7R60lqkW2MjLPDC3HgmxAjnvZ+a7bd
         TC97RsnSPi+XFMT/tvWoSNZnR4p1vqgel6Ww7G0DfZK50OOR5+0GBFqSjAuYmF6kOTlk
         HPCw==
X-Gm-Message-State: AOAM5336DPxgc1SpdwLeaphOzwMNFTWVFmTBMvp22Z097B5EV+FzcLGw
        fBYE8DBvA4zYBDEMQgQsR2Y3dg==
X-Google-Smtp-Source: ABdhPJwp63GvB/dQLUlnfmHSkdx3r+o8KTpl2rperSXiuzFBmcNnTXvqZfvVPb+RGfMUMfxUMqh7aA==
X-Received: by 2002:a17:902:d1cd:b0:15d:1483:6ed6 with SMTP id g13-20020a170902d1cd00b0015d14836ed6mr25511839plb.58.1651711012483;
        Wed, 04 May 2022 17:36:52 -0700 (PDT)
Received: from [10.255.89.252] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id y12-20020a63fa0c000000b003c574b4a95dsm2329656pgh.53.2022.05.04.17.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 17:36:51 -0700 (PDT)
Message-ID: <527342ea-ad25-6f66-169d-912a6d75ae54@bytedance.com>
Date:   Thu, 5 May 2022 08:32:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: PING: [PATCH] KVM: HWPoison: Fix memory address&size during remap
Content-Language: en-US
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org, mtosatti@redhat.com,
        peter.maydell@linaro.org
References: <20220420064542.423508-1-pizhenwei@bytedance.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <20220420064542.423508-1-pizhenwei@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo

I would appreciate it if you could review patch.

On 4/20/22 14:45, zhenwei pi wrote:
> qemu exits during reset with log:
> qemu-system-x86_64: Could not remap addr: 1000@22001000
> 
> Currently, after MCE on RAM of a guest, qemu records a ram_addr only,
> remaps this address with a fixed size(TARGET_PAGE_SIZE) during reset.
> In the hugetlbfs scenario, mmap(addr...) needs page_size aligned
> address and correct size. Unaligned address leads mmap to fail.
> 
> What's more, hitting MCE on RAM of a guest, qemu records this address
> and try to fix it during reset, this should be a common logic. So
> remove kvm_hwpoison_page_add from architecture dependent code, record
> this in SIGBUS handler instead. Finally poisoning/unpoisoning a page
> gets static in kvm-all.c,
> 
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>   accel/kvm/kvm-all.c      | 47 ++++++++++++++++++++++++++++++----------
>   include/sysemu/kvm_int.h | 12 ----------
>   target/arm/kvm64.c       |  1 -
>   target/i386/kvm/kvm.c    |  1 -
>   4 files changed, 36 insertions(+), 25 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 5f1377ca04..2a91c5a461 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1167,11 +1167,14 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension)
>       return ret;
>   }
>   
> +#ifdef KVM_HAVE_MCE_INJECTION
>   typedef struct HWPoisonPage {
>       ram_addr_t ram_addr;
> +    size_t page_size; /* normal page or hugeTLB page? */
>       QLIST_ENTRY(HWPoisonPage) list;
>   } HWPoisonPage;
>   
> +/* hwpoison_page_list stores the poisoned pages, unpoison them during reset */
>   static QLIST_HEAD(, HWPoisonPage) hwpoison_page_list =
>       QLIST_HEAD_INITIALIZER(hwpoison_page_list);
>   
> @@ -1181,25 +1184,48 @@ static void kvm_unpoison_all(void *param)
>   
>       QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>           QLIST_REMOVE(page, list);
> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
> +        qemu_ram_remap(page->ram_addr, page->page_size);
>           g_free(page);
>       }
>   }
>   
> -void kvm_hwpoison_page_add(ram_addr_t ram_addr)
> +static void kvm_hwpoison_page_add(CPUState *cpu, int sigbus_code, void *addr)
>   {
>       HWPoisonPage *page;
> +    ram_addr_t ram_addr, align_ram_addr;
> +    ram_addr_t offset;
> +    hwaddr paddr;
> +    size_t page_size;
> +
> +    assert(sigbus_code == BUS_MCEERR_AR || sigbus_code == BUS_MCEERR_AO);
> +    ram_addr = qemu_ram_addr_from_host(addr);
> +    if (ram_addr == RAM_ADDR_INVALID ||
> +        !kvm_physical_memory_addr_from_host(cpu->kvm_state, addr, &paddr)) {
> +        /* only deal with valid guest RAM here */
> +        return;
> +    }
>   
> +    /* get page size of RAM block, test it's a normal page or huge page */
> +    page_size = qemu_ram_block_from_host(addr, false, &offset)->page_size;
> +    align_ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
>       QLIST_FOREACH(page, &hwpoison_page_list, list) {
> -        if (page->ram_addr == ram_addr) {
> +        if (page->ram_addr == align_ram_addr) {
> +            assert(page->page_size == page_size);
>               return;
>           }
>       }
> -    page = g_new(HWPoisonPage, 1);
> -    page->ram_addr = ram_addr;
> +
> +    page = g_new0(HWPoisonPage, 1);
> +    page->ram_addr = align_ram_addr;
> +    page->page_size = page_size;
>       QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
>   }
>   
> +static __thread void *pending_sigbus_addr;
> +static __thread int pending_sigbus_code;
> +static __thread bool have_sigbus_pending;
> +#endif
> +
>   static uint32_t adjust_ioeventfd_endianness(uint32_t val, uint32_t size)
>   {
>   #if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
> @@ -2601,7 +2627,9 @@ static int kvm_init(MachineState *ms)
>           s->kernel_irqchip_split = mc->default_kernel_irqchip_split ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>       }
>   
> +#if defined KVM_HAVE_MCE_INJECTION
>       qemu_register_reset(kvm_unpoison_all, NULL);
> +#endif
>   
>       if (s->kernel_irqchip_allowed) {
>           kvm_irqchip_create(s);
> @@ -2782,12 +2810,6 @@ void kvm_cpu_synchronize_pre_loadvm(CPUState *cpu)
>       run_on_cpu(cpu, do_kvm_cpu_synchronize_pre_loadvm, RUN_ON_CPU_NULL);
>   }
>   
> -#ifdef KVM_HAVE_MCE_INJECTION
> -static __thread void *pending_sigbus_addr;
> -static __thread int pending_sigbus_code;
> -static __thread bool have_sigbus_pending;
> -#endif
> -
>   static void kvm_cpu_kick(CPUState *cpu)
>   {
>       qatomic_set(&cpu->kvm_run->immediate_exit, 1);
> @@ -2883,6 +2905,8 @@ int kvm_cpu_exec(CPUState *cpu)
>   #ifdef KVM_HAVE_MCE_INJECTION
>           if (unlikely(have_sigbus_pending)) {
>               qemu_mutex_lock_iothread();
> +            kvm_hwpoison_page_add(cpu, pending_sigbus_code,
> +                                  pending_sigbus_addr);
>               kvm_arch_on_sigbus_vcpu(cpu, pending_sigbus_code,
>                                       pending_sigbus_addr);
>               have_sigbus_pending = false;
> @@ -3436,6 +3460,7 @@ int kvm_on_sigbus(int code, void *addr)
>        * we can only get action optional here.
>        */
>       assert(code != BUS_MCEERR_AR);
> +    kvm_hwpoison_page_add(first_cpu, code, addr);
>       kvm_arch_on_sigbus_vcpu(first_cpu, code, addr);
>       return 0;
>   #else
> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
> index 1f5487d9b7..52ec8ef99c 100644
> --- a/include/sysemu/kvm_int.h
> +++ b/include/sysemu/kvm_int.h
> @@ -40,16 +40,4 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
>                                     AddressSpace *as, int as_id, const char *name);
>   
>   void kvm_set_max_memslot_size(hwaddr max_slot_size);
> -
> -/**
> - * kvm_hwpoison_page_add:
> - *
> - * Parameters:
> - *  @ram_addr: the address in the RAM for the poisoned page
> - *
> - * Add a poisoned page to the list
> - *
> - * Return: None.
> - */
> -void kvm_hwpoison_page_add(ram_addr_t ram_addr);
>   #endif
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index ccadfbbe72..a3184eb3d2 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -1450,7 +1450,6 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>           ram_addr = qemu_ram_addr_from_host(addr);
>           if (ram_addr != RAM_ADDR_INVALID &&
>               kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> -            kvm_hwpoison_page_add(ram_addr);
>               /*
>                * If this is a BUS_MCEERR_AR, we know we have been called
>                * synchronously from the vCPU thread, so we can easily
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 9cf8e03669..fb72b349ed 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -622,7 +622,6 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>           ram_addr = qemu_ram_addr_from_host(addr);
>           if (ram_addr != RAM_ADDR_INVALID &&
>               kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> -            kvm_hwpoison_page_add(ram_addr);
>               kvm_mce_inject(cpu, paddr, code);
>   
>               /*

-- 
zhenwei pi
