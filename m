Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE956A203A
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjBXRDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBXRDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:03:23 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B828C46A2
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:13 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id ky4so153501plb.3
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gGZWEGHhXqO9OeXhoDxEGsON6GC4YBeiRX5XbYj9IGA=;
        b=ghKPeKR0G7uqNkPIH1npSQFQIWcsGSKvYwwCyhwQTOj1TK5WP1/aNJ87vT0C1mdcnO
         ht5/8+RtBaKIBxaPDYvuzQsOxqiMvI534Qu4gaxQ+XfWL9g2HKUXKKWh1ey/XkDk9aE4
         uOginkp7cstMsnvp873wEwWYntVED1Z4ero00tYFcx5ZsZFedEvwzeLBaW2pWlE7ZkvX
         SRYhb5BU8VVVN5y4d3J1ryOd+P61zO/X+cx91jMeI/8uHICjlll5wYhewyKdfmnsTgxM
         4UtNUvfkSRXbex1Rs90s99OR/M3QkP960CJkZZXziXCoNG/Qs9eq5X/jSB4btL/i3pcv
         y8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gGZWEGHhXqO9OeXhoDxEGsON6GC4YBeiRX5XbYj9IGA=;
        b=Yf5OU1h718QI9mHYEHqlxbvfc26ycAtmIrvSUl7dww8vcQA5FbiCTDwElbAVfhkFF2
         E1NOmXqCB3s76mdLupQ+uN+j8GSytZWeAj3RPCI0h8GInZDl0Cf6164XFOsX54nqyu+h
         JWUUSQaQFp5va2tQQSRbD5p3CtDiJ9g83d96TMQPJ8zmeGCPTMxMbYm7hD77fjzoKJBL
         JZed33TWcgeFNxZeFyNDyeFB12R2a0aznrdZv7yZpLGnb5UEWH3EZs1NR1GUZkdZRFrc
         B5czWmga5DITvDvPEvKQqDIgHSvya6C1x/vcz5E6o5751uade04i31kIPHDx673vyAos
         9PBg==
X-Gm-Message-State: AO0yUKUtPVNiij5q5sY+8uAWOrFU3aoYJCBdxuhtapmp0QKHGpURD/f8
        KSP1mUUsXUOvyVK/cuNuO3jzZw==
X-Google-Smtp-Source: AK7set/PDa9oZC/tYXZAV4EbClHLZdMbVmxGR97qkvUkEEVLbHU3vmzGKHxKFJkEDjHgyyUthiP+iw==
X-Received: by 2002:a17:903:1ce:b0:19a:c65d:f97 with SMTP id e14-20020a17090301ce00b0019ac65d0f97mr24637061plh.41.1677258193134;
        Fri, 24 Feb 2023 09:03:13 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:03:12 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v14 15/19] riscv: signal: validate altstack to reflect Vector
Date:   Fri, 24 Feb 2023 17:01:14 +0000
Message-Id: <20230224170118.16766-16-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MINSIGSTKSZ alone have become less informative by the time an user calls
sigaltstack(), as the kernel starts to support extensions that
dynamically introduce footprint on a signal frame. For example, an RV64V
implementation with vlen = 512 may occupy 2K + 40 + 12 Bytes of a signal
frame with the upcoming Vector support. And there is no need for
reserving the extra sigframe for some processes that do not execute any
V-instructions.

Thus, provide the function sigaltstack_size_valid() to validate its size
based on current allocation status of supported extensions.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/kernel/signal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index aa8ee95dee2d..aff441e83a98 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -494,3 +494,11 @@ void __init init_rt_signal_env(void)
 	 */
 	signal_minsigstksz = cal_rt_frame_size(true);
 }
+
+#ifdef CONFIG_DYNAMIC_SIGFRAME
+bool sigaltstack_size_valid(size_t ss_size)
+{
+	return ss_size > cal_rt_frame_size(false);
+}
+#endif /* CONFIG_DYNAMIC_SIGFRAME */
+
-- 
2.17.1

