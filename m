Return-Path: <kvm+bounces-21259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D7B92C9B5
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 06:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 399281C248FC
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 04:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8224053804;
	Wed, 10 Jul 2024 04:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XCwWl7iE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB8015D1
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 04:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720584663; cv=fail; b=GYCDoNuhN+GDiRQY4dZHMazKTqdVpxJGOGI0VFGQXiI4vWPIghtFL7oc68lpNav+cz2aSdk49fkW3FkIV0dqgpqlRmkQ5DwwN2fF6/PQf/sucVBxQsA6Dne3K1AIC5ouHvnMx5NZxQ66jrZw7Ba2sjNeOuWS+lYpRJCwQxrEA2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720584663; c=relaxed/simple;
	bh=9g0EGcxglZWvf5bfKJ6wQ7nJvIk6ZmznzTYDlpOtDck=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SlsXq1KEeLoMRGZfM8BUWblwnhedtxyGfnoYKr2Kzlh6y8u/9QxC3RDCzcKrFstYdvDW2nHNid+EgvNADcUrKUokHuIoyKbG8BjG0UgrGizBDw4gC5M9jqWzgClIF/aPOLD4KTb8QVlLXHn+7GLOd5v77gdXVVNnisYdA8I3st8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XCwWl7iE; arc=fail smtp.client-ip=40.107.92.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPIJXUOneTbqy5O22gl4eFCjHCHyw1bgY6GRJ8wjj6Dsn4awomL8YR1HxNZm/BPLbxqia9JH8A5+0MaKyHfMcachPiZr3wLstcx0RFd6obW/ajlUMlu/xB9kd4/p3CPfunCmdZjC6zJJIiH81PbUbDiWPCbs3AD8bNGvVx9NZnk9VINc/Q7aRUbYk7TfKnH+nf/YqShRUX0auWnUrXXH1kcZKgaTBAYKWIGVWPt68B6JIBJ4XgpUN3RT4YPmK3689Oo62YHjkvwZyUQQh+J7ePs0w19EDW13+7rxcA1EjaoRAEN0zVc4KnXJTCNU8yFXORMeudNiP6yhd9xcSaBLEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Bdn7g7IpiRWOFaRzYee/tGLlCexvB+mIUDU/0bF/i4=;
 b=F3G7JLsHbWdn8nRgaA07/EzGvBjgMqb8M0VJY/pxzMKzQdp+CZ/r3oBgpDuokzHz435DLiVmgVKrWyRyPsOHhJfHyf0vRVfhM0Ik6yLBhYRDLj3I3aHq7EYicIWY7m/JPsoxX0pjBEDuuVFxnA6+wZo7reBzXdn3STOMIsPtAj/OmK3INqxYE2SbKrFTUsL6MQOog1QT7aNCuWFtWQ/gj7VlcNReSwrnlWRgkwl8VFdaVfmualsfYNwEvgMIx/G4NbmQ5jNlWjevQNnmj/2aNHub/KEfL+xYOwcjBCRL0J3zgU/VOrxz4PU49mjRWudoN9dWNz6gzWSDzH/lUG4QkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Bdn7g7IpiRWOFaRzYee/tGLlCexvB+mIUDU/0bF/i4=;
 b=XCwWl7iEN9kOnxSOAH6yxHXT4lDNuxyJi5JPhYGPuIHfZ28EbOgoJ8daUiLdaEXm4syIbLoXvO2+YLZy3/tbl+cww65/Hy/jbTzvt3xPMV0tWQUs1eOm08bojZXetQqzPD3CLeIQaVu0GC8DeLzYFTzHSGnRHMNM+x1EOZD0TQQ=
