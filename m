Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EC674AB6D
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 08:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjGGGzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 02:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGGGzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 02:55:11 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2036.outbound.protection.outlook.com [40.92.18.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478211FE4;
        Thu,  6 Jul 2023 23:55:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PimVkxb0U2SZBYOu8QqdU8uaWNLLqFu51v4U5UOrPaWpvI8+waGMH90h0zYU06ikasf0y4S7lXiVRIFAHVx0gRGcB/alRci78h3nkDAZvEp0vrhyICpIJHF26vLuzItG2Q6qPyzvK/OkuhPET9YQyChonuYS9W5V9EjIsBsQ9dWoMXI/Qi6eHMalutntQXZfEg9q6MybZ4gKSkcbfzHawKm5XRI/UxZnEBPHExvnyObyKzPYi1449kuzOhf+JOj5zzk8qfBSdesu02srGyf0nLPnkSg7LGJZU18KRgq2/Aqqvl5R3Fv4JE/crjc7NTUUIoNmiHlBIj6Oh83z/3yJhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxWpiCV8VUbYbVodEqP46s1JV17LbufJ9vImRtJHhmc=;
 b=Ytsl1opg4rEmUxd8oSFYSz5Wnjp05iTjI/llhfdTqY8LRp5UVsbr8xL/i2YI9F0wWK9lsyx1tl7p7G97J78aIhcO8nNO0MBrhAHuuS9wcHUUJFp5Ywv0aaBMM6UI3i/y0SAfENPF/yLMlTV5WQdoyxyUkL5NNR5OL9f7VvmAbrOF6bFeTCtz717k4R2srO35tDGFv/aDDrDOnORPyLLTbcFXvTPBSGIVyhuOUR7HWoPzFJSZk+nEkwcdTWHAcR1gNjkIM+zy+tIHGYPM7hH09hi4c/BGlHt3AwuZCnHeGVnD8seXbMowpzL/ZR4vWcJxaUZSCAgR9vuLYfj9Clv16g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxWpiCV8VUbYbVodEqP46s1JV17LbufJ9vImRtJHhmc=;
 b=VBOpGSe37d4lmb+rJPN8T6obD0toP0viNNhr7Vh7pIqPlmDDm0ZPWFCAIl7+3cPZ+XI2a6LKpSmoeWbyqRhlscnUz/ZQcO3tQ+6YC6eyhccUf82AF64Jv5YMjGySECpXD4YOmG7UTWy5PS4eOnpx2XVGmlLA/kD0hgFz6fBFvVXmM+FMokmuylODDBOYcLMqdxNfwTldEBgb42il/AmNP4k4pBF1RPdYRy3pZnyRZUy52295v8g8EjzK+5xKsjwk+cBu2t6HE3JVle0T34OaQp/3mOU0+E00gThph0Mlo4jim5QAjuXFziUKTigqxf3JdWIcGzvpv8Iek6uMotxDvg==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by MW4PR03MB6363.namprd03.prod.outlook.com (2603:10b6:303:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.24; Fri, 7 Jul
 2023 06:55:07 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671%4]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 06:55:07 +0000
Subject: Re: [RFC PATCH 0/3] KVM: x86: introduce pv feature lazy tscdeadline
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
References: <BYAPR03MB413341039F377D6161D0C7C5CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
Message-ID: <BYAPR03MB4133E6D18101F0D788475105CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
Date:   Fri, 7 Jul 2023 14:53:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <BYAPR03MB413341039F377D6161D0C7C5CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
Content-Type: multipart/mixed;
 boundary="------------55CAD26FA83D0286C7C60A7F"
Content-Language: en-US
X-TMN:  [OwSO3Rv5XMPVidTIt37TEKJGypQkEnH6Eye48g/OIYc=]
X-ClientProxiedBy: SG2PR04CA0212.apcprd04.prod.outlook.com
 (2603:1096:4:187::8) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <bb00459c-0d35-73c3-9206-4b3083839a87@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|MW4PR03MB6363:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b577255-2c17-4f81-7ff3-08db7eb71925
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y3ArECWzaLeqe+tdUok3smDoaLp6+KNWQQUAFLRAM150vy7c3hE5R1G1gF1GM6focsgQUCzh5g1vkRcxH5dn95uBxrK+EWqQ/jGStyl4l77j42MNo4ovgPCzK4IC1fg+815PnISlCcokWl2x6ZV37Z7gea2hAxl745lzvSJZAyvOTIKJC1+YV2+IWtK5EopXyIz0bDmZEYoAWp3hXWtn3iLyjGyIhe/4ygXC2XYcxA1sNnKsOeg3Dnl7z445Vulpb6f6katrISel4oLLCO8MT+5lr2eIBAhu/QSmlVIloYPRhgnXcFKxkoLsMdYsJz8LALpYfOT994JSVHdE1XQEgb1jhsbVM07eWtTEVS5X65gktvdfUrT1VKUL72uDcLkOjO0aLk2naJgzRxKDklq4HIM3hkc2Ing7fXLZWB6zXv2g/QnHI4yjQdWHq88Q8R2QAaYC2wDl0t22WDwS0C8dNeIF2IUBWVvs1bYr0M0on0oZS70l9keWzP0nSKO6lIy+LDxk7kLUci9LdPsbSp6Ong5kMlYr2viLAsu93g5kEPNX5XXpJKKmBLsNqgbbKs3qCf+cPHN57tx4LOAot1Vs6nsK2xuVfif0xgMPFmW973iYBVjdp18/3qSixZE5/wqNLdxnoan4wJoDZJqYHqji4q3+KCprC8Fhel+tqIMXV5XXkvtFz3QqGCp5XkFQo4D1LvwCAcJpzrgtZoHfebBhnZXg0q2CN2gvPhHB6FYQfJDp81iqqZKoLeG
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFSV1z1Lh78/KnBe+Gbds24y/gl7ZBTQKaZ8WXhmFgQdoVWlrYJh7kqWGDaQLCHE+nHWB2MsLQzJQ64P561ILvH0ESZsXJGQZWA2W4/Ar1JBcz/P4vLVgIhMEMiW0zIXyvG4TISeKrCwPqHV4r8KC6xsTfktov0wjMNHM+hrluk3DCKpupmVAfvsqiL3eb1eu0buEvEH5jJfUybsXc2oUXdHsAaTc75PrlrXfpwHMizbveUizmxAY7/YubMWEG7D6uP5/HsEUC7PX6n2+ixY/khPkTz+3axPsqJ35GJlZM2TXN7lVhGzO5wn39QNXafy0niTyimPG/mKWuYp01O+0/OtNWXaK37wDdYc97oHm3f6Ji/jtdsoy1KyNTvM7RgXe2BKtd5FKYyUskTiQcNSc5F+rkFUpTHGye6ToVTNtAYBvLFqs6Qh15gUrrS5n3fMdTkkkjF0WpgIcHK/s4kwzN+D85fvFOL6DJYS6wEjVnxsDxaMBHtPpdXYHpyvhfNIRFqiPdO2RWLppemEx73NE/bOzuc5EHQ1z10vse9kf2bUNz5eYPI3++5d2BDJkIzn
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjU1Y3RmWDVVN0ZqYUZvc3JNdlMzd1RpdTZPa3BmYTV0Nk5YNVNYTkpuMlBM?=
 =?utf-8?B?WHBDOWx0NUhIdnJMMitPOVNkVXd3N3BscHlhU00wMkgyRkFHb2VWaTRPczI5?=
 =?utf-8?B?YmtSNXlyQnZWSGJCRllENlVpdXlJMytvVTdndjFselhiaWVjSE5xZTh6d1k1?=
 =?utf-8?B?NzF0NXNMMG8rYmI5SEhlL2ZnRVQyMXhOZXlqUzBjRjdPRjdQV1pHU2d5VG94?=
 =?utf-8?B?RG5QckREYjZkczd3bjRVTklsWnBSS05xRE1RN3lmdngvTWJHNFlXQ1A5M0Rl?=
 =?utf-8?B?d0xDRGE2V3NBQ1c0enFBdTZmejcxd3EyYmhQd2tNQWV4RmllRTVkcGRBNFdi?=
 =?utf-8?B?T3JKem5odTNlVVBpd2VGTEVlZkFxU2JKU1FnczNydjF1Tk4xb3VETUdmczND?=
 =?utf-8?B?RDFpVVE2R29IQWdjUDVvdWdBakVtT1I1eXFDZkJYNkVXWjJkQXlkLzNGc2l5?=
 =?utf-8?B?cnh2ZHhwZ1VoTDFPUDlXdGEySEMzazVTdkRNZkVwekk3SFdIZDUvc1RCMEVC?=
 =?utf-8?B?NlA2d3ZCTUtpdnRrM2liSEZrS2JaRmJiQnJXcStUWDdZaEp4Umw0MXd2Y2dQ?=
 =?utf-8?B?bGppZzRrYUVuT2J4c2ZrQzFlTDBlVXdVQVN3VEZFRHBqR1MveXg3RXF5b0lw?=
 =?utf-8?B?Y2xybFpJT0Vmd2xoY0ZwYUNkNDEvNXVEY2x2ejZtN3dmY0dmdmtod1NhYjBi?=
 =?utf-8?B?TzB3SXkzVVBNT21ueFN1YzlaVXNVNzF3WSs1K1ROWkdEM3lObjVaczQ1M3Jh?=
 =?utf-8?B?NGQ3cnk2UnlBQW9GUXhxNW5oRGp1V1dRYjF6ejdPaHVQdCs0N0ZHMCtrbVpE?=
 =?utf-8?B?RFVSRDVuRnBvcS8xSnVHb0ExNDkycnZTRUxpc2k4NFdCNEd6M0o3OWhIRllM?=
 =?utf-8?B?S05yYzE2UjhaTHpZVC9JdEJQaDhPcE5VTm96LzRlNkYzelI1WU1RblN0TFBH?=
 =?utf-8?B?cks5aENjekVXVHFsZzNZZlJPQy80QWN6MENYaUJWaG9ZdU9kNTFKSFlzTUhI?=
 =?utf-8?B?dkxIRGJhaFUzWGVZVmZHL1ltdktVT1RIblhZdXdpaXRPK1JBVDdxbTBTcnpI?=
 =?utf-8?B?WnFNRkk3N3YxN3dySjRIYWZFTUh5RDZhYlkvSS9maCs3MkNSSC9uN2pnWHZp?=
 =?utf-8?B?b3d0ZldabUJ3d3IvTFFNRXRjSmczaElOMHByYWxPUEFkeVJqYnJCYWZ6TXd6?=
 =?utf-8?B?KzVHOHg4Wkw3T3N6bmJieTF3OHhybVduTGI2TzROTWtkZU5LRVFhQkF2RS9Q?=
 =?utf-8?B?ODFJQm9CdSs0YzFVWWdBa1BOdjI0NUlBc0RNNHRscUs0YkRRUmV3MnArUWFn?=
 =?utf-8?B?dzNGR01ocXFpc1dqZXZHbWhNYkpabEcvN2pTdG84T3VLTEtJc0dFM2ZQbWpD?=
 =?utf-8?B?TW5UVEIxd3RkUTArOFljVER0QlZ6OWl1bHo1aUluZ2dQTmwxa2NyT0hXTzdK?=
 =?utf-8?B?R1kvQlAxMncrMnN3ZTZoSDZUTTdyZmdpbm5KWGpsNXBEaDRkK1dyaHJXRXpa?=
 =?utf-8?B?N1RnQW9ERzN6YWJjUTRUVDA2Qm81dHZCVFZ1VjU0Y0JNWmpUS0x4aFFMOTls?=
 =?utf-8?B?TkF6SDV1TGRYV3BzVlVKQzdvbWcvMFI0Nm9PbHcwSmFBMFVyRWJ1NUxpMmoy?=
 =?utf-8?Q?qIen1Pqsq+d4Uf+xNfgct+1C3mXgW7Udh8dle6Jb2qmE=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b577255-2c17-4f81-7ff3-08db7eb71925
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 06:55:07.1485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR03MB6363
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--------------55CAD26FA83D0286C7C60A7F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit



On 2023.07.07 14:38, Wang Jianchao wrote:
> 
> Hi
> 
> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
> and host side handle it. However, a lot of the vm-exit is unnecessary
> because the timer is often over-written before it expires. 
> 
> v : write to msr of tsc deadline
> | : timer armed by tsc deadline
> 
>          v v v v v        | | | | |
> --------------------------------------->  Time
> 
> The timer armed by msr write is over-written before expires and the
> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
> 
>          v v v v v        |       |
> --------------------------------------->  Time
>                           '- arm -'
> 
> The 1st timer is responsible for arming the next timer. When the armed
> timer is expired, it will check pending and arm a new timer.
> 
> In the netperf test with TCP_RR on loopback, this lazy_tscdeadline can
> reduce vm-exit obviously.
> 
>                          Close               Open
> --------------------------------------------------------
> VM-Exit
>              sum         12617503            5815737
>             intr      0% 37023            0% 33002
>            cpuid      0% 1                0% 0
>             halt     19% 2503932         47% 2780683
>        msr-write     79% 10046340        51% 2966824
>            pause      0% 90               0% 84
>    ept-violation      0% 584              0% 336
>    ept-misconfig      0% 0                0% 2
> preemption-timer      0% 29518            0% 34800
> -------------------------------------------------------
> MSR-Write
>             sum          10046455            2966864
>         apic-icr     25% 2533498         93% 2781235
>     tsc-deadline     74% 7512945          6% 185629
> 

There has not been any patches on qemu side, I open this feature with a
debug patch as attachment. It is to make the test more convenient which
can open the feature w/o involving the qemu. If you want to test this
feature, it may help.

echo 1 > /proc/sys/kernel/apic_lazy_tsc_deadline

Since it is just for testing, the serializing is not so exact.
Please use it w/o any running guests ;)

