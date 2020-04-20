Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6B11B1347
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 19:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgDTRjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 13:39:35 -0400
Received: from mail-mw2nam12on2124.outbound.protection.outlook.com ([40.107.244.124]:36000
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726021AbgDTRjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 13:39:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2tspkJ5QPOZzpHHZL3+YNleYT3Xqsg497ES5sP972QQAyWPkdxkUBMvhXWMyloOkLokxEW03GvZ2r2pwqbF+/98ehlIJ5YwWtAVhKSRwHfdW+KwdKqfSAX8tjj8afCUJCuOU9N+8oSwGe1c3wdMMggtGhvmD4HiKkGeRTbKjdGFCbYYg1ZF9O3YPWxGYfIo7vZGhuHzC+OuzRfuOk7/iwzJ+J7VCW//M2rmHPgkJeZ0j8/wyx0eew5lbTPoluBmbxANG9MxhbA/p/MdzmnNVPE+/iisHsuWQ/+By+SQCSmBCWFHze+fTkEkgiBYnTL0NjPRb0lk2+7eW9L0dw3/1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rURpkildjr2k32/HcTJXbyFaUgkXhqE2Pfu/AMJr+e4=;
 b=WzcP70q0CSxzk3Y1dXHQoZC0YUDCB4+xLyyydTYI7gokJYyBvcK8qE4DO0EKtE5MdKEZ5chYApLzDt4b1BvffHBMR94DIg7LnYvjaMz0tIoNBKmYljJ+8gRSm8shsTRfMsKaRsEc+RNNak/GCylRzOHd3XUuwyZM4xF9Jsi1HRoH+SbX0NZQOYbqMNY1vqrQ0Xw9MZOSHhZHOuFo4AdAna8wu0q4suR9zxViXsG4N62qUNCba/13y2z049VAihZchtW1d/zPf/RaQnfmDo/3vmBELIaNMqGj0C2din6+LbIR+XGX2ypy/S5RWapr5ijtdUDnox7cEZav0LHGF0VjWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rURpkildjr2k32/HcTJXbyFaUgkXhqE2Pfu/AMJr+e4=;
 b=Gm3Iqql1yvUvGgs3xsHXgmv7vhjxUm6JJXnGNuWo1wWd5FN7Q4RSU69ahPyf7LQ6dUfdCU5ySyBe/fPOLxAAVlpXPlQ6DSjX2UT10dQGe6jn4z0vdq9fvQBciQnZr3JMaB6fb53J6xjMn9rApAPgRUmRbMZObk1S5uXQA40PqqA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
Received: from BN6PR21MB0178.namprd21.prod.outlook.com (2603:10b6:404:94::12)
 by BN6PR21MB0691.namprd21.prod.outlook.com (2603:10b6:404:11b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Mon, 20 Apr
 2020 17:39:28 +0000
Received: from BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec]) by BN6PR21MB0178.namprd21.prod.outlook.com
 ([fe80::a97c:360c:9ed2:12ec%11]) with mapi id 15.20.2958.001; Mon, 20 Apr
 2020 17:39:28 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     mikelley@microsoft.com
