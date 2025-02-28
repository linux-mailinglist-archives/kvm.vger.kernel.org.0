Return-Path: <kvm+bounces-39685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3D1A494F9
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A3C51895419
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5662A25D53D;
	Fri, 28 Feb 2025 09:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xo7SjN3p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23EA25CC84;
	Fri, 28 Feb 2025 09:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734814; cv=fail; b=idV2XjHcxVVw5KYmi/7dUTNguKZjh2uAZzReRrCRWFRG93pYwPqRB6nJe7HKev3cwPzoG+KWV6DF50amiGXwYZrRPlytPe9ONNWmjhdS8JUa8OI2ij12xHajHFwaLxYbcGXWZOMeRG48vu8b4hOLaUD6wkLmgfpB7i9jakpnmMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734814; c=relaxed/simple;
	bh=gDN5vBFkmjy4bwQHFeXsJTJjXsXPTpfSQv93mx9Be14=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tu0Amywjo7fIu9hHZ2X3FaCBBkcROq+fNXxK4UEPkhjrtK/bdNKgDf7r1mta/E1NmK7u41KmDutkchfodOJuL3MKIlJYeOzrHsFlc0SWbqrcfRJ0iLI1ggBo7w8NNrwfwwHC2e65+8wBvUCmo99l17/qDSQpMl0Kcg+8uU5V0cU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xo7SjN3p; arc=fail smtp.client-ip=40.107.93.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=trv03TzDH9nkKHhZpAO3GMxcjWHHdjFhTmjbl8KfPrAX0f9goFzuiJFs9z3JYE3xsdb3PpUXqQayIS1nJYW2wqp652Bbwf2Vcw0p5rcuVTfnrB9WZiXekG0CWwREmVvpOojAwhv5hoplOCOPeCQEcJySr9NqxFXSj3m5zr4XBiWctr9ueAjvB26XeCNWh91XfqAyWDaq2oCgC8oaeC0H/FkXG8GFSVi8BVzrUQD9Q1+6fjEFivLW8dICOtPrfOuZbBBHaKe5Ly1KarCzC/o9NCb53Sajj9yCNlaNaq1tKOb0ja0qlo7vl7XIRpPIB12x/rJy3w23USEg9IbZrrMatw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIKdtg3JwyaJJrJLv84FvtqS/CN3qQRtwN3wzgrzqQw=;
 b=O6DQqGH4NfjbtVC5H8h23SPVaqLxEyA1ltMotrmWXCTatD+xFEWc5ni4NE3FmhW2dLT0MoRG07E6kF99op8Jsc6/Xa/SqmIlnKaAr3UDGTvf0T5rrHpPvQXJ+nF8Rjk/zSL6K0OxDUWM2yXjl5e6MOu1Bw3NF7f087rnSQp/NxxrxcYYO44itRG+6MVop5n0YDPGJBxVKghV4jGh7xYqeyb2VDh6sERfvWa+cP/dRTKUluhM8Gfze4sLDNf7f9asQh1Po7p1PJuLSOf7QBedWCyXLRTBo2e//22q3GDRYAq5nOaXSc5NEzhN9Q/BM1ExRMuzPQVpGNCvVXT9+nsaUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIKdtg3JwyaJJrJLv84FvtqS/CN3qQRtwN3wzgrzqQw=;
 b=Xo7SjN3pByuUCgxX6+lk2zJlEzWokxMpRjn3vfWZSkQLOwfOPLguaFqKmaXEjL6O6shBCBH+ekypXgEPoeej2xccfQ4BaqqB/1NPh8iQZ+zs+Ld7Y+Ctr86Dk7t0pSRoKNkiwO9OcZLOw4AktTWPst11tSgRspK1kBYbqYGhFzg=
