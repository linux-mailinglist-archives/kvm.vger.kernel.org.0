Return-Path: <kvm+bounces-41557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 739B4A6A740
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:36:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7BD51886945
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 906E0221D86;
	Thu, 20 Mar 2025 13:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Sd/SA/T1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A02A21B9E3;
	Thu, 20 Mar 2025 13:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477270; cv=fail; b=pacZmesw72VXL3yHzfFeMrdvs50gml0cg7sKQAk9erx84Nmc/D5xEw019diq4lkI7fqLDCtk4/L/0S/uPj4m0CJI+seqfVpoagxwcIQ2fTuGTri8b0xQOzzBq8GMafmoPeaeu6FIZzH3mSnp2Lxv49Z1I/sJ3Hy0dn5XCGuY4D0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477270; c=relaxed/simple;
	bh=cxXDlK4r40JqCSEWv14FCYDr0ohDBHjo4Z14wJnPVUQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJxundRJDKwVh7XeVBGySPKp0CX/iBToBPm1228F9KpHqwVPPiDh35D/DmTK2N2328yCyMVFz4Po+lHm4mFMY3vfv66gWzK9bY5ZVhdigAANn9QvMriDoJ/WsKBTTqVJklQhwGS5D6lb7hbEkOlC4ei1jOSibUSGqk+qZP7i9RU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Sd/SA/T1; arc=fail smtp.client-ip=40.107.220.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVqY2LA8i45s+CBB3LQp2RUThgUVvS2wjJYZrrBYredLEIjd0bsYBsrfraXw9jguAnRck13YebFNN0dynBdcZt5d1g/S0js7sXYfoJRmd+e7f334FfYS64b0lIA8/UJkk/Xd5rWD051LvkOj3nuPoIwmqade5TuGLJ47ehx+8jgwyvqdFXxT3CNBMkDbOip5j1+aqpnVfmKgXaeGZsR+xR4pfX9ylC0WU6AGXUzhP5y9P6GcRp/T1U1mvoE4TPOjHZJ3zjv9VCqmXGbLXyC7GGdIgau+Jhu/+6Lk4QRcUZ1ijPt7EXw8Jm/I1ObKHHxup/8wNzhWTsGP7wlGk4bbnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLjmeB5J03BrnQVyoqoDe+3hFB6kzGYoB9gZYYu69yQ=;
 b=Lz2wKniPPR4Zq3X6pedTDoUTP2Jfn6CdF8tyNR5NjRAOXm6ozu2uukoCRtGPdN2lAxTostM0MJhl3QDGA9XSztCio2W0+1J2ENamE+WLtqB+mKeRybOUcITojYbbwg3m7ASKCZVIMqJZ5SZf2u/NhVJoxBL5Pw9dh97jn+ZPXZMHQPX8pTIM8IkHe4mdAtvl2qpevHYHqUGA5tZcDypWSoQFrDepSc/bU6mo9uIFd6eGiqv+xLy4pGyuhrKUm1DtuGhX/Yz60nQZFbyX4IufL9Hn+z+ja6cz/ALb5WsEqSSpOlgKZmEQlMoHYRgpMRs7EWsm9EV4gso5wZYG2GNVyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLjmeB5J03BrnQVyoqoDe+3hFB6kzGYoB9gZYYu69yQ=;
 b=Sd/SA/T1pSOi+YIJAGKBY6XbS+oYohTatqd6XzxxrT2qoKh8wvWExYt4EoxN6d97z3DJMUpu/KgZ2kIcXf5l6HGV6xq7xw3cS7PCPgGyVtGDSojXyPEap0/iH5lL459CirkZBDRJaT6qXPjYR4buhb/zhK8YIx0990fBl+rS6ps=
