Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5AA6C6120
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjCWHuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCWHuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:50:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC2C1ACF6
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 00:50:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so1165130pjp.1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 00:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679557822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GQvyyWfzdZlNTPcJjFuNq4iVi6kYqIRTdIXM0bxkig=;
        b=YrA6kgUuYXXc/yhtRQjq7msKg6c5+EDSg8TFX0Lx/oemng6GYs/2p+aorlJgMm/2fW
         4wAgSJoVKSyBRG03vz63JfUwBWt/DBOgxVv+I2sIrRmEBmltH2QBWhPnh7Fccwtzgiq/
         4gBCtyWPN9dafmH7irN5n0eiQ/jCT/lsUOC83oqw2Md577Ejk2UaClNJzgBen3RjXW1W
         ZtzTgr2blbfcJf54cSlkKse2MCu8AFOlIoJmtSfNIHpzjJvE42Kblo2qEhJ1Fzb2lQFL
         ED2e+kPUYtYAuV7dF7NGikoDI5sYKGLXUCHlqKK3u74OU/SxWrEjTMkSJmWC2fKvxlLD
         TqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679557822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6GQvyyWfzdZlNTPcJjFuNq4iVi6kYqIRTdIXM0bxkig=;
        b=z9TvRfRNHAyvpCba00bRG78heXxkJ7XTrqm/zEpozHrzE5Ide6cDaKZmMBc9ROFGik
         XI/kAZFAIKfGXW/s698O4niL4iMTTjzVk4pZ/BFPk8O0Wgbp+W8aHpQ1XNQe7jLAcAvC
         Kyz3YdXP8ZXu5LaAT8yEfBCHBV85EMw8UnJaxIgPrSpzEHsTGRAYd5Txmlm7mz+aJRtY
         ybcK90PJGP4mL2ZK/ySD9KDmo2QOPUzyaiAejQrI5hpvbiS2HTm4l9YId8p6QnQyJxfS
         K14plLM5j72B4P4p5NImZB2X4Cr6g5keWEqa2lXRvvJDApCgR3fkqGLqUKd1zWhEJ4yT
         lRtQ==
X-Gm-Message-State: AO0yUKW6L42AHQon2ZaXUCM1B0KfWdRmGodmM0zohXWBAw4j5txAhTdV
        F+UihbaUmADqrrIUikIzcnzf+g==
X-Google-Smtp-Source: AK7set8reMhX/0K1+rtbWu5hJYhaj/eSdvG6l3WSWzeAaiqpKAIhdJYZ/Zlz/C6BcxymP8O2h7O7/A==
X-Received: by 2002:a05:6a20:6aa0:b0:db:d1d5:1e00 with SMTP id bi32-20020a056a206aa000b000dbd1d51e00mr1664778pzb.60.1679557822205;
        Thu, 23 Mar 2023 00:50:22 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id x16-20020a63fe50000000b005004919b31dsm11063641pgj.72.2023.03.23.00.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:50:21 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     conor.dooley@microchip.com
Cc:     abrestic@rivosinc.com, andy.chiu@sifive.com, anup@brainfault.org,
        aou@eecs.berkeley.edu, atishp@atishpatra.org, bjorn@rivosinc.com,
        david@redhat.com, greentime.hu@sifive.com, guoren@kernel.org,
        guoren@linux.alibaba.com, heiko@sntech.de, jszhang@kernel.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, richard.henderson@linaro.org,
        vincent.chen@sifive.com, vineetg@rivosinc.com,
        xianting.tian@linux.alibaba.com, zephray@outlook.com
Subject: Re: [PATCH -next v15 13/19] riscv: signal: Add sigcontext save/restore for vector
Date:   Thu, 23 Mar 2023 15:50:14 +0800
Message-Id: <20230323075014.2135132-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <e0b5df49-4d78-4a0f-8509-ff29085486cf@spud>
References: <e0b5df49-4d78-4a0f-8509-ff29085486cf@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 9:37 PM Conor Dooley <conor.dooley@microchip.com> wrote:
> Sparse, or at least Palmer's hacked up version of it that I am running
> [1] complains a bit about this patch, that you've added a few:
> +      1 ../arch/riscv/kernel/signal.c:145:29: warning: incorrect type in initializer (different address spaces)
> +      1 ../arch/riscv/kernel/signal.c:171:24: warning: incorrect type in initializer (different address spaces)
> +      1 ../arch/riscv/kernel/signal.c:172:24: warning: incorrect type in initializer (different address spaces)
> +      1 ../arch/riscv/kernel/signal.c:268:47: warning: incorrect type in initializer (different address spaces)
> +      1 ../arch/riscv/kernel/signal.c:282:16: warning: incorrect type in initializer (different address spaces)
> +      1 ../arch/riscv/kernel/signal.c:283:16: warning: incorrect type in initializer (different address spaces)
> Please have a look at those, and check whether they're valid complaints.

Yes, they are valid. Meanwhile, running sparse locally, I found the 
following, which are also reported at 19/19 patch:
arch/riscv/kernel/signal.c:78:13: warning: incorrect type in assignment (different address spaces)                                                                                                                                                                              
arch/riscv/kernel/signal.c:80:18: warning: cast removes address space '__user' of expression
arch/riscv/kernel/signal.c:92:16: warning: incorrect type in initializer (different address spaces)
arch/riscv/kernel/signal.c:114:51: warning: incorrect type in initializer (different address spaces)

And these need to be fixed, while not found by your sparse:
arch/riscv/kernel/vector.c:81:28: warning: incorrect type in initializer (different address spaces)
arch/riscv/kernel/vector.c:81:28:    expected unsigned int [noderef] [usertype] __user *epc
arch/riscv/kernel/vector.c:81:28:    got unsigned int [usertype] *

However, there is no way to get around signal.c:92 though. The copying of
__user pointer to a __user address should be valid.

+static long save_v_state(struct pt_regs *regs, void **sc_vec)
+{
...
+	/* Copy the pointer datap itself. */
+	err |= __put_user(datap, &state->v_state.datap); 
...

>
> Otherwise, this version of this patch seems a lot nicer than the last
> version, so that makes me happy at least, even if sparse isn't..
>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
>
> Cheers,
> Conor.

Thanks,
Andy
