Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C176FFCDF
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbjEKW4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239468AbjEKW4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:56:40 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681A7769F
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:39 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64359d9c531so6944669b3a.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683845799; x=1686437799;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s/EBpBOm5vo3q71SlWRs0MuC5Apo6vy0eW96vyd8toI=;
        b=mQO5zt9Ba5t9UkAThyuSS9r90cQ4QX3N4N7mLDQfIstKGZopIVWqUnWtMG7NxP1CU4
         OvhFPZdx6fORueaQpi1tD2Z3I1ilpQfmPX/mdD70knOX9IrfHvLz9nHY35B3eh+rIwxg
         LXv/uRbhoMqvkBmoRjoMpQw476MFY1UI2ncl515LU5vTL6cPrseubJJgLQp6TgFIpnlK
         aFL/RxwLVtHA1fyTJHvfJo9US1/BheGvTKHm+ff0UwFFUHWHz2TRs4juEGVR5vnhHTrt
         o9OKL3CbKqFoIu7HH8OBKcH8khvJJptm+2C4VRA3a5nX6SBjSPUuzfRrQPQtts3ZnPt9
         zsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683845799; x=1686437799;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/EBpBOm5vo3q71SlWRs0MuC5Apo6vy0eW96vyd8toI=;
        b=GgFYd9RKpfKFRAj2ZNuPgyHJbFoRCRs6ZEYCguHeBV7IBmjPyBgRFtTNHYzzc67ej9
         wP3api2I5YhX1XDO77wHftMDrEo0lj27o075WdgquqVrwL0nn67XQ9XrT2P6/lJM75lL
         KZlPbufNhWm4pTpsNW1s9ifaOoYFIMFkzOMVwpk7fSlme2FfIZ6mLJSKKFquLDiBUf4L
         oAKFUtEHH5CRLno/oDjdJK4Yr10C/7YfMGPMyAX6TF9BIEBbpfllnGAn8IA2Wpdg1k8Q
         RTgHlOWlMxnJAn5QEDOsuAXHqNUuZqa3nEE1wh+l6omeNx5qeZ8VpaDIMmo/8DoFdW9e
         XCAQ==
X-Gm-Message-State: AC+VfDy8YrjeCntiSXQufg/rDMel7J6wiWwwUbP7GVr9cE6+raEAB1S8
        yUK0ryLpaLftnjtYhNIMLXBNDQ==
X-Google-Smtp-Source: ACHHUZ5dbn7gAu3zCZgMg81mlwRuznXrjNVO/EHp9Yuy6xgQdH4qVWUmx+G8s/NoSxGa91AL2ZRLaQ==
X-Received: by 2002:a05:6a20:7d9c:b0:100:c125:5c93 with SMTP id v28-20020a056a207d9c00b00100c1255c93mr20011274pzj.21.1683845798797;
        Thu, 11 May 2023 15:56:38 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id i2-20020aa78b42000000b006352a6d56ebsm5805516pfd.119.2023.05.11.15.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:56:38 -0700 (PDT)
Date:   Thu, 11 May 2023 15:56:38 -0700 (PDT)
X-Google-Original-Date: Thu, 11 May 2023 15:47:41 PDT (-0700)
Subject:     Re: [PATCH -next v19 05/24] riscv: Clear vector regfile on bootup
In-Reply-To: <20230509103033.11285-6-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        andy.chiu@sifive.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, heiko.stuebner@vrull.eu,
        vincent.chen@sifive.com, Conor Dooley <conor.dooley@microchip.com>,
        guoren@kernel.org, alex@ghiti.fr, masahiroy@kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-6740b2a0-90ed-49c7-8908-87d55dbda354@palmer-ri-x1c9a>
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

On Tue, 09 May 2023 03:30:14 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>
> clear vector registers on boot if kernel supports V.
>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> ---
>  arch/riscv/kernel/head.S | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index 4bf6c449d78b..3fd6a4bd9c3e 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -392,7 +392,7 @@ ENTRY(reset_regs)
>  #ifdef CONFIG_FPU
>  	csrr	t0, CSR_MISA
>  	andi	t0, t0, (COMPAT_HWCAP_ISA_F | COMPAT_HWCAP_ISA_D)
> -	beqz	t0, .Lreset_regs_done
> +	beqz	t0, .Lreset_regs_done_fpu
>
>  	li	t1, SR_FS
>  	csrs	CSR_STATUS, t1
> @@ -430,8 +430,31 @@ ENTRY(reset_regs)
>  	fmv.s.x	f31, zero
>  	csrw	fcsr, 0
>  	/* note that the caller must clear SR_FS */
> +.Lreset_regs_done_fpu:
>  #endif /* CONFIG_FPU */
> -.Lreset_regs_done:
> +
> +#ifdef CONFIG_RISCV_ISA_V
> +	csrr	t0, CSR_MISA
> +	li	t1, COMPAT_HWCAP_ISA_V
> +	and	t0, t0, t1
> +	beqz	t0, .Lreset_regs_done_vector
> +
> +	/*
> +	 * Clear vector registers and reset vcsr
> +	 * VLMAX has a defined value, VLEN is a constant,
> +	 * and this form of vsetvli is defined to set vl to VLMAX.
> +	 */
> +	li	t1, SR_VS
> +	csrs	CSR_STATUS, t1
> +	csrs	CSR_VCSR, x0
> +	vsetvli t1, x0, e8, m8, ta, ma
> +	vmv.v.i v0, 0
> +	vmv.v.i v8, 0
> +	vmv.v.i v16, 0
> +	vmv.v.i v24, 0
> +	/* note that the caller must clear SR_VS */
> +.Lreset_regs_done_vector:
> +#endif /* CONFIG_RISCV_ISA_V */
>  	ret
>  END(reset_regs)
>  #endif /* CONFIG_RISCV_M_MODE */

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
