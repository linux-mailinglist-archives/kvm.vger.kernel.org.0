Return-Path: <kvm+bounces-15431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BF68AC079
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B2462813CD
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02173F9E0;
	Sun, 21 Apr 2024 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JUBGz3yn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895203B1A2;
	Sun, 21 Apr 2024 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722717; cv=fail; b=LG28joNEkOhY1MwdU8NP1yffI9r95Nd0gKrIzJaIah3vJohSADHOfu829oNMsTIfifMBeLk6NgQvOX95FrWGAHxnGWz69cx1T8/bm9jU2gSFyhXr5Sd5LIthThYEHz3cap8zI+Opqw3i8kb5lDPQj+0e5v2aFUF8C74gh6KwxxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722717; c=relaxed/simple;
	bh=RFAUDHY5dfoT8M1Vqc6cEXuTw22XLAFaog+IfYtsVnw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V8DjGNHfsNxfBKpwVjsKYcw2e17R5svg3lg1mKGqeFwtXy7/dQE30bN2+G+POdZypmrAgLH301v1VW8033kIQywraQ2FFUeRqFXs2htTUH1t5WOV7ODXR7SfF45EF+gR4+KEQes3KOrZ0YrhiJYhg9UIJeuC8unNj08djlUEaK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JUBGz3yn; arc=fail smtp.client-ip=40.107.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBjZ3QC8SDBybSAmhVzlHDGLbqPoJc8wXuCW/O8zaYR7hEkP3Jtg7jAO6/84alpNoVVryAjJ593PKgWjcKiPpsoaUYZQuG4iBg5SBwuPeCrBpT0hRRkU7rH7FbiDQB64J8T7A9vDZ9HhO1rKWNjgLnfuxoaLS20rlMsObNx02qiRKgm4/a7mj9wG0fylkm7JiXM+o658kwwn0xfUy7ObRyRrFrN7sCEOplXq5QpP2llb972P/gBnNb7k4OgF+WeRF+FADPae7rQIEJ9d66+OcRt+MX/F2geHKEUBMUXJj2cYnZv/MooCqSisujv5pCoiXHgow2+zUPBdIirKhOfL3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DyFt9nWIzOZuIP2XGjP5mX6hVeYpS/HgXrectrvJ2BE=;
 b=WlaP6MJ5Jmt/9FWGy0iph5F6MyzbqHM2PFxN0FlkSDY9Zh1nNVVEZbo+dD61/8mZ7lD0HeQBi67C+DmHIbaHNJzc0WdB38WJHe3WmYIO0LiwRrEQvP0qEN8Ec8Cpgvxxs2aINqj0koknghGAO+Yli7L/g1JWYDyql/g4t4jpt3E3clVop5pTU1sfa+aQ5CPvzlt2KQ7OqwBKDcYEq4fkj/Xv8GiCFE/Z9RR4JxlUf/+Jh3cUW9ORVBuUvn3wYuFO9Rvf2juKCli75V2Cg0nQZhNPbrLvApg0wGTOADi1U6LZh+sc114oxNgbi2jCH3qcC1T9JSWCC9vZ9PbXVWqCsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyFt9nWIzOZuIP2XGjP5mX6hVeYpS/HgXrectrvJ2BE=;
 b=JUBGz3yn0UyWPXlBkY/i2i+UadOAdV98E9pVBt5t5GIwQ1cKtwJZS9URlL4Ib1Ti5fHwtUZ7FmhaEJy9LIzKMPs3rs998q+0rU6WvLCoAwst+1SdVj/QxaNYmAHRsgnSayXmxpjn9F/199PYY8z2kYfOPFYhDpMnhL/8q8mEwGU=
