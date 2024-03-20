Return-Path: <kvm+bounces-12236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD6B880DA7
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:50:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B87F1F226B0
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8807647F72;
	Wed, 20 Mar 2024 08:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5MqXzkwU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E714247F53
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924433; cv=fail; b=HTnn8LNZT1QOvkaPt0KROXgWBMHaQCy8Z0MirmaE9HhyTtoX0kjGJwJ5bEPTlnPTns7KyVX2BrjAfPayltPrBTSjupXtjB4g9eb4jDz+jqmL/z9jFz+nQPO8semippuU4R7Xt50OHdBjKNsgT07ULrLUi1T+9EzkREa8YMzk5FA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924433; c=relaxed/simple;
	bh=Snaucu+UKqUDZg2I2DX+MuxXOxUTDmhN5YCp52Sw/ag=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JL1+hxYuVk62OUh8t7ZewTeau3ZnJ3/srroVa8HgyfLamWeiw+NPmfwZj0B3sOtLcQ5kglX2i1cFVUFNceKzXiB7ZYAKpCNCLz5vNS3jlsbnsPm4VNynmoe6YyfMK0SH73X+ie+oBx5n5+3E1zR6zlpPn/2BvyFcUSM8dJ4YnOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5MqXzkwU; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WoxHFZ3nWlrvM6qp3LK12Nhxu7chheLkLcrRzgxdNWkoNebnVynPoDYULars1XLus5C87ikUVXm5XjqdVMnVv9TInXzQbAT04Myk/gMVFSxPvc8XpDcebuUicXYg/xR70WvTD8CZ9hJPQ9+Ce2tczCaBJ3OqLgoA2seeAYOP3YL+G7nb8fwz/5KyMFaR4UQSSlvychNknV5U9ailBEK8Gwt3QnOxaE4nNJgXCL+t0yW425Br5+I5Z8pKGkUtcM0Y8B0TP82lmjonb6kVkiifte6Qoopb/nGdM6hrGb653ra2+OYW+6NCTjhFlDRK5NS7/06GuWbT1mLGAUO6DEEDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pesdI+jXJDEwkRLY4SLTNkhoIN76qXTPlwOt8rnWz40=;
 b=F8rqRUDbu6hE/bsDQSfKbqTs5RD9qcFpR/4UpE2rv/0a1c5lpXgf02HUfNQw1h7CvDtD+dyY88pNqIfa2l3/1yCA0dIaY7PC7f7NPduH/2gOMd2l/B90xv1MPDG9P7hY1eOt94ScrEvWVAedvVqaKh+HRaBRE5ZSme9YOl+gWGgRBUI0yDH+YF9SvsngLonuh9hCapUMVibMvFuS9PRFPXakOSz3wSEeRMZlIuCGb7F5fUGce8G7SI8LCddtDaqyyquVgJUCBMGSr6WjTDKkOeuZgYV0sdNRXhbJDD8BTLJtaTZd9L4n5dHxC8P5QZ58ng6tOyUm011+/3xDzB+bvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pesdI+jXJDEwkRLY4SLTNkhoIN76qXTPlwOt8rnWz40=;
 b=5MqXzkwUID11cP4zTv/h7yc5ijiPtzXLfjInUsf+LtTfHBWM0KaO7bK5FQtF2hlVz4yDE43QCmYPIR6sxUA6OmsK88BFY/SHbCTS0G61sR9EKmwNR+4z0KHG02TMkroZY97JmhCeMNCn5+mOJGM25uJ9QB7X+8izoIBPlaBhyk0=
Received: from MW4PR03CA0256.namprd03.prod.outlook.com (2603:10b6:303:b4::21)
 by DM4PR12MB8476.namprd12.prod.outlook.com (2603:10b6:8:17e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26; Wed, 20 Mar
 2024 08:47:09 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:303:b4:cafe::af) by MW4PR03CA0256.outlook.office365.com
 (2603:10b6:303:b4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35 via Frontend
 Transport; Wed, 20 Mar 2024 08:47:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:47:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:47:04 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 24/49] target/i386: Add handling for KVM_X86_SNP_VM VM type
