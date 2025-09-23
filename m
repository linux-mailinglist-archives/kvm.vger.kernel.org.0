Return-Path: <kvm+bounces-58455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8780DB94470
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16FF93AA4EA
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C879272E5A;
	Tue, 23 Sep 2025 05:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E6Mm559Q"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012047.outbound.protection.outlook.com [52.101.53.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AF478F20;
	Tue, 23 Sep 2025 05:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603907; cv=fail; b=Y4Lf9UZ5eRlMhm9SRyrcwIvh3u9aGiPXS6qy5/LZFJj501Vxqms7E0EwjDZXj1KovOsWJc3nfDLpc0dcbSwoXj6s1ag3w/YcpIq/bZnggaXNXz0d7mKnySTs6RAnSaDSjWdOvZfhyo5S2nHRFEREAoyGLfwy74TUe1TS1w/vHSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603907; c=relaxed/simple;
	bh=E/5i9KWQV9bboEW/p6Xwpyby4tpa0it6mA9qjvD5oTo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i1OhtMp7uSvcDoiR+lYqupfs1AmgXKHMlQJc+fUjm61RZP5+VAjBF01eYemcsyyOlb+NSqZUDZn1ujXxdmrG4drF8HXUAK9JsRLGRhGRUBmyJu5lg9so+wtYVLkeWVKp+sRrNvzZVdVD7iFkRF1MT0MzgblxC7NTF5OuYU0Lhro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E6Mm559Q; arc=fail smtp.client-ip=52.101.53.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b+jRJY6YQ9qOf9FjVLJcKQGeI2rHUCE5NBKFAegqeU0FXLYlYrIlW7hbwzRZTt1Ne/+I7ufsAvsVWaoHhCGAkesJ7lEdA3Gn29xv04v6PGoWddcWQP+8kjJJ+OpMQWED+UGeJIunWBQ10BAopAb1kz+zNBedokxVvtXStbyroYrW9XicY9OQaCwAVbQoQI7t6y1hfrVAtUTreBByNXjkOzVxT7HWcLaPFigcqQVqdRQYaXwwlxYfp50bwTiwtIJ8EnignaJCwxtN+DGUKi2lqeKlfrhfo5T3uo8grUSqNvBDEmM8Vc6pzL1n+hC8JWfJEJXJBTBCgNyqJ+I5xfwtbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcX9QMnVXZlDlu+zVlayyyUhx2obSz/LyuuTIwMvbmU=;
 b=JJJl1eKxpmDoaeElR0Z9/WN/XSN+WKX+u315V4/JVfLZC6S35dseFO7Y5o217/We+EcPLEKoXX5ZV18Xcd55HqdNMjWNI5T6SXzvOnesJRKQh+Y2LA8GYi1RIW6bQfbKNXBSBxNl/Q4d4ZzOalV/dsWO+fxcKm5EsZrQAqYrmOP2OkNLSM8Wu7XvTpWwdbcMAf+Nq9BiWAI7hCsMyp90XCmAF5PM/psikmvMLodjH4Z2GEbuIkEkEsRxkXxOqQWY2o/XTQsqMvIQoyyp9m0jAgifB+YbnqbtbEgbFNWanr22ahJyhbthHAOZsjROi3mCZeFD5IzLNvd1gHnoqOYY/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcX9QMnVXZlDlu+zVlayyyUhx2obSz/LyuuTIwMvbmU=;
 b=E6Mm559QF6g0aSO7CLsl5RIKmADCho9sfK11C2eiICfDDesdxWn+xrzA7DVmuV1YlgRUoYCMKAci/Knf4VTt6MgdaieDgiXFKTNCDZ0yTMiO8Z3E/BBqCZLwxCbL2mdZyDiFMQC4ZICxSQ4G9DFezw7ZQVqqbelWe3DrwrONNdQ=
Received: from SJ0PR05CA0183.namprd05.prod.outlook.com (2603:10b6:a03:330::8)
 by PH7PR12MB6540.namprd12.prod.outlook.com (2603:10b6:510:213::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:05:00 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:330:cafe::d9) by SJ0PR05CA0183.outlook.office365.com
 (2603:10b6:a03:330::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.19 via Frontend Transport; Tue,
 23 Sep 2025 05:04:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:04:59 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:04:50 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 05/17] KVM: SVM: Do not intercept SECURE_AVIC_CONTROL MSR for SAVIC guests
