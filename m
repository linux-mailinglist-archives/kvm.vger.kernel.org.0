Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730932B6B33
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgKQRJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:09:20 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:21217
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728873AbgKQRJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:09:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzwWFOpvfi1r3p/YLEV18T4HqP4PlikQyqNZIfI9WUSB+NVF0ho/x5q5/t0V+79XOqjAbA6n6Lj9gAPVfJQuIkY+JM/QOkVvN805CGTiT8Q1QAZGadrwWZMXuZOfhffRsxAXzVTRFHNZd7ysawoTis5YaZRJd2RgqzZSiNz2skcXsnqI8G6K01wFU4eO/hK/3ZcTcSW7OVBrYyM1oeXKD+YJaSRyfezf/s2gX1XsGYHY30nXPVv9tsyrYDF8QHPeMKgnTpERDXKctdrhyt6tn492AIVUHy0Cr8PF3Ye2xVk7bryNHSKmtN42/0RonuzZ909GpgaiGNUIWdoTdf0i4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZabV9guGbxCltEM7dvO9aa9sU1wbTinyLVyTMd9S8M=;
 b=WWXK6AVIdZCzshBW1KVl25tE/zxLPgVhM9Q2pEOCUUtU/60kgArdkHu5LDTD7rOGPxT6wnbeOgwpAg6/KFsp0EpGmOiw58uL0vLyh9lMI/TXfXvrx+FVKmqQTn+2f4hSeCyjYedq51kWCanabNrS6nJGTNzQ3I7WuNV5/qCmljQgYiB4yPdzVR/kjd2Uty+9tV5Rfb7zb0uFxc528yPnZxODRtogbJkHr/9Bf0ARR43PKuXiVaq6frj41T00nlfFqN9JRa1I+jLTGHAGXiJAzPZuuP6gDcFpr2sSpYvjiiIhCiya+oq1XQzrXSilon3xtMseIjRV2VyzlebmkzLcLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZabV9guGbxCltEM7dvO9aa9sU1wbTinyLVyTMd9S8M=;
 b=QWi3o7r0Mib2enpkXfO2gJOiwcE+D1NwQaWre2NO2HECd22ZtJSln2IPKyRMCYQWqD1xEfhLmu0p0Lr/Bv0+45C1LqyGoVVT0FMT1pZgpxUaS5pQXRTf28iqO1xu22R5f9q9KRufkKUYk7cUxvg03M+B+3TQ6rr9m7a7gIun+jU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:09:15 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:09:15 +0000
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
Subject: [PATCH v4 11/34] KVM: SVM: Prepare for SEV-ES exit handling in the sev.c file
Date:   Tue, 17 Nov 2020 11:07:14 -0600
Message-Id: <7ba89a377d1fe006091e725dbe731fd530cd4b02.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR21CA0024.namprd21.prod.outlook.com
 (2603:10b6:5:174::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR21CA0024.namprd21.prod.outlook.com (2603:10b6:5:174::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4 via Frontend Transport; Tue, 17 Nov 2020 17:09:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ac5dd4c-1c80-4040-0777-08d88b1b82b9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772AE9C50F74B199DE12F26ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 38Y6Xn6rbVVETNYlDlid8P3DbE37IRoUFZs8AXDZKmmcHYfK7QNW2c/MudmpD244fpAOv30GMpY9dsPljEhOkVGrTEydkMn2V3pXflsSns48zIsfCmmm7iLvO/J4HSaMfAsvqJ56kY/Uwi2M1e3Ugug2NWbfQ/9H0uZc17EDFSJe6kpywtrEsDwYV/XdZfKvEUczLwQ7kdYBmV4CG6GHmOs2A4Od+U3mupFEc3Eti9jeaPzbxJn9kU6kIjTilhnNvxOKx66Cl1cAq77VxV/0RiYmuCPgRcCP7R4zXe9T7XWgjpcfmUr5YIBbJFhojAUVPV4ouifxPSSYj/pgj0cPFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rS/jgvTJyN095MjJ2Wa1zU2+Ef7DvlONHFH+0HQ0m6cQ9o1R98sxGCvOp96rIS3i+dHP8KplCDPV9teG1gtTgcSalyLGMDb/rlOb9hMUiCj5jL0zRYRYcJ19sDw0KZ3FQIyLTlEXtgE4prsgVAL60ocZiAYvdRtVH6S42r+x+EgeZ1dfFAsFQAbKbYc/r5gdbXnQ9iRXCiHSUicOotjMKG9R8p9i2j2PnLCqtMCMqPQjnJdVO/Qni4zqhix3KKPiDqRbDJ5zXpDMQJ7Z5vvhxyVbCTe0l+DLH5jxTuRIoPl0n8BBfOCaOGhwDQir9bMIp8EKsCxgYF7qT8K7dBJ4SPox7UqlcrhPrHOC/WkCyP/390s3lA0uWQAUp0tsBbE4nmFQJ1SV0obciHZ9nceQ3OrjML80bPWOlMMQV0d7VK1hZZEzpzKNYgC73VxA7zyXB5kW5VAzJUfjzPCyynOAzxIquUo6BYkZ7CgzmH1vSyqaOoEFt4b42MJX6iKNwVpXMhfHDHM2FR6s1BtiiqGik0JK9VOz14m0T3E/ztsY5bq11cNJSqGFTdbm8D6IyRwgLJCZY1knrWHWl6L5Ldz//1L1+YkpBhcUDpUBBnlqpgdhilOTR0sks6t3gB7gmfGttAfYePtFq8phABhdCAxzFg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac5dd4c-1c80-4040-0777-08d88b1b82b9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:09:14.8946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ktowA6krJGnGpCm//CLqQ+LU6zVabsXMmv8P9/3jlC6H0NXC14W9ShgkLsGNg1EoCfckmAfAO8aZSzQKJSgL2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This is a pre-patch to consolidate some exit handling code into callable
functions. Follow-on patches for SEV-ES exit handling will then be able
to use them from the sev.c file.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 64 +++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f353039e54b6..602e20f38bdc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3147,6 +3147,43 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "excp_to:", save->last_excp_to);
 }
 
