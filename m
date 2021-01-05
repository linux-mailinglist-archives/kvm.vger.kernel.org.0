Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454522EAD82
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 15:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbhAEOkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 09:40:16 -0500
Received: from mail-dm6nam12hn2247.outbound.protection.outlook.com ([52.100.166.247]:56129
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726846AbhAEOkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 09:40:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgSbLeZ1DhfyNTKPtZZ5yvFxXiT/qrx1qT9qtdY2DpCyxPc6aKQxIWeraVwSOrNxNnAV8OKSDxM/Wq/3+7Yzhr/4df5ZYhKMQ6W4J2M8du+bxudQODNjNnWEwOrzoGzzGR202dCi24s7b1E2mG/4yiNNmWiS5Y4Wu71WIUes7MozBVaVyylDPVbwwlQiiPLCd1uSTmTe+Z5fWGUgZK5414khDb+5o1I6A3Y9Iu2vDOs8iE5aKsS55Ggxd0OC4QwkDeUaBEjScRxo0lCKI664SYZtzZgTqGbCnu8oFJD1TiYib6HKOCbGZPgRIjQ3Wz34qski1jIwkgh7YSqR5aUTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jY0o6/URRyZq57WzkAJw7mo2KVO0Y5KD5J4LxUciOjE=;
 b=IPMod21Igtm4s2QZdx0EOEU2Htd2GlUekze1HSC5YLl9Wnbl83vRA7qKRyv/iQmIrr+DjO4uoLouYIcVFnyQLkAq+S3+LTC4C5u+ObT5/0l/5hjirxNzJ77yIq+v9OgpvhKzCf1wmZkbVzRjMtSodnFyQGQ+aoG4K+eVuodpzh9FwOv94TOCFqFdL/ZUEfyJDWRwl+Of53hu0ezadEgJz9FprxTVouvyRr2rB+ueZ2OFBZG5GH3HZD2F+IeJIM1YM7BG4A1iQOqrCIIKgS5vAhxsAFDqrWe6KT1yfELCPzUlSWgspkQbj/jbQkWs8tAb08eZpa45TqOOfudfpv51wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jY0o6/URRyZq57WzkAJw7mo2KVO0Y5KD5J4LxUciOjE=;
 b=ayCHO7lWyw7Rwo6vH+WkVqmmTeoKU21N/vxiqYnGq1uBFvvP19TRNM6NrC/by9aTqJwfCeDxrdWzg9PDpxikXWs3jTkRjSDQAf85Gk3ue5wDpGOVC5V8mFASPNy/jAnU0csx6SCKHRWJ7WQT++0NV6YweNxHZbLYGt81N6KKHjE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Tue, 5 Jan
 2021 14:38:55 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 14:38:55 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] KVM: SVM: remove uneeded fields from host_save_users_msrs
