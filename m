Return-Path: <kvm+bounces-18417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B388D4A4A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CB5E1C22204
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2079917082A;
	Thu, 30 May 2024 11:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CBuaH5B4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78C517554D
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067831; cv=fail; b=mQJfV4/JUHg/e8qkVDaM+GvU621hNTrpoKu2RopTdNLLf8UGHtpgCmp8+rot4aCF55iwbS3yAi/e4OgQDsE93RLMdekqUhQsK2UxCz+C4dyraJFM/id1SfL/iFiui3aKkXr82lJtENw/kkByNwLKDe34wgTVEnYQRfK8KP0Vps0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067831; c=relaxed/simple;
	bh=xKeW3WheIczmbA8L7KB+G8X6B72bOW/nB5BhmZUY+20=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VbB7l2uOkQ9D9guy4ply7ki4MOnd9uPcORDVmkdrzOhffjfi4x5LHhCJffGoa9iYPIJohsfEbaQyxvyoukvuFqtyeamzoLdGfJojvqXMyaYH2mDKMNQuCa0DLerO4ebBd+W9JB/QtLJWpZPJ8A0Ag+asuTgoLkeaeo2lpao0NcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CBuaH5B4; arc=fail smtp.client-ip=40.107.100.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sh6ba1V2ZPjnzm4iOoWU86Ha6rG/ckrmF9Yls9vagDv5tFeTuMtcWU8kaSaufFbHiXzmotcmWCO6L3gFN0myccnxjbTIjMR8E/qRMmTaRjNthhdDqXNYBZjLD5qU1CwUGLqbopWdYa3nTIiRzLAFNAnjxIXcXWoc/ZuB24RdyQlpyaOnBM5ns/WdKrC490/nflEQatLzKvmA9JxjvHcrz67pCFSWxMS7MPDFb0XY3XjevhawKw8LgqnsIxcZMksHiM04raHWMeqWq8UIcwx/TYsbMC8x26csjY8cHJWumLNYywk688DxsFc8Ishow046P4YZ2gwZCljrCRWf+5Hnpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LIsthe0rC5up4jHnC6jnkP/A/JdTMz+A6gWSUy2I91Y=;
 b=IfjQRDC6Fcedfj7in0/HYq35wDvhVNyivZFCtqnCic8+cHg7Tcmhihb1fCinKPsseaF9+jtA/6yZoYO6+h9T5E1qeBgROaaTFU172NR951Xyrx+ssJ6EdJ6VxB8x3Il1dzPATfIrnIBMxdBc70ZFzZeafR/eNMdriTvlSX/iuzDie+VrVXWwbQjjanoURC6drS2B8iO1FedcUbFuUdRFAhuB228qk07OCKt9n/FiwbtI9Nd55DfZvEwpDsfys3Zbolhjt8fWAhBhwNytHaFdnzp/rPkjfRJho+vjv3JCg7u4rsiv31JF68a6eZ1LtxF1oYNMtSFUA1SIuG0lhA3rXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIsthe0rC5up4jHnC6jnkP/A/JdTMz+A6gWSUy2I91Y=;
 b=CBuaH5B4Xx9V1Kjs5DaWGrXw4mPVHTf1ht/A5DkaOsibNIIr7U/oi3eUO0m88phYwe8zKNhySHANUp/78TITIlFjYfClLyPgUfJg9Ao4QQW4ryTTnkyaoAkyNLD0D25heDrv+MsotQHlY3cYCZRExiihds46wuAR7XyTEKa1AKI=
