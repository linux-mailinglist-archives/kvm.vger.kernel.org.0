Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1A12818C3
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbgJBRHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:07:04 -0400
Received: from mail-eopbgr770043.outbound.protection.outlook.com ([40.107.77.43]:56387
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388550AbgJBRHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:07:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRrmgAFMTvnYHDvcju+rsXVcT5L8rjWdj8IdZorsbBQOQ6gfpI7i39VFAgBq0CzbmY3fc4oQkN0bFyxIhLB1W0EMBiTuxBYFtpxqy9J0C7vnH65NONtZg5pQm0vP4Z8SKWLGMABGT7bv1d9gFovdZJeHqSDNeEU7bA0dtNhATsdehH051PxDMF42YZ/hOpfBw671uMTIan1Ra0uW/X3a1mfM4e60bsGr30aka/3jZS6ebxRZ6GM0b5QVR2QBO7Uwo+9yiUHbKZKtPPa9NtIpApQFbT2btG/+1NJe99VorCOvJl133A1mRe8G7iSVEtgWrBdc0wldQFKrmJv46ltANQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xFk6BkMEsymm4GZoBE5+iLEv8dDzpzp8JZGoEPHRos=;
 b=Z/LdLVyAWS2ApTyJMeFR3FPEemfP0o2bGpvpvD5JJBoDQsDJPGw56lxEg9p6EHX1nfyJfLxgmo+XWeWzMZ9Qic7vs+H5wYXVLsh8X8fro55ULHC6UtrPjeSaNKp1H6sdnUipZ/8ZdZJTBNlj30DWWsO1dhRn92jO9k8RSy2V9wACXbgaSu5blKK4q15kVVHNKd0ScapBWH5Dw4qts5LwhkSvpPc4kQNp1rv//hHbygSye3DZj8NR3oFjN7cHB7lWz2mXeWly8RowzR7rVhqS+qahb9PexKerHd6GpRgc52j/JT6mEpXyQ8MtKLlZ16dhVb4i9uCuOqnk6EAwGUIp7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xFk6BkMEsymm4GZoBE5+iLEv8dDzpzp8JZGoEPHRos=;
 b=RGWfeJAmt88JkNBWaXflWwOXIqXsWWUUft/5wzM5Z0w+CpLbJK9ZpiJbaQjPKLgI8mUYkhba1gqBxzFSSZeRf3vYwz0PC94Q+W/z7bv69ksV1OWTWyQ1CIaVc5sBks63jB7PrZC9gWNxg8jODWhtijj3KW3SDmg97sEjI9TmiZw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:06:59 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:06:59 +0000
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
Subject: [RFC PATCH v2 27/33] KVM: SVM: Add NMI support for an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:51 -0500
Message-Id: <832b475b5db008ca8c6793834f8e7f20cb89e3bf.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR08CA0017.namprd08.prod.outlook.com
 (2603:10b6:805:66::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR08CA0017.namprd08.prod.outlook.com (2603:10b6:805:66::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Fri, 2 Oct 2020 17:06:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35dc8be1-56c2-4f93-c59c-08d866f592f7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218E3047FFD71486760B8FAEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tHWak2/j5NtKfNpcY5JPrDkERp3e7D7gEJP7f7TTDFJbv3w3L7YyfqAm1Txv/Nl67NpWo569tg69/uDUgqDq9MgjA+hY8FFbt731USnWX0kIACRP3pS41SGQ7nw2Wx4u+f5VDKw8F65UMpaT5H5DAoSOTHN1fNbVV/Mt+nifcj34N+e9yV/pISZRDlxoxurhng5gaziL3Pn1tnqCJ4EqICXObtDxZhSm8ToUVevkZlYekNhi5NZoSjlJNMv7TpH/FrHfuayVGdNMyzacQ3EyJrCid8rhMX0ouxMi39+BYm6XfmpQ9ftnuYXcFIrVbSWTPpv4h8Gt4PqKOHukYbDLsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Uia2eaZuwmovY9hlux5OXLG+2MBDu6C/3dwAwE6J9crnkHKQ/9Zn4F/hKVdQgFGehpXcrry1Z+TpgvarDlB9aFZEBV3VnMtF+pGEyXOdOpn/2cNIhdy1o9FwzlTZ0T9O6k7+qpyugDbqvaxYbFUu4JnLCQ1WrSulovPjxDXbsO1feXRTZ+W7Q7o3JixC8wOLtxAJS06EKpmEmHpEh0Ti1CPVpHGaRrzvyae08zsu/1XNPCxw6wn7hQMR9WXaRjH1UxmBo+ImZNINtiHVKEDHLes24j09OCH+wva7m7YS/qSTWcq3gbc6HOrdef8VprZF174o/CibUFGb7kWjuC2jVcvxjln0+N++U82rCcJPYLWRkexbPg+30KmVQkTWewFR9eGHs5geM1UtHcCD9TYdgl5pogDnEdmKXVWeZ+nZUk01n+5NvD2BpZOwHQwgtylVEKEei6AlcWmuF/hWC9nNa96WCexs9EPt/Lwv3jAM07/AoCs1iOFJRIFJEoKJxrQxn1WgKiECGA9TlZJxtpcJHizENdSr9iS9isHD+VQ57FuRGeruWx/02l2S4+crylW26BWa0CsPnrer79Wg4KxWUwpNOVaRa7k/xGK1plgHrKO620jAj/SCBItHNjdpGE8BxEaP7Wc2402c4hQis7Wrsg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35dc8be1-56c2-4f93-c59c-08d866f592f7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:06:59.3836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82LNfM4JOC0OKyjJE3+dGSa11dVKIYYpbwo3WxSquqt9evft7JnUChsm4UirqyFnaoqlH9LG9LMExMf5iaQOHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index f771173021d8..d30ceac85f88 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1361,6 +1361,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
@@ -1678,6 +1679,9 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
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
index 71be48f0113e..69ccffd0aef0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2353,9 +2353,11 @@ static int cpuid_interception(struct vcpu_svm *svm)
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
@@ -3362,7 +3364,8 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
-	svm_set_intercept(svm, INTERCEPT_IRET);
+	if (!sev_es_guest(svm->vcpu.kvm))
+		svm_set_intercept(svm, INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3446,10 +3449,12 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
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
 
@@ -3627,8 +3632,9 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
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

