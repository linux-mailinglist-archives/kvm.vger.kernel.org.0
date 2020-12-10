Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02DB2D63C4
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392842AbgLJRgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:36:10 -0500
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:61760
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404102AbgLJRPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:15:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXExcYyE0UQW6+9bw45q/oFkdf4H17l/IB7CXEiZbYNYuQiXBpfOzCs6LMwF5E1BBwNRZjqufwZSuoKuXvI38xtOgR1/MTBZi+tz1x+xttYroKmbIMaNI9IbSw3s9xJaLahnjI8rN2dsZeTGi8fFOmeXBcfx4rc6J3UJCauL6Uj+fE5k3xY6t1/fBq+p+ZvA4AHWYa6SuTypkBypojDJvoWD0Sa82JDrfu8pWdgTSp7Pd7fARu7T4XPwePuGu8T1V52Z+Kyh7PNrWsypHRaLnmYW/LtHEyXyFcYoJhpfwBTI4BeEHaiNeCl/oesNAAi8aWN4z/Ox/ZlrDocCvgg5yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+00cw+QMyVxnB5QrqLlEnbzUtHpRkANbvDvwE4cRFzo=;
 b=UkLXrU3KONesxB5rirNtjCOIKOflpkoNM5SNCXPVEBwDryhIHp68aYnDPkUNY9HyBxCp2tSQzn+wF7F26qXYlkRcIkY+MPRec1b8n7YAuY0oC/m8X1KaSM6Eljrh+AzVIqOVunHun1WwvapUbUofiqMBj/prO70wy+x45eDW7aAEhA+L2Sn+obBeOknBCJxodtubqxkyoF1SFE9lO3zIfRVC3jVf33Eax7qwWsM03FHSPUjpEQilSaYEL4GDQX3QlL9eZQoyn7VpOXeoSsQMxoxAurfEg2Snj7ypMJs1ThPXsV1TrJ85eSdkx7aI7sjgpJgtNJUbpgUaq/mNXQcWVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+00cw+QMyVxnB5QrqLlEnbzUtHpRkANbvDvwE4cRFzo=;
 b=NN/3tJys8q8LzLfApX7bSxw9deW0PgvzUmk0O7GuVxNu058ZyXUuKd2HFoREOBqrnh8NiFI1jEqPmeE2hgQvUgUUEi0Orp+7d2ZR6JvAQRduQNrbreyUzleko+RCERvBHVWi7pLOW0hMlo0HKdTvzvj6NsOYEpy79wEcMDlF8nM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1350.namprd12.prod.outlook.com (2603:10b6:903:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Thu, 10 Dec
 2020 17:14:40 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:14:40 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 29/34] KVM: SVM: Set the encryption mask for the SVM host save area
