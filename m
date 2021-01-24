Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEC3301D6A
	for <lists+kvm@lfdr.de>; Sun, 24 Jan 2021 17:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbhAXQPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Jan 2021 11:15:47 -0500
Received: from mail-mw2nam10on2104.outbound.protection.outlook.com ([40.107.94.104]:13088
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbhAXQPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Jan 2021 11:15:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pnf29PYDBXAObPg12rWLOxVKkHLvFlUfB0mRangUDS1Tz49blsNR7CYK/jHmDHFwV/pAX7yRPNDNZFPur4OKwpVkcU4Th8FXISC+pP4r6GZ05Xz90WSXGkS+YvPSaRfObEVJWTTZVRNIrv1O0XOAo72RcBb2vuv10VfeFs33T5XFbRAwRefprJACMZP8xivVYcqobtlRZZnEqsbjH1evupnIHe4gav2BUheD6yNF3QHM9WdjBYdDj41ISU469+adkqqoDj9PiTgg5LiuG2wGULiB4vJ3pOcznVlqdfteY7NFi6dKdxbfoCfWuIJnN/Vf2fUgl1Nw8j1gt9vGfhquOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6kaM3w5vMJvVuegHx0ENVTzpA5s2k6LrcBEwVm5Mlo=;
 b=LQQ7JiBthGFimfKeFlbvYZ76b/VtYCOGBDChvzaqftW8GrfOfyspC4qT1zKoVaHU33oh2F/32TP2ubhLwSa+kcVqNz3PYTgaNyGHz/zISJaDjO+iahfeYjlgOYIvKDAgIQEfLltE0zT9pMeIk/AGW9MpXsoew3dOXZBqVKdi4giSmKDbpqFW8L8ZEeDEPp079MHFcqZWgkUifMSOp9u40QqWZEGpcFC7QUPnZMdT40jwiPw3kbACHeVswGCYDLx3HvG4cgNWWPbIcqFSfuUYSYIUAlfd17GzOMclKDlp2Y753byTqeBgMxCDweZUJk0cD2GG+Yb05xY13RhUy5bmaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6kaM3w5vMJvVuegHx0ENVTzpA5s2k6LrcBEwVm5Mlo=;
 b=ewGwE1S2YttbCB3WjnMELD7OWBTx2om/XXtatIQ8p91mNd1yxaWN09oG5WI2DatDm11NVoRUO8U/0P/VR5fzI14bkgOovsYMOes3W0dNzu4VFDTG3KCFm0akjlhzWPbXE3voXJFeVLZUNrjf0DDqO55vspHDddJmvmtoLyqVpzQ=
Received: from (2603:10b6:301:7c::11) by
 MWHPR21MB0766.namprd21.prod.outlook.com (2603:10b6:300:76::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.3; Sun, 24 Jan 2021 16:14:53 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9c8:94c9:faf1:17c2]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::9c8:94c9:faf1:17c2%9]) with mapi id 15.20.3825.003; Sun, 24 Jan 2021
 16:14:53 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Juergen Gross <jgross@suse.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        vkuznets <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: RE: [PATCH v4 07/15] x86/paravirt: switch time pvops functions to use
 static_call()
Thread-Topic: [PATCH v4 07/15] x86/paravirt: switch time pvops functions to
 use static_call()
Thread-Index: AQHW72lBoCJK4XcIc0e5K1+SYrbIiqo29YsA
Date:   Sun, 24 Jan 2021 16:14:52 +0000
Message-ID: <MWHPR21MB15930A0BC65D8A3F31C13F49D7BE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210120135555.32594-1-jgross@suse.com>
 <20210120135555.32594-8-jgross@suse.com>
