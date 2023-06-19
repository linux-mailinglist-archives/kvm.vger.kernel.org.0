Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E7A734CF6
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjFSIDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjFSICb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:02:31 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDB7E7D;
        Mon, 19 Jun 2023 01:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687161660; x=1718697660;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TROV0MM38z3rxl+L0dwzQrmX1LWnJRC6GkgxtqMaJQM=;
  b=AASYIycVR81dc1a4An9LmEAGR6tMc2Hgcx3dtHErEcMZfn27DTMGRf2b
   Iv0Y0xa8LRUmt2llc/q+Gr0Q2DS1W7vUrn/VwEMvQNNANRjNQHKOVmNhF
   D4Y/D7ZC5PK7QpNxgRgTuP568dbIKyIqJmaOo3vLXBN+NvcqqauB+Cp3O
   4j6YMwYhsf1jSBtAMnsE5to/vMjk9mmnrzJUcR6gDqYnOUpzcTuzfxKki
   +qZxjIx/yuFWflRqBEMuab4y8QOW8pGMp9Ff0QmYbUpT2SaTQojemcuuJ
   rnDp+gZ5IiBWUGTTsgCgoIbGg/Y+19+/h+aqjDMtmhfqFDrCIYIIbnfql
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="358444844"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="358444844"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 01:00:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="960348486"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="960348486"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jun 2023 01:00:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 01:00:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 01:00:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 01:00:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 01:00:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UY9DsDVg547cjUBCQccG288V+lpzhfajCuQxmWzjX2YO8yjaM2rS66pjes0uWRXAuae3/UijHbw52p2OjNcxWhAXeE0wkoLTv5/KnZC+OsmyfYakkzZIErPBby6gOOPPADYXK6F6Cqkq/HIpCdBOpkipUwXjSZ/K90AN8+A7HX+K4V5JNWLshVimSZF7SIk1X/e9FxfMNpoDR9bbobuH3pkU72CFLRL95aQwKjPulAEbThkqRjZGvrpwHvoodv1y/qubOuAYF1h9Mm+rl1+PZtAwbfdtSW0YGwHWuNVSO0Wqcvaai0YlAOLKCFg+7APF2TO1xxSFKWOjHD80xLob4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cy1gqhNhBzJX2O2QfZIVAc1QPWUfay74WzOa9xO6M1E=;
 b=Xzv6lS7fUtPOfJ9VZtTpsI1GElZDVRMX+KvarTEJqnn/+52ZVjOJl+nzgpZovt1e25HpTjU9Tl5sg0+tpN365ai4HQDxwrrDO+pLyxasiFJmuIuX9H/yXsOOjc4QDK1dBvkquA6wROQd05bjXr8omazFQEMXBqolw3uARWs6bF38+kE7mLYTIOlfgWfU4tx7cwGC6yd5n/MVXq+tjkJSl1phafesUlgKLi5CadbqGW0LNw+nPSyWC2QLfLhGmiL1DIQahgEFX/dFHRDaWqr0/d2afXBffkIPC4w0gp/1Hat4/JBE/0gvVnXKIyyfvDOFpyGQqShKSk+s1vLbR0ArSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DS7PR11MB6246.namprd11.prod.outlook.com (2603:10b6:8:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 08:00:35 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc%7]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 08:00:35 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Topic: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Thread-Index: AQHZa4g62amPAW2/oE6/VfNOqnc7za9542QAgALl3wCAAACfgIABxIeAgBOgaQA=
Date:   Mon, 19 Jun 2023 08:00:34 +0000
Message-ID: <SA1PR11MB67344FE6C8A83810D0CAF175A85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com> <87leh08e1h.ffs@tglx>
 <87edmp6doh.ffs@tglx> <70ef07f1-e3b7-7c4e-01ac-11f159a87a6b@zytor.com>
 <877csgl5eo.ffs@tglx>
