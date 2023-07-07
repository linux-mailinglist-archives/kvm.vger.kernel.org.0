Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D8B74AB01
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 08:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjGGGT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 02:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGGGT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 02:19:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2058.outbound.protection.outlook.com [40.92.18.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D11010F7;
        Thu,  6 Jul 2023 23:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emNK5+QT/elQNfOSakmsFHwidTLRgV2hSQ8kPGsq0YSiRoRX39kMJi5r8gkppq8mGiTyiFD32UpEyK0FtCNn/UvV67aFKyxrR0pB3w+bK+Mlm2Fl8Cf1Nt03EhWVZ0U2Pns5gTmRjpqWKjHuJzEV/qURrUZvuNLnVwV1q+K5NevrUq+5mEWmKn/9VYTFbOQZdbZApFdRHlRf9sV0Ync4cyscUm4T5X9YCDuIDPPpOUnkey0iBTOgwW17wzazeKPp4h979CDkogrAKw+f4bWEDg4TkVtxVfkaKem67HR3lZ1eaFlRMxXZwIS9/ue4l/mbMaT2fgvfcxggVQYto0R8FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LT9P6s9zwLrdSUAWkaaS5qw2HWU7TUcwdZg786Kp9yE=;
 b=QtocBPLo46fdORpcYapApbWczlgDUo0bfV+xI/vmk56n5pnfcm2AbVf8p+EgDjvFTQUYXlFO0wZ6aos1XSrQbw8crxb1kdP1VfGFbJC/+NGo0L6x0wA0GngefUDVhdD8ssxHaEPSLHMqfRmlS52cTGiEShaP0x6S8ZDwfE1ZGoNR3ocNrtAPhUx4+Mo8tYudK36V9ZPZwB3VaqnWF9ZjwZBdh2Z94kYHlZZs33w3p9AUZms2fqhusf/PkkuCJMIQkcahidy9ojmFVql5O8HF3GwmShSJ153BPeyLT95EzwScQ7seT/4T4NwvWs4weQ1qf50ZElGAxJ3UHvxrg+Eiug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LT9P6s9zwLrdSUAWkaaS5qw2HWU7TUcwdZg786Kp9yE=;
 b=KcyKwB4vJXj0kp1PxvseF5QE7/lCwRiZSA1VKs+VV9rJLEXe56noO5ampJadAM0EdPLUd7DNn5BLeWe41rS9rGN7bemf9g7T1Z6OUgffvair2SbagExC8OU+5gtOi878RBTNad9s294Sn9D2VRn9IFsskg9M/EjY931x6e/k9liXctEDcA7sE+UaEiQd7+aivVkRqZIPAuzUtS2iapKFg0p4n0NyWk00f5+lavWzRC6M/1+8Zc2Mttr2cqAwFKeV2CqO1SEFwJ2+kfO0EVbCffUHjfy7mvdqQOGs+Qp5n8NjCTGRDrbrNc/wJRm1R9nZ/vSsBbFkpgQABpSWVrcNtA==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by BY5PR03MB5201.namprd03.prod.outlook.com (2603:10b6:a03:221::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.24; Fri, 7 Jul
 2023 06:19:22 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671%4]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 06:19:22 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC 0/3] KVM: x86: introduce pv feature lazy tscdeadline