Date:   Tue,  5 Jan 2021 08:37:49 -0600
Message-Id: <20210105143749.557054-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105143749.557054-1-michael.roth@amd.com>
References: <20210105143749.557054-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.54.211]
X-ClientProxiedBy: YT1PR01CA0073.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::12) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.54.211) by YT1PR01CA0073.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19 via Frontend Transport; Tue, 5 Jan 2021 14:38:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 669309ad-fde9-4fcd-f9ba-08d8b187a13f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4134:
X-Microsoft-Antispam-PRVS: <CH2PR12MB413418DC1641C40D212A423495D10@CH2PR12MB4134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FNltrtZVTcORKpaI7nr1sbkZJVu37cuVKBHjH5OEwHpw3hEyXB4GIBatMeSPz+aTsobWiGLyWJHI9YUx6gvSPGr5Sb60HFtNkmgkNzVH7tqWp7RyXevhabm4XfByevBu7T52Mqk0qNG8bxEvUdG+0jE5D26dafewlOyKzClGq8M+tyaaeNWOAo9LNM35pS4Z3JrXmctY41ONHdrhtCcANBBzU9iCTDjIKMUIRwzWwzgVnG3QqOJdU7q+uN9aIz2VzGsOXoAfxqYl3/Q/6xN0kYkqezXl5qaaM1IfHugq3JYa4nB30DJzt0Gd2x79Hw3ocIPdzyFbccG2ETP/g8r5jQhyL8ZV+PDquPuPHzA2BD1s7tE7aD610YxdJXcNfy2Q89438Pdi6xx60KbbcxzFbkRJXqabllGTFCUzG56l2MAI4KpYB3jk2IZfvslJTHUF0Nec6G2NTdB5M/vfrY8rZuH1+pqDLkqS8eln/YK33FAKfkMf23X2C7r6YmxHzSP6Uf91DjgWCpkx3GXdBxvxPPPCHTlpwE4e1UrEXGOSZpYymg+MHpISQt340l5EVW6K43sj8UlatzOlLWp0w1ukQOVmzrp3VmoQnfkR26PZWymQrZ+CmPSZZgWdRw6B4ZRik6raOlB9xbk84+4f3N5U5sOBQkUF7JfwfG1rLEhFYvJ+kTyzLLfHfwnyMBPchmPSORBry0IK6SUqcEIPwG7wgFqbHG/TJBtnuONGx6UqV/w/JCgSU5JK6obRoxoEfeZa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(6496006)(52116002)(16526019)(956004)(2616005)(66946007)(54906003)(186003)(6916009)(2906002)(6486002)(26005)(86362001)(8936002)(1076003)(44832011)(4326008)(5660300002)(7416002)(83380400001)(478600001)(66556008)(316002)(6666004)(8676002)(66476007)(36756003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gyYKZkbraNbYFbUPMS33/oMXNw2UJO2hzRDDzLT+FwIXZXM+VuTHrX9AEtMX?=
 =?us-ascii?Q?FhYIpi0nQUQ9hN1bnpCOZJDDHyLrkGGigG2bcUTNh4Mt0vaDp6uVgJDC0jyk?=
 =?us-ascii?Q?4rPTKG403OhsmQrUW935bpjajRQOnNPuH5yEd5UinGyiYdjKWN7DO1aY9whR?=
 =?us-ascii?Q?9Kf+ULxvKFyxVTSYkeOE1uZMlrJtu6AKM9D6Vu7Lhlv/Ey9GCfUnEMY6cFXa?=
 =?us-ascii?Q?+8ZJo8YwtMgHSNgDYsE5yUOi3nrDQDuqnevemAjIguvyxMg5e1LJ8DY6rh84?=
 =?us-ascii?Q?1w0eUUU/+XIlz+oGj5rLC9alWFJfrHXCh7Vz9HP1CxhzBlmGxtS+j3CzeEzF?=
 =?us-ascii?Q?w99aIGePijNOduGbOCLK+I7P7WI50kcAj1y6A+eHr3V4BHoUih2ZU4k7b41n?=
 =?us-ascii?Q?bqGYyjwEmrnVP2ce9AbToj+pi2e13aKIwSPnsaRkUDpSwlZTZXb4dtpgFv84?=
 =?us-ascii?Q?ud6Lo0CRNlcgR+cv63p7FeEZ8mkSBgjaViG7q+mB5XQXVsonBVeyscJCOr2q?=
 =?us-ascii?Q?fgqaRQMZ3CQuL2o8VhKoRVunfOfwNl+cXsLipyaE6WT//b+XMCW8Qgr747cZ?=
 =?us-ascii?Q?BG/L9Ew7DWidtkjNr71a2gaFyG7tqnLU2utv2IWT5Fy7eXGoUuI+jpcGw4LN?=
 =?us-ascii?Q?d8x9G0km9Og31jid/4pX0Y2Drn9+ajnf1zTJo3snsRggVgqaGqQIIrvmDM/6?=
 =?us-ascii?Q?WsM2k9/afAKFfT3ew0Thqvf/TfKtfXoHy6uZ9ifTFYVmt9byhJPaPssEuhoy?=
 =?us-ascii?Q?yMKzlCPQXIhpBE685FIZK7dS4e0dKI/zrTrCKvmwtfoVBeqLXz+LGV3AnuiM?=
 =?us-ascii?Q?lnHwPaUwIQFzjsu1Rlrt+tUlNLp3yezA4TfSN0S8y5ixFzd5MtWVGwCEzWMV?=
 =?us-ascii?Q?ZXIDbeSFbZB7TuhXnsFqmoG5pe+2BWyrubk2vkS7bOEMFp7loxt/ajYTIK+J?=
 =?us-ascii?Q?TluBkQYYM5HxT90MoGPaQRLxsfYl3YrlyCy0xOBPznOvegy3IAbozVx0WO76?=
 =?us-ascii?Q?ePAi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 14:38:55.6054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 669309ad-fde9-4fcd-f9ba-08d8b187a13f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CH07Leu8M0xmvLQVUjXTxn5lkZ5I8CXnuj77laBsAv+/QH1rm204zOlFjjbcq9B9peZECRqv5KVNjrUzlSMLuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the set of host user MSRs that need to be individually
saved/restored are the same with/without SEV-ES, we can drop the
.sev_es_restored flag and just iterate through the list unconditionally
for both cases. A subsequent patch can then move these loops to a
common path.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 16 ++++------------
 arch/x86/kvm/svm/svm.c |  6 ++----
 arch/x86/kvm/svm/svm.h |  7 ++-----
 3 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e57847ff8bd2..2a93b63322f4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2007,12 +2007,8 @@ void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
 	 * Certain MSRs are restored on VMEXIT, only save ones that aren't
 	 * restored.
 	 */
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
-		if (host_save_user_msrs[i].sev_es_restored)
-			continue;
-
-		rdmsrl(host_save_user_msrs[i].index, svm->host_user_msrs[i]);
-	}
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
+		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
 	/* XCR0 is restored on VMEXIT, save the current host value */
 	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
@@ -2033,10 +2029,6 @@ void sev_es_vcpu_put(struct vcpu_svm *svm)
 	 * Certain MSRs are restored on VMEXIT and were saved with vmsave in
 	 * sev_es_vcpu_load() above. Only restore ones that weren't.
 	 */
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
-		if (host_save_user_msrs[i].sev_es_restored)
-			continue;
-
-		wrmsrl(host_save_user_msrs[i].index, svm->host_user_msrs[i]);
-	}
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
+		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7a7e9b7d47a7..7e1b5b452244 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1421,8 +1421,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		sev_es_vcpu_load(svm, cpu);
 	} else {
 		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-			rdmsrl(host_save_user_msrs[i].index,
-			       svm->host_user_msrs[i]);
+			rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
 		asm volatile(__ex("vmsave %%"_ASM_AX)
 			     : : "a" (page_to_phys(sd->save_area)) : "memory");
@@ -1458,8 +1457,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 		sev_es_vcpu_put(svm);
 	} else {
 		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-			wrmsrl(host_save_user_msrs[i].index,
-			       svm->host_user_msrs[i]);
+			wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 	}
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1f4460508036..a476449862f8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -23,11 +23,8 @@
 
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
-static const struct svm_host_save_msrs {
-	u32 index;		/* Index of the MSR */
-	bool sev_es_restored;	/* True if MSR is restored on SEV-ES VMEXIT */
-} host_save_user_msrs[] = {
-	{ .index = MSR_TSC_AUX,			.sev_es_restored = false },
+static const u32 host_save_user_msrs[] = {
+	MSR_TSC_AUX,
 };
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
 
-- 
2.25.1