In-Reply-To: <877csgl5eo.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DS7PR11MB6246:EE_
x-ms-office365-filtering-correlation-id: dbe7d4bd-c6a9-4b68-01c0-08db709b4304
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rBOG2C01OTsCR/jkZr3G1LvUeWWhg/5ZfG/Hd+27q2D4GTSIwlQgDsNggd6nacemGBpHg7mjBd1gluCHkMmv4v4H/q5mv5OgF+zPEM+ANpQj3Uoq1iQvZnKkC3+A/9iPL5ksBoA6I4DN+QuB6lfumXnQ1fWYFiFw/7pajgCZci+ooOvY2DKaVVyGzy+vTfMGwlW7oICJ0UtIRk3iBEnW1GZdAKUekKiMsV8nTF2cae4GoynvKqEYLsSK0PpY/oAJpmL204YPSne19Ng9sDr9yJoIXUtu6tkJ/dFFjd/mRbE7ClaX2r8lxqs357C5zJiyCAy4Z06B72VPWaFyUYL1D1uMbNSwA5kRa/qCwwUbquUdRNa+EcdA0XiOR+fVtabnae+OWshkFVScq0CvlrwEwj7pKpu3nQxI+HX23skfOGFsHyN0EcLD8bWNv+iW9Pe6P0UMbfsfX1e45dj0uvqL6AxbPfjPNubjwA0rCpc/ItQG5mDUGgtYAXq0NbhANuGW93eHXWc68RwLfKhsK07NB2Vd9N2LPRemcHH3xpkoJd76yEObEhBEAVctFZM09S9FNJJ6yw+MnhGLBpg6XC2qGUdvDv6M8+OeaIF/5KT+6S1MgP7wAbPmLluRDf3wf2RL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(122000001)(82960400001)(478600001)(2906002)(38070700005)(55016003)(71200400001)(110136005)(7696005)(54906003)(38100700002)(316002)(7416002)(83380400001)(52536014)(5660300002)(41300700001)(66946007)(66556008)(66476007)(66446008)(76116006)(64756008)(6506007)(9686003)(26005)(86362001)(8676002)(8936002)(33656002)(186003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?erfn5yCCNodpWukqyvtEW2c1neqgy+/wGPIuBeFgnuNFO4gaVZd8LRduwegw?=
 =?us-ascii?Q?TueVzc75Dv33ya173MVdgJX9CUCgk/6IMvNYcRsIifn1XJwPQfbnTLSn8aQ3?=
 =?us-ascii?Q?g1RCA/SpoV0KCPH5xyslOrDDdujsvgGRar7DUGLIgmt+arf/E4xuSO7Z9KxC?=
 =?us-ascii?Q?EwfEjXcVwjSlqR+zDxhHySItYGbhtY6XGEeALhTGFbmv6uO1PHvhqubaYq9N?=
 =?us-ascii?Q?Ug5U+56Xx910jSh/OFTzYSiMQ47VTufCORrsNu1QmZY4RAWEyV7+smlcfCJn?=
 =?us-ascii?Q?9gdZA42Uh3+CB3hGcPOQjG2J1SzrBCU2Waw/5bIdrQir/n13ehDveBr145X2?=
 =?us-ascii?Q?OJnRGEB2CpicmSAJiWoli17tyNl6l0kXeMaAnwP4kHjUlauSDC11uctfeuY4?=
 =?us-ascii?Q?I8cjvaaFHzUd7kXVWSYOd03jTRN4sf/Zkt0TCAdk4hS9EUcJ3KBztu6yW2zg?=
 =?us-ascii?Q?XVsx/JcUC1QpsqgSGRYXJ08sLxgRefE58Pc17XwGirukTjzGLVJMPRD1/WLz?=
 =?us-ascii?Q?hvJ5fb0KcAfm6STPXnxjsAbWfBPAYDyxFpoOBdc5r2qfKxh+nG882XWtisfT?=
 =?us-ascii?Q?BMX2AWsPIAf7kDdMUYK9QSwn4Q77CvA38ohX+lsUT6JiAd/nSvd1cXjnWudv?=
 =?us-ascii?Q?h/EzsIK/N2+aEt+zMilJsOyuc/CETwKrgtUrGTZFyoOyS5UZDUxcyxQzmOvv?=
 =?us-ascii?Q?6MGcmZ/zbi1xAArq5h8g6vQBPugDsbKvOctkL1eWg5mCQ+G8Coe/MbXxfSUU?=
 =?us-ascii?Q?P2Zv7dpZ5ggH787+Fbn02iZwIM0T8fZz/BxZyZgEGoeGhWBBHuj1zHMDWcT3?=
 =?us-ascii?Q?yWDlwqZgHQIv0f7xDq3Gb2G3dVFYOMY8B9deUrsBvX8+JiNmeSAT7Ms2NfcD?=
 =?us-ascii?Q?1Pbh84XCYps+X2xyDaolWlBs6etRYZLYItNxTY4z/FrC9oGUZqV9LqhviUbb?=
 =?us-ascii?Q?2FDP3TI6P9FC2zaxBAsCEsx0XMs8GYyxpYZorbi44q3nLaFtSV1oNGVSWwj6?=
 =?us-ascii?Q?Dsy3D791kQczCiiFpI41SFOClWOpdFpXQf9cOID7f+gXu6LT1nU4oKi2+BzY?=
 =?us-ascii?Q?7YWEmDBaq+O9tvV+vVuaDUrFf7IDEBRBnOyqAod7iBIks2nCXAq7H+tgHjPa?=
 =?us-ascii?Q?PD30vJQj5MAhSK1D4qjzZUUCsJYJnjk/zHMG0MThZeB3pToA8KTkJN+OnFRE?=
 =?us-ascii?Q?8L6V79gHt0WUpauieHs0uuz+tEwTclrEIbgIB/Je+E8PwHVCsBuY/rTMl6+2?=
 =?us-ascii?Q?djr87BETkeUaKUx8VFj5ceqUy7w1hk9TRWS89K5IN9axy+WI8nC1CSsWsIp0?=
 =?us-ascii?Q?QWnCeoYk8hvqjoPb2qiDUTJG9KkH5T4Jf9S72lImM+lItOtXVgEb/bVhAJCg?=
 =?us-ascii?Q?S+da63lH2uNksb4+tmLGgj+Z/956UBvyB6fjQyd1ApSlbWvh+JuvtvsRpEj0?=
 =?us-ascii?Q?yg4x5HOF5manEFl/seTf0iqGEqaRzfg8lvsj7Z2GIDFRk6VXWhjviElTu7fj?=
 =?us-ascii?Q?G954UNUc69jJ3YM+8aOoSHP32CsXK2OisFDQLJQPJIghBxcoidPzTpk77k0v?=
 =?us-ascii?Q?Jsw/VrtvRGOVsXRcNeg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe7d4bd-c6a9-4b68-01c0-08db709b4304
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 08:00:34.9054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ewHdOCOWCY0PrzTCahuVeZ8qvXgwaEyI+1G5IkAjuSkA26fagfgGahgTwAXwaDk2BiatHDSsie8tn7rjQ2Vtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6246
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> The untested below should do the trick. Wants to be split in several
> patches, but you get the idea.

Hi Thomas,

How do you want to split the patch?

To me it's better to keep the changes in one patch, thus the differences
are more obvious.

We need a second patch to do vector cleanup in lapic_offline() in case the
vector cleanup timer has not expired.  But I don't see a good way to split
your draft patch (I only have a minor fix on it).

Thanks!
Xin

>=20
> Thanks,
>=20
>         tglx
> ---
> Subject: x86/vector: Get rid of IRQ_MOVE_CLEANUP_VECTOR
> From: Thomas Gleixner <tglx@linutronix.de>
>=20
> No point to waste a vector for cleaning up the leftovers of a moved
> interrupt. Aside of that this must be the lowest priority of all vectors
> which makes FRED systems utilizing vectors 0x10-0x1f more complicated
> than necessary.
>=20
> Schedule a timer instead.
>=20
> Not-Yet-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/hw_irq.h       |    4 -
>  arch/x86/include/asm/idtentry.h     |    1
>  arch/x86/include/asm/irq_vectors.h  |    7 ---
>  arch/x86/kernel/apic/vector.c       |   83 ++++++++++++++++++++++++++---=
-------
>  arch/x86/kernel/idt.c               |    1
>  arch/x86/platform/uv/uv_irq.c       |    2
>  drivers/iommu/amd/iommu.c           |    2
>  drivers/iommu/hyperv-iommu.c        |    4 -
>  drivers/iommu/intel/irq_remapping.c |    2
>  9 files changed, 68 insertions(+), 38 deletions(-)
>=20
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -97,10 +97,10 @@ extern struct irq_cfg *irqd_cfg(struct i
>  extern void lock_vector_lock(void);
>  extern void unlock_vector_lock(void);
>  #ifdef CONFIG_SMP
> -extern void send_cleanup_vector(struct irq_cfg *);
> +extern void vector_schedule_cleanup(struct irq_cfg *);
>  extern void irq_complete_move(struct irq_cfg *cfg);
>  #else
> -static inline void send_cleanup_vector(struct irq_cfg *c) { }
> +static inline void vector_schedule_cleanup(struct irq_cfg *c) { }
>  static inline void irq_complete_move(struct irq_cfg *c) { }
>  #endif
>=20
> --- a/arch/x86/include/asm/idtentry.h
> +++ b/arch/x86/include/asm/idtentry.h
> @@ -648,7 +648,6 @@ DECLARE_IDTENTRY_SYSVEC(X86_PLATFORM_IPI
>=20
>  #ifdef CONFIG_SMP
>  DECLARE_IDTENTRY(RESCHEDULE_VECTOR,
> 	sysvec_reschedule_ipi);
> -DECLARE_IDTENTRY_SYSVEC(IRQ_MOVE_CLEANUP_VECTOR,
> 	sysvec_irq_move_cleanup);
>  DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
>  DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,
> 	sysvec_call_function_single);
>  DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,
> 	sysvec_call_function);
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -35,13 +35,6 @@
>   */
>  #define FIRST_EXTERNAL_VECTOR		0x20
>=20
> -/*
> - * Reserve the lowest usable vector (and hence lowest priority)  0x20 fo=
r
> - * triggering cleanup after irq migration. 0x21-0x2f will still be used
> - * for device interrupts.
> - */
> -#define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
> -
>  #define IA32_SYSCALL_VECTOR		0x80
>=20
>  /*
> --- a/arch/x86/kernel/apic/vector.c
> +++ b/arch/x86/kernel/apic/vector.c
> @@ -44,7 +44,18 @@ static cpumask_var_t vector_searchmask;
>  static struct irq_chip lapic_controller;
>  static struct irq_matrix *vector_matrix;
>  #ifdef CONFIG_SMP
> -static DEFINE_PER_CPU(struct hlist_head, cleanup_list);
> +
> +static void vector_cleanup_callback(struct timer_list *tmr);
> +
> +struct vector_cleanup {
> +	struct hlist_head	head;
> +	struct timer_list	timer;
> +};
> +
> +static DEFINE_PER_CPU(struct vector_cleanup, vector_cleanup) =3D {
> +	.head	=3D HLIST_HEAD_INIT,
> +	.timer	=3D __TIMER_INITIALIZER(vector_cleanup_callback, TIMER_PINNED),
> +};
>  #endif
>=20
>  void lock_vector_lock(void)
> @@ -843,8 +854,12 @@ void lapic_online(void)
>=20
>  void lapic_offline(void)
>  {
> +	struct vector_cleanup *cl =3D this_cpu_ptr(&vector_cleanup);
> +
>  	lock_vector_lock();
>  	irq_matrix_offline(vector_matrix);
> +	WARN_ON_ONCE(try_to_del_timer_sync(&cl->timer) < 0);
> +	WARN_ON_ONCE(!hlist_empty(&cl->head));
>  	unlock_vector_lock();
>  }
>=20
> @@ -934,62 +949,86 @@ static void free_moved_vector(struct api
>  	apicd->move_in_progress =3D 0;
>  }
>=20
> -DEFINE_IDTENTRY_SYSVEC(sysvec_irq_move_cleanup)
> +static void vector_cleanup_callback(struct timer_list *tmr)
>  {
> -	struct hlist_head *clhead =3D this_cpu_ptr(&cleanup_list);
> +	struct vector_cleanup *cl =3D container_of(tmr, typeof(*cl), timer);
>  	struct apic_chip_data *apicd;
>  	struct hlist_node *tmp;
> +	bool rearm =3D false;
>=20
> -	ack_APIC_irq();
>  	/* Prevent vectors vanishing under us */
> -	raw_spin_lock(&vector_lock);
> +	raw_spin_lock_irq(&vector_lock);
>=20
> -	hlist_for_each_entry_safe(apicd, tmp, clhead, clist) {
> +	hlist_for_each_entry_safe(apicd, tmp, &cl->head, clist) {
>  		unsigned int irr, vector =3D apicd->prev_vector;
>=20
>  		/*
>  		 * Paranoia: Check if the vector that needs to be cleaned
> -		 * up is registered at the APICs IRR. If so, then this is
> -		 * not the best time to clean it up. Clean it up in the
> -		 * next attempt by sending another IRQ_MOVE_CLEANUP_VECTOR
> -		 * to this CPU. IRQ_MOVE_CLEANUP_VECTOR is the lowest
> -		 * priority external vector, so on return from this
> -		 * interrupt the device interrupt will happen first.
> +		 * up is registered at the APICs IRR. That's clearly a
> +		 * hardware issue if the vector arrived on the old target
> +		 * _after_ interrupts were disabled above. Keep @apicd
> +		 * on the list and schedule the timer again to give the CPU
> +		 * a chance to handle the pending interrupt.
>  		 */
>  		irr =3D apic_read(APIC_IRR + (vector / 32 * 0x10));
>  		if (irr & (1U << (vector % 32))) {
> -			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
> +			pr_warn_once("Moved interrupt pending in old target APIC
> %u\n", apicd->irq);
> +			rearm =3D true;
>  			continue;
>  		}
>  		free_moved_vector(apicd);
>  	}
>=20
> -	raw_spin_unlock(&vector_lock);
> +	/*
> +	 * Must happen under vector_lock to make the timer_pending() check
> +	 * in __vector_schedule_cleanup() race free against the rearm here.
> +	 */
> +	if (rearm)
> +		mod_timer(tmr, jiffies + 1);
> +
> +	raw_spin_unlock_irq(&vector_lock);
>  }
>=20
> -static void __send_cleanup_vector(struct apic_chip_data *apicd)
> +static void __vector_schedule_cleanup(struct apic_chip_data *apicd)
>  {
> -	unsigned int cpu;
> +	unsigned int cpu =3D apicd->prev_cpu;
>=20
>  	raw_spin_lock(&vector_lock);
>  	apicd->move_in_progress =3D 0;
> -	cpu =3D apicd->prev_cpu;
>  	if (cpu_online(cpu)) {
> -		hlist_add_head(&apicd->clist, per_cpu_ptr(&cleanup_list, cpu));
> -		apic->send_IPI(cpu, IRQ_MOVE_CLEANUP_VECTOR);
> +		struct vector_cleanup *cl =3D per_cpu_ptr(&vector_cleanup, cpu);
> +
> +		/*
> +		 * The lockless timer_pending() check is safe here. If it
> +		 * returns true, then the callback will observe this new
> +		 * apic data in the hlist as everything is serialized by
> +		 * vector lock.
> +		 *
> +		 * If it returns false then the timer is either not armed
> +		 * or the other CPU executes the callback, which again
> +		 * would be blocked on vector lock. Rearming it in the
> +		 * latter case makes it fire for nothing.
> +		 *
> +		 * This is also safe against the callback rearming the timer
> +		 * because that's serialized via vector lock too.
> +		 */
> +		if (!timer_pending(&cl->timer)) {
> +			cl->timer.expires =3D jiffies + 1;
> +			add_timer_on(&cl->timer, cpu);
> +		}
>  	} else {
>  		apicd->prev_vector =3D 0;
>  	}
>  	raw_spin_unlock(&vector_lock);
>  }
>=20
> -void send_cleanup_vector(struct irq_cfg *cfg)
> +void vector_schedule_cleanup(struct irq_cfg *cfg)
>  {
>  	struct apic_chip_data *apicd;
>=20
>  	apicd =3D container_of(cfg, struct apic_chip_data, hw_irq_cfg);
>  	if (apicd->move_in_progress)
> -		__send_cleanup_vector(apicd);
> +		__vector_schedule_cleanup(apicd);
>  }
>=20
>  void irq_complete_move(struct irq_cfg *cfg)
> @@ -1007,7 +1046,7 @@ void irq_complete_move(struct irq_cfg *c
>  	 * on the same CPU.
>  	 */
>  	if (apicd->cpu =3D=3D smp_processor_id())
> -		__send_cleanup_vector(apicd);
> +		__vector_schedule_cleanup(apicd);
>  }
>=20
>  /*
> --- a/arch/x86/kernel/idt.c
> +++ b/arch/x86/kernel/idt.c
> @@ -131,7 +131,6 @@ static const __initconst struct idt_data
>  	INTG(RESCHEDULE_VECTOR,
> 	asm_sysvec_reschedule_ipi),
>  	INTG(CALL_FUNCTION_VECTOR,		asm_sysvec_call_function),
>  	INTG(CALL_FUNCTION_SINGLE_VECTOR,	asm_sysvec_call_function_single),
> -	INTG(IRQ_MOVE_CLEANUP_VECTOR,
> 	asm_sysvec_irq_move_cleanup),
>  	INTG(REBOOT_VECTOR,			asm_sysvec_reboot),
>  #endif
>=20
> --- a/arch/x86/platform/uv/uv_irq.c
> +++ b/arch/x86/platform/uv/uv_irq.c
> @@ -58,7 +58,7 @@ uv_set_irq_affinity(struct irq_data *dat
>  	ret =3D parent->chip->irq_set_affinity(parent, mask, force);
>  	if (ret >=3D 0) {
>  		uv_program_mmr(cfg, data->chip_data);
> -		send_cleanup_vector(cfg);
> +		vector_schedule_cleanup(cfg);
>  	}
>=20
>  	return ret;
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3639,7 +3639,7 @@ static int amd_ir_set_affinity(struct ir
>  	 * at the new destination. So, time to cleanup the previous
>  	 * vector allocation.
>  	 */
> -	send_cleanup_vector(cfg);
> +	vector_schedule_cleanup(cfg);
>=20
>  	return IRQ_SET_MASK_OK_DONE;
>  }
> --- a/drivers/iommu/hyperv-iommu.c
> +++ b/drivers/iommu/hyperv-iommu.c
> @@ -51,7 +51,7 @@ static int hyperv_ir_set_affinity(struct
>  	if (ret < 0 || ret =3D=3D IRQ_SET_MASK_OK_DONE)
>  		return ret;
>=20
> -	send_cleanup_vector(cfg);
> +	vector_schedule_cleanup(cfg);
>=20
>  	return 0;
>  }
> @@ -257,7 +257,7 @@ static int hyperv_root_ir_set_affinity(s
>  	if (ret < 0 || ret =3D=3D IRQ_SET_MASK_OK_DONE)
>  		return ret;
>=20
> -	send_cleanup_vector(cfg);
> +	vector_schedule_cleanup(cfg);
>=20
>  	return 0;
>  }
> --- a/drivers/iommu/intel/irq_remapping.c
> +++ b/drivers/iommu/intel/irq_remapping.c
> @@ -1180,7 +1180,7 @@ intel_ir_set_affinity(struct irq_data *d
>  	 * at the new destination. So, time to cleanup the previous
>  	 * vector allocation.
>  	 */
> -	send_cleanup_vector(cfg);
> +	vector_schedule_cleanup(cfg);
>=20
>  	return IRQ_SET_MASK_OK_DONE;
>  }
