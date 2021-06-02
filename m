Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A49B398C68
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhFBOSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:18:22 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:63776
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232290AbhFBOQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:16:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzzSOEFYcdAry6Xrlte+LX5ydxpxCGZyADobAVhcuBROMbd4rbEs8zRbDkSN/SZ6Wjy8rOa+LPuUimc4vejwa40D+7wKkyxXkSSswJyJlZxtDftyPaNfCpGZKJhOJpJ4H5zEWKYg8IDNirEdjbLBsrSqP3Zf9TmLiwYFtZJ+QJsC6+0xmZOxP9YLp05dLhZAca/RCvXPDqWY1uaKJiVuQl/IRi1gPNLFKNraoYDDg1OSkrvg8lltt8ocUYQ4Lksnk+ILPWQhH6INnub9+vDyZCkrDmVIlqcZp4S6HIepxn/Gwy0OJljnwVl34iTYgiA60WDcHEBIHRqECnmwBonYwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvMlsfQpaPzh8sw3rRnK68ziGc8ZpmAC5O4Vs8R5wkI=;
 b=A7a/sKg4wdxYjeamHDfNsImli97s24KL2Z2M8rgUz6K7CEZ2RHvMB3HPZq68qfF77a0fZWLnQ35Of2tNn71Z8qdfweQUHEpz2Gu4Qhcxkun1byfmsnb2EJdro3GS/Ml6KQbPdZ2bJ1AgOZ50/JQ9x6DZKyr6pOI7dJhklsPr3OZ7gX29RkUewAAIqyH2VLGZ+p75uMv3E/idNyu/bzP2XxXoDDZGnlne9RUyVhbHdKW7h1E+FsXU2V2LTvSkPDzlZblILtrKrgLVnIzVHMoS/0YgnIG0MNxORP25CINpsHcOirB861blxGpJxAsAPFXCH2RuUlmtjHnOyW/OlxxrnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvMlsfQpaPzh8sw3rRnK68ziGc8ZpmAC5O4Vs8R5wkI=;
 b=xE/oXC7qX3/4QG1Mo/zr0jnxXrwLkdP2Xt0fCfyPt70Q+RFYml8wf16UIk4EaCKOhBOjxzZ2S+fZg1G8sJnLJaOlSjANVBTe0HfR/Da06hTYe8+CVN2iOHdhj/vUU0goD+z6aZDVjoNAWOTGcCKsP2eyooRzYbKowIVJMPGh2Cc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:51 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:51 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 18/37] KVM: SVM: Add initial SEV-SNP support