Thanks
Jianchao

> This patchset is made and tested on 6.4.0, includes 3 patches,
> 
> The 1st one adds necessary data structures for this feature
> The 2nd one adds the specific msr operations between guest and host
> The 3rd one are the one make this feature works.
> 
> Any comment is welcome.
> 
> Thanks
> Jianchao
> 
> Wang Jianchao (3)
> 	KVM: x86: add msr register and data structure for lazy tscdeadline
> 	KVM: x86: exchange info about lazy_tscdeadline with msr
> 	KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
> 
> 
>  arch/x86/include/asm/kvm_host.h      |  10 ++++++++
>  arch/x86/include/uapi/asm/kvm_para.h |   9 +++++++
>  arch/x86/kernel/apic/apic.c          |  47 ++++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/kvm.c                |  13 ++++++++++
>  arch/x86/kvm/cpuid.c                 |   1 +
>  arch/x86/kvm/lapic.c                 | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  arch/x86/kvm/lapic.h                 |   4 +++
>  arch/x86/kvm/x86.c                   |  26 ++++++++++++++++++++
>  8 files changed, 229 insertions(+), 9 deletions(-)
> 

--------------55CAD26FA83D0286C7C60A7F
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-KVM-x86-open-pv-lazy-tscdeadline-forcily-w-o-modific.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-KVM-x86-open-pv-lazy-tscdeadline-forcily-w-o-modific.pa";
 filename*1="tch"

