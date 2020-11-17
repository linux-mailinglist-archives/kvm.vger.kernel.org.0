Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379602B6B5D
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgKQRLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:11:52 -0500
Received: from mail-dm6nam11on2052.outbound.protection.outlook.com ([40.107.223.52]:52853
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728630AbgKQRLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:11:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=japP5x5K8gtSgQJJQ0qYGKo/TBElPZPFaXDGozmRkiwtCBJ/YZ8FQ3+SBdQl7kHRtOKHbnOJCOavK4CH7Ghntz0rtuQUs09TGjd3JSw/V/REBhAWSKILg/WqyxrCsAACJS7eJu8y6FCYLDzMxTkXs++IYfOYT4/m1zV+ZrTWvcJmN9380EuVXr0m26eoO70wNXbR7vwkM/ccF9VOvgQKCWmVXHDIGEFHocDCzADuq59PpYUznqpGbKBlvKGrweKSDYAI5080v6atzZcwd1pYMVHpLL9TdksQn72UUQImGmG164Ol4Ah/g6uTgHm18qLtlR93mDOjLVd4THSC+Q3Pqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1poqP85zmmUwcjc7dbgs8Xdz21IgQcCeqBkzA9v6IbQ=;
 b=Nd3/JqqFistUjUA/vf17ytDgNxZik0/nqOaYXB3rkByzfHPQawwuOTKVMoLRzFRp/G5dgJ3WvlnSPiiopCQcUYD1i9DE7ze9bvvhJOIjTDQOPetsQxaGszdcukGo0DTuaq5wLSwXAZVjEo6d1VDCPCHD/rtfm7e6RgUu8/PsQDkLhrBfE0hoewMHVQpc9nXtqdx8V0r2W5Nt3mY9u/t06YK7viYaBhB8wqtHDWLITOzeUvbWEgBlVZTgoCEzmmfeSoY37hr29LdlrsQiEhH6Cliye60mD6v5emzV4Zbk6hRmgiiQFdZQ6JzP1j26gMFhfcG7smAJG0h3C91UMeXO1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1poqP85zmmUwcjc7dbgs8Xdz21IgQcCeqBkzA9v6IbQ=;
 b=uMuKtZ5one5O5TLyFtyCz296q6cPMOgS4Ovu0rrAt0cSMkSD4CC/t/vyakSL6+VntIMEwnOxom+9AREuNhKN2t7Jc2Vg3xTC8MOuIl8C9I/zHocxP/bc/ZvSSmS/zvWyG6/kzdnp4W+fHpDOyMSia0ECBzDIfPbRB4Vtvi3Iw3k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:11:47 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:11:47 +0000
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
Subject: [PATCH v4 28/34] KVM: SVM: Add NMI support for an SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:31 -0600
Message-Id: <e966669930488151736286cad826269cf8526d91.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:805:de::38) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR05CA0025.namprd05.prod.outlook.com (2603:10b6:805:de::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:11:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b162876-e37a-43b3-280b-08d88b1bdd67
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772BC678E4FDF3BEF77C78CECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f7huTq/PiiuCRKZ1oLivso9b+QWcYwqhfIBxcioUNHAt9YrcNCikB+lCv62BdxOd5yzLQXE8kiHaIxrYkBS6NwqfjJGfmVVvMySUBRMN/+GiAsSlqL8KJc5HfJrDlU4NhNfIr2ByK3aNsgZK5GsWKa7HGM1KWN1H1gfuhtLldXFnyA45xiESiZeQu29cAAvc0T3bNnYBQkFc6DKbtG4MASiSLTmhUEx4RSK9WuQsqKFwqUsZkL6LtW3oVmEwvEy/y+jFSwBWgvkp6LRzm20oqLGMzpxHMP6USQfUY1I7SmuV99p8rEAXEXLVM1E1MD94YvoiKkItPeWayoCGOAhF6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 69XH6MtoInUg4Tj6a3CMfpCcN0pfFhZsffycklklKzKs/xYk2//lmsljjMcB0Tp0hDioic/GQGueCccgUCq/rgP99U+6cGNEPnOUSJmn6azl+0Hg2GlXbw9Y/+QUEe12cNLAu2/JDol9iXQPKkxkT46MnGlis6mpzCKZOhT2dFcrsDyGyH6juWlUeX8ahtwno05GTr+JiUt93ufeZZfG0GUIeN1BMyzUK8PZmGlOud5uGWxR6NWZajnLC3ADC/fft/eRRNcgAJj18QO7pTNT7l+I77HwsZyCPgpZKCpefnGO8jil/dzuskz+F/TWsWTbH0kAROYJjL3pzvxbLukDFjscoaP/K79Xy+wKanD4OE63y1ENmo42MAj1CyA1WyHYZKyVmhVueFcZMzBXzefDiuQIGB1d9PaWAH5zTcAlFeHadl75fAoVnoHV1KxnzEigAZ8G5yjj4btyvpU4tJe9TXJJfyTr6Yp4DFvIJXt/pEo9BBqbJZYDIszUwQbVCnVEmEbTZ8OY7Ce2P1yQK7kuACxRNLLq4mXQZPTwrZacpfIV0Zxz3xjpOELJ98zXZV2wF/3Wu8yaaR5hN6SHcNcYM4ax9mzMY2SLtt5bUy4eQ9ms+w8Wp4QySDnUPbSprBVDRsjOeHhfzwWGshMc+qOrlw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b162876-e37a-43b3-280b-08d88b1bdd67
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:11:46.9727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qaDlpbhvikHNYNB4uyNHQD1TtmUXaAdzZr6IPW5h/2iiw2BhwthxjeT5358gyrKqEe8hUxTaf4uVTwsBfytmkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB specification defines how NMIs are to be handled for an SEV-ES
guest. To detect the completion of an NMI the hypervisor must not
intercept the IRET instruction (because a #VC while running the NMI will
issue an IRET) and, instead, must receive an NMI Complete exit event from
the guest.

Update the KVM support for detecting the completion of NMIs in the guest
to follow the GHCB specification. When an SEV-ES guest is active, the
IRET instruction will no longer be intercepted. Now, when the NMI Complete
exit event is received, the iret_interception() function will be called
to simulate the completion of the NMI.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c |  4 ++++
 arch/x86/kvm/svm/svm.c | 20 +++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b47285384b1f..486c5609fa25 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1451,6 +1451,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
@@ -1774,6 +1775,9 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 					    control->exit_info_2,
 					    svm->ghcb_sa);
 		break;
