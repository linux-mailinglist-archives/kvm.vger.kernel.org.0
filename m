Return-Path: <kvm+bounces-36322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 08868A19E1E
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 06:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 653B87A3854
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 05:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9E11BD504;
	Thu, 23 Jan 2025 05:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Llz4L57U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F4FC2FD
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 05:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737611525; cv=fail; b=ivBm/A7MgyfAVTgKpscFYjakFZeDb2wD6XW98S4Jgj7AdzCnO3mdbYNzT6Y3BQz0l96x+yhK0zKlPp5XbpUrGvlvOlvpqQzxfEwqd4ZB/i+Bi+ilIXKS3tdOSfUbmm5aUtAwkUWZ/SIvrx9pv+4MrINeVMAv79zZ+p5LyuRhddI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737611525; c=relaxed/simple;
	bh=/B07Cbm7vA3O31yUdSdxWeo6Sa9RBeaFJEg0gq94Eko=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TmvoBKms0L6uYW5Sku++w+ubiusvSK30A+Cj4g4SW9QDDT/Zyi5VCMr70IlV6rAxRDSE0ekWjJKRGMf7Nb2wSDDSe5ReSGxdTI4B7fWppKJk5m5/lE4Jd/3eXSxkNIHTlSxNtAz0kuVzL0547I+GhgUmQwYwAz4deLx2gaHRLQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Llz4L57U; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rOYFHYc8y7L/T7Dt/dh/HikBlBmkhZXmhvJknCkpDIsSr7IddF6RJ2Wt6b5MMk6Laut3yGOrixUCEDWjwVh2SScV6JId7DDbm08QvxffvAkaMsRA1tLI+CMP9VLRNcWQHhlmGMdZ79NHuYlAo5dxu1qAH+8c5trNah16yYfSb/+M7fv95E1965lPzHL3TVHMa/l1f9kiWWXpVXJteNW6UWekq+Z7E1tpacIKAjD5ncHx/qdrK+TYI7jOa5gZi46L3pZ4VvWNqjHS3/Movr474zRN+KIFZBVfikjFYbJzwKl0G2bI8lLBuEmpAuVA3fWbow0lyL6Woww6UHIXJRkr7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6PeYubr9Y0tMSR0cZ9sQTcLVb832m78vfYdMsF6akU=;
 b=qa/LIT8q7p7N7B/OX15Gj7EuJvFoGBNJe4DXCvur2VBj20diQQhgA/RN6SfMOznWl4F/wCRUtFu7/ZY2nEwMebT8Q95HUtttqk7Ee18qFIR1fOsEssIQdciII4wkSTC3vXOG3zErJlw1t2g4L10UzzJJ76Vg8ReK4s4oVU0vKaNO5DtZO6CMVb20H+LsQS2wWzvSvfsHugs7cpFFki7UuyUEAw7ZObRMRQlhxMUvu5RniW86d2+50HMYwuS/P4S+SKsjF6HmjS6vlEv2WYsSIaC1qZGhVBWL4V/C4dRKHKrUoEpDeEJHcYm24F4nbjAjBzOnBTt2B9Sou2JWpZlmCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6PeYubr9Y0tMSR0cZ9sQTcLVb832m78vfYdMsF6akU=;
 b=Llz4L57UdCuAljJhpujwSA16GaPNnVhIQTVxqoh+Y4FXJuS/6wEPSxNFwlARRGtA3NzDx1b2+lYP+fFL45vMkrbp1qypOuSfcnixDx4wS/YVzkPcsYIbsnUiXJLi2NizXvlzUgd1N4hn8/w+lxJag2acCTeZiLI96eN/Eg8sfJA=
