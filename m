Return-Path: <kvm+bounces-39679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88194A494A5
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2042C1894BD0
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5280A256C88;
	Fri, 28 Feb 2025 09:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0IA5aiDl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF8C24DFF5;
	Fri, 28 Feb 2025 09:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734336; cv=fail; b=FqWb9s6VSMaRiSYBl1WMfL7w/rIHMHwAagPSivHRWeUS9emG9a3JyPifIsWyzNDGnKwuCjTehbnjODF5im2JfJXYuFmniQskmioB/RLesBr+gpGCdALxWYMeXKW29Ajsb/4Lud5DUCXvhZAuWQLo+YGtovKD+mDFe8m+WqWqAVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734336; c=relaxed/simple;
	bh=kduU1XC5es3TnjditFVb994gpJtps1kz6t+YZ8vQG/Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oITCUE43ET03tB8dqgusLb/eDktXYyh46mBtkavwjcbpisswpADgOKwrEGGpV9W5NqqCD/jo+PcTrssZWuusTrIQXtCy3XM5uiqfjxfrlWzUKU9pH73PBSGcVtFrmV6kR6YuUr5omitsEXFRLofAIRy+Wuypk7/wStvwvriLK74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0IA5aiDl; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qp1tuYPO7wfzv3VNWyieAB3Mvy/jS38O5jZa3ed83+klED70t3a7+TRN308h/5fHTk/Icl1YckLh4OTQOZ6bFpOKxJIrCe6bfgYVmW8sR9CV2aLkLe+jgCYqcW3F3QHkN1CZ/d9Sd0xhTzAE4V7Dc4jXFx5M4iA4eEkuJm24VbCrlEYnpjToop9ZSeMQizk8tWtuq2zkmMNj0gQxy1Cp5demJzEZ6eI6ai3dkozDxhvZRY4PIGjhBfaKuFzdKNnAVclVvPnIh7nn0nisb+a/QPtSeOpAWe7bnur26sLfx5j+7DkJ/sTPG87RZLYT8jdOK+t1hE5Av3cPRzaOULug4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dsSkb1coara77qY5f1uZxJboPiy9PEgzbZcCWKgLhtE=;
 b=Ei3NZYdLQTLwTmTgHxcfwyTEUM3mrNd+NOmHKU5HICWVTceHQPv/d6LN+u86gMI1JNWq2jgMnhQWBT3IVz4RDJwCOSRgFyvwfeX/pMgMQb5a5VzDpzq1L1Je8J54RSNApWWs9CULdisrxfAw5uOyIYrh7h1rhGDSc0aQ5jdckquGiqkhK4r6EhOH+jtlTmYl4Ib49sJi0Qr/Flv5vkUVFopHF0CabnIiBzkSrvgttzYQO0yRZ+TmRqys2f1A+l8t2Ms6ixkXEHfxq8V6CUaJcDkTACsYLJu5fmzd0VBNTMiNfMz46uFiobvkt9T6dfwb0e9/+ZFVkyk8QbYPe6hF+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsSkb1coara77qY5f1uZxJboPiy9PEgzbZcCWKgLhtE=;
 b=0IA5aiDlEZb7NSKB28cisMMULSlYOKHyD7/iL5rO+DROkA5AWldn2W7jtYU9REUhxc/ffvvAFEgMt/s+DgZi0y2s3TxtHGfIJpppqggX3RDk4ilagj7P8UKncbnw9ATDCg1NbesKupnkWkQp2viKY/jnM4Jigi/TWk/suLCo36Y=
