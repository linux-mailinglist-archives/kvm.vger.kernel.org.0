Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3BD3F30E8
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhHTQFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:05:19 -0400
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:18817
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229586AbhHTQDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:03:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUPxAhhaMWHzmLHVWraN41kLp0+4wsegbmDJvSBcPMuwFHgyGh0Y1UgYQQ+8H9qrhsGdBRRSp4YoukJsyTArQJmVTW78pg6cBGcrcSW3rmy3CTG3SXxNRyrp9sxgm3i2mnyY6p2fHFSjI6RsexiWn6Y3ZUSgCU/MgaFHiaiFH1Zj+oRQVmYBoX1a6mtgstKi8/MclL4B3pNobG4UdjQ5ymZ6TwBGlEe4yptlmePQwQA7bvKHAE79g/mcOa0VXZyS+TALm6zSkybITKi5JAhIs4z/EfdlmisXFmLqXysBzFV7z1XIHmWYb2Md+Rs18lhzTPD+ijKEYcL5ezQAObPwAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZekUPhhoSKgdDUh9PZTD4TSQ/T7uPzlK2HoQ6XScw8k=;
 b=h/U60qUnrg7YHXYlBJMYPFs0m+T+GpQXfnFxqJrydndM15GWetSoVkxrMa0puFrLRGa2ZH6Ol7UHGTaBcqat2735ytes8ksFBcLnSXDG37PLTU2KKs+8LjkYEN255lcNf1s/oOaduGI2pD/97BVgmhGSj8HiLBDIezbDYAu/xoEDl9HrqIYEsI7MNDVt5OWXhCOJ49UmXFwxF3qRXK9DrKCrbJpIk9xqNaedLJmpX3ftiuKw91j9NseFLDa1N3/GYHG6nLZEFUUNc2aB0IAixA+6WpJ0sE7jRPAs1yExCFMQxtVDjkyZW8th9wRllYteCuiO7Mbgbd117n2UwOVDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZekUPhhoSKgdDUh9PZTD4TSQ/T7uPzlK2HoQ6XScw8k=;
 b=n+aV0i/LFdkUcCONy8QFuVWv2JpK1qrKnhb+PULnsxJCD3rMAPTTxqnIsJ711z2mvFx99R8IUGmLRo6kdRgZbfQlGflW8XUUa1vHYyyV0zB+JHjLfTMFcHI4C5HJs1fA3u5L+5hGby41eGd9ML4ERUcBq5NXaQg5iIKsacQ4xLQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:22 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:22 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 22/45] KVM: SVM: Add initial SEV-SNP support
