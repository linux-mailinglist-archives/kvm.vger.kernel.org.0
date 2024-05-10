Return-Path: <kvm+bounces-17148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79EBB8C1C79
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 04:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F87A281759
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 02:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002D2148846;
	Fri, 10 May 2024 02:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EvvGTigk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F5C10E9;
	Fri, 10 May 2024 02:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715308662; cv=fail; b=RJ+WRIWD+LhuucPzMjO1wUC0S58BiVZdmH2mWPJ6rLlSMk8E7ppjyWSU6maBso0M40637Gxsz6Nq3S1cTroloud8MsBryM0KrjP3AIDEOdGlUQwc8hj+ZHyE3eg8sFbTs/99wKREVzltCuA+PtahgJKLi437KPt2/JNz+X7eBt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715308662; c=relaxed/simple;
	bh=SVhEphBm9HatbJVzmiJyOppxZm7UffmKJEf3IfqFicI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GrZ7G+COBX+IspyGWeqaxwCXP9jiGnJJ3tEtXhaOICCPK+qYuCStv0TgwUIAd5ZsGamYyoGjVb6y1s0ETNtIMo2B18ailoEugQ5mo4EmBe/ne+X0caCRAGOVHKNXbS+6CMgmH+YFfxs7H26rTH3NXaoCJDK+ikDlLM0yqPUMGLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EvvGTigk; arc=fail smtp.client-ip=40.107.93.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOmi7GdckC9/5tCpeFqf1WOzdbQp6UrMMaSH/Az9SeOMb1KKoL0burWOIiHp5qIDTjHPZFcIv8v96v6Z6UAJf7TGi5LkHl+E2uqq7xEKl3dXctV8Wcai8+JjEvXYBfW6vf5rO5+kiQA/lCfVqjvBoz1daCtHrnN1QmkUXKGGO9OJubZJw9J/ltxfnAmnzir7hjDvRhb9/ulj5Dv0+yYEvN7XaS+i5MjB3hdVPUsciLoyYoPT7q6WJk622QbVtj+wk33KXhdUXGRVvf+SfB3gS+CCLUbGEr+QsChli+CuDixVC/6b9mwiyG+RxLNQRXSGnY9hwr+a2Dn8eQWD0dV+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWgS+DI5R4F/sRW6PXtLiv7vQo8y0dnmJd23rQLEfgE=;
 b=VU1OxlKYRjP8x+W8XO4K7lsrofPYAB4t6bTFma+FbVaE1XgVI54/a6Cy6W3ZTwOD8p21g9CC0ZwWAWnEP6agOmImoNZh01CZ0UysTcct3+uNH3flc7ozVfPLOwzW4/5EOQ4TBIwMvh1uKOzWfOowEJIEADZkGU9V4p3baklfLclx8kPXzDyKaHMk5/IonQF6NMCi/49djlWi8hNV6mO9Qqrfgw9VbjGUyJ1nZj65WoQ+kTtEs6TfmrxgHTzGQr4CHOdkWk4x0UjXE08MZ/C68Wv8s8umA8Pu9RYklpfIgDgTKPByvKiJyP7TyLw2DqeoBmLGjxIDHovQeKv8xMTbeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWgS+DI5R4F/sRW6PXtLiv7vQo8y0dnmJd23rQLEfgE=;
 b=EvvGTigkA8t/4ou5BN8idWHGcDHK8XaPO3AOT0tb7FWeQ+f0nunBRayzXHZcLvlwOdOp3W5Y1OyoqHdoc6KzBJJRMbQpMb7WhTdzTZPUMc8S8yJrEI2w+cAeKp+DXFKRAUNcX/75mrG0FzXCN//ska02D6vb6ATAxMlEYisSA+o=
