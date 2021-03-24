Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE84347EAC
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbhCXRFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:46 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:12961
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237038AbhCXRFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfcNiuNqsVaY/x8zLmQsfUnfNTYaovpLgJkeDG2g+h+eOX/pd1685ABPEDdAbMHsW/yLAfAkE2KTFQ+cpK4gZKzCfP16kOsSQGiHV3FeDYWfZAbnxVgtoU3TsZLnNimHwFOX+UEdYha6So8+EhjTm4iWKtTE+Z+YjaepgzMPcjAyqjwI32EnGTcp0PGpUYZH8TsF/qiO/HoXcnsn9jx5zwDSd4O/BLnMVcxDIZvKcyQVS/UiV9Ah82+HXO+FxfYzeY9y4A3OUjJsMR+SYnvBiMnLhoif3bu3KTta3Xc49bnxDV5+iJzg7oRVdJxAsv8EfdzZO9piTBuulAN49Xb9Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgGBQydwdQQknfHd2XQrC6ndF4fFhwTX2JD31hcEizk=;
 b=Y+JFBWirI3YVXUivf/3rImkn8d4SlFhYnjlCfJ5+c40CvmbRGBy5RJBrHKXdym0Rp+5IrLrK+cooWLplIMDlEh1LcA9Fxo/d5JYYlLpV48iLCUDlI4ia2zVBceSH7keoMT2z1glMPmWdfHW3reQSC9M6HjMEI92vakkDyMMpOh+OE15VxuifUoPDX0d+6yIby2I8IkARstdHwAOYw5M87JqPBt5GvHEgmHoxD+d98UvlDfCqPpIwUpjQkmdov0nKoOBXbh4IWzaE5uFMje9Mu3wW0NCMa5c83Wn6d9IjLP4r4csq9cGjsvNhS5mywCl8SQGCROn47CbiAuywQaHMEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgGBQydwdQQknfHd2XQrC6ndF4fFhwTX2JD31hcEizk=;
 b=gMo04c0woqsuT5aaciqDrzE+X7laOLh4xsUwLYCc515mZK6FB20IX063yrR+83mnRfHPFYOe77j3f5Ir5NO4mo+i7q+RiRb5zW4AM0/joGhgziGet9YC+0I5OTebVyn0HBxX9dMBBlXW7LPCNDALS66MlrEWvSYQZlpUSZV/9Oc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2768.namprd12.prod.outlook.com (2603:10b6:805:72::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 17:05:01 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:01 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 13/30] KVM: SVM: add initial SEV-SNP support
