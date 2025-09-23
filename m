Return-Path: <kvm+bounces-58458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00EFAB94491
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 815597B4C78
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8381C30E82A;
	Tue, 23 Sep 2025 05:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Tg7DSd6S"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012059.outbound.protection.outlook.com [40.93.195.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C8D30CB3D;
	Tue, 23 Sep 2025 05:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603952; cv=fail; b=GtdwuiWmDpGsJY4VZjDklIBZ0+GYTU/yU5u3N7NsgdFs+pcqfhnEAHPkmQ+dBq66irJQE86G77yr6w0uUzdND7D3O1yVJUhfnh7ZkbVJ++PJrOoNLz8wSLsiKACmUgzDLFVoj1i3vsPvdkwWQLewxBU9+NJ+6zQl+RnwXOj5I9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603952; c=relaxed/simple;
	bh=6/b1lDeX2exVWjbByeSPoPUQfYt6O7/NuKtBAwrqcZQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DuQSg2J74eRNFbPejPBFnmpK8IvD9+K0KpPAc5/0Th7wpDR5WSad4lrHDhemDesKrJHKCPfdCcFQvmm+jPDIXuSW/vR5R9ZfFgjHfGbkun0mnFgG8fZKi1Y21ne4O0orvLeyZiOSq5Iq+X3BKWjfCUsNtI8EYADpbSOK1e6L9fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Tg7DSd6S; arc=fail smtp.client-ip=40.93.195.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LI9Y0rTOP54lHCqzVx89iP/db57x0TKouevAC/BMk/PjfoU94JnfPDPVBX8TOYElbYzFLvoVLNFIJqYf/n9l6CJmwh2lfViwL/VGDC43I/rEGC7I8wkzcTCN+WprhLVnEaN8zZIcpGv+P7+TaoYamUN1HgiEV1yAwxTWasVVk2lRk2SzLUGQ51yq5RNkWpZxciugCaJhjSHZKp0kDGhnigQuB8xW4Z1mAn+otUqQmnBGn5vAX92pBpYJ6sWb8jTm8cyzSp7dYy0VxJi4Gd1PG+lu7aKKXvAG6bGTEHc8Wygglpp4JkyUWkDSafixdC8XUZPtcyrC0yeXjpE3a6jusg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJE+iSsxrTqrcf5PHzJt+Wbsh3mVjbXOHAwAj1JRBBs=;
 b=rsAw+o2ng7Y1X/FQMpvkqqIBqNKUKKDpaBuZDyVHoAA22k72oGDwwkc2uCr9HOShElB4jjn0640K3on7In/fdLYggGmTgdTdGpn6fZ/C395sNYpw+MIsxjdumEiGhVNuR5cKTIH0VuKIpHhUwa9NZmTsrAW/bnHaq4B3E6pB5XCxls+gk725hid27xuRVQ7eMrQnvB0MVJOwZ1Nq1EUwDskZWs86pXH6qsFYJPE/r76l+5gj69FB8DTF6lpIcweW6aw+1Sg6PKoR+tiYf3ZUNYh0ywxuM0fDwL9ppYmDrbqvHeOjdChvPQoj4zuExmelAmIMxonTi+7wzwWM75dX0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJE+iSsxrTqrcf5PHzJt+Wbsh3mVjbXOHAwAj1JRBBs=;
 b=Tg7DSd6SXPqr0hrm3braKvIvFafZp5r6NW9m7D3gt145JxRemQa1oaAdvK96Nx+ngi4XcCPKEW5ni8N/tK36AI3gR70N/H0IYLVZT0pEOr3mosBxUSuyIoSOKMNE2ocLm5Jn7OdFSkHVACKMN+NfuxIB2p3CB1mXjkP+NP0G0sI=
Received: from SJ0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:a03:33a::17)
 by IA1PR12MB6433.namprd12.prod.outlook.com (2603:10b6:208:3af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:05:47 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::67) by SJ0PR03CA0012.outlook.office365.com
 (2603:10b6:a03:33a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.19 via Frontend Transport; Tue,
 23 Sep 2025 05:05:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:05:46 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:05:41 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 08/17] KVM: SVM: Do not inject exception for Secure AVIC
