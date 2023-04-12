Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E41F6DFD73
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 20:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjDLS0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 14:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDLS0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 14:26:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A20E65;
        Wed, 12 Apr 2023 11:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681323982; x=1712859982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CbJbKQR4Bt91iN9hPbSpM/8oNk9XkiF5Z4SMfqwZycs=;
  b=GqiMpgUp410hIefA6/IO6K9gWhlWdqzvtUCLv11LrLGNWroRhSL5/3pk
   7l3Al8IXKSS/t7yHoYbZ1ii3UQ8jAUOuQjfkFx2UV8TeSFNivPPeUSPGX
   hw8SkSueJ1xJM8IRr+azA5g1aN+KMptjkYIhkS2ksbbD1Ejm5wyDn8Ciz
   fevWSjf2/Kyn9FLMzh12LPeYM0OuoCrJCzFb1ClcqVrAV7uv4C5uslcrY
   KuW2TxynetCUp+MxQr59z/8MRx9h6ipV2Se6Pzkv/lxXlhUuEdN+Jeb97
   fJ95eaQSuhFi9hQ8XmA+UHc+o5unOt35aH6467+gm3rNkE5MHWQMG/JuJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="371835887"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="371835887"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 11:26:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="719499846"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="719499846"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 12 Apr 2023 11:26:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 11:26:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 11:26:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 11:26:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 11:26:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSTvox52Nd32+awadmfO3rRWKivnRF/yYDaWq5zwEnp7kRljM4M9MgQM16zqSR5MP2t0YpA954UgS0PWsyF4hZ01FvQJukX0waQYnF79PxRAavnKFWSBNb1UGv51NLoH+/M0WvsoStcl54NjriMyEwn7oqd1MHy1sG8E2j3Qf59JkzCoBHgEkpqRfA/sJNS/oDO5S0X0DsW+3Gl8+AHppJTSSf9BcKDSWQdp9XQpJkG2yNlyI59Wr0sNw4402jWcQ8EVTYNjflkMNE8fA0BL5MyeSel4x9nQmG1FJYT4OTNmuS/J44gMHJK5i/q5TKjVxiK5jFBVEy6h8KmTJE5RxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHPCH4Tv+YlVVFmfoApeZN6/B//hEorOfafMV7ApypU=;
 b=gOnmFDwHSZwApvd89033uFgZCV3OwIAuQeEXQBdYvrbIITYjLZyp1ExjSNv845cD1tOOHd+7YI7lYESgiMcZ1Fo6iOIgJxRbuiBPz2oEOjlO1qFlwdPV+3D4zoscGbSEP+OxwtltHJpceet8BQdtN1CsUZ8H48YbvR5Y2AERcCuyJbRQgiOrCO75EDEgnJrGz6SNKDlELpFodofh5nxxklD3jrBPM4N0cACDl2TilAkSCqt8+WskdPBZtgU5iTe8UapXVVBGxEQRQjgYgk2x0jMwXsirHnsMankoEOzNX95F6czNXo+azUnq60iOFSFEj3mvg31v+hb8oxTaq3oqtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH7PR11MB5817.namprd11.prod.outlook.com (2603:10b6:510:13a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 18:26:18 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%5]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 18:26:18 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to
 generate FRED stack frames
