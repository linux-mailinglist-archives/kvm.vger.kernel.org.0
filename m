Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07330CAF7
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbhBBTHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:07:45 -0500
Received: from mail-mw2nam12hn2225.outbound.protection.outlook.com ([52.100.167.225]:26626
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239431AbhBBTDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:03:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxMh7kn8odq1yh6UxF+FWfH6t01uZEj/oqvRSB3GB2OYrhT+twcqxZg+4lPPYrLZEb4+BOKJbvl0JJcOmh8KT8SkA8CTWmcN4JuJzHYzyKRUxOb/XtI+1u5cTPHCMy1o0WNExNiJLT14jz5XjCh/8JkGmPKniVEIIexK0IYTePwlbLLHciwlogmSamG8xaNu88PRzVKo5P6/SR5iRM4lUmRW8WA+EuN3bWdVRpiyAM+h7fE7+X44XTInUTPHmnHWZEZjWgbDYgcrMOSbkOrCxAHT8Xgv75kzZ1SEPiXPs7vQRLkcvh5nRa6pFPwbUWESz13yfzLjOiuGRIXVLQdT5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/sOqT9outqhrzEUhrYT5WaVS9dh0d1r0jcfU7DNVWE=;
 b=c9siTLyTJTClZSm109oq6Rbi+BTMLPjtEJM7rUE8pMEkagTNVmyxad54++L3FTGvuEOXxJ8A9CPYgkZ9imslA5z/1/lDrcq2O8/cr90ToWWCpwYQA4KnQ6JPYwozru+VI1Z8BcBohBwZaX9KfN7a0MonxsuVuc78PI0/m8b4opfJIz48uKCuZnKvnp7Q56ZwbNho555c2QpKWaUKx4A27Cu/1Z/trN+D5kbryi2VHdpLOfSCXmlejiSU0WAZmftstvojBCuK9P2zl4Vbi1iEdJwdCKXFU1Kr+BRmbb9SGIWiy8kS0tHOtQ0mWsbXTqLUpmhbDY58zs4MYXwViX3fXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/sOqT9outqhrzEUhrYT5WaVS9dh0d1r0jcfU7DNVWE=;
 b=XtxB0PHAumMu/HAEMliICN+aDEGsq/M50Rkhxwt76naq/tYO6aAz+sYNq1YY1OwhBK5guK634hlR3cct/UX8dda4YljL19NWMuVKNt+ZfgXBGDn339KXqHdM3U3MT4sLS92yugB1NX1TkLyCjyUq6GXNrqQz3CIXSajEkRpmBis=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4264.namprd12.prod.outlook.com (2603:10b6:610:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Tue, 2 Feb
 2021 19:02:03 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 19:02:03 +0000
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
Subject: [PATCH v4 2/3] KVM: SVM: remove uneeded fields from host_save_users_msrs
Date:   Tue,  2 Feb 2021 13:01:25 -0600
Message-Id: <20210202190126.2185715-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202190126.2185715-1-michael.roth@amd.com>
References: <20210202190126.2185715-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.78.25]
X-ClientProxiedBy: SN6PR01CA0012.prod.exchangelabs.com (2603:10b6:805:b6::25)
 To CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.78.25) by SN6PR01CA0012.prod.exchangelabs.com (2603:10b6:805:b6::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Tue, 2 Feb 2021 19:02:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50809c3d-2f7b-4f05-728a-08d8c7ad06e9
X-MS-TrafficTypeDiagnostic: CH2PR12MB4264:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4264980E78221C8434B3E1F195B59@CH2PR12MB4264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k9UmSxLCSCxqh/l2QmnMJtmOURd8QW+BUvatQfzwWeVgEFqhknQXvu4iqIecaHbln0LCBfXgqP/SkqsDdOw7GU0eHOHNlfy86bbb3w/UKACEYtIeklIJyW3kI+HT4ePcA3bUsGP6EelSI6BYKyHERuQnKsWFyR2dOjr6gDt7DhrUXUiasfw0Yq2yGZ379eiwEoGorPNXzV0whCC1ysKtsrh1S+Gg4RM74hPyu5QnwiExnkrKdrHBYKCvny5kcJCdeHTCs/DipPeTwloWihdHtACjfw02NFYab1D8Fmjq4D/+SHkrfo1pZ7eE6ixWMh+cugSs19mUWUwMJ8j++Tt6EGfC4iOXvOvfuSaBG1y9M0X2B3zHxd0ojj4GH75hbpGwXodONHg/CkgmAkD/7k9W6K2hK79VyMd1SurEPugaFio1RpKhBjFJTwx9HqJz6fy/OjFLOnn2MPN7D/e4RTY1hIC20+wp6LOOH7oS1RGV27GKFdLw2Q4fzh0tA6tfCGeDPradvWO2tWN1dAedyCjnTVF/mU270mly8XuueRuRLC8Xn9vxW/pXdn7hvIp3sbWIGETbkbLtpYWtOLYZHxKydjER5iPJudRi1XHjChAz3xcVqy2y3GCEl9Mf9ruM22GmUpiHpIcCwqTnyc91aO3HiL91/S76m3Hex4at7JW/dQXNJpYnB106cq+Y5zcPFJVFrlQXdxzS9DKKSqEi9ewL9g7e7jCOc5lXKkynEnmBo7W4/pK0xHP0yI4SbQ2PSKxy/xm2SJvEm62u4WzELRqxDG3brHsTU7j8EycPHzTs8oUTcmwz0fjbISXvAtBwcTsd9wxabg1erJ1hcliMLFg8DGsURzDXdGNZynjImS6kaIBPBCjXg+EMYLY5VLCiX/E+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(186003)(6666004)(16526019)(66476007)(66556008)(2616005)(956004)(36756003)(8936002)(44832011)(26005)(2906002)(54906003)(83380400001)(86362001)(478600001)(8676002)(6916009)(7416002)(1076003)(6486002)(52116002)(4326008)(5660300002)(66946007)(6496006)(316002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yu6zM14cc1CulhwASuADm+/L5sxUOWhjvXmuSVD45xnwFNvfZRXkxgQZae3N?=
 =?us-ascii?Q?tU08F6dDjgWc6aDcH4/fCT66nJEcRXaFMKPF8kYa8esAK32khDIBFXqJpYfp?=
 =?us-ascii?Q?2lSt+CTdz8Rw9Yq/5nnQu3ibu08rRwlCoq7+iWl6Qrvn9Ka+6BxR9LdJ6jm+?=
 =?us-ascii?Q?YeiDLn/w2j+7qWQ53blS9u54Ozrpf0OLcpQVdS2Bn6KIHMf4Jbymomqf1UW/?=
 =?us-ascii?Q?WbHwSFE9+hCZB6x2kC5OppZEe/XuC7XWIXoosEz9BywwV3NAx7Do0Z+aTAnE?=
 =?us-ascii?Q?bXx5q1ZRMuWkP60CUwsiwe+0T5pDjhtA6DDAywxcRXxv7WT7j4bdR4yclGyo?=
 =?us-ascii?Q?HW/ZdxtDbMlwtuKQ0jjv5ZDDIgWO0hrxaWAZYuEMpyjgkUU1pj4LCMWBwFQK?=
 =?us-ascii?Q?g21T3LC8OrxB/m9yU7cZoEjD3V57M07JU3D9UUWMegmB+0Ej/ZdxCK+ZVXCe?=
 =?us-ascii?Q?M6ImgC7Fm+FTUo2l96BttIa506VLU52c9QNSWyGb9ZrH7GPqnfSHHl0eblwt?=
 =?us-ascii?Q?IeFygLBXQxqjxeqPWCFZsDOLD94A93PpwSEMFO571ZZkxjpWuh1Z30HwnEGo?=
 =?us-ascii?Q?3e5z26ZtUpckez0WKwV1paeChqxhr2n7parI+TkMa+5xXc4bU+//xDp4Ac2c?=
 =?us-ascii?Q?hfyfrPpV0mJI3LpuxtIyGPDBInp/OsAJTOhf4ugBXqsD6xPx1sDdusdZyQff?=
 =?us-ascii?Q?LJMvWYOceN3scHGzxXxUNuMWp5fHo/Cjq8jGnyPXbkIh3EVg8lBIDSRZCj5e?=
 =?us-ascii?Q?Go+PfUyBgfOSwN9YA4mcYVGzSMLNqGPzDi01WSGz9WpdWoNq77NlvaFw+w37?=
 =?us-ascii?Q?McKpLdKOOMP88K8TTDvCKkj69orTJ5jwXg5AFpp1q5bTdRsGzsArQrLqjzSy?=
 =?us-ascii?Q?OwgdF0oW3IJoKR6evjCUMylIRriEPzgEBoMlT5ZeWTYjUBEWuPIpx/zg7l2C?=
 =?us-ascii?Q?FJqKRnSF7raDBvdVpMiqc7HViEOp5sTi+LXy77HQFSe6v4GUU7Zzd1izAqeY?=
 =?us-ascii?Q?etkMcwHr39jVLcEG9YgMCwAzA7Z1Cz6LmfyyOwTHZuyM1sbZZlyN2tEd0NXf?=
 =?us-ascii?Q?p017zRsoKMWkCa8sCcH7tAEPSoPUVgyKE/pbn1zOwkRkVhYSFIgX6fkPiWkM?=
 =?us-ascii?Q?SFyXUEMDY+6rrHjEV4etcsgyGjcUsskJrhHrrqKQU0iKcTqHFehdJZEplQeb?=
 =?us-ascii?Q?ew/hrLcmPwMFj7sVUyTBE1p4P9N8/THOLT7mbyvhPC74vFciexnARFZCDhfy?=
 =?us-ascii?Q?TrOrcps2334xagmcwwJGGY5kFE40PyiATkGH13Fwh5cZRI38TNuB5t7Ghy7O?=
 =?us-ascii?Q?vMUKIzk27ghYcK6HC9CjcXXm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50809c3d-2f7b-4f05-728a-08d8c7ad06e9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 19:02:03.3839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugKV/kXlqDxdcUP4SjOQ8FClmONOK5g+IJUZYHJrBHRNv7WqMXz5yk0oFq9scAjwJmDe3tTUYF1yw0rBCYU1cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4264
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
index a3e2b29f484d..87167ef8ca23 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2083,12 +2083,8 @@ void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
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
@@ -2109,12 +2105,8 @@ void sev_es_vcpu_put(struct vcpu_svm *svm)
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
 
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bdc1921094dc..ae897aaa4471 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1423,8 +1423,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		sev_es_vcpu_load(svm, cpu);
 	} else {
 		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-			rdmsrl(host_save_user_msrs[i].index,
-			       svm->host_user_msrs[i]);
+			rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
 		vmsave(__sme_page_pa(sd->save_area));
 	}
@@ -1459,8 +1458,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 		sev_es_vcpu_put(svm);
 	} else {
 		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-			wrmsrl(host_save_user_msrs[i].index,
-			       svm->host_user_msrs[i]);
+			wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 	}
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 525f1bf57917..66d83dfefe18 100644
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

