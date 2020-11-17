Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429C02B6B38
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgKQRJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:09:46 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:3169
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728921AbgKQRJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:09:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bp8U7HXnq67S3WsWJiOxdpu2EYRw8WWczEGdLxnAjeVfgj8a3n+qYtmgUmDuWaOlBB8TueiLzTBMYVmE0cZF2ZYr1KJYPkPaj/chXn6Yz4N1VQVCLUWmmSJdkkiXthF6muz1LxEcNfj88LLS9JmdNxlGv/pcu6QC247MLrYhyEC7q+4gizK+Uxx31+M5YSihYTKeXQmDPecNvGNq90S0GkAaEOpJacZNABjdv1Y4wELw7vIXyuDPgaGGBuEeKAx2KMbio4mCCEjsij1oLKylzx9SPN3RY7vdYgLGXfZBIMGcQGqqMYQvkXAeLx9hKxVhQSyPEDcNCAtA/vChgIJxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlmCz+0TYPvPoGssDoHYDYZSJiCRJyCrr3lYvG+FsZc=;
 b=fyIU+fsYHVQuXNpwk/lyYZE0v8n0341zV7ZKm/LVjB5MhI0ccWWuSAXCg5epSixmFEGLgqofm9B19F0JBB9De5EbniljApqH0MkvNRLIJaOYC7S0ARu5fbqpc1BpeQVklDIY/bePTEh+Ph7CVyz1m0PkBBJPTd+3YudVqhGWHLBmT208OjzqXuI24pY5TTkeXsR05Iyye0zTyOVgldHGpDoy0qDJiYPBORPVLhBkauBT9iTCb5dFBo2vyfpTdE3JN446HnRa/tfN8qhIvcefcfgWBbRcD2D41RDGnFgiMk0F1Ub7GWGi5VH3nSiKtjL0WP39ARO3xilKc2y1QLTQtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlmCz+0TYPvPoGssDoHYDYZSJiCRJyCrr3lYvG+FsZc=;
 b=wc1xCOmlg9NNQeXoNVAp+2CJ7XI+6VsP3gZB3I7JsCS7BmynTd6ChvUiBJCf7HE2gsL+oub36MIC0YaHQqzV5GSUW7tS0RPQ2xlv4rsq3vkDB0Af6+gsUGmXUMOTit2kL6Hjn2dlFZ8w5sBOowIQN4Bt3EoYauLA2cdyT7zjGEo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:09:38 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:09:38 +0000
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
Subject: [PATCH v4 14/34] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x002
Date:   Tue, 17 Nov 2020 11:07:17 -0600
Message-Id: <ab217434007c8a43c136ee36119e202b4ab17fda.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR06CA0088.namprd06.prod.outlook.com (2603:10b6:3:4::26)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR06CA0088.namprd06.prod.outlook.com (2603:10b6:3:4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:09:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ba35444-1eb7-47f3-ca9a-08d88b1b9082
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB177229B99B6084E6F0198192ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sa6vzRVteaM0XVTs3UllQBtsFV4TI4HlG6hZKqAxb8WvBkeBqSOzUVJU3YH4dXljIkslY4trJaARo2nzRkHwRopRZovj7nZ3UQVFdmrdqNGXh0KMBFJA4zLmT3FllqODU8nWiI7m4VWj47rtS22hBWKQ8mEP6Wk4kQeH8KgnpSB6gTMXNivjqhrVotE8ttXhz0GGga63nXNLBdcYtiH5SntWxZI1yQMkj6wssSFfkyqF4ND+NbOgBHRTtd1VWnv8vKt8y7FMkUXXBa2Wrd77nL6RC/giwzMLrGfdZs7LoRdSrnpubFACbdua/aNv3ryGOiIxW9ZrE65q6+16zmTzQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LC1B3u6crTt/3xQq0kLOTmdY8ZogEum7D6qf4hZ3Q1wuqzp7Zs4iTzi8/rwWSQGPhJBZkKIE5gXNzTKBTKbBOhkhxhyrtnibKR0DenJwkFvkMOaygC7N1AzIgI3L6qnzRxqhjhgHR5vJvZ6RiFqbR3dXKapUOf9CRwrf2aVMoug8/RFOZEd//CusXs4lQ6FlUBxL1WaLJoKe3kOg8VIaNteQpV4XkUA3yfjU+VJPHqLC+yVQQ83OIo4DqJHUL8dhGTw5xYMsvZ4rmYKIKP6XW6dABe4OQMJxeVJKXsFMOe4YgrvaAK0vF+jBusmdVOeMkgaezfULkMehEJyNMxGYKlHhrQPIG7xVc3M3T1dgiZncnGwgHa8ltDDSEtoxRpG1bMx67HXobPycw/BDXitqi0FM75sdUrY3v4ZA2t/y/O+qGdDbKcps+hB3bLBJupfKnykqIr1HFMmhbQ88+SDllQMGs0uRZoBzNnxwyXxeaogxjYGCLS9I9XweOUSqDQFU5TSz1/nozY+0tHwW4r3JE/UE/sU3KR6xGMnINA3jYoim8iYMle+/ewV7neY+TZsrbGn73OVqSBIRS0liuBBjgB4pRCskr+PWxyOQJ5kXubKEJgmuSDhepJOfKmwqOO7sWgH4jJxmE1W4ON6v63mfRw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba35444-1eb7-47f3-ca9a-08d88b1b9082
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:09:38.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pE9oUVfsFVIUVTAjdBz/vLQYFFUh/zDD7rDwDHyWABMgyMzYYHGYnNiS3drk+Flhsg8eHKr6W6zjBAORwqs9fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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

