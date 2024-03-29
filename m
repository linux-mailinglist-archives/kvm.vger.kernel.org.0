Return-Path: <kvm+bounces-13138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9938927AF
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 975A11F2327B
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7733113DDA5;
	Fri, 29 Mar 2024 23:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jkRRnu1D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE1513E881;
	Fri, 29 Mar 2024 23:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753691; cv=fail; b=rhUz10sMH7ysQ3Gf3nAAE6JGgLkVk25KxbcvNgEhCzXyouwOtEfvlSHFq+LSkokQaAAy296RKLa2TUsfA97gk1U3msLnziBMmgEIwHYcWCvlG6xqdvQDUSAxLlmDoM88cd3F3yemdfMxxyuvKnT6UOTFUXQhYuWe2uyIHhTt4Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753691; c=relaxed/simple;
	bh=9jDVCTXTRZqcYSVNskUgaXz92GPipcTW6IgD/uW1mac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JF5T15WcRsENYBRWz/bnASnHcbE5O1yDgB5vqFL+bfwT0BABTR+NpGZR0Tpajbsy6NSRtIiYljNht8pOQMQVTOSs/E52ln93T0Bgjgfdv+XIDza4w1gHeIaqX+yHxi3Q0ykzNtu22TfOdumr9ks1nrDh2q37Dw5lAwAgYb2mKDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jkRRnu1D; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUtAGVxi9a+ts2JGkAWzTY0Z9HMyUfil7JVHRilfxRTGdbqYqGGwz+kzafM8AD+prBKsMZrNIJj63KwK/8pYqFOm4gWv8XkMgb5tjNKZqzr5tXhvOzxhnVtAvuRV9wkJ5XvmUNVXHPRaju+HZi2ckqHjolOWLCwDAiToNVngCduezaaSTFt3wMP56tedOoC7kY7I2UCUYbwI97ci/YzIpCmYh8toTJtvTnl14EQTEEoQvLc7+ONaLK4PaMHmMtdUv3dgsZAMVBTkPTjAjAVk6R5hWV6bWZmCr53/SfJpXo5eOpTa5WqHrVSRpdphxD0bOZJH9HSsFKxAjeXSy3AkuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqo2lS93b7j+DN/B6gCMq8Sc0FgsJ2aUVuwjoiBOWCk=;
 b=kesMcNomOzCD8wqZFkS2enIgFeamc+kykphemxEX3JMHJu676AZwyzox6/BiW/V19xHgmH0OB8iiwL8K55oqBQZNzH4XxFYciwUhCPnv4bEOLcUlAaYI13vKCAXhZMTYzNWZ+h3AiDIcyYTHLjKTiVozFEh2fvch9VjSWuF2P+bT+mmTNr7SpfLLnv4V79nc9dhTkXgrGbbRAA+0lsrf5Q1ZGTuAkB15x1KH6NA3LsBNVa2GuArIphIuWgOs6mErx4XUxmCGvkSZiWKRjIUWEHz5Bq68FFZ2PJrFCFn1R+vV4JQrce1wx4MKOJVZ17UH8PqYGlNDeTHdOZntP0I2pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqo2lS93b7j+DN/B6gCMq8Sc0FgsJ2aUVuwjoiBOWCk=;
 b=jkRRnu1D2Ysa/HygOtgPBbzM7gvfNJqmDmrAulzQApdFP6eNtOMnH1Hkvp0hfjB9TdxpDWWTYRW3VVjPST3h64hYN5mu/EvF80cXXqde0LmB84Y6AEeXX5D1yVcfQaeue+34r25sBlK0+g3gd6h6okDybNuHuUQ1y0489StLXA4=
Received: from DS7PR03CA0318.namprd03.prod.outlook.com (2603:10b6:8:2b::32) by
 IA1PR12MB7496.namprd12.prod.outlook.com (2603:10b6:208:418::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:08:06 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:8:2b:cafe::c8) by DS7PR03CA0318.outlook.office365.com
 (2603:10b6:8:2b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:08:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:08:06 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:08:05 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 05/29] KVM: x86: Define RMP page fault error bits for #NPF
Date: Fri, 29 Mar 2024 17:58:11 -0500
Message-ID: <20240329225835.400662-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|IA1PR12MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: 61266219-2315-4a78-b671-08dc50451801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QJCgcerE3IBIz9iD7DlRFq/OFWVU6nZljgnZUoduNAJ65PlvRkEg8pU6FhMLW3AStZRrlYjQnurxfNe9sbAH1Ixqcs2jA3P5mB4mKLtCSao6d0TGt/TQTLXFnZnxdmgMhPBahgKM/ZYSXdGDys46w7ET7CUrzHmi95VSrqW9sCPFpQX9w07hpmfV7dBlNAShiSVRGqQstt9FkzU+A3mXTOSPIvNYBPl9CYEiAtNKUN5UMB34P46h5jEvS4aSKi4qPScerclkF0Bra54qbJHThxrMMz35LOhnnVSopvqhNFCtWjNLgvz5Wn5rCTpGkmJv7o/EiwocmHfZwgEGhlPKccvXql6G2M6qKc2tpymHWqULeYOUS1M20IJTszu/a7Xb8h/XE2v2hTy89JLPIXUZ9IWfRw8ag7K8WHAg11+sXj0t3P8cbm0I6xN24WbE3ak5YJnKv0q5V98PZLv43/Cpn6Xprakx5+5bs/f/OEVSxp85kyPETazI/tgnH+W6ufkY9Jq4S+4osEBUQUbo1RbD+L2M8N8OhYSqCuPdWuPBU3ut71vgOcrLNoEPPma81wCgI/yrtYzRQqsOvnnoxNd5jOWvUOtrAOwR/XrwNEfLFZ99uhViZ8tz7woCJ9Ytr9vGC2Sq7HIWPJwaLqikyXfs+EoFYUqjWD0vJO3p+MAaS3S0q7dtoJSwpy+veynVj736fGZcWFtQjfCp7mPgok7FcwztF6NGpLAjEXbjJWsW1tt5Ucl+MZFcLtiPu/8eCpEE
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:08:06.4561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61266219-2315-4a78-b671-08dc50451801
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7496

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled globally, the hardware places restrictions on
all memory accesses based on the RMP entry, whether the hypervisor or a
VM, performs the accesses. When hardware encounters an RMP access
violation during a guest access, it will cause a #VMEXIT(NPF) with a
number of additional bits set to indicate the reasons for the #NPF.
Define those here.

See APM2 section 16.36.10 for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: add some additional details to commit message]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 90dc0ae9311a..a3f8eba8d8b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -262,9 +262,12 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_GUEST_RMP_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_GUEST_ENC_BIT 34
+#define PFERR_GUEST_SIZEM_BIT 35
+#define PFERR_GUEST_VMPL_BIT 36
 #define PFERR_IMPLICIT_ACCESS_BIT 48
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
@@ -277,7 +280,10 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
+#define PFERR_GUEST_RMP_MASK	BIT_ULL(PFERR_GUEST_RMP_BIT)
+#define PFERR_GUEST_SIZEM_MASK	BIT_ULL(PFERR_GUEST_SIZEM_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_GUEST_VMPL_MASK	BIT_ULL(PFERR_GUEST_VMPL_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.25.1


