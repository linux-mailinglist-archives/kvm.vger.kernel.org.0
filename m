Return-Path: <kvm+bounces-15276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 042528AAEF0
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3D1F283B1C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8298185951;
	Fri, 19 Apr 2024 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Fa9Lmh8r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A087F46C
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531616; cv=fail; b=YE/Fa6jgyWdXplgGKoZmt+3R1y9WAARtxuWSGfMOLmjgG+IDpy8O/00SkhuHHuC+N4cdsyRZpE82EjYNXattTI5So8pp+FPNVCwkG71irm/wv83bJ9Q+47Md5GzaVaFhFV9qgr80JYioMYAdyY3LEhwWxJKcTppyVizr4/mB/M0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531616; c=relaxed/simple;
	bh=e3BoDNfcZKC4nkb1J/PGqqklcMilNM0SbpqgfMqA9j0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VtdUTWwgDqt7EX7LEyAJTUT9b2YwOElNzaB1tYpIIYSSlzIe4+tGNSFJHN0G9UHfbg9NawOZK4tpCsecMz0RjJRx5hi4qvqA8ELikzejTt9vowRfird3mG0kBT7N+XGi94SOtA+Epr641e4I/9O6imMFJ9wl0ZlmA3qCvSOSZ5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Fa9Lmh8r; arc=fail smtp.client-ip=40.107.236.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1ZoBGb/CGPC7w7ScMNxJEIYCKIfKQpAyUMz4OpBJ8OO8UK2XMFh01catpt9+A6dg4adiuzae/XUPBF+0UHs7mBitGMf8QAcXIFAC7yXsgOLFD1jvqaD1carGxGoUmkFPmx2305ZuoRkqOSkjY43seQbJJ2z5bSJ7aVoWhjfN0o87IkzyZJJS1cNrwgX9cbIXqVxMOetlNInD+bAk6RlWuWAwE/IdW/NRVJhe3xgbnf628lYDTVdvs3QK+N6xTzG03h3cGGsWwu7qKw60YYZe1OEQFuektCc3kghKAJg833pTmM4zQjNS0HwrL7Q8jO5vkpYCbtffWJlbItCaEiskw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NI4Ikc+Zpyy/Hxr76vLunfzfzuVVYuKCsGYrVazelU=;
 b=UwbcG6pBNEArv1PycuXGmC95SLR9P2sCwdXHbagZ1Ang72AijUrNqer4wD64ImYB6qmqDK0XDsUzfI+hzZqn5vLTxyfoTN1ZbDHaGSiZqAAMXt+71Jq48TRp+l8+7xPGcNth5zY8vxkpxrUQsY9Ea95v4DM6o50Tbxj2dgJd5SFMjuuM/+AvU67pWJrUtVoyBXi/KvsmJXKFIlKagzlLjX3389yaH1/T0wxT98MfEaNOV9f0OXEoB0b4mfsnY+OBgnINmoFOyJEzDJV//lIlC5XY8T8FBl6WwOXy3ScQJv2UfxRvJSoKISLkg9harooKmU7x+R78YOhh+mt37kQR6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NI4Ikc+Zpyy/Hxr76vLunfzfzuVVYuKCsGYrVazelU=;
 b=Fa9Lmh8rPZpvM35z1kuohi309pKladAAqWzbfpEzyOIz8IOl/BV2H6hbIi2gLR0q4w6MekVhG9efdE0uO0918frdGMrSSrxOKx8t5K1WHzoqPCA6pAKk5qpYgw1S/KLs6gJZJoPlpFjzv31HMbPm2Rbdy9IHSsQ/r+3QekowRS0=
Received: from SA9PR13CA0086.namprd13.prod.outlook.com (2603:10b6:806:23::31)
 by IA0PR12MB8325.namprd12.prod.outlook.com (2603:10b6:208:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Fri, 19 Apr
 2024 13:00:12 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:806:23:cafe::6a) by SA9PR13CA0086.outlook.office365.com
 (2603:10b6:806:23::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.30 via Frontend
 Transport; Fri, 19 Apr 2024 13:00:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 13:00:11 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 08:00:10 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 09/13] x86 AMD SEV-SNP: Test Shared->Private Page State Changes using GHCB MSR
