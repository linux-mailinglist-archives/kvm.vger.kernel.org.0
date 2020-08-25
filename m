Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D259251F85
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 21:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHYTG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 15:06:27 -0400
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:7937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726777AbgHYTGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 15:06:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbTEsnU2PcNmjfk1FeN7Sk/CqflXDjRK0Vi761brPaUnHHBpl8bLTNVvmiFvbzbkEht7kU0tZaj3/agziSm+pMkPwgQlCLZ0XWPE9hKzbNdgJW0sPFOCGBHdYqmsywLyGhCa29IuLs5u/2nEPk6wWYeJArdgyMJ1Ir5n/BrTEr0IYSisxekepuN3/ZmLcCU+V15xDk5QTdbssUbIGJK+dHYlqNreQV7XVg7bmGxf6y6wIKXQJJYmIVwYN74TvA0nVdRKfx7qWq4q4vJqWfFhCBGkEd4iyGBwinmMGduYpo19WHWyYQtIUAH9ITtfoD59rRSqrxrCwi/duJkTnib1Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ad/nf83l2epmwPr5uQxGiDbyaCIjQcn72MgaSbtOkXA=;
 b=M8EHC6/nS8IzHuLK73BMceH8VgTfM1r4EkJCb82jKIBcHD+UwkwL7JZXF4Tu3SdP+U9mbs1htuG/A7MgzWV5oGZMYf9fFA1H/yDjJxWAjSgsTz2VIfEyDPb53NV15h8Xw8QIfIp8rdFSZe6KDmiqTij+4waDCZ3/vBQPrCxTFswfpuv8O51C5+9RR9iDGsKWgnXClWncLxlsJX+kY5bnSnpPRKxtM96HTlwOQJoesuikWV3o02OvzjCHCaW37WBLhBsE6QmTC+KQx609FzziTo8OkM0+pFn4ktYh+sWiuD7y8BxtXvhJm+24je51ZZ2RFEkXxWgLy+dis++Vk17v9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ad/nf83l2epmwPr5uQxGiDbyaCIjQcn72MgaSbtOkXA=;
 b=foGvAMRCEW8GyRVdLX0sEV9JV5MSsFheVArnXkuzkcuL45ULTVdYU+6WPhQICqbMKk2+NtSLb3qXkgoKsuN/TnaFdyxd+U7H9nQzlQ4TjnFHYnpACLk//WUN8if2Go385OEsqnLQPZWM4Lrl/ubrs9Ua/a/V3qrpvkzzLyieEvc=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0219.namprd12.prod.outlook.com (2603:10b6:4:56::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.25; Tue, 25 Aug 2020 19:06:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 19:06:22 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH 3/4] sev/i386: Don't allow a system reset under an SEV-ES guest
