Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6DE73FB65
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 13:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjF0Lv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 07:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjF0Lvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 07:51:54 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D23120
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:53 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51d9124e1baso3780056a12.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 04:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687866711; x=1690458711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGZXRn778tTjabpObTTq7zFLfhDFVmkSDdvtG4Gr8rE=;
        b=ivXPP7EELHfP6sJ0l5qbHx5mCV8QlbwHGwSr7NB/wOhD6ru2flkDn3IF6/KjnLc1Sc
         RuPyAvov01ZLYBdsoZomj1ewZoI+FtwOEl+ccTsSDdOldyqu+FZwmlFqzaqtzYFbfs8P
         ce1DotNHn0nwCBkYyHAAx/Bd9+mhjvIj0Pyhk+o56mBDh/nXkkbTS71Ee83uhnydL9yI
         P77qRKp256o1b5l9IuNXT9ndDCwwreprJlClr4Q5c4N+b1Th9tj8Xpj+sbA3a1w9/BJR
         GOcbV8TtL+sewaMNfqzFZ2+sjHp2XuNJOG9liHKOZSwFlzeMYHcKGHdDLNplrav8YT5U
         JkmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687866711; x=1690458711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TGZXRn778tTjabpObTTq7zFLfhDFVmkSDdvtG4Gr8rE=;
        b=SDtwEMkz5S8BY93ngEyhWLORUq8aHekH27iS2/g5DLkDeg+8/8pmmshijU0ePJNprX
         HmvIYGhsi+Yw6UBGAeftYT/CcThSwkQ5P1QeJLmCkha5bs384t/z5v2t6EnQ75JD/CF4
         P/vrECW/Xh/D0WD1cRgqDWRORv3NSI+fYMBG1zOHDBDIBFWk6bThbVVu+O07wLRQwEBk
         MBdBUI731LChm26Q5FqBdakhVWIMoakKiN8DdWiZ7EuU1SeuFHclk5IcNb9zB6yFJ6Pf
         H40HqU0D+ze7doTQb5VGGhIf1uXt7rTOl3rFRDe9VyilzwQ/UWz4hYT7AZjWqz8L8YB0
         cUIQ==
X-Gm-Message-State: AC+VfDyiGaqf6C7tQu+o9GosvU9DvxFokH2kpYCjuWN0Hkmkx62U2qCg
        Twmvq184Bhbz9AxFrVEqGQ60fQ==
X-Google-Smtp-Source: ACHHUZ6KmfyVDXHoF0LSGwDDJ1p2i/7O7JP2KiimBL6Oz48s5RB2ncVVHEPFcgvvbfKEdG3eNwqUoQ==
X-Received: by 2002:aa7:d5d6:0:b0:51d:961c:8ad4 with SMTP id d22-20020aa7d5d6000000b0051d961c8ad4mr4856426eds.28.1687866711477;
        Tue, 27 Jun 2023 04:51:51 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id v20-20020aa7dbd4000000b00514a5f7a145sm3701418edt.37.2023.06.27.04.51.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Jun 2023 04:51:51 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v3 4/6] target/ppc: Define TYPE_HOST_POWERPC_CPU in cpu-qom.h
Date:   Tue, 27 Jun 2023 13:51:22 +0200
Message-Id: <20230627115124.19632-5-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230627115124.19632-1-philmd@linaro.org>
References: <20230627115124.19632-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TYPE_HOST_POWERPC_CPU is used in various places of cpu_init.c,
in order to restrict "kvm_ppc.h" to sysemu, move this QOM-related
definition to cpu-qom.h.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/cpu-qom.h | 2 ++
 target/ppc/kvm_ppc.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/ppc/cpu-qom.h b/target/ppc/cpu-qom.h
index c2bff349cc..4e4061068e 100644
--- a/target/ppc/cpu-qom.h
+++ b/target/ppc/cpu-qom.h
@@ -36,6 +36,8 @@ OBJECT_DECLARE_CPU_TYPE(PowerPCCPU, PowerPCCPUClass, POWERPC_CPU)
 #define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
 #define cpu_list ppc_cpu_list
 
+#define TYPE_HOST_POWERPC_CPU POWERPC_CPU_TYPE_NAME("host")
+
 ObjectClass *ppc_cpu_class_by_name(const char *name);
 
 typedef struct CPUArchState CPUPPCState;
diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 49954a300b..901e188c9a 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -13,8 +13,6 @@
 #include "exec/hwaddr.h"
 #include "cpu.h"
 
-#define TYPE_HOST_POWERPC_CPU POWERPC_CPU_TYPE_NAME("host")
-
 #ifdef CONFIG_KVM
 
 uint32_t kvmppc_get_tbfreq(void);
-- 
2.38.1

