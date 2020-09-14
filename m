Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E1C269642
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgINUTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:19:54 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbgINUTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:19:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEB0dz2MfSUZnfRWjFmBFMM00DODNPRk0NCKc0NcUutimbgAm19fVUQ2eow+luy9omtLLoCmCEWQR9ClaV92K7yJKbRfS31zoDqf8sapgQaCyDkf60vAZG3OurqOwb9iYwN93n3+RB51cjmOVtNIGgEesScJShjVBm8j7/2lIkhrAzGfBXbfGQUwfj74VFcT8xF7ZGjTLqBitqz02kxrtgSCB5jscV5YrJdlJuNIWoNBpGH8/OJJXo9r9Bn0XPB+p4iIrYOzGN4Ld1o43lOghGAhS7rC0aF/HyzH4y7nMnd49+gt3ZfEuEtjvtkbU4wPLywYq2IcTHUcYjSTX2rDlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBdYoePzxSxwo/FexpMU4ueg8FgUrUUboEtMhaRNv8A=;
 b=Xx1ovFf/xHhK0+76yelfZd7I1iVfdxuO2CMF29tMchC4hKE/rXnfCTNRpXKm82qGJOURxdHbqy04p/CqExKFHZWUogvAa13P67z326n2Y0EpIMmiENbI3kCEd9qU/ptzUlU9M+qfgLLQONKVGqoOJZW8Un9EimiCHo7XxDjdG02oi6xIR536J+lJvIw5KM7CWTHm/fnsBFFpE2O8FsoKZS3bmkUVIwfujIlrzFCtzUJzlhdkY6PaRDzC8D6+u9sWYEfq/oZpp6A1f0Zx7tG8w600IwxPuueQkYfpUCxfNbqYywWbcslnjZuHhqkhFWGWaWQY7SDCl6mnK0psAx5/yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBdYoePzxSxwo/FexpMU4ueg8FgUrUUboEtMhaRNv8A=;
 b=B8vHcvpe28MXV0goXCESvwb3kWy6oI2YOFOcqMSPyOb8YAw5WudS4l7DumUTh/e9hXj96xyeqW2a9FsgGX6puuNnmC9iWwJ+1V8YA1DSUJD8djEUaKASTNNobiZMkW+v0xaEPLYaPezNaJjItD0RFExzjzSF+rRqYT5pB8tqv48=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:18:06 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:18:06 +0000
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
Subject: [RFC PATCH 16/35] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x100
Date:   Mon, 14 Sep 2020 15:15:30 -0500
Message-Id: <ddf8568012144853222c014ec83bc9a273da7be1.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR06CA0037.namprd06.prod.outlook.com
 (2603:10b6:3:5d::23) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR06CA0037.namprd06.prod.outlook.com (2603:10b6:3:5d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:18:05 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e47b0997-b8de-4988-0254-08d858eb4a3a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1163B2823C72BEDC86E1F3FAEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3MZQVKZjUbKiqoKo7sYqNX5bdGJ133EB6UtmE4VEO7DiFMcoyj5Sl1idIQcLkE0vo6EXKDtlpE0jxViSCFTdrtcy2X3Tj0wngTBjB5CvZjXIH6Kci12aItZ0lARbrizgS9zQ1tu/zqRegB8hhU+OdPNUE/pkQ3Skf8djCDXa1Ng8Zs5F43bxjWD+xGI+3V865/ShamUtN4azdAKPX5BrwybJt72pT5aYGUbNk2UmlD+rIUN+Ub9d6jFR59L7LAQ6iu+F8V6WDhiyfirrMc4lTOpk/QUiY7YTN6n6nn4TF9drjPjTgEOSLPVZu6X+8ak
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TjagE3jv8w2Q+XMbQb2ZawHxTKBl2l9kbi4/GK2GlH7eic624n0QrG4Tv02BbQxnoaYbOx2ooMbL/zg6VZYMbiJJzzxyb+fC7V7RQq+OXn/weOIPwVQVhhmkt3pNr7rVdCQ6AHV3yLYhAooETZEkSbG7y17mv2eniMFqiBreSDUmvaRYUklV7sYVv4kdQgKifm7ja+RbZx0e+tlchhqtRkUdzBzKddr/xJsj7XDgJs74mzCX+j59XkD4U6bqsyB46mOMT/2dACUM/Mh3BB6aP7hD413x26z62a+x7pOVnxODTqR+T9a5EmiXKY7dK/E1xsYv1XTHLDtJsfwzAdcVG467Ozz/upBupR6iCe0FsUVVnEniML/Bw0m4oa5oXUxWnxvSWhbilm4sGLW8dBcfTRnyMhg1Pa3FTvdWcBdJbfnC/63xXyGN/E+Rc712pQ5Od5MAD8IVLUAgZxIPmq+NIWHFzbElPPr+SLXMv384FLoAH+Ey122XpmLbJvosvmzhcE3cZJazpOucfTU3ScWSi9RvRm/CLrZ2pXq4hiNgcfdvXYlLRkHCk8LkHrBpPGgaeZXQDQfw+oRaDHfApGfs/+kdICuOnHwaYdeFPujfpPRxnX1gnhJ1WCJHaditG9YIAXhEMUjESgGcQov3WSD6eg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e47b0997-b8de-4988-0254-08d858eb4a3a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:18:06.0448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4zzZ1g3F2BPkeOJVK54GPommkPkWPzwGpENhsLUgmy+K0k7mBBOGDYjwi5jWXkO7A7Ktar4QtzF1ZAjvr1kapg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB defines a GHCB MSR protocol using the lower 12-bits of the GHCB
MSR (in the hypervisor this corresponds to the GHCB GPA field in the
VMCB).

Function 0x100 is a request for termination of the guest. The guest has
encountered some situation for which it has requested to be terminated.
The GHCB MSR value contains the reason for the request.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 13 +++++++++++++
 arch/x86/kvm/svm/svm.h |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5cf823e1ce01..8300f3846580 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1292,6 +1292,19 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_TERM_REQ: {
+		u64 reason_set, reason_code;
+
+		reason_set = get_ghcb_msr_bits(svm,
+					       GHCB_MSR_TERM_REASON_SET_MASK,
+					       GHCB_MSR_TERM_REASON_SET_POS);
+		reason_code = get_ghcb_msr_bits(svm,
+						GHCB_MSR_TERM_REASON_MASK,
+						GHCB_MSR_TERM_REASON_POS);
+		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
+			reason_set, reason_code);
+		fallthrough;
+	}
 	default:
 		ret = -EINVAL;
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0a84fae34629..3574f52f8a1c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -535,6 +535,12 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_MSR_CPUID_REG_POS		30
 #define GHCB_MSR_CPUID_REG_MASK		0x3
 
+#define GHCB_MSR_TERM_REQ		0x100
+#define GHCB_MSR_TERM_REASON_SET_POS	12
+#define GHCB_MSR_TERM_REASON_SET_MASK	0xf
+#define GHCB_MSR_TERM_REASON_POS	16
+#define GHCB_MSR_TERM_REASON_MASK	0xff
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
-- 
2.28.0

