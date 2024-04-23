Return-Path: <kvm+bounces-15677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D478AF3E3
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F069E1F24E40
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C7613D522;
	Tue, 23 Apr 2024 16:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xhg5CJpY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C4C13DDCB;
	Tue, 23 Apr 2024 16:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889435; cv=fail; b=s9fZzrTDo7oSPEs2mUd28C1/kzIis160LXbX59w0+cy6EOfFqiF5j+kvjclhxuvA3FVbaJPA5opLFjz/PcW9OYWAYB7HCMsCTA+F1CvWHsD8rMB1JkUbHILLw2Qimz1/gPh3R9Q7rUQRUpBHSBwddGqOiohEeM5qjWNu9JFn89o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889435; c=relaxed/simple;
	bh=OdTyCTLp5S1scrlfS6SsPoLNAcdeKotLZPehcAHzCIY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hS5T1cctqioFQDweo57o+pna1F+50InFgt5r2qk5geLYC1BxejHWepjsbbtv7N8X/08vLMGEI4OW2eYNcfIwmnlsdHBEPW26tiNRcESfnvCXYzsoQoAPMOMwgebhFyIs8XnJAyeMCd7qNzlKZOeDqvuIWMyu3veHA4MqjLFaBmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xhg5CJpY; arc=fail smtp.client-ip=40.107.220.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbCr9Gb/gRKAYFxDyNXxzsWikQzcWcPOEkvFAlHYTKuQ37litzimRSdHcCZO1MuSz+beTGGYLyKhuhwbTxlbYgbMJUnc8qLwMuyr68ROH02VT3hJs3a1QL38p2/lP7fmfwTj/HuETEl7tAlYuXwK4DH1BlJb33pHJ/L7krWX/Qi6woHH/X3UNxHFeFZtqyiKrNVwec5+73WX7vN6Z5xvnw2DAQBj8d4Cen606gP7hB5uw0qprebw6H6bxHA/hgJmbejRkOC5bY/b0ecF+FpswmylJStc4Z0K4jDCdc5SsW7bQlNndz6Hyiu6nej68Xja/I4hWSWHWFksl71yaYXTpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ukt0dfh46WsP7kqfOQpXbL4+TBUFfUgpVFR7pGR/JeY=;
 b=klEmjiaO5cFsupyE2wraZK6qVYu6atuKSBnfXfoLeaH0lXwWNUNpo6wMMIsAG7BFfU0jrvTUQfiZ7dpnd9+eWnRlkdDPfEdpfoVjhosApv+xh/2OJqDdur93UWQslrn773dj8KR3hrWlpXFNmDXJF3EcfmyfwZiTEUCQPZMwnmU7pfM6fNPPgPorifVrWeDYuuKWKa8H90yCiH3uZYIwGW6JQeVG06AfAy50hX+jwiwZL2hp2hPeBGZQkWVehFa67zDyefHHEOJ3jEoSAjM4dj72uDidMPlbn3ChVVHbdxmk22nz8qFcmxS+otTgvhhY1VPxgUj/HTQAuo1UmtjCnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ukt0dfh46WsP7kqfOQpXbL4+TBUFfUgpVFR7pGR/JeY=;
 b=Xhg5CJpY+rwam0zs5F0DtWoJ7yB4LDhAmzZsAm8D++I4i7GQKfXOciHlwByTlnI1Vle59Q+tafHc95Tk8ipNsZZaSLu7ONsJJYbR+OeVzEXP9D0IpEIjoSWQD4WNJjjqjb3QNepjXt376WleFsxEIgTcv1FlgFYPy2xZAXxH10E=
