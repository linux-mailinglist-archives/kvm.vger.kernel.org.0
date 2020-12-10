Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36AB2D6415
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392558AbgLJRNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:13:33 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:37494
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390277AbgLJRNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:13:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IODUTILQkG9egPeE0slIf0/ot4Sf8Nr0qrl+V6zZFQyLdUi4IcrQ6m+mfiedRJqm7d300sugRjwL5pbZAm/Cq/HrEsAQWmNGiiQ0FqKkwFTOaOK3J2W9XzL35rU3HWbGCvPZ1stZFaT+IlJ6a1Z93Vcc2g27v6wYcsVkj2NqAfM3D2ZR94X9D6bT7vi2fZs67uYdaMzIGGtxDHT60UqK82WjX4xRk74kY6d6za5jwyDXCIneMz5w49C+ZMvTu9C6Yz2jxce3hDnisCDB1+NTo2KLFaOHhtk7o2A6Y/+FvIjIuITVcKbiX0NSyV5l96tuzSwk9Xhhgb8pX9XDNVHUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMSAUbVqemGru/527gfru/9I+K7McdmSIs5VZm1ec6c=;
 b=LSiQPOCxs++JYfWy1fmL3L+K/BQllxuobNr9waYv38MmWj3Ck3QwuvtN60tXsvIR9E3F5r/gK/DdvYdB/mh4ihxX4MmxFP0Dk7Kb3zhjgiZzc3DwqFTBLO92ohULbwHAQ7GpmzLc/44OpdMIJwoVwT3Da10gu8AmuM8Y8gqcRAAU4Wzj4YkwEI6+U99u8KT9j58sWUNfU3Cghr38o1VVhG74IoxnxX43fp/zr2Q8ru/A/IKp5SlrWGqkRjV9nlwY462ySaTYGoFSkMNTAJed1rrhfYhGyj7ukv/8k3FMJpghKJJ3kEjDLmnjROO5sBDrtylRmPhDodBO//4imZVypQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMSAUbVqemGru/527gfru/9I+K7McdmSIs5VZm1ec6c=;
 b=vONSx/5vBZ974nrqWBfBuv2ie7izTI3mHesv9m2PiUMd/NYAiTz1ETWkRfiHJBG42++5HXJ7H7CJDylmPW6Pdvzq+ojJzKsLPfYma7LYFmoZ/2fGgO9F7DhhpaqLd+B+7jtiBEBfsB1de34XxZ1I3/a8Nde9kpjwPp6EVOJGy6E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0168.namprd12.prod.outlook.com (2603:10b6:910:1d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Thu, 10 Dec
 2020 17:12:22 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:12:22 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 14/34] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x002
