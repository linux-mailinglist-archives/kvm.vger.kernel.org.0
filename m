Return-Path: <kvm+bounces-18817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BFCA8FBFEA
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D946A1F24740
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D67F14D449;
	Tue,  4 Jun 2024 23:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vgyjDDEJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA6BA5F;
	Tue,  4 Jun 2024 23:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544172; cv=fail; b=PJtKEvilv922ZVqcDWXwNbetU8yIeo2ebuJVQGqiOhjVPBRCiB7Xh7dAfnodlmnJ/b3U/8hfucQJKIn4cxnlzt7BY9dUWtfkosNXDx4Km6xs2c7viWA5BEDDMha8mawTrnhCRk3SQjc3tbtGwv46leBUxG/MthxheIxWLMpcFGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544172; c=relaxed/simple;
	bh=XqCZtA1ajN6WWkL9IxIz7HIO5f6zzWzPpu5nt3aHEGc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CQW0hnno0+UmqW9Jc0wwOYZEVeGMVtDuvEuQzb46Am0h3bBPDvq8s1JBGbBy1VIiZpSzK1ksTy50zd6v9eR26HUal/F1QZ1yFibxucW7e6RW/0NDyhwYSjPvioCQAhrtUvNd7Yhf656WRddo4A19+G9YabMS+3Fr7c1bAqv9ETs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vgyjDDEJ; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oe0/T6Ee1nLhq9ynYUYvmpsqFVuAFM7zy1p7BblTIju4YY056ClMZ7YW40Np5HH4dqaHLZat2ujCdUYNWi7C5i0yxifbY5ILsdElTbykspB0qeKf6MeZBYPZuodxOklivqeE91pZpiPIgdCoKQuVsBk19G/ETPP1GZFql9KgOFEGOi/XTgJSr5e9XfZ2+vdcICsLSuWCXVVJYpxZI18JgVSwiUtbUd4lccWPF1u2znO/DxeBmoL3AY0PgvrHHx5JHygwgEN95DU7cz4w8hUGE3+TiP6uUST7sul+TaqejMLP4+udtwN/IqYJCAR85XhQmH6Zo7Az9YhEPRVoQOptoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WlJuFPyzInGvjwzIXd5Ue7xI01aVNNrNGuSeH9SRUA4=;
 b=HpWAfpWLf9zUANsckwnOSFqnxp5q5PdBtemiGU2EqpcVKn6dLXI9SSZwCUiuakVrwl9dBW7vKkcUedeBCks9VPknOf9hBcnokLDksRIdpDwtBMpHYdtW3BIpgl7TGYYVoMvAMi3CDvICX2WI5ZpuImmu3hRWC7xujy98NMH/ltKtVPYp3SsTMpWrvvBHPsFtkCRY0TK8Z3TPo9824lcuSagiKO2Ghds+HpfWocJ2bQG0q1v95T2hXnOXfp24nMt+4UvbhvTRVp9fnEr6IcGwO8JhRTD9U24CtYZWi94Tho42IKybGXQaCXiOIZSLnJqO+ui14maNEp7lJ2hPcWny4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlJuFPyzInGvjwzIXd5Ue7xI01aVNNrNGuSeH9SRUA4=;
 b=vgyjDDEJsoeQ4XsdwwJRx0b6O5PTLcbmpJ978RTCdFCwoDBG2L5Ggy9fDOBuChfm8kqMCt9WNzoT5I9sBOdoB7eTeE1olTy9c01SXWmnGihV1oZNpya7GRvjDNAkLF/m1tfqaatDbVyL+M4jOl7uvz0Oxz3Yb1L0KA54WmzHAFQ=
