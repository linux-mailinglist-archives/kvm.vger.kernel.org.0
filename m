Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9843B2AC893
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732532AbgKIW3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:29:55 -0500
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:35776
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729874AbgKIW3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:29:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXuzeV4NPxltt4vNMNDJQuv+swYk2lG+YGPe5IM3r3+xuYroJOXFanqpxO+0B5ANazjWcZI6csCHE57nlk7Oy59Xcbl9FzcqTLV/V2NSIbzr87xPODT+cSMbWUegPew33Pbo7fJ/gmFvSfCTaAnkxBCVXu0W51lwSTX1w92vLrlXTg1kxUZhCVjqqQgblu/mG/upcNFOLF0JR1WfbT6mgmbzKkiAsvK9JmEf/mOWCyDKvawkXpYyHI6zwenE8ERfbNnowBPlraRAaIBwFoGqBK/kxKhdyFozX5TbcwlOpt3a1iFGBHLps+M6kQWj2Nh7WvfM3UiZIONsW0uxSRaZFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3UI4Nsu7Gk+M0M2p9lXruc1W7AGuVrBincsw1cbAy0=;
 b=foxUSkuQnjNkbUFBHKhocqmGfrtFPVpjrZc+kMWakofBNAqJHkb1pCsXFvmpk7tuoPIARYZOVgbRvJE+DPO7yOZJwgPy6ISb4APOP4ixx1S3BYjNXc70SdJdveU3SNsJKUmE4N0A8A6Kd5uBvM1GHHXGQLpyO57MaPHLCbVOotpJwFBPpvoA97qdKkMvUgYEsWIpwcloECTHY5wqgf6cWWSEA5mC3hiF5kaRNNdHsHwMW3GB++bsmyUDZM6pUUNoZAaGrSYv1jgPdJlxaxBKZkqapzR748CXa31xAvbpqDQvkWq+Vd8+5apZzokm5SxuTWyYHr9NDD5gZb/N7optIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3UI4Nsu7Gk+M0M2p9lXruc1W7AGuVrBincsw1cbAy0=;
 b=cHTNXCz/s7iRwxdjtdcjdA3sO003Dk8jMggW5q+1cUeTH8z3ffuhWnquhu5KSjB9kRTlDn1tF6egLAzpMyQkH4CHJvCzTKVvQs/7yuz/JMeifOGJkMziaN+4ddgSXFGNA5MEoCQg77dCDj7ZMm9Lz0Yfg/l1gCWNfckUKLFjVSU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:29:52 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:29:51 +0000
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
Subject: [PATCH v3 28/34] KVM: SVM: Add NMI support for an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:25:54 -0600
Message-Id: <6ac95412dc86735c002673d75448de109d5f9a53.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR18CA0096.namprd18.prod.outlook.com (2603:10b6:3:3::34)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR18CA0096.namprd18.prod.outlook.com (2603:10b6:3:3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25 via Frontend Transport; Mon, 9 Nov 2020 22:29:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e19e5bf4-8209-450d-b884-08d884fef99b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40587C82BF9A5F48F9E1B99CECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZ47xXIuCA+9aU7wSyfJEDlVY01DTP1+qo6XLyOtfwPtBsrhOuT4KhYPIUHa0lbkFIh60v/zLjK7SMaMF0FIaha01DvUWPKkBEO3dUPZtx3FgC6s2c43y9V/yIxvkDdbRBk0xjpTnKeLsthiwD0R6yCJe6rt/pYJL0DfGMhN8WfpUCEQizX91STjeMO0dCKNnnu8HAJmI4kmj2M9MA4ZxICQ3lur6EJbIdAN4lY5SozQrzu2qpqwCN2seND5stDX9Nnr7nFRx3Ul0Z/OCnr/1ZFWYF73sFkS/3DU9fTo/wjg+VlsHmRL3DSZITI1U9AxBFjYCSFcNKxFrlexTuwSKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5GsMP5vMv06ex9ZL0sffFu1KIW9UuE+9Uz5VNbSuB0Q3Eqb4wP1WHNBh6M3eP+LNq0fy9QTFf/+GpJMJfXwEP2FjVxZNoZIOHYU6PFaiKOQ2Lqy90iVEuHGHwk76DqQ3MNOhSr/3M6XfjHPHh+KdRQzeBk90Jp45ZCp6QSSiYkG4XlZfgz3Qvtc2oOD5LMYZwx1y305Qw6Sk0wnStKEuNWJ5UirjVq/e5tao/Fu6Og4WlJzLU039MATccMQCY+XvuSBBJFgU+TVR72SnJUqU5vOm4a7VEDoYI2ldLDwkrXXf+Sl7t9inogUGgIg5Iabh46brNMefOUttDEZHwqX7br3eRESP99aBcYUBxd0DcUOwz3+1ywKWVRKt6aXWvXkXzMCfkRbiJMn1i1vAa6UBzM/kO0sz98QPT48dAJtbRCyt8Yf/g6afY1hSZup0QCnMm4ZXODORdOGHRz7BiEAu71lNuysE2KXcf3Q4wCTtIUL6ybSyKHyXjawcXWk5yEeSu0YDkJucKZYhYyGR0eqkj2FShGbO7bQTFh2LBuBlQd8YLgzd33iZuD42j0ThZ39mJhkxkowlMkjedP/AqynUqOY0zQCYb+qRlteh7luqhJMAj5HZtOYiz/CFzZZQD78dVEi/NBH/ecRknxwXwRH0Ww==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e19e5bf4-8209-450d-b884-08d884fef99b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:29:51.9176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NT3TjrDRzshBSbLYCrH6yHqyGwN8NqftoCOKTC+XwRCrUh3tnLMCG9B7aadjwmEs0gi0viq7wmn6hLfyMmvKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index 53897564fe48..ef31396b846c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1448,6 +1448,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
@@ -1771,6 +1772,9 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
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
index 4dd33eea4a68..9dfd60395c8d 100644
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

