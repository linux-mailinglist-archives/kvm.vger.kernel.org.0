Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCC87A4F68
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjIRQm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjIRQmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:42:14 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8530930FC
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:11 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-991c786369cso637508466b.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053026; x=1695657826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSVRQGIJEmce1VSEx8yaDe0o7AipRr5BDfgLzGOyz48=;
        b=M2kBVeM3dI60skb5HWNU5zPVPQw4We/Zu1++N/sMSBDSlWRIPW8ZRgsfEI5DhTO4Y/
         8PXyb7qsYu8kTS+sEb2W9ktjLRaLrCY0FRyncACqpxoa+YdWKinIgdR+u3tKibg07XBP
         DCns4AQ6x6/4HwQC9VCAWca8Mruk9RIII9UhWbnbwu4ctbjjkDOQ7NRZhRj+oCpWd9Di
         wnToxbwGG6Of53KO7HvE7QktEzwjR/zXAvkflgw4ui21VuvgaFyvUK63Axr/v+NkQQrm
         w88qB9GGiBDRRDRgYWc0mLOsuB1M0A471U2hlOnV0lkLx5JhmzHSUY/zRf51CAR+UKv9
         8Q1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053026; x=1695657826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hSVRQGIJEmce1VSEx8yaDe0o7AipRr5BDfgLzGOyz48=;
        b=iMSHnf/NRT66slhfqjn0eraeVYUpMgJJEpw2Kpo1Qle03qrH3egc3+AzHKmvdlF58E
         WCT5Jx2pbh3eVMay3hnWcEUyxyehg9NEBZWNufgAglIQNugsP34i7RxaiOdXowIdqKYO
         5QDmrgQNi8iGEDLlChbucPRsPundgiEFGmgK5mV9D6UWYesopXMl3yxJDuSjbnQdDhKr
         nacI+nVk94OePQo0vw8xCn4Z2V90gA2NAe+AcwfOA/W5HZCChPrKkVSa7XUV62wQ9FQz
         sh5+0rA/NJFVyLYJyfArBvPmPJ1Hcue94iWcaBZTcj3j5CCVa25maKlSuG0Wych4hmsG
         7dYw==
X-Gm-Message-State: AOJu0YxpiftjhkFtns1CmG0kfV4/Q5j0dCoptxHjMMsCkDsWqkpMCAzC
        XizIN0wt3zUHSp6uG6UlpZdrOg==
X-Google-Smtp-Source: AGHT+IG4piDQtxZVYFiU0HjN8n/Q699dig17N/FQPVs1xyeDcBS2KjVyyREmZ08RNzkeawSSuXGK6A==
X-Received: by 2002:a17:906:74d5:b0:9a1:8ee9:cc0b with SMTP id z21-20020a17090674d500b009a18ee9cc0bmr8829825ejl.21.1695053026100;
        Mon, 18 Sep 2023 09:03:46 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id g5-20020a170906394500b0099bc038eb2bsm6614676eje.58.2023.09.18.09.03.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:45 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Brian Cain <bcain@quicinc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
        Claudio Fontana <cfontana@suse.de>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Alessandro Di Federico <ale@rev.ng>,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Chris Wulff <crwulff@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
        Bin Meng <bin.meng@windriver.com>,
        Stafford Horne <shorne@gmail.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kurz <groug@kaod.org>, Michael Rolnik <mrolnik@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 09/22] target/arm: Create timers *after* accelerator vCPU is realized
Date:   Mon, 18 Sep 2023 18:02:42 +0200
Message-ID: <20230918160257.30127-10-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Architecture specific hardware doesn't have a particular dependency
on the accelerator vCPU (created with cpu_exec_realizefn), and can
be initialized *after* the vCPU is realized. Doing so allows further
generic API simplification (in few commits).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index fc3772025c..46d3f70d63 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1748,7 +1748,15 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
             return;
         }
     }
+#endif
 
+    cpu_exec_realizefn(cs, &local_err);
+    if (local_err != NULL) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
+#ifndef CONFIG_USER_ONLY
     {
         uint64_t scale;
 
@@ -1776,12 +1784,6 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
     }
 #endif
 
-    cpu_exec_realizefn(cs, &local_err);
-    if (local_err != NULL) {
-        error_propagate(errp, local_err);
-        return;
-    }
-
     arm_cpu_finalize_features(cpu, &local_err);
     if (local_err != NULL) {
         error_propagate(errp, local_err);
-- 
2.41.0

