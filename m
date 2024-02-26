Return-Path: <kvm+bounces-10004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8C2868331
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01ADF28B0A4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405FD12C7F6;
	Mon, 26 Feb 2024 21:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XxymhIZp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED880134735;
	Mon, 26 Feb 2024 21:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983213; cv=fail; b=uGPiivmazHHAX1WPGjaEQ213fWAJyb5MFTPTY6Lrhgoy/c2ocAmQN3lMDi5R48d6LkjRJ0V63fLnvdlHiIG3mhYUbg8MTBLNi+rgXINIRAI4PIq5X8sIQ9ZBiWaiabD0lTwBgpqIpUoctgiYezEtCrQ5qEV6jbvkzGYjjrb8GAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983213; c=relaxed/simple;
	bh=ZzMR9NL+iOlvGkVw29tC6MVRLuXxqgXEExLmpq42p54=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sFlKlv7Xp2tkLvAtXBf7CGybfHKDZrrFsSCpLpqlhSw8fVOKuLfa1QNZld+pqn2pYLZXGXr45JOmPo5PPxy/VrD0F+Tok5koyCiwcMEu6cx6jsK0pW4SfB25ow6JJEyQjIPUgQWN5S74pjzIJh7jocSgIqWuvjccnPzlKrSdHl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XxymhIZp; arc=fail smtp.client-ip=40.107.223.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2Gob23UqdW5OMxmWTO19FRlBPg+ibCvl4i1zTn1Q91yoMe5Ij2hj/epn2J87hLdUJBJFdVb6UEerOGy/j3MR5sBhG7agtC5nDP2Y+V8x4lksK62xnp149hiz+AwrtW1I9ICkaxG7g4oVksxk6vGiSE+wVpkHIkBFY1dmrfdkfGN+IoS/29GsSuuYC4tUTuG802N2ZKPycMW9rNyLC9D1/imsUpKcm8uW9h72weRLrSlch74wxRHnJi32gw9eAf+QnlkT7ZnSXMJtoqgh8xFqz+H7er5pGDfwRpUQZcoU63f4vqKbtwfIzDuB9uY2jNkTV13ttArqH3Xkcwj/eKMnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3Gy8dugqKHWN5FieegfFCw/GVM0x8C+XZCNJ+OXsa4=;
 b=Sl/0M28Enm2vID8b2G8Gd/Lnr3E6pGMavlHvP5sgeeyMrTdgpJjAUPJsQ/XT8kPYMPC1WBiB4Rnx6xdjs101DJoE7BTdPvsp0MJvCnJzBACnPmlHKVp4RMKJ+PfH1+f+zhm7HnJA7D5Jcwkh9IFZhRUEmzEQN89Myvtl/SR3X/k7Aq8yvvKIv+XtOtwL1LamL4KA3BUywvdvT9WIPgk+uMwRdts69ubtMezPH1aWtdePWrhPytreq+tcpKpqKph1v9jEdvbBHUQvLVhbDYYAjlDdfaEUqvnSgRF+62J7dg0OWXr8WIb724gup55aiOJcgJF2aNhRW56rFVI+yx1J9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3Gy8dugqKHWN5FieegfFCw/GVM0x8C+XZCNJ+OXsa4=;
 b=XxymhIZphwHnaLDUSpmSJkfAWbZFs+4J9ZTh+eJZy2s50NlaK2flmd15h3VBZQMs37mUBBiDi63+cv8P8tzq05qMB2fZtp3UEp/G6HiElrdVlW5jo9cVAsJhfVxfQbKUdJCs0pyUCUd78JGvZhLKxFO75HYe8cYJNHYOrw7K5vc=
