Return-Path: <kvm+bounces-18040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB3D8CD229
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 833BA283C88
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FA614883D;
	Thu, 23 May 2024 12:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C49zIrIF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530261487E6;
	Thu, 23 May 2024 12:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716466755; cv=fail; b=AA7JbciUCBpfFMx627ptLwVp4CrnuCsCYmL1XgA9wRns5UHpyCLQUg202/sdQITQB2rVZCmLx5rQa9b2r1MuztgzfZ/12Da5fsGms+LTgLDIoOgKku2YWM3EZxU459QmRWq0x9X0EYTmHorY0JtDdIQ36cgkUM9z9dW53qLA7oI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716466755; c=relaxed/simple;
	bh=Qd73mJHQAi+tS1x4W+D+L/MdD30yMlMKPxElWTEQ064=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lj5zWPwv3BeC3+dGRR7N6ZkHX9nTwlDaJcYViF13EIHklgGDvmlPifI2UyDf/k3ZlaqIhZH44AZSfgR7a1nENgQd20+xAL/x2K2sqyRM+1mLuJR61iZsrKN5pocByooErRQMfUxgmzy+PTknlb15stg8z1gV8mh1q0B1tCubpws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C49zIrIF; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2x6AZOseo9nJz78PihlUIN+EvBQG7r9E826E8HY702p1cq9YZb5wS4mK1YGCXA6mI8+TffIuHRpnkIDv3KX+L8tFxeljLjxbX0DsJ6Des3vXW1C7XCvRyu0usyc6UYWNtE5J1vs2hvuMGjqwwODsS+EM8iHwtVO3if3VDA7xSrxTobD7B2//pSbh6CdtO1HGy4Nf1GWPuQ8IKUPO5XDJeJ7tY8q7EfMNxl9Y3zaflb4VmaUIt2rmN7m9Hfa19HE2k4v2TkwqWkr0mW596pIFyhZNf95w7Bq8c9Tb8e2lx8su3EeUm64VnBPFDNGTpgzzYTOkt/N6mFR0dkWD+AFfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pycldfp6p5cnxOUITP3B15iwpIMasZlnLYyzwN1uZ74=;
 b=alRRkj7mNputVijYd/pKUNvpdVZNLGLQJH54R0RAPnJpsAbh8gzGMer+vh+HlvX6mTf/AUDjOmirmLeLJTfkTEt6GnihtQiDnGRBQaESl98guTB8WBET0GrSoi9+Boa/QqD/qs8lI58fuVRiCQrbyAW6Jym4VS3xYtYv8uCn62EhYK7Hd3/5+ZjsSyno5R/j0YeF/Eb4uoX1CoZsTvXLN/eHpeaYQnASy6p36FqUeK+GmX370EdGuwWkJXPrKqkNKk4R/YfDNGiakVTVYOCh1JkzZg7L/WtHAGRpPCnsu9wSOsl2MK/YqlH/6WFneNk9YSbGnXQZZw/XemKxJAqDig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pycldfp6p5cnxOUITP3B15iwpIMasZlnLYyzwN1uZ74=;
 b=C49zIrIFsKRJFrNoX6+xCyLiwcx0856RUPsP9h+t5vMgjsbKqoABvtUgLSUm2r6YXodOAjYwhAjHfJWdkzGCL3aL/Ns2XbSPYbd9Fu96ElgrXoQsYl03XlCdcHalbqH8TnJn/XnW99nqLgZmXB1H/aM6XBBR20fm/e/ts9Aqx6U=
