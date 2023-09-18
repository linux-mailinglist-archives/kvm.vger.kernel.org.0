Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8412C7A4F50
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjIRQja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjIRQjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:39:16 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD33D1B1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:11:17 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-502984f5018so7818607e87.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053474; x=1695658274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kTBjPJZgBk13UdBUXwIisPTyIoW0XcuNCZty165NaD0=;
        b=WKpn98SV6of9c1lnbWY3PSv8hh6KASrw0feSpACl9JhxETN7d6WhzVBxDE1WP3FiL5
         7X/sY9FxUG9QpUC1non50cWeb8eAgi27KMh/phpbj9Ii+1PgHOr3CJhT27ryTNRl7nFd
         pxm5RyRvM/BzbjXM7P4YN/+ch4paWWLaWvRN9vv+OEGDdQ8rHpGjqk1/hC6Kej1iMIm7
         D66T1I0lwOoHIDRafMjTkSR25WgLX9DTRtTxCDU7LFvjmRsMdjiTgd2VqJmB8db8ZYDE
         WEuqqMsqpMEfNMpeSQONMOzISw6elY2FFH4G6jVTJhJaIgtiecKF5fBjTBxl0AWstMJU
         K3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053474; x=1695658274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kTBjPJZgBk13UdBUXwIisPTyIoW0XcuNCZty165NaD0=;
        b=VTYsrPkmROsnV797IgI6RR3xLBU3EnJjatuN4lofbUzikBqMllcGjSOsF9VXsLDThX
         wmuHBA/Q4aD+pkQDrApA6VG9tTFgSHAjkmz+9yZTN+OzsBDXAov2ihZnyhzdlMW77Yw2
         +at+1pA0ITOfHbbH6kZTkiXMbMuYCNHFRG6RPkgtFMWdvoTqwBunWHNNsux9zP4yKUzT
         2x4wphPi1AqjTjV3Yl+sdl4nybieIFFvI8PJz7amYhFQdJcvCyLd8GGL/iNtX1uVbDEK
         EfPlV1dZleOAmRimsHI0i848tkleHPW2T6nUpHfiMLWGDn3mdy0jY/jx7KQAtb4j5KGv
         RaSg==
X-Gm-Message-State: AOJu0Yy8hSal8TD2txzKPgFZG55tWMuh+Z67KGSKhvgQFGCkS2GGpNF+
        dXhuu1UJiheA/gdNtm9f+qJc2R+FWDHndZiZuq/DVibJ
X-Google-Smtp-Source: AGHT+IFq/QL5z5bo/y5y/kDRcLT1d9XsePcCQP72fHn+R4rgmGpcF6OIn0/xzDT8r3fspp9H+r5Uyw==
X-Received: by 2002:a05:6402:1bc8:b0:530:be79:49e7 with SMTP id ch8-20020a0564021bc800b00530be7949e7mr6068787edb.37.1695053016011;
        Mon, 18 Sep 2023 09:03:36 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id eh16-20020a0564020f9000b005256aaa6e7asm1688491edb.78.2023.09.18.09.03.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:35 -0700 (PDT)
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
        Palmer Dabbelt <palmer@dabbelt.com>,
        xianglai li <lixianglai@loongson.cn>,
        "Salil Mehta" <salil.mehta@opnsrc.net>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Bibo Mao <maobibo@loongson.cn>
Subject: [PATCH 07/22] exec/cpu: Introduce the CPU address space destruction function
Date:   Mon, 18 Sep 2023 18:02:40 +0200
Message-ID: <20230918160257.30127-8-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: xianglai li <lixianglai@loongson.cn>

Introduce new function to destroy CPU address space resources
for cpu hot-(un)plug.

Co-authored-by: "Salil Mehta" <salil.mehta@opnsrc.net>
Cc: "Salil Mehta" <salil.mehta@opnsrc.net>
Cc: Xiaojuan Yang <yangxiaojuan@loongson.cn>
Cc: Song Gao <gaosong@loongson.cn>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Eduardo Habkost <eduardo@habkost.net>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: "Philippe Mathieu-Daudé" <philmd@linaro.org>
Cc: Yanan Wang <wangyanan55@huawei.com>
Cc: "Daniel P. Berrangé" <berrange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: xianglai li <lixianglai@loongson.cn>
Message-ID: <3a4fc2a3df4b767c3c296a7da3bc15ca9c251316.1694433326.git.lixianglai@loongson.cn>
---
 include/exec/cpu-common.h |  8 ++++++++
 include/hw/core/cpu.h     |  1 +
 softmmu/physmem.c         | 24 ++++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 41788c0bdd..eb56a228a2 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -120,6 +120,14 @@ size_t qemu_ram_pagesize_largest(void);
  */
 void cpu_address_space_init(CPUState *cpu, int asidx,
                             const char *prefix, MemoryRegion *mr);
+/**
+ * cpu_address_space_destroy:
+ * @cpu: CPU for which address space needs to be destroyed
+ * @asidx: integer index of this address space
+ *
+ * Note that with KVM only one address space is supported.
+ */
+void cpu_address_space_destroy(CPUState *cpu, int asidx);
 
 void cpu_physical_memory_rw(hwaddr addr, void *buf,
                             hwaddr len, bool is_write);
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 92a4234439..c90cf3a162 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -366,6 +366,7 @@ struct CPUState {
     QSIMPLEQ_HEAD(, qemu_work_item) work_list;
 
     CPUAddressSpace *cpu_ases;
+    int cpu_ases_ref_count;
     int num_ases;
     AddressSpace *as;
     MemoryRegion *memory;
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 18277ddd67..c75e3e8042 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -761,6 +761,7 @@ void cpu_address_space_init(CPUState *cpu, int asidx,
 
     if (!cpu->cpu_ases) {
         cpu->cpu_ases = g_new0(CPUAddressSpace, cpu->num_ases);
+        cpu->cpu_ases_ref_count = cpu->num_ases;
     }
 
     newas = &cpu->cpu_ases[asidx];
@@ -774,6 +775,29 @@ void cpu_address_space_init(CPUState *cpu, int asidx,
     }
 }
 
+void cpu_address_space_destroy(CPUState *cpu, int asidx)
+{
+    CPUAddressSpace *cpuas;
+
+    assert(asidx < cpu->num_ases);
+    assert(asidx == 0 || !kvm_enabled());
+    assert(cpu->cpu_ases);
+
+    cpuas = &cpu->cpu_ases[asidx];
+    if (tcg_enabled()) {
+        memory_listener_unregister(&cpuas->tcg_as_listener);
+    }
+
+    address_space_destroy(cpuas->as);
+
+    cpu->cpu_ases_ref_count--;
+    if (cpu->cpu_ases_ref_count == 0) {
+        g_free(cpu->cpu_ases);
+        cpu->cpu_ases = NULL;
+    }
+
+}
+
 AddressSpace *cpu_get_address_space(CPUState *cpu, int asidx)
 {
     /* Return the AddressSpace corresponding to the specified index */
-- 
2.41.0