Received: from CH5PR04CA0011.namprd04.prod.outlook.com (2603:10b6:610:1f4::27)
 by MW5PR12MB5622.namprd12.prod.outlook.com (2603:10b6:303:198::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Mon, 26 Feb
 2024 21:33:28 +0000
Received: from CH3PEPF0000000E.namprd04.prod.outlook.com
 (2603:10b6:610:1f4:cafe::eb) by CH5PR04CA0011.outlook.office365.com
 (2603:10b6:610:1f4::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000E.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:28 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:27 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
Date: Mon, 26 Feb 2024 21:32:41 +0000
Message-ID: <20240226213244.18441-7-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240226213244.18441-1-john.allen@amd.com>
References: <20240226213244.18441-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000E:EE_|MW5PR12MB5622:EE_
X-MS-Office365-Filtering-Correlation-Id: 943d1a2d-3c1a-48f3-5590-08dc3712926d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yQcnWAN4flEY0dzcmXPSELz3HRzrrCYD6QUEsgP2EzN4tgPT8Gp8+4Y6VcMQ46rHF0ucV+aN/HQarbQ317gxJD0Q07QyRp7h6Id6n3ihE48u995UYEJYTatfK4bD9zG14jz2DVAfsZ9GgLLhjW6CPgDkJg1/SGPKeIlRF30/1u/h+Bit3Pukonl2kSH9WqVuchekZJhcoN88Yv46ZDHydLamWvnSsMHrWi5CmTX106hdw9vypPna1mBNeLKgSP4CVXpuZj5WdR4qmGDjzQ7RFWpguyuSHUqdBLU7TrtdzRIDmeNWBGVJkcEyz+GDjNsjOANirJ+LPuac5ZK0fr5AeIZrq3hKnyz8YivX5RIGCBCt8KWxGPmeU6gwfBOEnkCAzptzse+Ng7kjpRZv5zPryqxL/T7cztU1a3DF7QgGqQNbYcENZvGlbFE0qh4Oc2v+XOTg6ZRSiagIhN52sbi8ewz+9KremV7K3qsG2FLMwu3xzvxtm7hHYsA6XM7HoCcjXixPtiizr36FVyv11K/+rUE+Gc4WIfV7Iq9styc2yeq7NbBMywCxK4Qny819ebO2mVJyKr3Xvk7KFg1MCRHZZcmTdU/76ppypCiz+FsyuQx8yIpkyYnKvw7kojAX/Ut2oTOErBq3AHMXfMUDWf5csTytY1HK4oj7JfNGm+r92GN8RPCcmo5c2fyghEe9cFZhgHGaYHzNX+6lgd2Nuc7iChEJyK0vnj02DDYsHYaMifpdltauEKeHssZRH0OhIdFv
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:28.4720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 943d1a2d-3c1a-48f3-5590-08dc3712926d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5622

When a guest issues a cpuid instruction for Fn0000000D_x0B
(CetUserOffset), KVM will intercept and need to access the guest
MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
included in the GHCB to be visible to the hypervisor.

Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - Omit passing through XSS as this has already been properly
    implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
    accesses to MSR_IA32_XSS for SEV-ES guests") 
---
 arch/x86/include/asm/svm.h | 1 +
 arch/x86/kvm/svm/sev.c     | 9 +++++++--
 arch/x86/kvm/svm/svm.h     | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 728c98175b9c..44cd41e2fb68 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -673,5 +673,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
+DEFINE_GHCB_ACCESSORS(xss)
 
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f06f9e51ad9d..c3060d2068eb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2458,8 +2458,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 
 	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
 
-	if (kvm_ghcb_xcr0_is_valid(svm)) {
-		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+	if (kvm_ghcb_xcr0_is_valid(svm) || kvm_ghcb_xss_is_valid(svm)) {
+		if (kvm_ghcb_xcr0_is_valid(svm))
+			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+
+		if (kvm_ghcb_xss_is_valid(svm))
+			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
+
 		kvm_update_cpuid_runtime(vcpu);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0741fa049fd7..eb9c9e337c43 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -723,5 +723,6 @@ DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
 DEFINE_KVM_GHCB_ACCESSORS(xcr0)
+DEFINE_KVM_GHCB_ACCESSORS(xss)
 
 #endif
-- 
2.40.1


