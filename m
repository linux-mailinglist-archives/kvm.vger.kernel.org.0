Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EB32696AC
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgINUa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:30:57 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbgINUS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:18:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtgKOonny7YnCx0P1jth7AA47HcF/m0kwvsL+gx7THSwb2kvJGv5dkoy8BsDZXB+Hac1F5zbxgfWEK9Dg/2AqmDqpXhmDnHopWKmFJILQr1km2GuEqreVUejsOpb8xpicn9ROo9pdw/sa6/h6/IYQIlpU+8wA9i/LDh/N//rFJQ8KnGwDiUsI8uJuCdVIZIWW6LpYHvgzTA5V+XqnTMz/4J5SpunvQEhoNAF9uq4Lw+r+lWiqRZII96Ooz1XrOxHmHEnUoh59Gc58XcAljjVfxTOd5wjxRQzeHdh8xyiNY5sI+tc/kB7ixvOPSa5HP5cy5vDFmTq0poPUly6h1eW8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dsm7MhJiYek0PTUZS3UBc0XnHSKpAqET/iou8FFRtOQ=;
 b=aLuA5I6zC5Uox79MXG0uVU46cvTOfwL1g3z3L0D9kRqQXUAtWGmLPf0odPMAhnfDExqwCPLYHk/MAhh2juJJynjiicfY2pmONZbUEHsADFK+bYWo/MsFlNYlL4mWUrKV+mJx02zzBJz7sIPAwaRqiEb+D7H0rqyaWXRSVAGVgEp5n/JGgmM3BrBlng8CuS921Yj5KKDjKW+e5P/Fe5HXKReslnxvin1MfzURNpX6r8qcezDi3OZM/vRCXaefSpcInceY8hoHDpDj89onQzhb8ae/mg3jYm5AQLld23lDsT4FWvR7OEdJAN+LiGCus9D8yhPwd3Qt2K0NBJyJDVkXMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dsm7MhJiYek0PTUZS3UBc0XnHSKpAqET/iou8FFRtOQ=;
 b=SdcohynvQqtkXhmL7j9dnIT9KjceWpDZSKzl/SMlIXSVePC7nrTFSz1fi5MnePUyTGrrXKU5bAYQ84W38o7xSszGejdOhnJx26KKgZkoO7TE1t415cpiI0kZ+1Zl+zGvRehzBN2N39KoGdDJruQhqeh2+pCuZRtlDBA5BC5Mt2E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:17:50 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:17:50 +0000
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
Subject: [RFC PATCH 14/35] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x002
Date:   Mon, 14 Sep 2020 15:15:28 -0500
Message-Id: <91ddbabb64a338c59bf5cbe554d537d0b72464d9.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR16CA0023.namprd16.prod.outlook.com
 (2603:10b6:3:c0::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR16CA0023.namprd16.prod.outlook.com (2603:10b6:3:c0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:17:49 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b0943643-bbf7-4fe6-a4b9-08d858eb4091
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1163AA5ABDE75B303245E47EEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HbzOLhHtQWW4OF/fNwBXp52/6yn+AYQ7xAV9s1G935Q4yv0Fw+9OnI7fzYgCgE8a5BuZYa/GNZiCsuFFRl+DZL3wAqnzKvq+NfTf8FM5v62bG9yljfCxUWEJanV0TmRoAThIhrWfM5BVx9F39pf1Ivm/dCzXDfikzp+D/5XTeav/5mzqf00hDYAnh+7HXunuw+G6fXpPfX+huboUFNdh+KAd/srnR+aM8hEC1CptofarOqnGshCYK2SSJwuf+kaAsb1FYsd5aOq97WiMMIXj4K79neXiHdBoql/9h+e9Yk54RHUMm8rAn9ZGLFXfWcV1a7KRUam8BUsKicjj/XAl1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eurorStjFpmB0ZjtltoYDSbZZhayzePpzgGnKws6KP6LEicNYeoXUW3foRjMCIrUgkL3eOHeCPsBkJZpT2DP/bIt0UMw+MeEJz7MuzMzNFMwBdd0cDxmewlMNcJdMMmrWJSlPzjRTyPUiEiZJGs6qOqs19GCDjnjKQUVljNpifYOHPY+8w/jrJwRvCNzIh42qkgz6/LgO594+vcZdFP0ruUeP3nbFiH+8ZpmO94IDl1Eev7fKNfDilspgk+yQJy4lGiR3wpV+JON22KLTA0Nfl2eZvUdj3t68mj/ei9Qv/9EZieFCqVsPuyBN7/yO3HNgD/bmbf/YjtcWi2ZHXu9S1Mbve0SNMXSGp9pFMO/8dvsKf3rqAHzKF/3wwyLXOC5ZVFTfacYmQYwIY5HJcLrM1pnOuBm+ZKxrl4N/i66eQfaC3oCblp+jZwXg55bQyc5gCEzK+BWUpVqrg/9IUHQu4YfAjsBOHpYrNTgr4EhKUaNRuK0PDO2wds7oDVmEGraEKv2bwNEIqtUDVCbS2VTax76RiqinICit9pRgfGGBoFDo3bRJZ9legv0B4uYEXyPv4YYGtJUwRoQzArNCl129yBBIBIVPe8nacuKVPRzeVTovibJsiRT7yX/NQZp9SJT4E24cRLYE99aDT/+3dEo4g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0943643-bbf7-4fe6-a4b9-08d858eb4091
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:17:49.9289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 675UOxHuRmDnxopW65jTnmEfPk9rXNTrcsERKHeEu1TjvL19gHyTuM8KPTj3JvXHq5QZqX0lOtNpaQ0WfTTuPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB defines a GHCB MSR protocol using the lower 12-bits of the GHCB
MSR (in the hypervisor this corresponds to the GHCB GPA field in the
VMCB).

Function 0x002 is a request to set the GHCB MSR value to the SEV INFO as
per the specification via the VMCB GHCB GPA field.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h | 17 +++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f0fd89788de7..07082c752c76 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -20,6 +20,7 @@
 #include "svm.h"
 #include "trace.h"
 
+static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -1130,6 +1131,9 @@ void __init sev_hardware_setup(void)
 	/* Retrieve SEV CPUID information */
 	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
 
+	/* Set encryption bit location for SEV-ES guests */
+	sev_enc_bit = ebx & 0x3f;
+
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = ecx;
 
@@ -1219,9 +1223,29 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
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
index 1690e52d5265..b1a5d90a860c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -506,9 +506,26 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
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

