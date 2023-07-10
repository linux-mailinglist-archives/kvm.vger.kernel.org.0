Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E9274CC8E
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 08:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjGJGDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 02:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjGJGDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 02:03:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10olkn2058.outbound.protection.outlook.com [40.92.42.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5176EF9;
        Sun,  9 Jul 2023 23:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjGbyPs7EMTUM80OpasFNcqA4HGYDFB9o0p//tElWSX6PwC2emDCb29sbnaUXDKQXVWT4kn9w55Gro7ozZJlzemo81+13IubmWeCe1aSGEJ5o5MvoEDkUHUeTadA8qF/lJsUhEfCoHJSmSLsRsf3IYNsOTUKiTIkY3bsMK5ohQ64HR8cj/olX/p+teL8EdbKMkuRZRLjEgTbzz4tsChKlvzQdjGynbVPKTElL2oq9dSdZHMeof2tMYkiZWW/ZkF1AL3XKdip8pRh7C5cfDAbM6DX6idEWqhFk122td57ZmNZmf3QA13b/2y7rxvt+7tSeTUE5RH9/hM5hxU/S00ybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0MgV5VPMyqweO/ihBS8dO7N1j/KZgwBvlpicDA+gW0=;
 b=Krzh2MVYraCDpGD6x6iQtNXBbf3Qzv/w0bahY93vWDLag1eFci2IQGkD3pTBlcwh3qs/1idjOkTJbfpJcQMQ6/l5tbLQnk6ZoDRhRFXKTeJQ4YPn0gPPsTT4bkbl11YfJLEuBXIRNdGnH2VeQXbu43VOQ2k08TC2Bx1LwODh8JmKH89RrjHFkfr39bmYEvmtLTp7B9yzH5PhU2CwqBSUd+pnSNRs+H6NaaaIyd2jXthaS9NqVsbiF84YrWojR8RSNa9rAxb5fT8Wt/WtN2Jv6YirDBUPx8QdwMTC3r6m4ieOzPUzCrp8wgC/JRJTei+Jf6W4L1Q8NXf/bp1/ip1YtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0MgV5VPMyqweO/ihBS8dO7N1j/KZgwBvlpicDA+gW0=;
 b=fhunOG5i23VmlNoaiiSqS+rkQLdCrTRKVpRKoh0IbylKCnTpC9mNXiB0jkU9MujeRE53AAE86DPfaFSua253SJo9fW0OGeQsF6sV8BjYXnG1n/IAMi1z6ZYK/bHAQY+VCftgqO4gPsrqFG9JC+94v+Y+Zx45jKuRvRj8jLfi8YdXXUKFUyouSsa4+hskR6Qk5MN4On1xI7aIeL28sGydI3KXiCHEhSY35zYxLEvAphPgrlTkfXD/uM6JcQmT036rTj9bXKn5p1CL+qbkyDsLsHlZDTVzr7IGye25RTatFzx43O9n38CCq2i+579XzVmBgmoo1XWwV70myorkDCuGlQ==
Received: from DM6PR03MB4140.namprd03.prod.outlook.com (2603:10b6:5:5c::12) by
 DM4PR03MB6109.namprd03.prod.outlook.com (2603:10b6:5:394::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.30; Mon, 10 Jul 2023 06:03:49 +0000
Received: from DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33]) by DM6PR03MB4140.namprd03.prod.outlook.com
 ([fe80::d106:d232:850a:bd33%3]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 06:03:49 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH V2 0/4] KVM: x86: introduce pv feature lazy tscdeadline
Date:   Mon, 10 Jul 2023 14:03:23 +0800
Message-ID: <DM6PR03MB41406AFEDAEF105804ACE573CD30A@DM6PR03MB4140.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-TMN:  [BKFSQvwwIgS3t2kDN7E/u7D5OnSia0WEYTQviqQ8HTM=]
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To DM6PR03MB4140.namprd03.prod.outlook.com
 (2603:10b6:5:5c::12)