+static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
+{
+	if (exit_code < ARRAY_SIZE(svm_exit_handlers) &&
+	    svm_exit_handlers[exit_code])
+		return 0;
+
+	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
+	dump_vmcb(vcpu);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = exit_code;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+
+	return -EINVAL;
+}
+
+static int svm_invoke_exit_handler(struct vcpu_svm *svm, u64 exit_code)
+{
+	if (svm_handle_invalid_exit(&svm->vcpu, exit_code))
+		return 0;
+
+#ifdef CONFIG_RETPOLINE
+	if (exit_code == SVM_EXIT_MSR)
+		return msr_interception(svm);
+	else if (exit_code == SVM_EXIT_VINTR)
+		return interrupt_window_interception(svm);
+	else if (exit_code == SVM_EXIT_INTR)
+		return intr_interception(svm);
+	else if (exit_code == SVM_EXIT_HLT)
+		return halt_interception(svm);
+	else if (exit_code == SVM_EXIT_NPF)
+		return npf_interception(svm);
+#endif
+	return svm_exit_handlers[exit_code](svm);
+}
+
 static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
 			      u32 *intr_info, u32 *error_code)
 {
@@ -3213,32 +3250,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
-	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
-	    || !svm_exit_handlers[exit_code]) {
-		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", exit_code);
-		dump_vmcb(vcpu);
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-		vcpu->run->internal.ndata = 2;
-		vcpu->run->internal.data[0] = exit_code;
-		vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
-		return 0;
-	}
-
-#ifdef CONFIG_RETPOLINE
-	if (exit_code == SVM_EXIT_MSR)
-		return msr_interception(svm);
-	else if (exit_code == SVM_EXIT_VINTR)
-		return interrupt_window_interception(svm);
-	else if (exit_code == SVM_EXIT_INTR)
-		return intr_interception(svm);
-	else if (exit_code == SVM_EXIT_HLT)
-		return halt_interception(svm);
-	else if (exit_code == SVM_EXIT_NPF)
-		return npf_interception(svm);
-#endif
-	return svm_exit_handlers[exit_code](svm);
+	return svm_invoke_exit_handler(svm, exit_code);
 }
 
 static void reload_tss(struct kvm_vcpu *vcpu)
-- 
2.28.0

