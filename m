Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A0F6BE866
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 12:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjCQLiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 07:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCQLix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 07:38:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9029B3E2E
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso8809304pjb.0
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 04:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1679053073;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+aD01a07TD9YiAyArNVpoWUMoGh41bK5OsvLALwwGTk=;
        b=kgz33J1KTriakXGsceNyZdDcVQmgksAsmhVAl/JM3kI+JZxyb7q9TueRxzUxqrnVL2
         kZ1EPX+wNxy+z5TjRoyR5BMjusEV+Jg6LxJHWmM63Elm3em3Y7vFS720jxtTKOgj1k/H
         gY3ZfvYcvi0ErSlRIpNvm3Xq2umG0E47PJJA/9gNsWMMG/XMpB3fb5I3vZ/akzgBmYlj
         8GVJxiSl+BAdndoDCsSv3H8mfB4HiU/jlGF7zHOhoSiIsVueDXlJ6O9iOZDKvhUADYpe
         IdiqrLUuq/jRHt6/pLTAwAVDHf4fGULXgYZKDH0z3U7JduJGGKkW9HGS3vD3G9S6pHjm
         sVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053073;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+aD01a07TD9YiAyArNVpoWUMoGh41bK5OsvLALwwGTk=;
        b=Wqm6nBviwjaxtAGtaiWcVt8a//m1bL0fn3T91/x/UR5f+jrd2mTvGTR7hbdmmXzAyl
         HVXGeYUdCa5m/+bGgodQVZSx2HbgqRbCcOANoHJgOjJeCyem+ObzSGH9t2nLCVmLOHiF
         Z3WTyBVKW/XBTEJpNayFy2BzYPVj12bBzNgsMkCPq4uuXeM+ywXwGB412y0t4vFFD6JE
         /7P+YQLXLEcsywfc0O6uAst31hiVbIyxyawBcrz6uOxyBvJpQKsic4H48xHsZRMARL10
         HbZ1WVWON8lTUz/0chHZ2ALKyF0J7CTGc9mXoSDMdGwPU9ZXfiC3xMGcv3FPMpLhP4J1
         l1sA==
X-Gm-Message-State: AO0yUKXrmXHCjDNo66IeN234akRDR5/ppIoN20UlUMK02JSZZASYxlqI
        LoK7ZaXVYrJaoPBGcTJw0ABuyw==
X-Google-Smtp-Source: AK7set+QG1o+yUDrVrmWTPRkmTPPW7OcS7fKYgXunBMDI70R12mYh+xc8Szb1J7aY+sAETv+D8BIqA==
X-Received: by 2002:a17:90b:1d87:b0:23b:53d3:b537 with SMTP id pf7-20020a17090b1d8700b0023b53d3b537mr2943778pjb.1.1679053072800;
        Fri, 17 Mar 2023 04:37:52 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0023d3845b02bsm1188740pjd.45.2023.03.17.04.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:37:52 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: [PATCH -next v15 15/19] riscv: signal: validate altstack to reflect Vector
Date:   Fri, 17 Mar 2023 11:35:34 +0000
Message-Id: <20230317113538.10878-16-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230317113538.10878-1-andy.chiu@sifive.com>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 arch/riscv/kernel/signal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index d2d9232498ca..b8ad9a7fc0ad 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -494,3 +494,11 @@ void __init init_rt_signal_env(void)
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
+
-- 
2.17.1

