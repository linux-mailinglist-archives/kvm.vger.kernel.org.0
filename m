Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FF1722B86
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbjFEPmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbjFEPmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:42:02 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0888610C7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:41:37 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b024e29657so22410615ad.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979683; x=1688571683;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=le6WsiFFpntTNhwR6ZdThyFuzfVMTXPYkTAyRr8nwRI=;
        b=d+VxNOOQAYl7No/bE0Eojd1GYi+MRhT2Pby2jWoSFXSqUG8BgURwze0nShY/toqzYx
         C/WtCyxZA8GCoZnSCw7mO36blaG/NDggsPeg04KH2aJoaDhPkXVbw9Oz8f/H5Qh1x990
         taBoEsUSxj94ml9ML0MwfSzKodLhVwBsLOWyslkDYUSh4VosvqwIltYtzDzD0pnFvn/i
         hGLMy0SKjDc7WllfsI/57BAJwE0zqYQPa+9VLrBSLjj02U1OUHyHUE2xw172H9W49dJj
         GLB7YZNAaWZ2R/F8NDODJUWaVu8V5dhYQ+LxFxQi512Vtxs/a/R2XiF7GzRrFS2Qng9h
         N5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979683; x=1688571683;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=le6WsiFFpntTNhwR6ZdThyFuzfVMTXPYkTAyRr8nwRI=;
        b=KbdKpQC6O5DQBIyV3oLMiJFfv73NAIA2HHJ3JHuD4RoNeNChi0xoffxNU8QL3kUTwX
         crjrXQY9NetZ5mOAqoPc0E1F6TAGsiCkat6/L1gvWYhwJIrs8S6RQ6oyFjCYAcyTKW26
         wMHbaHvwV8HpeVtJojhOwl1fIToUGqYw0eqCgNNKzuoMVBf6ermKUtEe/6N5Yr88R8sZ
         pP330tvT0Dc1vaMiF1zgDWOPCZa4ZSGUG6/7Ls0k93w0KKsXg0lWri3RCukpSGkXT2iY
         6ReklvV52mM7cqUCGrKYUNiimWLn11fX51573AvBlIuTTMuYkAjkCBz3O9b2gODuy0rS
         C4rA==
X-Gm-Message-State: AC+VfDz87w8UMHFqWDLoLtceo5Mss79WyepnEmZJl7F+rA8r6nZCLM0Q
        UwGdCOBSL/U7Sbzb9U+u9xfHOA==
X-Google-Smtp-Source: ACHHUZ7q7e7Tg1BdWpbPDPd+Pjd+pgjDAOZ9wkARLO/Bd52hIUUFEEnGT7DcWONAockW3n4coc2/bw==
X-Received: by 2002:a17:903:4293:b0:1b0:26f0:4c8e with SMTP id ju19-20020a170903429300b001b026f04c8emr2643302plb.69.1685979683648;
        Mon, 05 Jun 2023 08:41:23 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:41:23 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Mathis Salmen <mathis.salmen@matsal.de>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v21 16/27] riscv: signal: validate altstack to reflect Vector
Date:   Mon,  5 Jun 2023 11:07:13 +0000
Message-Id: <20230605110724.21391-17-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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