Date:   Wed,  2 Jun 2021 09:10:38 -0500
Message-Id: <20210602141057.27107-19-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88c61faf-c630-4e37-97fd-08d925d05dd2
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368D3FABBEEB587A52F2654E53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEoGdOUP8U7wdTG6CBHx0qxDsbziAIVtFXWYclc5rdDJXB/GeL5cs1vOHEcNiKxHvs5jZTawhrQ+fHeh9ABKwAtuXQsNoxMor0aP6sperAXjrA9Hq5uwXtjI06PMoQh0A3+VyazbsjrxJlR7N2Om1pxHNX4bXw6xjU03lUlqZYmWPvzlhQxgxpI33WDuabdHR5FDTy+7Y8AOP4C+tlPFtkwGW78FXsP0R+kl2R67DnORIt5Ph4PtFM/Q41nrkl8wupOa5NOJFEm7S5uD2JMp3UQCwxdt8h36/lh66LU+uGlZn3oEPMRe9Go1vjAFjpwGTlSX5BFpRh+gXjyGxveAW3j33O08zeXmmlyUL6GLQylA/S2J/0BXtYoYXzK6y+BifgQ9r5iE84sOdtHsHDvui7qCvdE2URW9gSX7qBRRgWZW3ZMukQsKSQkV9YOs7sl6Q5zmaektVuIaPYZXhu2//IMB9rBWzQuRNi6xNrPNl80FXWP1r8NICBRbn4JlS1WDOUSIQnRRZvgIkrUjriQGhN9ywWLPFE8Ru1Lnoa7fqQ4a1H08BrjCLzhpV7aq14J99PTW0IxQ74hUxu57nKSPIE9DShBkEFTwp4nlTYqRN+BI3O1NSVA1njfEkCo7Wcyc8VYW55hJ9usBYsx4GCzhbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5/r50BPDtdw/wh15i1PXkyFGFLRKBTJM/rgL7+mVkcUEFHLSYMNn5BcT1S8s?=
 =?us-ascii?Q?oZcfZ1MMEsI1HmR38hifnmbIw3GEkocs+wkFZbryrginGLj1EeZoCe3NAmfu?=
 =?us-ascii?Q?t2P3Qw0BEEhJwpRp8lja32TrGsTByS0Lsxly31XwekLXNUAB1vRWFw6ZiyEe?=
 =?us-ascii?Q?lUO0xasoQobUo3mo2NVNvnNucI+++/QxP49WLrAoHHJZKZooSaXVlim8Faro?=
 =?us-ascii?Q?zUELHHSeLnjOTTH0pth6bmIU2tFdR7EXBSPLOhLwPs2Y7mgkdJ2QkPBrQDIc?=
 =?us-ascii?Q?qRmW7jZg4DHVdTKqV4emoZUOvJLPwIQL5JFGKN2y1ZFFOCVBpDsy5niVBv+c?=
 =?us-ascii?Q?R8o4zTxxo8FGqSOjsCxAanA9bY3lYaK1jNqiMaqpEUcIEMHRI1OTLH+gJtaT?=
 =?us-ascii?Q?INi1cRtoxdOpKArnG+n29EzRQ4ksnw6b5h0XnRGBuoTIq0oWE88Od3owBdR8?=
 =?us-ascii?Q?FzYmNNM6Q7yetrpI6vKdcZboL7bvstFWExNmL49hiq4+lYxx9sZ+Z0KLo+e+?=
 =?us-ascii?Q?ERAGxCwKy/UCf5N2p13VkRMxIySLGkiXIsiuiue07vlcJhyWKUAbw1/tCkL1?=
 =?us-ascii?Q?xiogQLuMfccyFUvcEvNroQrlwLbaRTihd3B5h0+erTYCjTRl3FiCYz6JahoT?=
 =?us-ascii?Q?zk9jdD1S8LFRSJfsolYw70jVybohbARhy6fTwc9hHaJ6DrXntMLJp8pwzGo+?=
 =?us-ascii?Q?jgGd+L4NhfYSl8bbhfVObLF58KdUpdn/1Poq6yVHcsGv7ieg09mFlZctXtnF?=
 =?us-ascii?Q?+G7Gg1NPY9x6Jd01q1j05xa0GcwIyyfYTJ9REdrDl5pigHRXw15G4xfMV97O?=
 =?us-ascii?Q?bNTbOh2x3CohI6bZznzNl1/S6CHAILl88rSxDC/f34oGdSjvKcSZuN+rZDoU?=
 =?us-ascii?Q?pSlj9+Mr/qlZ65rftScP1tYKcwrIXJh58+SkIhGq4K2ctRLlVPMnwNxMO2E8?=
 =?us-ascii?Q?vE2Y9VQy7FVYZDFqTjEDPbpALZpFBdT58qtF+YyzX4XTf20C1Fem96Mswp/n?=
 =?us-ascii?Q?Nd7SmcWKE/lUIw+cqBmyQzomMtna+MEd9NYSOqd2d53qwvmeThZWz7DE5ZsW?=
 =?us-ascii?Q?SeFO+BBJQr07KHEIiPQ0gevvU2c+P1o5Kfm01FIn9ifoFNqeXB93LNefByp/?=
 =?us-ascii?Q?P+HhcguL/axSufxmLZNlEO61KpQz3a4CNsi9anEIiMbIrJsWlB0FhzWEOH+c?=
 =?us-ascii?Q?Fyc/0VEAzDTf/jn74NGff2x6T9Ggo157iGObrQUtBFO94R0VIJYrKvGI5q81?=
 =?us-ascii?Q?MsFnVeNaNwrab8pJPFGeDlY/LPI4B3e7UTTj4UW9RJmjiGiItKDIgwMZH77m?=
 =?us-ascii?Q?2IYxlDo4gGm1K1w1AYZwyQ5e?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c61faf-c630-4e37-97fd-08d925d05dd2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:50.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: paiV6HYMitQDkiT2DbmL1osiozvqsTX4zZXYJrGzlnW5SWGqq8JmqkAIUxRAVP6LvVoZS/ZHAvpwr/NiztVhQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
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

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 18 ++++++++++++++++++
 arch/x86/kvm/svm/svm.h | 12 ++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 411ed72f63af..abca2b9dee83 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -52,9 +52,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
+#define sev_snp_enabled  false
 #endif /* CONFIG_KVM_AMD_SEV */
 
 #define AP_RESET_HOLD_NONE		0
@@ -1825,6 +1830,7 @@ void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -1888,9 +1894,21 @@ void __init sev_hardware_setup(void)
 	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
 	sev_es_supported = true;
 
+	/* SEV-SNP support requested? */
+	if (!sev_snp_enabled)
+		goto out;
+
+	/* Is SEV-SNP enabled? */
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		goto out;
+
+	pr_info("SEV-SNP supported: %u ASIDs\n", min_sev_asid - 1);
+	sev_snp_supported = true;
+
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	sev_snp_enabled = sev_snp_supported;
 #endif
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1175edb02d33..b9ea99f8579e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -58,6 +58,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool snp_active;	/* SEV-SNP enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -232,6 +233,17 @@ static inline bool sev_es_guest(struct kvm *kvm)
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
-- 
2.17.1

