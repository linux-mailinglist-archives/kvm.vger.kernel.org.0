Return-Path: <kvm+bounces-71636-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JOdJTLqnWlDSgQAu9opvQ
	(envelope-from <kvm+bounces-71636-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:13:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3737E18B137
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:13:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 005F8308E8CB
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473C73ACA72;
	Tue, 24 Feb 2026 18:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EGemOAs8"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010038.outbound.protection.outlook.com [52.101.46.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F87429BD80;
	Tue, 24 Feb 2026 18:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956132; cv=fail; b=LpFGZ0Qiz15X7SMBF9UZlOQomu6B5H8lOOPtbFpWB5Vxp7ztSNO+pW7QYWQxFWyzowAPj8r2trdLm1H9zmzCG4NPuXDOn5BTZlvbVJrwIa1YadEC8qtcd4YYkUN+Mh30hTyDKpncAN4WR873mO1NnDH7tzhpfhsQyhGrUfA52LU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956132; c=relaxed/simple;
	bh=i7NGo+6LeDtII0HtDo4NUIVuPriLiKNy7prpDET1cg8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jnvPYU/9uyrITnpfCcwI2I0e61vhAU2s7SWuUKu/8MzFixd5nYjsM/069zlirc95pSBpjN0YeV/zZ8C0Ge6poTC6+0Fr5gx63uM+VoFARnDdt/Pm1yo9VsUufRm0vpLFoJIJHplSMHQioCrAGZTFoHlpk6esJpKW3hzxVRDSmiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EGemOAs8; arc=fail smtp.client-ip=52.101.46.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kz/G5iNYr84wb/rHqplCm5r7VnWsOYZZeaHfzaPAQlzL6uomXuMR9NCWtsZHqOZqd9Jcif+UsX2vzMmP3g6B2YH+ntc/F959DSwGW2Dsfw1dhVJB6YWPtQY1YVwr4mtbJrG9/GatZjGlxt1vZSlG3taHWsITiImWOwyFYu7RP9KurGNVaH2bayv+WPZnlThFgZjsx5+ppjFzLIil8yP5IhGaInng2wk7PNy1u0dDXhiziiDn0519elLw/oCb0FHo7kgxvBJN0bWShuaFcgSzC0nQk6WUMiUGLsA0nAu0xSvj8wVLgC2E6ieAfwEBb1zx4q+4HaaQ7gx3N77fO9nDhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLjSQsqeSvtg2Cr7OhXVCQZPoMxO07n9Uohq5DqS5P4=;
 b=cq9BmKvlnvWXFG6iZKsZjwEtqM7NwxAnXihLptrmEgSvg+JkXqN15Og0N82WcL/vwiF8HtzM1dLq1TBLEm9QnAfGN3jKgnijSWboYmOI/JJA7XHo/kj+cfXDnSpjY1kqZ7eYxIyKLR24COdPUDDdF1UD1V6rYN4KNqIuCJNGT8LWCr8XTLiPzo6i6hi4viJqzfUz/ny23q/pMbRl+Qsh5vwonhQDkZd7DO/tkN//BRsI+KoZHtQG9YJh1KHuXgaeM6YeDIp8gTc3UI+Mqjw92solQvQ7DKQpdXKl+HR+1yobBU2M/S9Uona5pZmbWjMyrJPpGymDlvT43hph97XA6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLjSQsqeSvtg2Cr7OhXVCQZPoMxO07n9Uohq5DqS5P4=;
 b=EGemOAs8NGu1/OBQoyCVRNDD9IsjkAENvQ9SkjAQa4pVcRuLJ0/9q1M0sHzw0C6+XkGqQlpEA0xYRSVThvLfpL51/CgU306r6a7H4pjnVGC4FSJqUqQjC6gTDyk+joGczsAGimJChSPPMEbdb7ZmstIFYvnV7Tl8ChrYCFBPSuw=
Received: from BN9P223CA0009.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::14)
 by DM4PR12MB9071.namprd12.prod.outlook.com (2603:10b6:8:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 18:02:08 +0000
Received: from BL02EPF00029927.namprd02.prod.outlook.com
 (2603:10b6:408:10b:cafe::45) by BN9P223CA0009.outlook.office365.com
 (2603:10b6:408:10b::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 18:01:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00029927.mail.protection.outlook.com (10.167.249.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 18:02:06 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 12:02:05 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Borislav Petkov <borislav.petkov@amd.com>,
	Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, David Kaplan
	<david.kaplan@amd.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, "Kim
 Phillips" <kim.phillips@amd.com>
Subject: [PATCH 0/3] KVM: SEV: Add support for BTB Isolation
Date: Tue, 24 Feb 2026 12:01:54 -0600
Message-ID: <20260224180157.725159-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029927:EE_|DM4PR12MB9071:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ef65866-f81f-41d5-8636-08de73ced28c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I1y/H7HhCJhy0C+L53cSkOPjYkEyxbsPOtlt5baJco424QtBD+MXbIKkKIT1?=
 =?us-ascii?Q?V3m1gny/sAYxexosrOpJKPhFS7GJamxEsM0ZZsXm1F9EKj3ljRIqSZxuv8pK?=
 =?us-ascii?Q?SJLMpRrsb4OOYmRefvCo4aKdcvtAAkVTl/0nvOpV2vVHv0b776KVs7th2wGw?=
 =?us-ascii?Q?I8XAbTEXs3TjGryFDicFkiaa5orxeZyYNVprgc66H4WdV+3GgkayPJaW7G/0?=
 =?us-ascii?Q?aW7Z1yIsPBfu8Wt8gcGGscY/im7mubpkoNHc2MzoSenCTBHLP7pu2k6rtXkf?=
 =?us-ascii?Q?MEE5zsowOMv1/PxtaCUWxoGr8e3+kGDQ56vMbdxdXWEeBH5HV6wDBlj0VCxt?=
 =?us-ascii?Q?gvA9ju40cdYGG/DIf/Tj+9of322TlVWytdyLrO24IlamePthRNwVKIpWkEnQ?=
 =?us-ascii?Q?VhXX0hYEphEX0T8sjKDrWFVB6zBtzpVKb1xs4XxhaTCQ5Gd9a/ecxEhdcTh3?=
 =?us-ascii?Q?1VNd3V/SGB1YmndkIbHIQOJ/06EPzbZBSP9PnqzBWBFkwGTb5xkrdKWDlkzp?=
 =?us-ascii?Q?Qwbp6bARpATHg3uCRr3lcGX2KXzEfHiYQkELKDsa/y/Uj2VIgQrW4MKWO8G9?=
 =?us-ascii?Q?QE9BrlsSK/I4qD8OWLE3ZZZa+rHgKgMGiD6NKWb+QyTWnjti6Zphetot2XHJ?=
 =?us-ascii?Q?XKBgj/rda3Cz6LJNLVAilf1PPWAIwsQEaD4ufxe2S32W58lMshR4hO2Q79bq?=
 =?us-ascii?Q?H/3Jrz83GhZoKogX/icogB0fQubNz796uF/BuhuJpjcmVxhUS/yrrnCSlpLz?=
 =?us-ascii?Q?tF/4bbGeQwH4/4s+Yt8pVm0vqlzteZ9ZUsxGeK2zDIQ91qg0DdU2uPxhRQM5?=
 =?us-ascii?Q?CWwGibooFJ2skFqYe13JL5oiLKzXGc3OL5V7KojSOX2QOPzPIzhQcuZCCl6e?=
 =?us-ascii?Q?05EOmIq7ai3aEkpKBsQaGyBhz3lXl/fBZsbbAYbtZvpqZZUvvb2u2/a0gMBu?=
 =?us-ascii?Q?Yd06VVGDfTI/TwWv0nEOS1OZUl2E4qKuB6ZQSFo+HPZWNXRQIJ+p4f/MZQDt?=
 =?us-ascii?Q?jihZ0Ar28fcue49B9hfaZCLtTruq2J24PqLJsYSEG691d+x4se1AE5UlGpPD?=
 =?us-ascii?Q?mRRaQyR7WfLGfGwInJ0OY8lDXdFYYSp6ZwTBTesEz58jBSQ4uZRhLx/8iLtJ?=
 =?us-ascii?Q?e91b4W/wDbCA8CMtZvwRlDN98/bS7aiYEmA42mKhCxB4eqOOr1LgVrm3ikrj?=
 =?us-ascii?Q?OTLt2sN/0rhiDD2VAqmMy7gafE2tWowG89ubdFw4z6prC+jktEGjkHr5pJnN?=
 =?us-ascii?Q?dDAAlRfUtBmI+1sUZvoVaOmKn9LtpVFs26yKjrov1LoKsG7h14VKS7tRdAxd?=
 =?us-ascii?Q?5prYyQZQwWF5cynZc/LgZRvpYSjMXIS5QQdePaCWkt2sW9tjrHfJbymoVdae?=
 =?us-ascii?Q?s9oKNN1qUryxKm0S7ys+ZUgnuuXUlkXpfu25sDFoq/w2rhAloa90OqnSyGsd?=
 =?us-ascii?Q?bJMIjMEg2K+tu/ZjOdMYdBtEAm6NIq2XOc31eLbgRXMCs81MGQB9bfd00mqK?=
 =?us-ascii?Q?Ut5BLwEB8gJI8exTcPrbYTpTqxofY5vbH0xzdl6ZKCHiVSV0z2udqF8k9qD2?=
 =?us-ascii?Q?msRkNCkxkRqg7MZskXIq7iPXc7NMdtjBL47hXjmnIvP1q2epemQ4zU4p87l6?=
 =?us-ascii?Q?DQhgPy9Fz8Mwsn+r+Li5f9xtUSsLnZjq0Z5n2Dzlk8UzEPd9of/pcWM70Vg3?=
 =?us-ascii?Q?n984Ig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fyL3jdIuHcISJjO5lQ/mHqDD7q3BiZdwD/zQfODF2PQz/PL5ZME5nn/3nv5si3eL6jpvKxegws/iqm6xCFJ343KoSWgv5ppGR0bnF+Ecz09LzbOsoJCHmJVyV9lS8uJ0O9kRNFHeBvRFTnVQnm24UefeONHehuEqHVAka/V4nkC74jaBh/ZesL/mzV/m83JsDc+uFZBcLiObbT5h46njKMpubfy/Tel5lUOSkxUD3bmm3i0i8mjo2gMRq2tTMPMejOpNC8e7q7enfp2zSDPhfx7v+Gp+UPOpcuZX+0fEGk2Z7dYftpFAeNcPLx7n64PWKSR1GXiYEjZ8wpEsqwcNrY9yWrqIp4v4gJ3HQFPgHj+Lu8xMLeUriqizc0dBk14P9yoMOl5hSNXRgGcLPEGyoAaSOCs/LLwNiaXIf9hXjOsiCfqPZiMv9dUoJCJxWJoD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:02:06.5637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef65866-f81f-41d5-8636-08de73ced28c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029927.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9071
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71636-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 3737E18B137
X-Rspamd-Action: no action

This feature ensures SNP guest Branch Target Buffers (BTBs) are not
affected by context outside that guest.

The first patch fixes a longstanding bug where users couldn't select
Automatic IBRS on AMD machines using spectre_v2=eibrs on the kcmdline.

The second patch fixes another longstanding bug where users couldn't
select legacy / toggling SPEC_CTRL[IBRS] on AMD systems, which may
be used by users of the BTB Isolation feature.

The third patch adds support for the feature by adding it to the
supported features bitmask.

Based on git://git.kernel.org/pub/scm/virt/kvm/kvm.git next,
currently b1195183ed42 (tag: tags/kvm-7.0-1, kvm/queue, kvm/next).

This series also available here:

https://github.com/AMDESE/linux/tree/btb-isol-latest

Advance qemu bits (to add btb-isol=on/off switch) available here:

https://github.com/AMDESE/qemu/tree/btb-isol-latest

Qemu bits will be posted upstream once kernel bits are merged.
They depend on Naveen Rao's "target/i386: SEV: Add support for
enabling VMSA SEV features":

https://lore.kernel.org/qemu-devel/cover.1761648149.git.naveen@kernel.org/

Kim Phillips (3):
  cpu/bugs: Fix selecting Automatic IBRS using spectre_v2=eibrs
  cpu/bugs: Allow spectre_v2=ibrs on x86 vendors other than Intel
  KVM: SEV: Add support for SNP BTB Isolation

 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kernel/cpu/bugs.c | 16 +++++++---------
 arch/x86/kvm/svm/sev.c     |  3 +++
 3 files changed, 11 insertions(+), 9 deletions(-)


base-commit: b1195183ed42f1522fae3fe44ebee3af437aa000
-- 
2.43.0


