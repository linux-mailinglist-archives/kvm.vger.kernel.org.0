Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0446836FAAC
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhD3Mmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:42:36 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:41101
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233237AbhD3MlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:41:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXRLuqpUHg8sNLdnnjsIYrIKlsF0zWwdvT9m4Xm6fy8aqISm9U5/1oGY60atnie7fVECMXDt12lZK/VwP2AJiITvC0zkocYeLpzuAWIOrHSzv+i9P7INNj3Wkcr7rlCNDidCXr6p8Hn8b9zw3rJ9oXXn9wLi/QQR9yTiS2t9TCSTINueKTPdXsuatUAC5gNJw7td5njegvW9nN23HR6tFH5hevGnJqGd7v8g+W868xtUuTb5ajkvQaAhmb09SGvFTtNWMca9YmWFaU88z7Uhk9DFtNMnTl2oSP6wxp+fCtsXRI3bncTQQF/+0W4yqGOQlRq6fnNnSu2ypn27gPeq1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyvB6OnFxDA3FMZa9lz50v/vprWkE6Bze0Khl2JScwI=;
 b=InrAeabHx0ZnTfusApv/6jLpqMTfo1wmAqrLSouNAXYbvNl7uvmplrostEVCuE/NbzgoEjVBluRntF1fBs9QJBeX12N7EJoQK2rzGl5MHi+oHYsL+u/d9B5gLUsOALvM7xGSUO6wtQPkFxtb69uoTr5Vt944iVupnjQKbppelzFeMsbNSoaoGFteeWCz8Yui4TuyosUkIhh8rw25BuZxmNn5DpzN/y+hkbu0Ds8DnKMwQ1PK1jZBMm/PUDkFSglUk3sOFAELM9CPL/nY3OHPNrvAUEgmm5Wv8qX+6uXRsuVkJyIQTobCcolXXd7e9yizCLUG2artzKJhUGpeGiwZjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyvB6OnFxDA3FMZa9lz50v/vprWkE6Bze0Khl2JScwI=;
 b=Imx5LsF44Nst0za6b2Stj4wmMt48fKuocIoLx5ariuSjLdxAHVbc2bsdaglbnjtz9GNLVlS4o/LiWeMVQiP8vBmMTQMrpzGZYgVBpUdonInbV/hM3yl9c0WMFzh0Fujw6TfEiTOWdtsR9lIj08lMbwFVFKAYXCOz/aN17VoDBak=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:07 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:07 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 19/37] KVM: SVM: Add initial SEV-SNP support
