Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329A67C65B3
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 08:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377455AbjJLGhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 02:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377412AbjJLGhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 02:37:04 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2165.outbound.protection.outlook.com [40.92.63.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6616DBA;
        Wed, 11 Oct 2023 23:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjLXMoWRzO2jnOkhFdrVYem5JOSy5ONHbyDArJ23XuajWbx8V6itjTECSClQRnXM4tDI/oZR233mGwPFyllpvDNPEZsPzi4vUneRGnH6XlKIhuJ848e95VEIjTGx9ZKC1stehBOEcToNHxMKcm5OoBPiWqTUImxafTunIEXt1XDujsHCZcOZClNgLa5nQ7Q0w64dkA4a6nGPpZpHZ6quOtvs0DlUH6z+OX74QoPbVTKweqq6oZ8J5tHUZEZ159PlIQjDMaGu5tzBH0rFbI66zoqz/XMvDtWYIpLjJlq6E4VXA8kCUP9HGeun1jc/cPB3MaW/8mz7qIVOcnvZ6iSz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/zi1k5Bt8i5xY1TJf1ulJEh9dawMRmg0DMn+K+bGYc=;
 b=MMcddldYOMi6TZovDNBfzT4SVGLzRrW27YECAIZpr+oGDx50ZoeWSWQA2ChVojIt1KC6h1FPFZkp+SMf9hPYlc+towHvBRKCX2xkT7h7Niznr2153s2eBOXz/iTcFK7/bV7+kU4EtJBfAoXHP4wpIzE142lGuLuYRA4zhx+q1HpdpfFdJIb4/orb4ommkmhXV7H3KqCJJM0s9wHx8x1tXS4m2P4tB0ZQePrJvdfHf4yTfx5CiSMAGnsrQkcKyaDHPvUgRkHpGSZY1rUT21bmC9FtpbjGPB3uJAha/Ev4GyBm/cAllqS1n/FbsIfbIRToRhjCOPDDwPe3OKV9a/V24g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/zi1k5Bt8i5xY1TJf1ulJEh9dawMRmg0DMn+K+bGYc=;
 b=I8GDdjVd0Dw4ijRqJ9j6Vo6K66hsw5jJAz3JJquufAAdnP6fOBx2aukPJD2rl1Gb1HuYnRviQOjfp8vXwRw/lvi+ziGQ+f0eCV8DGg83afYAZzC2H6DpKcSgVSKdWzKGEV2sW98fjbGYCbCuJYYBQsTrcTBrEdj9Yp6ErXi+SPpgHuOEvflCtGhTs8DJsy39eo0ZU6EymnK2WNMgQs59mLSQHCHplpPsSsjKBuY3LPFvXssJPWyt2tuI2Gs4+/p4VbXQi0St6YA/Htfbl9r5ZuyUr1atST2+KryJleg1LN93zZLwR+EnULwmc7LnePdgD8TXZjTKzkISIO0q7txCjA==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 ME0P282MB4566.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:226::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.41; Thu, 12 Oct 2023 06:36:55 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6863.043; Thu, 12 Oct 2023
 06:36:55 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     maz@kernel.org
Cc:     acme@kernel.org, adrian.hunter@intel.com,
        alexander.shishkin@linux.intel.com, i.pear@outlook.com,
        irogers@google.com, jolsa@kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, seanjc@google.com,
        x86@kernel.org
Subject: Re: [PATCH v2 0/5] perf: KVM: Enable callchains for guests
Date:   Thu, 12 Oct 2023 14:35:42 +0800
Message-ID: <SY4P282MB108434CA47F2C55E490A1C6B9DD3A@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <8734yhm7km.wl-maz@kernel.org>
References: <8734yhm7km.wl-maz@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [cpHoawMzPf0CDk2dl+apQEcio79YiLmg2sq/SHXyET6gzhgV1W3Wmw==]
X-ClientProxiedBy: SG2PR06CA0237.apcprd06.prod.outlook.com
 (2603:1096:4:ac::21) To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231012063542.13167-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|ME0P282MB4566:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d30b3c1-a455-4072-7769-08dbcaed9fe5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EnwI2d6YhylB4yVn9GiD8ne6Wq1WbWkRHv9Vn/JqujEx43bXRo+s3x5n/rCwHKx6hB43Dq7LY+G8l8G0JDLx928m0v2km0/BHUa44hnH/J1X0DeTCIEUe/6l0rzLepP73mkajOl9Vj8iSCMbX3XvR+9LBcbuJyzbjTlixMQQaE9jow3UtCNEEZ6UEY/vChSgT1AWVZLVoNjYuy6COzC9JuejxAK/iSYqZt0wcKFM45y3lx3yuH+L4nTC9bdB35CoXieuxkP22Jpr3AHfZ3vOk0V4LwUKysW3YUmSaPfOxdEMhWzVFNo76oPMifNshEed4OB/+hw809sXLCgVlaBvrgyfnzOmmxfedAcrLSp6L5O0+VYS87CKnVodD5i1fLzVLVXkhHAiBe2uRtKy5kkxLPJar0ww2gpGNFk7zLf2Z4uobvxxfl82hIwYLcTSM1NO0t+zYwB2L4m0zXV4YSKGBXjrq6EB2YuPS9W5atar6pryCThHcVNCbkHeE30qW0GHkUkQMnwSpyFNtDnUQSgXbrs1FGKGVCCOjAGqKml0VGjHDS0HXcH5zNvZTrtUOVcNv6m6PdGQVPa29vb0kJuTYD+XSVubG5CK8paXVz6pOP2yWEN+K7yLSzckySwwE3h3
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SZlwvVk9U/VxBRpNav8g8J9W6y4cCoQ7sMRQPNOjMivvAUrT6L1YQ2i/7Bee?=
 =?us-ascii?Q?MIlX2ZGNELi2l00p/LAlA1IkiC0JHuN6jsfXTwP/ZIOatOlDPqDsh/9URUyU?=
 =?us-ascii?Q?7jqAKecjQciu6XY2MQQxQe6nSJA/dBjfbAo8NPu8Cwguy7T7fCTCkWelFCf4?=
 =?us-ascii?Q?3Xcy0CH3DSFqhzziVeXZXkUfcnpEDM7ww8s5jUnuu2fYbRji4NFUUu5FFgvb?=
 =?us-ascii?Q?nk0vDAAuzWMVumneEv4SnhHnSrpMXgdkMlSAHjAfUi15MuaVr8cCWMR16sp0?=
 =?us-ascii?Q?emKhq6ln4xV65sUmjYnZeCYTb2G8f6EMZwwxRt5PMdHS8k2J0zonQ/eJFk9U?=
 =?us-ascii?Q?azX3WkokAZJVe5r26SEH8JgsCiiGGFwui0ZIk03JY7eNKWEN0qZEiJQdCxMZ?=
 =?us-ascii?Q?DumRX3cDnaAgBpsjhJJpWRMgEwrbu+VHvG0ZsdlHzji5C15WLS85u+PtFI5o?=
 =?us-ascii?Q?NeNJpVYPceipBMc4ru7RQ+5leVGjGZJXKYbkmJ08wGg9oLkQtwlei01Wwuvu?=
 =?us-ascii?Q?uv58VQsFDbYr8al3ytXWvPRTtoc6hsg16gtpFnog12afYnEnC6ZM4p57zDlq?=
 =?us-ascii?Q?wdCjmK2uygTrbCl+MYw/8joniyNJBMLRhotHVJpcsNfvk4uPHLsGrYOWdNxJ?=
 =?us-ascii?Q?P5hBzG+5tcPuhR2DQ6CCdIPaslWhhbhSJ0ZlA6UimqF4sSMyn8kw/whLwGUv?=
 =?us-ascii?Q?Y9vMxyLd2FuOJPue8f26uSdhBLGPe7+3Q/8K8Z4RMVX/Iy1GOjRr8lpv5kyP?=
 =?us-ascii?Q?JCIqxWSBtDCcDmyEOOOytHuxYtWMI+beyX28hpdvAAWKMlj8wMIGepwTXKNF?=
 =?us-ascii?Q?syX4Xc5muq0VU3I/pmdN4yv3/KBMaSOWZKd6vyL+oUPmYzFhTe3VAA+37K8Z?=
 =?us-ascii?Q?bS2SsU49ccxyc6WKy+w7BbcsmnycSNR6AE7KjQZ/I2zCCAncAU9H1Rn1bCS/?=
 =?us-ascii?Q?MuyxiNX+c5kGV4+nziP76PhrlgB9A2y6ER5xfxE2oeola2PLm9WVCa4H9iMd?=
 =?us-ascii?Q?vcQT1LOYrlVN6ILYhur/b2px+LulJMFCmrt13hGN4BnqsDfP3sBokBsXSyO9?=
 =?us-ascii?Q?KoyoPnyTXd99LHahg/b6m0etABIYuxiU/hVZvi7UNBEgMssXS+GuPYbr2C9z?=
 =?us-ascii?Q?CNqKr8teiwiKFk0rG5GHFF+ldPqIc7wnJ+sP8Wyi5qJJrZCaRTxNRgTR+WiA?=
 =?us-ascii?Q?VZrsbCgwwcvoBr7DfoWJpuQY+W/75Cu7ctvV+zFmnYFqM3nGMkfG3GK1NR9b?=
 =?us-ascii?Q?CSiNMgJBP5JexrDOKUdR?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d30b3c1-a455-4072-7769-08dbcaed9fe5
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2023 06:36:55.4181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME0P282MB4566
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Sun, 11 Oct 2023 16:45:17 +0000, Marc Zyngier wrote:
> > The event processing flow is as follows (shown as backtrace):
> >   #0 kvm_arch_vcpu_get_frame_pointer / kvm_arch_vcpu_read_virt (per arch)
> >   #1 kvm_guest_get_frame_pointer / kvm_guest_read_virt
> >      <callback function pointers in `struct perf_guest_info_callbacks`>
> >   #2 perf_guest_get_frame_pointer / perf_guest_read_virt
> >   #3 perf_callchain_guest
> >   #4 get_perf_callchain
> >   #5 perf_callchain
> >
> > Between #0 and #1 is the interface between KVM and the arch-specific
> > impl, while between #1 and #2 is the interface between Perf and KVM.
> > The 1st patch implements #0. The 2nd patch extends interfaces between #1
> > and #2, while the 3rd patch implements #1. The 4th patch implements #3
> > and modifies #4 #5. The last patch is for userspace utils.
> >
> > Since arm64 hasn't provided some foundational infrastructure (interface
> > for reading from a virtual address of guest), the arm64 implementation
> > is stubbed for now because it's a bit complex, and will be implemented
> > later.
> 
> I hope you realise that such an "interface" would be, by definition,
> fragile and very likely to break in a subtle way. The only existing
> case where we walk the guest's page tables is for NV, and even that is
> extremely fragile.
>