Received: from BN9PR03CA0769.namprd03.prod.outlook.com (2603:10b6:408:13a::24)
 by DS0PR12MB9398.namprd12.prod.outlook.com (2603:10b6:8:1b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 11:17:07 +0000
Received: from BN2PEPF00004FBF.namprd04.prod.outlook.com
 (2603:10b6:408:13a:cafe::4b) by BN9PR03CA0769.outlook.office365.com
 (2603:10b6:408:13a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Thu, 30 May 2024 11:17:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBF.mail.protection.outlook.com (10.167.243.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:17:06 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:17:03 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:17:03 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:17:02 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 30/31] i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE
Date: Thu, 30 May 2024 06:16:42 -0500
Message-ID: <20240530111643.1091816-31-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBF:EE_|DS0PR12MB9398:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fa55a3d-efc9-4c55-0e28-08dc809a0a85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Si8sqX7l5nWtyICaPIjERU7VT5+2U6SSoCnS0UWCo8qXhWtnzVm9v5neIUs?=
 =?us-ascii?Q?s8mShuQuNfQTyHH2Gb7JGuNU09CEvs67fbmli/nnGwztuHjdpSCAPbKUcbBJ?=
 =?us-ascii?Q?XP+66OrfIRiU0h4tTx20HAEJHG3GZLxmh+L09nX6Bbj2moVzrQGOOLJysi3h?=
 =?us-ascii?Q?OHsZJj+3NNC+kkD7sasnARV6IFObXrl7vhZttYLRaVwG5sh4icHGZ2ONh5i/?=
 =?us-ascii?Q?K9C2N4I+akkgY33FyxPqdHUTmpRSXEAqL5BipSxW6rm72zQ2d+82Uj9XDEzL?=
 =?us-ascii?Q?MzyArRwJ4+GasUVWP7EyHZ97ZZ7O1nomUqb4VGHu06Y1+qOZPCR3hSavpmhM?=
 =?us-ascii?Q?/vIRsVn3q9gnHRa3+yF4S4zgIn7jHqVeT+NROQ8WzghvOc8tcIq2owjT2Mih?=
 =?us-ascii?Q?Vo3hk0uKDMBL87Fkuii7XdwadLhHFruCvdNZQWkusWHInVqsoNYffheizkOv?=
 =?us-ascii?Q?ic5IU/hNoYkyWg1MtXcayowwofqzJwGgrcfv6MNwRrC8z+E9I/X+5rqCkXy7?=
 =?us-ascii?Q?3eJAGvWgYXmacAD/E/owe6OKHtCqAF42mMyyc7aW98C1FyuOl+CdB7kNJn+p?=
 =?us-ascii?Q?cI9VKmxFPft2FQJNRJYSZat3wZJJN2vMPXaBL9gt2Jscy1ItsWHkSV3O6cFz?=
 =?us-ascii?Q?qqE0+UipPSaUtznOX//NtikQiSXVjKg6OfMagdhxNpCM+eG7s714v67SCTZK?=
 =?us-ascii?Q?Q1wKvE1+tF0pzQWcZElgc3t9N61PL+eCzqcuw3nJxK8n/F3dyFE4DSMqZ6+a?=
 =?us-ascii?Q?0R+lDiodyIviYUMBsMvIOwwXT05r8NwuD6b0Z5n+1XYm691sq5/ESD2RN4t6?=
 =?us-ascii?Q?M7A/y74fzSd+Ua77+3eebA21arBU7BTcmn7XnowVlvElICZ3ou3WVCxj7LqB?=
 =?us-ascii?Q?i73He4+ynK3xs+ITTe9GEjwdG2tqPV8ipUldnqCwvgyh9+7KWxQ4in7FJU3S?=
 =?us-ascii?Q?a7XVwLrW5L2TQiRVENyurn1UT8Rf1DWNeMWHFGTIMuL0Qy+90cRG1ILlTuX3?=
 =?us-ascii?Q?ytp7erUzJpl87wNGxBceWPLSWWvtCafUiL42tD2sw0Zozgutp3dC0Yna5FgA?=
 =?us-ascii?Q?D9pqQIWuehXRIcxpWDfceoRImCAdcce2dkxJg26P12WcEl10kpjZH1Da5XFg?=
 =?us-ascii?Q?9I1FevrB47W5KO2/MRYjGSeBwYzI+5d8TXqKFZyLRUq0T62JLYg6V/eLNUor?=
 =?us-ascii?Q?4tdgw1e8lwrcfi0TSgPxQSMR2ACtG2CFeyCnL7VLZ6TU7LahY/ztS2VgmZZ+?=
 =?us-ascii?Q?HLiwkqtLX0QhR7x3yLzyNn9xLWc5m+jrMqpHcusCocjlZD1WtHWvI4XHE5Og?=
 =?us-ascii?Q?qDu8n8h6mfKyrgAJZl9oPFyaBKWkxudImZVgwyZTTS+yqvjJvd0XUqdODkLv?=
 =?us-ascii?Q?dXTbnFSgZzvVeHyerUoCFOSypxzV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:17:06.9110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa55a3d-efc9-4c55-0e28-08dc809a0a85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9398

From: Michael Roth <michael.roth@amd.com>

KVM_HC_MAP_GPA_RANGE will be used to send requests to userspace for
private/shared memory attribute updates requested by the guest.
Implement handling for that use-case along with some basic
infrastructure for enabling specific hypercall events.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/kvm/kvm.c        | 55 ++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h   |  1 +
 target/i386/kvm/trace-events |  1 +
 3 files changed, 57 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c864e4611..e72c295f77 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -21,6 +21,7 @@
 #include <sys/syscall.h>
 
 #include <linux/kvm.h>
+#include <linux/kvm_para.h>
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "hw/xen/interface/arch-x86/cpuid.h"
 
@@ -208,6 +209,13 @@ int kvm_get_vm_type(MachineState *ms)
     return kvm_type;
 }
 
+bool kvm_enable_hypercall(uint64_t enable_mask)
+{
+    KVMState *s = KVM_STATE(current_accel());
+
+    return !kvm_vm_enable_cap(s, KVM_CAP_EXIT_HYPERCALL, 0, enable_mask);
+}
+
 bool kvm_has_smm(void)
 {
     return kvm_vm_check_extension(kvm_state, KVM_CAP_X86_SMM);
@@ -5321,6 +5329,50 @@ static bool host_supports_vmx(void)
     return ecx & CPUID_EXT_VMX;
 }
 
+/*
+ * Currently the handling here only supports use of KVM_HC_MAP_GPA_RANGE
+ * to service guest-initiated memory attribute update requests so that
+ * KVM_SET_MEMORY_ATTRIBUTES can update whether or not a page should be
+ * backed by the private memory pool provided by guest_memfd, and as such
+ * is only applicable to guest_memfd-backed guests (e.g. SNP/TDX).
+ *
+ * Other other use-cases for KVM_HC_MAP_GPA_RANGE, such as for SEV live
+ * migration, are not implemented here currently.
+ *
+ * For the guest_memfd use-case, these exits will generally be synthesized
+ * by KVM based on platform-specific hypercalls, like GHCB requests in the
+ * case of SEV-SNP, and not issued directly within the guest though the
+ * KVM_HC_MAP_GPA_RANGE hypercall. So in this case, KVM_HC_MAP_GPA_RANGE is
+ * not actually advertised to guests via the KVM CPUID feature bit, as
+ * opposed to SEV live migration where it would be. Since it is unlikely the
+ * SEV live migration use-case would be useful for guest-memfd backed guests,
+ * because private/shared page tracking is already provided through other
+ * means, these 2 use-cases should be treated as being mutually-exclusive.
+ */
+static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
+{
+    uint64_t gpa, size, attributes;
+
+    if (!machine_require_guest_memfd(current_machine))
+        return -EINVAL;
+
+    gpa = run->hypercall.args[0];
+    size = run->hypercall.args[1] * TARGET_PAGE_SIZE;
+    attributes = run->hypercall.args[2];
+
+    trace_kvm_hc_map_gpa_range(gpa, size, attributes, run->hypercall.flags);
+
+    return kvm_convert_memory(gpa, size, attributes & KVM_MAP_GPA_RANGE_ENCRYPTED);
+}
+
+static int kvm_handle_hypercall(struct kvm_run *run)
+{
+    if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
+        return kvm_handle_hc_map_gpa_range(run);
+
+    return -EINVAL;
+}
+
 #define VMX_INVALID_GUEST_STATE 0x80000021
 
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
@@ -5416,6 +5468,9 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         ret = kvm_xen_handle_exit(cpu, &run->xen);
         break;
 #endif
+    case KVM_EXIT_HYPERCALL:
+        ret = kvm_handle_hypercall(run);
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 6b44844d95..34fc60774b 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -33,6 +33,7 @@
 bool kvm_has_smm(void);
 bool kvm_enable_x2apic(void);
 bool kvm_hv_vpindex_settable(void);
+bool kvm_enable_hypercall(uint64_t enable_mask);
 
 bool kvm_enable_sgx_provisioning(KVMState *s);
 bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
diff --git a/target/i386/kvm/trace-events b/target/i386/kvm/trace-events
index b365a8e8e2..74a6234ff7 100644
--- a/target/i386/kvm/trace-events
+++ b/target/i386/kvm/trace-events
@@ -5,6 +5,7 @@ kvm_x86_fixup_msi_error(uint32_t gsi) "VT-d failed to remap interrupt for GSI %"
 kvm_x86_add_msi_route(int virq) "Adding route entry for virq %d"
 kvm_x86_remove_msi_route(int virq) "Removing route entry for virq %d"
 kvm_x86_update_msi_routes(int num) "Updated %d MSI routes"
+kvm_hc_map_gpa_range(uint64_t gpa, uint64_t size, uint64_t attributes, uint64_t flags) "gpa 0x%" PRIx64 " size 0x%" PRIx64 " attributes 0x%" PRIx64 " flags 0x%" PRIx64
 
 # xen-emu.c
 kvm_xen_hypercall(int cpu, uint8_t cpl, uint64_t input, uint64_t a0, uint64_t a1, uint64_t a2, uint64_t ret) "xen_hypercall: cpu %d cpl %d input %" PRIu64 " a0 0x%" PRIx64 " a1 0x%" PRIx64 " a2 0x%" PRIx64" ret 0x%" PRIx64
-- 
2.34.1