X-Microsoft-Original-Message-ID: <1688969007-3796-1-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR03MB4140:EE_|DM4PR03MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bda9824-3cc5-4653-ef44-08db810b6dc6
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y28mnXrYaz3TQtaqHIOdY46AcQLpw4pHL6AUFmZ/q1kxd2ajXWVExebK1IbUxRMGuIYT5RaOf1xb7f9SxgcWlmCUud5/ufca/2f5/O16sMgN+LN1pR9WN8itmVko+htyPbDr4MfXjOXiRPmFVhy9Lzfc62RnbkjWWUCln0bgc2nGs+aN/RI3YDGnBJg/gtWQxqS7zIH/6V/5D2Jhmgu6ndw3l2VUKcBfJ1K6WgIEQ8uxeOS2DQssy8O/02BOlNzCCurmusJNeQrB/daDx0i7237QoKzLSyH5FDx7ijDzMXMuljS2v3toO240FECKmvv6Lgq3Wx/M5TfSNj67ZYBBOt2H+sS1UVy/XuEFrlxBIZp23ClNFfunVE3u2eMq/2s2EoO+auOSn/1w/b0Asm51Wlg2Gu6R/I+jXFzwvcUSIpqJMneoRfqRKaG2TJ0LlTnBNcK8RunVVO8ypdlhM3cINmgWYX53usymFm707+bL/IXLAUtLV7H0hzWiurVjvi/ZyNkANJUnPRiorxPEwpReUIa1oHrzRG7EcyUZcMosMXqEaE+y9TwTQ+cED0sYVgZZoaXenmvCHtXSNiLTv00ZUvu0J0RGg2uFF5uQz51A3HJRa5uL94u78rRoolJ2dKTqowe4dME0ARClhn3XfKRtIj792QfRPqN5W46h64hTZFsWUx0pZwnNfH+8q5OXjsKC45cyCVbGYu2qvLB0MHO4UXf4HwV8iHPKNfjhqfcUxsL7PnWpixj1pVW
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wxw2YNIDISx0X1d9bI50zjOrM4rOk54KDFz60Ysd0zlF8drzyqez0o7c2HvDalqjIoNBktT5zgjg1uh3U7Wv53W5dWSOANdA0a5/qLUCZJ/8MPGs8U0pZOINRN3R5LBwzYMMhzsVuZV4WgLcTR6gBkDKuiDbtldgTGknEgS4vNV6BuHQZjLI0Kgla/Xm25d2rJu0RB5D3NHvXy1t1d8MM+rhGmEp03rYz3tMqqRZ2MWWd+rhddOACnS3rFz3YtQjU4xL0S++JwGu5I9DU7Or6V/VJRBwc67LiDnJfpaO9pzj/TlK1tDqcvNLayWKv8isubPU9AUZELq6KtsqA/ejYLxN3zz9QENm1GEhFB0jYcDlnHEx8f64oYKC2LmkoEISuqYWxSOawH9cvjRK8OAg2MkVKCoeh0B9yhR73JkVdM4tCAXPfeN2sAypb22LBrHyqJmun2d2/wrEdDNb1oqSQ80v+JcS7hKinHAHWEadFxZuoMHHRpN1+mT44TvwzCvj3YkCu0t2TgWccdtwyyz9Cm7etnD551TUcbozsbp14WQOPK3o8EMzti0f0ze9JzJ0
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6zZEp6BcQPw1Kf8xTlOOyTCFCzLjqtvewKOK3TaRsNaNjycEYUafS4xaFDsE?=
 =?us-ascii?Q?qfgj97nvHssjiA051li8hhTTbBjO57Rxkhvp3cxaSuueWxr/UJ/IELGDsOoX?=
 =?us-ascii?Q?O7XwjOeOLmiRdGmvnBs0qSZqunz8sSsLGRheBhKB7pYJpM0zKwli9OOKu7b7?=
 =?us-ascii?Q?Cqf9RCZcD9hKnu7Xb35czplFSMCAQ0hQM8QheMFSrEMKsep7NcO76CyPo+Gr?=
 =?us-ascii?Q?W8MLq4MmxiqKZVIk5Ibm+7FTe1gWRTYAygbe8xCWyzbUFqm75emJrmNGk0Ns?=
 =?us-ascii?Q?RhWFiMJPebt2ajBEyUazlgZ6xYP7nNhOsKMpHkNLXuFxBCG2COVO1rfc89qZ?=
 =?us-ascii?Q?sP3bd43OManqaMV6n6/91mAtb4W6SLx6ToQ9IK4fjs83wINg3qgWrVDbIr0y?=
 =?us-ascii?Q?9tAc8fRJe/wZHITbe+eFbRenMLtUNM07vG8uWvO/hdQ6RckCKv+dRRbKA9Bm?=
 =?us-ascii?Q?uZurJBSsk+YIOuGOsxPsErLGECljzgUvP1pPN92YbmoJdwssUd4sJ/9/4VXd?=
 =?us-ascii?Q?gAfRnP82xk8klwxeGWJ7XGaiZx7H356T8UCxUdmoWlrkI7R3kgkYXkN67MWr?=
 =?us-ascii?Q?/A1avog2utKR978CYX9fQlaB/iFI3ANb9C2CM7SzEaJyStX/Ass7/+JV/924?=
 =?us-ascii?Q?UFWvsCt38qJwYGXtFeZL/2D+uvOZBFH105cCE0YKwuHg0ijEgC7N8g4wYUtL?=
 =?us-ascii?Q?o0U2yTeooK/2meMrNNeLMalivhUQ+d/qu13p4W77+pmIfWv89wLvVz0IEjIh?=
 =?us-ascii?Q?kqzdGA7fFzD8OFYac0Rtrh7aW6PGcFXg8L2gAywCgyfpyB1A3g2byW6Xhgx4?=
 =?us-ascii?Q?nUlI3zg5eeHQUXKrt9LiLQGXMdyB1sRXsSxFGwmMHxtXI53mK/wojhPqRyGt?=
 =?us-ascii?Q?gmV7KxRrVcoftaCw/d+AqHuhrZyf8XSdvvpSxhua095qjGMfv6dyK8+Z2v0m?=
 =?us-ascii?Q?eYdKue1XUpEs/u62HNBlz7wtYTjbtBVj5hMOhd6vIlvW5fB9vc98KOg8D659?=
 =?us-ascii?Q?Bv1YjX0krmHyzlOYfNVyi9jO+kYrV7tpoBnrX667ZWCHdl2CTITrHd2NlLk7?=
 =?us-ascii?Q?VIBHJhNgNH0zwWEcnNu8FvuxC7YZOwP9MsAWyOKJaYbiE7JjcZK9U5nOCfxc?=
 =?us-ascii?Q?Swz/KB+6bh8jueq2knqqaN7n9+Yj2MWneR90vua8NY1iXSypUfBMtc9fLipo?=
 =?us-ascii?Q?uaH6zS3HQzEsDY8YvKJT3iH1DpE0ZKNfueJeWUcH2GPt8FbMjdviynN9sKc?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bda9824-3cc5-4653-ef44-08db810b6dc6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4140.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 06:03:49.5664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR03MB6109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