From 85b0ba7dc42be36f03ae3783d4e4b23cd96bbed8 Mon Sep 17 00:00:00 2001
From: Wang Jianchao <jianchwa@outlook.com>
Date: Fri, 7 Jul 2023 10:06:58 +0800
Subject: [PATCH 4/4] KVM: x86: open pv lazy tscdeadline forcily w/o
 modification in qemu

This is not part of the patchset, but just a debug patch to make
the test convenient. It can open the pv lazy tscdeadline w/o
involving the qemu.

echo 1 > /proc/sys/kernel/apic_lazy_tsc_deadline

Since it is just for testing, the serializing is not so exact.
Please use it w/o any running guests ;)

Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/kernel/apic/apic.c |  1 +
 arch/x86/kvm/cpuid.c        | 13 +++++++++++++
 kernel/sysctl.c             | 12 ++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0fe1215..e60aaa3 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -679,6 +679,7 @@ static void setup_APIC_timer(void)
 		if (kvm_para_available() &&
 		    kvm_para_has_feature(KVM_FEATURE_LAZY_TSCDEADLINE)) {
 			levt->set_next_event = kvm_lapic_next_deadline;
+			pr_info("%s: switch set_next_event to lazy tscdeadline version\n", __func__);
 		} else {
 			levt->set_next_event = lapic_next_deadline;
 		}
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5a12601..ee5a828 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -380,9 +380,12 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 }
 
