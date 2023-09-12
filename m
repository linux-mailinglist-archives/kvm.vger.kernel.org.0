Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BF279D123
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 14:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbjILMcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 08:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbjILMck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 08:32:40 -0400
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9425E9F
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 05:32:34 -0700 (PDT)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id 759B6211E4;
        Tue, 12 Sep 2023 15:32:34 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 603DF2783E;
        Tue, 12 Sep 2023 15:32:30 +0300 (MSK)
Message-ID: <b49e350d-089d-62f7-3e5b-dcc885547912@tls.msk.ru>
Date:   Tue, 12 Sep 2023 15:32:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 1/4] sysemu/kvm: Restrict kvmppc_get_radix_page_info() to
 ppc targets
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>
References: <20230912113027.63941-1-philmd@linaro.org>
 <20230912113027.63941-2-philmd@linaro.org>
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <20230912113027.63941-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

12.09.2023 14:30, Philippe Mathieu-Daudé:
> kvm_get_radix_page_info() is only defined for ppc targets (in
> target/ppc/kvm.c). The declaration is not useful in other targets.
> Rename using the 'kvmppc_' prefix following other declarations
> from target/ppc/kvm_ppc.h.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/sysemu/kvm.h | 1 -
>   target/ppc/kvm_ppc.h | 2 ++
>   target/ppc/kvm.c     | 4 ++--
>   3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index ee9025f8e9..3bcd8f45be 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -551,7 +551,6 @@ int kvm_set_one_reg(CPUState *cs, uint64_t id, void *source);
>    * Returns: 0 on success, or a negative errno on failure.
>    */
>   int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target);
> -struct ppc_radix_page_info *kvm_get_radix_page_info(void);
>   int kvm_get_max_memslots(void);
>   
>   /* Notify resamplefd for EOI of specific interrupts. */
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index 6a4dd9c560..440e93f923 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -89,6 +89,8 @@ void kvmppc_set_reg_tb_offset(PowerPCCPU *cpu, int64_t tb_offset);
>   
>   int kvm_handle_nmi(PowerPCCPU *cpu, struct kvm_run *run);
>   
> +struct ppc_radix_page_info *kvmppc_get_radix_page_info(void);
> +
>   #define kvmppc_eieio() \
>       do {                                          \
>           if (kvm_enabled()) {                          \
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 51112bd367..a58708cdfc 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -268,7 +268,7 @@ static void kvm_get_smmu_info(struct kvm_ppc_smmu_info *info, Error **errp)
>                        "KVM failed to provide the MMU features it supports");
>   }
>   
> -struct ppc_radix_page_info *kvm_get_radix_page_info(void)
> +struct ppc_radix_page_info *kvmppc_get_radix_page_info(void)
>   {
>       KVMState *s = KVM_STATE(current_accel());
>       struct ppc_radix_page_info *radix_page_info;
> @@ -2372,7 +2372,7 @@ static void kvmppc_host_cpu_class_init(ObjectClass *oc, void *data)
>       }
>   
>   #if defined(TARGET_PPC64)
> -    pcc->radix_page_info = kvm_get_radix_page_info();
> +    pcc->radix_page_info = kvmppc_get_radix_page_info();
>   
>       if ((pcc->pvr & 0xffffff00) == CPU_POWERPC_POWER9_DD1) {
>           /*

I wonder, if it's defined and used in target/ppc/kvm.c only,
why it needs to be in an .h file to begin with, instead of being static?

/mjt
