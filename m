Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148B436FAB1
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbhD3Mmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:42:54 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:61889
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232313AbhD3Mli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:41:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2O/UyRxx5l2rFcTL+NE5HCOnLLbt/bKOs75CbeD4BO2wvsQSPhjfmqOBpXwsa8v54pVr5XqI113IIh3IaCJ6rshSvt8yeTKCXAJSsAe9DxFLvqCtCVFnAlGlaeAT3Flm8n5/nLA1jB3BV0n9B1Pd/L+sTaac7/9+6w1dS55R+QJsO7jlx+8AggjbEMhtz/JLIZDMQMLPKAt6wcL501lvIFSoG/zYVezmrNddmnzw6AL+Hef5RbmoSP9Kyu/+8L+s+BmkTNOlzpZhYclAcPdf0d1DVXF3ms4AjSudUMlerbA4URvdva/CoKqJLY9jC5yBd/BMeU68SUZoDXYMp3R8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTfXibOv5pZ8sJjKJLbgCpZg6Xt/B6JOq4HjVOfH9MU=;
 b=ULPM32zLO/xKUrUvZZz+j6a/T6aCjwPLO+Znvhkez0lAR5BNR45si/BvUed5N8t+KLWicq9fOjUJdsQE4f0C1bw5dkn4M/zddsI935fX4oojermRvSJ6Duq383n/VG6BZRCp8MPq2tATrCyuk7OCUGXUzznxy6Esb/50G19J9Q+oLUsg49ydWPOgS9aLVw2x0aGi3F72YadJzBDPeqqUWvH3Qh8V28TVwKKzLdCxiOP/XGJkCJDYH9uV8iUAv7WqOSBx3ECadzxKQ47ZcWimjZzKp6kyoz4WsvaHaZL9ovonghU+QkEwzBSVfrY22xkH5WXw+amQ1rQHERlTG8Ey9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTfXibOv5pZ8sJjKJLbgCpZg6Xt/B6JOq4HjVOfH9MU=;
 b=eT/uWgrvt8GtiD+bJsa/c04XnDnOofxG+mTCM83ozBvLwWxy61pVdkNQEy8F0PHTqMO43iXKuKzXb/cdXabuOfa7yonh2KdYVIaE9RzB/Pu1hGoZuPMn0VG207KxbgoODhKw1vk58OtVPDbqp8bLEynjWxqNIHVplCiX0RhNZ1w=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:46 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 31/37] KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