+extern int sysctl_apic_lazy_tsc_deadline;
+
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
+	struct kvm_cpuid_entry2 *pve2;
 	int r;
 
 	__kvm_update_cpuid_runtime(vcpu, e2, nent);
@@ -423,6 +426,16 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 
 	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
 	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
+
+	if (sysctl_apic_lazy_tsc_deadline) {
+		pve2 = kvm_find_kvm_cpuid_features(vcpu);
+		if (pve2) {
+			pr_info("set lazy tscdeadline forcily\n");
+			pve2->eax |= 1 << KVM_FEATURE_LAZY_TSCDEADLINE;
+		} else {
+			pr_err("cannot open lazy tscdeadline forcily\n");
+		}
+	}
 	kvm_vcpu_after_set_cpuid(vcpu);
 
 	return 0;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index bfe53e8..f5f94dd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -137,6 +137,9 @@ int sysctl_legacy_va_layout;
 
 #endif /* CONFIG_SYSCTL */
 
+int sysctl_apic_lazy_tsc_deadline;
+EXPORT_SYMBOL_GPL(sysctl_apic_lazy_tsc_deadline);
+
 /*
  * /proc/sys support
  */
@@ -2055,6 +2058,15 @@ static struct ctl_table kern_table[] = {
 		.extra2		= SYSCTL_INT_MAX,
 	},
 #endif
+	{
+		.procname	= "apic_lazy_tsc_deadline",
+		.data		= &sysctl_apic_lazy_tsc_deadline,
+		.maxlen		= sizeof(sysctl_apic_lazy_tsc_deadline),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{ }
 };
 
-- 
2.7.4


--------------55CAD26FA83D0286C7C60A7F--
