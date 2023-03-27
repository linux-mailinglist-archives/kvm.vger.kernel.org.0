Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06296CAB0A
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjC0Qvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbjC0Qvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:51:44 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2855135B5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so9569928pjb.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679935881;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nbAQf53FAokWQnx9Hl1GNT2kMHatESLZYwwPAnVmB08=;
        b=BWDccv2nRJoHZr9MsLWYDDRsOQ7r3Wn0UVHdJlNNFUYXGwtCwrMQViCD6PlPtTg2Oe
         wermLMINocauElbnI4HGE4dnhPmtYLHt6Kxl+mpSWJpUhZn+x8HccOFH2hpXrGlJZjZA
         G+JqH1yMA5zSOPyC5XGj42FvGvlZyzrV2VtpZJcE9ZnyZZuJaeueiK65Bq6npEc/negG
         uv8dTwHge5xvQVkyhoZUqpYOffNNB2WuF9aUpT/v9YV1Nuwbzjh2/yI/ODG1AVL5KHHC
         9mQkC1w8sc5eaFuQxRRRSNdnxVUbAh1yLLba+R5TYFzCVfR/MwdOwyUczFmG/rtUkS8g
         dN6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935881;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nbAQf53FAokWQnx9Hl1GNT2kMHatESLZYwwPAnVmB08=;
        b=d3NTIogTDZCMY7x3GtE8D/yAGrdUWvn+1lR4s53O71dwKmb9uY9iAX+ADFZRni6GF5
         GT1qUzAj8cnjh2j8j04PxpeWwHlBIj3XCNwOke92FY7bGzNICiwIxhgzLh5l1O289Uzu
         +nKXnF75piemirtRXPetqsrk+ouBeUTndWu7zO7lDMjxLvzyUR02XX1vtNlW/d1r7smW
         sgRvmXRgcZaHUmT72yW8KKAn3iFMW/j+N7FGyyyiQdD1iVAuInjk/gmXH/HMa2/8gLWB
         U/VrbK/7e2p+gz6MH84MvQWA3KGezstqHyuojza2+VuaYC7tp+44WoCwSn+qbfbojq4P
         vdzw==
X-Gm-Message-State: AO0yUKUN9/pqDE5FEOzMNJaTLvG1UEKSV4MgzWYFuM7aySfZw6hf9j4S
        vWnW9+cB+jDaJa2ATIWMaYIgBw==
X-Google-Smtp-Source: AK7set+S9h69zKt68G0ddcaputyDZLQS/VFJmLWV3zg37fQviXsmrFpo1rlOaWyul6KYYImLB3755A==
X-Received: by 2002:a05:6a20:24a7:b0:da:a1c9:aa0f with SMTP id m39-20020a056a2024a700b000daa1c9aa0fmr10541584pzd.14.1679935881624;
        Mon, 27 Mar 2023 09:51:21 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b0061949fe3beasm19310550pfh.22.2023.03.27.09.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:51:21 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v17 15/20] riscv: signal: validate altstack to reflect Vector
Date:   Mon, 27 Mar 2023 16:49:35 +0000
Message-Id: <20230327164941.20491-16-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327164941.20491-1-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some extensions, such as Vector, dynamically change footprint on a
signal frame, so MINSIGSTKSZ is no longer accurate. For example, an
RV64V implementation with vlen = 512 may occupy 2K + 40 + 12 Bytes of a
signal frame with the upcoming support. And processes that do not
execute any vector instructions do not need to reserve the extra
sigframe. So we need a way to guard the allocation size of the sigframe
at process runtime according to current status of V.

Thus, provide the function sigaltstack_size_valid() to validate its size
based on current allocation status of supported extensions.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/kernel/signal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 40f740183768..11411e113f0e 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -469,3 +469,10 @@ void __init init_rt_signal_env(void)
 	 */
 	signal_minsigstksz = get_rt_frame_size(true);
 }
+
+#ifdef CONFIG_DYNAMIC_SIGFRAME
+bool sigaltstack_size_valid(size_t ss_size)
+{
+	return ss_size > get_rt_frame_size(false);
+}
+#endif /* CONFIG_DYNAMIC_SIGFRAME */
-- 
2.17.1