Received: from BLAPR05CA0035.namprd05.prod.outlook.com (2603:10b6:208:335::16)
 by MN0PR12MB5788.namprd12.prod.outlook.com (2603:10b6:208:377::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:05:08 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:335:cafe::40) by BLAPR05CA0035.outlook.office365.com
 (2603:10b6:208:335::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20 via Frontend
 Transport; Sun, 21 Apr 2024 18:05:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:05:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:05:08 -0500
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
Subject: [PATCH v14 13/22] KVM: SEV: Add support for GHCB-based termination requests
Date: Sun, 21 Apr 2024 13:01:13 -0500
Message-ID: <20240421180122.1650812-14-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|MN0PR12MB5788:EE_
X-MS-Office365-Filtering-Correlation-Id: 43f32f30-c734-43fa-bb81-08dc622d94a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Rye0CGSjcTyRvqP3pPVAmUv3PzdbYrPFKfaw1XMdA3GS8fu7b9AW6soMyQ9P?=
 =?us-ascii?Q?o8goq4997OXtvIU65DlU4RRuvSfcfsyauOESztJ/+k2waRd5APWPH95b1i/G?=
 =?us-ascii?Q?bVZZdGiHamlyD/F5IAeTACyJq/sXqUfm2/uM7v0+K61IVsM3Bm7avyJ2Z9st?=
 =?us-ascii?Q?AG6LPbCiT/PzFqQeBYVJUCdvG8Vx4Ngi1Vzd/gpZagHTdU1XmvpM5/AhcZsm?=
 =?us-ascii?Q?WyhSz7KBgCOjETYZv5VW+BgV6BghsF8ey9hWWF0TRIjbvx7kYt3SeXunHuu3?=
 =?us-ascii?Q?m6yM0LlFLu8AMJyrwZdFEVarP1JP1ygdWSa16lfQsBL1tGGHrFSM0zYdtbkZ?=
 =?us-ascii?Q?mQ3n7Kbr2NtwHyNH1YM3iBL+LrQc9SQxe5lkVfp9SZE4ImUD9DwK91Rdq3/e?=
 =?us-ascii?Q?bU4oxOCMVEj0I6c6tl0UhygMRFMHcWWLmcNuGr/mCQILDYgGndtHWC8u7+W8?=
 =?us-ascii?Q?8pTF79Y8f5+f0npZi8gpojG5ZM47T6cGlvOO44cRFaZVWfmrKQojiwcemoCZ?=
 =?us-ascii?Q?xUBgZW1uef4NzB/INiB39UX+4KwIJfT1Nos+yznRgXHE+z1k3rHnavYJRiUU?=
 =?us-ascii?Q?b60YTZnjISmEA+VkYxzoCQBnKlfie0qUeF07Kx0MLWCN9D52DiMudX5IJmaQ?=
 =?us-ascii?Q?Ghk3bdgf5FVs22ZvDdrWeMahCl7G7xpVL8omo6OadqqjqVnYknD6lcpIgyyJ?=
 =?us-ascii?Q?T0DupVqvECjILh07C4FlLgJWe0F5AkSteuo7SAEBX0UcEb0cQD2imwm1Pofi?=
 =?us-ascii?Q?8B+ImOBrOn5GtQ/F/Yv7Qx0uMMoe/QeOdldD4VkYWe7FGaTBn5ZlayKJ227e?=
 =?us-ascii?Q?ZTFqHpe2v9MSSzFolF5KbIpBAIoKnTaRPpUuBaTT+UTnNnxOxhTL1LaAt64c?=
 =?us-ascii?Q?REgNBLlfoYawwCRqaroPjXns7SoO7v2UoKilAPwZm4cDXOF1KPpdFOzt58wL?=
 =?us-ascii?Q?vNqhYQP9p30ybE6MI7DJeP2IK4P52PPgQtEO/EfW2dRHGn2jm4r2ztJdFhOD?=
 =?us-ascii?Q?BtdGGqgQgm9Zp7sMSHYmQkPcyLmizohdmT/zmRqbYJrAHxlacRf3rAJsaoOT?=
 =?us-ascii?Q?O2fuKOR1kntKXkxN2dCFHvNtT4sNH1Uhb8FSfqCv3nhjCMmPhaYwviII7owY?=
 =?us-ascii?Q?to1k2JkzS8L6CmVO+Gm8Te8wkHZVOSbsMPjKBfS+cIjIwV1a7ydrkiEbTAB0?=
 =?us-ascii?Q?+7RRapdZx3FLCR5YNx4xQGJacTKmRswOXQoqho2thG2a2LQ+chskJ69dByUc?=
 =?us-ascii?Q?DsIb0LKNzWlTO8ndpY7vIrFfE631YCD/GzYukPKCp2Oiav7AW7mUYkAy09UP?=
 =?us-ascii?Q?c6V7t7sXbcYD7wvBr8eMvu7RI80cdHZzbnQ1AWW9x9Y37S40mabpPazJ5Bdp?=
 =?us-ascii?Q?NA/IvrI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:05:08.6148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43f32f30-c734-43fa-bb81-08dc622d94a6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5788

GHCB version 2 adds support for a GHCB-based termination request that
a guest can issue when it reaches an error state and wishes to inform
the hypervisor that it should be terminated. Implement support for that
similarly to GHCB MSR-based termination requests that are already
available to SEV-ES guests via earlier versions of the GHCB protocol.

See 'Termination Request' in the 'Invoking VMGEXIT' section of the GHCB
specification for more details.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 67e245a0d2bb..1d18e3497b4e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3281,6 +3281,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3976,6 +3977,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_TERM_REQUEST:
+		pr_info("SEV-ES guest requested termination: reason %#llx info %#llx\n",
+			control->exit_info_1, control->exit_info_2);
+		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->run->system_event.ndata = 1;
+		vcpu->run->system_event.data[0] = control->ghcb_gpa;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