Received: from BY3PR05CA0053.namprd05.prod.outlook.com (2603:10b6:a03:39b::28)
 by IA1PR12MB7613.namprd12.prod.outlook.com (2603:10b6:208:42a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.38; Wed, 10 Jul
 2024 04:10:58 +0000
Received: from SJ1PEPF00002313.namprd03.prod.outlook.com
 (2603:10b6:a03:39b:cafe::56) by BY3PR05CA0053.outlook.office365.com
 (2603:10b6:a03:39b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.18 via Frontend
 Transport; Wed, 10 Jul 2024 04:10:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002313.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.17 via Frontend Transport; Wed, 10 Jul 2024 04:10:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 9 Jul
 2024 23:10:55 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Paolo
 Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>
Subject: [PATCH v2] i386/sev: Don't allow automatic fallback to legacy KVM_SEV*_INIT
Date: Tue, 9 Jul 2024 23:10:05 -0500
Message-ID: <20240710041005.83720-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002313:EE_|IA1PR12MB7613:EE_
X-MS-Office365-Filtering-Correlation-Id: 38afa45a-50a9-4c76-312b-08dca0964cf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDBjYlo3S1pvalRXdEtTazRRd2N3VUFBTjVVdFJ1d2xXZjRTRkdvODE5SlV0?=
 =?utf-8?B?NlRRN2RFeWNvbzZWa3ZZVzNjZkhTbmR3MEhLRW1XOFRYNWJIUGc2dXczbndy?=
 =?utf-8?B?emI4UEJUS2JVQnlOSWVaUnZnS2hodVBxaVg2eDZ3WjRWWDJUcm1qeVJHYzFl?=
 =?utf-8?B?d2tCMVRlVkh6RDhBa2Evdk9yTG1yUnpjWkFpR2FhYUZtOGgwaWRkMHNCRFJU?=
 =?utf-8?B?MHpzaEJCc3R1MFlaeFpXZVpPZ0hDUTl1NUFKWEVXWXVaSmJSeVBCYVB1eW95?=
 =?utf-8?B?R3dxT0E1SEtsL1UrMGpFaHFXNmRKSW5keURrZ3pPb09IODB4M0xhemt1bjRJ?=
 =?utf-8?B?a3VzQWd3aklMdkpibVR3TzFrZVRja0V0ZnZzd2xrZ3M2T2pzYWdudXcxdDlk?=
 =?utf-8?B?ZjUvTlNwNzJiUWphT1k2QUtqOTkveWpHb1A1Mko1TWlpaVlEQ2NNM25VTTV4?=
 =?utf-8?B?ekt5VWF1RFV5T3FPZEJHWHpZdDNHR0VzOFJYNG5xZG1XY1dWTDUvSml5RkZN?=
 =?utf-8?B?UFFtcFl0YWp2SHRJNU5MY2d5WVFTZVpSckxNU1hWYW1WNHZFdVhDa290amtF?=
 =?utf-8?B?OThmdG45dEdnbGQ3M2piNjRGQ1g0Snd1SWpVU2ZCUzlML2pmdzBUbVExU2Rs?=
 =?utf-8?B?RHlTbTFJbE1yTVFGbFpOTVNVYlM3dW1XMG81c2dQNU1KK1FrbUU3N2pUWm1R?=
 =?utf-8?B?MDVDaG9lcCt4aytsRnltTDhQQnFRQzFWL3R6cHdBbDZJNVlRa2NHek5CVkkz?=
 =?utf-8?B?c3RENktWR3RSeHhrYy9DWTVIOFdpa3l2MHNKMlY4UE5uQzNybGx2bHlzdCtM?=
 =?utf-8?B?WTluOEpyUWE3WUhUYjlrSi9BMXdZWGduN1RnZ1Nqakp5TXlhWjNiRVU0Znlw?=
 =?utf-8?B?ZzJGZThqbXI2cnNvUlpVV2RPVUdxQUYrc1NVTjRBYlM0NmUwMVNMdml1VkdP?=
 =?utf-8?B?Q0JkMk5JVTNRbFlFdjRRNU9QalRyOU5lZlg1cUVUaG9LVUs4S3lybS8xbzJI?=
 =?utf-8?B?SnRwMS95Zm1DSnNqQTA0NUxUZ242angzVHd6RkszK2FrTGE2QVJ5YmFBVWp6?=
 =?utf-8?B?VytHRXAwVzJzK0pxMk5wSkd2LzdoUG8wdkc5eVBZTjRpMjN5bXZESkNGTi96?=
 =?utf-8?B?U21sR2RHSGVDeUdDbEFqVnFwaEhzVmJiTWtwZGd5UkJQOGEweUsrdUUxb21z?=
 =?utf-8?B?WURGOWxPTmlKcXZwL0V6YWtIOU9UdG1hRElJNGxCTUNVK3hGSmFDVHFGUTlC?=
 =?utf-8?B?eGUvRFltaTlYL2dubUFhbktPSVNWWkxEeDE4NS9oNnB1RGJIUjg3VGFqSHlN?=
 =?utf-8?B?bVg0Q1ZzcFlCa242dFZMeWRFTVJyMldrNGdVdkt1MVFiTW1Qa1hrVVJKcXdE?=
 =?utf-8?B?SDFUVTh4RXIzalVaelhkNEh0NHc2bkowbDc0dE96VnhFaWtNdlFsL1o4dkdk?=
 =?utf-8?B?MUhURk4wOERoYkZqTzZVbTM1cnFRcExnZ1BnVHNqT1lueXp3NXQ0RGJYdU9V?=
 =?utf-8?B?VHVDdytxcklSYnZuRUtqU2NkWmUxekNoZnM0MmJwN0hOU1FzMFFtQUdBNHY0?=
 =?utf-8?B?SW52QTJEcEZFSWdCd2tCckFXQlZQMDdmamtuZXJVZ3M4UzFiVkVqRFNqU2FS?=
 =?utf-8?B?dmtjOCs5S0VZQlhiZUJWQUpDNDV2dWtkTkRhWXpZalRyajBpeS9taHpTVDda?=
 =?utf-8?B?dk5Kbm5FZ2xFbFBLdGo5ZC9sQWNjbXJMVmNzc283cmlkakZBMDQxZXhpVEhD?=
 =?utf-8?B?aE5VYVVUeStXRFBZT0dhYXlWaEx1b2JlWUo0VGZYVTMrSzhSbS9DTlJXLzFF?=
 =?utf-8?B?SEpOVkEvV3EwWDVXMVI5NFMyYTVpMkRsL0JzOUdxMlJGQ3diV1djSWhVczNp?=
 =?utf-8?B?SnU2aGhWSHNDc3RuWTUzUVlZcUpDZk1RTGUzU3Y2ZEduSkhqYVRwRzJoVU9V?=
 =?utf-8?Q?5eGfPii9PnwtTUeJptEmYGXmqAbBWVLF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 04:10:57.3359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38afa45a-50a9-4c76-312b-08dca0964cf8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002313.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7613

Currently if the 'legacy-vm-type' property of the sev-guest object is
'on', QEMU will attempt to use the newer KVM_SEV_INIT2 kernel
interface in conjunction with the newer KVM_X86_SEV_VM and
KVM_X86_SEV_ES_VM KVM VM types.

This can lead to measurement changes if, for instance, an SEV guest was
created on a host that originally had an older kernel that didn't
support KVM_SEV_INIT2, but is booted on the same host later on after the
host kernel was upgraded.

Instead, if legacy-vm-type is 'off', QEMU should fail if the
KVM_SEV_INIT2 interface is not provided by the current host kernel.
Modify the fallback handling accordingly.

In the future, VMSA features and other flags might be added to QEMU
which will require legacy-vm-type to be 'off' because they will rely
on the newer KVM_SEV_INIT2 interface. It may be difficult to convey to
users what values of legacy-vm-type are compatible with which
features/options, so as part of this rework, switch legacy-vm-type to a
tri-state OnOffAuto option. 'auto' in this case will automatically
switch to using the newer KVM_SEV_INIT2, but only if it is required to
make use of new VMSA features or other options only available via
KVM_SEV_INIT2.

Defining 'auto' in this way would avoid inadvertantly breaking
compatibility with older kernels since it would only be used in cases
where users opt into newer features that are only available via
KVM_SEV_INIT2 and newer kernels, and provide better default behavior
than the legacy-vm-type=off behavior that was previously in place, so
make it the default for 9.1+ machine types.

Cc: Daniel P. Berrangé <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
cc: kvm@vger.kernel.org
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
v2:
  - switch to OnOffAuto for legacy-vm-type 'property'
  - make 'auto' the default for 9.1+, which will automatically use
    KVM_SEV_INIT2 when strictly required by a particular set of options,
    but will otherwise keep using the legacy interface.

 hw/i386/pc.c      |  2 +-
 qapi/qom.json     | 18 ++++++----
 target/i386/sev.c | 85 +++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 83 insertions(+), 22 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 4fbc577470..c74931d577 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -83,7 +83,7 @@ GlobalProperty pc_compat_9_0[] = {
     { TYPE_X86_CPU, "x-amd-topoext-features-only", "false" },
     { TYPE_X86_CPU, "x-l1-cache-per-thread", "false" },
     { TYPE_X86_CPU, "guest-phys-bits", "0" },
-    { "sev-guest", "legacy-vm-type", "true" },
+    { "sev-guest", "legacy-vm-type", "on" },
     { TYPE_X86_CPU, "legacy-multi-node", "on" },
 };
 const size_t pc_compat_9_0_len = G_N_ELEMENTS(pc_compat_9_0);
diff --git a/qapi/qom.json b/qapi/qom.json
index 8e75a419c3..7eccd2e14e 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -924,12 +924,16 @@
 # @handle: SEV firmware handle (default: 0)
 #
 # @legacy-vm-type: Use legacy KVM_SEV_INIT KVM interface for creating the VM.
-#                  The newer KVM_SEV_INIT2 interface syncs additional vCPU
-#                  state when initializing the VMSA structures, which will
-#                  result in a different guest measurement. Set this to
-#                  maintain compatibility with older QEMU or kernel versions
-#                  that rely on legacy KVM_SEV_INIT behavior.
-#                  (default: false) (since 9.1)
+#                  The newer KVM_SEV_INIT2 interface, from Linux >= 6.10, syncs
+#                  additional vCPU state when initializing the VMSA structures,
+#                  which will result in a different guest measurement. Set
+#                  this to 'on' to force compatibility with older QEMU or kernel
+#                  versions that rely on legacy KVM_SEV_INIT behavior. 'auto'
+#                  will behave identically to 'on', but will automatically
+#                  switch to using KVM_SEV_INIT2 if the user specifies any
+#                  additional options that require it. If set to 'off', QEMU
+#                  will require KVM_SEV_INIT2 unconditionally.
+#                  (default: off) (since 9.1)
 #
 # Since: 2.12
 ##
@@ -939,7 +943,7 @@
             '*session-file': 'str',
             '*policy': 'uint32',
             '*handle': 'uint32',
-            '*legacy-vm-type': 'bool' } }
+            '*legacy-vm-type': 'OnOffAuto' } }
 
 ##
 # @SevSnpGuestProperties:
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 2ba5f51722..a1157c0ede 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -144,7 +144,7 @@ struct SevGuestState {
     uint32_t policy;
     char *dh_cert_file;
     char *session_file;
-    bool legacy_vm_type;
+    OnOffAuto legacy_vm_type;
 };
 
 struct SevSnpGuestState {
@@ -1369,6 +1369,17 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
     }
 }
 