Received: from MN2PR17CA0023.namprd17.prod.outlook.com (2603:10b6:208:15e::36)
 by IA0PR12MB8326.namprd12.prod.outlook.com (2603:10b6:208:40d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.26; Tue, 4 Jun
 2024 23:36:07 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:208:15e:cafe::dd) by MN2PR17CA0023.outlook.office365.com
 (2603:10b6:208:15e::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.28 via Frontend
 Transport; Tue, 4 Jun 2024 23:36:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 23:36:06 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 4 Jun
 2024 18:36:06 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>, Srikanth Aithal <sraithal@amd.com>
Subject: [PATCH] KVM: SEV-ES: Fix svm_get_msr()/svm_set_msr() for KVM_SEV_ES_INIT guests
Date: Tue, 4 Jun 2024 18:35:10 -0500
Message-ID: <20240604233510.764949-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|IA0PR12MB8326:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b1b105c-6dcb-48a0-776e-08dc84ef1b55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zn+jjbTl2UmdBCcWwRr/fh4UqqFxIc29n3OmvDR147j4cMKgybiPO6skBf06?=
 =?us-ascii?Q?qOF0c/RgjslQlKkc7iM1ZJ6Tfk+Me2s9dXXXSuQz7Lpwz5rO3HM+wr1CkVWA?=
 =?us-ascii?Q?a299wcZPnT3bLbOsNA2dnn03nQCiEz3K0pduCPgne5RgeCOgWVRhoXOH/7Bg?=
 =?us-ascii?Q?vIqA/Z+oJptoMQuVhNxBL0/bglubk4jc8IiBmS4FIgPKwFXKN5ts3mzHKUjx?=
 =?us-ascii?Q?BX6Tqy1k1KyRVFSI5DVryabJWnrrp9Y0aTAsX9hGGKjkWriqTjsCxdE12jGo?=
 =?us-ascii?Q?aH6YY1mhwVa7sQfSla5XcEJtIy93Cw4ArhUwQMWnXLfjOxUknKcPLjLZu4RK?=
 =?us-ascii?Q?ZqH5CW1DRG48A3Mj4yllN4SiFVnlNkYet90k1f8Z0I8Bisn12rZ6z1irMW5L?=
 =?us-ascii?Q?PaezjWGQQU8zv+dn7VG252IwVUHOqUB0xu1iygHw0vf4wrqDBd0ajyB1wokc?=
 =?us-ascii?Q?CMvhK7fwz7mkE6aNhwR5VpaMRcW1EXBAXmjkmH/LMVZ4S/+82X1dl7J3aw6/?=
 =?us-ascii?Q?YDjbemFVrISVYolBaXmQnUVxZObWZhRwxM2W+EBdioFbS/sldLbPgrjZI9kv?=
 =?us-ascii?Q?4tjxxMobwBD+3fImzVxvDBrT2QZghATiy21ZxVNVXCU4naYpGY+Q5+1J1L7m?=
 =?us-ascii?Q?6ui71zdwE0QEI6ppEo8DXe8dth/pa/rhpMTD43hiZUwF+FaPSOxWUj5TQ1VE?=
 =?us-ascii?Q?NnLemJdQmroDxxehRdljYN/qG8tzANoc5HC3jkFKQJEj3R6rCLI0219ZwItK?=
 =?us-ascii?Q?08WMGpZxcmOWg6sgGkNP3FLD3x6wsrc0KTlC75DToBlKXBsSEpLRvVPEKk7X?=
 =?us-ascii?Q?A49NrtfFXfZqTdKxbMKno+6R7FLznoIz3SvRcV+6DsTjr0jWhY/qxbh/IfvQ?=
 =?us-ascii?Q?1lyHJNSdgfs6hJi+IECI4cIrRORpaalM1HFgep7jb7vG1P54iXDknH1burus?=
 =?us-ascii?Q?VXwgp4hxLa2RhWUj24/J+CrGlQeygXWFDTtKOX8Q8u7Itb8TcEfH76S9aAfn?=
 =?us-ascii?Q?i2ivlSRB1IZ/G1kHD10hPJjE9SZS8APrme9EmEuOLI5vpH9NVIkhZ8BtmO8n?=
 =?us-ascii?Q?Lv1ERIRqIB5BxKZu3rhfb5wAv61r/MffoqAFAsX8o6GAUc8qU2viM1w6baFh?=
 =?us-ascii?Q?OewNQLg+gZyQZzBCQKZf4zaGFmXh5BTQahCgqqk/7eOG07gtWieTeQAhSsuQ?=
 =?us-ascii?Q?ZT2QWJUs/MbKBFHSN3Sp1djYjBe990PkTbJ2AuiCIyf70nmIPSk/oX7LYoAJ?=
 =?us-ascii?Q?i2reSs+qo/vJX5BawG/8sOe2FmSzPD63EobJqu5d5XEVViuUHjP6pPsTs10H?=
 =?us-ascii?Q?EXzkx2Ls15mIPIkBKwZnvpYwK5magOStSf7AsLIy8dOBlrc7JWRamGxXLIMK?=
 =?us-ascii?Q?Iht7guk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 23:36:06.9622
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1b105c-6dcb-48a0-776e-08dc84ef1b55
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8326

With commit 27bd5fdc24c0 ("KVM: SEV-ES: Prevent MSR access post VMSA
encryption"), older VMMs like QEMU 9.0 and older will fail when booting
SEV-ES guests with something like the following error:

  qemu-system-x86_64: error: failed to get MSR 0x174
  qemu-system-x86_64: ../qemu.git/target/i386/kvm/kvm.c:3950: kvm_get_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.

This is because older VMMs that might still call
svm_get_msr()/svm_set_msr() for SEV-ES guests after guest boot even if
those interfaces were essentially just noops because of the vCPU state
being encrypted and stored separately in the VMSA. Now those VMMs will
get an -EINVAL and generally crash.

Newer VMMs that are aware of KVM_SEV_INIT2 however are already aware of
the stricter limitations of what vCPU state can be sync'd during
guest run-time, so newer QEMU for instance will work both for legacy
KVM_SEV_ES_INIT interface as well as KVM_SEV_INIT2.

So when using KVM_SEV_INIT2 it's okay to assume userspace can deal with
-EINVAL, whereas for legacy KVM_SEV_ES_INIT the kernel might be dealing
with either an older VMM and so it needs to assume that returning
-EINVAL might break the VMM.

Address this by only returning -EINVAL if the guest was started with
KVM_SEV_INIT2. Otherwise, just silently return.

Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>
Reported-by: Srikanth Aithal <sraithal@amd.com>
Closes: https://lore.kernel.org/lkml/37usuu4yu4ok7be2hqexhmcyopluuiqj3k266z4gajc2rcj4yo@eujb23qc3zcm/
Fixes: 27bd5fdc24c0 ("KVM: SEV-ES: Prevent MSR access post VMSA encryption")
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b252a2732b6f..c58da281f14f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2855,7 +2855,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	if (sev_es_prevent_msr_access(vcpu, msr_info)) {
 		msr_info->data = 0;
-		return -EINVAL;
+		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
 	}
 
 	switch (msr_info->index) {
@@ -3010,7 +3010,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	u64 data = msr->data;
 
 	if (sev_es_prevent_msr_access(vcpu, msr))
-		return -EINVAL;
+		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
 
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
-- 
2.43.0


