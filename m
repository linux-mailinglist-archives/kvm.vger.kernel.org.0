Return-Path: <kvm+bounces-5376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA0A8207B5
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:27:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8717B1F21D4F
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 723E014F69;
	Sat, 30 Dec 2023 17:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZxZCdnGa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D402514A8A;
	Sat, 30 Dec 2023 17:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XV0HuVHsBcxaHTzLmc0vQmdDu39G07TX/K3rXm1yIjRcZzMKMvcbCAsS7O5nuZbySAMABtsIrpO/h3cGpQkH5Gy65D5eBNmxEb1gbKoe9wU0x86xzUHTlkIE/b51DunKgMGyJ2Kmkh5SBJLvsuABGzEG9Qbq02mTWmgg9blzIBpCuw/Jy8Dz2yPdan2PckZyKSj+LuibSTrXFSEFIih/QjuqLyC5woPBLf8aqhe3V2gzANSoosT87seT/nnB7aQ4Bar2HpVUqP/ySF0R71WlqloqdKR5pV5K8KhhUJXIyi1l4IzcTM37G+lZ2or4r/M05f9Ovu+iuRUr8/WMV5cUDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cV0nolCtMFnjjNeXYaYl/BW5dCPmq0Y3knu7gIz0vWQ=;
 b=RSQGk4cM2l9/pq053im07F877vJs2raW41Fq4rhPLqsOKPFOgdlzbEMuf3kExmXiJHTF8hZdbvE3XQq6G39LcmVc9k7irkvxn8h/fp45V0uICpbdzH9gCVrvYijzjgYeeXu+zTPqGxu7/lhZgQ7kbsU5gAJ0nc9HXT7lbHBnVlAKnX3BLEa+4PQir0cuklnj2QzPnADUJlyVdEV4srtTkxvi4y+qHQ4ivj76yhzklkaW4oYbgBKYh0Uh4bPjh2qkXwXoyTLff4Sb1ZBHHauHMi3hfwiiPttDTs0huV2IiSIwBvYnZPwfPbaCb5HFzYOMiB2kLamSSc1N3vKExa7CEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cV0nolCtMFnjjNeXYaYl/BW5dCPmq0Y3knu7gIz0vWQ=;
 b=ZxZCdnGaG2XB/SFEBBWK/4xVostqgm/aLBHWiTEKkZQJtt3xxy7bm6Uqfw1ZE9ZMZl22+oNiszd+KmoGsYId9n4pqfADbUka0S1U0fAz+h7kwetVPS4qUMwj4tg2irYzl+qDYSMzt4ItJJ1digbwbv0zMJ2L+4uIwolxO5IYaBg=
Received: from MN2PR11CA0030.namprd11.prod.outlook.com (2603:10b6:208:23b::35)
 by MN2PR12MB4287.namprd12.prod.outlook.com (2603:10b6:208:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.28; Sat, 30 Dec
 2023 17:26:26 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:23b:cafe::d8) by MN2PR11CA0030.outlook.office365.com
 (2603:10b6:208:23b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:26:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:26:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:26:25 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v11 14/35] KVM: SEV: Add initial SEV-SNP support
Date: Sat, 30 Dec 2023 11:23:30 -0600
Message-ID: <20231230172351.574091-15-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|MN2PR12MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: e497ca4e-70ac-4851-296a-08dc095c73cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4ZL8RVOM1q/JgccwwXeRna0n1zH+Q+cexopfT28R2J2+iedZGqI6Uc8ufZaAoZPdBc2EXqden56beDAAlhvwwVGyS3cWw8+HB+IAzXRRKsyqQZKXBpVKo/3kCDxBdwXXPEpca0MHKO3LjKgHylcqNoUD08lekBI5XIaI7PUDpA1Q1Tb34GdzFONrKpVYibohvV24apiDHv9RyavEchnx+GZ7WM7hNkcNoktIIvN4AlRR+h3Mi7LatBUeJorvGAcRL2sFeYvQkcrxZFgcqwLA3pj/kV4u6bDP/Bbm3UGmB63UwROtqfF7XTi8QK475/fh2CSodVP16uZSGvNMQnZCX7G3GjXuBi3McQrWCwcNlzapEmfA6Dj3b9Tnk43//BIHfhkY5iKy/2Wv6WH2cAEbiE5g22qRpDgxcVGwAVj18bUMUyNYw1uDEbD6u3+RWPwF2Gsc0iOQOt5QWXTyt6Pp7rzrmp0iGFLTCCmEF16KeAe0WLVOiDNE+FhAb6I3BDa5WYykJ4/1VQY/B28mVNGeGqUo/4YrjjpGq/MoSO5sQ/Gd+JyKAxPxkE0cNV4F2119sqHsOFGQlSERS7nAgiISpsnuxpGxQRkDwgq5l3xKspTXa2nI+HzKp8BEI7bcLXtB7gWx6s+8+n1pJcUgeRgEGM+TXpjWyWBPG1umGNPz5nJbO0GbQ1rOcIwSOixh/pBiiCPEnJTEC4yMY24jezxcctSPSwypA+TxFBFcdPfSre2lcwc2VYFbF8S5D1nHIqK2na1zqbDqFFdzrUf4cV6GRA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(82310400011)(46966006)(40470700004)(36840700001)(2906002)(4326008)(8936002)(8676002)(83380400001)(1076003)(7416002)(16526019)(26005)(5660300002)(7406005)(336012)(426003)(44832011)(356005)(81166007)(2616005)(36860700001)(40460700003)(6666004)(478600001)(40480700001)(47076005)(36756003)(86362001)(82740400003)(316002)(54906003)(70586007)(41300700001)(6916009)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:26:26.3478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e497ca4e-70ac-4851-296a-08dc095c73cb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4287

From: Brijesh Singh <brijesh.singh@amd.com>

The next generation of SEV is called SEV-SNP (Secure Nested Paging).
SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based security protection. SEV-SNP adds strong memory
encryption and integrity protection to help prevent malicious
hypervisor-based attacks such as data replay, memory re-mapping, and
more, to create an isolated execution environment.

Implement some initial infrastructure in KVM to check/report when SNP is
enabled on the system.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: commit fixups, use similar ASID reporting as with SEV/SEV-ES]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 arch/x86/kvm/svm/svm.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d6e206d21750..18c09863377b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,10 +59,13 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
+
+static bool sev_snp_enabled;
 #else
 #define sev_enabled false
 #define sev_es_enabled false
 #define sev_es_debug_swap_enabled false
+#define sev_snp_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
 #define AP_RESET_HOLD_NONE		0
@@ -2189,6 +2192,7 @@ void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -2267,6 +2271,7 @@ void __init sev_hardware_setup(void)
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
+	sev_snp_supported = sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SEV_SNP);
 
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -2277,12 +2282,17 @@ void __init sev_hardware_setup(void)
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
 			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
+		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
+			sev_snp_supported ? "enabled" : "disabled",
+			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
+	sev_snp_enabled = sev_snp_supported;
 #endif
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d0f8167ada7c..a3e27c82866b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,6 +79,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool snp_active;	/* SEV-SNP enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -341,6 +342,13 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
 #endif
 }
 
+static __always_inline bool sev_snp_guest(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_es_guest(kvm) && sev->snp_active;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1