In-Reply-To: <20210120135555.32594-8-jgross@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-24T16:14:50Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=819a5dc4-1861-402f-a4b0-8109384682ad;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [66.75.126.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: abac4818-1089-42f7-3a44-08d8c0832efa
x-ms-traffictypediagnostic: MWHPR21MB0766:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB076658EA4DDC06E93557023FD7BE9@MWHPR21MB0766.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1188+vCYRZjxXPC7Ti8SBtXV6yPsJ893MHnL7vTaiDZcKuDnC9u6ocOuPA27EpZ2OjuZ8r+PDsNHspT3Vzhe5AtGEXWBf3vrxhZ+p7RNa0gChnB3gjXB5p3PFkkwLsYhvCMBg2o5oDqwnr5gXb9bD/hAcSgcYyOnsQd5eTge45swpHxlHzEEOOCGmWxMKhj6QlFuKtfFBQu83gRc4+LoxIo9u/sR5swz7Wwa0EudacSuo9WSzv9R9tJTO0lmAT/MLOK2yQLfZomYSKbqdUYfyK8mX+5lujqBItELY7B+8pZ71Cu5kwdxr0JkYwh3rexpRjf6kK0+qer97CuE0dnaw+TTcMnUdBD/uq4vRrAElXiLO9G9RelNlwBllm0KUFNfIF/vhSLpfgej8tpLLKNVKK1gyKoNfMcUXBifKbOeoPLxLBIc6LtlJdQA5h5/tTUuwNlKFrRBkN4GMKmE0wXyghMc9yopH78J39DGV6ypnrWz+NiScz7vtadlGWh1Ghw1lFdP4CaH+9QIIJbCniaSrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(8676002)(8936002)(10290500003)(86362001)(83380400001)(76116006)(66476007)(66946007)(66556008)(64756008)(316002)(66446008)(7696005)(54906003)(26005)(186003)(8990500004)(5660300002)(4326008)(110136005)(71200400001)(7416002)(9686003)(6506007)(52536014)(2906002)(82950400001)(55016002)(82960400001)(33656002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?kz/zFCJOu4H9XEpVGhuyuo467KMOSNWslf305XmQ4FJ/tpNt32FQSs1zJa1D?=
 =?us-ascii?Q?5MysFF/ynK4NaO5eusgIi/dJFaNlPd0z2xya1bZLlAB/Cx9V2NvjB+Ch7ntZ?=
 =?us-ascii?Q?O+Yc8B3I0Ga9hzcpTeAhgb9yxma1ye/GLP2VXKLijH6q8o/1/NV58jPVYVyS?=
 =?us-ascii?Q?kpErNEN+LUp0xrpujwkG84QSr1SAsuRB94BKjAycIFfXV0qzbnE0v5hBrDMT?=
 =?us-ascii?Q?vNXQa1v8YuXasMypTjNponwsuttc7H0ToK8c0JOGDXXNlTW+M32UhmtuO39L?=
 =?us-ascii?Q?AUBtCBZe1DnZednan8tJ8Kbp1lpvMSiE5AGQONkeBDM122AlMuROJSZH2yZ2?=
 =?us-ascii?Q?GS0+kZIyQCkF8sZTJW1CH/69JZtVJeSQzLjP3fnORPeh3zi3ZFUmAxz68+V/?=
 =?us-ascii?Q?z4UrsxyPcRiUiY06QyLy5JV8nX+fmGcDeA7htgKlLE6waXwP4N8tXEidg/9L?=
 =?us-ascii?Q?vz6LGingVD9yvswJ+6Gmpx0VlS+uP41DvBUofGwTxpIJOza/kQIPqyf48DWb?=
 =?us-ascii?Q?5UFNFdYPFFcCA+FymkZA4McibR51GMnsDuMkA9kkVZPcEshdQOiCPxw95RDG?=
 =?us-ascii?Q?jUVz5zKXwCRWXNzza7idtVzWta8tVKSDWQmnv/rJDPyYdrn5iR2TpJsOhNl0?=
 =?us-ascii?Q?qQRWC55jsWZXIScyb3fylHJqAdeukLQ3EfIwpYBTPs8CfrfRe8YtMBeDNEN0?=
 =?us-ascii?Q?Hkh2XzSafosFtxk8y2yoZS11vIMuOOEMoy6sqDBQJWNGoIyt5Oy5yWJVzoIb?=
 =?us-ascii?Q?1T5yWhduBWAxYdsoOCkyYMDjMiPLCj3EtPdMsxezJII1GNesyk+9Arx1g4sP?=
 =?us-ascii?Q?d7qeWmgz9LglUb/PcUG8v3SrCW7LZpUZwSLRwrbee8LsSwHHT4hwAmqvDN4I?=
 =?us-ascii?Q?B+5F1q8V5ZiEkdKP022dPwBLWMnXt/dKQ912VwhIAiWIzwELwVahwvYvqQF9?=
 =?us-ascii?Q?EcZFJn8cl/2AmZkGBbF6aPSxjoC5wmNBSJ/hEyfrFZ3pwdO3X1SFeeTuLlOG?=
 =?us-ascii?Q?F9WJl3RxRR49m3yBbf3Ig4KH4Jd68Bm85cthOOCbUiy4j4Soinn9E5WRloKJ?=
 =?us-ascii?Q?LddEMjJK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abac4818-1089-42f7-3a44-08d8c0832efa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 16:14:52.8508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xztFFZkAgufhIpsxNn9jfAwjKZDnihx8Hd1SovgteFrbj6RTL0YsgqffhEus7e7DkQPdHpJmj/Is8hNS/YABtAQMvY5JCgJVygxYlz+2mIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0766
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Juergen Gross <jgross@suse.com> Sent: Wednesday, January 20, 2021 5:5=
6 AM
>=20
> The time pvops functions are the only ones left which might be
> used in 32-bit mode and which return a 64-bit value.
>=20
> Switch them to use the static_call() mechanism instead of pvops, as
> this allows quite some simplification of the pvops implementation.
>=20
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> V4:
> - drop paravirt_time.h again
> - don't move Hyper-V code (Michael Kelley)
> ---
>  arch/x86/Kconfig                      |  1 +
>  arch/x86/include/asm/mshyperv.h       |  2 +-
>  arch/x86/include/asm/paravirt.h       | 17 ++++++++++++++---
>  arch/x86/include/asm/paravirt_types.h |  6 ------
>  arch/x86/kernel/cpu/vmware.c          |  5 +++--
>  arch/x86/kernel/kvm.c                 |  2 +-
>  arch/x86/kernel/kvmclock.c            |  2 +-
>  arch/x86/kernel/paravirt.c            | 16 ++++++++++++----
>  arch/x86/kernel/tsc.c                 |  2 +-
>  arch/x86/xen/time.c                   | 11 ++++-------
>  drivers/clocksource/hyperv_timer.c    |  5 +++--
>  drivers/xen/time.c                    |  2 +-
>  12 files changed, 42 insertions(+), 29 deletions(-)
>=20

[snip]

> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyp=
erv.h
> index 30f76b966857..b4ee331d29a7 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -63,7 +63,7 @@ typedef int (*hyperv_fill_flush_list_func)(
>  static __always_inline void hv_setup_sched_clock(void *sched_clock)
>  {
>  #ifdef CONFIG_PARAVIRT
> -	pv_ops.time.sched_clock =3D sched_clock;
> +	paravirt_set_sched_clock(sched_clock);
>  #endif
>  }
>=20

This looks fine.

[snip]

> diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyp=
erv_timer.c
> index ba04cb381cd3..bf3bf20bc6bd 100644
> --- a/drivers/clocksource/hyperv_timer.c
> +++ b/drivers/clocksource/hyperv_timer.c
> @@ -18,6 +18,7 @@
>  #include <linux/sched_clock.h>
>  #include <linux/mm.h>
>  #include <linux/cpuhotplug.h>
> +#include <linux/static_call.h>
>  #include <clocksource/hyperv_timer.h>
>  #include <asm/hyperv-tlfs.h>
>  #include <asm/mshyperv.h>
> @@ -445,7 +446,7 @@ static bool __init hv_init_tsc_clocksource(void)
>  	clocksource_register_hz(&hyperv_cs_tsc, NSEC_PER_SEC/100);
>=20
>  	hv_sched_clock_offset =3D hv_read_reference_counter();
> -	hv_setup_sched_clock(read_hv_sched_clock_tsc);
> +	paravirt_set_sched_clock(read_hv_sched_clock_tsc);
>=20
>  	return true;
>  }
> @@ -470,6 +471,6 @@ void __init hv_init_clocksource(void)
>  	clocksource_register_hz(&hyperv_cs_msr, NSEC_PER_SEC/100);
>=20
>  	hv_sched_clock_offset =3D hv_read_reference_counter();
> -	hv_setup_sched_clock(read_hv_sched_clock_msr);
> +	static_call_update(pv_sched_clock, read_hv_sched_clock_msr);
>  }
>  EXPORT_SYMBOL_GPL(hv_init_clocksource);

The changes to hyperv_timer.c aren't needed and shouldn't be
there, so as to preserve hyperv_timer.c as architecture neutral.  With
your update to hv_setup_sched_clock() in mshyperv.h, the original
code works correctly.  While there are two call sites for
hv_setup_sched_clock(), only one is called.  And once the sched clock
function is set, it is never changed or overridden.

Michael