+	case SVM_VMGEXIT_NMI_COMPLETE:
+		ret = svm_invoke_exit_handler(svm, SVM_EXIT_IRET);
+		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 		svm->ap_hlt_loop = true;
 		ret = kvm_emulate_halt(&svm->vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f4b9501fe0ea..bb6b624c0d12 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2335,9 +2335,11 @@ static int cpuid_interception(struct vcpu_svm *svm)
 static int iret_interception(struct vcpu_svm *svm)
 {
 	++svm->vcpu.stat.nmi_window_exits;
-	svm_clr_intercept(svm, INTERCEPT_IRET);
 	svm->vcpu.arch.hflags |= HF_IRET_MASK;
-	svm->nmi_iret_rip = kvm_rip_read(&svm->vcpu);
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		svm_clr_intercept(svm, INTERCEPT_IRET);
+		svm->nmi_iret_rip = kvm_rip_read(&svm->vcpu);
+	}
 	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	return 1;
 }
@@ -3350,7 +3352,8 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
-	svm_set_intercept(svm, INTERCEPT_IRET);
+	if (!sev_es_guest(svm->vcpu.kvm))
+		svm_set_intercept(svm, INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3434,10 +3437,12 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
 	if (masked) {
 		svm->vcpu.arch.hflags |= HF_NMI_MASK;
-		svm_set_intercept(svm, INTERCEPT_IRET);
+		if (!sev_es_guest(svm->vcpu.kvm))
+			svm_set_intercept(svm, INTERCEPT_IRET);
 	} else {
 		svm->vcpu.arch.hflags &= ~HF_NMI_MASK;
-		svm_clr_intercept(svm, INTERCEPT_IRET);
+		if (!sev_es_guest(svm->vcpu.kvm))
+			svm_clr_intercept(svm, INTERCEPT_IRET);
 	}
 }
 
@@ -3615,8 +3620,9 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 	 * If we've made progress since setting HF_IRET_MASK, we've
 	 * executed an IRET and can allow NMI injection.
 	 */
-	if ((svm->vcpu.arch.hflags & HF_IRET_MASK)
-	    && kvm_rip_read(&svm->vcpu) != svm->nmi_iret_rip) {
+	if ((svm->vcpu.arch.hflags & HF_IRET_MASK) &&
+	    (sev_es_guest(svm->vcpu.kvm) ||
+	     kvm_rip_read(&svm->vcpu) != svm->nmi_iret_rip)) {
 		svm->vcpu.arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	}
-- 
2.28.0