+/*
+ * This helper is to examine sev-guest properties and determine if any options
+ * have been set which rely on the newer KVM_SEV_INIT2 interface and associated
+ * KVM VM types.
+ */
+static bool sev_init2_required(SevGuestState *sev_guest)
+{
+    /* Currently no KVM_SEV_INIT2-specific options are exposed via QEMU */
+    return false;
+}
+
 static int sev_kvm_type(X86ConfidentialGuest *cg)
 {
     SevCommonState *sev_common = SEV_COMMON(cg);
@@ -1379,14 +1390,39 @@ static int sev_kvm_type(X86ConfidentialGuest *cg)
         goto out;
     }
 
+    /* These are the only cases where legacy VM types can be used. */
+    if (sev_guest->legacy_vm_type == ON_OFF_AUTO_ON ||
+        (sev_guest->legacy_vm_type == ON_OFF_AUTO_AUTO &&
+         !sev_init2_required(sev_guest))) {
+        sev_common->kvm_type = KVM_X86_DEFAULT_VM;
+        goto out;
+    }
+
+    /*
+     * Newer VM types are required, either explicitly via legacy-vm-type=on, or
+     * implicitly via legacy-vm-type=auto along with additional sev-guest
+     * properties that require the newer VM types.
+     */
     kvm_type = (sev_guest->policy & SEV_POLICY_ES) ?
                 KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