For walking the guest's page tables, yes, there're only very few
use cases. Most of them are used in nested virtualization and XEN.

> Given that, I really wonder why this needs to happen in the kernel.
> Userspace has all the required information to interrupt a vcpu and
> walk its current context, without any additional kernel support. What
> are the bits here that cannot be implemented anywhere else?
>

Thanks for pointing this out, I agree with your opinion.
Whether it's walking guest's contexts or performing an unwind,
user space can indeed accomplish these tasks.
The only reasons I see for implementing them in the kernel are performance
and the access to a broader range of PMU events.

Consider if I were to implement these functionalities in userspace:
I could have `perf kvm` periodically access the guest through the KVM API
to retrieve the necessary information. However, interrupting a VCPU
through the KVM API from user space might introduce higher latency
(not tested specifically), and the overhead of syscalls could also
limit the sampling frequency.

Additionally, it seems that user space can only interrupt the VCPU
at a certain frequency, without harnessing the richness of the PMU's
performance events. And if we incorporate the logic into the kernel,
`perf kvm` can bind to various PMU events and sample with a faster
performance in PMU interrupts.

So, it appears to be a tradeoff -- whether it's necessary to introduce
more complexity in the kernel to gain access to a broader range and more
precise performance data with less overhead. In my current use case,
I just require simple periodic sampling, which is sufficient for me,
so I'm open to both approaches.

> > Tianyi Liu (5):
> >   KVM: Add arch specific interfaces for sampling guest callchains
> >   perf kvm: Introduce guest interfaces for sampling callchains
> >   KVM: implement new perf interfaces
> >   perf kvm: Support sampling guest callchains
> >   perf tools: Support PERF_CONTEXT_GUEST_* flags
> >
> >  arch/arm64/kvm/arm.c                | 17 +++++++++
> 
> Given that there is more to KVM than just arm64 and x86, I suggest
> that you move the lack of support for this feature into the main KVM
> code.

Currently, sampling for KVM guests is only available for the guest's
instruction pointer, and even the support is limited, it is available
on only two architectures (x86 and arm64). This functionality relies on
a kernel configuration option called `CONFIG_GUEST_PERF_EVENTS`,
which will only be enabled on x86 and arm64.
Within the main KVM code, these interfaces are enclosed within
`#ifdef CONFIG_GUEST_PERF_EVENTS`. Do you think these are enough?

Best regards,
Tianyi Liu