Subject: [PATCH 1/4] KVM: x86: hyperv: Remove duplicate definitions of Reference TSC Page
Date:   Mon, 20 Apr 2020 10:38:35 -0700
Message-Id: <20200420173838.24672-2-mikelley@microsoft.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200420173838.24672-1-mikelley@microsoft.com>
References: <20200420173838.24672-1-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To BN6PR21MB0178.namprd21.prod.outlook.com
 (2603:10b6:404:94::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MHKdev.corp.microsoft.com (131.107.160.236) by MWHPR08CA0047.namprd08.prod.outlook.com (2603:10b6:300:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 17:39:26 +0000
X-Mailer: git-send-email 2.18.2
X-Originating-IP: [131.107.160.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0597de61-168d-46bc-82eb-08d7e551c671
X-MS-TrafficTypeDiagnostic: BN6PR21MB0691:|BN6PR21MB0691:|BN6PR21MB0691:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR21MB069162D3419ABB03EF26FF0BD7D40@BN6PR21MB0691.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0178.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(7416002)(66556008)(66946007)(66476007)(6486002)(16526019)(36756003)(6666004)(1076003)(186003)(7696005)(52116002)(86362001)(26005)(5660300002)(4326008)(2616005)(10290500003)(8676002)(956004)(316002)(478600001)(2906002)(82960400001)(82950400001)(81156014)(8936002)(107886003)(921003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZeCwuwfbV6U01ZgoCdkjDEUVhVFn1XQ6nTbukuru7qtYoKE/oHoO/dsweZtDDxZZ8/ed2N5iSRDrLGjuAmv786C+iv2UkrlZKaLcwU6OyZ7Yf0xtqN7EOkz5cjrBWr4ZG3w8qkWH69Cf3kKxszg9QaBDLbe3h+sT+bNmGcmMK8FgUlKBvNa8G9tMTemaBRcCtpskWgOAoT59EcfcAlmDIFX6LLCpZDt7Q2u2zN/r9vtGOEe6pz+m38wPfB663S9dJPJdw8thQik6x9M2XGlELGcPldEzpVX0QtexeOu5KhGQdVspHzH+kH8dK0J7zlGghTVgNH1yLeEgjxqwGc/MFr9L/VrUnh0j5pMNX2Zy3sBoHThXjyIfN8FIBdQtX2Hd64ykVwkon+t+0jyQQAIGYHwmnmvqbJ+KFrGjg0qfXbjAu6o9I9iGIWjoRcvFqs+HWLEipQz5DdTaOpN9pC7dUj2gqiE3BecbQJXGzQMbtA=
X-MS-Exchange-AntiSpam-MessageData: 1WuR1oguNIZ1njAjorC3PE5uWuQH4MA5m/X9+Wvd+c5pveSj8SDk3AZW1y9Y/VzlhOkIpMk2DKceHYAw89/VV3f1wGbSZSH30CdP+N3S9SnnGxHYxuXjfVLo7RO3RMC00NkHthAEGF9Rpl8qYRjhlQzij0E9VPT9wzGWN/UH/ejiu70qf7WN2CUv5J2jkifgrGuRcVGEwfhcw69WP0FFpySCqWrMcgJQdQgXWmvY9hXHtXCKHJV8F73OSJ39/98COYQHQVijjUXDJJRQjbm6zB5cK61UGW/n7q954ZQlpeLdMo4IRaUk4YqsqqG5ufwzHJF2BvRrdgduLqZZRaZ4QD0cny13nNfVTWJdMlWiScm1GJVJcXljrYTs/CxTeRmlxCUGWL4VYHRAfb433nJWDhXUOvmsKa+771/wrbtFh2O4pRoHJsgf3JWre2UK4hAqmb6v0c2nteyIS0atA9gN4reL3fG9oECD2NE32jR3udZMSuShkUbECfSgRZH1PiM/fHQSWeiO4qr98UHV3Q03iBJNMN18Y/P6QzasqMsFRsa28hHESsZQxDv7AvucD0r8bgoDq9Su17PjXhch5qltCy8IMALjI36HBZfJ2HcA6pYt1GuuCqqQl+xC9sxZQ7ds/WV4pY/4ss7R9q8LOfjSwqtZwkalOrRHQuqK5DcCQfROM4ADwMsNsIVgS0lelai0nR+6wKWzbxkClcBsOAlYrf6fHiFPoGY4OhMvT1tli/Vdi0B3X1z53R8ruxm1QNza+YwEvKMhAu653r6paKhaYAboKImad+R7rm0XjRUfP6gu2Q8J/CdnceJyTLL/qpfK
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0597de61-168d-46bc-82eb-08d7e551c671
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 17:39:28.2393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k/iABEmlEjUlIr49f0J0P8ibccjxY/odeu06iD8gNtE/6HKpD+R3+6KxwXdWdvXOjiZyNkTJqhtUbgAu7y4Npg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0691
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Hyper-V Reference TSC Page structure is defined twice. struct
ms_hyperv_tsc_page has padding out to a full 4 Kbyte page size. But
the padding is not needed because the declaration includes a union
with HV_HYP_PAGE_SIZE.  KVM uses the second definition, which is
struct _HV_REFERENCE_TSC_PAGE, because it does not have the padding.

Fix the duplication by removing the padding from ms_hyperv_tsc_page.
Fix up the KVM code to use it. Remove the no longer used struct
_HV_REFERENCE_TSC_PAGE.

There is no functional change.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 8 --------
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/hyperv.c              | 4 ++--
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 29336574d0bc..0e4d76920957 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -303,7 +303,6 @@ struct ms_hyperv_tsc_page {
 	u32 reserved1;
 	volatile u64 tsc_scale;
 	volatile s64 tsc_offset;
-	u64 reserved2[509];
 }  __packed;
 
 /*
@@ -433,13 +432,6 @@ enum HV_GENERIC_SET_FORMAT {
  */
 #define HV_CLOCK_HZ (NSEC_PER_SEC/100)
 
-typedef struct _HV_REFERENCE_TSC_PAGE {
-	__u32 tsc_sequence;
-	__u32 res1;
-	__u64 tsc_scale;
-	__s64 tsc_offset;
-}  __packed HV_REFERENCE_TSC_PAGE, *PHV_REFERENCE_TSC_PAGE;
-
 /* Define the number of synthetic interrupt sources. */
 #define HV_SYNIC_SINT_COUNT		(16)
 /* Define the expected SynIC version. */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..4698343b9a05 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -865,7 +865,7 @@ struct kvm_hv {
 	u64 hv_crash_param[HV_X64_MSR_CRASH_PARAMS];
 	u64 hv_crash_ctl;
 
-	HV_REFERENCE_TSC_PAGE tsc_ref;
+	struct ms_hyperv_tsc_page tsc_ref;
 
 	struct idr conn_to_evt;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bcefa9d4e57e..1f3c6fd3cdaa 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -900,7 +900,7 @@ static int kvm_hv_msr_set_crash_data(struct kvm_vcpu *vcpu,
  * These two equivalencies are implemented in this function.
  */
 static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
-					HV_REFERENCE_TSC_PAGE *tsc_ref)
+					struct ms_hyperv_tsc_page *tsc_ref)
 {
 	u64 max_mul;
 
@@ -941,7 +941,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 	u64 gfn;
 
 	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
-	BUILD_BUG_ON(offsetof(HV_REFERENCE_TSC_PAGE, tsc_sequence) != 0);
+	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
 
 	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 		return;
-- 
2.18.2