Date: Fri, 19 Apr 2024 07:57:55 -0500
Message-ID: <20240419125759.242870-10-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419125759.242870-1-papaluri@amd.com>
References: <20240419125759.242870-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|IA0PR12MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: a5ef1902-0bc0-484a-44fc-08dc6070a61f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QJXaxwzKpRspbis1pzGZf21rngqcPlANzf6E0xIrbOq6bBH7ujPT0sJRXnc6?=
 =?us-ascii?Q?eM1oRHBKFMnIKCoYtOs1ZtgqDpx90QYQW0KoNGWSbC0X/YpXX4vxTXToj7ux?=
 =?us-ascii?Q?rY9V44eWgFrTuEsE9xm/HJ6rtXbRI7qW17mosWCmS1jT188yQ+4t1I80EqTZ?=
 =?us-ascii?Q?8Oem1XQBgPDZR6F6VrKbtekLDNUP5xlhVp+jRbhQKrfaUD8LhIaA5OjioMPw?=
 =?us-ascii?Q?CvGkVkD8SwV1/m8iaCVxO+qM0BIPI9KLxlL2EP3e0CSQL72E059T+2i3t1Xi?=
 =?us-ascii?Q?gXykKi6I87Ve03+NPXhmkcVLABiX8abQjT2d53+3/H2VX7yRN5LePL8fNSa7?=
 =?us-ascii?Q?FBWqC+5/syTO5B6FR+S9QqAro6p44VRIS9a8GEl8WAnAoosswvtSJ7L0xdGr?=
 =?us-ascii?Q?4MIZGjyxviZb0m2mvCuGKkIg6rdQzPO3JR1KP0/ruaOqo5giAKfwno9rBHQt?=
 =?us-ascii?Q?U+wbIB1bWqk3IlEPmX8ZN0NJUTWMkMUy4rAFNYjiBgahWb4SInax3HRfyCDz?=
 =?us-ascii?Q?PSoMfy6e11IcjaPM3GH11K3y1+9xid9TQyJ2RanMFk3LOOqBlPFGMNks4RPr?=
 =?us-ascii?Q?6GVQp7TOghSbPB+qJ7e9ekzmmEQPurH/WRbcO2ASR2GRc5cWr3lBBaeCKpgK?=
 =?us-ascii?Q?4QoxaoT9Bor0zQjAl/lH6QZ/AfeCxvhA7vH4tcZoWcaNRMqAeUUsuCywTdLo?=
 =?us-ascii?Q?MdmgGj5U0G1Ha+Kj36gGHJK8b62A+dZmSBQWV+OLH5t6iJrqT5Ct4ULB9U+Q?=
 =?us-ascii?Q?p2N/XOVL05fRoIyuCDfrZ/98FnfRSyy2B3q+9pgYdOo6w7c14ffChFenAbgG?=
 =?us-ascii?Q?Di7hxhgPk4rs6W0Ol+mHsKtDDD1+PNsm8hv8sCEAF0DWkJYEe2fW84tv3DET?=
 =?us-ascii?Q?7aLpMi8f5NF28f9TQjxmdUKNkyECrj87J1xWCQledMgLx0Ni9ZUHICAeJAIl?=
 =?us-ascii?Q?HfUOOATHIVj7Il2hw/qFZuyHBskHero98i4O32voMg0VkAejzABF9ozaET8W?=
 =?us-ascii?Q?INm+5irdBbxkSbH3JcvCi+4Lm3K+ns7JeHST4+aT6pOS+40JEYr7Hk7j3O2F?=
 =?us-ascii?Q?hMT76HFMY6FMryVSu+orafCKDMxm833Xpf6UOLc1RpT8pB7Gsm+G+ADVdiSm?=
 =?us-ascii?Q?whuZQ387m7bUa5BmZJ76lAvdLSK6EyaBlMcbFRDTCp4kHeBqQx8/85uz7ONn?=
 =?us-ascii?Q?BZM8mxc1oAH0E5gskTD9yNaZ7HIPOHD/VmO0k+Q+8ui8tFDfYtCot1U4F774?=
 =?us-ascii?Q?/tOMPH5DcwdqVe7r9GD06QlJWYGUl/RbRchEl0xiGtuxgROttuXohtvWSQ3S?=
 =?us-ascii?Q?dar4Ws7WxHPs0MQalq79veWpnfJGJAvMkuIMrNJ5nLLlqeyOUUxsKkHjFYRG?=
 =?us-ascii?Q?eZ/ZMM8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 13:00:11.8032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ef1902-0bc0-484a-44fc-08dc6070a61f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8325

