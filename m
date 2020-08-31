Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF97C257D7C
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 17:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgHaPiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 11:38:03 -0400
Received: from mail-dm6nam08on2043.outbound.protection.outlook.com ([40.107.102.43]:56437
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728535AbgHaPh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 11:37:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lH9seH9Sf+TRE5Q4c5DPo0Y7mNH7xc0CNSmkZiqIWH6n5DAKB1Dn1+l+El1ePeQ1fhoHnJZ+afTI+8oQZOFX+BoQfO1Ot1Td0QvkdamLrp3B6lT89IVgnGtodoJrNhEcSb+f1hiBNTbPD6szbOCkT8FhYPXP5pxVc6GWUrJrU/iLTXuEzMCmtBJffABVwlBnITK7rPmB0XEe+v4QzP21zU0FRbG1qZn71gn9wP7d4Sxb2Ysb9QLwGso3QfkMXcoI+92K0xeMOrmMfVkCxSkeiHAceBtof/v3MySSl2C2MnM1s1j46DtpPCF1mXojlll+T6sMDlUMeJ0PlLe6BPczkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXF8fTPJ/Y9pFcClOLMeQ5tenPBU4qylEmby8f9sbW8=;
 b=miim6xnQ0HxXovoXKDEnp8qKCeTQLweQStUxWSIWWEeIlNgI1HSjk2zHI06KMxOHGvMRsu/pOa6vWwApRGYHr8bsTxCQ8aEw9p3AXhNO9kpoU7zdfyoMmhejbl8TuZdMls+TyC+80LFBwxtwOvh9c3DiEajfDXx87tyn9SVXdWMy+dda8mhkiGEx1ZNSZUJmoFxQ90puTjPM+8VpJpa6DKgz3P/PH7mJWkD8MfRKb2wdbIqPD0olaoh7gYSbYvRw2T5YPaFd22nXyiDCGh6T9ZfDA1rkKAf0Li+m/nrYoQ4ZqRteFx7oXSvJNLsSRqvI18KLnMRTp6H6nPkykjwtCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXF8fTPJ/Y9pFcClOLMeQ5tenPBU4qylEmby8f9sbW8=;
 b=yOO8cZc9TY6omObVz30baBinFtakqBehZ9mNtBR/ZHMClametkwj3sI9Q4kbJawIbofntS9VR37E6l7Gp9oELdMXYFKSfYK5GYb8cFsOqROacvqulY0HMMZgJwOmhR4zYgpaJVWtwzQZjp32k7eG4rw8frNYdCbLcNF2jenizAs=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19; Mon, 31 Aug 2020 15:37:53 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 15:37:53 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 3/4] sev/i386: Don't allow a system reset under an SEV-ES guest
Date:   Mon, 31 Aug 2020 10:37:12 -0500
Message-Id: <42e7c4c3b410731b191d5328a19a790255818a00.1598888232.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1598888232.git.thomas.lendacky@amd.com>
References: <cover.1598888232.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0029.namprd04.prod.outlook.com
 (2603:10b6:803:2a::15) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN4PR0401CA0029.namprd04.prod.outlook.com (2603:10b6:803:2a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 15:37:52 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bda848df-9c59-4aad-9924-08d84dc3d363
X-MS-TrafficTypeDiagnostic: DM6PR12MB4484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4484F5DC1A2E6617C4860931EC510@DM6PR12MB4484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:418;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b3feol6n2Z8j7UvXAkSvWFCXemD1fBIk0VWZDLE7/srLZ3s/x4JzkwClM6fNsLf/VVhlXyDV3E+XbGn/PZjK5caCnSvGfFEAxvEB+lX1etkNvT5HMHvKTTZdMOhh4QO+12JgmheanKgcR9ki5sW9xrDVwtSq9WRlFNIuYE53iYjFRcOJ84zoHcLUP4HagaycN4FrEjQ1Fne6fPfkXXHgaaHu1W+1ArwHTG8YfP2Wc1mgYXG/7e6aEyFKuSiiBGEOIeQ1JkVX2/zA/qTIdYm7N1/y5j7EyroDvFM4gb68yiVNTYGJoHerE4GoMyCiXYx+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(54906003)(956004)(16576012)(7416002)(2906002)(6666004)(4326008)(2616005)(6486002)(316002)(66556008)(8676002)(66946007)(478600001)(186003)(5660300002)(8936002)(86362001)(83380400001)(66476007)(36756003)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cnsTIa8m9YMXqbyF0uIw7Ao+nfksQqqZcgYkm8YI1/Sk8stejtIFEvjgkaCsZBEUsF/NnCXhGbYNgH7Bu4omvss/JgF6eGsXnUmuNNhJEO8k1KHmNOgDAl/hB3FIAIn4gPVvdY1pvqImylq2Kpk9JbJ24XdOWMlsXDM0ZWxn49V69qAfKYw4LQZSG6b06pfUpdbaOiBq8UIZH0BJB+4QbUjh0mMBuE6TN5SJy+Pp+BT3K+0reJ0Dfw0vIRaRYYRCfVF6mXJcCRFDz4D9yncCnxZqY/g8gR255oNqNR+x6mEUcED3krm8Ym5gaXht9wTvUW+AWW6lWhGHNv1dD67/hhn/YQIU1urWx2LPafPNk2wtYayENOAYNBrSUm87wuRBWqbMMKmD+FYnrNhZAvsywepgbCJaSkmTCTIaFgMcIe/yipiZJD6QsnUJHsKJAPYlZUtVaG5Vg64+0N63CqYPgDYpoCaM3fqi8oQKh6AdjkTviRRDWV73e9U5NVFKfrhRgirsLE+8HiMfMRrXuHr3g9k+AW6wb+JJMzQ0ljpSb4UgLMxHiL8tRI2uCEMZpvaUjyNilKi/FuhsxawzvmS1I2Bm7Xwp9quUXsh9/3k7YbZWTjHw81km56T8jKgJvXkIfIhgMlV823vJKx7R01IMBg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bda848df-9c59-4aad-9924-08d84dc3d363
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 15:37:53.6325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f2hrWQQNTRrT167uAXf0q1g15rF2IYLOv/BZiat0rvfI++hW4QA7UAJLRW7GxYW6Kw3EKH3jtTxH4rD1t58Adw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
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
 accel/kvm/kvm-all.c       | 9 +++++++++
 include/sysemu/cpus.h     | 2 ++
 include/sysemu/hw_accel.h | 5 +++++
 include/sysemu/kvm.h      | 2 ++
 softmmu/cpus.c            | 5 +++++
 softmmu/vl.c              | 5 ++++-
 6 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 20725b0368..63153b6e53 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2388,6 +2388,15 @@ void kvm_flush_coalesced_mmio_buffer(void)
     s->coalesced_flush_in_progress = false;
 }
 
+bool kvm_cpu_check_resettable(void)
+{
+    /*
+     * If we have a valid reset vector override, then SEV-ES is active
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
index e128f8b06b..8b4536e7ae 100644
--- a/include/sysemu/hw_accel.h
+++ b/include/sysemu/hw_accel.h
@@ -17,6 +17,11 @@
 #include "sysemu/hvf.h"
 #include "sysemu/whpx.h"
 
+static inline bool cpu_check_resettable(void)
+{
+    return kvm_enabled() ? kvm_cpu_check_resettable() : true;
+}
+
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