Date:   Wed, 24 Mar 2021 12:04:19 -0500
Message-Id: <20210324170436.31843-14-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 572bc454-efb5-4fcc-80fb-08d8eee6f602
X-MS-TrafficTypeDiagnostic: SN6PR12MB2768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2768F8A12F0455DECB60662BE5639@SN6PR12MB2768.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Smw9KAojWtGfPbWeY7TxVhj/AT04cMI5hf63B6itpa51tr4123eGIXwyXinftlB99dZDtJgCWyPWOlWEGT5TfL98JLRrKZkBcYJ4J1QvzzaaQ5ZehJjkqxcl5W599KzyMdOQatNw9r1dKNsp8UNHWdr2eIigI2F/PH0wJrICr76JEzm5JYnglP0t65mpWAqgGsxMM4zgOH/IBVShIYhuQDdsrOZL89Wa7s7AIQm+KhOap68zDp4ARu1BHoUHsoF9fvRs/8L4GsdQAQXkaUP1W7jIusgLNlmlQ/WSiyVslHvClHsaUGCR5DrlOwYG7KkHfBb82id1JYiAqGABTTxQf5DlMRCJH8H6GgRWTVnuJYeXmyTxDcsJZeUcsgTq/dYBxqThry8T9ph8m1TOXQ+uhp2wJ1ZTdsfkNK1+Zyh3+SFsxzD1fiOBpidi2VelPMzFboWws+y1JkCZKuZ4sU4aGbR192gKgvugjLae+9fic/m6B1ZKQ+DvJR0FTqCKAWIfq9ONHmxqVvcYD/eYbDfM86Ur8JHqWdqi7pjkUoHwlzu6CjJ2AnL6XpwgS3XzPmG9+y9bsrF7snoQypUfd/Qy9Gi+zi16VW9mD8iEiY6EDBmUI+O1HVMXHwteK8w36xIuhnd3CL0x8Ddma/+pInwOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(4326008)(5660300002)(7696005)(66946007)(956004)(66476007)(2906002)(1076003)(7416002)(38100700001)(52116002)(86362001)(44832011)(6486002)(2616005)(66556008)(36756003)(8936002)(83380400001)(8676002)(26005)(478600001)(54906003)(6666004)(316002)(186003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WrgUYY00phhP0Ss72gfmssESsUVSgYvENRI7JMg75mX9a49E4mA615rP4xvI?=
 =?us-ascii?Q?f1RmMBYmQM0P34VDrwQNgldRpauXmz+YP6HVqxklFZVJ9J9is9dGEbFy+xep?=
 =?us-ascii?Q?KNTSnsQLTotHj/7cRVLxa5TcLmrR0ItJwPfecyXETlKDRfz1e5DE+BX8vOqj?=
 =?us-ascii?Q?q9lQEzckiRSUXEPQVqz7JuCkTXDaPQPGLeIzOpmQ3pV/vkPqRWNRsW6RTe6B?=
 =?us-ascii?Q?AoUmU9fz8bc/DPsUS3jBcF4PiJV6j+L2Gjf/A5fDbwWd5OfjWjYWSKiwY3F7?=
 =?us-ascii?Q?FTT1RkKt6Q+VK/VOl57y/zFUz3gu+8czu+bAPyLJfHqS6UgycRfUuX6C0VFJ?=
 =?us-ascii?Q?GdS7hL9nmEkw3XYMcHVQUURX9mw+ec3EunV8NtP6V3O1qwn7RBNOrEWkmx2O?=
 =?us-ascii?Q?quPCllEoq3H+BXIy+wKwzfLS9jvVJMY0znfEaa5+gldtJnhPOeP3u+No8dHs?=
 =?us-ascii?Q?E6Fb+37dhF4tm6S4GjAw97dmDnYnbWshwpDxgjlZR3Zb5mn8TuD7GVKQl4Ix?=
 =?us-ascii?Q?Awtkw9tD2VUXOTBQ3ZIksFsgUqSOgmkXnIhv41LeDaCwpH30/nrPcdGcyvnP?=
 =?us-ascii?Q?DbwBoox9R9cSoxxjzCCFKEvplA1JYUgb9ci2Rn1hIRvyo4YOl5PXMB3xItOE?=
 =?us-ascii?Q?WSAykqILetanVkVjN/ZJgqME/Dm6AN1J0uPy/5cb85tTnmPOk0HLaaBfEo3J?=
 =?us-ascii?Q?FO3h25PtefKZRIuLVof6z2DdeelTKCq9MxBeplxs3kqZz9GwH+UwzOCD1M8m?=
 =?us-ascii?Q?4mNtiuWsAr4/4IeJicP0hZARSDdF/fF7cqLkkg8YO/0uqsmbCyBRXLhRYzGu?=
 =?us-ascii?Q?Gvzuaz+chLTP5yBpDBelKTnBoukdhBXB4RnHjgRJiT6Y3sKCWsAhDetsjG8n?=
 =?us-ascii?Q?fv9WUqoGWWqPXMY09dNNfq9UFTz85q5UwOOaXgmK71+L7WRNiy5feiCq+sT7?=
 =?us-ascii?Q?vlReU82rpy7Ps0kewtvCBDiYSyOaxcH4/imdcXUZyWFviHuF4dJytRQWsMKa?=
 =?us-ascii?Q?I35nCIK5cWJ4RHu3bn+Ooz937A4gaAjOeXuTBL1jjPXFC+WzaELzEBI4VGwN?=
 =?us-ascii?Q?IxA/02oTslxbPOd7p1bL/riaRgigEbSrIvis+ANgOlji3LtU5l+pCLFe9aIK?=
 =?us-ascii?Q?TxEpjs6QMPda1KhrNT/wzcL4KWOcdDE3y3R4uxhkn8MzIXxcwxxhDVTUFGEX?=
 =?us-ascii?Q?FLC5P7kuOQON+JQvGDDbP3pzEhla1bec1/RoMlw/Rq3CDZI2No9wZ6nSJxDM?=
 =?us-ascii?Q?3WIL9aoOe2LCiq/Yh8GrC6vGRyIT4PheFp/+DDsOpTO8yUykDnBmxknqh786?=
 =?us-ascii?Q?a8dGcfyQZ/Wk+rZEGl4e9tk5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 572bc454-efb5-4fcc-80fb-08d8eee6f602
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:01.2042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZP9CngleqRD2DjU2W26/Z68tCJv5/S0SU5zI9uNHA3/+Zxydxf7EHdHza4CTI5wtDVO+Z8Q4UzG+5LITK3aDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2768
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next generation of SEV is called SEV-SNP (Secure Nested Paging).
SEV-SNP builds upon existing SEV and SEV-ES functionality  while adding new
hardware based security protection. SEV-SNP adds strong memory encryption
integrity protection to help prevent malicious hypervisor-based attacks
such as data replay, memory re-mapping, and more, to create an isolated
execution environment.

The SNP feature can be enabled in the KVM by passing the sev-snp module
parameter.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.c |  5 +++++
 arch/x86/kvm/svm/svm.h | 13 +++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 48017fef1cd9..b720837faf5a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <asm/fpu/internal.h>
 
 #include <asm/trapnr.h>
+#include <asm/sev-snp.h>
 
 #include "x86.h"
 #include "svm.h"
@@ -1249,6 +1250,7 @@ void sev_vm_destroy(struct kvm *kvm)
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -1298,9 +1300,24 @@ void __init sev_hardware_setup(void)
 	pr_info("SEV-ES supported: %u ASIDs\n", min_sev_asid - 1);
 	sev_es_supported = true;
 
+	/* SEV-SNP support requested? */
+	if (!sev_snp)
+		goto out;
+
+	/* Does the CPU support SEV-SNP? */
+	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
+		goto out;
+
+	if (!snp_key_active())
+		goto out;
+
+	pr_info("SEV-SNP supported: %u ASIDs\n", min_sev_asid - 1);
+	sev_snp_supported = true;
+
 out:
 	sev = sev_supported;
 	sev_es = sev_es_supported;
+	sev_snp = sev_snp_supported;
 }
 
 void sev_hardware_teardown(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3442d44ca53b..aa7ff4685c87 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -197,6 +197,10 @@ module_param(sev, int, 0444);
 int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param(sev_es, int, 0444);
 
+/* enable/disable SEV-SNP support */
+int sev_snp = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+module_param(sev_snp, int, 0444);
+
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -986,6 +990,7 @@ static __init int svm_hardware_setup(void)
 	} else {
 		sev = false;
 		sev_es = false;
+		sev_snp = false;
 	}
 
 	svm_adjust_mmio_mask();
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6e7d070f8b86..3dd60d2a567a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -73,6 +73,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool snp_active;	/* SEV-SNP enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -241,6 +242,17 @@ static inline bool sev_es_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool sev_snp_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_es_guest(kvm) && sev->snp_active;
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
@@ -407,6 +419,7 @@ static inline bool gif_set(struct vcpu_svm *svm)
 
 extern int sev;
 extern int sev_es;
+extern int sev_snp;
 extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
-- 
2.17.1