Received: from BL1PR13CA0267.namprd13.prod.outlook.com (2603:10b6:208:2ba::32)
 by DS7PR12MB6093.namprd12.prod.outlook.com (2603:10b6:8:9e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Fri, 10 May
 2024 02:37:36 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:2ba:cafe::e7) by BL1PR13CA0267.outlook.office365.com
 (2603:10b6:208:2ba::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45 via Frontend
 Transport; Fri, 10 May 2024 02:37:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 02:37:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 9 May
 2024 21:37:33 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: [PATCH v15 23/23] KVM: SEV: Fix PSC handling for SMASH/UNSMASH and partial update ops
Date: Thu, 9 May 2024 20:58:22 -0500
Message-ID: <20240510015822.503071-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510015822.503071-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|DS7PR12MB6093:EE_
X-MS-Office365-Filtering-Correlation-Id: 335743a1-5c28-4db4-c211-08dc709a26e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|7416005|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ji9kjP+Eq1LF9eb9G3BxQsLbHLCm2T30G8yPBcHserdQdY3gJ9hTBVl1iIft?=
 =?us-ascii?Q?Sdh87C42c7PFnlV+hfPPSJBxZgTPihWFG2VorkeaDKnrNMb6GiX9mRv475ge?=
 =?us-ascii?Q?S1JpDopmbRxzcZzdiNCrNCsw9OGncHlQlk+1LwYpXZRLy+pKoDnrlnPTKp5p?=
 =?us-ascii?Q?A9H7BGNdyzyWjAl0S1ktH5uBFWZv+oOnHqzcxEUjQn9/t0JmEJoz63IEb6Yf?=
 =?us-ascii?Q?GfvEvuhaWWiZ5J0Oz9zKF086VApkDN+TmB3iNvdilMFD8DRNxAr1M1UKk9Ae?=
 =?us-ascii?Q?YGaYRl56ynT+OoKw1LdcdvzeglTprkJBGHVasysDdXpkwE8/t7SiWq+FpBd2?=
 =?us-ascii?Q?dwfipnE84UvZrrHQirVHALgpWS+95Ie3arpezZlpd6vPlQ36vprp799H9Q71?=
 =?us-ascii?Q?1lqhPM0iTze5tBobcfAcIF0mxDZDxk/KctE5x4ZIc4JisrPltlQCcbMV8ugP?=
 =?us-ascii?Q?eZZbfU27UnZp1gsg6zs9DwV5m8oAKLCU8KojPXsZrP0R77Ql0heuNwUa+Cje?=
 =?us-ascii?Q?FHSomFONRLZ2vpkwucQY2JfqO0T1XNNdn2w2hpmMCxgnKgoZvoRkB07Ww0aQ?=
 =?us-ascii?Q?tX0aRDzRo9LTtCaxJMkXO7JDd8WBO7exLz38jOFUR0jw76dbYuYv21XjaCJt?=
 =?us-ascii?Q?nKLIZ3smTXxDDp1DZLMSkLRMzntOqE28w6mP3DawNQa+Lw6nrcp+jY9MuSRV?=
 =?us-ascii?Q?kZEQk0SL3skXNRzAeWaxTdAve3dW+EPQqrEPd601ddeTb2/wlL4LICWOwoKC?=
 =?us-ascii?Q?Qzt8wliWG2dhAPs18qMNZ1tRC0Ol0/8v2JH0B+H01ycnV7RIQJLwG4NdnR98?=
 =?us-ascii?Q?A9riidzb8swfSfsaxATw8onvmCwgVD9tk+Sq/GNkKknvyd7iYg/URDLo2dYl?=
 =?us-ascii?Q?zhjJa4rzltcfR8Bl7FBQBjz3UeYUv5NJZppahfJYbkYL9/399qL+4CGuL3Uk?=
 =?us-ascii?Q?3gNZ/yrgQ/RG+ddAvqBszumPjeTEdCQHj+ztOyhTqwD3O/Fmn++Eltd72c7b?=
 =?us-ascii?Q?tHJc59WcQLeQGiqnRSE6dn2+J2CNxTNk0tNFBRyJWZUCeBqomVCFBlEHz+Ke?=
 =?us-ascii?Q?yf0gE0BNryeaUYdxl6M5qhorHYeoyvzFyA4ugd9BhKC3XuqnlmykaxEL1Fg4?=
 =?us-ascii?Q?0lUzlLoK8nWWSv4gO7xFop+OhIAzCDP9iI539inaLXoG3+35gRTBDZtlT31L?=
 =?us-ascii?Q?lC3hnuAE5PQFG9CqdoHQOXg2ewahDA6j0FqGz2TZkUrW5F84VkoQPogz/1Xx?=
 =?us-ascii?Q?tMZX/5xA8SAt2FIC6kmMitzmZLu9smM+tMuONfjE1eaExIxeNW7Fhv5obV8O?=
 =?us-ascii?Q?Cy53HjWVZO297V1RWUosdGWdMdCoN6AvWvOrQN3OSIvTAyRrdRtG0RPO//eT?=
 =?us-ascii?Q?WlX0rCOxnJAlokjv4lveescM8e1J?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 02:37:35.9205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 335743a1-5c28-4db4-c211-08dc709a26e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6093

There are a few edge-cases that the current processing for GHCB PSC
requests doesn't handle properly:

 - KVM properly ignores SMASH/UNSMASH ops when they are embedded in a
   PSC request buffer which contains other PSC operations, but
   inadvertantly forwards them to userspace as private->shared PSC
   requests if they appear at the end of the buffer. Make sure these are
   ignored instead, just like cases where they are not at the end of the
   request buffer.

 - Current code handles non-zero 'cur_page' fields when they are at the
   beginning of a new GPA range, but it is not handling properly when
   iterating through subsequent entries which are otherwise part of a
   contiguous range. Fix up the handling so that these entries are not
   combined into a larger contiguous range that include unintended GPA
   ranges and are instead processed later as the start of a new
   contiguous range.

 - The page size variable used to track 2M entries in KVM for inflight PSCs
   might be artifically set to a different value, which can lead to
   unexpected values in the entry's final 'cur_page' update. Use the
   entry's 'pagesize' field instead to determine what the value of
   'cur_page' should be upon completion of processing.

While here, also add a small helper for clearing in-flight PSCs
variables and fix up comments for better readability.

Fixes: 266205d810d2 ("KVM: SEV: Add support to handle Page State Change VMGEXIT")
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 73 +++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 35f0bd91f92e..ab23329e2bd0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3555,43 +3555,50 @@ struct psc_buffer {
 
 static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc);
 
-static int snp_complete_psc(struct kvm_vcpu *vcpu)
+static void snp_reset_inflight_psc(struct vcpu_svm *svm)
+{
+	svm->sev_es.psc_idx = 0;
+	svm->sev_es.psc_inflight = 0;
+	svm->sev_es.psc_2m = false;
+}
+
+static void __snp_complete_psc(struct vcpu_svm *svm)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
 	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
 	struct psc_entry *entries = psc->entries;
 	struct psc_hdr *hdr = &psc->hdr;
-	__u64 psc_ret;
 	__u16 idx;
 
-	if (vcpu->run->hypercall.ret) {
-		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
-		goto out_resume;
-	}
-
 	/*
 	 * Everything in-flight has been processed successfully. Update the
-	 * corresponding entries in the guest's PSC buffer.
+	 * corresponding entries in the guest's PSC buffer and zero out the
+	 * count of in-flight PSC entries.
 	 */
 	for (idx = svm->sev_es.psc_idx; svm->sev_es.psc_inflight;
 	     svm->sev_es.psc_inflight--, idx++) {
 		struct psc_entry *entry = &entries[idx];
 
-		entry->cur_page = svm->sev_es.psc_2m ? 512 : 1;
+		entry->cur_page = entry->pagesize ? 512 : 1;
 	}
 
 	hdr->cur_entry = idx;
+}
 