Received: from BY5PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:1e0::13)
 by CYXPR12MB9441.namprd12.prod.outlook.com (2603:10b6:930:dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Fri, 28 Feb
 2025 09:18:50 +0000
Received: from SJ1PEPF00002318.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::f2) by BY5PR03CA0003.outlook.office365.com
 (2603:10b6:a03:1e0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.21 via Frontend Transport; Fri,
 28 Feb 2025 09:18:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002318.mail.protection.outlook.com (10.167.242.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:18:50 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:16:11 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 14/19] KVM: SVM/SEV: Add SVM_VMGEXIT_SECURE_AVIC GHCB protocol event handling
Date: Fri, 28 Feb 2025 14:21:10 +0530
Message-ID: <20250228085115.105648-15-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002318:EE_|CYXPR12MB9441:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c892643-e439-4b8a-8a0a-08dd57d8e9b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cm1seFpLNUh0OXh0dnl5NjVJL25oRkNPUW11TTFpRVVKQUoxR05GY0dZYU5Q?=
 =?utf-8?B?NEJjTmUvZkI0aHp1aGxGVk5ZNERjTGpGeXNaV3ZwbEZGRlQ5RklmdWI3QmdL?=
 =?utf-8?B?RTN2UUdpWDg5ckhMRktnYS9CUkV6bGluSE5tWnIvcmpkeExvU1J4cVFRVHBj?=
 =?utf-8?B?ZFhYQ2ZnRHhNYmZvSUZYVGdRZjBEdXh5SDNQWk92RG9ZQStrTHNEeG1jZ0hH?=
 =?utf-8?B?d216RGxPNTJnUUNoRzkxU2hQb2ptdlpTeVczS2JFM2xmOWNOMFlvajBRazdy?=
 =?utf-8?B?Zk5iM3IyUU5UZkV2SFdUaFRvbGdPK1lvQ29JbHJSUHdRN1lSN0RONENoNFhT?=
 =?utf-8?B?R0U2T1RjWVRsY3FFMzZsMU5aZE1nQ1dxVS91RHExSVpxMGJYYnc3b3FtcjZH?=
 =?utf-8?B?NldPaTZpMVR3ZjZZSlFiYzRzdXRVZmpmVEJGcll3ZEEyazFSVklINTVjMDJD?=
 =?utf-8?B?am1UUnBuYVNnMEFQYTlNdElPa0RMMGZCQWN5SUw4Wkx3MERNcnN1TktPYlo5?=
 =?utf-8?B?ZmpKbktrcWZhQ21rYW4zSjNyQXF5Ny9kL3d3RzRDakMwOU1zczBtZFFRQ0Vs?=
 =?utf-8?B?bFprc2FCUVY3UUpDV2c3SHlvMEZIcm1SWUhBT2JiR2RDMWx0MFNEclJjdnhO?=
 =?utf-8?B?SU8vbE1UdnltUWhTUnpBUGFia0RpZTlNc2c1ckpxNGl1UkZGOExEVzlhUVN5?=
 =?utf-8?B?RHZmZ0dnZ1lCR3ZHOTJ6WStLYnFnbGtSUWhhSCtTbTZjdE9CUnU3dml3Tkw3?=
 =?utf-8?B?Y3k3bTRZdStKTlpPWjluZXFSb3N1MmwzeUJ4bmI1TVVTaE1pRTQrazNTRmZK?=
 =?utf-8?B?K0FvTXpZZFd6VXljZ2E3RjFHaks3bjExcTl4bHBQRVBab1J5YlF5MnRyUVY1?=
 =?utf-8?B?SlNpTEtSZkYxbmJHSkc4MGVJQ28xZnZNUkphQ0JFbk5QbUJ1WDhLQnpPM083?=
 =?utf-8?B?V2JNQk5rbFhSb1NiNnI3ZTVlVytNbzhhOUZtby9sSzhmLzJQSXNwS1F5T01L?=
 =?utf-8?B?WU5FT2trd1hVS3hEeG42T1hGV1laMHdPQWxKbnUreGoxOHcwVUpLTWwxcXU2?=
 =?utf-8?B?OU5XR1pidTludmZEdjdFSWRWRmdjMHVmcWtGMkZnMHR1UEhiYVh4MWZFZWk4?=
 =?utf-8?B?RVhwRjM2QXpxS3RNNjYrNkxNbkVYeU01VEJ5c2NDVFdjZ3NWSXljakFtRXNq?=
 =?utf-8?B?TFZpS3I4djRzbzhXTmRLYmRkMm93aWFVaTJZTmRyRkVxbDIrUzF0ZXJ5cENv?=
 =?utf-8?B?SVdBeFYzaGlFNHUrK1N3UFduMklFQmtpZkVCUGx5TWFoK3RXS1ZhWHNXMVA5?=
 =?utf-8?B?amFkZTBKaVFQRnJHOXUzSzJTQmF3TjJRSHdDRy8xSUR0eFQ0UmJxdGVDeTI2?=
 =?utf-8?B?VGNmdTVwYkdRQXlQUGw5VnkxdlRUN1BZdFVxeFlrM2EwWCtoOVJMb0FrYmU0?=
 =?utf-8?B?LzZzYmluTUl1SEw2WDN5SzNTcWt5OXVON2U0RWtyclZYV2ZWcUZCYlpLTDRV?=
 =?utf-8?B?SFA4TjJtRFhBbWZ0b0JocTJ0VE10YU5QbGhleXQvbnFYMitKZkd1bXlkUmlU?=
 =?utf-8?B?NWd1TDBZaGs4dFJaRTVuNU5GT1A5WmhwRml2TVBaOVVoMmZaRVR4ODkxSTFp?=
 =?utf-8?B?MFYvWnpJZWFmZzJESDdrRFFCL2l5cEdxelI3Q2Q1Zks4RVdRNnFtdW5ieEht?=
 =?utf-8?B?NTZFWVo5UTlDUFZVTnk0T2dZQ2NHYjVVamJHY3VWK2ZYVmU5aTBXRGs2bFZJ?=
 =?utf-8?B?U2pNTElhanJKTXR4SXVHOG14ZmlhRWMvdUxGT1ZwTWk2UmZrcUFnRW53UndL?=
 =?utf-8?B?Z1FwQ0ZiQW5iRUMrMGU5d0xQMytiZXFBVFMrVkFzTk1KWjdvNW0rbjU4c00w?=
 =?utf-8?B?d3ord3JHWWtOU0MvT0szSWJrSU8wT2NzN3FjTUJvU09VL21vd1pxL1N0SFBm?=
 =?utf-8?Q?qaDw6YLasNFjgDMfh9y8M8iIwhdt8Tah?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:18:50.0038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c892643-e439-4b8a-8a0a-08dd57d8e9b1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002318.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9441

This GHCB protocol event is used by the guest to notify KVM
of the GPA of the APIC backing page being used by a vCPU. The APIC ID
parameter is used to identify the vCPU to which the backing page
action is related is assigned. An APIC ID value of 0xffff_ffff_ffff_ffff
means that the backing page action is for the vCPU performing the call.

Secure AVIC requires the guest vCPU APIC backing page entry to be
always present in the guest’s Nested Paginge Table (NPT) while the
vCPU is running because some AVIC hardware acceleration sequences
may not be restartable when Secure AVIC is enabled. If an access to
the guest's APIC backing page by Secure AVIC hardware results in a
nested page fault, the BUSY bit in the VMSA is set and subsequent
VMRUN fails with a VMEXIT_BUSY error code. VMEXIT_BUSY is unrecoverable
in this instance and the vCPU cannot be resumed post this event.

Two actions are available to the guest to notify KVM of these pages.

• SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE (0)

A Secure AVIC guest should use this action to inform KVM of the
page-aligned GPA that will be used as the Secure AVIC backing
page for the specified vCPU.

To ensure that the backing page NPT entry is present while vCPU is
running, KVM does a PSMASH for the GPA if the corresponding NPT entry
is of size 2M. Without PSMASH, it is possible for other allocations
to be part of the same 2M page as the APIC backing page and any
modifications (page state change from private to shared) to any one
of those allocations would result in splitting the 2M page to 4K pages.
This would result in zapping the 2M PTE while APIC backing page is
potentially being accessed by Secure AVIC hardware.

Setting a Secure AVIC backing page GPA automatically clears any
currently set Secure AVIC backing page GPA.

• SVM_VMGEXIT_SAVIC_UNREGISTER_BACKING_PAGE (1)

A guest may use this action to inform KVM that the previously set
GPA is no longer being used as the Secure AVIC backing page for
the specified vCPU. This removes the requirement on KVM to ensure
that the specified GPA is always present in the NPT of the guest
while the specified vCPU is running. KVM returns the GPA that was
currently SET or 0 if there was no previously set GPA.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---

Initial GHCB draft spec for the new GHCB event for Secure AVIC is at:

https://lore.kernel.org/linux-coco/3453675d-ca29-4715-9c17-10b56b3af17e@amd.com/T/#u

The GHCB event has been updated to pass the action param
for GPA register/unregister. The new GHCB spec will be published soon.
I will share the link to the updated spec once it is available
publically.


 arch/x86/include/uapi/asm/svm.h |  3 ++
 arch/x86/kvm/svm/sev.c          | 58 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h          |  1 +
 3 files changed, 62 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index ec1321248dac..0a1e8687f464 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -117,6 +117,9 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SECURE_AVIC			0x8000001a
+#define SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE	0
+#define SVM_VMGEXIT_SAVIC_UNREGISTER_BACKING_PAGE	1
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 40314c4086c2..77c1ecebf677 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3400,6 +3400,14 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		    !kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_SECURE_AVIC:
+		if (!sev_savic_active(vcpu->kvm) ||
+		    !kvm_ghcb_rax_is_valid(svm))
+			goto vmgexit_err;
+		if (svm->vmcb->control.exit_info_1 == SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE)
+			if (!kvm_ghcb_rbx_is_valid(svm))
+				goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_MMIO_READ:
 	case SVM_VMGEXIT_MMIO_WRITE:
 		if (!kvm_ghcb_sw_scratch_is_valid(svm))
@@ -4511,6 +4519,53 @@ static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static int sev_handle_savic_vmgexit(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = NULL;
+	u64 apic_id;
+
+	apic_id = kvm_rax_read(&svm->vcpu);
+
+	if (apic_id == -1ULL) {
+		vcpu = &svm->vcpu;
+	} else {
+		vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
+		if (!vcpu)
+			goto savic_request_invalid;
+	}
+
+	switch (svm->vmcb->control.exit_info_1) {
+	case SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE:
+		gpa_t gpa;
+
+		gpa = kvm_rbx_read(&svm->vcpu);
+		if (!PAGE_ALIGNED(gpa))
+			goto savic_request_invalid;
+
+		/*
+		 * sev_handle_rmp_fault() invocation would result in PSMASH if
+		 * NPTE size is 2M.
+		 */
+		sev_handle_rmp_fault(vcpu, gpa, 0);
+		to_svm(vcpu)->sev_savic_gpa = gpa;
+		break;
+	case SVM_VMGEXIT_SAVIC_UNREGISTER_BACKING_PAGE:
+		kvm_rbx_write(&svm->vcpu, to_svm(vcpu)->sev_savic_gpa);
+		to_svm(vcpu)->sev_savic_gpa = 0;
+		break;
+	default:
+		goto savic_request_invalid;
+	}
+
+	return 1;
+
+savic_request_invalid:
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+
+	return 1;
+}
+
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4653,6 +4708,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			    control->exit_info_1, control->exit_info_2);
 		ret = -EINVAL;
 		break;
+	case SVM_VMGEXIT_SECURE_AVIC:
+		ret = sev_handle_savic_vmgexit(svm);
+		break;
 	case SVM_EXIT_MSR:
 		if (sev_savic_active(vcpu->kvm) && savic_handle_msr_exit(vcpu))
 			return 1;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 62e3581b7d31..be87b9a0284f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -329,6 +329,7 @@ struct vcpu_svm {
 	bool guest_gif;
 
 	bool sev_savic_has_pending_ipi;
+	gpa_t sev_savic_gpa;
 };
 
 struct svm_cpu_data {
-- 
2.34.1