Received: from BN8PR15CA0027.namprd15.prod.outlook.com (2603:10b6:408:c0::40)
 by DS7PR12MB8324.namprd12.prod.outlook.com (2603:10b6:8:ec::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.22; Thu, 23 May 2024 12:19:09 +0000
Received: from BN1PEPF0000467F.namprd03.prod.outlook.com
 (2603:10b6:408:c0:cafe::49) by BN8PR15CA0027.outlook.office365.com
 (2603:10b6:408:c0::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22 via Frontend
 Transport; Thu, 23 May 2024 12:19:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000467F.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Thu, 23 May 2024 12:19:09 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 23 May
 2024 07:19:02 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj.dadhania@amd.com>
CC: <ravi.bangoria@amd.com>, <thomas.lendacky@amd.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <michael.roth@amd.com>,
	<pankaj.gupta@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>
Subject: [PATCH v3 1/3] KVM: SEV-ES: Prevent MSR access post VMSA encryption
Date: Thu, 23 May 2024 12:18:26 +0000
Message-ID: <20240523121828.808-2-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240523121828.808-1-ravi.bangoria@amd.com>
References: <20240523121828.808-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000467F:EE_|DS7PR12MB8324:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e34083a-765c-4831-453a-08dc7b228c49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|7416005|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xP1QxiRLoBNPMclKJZlMRROjivTlE/Qm3U2vKDEv4qOJY4mMUrhOljD4/uyc?=
 =?us-ascii?Q?zSIyxHdidwniydPBRD7On2FxYO87WpYrYJoePIF8VaZkOEEFrcnfDuE1nZeE?=
 =?us-ascii?Q?QA+5ddYpyfGz4BRuYt1VxzcpttDP54EZRKJ4EH6FBYGWgzCRkcgxadSY/Cwx?=
 =?us-ascii?Q?ObRKTjeZi2/1tOP4MvZymE8LXYbc/NqK6078Zkg2gtB31JjNJHQ3+OP+PsYE?=
 =?us-ascii?Q?a6jmFJk21yXd4DJ3SgFD2wBVAnuJeUu96+786YHYegVUy7gonFNnNuwQHxk+?=
 =?us-ascii?Q?1Xof9zB6Zac791M5HIXJhhpQ7P+0uzpK04Iqq3aXreEX20h76nbgZ7zp0zpR?=
 =?us-ascii?Q?ZFzkamavhHQNivIHHj0BGUE/XmQTH8jccpiciTV+GjJPJj+Hkg7wzDo04SaP?=
 =?us-ascii?Q?/iIH6wfnowJM5A9EnAnkUx9I+1ZY4Rw+cbwtOsiHxE8+YjwiDFINwZr8cJzF?=
 =?us-ascii?Q?FoqBfd2V0C6o2dwjXEHc+d5URs0Jz0B4nZJIJlArOoKXOlz2PKc4HtGHBQxP?=
 =?us-ascii?Q?hJYiSn6LNBq3WemOEH/5iNPef4pfOmeJcMRawOJp/lA8/rPHhM6cQLYly66f?=
 =?us-ascii?Q?/Wz8a+8/Gx+0gzOXRdvpTopGt5eP4LdsOglsfshXmbV4q+RZ50JYmU1OYxe9?=
 =?us-ascii?Q?NePIPBYEdpMkVafHLIxA6J+qD39kA2cZZSsAPdoBEaq8CzbkT2IEQQQamweV?=
 =?us-ascii?Q?qONpIYlswswNSrs+ShNy0xTYasdcykFK1/VhnYJKD/RHlwyx0iNuAmqqEoAg?=
 =?us-ascii?Q?Kwb7l3CwPG1S7luCefLMqdxdldiN7m+512vd5gyACn2cjIwZCKD6k8eDl8B/?=
 =?us-ascii?Q?P1EH3QyprtbDXBvgigQH46stnP4SkEWW7eIzOU5Y/A7q5KDf6YW2DDP+0+ho?=
 =?us-ascii?Q?l/SAx5N6GeRu3HvKGZvL8X5mth8/v9XDsH+V7Og3iIgMK1PbU4cmqMCWRVh5?=
 =?us-ascii?Q?AGm5s+gH5I9kHrO97ibBV3jfiAhY4n74wycEGWn92qFtmUqzEECcbY1Kvx+9?=
 =?us-ascii?Q?uwYWlDWD4ohtSTBfCzG15j859Yc0CNo5rizQw5mj+uVLC9+OjrahaRHi6DND?=
 =?us-ascii?Q?W5ZDfWIpZDiuvszHOKYkToQdMh7ZM/73uFbvnPnlP5SpjM/I4Qf5rLpF1f6G?=
 =?us-ascii?Q?/xBIh6hvnBXbYwyVNIi8Jcw+El0Vtrk/MOb15tstg2I0crJ3pZHQK1dO1Xd7?=
 =?us-ascii?Q?088Ih5fK/5b1rCAahmXEL520qHjNNj55BsvCt5CjFXHRVu1/RbDyYak/7z24?=
 =?us-ascii?Q?RyAlkR09AsMuOFJRAiFzl+T7PAwXePKjrrUXyiCqB/btjKtvImF6IRJ0o9G8?=
 =?us-ascii?Q?VntVk6EKbjd44LUuoBuLuPy/0GIy3UXUgQ7igHuwhD8QYPsOJxTL4AzwUSbM?=
 =?us-ascii?Q?rTJ9JXY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(7416005)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 12:19:09.1703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e34083a-765c-4831-453a-08dc7b228c49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000467F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8324

From: Nikunj A Dadhania <nikunj@amd.com>

KVM currently allows userspace to read/write MSRs even after the VMSA is
encrypted. This can cause unintentional issues if MSR access has side-
effects. For ex, while migrating a guest, userspace could attempt to
migrate MSR_IA32_DEBUGCTLMSR and end up unintentionally disabling LBRV on
the target. Fix this by preventing access to those MSRs which are context
switched via the VMSA, once the VMSA is encrypted.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3d0549ca246f..489b0183f37d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2834,10 +2834,24 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 	return 0;
 }
 
+static bool
+sev_es_prevent_msr_access(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	return sev_es_guest(vcpu->kvm) &&
+	       vcpu->arch.guest_state_protected &&
+	       svm_msrpm_offset(msr_info->index) != MSR_INVALID &&
+	       !msr_write_intercepted(vcpu, msr_info->index);
+}
+
 static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_es_prevent_msr_access(vcpu, msr_info)) {
+		msr_info->data = 0;
+		return 0;
+	}
+
 	switch (msr_info->index) {
 	case MSR_AMD64_TSC_RATIO:
 		if (!msr_info->host_initiated &&
@@ -2988,6 +3002,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 	u32 ecx = msr->index;
 	u64 data = msr->data;
+
+	if (sev_es_prevent_msr_access(vcpu, msr))
+		return 0;
+
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
 
-- 
2.45.1


