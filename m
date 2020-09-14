Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3EA269654
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgINUXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:23:18 -0400
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:9896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726131AbgINUVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:21:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9oP5w6PNAwBsMNEvHPu5FCiheXyejJe/Ta/LJYIi4rKEnUZFeVU4czPlcAIfzdVUKWyfc0wdK0rPpZB9Rwy9/7aBudOB/nnXLWHSD9f+72s6eSfPkvHU6GIZf+TedtA1lPvTcV7Cw4P+2Wpzh6tDeQkVT7eRNgejMl6TPP1DY6wasVip6KwcEne0r7Bm3NBXw/82goadi8+rZ2Rqf2xr4ckni0DO4q0dEDSWnUIgK12bW3w0JuKQg0d429PrHQwe5f1n/CUqQKC9lYMAjn8PwqY41zhrqF/EewTH//v8SEeWOngnWP9kFJG0xS9xntbkw+lX8SjURoXxBOTdxzy3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkopvjtBpI8D16bfJNa+vKVFafoGHkHzSg5T0u5TC68=;
 b=eiDe8gwSTCE1kGpuL58zHCZvZXkURQJ/13xuBMfbDu82cGq8+yABHtyzubyjxu5Xt/FxKC1wkVITme5gMZf5a/Z+s/dqVcC1X4xUVeklVS3s6s6P9Hv9NOTxnZk5PqiMoPv/ALuC9ALoaHWD6G/d7FPkUIZFvfd2+WvVe0PWYFj7sf/rasd3Tlh+UI3KMGEELk1r2oFa94W3wouMaVMdkvuNDL7MUQGVvimU6tKUsilZ8fQI7AwiMhwkLbfSBpthh31lwMOpYTnw5zDlzRv5pkrgq8cc4eRwJFgDjzzd7IQ18IILxftNPsjVgV2X06wDt8cPJsAjbiLk2ag2KP7N1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkopvjtBpI8D16bfJNa+vKVFafoGHkHzSg5T0u5TC68=;
 b=OHcgqB0g+ykEKKYsWPy6BftOwN/n43Ih7LmcT7lAWth3A8nr/FDSu92FgTzmO+bM8r/KzMzr6NLJ5mBjGjFeGVdHFgvrMy4zcyv1gqZw1ep3bYVtRU6ZVrNlQFg0Xt5XzlSAVLzGwATLEYuVv6z99xq5TNa0cwYJ4xJo3kOmzv0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:19:52 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:19:52 +0000
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
Subject: [RFC PATCH 29/35] KVM: SVM: Add NMI support for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:43 -0500
Message-Id: <f9d156fa3860c715eeb9f05a40027b9755ce082b.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0801CA0009.namprd08.prod.outlook.com
 (2603:10b6:803:29::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0801CA0009.namprd08.prod.outlook.com (2603:10b6:803:29::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:19:51 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 702eb045-205e-4e3c-b20d-08d858eb89a7
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29883C999862B8AD88CB72A5EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hKMS6/oBc+EsRGkgcKbkwSti0SotRqCbgYoLdn+p4woHy+2MBC2fUJgOSZlZRMCNO0cdJHlYd8SuSfnB4qXd9Y+eM/5KSC74yN/vKDC/mqqLJrIpU1LIaxhzOTbQakjSNEza5tp77nwfK0az38f2ph4asr4RY0H4ETg5yvwbQZVP6EqOezQmgGEf0PE3j92uxUvu7bD8NYXSCNr2FnG/tcru2VxFKbJyuot6VdLkJ+xUAHEk1CmlAwYEMrQXbo6eQyQtcDDYONsjkGc3ybWaYj1KatKQ/Iiy7hdjI5WLiw+dA7GQ3d6J+EMoytYXdd9LVhQXvkOAsp95rhjf7JpB9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: u12uy16qJ2gyjgtr9HtlC8TJnDXjCgrCcYoijO1FDynPg8zOKyI5OIeAnpyMyKsQvXOno4himIoGNDiW4qE0I4oC0VqjiUFLKPk1fTeHO7sUY1Fr71MFuKfz1lZIF6UC+mL7qRPrgEXf7scnBCR7zfDhgnIkkCgRm99UPv0Iu5mRok5xEQPPlzciWPlQdnWhN7Oyr7WGszKCj/xx1J+tb477Hvz3b1INJGErGckdfEk9GKQKGiFGRV9bY1e4/MiNg0ImHJyJPxVo6oEOC0ybytevhzMGIOULAvQ5jFRE4ndhS5ReWoNenuTOssT0DBdDWzw+7NCU5YwM2JnazBoxf6aLw1AeJkbMa9Fj4dlxKlOUSqtlL18QIRadZ1EYwp53Z5ps7uKVl/OjPDgkoyObUM9L4CBMv0rBJpLmtrRcDNI3g3GjoOTei1y4vbvhtFI0WsMBHUPFHVmmLZzqQGeCVrelTqq6w+G8STHMRR0OWTDfAW6TyrRz3OzJqkn44Ekp2+/7nIhlZdfD5Z1o9Q78wqVJix9pc345dBECSzP6wbpkaaeLl7CNkUQxd2yJtWSurGsrIz+OlUjkppy9HkCpYUIGPyr/JeUNXYQOzCFg6ejHd1CVQHfH/fGbSG8nAdxH6GV/p1mzhuhnb4sim/96Qg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702eb045-205e-4e3c-b20d-08d858eb89a7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:19:52.4991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6nlbwYrXI0ggxc+U9UeSmyeArTS/Lhu67J1iaF05CAdoPfEtnow77csTDx4MHMjIm8WzPzrQAyXGIKJCMpjug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
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
 arch/x86/kvm/svm/sev.c |  3 +++
 arch/x86/kvm/svm/svm.c | 20 +++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cbb5f1b191bb..9bf7411a4b5d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1474,6 +1474,9 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
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
index ce1707dc9464..fcd4f0d983e9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2268,9 +2268,11 @@ static int cpuid_interception(struct vcpu_svm *svm)
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
@@ -3242,7 +3244,8 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
-	svm_set_intercept(svm, INTERCEPT_IRET);
+	if (!sev_es_guest(svm->vcpu.kvm))
+		svm_set_intercept(svm, INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
 }
 
@@ -3326,10 +3329,12 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
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
 
@@ -3507,8 +3512,9 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
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

