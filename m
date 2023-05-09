Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474B66FC3F5
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbjEIKdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbjEIKdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:33:11 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B860E100E8
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 03:32:54 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1ab267e3528so40079995ad.0
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 03:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683628374; x=1686220374;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=le6WsiFFpntTNhwR6ZdThyFuzfVMTXPYkTAyRr8nwRI=;
        b=dkcYXwuoWC+sWSXkRa1UkLXyr+4XeX3wyrwCnJW1m4VUC31Sc/0XGayn6JJ/j/cD00
         9NAkxSPLSJk8NztvhxgyuIEcv6aGgxydyzXNVJqsi4T9U720OmiUDVYJYJKJZZm/J28Q
         ccwMzjTHVkzXDsF6ftKJiOuAIDQ9YAaJPwkwricp2/BqNbsYPzJEeYqo1PgLdkkB526W
         +32RH0S3cb7fUOpmYREceNRXiOsChWS7gHaCG2oNdLGikKclVjo8rLiVhPI/cvdloWvF
         8KJx8n0bHIpvthsrQUCP3ToQIiDIkwiI+jpMJ351x8X8DkDyWa1i9VnYlHnBdFAYfSOY
         io/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628374; x=1686220374;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=le6WsiFFpntTNhwR6ZdThyFuzfVMTXPYkTAyRr8nwRI=;
        b=RL5Bc9bUpZgu8QFbDmZMjLZ0XU7ors+D2Ggdpw7/cjFlgC1bnDJMm8l+xd++DpsbI3
         6YFqAFUIuyVjIXt1gi5C+bdQRTWQix2o4j8tIZQfMiuWJrGYAEbgnS12nKsKAzRJsCsL
         1WarbREybxHnN7E0W3MupB8CHTqCyZ2svSah3VhJ0IV49prL0hl6RSpk93FuuzMETuXb
         I/HhgGpTEn8wdh7o73DZOEtVMAew6ktKhOFGHnsZEw1e9+cqHbSroKBOznUvGzsTy3Eg
         i5OypO15tx5jvSO5dBOoYwGAT9UrTF1WV4p9fcd3aLgbrHEnJL4Fri7u8aSL2p8C7Ztg
         LW2A==
X-Gm-Message-State: AC+VfDxKwom26OvXyB71N9eqwlDQ9sq5+Iicj+galSKgZgj81aEZWBKH
        OLMq1vqhxD5wHd10XSZOOuudWA==
X-Google-Smtp-Source: ACHHUZ4foWCrYcy+o18/SjgL1rsvMsKKMsfLDxh/nHILJosxokD4padIvzV9kYiYkeuD+KnqM3ICaQ==
X-Received: by 2002:a17:902:bb8c:b0:1a1:ee8c:eef5 with SMTP id m12-20020a170902bb8c00b001a1ee8ceef5mr11531654pls.7.1683628374212;
        Tue, 09 May 2023 03:32:54 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b001a076025715sm1195191plg.117.2023.05.09.03.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 03:32:53 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Vincent Chen <vincent.chen@sifive.com>
Subject: [PATCH -next v19 16/24] riscv: signal: validate altstack to reflect Vector
Date:   Tue,  9 May 2023 10:30:25 +0000
Message-Id: <20230509103033.11285-17-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509103033.11285-1-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/kernel/signal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index f117641c1c49..180d951d3624 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -476,3 +476,10 @@ void __init init_rt_signal_env(void)
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