Date:   Fri,  7 Jul 2023 14:17:58 +0800
Message-ID: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-TMN:  [7TmDqB38EMK50384RSKeEPLu3yceHSC+usNKG67c59s=]
X-ClientProxiedBy: TYCP286CA0131.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b6::13) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1688710681-22896-1-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|BY5PR03MB5201:EE_
X-MS-Office365-Filtering-Correlation-Id: f004cce8-7c2a-4435-0b22-08db7eb21abb
X-MS-Exchange-SLBlob-MailProps: AZnQBsB9XmqH3kRfXJefTp/U8AtyfwZL9p+77ELxSitshBlJg2k+K5Tcd6OTK2vBg5MH8Uh+g7oK2pR+Ng4Mexk5RQFBw/aeR76qo+OfBP5jYremHgTy6Gbm4fECN4PF4CG+/plsbZVYBsOrkAID6H7ttC/EHi/DUQmQDkAnrPiULI27fQ5UDDHZT6i5wugcNo8njVx468SrAvgnHwf6fPpUTETsNBvFW3z0lHFTcgN4rHlE8E9pe/dJk+RRXCzYqeDvdyvzr6GbRjh8uAv29m2xkObRP56GS5Hk2cfdn/4KLFAUMcJajIPceC5RgaY0Z374r51BFGDYuRCYlCAJeBdwfsQ7z6k94nQ6qB9m09nKqZXl5al/oae17/oEsu3S782KVuBpqqqyO94SpiHq9f0/3q8pupw5bzszyy7dj/FBa+KQAfUHF5bii6h7Q7i8+xv3T5VFH+Yf3lIQFTbh294vuF6ArLuuzoOAWTIGja8IMgqLLElv3cIv7KLS+4ayDmFMEqbap7FPIVF64OxxI4tj0JYKDheSwFLK78Nh3pe3KB0ch0GLo/8LsLb9FFGbCnZgiO5i/XLg8TV8Eof6PVfP7WM0w/2dRnH5o1T+Q4t1yaqZKLvKih+6kNm/HI44Ves62/bcGvaJoIMi3NELGzHSk+RkdrCUzRAE/vn3r9eL4ibSra6zfcvSg+ZPmYymOiIuKlK2GOZ26Cn9Pm9Xt1FSVGfPArtW7TnghBpbudp3HOoJNSji8cNzcaSrZ2O9IDlBcwOCI1o=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2RlPq0kHv77H4DS6I6XWXlQ89CKZuOVSQKMS4DTmcnNkLsjL8HAFTodpn+PhbjiOxtIw/FElyYpK9jPQxokR/LYvP8r9kfQTtpR/xog96rOebhTWRWcGHBz0BOIzyK+qvt+4qRtnI6w+OBFT1GcW9GGy3GO2jCgWjcfpuQBZLEbkf3kTeMeJF0JiQSqp9BabzTsbhoybJ9ZnLH4YlQzPM4qhAvCgctZrkLb/X2xtfO6vmGP7EdzLYcg1vZ4L+HStgw34QxWqmiGXx5wt//a6Hs6T4WiZeJfYBz2971iJ03bJfCWV5H2cGH6xh0+7jIrjwKnuIH8s0y7pGXeLxcnZV6wNQ39Em7KWPQtHuK4LeNbvbuDWSXgxrGzb1HZNfezAckFpPFrMtaiMfK/RHWqtCX7OZe4TuY+J4rCh2xicHCSxmdg/OH877eVfFh2F3v10uFxocLnNPC9wPiErD90mlkLpMk9dbVYeDIDbaKhRXE+mkI2gzdLMHjLex/H2KV3SNY/oF2KArPg4IW8BqautEHirbheSZqQGVkOJ3X1tRa8JjgLfcupSUXcOK5cS3AI8
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yXxD7jpupLNOvYK2zXcnTuGQEPtdPzlsZd/ryADLi+mAPaEubHfwVkfa2t90?=
 =?us-ascii?Q?weaoZCqCyVXpPWT3fm8UHoI47/jgXq9KMukBPlyZsc6LCoMfQijsjCpGnEBn?=
 =?us-ascii?Q?QnmWzuc/BmYCGQOar91D9e2DiPMOeBwFCHz78LEFDLS4tk8YqkOvQ4Wopjr2?=
 =?us-ascii?Q?fQQX27OfGnbkb6uWqdZvP2oyI56v4EZA0sI9+v9yiQFu+SKKRvbVo0qahDuo?=
 =?us-ascii?Q?VtfAEewxvmEjCHI0BBOYyIxoe2DMX3hxfyHrG9PvClwhFFVnXuLanoM8NcB3?=
 =?us-ascii?Q?5p4aT3C5W/XPDnkCzYnQUeLA2iEjPxG916+jCMTq7RGvdqfd9cgDDgzB3klZ?=
 =?us-ascii?Q?0YryHgFxeRd5Tevy/k2I+5J1kjXUHP/D4J4mZtLTiv4OrCdCkCIZK9LNts/x?=
 =?us-ascii?Q?hk6YCLbPH2LGpgs9gwNprrGOfEC3Y8qnj7K/cxkRXNVnCO7whcVvOq5ZmDad?=
 =?us-ascii?Q?gEOx+XUalHvTndu4wJzRhM2kPVUQ1ixYYsormEDYt45tkiKUcwcZu87XOTvP?=
 =?us-ascii?Q?BxSoE4iMBGbIuE+Nn65YZHIXFqEhbDEwIJI6tRlSaUvMUATWRONe48voLSYo?=
 =?us-ascii?Q?9a79mLgQUVASbBwsRZi66p77Ya4Kr4CKSuwsVwXry+FZ4ggnVqBQxMFX9+yL?=
 =?us-ascii?Q?CFIWxbajy8RQmd93ccvIiOEpBcKa8znjMvcR0aUqfpkCsL/IcJ8dS64Jj2Vl?=
 =?us-ascii?Q?FxKgHIJVlhB5/hl3ifxPWXX0A5Qdche/2RWUJPGfBhTes3wrPk6VLXU00iHR?=
 =?us-ascii?Q?5AHxvv8Hn5Lo+5+k+xDNib6YlK/J5sDzYQb7aTsaItf+rqfP4kImY2JRM0MM?=
 =?us-ascii?Q?qh5ziJ3ZZdqeMdtW7TVcwr5zCMQk57+fzds5jEXLvKTkfrLB4jPUj7xSeQ73?=
 =?us-ascii?Q?BpyFHnRmFaKqPspLRbpMKy0/pfOTR2gl8rZt5B1rSayAtb1klypQLrlHhJS2?=
 =?us-ascii?Q?1xdHrZu5CpwHX2ni05Nn/oKcxjqlcKpvsNUXCVj5dhHaMMAzuswGjy0/Vg3D?=
 =?us-ascii?Q?DkL3hAjSy0JvyV+HANLn2zt5CvTYLm+Fv9pwGzqr9rgSpy5po2H65A99JMWE?=
 =?us-ascii?Q?ZrsM11tBN5ioIcS8UBKLP+P9f5l24wQXn6Z0ShUd+XfQLSAqKfBO5svAq0jG?=
 =?us-ascii?Q?3isJGJqv1PUdo3knOZ6ByEAAHPnyXwEp712/Byd4SM6KEHxmWIQpHT3HRG8w?=
 =?us-ascii?Q?fY2UspcRKUegYOh89w364YgJBK3t7O7d2kbg0wHFTE2dy3UuSojWDCsRkyo?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f004cce8-7c2a-4435-0b22-08db7eb21abb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 06:19:22.3165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5201
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