Thread-Topic: [PATCH v8 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to
 generate FRED stack frames
Thread-Index: AQHZa4iiYR92PWeRCEi6WbUcy97+Bq8lFcEAgALhuRA=
Date:   Wed, 12 Apr 2023 18:26:17 +0000
Message-ID: <SA1PR11MB6734897C0BC0FC7481333E29A89B9@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-34-xin3.li@intel.com> <ZDSEjhGV9D90J6Bx@google.com>
In-Reply-To: <ZDSEjhGV9D90J6Bx@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH7PR11MB5817:EE_
x-ms-office365-filtering-correlation-id: e5701316-e41a-4739-b772-08db3b83683a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tVxk3e6Nk0gyNIIkLweoyhg/Dm2+sPqzou/GdWGKPISUuDUv7vkJ/DLd82hyB45oHIxPlIowPUrWQ9HKYIKu5YXriq8QtOBFEVZoPA3a6Lx4CMTB8Dv8ppjcdVajK6/nchr05ToLeB0QnweRtmn1i0vlnNB3RQZFrvxTbCy3NJQD+prbsTVLELR5DDdFiIGMUz+j+fWPofFYHtuxPixZpuDHPwTG+dQZSh9YguoYb6i6cZhF5Q7iI1RlWoBAKeqEY0EKTVK0Vd96hD41YZYwx+Lyc6S6HR4mnuCAZ70z5myT1aqbabRfcH7S6PP2J0EtrApGtepA62W+BfzBJefS6RWFGS1LedTwduXiZ6LsjS6xum0c3UXsQ+n5Lw/So5AMD1Iuh+sD119NT/im0T64vx3DlDQjvPRc46o5TiCDst2zmWU5cIKbs1S9RZk1l5Pi+EvE4vjXpzSBw/3qos3RgKWKVT8lxw4YdV1FstlrykacnQC9FwLOQRTEYXXqJpRfCQmSWJpSoIEbNRcdNlGkc2ZTI2mezIYvp2llkHearHyJXNCXN+urI+AuqOpcggFdIgh8DhnRkotlMQ5Zo46VE2Zf+tqV+3+xrRzo4oYspCotp9hJOnQQe/ih7d7Y0Ayb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199021)(186003)(41300700001)(122000001)(4326008)(6916009)(66446008)(64756008)(55016003)(66476007)(66556008)(76116006)(86362001)(9686003)(66946007)(82960400001)(316002)(6506007)(54906003)(478600001)(26005)(71200400001)(5660300002)(7696005)(52536014)(83380400001)(33656002)(7416002)(38100700002)(38070700005)(2906002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+guFN0IGHLxJFWcoQcRl08oyKF6Rvg9RFVqq5SRwy/irhG88ldQzyQZ0So0B?=
 =?us-ascii?Q?ng7Ay8ZbqqZOBde+ws/puaNYXX2LrdcoDlT7E9b7GzVAC5ZVxsR8NywjECvo?=
 =?us-ascii?Q?ytWJzOsCe9pxFbnS9Rgk9gHgy59k8tT2Nz8u69pjHj4ErnPl0Qv5kB1hAYWC?=
 =?us-ascii?Q?W7Jp0hYdwhKG9RgfQBvj1tKT2cgOhJoMBq9Q6p00xE740aC954XF0LKsav/L?=
 =?us-ascii?Q?wRjf+5zd0pyppngxi/FYruW2A0uAsAV+O1/4fPI8vRA3ArxEPoHB0de2sypm?=
 =?us-ascii?Q?ANO1D0cvZBh5hCALM8a2MX6n0KOGxfJwhL5u/3mfiJVYx8pKnO1ZtBU7ubc+?=
 =?us-ascii?Q?QgFC4Vjz594wH0MgWopO8PrBLX2AlsSNoWRVl5eLyjDW1MDIRiLJr0waeTFR?=
 =?us-ascii?Q?wPGYc4s5BvDOYloeZ6TR1tIm2oXTRDd1EpkwqgwQuaDXafPD+dlj1GzGp0ak?=
 =?us-ascii?Q?XVt8jM0+3+e8IIjFK7TqSnXPeStB6bEIhVcZYP1IBl35jMn06iOitiL/MbSx?=
 =?us-ascii?Q?exPQ0B9CeBCJSZ0jejhupYmZMyEWoHqRT+dNfpHLeHS8JbkrLnzhDp44NGfI?=
 =?us-ascii?Q?A94NzpkdTh5fZZJA1kwt+kXNSSovnWjPLVnvGQ10NSxqDaKpknwiosWMLR0B?=
 =?us-ascii?Q?+wU4iUIaXETKln6TH9hjfwPpVrV1dwTFsWphzALl+HR0WhFIadpq8y4VHN0D?=
 =?us-ascii?Q?rxNrUMZNtWiPeRcbK2GPGFbCQtiT7X5A2dUrLSsmRWtMwZiaU20DhOuyVWUu?=
 =?us-ascii?Q?wHI0zfLJ1788bNEmOV0JHj2zWkoZy8MNGGV1PeXzudKC6O/2kZWJfPGb2aoE?=
 =?us-ascii?Q?phSZKulT/0uWV3n8F2Y/cBoFeJoyXSI/u9jN8qsFiN/Dy6ymezKRwnDp3vXj?=
 =?us-ascii?Q?ESRirHrq6mQ6sf+AsIlLd7zUwAqhCOOJ50djmEeSIccudaVl2hx3ZPb3nnW9?=
 =?us-ascii?Q?zEQnTnAPbsLFN6bHWC42gfuqkrbCIhAIXi5zJAP/bPE5k68TqrJPMusXwK04?=
 =?us-ascii?Q?rnPipERWOZbM10HiTsl4NV8JnL/oqVbceSXOCePHMpm4ct7wE3g3TwikGIo7?=
 =?us-ascii?Q?7Tf+q1UblP9WmWK7lLv/O7XjrBSm7AgYmbT0i0azFA9jvEhJ1qPuPxZqPwyq?=
 =?us-ascii?Q?pZ5tkOIQPANurA2kONaQ8SwLNzXfO9RP+LNOWacaK+8VhNqeB32rHfHDyzKl?=
 =?us-ascii?Q?uLaTLktktdiO8101FsrNJsP9xO62qhx8Q8plEUJvnm5n3cIt2j6Hj3YfFepc?=
 =?us-ascii?Q?7tTvKd0YW1TKwlq+8msWw1+Sc74MzQtRb1ejAz8EG5Q12ZI0zfve7db3QUFK?=
 =?us-ascii?Q?mSSL8Jp3VyK4LuD98joTftYElv1VvVyMtXDxtgMvKaFmDfj++fOkg1zQek2j?=
 =?us-ascii?Q?PF1UG69+dyzXj0z6W5DS7nqaaScGuIVmyaPFsBN3sDUbVYhTDaWJYhOlL3vT?=
 =?us-ascii?Q?ytrjs1l5gmiXFL61XudeQzZzNW/o+kYdKa3+qgFoJhWfuT5dwnMG97adF9Qb?=
 =?us-ascii?Q?0VeXNpk4JIBYUhBoTzNjsIdmZ7T7t1mgxys2DTcekFE4jaRWm/mfLvrkGGF6?=
 =?us-ascii?Q?4HtT3RrKG8C8M+nXWys=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5701316-e41a-4739-b772-08db3b83683a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 18:26:17.8136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U9Vpmh2gAwvaoHchzU0KfF6RX9wmXsBNwvLHR8ow7dEr0TEOAg5wjA1tjiPP2hlge2W1iiromkpgkMoxqK6YuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5817
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> And then this is equally gross.  Rather than funnel FRED+legacy into a si=
ngle
> function only to split them back out, just route FRED into its own asm su=
broutine.
> The common bits are basically the creation/destruction of the stack frame=
 and
> the CALL itself, i.e. the truly interesting bits are what's different.

I try to catch up with you but am still confused.

Because a FRED stack frame always contains an error code pushed after RIP,
the FRED entry code doesn't push any error code.

Thus I introduced a trampoline code, which is called to have the return
instruction address pushed first. Then the trampoline code pushes an error
code (0 for both IRQ and NMI) and jumps to fred_entrypoint_kernel() for NMI
handling or calls external_interrupt() for IRQ handling.

The return RIP is used to return from fred_entrypoint_kernel(), but not
external_interrupt().


> Pretty much all of the #ifdeffery goes away, the helpers just need #ifdef=
s to play
> nice with CONFIG_X86_FRED=3Dn.  E.g. something like the below as a starti=
ng point
> (it most definitely doesn't compile, and most definitely isn't 100% corre=
ct).
>=20
> ---
>  arch/x86/kvm/vmx/vmenter.S | 72
> ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c     | 19 ++++++++--
>  2 files changed, 88 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S inde=
x
> 631fd7da2bc3..a6929c78e038 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -2,12 +2,14 @@
>  #include <linux/linkage.h>
>  #include <asm/asm.h>
>  #include <asm/bitsperlong.h>
> +#include <asm/fred.h>
>  #include <asm/kvm_vcpu_regs.h>
>  #include <asm/nospec-branch.h>
>  #include <asm/percpu.h>
>  #include <asm/segment.h>
>  #include "kvm-asm-offsets.h"
>  #include "run_flags.h"
> +#include "../../entry/calling.h"
>=20
>  #define WORD_SIZE (BITS_PER_LONG / 8)
>=20
> @@ -31,6 +33,62 @@
>  #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
>  #endif
>=20
> +#ifdef CONFIG_X86_FRED
> +.macro VMX_DO_FRED_EVENT_IRQOFF call_target cs_val
> +	/*
> +	 * Unconditionally create a stack frame, getting the correct RSP on the
> +	 * stack (for x86-64) would take two instructions anyways, and RBP can
> +	 * be used to restore RSP to make objtool happy (see below).
> +	 */
> +	push %_ASM_BP
> +	mov %_ASM_SP, %_ASM_BP
> +
> +	/*
> +	 * Don't check the FRED stack level, the call stack leading to this
> +	 * helper is effectively constant and shallow (relatively speaking).
> +	 *
> +	 * Emulate the FRED-defined redzone and stack alignment (128 bytes and
> +	 * 64 bytes respectively).
> +	 */
> +	sub $(FRED_CONFIG_REDZONE_AMOUNT << 6), %rsp
> +	and $FRED_STACK_FRAME_RSP_MASK, %rsp
> +
> +	/*
> +	* A FRED stack frame has extra 16 bytes of information pushed at the
> +	* regular stack top compared to an IDT stack frame.
> +	*/
> +	push $0         /* Reserved by FRED, must be 0 */
> +	push $0         /* FRED event data, 0 for NMI and external interrupts *=
/
> +	shl $32, %rax
> +	orq $__KERNEL_DS | $FRED_64_BIT_MODE, %ax
> +	push %rax	/* Vector (from the "caller") and DS */
> +
> +	push %rbp
> +	pushf
> +	push \cs_val

We need to push the RIP of the next instruction here. Or are you suggesting
we don't need to care about it because it may not be used to return from th=
e
callee?

As mentioned above, the return RIP is used when returning from NMI handling=
.

Or I totally missed a key idea to build a FRED stack frame?

Thanks!
  Xin

> +	push $0 /* FRED error code, 0 for NMI and external interrupts */
> +	PUSH_REGS
> +
> +	/* Load @pt_regs */
> +	movq    %rsp, %_ASM_ARG1
> +
> +	call \call_target
> +
> +	POP_REGS
> +
> +	/*
> +	 * "Restore" RSP from RBP, even though IRET has already unwound RSP
> to
> +	 * the correct value.  objtool doesn't know the callee will IRET and,
> +	 * without the explicit restore, thinks the stack is getting walloped.
> +	 * Using an unwind hint is problematic due to x86-64's dynamic
> alignment.
> +	 */
> +	mov %_ASM_BP, %_ASM_SP
> +	pop %_ASM_BP
> +	RET
> +.endm
> +#endif
> +