-    if (kvm_is_vm_type_supported(kvm_type) && !sev_guest->legacy_vm_type) {
-        sev_common->kvm_type = kvm_type;
-    } else {
-        sev_common->kvm_type = KVM_X86_DEFAULT_VM;
+    if (!kvm_is_vm_type_supported(kvm_type)) {
+        if (sev_guest->legacy_vm_type == ON_OFF_AUTO_AUTO) {
+            error_report("SEV: host kernel does not support requested %s VM type, which is required "
+                         "for the set of options specified. To allow use of the legacy "
+                         "KVM_X86_DEFAULT_VM VM type, please disable any options that are not "
+                         "compatible with the legacy VM type, or upgrade your kernel.",
+                         kvm_type == KVM_X86_SEV_VM ? "KVM_X86_SEV_VM" : "KVM_X86_SEV_ES_VM");
+        } else {
+            error_report("SEV: host kernel does not support requested %s VM type. To allow use of "
+                         "the legacy KVM_X86_DEFAULT_VM VM type, the 'legacy-vm-type' argument "
+                         "must be set to 'on' or 'auto' for the sev-guest object.",
+                         kvm_type == KVM_X86_SEV_VM ? "KVM_X86_SEV_VM" : "KVM_X86_SEV_ES_VM");
+        }
+
+        return -1;
     }
 
+    sev_common->kvm_type = kvm_type;
 out:
     return sev_common->kvm_type;
 }
