Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34FF2818C6
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388563AbgJBRHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:07:11 -0400
Received: from mail-eopbgr770049.outbound.protection.outlook.com ([40.107.77.49]:9046
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388363AbgJBRHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:07:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZ1cchgbOUHae6n6xsULsOIjNha341ai2BdpUnhMU7BNSl6K7qV4jAhR/XHcGvQ270Koe/lYEWOjjioxb0Ln+LfNfrql1bbosTFx+p/tDFYb1zwWQ2y7AkKsIsmg332bONR6XmPL9pUrZ7qh5NCIMWPTvzEqzJzD5byJmmGTEalTt6gv6ByMgnPUZcvcJHfmxumLsjCMWuChJG4lndsgatRUcRHK0XLGE5hQTTB75MZjrv47MtwRwdiKlLcZSduNV7wt9XsQAyjG4P1OOct8LldyjCmOsdVKZ9bDfBYGWkUH2RKOhh8on8WtTWVkrg2hLoFlfN09cIW0ButxFGdi3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEJH4EFhbGw5lJsJme904V3ZC4r4iIBvbULMyTfMsy8=;
 b=L12Jl0AXNrgSN9IiPqsh0gk5VH9p/elGmGI/35G3989fDiB9Tq7F1yJi9E8v3BjKHfin4lKerD8FInH15Xad72VOwq9LT7Ti2uot/uARC4RUbMuIoAuFOssAcifm6ADDUKP9X5Vn5/B3gjLgAGcCuHUZCAX7KmUzJZmg1V50rc41ms7wrUWdrm4uuuoLV5i5qa6b7QRonCWauncBgGfgRgeZOKtxx3E/sXcMJRB+LwMSl9kCOVPXLeSSM5tKt9M77wlty288wUyltNwpxOUpCOuKz2XECExlUUbXmSHTysj3rePoZW9segI7tibLcVYaJM8ENfX/ttEvm3tpX4s8tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEJH4EFhbGw5lJsJme904V3ZC4r4iIBvbULMyTfMsy8=;
 b=v74w+OYFvAZq8a7yKEHwh5txxpbPUTIDvyBQc+ky1pgjtkrtBq0DF5FOBqqg02NSfiBgEEakkpni9E5SYuqB18QxSd0xRFfF6OLc0QD6YqEEAUZni7i0esyfXiGclD/YnGg8KaCZcLVX05dwFSWbjDgrDSJ/HrVTefEkSv6Yp2c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:07:07 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:07:07 +0000
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
Subject: [RFC PATCH v2 28/33] KVM: SVM: Set the encryption mask for the SVM host save area
Date:   Fri,  2 Oct 2020 12:02:52 -0500
Message-Id: <36826ae2ddedc0c2ce71cdbf516b1bf74fe343ac.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:5:100::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR03CA0052.namprd03.prod.outlook.com (2603:10b6:5:100::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend Transport; Fri, 2 Oct 2020 17:07:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 41abe7c0-a3be-4028-0162-08d866f597a2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218EEE953B666254D5633E5EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ryo1QSB952Jn/o1ciJZ4IcacnKj/jpmm0K/M+TUM49dLaVHgcho2LJ3jpNaYtixVEO2ln53suQV+jxnoXyuhbDmYtzQMd074vTK5wTLtWfc3+lzKQEmyrFbMysDk0azG3h3LYgwuleQziPw76vt0fA5sPBsLXvL5ive/RVXsscVplxLqncUDmTABhkv5dWf5++M3ED7GeecL1MdtbVMjZJlf0aJvjiLdAf9T8c/v+7vgQTyXEVSnpgaulpTAsmFw686jJwA+tYnSzY/eZqxktzJcKA27A44AG/aegWrv6EnK2E5XgcDmBpa91TxN8lPRygl3udCQqmdzjE5UGYQkng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0Wh0SAkd6jEfi/BXGncKd9G7uYggedx4yuYIBtUUU2LQBTf8b7vHSZ3BFyUbaxje1IJWr7bHc1MJNzsmi40Vt82IVdxlIG8RgCKh7o7OTlPM0Zj3jhGX3KK+qkDTV0UDCui92pg0nSWxU2rW+ExwgEJctvHgOKhS9FpC5mJHY8uGedvTtbng9c1WpUeW2ihuPrmiPaLUFA+Lt/T2vJlpVc46X5Tf599Ilf2W4CcoilrlcOklwPa/nhs1Zg6+hZy0J/vx1gUgMyyiK/Phhb//LWIpbyG7L4ssHFWHGmUTQtaIjUBHJc3frZjL4j5wQ/xgi4lYRIjIFGiDviil2+egS4SidF7O5MViAYU9Co9UkXIag4NY+8xnFAHaVJiI0vQxP963ymFBSEViTfmlcU+wLp0FinnUg93BWCRSi7RXcP+m/pNIBay4Ft+rd8u0+ZFK37257oxT6GRB68GhYcQ8QrpasZM8ABGjpyptVJsMvdNKWPU0LUxBpHLa/OtLwTB8fEViLOIwng99chfwUnYrhyfIGnWE5eIHGUrhDdSKCiIS2Q23Ki0OBY1HE4psw69dW2JtZPqiti1zZ4KIVhPVt8JYM5X7ikzfHgTGcsR5UR1oncjkAZ6xmvs6MTnqulg7qf0rwdByrB4TeWxx4t/qYQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41abe7c0-a3be-4028-0162-08d866f597a2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:07:07.2051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Or3jQHhl0UogHvHrAopgLjbyw1RlYFpRQ3mKsmCCFH32GS5n66TgEuH7n+k+1aSsYnVkxc33pN5UNCfns/Tfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index d30ceac85f88..4673bed1c923 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -31,7 +31,6 @@ unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
-#define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
 struct enc_region {
 	struct list_head list;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 69ccffd0aef0..ff8f21ef2edb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -478,7 +478,7 @@ static int svm_hardware_enable(void)
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
-	wrmsrl(MSR_VM_HSAVE_PA, page_to_pfn(sd->save_area) << PAGE_SHIFT);
+	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
@@ -546,6 +546,7 @@ static int svm_cpu_init(int cpu)
 	sd->save_area = alloc_page(GFP_KERNEL);
 	if (!sd->save_area)
 		goto free_cpu_data;
+	clear_page(page_address(sd->save_area));
 
 	if (svm_sev_enabled()) {
 		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0d011f68064c..75733163294f 100644
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

