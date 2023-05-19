Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D680709F59
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 20:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjESSs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 14:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjESSsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 14:48:25 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021017.outbound.protection.outlook.com [52.101.62.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6104CF3;
        Fri, 19 May 2023 11:48:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UANkpDnVSZZNQMOleAkrOEmr1dfdfGHVAVp6itf0VsAEEMqxiLGj7sOpb5ocIh+vyN/esPq5SmZtWs+Qjoh/LZv5mYlpp5a4jcgGZXd+NS4N0DwP7r7oNZN0ta5qGpMFj5OHHyf7H53PIco35dDERWZ0xsOcZv6Cw46sUVNhpbvwmVu1HmUQth37t2QWgFv3RHoL8Bp+Hz0myX4uzo6Q8NDY6CbhS9LtsagFvuG4E3mrAU0WIP/IdHMDXROktL/r2H6arac2K8y6uYmjvXpm9X/zSqDzOjTZPf+a/RR+p0NoLwnGiCEakai2i0SecasVrOswUaFXbWLemvFW077JKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuA9oV2aPaHyo1atkeJyk8mbwVgSIglUdFC691brwc4=;
 b=VOBjYn+twyiOcN0OjlQz1ayBW9ZAXTS3Jtne0MTSx/EiQNhY21B+vP8E+EgKuPSKI3S221BLQCjZQ1D3nSTMABiWMuLbKdGvYF+EHG2AJ1ND9CYbx//mDeeINnUZEsTL0/KClbPj2ZgmIa0MZorZT9nAcs3XqpPAr+Eqxa9owSQKMhAugLYFbXnTJMOmn95kPmWJxU1a0mTRWbB3q6R9gYhiIRF0+JqbGEjw+u4iIl8+0smTIsljfq/tO4QNMa3Xxd1PJi95jg2KjkFZAQXdJgZ/MfOH+cdShymTb8oSN5jMtC3Ixr2CH6iHMJZ+p1yiFL0e22iOnawrRIj3EbjvbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuA9oV2aPaHyo1atkeJyk8mbwVgSIglUdFC691brwc4=;
 b=cC+1hHVZWHqSWsDEpKStSylDnqCLYJCN2g0XkY0THhTPGKnO4G51eBl8GiKABGlWOOiMryy/OlODy/Ccy6HG6Vct7s78H4KROwu/bGb2XRfJ3pDRh1QTS/Fig4LJu/yNn5kioOnmXPikUiZ4qs0a+B9fE7HAU6fkIOXVxx3kMQY=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by CO1PPF59DDB86B4.namprd21.prod.outlook.com (2603:10b6:30f:fff1:0:4:0:c)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.5; Fri, 19 May
 2023 18:48:21 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31%5]) with mapi id 15.20.6433.007; Fri, 19 May 2023
 18:48:21 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>
CC:     Mark Rutland <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "kernel@xen0n.name" <kernel@xen0n.name>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "longman@redhat.com" <longman@redhat.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "john.ogness@linutronix.de" <john.ogness@linutronix.de>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "bristot@redhat.com" <bristot@redhat.com>,
        "vschneid@redhat.com" <vschneid@redhat.com>,
        "jstultz@google.com" <jstultz@google.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH v2 00/13] local_clock() vs noinstr
