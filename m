Return-Path: <kvm+bounces-5388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2BFE8207DA
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:31:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22BBC1C21EA3
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7575C8F8;
	Sat, 30 Dec 2023 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yP9U/8Eb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B26014262;
	Sat, 30 Dec 2023 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUS/qVOuvtWZ2R5lSELKx4ZnSuHVf4wSTsqyE66a90YThJx8FAipg9aZ0abcDpxNTrr6uwPZe6E9Rw4Z+rmWo4f7rKQtvqI1oH4Ykjy7muio+ggekX1hlBOvrgq0K9r24qUGzszlsnzE8Vag0kwTNGrntDi5aFj1cxLQ5gNqX2hLCckoqA0lwBjzHDUuusTofpbQrmKJOMzL9hS2ZO1tCS9wqqFv3wfn4y3LsyZRkQQjjymwotVS3TZyqXFoq4FH18yZ0dsUz9D1a6tmssRz2ZAW7mcwgnVXJnKL7tHzz3on6qTixEcvQXWW+hxxMgKf3jrPolEdiKqq9VBGE0lwbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZLQXigzIBK5AyX+86qeDrc/89Jk6ptkw/5jLdrqHdI=;
 b=SWUZnJP02O5jHhPYfX6Ruebx0XJ7BsWzj3ngutUWceBPzcFdB/6pIVcrB2lKipMw59zhTO78PPAma3018AlwbXOikqDkrjkR5RM/QCpxpJVdj+3+Xf0YoIf1o7vIV7ppWxPUU4vTx/EIvYFSfJBNRiYgvpJTFmypi9bm6VhCUOgLaznuIYK0IOsPZlob6TzUFhZReIzOdyxGSnPbaI051XuES/OjmE7vZIa0fhsBf5XxqcS28EIGAx2hSgo4bKgXN3f3ONb5nVT7cCkbIzddtrZVxizNf+oKHOzasQNfXeibdr5I/2sgHu0c0O4Z1QumZj526VgeNgiHFcwhaP0C+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZLQXigzIBK5AyX+86qeDrc/89Jk6ptkw/5jLdrqHdI=;
 b=yP9U/8Eb9OsiTE95DwpiRMfj/AeA2XB6goVs7iWO51G7NW384KgXlyu6mAWoi2Cfv8+EHsDmu7aJegTPSSnjBsn3rfh6GSe/wM46KvgjFkOQyzzONOR8eK708yjPWyz6WpoKwlEr6UVuYzF+rv84cVSVJaOF1GnLo3o4gM+9Rag=
Received: from MW4PR03CA0267.namprd03.prod.outlook.com (2603:10b6:303:b4::32)
 by DM4PR12MB5231.namprd12.prod.outlook.com (2603:10b6:5:39b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:30:36 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:303:b4:cafe::ab) by MW4PR03CA0267.outlook.office365.com
 (2603:10b6:303:b4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:30:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:30:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:30:35 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 25/35] KVM: SEV: Use a VMSA physical address variable for populating VMCB
Date: Sat, 30 Dec 2023 11:23:41 -0600
Message-ID: <20231230172351.574091-26-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|DM4PR12MB5231:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ff53c6a-0823-45d5-cd2b-08dc095d0903
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pOMFAFa3q9xDAeE4FPEgGPjsHwnUCEAh3oRgMAPQiS7EyD7XKE/dFQ6GscwRKLgNxGi7BEwECkfK+iZ63P2uKXQJNOf2mJaCjivLJTRAJREhDu7avYQIy7C1BzT7hWG1wKmXRf0+/kcPunStAoMetwW3m5WBXToR5SsZhw2WsMKhwh/b1ya0Nia+YB4S86CBOdz5FOk6ltgJInE6aBCSlGgc8mUeISaNtGR7n29N+GYC1Y4QThweWjbi/D3WQII4WrD4lAHuwnw9jI4m7Db+LXwFIsZhDmFG5wnRQKhtbBO73DzwVQUnxuys8L4WNNP+dj1GE9X/PLDfoZMMDbJRsJDbYtmjiCn3CaBjaUtpmeH1hMh1ReFqQEbGo7xzlR/jIpAzvmBSbQ+y9DYtToFn1qFjOPsChe2jEW5E4prde7PWBom9rGYancFSnHFVlvpI9c/n0N6THLFnRgU4bkqigGGrRi80ja/WWUpHESamZXQKJkfMogxuNeG8/68EbiTgiydeOKh7FmKmZvQUK0PZwc6sUtZ+T4r6Gnc43gNFno92qCPVc0QVoNmUC9Rhhe7h+uYyhrneHJYC1scCw/P5bfknL3UvriT1g/yFlH73dXwfW1DS7Enz1bmYkWLYdMMJzr1i1bQBj5/tadoVhyd/8olU5R6rM443ChYh9+LU7ydukDtNFM3M8cgZfg9SJNqBPaCvT1R7VhmeQcxcSsB3dWaS4tpHd4xDUYO9I+0Om4mHZ90n6K7XSihAgeXzKK7hxhtslt4/ubD4SNYgyqOssw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(186009)(1800799012)(64100799003)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(36860700001)(478600001)(40460700003)(41300700001)(82740400003)(44832011)(356005)(6916009)(36756003)(4326008)(86362001)(316002)(54906003)(81166007)(70206006)(70586007)(6666004)(47076005)(336012)(426003)(16526019)(26005)(1076003)(40480700001)(83380400001)(8676002)(8936002)(2616005)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:30:36.6057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ff53c6a-0823-45d5-cd2b-08dc095d0903
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5231

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation to support SEV-SNP AP Creation, use a variable that holds
the VMSA physical address rather than converting the virtual address.
This will allow SEV-SNP AP Creation to set the new physical address that
will be used should the vCPU reset path be taken.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ad1aea7f6266..996b5a668938 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3659,8 +3659,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * the VMSA will be NULL if this vCPU is the destination for intrahost
 	 * migration, and will be copied later.
 	 */
-	if (svm->sev_es.vmsa)
-		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
+	svm->vmcb->control.vmsa_pa = svm->sev_es.vmsa_pa;
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4367da074612..da49e4981d75 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1459,9 +1459,16 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (vmsa_page)
+	if (vmsa_page) {
 		svm->sev_es.vmsa = page_address(vmsa_page);
 
+		/*
+		 * Do not include the encryption mask on the VMSA physical
+		 * address since hardware will access it using the guest key.
+		 */
+		svm->sev_es.vmsa_pa = __pa(svm->sev_es.vmsa);
+	}
+
 	svm->guest_state_loaded = false;
 
 	return 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fb98d88d8124..4ef41f4d4ee6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -202,6 +202,7 @@ struct vcpu_sev_es_state {
 	struct ghcb *ghcb;
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
+	hpa_t vmsa_pa;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
 
-- 
2.25.1


