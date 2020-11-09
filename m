Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B832AC872
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbgKIW2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:28:12 -0500
Received: from mail-bn8nam12on2053.outbound.protection.outlook.com ([40.107.237.53]:4576
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732067AbgKIW2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:28:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nt/q1QMom3I/Ah48JJY1vr8xi3/8E+xfhSyPTZajnGF4APTKBO29jsQzfwSNuzcFCQ7nBvFAxjARgr9a56uej3AYoYi7yoqAKUcRvykQW3qGe9BUSdoc5M4z0Za8oWdleW7UQyquvj2TcqnfSQKY36YVQGPuYXdICg3gU+j6CJeEGY7YGTSSr6VYiDFpx+c3+Tm6800r3+k45cVh6uGOdIx50q/xVCBF+jdV8JIVwDe79L/YuMYriUCGLu4+5j4D+Wcqw4zpsmtXdlb/IfIbN63kx34sdPlnLlRxBQ7TX3uIT7qs2Ns6Sx9Snsz5rIrOSGUR88t8aZREO8AUJXiXiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnO6zLsx73AXCJV4dEKRMJuT2R5jp0XN6FHm2xZOH1Y=;
 b=RGgNJwk0N1zYyXwpA+E96mykAJT2Sc10XFhjYCY5I6mI3jCAYmx108xkEIIwB0qOKexZ4LVqHnr1mK2+oFwqorTJxDZssJdVF3pQ2jSlfQlwGbmKxUGXwBXySkcnVmc9QZifVAG3xNnhtH2DSiyu+44ebBdFO+hiZUZmSGD5Ohu5H7nzyfmjo95gRCfqtCrk/Vv52kFWog5ghWtz42pMuqyXNwf3qstMjA7n7oMHsxLSFs/IuVjX26aymKcQ/FyhJ3M6Jw2hBswX9PpmKyDOEUC9YWOrD5iV/x0HU48kvoQWriN6IUAfiGflDgaziLXHMBwxwnxkbk+OpVWZpPYSWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnO6zLsx73AXCJV4dEKRMJuT2R5jp0XN6FHm2xZOH1Y=;
 b=HRV35I5cK+4dQYNfLEOmwXof4G85tg0ZeEJ9FT+QjC1RmyitMs/dZLWImFfAWlnLD+BR2OwaMWrTa9ruhh8Gzd1NcBcthnj7bzj/TU0+leCBS5yVDecD3EqiWtsdET9NVo2lvoFXo7WMTx2RYoIuh7jd6g/lGaqZQRolMSAPRvk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:28:06 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:28:06 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 14/34] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x002
Date:   Mon,  9 Nov 2020 16:25:40 -0600
Message-Id: <fc840f92057a90aa6e1e9e9edee581910c983f65.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR06CA0060.namprd06.prod.outlook.com
 (2603:10b6:3:37::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR06CA0060.namprd06.prod.outlook.com (2603:10b6:3:37::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:28:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b8b08ab-979b-4ef7-ab70-08d884febadc
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40582715F03EA33EEB93FD28ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 353/NVoZe260f4UfhZhhl/iyCPf/cir50wTFoHlsYso3l0inOdrjGlxur4WY8FvVJro/bafoRNZpRdgnGUHyUXmcnbRYkb5rEHDm3QezsDA1SqYN7hHD8W5OWrDHDYaaui8MM5UKpbAkTkJwSWNsGFxJnVEInRECcIwFiOi0VYSv3LKRYyuMoNsHf79hGYwT5/mmATfIfo5F3aQSqUm2sGcl1s1SYNqRtguWaiJ+7sbeK0Elyc9Zdc1ttu9+N83JEnycTeKRHVwcOcKkamNx//v+sqg0rE2Y6KkOfmzPKbKa3qoowY7EOJTggeW5foJg6vSCYrX1cdQ/1xkfcM0TwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uhK2eoQRYPfUMoc8WVYpsV4DEvE70wEHqS287phxRNrPCE2KeQn39hTB3Zpw4UoCQvwZ3fX6eMp4ZNs6aehYS2tpKSVolUEx6GQNSh47C7X2XbSxWLH0JosokcTXh4UeUrflQwWDkdNbGyVyHonhpneX3Jzlsii+n+AaVq00xVQdH+2fdwt0MOdlhlnKbyTGZzi4raDHCDBMV6cbLR2cZQNgk5fVaP9chQnMo/4YhYu22HqvXKe6/Y/Hg61cbCQT+LIMqspnBT4hoq1+26Wo5Ma/VWMguV7Djy+be4TeVyv55aoSvfclHSBA45yyvmgO5mkFJ5Zbkj5BSeINTMKRQic53NPDbmfaHuBpTvoDJS1qWKrBdg3/t9FAOMaNLJ5F0/RA9w69h6jNIKwlOZP+R0XpXmWN3GrDevBmxm6kyeA1QMwK/SSRRz0WFOQa9akcqnffTjL7cGGoUkhlGkxHUmukFNZpKXzwV7bcwVv9ieYRyrV8I13ClGwDCr+mBkWLClJibcUQaxnGmtJ7UJpRBjXHphid7Q7JLpLLSG1lyDCh7EynC3xbF9TBOrOBnS9KKB6wVot/g3ex1fV3SLSB2u0v6ndyAP0FwWKmA87MKvexwwCwiRIWO1mrfhqqSXc0WUey8RvEtsQbhD4uAvqIwQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b8b08ab-979b-4ef7-ab70-08d884febadc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:28:06.5998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: znD43Rc7y+YmFY85aFqevosONLGWGxK8BUrfK9zUxjIgzCEeMziLjrmpxwsojAHgbPnPlRdoV1YwwgxPTilegw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index 6128ac9dd5e2..204ea9422af5 100644
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
 
@@ -1497,9 +1501,29 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
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
index 4ee217338d0b..b975c0819819 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -513,9 +513,26 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
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

