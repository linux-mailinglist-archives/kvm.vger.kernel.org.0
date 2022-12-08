Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC08564733D
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 16:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiLHPgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 10:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHPgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 10:36:19 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8114B750BC
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 07:35:39 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m19so1330938wms.5
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 07:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q7RS6UvhOjqcYyu9Kw9e2FPYxya3Ny6m4Myksv2MLL4=;
        b=Jb/HWx35b+MtI6qBxIsRwbEw6joOnDCickQMBxUWMv8ACprcbix5ALhfED1cXn7zyP
         1e39u8vTM4eEAUw86m3FLwmt8IPHqE1LoYRyA0VP1apn/ZHnZrsoxZJYG/imRavJfplr
         O8PFqGz9twAjDzSFzgCvbXviB/s7n4P2xjJlqHXDyV+RoLEmUE+wU2HRXjaf5BoN9Pcs
         cyhnIASf7v2t63hX7ZpSLSFH9Mrn7NoQ/mwoVfizSw3m77UL4Xz0MOoxxN73ZeLtiVir
         o8CgfsmLIotwTbS3EfxSzBftxkvWvH1bY5hxcuVW30VPTET/qr9fXy6QGoGxJIDdLmxv
         g6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q7RS6UvhOjqcYyu9Kw9e2FPYxya3Ny6m4Myksv2MLL4=;
        b=i1vCodgcjuy+tGYz9tZwQ4Ng1sJY3JkC2uPLphX+OGYeVwxxH2DIGrBlRzOHSMZtCg
         kyObEitXDTw+4T+Yng5olPLvbdyUn1aZhHW9kAxOEKCrEGuptM2MQBH5SRZjEUJqEBOs
         /cPII8I/BL2s9kNTco8qNrBa+gure2SK4daoCGHLEj0n74JvumxmDT+k3Y5x+ms0De1C
         oNx0Oq8NJKwEZkbqWXlJJG8dttdovmjW8bD9uKLrJ1S7nArTK8AzCRpTFVJokbpjvHH/
         qVeFDzZheTQ/IMjAu1Pqpi4zdyp0brxyy4mZNnKQweccnwHEz5FH9YUQJOI4c+MwnAHO
         BU3g==
X-Gm-Message-State: ANoB5pm3aBAulpGY1a8pjVAtF0xtIv2IHmMpqYTBsuGpcsMImpNFdxj/
        n1mt51Zny2d7Skvjj/muKuXppw==
X-Google-Smtp-Source: AA0mqf5GRks/FSj81VAor7KpuA/Da36aH3ckWQFqynuKRTr7/83Wm78Sk7brGSoOwvfQFhftwSqj+g==
X-Received: by 2002:a7b:c358:0:b0:3d1:f882:43eb with SMTP id l24-20020a7bc358000000b003d1f88243ebmr1952493wmj.10.1670513738126;
        Thu, 08 Dec 2022 07:35:38 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id f16-20020a05600c4e9000b003c6c182bef9sm7940862wmq.36.2022.12.08.07.35.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Dec 2022 07:35:37 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Greg Kurz <groug@kaod.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Stafford Horne <shorne@gmail.com>,
        Anton Johansson <anjo@rev.ng>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        Chris Wulff <crwulff@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Marek Vasut <marex@denx.de>, Max Filippov <jcmvbkbc@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Laurent Vivier <laurent@vivier.eu>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>
Subject: [PATCH-for-8.0 v2 1/4] cputlb: Restrict SavedIOTLB to system emulation
Date:   Thu,  8 Dec 2022 16:35:25 +0100
Message-Id: <20221208153528.27238-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208153528.27238-1-philmd@linaro.org>
References: <20221208153528.27238-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 2f3a57ee47 ("cputlb: ensure we save the IOTLB data in
case of reset") added the SavedIOTLB structure -- which is
system emulation specific -- in the generic CPUState structure.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 8830546121..bc3229ae13 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -222,7 +222,7 @@ struct CPUWatchpoint {
     QTAILQ_ENTRY(CPUWatchpoint) entry;
 };
 
-#ifdef CONFIG_PLUGIN
+#if defined(CONFIG_PLUGIN) && !defined(CONFIG_USER_ONLY)
 /*
  * For plugins we sometime need to save the resolved iotlb data before
  * the memory regions get moved around  by io_writex.
@@ -406,9 +406,11 @@ struct CPUState {
 
 #ifdef CONFIG_PLUGIN
     GArray *plugin_mem_cbs;
+#if !defined(CONFIG_USER_ONLY)
     /* saved iotlb data from io_writex */
     SavedIOTLB saved_iotlb;
-#endif
+#endif /* !CONFIG_USER_ONLY */
+#endif /* CONFIG_PLUGIN */
 
     /* TODO Move common fields from CPUArchState here. */
     int cpu_index;
-- 
2.38.1