Received: from BL1PR13CA0383.namprd13.prod.outlook.com (2603:10b6:208:2c0::28)
 by MN2PR12MB4422.namprd12.prod.outlook.com (2603:10b6:208:265::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Thu, 20 Mar
 2025 13:27:46 +0000
Received: from BL02EPF00021F68.namprd02.prod.outlook.com
 (2603:10b6:208:2c0:cafe::da) by BL1PR13CA0383.outlook.office365.com
 (2603:10b6:208:2c0::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.30 via Frontend Transport; Thu,
 20 Mar 2025 13:27:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F68.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 13:27:46 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 20 Mar
 2025 08:27:45 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH 5/5] KVM: SVM: Add a mutex to dump_vmcb() to prevent concurrent output
Date: Thu, 20 Mar 2025 08:26:53 -0500
Message-ID: <a880678afd9488e1dd6017445802712f7c02cc6d.1742477213.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1742477213.git.thomas.lendacky@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F68:EE_|MN2PR12MB4422:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ecf26bd-c0dd-4fd7-4647-08dd67b3008d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bZIc8HHKq701euyQH+Ymt6BCIQvifbhn1SPI5NoBK0rIfBUhGXHpn1nMn4Tt?=
 =?us-ascii?Q?ro//JfP910UVVH/TylNgVc7EId18Xy2Ws9SA48F+HMCowHloTCBvOXg3lmsw?=
 =?us-ascii?Q?09uo2+iSmxoOAmT012uvnTuKONTa7M1bprwcNQ41+oYfjEC9kwAuzZOPp8Jg?=
 =?us-ascii?Q?Tc5A412uksBRvOuqi2WVCh9cgcyRqvCcUZXQYYvclkMUiGk/u2BWJSRw2aSe?=
 =?us-ascii?Q?67PrMiSOG0fG0kcIWsdceY6NjcZHvXx9Is99tLfXCCcsA1yhiY0RVpE3eAei?=
 =?us-ascii?Q?A2S+07QJBCmxn/hj6i0NdQEMWGyrlvIJebbaZFJP0Iuk1FWtPm4qh3/NvsB8?=
 =?us-ascii?Q?oeBD/XTxLfTgyYr1RbQaPi2xfd/S1VDM9KvondScOi/lM7AGhtfgGY6c/ZIu?=
 =?us-ascii?Q?bUfvklEfBxMGly1EWwinnSh+brpLNXQiJOj22/kAyZCvp22c5Yc4zMuvqHC0?=
 =?us-ascii?Q?3QXtQ42/aiCVQrwcQRMOjEHEeCTU1X+L1XMKpqnthVKa/NgyFEg7OXE6KdeT?=
 =?us-ascii?Q?oOsNWMshjPVH5p/G77bq71cEOZBKhSxn+uwfMBk0NV8dIBQPzhNwr4feBHSk?=
 =?us-ascii?Q?/pd4aUwlXfTs6YtroFaWNp+JM+KgYt8bwGo1zDPR10PAk42ZGJ0uvdPm1pEX?=
 =?us-ascii?Q?BfNTeumcVyCgeLBpah5tYsr93kPqLb5+SyFf9Kez1y50Wtciwj89Edf0+tWt?=
 =?us-ascii?Q?jqSY+PAn72tP5VX94iASJHpsjvQo+pKvPyfcbaRne96+ThATYmubs1u4RVKu?=
 =?us-ascii?Q?IxhFPpeZAXjdVwh+qTD8aa6oCqLO69V1p+SWhYTiI+QY8jUBXDblK1xMdM4V?=
 =?us-ascii?Q?Hi7TSXiPbwxFe8ckCiDSVVeetX8fqL5TMhNfAO9V6pDnua60Th/nvelS12bT?=
 =?us-ascii?Q?f18FFzZnGBxQbxsUZnQsKyLpLZ/T8e1p8KznIyxTFo3uEGc9ltmjQsBj3HED?=
 =?us-ascii?Q?xsBO9KPvi3+B81z157dVlIMYcJ8DV8h64anZmrOm7eSyDQQVfmjMw2somH8F?=
 =?us-ascii?Q?eeIGK7PAjSJC7MYG6HSgrFzXTXwAOU6qNFyztXAZWj8TXCAh9A/9Q/Ux/2et?=
 =?us-ascii?Q?lTvk/Acb8GsX72y8UQGvbrna+2gZTxSe7C0zYQux/oyImiPIDcX13S7HEQjS?=
 =?us-ascii?Q?tlJGt49gcjdcqUAiH8hboZ5DY6XmlAoEPxhnxBvuQU9IAZB4rY6zyqH/HeVY?=
 =?us-ascii?Q?t0rCv8WNGe5Hk/ubOG0eSXtIAekyn/XC9TF2hcBYV/LLERgWI5z9SGMPyXya?=
 =?us-ascii?Q?04SaaF7WoQ9XQzEIPZX8OdWdu36dG1YycMpXLR+FxE86I/oNmxjU2CIKfow0?=
 =?us-ascii?Q?Pjc16o2ELzg+YnXiirL7YAfxZHkzvxjFD+t3VtY0aLOlAX93th6qDs4+rjOG?=
 =?us-ascii?Q?rHx7Jpd7iD/Yp6orG+Ms7mkYHHcKfKfKqPm2RC7rra5wToRkwVcZkJas31wE?=
 =?us-ascii?Q?Zk47Fm/c5/toiEui09ZRfjjpSewfSZ0KStzZIb31AAg46aFA8cQb/w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 13:27:46.2231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ecf26bd-c0dd-4fd7-4647-08dd67b3008d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F68.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4422

If multiple VMRUN instructions fail, resulting in calls to dump_vmcb(),
the output can become interleaved and it is impossible to identify which
line of output belongs to which VMCB. Add a mutex to dump_vmcb() so that
the output is serialized.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 99f2d9de6ce2..5b62ac06a19e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -29,6 +29,7 @@
 #include <linux/cc_platform.h>
 #include <linux/smp.h>
 #include <linux/string_choices.h>
+#include <linux/mutex.h>
 
 #include <asm/apic.h>
 #include <asm/perf_event.h>
@@ -249,6 +250,8 @@ static unsigned long iopm_base;
 
 DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
+static DEFINE_MUTEX(vmcb_dump_mutex);
+
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
  * the VMCB, and the SYSCALL/SYSENTER MSRs are handled by VMLOAD/VMSAVE.
@@ -3385,6 +3388,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 		return;
 	}
 
+	guard(mutex)(&vmcb_dump_mutex);
+
 	vm_type = sev_snp_guest(vcpu->kvm) ? "SEV-SNP" :
 		  sev_es_guest(vcpu->kvm) ? "SEV-ES" :
 		  sev_guest(vcpu->kvm) ? "SEV" : "SVM";
-- 
2.46.2


