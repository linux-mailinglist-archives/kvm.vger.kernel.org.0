Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980E12F821F
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 18:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbhAORW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 12:22:27 -0500
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:31456
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727902AbhAORW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 12:22:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wy1PQrikKe27Y2fWpLmqL8zFjzHBC+5L6PXzD/HwaK9w+kz1GAl2PhxyEIgUFlpehS3rH2CPlD16Ah52GQBie8iABIFqxe0lCtf1QGQzSfH8h+67bSEj0cV5KJ2Ljf2hZCTi7w/3GN0/XLu7bgbbD6bltcU0D5YEFW+ruQh5dpyJYb3GRWlimNz9Bb1TcJ91Ij+8Eob8pzm8MBgd2hEGlQuiFO29HyJDjYz355EFK/W6s2+muSuAN/cUeQYUdRk2gv9zEhEv2vvQpNUeSPO16RhZhI7/m2Y4fPrlWMtQhzvs5Lr8PJLzu11Uzi/ppDGRydn6rygrI9BuK1UMno5bwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aU+cEoFG20fBtXeFBdLKxb25bP2RxVKXyqGS9kJG8y8=;
 b=hyw00snUuz7s9lzuNDhhBUs2sF3YYkjsuYmgoXs1D0ouDERnjz0U539kZnln+E0rtjWfK2NXCb/jhko4tuOWqyGjPO+xEZsixS2QqPrAAL1/Wk3K7wY4pyGWJXZAFoTfC+NUDzrCPshq3rF95peQDLGrhZxtJfu1WIZGxrFIRC3o6IJUEecex6vL+U5EN3OdswQVy1FlI1xWslTEBJlAzEGO1mjtAIGcUeZz5UqYzCIsddx4MvTBE3pTDWOGlz1i2Lrn6sB++22KNlL1X7jz/FKwXr12GOGeP46/nYTAdv72lb3/8d/twphNikOOdHOCDHdYu+/N50G18CZnoIfQCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aU+cEoFG20fBtXeFBdLKxb25bP2RxVKXyqGS9kJG8y8=;
 b=WcPmIgOIQKFK9YoGpGI9kIz5Uy2w/7a+YgrYlL4cvAIHeaiCD6poc7cqTyUs7pFAsCsuQZfBVEGmqfOEi8DPs2FYqi+Rn1l53sMq/aP0HhXYJWTbwSm3gszjSoTBt14D7W6ftRNVQb0rOywrn07+YvFFEneuBEeqhFXfJL9M7yM=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4383.namprd12.prod.outlook.com (2603:10b6:806:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Fri, 15 Jan
 2021 17:21:28 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3763.010; Fri, 15 Jan 2021
 17:21:28 +0000
Subject: [PATCH v3 0/2] x86: Add the feature Virtual SPEC_CTRL
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de
Cc:     fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, thomas.lendacky@amd.com, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com,
        jmattson@google.com
Date:   Fri, 15 Jan 2021 11:21:26 -0600
Message-ID: <161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0136.namprd11.prod.outlook.com
 (2603:10b6:806:131::21) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA0PR11CA0136.namprd11.prod.outlook.com (2603:10b6:806:131::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11 via Frontend Transport; Fri, 15 Jan 2021 17:21:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6dde84e2-aed4-4c3c-30bf-08d8b979fe31
X-MS-TrafficTypeDiagnostic: SA0PR12MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4383182CC7A067E73A78A81995A70@SA0PR12MB4383.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJIF/4JfN1OQOEh0UGiydCKFJg4FpVjRr+h71TcA0u6OjrOyoVp1hiCdIuYZIORWPBNYmi2jD7TbJ/+msoZba6n7/FBO5lEbwLmDEjwcbODUDKjOkZ8fjoZ3v7rFRcHA5jxZ7Ab/tgQJOVLltqcbTYXdaNhaDHTey+qEI5bVU2aTaV9Z0xmDEaCf5x6KtGX0CRbco+dAHfOS//75vwpWfPFTqb1sZSWwFTgTGvuwf1Ol+8g/oAgWboliZg94qMTNHOrRE2rDrZRyPcHTBSQZO18tg8APAJskFLXk3a7P1HvbAh/AT6lA9BURsBWoDCZ46PwehkpPG3Vfqv26obli/7AmjP1mq8rk7c9H6y5y7npupcqtFRC82LlTH8kno0foOptspgykg9/+6ZcroIBkF6Z+4r68RGraSwehFhfy6engCjsN9gVB3WAh2yisZoHBUOU3NfcSSINjzOBAjmOZtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(4326008)(956004)(16526019)(33716001)(7416002)(316002)(44832011)(83380400001)(478600001)(52116002)(966005)(9686003)(66556008)(103116003)(66476007)(8936002)(26005)(16576012)(6486002)(8676002)(186003)(86362001)(2906002)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MzlISnNqa1o5cVZvSm5FTmE1Yi9oLzFKbHdtbXl3U2p3R2RGWTA3TXhTRVBv?=
 =?utf-8?B?WklRUUhyK1pHbHdTdVNEbU9raDFBQlplRFUwSGRCQlNOOGo4bDE4UHJtUUFM?=
 =?utf-8?B?OTNnQWFydFlDTTNYeXpzcDZpaDhmTkIxTHUvQU03WmowcENySEM3R0xyUXg5?=
 =?utf-8?B?TVVpVXFIemprcGp2K0hzdmZDUkNKdVNRbmZneDdLNWN4Z2V5cDQ1MGJKU1lG?=
 =?utf-8?B?dWZDbk5VcTF2RnNwb2NmcGJCS3JnaWRQWW5zbUtJL0RPRUhmOTN2VnNkWDA4?=
 =?utf-8?B?YzJuTFNFdDhqeXc5anh0OWFHVzRhR2VMWFRkQW5BVlFYRGZkcXpEcDNURVkv?=
 =?utf-8?B?dnNLMkdyMlVaQ1dwUEZNbllmVE4wUFRyMk8yRWV0ZjV0UVFxcjNlNTJLK3ls?=
 =?utf-8?B?dmN0L2RydHdTN3IwdnA2a21sZC9SWW1vUFphWHVVeHJ4NVNpbVcrRGpRRG5Y?=
 =?utf-8?B?RkRJbFY1NDZNSUtyZ2lwY1VqTWQzUmQ5RGdBbjRMWGNMRzcwVVY4UWcrcGtv?=
 =?utf-8?B?dXFjc3BFYXVhSldOSG5WZERwcStIK1psVElLUjVwY3hiVG84NjJpMzBVZ1JQ?=
 =?utf-8?B?VkNJc1lmMkxjL3lXY0pBTGFrTnlacVA2YlVhdHhPVEZ2YmszQS9LZEZaSjBK?=
 =?utf-8?B?U2pYWFJFV0puNisvRVhHc1NOaG5ybFp5YWpGQ1JMQkQzS0g3UTFsOHdjVnBC?=
 =?utf-8?B?dFBsUkx0ODRXdWcyTWQ2MUJuNEw4SVBhNmJjZ2pkODhEYXdlejVEMTJhM1dI?=
 =?utf-8?B?Nkp0MDlhcWYyZnNCdTFYQzNibEV3UEg2WDBQZjlYQ0hrcUE3UE1Ud2UrRUpO?=
 =?utf-8?B?ZlVFU3VENXo5WmZCSVlBNXBCQytXd3hvQ25nNGVZdVNLNUcveEV5MkorNlVB?=
 =?utf-8?B?K3VISmlRQVNjL1dVWmU4bzJNa244SWx5QlhLN0JwdVNUckZwU28vdkFqSU5v?=
 =?utf-8?B?TVFlUkt1dEZrcGt4Tk5nblhWVFRWSzNPR3JiSkhDa0wzcmMzOHRIYXdqREtT?=
 =?utf-8?B?MERzZlJ2Y3REWEVDTzZjN29GQWpwUGtTcmlOejhvaVRqZTlsM2w5YjI3bU9F?=
 =?utf-8?B?L1NUUnovMWhZQ2tVQ2lET0ZDa2t6czlmemNKdkhCMENTQ1ZzR0NBQmpzMWsx?=
 =?utf-8?B?YWxoWlJDa1NPWUNnc2xYMENwUnF4MXgwOUtmU01acCtuWTlRLzAwQVI5K2Zx?=
 =?utf-8?B?Y0crRWg5cEdpQWxHOElWV2tIYklBcm84Zys2R3VvczVrL0ZlcUE0Q1VVM3Zt?=
 =?utf-8?B?Z0NzL2gzTit4R0NBNklIa2d1M1VxV1NibHhqSkhHbm1DK0lIOVRkeW9IeW1m?=
 =?utf-8?Q?c/L72mVsdfU5gfYW+xZUzOnzXeJ9hnVAlD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dde84e2-aed4-4c3c-30bf-08d8b979fe31
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 17:21:28.0962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rr33v0Qx7pRrxZLyHZ6rb4srJx0uNt+pD3W45ny/B5BM3dd8Z7AEybJrHd5VHEN6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4383
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR on the guest. The series adds the feature support
and enables the feature on SVM.
---
v3:
  1. Taken care of recent changes in vmcb_save_area. Needed to adjust the save
     area spec_ctrl definition.
  2. Taken care of few comments from Tom.
     a. Initialised the save area spec_ctrl in case of SEV-ES.
     b. Removed the changes in svm_get_msr/svm_set_msr.
     c. Reverted the changes to disable the msr interception to avoid compatibility
        issue.
  3. Updated the patch #1 with Acked-by from Boris.
  
v2:
  https://lore.kernel.org/kvm/160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu/
  NOTE: This is not final yet. Sending out the patches to make
  sure I captured all the comments correctly.

  1. Most of the changes are related to Jim and Sean's feedback.
  2. Improved the description of patch #2.
  3. Updated the vmcb save area's guest spec_ctrl value(offset 0x2E0)
     properly. Initialized during init_vmcb and svm_set_msr and
     returned the value from save area for svm_get_msr.
  4. As Jim commented, transferred the value into the VMCB prior
     to VMRUN and out of the VMCB after #VMEXIT.
  5. Added kvm-unit-test to detect the SPEC CTRL feature.
     https://lore.kernel.org/kvm/160865324865.19910.5159218511905134908.stgit@bmoger-ubuntu/
  6. Sean mantioned of renaming MSR_AMD64_VIRT_SPEC_CTRL. But, it might
     create even more confusion, so dropped the idea for now.

v1:
https://lore.kernel.org/kvm/160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu/

Babu Moger (2):
      x86/cpufeatures: Add the Virtual SPEC_CTRL feature
      KVM: SVM: Add support for Virtual SPEC_CTRL


 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/include/asm/svm.h         |    4 +++-
 arch/x86/kvm/svm/sev.c             |    4 ++++
 arch/x86/kvm/svm/svm.c             |   19 +++++++++++++++----
 4 files changed, 23 insertions(+), 5 deletions(-)

--
