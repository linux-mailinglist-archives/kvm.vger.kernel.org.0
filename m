Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B3636967A
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242868AbhDWP6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 11:58:30 -0400
Received: from mail-bn7nam10on2040.outbound.protection.outlook.com ([40.107.92.40]:30177
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230294AbhDWP63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 11:58:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hj8qwmi4AJr8VBRVDxxcenvzfJfDXSk3q4SRKBmQmMvMayr7bHuYUdEw+MVeVdjVVWzHlMxzkXqJBYoLxCmIZFe9dpWTi77pbhkuV24FQL0MnsUD1JVk6lVg1Yh5G1ZA46wLzfXEu3Wx+mg+RUAivvvXwtxLFNwH+GLzYS/YwSdkXpugfDbZ4MuTBzCnFBi9jfnRWYGgRF3TNCxwnp4CJQJNDSgkmEzOTc8goH3/ceNK/SeX5aiT2iGXd/+TJS+0u5l8RaK18i7fyH7H14BeX7xOyxSVMWJjZ2MiNpAxJW+D8csHTxlcvcmD19WmL3dAUJsfp2s9GmzcMOhrw2kZVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F53DxMEmTDauDiuBiayNoqFb/H5LiJjzcRFK40j+zLc=;
 b=k5B5TejZ8q+GFAJ8Sc63jpsHiBF4aLlGF9Wd871PgzSB7LXfDgn3buT77r+ToewSounmvEWAtgpuwRbmTA7oLO7t86tfEIQ0QO+ZXY+wzl4DzisEWCkCw410ayvBk6TCT+sxRB3yGR4hQiT4YCnXoqSXCYlyydQ0xb39MsizwekeK3daNrf5gI8eimkb3CoObDrYkqP3+N4XH2xYfqZOs1wp69w3GCrevjMvJqfUFseobfNyRSfjaCdtItrv3vgWqpbdF3fMainaqPm2s4QRa/KMLOjPtfeyo2SUOQSotGwg//Y6yakaWG+Gc3s0pj10WdCQI0sS7guULLAhMdplHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F53DxMEmTDauDiuBiayNoqFb/H5LiJjzcRFK40j+zLc=;
 b=tsUKZKvq2ga2HSGMkEoHtmXVWZ1+NLsyYvGFliWCURgGzLbfzgSxnN+kxkqDQlWBHst7WwVsz9VWo+FblhQyzVAx7d/xG8B/ua7cWpieglIHLm725owd0aW4xkoTZq2IsYEiTLAl3yFwSWJE8lCwav5QtEybscVRx2tBefrhFtM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2510.namprd12.prod.outlook.com (2603:10b6:802:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 15:57:48 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 15:57:48 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v2 0/4] Add guest support for SEV live migration.
Date:   Fri, 23 Apr 2021 15:57:37 +0000
Message-Id: <cover.1619193043.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR2101CA0022.namprd21.prod.outlook.com
 (2603:10b6:805:106::32) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR2101CA0022.namprd21.prod.outlook.com (2603:10b6:805:106::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.1 via Frontend Transport; Fri, 23 Apr 2021 15:57:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42598c91-4627-4b6d-ab9d-08d906708a85
X-MS-TrafficTypeDiagnostic: SN1PR12MB2510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25101F90E197B04088A803448E459@SN1PR12MB2510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lb+wb4rligL5vLiECCCipSmM0bhFPJk1DA4Od35vONcrFTyFlcTUhfV28nDozhPse/QQ0dYCedGLkxjO7aIzWqHdjW7k6vCf11lLMrWhDzQHk3omB0C3om5PoVuonJQrFfwsacmp6ccllUXsd/OoMg9Io/7QFJ/CvZuU3lx95e77ooFc6Bd+RoEBqV76IyRibsTxnIEmevdzRudi4gDe+2LkqD+R4jhPp1W42B4enc/FXQVrrSW9AqXD5j8rzd+sG4HDq2m7ViB1uTS+nM2y07fJMwU+j95M9RaivqJnPZxzkmQOOtPNJvX7SNOU7g3m83f1Nx1hXIvQK/rTzLLYjp9aRTa7aLd8zqDhyaxYMN8TIKdeSaeJJtHME1KZNT7b8EsjYMYWbtBC9MrBknPeNeOiMyBfAqpnE/9ZM1K0BQi7/yrqySZnUqEdAG16mP5BDrKW0r+MwRK4t8It0HDWE0xsQ2nds540LZ2icPCUU9f8V1XzzFfohs/WRJbuWR4lEj9rgLoST8I5WOxDqktO4sGsfy01Bh3TPWBiamld9Ym1rLvkNo7pLQTrY/Tb2sQS6r45ojtodpTpd4ZyAkXUxSAT1JQbuYqPfZj79lRTLy9hxsI/CE0l1rjlBJsePUsJcQlc007sV0OeoOa+LzrPDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(52116002)(186003)(478600001)(38100700002)(38350700002)(26005)(16526019)(7696005)(8936002)(6666004)(6486002)(316002)(86362001)(7416002)(2906002)(8676002)(5660300002)(6916009)(4326008)(36756003)(66946007)(83380400001)(956004)(2616005)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6D3makMF8kwQCjRcBu3Cr8YTdXMCDwi8hz0JrKamtpmwbU91iex5Jk9mpWzJ?=
 =?us-ascii?Q?EJdj3AsNfOhk6tzuFZyafCGrryvJf28GcfGY4Y/OnzxNAKQ8L6YxcRXgH+r4?=
 =?us-ascii?Q?XO6hMiD4BlDmDm85lUYdwepsfiovioauoO7uns8tzz99mPkohOOneh5rKugj?=
 =?us-ascii?Q?Z/Ae1OaLhBacBAme6IZtmfc6jBKmXVVC8D2331x0IM7vCXQT5UBjRbL38mV3?=
 =?us-ascii?Q?mcRod2iWPa+ePnPKYGbtyqXBxeIihI7UVzj89mXVZ3EWdzdLdyM1Mk6xInng?=
 =?us-ascii?Q?Z9i14J6NRClbqNJKj6Cjo/ed3eVj85BC55kUzlIKXjHEoshR++kXpwLN410S?=
 =?us-ascii?Q?uywEkDtzmltKZOoZzikeQecQ0fvZ09m+9+UjkQAe3VFHQu5eZbJz8ua0pKmy?=
 =?us-ascii?Q?Gn9owqSIPdDyKuQIeLvoEM1kXy009oQAFiiSQXgd7t3x/fcWUcs+0N5K//HB?=
 =?us-ascii?Q?0eiF3z1sM3xsziyzJcjaJJXfiySFkR7qZR1ogBNFJp9NRtaySXuhh9GvkS0n?=
 =?us-ascii?Q?k6o9dULvVBI1/JpNkNXGyalf/Q13jS5zebsnnX19fUcs5kzkp4ROWTyH8abU?=
 =?us-ascii?Q?j+tQ9AtNIIhXN7Zqgawr0swL0d6/m0XL9o5hXNtZr0Serx2pmv0WK3Lw2GcO?=
 =?us-ascii?Q?SNJcTHdPO+e2Aqj9CB7lSXoWBLFAAfk3xGgb6HMGF9pTrd2JGhg4dJG+JO2g?=
 =?us-ascii?Q?uXlj5nF88ZaJH3PPJNYorXNOGmp5YSEdByks40qgyvfO3vHkbIggHIGyoiLO?=
 =?us-ascii?Q?8JqK4o1Z31tRMeEp3X+A9dDfe5SBE9kvr1PmWhdX55L7Te5UBITlLzOK9iU4?=
 =?us-ascii?Q?Vv016cc7+J+Y07tdcJUXGy7NcaknLEkeynU5rAjm0RmaLTPBPNu1HLboYr9f?=
 =?us-ascii?Q?+FX7QwdGhC/53blGwyBtavZgo/phwZ4UGWgA8TGPVYuXVU2ULbaOHUM4g6Xc?=
 =?us-ascii?Q?0Am8WK7RwtjiUdJxXSHLwUOBFLpl8lTPz/YQI8oa7SlY341T5aq2D2J+sR/X?=
 =?us-ascii?Q?8yW0PR6x5AQQgiJ5J3yLGC5a7Qb8qwSeo3vYk235n1mkfbfytLImlSGDhZtt?=
 =?us-ascii?Q?qMVMyneSQRy7buAb4sXbg+i7mOZY422frs8EWLfyWYrxK2oKLEqH4xpna/He?=
 =?us-ascii?Q?Og9xt+xNvE11iIyGUR/6ENJrV4xp5ZHq8Y+V/z0ZUiAOhN8JofHo7s1lBBA3?=
 =?us-ascii?Q?6YAVgcWXnKv+HQ4AxG/xCB9P7JXEPUiEjvjueMazV21amTjwM86LS4czOv5R?=
 =?us-ascii?Q?S6B9fyhPbTgcypD6wfsn7quZIEayy2qTNi1/06O2U9Op9DdHnJnvzDENZRXw?=
 =?us-ascii?Q?bddJ9jHajsBjmivT1TyI9V/T?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42598c91-4627-4b6d-ab9d-08d906708a85
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:57:48.2084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fyy4rZQwBNd5dBISWgnbIv8kquIyqL1XvMD5TtpwoUGXm5x8eJIzFntvgb1u2B5cxCJK1TyrazIXULUqiz2yYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2510
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The series adds guest support for SEV live migration.

The patch series introduces a new hypercall. The guest OS can use this
hypercall to notify the page encryption status. If the page is encrypted
with guest specific-key then we use SEV command during the migration.
If page is not encrypted then fallback to default.

This section descibes how the SEV live migration feature is negotiated
between the host and guest, the host indicates this feature support via 
KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
sets a UEFI enviroment variable indicating OVMF support for live
migration, the guest kernel also detects the host support for this
feature via cpuid and in case of an EFI boot verifies if OVMF also
supports this feature by getting the UEFI enviroment variable and if it
set then enables live migration feature on host by writing to a custom
MSR, if not booted under EFI, then it simply enables the feature by
again writing to the custom MSR.

Changes since v1:
 - Avoid having an SEV specific variant of kvm_hypercall3() and instead
   invert the default to VMMCALL.

Ashish Kalra (3):
  KVM: x86: invert KVM_HYPERCALL to default to VMMCALL
  EFI: Introduce the new AMD Memory Encryption GUID.
  x86/kvm: Add guest support for detecting and enabling SEV Live
    Migration feature.

Brijesh Singh (1):
  mm: x86: Invoke hypercall when page encryption status is changed

 arch/x86/include/asm/kvm_para.h       |   2 +-
 arch/x86/include/asm/mem_encrypt.h    |   4 +
 arch/x86/include/asm/paravirt.h       |   6 ++
 arch/x86/include/asm/paravirt_types.h |   2 +
 arch/x86/include/asm/set_memory.h     |   2 +
 arch/x86/kernel/kvm.c                 | 106 ++++++++++++++++++++++++++
 arch/x86/kernel/paravirt.c            |   1 +
 arch/x86/mm/mem_encrypt.c             |  72 ++++++++++++++---
 arch/x86/mm/pat/set_memory.c          |   7 ++
 include/linux/efi.h                   |   1 +
 10 files changed, 193 insertions(+), 10 deletions(-)

-- 
2.17.1