Date:   Fri, 30 Apr 2021 07:38:04 -0500
Message-Id: <20210430123822.13825-20-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adbbbe28-cdb0-43cd-d0e7-08d90bd4f260
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2832CD686B0C355ACCAB5460E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5RPmWOthSyrJV14V1g/3NHtEoNDw/9mnxbHZVl9jTYNyA3oiBp1iMzGdS/unY+xagH6UZ5Xo4lchJ8PJ3iF1HdDLIvCEB7nsfD06FISOy2YoCZ6siaxLeH/seUejXxS4HhxWdLCHU+J9uS4xslC7j513DwI7oFUTE+2kTz9235t+CEBynGRiwLeYn+o/PtjjledUaGUcKAxvKDDNaAS3KqY/PaCa3WCbZ/5pBGYQvFXq0M5Acr0eMQhmQVuOuLqWtQ2zUu8pIjGx7A6dvWuL/8uTrTqhymkW0Khza+U4ALsWrRiNEzuJ9JOFyHx5nXZDq9nbjAtKvpqNJuQT+vjxEhlDUOGRkFxvh2GxJU21GuQ2DxxkuyZWlFBs3ZWE4bV33l6wQtBIP6WpoPQESqtQZ+WiekrjJ1sBOE4DUkni79rvLvOk8sWAw73RM216lcUeTkil46fIQltZWn/FlXCDsmKV88Wn6iIOKpQJq1Es7LGZmS+Jahs8YC8ovSiU++mI8EY37npLzARN+Fm/rsspVFrw3yf4UBuWx8RbsVyJfsOK4AGP2R6KUXRahHz+L/sQkQJGzLDmt4QkKb5tcup62DU/dKIhZ0idFeuhnXwK/p8C14j7GXTa/BgUDO+pw2flQLnDUV1jXRmHhT1lQUYjqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Xu9GIyKGec+Nl8/wjELYLXnDKd9URnn7SehkDt1fFD8cQg5Hp+eefrKjH3su?=
 =?us-ascii?Q?u4RV8VUiVGWzJMe6r/RJCMCczesnGZX27NH11YI1+JNU0H7MbBwzxBVBVuHU?=
 =?us-ascii?Q?HtNpqj7kYu6YDbFUhIsKu3CykYDnJIlGnVxwN9yKEYLt5FiZ8Apv+JP4Mk8Z?=
 =?us-ascii?Q?tDnsQm/xxhf7c1AJzEROOGiyrl2hlHWXuB1aM/84wN5dFnGmiJUrV55K+EEv?=
 =?us-ascii?Q?P+BuEPesgIH+4ZrE+ZQJLKNkHV9SsV+nSeNqyq56jceCO+te5FLyHnlm+CxJ?=
 =?us-ascii?Q?4fwE+oGUrL35igz/9h7t7Y2JCtqzOWAKEMrmVwA66Y10sg+tF18FUOF1VUWK?=
 =?us-ascii?Q?5IK3t/MR+UtqGAqQeHHCBFte1rOGgV8eHWVlQu95w8Pi4wzCzSJtYCHCCy0B?=
 =?us-ascii?Q?lxI4DQpmdZK325l9SNlmRlzrE78YOgF+Y8Qjgovr7oPRIPrZrd9VfIwdkv5Z?=
 =?us-ascii?Q?Ni8eN8RWsP05fUx6474lia6hT9YkiiTi7Yqq4AS4/q15KzOjtWw06pa/jn4N?=
 =?us-ascii?Q?pIdHBScgml4FENy5nNuYhSqhG+ZLBJ3FCJZsM1697KNF7ASxlZsoEW65S0W/?=
 =?us-ascii?Q?WZvXgoH8a3mMWumVjK7juXAAkpEKstwfeZqdjqcDNPxUey8HI/+Qg3bHH04Y?=
 =?us-ascii?Q?fOcAeV4CxuxLiVnxUMTXHQxZeSq6wvmCY4/1wkek054ujYhFr0zkuivaT29p?=
 =?us-ascii?Q?bbZs0rIO8q/sgjz/4DrrrNhWAMZmiAvO+uK65z1jKfJ4X/A2pcW/80vOvgpQ?=
 =?us-ascii?Q?D7/1w5KqWKvCMp51WOacWZxqLeTPl0NDT4CO+4r7xzcb/IiKM7Dm6evpTaqu?=
 =?us-ascii?Q?9FNhll089zN6msjOwhb+wOI35qIsYmkzUAJyImSjSZu/trBo4v4Cl6fIJ8So?=
 =?us-ascii?Q?oxvacL3HMQmkoOqv1QuJJRZ5GfifTYJyjaNoIce7sNC1Cr5j1FsiJnTcChLU?=
 =?us-ascii?Q?rvkK0im1yiwNuyZRxVZcdusyEJCwDYezU7s965LlG6XS2HrLbHXTgWjEhc8P?=
 =?us-ascii?Q?gOa6+jOyD1M2BO8d/L3g0Ezh6ifSKyfpTH9XOA9HAdEK2YqsbEYaB+XHFYOQ?=
 =?us-ascii?Q?N5A09Zi/lk56x+zDwFeR+ElytbswZ410qJuEJdtwEq91lhECgF50GOabym+b?=
 =?us-ascii?Q?xKLXyKRQo5+7KAXmg6N83LHd6Vk15dVAOSi0vWa+l9gnnyWVJ12P2ACeaBT/?=
 =?us-ascii?Q?bVq+53lnotGwljvu9FmKIs1cHKFxR45OZadVhJF/AszA25IZ2TKoIN7KQknU?=
 =?us-ascii?Q?qtdZf2d2otAiXFsS121svIw+gewC46Yc3CUiZePL8T13IbR2shGmYv5pxKOa?=
 =?us-ascii?Q?IOhPJlL6DswPoUtTokOaBGu9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adbbbe28-cdb0-43cd-d0e7-08d90bd4f260
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:07.8448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +bE/7CdhVydKmJ2/A13w3uqWOmPOptP1Sx0vioD6E2xs3qISKlWVj37uE/rKSXdih3GOPDnZegNWcNnGb4D8uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
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
index b750e435626a..200d227f9232 100644
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
@@ -1826,6 +1831,7 @@ void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -1889,9 +1895,21 @@ void __init sev_hardware_setup(void)
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
index 894e828227d9..85a2d5857ffb 100644
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

