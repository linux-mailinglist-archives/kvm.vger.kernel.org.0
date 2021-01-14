Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EDC2F6ED7
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 00:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbhANXOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 18:14:52 -0500
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:37125
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726512AbhANXOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 18:14:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+E4mAwMlgoIDpMfAu9axNdDQ0aEF26c3BF5isPaYjyamrUipkqQlLUYfevLVf+rggJ+NkRzO6K0xWXM9uf0YwY7t2OSclPmjvFx7GJLNBiicosf3eJn9hNfsmUX1Cu5+/rjHsAifLawOym7UeqxoMGPEsD2Y+y8NRe8tDylCEmv9atmiPMdg7EGslV9tLC6+RjJmM9xoNM7Pr1nC3VdTywVYqKqWaOwoB+GUfeI5koScswdW+2qj966yFf6gX3D51qrMJlLE7gKGUu1wFkmw/xWwe+gCMQ4VTXQiyghKNH4VSyp/4LKAvEK/xiBgWj/9SXyJiYdXhJdoLXuTrIIUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MJM3MwcQCi6+TtCwbqmYr7g5OpsCa+GYvXki6dgeA0=;
 b=gl3q/jItqs7gOPd+aTSx8cxusC4PwQ/1s9gdcT7Zj6XAaINZocQdRsTfT4G147iEjSaEB1wE8ytVksyTKm4JxKdz3T8GAHEqNdjFqWZbhbKhe4D77AT/hd9K/VI41VzRUO8cqXD6Qgq0qT5e3R4xvHCBIQw2sjWAIkM4WBGv+l/e0oNY8m2F8bmRwrXBVz9A0hbANtNCf+/meFK6bYbvbhKsktmUBjsyEdcJ/c/vDjickomlkgRC7nMLQb7qVTdiar5Yz5C8b8GMTS1Hxz38EJala/Q1FwpljTbM8i/CHldaurDwYVkNAgTjtWZe7GanhrGEx8PtrQLhgwfmMppF5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MJM3MwcQCi6+TtCwbqmYr7g5OpsCa+GYvXki6dgeA0=;
 b=FL+I4nqCIadYCCTL2K8KHo8fdlaCTMPmiWXXeDJU1fRiUalfkW6s8tPFXU527LR7/J4lfTSU9cEYBBwKFvSdud+GMn0cZrJo4eC/LZQt4NvPO61itUMuWFJtJbNB5ikKeegF/UKrX1ZttS4SdRfKoLqnN1oGHE8ZmPIMso4/cOU=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2503.namprd12.prod.outlook.com (2603:10b6:4:b2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 23:13:38 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 23:13:37 +0000
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
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 4/6] sev/i386: Don't allow a system reset under an SEV-ES guest
Date:   Thu, 14 Jan 2021 17:12:34 -0600
Message-Id: <c1b45c0f74820dffbc28625c9c44f603f44b76ee.1610665956.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1610665956.git.thomas.lendacky@amd.com>
References: <cover.1610665956.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR01CA0022.prod.exchangelabs.com (2603:10b6:805:b6::35)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR01CA0022.prod.exchangelabs.com (2603:10b6:805:b6::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 23:13:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cae84028-a466-4b93-2f8b-08d8b8e2063b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25032A817425EC563390102BECA80@DM5PR12MB2503.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4e7lTdf+WITIgLcuNpWmY2pKPlgf3+GdiFiQT8BCl0QMb8nZoQKPjpy9cDTIfUM/ccRF+0yWpDbXNG+02yiGEqvUBXM/+3IymkUKfzcI9WoidNVC/8vORNhRAfjDlusMtA4oDb4lSqAMyMGOvTA+ZQXen71D+1jkmfVGD0lmuY87b/uXOaKZV+NkzprDXRvaOYkRNwqzPvm2rcsmzCpfYdvc/kuhg6gwS0ICn2aeorigSnvdAvEZFPPK5LBP4Vpv1SUhpgf4nj8WZxhv9KQa0iUkEiMeuKxYT1DlGSU4vwErDjRxrMpypT0v6s8q1OwWN4WAV7W5ThHmwIRH6xjr2h2prxY2UPoTTVL+zjf148T1zrPD7VcMMTkOAXF47hoyyZET8DNBLrnZAF9do0oApQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(8936002)(54906003)(186003)(6486002)(16526019)(86362001)(7696005)(956004)(66476007)(66556008)(52116002)(316002)(5660300002)(7416002)(2616005)(4326008)(36756003)(26005)(478600001)(83380400001)(2906002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6KToolttX1keJDcG4TF5TU/gl1g316BF3OyLt0gDataIkVfDgxgCmNEZ4Rxr?=
 =?us-ascii?Q?bW0oPuA5JtYBb5TD4AXtBeNPf0DCABz+dQOVZFJHu9SwIVx4zV7Nfw7Pbccr?=
 =?us-ascii?Q?T65BFYnhX1Oif0J67MsQtnwFJTbOECLqoeqSkzx7+PidrQaEARliXq7akyDQ?=
 =?us-ascii?Q?MWCcil+NgMVgqLz7fdvuoDBobLsQA5lQ7eF2WVX9b0B2LdHyYheZmAmqxQ9+?=
 =?us-ascii?Q?XvkU/QBlhJ3BlEHN6feNJIFsX+hN9Z5V0GIBTqAnnlv/84RoYLcyewbcT1Bd?=
 =?us-ascii?Q?uVislIv9hrUBi9kldVAxnGuXMGFjdMsWlf8CTa7v/CNLamKVSEI8XwXIavIc?=
 =?us-ascii?Q?XmZz4/dbxnHHxi5nw4RegGydQk961yjxpdwd/EHQJLOpBSsR9eJjsOJmPXOW?=
 =?us-ascii?Q?tqNLronf9dEid5A+wGxnLwees9mbLDxkUu81UImnN+VfxxxM6nMni2CTSiX0?=
 =?us-ascii?Q?JlvR76YMTR3cXarODglhFW4uzjFym9kbNMECw1xxuw4ROp5pUUfpRqE8BNO4?=
 =?us-ascii?Q?ri9QVdjZj75oPs4aXM8UcdtVS2ttNjeMgIl04gBpvH6sJEGZcaXYVymuBBKa?=
 =?us-ascii?Q?OXKmX9MGbLDVgp/RX1uGsDVidQJ2wIk8o5qh5K5j1RZo96uYIJ2PrGDYDXE2?=
 =?us-ascii?Q?4l842PJXrUNOVSrYzkFV+kJogaFuMIw7adqnq1kerP9mLooVq5+gzGVDUhLb?=
 =?us-ascii?Q?/Gq241TIYeYB+kYb7r/D4dGesA4CmJ0HZCvB566tVAUWDxdk5uamA4qC3Emf?=
 =?us-ascii?Q?XYui4/frDCV6kFALxnzTbqV/8mnqowR/NdSbrkxOJjo08SMPOZZvcf6tpsO0?=
 =?us-ascii?Q?dYXrVM3XLWNZFisqUWQOeaN9Jgh96/iCpsNC85wV0fVbPeySIBElCQlbVEEf?=
 =?us-ascii?Q?GypcKk85YR3q3yuUevsjxDZrk6aZO7v5jLzg+MzQO2+UxoARamy3nqopMRSl?=
 =?us-ascii?Q?ZQgFLoA2EnaYf3+tqEoyh6LnZFID79Xyat8PcS7xDqaC022Rit/ALITITZSL?=
 =?us-ascii?Q?CzAA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 23:13:37.9087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: cae84028-a466-4b93-2f8b-08d8b8e2063b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7mJgV5SXt2IiZwDF5QZb+HfiKC9od8VaY9Z76iKwYzqV7o94gKJwQMOxE1RmIdFhurkJwPB3wiAIKSNyhP5Htg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

An SEV-ES guest does not allow register state to be altered once it has
been measured. When an SEV-ES guest issues a reboot command, Qemu will
reset the vCPU state and resume the guest. This will cause failures under
SEV-ES. Prevent that from occuring by introducing an arch-specific
callback that returns a boolean indicating whether vCPUs are resettable.

Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 accel/kvm/kvm-all.c       |  5 +++++
 include/sysemu/cpus.h     |  2 ++
 include/sysemu/hw_accel.h |  5 +++++
 include/sysemu/kvm.h      | 10 ++++++++++
 softmmu/cpus.c            |  5 +++++
 softmmu/runstate.c        |  7 +++++--
 target/arm/kvm.c          |  5 +++++
 target/i386/kvm/kvm.c     |  6 ++++++
 target/mips/kvm.c         |  5 +++++
 target/ppc/kvm.c          |  5 +++++
 target/s390x/kvm.c        |  5 +++++
 11 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9db74b465e..9ac44ad018 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2411,6 +2411,11 @@ void kvm_flush_coalesced_mmio_buffer(void)
     s->coalesced_flush_in_progress = false;
 }
 
+bool kvm_cpu_check_are_resettable(void)
+{
+    return kvm_arch_cpu_check_are_resettable();
+}
+
 static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
 {
     if (!cpu->vcpu_dirty) {
diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
index e8156728c6..1cb4f9dbeb 100644
--- a/include/sysemu/cpus.h
+++ b/include/sysemu/cpus.h
@@ -57,6 +57,8 @@ extern int icount_align_option;
 /* Unblock cpu */
 void qemu_cpu_kick_self(void);
 
+bool cpus_are_resettable(void);
+
 void cpu_synchronize_all_states(void);
 void cpu_synchronize_all_post_reset(void);
 void cpu_synchronize_all_post_init(void);
diff --git a/include/sysemu/hw_accel.h b/include/sysemu/hw_accel.h
index ffed6192a3..61672f9b32 100644
--- a/include/sysemu/hw_accel.h
+++ b/include/sysemu/hw_accel.h
@@ -22,4 +22,9 @@ void cpu_synchronize_post_reset(CPUState *cpu);
 void cpu_synchronize_post_init(CPUState *cpu);
 void cpu_synchronize_pre_loadvm(CPUState *cpu);
 
+static inline bool cpu_check_are_resettable(void)
+{
+    return kvm_enabled() ? kvm_cpu_check_are_resettable() : true;
+}
+
 #endif /* QEMU_HW_ACCEL_H */
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 875ca101e3..3e265cea3d 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -573,4 +573,14 @@ int kvm_get_max_memslots(void);
 /* Notify resamplefd for EOI of specific interrupts. */
 void kvm_resample_fd_notify(int gsi);
 
+/**
+ * kvm_cpu_check_are_resettable - return whether CPUs can be reset
+ *
+ * Returns: true: CPUs are resettable
+ *          false: CPUs are not resettable
+ */
+bool kvm_cpu_check_are_resettable(void);
+
+bool kvm_arch_cpu_check_are_resettable(void);
+
 #endif
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index 1dc20b9dc3..89de46eae0 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -194,6 +194,11 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu)
     }
 }
 