Date: Tue, 23 Sep 2025 10:33:08 +0530
Message-ID: <20250923050317.205482-9-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|IA1PR12MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: e58eef34-3315-4c31-493d-08ddfa5edb52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hQlRHGC22fYetCKI54n5vgoc8ydqRN/xAudwFyrwpZTXWp/AGvAtcG9bzTOJ?=
 =?us-ascii?Q?OnADK87j0ttwoVwoXcc5jECxdOnl438BW/chzfWuUxUutxpNcoN4rt7QCgqz?=
 =?us-ascii?Q?dS/SVTMtdcV39ifp3XG7CcITwsVaVG+hgEqceN2D5X4A3TL2NfnZqODTc02q?=
 =?us-ascii?Q?V/UfTwBKcbY76QcwbnyfjmLqGYRIZ95rHHeEkZ92LZUoi39Ds9FMwjqa/+/Q?=
 =?us-ascii?Q?mbvkIIgHmUEUH8xpuSMhwrGtIuPCjs6B1NCQ5ZRmW6vZedA1+lBMjutNyjvn?=
 =?us-ascii?Q?jdouzgNGix2Jrxh8Fyp9Erm1W1PR6xQxsrVbFPRjNNe84ejTnIFYDPX9hNIv?=
 =?us-ascii?Q?APwG6GNVd1hRHP7X7FsR87KzEQWfk+HGsLR7g6JsMVtAOsqeM297aHEvTMJ7?=
 =?us-ascii?Q?1+4QO9uOLLkXF2vpaMaU3tOupr00/OamMrEqwcad0Wqf6bhTbR0fYvv1kWjh?=
 =?us-ascii?Q?H4yN0fOsgBb7cP4O3OHAjwmblOSUE2fT63oqaWviUdYWqdHAzr5k16sfrHsu?=
 =?us-ascii?Q?Ncd+31Iowh4lui/aGL1bfCM5bplox5V2ru9lNkHrH/VUWLWUAsT9fMbgsPqk?=
 =?us-ascii?Q?S32BnKi/B8aKDeAhcKdQnQvcMimqrW/nJrYMec45UJVUjq+a2D9Mx53iI62N?=
 =?us-ascii?Q?BV4ZLDQbfNbbNW1eyGzfN9td+izQy5dX3NpbJMjypLe6GsEj+335TuJep9wl?=
 =?us-ascii?Q?/wTzSgByobqmUJ9f3ZN6FatGc/zFm9uwTtqMhL3xChmhFjMvP/x0Y/2P/fnj?=
 =?us-ascii?Q?oF/H7mWEH1rZNWlabKOxZSgpJJoJO+fWH2LPFg/eI78XQkUuLBpJi2Kebdf0?=
 =?us-ascii?Q?gSIN2Z1V5k3FjOZ7y72qrpxjs/JOZgugfYTgVPp41yqEUIl+mV2jMlwPxC6l?=
 =?us-ascii?Q?QiRnm+ZxBlbmzMocAT+dxZdOpk1VaNCiTi6aQdwf8Yx7Uzd4+9vsUKPS6Cag?=
 =?us-ascii?Q?ziuSYV5+5KqaNODv7wbwD1c2Y0L7sq8H7ROnmS97hACkRKJLRNj55bUEpaZQ?=
 =?us-ascii?Q?HknfK4Vy/DHlG/y7PfbF4nILY3p8+y1LUCU5Ca20/QEh46nRDczHVa/wxzGu?=
 =?us-ascii?Q?So8aWGdr57GPdW0g5wCt/8UoANGyYZgP71gIkprU+KxdHWbbHGgWmqQDmghT?=
 =?us-ascii?Q?OaaoGVzl+fylkqGHc74fxq1w6gRA/UjrIpgfy7vFldNknO+MezpY5zDvg/52?=
 =?us-ascii?Q?BDP4IfPvRBAbXO92OolGtKZoAeP8xkfxTdftpfdvEwSVQUz1LgOqBccXmeAJ?=
 =?us-ascii?Q?gvatM3I/Jymf6WZYWEioAhfRi9fbgj7gRkscmUB20OlmmdhBjZzSkTwStJEm?=
 =?us-ascii?Q?2z1w/H6hg2IItfGR15qNJ2USmd4Nby5G8EJWbr3BOgGuYOHSf7p+c5KNyaZe?=
 =?us-ascii?Q?qR/xO01xSq1s3Q960xJ6Wg2hCmI7+Xy2MUOqnDtME9rfQT7Wg4KTyP6GV+Cs?=
 =?us-ascii?Q?M9Og5CFgI4N+ti9/Ak+VjqD18Mv9EtYIaAfhyIYbuSb9fyNrAjOXEklm9TC4?=
 =?us-ascii?Q?0RqPSmobLrNiY7DS4fvwAOifOFmuKYF46gYr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:05:46.8508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e58eef34-3315-4c31-493d-08ddfa5edb52
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6433

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC does not support injecting exception from the hypervisor.
Take an early return from svm_inject_exception() for Secure AVIC enabled
guests.

Hardware takes care of delivering exceptions initiated by the guest as
well as re-injecting exceptions initiated by the guest (in case there's
an intercept before delivering the exception).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7811a87bc111..fdd612c975ae 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -374,6 +374,9 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_savic_active(vcpu->kvm))
+		return;
+
 	kvm_deliver_exception_payload(vcpu, ex);
 
 	if (kvm_exception_is_soft(ex->vector) &&
-- 
2.34.1


