Return-Path: <kvm+bounces-54188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C807BB1CE03
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EA373A6447
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85459220F57;
	Wed,  6 Aug 2025 20:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TRnX/ow0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130B921ABD5;
	Wed,  6 Aug 2025 20:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513169; cv=fail; b=GttRI4X4lYPgzVAgiJc2Adci6nCSgT13Nl24QgoBaDhLEscGlo3btscZA3vNbKkgdNdWrbTEE2VgicdxtDtK4YnAKW30bgdIM8auBPqhhhbbtEhhZDwke6i7KsH49VIbuvKIh6t/9mlj+tWXKftXROwaSOZePhlUvdeIyvNi7i4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513169; c=relaxed/simple;
	bh=EYClAOL4kI24UktTucOTF1782t2w7bayQbEbslm7nqs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XbZmM0WGj5QmuIFNDHgMlKvopMQ0hyAMCx7ktnyj/HEistoRekoGRZoOPEmRkihXhr7S6Xi0/EiFiMSoXsMpVeR8EuWvhQ5+g5CqlT3lvVNmTjAeOqhwNMZSpKztPd9HqNsgvUXI3Zff9ie4duEQhYMHkf1UMJEwA5FDlBecCcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TRnX/ow0; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Smqb++ZlRv5KhxV92i633c61v5S2U3F1y57EoyJCLmg34J2/wugDSZNiiSHuVhm0OOdtcuRsaKRaMqVNOiH+4mck8WvnQw2xZy4u/wjA1rB3b+7dks1tEmvdbPHRALQbeB99Hn3p4mXD06RPu0+XGd0r/QGAbSA4nn7rgVh3hErT8+NpH2gc49sim/0CczXE504S9hnxqF6F9WI2j4yjMqhK9OdTWzppNLJ0vP9x9PTElAXg32lxB0PhOYVGVCGFJjZG4z00hBjmE5xWlvqxRh73DSLbQ8JvnfyDMzwO/kbzwg8H64ulJ7i0CaUhxYZ5dsQaiFwTJU/ZipYL4SvZTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zk2130jr41F9qoY4RJJJLTvQ/G+SuFnWzrbGr6GK+uc=;
 b=t7S9UfygS0JdRPXGsPgNNcqUtzJgjsCWluja1ePB8mFiv0H1hUuszFxi0jjh3GDvwLeRSkpuZHTKYyttUi9V8FaDbuCtCwDlNscm3AG7iyL6HIEBaCPI0uwYZOMzHuEwZ7XZ/eGKbT/M5tOZeu9s/dUngmqe12M87rypkOMM8JApBPkh8fyUj2SUrpSDIv17AlIZf0Bp+ZXAeAWS+7CLxkFVnbI0qe15kQHqfNDr844cYuYGB8glTYaVscpbppr9dKjaIX8I4TUexTn0GRpp9cHIi77Zn+ow/9IEWLS1xKsKOSYdtn8UQpYe7vMooswLiDcSQf7yJVst37xWekLDzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zk2130jr41F9qoY4RJJJLTvQ/G+SuFnWzrbGr6GK+uc=;
 b=TRnX/ow0g//0RifBa9LkOlMdLp7BNzE31eviJOaCk+4+as0XY7XalnLjgFgqBmazT2xWaRbiHUohcL6QqfsE5jXoQpAjciRpnOa4GDKqA3DwBi3lAapj4JDsO0YP9MSVjITQs2yD40jTCIpzEicS2yzgqJMkLkXXH1pbVd4F0FI=