Date:   Thu, 10 Dec 2020 11:09:49 -0600
Message-Id: <c23c163a505290a0d1b9efc4659b838c8c902cbc.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR18CA0049.namprd18.prod.outlook.com
 (2603:10b6:610:55::29) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR18CA0049.namprd18.prod.outlook.com (2603:10b6:610:55::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:12:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 07837e1c-c515-43de-74b2-08d89d2ec20e
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0168E1EF6BFA57D099B28D7BECCB0@CY4PR1201MB0168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zfRzFQQAyh2/4UoRjxzBDvSDsCBXwX0DIgZg8PXoOXFQQL43vCoFa73e931MjVHoLbRPRxi6W+LIqNsRbqD73H6ViqVNSWLYUOpezY/Bgm8k52NG2KQ6zJJVkkpfx2irjlnuOzcPFanCW2sw84LRN4Y1Dehydo4M4OdZXLm4067cGVHzJp0JJDlsiBtazbKSZy5oec3yFHJA8A/eenfPy4/UGqrfCT8O9wM1oSkNpuFRoSbszR7rPHOzvU3rHrC1823+Jq87+UT1jjktCFjUcCOlqOoo0756Jnt003nSOzCtUULo/JoMEThj5hH+Seqzkv47wvJub2K5V8hzXOi6h7GSXXZod9emDecAzjPfCFLs4wfzufo374QcrqlHfFhH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(36756003)(8676002)(6486002)(4326008)(66476007)(86362001)(7416002)(66946007)(7696005)(54906003)(6666004)(26005)(16526019)(34490700003)(66556008)(8936002)(83380400001)(186003)(2906002)(2616005)(52116002)(956004)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LatfYD3ovN3MPUyFkxxaUOTsLQkAyF3AY8ftPNTWLopeeWYC1GPnVaiF9Ibj?=
 =?us-ascii?Q?6kkm0kUgTlCXoeZKwCZaFNsXGUS5H7mIKs9PnXkWQoZWrO3FjySjluXdnSFj?=
 =?us-ascii?Q?brHmSZZBHqiTBavWsg7Vuq1PesH2bvpF0YznKOmXMNkedIS9mLyPD1yY8Ge8?=
 =?us-ascii?Q?mhCYVwi0o/Q2iwOcoQ4Py/mhziyRU3GzHEkyw9e5iXmfmLA2W6KHak1mYKao?=
 =?us-ascii?Q?nGijRAc6CXj2WTNoPGONrOAvZCDy5u6DeOSXvb34AvsSYVtavS8KHrWAFpP7?=
 =?us-ascii?Q?vACdqf9iVyXeyNHwrSwMak+0iyMwWHh8aUMCCsQrk0B1t9F3YKToze37Lgwd?=
 =?us-ascii?Q?jXuQQc/Z822ZQQXglFdxuJrKvcVqJpNfgqphKF7+FXhU36+JmJ3A4UIewUeH?=
 =?us-ascii?Q?cpoTH/E41Xtlp8/hB4IyYGxzlRRoA2f8u1TJ8q23nLtf1ggn5wdzXEpBZpO2?=
 =?us-ascii?Q?cmGo0mrPmuydps9y47i9BGgI69lzYl0m9yx6Dk7hevsxWzQrVXWp+JFDq+Ka?=
 =?us-ascii?Q?74S5fnnhaEx6LZxeJKTO0N0StgyOGbynvqgmIMuPXTNBKVoJ97TwehtrJTeY?=
 =?us-ascii?Q?xBdB1HbGW87hPgUrgUOS18CmHwD8pQpTTaRByq/2PJoNW4h3uDQyI4Njs9d6?=
 =?us-ascii?Q?I1/J/xTo9lDle7cCtd3C45OeFnxT9jPafWbzEIAM9F6iQOdqzgdkHMVDsnvb?=
 =?us-ascii?Q?DbUBoV5jqFfjiZ2vdnyElcs7bISFQHJVRHYZzLsbhNEsqjTjpuJxeTaNXgWo?=
 =?us-ascii?Q?83kFC5Pr8Xt722K9uuZx9qG/wlSRT0rKjXO2LhVqAmaDPhAGoMZafkbEeFuQ?=
 =?us-ascii?Q?7a0bNIGTtW0lcmLNSPxbx69oiFiPrMzvLPNWqNvcEwAjtB88FFsw80K1WA9z?=
 =?us-ascii?Q?kazmcr4bTTD3l5zWOAxkehA33B20BSbqJ9dJd8xR9QyYNmtpHD75eU78MxJN?=
 =?us-ascii?Q?sjRXIVSxMn64l1x40TbcB3LF3eZEkfT3/4Z0erdon3Ud54heVosgBb4GGdmD?=
 =?us-ascii?Q?NKmu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:12:22.1309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 07837e1c-c515-43de-74b2-08d89d2ec20e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agQAVBtkRxbqLMxHmHnalu21QDjnOfTHBHSiWjpMLyODDA8q+ER5yyQU0U9lCSjXibNwj/paFRqpNhQ/pjrtWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0168
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB specification defines a GHCB MSR protocol using the lower
12-bits of the GHCB MSR (in the hypervisor this corresponds to the
GHCB GPA field in the VMCB).

Function 0x002 is a request to set the GHCB MSR value to the SEV INFO as
per the specification via the VMCB GHCB GPA field.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h | 17 +++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index da473c6b725e..58861515d3e3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 #include "cpuid.h"
 #include "trace.h"
 
+static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -1142,6 +1143,9 @@ void __init sev_hardware_setup(void)
 	/* Retrieve SEV CPUID information */
 	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
 
+	/* Set encryption bit location for SEV-ES guests */
+	sev_enc_bit = ebx & 0x3f;
+
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = ecx;
 
@@ -1500,9 +1504,29 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
+static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
+{
+	svm->vmcb->control.ghcb_gpa = value;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
-	return -EINVAL;
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	u64 ghcb_info;
+
+	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
+
+	switch (ghcb_info) {
+	case GHCB_MSR_SEV_INFO_REQ:
+		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
+						    GHCB_VERSION_MIN,
+						    sev_enc_bit));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 1;
 }
 
 int sev_handle_vmgexit(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 89bcb26977e5..546f8d05e81e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -514,9 +514,26 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
+#define GHCB_VERSION_MAX		1ULL
+#define GHCB_VERSION_MIN		1ULL
+
 #define GHCB_MSR_INFO_POS		0
 #define GHCB_MSR_INFO_MASK		(BIT_ULL(12) - 1)
 
+#define GHCB_MSR_SEV_INFO_RESP		0x001
+#define GHCB_MSR_SEV_INFO_REQ		0x002
+#define GHCB_MSR_VER_MAX_POS		48
+#define GHCB_MSR_VER_MAX_MASK		0xffff
+#define GHCB_MSR_VER_MIN_POS		32
+#define GHCB_MSR_VER_MIN_MASK		0xffff
+#define GHCB_MSR_CBIT_POS		24
+#define GHCB_MSR_CBIT_MASK		0xff
+#define GHCB_MSR_SEV_INFO(_max, _min, _cbit)				\
+	((((_max) & GHCB_MSR_VER_MAX_MASK) << GHCB_MSR_VER_MAX_POS) |	\
+	 (((_min) & GHCB_MSR_VER_MIN_MASK) << GHCB_MSR_VER_MIN_POS) |	\
+	 (((_cbit) & GHCB_MSR_CBIT_MASK) << GHCB_MSR_CBIT_POS) |	\
+	 GHCB_MSR_SEV_INFO_RESP)
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
-- 
2.28.0

