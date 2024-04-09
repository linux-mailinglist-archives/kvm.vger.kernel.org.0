Return-Path: <kvm+bounces-14037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD8CD89E5E3
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EF1FB22BA0
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 23:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8A9158D95;
	Tue,  9 Apr 2024 23:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AIeDnd7s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD76E158DA0
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 23:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704115; cv=fail; b=EhLVgS8SYxlP6WYebiN6UPXh5csxlbIrPZVQQi2yTBfpZ8dnVpNut+wYzUZhDtm8bkx5shAqwRMyJr6ob8lVJLb/w0So9phyGDQpdqpW7sdo4A8cGgrcyWPhakJJMQT+WpCU9q7hNcDJ0L17VYOw5lCh7XB3r1UsBh9WvzigeRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704115; c=relaxed/simple;
	bh=5Xu6gApzRHFPl1IE9Nui24YsIdFCvtoL95NdHhrTFkA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xc5MkBYyPCLxvwtb7ozRWOqHRqnEM3HLvN8DdyLHRCRmaRg2GdZEAJKMOJUcUVdf8Dgx63mpIhacBCH3fLkC3cjLlNmxJT31lybcS+8W2jKAIw/j9+2IEHaOLgbId5UZfwL+x8hkl/lQoOWBvMmhmnadj6PWHuaD6q9htDNtwYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AIeDnd7s; arc=fail smtp.client-ip=40.107.102.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hS2fpJd1NqycB/UznJRjCo4SSdRYs0daGa6gOENqqB6VIoKO2NZmgNDku4/rL0EeUCV+FU2N+UpruTX7a9wHAfyCnX6B3qAk22HkcdrP/2b0V+Oe67CNxxkyujb3omvs+wzGFelSsHknTzK6d95FSiHlyzCqd52FA3IbL2KE00keJOzckY9oUzh4wIHS0BsQvJ0qK0rDLNaLVJOYkN97PHE7uLNw3ZkKGZTxVob9OkAwGryAlYwH3Bv3iL56X/6zenNKSbYbzoacmEetnZnchrKIc45MJ3TBxjS6kTwnlIlMV0otd9pMG6TaQBpOjRfKBYOruGXutb6v3g6oiD4yow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13OrMkDe2zUg6G2zYtaNt3Z9bXv4jVkyvbPd9ZKmXLk=;
 b=UJztS7NbfKRYQYV1v3CPPwxt+wLp9Pzh3/cuKGr2v7qoAsrm2GVuLnL+72dGdu7xu03+Jew7lz6sXcq+uIIxVIAsBdWqfEHP3BMKGaUPvUhDzTGyWMoYujseIEl1ysb7xW8l3KyeU2dsJJb7yZxkZtmZsWH3T9F+dNlaldG68CGbtjymaWwgn+NJyYZGGv3cEjOvoFFhIfxQHB7irfLcDnzZlv7JovyvfeUia03a3/GLbERfDcJ4ANgvooOGmtMfjgf5Cp/LG7+YNzgFSkSCDCTh73KkpxeGd4hI7/n8VrxBgJ0ekn0gzP6mJPfWcAFC5hqB6HpJwFT/xZz8HFTgQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13OrMkDe2zUg6G2zYtaNt3Z9bXv4jVkyvbPd9ZKmXLk=;
 b=AIeDnd7s8WF8gwHJyxiHTNueFlBMwF83wlszMbP6nV3r5eQ+K6lNpb/XfhydrqIoE29Nj8io5OOjn4WpvgBsOKmfq75m/cp0YqpJfvmM8KDoZ+ORZAbepJ6akvbzfBOqt2qbs8y2m6iS105OqKHyPaXFyaek9Jz/bDZmCWdyVQc=
