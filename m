Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EC2741F73
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 07:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjF2FD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 01:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjF2FD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 01:03:58 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C635026B7
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 22:03:56 -0700 (PDT)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4Qs5vX11xQz4wp1;
        Thu, 29 Jun 2023 15:03:52 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qs5vT1vzTz4wgk;
        Thu, 29 Jun 2023 15:03:48 +1000 (AEST)
Message-ID: <5b7e4244-5909-b349-a0f1-0cf83203865a@kaod.org>
Date:   Thu, 29 Jun 2023 07:03:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 2/6] target/ppc: Reorder #ifdef'ry in kvm_ppc.h
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
References: <20230627115124.19632-1-philmd@linaro.org>
 <20230627115124.19632-3-philmd@linaro.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230627115124.19632-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/23 13:51, Philippe Mathieu-Daudé wrote:
> Keep a single if/else/endif block checking CONFIG_KVM.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>





Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.


> ---
>   target/ppc/kvm_ppc.h | 62 ++++++++++++++++++++------------------------
>   1 file changed, 28 insertions(+), 34 deletions(-)
> 
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index 2e395416f0..49954a300b 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -93,7 +93,34 @@ void kvmppc_set_reg_tb_offset(PowerPCCPU *cpu, int64_t tb_offset);
>   
>   int kvm_handle_nmi(PowerPCCPU *cpu, struct kvm_run *run);
>   
> -#else
> +#define kvmppc_eieio() \
> +    do {                                          \
> +        if (kvm_enabled()) {                          \
> +            asm volatile("eieio" : : : "memory"); \
> +        } \
> +    } while (0)
> +
> +/* Store data cache blocks back to memory */
> +static inline void kvmppc_dcbst_range(PowerPCCPU *cpu, uint8_t *addr, int len)
> +{
> +    uint8_t *p;
> +
> +    for (p = addr; p < addr + len; p += cpu->env.dcache_line_size) {
> +        asm volatile("dcbst 0,%0" : : "r"(p) : "memory");
> +    }
> +}
> +
> +/* Invalidate instruction cache blocks */
> +static inline void kvmppc_icbi_range(PowerPCCPU *cpu, uint8_t *addr, int len)
> +{
> +    uint8_t *p;
> +
> +    for (p = addr; p < addr + len; p += cpu->env.icache_line_size) {
> +        asm volatile("icbi 0,%0" : : "r"(p));
> +    }
> +}
> +
> +#else /* !CONFIG_KVM */
>   
>   static inline uint32_t kvmppc_get_tbfreq(void)
>   {
> @@ -440,10 +467,6 @@ static inline bool kvmppc_pvr_workaround_required(PowerPCCPU *cpu)
>       return false;
>   }
>   
> -#endif
> -
> -#ifndef CONFIG_KVM
> -
>   #define kvmppc_eieio() do { } while (0)
>   
>   static inline void kvmppc_dcbst_range(PowerPCCPU *cpu, uint8_t *addr, int len)
> @@ -454,35 +477,6 @@ static inline void kvmppc_icbi_range(PowerPCCPU *cpu, uint8_t *addr, int len)
>   {
>   }
>   
> -#else   /* CONFIG_KVM */
> -
> -#define kvmppc_eieio() \
> -    do {                                          \
> -        if (kvm_enabled()) {                          \
> -            asm volatile("eieio" : : : "memory"); \
> -        } \
> -    } while (0)
> -
> -/* Store data cache blocks back to memory */
> -static inline void kvmppc_dcbst_range(PowerPCCPU *cpu, uint8_t *addr, int len)
> -{
> -    uint8_t *p;
> -
> -    for (p = addr; p < addr + len; p += cpu->env.dcache_line_size) {
> -        asm volatile("dcbst 0,%0" : : "r"(p) : "memory");
> -    }
> -}
> -
> -/* Invalidate instruction cache blocks */
> -static inline void kvmppc_icbi_range(PowerPCCPU *cpu, uint8_t *addr, int len)
> -{
> -    uint8_t *p;
> -
> -    for (p = addr; p < addr + len; p += cpu->env.icache_line_size) {
> -        asm volatile("icbi 0,%0" : : "r"(p));
> -    }
> -}
> -
>   #endif  /* CONFIG_KVM */
>   
>   #endif /* KVM_PPC_H */

