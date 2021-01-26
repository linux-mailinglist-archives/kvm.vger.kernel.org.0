Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E22305CED
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313069AbhAZWjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:39:11 -0500
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:50724
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392888AbhAZRkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:40:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dz57kt7HvC0/Xee9FSbVd+h+RgVOvzPF2dkIT4Q+59GKPeLaQhK5RlRI4LZ38HCSv1MI6O1IFWqbMy/+JnTZIPF3MAUS4xn3l9NIxuJpt4ac2ul1AqKdfzyTfEEDkBLIjC6HY6+AaQ8W/+7q8bJGZEZdTm2xpdyNh5rwoaiYpOsuKoU3k5L6hrPHQaWG5S68PbYIJken+UCvHIn36a9hBDU65C6hqWmcwFdr0aFcYI/JHwBJRmu8ocQ3zkRSXigYt6b21YTEXW+cCSmz0VbSvEvU+oWL6PTZi/gj25ugFPgM9+xHnhKjstM+PCxXkPligKbIoWu9lb4eV2gTbIj1yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNEcWZlWlcJqfGW8c3IYrcWONHME3Ra1aEww8H3njTI=;
 b=ISeqHNw1qrBSSJ1Ab/PS8XHbiWrkG8Q0iOpIGsYrYTDTyKWktK2F3C9Z6LVV4lKxYHHzKy6psV8v377ScWlhRLxYZouQw0/iWBgxX1SH26BG8FZ3fynrLDaHDe2fm45oC3yFvIj1K3awu62gG7U06iAaWZ6AWWkr6FIrML8LAGRsSjqG4A7NLY/TkkocqaRBinMcNJgeEtqIdzPNj+VlL/pSGU7mNgnup4fhHQEGn7tYMoNLjnqECEhK2Pk73i84jldpLfiSUHwCXxxfPBEnnDWEc9gvomQJmPMx1B1x15Qlu5FmOKJ5y7f3T0Y0v8lfWhuAxBkfsxVOX2SiOh0NGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNEcWZlWlcJqfGW8c3IYrcWONHME3Ra1aEww8H3njTI=;
 b=me61X51CpIiGp25+otD9M4a8UullB9EDIB1Ggas/eYDzqmPjiJUXPAV6Ji4Q6tLxh7Eztxwgd5ig9FWb5Xau3JamF9qRmcxxCFRDVI1VZ4+SzWuUUK9ij0I6B5LTMk0cOZVc0rG0mZ3aQT/hxYRF/9oXUOi7rLIFlEkBxH816Hk=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Tue, 26 Jan 2021 17:37:53 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 17:37:53 +0000
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
Subject: [PATCH v6 4/6] sev/i386: Don't allow a system reset under an SEV-ES guest
Date:   Tue, 26 Jan 2021 11:36:47 -0600
Message-Id: <1ac39c441b9a3e970e9556e1cc29d0a0814de6fd.1611682609.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1611682609.git.thomas.lendacky@amd.com>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0001.namprd04.prod.outlook.com
 (2603:10b6:803:21::11) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0401CA0001.namprd04.prod.outlook.com (2603:10b6:803:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 17:37:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9fd6630f-5cb9-43c9-09fe-08d8c2211bda
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB41535FC672FE0EDE28556647ECBC9@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8R5flbpe0h2CYp0FMV4h1nxLugCvl/BxGHX79xRewLdYnjuHTO/jynHolfHiVCHL3GE79/PBa8tB2PpsdeMBw1nES9/Gy0I71KM2qmKzAjIxbmVg30W0fFkIrGMmciAE2vbThDqsRWPfqCISrlNXE36TpGXmHf2MmdB438x4Py7Hudk5/+Cu/HFMkwsqsGJvOJ1COyBaS/WlbM8f34H12RSRFUJgQ8mOqy4dv1QKh5PC3GBKhWmn9g3r9LZas3g0fFiK4r7nRk3NmnFtJdH4fqQvxNiZro6Xif0MuXiIemqdUUGc3j3OJZ/scEM8fzSO32rF5ZLWh2Z52siI/vPLxEHqk5svkpZXXloxkantuyCul9U7aCmue6o7B54+Khtgvp+oSoruFlAZXRu+BiRQuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(8676002)(7696005)(52116002)(478600001)(6666004)(7416002)(4326008)(2906002)(66476007)(316002)(54906003)(5660300002)(26005)(2616005)(956004)(86362001)(83380400001)(36756003)(186003)(16526019)(6486002)(66946007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TM+aGvOM22WA9gAa25tqFKSTpmMCFOrCuqncMKfV7J9pHstQEI3NschchKAG?=
 =?us-ascii?Q?oamRh5/uL6NaMkXoW3xt6bNnd93bdeMj2ACmf9sE9ZV89wa/u/nX37UK1nVH?=
 =?us-ascii?Q?2qH35/QPv1S9/mwYhYMJCI7IbEMMLBLHZhjDRam7fe93KqLLk/ErHDrJnE1U?=
 =?us-ascii?Q?12tXEhYGJ4i42zdbLWEysKWc2BCHBbEXyd9IeLPk0hXWXdwglt8hSJw2MK8H?=
 =?us-ascii?Q?TwawxxH2gVjo4k3+hbyTjKWdEgkpFEHpehQus0HAEeZ9s9IRR5oecQsotRV7?=
 =?us-ascii?Q?LCaOOhSsv0RbMjfaPBIvp6ZLgtRaP3scsOG409tr1LfjN8HlRK9n0hmd0cEF?=
 =?us-ascii?Q?GYNdfhkGw5KhE75t+z7JQSoxfk9nkA5ifq5+keerN39lztVea6CiZZvMcSc8?=
 =?us-ascii?Q?KdYNUFcx20Is30CJIhuRNIuMp8bmsk5XEErPu74wHDqDAPq9YO0lM9J2ct9l?=
 =?us-ascii?Q?BTdmma2r9JkWQX19AWbhrlIIbXKave8InQuyxo8cU+BBzXL/pJX4s6oOUcOe?=
 =?us-ascii?Q?afW6FBjBKVWEzliNjDmU6BCJ25FdYKcXEoK5WHZ0GyzjTBhb+LOLZtUYLrAT?=
 =?us-ascii?Q?Q3PLLtrqt860P7UQYYhJ49uuz8YSJHdb4LnyMhwexdNRpz5uj+19WitEAtBu?=
 =?us-ascii?Q?tV+54gOc0YLkimfo1aHoOlCtluKEFEpWkL2929BL3O48SzK/gBLG7n5JsiWb?=
 =?us-ascii?Q?SWZ1Jlt3hFr0pK5QloA+GUNNn2d1yK8+NGiQOD5BDsjvUfiJBpb8yQ4gg14+?=
 =?us-ascii?Q?ATxndJZjWU/mYaKFdmwS+jPJA8Rwr36WhBtnbA1k1M2NGUA80n5EttG6Q0sR?=
 =?us-ascii?Q?GHA0OXNhoQjflLY40+UryDvhmxVZvhPFyVMvqnJKf++0LUr1/2woMjVJs2ua?=
 =?us-ascii?Q?nPwuFjbhyo3QxI6T12+qDZhmbAxpujffLEai8ecTYhBupbc47yILLL1reHo0?=
 =?us-ascii?Q?eKEnAPP560aPvY5kpA4YVlabqNyasJqIpyM3xuszwSnXzOTV3naFln/Trpl3?=
 =?us-ascii?Q?eC+T9cBirF1kv61MPVwcNpU+7xrmhyR+0z2+BkaYCj196knVFe72vuqvdlwF?=
 =?us-ascii?Q?94ho2fyS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd6630f-5cb9-43c9-09fe-08d8c2211bda
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 17:37:53.1398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zOlvDZfdFACCg9TVPhsFmllXih+RMEDV34exjUNLO4dB9HVZm8RP4X0XCCN0By3ET9Uzqe73eph968ho4S/yQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
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
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 accel/kvm/kvm-all.c       |  5 +++++
 include/sysemu/cpus.h     |  2 ++
 include/sysemu/hw_accel.h |  5 +++++
 include/sysemu/kvm.h      | 10 ++++++++++
 softmmu/cpus.c            |  5 +++++
 softmmu/runstate.c        |  3 +++
 target/arm/kvm.c          |  5 +++++
 target/i386/kvm/kvm.c     |  6 ++++++
 target/mips/kvm.c         |  5 +++++
 target/ppc/kvm.c          |  5 +++++
 target/s390x/kvm.c        |  5 +++++
 11 files changed, 56 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 410879cf94..6c099a3869 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2414,6 +2414,11 @@ void kvm_flush_coalesced_mmio_buffer(void)
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
index beee050815..1813691898 100644
--- a/softmmu/runstate.c
+++ b/softmmu/runstate.c
@@ -527,6 +527,9 @@ void qemu_system_reset_request(ShutdownCause reason)
     if (reboot_action == REBOOT_ACTION_SHUTDOWN &&
         reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
         shutdown_requested = reason;
+    } else if (!cpus_are_resettable()) {
+        error_report("cpus are not resettable, terminating");
+        shutdown_requested = reason;
     } else {
         reset_requested = reason;
     }
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
index 84fb10ea35..123ec1be7e 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -1290,3 +1290,8 @@ int mips_kvm_type(MachineState *machine, const char *vm_type)
 
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
index dc27fa36c9..7a892d663d 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -2599,3 +2599,8 @@ void kvm_s390_stop_interrupt(S390CPU *cpu)
 
     kvm_s390_vcpu_interrupt(cpu, &irq);
 }
+
+bool kvm_arch_cpu_check_are_resettable(void)
+{
+    return true;
+}
-- 
2.30.0