Thread-Topic: [PATCH v2 00/13] local_clock() vs noinstr
Thread-Index: AQHZij3IV/oI1X52lEiQ97JQ1G8kIa9h7iJw
Date:   Fri, 19 May 2023 18:48:20 +0000
Message-ID: <BYAPR21MB16887E8B94335E4331FF439AD77CA@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230519102058.581557770@infradead.org>
In-Reply-To: <20230519102058.581557770@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=86956934-20fc-4e64-960d-927f86cb8830;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-19T18:39:56Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|CO1PPF59DDB86B4:EE_
x-ms-office365-filtering-correlation-id: e52c8618-69c5-4183-a096-08db58999e12
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lB2PNdJjxe3vAABKSSGPPlkVHpiWmKd/vsNFRTmyci9cVjoKA1b7QycEyJQvVCGqjgHo3nRqxPywdMZG2fFplULr1mZ/AAPBo6cxFllWFc+QGL+7G8QC1awKmdAorTNWf/hgOoe0Fk1lZuNYydW8TxEVaxNdOXBwlCTfieFOd4bT38V5Tkt1dpPPPi/IfaOQRPtOrgIesYK08+SJ7dqr9f+6nYcpsaBnIb0FTmh5i3qX4uRA/sjVk3BvuXgH0IsPFuHTzLYqSMn8KmhLM/y9HaEw+bd9cMCXvMgAAsZzbEA1iug1Or0GWCQPxM1Wrp/EYmF+o0hBPLFCaJsBF34vX37DRsIFSp356bnOU37sJQ2PZBNgOaZGpy3emwqdD1PFQJEE1d32eZksu+heylbfBbq+wyLH8xqx9F0yhOPfGb5ZRlbay6a9kKNSOm8KAY5ZxxGOX+E2drpCYBQ9327+K8+h2wFr++5hbFJPnPl1r1UyW5hugwy1fOJa5l9hTSA9gadHXb+5qtjOt6pTHpJKGnalb4/IjmwdaAhYeGGUk3/DB5W2ZBzs/UMRArh4sFH3aNVsXSqSWu3jCGgnHEZrYcOHWUdmj5ArQGNZFmwMzGHLoTXcGv007yWGS6E58ctrxeFO0osrMgn3eNTEKJjhbO/9+t02PhGFln088esy3lM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199021)(71200400001)(76116006)(66556008)(10290500003)(478600001)(86362001)(54906003)(786003)(316002)(66446008)(4326008)(66946007)(7696005)(66476007)(64756008)(110136005)(52536014)(8936002)(82950400001)(7416002)(7406005)(55016003)(38100700002)(38070700005)(5660300002)(41300700001)(2906002)(122000001)(8990500004)(33656002)(8676002)(82960400001)(6506007)(9686003)(83380400001)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7T2jFawu8LnV4egSakgssV2YFkBwDFrd8eihD5/kFgXEDneoeY47tUZETr9W?=
 =?us-ascii?Q?FjEhpf8EZKTD0Of5rHTKZKmFGbQJS6wB3IKH8PsEoQkuhcfuKp7AnMlRMrty?=
 =?us-ascii?Q?SjdVl4iHlUFef+TVNgUWKPDenLXzTpCxE8iNPHxSltwRtV+JJK26p0U5ZXEQ?=
 =?us-ascii?Q?shTVZjc1Q/HAC4iuxrRSoiSrD9Ws0Ytiy2jh+kdqJsMrX866XqTyQ0D7DS2c?=
 =?us-ascii?Q?PD7byjZiIY0PdSc8WPOEo3l8Xfw5LC4alvoy1mgv1cw/yj82fFJH3T/rVmAj?=
 =?us-ascii?Q?yCRjGimtiiVhLAJVYLpHxgd3fpZmEB2nUTN9qfoc529LZDN4prsXpTUZfLPm?=
 =?us-ascii?Q?F+0xGGdZLTqRUWhSXIgufzANVfp/nL5EfFsauo2IYtlUtNykeZySUETbpOrP?=
 =?us-ascii?Q?q1Whp1dZXpHPrq/QwmqnYHDT2vCXs5oqfZC/TKu/A6Mrxufah6DhyvvMWbAu?=
 =?us-ascii?Q?kIEptTMytZs1gB/Dkiz1A2HQZnSoZkPNXGO7WvA6Yc48EAjLEJunDvDPrfen?=
 =?us-ascii?Q?Idpf5a//f5NWnNrn0ZE37nsctAp2OuwN6WOfwphn2tmvv7qUtaoM8/8kQv1O?=
 =?us-ascii?Q?QPjQeS3RtSlr09s7UIEDAQT11zIVwitr14q3sEE84+mR3rhKEgVm31l357sR?=
 =?us-ascii?Q?hw6HU/yGWb6AHIEghwwAawAumnzZwTWmfehYxfkX91E8Z7LLZnv1WNV3zutX?=
 =?us-ascii?Q?v7wagmrZs7nm40MihiJPDcVbwPpi8HI+HqY+YONBQ9zR4vcNBOOmnQ9GTZmL?=
 =?us-ascii?Q?LyRCnaPoqKHJkEgrJnNAUvg0aPA+7yPddoCePqJrC0hpRbbHS5KkCyBn8cc7?=
 =?us-ascii?Q?/hdK+0s8lpT6IdvAaOzBwGSddcWvqJepz1ubiwALx4Lt0S1hATvBLxY+oFRk?=
 =?us-ascii?Q?e3cLs85fU47jWs/MV1xdPVx9mwH5jvopfTaPPO73cwyIA5anz/MNEktK96Q4?=
 =?us-ascii?Q?jlPvYXwTi12hlMJMMYN/XwwwQAGIACOwpxymrn1TF55ukeyLds1Y8BayCmSY?=
 =?us-ascii?Q?+lsJr/3Yn5jbjaa7FM00qyC+qaTxD/+OxlvfAmEh4eEOEbikASE3GfhXoGTS?=
 =?us-ascii?Q?YRxuwlNdKK6OTNCNkKSqECPArYpc4IXOVP+HzST9HAj70WUvjERa/xuKBI9D?=
 =?us-ascii?Q?c2tSacbQmNhmehOeA53AfIB1ITY0foKIzLgKnwzVd7NUD2oWM+AwPUQAtu3m?=
 =?us-ascii?Q?jqzV38yzeetKnEeo9/9kkus8Kv/IXBAg/m2n2LM4PbueqxYbWf4TV3WNrfys?=
 =?us-ascii?Q?rJ93hHgiBMBYouhpum+eWoxDkKbwGyVxaKZOezEj7olS2dNKQe4u59xCUoOO?=
 =?us-ascii?Q?KeAF9Xc4xqtln+zmxcLwSiutxHKMkYAViv1MtO1V2DUtDDFKzIDQs3v1nPkJ?=
 =?us-ascii?Q?0xfoGphcLB39Kx+WfO7E8urXlPafL5MAGvcfSulb+0ykbRxJUa9m2WdR/6z7?=
 =?us-ascii?Q?tlmlZ/iKxfrLFiGOoBD/0DeqgUyB4dT5hMYXQNlyakIm0zU7Zd9g+o6KxHK6?=
 =?us-ascii?Q?RVcCdUMtwbU1kcJo0cd5bMbT3TP8hlKekdhRvrLIKUWmhmeFge8CVFBMGmUg?=
 =?us-ascii?Q?/IqFQyWEnF9O8CpbzaSy0m/A1QzOoG+593GaIzVUmn1mxqsdipItbOIXTrlB?=
 =?us-ascii?Q?4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e52c8618-69c5-4183-a096-08db58999e12
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 18:48:20.7722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kB1+KDQN6kL950BelAL49/u33BuEIWKLrz/OpEDOdpfMVcOlQfhkdmCcQi0Y6DgAz3VsuA8y2hGOCEAXIl5gHkn8wKyX00CYdcz5OvO8ato=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PPF59DDB86B4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org> Sent: Friday, May 19, 2023 3:21=
 AM
