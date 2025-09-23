Return-Path: <kvm+bounces-58454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B681B9446A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:05:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F36E52A801D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8848130DD25;
	Tue, 23 Sep 2025 05:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gQ+af+3v"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012050.outbound.protection.outlook.com [52.101.53.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA78274671;
	Tue, 23 Sep 2025 05:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603890; cv=fail; b=G+sjkUj0jtm3/b8w9U0K6ZD2XYIX1oOijrIF5XETGQ3DwFbDRPtyvgEMAJ2VPNME/FBw+3aZlkj8iduovkiF0bn0f9bTQdKT+y6ADVZYcUv8gFmM2irQqJjWjxd2F/FO5RMNUxFAtdZyTOeqxnRdaqWWPnsn6ddJIK3kE9DFCvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603890; c=relaxed/simple;
	bh=xblGdLMa3qKYbkBs71Rmrmc+MW3lzAAtBMcm8abS0rs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pYL7zvNf0elw14aSLnD9TCXZ/Blqj1o86qzEeYoD/Xb+9+8t/UHPhipnP7XjZpCqzotB8XO0CUoJUTg5X3Q3c4FcQcjI0orUpYqBCxzxg+V1m3ABmvGnBdr1hn03ySNwJvfHI/nl84EOIgyDHsiUtlqmgwk5kGHXSeMQFxvjK9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gQ+af+3v; arc=fail smtp.client-ip=52.101.53.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rCK6sSF1suweFAukFJJ6KIJyyZ4c733P4l6zjAGBams0J5QHAF+VR0jax+UueEiq028/YkI2OhbmA5O1uF/gv4p+ruMsaA5hblZTIjR/hKROJ0/oNGEVUj29+U6xSuyKXSEehuoFm3IaONu/sWWbZ2FDWYsfpHqYXDjeRT+XLKG8LuYvx84ynpSP4zhogbD+ICKZE/9hVfd7n7oqX6TfndjU24Nc8a2wp3+Y0sOBj2aFIilWqybdcZuMK8tkdrUE7WtpyVJDenyd0KZP8uLhLBXjbItARHlVVZcI7USF01FnjOvoV9/UhbFw6zlKspFft2sZ2QhDpHLNMJPGxD+epw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XItqrWyRhxf8pIGHcpQhl6QE0K780EjiWORjSM2FKso=;
 b=Xy8bw1pjVW2uYVB6Q5MEUJnuaeWcuaiuHQszkG1TK9EXtXX0yLh/vmDr3r/aa0ew4CYR2839KGxf2TH4lQv5XJvvNOksr/73FZkDk4GPT5pmoilsAv2OjFfKvC7EWrtlMDccq/YgWfhpP107kOzADl51GD9tBcEJ7qv+RmXzabcj4gi19moi6qFMGTBaHKdwZo04v1DIWCE3asYeT0wGnINs2AOD9DWOkdWYlRYWKiuCIyZKTgVRxZ6+3ExzE77JlWO+biPDO3d8DONidsQ605HT/AQl2eADSTEafSVt/Q77zBcGI3ZD5+Yf1ZeXrOdNklLAASVlRxgehdUvktDihw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XItqrWyRhxf8pIGHcpQhl6QE0K780EjiWORjSM2FKso=;
 b=gQ+af+3vCVU+AkWjHi8huw92RvF+PQ1qdi1Ne95N8qsAfjkC+WB2cte7JOlShTIiis5DpL4IAe05Zrm5D/9SDN+4YWBiOdOxV/IvzzOkwVsdpoZ9fJo7tC7hQaXYewtoBocej9oHIgYenDmqJpC7ei26ZjMuIqf68J1FQdQbZiQ=
Received: from SJ0PR03CA0001.namprd03.prod.outlook.com (2603:10b6:a03:33a::6)
 by IA0PR12MB8277.namprd12.prod.outlook.com (2603:10b6:208:3de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:04:45 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::ab) by SJ0PR03CA0001.outlook.office365.com
 (2603:10b6:a03:33a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.19 via Frontend Transport; Tue,
 23 Sep 2025 05:04:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:04:44 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:04:33 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 04/17] KVM: SVM: Set guest APIC protection flags for Secure AVIC