Date:   Fri, 20 Aug 2021 10:58:55 -0500
Message-Id: <20210820155918.7518-23-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08c6d96b-2cab-44e0-d77e-08d963f39d8c
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2685BA20D22CD42B94CD1039E5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vXnWS1BXu904MvBq0iyeivaV/ILSTF7HSTKK7WoDdoumuFpbfJ9WcShUEgg4X36F+AFCj86iSrU37pyjd9nN7p7rghSPAC0wFaP8kCiya11DPhSdcYjsbPbQW+a2ngpIf6DgaeTKrrvcoMI8GFIKxQWlmrmnGvNoXnbCMq0c8wZdxXVDWNyROayKU3DBhgVNYh1TBK6rhAoxm60rQKHjqM+boaLApT+d2kNNjMSnj8I/e6FOeiCkgV/kNBOIz6/R9+sAI05PFXVzC0ZOPYXa5DlP5OmouxZcCD5OgOdoF/5E/jAAVjdJt6DysQuhRSq6ncKrqO3p6DonwoFLlIPkLOcOZHxmkGZr2MAiTR4II631/VbUYCgDKOFR4+NXqjwX910r6dbVriaTTPwXSDiZngw+79SAPwPyjoKEGx85tnE3LGS/trbv8P8iTMnuJnkXfj/6iCyIrgun0x4U+EJViX3eZYXWLDZepf5cwRzU4YM6hCKK17pZTptXYEuWc5qQXwcabl35RqIgT6EQudcIizhhGheULIp5LIGQ1fOgCsjLYSPMjqPrlxJ8aNppStRNqnn8AkKy/cuJEJ7Gsb1KNCdp+/yMngxbm2Xoz9zNzt05PnYDzP2uCB7WrGt3HMadj/FiPBNqOCvrXxbMGUCUzMbdv3YPZ15fIV46SptrbwdebCezDdCJS7wd5sVTQRYIZvxnv2qcqcgJuX/0H8AYag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(83380400001)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AYWgZFVDOsy4VSRU2o81jCcRCISnnHwn31w2ViROJjMCVvi54VgFnuXXFlTA?=
 =?us-ascii?Q?WRBANEllxEAaAI/A7i4Lb843KksGjWIDs9hVdyCKiK4cTArnfReGlr6oqt0o?=
 =?us-ascii?Q?MG0J0jqGMP7BKh+J5tHtLHRcTg6BbaSSOwO30PxLsRn64SfHsrcbFWOnC+gF?=
 =?us-ascii?Q?l3lm41+hkxGITjnfX4t1XtfJhkeK8Dntf9ObCS+Wf+Cont4RMr/JQkOz5OE1?=
 =?us-ascii?Q?vBWURvAe7/gksFlJ/9dLjdgZuPTdxXhLu76dGBI0oBlTzEU4CSCV5k5vqczO?=
 =?us-ascii?Q?gk1H98QnxM0zOdntlXXU6z3u47BWFgirR7geHqE0beiLX8Ub4Of97voY+st/?=
 =?us-ascii?Q?FoOE1snwVcixi5i9D1MoGjWHxdztRSEbvTMOTguYD4gW9R+jW6A+q+5mK+3A?=
 =?us-ascii?Q?kP2eg0Wj2qXQGf/zaRp7NIlZna+GWqZtiZp6dD//6W69AOQmPcS5AG8seF53?=
 =?us-ascii?Q?B9bVk+yasAu9cQ+/K8CfqieXubW22u1wrXoD2aTvfz+itZoo2+hvH0sHRcMh?=
 =?us-ascii?Q?wVDbQ18Mj+o+wIDAq1qa3DKlEhdS9aBGZehRQhyWUz/cTnsSuiuhuqiLfnct?=
 =?us-ascii?Q?6EOd3ne3lW4bjJTvg7pe8ZJgoH0KvguG15SuJ6b/VIHVbjkbbNxmSKlJNKvs?=
 =?us-ascii?Q?yd3w14mtn3J9xIL1Duspzac5qmXyaVbw+5OdgOOL2NX1olkmLoyg0KRIV20U?=
 =?us-ascii?Q?By4/RrgX/p0sY68Xq+5yimaYIREznCPqDqfsrr3PjZdVab/mX1E6xB3oZKRb?=
 =?us-ascii?Q?DNh/jkyl+R8jPWiPuhrfVSTYiRCj1iuwCk7s0Y2pbbAUE38QGZPN3UaXzQ1v?=
 =?us-ascii?Q?0jMLDRUAuuZy7f0XEKBArhTQ0p8ugVdv1qv3voMBEQIa5R7m/zbiHn7AJWRD?=
 =?us-ascii?Q?TEfnDP9brVYbZjViZgIVDccwJUZzWhJ7Bsj+ydQPjTMIkBDODuHii0KTnX8L?=
 =?us-ascii?Q?jlxrDr2AhPrLQBioZbjh0EGXSE+B4eEYHboSS92OZwjQ7nloZqItpH+PNfIt?=
 =?us-ascii?Q?ezAqnBlvn/+VQzD57TX+ZS87oMS3kbuzDf3VZeLy2S0kmtmg94XDKd/KsUBY?=
 =?us-ascii?Q?Izr3uwzyaJhZMBQQdS15XgEpUyEshuwP0ZFIpXi2or4JTueW6XC1uYgQILgS?=
 =?us-ascii?Q?12as4e6TqOAui6zz/FvAcEciumA8kvUqT9YZNmCGkZxy12ekXfTVptbUkg9j?=
 =?us-ascii?Q?Vv8IQp9ZtR21KZd+SSidUOi9cPvvrebfnWs5NyQRRbYP/NjWwiJr82CDGgwS?=
 =?us-ascii?Q?IN6yIqMuncHg0mO7pritTVobIbsJCtaDtNa7frzGStStPAbWo6vGjCzy1N2B?=
 =?us-ascii?Q?AvzW+6J94pylLFwVoURkGBBY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c6d96b-2cab-44e0-d77e-08d963f39d8c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:22.2990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +vX8aG3Z6zxgFNoEiJ3SiyXLMUYx3Fqh4AVfEXXCs+x4cAtShItVYGo2Z2FVxywdXSjq6xdg+xVBgeZ23zzjLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next generation of SEV is called SEV-SNP (Secure Nested Paging).
SEV-SNP builds upon existing SEV and SEV-ES functionality  while adding new
hardware based security protection. SEV-SNP adds strong memory encryption
integrity protection to help prevent malicious hypervisor-based attacks
such as data replay, memory re-mapping, and more, to create an isolated
execution environment.

The SNP feature is added incrementally, the later patches adds a new module
parameters that can be used to enabled SEV-SNP in the KVM.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 +++++++++-
 arch/x86/kvm/svm/svm.h |  8 ++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8771b878193f..50fddbe56981 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -58,6 +58,9 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -1836,6 +1839,7 @@ void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -1896,12 +1900,16 @@ void __init sev_hardware_setup(void)
 	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
 		goto out;
 
-	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
 	sev_es_supported = true;
+	sev_snp_supported = sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SEV_SNP);
+
+	pr_info("SEV-ES %ssupported: %u ASIDs\n",
+		sev_snp_supported ? "and SEV-SNP " : "", sev_es_asid_count);
 
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	sev_snp_enabled = sev_snp_supported;
 #endif
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e40800e9c998..01953522097d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -72,6 +72,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool snp_active;	/* SEV-SNP enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -246,6 +247,13 @@ static inline bool sev_es_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool sev_snp_guest(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_es_guest(kvm) && sev->snp_active;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.17.1