-	/* Handle the next range (if any). */
-	return snp_begin_psc(svm, psc);
+static int snp_complete_psc(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
 
-out_resume:
-	svm->sev_es.psc_idx = 0;
-	svm->sev_es.psc_inflight = 0;
-	svm->sev_es.psc_2m = false;
-	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
+	if (vcpu->run->hypercall.ret) {
+		snp_reset_inflight_psc(svm);
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, VMGEXIT_PSC_ERROR_GENERIC);
+		return 1; /* resume guest */
+	}
 
-	return 1; /* resume guest */
+	__snp_complete_psc(svm);
+
+	/* Handle the next range (if any). */
+	return snp_begin_psc(svm, psc);
 }
 
 static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
@@ -3634,6 +3641,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 		goto out_resume;
 	}
 
+next_range:
 	/* Find the start of the next range which needs processing. */
 	for (idx = idx_start; idx <= idx_end; idx++, hdr->cur_entry++) {
 		__u16 cur_page;
@@ -3642,11 +3650,6 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 
 		entry_start = entries[idx];
 
-		/* Only private/shared conversions are currently supported. */
-		if (entry_start.operation != VMGEXIT_PSC_OP_PRIVATE &&
-		    entry_start.operation != VMGEXIT_PSC_OP_SHARED)
-			continue;
-
 		gfn = entry_start.gfn;
 		cur_page = entry_start.cur_page;
 		huge = entry_start.pagesize;
@@ -3687,6 +3690,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 
 		if (entry.operation != entry_start.operation ||
 		    entry.gfn != entry_start.gfn + npages ||
+		    entry.cur_page != 0 ||
 		    !!entry.pagesize != svm->sev_es.psc_2m)
 			break;
 
@@ -3694,6 +3698,25 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 		npages += entry_start.pagesize ? 512 : 1;
 	}
 
+	/*
+	 * Only shared/private PSC operations are currently supported, so if the
+	 * entire range consists of unsupported operations (e.g. SMASH/UNSMASH),
+	 * then consider the entire range completed and avoid exiting to
+	 * userspace. In theory snp_complete_psc() can always be called directly
+	 * at this point to complete the current range and start the next one,
+	 * but that could lead to unexpected levels of recursion, so only do
+	 * that if there are no more entries to process and the entire request
+	 * has been completed.
+	 */
+	if (entry_start.operation != VMGEXIT_PSC_OP_PRIVATE &&
+	    entry_start.operation != VMGEXIT_PSC_OP_SHARED) {
+		if (idx > idx_end)
+			return snp_complete_psc(vcpu);
+
+		__snp_complete_psc(svm);
+		goto next_range;
+	}
+
 	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
 	vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
 	vcpu->run->hypercall.args[0] = gpa;
@@ -3709,9 +3732,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 	return 0; /* forward request to userspace */
 
 out_resume:
-	svm->sev_es.psc_idx = 0;
-	svm->sev_es.psc_inflight = 0;
-	svm->sev_es.psc_2m = false;
+	snp_reset_inflight_psc(svm);
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
 
 	return 1; /* resume guest */
-- 
2.25.1