This patchset attemps to introduce a new pv feature, lazy tscdeadline.
Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
and host side handle it. However, a lot of the vm-exit is unnecessary
because the timer is often over-written before it expires. 

v : write to msr of tsc deadline
| : timer armed by tsc deadline

         v v v v v        | | | | |
--------------------------------------->  Time

The timer armed by msr write is over-written before expires and the
vm-exit caused by it are wasted. The lazy tscdeadline works as following,

         v v v v v        |       |
--------------------------------------->  Time
                          '- arm -'

The 1st timer is responsible for arming the next timer. When the armed
timer is expired, it will check pending and arm a new timer.

In the netperf test with TCP_RR on loopback, this lazy_tscdeadline can
reduce vm-exit obviously.

                         Close               Open
--------------------------------------------------------
VM-Exit
             sum         12617503            5815737
            intr      0% 37023            0% 33002
           cpuid      0% 1                0% 0
            halt     19% 2503932         47% 2780683
       msr-write     79% 10046340        51% 2966824
           pause      0% 90               0% 84
   ept-violation      0% 584              0% 336
   ept-misconfig      0% 0                0% 2
preemption-timer      0% 29518            0% 34800
-------------------------------------------------------
MSR-Write
            sum          10046455            2966864
        apic-icr     25% 2533498         93% 2781235
    tsc-deadline     74% 7512945          6% 185629

This patchset is made and tested on 6.4.0, includes 4 patches,

The 1st one adds necessary data structures for this feature
The 2nd one adds the specific msr operations between guest and host
The 3rd one are the one make this feature works.
The 4th one adds debugfs file into /sys/kernel/debug/kvm for this feature

Changes from V1:
 - In 3rd patch, rename the variable of kvm_host_lazy_tscdeadline from 'host'
   to 'hlt'. And in addition, add more details into the comment of patch
 - Add 4th patch which add debugfs file for this patch

Any comment is welcome.

Thanks
Jianchao

Wang Jianchao (4)
	KVM: x86: add msr register and data structure for lazy tscdeadline
	KVM: x86: exchange info about lazy_tscdeadline with msr
	KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
    KVM: x86: add debugfs file for lazy tscdeadline


arch/x86/include/asm/kvm_host.h      |  10 +++
 arch/x86/include/uapi/asm/kvm_para.h |   9 +++
 arch/x86/kernel/apic/apic.c          |  47 ++++++++++++-
 arch/x86/kernel/kvm.c                |  13 ++++
 arch/x86/kvm/cpuid.c                 |   1 +
 arch/x86/kvm/debugfs.c               |  79 ++++++++++++++++++++-
 arch/x86/kvm/lapic.c                 | 129 ++++++++++++++++++++++++++++++++---
 arch/x86/kvm/lapic.h                 |   4 ++
 arch/x86/kvm/x86.c                   |  26 +++++++
 9 files changed, 308 insertions(+), 10 deletions(-)