Date: Tue, 23 Sep 2025 10:33:04 +0530
Message-ID: <20250923050317.205482-5-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|IA0PR12MB8277:EE_
X-MS-Office365-Filtering-Correlation-Id: de20d218-9808-460c-2781-08ddfa5eb657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BxWFB24V4yaLpHv7JrS7tXGEXHbvsdpj750Ykc9ql5KTuJn5nhV+WbvbUBj9?=
 =?us-ascii?Q?EuqSqprT5aQo96t7cgEIAlWD5SJKEaURryM0MUqqexy2NgFVHgU9oQTpSEaQ?=
 =?us-ascii?Q?P2dUbcwObghoR8PcAj9J+/mAEespskMc+Y2jiR8YR8RuCvWAXBl/ahOzByjK?=
 =?us-ascii?Q?qrxH2eZ3YI5E1o+mVtafW7edhjzlD3QBgy54XgS/IU6OcOxbHgXwbFGv7KzN?=
 =?us-ascii?Q?yMwSGcw+5T7Rexw88VpVgIb+SkFXYmvmC7UVMM03xdQwY/c9o9V+rBnLPHtD?=
 =?us-ascii?Q?uPvBvXG7tx6iGq3qEwo+FHvncqSaXVjv5smA7ZKoOvBUGOkA1w7EIO/M1CC2?=
 =?us-ascii?Q?T3wC9TCLFWlC0G4/L+XZ5lakZdwFpzlHPuWu2lydAqbftBYPzupiwNZgvA2C?=
 =?us-ascii?Q?NObZJSLUvk+1xq35+GQEsi0eiO6/rcfuOhghgEN38OQSLfzkdIIO21aTJcgE?=
 =?us-ascii?Q?gua/Vqh6BJpqjCsTVQaK5NGgdUzrS+J44HzTSaDtqw+md2BLUv3YUsa7qysA?=
 =?us-ascii?Q?I4hEjWz5cHk0HKCOjrR0ysbPEy5kJ3nL3EHxFmBJx5KoWApmprLhX84BrFVq?=
 =?us-ascii?Q?rWmXOjfbysHYJgpe04/HbZq0r/CXXjJ3oPsMapH8RpZo0QPAzpLxRuwiPJFN?=
 =?us-ascii?Q?l76xx5ZyIEdV6muwLdVTb0lSII5zfjcZdRtup9KPAWMgIPHmSrLcoku/CW+v?=
 =?us-ascii?Q?1U1QMOsUVfN4tygbIs0BhRzvRkcAYfti8gwZc5joXEVwX+FTqzA+oexu7cJ1?=
 =?us-ascii?Q?oXZTWOvj/OHI9ckc+pY7OZIelaHalxdYe//aNZ5jRuVo2kJ/1wGB6lfVXwlA?=
 =?us-ascii?Q?NRDgLPSOUayYApwnAkclZOsmEsdU454E7zuSqSueOZsKYXCumbo+dpWpYEh/?=
 =?us-ascii?Q?twI9phQ7Jq+BMT+QD/yB5LqpWk15SdD+h7mZjBUx5t+JIJt4skfkxAnR2pkX?=
 =?us-ascii?Q?RrBhi6IVag+z46vAnvd43VKOw1R94eAx5uu4Kq5kUA92693Ld/x2WeUoYW58?=
 =?us-ascii?Q?Z0/xC4YiG4surv5VJRh6p5mLnOEo2AOLtbnSko6HONDrdKfVmfjZdgkU5tTk?=
 =?us-ascii?Q?3m5rvxHybqrgvg28ZYXGtx85g6EklwXP2UrlLA7anaJatLG99iRyeHEaG1kI?=
 =?us-ascii?Q?6aDvzncAdysuDdZE0rMQLb913F69YiJMqsxrP4YX0l8xCxh3gZ8LxBusQ4KM?=
 =?us-ascii?Q?oVmXZjCLQfJiZpIetDV1gPtsNQd8bQ+mrTsf6Xo76Y8oFEj8f5H0GtxCRZwW?=
 =?us-ascii?Q?P2QERuP1RmRDU7CX52c0PeaQpoujf7x2o5aQshACFVCqvEevBWClXk7Zznva?=
 =?us-ascii?Q?ZPhRQKzKTvTZqoEG+RenOcJGgG8qwueRIeAb/aYFbWDl/MTjqjqlgAEYc4uW?=
 =?us-ascii?Q?Q1b36xl4vg9aZ4CdX4jTgr0HHRV9IlKLwjOIVaOJC79KDocbe/VxUwhTnVKc?=
 =?us-ascii?Q?TuaRmXnNJKKtVfISefo9YRGPhd0IraeeD06BdezAJowL73r8xAQeJdbic0w0?=
 =?us-ascii?Q?8tqe5JgSkCIM6BUajYAM8iCNBIT/ZmG0VqVI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:04:44.8087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de20d218-9808-460c-2781-08ddfa5eb657
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8277

Secure AVIC provides a hardware-backed, protected virtual APIC for
SNP guests. When this feature is active, KVM cannot directly access
the virtual APIC state and must use software-based interrupt injection
to deliver interrupts to the guest.

Introduce a helper, sev_savic_active(), to detect when a VM has Secure AVIC
enabled based on its VMSA features.

At vCPU creation time, use this helper to set the appropriate APIC flags:
 - guest_apic_protected is set to true, as the APIC state is not visible
   to KVM.
 - prot_apic_intr_inject is set to true to signal that the software
   injection path must be used for interrupt delivery.

This ensures that the core APIC code can correctly identify and handle
Secure AVIC guests.

This is only an initialization commit and actual support for creating
Secure AVIC enabled guests and injecting interrupts will be added in
later commits.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/svm.c | 5 +++++
 arch/x86/kvm/svm/svm.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8a66e2e985a4..064ec98d7e67 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1300,6 +1300,11 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		goto error_free_vmsa_page;
 
+	if (sev_savic_active(vcpu->kvm)) {
+		vcpu->arch.apic->guest_apic_protected = true;
+		vcpu->arch.apic->prot_apic_intr_inject = true;
+	}
+
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 70df7c6413cf..1090a48adeda 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -869,6 +869,10 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
+static inline bool sev_savic_active(struct kvm *kvm)
+{
+	return to_kvm_sev_info(kvm)->vmsa_features & SVM_SEV_FEAT_SECURE_AVIC;
+}
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -899,6 +903,7 @@ static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, boo
 {
 	return 0;
 }
+static inline bool sev_savic_active(struct kvm *kvm) { return false; }
 
 static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 {
-- 
2.34.1