Received: from MN0PR05CA0014.namprd05.prod.outlook.com (2603:10b6:208:52c::25)
 by DM4PR12MB6183.namprd12.prod.outlook.com (2603:10b6:8:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 20:46:01 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:208:52c:cafe::8b) by MN0PR05CA0014.outlook.office365.com
 (2603:10b6:208:52c::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.6 via Frontend Transport; Wed, 6
 Aug 2025 20:46:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Wed, 6 Aug 2025 20:46:01 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Aug
 2025 15:46:00 -0500
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v3 1/5] KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
Date: Wed, 6 Aug 2025 20:45:06 +0000
Message-ID: <20250806204510.59083-2-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250806204510.59083-1-john.allen@amd.com>
References: <20250806204510.59083-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|DM4PR12MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: d87ed269-e8a6-46af-46d8-08ddd52a4119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2q6JXQGqQ83cn8ngqxbAJaGF5DX/gw0QiESEFiTUruf4O+4uUne0MrnSV9E5?=
 =?us-ascii?Q?Z+1/1NIsTg4YOqIKmIWfVXu7a7Mzh24dAjcTXyecRfIlz1MwtDIx4CFOr54i?=
 =?us-ascii?Q?2STn9NgpqoR/3wWZqI/3E1PGkhIiPoeVJWY19ZNfWL1wJr4vyYXCE0sa8bK8?=
 =?us-ascii?Q?x3ilcfDPajvcuCumncu0WmbpTWdBxo+HVZMxI1XU6eNQSG6IDgvL2vpJLAPJ?=
 =?us-ascii?Q?IOibXDylES67aezetdzdXR3jf6LoSk0htoQbTDU973Wgms6/LpBlEbGHB8I6?=
 =?us-ascii?Q?JrR6l0xIOK83J/YDQ6OEBgwOs09Vs5w7RzvGTHF0WsbDe88mz+t3E6dWE+4p?=
 =?us-ascii?Q?BM+FEWr88HQa1/7oazaHgXlbh8itomcmdIf+5GwO8E6Gx8gokkxg7haBO3Bh?=
 =?us-ascii?Q?D83prlhXQCuZGP34KrjltaT89dbyeq3jsVOSDpPmvkVL99Yc+qip4TtPtt4x?=
 =?us-ascii?Q?sv99DSz1busaaL1V0RsTUuftz3TNvJQRISWWQN1o9AGsIaJuJ3BveI3arIAa?=
 =?us-ascii?Q?aPpLIQgL6nWXq/8odo8OeXPKHoY8+vJlyCJSyuGQdCuZlWy7aH3q6Iz4qTcB?=
 =?us-ascii?Q?iY1ZJIPNk/YyB2F2ZxYY7E0Dy7PZAyjhZJIRTlj9lhVuemdS/VT3QC8TisPa?=
 =?us-ascii?Q?rw5MsfW6XZtJ3gKfokkZCarpfYzI9zaGi8bh+eKsC0Y5E9f+MZMots7BCGS1?=
 =?us-ascii?Q?sP44+tBiAH765F73sO3wJ09xQq+RLh9TG4lqTfAm1SgBacMmFm+Le5ZsFU9S?=
 =?us-ascii?Q?fdbRVChl3KMEcg3qPnkecM9ywZoWvKIn/0c3kkn0wtdR6oqpmV94jps3DTcz?=
 =?us-ascii?Q?SWvfkit2Y3qwYn9/HTzo42h/h4076PgRyNx0964dazRIMPVXS7KqpR8bddlG?=
 =?us-ascii?Q?n2UEcr1ad1R+/4IbACk3eoWMO94TdWhUg/T8P4Nl8w4eCOZboAEWnGU4o9wJ?=
 =?us-ascii?Q?/as5HdJBIG6sb1dKyFqLFsQGweoZnfjV3j2OQIB9vEnr8soCMFL7fiiOE5af?=
 =?us-ascii?Q?/OjcCnF55A6chSACQaF47gXqD3IwEscfRLiL+h9sLqsGh4Z0qaHn7nOT+Rtm?=
 =?us-ascii?Q?Ga6twbry9A8DMOh7z6FSy7jA50tY8uiNoxmYMigGNaMT5T9cro72aWrZhGIh?=
 =?us-ascii?Q?yjuC6/YuCufULtsqqNovqs09vNKkYqkjz0QWOLzyqgjsXBazwRE5YZFou5fi?=
 =?us-ascii?Q?8NtXkbBMzpUZNapZsWibL73GQ1iT2FfI0gepulVfS26T/lI5sABEgcAkmPZ0?=
 =?us-ascii?Q?41PSdKhMAC+XUrbnSc6tRp5Z4oyiFJmvAkS40uwGrnJOS/pdWMB5FYVDk7ou?=
 =?us-ascii?Q?HQtAH4Nrrzb/qKZQS6YGjQNNcd4f4O4W/7zdHxkrcF6g18RgBYZwyCidh+DH?=
 =?us-ascii?Q?lRql+fSnELfFE7FHip/I0msLKEXzKsIMjyam4LRu6Qj6S7lbvmGSpcczLp3Y?=
 =?us-ascii?Q?J/56Q0OJqj4dePVuZgMmiZlB3vHI/lsBnMfRd2dA4G8Jv+VMuzL5MQakBvhz?=
 =?us-ascii?Q?OTzvefO1vKHw3xg9ET2IEphBNaIjHjZYcD15?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:46:01.3550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d87ed269-e8a6-46af-46d8-08ddd52a4119
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6183

Set up interception of shadow stack MSRs. In the event that shadow stack
is unsupported on the host or the MSRs are otherwise inaccessible, the
interception code will return an error. In certain circumstances such as
host initiated MSR reads or writes, the interception code will get or
set the requested MSR value.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6375695ce285..d4e27e70b926 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2776,6 +2776,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_is_intel_compatible(vcpu))
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = svm->vmcb->save.s_cet;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = svm->vmcb->save.isst_addr;
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		msr_info->data = svm->vmcb->save.ssp;
+		break;
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -3008,6 +3017,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
 		svm->sysenter_esp_hi = guest_cpuid_is_intel_compatible(vcpu) ? (data >> 32) : 0;
 		break;
+	case MSR_IA32_S_CET:
+		svm->vmcb->save.s_cet = data;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		svm->vmcb->save.isst_addr = data;
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		svm->vmcb->save.ssp = data;
+		break;
 	case MSR_TSC_AUX:
 		/*
 		 * TSC_AUX is always virtualized for SEV-ES guests when the
-- 
2.34.1


