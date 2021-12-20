Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E04847AA29
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbhLTNJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 08:09:45 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:30145 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbhLTNJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 08:09:44 -0500
Received: from kwepemi100002.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JHfy42fWVz8vyl;
        Mon, 20 Dec 2021 21:07:24 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100002.china.huawei.com (7.221.188.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 21:09:42 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 20 Dec
 2021 21:09:41 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <wanghaibin.wang@huawei.com>,
        <wanbo13@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Mingwang Li <limingwang@huawei.com>,
        Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH v3 09/12] target/riscv: Add host cpu type
Date:   Mon, 20 Dec 2021 21:09:16 +0800
Message-ID: <20211220130919.413-10-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20211220130919.413-1-jiangyifei@huawei.com>
References: <20211220130919.413-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'host' type cpu is set isa to RV32 or RV64 simply, more isa info
will obtain from KVM in kvm_arch_init_vcpu()

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Anup Patel <anup.patel@wdc.com>
---
 target/riscv/cpu.c | 15 +++++++++++++++
 target/riscv/cpu.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 3fc3a9c45b..c6d979594b 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -213,6 +213,18 @@ static void rv32_imafcu_nommu_cpu_init(Object *obj)
 }
 #endif
 
+#if defined(CONFIG_KVM)
+static void riscv_host_cpu_init(Object *obj)
+{
+    CPURISCVState *env = &RISCV_CPU(obj)->env;
+#if defined(TARGET_RISCV32)
+    set_misa(env, MXL_RV32, 0);
+#elif defined(TARGET_RISCV64)
+    set_misa(env, MXL_RV64, 0);
+#endif
+}
+#endif
+
 static ObjectClass *riscv_cpu_class_by_name(const char *cpu_model)
 {
     ObjectClass *oc;
@@ -814,6 +826,9 @@ static const TypeInfo riscv_cpu_type_infos[] = {
         .class_init = riscv_cpu_class_init,
     },
     DEFINE_CPU(TYPE_RISCV_CPU_ANY,              riscv_any_cpu_init),
+#if defined(CONFIG_KVM)
+    DEFINE_CPU(TYPE_RISCV_CPU_HOST,             riscv_host_cpu_init),
+#endif
 #if defined(TARGET_RISCV32)
     DEFINE_CPU(TYPE_RISCV_CPU_BASE32,           rv32_base_cpu_init),
     DEFINE_CPU(TYPE_RISCV_CPU_IBEX,             rv32_ibex_cpu_init),
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 2807eb1bcb..e7dba35acb 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -45,6 +45,7 @@
 #define TYPE_RISCV_CPU_SIFIVE_E51       RISCV_CPU_TYPE_NAME("sifive-e51")
 #define TYPE_RISCV_CPU_SIFIVE_U34       RISCV_CPU_TYPE_NAME("sifive-u34")
 #define TYPE_RISCV_CPU_SIFIVE_U54       RISCV_CPU_TYPE_NAME("sifive-u54")
+#define TYPE_RISCV_CPU_HOST             RISCV_CPU_TYPE_NAME("host")
 
 #if defined(TARGET_RISCV32)
 # define TYPE_RISCV_CPU_BASE            TYPE_RISCV_CPU_BASE32
-- 
2.19.1