Date:   Fri, 30 Apr 2021 07:38:16 -0500
Message-Id: <20210430123822.13825-32-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f56c63c3-60bd-4a68-0e35-08d90bd4f7db
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2688DCA7B3D786660372E304E55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LIqrrVel5Cub79bqz9ZWcEtscF0anJdphUkRYjb1Q3fOWyXMyS5dk4RKagdXEsvw3Mi/7VNZM4ulXXGNwnRk43KG9C4cEcfiRfFREzmbANLdaNED2zrqu8o+C3Ix0bn3gHhzv+yGL73qk8gbXVlq359neK7zdFL7HHhNyd5bLcTHjMDOtDtl4cYfR0Tf2rYlNoWIJk8fxQJKZDvBmDZPLpGT+gNSD0LGJv3tblWskfqsr/patWlC+S2Gej2T0RYZ9Net+QveRPsWMuuvqMlvivrTuvcyS4yNOHUNx0kPVEAKTJjI0K8FOQSMQO790++xf4aYubzptF8DcyEUt5Gm166le3KuZYysNK+ScEwQLO4FwP4PbMR4VMhiF3LfJ+aeBqfiCfz0PZKWL8BFqGW28BwgUH7h0Cu3MY3EmfRpi2yiV9EbhY5zme/mKxdoG7E8DM4DNriO2NBUnk2SRYtuvBJ76osY7WSGsrTk9Uw9UZwmKxj/TRF/0XYuQl2z0XOrxqGvsGjOsbR38wbWldpRuoO3nZE3h1GfnXe7PSSOdHEN5tYGZN89SEvu9GBaPajKPU61vapnD3o/hwGDruysL1BnirU2QmDiJawAWvL0zgEabyo1SeqF8tV5Qu8yrOIc1IcSRD3YEMUNzNGwpesfEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DL48X5PPogF2uXtRIpjK8Xfm0zkcAdjrZ4ioKpH9B682UYae7eKZG7C+QGFH?=
 =?us-ascii?Q?vGYO0RjdKkfQgFnhjfuQ3wsHx+jlyZe2eBj34QBSfQxE1Tv7sMpaAnstzRAF?=
 =?us-ascii?Q?7Lw4ZJNIAdivLtlzrRsjiZXba+FLt0hs2UFk2p+UAu08bwiZIyehRiJbLP3G?=
 =?us-ascii?Q?yTH7sokqqhdZdFgB+wpYK4EFLXHFJ+UKmdZv+RWs3IGkwN7P0Bqlpe8m/BEG?=
 =?us-ascii?Q?E+GkK/aYcq1MHZ7bMuCUKGuVIWr2kk+IKUVrUqkKGDEiBcXv0og2HzsFbT1R?=
 =?us-ascii?Q?PN8X4K/3JnPKcZ3QE79X4ib3k7A8B9yrdyKGkrenNRIVsXwI6apt7RL2qHKO?=
 =?us-ascii?Q?frVTzOncE8zvavvdyxNJQLQqYlNkkFVGhnSRo5fgn2H8/KASjH91KkCqj89B?=
 =?us-ascii?Q?7KvU3jw+gih0PlPdtdDpiioJWg/y1RV5UuPApFzk45Zrrjk3k8ueiqwASN8p?=
 =?us-ascii?Q?XY9w1WWS3A7MAdFZlDLOloQILCTOxIBKMrkm937diRMEQ9zqDcaV/0+vNvdZ?=
 =?us-ascii?Q?I1/k8FDnRmiTsQQC1eMbR0MPTScCseUrKveK+0US5w3+7W+j5qjHSnbMOaa8?=
 =?us-ascii?Q?CCLKNEjTQdcXV8bu03R0t07qD3czEYEoZIAZLkMm0G4lNEre6Lx6depcCbml?=
 =?us-ascii?Q?slr/1RxCm118rGWiz4Lu0nFlQ1iDxvnzpwA8SZYtZFpW9Z7TftGu8+xpe53w?=
 =?us-ascii?Q?IQSUrHwKGfXAdCemFXRFc1zxXlEDH/cI9PNK+8e+V/AWp2V6mUWLZ0WzFYf7?=
 =?us-ascii?Q?scxyRO9PmW8S2rqKXW3qLnI1a9F+apkVfneEI04VEO9q2MkfVMYRJ4tVujLa?=
 =?us-ascii?Q?dvNeuTK+9OLnJOK6BwDEetXk5gcwfE0Ic1469NHPWy6vPhCMC+aSF2Wrgt0e?=
 =?us-ascii?Q?NBaUHLWqCnDvLLVwKVuFGAA00mv7Ce8Cg3/pCxSzy0SSSKfyEJ5A0l80Ak70?=
 =?us-ascii?Q?ui+bNqBDcj8NmYrEzsaWZRmqe1CIfWfCtBv+/HtFwQ3GlT4sB0Vu2yYj0kmb?=
 =?us-ascii?Q?+h/WIWUBndcKhxu3HOZVQUt/aBoQJfg6Bn8nJCGdjBLA4l5vXm8IGGer8eTE?=
 =?us-ascii?Q?9Gwl4LQMl7VwLYjdVu+7w8TLutWgOhbV99qO6EKRFo3ziVJ5zhZhEbtZtVPj?=
 =?us-ascii?Q?vHk/4E1gywoeMVM3AJFMZWMZTlKAPQYgim5u/9Zvu0nS23ax3M0KnYcWSwrk?=
 =?us-ascii?Q?e9G6GfdDWxDZmKlaqgXM1YD+FhGak05QzZoAxVqu1msHoTrTPBtSVO4esb6I?=
 =?us-ascii?Q?TPX64K1ftNk41IjOqeQbI25l4J9TG/WUWQWJTj2h2D6tJ+oY8XXej3wdeB11?=
 =?us-ascii?Q?cU3f3a2K6MNxHiHuVD58dUw7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f56c63c3-60bd-4a68-0e35-08d90bd4f7db
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:17.0615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wRIf0NIcej3ORwXp8eMgGS4ml/FFQqCebVwlpprAScR9/yXTTZizXDQIfjZhr4crm/rYLrJbgqSZtUxKIvGlsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP guests are required to perform a GHCB GPA registration (see
section 2.5.2 in GHCB specification). Before using a GHCB GPA for a vCPU
the first time, a guest must register the vCPU GHCB GPA. If hypervisor
can work with the guest requested GPA then it must respond back with the
same GPA otherwise return -1.

On VMEXIT, Verify that GHCB GPA matches with the registered value. If a
mismatch is detected then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 25 +++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  7 +++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3203abbd22f3..1cba9d770860 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2904,6 +2904,25 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_GPA_REG_REQ: {
+		kvm_pfn_t pfn;
+		u64 gfn;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_REG_VALUE_MASK,
+					GHCB_MSR_GPA_REG_VALUE_POS);
+
+		pfn = kvm_vcpu_gfn_to_pfn(vcpu, gfn);
+		if (is_error_noslot_pfn(pfn))
+			gfn = GHCB_MSR_GPA_REG_ERROR;
+		else
+			svm->ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_REG_VALUE_MASK,
+				  GHCB_MSR_GPA_REG_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_GPA_REG_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2952,6 +2971,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	svm->ghcb = svm->ghcb_map.hva;
 	ghcb = svm->ghcb_map.hva;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cf9f0e6c6827..243503fa3fd6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -185,6 +185,8 @@ struct vcpu_svm {
 	bool ghcb_sa_free;
 
 	bool guest_state_loaded;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct svm_cpu_data {
@@ -245,6 +247,11 @@ static inline bool sev_snp_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.17.1

