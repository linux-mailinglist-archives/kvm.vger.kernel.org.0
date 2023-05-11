Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5436FFCE1
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbjEKW4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239582AbjEKW4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:56:46 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ACD59DA
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6436dfa15b3so6212680b3a.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683845802; x=1686437802;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vtFyDOMAJKBRcj1XAUfvXhteZXg5akh7Zy9dXQt3a3Q=;
        b=lQXEBe+tOsrYFmOsOhUZIKXGTfkBBB/YxSqJ/uBorrQPanAQLS2mqM5FbXwivEGSfj
         C+X5O8owg4/yQcskNIUrXRwrlDrzBK06HHulvB86eAVPHbvbvgKUMdL2uZGw//Ygjpsc
         qSE5/aZ+yotnbIJGifHcAu8LmLAUSvbp+Y/gHu8DvBrf6up1unsfWzNTtuR3h8EggC3R
         yjwI6UcdiEV9aLWxOxBgAXjBK/5xq1tIx4wYBWscXGD6V5BFVzKgABCsV9ugwTnSiXV4
         XZrQB/KNTC4PPHcmiYzz3RdTXA62SJyuOxm5L9wltiHsf9UviSANewFB1trzT/uo7Zr6
         BbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683845802; x=1686437802;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vtFyDOMAJKBRcj1XAUfvXhteZXg5akh7Zy9dXQt3a3Q=;
        b=YH8urZArpAd+l+7fDnwRyhOxO5KU54z37lhvaMBFxL1vEflkAP0tzskTWaStM1SnrL
         rjnKAPTq09JOe0NPsrrpF7/gyrkPpSWs9dm5NayTRira0Dw+IlUH5cDUlIwtQw4oqMPt
         USvoYcTLjL3V66iX+HZ7QmJMKfYGSohqPz7DgE69Y1scDisC5+k+VFYTicnrBxHV5VVK
         suT471DDSLU8FJuvkOQCCkRiDhsb6LwpTNvtG8Qkin7Oo8iJhC8HEKkrJfFeX170hME3
         MBdVGDfm660mDQhQMtUTCL3aniu6EutnJ3M8XRoIBuWJYIeaPYKIIkqBIxhbOf8uoVbt
         fhkw==
X-Gm-Message-State: AC+VfDw/jER7Ix3/q8Prta1HIU7wBPvQ/kmPaVAaLP/5fwExBcUJ5KAl
        sfaDd4JA3wBzI8MyLMU9t6n28A==
X-Google-Smtp-Source: ACHHUZ4p58nUXiAutn3RZFWaoZPE20JAFxaCgTIyzGVhYL/h+LN8ohopawHpb7pbRssOBiXeTRh1CQ==
X-Received: by 2002:a05:6a00:1796:b0:63d:260d:f9dd with SMTP id s22-20020a056a00179600b0063d260df9ddmr31626200pfg.33.1683845801828;
        Thu, 11 May 2023 15:56:41 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id i8-20020aa787c8000000b006413e6e7578sm5804346pfo.5.2023.05.11.15.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:56:41 -0700 (PDT)
Date:   Thu, 11 May 2023 15:56:41 -0700 (PDT)
X-Google-Original-Date: Thu, 11 May 2023 15:48:27 PDT (-0700)
Subject:     Re: [PATCH -next v19 07/24] riscv: Introduce Vector enable/disable helpers
In-Reply-To: <20230509103033.11285-8-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        vincent.chen@sifive.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, heiko.stuebner@vrull.eu, guoren@kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-52a1b4c6-da8b-4f8c-8587-efd8fc294aa8@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 03:30:16 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>
> These are small and likely to be frequently called so implement as
> inline routines (vs. function call).
>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> ---
>  arch/riscv/include/asm/vector.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
> index 427a3b51df72..dfe5a321b2b4 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -11,12 +11,23 @@
>  #ifdef CONFIG_RISCV_ISA_V
>
>  #include <asm/hwcap.h>
> +#include <asm/csr.h>
>
>  static __always_inline bool has_vector(void)
>  {
>  	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
>  }
>
> +static __always_inline void riscv_v_enable(void)
> +{
> +	csr_set(CSR_SSTATUS, SR_VS);
> +}
> +
> +static __always_inline void riscv_v_disable(void)
> +{
> +	csr_clear(CSR_SSTATUS, SR_VS);
> +}
> +
>  #else /* ! CONFIG_RISCV_ISA_V  */
>
>  static __always_inline bool has_vector(void) { return false; }

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