>=20
> Hi All,
>=20
> latest version of the local_clock_noinstr() patches.
>=20
> Most of the changes are in Hyper-V and x86/vdso/gettimeofday; Michael has=
 been
> very helpful navigating the Hyper-V spec and fixing their sched_clock
> implementation.
>=20
> ---
>  arch/arm64/include/asm/arch_timer.h      |  8 +----
>  arch/arm64/include/asm/io.h              | 12 +++----
>  arch/loongarch/include/asm/loongarch.h   |  2 +-
>  arch/loongarch/kernel/time.c             |  6 ++--
>  arch/s390/include/asm/timex.h            | 13 ++++---
>  arch/s390/kernel/time.c                  |  5 +++
>  arch/x86/include/asm/mshyperv.h          |  5 +++
>  arch/x86/include/asm/vdso/gettimeofday.h | 41 ++++++++++++++++------
>  arch/x86/kernel/kvmclock.c               |  4 +--
>  arch/x86/kernel/tsc.c                    | 38 +++++++++++++++-----
>  arch/x86/kvm/x86.c                       |  7 ++--
>  arch/x86/xen/time.c                      |  3 +-
>  drivers/clocksource/arm_arch_timer.c     | 60 ++++++++++++++++++++++++--=
------
>  drivers/clocksource/hyperv_timer.c       | 44 ++++++++++++++---------
>  drivers/cpuidle/cpuidle.c                |  8 ++---
>  drivers/cpuidle/poll_state.c             |  4 +--
>  include/clocksource/hyperv_timer.h       | 24 +++++--------
>  include/linux/math64.h                   |  2 +-
>  include/linux/rbtree_latch.h             |  2 +-
>  include/linux/sched/clock.h              | 17 ++++++++-
>  include/linux/seqlock.h                  | 15 ++++----
>  kernel/printk/printk.c                   |  2 +-
>  kernel/sched/clock.c                     | 19 ++++++----
>  kernel/time/sched_clock.c                | 24 +++++++++----
>  kernel/time/timekeeping.c                |  4 +--
>  25 files changed, 242 insertions(+), 127 deletions(-)

Based on linux-next20230519, tested the full series in a Hyper-V
VM on x86/x64.   Did mainly a basic smoke test.  Sched clock
appears to work correctly.  Verified correct operation of the TSC page
clocksource and the MSR-based clocksource.  Verified that vDSO
gettimeofday() works with the Hyper-V TSC page clocksource and
is correctly disabled with the Hyper-V MSR-based clocksource.
Tested in a normal VM and in an "SEV-SNP with vTOM" VM.

Tested-by: Michael Kelley <mikelley@microsoft.com>  # Hyper-V