Received: from SJ0PR13CA0148.namprd13.prod.outlook.com (2603:10b6:a03:2c6::33)
 by IA1PR12MB8080.namprd12.prod.outlook.com (2603:10b6:208:3fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Thu, 23 Jan
 2025 05:51:58 +0000
Received: from SJ1PEPF000023DA.namprd21.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::1a) by SJ0PR13CA0148.outlook.office365.com
 (2603:10b6:a03:2c6::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.12 via Frontend Transport; Thu,
 23 Jan 2025 05:51:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023DA.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.0 via Frontend Transport; Thu, 23 Jan 2025 05:51:57 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 22 Jan
 2025 23:51:54 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <nikunj@amd.com>
Subject: [PATCH] KVM: SEV: Use to_kvm_sev_info() for fetching kvm_sev_info struct
Date: Thu, 23 Jan 2025 11:21:40 +0530
Message-ID: <20250123055140.144378-1-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023DA:EE_|IA1PR12MB8080:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c0d25d2-faa0-40e0-22d5-08dd3b720c69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YoCX+mpKWlwuBvQFGqchxD0OyFPv5f5A2X+Da69e8OeDjSUIDlW41nKwS8FI?=
 =?us-ascii?Q?4DSpLVwannFnkSUOSD2iGP8nlswLrzh8R+PC8Y8sVNfmaqKUY1Tc3AkHkmye?=
 =?us-ascii?Q?+67cQAWYW7lfKyWtJTfM9mKaTQ0ko977XVB+m7Eyt1vxGKQ3r+BG9ta9UFiy?=
 =?us-ascii?Q?yT4XNcph6Db/d2Uny80KvumJ3qdQ5T8VpKnA4Q+NKlEub+011e9V8ftTNoc6?=
 =?us-ascii?Q?Osd5Ml17QY6+IHtltDu3A90FNmzZBtahIrdlP1P5m4dqFHij9gT65jgYe+3X?=
 =?us-ascii?Q?Wn10Uao76M4IOVL4m+7B6zAFjcn42dMsqctgwh5cycSQS98K+uGGqb13M5dc?=
 =?us-ascii?Q?na04GNYr967V1xyqpTs7thSy2zwoioXaB1r+8H2/pFE9RFWx1tPoeOdG0lvN?=
 =?us-ascii?Q?35/UuHI7EZ2riUESAib5JoAzgKvYrzv5yOfnl+TnzGYhjcH+mmKaVYWWJMUt?=
 =?us-ascii?Q?7kK/5cUn0tK1V4qpMLLi1d2Xswf088MV+/ujcTO3SppZrcZDMnZ0irmxvqM7?=
 =?us-ascii?Q?SvwhlZVh6Dx/+6ECMQ07BDuZxiL4Xt5hZLrOJVqUFGyJIuHnyeCR3A3oKQ3z?=
 =?us-ascii?Q?rq9UepDbtlxue39HuoO2ntLhI2fTloybLgMT6zMQ5zMmmDq9cGzkHfdRqQ11?=
 =?us-ascii?Q?Cd24jBALjBoY1hhmhOPQe1zCGtxzRkrDsiOEhbDNa7jefopuHpbM8uJI5Wsv?=
 =?us-ascii?Q?Dhf6/joYHyG4Y1bd+0nk8t3jowzGYgQdZBir8yuNOOmnHLVsntkjTO5id5C6?=
 =?us-ascii?Q?92DRt/Yn2fKC9oRscdCwZRf3U4YPQh/45tW0zqRe23J+fDqTOPwde/R1shj7?=
 =?us-ascii?Q?U40lmu8ZTxqaMrcIURkHLBzKrRLMN72QIJxExO2GNz/1Wz76+7HobiiYZ68M?=
 =?us-ascii?Q?Y1G6EtHx27P2qVu2GAWxyLY3ITAQAr9qxnFPRDWuVU2zKYmsr6ZGCC+yNdYU?=
 =?us-ascii?Q?yz3MvGEaoFMwcGS3URif9Mvop1Vu+AM0EB2iYzBL7a4cnY7zbgYH9W5jwlSy?=
 =?us-ascii?Q?aH05NOsNJgC0yx4NSCdMEa0MQ6VQie4XWi6toZLEEPKl22JnBH/SMyZ9SxVg?=
 =?us-ascii?Q?XK2U2EBT1L7TWrU/04Qx5gyueKnGrEcNzZP+BlmDEk+hDXvj44TjI6SgeMOk?=
 =?us-ascii?Q?cHQYlJrfQ3v3ZxUnm6vEUxKRLytDz61x4DwszoDxAyINJmDytzkrx88gfjQH?=
 =?us-ascii?Q?FBdbW1S4RhQ2Ap9YxdKIQbokrFfxHiEUkMAAHwxEfUoNi/3xQTKL/aK6Mmkq?=
 =?us-ascii?Q?q3TRrV0ZFSMEUjXlXs69kqfKrWTnx8c65g5jnUhSmPeX+zj0KZW87pzTIrvi?=
 =?us-ascii?Q?LhyK+vQsfTwLaoQPuz4F9K1c8AbBIm+1sKCOVtcQls/F7HzeKZGOgvtZt+Yi?=
 =?us-ascii?Q?CYMTvrMM5Y+4xTEU9g+8KXwlV3eRX4O9eAMnXdLdw5T0opDL0cCEcol5R9KO?=
 =?us-ascii?Q?+0p5s8yYf9wfvSHyNwg38W9Nd4agWSP4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 05:51:57.5443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0d25d2-faa0-40e0-22d5-08dd3b720c69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8080

Simplify code by replacing &to_kvm_svm(kvm)->sev_info with
to_kvm_sev_info() helper function. Wherever possible, drop the local
variable declaration and directly use the helper instead.

No functional changes.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 124 +++++++++++++++++------------------------
 arch/x86/kvm/svm/svm.h |   8 +--
 2 files changed, 54 insertions(+), 78 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0f04f365885c..e6fd60aac30c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -140,7 +140,7 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
 static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
 
 	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
 }