@@ -1477,14 +1513,24 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
 
     trace_kvm_sev_init();
-    if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) == KVM_X86_DEFAULT_VM) {
+    switch (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common))) {
+    case KVM_X86_DEFAULT_VM:
         cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
 
         ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
-    } else {
+        break;
+    case KVM_X86_SEV_VM:
+    case KVM_X86_SEV_ES_VM:
+    case KVM_X86_SNP_VM: {
         struct kvm_sev_init args = { 0 };
 
         ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
+        break;
+    }
+    default:
+        error_setg(errp, "%s: host kernel does not support the requested SEV configuration.",
+                   __func__);
+        return -1;
     }
 
     if (ret) {
@@ -2074,14 +2120,23 @@ sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
     SEV_GUEST(obj)->session_file = g_strdup(value);
 }
 
-static bool sev_guest_get_legacy_vm_type(Object *obj, Error **errp)
+static void sev_guest_get_legacy_vm_type(Object *obj, Visitor *v,
+                                         const char *name, void *opaque,
+                                         Error **errp)
 {
-    return SEV_GUEST(obj)->legacy_vm_type;
+    SevGuestState *sev_guest = SEV_GUEST(obj);
+    OnOffAuto legacy_vm_type = sev_guest->legacy_vm_type;
+
+    visit_type_OnOffAuto(v, name, &legacy_vm_type, errp);
 }
 
-static void sev_guest_set_legacy_vm_type(Object *obj, bool value, Error **errp)
+static void sev_guest_set_legacy_vm_type(Object *obj, Visitor *v,
+                                         const char *name, void *opaque,
+                                         Error **errp)
 {
-    SEV_GUEST(obj)->legacy_vm_type = value;
+    SevGuestState *sev_guest = SEV_GUEST(obj);
+
+    visit_type_OnOffAuto(v, name, &sev_guest->legacy_vm_type, errp);
 }
 
 static void
@@ -2107,9 +2162,9 @@ sev_guest_class_init(ObjectClass *oc, void *data)
                                   sev_guest_set_session_file);
     object_class_property_set_description(oc, "session-file",
             "guest owners session parameters (encoded with base64)");
-    object_class_property_add_bool(oc, "legacy-vm-type",
-                                   sev_guest_get_legacy_vm_type,
-                                   sev_guest_set_legacy_vm_type);
+    object_class_property_add(oc, "legacy-vm-type", "OnOffAuto",
+                              sev_guest_get_legacy_vm_type,
+                              sev_guest_set_legacy_vm_type, NULL, NULL);
     object_class_property_set_description(oc, "legacy-vm-type",
             "use legacy VM type to maintain measurement compatibility with older QEMU or kernel versions.");
 }
@@ -2125,6 +2180,8 @@ sev_guest_instance_init(Object *obj)
     object_property_add_uint32_ptr(obj, "policy", &sev_guest->policy,
                                    OBJ_PROP_FLAG_READWRITE);
     object_apply_compat_props(obj);
+
+    sev_guest->legacy_vm_type = ON_OFF_AUTO_AUTO;
 }
 
 /* guest info specific sev/sev-es */
-- 
2.25.1