Date: Wed, 20 Mar 2024 03:39:20 -0500
Message-ID: <20240320083945.991426-25-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|DM4PR12MB8476:EE_
X-MS-Office365-Filtering-Correlation-Id: b673c7bb-8344-41eb-8a7c-08dc48ba53d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P1QUQp+1dU8LQkFpAGhXjMeOu6SmEFJNR52WPgMkDqPLR0KcdcAz4pL1xEaHi7hgXMIIq34ROEdRycBEXtRl8cU198tRsQXrdpE1E3Ixs0DRLvfBunBFeK06BZP3IHhxLqLwLF6VNhOLI7fIe+TVwYHeUeZtFkTjB2SIf3d6mz5Yvc1n3r/AOLsuBSLvM0ktrA3i3KO1RHVKEQU+RKIixLomKXbJO+J1D9BkHh7ZWflvLM2DNgvqjrFzRYnW4BZC9YZMbfhSfzXGKLpRGMF8f+f9mYaF5ZB/NU3aQwKYdM1Z02OHaRIYu8wYvthdIZQ0ZO2q+BoWa5I/yKzJ2hgXL9w7cjRLypLoaGP7vnxWwP2ZI9CX4gdy0+GG9TSWBUVXLwRGb0iOMLnOnZjZ/nZOlPrghR57A89jlCw+5iXRCLngWuQ62lj1/5eu3G0dIrvTRNcVmDvv9PKWaQmNfbt3Kg6O8ahnVcFICVrskpIZtE8xEr8d6i+20VdAekssBl/841z/tOxbM/Jlw8nOqo4GBmMLsUFz7F2PYCNxvEhLFz8XxsWCK387vB1B488DE2yQ4UdJQ9V6Aqsg6U9D5Xo5DdaJyEaRfKFMWJZLAWtks6d00rZKYTE0dJN7c+Sq4N71D+Wv+0Rn/LwFsg4L8y57RtG+s1TCGqcdUYmOX+BMoxRJ3GcmYufZaXleGypzVQsTwP2LsqiC/UTivO0dtX84zQPJNiwzQvhOaBSm7uzh78ddaGm0Rz+mkTlQZCFArtLi
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:47:08.5654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b673c7bb-8344-41eb-8a7c-08dc48ba53d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8476

An SNP VM requires VM type KVM_X86_SNP_VM to be passed to
kvm_ioctl(KVM_CREATE_VM). Add it to the list of supported VM types, and
return it appropriately via X86ConfidentialGuestClass->kvm_type().

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/kvm/kvm.c |  1 +
 target/i386/sev.c     | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e109648f26..59e9048e61 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -164,6 +164,7 @@ static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
 
 static const char *vm_type_name[] = {
     [KVM_X86_DEFAULT_VM] = "default",
+    [KVM_X86_SNP_VM] = "snp"
 };
 
 bool kvm_is_vm_type_supported(int type)
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 2eb13ba639..61af312a11 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -853,14 +853,20 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
 static int sev_kvm_type(X86ConfidentialGuest *cg)
 {
     SevCommonState *sev_common = SEV_COMMON(cg);
-    SevGuestState *sev_guest = SEV_GUEST(sev_common);
     int kvm_type;
 
     if (sev_common->kvm_type != -1) {
         goto out;
     }
 
-    kvm_type = (sev_guest->policy & SEV_POLICY_ES) ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
+    if (sev_snp_enabled()) {
+        kvm_type = KVM_X86_SNP_VM;
+    } else if (sev_es_enabled()) {
+        kvm_type = KVM_X86_SEV_ES_VM;
+    } else {
+        kvm_type = KVM_X86_SEV_VM;
+    }
+
     if (kvm_is_vm_type_supported(kvm_type)) {
         sev_common->kvm_type = kvm_type;
     } else {
-- 
2.25.1


