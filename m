Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFD66AB9E5
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 10:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCFJco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 04:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCFJcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 04:32:43 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35C14EF3;
        Mon,  6 Mar 2023 01:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678095160; x=1709631160;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8H7+ajoRP4lzOQsBf+qso3qKZwWJxpr41UO49uxYoGg=;
  b=Ppg8Qcq8+PeS/V7qyLv90LgwECN1Tsd3fqd87l8K6l/kr96hDRpap8hx
   i9Esf6TR94JhhV71h+pHlIFNF+ZvmLmD133hFCPZ1fiIFCiqg8kBpwzH6
   frXXEPPlBSfUXk3CIQXVWpKMVvtscGYrfzeue/W6L1Gk59IKuPDZSCD99
   3sQUOQZWRguRgXg89lmdHem2/QqeVLyA6W8hz4jBjdrhIr/Qy5GaAiqU+
   qdFwTwC81XP8zu0u3IhWG9GGcUXO5rgeSH5orAvzEoA6H/oX3zm6YiVzA
   V2EjL+OxLjRwuANsnJh7ScI2f5jhvw6BpSeJcHNyY7O52e2FbFWU1T4fD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="315908222"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="315908222"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 01:32:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="921856312"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="921856312"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 06 Mar 2023 01:32:40 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 01:32:40 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 01:32:39 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 01:32:39 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 01:32:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpKxS9JX8sIHEwstPkBjwhRh8ZICc/x2DbOZ1pvp8kD+BrZHqYLBXJwoI/f69xEIMo8yl7Z0xFsTe5IkvOMR4R1cqyuk3rl4Tl3+dPoisFIgvUCkkFTBwUy3ZsO6xEsJNoowzGjVaNnHGcjllkhStIPRGA5SMc1hCCgSgTdD3zQtt0jTK+eOwKCj9d+XrVk0BaeTY+ckAujNdcTwi1ZLzb3lu/zXEnw9kZ2z2WrjjfucaSt3izObCz41X1qjRpBsmcCCWqA6VP7c2YDPThEb4Tw2sXc2xn0ARsSqiVSthZJxV4jIUnFZRHdFcMxZZ6czoYOhZBCEKDeC7eiPanfSEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ie8STeVQWRypMSw9wo8kzOYl7L68l3Ugt5h1aPhGt7k=;
 b=ghE+uCZHz5M81ywnyT64xkcH+2SNXtJryiibw6ewgQ6VzBZQ+z+M1a3d28DHzcVgQ0iWzWsl/kUERJ/1uRjU8ON9tO54bdUbW2WUaeJkw2hXPtvCXH7HqcFYDPa68WUxbUO8XKvVx7ZpJylGRM8XuNQUjWHdglLx7nLR8mbyqbpfeIlGeTkRQXGqGyCVT4EtffzbPt15ntMgUe8C35hzQz+R8z63R2qPmR3W4tGGqYFk8ORC1PYarWOsgzhZsq+rxzNio2y7ri/ACEi/gPpvldwPcqWlhzP0tUIXhNmreLp/GKSnvq9Aj4jzqYzOLspOOnkY1HwmG3wwOe5GeL/U5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH0PR11MB7167.namprd11.prod.outlook.com (2603:10b6:510:1e9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 09:32:35 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6156.027; Mon, 6 Mar 2023
 09:32:35 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v4 33/34] KVM: x86/vmx: call external_interrupt() for IRQ
 reinjection when FRED is enabled
Thread-Topic: [PATCH v4 33/34] KVM: x86/vmx: call external_interrupt() for IRQ
 reinjection when FRED is enabled
Thread-Index: AQHZTMtajA6OKKK7jkO+BOicqGsV567tgwFQ
Date:   Mon, 6 Mar 2023 09:32:35 +0000
Message-ID: <SA1PR11MB673422DA73549769390F5D3AA8B69@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230302052511.1918-1-xin3.li@intel.com>
 <20230302052511.1918-34-xin3.li@intel.com>
