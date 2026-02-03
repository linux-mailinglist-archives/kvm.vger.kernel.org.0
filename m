Return-Path: <kvm+bounces-70110-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMeTJux2gmm+UwMAu9opvQ
	(envelope-from <kvm+bounces-70110-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:30:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A593DF442
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2729B30D561B
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AC936F43E;
	Tue,  3 Feb 2026 22:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KuizrzsT"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10F5341ACC;
	Tue,  3 Feb 2026 22:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770157485; cv=fail; b=TBUcVOYC+HlVzZW6h6eovW/uqC8iRwoXLg0J+kiXNquXXggMwpSO/SttALVAo9uDmNH2/A/+RESwb8+LddQmFf6OOF3gRCzkz+BCkpx+AteDI/FtY1CBZDNgIL4317WLykWDgei9dwoIaZ+DwFbL9goBf+vuc5amV10ynnsX9c0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770157485; c=relaxed/simple;
	bh=QlOU9/fWKuQAuRf8SYPB/2Xz3fhcqpA33oBy1YFZH6U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sFG8TsSEb5p4YzJFAxX+uHMEPWfBujFDY4MrSPXuWrXbbcbB5az/NyE6xZwjn2r1TSjA5qNs0C4UMwxpgzWdeTXcKl+C81Luq+k9LCt/2YmZIm/6Kwjfs+cIleeNafewYwsWf3k4qXjD1DcrgxgWdqoQxoOrZt8PDrUNt/+9rzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KuizrzsT; arc=fail smtp.client-ip=40.93.201.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zj9l2W55BGsfU4W5A8EffKZ5JMrefyePMzXmoiNuaODG3oEOb6t+Gw5F3UJhoBXsApBhobLOz6dGQrxdFIpbltvDnQ1aFSg8on7sAUdR9i12vdcYtkT6VAW2xHImzcJTMrIfwtgSuv6WJrptAlECqNt+jhiTbE/XPyR/P75fDigv5M7YsNCbxBlxaQkb5v9HUSW8cYsZJIeQXjtSH0PipKh8E3BWJkXvsxeJxOZqnSTB/dxydJgAqNhvwEUrQIehxabI0bpfU7dPxiqvChmJDqYvcjbmlD/aM67L8Knb5s5DosPFS3Y7+lOP4gt8dyPnm7UZ9YlnPEVDtPlMdHfQVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rc6dWQ4C3q3GDxhGiT0aHaZU5nilMo8K/KhCeRK/bh0=;
 b=M38uj6npxdSDwQQ6pWPuJRXtQ98nQt175Rv0/Zv1tMnnyfYEt0R8mrgr+R4jDhwS4vE2xawy3YQraPHDpboNVh4OMA2crCbd3h/tFUe27gastnxPiKIJvv7531iovplB2IwnfNG95Qk1DsQilnJtkT/K/bTM5mfQgkFO08JrPwzz0vYC/K4JrWCUWdZvpFwANXnKS7EMxBr/lalsPYYWpyZOWJpz+IYIzGZxxdTfL1Gra6TTounsPQHuZOrElLnWpUc8hOeWLCkFwOhqhmKd1KKYx7y0C3mw0UZYIQzWlsAkDirKvDrEMueK71Rc0T5a8kCa5SnW6kv7olbLMHIcfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rc6dWQ4C3q3GDxhGiT0aHaZU5nilMo8K/KhCeRK/bh0=;
 b=KuizrzsTC10DLFjCKOFq/ZSwRDp7tnOtmNsv96vse4zZm7Etu3EmcRNuIQT4Q6Z4xJrZY3+IyoE9NgWSdpP2R4mfiyPeA0c6pA2r5jx0AmKN/okJalFuGyoufoffDoUWcpzDyPpHMIXOvpohiUK6mCWCR3/gigKau5ve0TS0XYw=
Received: from DM6PR02CA0072.namprd02.prod.outlook.com (2603:10b6:5:177::49)
 by BL4PR12MB9533.namprd12.prod.outlook.com (2603:10b6:208:58f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 22:24:40 +0000
Received: from DS2PEPF00003442.namprd04.prod.outlook.com
 (2603:10b6:5:177:cafe::85) by DM6PR02CA0072.outlook.office365.com
 (2603:10b6:5:177::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Tue,
 3 Feb 2026 22:24:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00003442.mail.protection.outlook.com (10.167.17.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Tue, 3 Feb 2026 22:24:40 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Feb
 2026 16:24:39 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Borislav Petkov <borislav.petkov@amd.com>,
	Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, David Kaplan
	<david.kaplan@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH v2 2/3] KVM: SEV: Add support for IBPB-on-Entry
Date: Tue, 3 Feb 2026 16:24:04 -0600
Message-ID: <20260203222405.4065706-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203222405.4065706-1-kim.phillips@amd.com>
References: <20260203222405.4065706-1-kim.phillips@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003442:EE_|BL4PR12MB9533:EE_
X-MS-Office365-Filtering-Correlation-Id: 14969d09-187c-4944-3a26-08de637305e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kEEWPvEOIdlmZgUbs4UlIm+ExZ/7HsfsaTd0VjdgAwPZ+o+JMAbGe06aoC/E?=
 =?us-ascii?Q?QfuGrXTPoLRmgtDImJ88cCeR+ynGp0jJxLluu4bx3g/swwZ1D0XMTjBgbZBT?=
 =?us-ascii?Q?64Cmqgrpcz5j6fwLGHwyDwxRHvMIUl8fjLWCXgPKvN49qdjF1eaaiKJpIdNG?=
 =?us-ascii?Q?EkV5ZZRSsWHyZp96WPPLm++Npa/+VMbTK0zgxdg9QjHG9HLdMSezsaIfHjjx?=
 =?us-ascii?Q?u1rFpjSaqq12YqVOAEzrD/wXUQvPuBszEmoQbdMKokRKntOtCXbMcsySSKEZ?=
 =?us-ascii?Q?IDVNmdqsp+W1tV/xwUhDYc3CXknoRg7B7OazhhUPE3cG63AYpMBU8Mf4PD35?=
 =?us-ascii?Q?oXsAgp7lQx1UcPhrF8MSqtTXco58jzuotfoMMNkJI2N9A6N44cU9LOdRCfDT?=
 =?us-ascii?Q?oxC8wO6an+7hwXuPMFYRrT+0OxqnQ2Vuq875N3D3h5+gygxnOoXgLHRXB/W6?=
 =?us-ascii?Q?E3JqOufBgS/f8py/59YoXOuameZR5Qal/mlLCQpClrPXz0RApqRXk7raPrZ7?=
 =?us-ascii?Q?ISsCK6KwTG79JDuyN5TbfbfTc/zx/aeSTf9ShhzkI8nVNhfMcpy7DO9b5wic?=
 =?us-ascii?Q?vyi0JKynkStwqEUaHy8CjdzHbpDExo18Vhb3u0YX79FT/gIfa2McqN7BURxt?=
 =?us-ascii?Q?5Qi9BUMdZnvJvckUKHlJQ027x4zQ3B/aMqFu2tRi0COuqQbWNWdct15lz/N6?=
 =?us-ascii?Q?R2Oy61Goo0Q1PI2bJcYOiSMbKI64g/bQnnFFU8jc+F6f26TCuaLqUIgGBkkG?=
 =?us-ascii?Q?UABvTA1ZeobEKXRbd2puWf0qmL8gESyU3GLJ0+vvOOXp2HAPkNtljPVCZUZW?=
 =?us-ascii?Q?V3NhfzUSXp/8AbLuxYBRU0sXwp74aCC/5nxbXqhqBNTaqZ7R3dGLN5UlHnYh?=
 =?us-ascii?Q?hDYJs387JktVowZDLLvxIgZP/lhS6E4bBUDJHFeVBgUK+hcvIuTX4VLCrpg4?=
 =?us-ascii?Q?dWAnrkXbNVSaEeoW7zIOr/RZIqRc7aFJHtEEoibJG6t3y+YhEKMkO2yivHGN?=
 =?us-ascii?Q?UvXC6vMr142Qko76S5PgxceDii7sOrGTQ8A+fZTyzITDFJdJGZVEtpl7rOAW?=
 =?us-ascii?Q?ca1Uk+4vYYgTB+ibRvE1zPGiSDzxDswhnuUb59w7x09egHwTk3bkYWEbOT8r?=
 =?us-ascii?Q?K0QJ4SPk+mfS7ml4PIbRhZXL6iCz4Dnq9Jh87Gworx7NTOa639NJQmV72dwt?=
 =?us-ascii?Q?AO1fK+/ahhtoamz/qfIIGT55IrcUQHT6UMvx3Qn1Owo65crvDREm1cBl5ALI?=
 =?us-ascii?Q?s3Latc07Y8MhNraDCZcbHgTDhry6OBkkTZlyN4WQfVSDzqGobdW6KfRnyODT?=
 =?us-ascii?Q?jumSnW88Vi1kVLV/N2sAsNHn12JAGGi3OMYEfgdIjAZwRe7A0RvKCK0hIP4Y?=
 =?us-ascii?Q?U3toINl/kph+7VJ50lsWcjIZFDt6+HELlCDdQVEmpOQyy7r3YVuJsa/SVpoo?=
 =?us-ascii?Q?c7C7RowquMhFacCF6HRMW/ZZuesAgu3H1vYD0VhM5mC5EJT8bSPz9uOK2TX5?=
 =?us-ascii?Q?yy9/MFReCr34aw4s8ZgQZUor/RRDx75TkxQ3GllT5UN/iYslSLzHg4R5QLU9?=
 =?us-ascii?Q?R1wCtkF7hZt1Do9AYhuaMGUMGlXRO5hIgrzjqNbbD49bPsCI2XDG4SE+EBPC?=
 =?us-ascii?Q?MPGzSo05vq6gSOZYLAPz5OiSaf50K4UycwqRZz6XQpinjT0O48/8y9T3I7ut?=
 =?us-ascii?Q?0EyoNQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7RumaYcFc7X8GhICnrzK92QWTt++MuUY6OmANgZ2BlKriQb478mSOhIyireHayfccnAhl3WMm4388KTlWeuOsPJL9NNH+vycx0a0ajtG2eTeiybAINjStLBrg7Z9xzXBhJOfSK908BBcwBU9fZkMo9E2R0gjUz1wakZs+wKU+oAentnJwYIbM22PBt79QRiHJgVx3l+Y7quL+cqV3EU2mLFD4DC/Ucj3bPb3Qoyj5YT1tsfjiWLQ0JoGQmCYC/N5Vwlz3P9PFW7qGLQi49onjtSnynVX2pFHZPiD/IVi1Leb63K1V6nPu1k+6r/6wRpTpTSHr7NACCfQRbbaRGzvTes9Azz1+rP8af3PIJVLkGLCpAaE1xLu5rwxW4CFF0pNV5RWxWIQVIhXxjRrLnUPQ9q+piesvvGsDYLgUoBwge41QSEXsv9RpLatjDIj2p+Q
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 22:24:40.4237
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14969d09-187c-4944-3a26-08de637305e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003442.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9533
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70110-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 3A593DF442
X-Rspamd-Action: no action

AMD EPYC 5th generation and above processors support IBPB-on-Entry
for SNP guests.  By invoking an Indirect Branch Prediction Barrier
(IBPB) on VMRUN, old indirect branch predictions are prevented
from influencing indirect branches within the guest.

SNP guests may choose to enable IBPB-on-Entry by setting
SEV_FEATURES bit 21 (IbpbOnEntry).

Host support for IBPB on Entry is indicated by CPUID
Fn8000_001F[IbpbOnEntry], bit 31.

If supported, indicate support for IBPB on Entry in
sev_supported_vmsa_features bit 23 (IbpbOnEntry).

For more info, refer to page 615, Section 15.36.17 "Side-Channel
Protection", AMD64 Architecture Programmer's Manual Volume 2: System
Programming Part 2, Pub. 24593 Rev. 3.42 - March 2024 (see Link).

Link: https://bugzilla.kernel.org/attachment.cgi?id=306250
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
v2: Added Tom's Reviewed-by.
v1: https://lore.kernel.org/kvm/20260126224205.1442196-3-kim.phillips@amd.com/

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/svm.h         | 1 +
 arch/x86/kvm/svm/sev.c             | 9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c01fdde465de..3ce5dff36f78 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -459,6 +459,7 @@
 #define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
 #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
+#define X86_FEATURE_IBPB_ON_ENTRY	(19*32+31) /* SEV-SNP IBPB on VM Entry */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index edde36097ddc..eebc65ec948f 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -306,6 +306,7 @@ static_assert((X2AVIC_4K_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AV
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
 #define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
+#define SVM_SEV_FEAT_IBPB_ON_ENTRY			BIT(21)
 
 #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ea515cf41168..8a6d25db0c00 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3165,8 +3165,15 @@ void __init sev_hardware_setup(void)
 	    cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 
-	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+	if (!sev_snp_enabled)
+		return;
+	/* the following feature bit checks are SNP specific */
+
+	if (tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
+
+	if (cpu_feature_enabled(X86_FEATURE_IBPB_ON_ENTRY))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_IBPB_ON_ENTRY;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.43.0


