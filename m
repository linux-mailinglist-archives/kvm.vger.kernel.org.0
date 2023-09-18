Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2374D7A4E04
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjIRQFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjIRQFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:05:08 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC0F30C1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:03:52 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2bffd6c1460so25542671fa.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695052984; x=1695657784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YY2zRc5UQ1ttBDAhQdzUYI1/2Fa0E28wpiBNWWnnf1g=;
        b=eWi3S/iiKr9RjgREjPL/yrs63YwjNxQbfu9bt339CgVyccD3bhoifgl/L6bhE27F1s
         dAn0C725urmuSNJTUTKCMjaHPpPwF8qKRJ6QURkIpgUVquIWyyYK67vyFP3m+qMLMSNa
         vTE6OAWtOkgLFZsC8VcZaSPAH+p0HsHEDj8OBLzh1nW4Y34G+taJ3DjcvNVRAglRBPXQ
         bo8uOATnPpXpOAI2VzqSGpawjLhFLo7+ZHFwWXShObNJAjNeF0tQw7gzSfOcgTlBFCZC
         BR9SN6kLqgmb3EhPSG3UNeZcvfSDdoSbXGzcLmnlMCxCVWwPml/4T73auYaTBaeHk+Nq
         jlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695052984; x=1695657784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YY2zRc5UQ1ttBDAhQdzUYI1/2Fa0E28wpiBNWWnnf1g=;
        b=IUM3Pltuz4nIG/QtznSdZKeDoua27ioGWWW8x0/wrgZVghD+HfroMHMFzCefQFuPIU
         yYT8YstlsjkJy4uVaUtgw1nLwoRxJy2Q+vZhLWJyFc66Qm5HTZj6CbYqw5gWReY0ksAB
         pP8Ibj4gg1VGKHs9GyiMOfGBKVrDP3kQpHz8C0YavegjYaMll2fj7ArIf3FBkyvk4JNU
         xWy94WTYI7uGjAVsszdd8OyOYiIEC2/DMJiRhwCb3ALCr66+fEQOBpxfNRhmCBcOY8id
         V/6y2brG9X/e2PAkgIz3widWJQlPejxIcaBDIfBhCKpZuevVhbyBcslr5ado4hxUhDJg
         8x7A==
X-Gm-Message-State: AOJu0Yw2QXUUUGenNVYva7fY91h1qkxmGAcsRdG1p05cBq7aTTAkheDX
        0uSNR0aob3VgyhXwsNN3CwKavg==
X-Google-Smtp-Source: AGHT+IFFWaHmceQaMQCtP1tx1U1BqdKcHKrYFUd0/PUiwjaiOXpmM2RbiU2HoQiVRUd/I863ShUWOQ==
X-Received: by 2002:a2e:3614:0:b0:2b9:f27f:e491 with SMTP id d20-20020a2e3614000000b002b9f27fe491mr9068179lja.42.1695052984526;
        Mon, 18 Sep 2023 09:03:04 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id x5-20020a1709065ac500b00993664a9987sm6574017ejs.103.2023.09.18.09.03.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:04 -0700 (PDT)
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
Subject: [PATCH 01/22] target/i386: Only realize existing APIC device
Date:   Mon, 18 Sep 2023 18:02:34 +0200
Message-ID: <20230918160257.30127-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APIC state is created under a certain condition,
use the same condition to realize it.
Having a NULL APIC state is a bug: use assert().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu-sysemu.c | 9 +++------
 target/i386/cpu.c        | 8 +++++---
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
index 2375e48178..6a164d3769 100644
--- a/target/i386/cpu-sysemu.c
+++ b/target/i386/cpu-sysemu.c
@@ -272,9 +272,7 @@ void x86_cpu_apic_create(X86CPU *cpu, Error **errp)
     APICCommonState *apic;
     APICCommonClass *apic_class = apic_get_class(errp);
 
-    if (!apic_class) {
-        return;
-    }
+    assert(apic_class);
 
     cpu->apic_state = DEVICE(object_new_with_class(OBJECT_CLASS(apic_class)));
     object_property_add_child(OBJECT(cpu), "lapic",
@@ -293,9 +291,8 @@ void x86_cpu_apic_realize(X86CPU *cpu, Error **errp)
     APICCommonState *apic;
     static bool apic_mmio_map_once;
 
-    if (cpu->apic_state == NULL) {
-        return;
-    }
+    assert(cpu->apic_state);
+
     qdev_realize(DEVICE(cpu->apic_state), NULL, errp);
 
     /* Map APIC MMIO area */
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b2a20365e1..a23d4795e0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7448,9 +7448,11 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     }
 
 #ifndef CONFIG_USER_ONLY
-    x86_cpu_apic_realize(cpu, &local_err);
-    if (local_err != NULL) {
-        goto out;
+    if (cpu->env.features[FEAT_1_EDX] & CPUID_APIC || ms->smp.cpus > 1) {
+        x86_cpu_apic_realize(cpu, &local_err);
+        if (local_err != NULL) {
+            goto out;
+        }
     }
 #endif /* !CONFIG_USER_ONLY */
     cpu_reset(cs);
-- 
2.41.0

