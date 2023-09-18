Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286D87A4F6E
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbjIRQmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjIRQmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:42:20 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B3A3A9B
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:04 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2b9c907bc68so78621831fa.2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053011; x=1695657811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkWYWSxfkqk4N63ErKsmSMdZBfBTpiMgD55n/Z94pZY=;
        b=xLQU8Lfb4Bm3xgvdBHP62byB3NDN5vgEtqvAYsSokcKH0P6Xcj6d2r/o1SPKD2sWoK
         BVzMkrrpr3qGFducXEx9u0xhTkrP2BFFOcWPyZEbiuR+5mZJJGAy7W/icZEBZ/ZVzwmF
         vbI3PjFv9SWFHtGuO8d17Wj7vfW24RQS2bUY7x1/dIVzXhNuzZ1bpuczbyqjNVA9i7xZ
         G/3miTIsGz88puVc6nTNN508/LQhs9QUDeYEMoG0SlfLdYxHDojaXRcQsFA3KrkiGsNG
         eHdfGzZoj6gzeh+Ne+nEc6HFsSOuD8s4zRH/XkydSQOUCYSpxY8PB5ajsoKf77DiwX1d
         M+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053011; x=1695657811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PkWYWSxfkqk4N63ErKsmSMdZBfBTpiMgD55n/Z94pZY=;
        b=bVi0UW9j/2fLH/iymKeV2v3JoUHYtzDG4WvXKzBfcDzL6wpIMImdrbbFGViPPBPncQ
         3FvUR7yHe0wIGP1hZiIvIBCjWg18ykcAX47ZV6C0h8E0VT1kyVfvrxBA4BZHy3vDYlwK
         XrVOQSIEgw7C+/P8EDNWu95roCdqtyvJhZWRfShzDOv0XB/aXHZ7U13jJtpTtzI07iBe
         MesZeRrcjafzl4KPoFToqifNoMu3dQrBsAH7odBVZVgZeNA7p3pnjRIRTlAH93kseDQd
         X8hrUSMMI83mwqttAkT79TKgqkH6ofCkoW3zV5jKL/y9hCkMfxiZIlO2D4a6bLtpcj5c
         DbOg==
X-Gm-Message-State: AOJu0YyEVuecqWfUGWWLcmKnPVXSmSrZMlCw5q8iLc7lLBnbKKzmzd9S
        hjhkLsZ55+oJfVxADo9M1Pfpfg==
X-Google-Smtp-Source: AGHT+IG9O7CyLiK/FqL5kcaE3CE/w3qepssp8f0K4INaJRuY2qrHmvactqhGEUSaLUJRFKiBVFJyXQ==
X-Received: by 2002:a2e:330c:0:b0:2b6:d13a:8e34 with SMTP id d12-20020a2e330c000000b002b6d13a8e34mr7309381ljc.46.1695053010845;
        Mon, 18 Sep 2023 09:03:30 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id o15-20020a1709061d4f00b0099cf840527csm6708419ejh.153.2023.09.18.09.03.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:30 -0700 (PDT)
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
Subject: [PATCH 06/22] exec/cpu: Call cpu_remove_sync() once in cpu_common_unrealize()
Date:   Mon, 18 Sep 2023 18:02:39 +0200
Message-ID: <20230918160257.30127-7-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While create_vcpu_thread() creates a vCPU thread, its counterpart
is cpu_remove_sync(), which join and destroy the thread.

create_vcpu_thread() is called in qemu_init_vcpu(), itself called
in cpu_common_realizefn(). Since we don't have qemu_deinit_vcpu()
helper (we probably don't need any), simply destroy the thread in
cpu_common_unrealizefn().

Note: only the PPC and X86 targets were calling cpu_remove_sync(),
meaning all other targets were leaking the thread when the vCPU
was unrealized (mostly when vCPU are hot-unplugged).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/core/cpu-common.c  | 3 +++
 target/i386/cpu.c     | 1 -
 target/ppc/cpu_init.c | 2 --
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index a3b8de7054..e5841c59df 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -221,6 +221,9 @@ static void cpu_common_unrealizefn(DeviceState *dev)
 
     /* NOTE: latest generic point before the cpu is fully unrealized */
     cpu_exec_unrealizefn(cpu);
+
+    /* Destroy vCPU thread */
+    cpu_remove_sync(cpu);
 }
 
 static void cpu_common_initfn(Object *obj)
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index cb41d30aab..d79797d963 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7470,7 +7470,6 @@ static void x86_cpu_unrealizefn(DeviceState *dev)
     X86CPUClass *xcc = X86_CPU_GET_CLASS(dev);
 
 #ifndef CONFIG_USER_ONLY
-    cpu_remove_sync(CPU(dev));
     qemu_unregister_reset(x86_cpu_machine_reset_cb, dev);
 #endif
 
diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
index e2c06c1f32..24d4e8fa7e 100644
--- a/target/ppc/cpu_init.c
+++ b/target/ppc/cpu_init.c
@@ -6853,8 +6853,6 @@ static void ppc_cpu_unrealize(DeviceState *dev)
 
     pcc->parent_unrealize(dev);
 
-    cpu_remove_sync(CPU(cpu));
-
     destroy_ppc_opcodes(cpu);
 }
 
-- 
2.41.0

