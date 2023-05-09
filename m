Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC0B6FC487
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 13:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbjEILFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 07:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbjEILFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 07:05:47 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C68E50
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 04:05:43 -0700 (PDT)
Received: from ip4d1634d3.dynamic.kabel-deutschland.de ([77.22.52.211] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pwLA1-0003Ee-Pp; Tue, 09 May 2023 13:05:37 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Evan Green <evan@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Celeste Liu <coelacanthus@outlook.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: Re: [PATCH -next v19 03/24] riscv: hwprobe: Add support for
 RISCV_HWPROBE_BASE_BEHAVIOR_V
Date:   Tue, 09 May 2023 13:05:36 +0200
Message-ID: <2172277.NgBsaNRSFp@diego>
In-Reply-To: <20230509103033.11285-4-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
 <20230509103033.11285-4-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Dienstag, 9. Mai 2023, 12:30:12 CEST schrieb Andy Chiu:
> Probing kernel support for Vector extension is available now.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  Documentation/riscv/hwprobe.rst       | 10 ++++++++++
>  arch/riscv/include/asm/hwprobe.h      |  2 +-
>  arch/riscv/include/uapi/asm/hwprobe.h |  3 +++
>  arch/riscv/kernel/sys_riscv.c         |  9 +++++++++
>  4 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprobe.rst
> index 9f0dd62dcb5d..b8755e180fbf 100644
> --- a/Documentation/riscv/hwprobe.rst
> +++ b/Documentation/riscv/hwprobe.rst
> @@ -53,6 +53,9 @@ The following keys are defined:
>        programs (it may still be executed in userspace via a
>        kernel-controlled mechanism such as the vDSO).
>  
> +  * :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: Support for Vector extension, as
> +    defined by verion 1.0 of the RISC-V Vector extension.

	^^ version [missing the S]

> +
>  * :c:macro:`RISCV_HWPROBE_KEY_IMA_EXT_0`: A bitmask containing the extensions
>    that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_IMA`:
>    base system behavior.
> @@ -64,6 +67,13 @@ The following keys are defined:
>    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as defined
>      by version 2.2 of the RISC-V ISA manual.
>  
> +* :c:macro:`RISCV_HWPROBE_KEY_V_EXT_0`: A bitmask containing the extensions
> +   that are compatible with the :c:macro:`RISCV_HWPROBE_BASE_BEHAVIOR_V`: base
> +   system behavior.
> +
> +  * :c:macro:`RISCV_HWPROBE_V`: The V extension is supported, as defined by
> +    version 1.0 of the RISC-V Vector extension manual.
> +

this seems to be doubling the RISCV_HWPROBE_BASE_BEHAVIOR_V state without
adding additional information? Both essentially tell the system that
V extension "defined by verion 1.0 of the RISC-V Vector extension" is supported.

I don't question that we'll probably need a key for deeper vector-
specifics but I guess I'd the commit message should definitly explain
why there is a duplication here.


>  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
>    information about the selected set of processors.
>  
> diff --git a/arch/riscv/include/asm/hwprobe.h b/arch/riscv/include/asm/hwprobe.h
> index 78936f4ff513..39df8604fea1 100644
> --- a/arch/riscv/include/asm/hwprobe.h
> +++ b/arch/riscv/include/asm/hwprobe.h
> @@ -8,6 +8,6 @@
>  
>  #include <uapi/asm/hwprobe.h>
>  
> -#define RISCV_HWPROBE_MAX_KEY 5
> +#define RISCV_HWPROBE_MAX_KEY 6
>  
>  #endif
> diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
> index 8d745a4ad8a2..93a7fd3fd341 100644
> --- a/arch/riscv/include/uapi/asm/hwprobe.h
> +++ b/arch/riscv/include/uapi/asm/hwprobe.h
> @@ -22,6 +22,7 @@ struct riscv_hwprobe {
>  #define RISCV_HWPROBE_KEY_MIMPID	2
>  #define RISCV_HWPROBE_KEY_BASE_BEHAVIOR	3
>  #define		RISCV_HWPROBE_BASE_BEHAVIOR_IMA	(1 << 0)
> +#define		RISCV_HWPROBE_BASE_BEHAVIOR_V	(1 << 1)
>  #define RISCV_HWPROBE_KEY_IMA_EXT_0	4
>  #define		RISCV_HWPROBE_IMA_FD		(1 << 0)
>  #define		RISCV_HWPROBE_IMA_C		(1 << 1)
> @@ -32,6 +33,8 @@ struct riscv_hwprobe {
>  #define		RISCV_HWPROBE_MISALIGNED_FAST		(3 << 0)
>  #define		RISCV_HWPROBE_MISALIGNED_UNSUPPORTED	(4 << 0)
>  #define		RISCV_HWPROBE_MISALIGNED_MASK		(7 << 0)
> +#define RISCV_HWPROBE_KEY_V_EXT_0	6
> +#define		RISCV_HWPROBE_V			(1 << 0)
>  /* Increase RISCV_HWPROBE_MAX_KEY when adding items. */
>  
>  #endif
> diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
> index 5db29683ebee..6280a7f778b3 100644
> --- a/arch/riscv/kernel/sys_riscv.c
> +++ b/arch/riscv/kernel/sys_riscv.c
> @@ -10,6 +10,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/hwprobe.h>
>  #include <asm/sbi.h>
> +#include <asm/vector.h>
>  #include <asm/switch_to.h>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -161,6 +162,7 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
>  	 */
>  	case RISCV_HWPROBE_KEY_BASE_BEHAVIOR:
>  		pair->value = RISCV_HWPROBE_BASE_BEHAVIOR_IMA;
> +		pair->value |= RISCV_HWPROBE_BASE_BEHAVIOR_V;

Doesn't this also need a
	if (has_vector())


Heiko

>  		break;
>  
>  	case RISCV_HWPROBE_KEY_IMA_EXT_0:
> @@ -173,6 +175,13 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
>  
>  		break;
>  
> +	case RISCV_HWPROBE_KEY_V_EXT_0:
> +		pair->value = 0;
> +		if (has_vector())
> +			pair->value |= RISCV_HWPROBE_V;
> +
> +		break;
> +
>  	case RISCV_HWPROBE_KEY_CPUPERF_0:
>  		pair->value = hwprobe_misaligned(cpus);
>  		break;
> 