Received: from DM6PR04CA0008.namprd04.prod.outlook.com (2603:10b6:5:334::13)
 by DM4PR12MB6304.namprd12.prod.outlook.com (2603:10b6:8:a2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.22; Fri, 28 Feb 2025 09:26:49 +0000
Received: from DS3PEPF000099D8.namprd04.prod.outlook.com
 (2603:10b6:5:334:cafe::70) by DM6PR04CA0008.outlook.office365.com
 (2603:10b6:5:334::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.23 via Frontend Transport; Fri,
 28 Feb 2025 09:26:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D8.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:26:49 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:24:15 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 19/19] KVM: SVM/SEV: Allow creating VMs with Secure AVIC enabled
Date: Fri, 28 Feb 2025 14:21:15 +0530
Message-ID: <20250228085115.105648-20-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D8:EE_|DM4PR12MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: fee2f30c-7fd9-4383-500a-08dd57da0770
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u6WURjBPVKLt3uHbWBEl25CgS+9YQ7rrKYUyxlrBuvSPlW5wh/dUHLPREZF5?=
 =?us-ascii?Q?5Jdtr6p6d1KRfUlEC5FrKVlewIwuP2/CmqdU+dNJmBifbQ7N64aPOlZfJ94T?=
 =?us-ascii?Q?bYw8jJmI0e1TtfV6y1VxtjXqsQTNMLr65t0XmcUo+3Sam2KQrBuTYE8xnnft?=
 =?us-ascii?Q?2ohubEr82czI6sYiWV1Rphl5kd+6ftYZxb81JePRL+I4Zj5E9Vn460utaYWk?=
 =?us-ascii?Q?izdDwPDN2tbykmB+ojTomIAXbS+gxzQ5zefVeSWAOtzE/6lrwAtedt02RNSP?=
 =?us-ascii?Q?gqTcYEKtgsisD0EJGXfHfIf2yrvnyO9uPp+ZIXtiHw+9s7RnAe8P8H8cp/GZ?=
 =?us-ascii?Q?ENNYDBPzKJr0AFap4+/wePlltmvLnK7fq5pba0iLwIRp4I99LG1s6D7vc9tE?=
 =?us-ascii?Q?6i/maSrtO6hNPpPbUbA23P6RF6BaMi1qg5dbGfdy86IEM3bVlEc4WFaCcFro?=
 =?us-ascii?Q?aWuJUr/kKDx7pjGbpR7K+q8W7qptAEF3Y5e4bZILy+XKLgHWp5syhrtdX5Ms?=
 =?us-ascii?Q?g2kCTpeeLyqlhyQljTuZBSqyUEIa3c+L1A2T4DNGL7TadOI1mhsy1VRzkSrI?=
 =?us-ascii?Q?Kp7hRnaYvyJoSPzD8ObaDTGhJ3xu+lFFlN8XBYdw5uzmd8/dWYS+vtWNP0Eo?=
 =?us-ascii?Q?ieDTOPNWTuWBnUqL+95Sv9MxAu5ptNWRm6TYOYrx3LzMeq9SzMvkrYrRYi5z?=
 =?us-ascii?Q?zIXP3lpbXY0lbM5sVs3PWv6CfGDM4QIeZu2D5SessSzDnOuzzFtNQWhPkHs8?=
 =?us-ascii?Q?k1g9wYG/KFG6Hk5KRyHM2y38Xfw7rHt5egE7GfsVie/efbj49+k7D6Itoyn4?=
 =?us-ascii?Q?Aq1Nj1lCG6G5RR391JLfqT28+sc4QWZ1yk3YFfFOGsXfWDzuFw3zBZGyYQy9?=
 =?us-ascii?Q?nrU+vQ9EMtq1LgxsEQcS6OQDeC7+26RhSgxZYZTDFxgld6sfpMeTqM+2oOnu?=
 =?us-ascii?Q?JhZzdN7oh+shBdqfM9Ij5RFQHFHMF3rj+wB23RfF36S5yvF8M7Tm3HQVh+Xn?=
 =?us-ascii?Q?slZKkHNcxUCLCOBEB1/U/q6G7sZkzQ9aqxk9/+j4I5tK0IOIb52N5FBcyju8?=
 =?us-ascii?Q?F4mz6aYVeVZ9gI/uExd6E8GF3Pcuc35xi+l1AeKMphgTmq62XSExKdeoqvBV?=
 =?us-ascii?Q?gjnKaE3Jqv/ZpRePKG1DUVbJzhPiZ2EmlBMf7WBjM8JFjHG8gKv0NpNIHdJM?=
 =?us-ascii?Q?Mg0VObxLJGgVvWp4s2Pcf7hUNPTdpbOKQOf7ap1izPHwXde8O/c7SgT/QlZG?=
 =?us-ascii?Q?Vk4LNG14miF1kOSkdh3tEp5j2/4waL+xFQCQCQqp/GQWPIstSpCF44RVonLq?=
 =?us-ascii?Q?23/I1rzk1fScRid/xym+AAV+DKOSDTO8DISthcwIAM9PumygW8/PWUVNtbU/?=
 =?us-ascii?Q?zbSA2y6lJ5PNjpH+Xv8Cr44VAUnIGGLEnAQt4zLmoSGc6S06RzxIMVTgoOwT?=
 =?us-ascii?Q?NyoJT49VuWoDhVkE7RiTUCW42Ydp9NL8ewOcmN0YitMMm/QPtyMYc5QEOpFM?=
 =?us-ascii?Q?HAyVPKtJzUV1SSY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:26:49.4672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fee2f30c-7fd9-4383-500a-08dd57da0770
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6304

Now that all the initialization required to enable secure AVIC is done,
set supported_vmsa_features to allow creating Secure AVIC VMs.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 881311227504..6b1ce8bc490c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3100,6 +3100,9 @@ void __init sev_hardware_setup(void)
 
 	if (sev_es_enabled && cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_ALLOWED_SEV_FEATURES;
+
+	if (sev_snp_savic_enabled)
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_AVIC;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.34.1