Date: Tue, 23 Sep 2025 10:33:05 +0530
Message-ID: <20250923050317.205482-6-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|PH7PR12MB6540:EE_
X-MS-Office365-Filtering-Correlation-Id: 556b5140-4cc4-46fe-ae37-08ddfa5ebf2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ctzR5RzBuyWlABXAjhGgcgaEYXcnkcr0h4Ls2jQ8LOfwzyHO6UQ8eaOuswwj?=
 =?us-ascii?Q?DWHSe0Tvj+g5d6qs1U+mXJLLad0qRyRXmw4Iv7ANw3PXsiwpQ0aNSyBJXzCj?=
 =?us-ascii?Q?xUuTWrlMGlgMfPJxDC6trphEfep9AAFbirrkWv7eCwm8+0NpICeC5obF8wXy?=
 =?us-ascii?Q?YeRdZkSZU0C8mdQhgJj7q+47cbGafwbO2aSKB+e0/GD/Vq1Mu94NC+wWL9OO?=
 =?us-ascii?Q?7B3iezpjX52h2K5i0WiizfHRNpyfZADZtkErHHUvxytCAjuq8cYYtDlXakIf?=
 =?us-ascii?Q?/qswAlSMkK5e0oEeJQyM76Oe8fFwwSWsHzr0xxMwLGqxGuCjjI9VWfht9hhe?=
 =?us-ascii?Q?OIlYJN5pi02iJYkHIQF9rEFUomyb1bKKE9/JldmsxKwhwNoNdnUoeB1rl1hJ?=
 =?us-ascii?Q?f+OZ51wjoHx0nnaG6LjxYkddDQQ0e3Ergh4uZKvxxmxG0CnsatWC7z/Dn21Q?=
 =?us-ascii?Q?NrTZrZrR3lfcHKPRIIU5jTA9+C60AxHu1InDgRKmurWoCXWp51gUJPU7wwt3?=
 =?us-ascii?Q?W6UkFTN1sWInVFTe4c2TqXlVH8w16/Yt1EkYPN7GM6sl5TmokOIFskdY4gWO?=
 =?us-ascii?Q?ftsPcTwTqw9nZb1NAQE6YIIVvvBNHBAo+nabk00/6SekJLnY06sH3xDcvXJ7?=
 =?us-ascii?Q?AF/I1rq6mxW/Kj/bltyzF1E9OD6NlsL0bzlUYDubEqnF8VqwPShNuU0tB85j?=
 =?us-ascii?Q?w1eseW14LXY4z+3IqVPcWthgzykHwkOz3ZqdAEnfXzGJ4WvPTVx63FxPHBJF?=
 =?us-ascii?Q?rR/+by2LkDINwLMOU+K7akqEg+4xBAX3T8VJBmkp5jJqLbfKDtNnZc/FpJdh?=
 =?us-ascii?Q?36sf3qLIYqX4iXT2fCKiUIaw0Jg69JVA6Er3N37LaREeffKfM/qroazDXnWS?=
 =?us-ascii?Q?PchPDC+73r7MpaFW9m4Ju46kPAZTnT+dj8UhxTpWKP4pUMdF5WRSnNqsZGqI?=
 =?us-ascii?Q?DWA2f9VmLEFZhjmjVW8KJukAdnBkVm8QZWoB/jpNBQ/MioFCVIMJr+1cU1o0?=
 =?us-ascii?Q?7ywNivXHGomoTFRfsV1OEba8Z/FtEAqAENvxX5uWs/XyMVQhdpqAe4QMJR1e?=
 =?us-ascii?Q?fR+ll3d1r2yT6iBh4PcJeCMtfGQgd56c2xzyNELACc0QmjEUQ+/LhvIx10vK?=
 =?us-ascii?Q?/MOQbYU7Fna1qE6dB0e69VkkEX9c6AdqXC+R7nz1PK/ItC4ltszyBz/7F+RC?=
 =?us-ascii?Q?HuJny6fsRVO1h4iQF85H/k6e5H0ilOJ0eIJJlyoXkWnhdXZyxS6W+HQwoJI7?=
 =?us-ascii?Q?btbiu7Ui72tRfM2rinWJKZvWPhTOGHVRUKPtsHue32YpBZzce7uDrLYK2TAT?=
 =?us-ascii?Q?G9cvnU45I5IZkuP+NJlSP1JJVy/UWRaPEfl3yS0JeRXMEzsuYCEB/Dd8J+5m?=
 =?us-ascii?Q?hdNRkWLON1PFU3SXXbnmTLoC2fAS8HCGtW4q7oruWltOlOhspTQRZnJNka+X?=
 =?us-ascii?Q?vXGCVYTLYho4n3237NdzRWpVxf6Z7nqrByC8Xr/7qcwyh3KrBnxIUhu2K3A/?=
 =?us-ascii?Q?oJCKFaXAs1tV4aHD87hFTcgn/Y5viryjI8df?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:04:59.6418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 556b5140-4cc4-46fe-ae37-08ddfa5ebf2e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6540

Disable interception for SECURE_AVIC_CONTROL MSR for Secure AVIC
enabled guests. The SECURE_AVIC_CONTROL MSR holds the GPA of the
guest APIC backing page and bitfields to control enablement of Secure
AVIC and whether the guest allows NMIs to be injected by the hypervisor.
This MSR is populated by the guest and can be read by the guest to get
the GPA of the APIC backing page. The MSR can only be accessed in Secure
AVIC mode; accessing it when not in Secure AVIC mode results in #GP. So,
KVM should not intercept it.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 arch/x86/kvm/svm/sev.c           | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b65c3ba5fa14..9f16030dd849 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -707,6 +707,7 @@
 #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
 #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
 #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
+#define MSR_AMD64_SAVIC_CONTROL		0xc0010138
 
 #define MSR_SVSM_CAA			0xc001f000
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b2eae102681c..afe4127a1918 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4487,7 +4487,8 @@ void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
-	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_sev_info *sev = to_kvm_sev_info(vcpu->kvm);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
@@ -4546,6 +4547,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
+
+	if (sev_savic_active(vcpu->kvm))
+		svm_set_intercept_for_msr(vcpu, MSR_AMD64_SAVIC_CONTROL, MSR_TYPE_RW, false);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
-- 
2.34.1


