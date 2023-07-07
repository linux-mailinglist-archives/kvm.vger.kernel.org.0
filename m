Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE9074AB37
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 08:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbjGGGkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 02:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjGGGkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 02:40:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2019.outbound.protection.outlook.com [40.92.22.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2441FC9;
        Thu,  6 Jul 2023 23:40:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzOm1DePLn0IgbeUxYqCaCLaEhWrQJdBEk0WvrZDHq/lNhtW2iG3rAwsy6YLaozuHDFIGN+9qfaY10FHp80Zb7IS9wU4iGIqSWxik6luNY5qyEf73SokRpjQVKtAMl+agMqQli5MxDUjbOEFqCHtYkFldixK8CBMaK96z2LmVzldosKfutGaa3FRr34zLDlZMIYYq0WPCVHeMZfHuGjOLn0//AKpoW/wf35iEFKWaXy0RN0xk6QpiWRc1MKfAO6kDOpfiW3kxSIXmmZtXbk7yI8fFgeXamuctT0gANr8vtJ+NMhLmnbEg4C7IJqnhd/YDObHjcLDbgHlPyYglHe+mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19RG1SaMUVl3+2EBXgCj+ApwBWPZNiGQRSlzd3o0kI0=;
 b=MAsUjpY45K6AvC5mT8YpKWZ1nMvgkYKQs37eLUGMVDNL+vO13UsG3MT9BDTz28wkVTPlSMgsz4OvTe7D5THaBy241breBArRnGZpSmwvMZKDjdSW/y7lYxjfE89C36j2v9FWiHYP2JoZsUelt2AZEx0+vclc3qb2H+zs4TTXwQZQBli4Xt1rT321SGqQdsK3tk4f7qwGJ/cX8iudZvqWHncjX9hQ5ran+paV3oHR2RBjTl8ePkAcwnC6slaZNfUctOZ7EPgfgcakxWgfd1x7yLzuJwfrzBlXZ4oqv3SzrCEExNfqOhWhdjnmbw9kxiHQGRQkNHhl1fKb9PctLsXajg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19RG1SaMUVl3+2EBXgCj+ApwBWPZNiGQRSlzd3o0kI0=;
 b=mSqTvW9e3feY0V3YWwQJ/6EkVIhpHuAweLFatWtJ9/1zGCZc5laGFrybyQaciqlzypju2jSMd1EmHJwIAJIMNn8Rly5DXWq5Ja/RtTbAZ72AfSpoaxHblMxWouyrFLsc5smXsAPWl7GWGLI9iNOtJhCbIq6JKA4XF3xYWmIK4v+jZimiqixJFI9vjVhCsZcT6L9iA7yNJYfMPJ9y9RF7hd4F+UbdjrqMcprJ25/i3BpDANAvvdqNJW2QNRH0PfBvmps46nWBmeDbGJoE8BethTxQ1XiykSgxEQyCPyotvcawPjJkwlafzQGcOJOliQ5UbMC9tMViM2VB9iq/+LMilw==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by BN8PR03MB5138.namprd03.prod.outlook.com (2603:10b6:408:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.25; Fri, 7 Jul
 2023 06:39:58 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671%4]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 06:39:58 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] KVM: x86: introduce pv feature lazy tscdeadline
Date:   Fri,  7 Jul 2023 14:38:30 +0800
Message-ID: <BYAPR03MB413341039F377D6161D0C7C5CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-TMN:  [dGQzSBwkW3S9/Adzmdqu0PjRTbrwD9rm]
X-ClientProxiedBy: SG2PR06CA0215.apcprd06.prod.outlook.com
 (2603:1096:4:68::23) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1688711913-23638-1-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|BN8PR03MB5138:EE_