Received: from DM6PR01CA0025.prod.exchangelabs.com (2603:10b6:5:296::30) by
 LV8PR12MB9335.namprd12.prod.outlook.com (2603:10b6:408:1fc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 16:23:50 +0000
Received: from CH1PEPF0000AD81.namprd04.prod.outlook.com
 (2603:10b6:5:296:cafe::80) by DM6PR01CA0025.outlook.office365.com
 (2603:10b6:5:296::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22 via Frontend
 Transport; Tue, 23 Apr 2024 16:23:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD81.mail.protection.outlook.com (10.167.244.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 23 Apr 2024 16:23:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 11:23:49 -0500
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
Subject: [PATCH v14 23/22] [SQUASH] KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
Date: Tue, 23 Apr 2024 11:21:38 -0500
Message-ID: <20240423162144.1780159-1-michael.roth@amd.com>
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
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD81:EE_|LV8PR12MB9335:EE_
X-MS-Office365-Filtering-Correlation-Id: 56a7b175-1353-4317-f9f2-08dc63b1c239
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uFQyLsmnn3kfiH7YOz+EMM1mlUpUBgoxbW+pdJGm04Mn3eKQ63odTbFEidG7?=
 =?us-ascii?Q?EN2sB+djnnKQNugWcZSdzFUlPmaXunCWwerrZZxgq4znghgHDNpk7bdxObZ6?=
 =?us-ascii?Q?x9mexPmDb5VKxCXLYxYxkmA0Cy28ez+Id/oGvuCssaPm+IU45YHnbhgIBMby?=
 =?us-ascii?Q?36MAvJj9U1CWm14GNAXITlkSYPwaqsOf9RTWgFCQM/x+APu2DJMfzgepZWND?=
 =?us-ascii?Q?m9NPrN0MRjw/irGKbRWEhS3xQzbnOV9UITldpL5Jv+r2HqlkTsvYOBwHzPs6?=
 =?us-ascii?Q?j9dz9E4xn6aibTK9gc6J5i2nRQdQIc6p5J5jHC4nFDkQLtMryQRNmPZ45bpk?=
 =?us-ascii?Q?mNzXraLwWD0s36lCf7A5DPHRcAQPdjXbqUziehCL5qOEIPRJ85tM5jo9s9yA?=
 =?us-ascii?Q?AXHic5VmzKzvo23PnNNI7DzYqbFENyPFJ4a9+lxDJb2e0J+orXglgExl34Rt?=
 =?us-ascii?Q?6n1tnTJUhKMvmYgbuf5UlPGE76/9VX6hjT4Ciqotb6xx38+nHgfUKUDL4K4g?=
 =?us-ascii?Q?VTExdaQeVtcEbz7NsCAMl/7SpOPpgbSh8Jd87FkuQwx4B4RB3hgbswMKT2Jb?=
 =?us-ascii?Q?nL/TfYorKyuWf5nZUey9X9dTn7DtXCnsr2INcM7N6vJMNnphuNEXgZAyB7cl?=
 =?us-ascii?Q?Wr8fdohygVyROenkS3cm9XobuYQu6L2QU20pB78SSvSpK7NjzfnZYFdd5tS0?=
 =?us-ascii?Q?3gvYiSXF0/vMpTVDQIc4Sg9nP0JK2YUJtx8YjNdLTeRN6GaPprqjc5slgnyC?=
 =?us-ascii?Q?RxhHFXFVq4GFhtRt+E4X0Z3J+Y18+ixJUdwZshLCpMyV7G+7LSkV/ZLP7P65?=
 =?us-ascii?Q?cnfY2em4MlyBynL7LyTsJ2/Iyg9nNY12Or5qZD3ZTI1X2oRuAwDAbb9/FaAE?=
 =?us-ascii?Q?x6NpQqdOktQewVhZC6Zp0Ch70iZGe1ogpM/KZr3l9axssJRQfwKmKBEIheT2?=
 =?us-ascii?Q?rcSeAZB8Gc5fwm9Y8PZS/q6Tv+SBy3t/JQlTmgDD7slhT4Tzdxemz5iDmCmo?=
 =?us-ascii?Q?GEVGlkfaH6K/ynXxF8suJcZZrs3GYlcpowF3EIfYJVA1dHEqouBpx1VOxkSs?=
 =?us-ascii?Q?+BQq8dqs9aYGtbzV8dOYkcaPEEwaEmlqjM0MUfjwjh1IGoOnXMMdSw4yK4dt?=
 =?us-ascii?Q?S+39+KVi5C9+mHCjQt+LAmPBl82Ms8jN4yG4d+PTz/JFRobwfWQ7QGzNnMr5?=
 =?us-ascii?Q?eRPKEYLrN1MH+uq9kuUwK/sfW6r7brd47ZfDF9g3lGsLMF68shc1rTxCKiPL?=
 =?us-ascii?Q?35uwkP4gIB9Fc1io3QqqBTJ42/88MsD6xtNtaQTb2z5tm8RiVb1/ZpoUY0id?=
 =?us-ascii?Q?cv+7UEDaVcSuZbJw5G9SyQH6bxWk8zXCgH8xFRdQWqG5Oxve0wtUEINOcuDH?=
 =?us-ascii?Q?b5U5IUh3W9FJudhAaQv5uyJoaxXS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 16:23:49.8083
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a7b175-1353-4317-f9f2-08dc63b1c239
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD81.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9335

Terminate if an non-SNP guest attempts to register a GHCB page; this
is an SNP-only GHCB request.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1cec466e593b..088eca85a6ac 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3970,6 +3970,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
 	case GHCB_MSR_PREF_GPA_REQ:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
 		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
 				  GHCB_MSR_GPA_VALUE_POS);
 		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
@@ -3978,6 +3981,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 	case GHCB_MSR_REG_GPA_REQ: {
 		u64 gfn;
 
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
 		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
 					GHCB_MSR_GPA_VALUE_POS);
 
@@ -4004,12 +4010,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
 
-		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
-		vcpu->run->system_event.ndata = 1;
-		vcpu->run->system_event.data[0] = control->ghcb_gpa;
-
-		return 0;
+		goto out_terminate;
 	}
 	default:
 		/* Error, keep GHCB MSR value as-is */
@@ -4020,6 +4021,14 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 					    control->ghcb_gpa, ret);
 
 	return ret;
+
+out_terminate:
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+	vcpu->run->system_event.ndata = 1;
+	vcpu->run->system_event.data[0] = control->ghcb_gpa;
+
+	return 0;
 }
 
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
-- 
2.25.1