+bool cpus_are_resettable(void)
+{
+    return cpu_check_are_resettable();
+}
+
 int64_t cpus_get_virtual_clock(void)
 {
     /*
diff --git a/softmmu/runstate.c b/softmmu/runstate.c
index 636aab0add..7b4f212d19 100644
--- a/softmmu/runstate.c
+++ b/softmmu/runstate.c
@@ -523,8 +523,11 @@ void qemu_system_guest_crashloaded(GuestPanicInformation *info)
 
 void qemu_system_reset_request(ShutdownCause reason)
 {
-    if (reboot_action == REBOOT_ACTION_SHUTDOWN &&
-        reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
+    if (!cpus_are_resettable()) {
+        error_report("cpus are not resettable, terminating");
+        shutdown_requested = reason;
+    } else if (reboot_action == REBOOT_ACTION_SHUTDOWN &&
+               reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
         shutdown_requested = reason;
     } else {
         reset_requested = reason;
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ffe186de8d..00e124c812 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1045,3 +1045,8 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
 {
     return (data - 32) & 0xffff;
 }
+
+bool kvm_arch_cpu_check_are_resettable(void)
+{
+    return true;
+}
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index aaae79557d..bb6bfc19de 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -27,6 +27,7 @@
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
+#include "sev_i386.h"
 #include "hyperv.h"
 #include "hyperv-proto.h"
 
@@ -4788,3 +4789,8 @@ bool kvm_has_waitpkg(void)
 {
     return has_msr_umwait;
 }
+
+bool kvm_arch_cpu_check_are_resettable(void)
+{
+    return !sev_es_enabled();
+}
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 477692566a..a907c59c5e 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -1289,3 +1289,8 @@ int mips_kvm_type(MachineState *machine, const char *vm_type)
 
     return -1;
 }
+
+bool kvm_arch_cpu_check_are_resettable(void)
+{
+    return true;
+}
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index daf690a678..f45ed11058 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2947,3 +2947,8 @@ void kvmppc_svm_off(Error **errp)
         error_setg_errno(errp, -rc, "KVM_PPC_SVM_OFF ioctl failed");
     }
 }
+
+bool kvm_arch_cpu_check_are_resettable(void)
+{
+    return true;
+}
diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index b8385e6b95..5c5ba801f1 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -2601,3 +2601,8 @@ void kvm_s390_stop_interrupt(S390CPU *cpu)
 
     kvm_s390_vcpu_interrupt(cpu, &irq);
 }
+
+bool kvm_arch_cpu_check_are_resettable(void)
+{
+    return true;
+}
-- 
2.30.0