X-MS-Office365-Filtering-Correlation-Id: d2f545f1-2dc1-4230-7326-08db7eb4fb53
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y36AGtJtE3eAQUqDJjjc43R3wiKbhilorkuNZzEjuhrLa8zbaRqgV+rViE8Og4q6XaqNt1ah2FwmCn5R1dKFAWg8mOxXLuqmVnglflfErxCpT+e6UgPEhd+FBoY9kZECIBUWeP7t45ALBRlEdtU4IK5Spg9KzMtH/+n1R4bb8HvKlV1/Zl0rwGmhqQGSASTRCRdbMO17KG3PyBLdV7hYaU4SMxVRXCTQJpo+qQXlqIoiwIk6KG4PZunV7OT7iLFSUvxYdz61Any50fxy0pqweMCYqnvm8MZ8WJYUVV1IM8GhyYO209cXE923eUFOE7kiYrhObvjZWeq5OA6k7yGvbglToR3pHuZsJd1gOaTbfXRJHzhLhbr616jXhG9Zjj5MdFcy21Wyluckks/5qrAolHK5pP/HTncvxlBGWGrehaV2ps/RI720ZhRup4NdeF12sRlmIBFO67r8T05/sj70oS7fDzmsAS8lDEeNxgJhpg/HeIumaFt1UZacA8At6b39iEgd5xH8mUbiQ7DFTuN6O06u3zhUZ5/pCCsorC92VMYpwYGlxAxfrFeh5uBM6XNDq3Poj6bKUh17Q2otcyytWLWxpN3rhttOqAN5nmH/27pe/4SUIbtE46ix0w0RMawVv8lHEHkAyUdDEWQEZUg4zoKYpG/WhXGfMagTxtOYY87p/T5ykqX2f7cfAnjH9m0048tGGYVSLORNUAE5++nYCv/5IaF9NAvfW8Gu0TaYoXD+7k5jd9NP4YJ
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRf3hgF+hfNZaTsdIGen98/Y5AjsD2kCiNXxQmc/QaVHjBkpepdM716OnlPNbdn0R2AH6jRdaxoGgQu5XBk4EaNJYBAUCG4H8keGyCUwTIOP1Y6kAjwBeJJrDj0j+hsFyX8iFZSg7OkZW4w1OU1iBvZS04AoeG4HQdqTFDbKcaeCN8JJ/eNTQAMVeu7On2aaSAcRZ1yRivNNK1SL0b1iw+uwkEFB9Yz7Mxxn1zYniCLP+uZug++1wIWNfpeACmPaBaOZHBXhs6cvcbBF1bSOxVnuFImDto97b05KcTEqIeAT61GhcgULUwgixCDE3cpIHdiJWUNvxgXlR1LdPXb7CRanm93sD/Z9tG5MKYeD6cizgHeAdSC9W4PUWiBhu1eDkRFusItMBJcn79vCPENfgw9DC9tmoZsm/D2516msRG22FlvXK8EpkDwCT7O3aAIZyEaJa8cxH9z6RLNiXOK/3wnlt+esOL7cdzuzTkUXCOvW3ltTOjoa6QyQGkBUyxEY5cwnVSZJeEoypX4fqvaPFqGOXQYAy+8Q/mUxsgS+GcNIULovSSTyQDXWFDJ3n6uT
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HU6w0afI2j8AVw3kG+zm4ofHePC5AZSlfq4MSgDoFQA5G0d9sBGJgkoyXH3R?=
 =?us-ascii?Q?4IJQWklyhUBCJ1k3e7d/o6O6FjAANtn+QyDpxDPI/oAZa3zWov32YPCTwHaF?=
 =?us-ascii?Q?tSSfREaR2BWfUqqWruDNXRdGD5ciSKMdj3CLuw2HAyH2l0yquHmYQPyPjDj7?=
 =?us-ascii?Q?nV5DMNBBQSj/m0n4hcS2ZB55lIVyQ0ObEdXny9nckQ1QJsBqC41IyPnsJPE8?=
 =?us-ascii?Q?aY1sy+GKamDOypQxDGa26Vc5LVqItigBb77Cmq0x84Kvw4ObKcGTikFz/TRI?=
 =?us-ascii?Q?fbS1vXJMaI3+o46cVatv1i0vuxaKAd3GZPttIKw7sL0qOveI+XeV0f5S5NQ0?=
 =?us-ascii?Q?dZkThes5vvxsWr5NrLUxcyc0LIdIml5HW7aVFkXksRN/AzkMFIRF/05JVrnh?=
 =?us-ascii?Q?kjEZ0jf6L+62POzmsSlS/9/lEkRigNoEm8Kx7AsYtknmUiRrSzdkSPnx8J99?=
 =?us-ascii?Q?OZyK7Q5acoA7iYWlq2e+JiWeP+v7BeEyys4S/K0oorFFgbuN94sJUeGnGPlt?=
 =?us-ascii?Q?0b2AapWbdBgXG1FOrxQC1KchZAxg/SAi3lM7+LtOHyF+J2K3Q01dk+8M6mWg?=
 =?us-ascii?Q?NE7MQ3pEIpwOkjf83NytrX+GTPHhJWWzU7U8xqjFDTol3DSeME4SYCmdXpAq?=
 =?us-ascii?Q?2J6A+jJ2OlgV0VwaeQwqxG6By+5al3tln9YgB/spsTGU9buyMhoUryYshZed?=
 =?us-ascii?Q?KssJX/IV/Jn0FhiIPJ6xM97xn57ML4WHyYDDBoFL268gjKtyNYtUTdo4fUsg?=
 =?us-ascii?Q?pxNcVM1694XqVdhewkljTCp6VDBJv3BxeZ9yvXCt7fh0H1MbPaqkluYJCwzq?=
 =?us-ascii?Q?nyxg7L3Wh9EAMHnqd8gSG0ULClby2wSKYYqT/m/EL34exm+TfEfsH+X534XT?=
 =?us-ascii?Q?8seyaOCJaq7pdCWzH8sgnNETN3f9zn0O9X7NWS2ePi6eIjPJwONUjBVJCy4o?=
 =?us-ascii?Q?m0jeS8kbltVuaVKnKG5a4iG32elNUmvkCcFR60Q/xGXugdp+3FLIIIKUU0bx?=
 =?us-ascii?Q?cnHEA822k2igzuvmAIVsqgvd+IYG3r0Q5VclQc+CE5Fet81tqP2VWerJsfWP?=
 =?us-ascii?Q?wM3OrMYLPt1GKoJgx4BJcLy6LSBgv0cqALlF3CjZeuopJCB/Yn2BQ+NDILm1?=
 =?us-ascii?Q?I61Ce34iBFoYnADzfKcAucwLJ2KGMLxWVKpIFZ14suakkM5lb8z+BJIuRzsy?=
 =?us-ascii?Q?9POOXfoPovjfS3Ahi/agxHBFMquX6JRrQ3jPT/FDzZXRMpCMpS1h9sqDiYc?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f545f1-2dc1-4230-7326-08db7eb4fb53
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 06:39:58.6325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB5138
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
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

This patchset is made and tested on 6.4.0, includes 3 patches,

The 1st one adds necessary data structures for this feature
The 2nd one adds the specific msr operations between guest and host
The 3rd one are the one make this feature works.

Any comment is welcome.

Thanks
Jianchao

Wang Jianchao (3)
	KVM: x86: add msr register and data structure for lazy tscdeadline
	KVM: x86: exchange info about lazy_tscdeadline with msr
	KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write


 arch/x86/include/asm/kvm_host.h      |  10 ++++++++
 arch/x86/include/uapi/asm/kvm_para.h |   9 +++++++
 arch/x86/kernel/apic/apic.c          |  47 ++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/kvm.c                |  13 ++++++++++
 arch/x86/kvm/cpuid.c                 |   1 +
 arch/x86/kvm/lapic.c                 | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/lapic.h                 |   4 +++
 arch/x86/kvm/x86.c                   |  26 ++++++++++++++++++++
 8 files changed, 229 insertions(+), 9 deletions(-)