The SEV-SNP guest VM issues page state change requests to hypervisor to
convert hypervisor-owned 4K shared pages back to private (guest-owned)
using GHCB MSR protocol. Guest then issues a 'pvalidate' instruction to
validate the pages after the conversions.

The purpose of this test is to determine whether the hypervisor changes
the page state to shared. After the conversion test, issue a re-validation
('pvalidate' with validated bit set) on one of the converted 4K pages to
ensure the page state is actually private.

It is important to note that the re-validation test cannot be performed
on a shared page ('pvalidate' with validated bit unset) as pvalidate
instruction will raise an undefined #PF exception as the page's C-bit
will be 0 during the guest page table walk, as mentioned in APM Vol-3,
PVALIDATE. Therefore, perform writes to the shared pages (with C-bit unset)
to ensure state of the pages are shared.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/amd_sev.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 71d1ee1cef91..31d15b49fc7a 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -206,8 +206,28 @@ static void set_pte_decrypted(unsigned long vaddr, int npages)
 	flush_tlb();
 }
 
-static efi_status_t sev_set_pages_state_msr_proto(unsigned long vaddr, int npages,
-						  int operation)
+static void set_pte_encrypted(unsigned long vaddr, int npages)
+{
+	pteval_t *pte;
+	unsigned long vaddr_end = vaddr + (npages * PAGE_SIZE);
+
+	while (vaddr < vaddr_end) {
+		pte = get_pte((pgd_t *)read_cr3(), (void *)vaddr);
+
+		if (!pte)
+			assert_msg(pte, "No pte found for vaddr 0x%lx", vaddr);
+
+		/* Set C-bit */
+		*pte |= get_amd_sev_c_bit_mask();
+
+		vaddr += PAGE_SIZE;
+	}
+
+	flush_tlb();
+}
+
+static efi_status_t sev_set_pages_state_msr_proto(unsigned long vaddr,
+						  int npages, int operation)
 {
 	efi_status_t status;
 
@@ -226,6 +246,16 @@ static efi_status_t sev_set_pages_state_msr_proto(unsigned long vaddr, int npage
 		}
 
 		set_pte_decrypted(vaddr, npages);
+
+	} else {
+		set_pte_encrypted(vaddr, npages);
+
+		status = __sev_set_pages_state_msr_proto(vaddr, npages,
+							 operation);
+		if (status != ES_OK) {
+			printf("Page state change (Shared->Private failure.\n");
+			return status;
+		}
 	}
 
 	return ES_OK;
@@ -358,6 +388,21 @@ static void test_sev_psc_ghcb_msr(void)
 		       1 << SNP_PSC_ALLOC_ORDER);
 	}
 
+	report_info("Shared->Private conversion test using GHCB MSR");
+	status = sev_set_pages_state_msr_proto((unsigned long)vaddr,
+					       1 << SNP_PSC_ALLOC_ORDER,
+					       SNP_PAGE_STATE_PRIVATE);
+
+	report(status == ES_OK, "Shared->Private Page State Change");
+
+	/*
+	 * After performing shared->private test, ensure the page is in
+	 * private state by issuing a pvalidate on a 4K page.
+	 */
+	report(is_validated_private_page((unsigned long)vaddr,
+					 RMP_PG_SIZE_4K, true),
+	       "Expected page state: Private");
+
 	/* Cleanup */
 	free_pages_by_order(vaddr, SNP_PSC_ALLOC_ORDER);
 }
-- 
2.34.1