Received: from PH8PR02CA0034.namprd02.prod.outlook.com (2603:10b6:510:2da::13)
 by MW4PR12MB7189.namprd12.prod.outlook.com (2603:10b6:303:224::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Tue, 9 Apr
 2024 23:08:30 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:510:2da:cafe::f0) by PH8PR02CA0034.outlook.office365.com
 (2603:10b6:510:2da::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.19 via Frontend
 Transport; Tue, 9 Apr 2024 23:08:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 9 Apr 2024 23:08:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 9 Apr
 2024 18:08:28 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, Larry Dewey
	<Larry.Dewey@amd.com>, Roy Hopkins <roy.hopkins@suse.com>
Subject: [PATCH v1 1/3] i386/sev: Add 'legacy-vm-type' parameter for SEV guest objects
Date: Tue, 9 Apr 2024 18:07:41 -0500
Message-ID: <20240409230743.962513-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240409230743.962513-1-michael.roth@amd.com>
References: <20240409230743.962513-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|MW4PR12MB7189:EE_
X-MS-Office365-Filtering-Correlation-Id: 850c0a92-4fdc-4b74-fe55-08dc58e9f80f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uKgMoQ1t+3BW+/Kecm8LeeC4TTvdQKRVvDbzB3+6J5EtgufkgTGN+abS30+YU63pHzvabhNcFjak/gT7YMkOMSGACVp3BY8A+nQ45DRB+GCKflpb8ry/EjpA6jpbd6dSu7lm/uagBel1kDIzg21kP1d+YYps8+US7CzkzguV4hdnWQ46Dal327GzcJ/RMjV/7xK1O5n/6JPjUmSr55eF1f7AQu5ayTkAWfJjkS05lfri9QjHGvIPkOWZYz6ST4M5FZaQpiVmjWn4s159szEh9oy+gEo1Lhn63sSW3BXYz8uIS7tyzL4+REcDYVao/sphbij5ZZyUNItJ2wKd4Q35yZdGAue1D1zLhq2RyTpou6MRQsSfYBhcZnXcpgOSBjN5OlAwjqOmxOMR/b9LVY9IrHEIBdtoz+MYVikxjt3CrPLggNqxLOh/1xDxQTkRQdzeaPRnMFxIy5wf4YLzdNiZZNX7eQ4GSsky4BKEcBQrXXFtwR1J6ddGYXSb7A5pgbs/gHJxURNouncDRKa5p8O1rXQmnFfTUSpLVU9Q/FTVw0iX9TcO1nKcjWpAVYbMeg68zH74WHpVhnFmMIsp0rbL9Oy3UoYxWJAYl1RLkENVDuop6dBhu4HvNOPaIg+hc22aiqP8fLMn5dOBiDM6kJAdNvrsALI1eHrJ2QyDPe0OieaaDle0IOdKEtjlHYtafn5SXwZIlPBpvlkaq/DZ5ZLnM0iB1irBfcDgcqu4Bdol29TtPzIQlYNnyisnmjd83Eci
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 23:08:29.1096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 850c0a92-4fdc-4b74-fe55-08dc58e9f80f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7189

QEMU will currently automatically make use of the KVM_SEV_INIT2 API for
initializing SEV and SEV-ES guests verses the older
KVM_SEV_INIT/KVM_SEV_ES_INIT interfaces.

However, the older interfaces will silently avoid sync'ing FPU/XSAVE
state to the VMSA prior to encryption, thus relying on behavior and
measurements that assume the related fields to be allow zero.

With KVM_SEV_INIT2, this state is now synced into the VMSA, resulting in
measurements changes and, theoretically, behaviorial changes, though the
latter are unlikely to be seen in practice.

To allow a smooth transition to the newer interface, while still
providing a mechanism to maintain backward compatibility with VMs
created using the older interfaces, provide a new command-line
parameter:

  -object sev-guest,legacy-vm-type=true,...

and have it default to false.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 qapi/qom.json     | 11 ++++++++++-
 target/i386/sev.c | 18 +++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index baae3a183f..8f2f75bde6 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -898,6 +898,14 @@
 #     designated guest firmware page for measured boot with -kernel
 #     (default: false) (since 6.2)
 #
+# @legacy-vm-type: Use legacy KVM_SEV_INIT KVM interface for creating the VM.
+#                  The newer KVM_SEV_INIT2 interface syncs additional vCPU
+#                  state when initializing the VMSA structures, which will
+#                  result in a different guest measurement. Set this to
+#                  maintain compatibility with older QEMU or kernel versions
+#                  that rely on legacy KVM_SEV_INIT behavior.
+#                  (default: false) (since 9.1)
+#
 # Since: 2.12
 ##
 { 'struct': 'SevGuestProperties',
@@ -908,7 +916,8 @@
             '*handle': 'uint32',
             '*cbitpos': 'uint32',
             'reduced-phys-bits': 'uint32',
-            '*kernel-hashes': 'bool' } }
+            '*kernel-hashes': 'bool',
+            '*legacy-vm-type': 'bool' } }
 
 ##
 # @ThreadContextProperties:
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 9dab4060b8..f4ee317cb0 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -67,6 +67,7 @@ struct SevGuestState {
     uint32_t cbitpos;
     uint32_t reduced_phys_bits;
     bool kernel_hashes;
+    bool legacy_vm_type;
 
     /* runtime state */
     uint32_t handle;
@@ -356,6 +357,16 @@ static void sev_guest_set_kernel_hashes(Object *obj, bool value, Error **errp)
     sev->kernel_hashes = value;
 }
 
+static bool sev_guest_get_legacy_vm_type(Object *obj, Error **errp)
+{
+    return SEV_GUEST(obj)->legacy_vm_type;
+}
+
+static void sev_guest_set_legacy_vm_type(Object *obj, bool value, Error **errp)
+{
+    SEV_GUEST(obj)->legacy_vm_type = value;
+}
+
 bool
 sev_enabled(void)
 {
@@ -863,7 +874,7 @@ static int sev_kvm_type(X86ConfidentialGuest *cg)
     }
 
     kvm_type = (sev->policy & SEV_POLICY_ES) ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
-    if (kvm_is_vm_type_supported(kvm_type)) {
+    if (kvm_is_vm_type_supported(kvm_type) && !sev->legacy_vm_type) {
         sev->kvm_type = kvm_type;
     } else {
         sev->kvm_type = KVM_X86_DEFAULT_VM;
@@ -1381,6 +1392,11 @@ sev_guest_class_init(ObjectClass *oc, void *data)
                                    sev_guest_set_kernel_hashes);
     object_class_property_set_description(oc, "kernel-hashes",
             "add kernel hashes to guest firmware for measured Linux boot");
+    object_class_property_add_bool(oc, "legacy-vm-type",
+                                   sev_guest_get_legacy_vm_type,
+                                   sev_guest_set_legacy_vm_type);
+    object_class_property_set_description(oc, "legacy-vm-type",
+            "use legacy VM type to maintain measurement compatibility with older QEMU or kernel versions.");
 }
 
 static void
-- 
2.25.1