@@ -226,9 +226,7 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 static unsigned int sev_get_asid(struct kvm *kvm)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev->asid;
+	return to_kvm_sev_info(kvm)->asid;
 }
 
 static void sev_asid_free(struct kvm_sev_info *sev)
@@ -403,7 +401,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 			    struct kvm_sev_init *data,
 			    unsigned long vm_type)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_platform_init_args init_args = {0};
 	bool es_active = vm_type != KVM_X86_SEV_VM;
 	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
@@ -500,10 +498,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct kvm_sev_init data;
 
-	if (!sev->need_init)
+	if (!to_kvm_sev_info(kvm)->need_init)
 		return -EINVAL;
 
 	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
@@ -543,14 +540,14 @@ static int __sev_issue_cmd(int fd, int id, void *data, int *error)
 
 static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 
 	return __sev_issue_cmd(sev->fd, id, data, error);
 }
 
 static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_data_launch_start start;
 	struct kvm_sev_launch_start params;
 	void *dh_blob, *session_blob;
@@ -624,7 +621,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 				    unsigned long ulen, unsigned long *n,
 				    int write)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	unsigned long npages, size;
 	int npinned;
 	unsigned long locked, lock_limit;
@@ -686,11 +683,9 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
 			     unsigned long npages)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
 	unpin_user_pages(pages, npages);
 	kvfree(pages);
-	sev->pages_locked -= npages;
+	to_kvm_sev_info(kvm)->pages_locked -= npages;
 }
 
 static void sev_clflush_pages(struct page *pages[], unsigned long npages)
