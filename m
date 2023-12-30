Return-Path: <kvm+bounces-5395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB9038207EF
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0A811C2235A
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A05D5EAC3;
	Sat, 30 Dec 2023 17:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vfs8TFwA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3AD14F89;
	Sat, 30 Dec 2023 17:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmR7SNIieKu6JBk8zJ9kADYGl0G7f0fSYuCVBNGMeIWB4iS1EkaL1nY+rGhOT8wxsVUtIJ2HyxUbQtVFgTrQeBt2MZV8/DRKFqVl2quiKD9pIGgFm+Pop59F3pZIuQVNZNl51fPaHjah+wIJBXr7duxMHfz6Th3XzqURzlW8Y/Ly0f6sodH9KH3SMe03ip0LnQbIuh183d9CkxSFg3PSCxOm2rA9V0UrD0QM+hWximE5xkFBOAzO+hfkEDgaVnaAlg9hM1rcYzXgXTgOqZvpF2GP2SijBSM8haJxcQ5kGZbgk+1qVVxCHux7r1E5FW2cXtN11AVOrZe4ba7XYMndpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HMquHRfJhztWwAGw0aEjpzQfmonSkbdg6a9RKxKNMiY=;
 b=dbVeOajYY++Pzfc9g6eOg8zVkR6bs5vlbwb55Qy1zZzs45Mp7OVEXPPt3k8hPfu321a1ddt+zjWZ/bo1sXPImfmzeXJDD8m4VDZ1X9TvV33HRXOoYcicoMyuludLpxbrKPXejANgEOanA3ObWvoIXdWi4jNAeqXQJOxue4sSIYiKYcYxSfQcA2SH0Hi6rpSHvc77bRBB2MqbY8avJtPuuYs8vbqqzjoM81TcZMp13YWtx3Yb9FyLjfyU8UWpVzflRxpSIUUdOpKMjENtzi3a18xHnOGQIq3Z4Lrq1nf+WPpGfOD/rUePe32rM0HziVn/slyGB7m9aJ1C2yalz0G5AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMquHRfJhztWwAGw0aEjpzQfmonSkbdg6a9RKxKNMiY=;
 b=Vfs8TFwArqDodrhXSrJKPAEymSSPDwm2oaWkmestuJLWA7pP8rcOu8LJoEcMcfW9bJjegzi13Fj3IzLnVYSBEzb0P4X/1bK0g2HEV2HgtyRv6YBIrDuXDGemO8TexXFKbPXEebDEiLBlihjV25bLxZSuQuwE32CfxXuZT1PD/Ac=
Received: from SJ0PR13CA0147.namprd13.prod.outlook.com (2603:10b6:a03:2c6::32)
 by SN7PR12MB7023.namprd12.prod.outlook.com (2603:10b6:806:260::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:33:03 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::e3) by SJ0PR13CA0147.outlook.office365.com
 (2603:10b6:a03:2c6::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.7 via Frontend
 Transport; Sat, 30 Dec 2023 17:33:03 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:33:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:33:01 -0600
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
Subject: [PATCH v11 31/35] KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
Date: Sat, 30 Dec 2023 11:23:47 -0600
Message-ID: <20231230172351.574091-32-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|SN7PR12MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b946496-a297-4964-53b6-08dc095d5fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uEUopIA+zJbIY2GCNfUFFoFgv805NV4/uVaDPWHvbUIqmjDmNrCzVxy5We4nxV5616O0BQT6GZn1j3o64VVbFDe6HsUiOqhv/egyRbQhJ+MgMI0W0xUPhZe0f2W7tPbmX8TdjAZ3jZkObO+EUbLmhE36FBqvPH3ljbUyMoQLZrVfw+lWWZGGtQaHn+Y+54tw+iliOKeqULiiHCh38Rgx1AexEeoX/17y7EACmgMFcchPcrlFuNBbA7yFUquHx+7ulvMKiAXADSTX1gbJPaqgEjWp4oSJjakc5qa+zEcoTqSydYUZo5nBeQ6VEn0bK2Vcw/wiQZb09xlwRWbZiBfUfvxU6TrjsH1lL/3RcGml0lQKjzNHqrY45sDpAGV7oQeYWxRLsVTsrNx18HykhQMuoWBlHlCU3xD/o1dl6SsW+MWY+3GF0IJPQbPSb3uGx80X4jwGTHNIchS/gwKAC46vm2Xv/N/EeBwNYR5fTS+jMRMNf+J5MEr9o24SCqk9G++e34PouTRBYXgvJCsVSu9Ex4pSXrnfyJqVR7+VgnRQJSgbT6h5Iu7Ms6Ps4RXywDb4Tc86Dr4s26vRmPMSGCsfqWNBn3B06o9spSzgNeIaLQrD3wQ5QnJWFdotLmdNndM3Z/jdgQYy7kSVwuk2m3wDSzFKHZh3TBhBDOAj1zugf7zxEkWmjqSVVpB4HI+dS/Zn/zjZHN2CfnzcnglwCsU85I/woBrTkVTRM4vYBjpLQZat+BnOTklkiE+YwExyOTG6VNB7yXnwWvKxTJaVZLg9CQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(376002)(346002)(230922051799003)(82310400011)(1800799012)(186009)(451199024)(64100799003)(46966006)(36840700001)(40470700004)(26005)(1076003)(54906003)(70586007)(70206006)(40460700003)(6916009)(40480700001)(2616005)(6666004)(83380400001)(63350400001)(63370400001)(4326008)(8676002)(8936002)(36756003)(316002)(336012)(426003)(478600001)(16526019)(44832011)(7416002)(7406005)(5660300002)(47076005)(86362001)(356005)(2906002)(81166007)(36860700001)(82740400003)(15650500001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:33:02.3154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b946496-a297-4964-53b6-08dc095d5fdd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7023

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
index 5eb836b73131..2cc909cc18c1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2858,7 +2858,14 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 
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


