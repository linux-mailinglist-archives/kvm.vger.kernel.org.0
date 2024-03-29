Return-Path: <kvm+bounces-13129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B711A89278A
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAE2D1C204F3
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0896513E02F;
	Fri, 29 Mar 2024 23:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xka1XG2f"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3712624B21;
	Fri, 29 Mar 2024 23:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753503; cv=fail; b=j3Z5XkIo/Jyzgx0FhX1SZxmzQnkYF1IIceQ3M53ahuSfsVtTHyM7Ip0lSQ1binhQGFj2+KtFLJbTflJL6lq06+75O120yDdJQobRJSzK9VzG/W/H8RR3n/pUo1AJXSaBXcxUzZPS9wVA5CLFskFKf+aVtkj1YX3iDNR6zB72mys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753503; c=relaxed/simple;
	bh=QdPmwA4s1bzloRrU7LfYk4aQuTetRlV4CB1Ei+KpTqk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HAfoSywigdYtcJ7RaTXDkdrSJhPoGvRf6xXScqKJuwdJyBNYkoaDr1xnnEwEelYxWjq5NaAaGykfzC07qHXzraHHmf+sK9nN9OPuRXLwMxpwxO4HIM5uCexEKWJmp0qJZ5qizvuWzqch3cAuip46FrzciDfYC9bWMIGqwySXBPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xka1XG2f; arc=fail smtp.client-ip=40.107.223.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXDibqk7audhSslyrWUhdymjwMsQlEzMG2y/x78y4xNKpoWOo827VJQzXPgB3c+qB00rBZuD+8AQtEw0y1+NAzeNqkxzyO7DRwb4F1yRvyPefna1MvPImOQkZ17YR6WNDIhBaNuMNIS13W+1fL92yZYZ6p8uDGRFTaVA7XDEDDtmgmTCVhILSOSJe0pfrm1f/omU/b0E0zuFV7qwxDHnWGDQofNvNc5i7d8fxmK6uRx0jFCCFQBuay9NHyxgKEbr8lXs+wFwHa0qmtCqOYG3PRcK0zObwfpfRkLCEotarKQBLEJpyEiLLpPr938eHuWUkPEu2o93zgUP+kHDWfTD2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKXbCNmvSryiI54Ff2uhgakSQGjXdl1kQVmeOpa0KZ8=;
 b=AC5zoY6d1lkApRPa1lIA34CEkDj1miK+dFwOns8Q9zQ4nFidEm8q2F9JaRWdPI4Sm6tcwUSySd3EbwxtztfjS8ZeF3TWaPICfB8Quq7U2mrYk/SZMGjZAz2S/4bJZvyagyWcrxpmf9jFUspVS8WIlmMnntHVrsIDoDQFBBqqSVU+vyN5L5l8VGkO44d8pETQ8FKLc+aEjvHgfHQ3PaX/7PyDT26nt4eiMw7g3nO+BaWX3ThTadRApqjTHubmUetlZ84kaBJygalxokWYcH/lzSJpTE6kzsTCznSrGag21iDcbxvQDwFA5RnpAG+GQ3RxU2CQO1EZVgHdX2/N9uO1pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKXbCNmvSryiI54Ff2uhgakSQGjXdl1kQVmeOpa0KZ8=;
 b=Xka1XG2fkRmyPtKz/8goE2vk8Rk5bg/mxX0s/WDaYPg1sDtMIDy5CC0XgY6CIBAL8tWodrDXP53P9LWeu8fDhqzVP37LGNZscib0/nqdVZjR1d11l1QmnEyHWfsrzL/ghq4KdZWatmwndh1wz029ZTn1PXi3gzHvNK4MQ0y4Zbo=
Received: from DS7PR05CA0099.namprd05.prod.outlook.com (2603:10b6:8:56::20) by
 DS0PR12MB8019.namprd12.prod.outlook.com (2603:10b6:8:14e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.38; Fri, 29 Mar 2024 23:04:57 +0000
Received: from DS1PEPF0001708E.namprd03.prod.outlook.com
 (2603:10b6:8:56:cafe::78) by DS7PR05CA0099.outlook.office365.com
 (2603:10b6:8:56::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.17 via Frontend
 Transport; Fri, 29 Mar 2024 23:04:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001708E.mail.protection.outlook.com (10.167.17.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:04:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:04:56 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 24/29] KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
Date: Fri, 29 Mar 2024 17:58:30 -0500
Message-ID: <20240329225835.400662-25-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708E:EE_|DS0PR12MB8019:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cb76b00-24f6-4909-fd0f-08dc5044a78d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yFOatBafXFkhfpYHUPmHZDL/5eabrCO0ABgx42kViRZOnMzg/BXECy3vh/VjAzJGuLMX0beyXKLfFnpVS/TpumRl/K/DpcTj7D+zhJrRsxIWQL6pkQcb3bJZFjHMcRah3wrMaaUP8l9oFVhLXnH/U5zfJHYxQGhrROf7qhSrIoZWt+A/TnZ+uNhOU0kjOP1Rb49edFVRyv8tltUrSfzs4AgDbgNKAI1FS9MWwFOmnUgdch6OObRiTzIz3GeCnOh9d6ap0HyWq2nZbm5R4YCHm2/uHpe9GB3sWnrqkbG9csxDlVfaAAVzME6l8/nHVPnK3GJB9m+2f2xUB0J+iJme0xxVycewahL5pOj8Zk6knIPS5NosPZJJFURpTSOeCbqWwN29zyAmYjy6b0xk5cUyFpitD5oVE5tp4RFdibQlDuUL4Na2hiIN23DzDEKlLhLCs8CME4B5GofrN87PZefnO67iJDl6smC2mC4NGdsdW/sLbp/OVkCHY5ZtqRDmq2b+U/gvpw5BDZ6STWD69bMKPvjYF1yXq4UPQmm9jMWIdzhKF+PY212DBX/tIYeQgy8H08ra6aCOVvmiQ+wsv7HnZo37qtMcbWZKPcOWQAq/ZTGxaE+c9xP9OB8oaLEoJsetF6W7CmwX5l1c8pvs9l4AMajJnf9Gone6DhYnOLAWk6/26TZpdy1sULtZClaq8YL6oz5sZkL4Ix+lh31M/W1Jmee8WYkF2UvDCQYEMLpyiC4jYAbiw+0LskdNQ4PI9JR1
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(82310400014)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:04:57.8085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb76b00-24f6-4909-fd0f-08dc5044a78d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8019

From: Ashish Kalra <ashish.kalra@amd.com>

With SNP/guest_memfd, private/encrypted memory should not be mappable,
and MMU notifications for HVA-mapped memory will only be relevant to
unencrypted guest memory. Therefore, the rationale behind issuing a
wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
for SNP guests and can be ignored.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: Add some clarifications in commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 31f6f4786503..3e8de7cb3c89 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2975,7 +2975,14 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
 {
-	if (!sev_guest(kvm))
+	/*
+	 * With SNP+gmem, private/encrypted memory should be
+	 * unreachable via the hva-based mmu notifiers. Additionally,
+	 * for shared->private translations, H/W coherency will ensure
+	 * first guest access to the page would clear out any existing
+	 * dirty copies of that cacheline.
+	 */
+	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
 	wbinvd_on_all_cpus();
-- 
2.25.1