@@ -734,7 +729,6 @@ static unsigned long get_num_contig_pages(unsigned long idx,
 static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct kvm_sev_launch_update_data params;
 	struct sev_data_launch_update_data data;
 	struct page **inpages;
@@ -762,7 +756,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev_clflush_pages(inpages, npages);
 
 	data.reserved = 0;
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 
 	for (i = 0; vaddr < vaddr_end; vaddr = next_vaddr, i += pages) {
 		int offset, len;
@@ -802,7 +796,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
 	struct xregs_state *xsave;
 	const u8 *s;
@@ -972,7 +966,6 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	void __user *measure = u64_to_user_ptr(argp->data);
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_measure data;
 	struct kvm_sev_launch_measure params;
 	void __user *p = NULL;
@@ -1005,7 +998,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	}
 
 cmd:
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_MEASURE, &data, &argp->error);
 
 	/*
@@ -1033,19 +1026,17 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_finish data;
 
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_FINISH, &data, &argp->error);
 }
 
 static int sev_guest_status(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct kvm_sev_guest_status params;
 	struct sev_data_guest_status data;
 	int ret;
@@ -1055,7 +1046,7 @@ static int sev_guest_status(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	memset(&data, 0, sizeof(data));
 
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	ret = sev_issue_cmd(kvm, SEV_CMD_GUEST_STATUS, &data, &argp->error);
 	if (ret)
 		return ret;
@@ -1074,11 +1065,10 @@ static int __sev_issue_dbg_cmd(struct kvm *kvm, unsigned long src,
 			       unsigned long dst, int size,
 			       int *error, bool enc)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_dbg data;
 
 	data.reserved = 0;
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	data.dst_addr = dst;
 	data.src_addr = src;
 	data.len = size;
@@ -1302,7 +1292,6 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 
 static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_secret data;
 	struct kvm_sev_launch_secret params;
 	struct page **pages;
@@ -1358,7 +1347,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	data.hdr_address = __psp_pa(hdr);
 	data.hdr_len = params.hdr_len;
 
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_SECRET, &data, &argp->error);
 
 	kfree(hdr);
@@ -1378,7 +1367,6 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	void __user *report = u64_to_user_ptr(argp->data);
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_attestation_report data;
 	struct kvm_sev_attestation_report params;
 	void __user *p;
@@ -1411,7 +1399,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		memcpy(data.mnonce, params.mnonce, sizeof(params.mnonce));
 	}
 cmd:
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, &data, &argp->error);
 	/*
 	 * If we query the session length, FW responded with expected data.
@@ -1441,12 +1429,11 @@ static int
 __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
 				      struct kvm_sev_send_start *params)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_send_start data;
 	int ret;
 
 	memset(&data, 0, sizeof(data));
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, &data, &argp->error);
 
 	params->session_len = data.session_len;
@@ -1459,7 +1446,6 @@ __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
 
 static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_send_start data;
 	struct kvm_sev_send_start params;
 	void *amd_certs, *session_data;
@@ -1520,7 +1506,7 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	data.amd_certs_len = params.amd_certs_len;
 	data.session_address = __psp_pa(session_data);
 	data.session_len = params.session_len;
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 
 	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, &data, &argp->error);
 
@@ -1552,12 +1538,11 @@ static int
 __sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
 				     struct kvm_sev_send_update_data *params)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_send_update_data data;
 	int ret;
 
 	memset(&data, 0, sizeof(data));
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, &data, &argp->error);
 
 	params->hdr_len = data.hdr_len;
@@ -1572,7 +1557,6 @@ __sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
 
 static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_send_update_data data;
 	struct kvm_sev_send_update_data params;
 	void *hdr, *trans_data;
@@ -1626,7 +1610,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
 	data.guest_address |= sev_me_mask;
 	data.guest_len = params.guest_len;
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 
 	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, &data, &argp->error);
 
@@ -1657,31 +1641,29 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_send_finish data;
 
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	return sev_issue_cmd(kvm, SEV_CMD_SEND_FINISH, &data, &argp->error);
 }
 
 static int sev_send_cancel(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_send_cancel data;
 
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	return sev_issue_cmd(kvm, SEV_CMD_SEND_CANCEL, &data, &argp->error);
 }
 
 static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_data_receive_start start;
 	struct kvm_sev_receive_start params;
 	int *error = &argp->error;
@@ -1755,7 +1737,6 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct kvm_sev_receive_update_data params;
 	struct sev_data_receive_update_data data;
 	void *hdr = NULL, *trans = NULL;
@@ -1815,7 +1796,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
 	data.guest_address |= sev_me_mask;
 	data.guest_len = params.guest_len;
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 
 	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, &data,
 				&argp->error);
@@ -1832,13 +1813,12 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_receive_finish data;
 
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	data.handle = sev->handle;
+	data.handle = to_kvm_sev_info(kvm)->handle;
 	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
 }
 
@@ -1858,8 +1838,8 @@ static bool is_cmd_allowed_from_mirror(u32 cmd_id)
 
 static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
-	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
-	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
+	struct kvm_sev_info *dst_sev = to_kvm_sev_info(dst_kvm);
+	struct kvm_sev_info *src_sev = to_kvm_sev_info(src_kvm);
 	int r = -EBUSY;
 
 	if (dst_kvm == src_kvm)
@@ -1893,8 +1873,8 @@ static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 
 static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
-	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
-	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
+	struct kvm_sev_info *dst_sev = to_kvm_sev_info(dst_kvm);
+	struct kvm_sev_info *src_sev = to_kvm_sev_info(src_kvm);
 
 	mutex_unlock(&dst_kvm->lock);
 	mutex_unlock(&src_kvm->lock);
@@ -1968,8 +1948,8 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
 
 static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
-	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
-	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
+	struct kvm_sev_info *dst = to_kvm_sev_info(dst_kvm);
+	struct kvm_sev_info *src = to_kvm_sev_info(src_kvm);
 	struct kvm_vcpu *dst_vcpu, *src_vcpu;
 	struct vcpu_svm *dst_svm, *src_svm;
 	struct kvm_sev_info *mirror;
@@ -2009,8 +1989,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 	 * and add the new mirror to the list.
 	 */
 	if (is_mirroring_enc_context(dst_kvm)) {
-		struct kvm_sev_info *owner_sev_info =
-			&to_kvm_svm(dst->enc_context_owner)->sev_info;
+		struct kvm_sev_info *owner_sev_info = to_kvm_sev_info(dst->enc_context_owner);
 
 		list_del(&src->mirror_entry);
 		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
@@ -2069,7 +2048,7 @@ static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
 
 int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 {
-	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *dst_sev = to_kvm_sev_info(kvm);
 	struct kvm_sev_info *src_sev, *cg_cleanup_sev;
 	CLASS(fd, f)(source_fd);
 	struct kvm *source_kvm;
@@ -2093,7 +2072,7 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		goto out_unlock;
 	}
 
-	src_sev = &to_kvm_svm(source_kvm)->sev_info;
+	src_sev = to_kvm_sev_info(source_kvm);
 
 	dst_sev->misc_cg = get_current_misc_cg();
 	cg_cleanup_sev = dst_sev;
@@ -2181,7 +2160,7 @@ static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int snp_bind_asid(struct kvm *kvm, int *error)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_data_snp_activate data = {0};
 
 	data.gctx_paddr = __psp_pa(sev->snp_context);
@@ -2191,7 +2170,7 @@ static int snp_bind_asid(struct kvm *kvm, int *error)
 
 static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_data_snp_launch_start start = {0};
 	struct kvm_sev_snp_launch_start params;
 	int rc;
@@ -2260,7 +2239,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 				  void __user *src, int order, void *opaque)
 {
 	struct sev_gmem_populate_args *sev_populate_args = opaque;
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	int n_private = 0, ret, i;
 	int npages = (1 << order);
 	gfn_t gfn;
@@ -2350,7 +2329,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 
 static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_gmem_populate_args sev_populate_args = {0};
 	struct kvm_sev_snp_launch_update params;
 	struct kvm_memory_slot *memslot;
@@ -2434,7 +2413,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_data_snp_launch_update data = {};
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
@@ -2482,7 +2461,7 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct kvm_sev_snp_launch_finish params;
 	struct sev_data_snp_launch_finish *data;
 	void *id_block = NULL, *id_auth = NULL;
@@ -2677,7 +2656,7 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 int sev_mem_enc_register_region(struct kvm *kvm,
 				struct kvm_enc_region *range)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct enc_region *region;
 	int ret = 0;
 
@@ -2729,7 +2708,7 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 static struct enc_region *
 find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct list_head *head = &sev->regions_list;
 	struct enc_region *i;
 
@@ -2824,9 +2803,9 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	 * The mirror kvm holds an enc_context_owner ref so its asid can't
 	 * disappear until we're done with it
 	 */
-	source_sev = &to_kvm_svm(source_kvm)->sev_info;
+	source_sev = to_kvm_sev_info(source_kvm);
 	kvm_get_kvm(source_kvm);
-	mirror_sev = &to_kvm_svm(kvm)->sev_info;
+	mirror_sev = to_kvm_sev_info(kvm);
 	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
 
 	/* Set enc_context_owner and copy its encryption context over */
@@ -2854,7 +2833,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 
 static int snp_decommission_context(struct kvm *kvm)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_data_snp_addr data = {};
 	int ret;
 
@@ -2879,7 +2858,7 @@ static int snp_decommission_context(struct kvm *kvm)
 
 void sev_vm_destroy(struct kvm *kvm)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct list_head *head = &sev->regions_list;
 	struct list_head *pos, *q;
 
@@ -3933,7 +3912,6 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 
 static int sev_snp_ap_creation(struct vcpu_svm *svm)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_vcpu *target_vcpu;
 	struct vcpu_svm *target_svm;
@@ -3974,7 +3952,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 		u64 sev_features;
 
 		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
-		sev_features ^= sev->vmsa_features;
+		sev_features ^= to_kvm_sev_info(svm->vcpu.kvm)->vmsa_features;
 
 		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
 			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
@@ -4134,7 +4112,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
 	u64 ghcb_info;
 	int ret = 1;
 
@@ -4354,7 +4332,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = kvm_emulate_ap_reset_hold(vcpu);
 		break;
 	case SVM_VMGEXIT_AP_JUMP_TABLE: {
-		struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+		struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
 
 		switch (control->exit_info_1) {
 		case 0:
@@ -4565,7 +4543,7 @@ void sev_init_vmcb(struct vcpu_svm *svm)
 void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
 
 	/*
 	 * Set the GHCB MSR value as per the GHCB specification when emulating
@@ -4833,7 +4811,7 @@ static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
 
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	kvm_pfn_t pfn_aligned;
 	gfn_t gfn_aligned;
 	int level, rc;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9d7cdb8fbf87..5b159f017055 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -361,20 +361,18 @@ static __always_inline struct kvm_sev_info *to_kvm_sev_info(struct kvm *kvm)
 #ifdef CONFIG_KVM_AMD_SEV
 static __always_inline bool sev_guest(struct kvm *kvm)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-
-	return sev->active;
+	return to_kvm_sev_info(kvm)->active;
 }
 static __always_inline bool sev_es_guest(struct kvm *kvm)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 
 	return sev->es_active && !WARN_ON_ONCE(!sev->active);
 }
 
 static __always_inline bool sev_snp_guest(struct kvm *kvm)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 
 	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
 	       !WARN_ON_ONCE(!sev_es_guest(kvm));

base-commit: 86eb1aef7279ec68fe9b7a44685efc09aa56a8f0
-- 
2.34.1