Date:   Thu, 10 Dec 2020 11:10:04 -0600
Message-Id: <b77aa28af6d7f1a0cb545959e08d6dc75e0c3cba.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:610:38::26) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR05CA0049.namprd05.prod.outlook.com (2603:10b6:610:38::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Thu, 10 Dec 2020 17:14:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f58d56bd-a3e4-4919-fa0a-08d89d2f1476
X-MS-TrafficTypeDiagnostic: CY4PR12MB1350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB135010F7C9D3F2CA41D6A7B7ECCB0@CY4PR12MB1350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LWi1LrvGja/gOFMVSHQRAvjSnIZ1enzgQ5DlOk5j6bFHKF0yeGUFt+SiTQdlyXVwdHTY/0LWYiiazHs2uHTHP1i9Jltd9FFpHtw1rytuGue370f4jPNay44hBdXAWFgd0yEfIO629LYcnGRJssompNNfSHHhK3kdidIbLHVT10IXzh9z0C7o00iaVcES8XfX5PAEfC0yNBPjVEfyXyONIk8TGEz08AkWHIGpOZVSvO9q28vRG61S0MA7WVWROdwjoyUC7gG1nhWrxagS1PRG5I9Gjyl48KkhJrUIOppkq946JtKb5xQ4mdmRCaG6FH54tcU+I8IaXXktaClO5yVywmMZQPhtWOqvJEYG0UYHdwGC9zU3OAtNB6mNXEXxEuWA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(6486002)(8936002)(16526019)(2906002)(2616005)(54906003)(508600001)(86362001)(52116002)(66946007)(36756003)(6666004)(8676002)(7696005)(83380400001)(4326008)(34490700003)(956004)(26005)(66556008)(66476007)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wSsC15pZMY3fwB76Vb15yeygVkw/MViI1FxCO/2Y55bOib1MYQq3rdTEnJsg?=
 =?us-ascii?Q?IeVjCu35ovaXkIu5aW2ede3it2ZFjauEa0DRUL5px0WDKneoo7x/rCPIM98j?=
 =?us-ascii?Q?5b+NVOAlKf/nIvu7V11L3qhFq2UGrjlpWuGwON6Ji2abLs95jVLqL8DmCu87?=
 =?us-ascii?Q?NTMa3r95iLsn9p9Dsh3wsO3WwFG74gQaOuBU5I+ShFAN92JZxazpcnPDSj6f?=
 =?us-ascii?Q?FTdu4dHI5fzjcrOzvyxn6+p51m7VzriYcCY+Asi0qweVvznvlz7oARIG+Kqq?=
 =?us-ascii?Q?JA7nnP4/1hkPDXdMoTSND5saEKVj9NdL3DA1TxSfj8EOWgq9XJZKYJo1q/pV?=
 =?us-ascii?Q?gEsrnCfDuc/4xOsOR8QJvSqF8pZ1pDoHUsZYtJP6jtsa1wW8ifJIKY+CjHha?=
 =?us-ascii?Q?6awa6er8ZSf3CKhtQnCMeZmUs3H85YpDbX/jAW1fJUMW7pCEzGNOn2cwde3r?=
 =?us-ascii?Q?56Xm+XF5xkt3sirvrCqcMw8Wvk2lAHfiWVI8Yw3zQbIQFFzhVGN9xqzi1ELT?=
 =?us-ascii?Q?E3n6OHyMzHYkfjaP0BukCrK+pqw24mNKiO1/GEgPaMMrD+a7Q2Qka7YhX2N7?=
 =?us-ascii?Q?TlyRgELH3vebr4fMWLrKiG6+68RlzN5f5HAYUlXQYj9ZCP4sJhjDUUyyuBBB?=
 =?us-ascii?Q?0pPMTv7UrUzGZ2KSYInvgTJM0k24dnOvitNxrfJy3zUmYxdO7Qov9+6lia28?=
 =?us-ascii?Q?gRRXvGgNNU1qKBcOa3kYa4Jb3D+seL7a8dvt7iTI7of8rQGHizVJlaQ2w0cE?=
 =?us-ascii?Q?FPyKc1INWK1B32tkmY3qERixyXfPDQIvLdrn6y0uS2AmLKAdswWkBHOR4jhD?=
 =?us-ascii?Q?HLxUjInhEpqYldX1fV4Hs0Nt631oWfLbDLqyJ0t2bXZCgl6HIhVs10kOryQo?=
 =?us-ascii?Q?CKgpMMqDMznO3poMnpatb0mwjm+r1IDMgwh9O0Zy149+tZBsZPZEdTOx9Rw1?=
 =?us-ascii?Q?kvTpSmDc2fJaJa79meIeIePYCzS3PdRpLcwUD931I30Czfr8j49ZShKTZEDE?=
 =?us-ascii?Q?FX2N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:14:40.4101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f58d56bd-a3e4-4919-fa0a-08d89d2f1476
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUDqBFBtIPjfy2XB5qbyl0H6TOBymT9cyRpOHE/0OIW4ZZAZ0aF/Pv7dIu/MZp5BJPtWLovt2X5vCdiVcX5w4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1350
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The SVM host save area is used to restore some host state on VMEXIT of an
SEV-ES guest. After allocating the save area, clear it and add the
encryption mask to the SVM host save area physical address that is
programmed into the VM_HSAVE_PA MSR.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 1 -
 arch/x86/kvm/svm/svm.c | 3 ++-
 arch/x86/kvm/svm/svm.h | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 486c5609fa25..4797a6768eaf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -32,7 +32,6 @@ unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
-#define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
 struct enc_region {
 	struct list_head list;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 16746bc6a1fa..d8217ba6791f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -498,7 +498,7 @@ static int svm_hardware_enable(void)
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
-	wrmsrl(MSR_VM_HSAVE_PA, page_to_pfn(sd->save_area) << PAGE_SHIFT);
+	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
@@ -566,6 +566,7 @@ static int svm_cpu_init(int cpu)
 	sd->save_area = alloc_page(GFP_KERNEL);
 	if (!sd->save_area)
 		goto free_cpu_data;
+	clear_page(page_address(sd->save_area));
 
 	if (svm_sev_enabled()) {
 		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d570d5a6a2c..313cfb733f7e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -21,6 +21,8 @@
 
 #include <asm/svm.h>
 
+#define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
+
 static const u32 host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
 	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
-- 
2.28.0