In-Reply-To: <20230302052511.1918-34-xin3.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH0PR11MB7167:EE_
x-ms-office365-filtering-correlation-id: 517ce8fc-fd4c-45c8-a99c-08db1e25b813
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bl2RDMj+9oXumYnYZPrWHqrE8ST63/+0N2KtH0JL66Ldbp1SRpw7dbWg3SnT6iSlNIFhUyEXq3kvPdOI4aoF5UbP2/icAAgHDxOoJZGQR6Hmr90eTWVxFQJpeBZDqPE8IsdBlqbZEzisSDB84VPmAYVC5W/Xx3kg2pc0ysKMULmtPor32STC51B2xJZFQaLio6xwQsX3mdrRAZXqcszFPJc+HlqHpCwlyrFUrj7lZfB2EPy3vB3FMR8StjudKoKJGKJDLOM2aiRBQqm6Et5cvsNIrDvjiB8S5hhFQuJZ+x1YRg0zYpe7MiS429Z27FPN1VTdrEFbm1VWv+3zTEv++NZmUEul3RLwg5632TiHQ/A1ORqLhnzIx6lI0CJHf7friGHqhXrOmkhuU1shTTiJI0NjtdA4DE9+AhaXTA7a/IvdARNkKFIvL/M6ZC450YsGRXbhQH7dLhLQsw9PhRphbHTRhoDnD0x7wnTvY8req2nEPRl7/samGRmLIAzL3Phdm2NTVVC00Z59QRBYeVdgxeLISEHvsfjWoxCK9X4oZ9iSbxpUHZDegSfmNRaWEUYDz9j3iT+Jl11u+sdscQYzc4bA7kIkwpr1Wbudtcc23/FkU/ZQThsQsPyyEgRMb87Q6Rd4CwFbUcIpglETCqhx5XaTkhjXifoZEgVrq4YVmd6R0z32sXxJLDOX2Cggg1zBvvjFwjW9u9Xwwi3I6TiiTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(396003)(346002)(39860400002)(451199018)(52536014)(7416002)(5660300002)(8936002)(66476007)(41300700001)(66446008)(66946007)(66556008)(2906002)(76116006)(8676002)(64756008)(4326008)(54906003)(110136005)(316002)(478600001)(7696005)(71200400001)(26005)(6506007)(186003)(122000001)(82960400001)(86362001)(33656002)(83380400001)(38070700005)(55016003)(38100700002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?orpVWW3yv5wDhAxPudjRexrLnxC1jFPQIbV13CiJhtFjrGwNAWYdBhMMVt1W?=
 =?us-ascii?Q?wuRLDI5fjbpv23Yaj8bzp9/S7TqUUC0fjl+Go4uYitiKcWaI2RS8bEufJboV?=
 =?us-ascii?Q?3p42zYfuXwRZzF3WuhjjHNuKvad0V1+MM6Mtu0mgop++pONjlm7evfoQSP7A?=
 =?us-ascii?Q?eu9q8u/HmdrnoAM21Bvn05xVS8jBiXkL8bUQZ6x5z3BGCl5fFbFRLmdNkOKs?=
 =?us-ascii?Q?WSGB2piLLNMn7UejGOGFM9KUGNED6CJ4YAd355UwRJQkUSPWcnCSR7oObYL2?=
 =?us-ascii?Q?tsZ7tFh65CN0Gegedg0X0Sqkp8xE14Z1J7wFb+ksCNdvaMxn1aP+5qK1LL5z?=
 =?us-ascii?Q?bj+5MTouZ0J/kw5JPwU0Ki3mqLWLNVU1nHgAEr9nA9WEvnDEoANOuaRc+KNO?=
 =?us-ascii?Q?UZmpXqC+O1oDaadV6QMobkiSz5a1GlzYAWmOHppX+rLqDPDveITCQ8mc0RqU?=
 =?us-ascii?Q?DEz/XjrCXUZSjKto4KJ9RRhBP+tqVelacOOuG56ZKA/KqBegpMedAn4KGP6O?=
 =?us-ascii?Q?+5CA/HcIZFdxElVM15NOxTu1Sbddk9W7sRab74KWY4WU+0tN1UgCSpZilXOu?=
 =?us-ascii?Q?gIoylJnwFSPERGVIfuHBO2Xwzcu8BBabKDNvWIB1DEB4eKlZIiKNvuzStBbr?=
 =?us-ascii?Q?sAoTu1/GHyN6QuW/THEpzAmkOyJBFrBg9j1M9kIAZBnMH/dXf42/1cQozl7f?=
 =?us-ascii?Q?izBzYSgydYqYcFTdPepsQeUF2j/V9ya6rN66RKH4LvIrIFE6mXZAENwGLj8f?=
 =?us-ascii?Q?Sgf70+TyQQ6ke/O3mtkLy3wD4TJU6OVesUy7ghdtj28JNVaH3nDzTwTBoT13?=
 =?us-ascii?Q?oD0KI4QfQ5xaksQ16ulygj3SsTeCDAnMJYNatQrcg9Q3MChj/pcMw33WKF2x?=
 =?us-ascii?Q?g1CwQ/hcphlBUhANtB87mGd5seizkh203Wx61b9ufLUcA1kEAW0svjz2/GZO?=
 =?us-ascii?Q?PqVCTQWck6gmDq7FGbmEgAEdFVXEvJxZg296UtHhLDMEsf4wGQu1EWIfuzX5?=
 =?us-ascii?Q?v8ckwWVo1r6Ko6cJuoxiM4VuuKDZmfnhgJ+yad6BfjzXo46zfehoEodgRx6d?=
 =?us-ascii?Q?0Tb39/8iDGLwaSMbBHO0JPE0tDX9ATTPKXRu1Z8wbH63dkXeLnvxIVFG/AYc?=
 =?us-ascii?Q?y9/WmKWqjlUe9zP2dFjbNzBZACd7TCk8QbFC9i4Yx8B9lIfsUkCuM7TcdMPO?=
 =?us-ascii?Q?PEbIWGmNp2mGqNpi+BMvicUH2nXXrG2PYLuONBF3ZCzpZYlTwwhU3XF5JW2m?=
 =?us-ascii?Q?iJ5FFmootIoLP3nqf6RUwGrbqSg7zDNSMxck4J4P/tiH//0nsR63zsW5ZWDK?=
 =?us-ascii?Q?RcYH2TrhbbWVfzPbJJ3exYi4HbhRj8Gx3xDbfxi3fhZ1Vbi5kNXZhSOWFsTS?=
 =?us-ascii?Q?VJ4JH+tR1Njsu37cTSerkVxXY1evl1c9bFvmCoUiFVAqxuiCMzTlgjqf85ub?=
 =?us-ascii?Q?/BEkgPl7oaCrAsW8HXw2JX9gvZ90RCCUtxRUg3U6J0MrkfdSyqCLvzI4nhOG?=
 =?us-ascii?Q?UjGfta4TJEVbpa8ThKtPbvRgWyI/DoQe1BsDOzbPkJx1tY+Ly43eVIuQRnc8?=
 =?us-ascii?Q?NhvvZDolxMjCS7xAS8s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 517ce8fc-fd4c-45c8-a99c-08db1e25b813
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 09:32:35.3351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z2ELqw/Q51wzJMiVGUzDN10Bad2HsHVDxs5guy3pAH0+xzwm5pL38IX4FkQCtKcAzsRqUlcQMtrSm1AUVmzdvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7167
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>  arch/x86/kvm/vmx/vmx.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> bcac3efcde41..30f854015c8c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -47,6 +47,7 @@
>  #include <asm/mshyperv.h>
>  #include <asm/mwait.h>
>  #include <asm/spec-ctrl.h>
> +#include <asm/traps.h>
>  #include <asm/virtext.h>
>  #include <asm/vmx.h>
>=20
> @@ -6923,7 +6924,26 @@ static void handle_external_interrupt_irqoff(struc=
t
> kvm_vcpu *vcpu)
>  		return;
>=20
>  	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
> -	vmx_do_interrupt_irqoff(gate_offset(desc));
> +	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
> +		struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> +		struct pt_regs regs =3D {};
> +
> +		/*
> +		 * Create an event return stack frame with the
> +		 * host context immediately after a VM exit.
> +		 *
> +		 * All other fields of the pt_regs structure are
> +		 * cleared to 0.
> +		 */
> +		regs.ssx	=3D __KERNEL_DS;

This breaks i386 build, and should use ss.

> +		regs.sp		=3D vmx->loaded_vmcs->host_state.rsp;
> +		regs.flags	=3D X86_EFLAGS_FIXED;
> +		regs.csx	=3D __KERNEL_CS;

And cs.

> +		regs.ip		=3D (unsigned long)vmx_vmexit;
> +
> +		external_interrupt(&regs, vector);
> +	} else
> +		vmx_do_interrupt_irqoff(gate_offset(desc));
>  	kvm_after_interrupt(vcpu);
>=20
>  	vcpu->arch.at_instruction_boundary =3D true;
> --
> 2.34.1

