Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046F130829F
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 01:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhA2ApM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 19:45:12 -0500
Received: from mail-dm6nam08on2058.outbound.protection.outlook.com ([40.107.102.58]:18528
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231444AbhA2AoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 19:44:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDwu4WxI9kECLFkQg22VTsOTxgKfsHQoM/talrVLxoER3/ir1qm1F5krjpMrUxs6H/mBOUvhVeyu/xo40eJejdP+02t6cut9KoSg9/zfMc9PZPVjEOxciI4XuOFFUku+/bkY3HWLLqxsKxwHczdVZ5ef29Wnv5hjBVFCJSJ9mND+Fu0dH96a1GcSbjdZ2ePUX2rCx/36hPzPmxDWiB4EeLx6rHe0yyXFb9DnEjcmmqM82TUNyVcWEUgq1MEsNqmrW4GABrK9G7gQ1DAqjUn/710+GKReNfEf3h3GAlLbae0EG+LLoLjddXvF5bbGSf8MKloc1990G7kFwi/qQEUJQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0wlbu+rGSGyJtV82TTyePIZ+f3cfD9tyoTp4dGGUeo=;
 b=AZfcy3nvY+QPk2hT6tCtmOJQDUOgYc6GXSgVQf52hcUyAXsMmh0SdDu+8F9zUNQW77hx880oHtuH8UDaarf97slznjIgNpvXSq7Q2yQjHJag7MFGGAyXugdCfY84W/oUqMrRLFrH3MjbfwysYDCVL6ySLZCvxmuOQRyp1Lac5I9uUrWLCKGgOAjMVZHvBTB95Sigvc8DGey8TRXNPWPAvdlF9s35/rOPE1RGvlhpqCY0qNawuqxb16XwuPxWxLBqRzzVHPA8o3m7inIqAea8SsC/Iux4IMCrTCic3GR42zxsOe1mR/TxkMMuEvEU7k8n8n0Li39dpRpVRANJZBrrSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0wlbu+rGSGyJtV82TTyePIZ+f3cfD9tyoTp4dGGUeo=;
 b=HJ4aOVoin8ZbTlKjqFWo+ScuzFFWqMi2vVCh1N1DsITZyj1mqwc1muacfEduoNII5x9O56hKTnuQqOxam56ulmBKW5qigNoA5PEkUEJcT/ItfEaa6m0hrPj0xMEieM714Qezl5YPsoFxAF3x+qktaUpyQbfOo5CSH1XT3yaTn3s=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 00:43:17 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 00:43:17 +0000
Subject: [PATCH v4 0/2] x86: Add the feature Virtual SPEC_CTRL
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
Date:   Thu, 28 Jan 2021 18:43:16 -0600
Message-ID: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0107.namprd04.prod.outlook.com
 (2603:10b6:806:122::22) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN7PR04CA0107.namprd04.prod.outlook.com (2603:10b6:806:122::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 00:43:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60361f35-5746-4c87-6fc2-08d8c3eede62
X-MS-TrafficTypeDiagnostic: SN1PR12MB2560:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2560F2879D5B7FEF19313AEF95B99@SN1PR12MB2560.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AU6Ynwm8ZILj39g8BC+OVmKCeiduD6FfHlExKYDkxilUBtY/N7I5/nmfVBSySQpxu7YyD7Wtft6EEen1oEjCZaAh6x2cBSUTBtK5JiYbO7mzWQvmltW6VAW0dGrJoPm/klaD8nnJnC5yGA7bYXJhzO4PNswEQw538e1gDqzIXQQwy/tYk7WFN83XU8vQqaJTY3ye5pXHM68LExX4leY/mKB/Z4bIAKRp4SAvIo1y04agYePRa/952QTXWDfXUxNwgv+WNmzZi1D2hHwpkg8Ek5urhYib6hgn83XDxpZYH2JPLh5Mo5aUuJr+JhR5F7+TH+mlRnNZPPoHd6My5xzuEA+9Gb2L6+msRfafYlC7XZt+AVzSL7I7ntocisSxz5uopay6xwQ4WBX8Y4i/2tKPUNJxLi+3MMVBkLDwbVvYjovndrvpehf7K/j+mwEMh3pQ0KaLSGfW79f2XBqkEMI8NQrz9RTbMI2MGRFGpcSJNrSwgIbp9JS3DYf2kIw+85uSuuYm0ynbTQGzKQYBdgMWYTpARhLWRwcRx4+pIkMkb22L8nNtlLwEpgBH4GW/z1aDU3PPh6nI/E6DfpOQdwuNpf6eBx7nVk7jNroCn/opJlk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(39860400002)(136003)(366004)(346002)(376002)(956004)(16576012)(52116002)(7416002)(8936002)(8676002)(316002)(86362001)(83380400001)(103116003)(44832011)(16526019)(186003)(33716001)(966005)(4326008)(478600001)(6486002)(9686003)(66476007)(66556008)(5660300002)(26005)(2906002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WVVYYUZNYkZOa2cySFE5KzNselV2RDZYb1lyeUpnK21mMTU5M0lmc3dDS2RW?=
 =?utf-8?B?THd1RHJ1QnlVWGRHZTZKL0o2TWhSRkNpWCt3TEdrZXViWGxvejVGQTA1ZXg1?=
 =?utf-8?B?ZjcrazlvcSsvTU94bG9UVmk1OU4yRytBNDl3OThLQnpVK25hNi9meUdTSW1M?=
 =?utf-8?B?QStacmRrdUZRZ0YyS3k0ekxRdnU3TUFrSUwveUluazkxSnZkRDNodlZBSFFo?=
 =?utf-8?B?a1V2UHZPbWV2UjMzWlB3ekpZRXJDRlF3ZGo2QXNLSDg2Q2k1MHVYdUJvaTlN?=
 =?utf-8?B?QlhGWXl0WmdGRW1NYTlaN21Pc052L3Joa2VXbC81VjRPZnRRQTdwOEc2aFBi?=
 =?utf-8?B?bzVGWEVIRWdpWW5JeWpZK05YZ20wbjJzcnpFU29VRG8ydnFWbFFublR3ZmRz?=
 =?utf-8?B?Z1BPRlpWV1VBMTZrUFFhRU5xNnF6VUlkZmJlc1FQOFBCUm01ajJIeW5mVG81?=
 =?utf-8?B?Zk5IOWJOWmxsWXphTWdYUFpha1NzSzFyQjEzN0phRlhUN0lnWGtKMFAxMjNl?=
 =?utf-8?B?LzVVR2t6ZGZRUG5ZTWh0dlVrb3AzUjBGVURjSU9pOUw0eVBrNzQ3THduVXhX?=
 =?utf-8?B?L2FneHhOWktPK0xGR2FCeXpRWURZNFpobTB5L0gybGd1VUxMZkY2bzhKL0cz?=
 =?utf-8?B?bjNCdUxiaVYvcVJUZmhidko2MmVGZ0h6bjBtcVBrZ2hNYnNWd2pDc0NVSm44?=
 =?utf-8?B?T1FDb3FHTGozaGdzTkkwODZBdzBzZFF1dXl6WFZUOThaMVBwcmlqblNVdTVw?=
 =?utf-8?B?WDZHNDRRK05LMUFMODNPbkFjbnFRd09QRXhjd1FWNXZOdnBBZ0YwblN5SE1x?=
 =?utf-8?B?WjdackxTc2NZOWFvRGtZNXZGeG4vVlV3QXJyQ1EwWEowa1hCeXRZUGFBWGNs?=
 =?utf-8?B?VVlteWg1RzM0R1RiRHVKdUl0cEdOdEZCZ1VNaUpNcW9ya25nMmkzM0s5eHdw?=
 =?utf-8?B?RE9vd3U2TkVnZlErSEMza2poNDhGazZmNkd3aFRwQUJLTDlsSmVDVjkzOG0z?=
 =?utf-8?B?RXhLd1FjZk8xK2taN0c3eXVDU29pNUpvYVIraXdtSW0yYmU0MFR6WCtnQmJU?=
 =?utf-8?B?NVdFVU5EYnJxTjJPSW5DMEtmaG9nY3lrcUtmbHhpdm1NL0VRSUNWSFhsMkIw?=
 =?utf-8?B?amJGU0FWZ0s2cDA5VytacVZuc05PQ0Q1ZExXbGtXbm5SNkRtbzhjZ2g4OStV?=
 =?utf-8?B?NEZUYmpuSjVxYnh3V2lyZjNhc2M0NFdjSHgxYTJKRGhZRnF5bGVtU0pMZk9B?=
 =?utf-8?B?MFBTQUoyRy9NVURxeE5tR2NDdlJldDZldnYwZ3N6b2JmNStOYlVSdTBOV01w?=
 =?utf-8?B?ZHFYYS9kTitkVERSbXRXWG81YTkxMWU5UUJiMnBqNnBZOW5sQnFCWmJPbEti?=
 =?utf-8?B?MklBQWxQVG1IZE9LQUZkOWlpbVdaVDZiQlhQK1pMWkdHSXhTdFN3MmcvM1BQ?=
 =?utf-8?Q?8rHRhW4N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60361f35-5746-4c87-6fc2-08d8c3eede62
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 00:43:17.5240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tNBKMZwh0nJYQqRF9NtATWL+7Elc7S8D7nlAMqt+yg1XKfNkUCoYV2PkwstKuIH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2560
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR on the guest. The series adds the feature support
and enables the feature on SVM.
---
v4:
  1. Taken care of comments from Sean Christopherson.
     a. Updated svm_set_msr/svm_get_msr to read/write the spec_ctrl value
        directly from save spec_ctrl.
     b. Disabled the msr_interception in init_vmcb when V_SPEC_CTRL is
        present.
     c. Added the save restore for nested vm. Also tested to make sure
        the nested SPEC_CTRL settings properly saved and restored between
        L2 and L1 guests.
  2. Added the kvm-unit-tests to verify that. Sent those patches separately.

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

v3: https://lore.kernel.org/kvm/161073115461.13848.18035972823733547803.stgit@bmoger-ubuntu/
v2: https://lore.kernel.org/kvm/160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu/
v1: https://lore.kernel.org/kvm/160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu/

Babu Moger (2):
      x86/cpufeatures: Add the Virtual SPEC_CTRL feature
      KVM: SVM: Add support for Virtual SPEC_CTRL


 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/include/asm/svm.h         |    4 +++-
 arch/x86/kvm/svm/nested.c          |    2 ++
 arch/x86/kvm/svm/svm.c             |   27 ++++++++++++++++++++++-----
 4 files changed, 28 insertions(+), 6 deletions(-)

--