Date:   Tue, 25 Aug 2020 14:05:42 -0500
Message-Id: <b394ef2e743ebd57d3b8fb5ce1d5069c030ffcfc.1598382343.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1598382343.git.thomas.lendacky@amd.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:3:ef::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM5PR04CA0072.namprd04.prod.outlook.com (2603:10b6:3:ef::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 19:06:21 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a38ec267-063a-45b1-c359-08d84929f481
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0219:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB021916684866E417C76DD181EC570@DM5PR1201MB0219.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:418;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EiazKAsyb/ymA9ReNqx5WgUJskeRDjbriiMy6NmfTvxbD/M8oYbeflFNxLNjXm+RGoVASt5DYZ0vt2REp3cCOYHjM2lLsa1cD4gdDaEZxMKhjOmozB4umTWNfU7cEpXzrn4Tg8jGeKnIYsVlq9WxL6svLQA1YOyxpgrjVxKd0WjQlsvWV+9fZo6Hu9IR1h3bWvJniVHncSHB1scDXIJNklh3JUkk8pJeu9mqHibwEJDOUCjc9+dmZhv9fhUtsLKCzEaPRPGsMCPafZt0cI8WpvdmpY88cOB8NjshfBT1v0jchFciptNmLNseByk5TuT4NlgXwFtoapMm46u8nbrtmK2Bs2tbk8vMFkOuPhnRv2KUwrVLVaRoC7hhyx0TOm3H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(4326008)(186003)(86362001)(8676002)(83380400001)(54906003)(16576012)(8936002)(6486002)(316002)(478600001)(36756003)(52116002)(26005)(6666004)(66556008)(2616005)(66476007)(66946007)(956004)(2906002)(5660300002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9VCSk67WJUEOHaTTwrZqZoiXgwHBbN+q1M/xqCyPImdsttk8WKcrv6r6jHCsAKtH8BMe1ChQsM+BNb5rSi4/vmwK7I5SJHmYgrn/OJVX6OaturzwUQE79zn8a3V9+sRdj1VaqbGHvNF3YOvZ6XTBH2HOTWJSxb+UE4L9MGKFShAfXPhIrkrUJCsxKwa09VD4kR3GyA0jS6xTh6xJMWpgquUn0/r3lzjWt0bArjT5sS+OeCB7LBgIRwXMZZTgBKmtIkbtNwC+69wguwrGKesuitwGC+JTs2hUnAX9mTj18BbCSNu9OObDLSPuL2ueJq/6VElJEgxH5yd6D00cc2wgC863YpXvmUugUP4C9ldrS/lRDtUpc3d9XawpyzVXgAa40cQD/wtdyo/3/vx7Zk/hvYRyg3s84Dp6qCQ3vDNNKAqLA22mCFjGBdCq0k4tA/njoTHI0kPZTPj7f4J9mtQmfq2X/E2OL4Jfrfha8Vdo9yEBCDBeZSKlO5P9GOPdFmeMNSmsDUdjRLhX9Uqk6OynuPAzMLTml6WilEVCc9d8M7MQx4ea8G3z+usF08O0pkQiFDAWDCD2kQMPHldAcHV8Efai87goCrfMpSrh8CMHWxVJjR70ZjGx01aFKhKVpB4MNpx3HfYmSdZKSq7EHUMqVA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a38ec267-063a-45b1-c359-08d84929f481
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 19:06:22.1595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+uFI3g/d6iQaD+m+iMFNXsY17cdfNDFDzwAE5/71u6ErD9UgK+BBeHQBYYqza96iR+ngBhQMMfeGb1ssb0mcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0219
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

An SEV-ES guest does not allow register state to be altered once it has
been measured. When a SEV-ES guest issues a reboot command, Qemu will
reset the vCPU state and resume the guest. This will cause failures under
SEV-ES, so prevent that from occurring.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 accel/kvm/kvm-all.c       | 8 ++++++++
 include/sysemu/cpus.h     | 2 ++
 include/sysemu/hw_accel.h | 4 ++++
 include/sysemu/kvm.h      | 2 ++
 softmmu/cpus.c            | 5 +++++
 softmmu/vl.c              | 5 ++++-
 6 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 54e8fd098d..1d925821b2 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2384,6 +2384,14 @@ void kvm_flush_coalesced_mmio_buffer(void)
     s->coalesced_flush_in_progress = false;
 }
 
+bool kvm_cpu_check_resettable(void)
+{
+    /* If we have a valid reset vector override, then SEV-ES is active
+     * and the CPU can't be reset.
+     */
+    return !kvm_state->reset_valid;
+}
+
 static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
 {
     if (!cpu->vcpu_dirty) {
diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
index 3c1da6a018..6d688c757f 100644
--- a/include/sysemu/cpus.h
+++ b/include/sysemu/cpus.h
@@ -24,6 +24,8 @@ void dump_drift_info(void);
 void qemu_cpu_kick_self(void);
 void qemu_timer_notify_cb(void *opaque, QEMUClockType type);
 
+bool cpu_is_resettable(void);
+
 void cpu_synchronize_all_states(void);
 void cpu_synchronize_all_post_reset(void);
 void cpu_synchronize_all_post_init(void);
diff --git a/include/sysemu/hw_accel.h b/include/sysemu/hw_accel.h
index e128f8b06b..1fddf4f5e1 100644
--- a/include/sysemu/hw_accel.h
+++ b/include/sysemu/hw_accel.h
@@ -17,6 +17,10 @@
 #include "sysemu/hvf.h"
 #include "sysemu/whpx.h"
 
+static inline bool cpu_check_resettable(void)
+{
+    return kvm_enabled() ? kvm_cpu_check_resettable() : true;
+}
 static inline void cpu_synchronize_state(CPUState *cpu)
 {
     if (kvm_enabled()) {
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index f74cfa85ab..eb94bbbff9 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -494,6 +494,8 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
 
 #endif /* NEED_CPU_H */
 
+bool kvm_cpu_check_resettable(void);
+
 void kvm_cpu_synchronize_state(CPUState *cpu);
 void kvm_cpu_synchronize_post_reset(CPUState *cpu);
 void kvm_cpu_synchronize_post_init(CPUState *cpu);
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index a802e899ab..32f286643f 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -927,6 +927,11 @@ void hw_error(const char *fmt, ...)
     abort();
 }
 
+bool cpu_is_resettable(void)
+{
+    return cpu_check_resettable();
+}
+
 void cpu_synchronize_all_states(void)
 {
     CPUState *cpu;
diff --git a/softmmu/vl.c b/softmmu/vl.c
index 4eb9d1f7fd..422fbb1650 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -1475,7 +1475,10 @@ void qemu_system_guest_crashloaded(GuestPanicInformation *info)
 
 void qemu_system_reset_request(ShutdownCause reason)
 {
-    if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
+    if (!cpu_is_resettable()) {
+        error_report("cpus are not resettable, terminating");
+        shutdown_requested = reason;
+    } else if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
         shutdown_requested = reason;
     } else {
         reset_requested = reason;
-- 
2.28.0

