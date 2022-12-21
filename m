Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2893652BA0
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 03:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbiLUC4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 21:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUC4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 21:56:23 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAD219291;
        Tue, 20 Dec 2022 18:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671591382; x=1703127382;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zi2fALu/RGwzkLtM8kbKTEhqiQ/GemV9fLtqoNV5ByA=;
  b=ilXk46bFoyECghNgMTsoqtD27W00tsVzdDfmJfOiChOeOjaWIi5YXp2x
   RnH9no54jgT/pArZo1GTfY0kZPgneUL9UOwrYDWzVxtM1fGS6m7CIij0A
   b9C8ccnbAQMbG6ANokMGOBg/pCHJfTktSHac3S6Ro3bhFlxb+1zQsBoQX
   kLH3oZMr1NR7V7m7jxQb/gAVFOB/F0HNaixbPRqJkqydCOIwezvCCQ8Rt
   2vpyqKPm68pQ9t/j4XNMrLBZ24mlV5DOSXdonCQ1iwns1iIj11D2zhrmw
   QNiIY4wIpuIv48kbGdnyNXUXJzexRxm7b0c6PkzTYk8HR0Id/EU7QFoNS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299446328"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="299446328"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 18:56:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="651255553"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="651255553"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 20 Dec 2022 18:56:18 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 18:56:17 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 18:56:17 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 18:56:17 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 18:56:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ8Z9oCAqv9k8dXPxYq+cPqC63aye16WSBqcGOtg98Q9s4UcLfa6svTeRI2qax26EBxZ/vDnRnnW0uSedpbAgKO3MxRzJymeJ+1ReVDtrjyicxteTk8YDDOaaPbTg74aPdRWxGZmpOHpufU4V6eRAUtlqE16oTXfmy4Kd7xgHeF6wH4Q8olYgNErxRVP7U7Vpv2Zbu9jH2r6UccQP478aiaLJ+r0EhUJA4U/DtNzq1k4XR000I0GCecGI87XQjd/zA35VK3PSAxpciiBEqdoKFSroxf2nSaLs0UXnIWa/Ug5CwkRFGo9/bamGPDjAzNkyFSxRN0Dmtd6/JaSZKOjbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oh4GfhzFqap46CupgClcM70AW4j+TOCIlVo+oBfokDI=;
 b=TmRSK7b9XAhmWn/R5V4gPckujlY/DDD0/9vaFbSocpWFN2yY3mKplQtUqkoeyLt1GGbHL4ijkVfbeNiAtKkIXEaYwz0lOK07oclmcQutXZWew3fYIvM+7eRfNFXLu902CAngtNs/rn5ZZ0WckdhgLM92yiMCgSvzhhEspmNLCPAY6OMLgpczSzNjtb96lljhTlLjkdASwZzqGzezGvVI03zU4Vc8Mx/+uasV8nF8YWWjf1ZeJZ1RiUbgFeRU+pcZ5PBN83/yT0Cdtu292OXxAAE1rDNADvArw2gB1g1FHyKY3nNKWLmOSEzAk2pNDDr6pJ64IGDsLhkq+q4Ba8jzIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by BL3PR11MB5699.namprd11.prod.outlook.com
 (2603:10b6:208:33e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 02:56:09 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130%6]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 02:56:09 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [RFC PATCH 21/32] x86/fred: FRED entry/exit and dispatch code
Thread-Topic: [RFC PATCH 21/32] x86/fred: FRED entry/exit and dispatch code
Thread-Index: AQHZFEEqB8vFGw46PUyUjTdrtrKg+q52hEwAgAEcqbA=
Date:   Wed, 21 Dec 2022 02:56:08 +0000
Message-ID: <BN6PR1101MB21611C69A6B168B2A0A888F4A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-22-xin3.li@intel.com>
 <Y6GB5C1Bx60L9hk3@hirez.programming.kicks-ass.net>
In-Reply-To: <Y6GB5C1Bx60L9hk3@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|BL3PR11MB5699:EE_
x-ms-office365-filtering-correlation-id: 00c1132d-318c-4884-dd46-08dae2fee958
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NSpvuL2mZRU4eHt3XxpMZ7Av8xK1jm8egcfHDFTlHlu4NaDE1zenUw6LYgTvX4rV+a5bVn7Nr9J3PBAX30d04xZHhs/wq543vpx5+m5+isDPyXPr1Q6Lw1yTbvrSCadI/nN/FwDZkW9AlvBmXGWxGhG/rkMuM85Cu3vllfCL7C+Qe5QtenVlQlqFATFYzxHBX9bKYcMtxKgza/sA9mybubClQsGSrCSuiIDvWsPrZMsNfh562DnuwlC9N3kUIG609PMHZIQ1KlWvb1hqDBwQvPK1lt2BYOs6yJmKc8skLpBxyn6vm7M1L9uGWjAab1Jri2uAZVvEG2NpcdVd1WUARcv+hwQuAieHdKXBF3rhX8URN/VoYS/PH17KEhhqqoFmeoswBHlefnmk6tZPFWZoepLi4PmpZSe+tPA1CIobp1pXbkh/g5gvUqGN6GFaHJ7Hh3PJAOyujucT93jNctIN7lUyNZvsl9gkZruX0o6XnBHfxW1TSKhvyx8kFZ4roM3tQWCAQsJo8tchAS5E3KroEEnaUaoI/quPb0CMOOECHN6trBhJGJflGT+S1Xcjhex01RUa553Pm1Jzu2ARLWT4qoStdczUikzjCFxp2I2OuCKgpInyai/EoGV2gggwPqdcfC09PMt0NomeoJ7HvKUgq2WVeCUKMlTW/x3xGg6zQOKdZRtMLdDSHuXepq5GjXmi0kL8uH4/km3+aRzzoPn+Ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(8936002)(2906002)(6916009)(54906003)(38070700005)(316002)(478600001)(6506007)(86362001)(33656002)(55016003)(26005)(7696005)(186003)(71200400001)(9686003)(122000001)(38100700002)(82960400001)(52536014)(41300700001)(66946007)(76116006)(5660300002)(66476007)(64756008)(7416002)(66446008)(8676002)(4326008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KntgHBXbwCWHNGKtF2cCk2dQBsuBjYMGmUc9DPJ0vofnxRvrboS/DKkFcszb?=
 =?us-ascii?Q?hyUjOnv60V0H+UoMO+ncDGCoNMNSObAeHORBIVK8YChrmpGjkN6z6RVfuKAe?=
 =?us-ascii?Q?0ptewpyybFNMLn0KkSSi6Z7fHl3HS0bzj9KYYohGNMA/gnzlgmOGw8N/NzQo?=
 =?us-ascii?Q?LibW/fs+gPh4qmIDWPb5YG0jYZf809Tfl7EpNIaAKh8hQfon5RlJTvQCqHem?=
 =?us-ascii?Q?CdYrEvjWPU+oG04CJLp45D5ZpVe4dHa1AwXpyka1hqMYhM4vVkiEBc1mpaom?=
 =?us-ascii?Q?g3pXPkK0eSKGM1XkMsnT5OrdJjBWc0vdu8865KRWZkvat8OviMSnfOV9ztk6?=
 =?us-ascii?Q?bnLPmc1c344JpQsbEl3kRKMz7XSUdSppmFjjxeV606CgGMRT4vvfTHtTtZtT?=
 =?us-ascii?Q?UTv+NxbB9cP7e3kPqfZ+c62Qv2S7VmDMydy91uyWiA6SJz4H337deOlKSH7+?=
 =?us-ascii?Q?22+66NIlIg8uTlK6A9BZPrJ9Wvf2tisuswjWePijzBr5u43SsUfdLLLaKWdx?=
 =?us-ascii?Q?ndmS+90kKDu8MucR19IYjsc8NpFGmeqWHADxQ+MbeXNzACpgp2vY6yGEpbW2?=
 =?us-ascii?Q?dkjhqcP0EKbaV2OPLNEPxQGjukIoFnfBYcq725QrROQf3WuN4jKyPpftrhfL?=
 =?us-ascii?Q?kwywdC6pEQu0DaweIiDSNomZNF6r954xNRwbUSKbSDsSN0xIYekvDztASwl+?=
 =?us-ascii?Q?UrxiUs0Lr2ymYnOW8MJ1PVx/RInuU26kvKmgxopwcYNFi15Of+RYGnmU+dLB?=
 =?us-ascii?Q?XEOcDRRTOuUHoqjGvGt01phzIgt7YtvOF2VojOqTExitcgyvmDaLGPwKHbXS?=
 =?us-ascii?Q?HTMb+2n+grwDEt9RIIJh7tJdwPDP/xQD/MV1JHUKsard7Wo4QdAgol4D3lF/?=
 =?us-ascii?Q?Tw9pYX8fKNLfcHsBf20srMGGOeOM49gRj8Ggcmg8eNYDDjTYethyBSnAciad?=
 =?us-ascii?Q?1k9+ndmqb4YpdM96LCe6XJqRJuQaT0V9YESl2G9axOrVdF4qkEiWnSV4GzML?=
 =?us-ascii?Q?VitlpogeRW5JQ2fVxzrlsVqGhCwQWaqD1YBt0myK9xBt33Kn7vDkMNp7Sgp0?=
 =?us-ascii?Q?++JpbMWZaL/6A9TeH3XPrJbJAJqSnpkKXUXesn8+Fv9PaqrSgZto3+Zh1Zqj?=
 =?us-ascii?Q?5WaaJrp0vxuvXFekFYumz9m1pHux6EV7BCfEafQIHsOr7K8d0aRkFqdvuiX5?=
 =?us-ascii?Q?3jq6JDocbGdCPrw83pH4rXicNQtg2avOIVHXdxRwkicfNoxJoQCgFIiUVFla?=
 =?us-ascii?Q?th35Obzfaxku0kNmGmwU1aHJtuDZ1GJC0VdNroW4pDejgT/baC5X7VFxfFmx?=
 =?us-ascii?Q?d4tA9u1JVYQu5/AVq7hBRcRIAzcKyZ4MRKRREeEiQdZq5zXzuYn1cHYABw+D?=
 =?us-ascii?Q?yzOii5gyZYzfT0eV7iCuV2NzvVQACtF0LPzJ057h0BlUTLVkgD1v38X4kR3z?=
 =?us-ascii?Q?G8PmXCMgfNZHeYt1duZSzfju712BqoRTEmf2p4CBiwSkj7wZU/hoYtt8dZbG?=
 =?us-ascii?Q?XajDI4HRA9ktcXLhtqz35uF92yQrSR3xX2YHhYcWXVoHV8SdF27Fv89zLtp4?=
 =?us-ascii?Q?GCe2OzS6m7uJQYxrFg1fmJMrLiuysuefUX1yFcOE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c1132d-318c-4884-dd46-08dae2fee958
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 02:56:09.0363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nNc/PFZCjKmrPMnLbL5893PRkiunja1g6eG2Rc2mD/LJTMc5TDUWm/MCWqsaxiypMn2bmNPrzdZL4j5suF8+ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5699
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > +static DEFINE_FRED_HANDLER(fred_exception)
> > +{
> > +	/*
> > +	 * This intentially omits exceptions that cannot happen on FRED h/w:
> > +	 * vectors _NOT_ listed are set to NULL.
> > +	 */
> > +	static const fred_handler
> exception_handlers[NUM_EXCEPTION_VECTORS] =3D {
> > +		[X86_TRAP_DE] =3D fred_exc_divide_error,
> > +		[X86_TRAP_DB] =3D fred_exc_debug,
> > +		[X86_TRAP_NMI] =3D NULL, /* A separate event type, not handled
> here */
> > +		[X86_TRAP_BP] =3D exc_int3,
> > +		[X86_TRAP_OF] =3D fred_exc_overflow,
> > +		[X86_TRAP_BR] =3D fred_exc_bounds,
> > +		[X86_TRAP_UD] =3D exc_invalid_op,
> > +		[X86_TRAP_NM] =3D fred_exc_device_not_available,
> > +		[X86_TRAP_DF] =3D fred_exc_double_fault,
> > +		[X86_TRAP_OLD_MF] =3D NULL, /* 387 only! */
> > +		[X86_TRAP_TS] =3D fred_exc_invalid_tss,
> > +		[X86_TRAP_NP] =3D fred_exc_segment_not_present,
> > +		[X86_TRAP_SS] =3D fred_exc_stack_segment,
> > +		[X86_TRAP_GP] =3D fred_exc_general_protection,
> > +		[X86_TRAP_PF] =3D fred_exc_page_fault,
> > +		[X86_TRAP_SPURIOUS] =3D NULL, /* Interrupts are their own event
> type */
> > +		[X86_TRAP_MF] =3D fred_exc_coprocessor_error,
> > +		[X86_TRAP_AC] =3D fred_exc_alignment_check,
> > +		[X86_TRAP_MC] =3D fred_exc_machine_check,
> > +		[X86_TRAP_XF] =3D fred_exc_simd_coprocessor_error
> > +	};
> > +	static const u32 noinstr_mask =3D BIT(X86_TRAP_DB) | BIT(X86_TRAP_BP)=
 |
> > +					BIT(X86_TRAP_DF) | BIT(X86_TRAP_PF) |
> > +					BIT(X86_TRAP_MC) | BIT(X86_TRAP_UD);
> > +	u8 vector =3D array_index_nospec((u8)regs->vector,
> NUM_EXCEPTION_VECTORS);
> > +	irqentry_state_t state;
> > +
> > +	if (likely(exception_handlers[vector])) {
>=20
> Can't you get rid of this branch by stuffing the exception_handlers[] tab=
le with
> fred_bad_event?
>=20
> > +		if (!(BIT(vector) & noinstr_mask)) {
> > +			state =3D irqentry_enter(regs);
> > +			instrumentation_begin();
> > +		}
> > +
> > +		exception_handlers[vector](regs);
> > +
> > +		if (!(BIT(vector) & noinstr_mask)) {
> > +			instrumentation_end();
> > +			irqentry_exit(regs, state);
> > +		}
>=20
> This noinstr mask is daft; why not have DEFINE_FRED_HANDLER and
> DEFINE_FRED_HANDLER_RAW or something, have the normal one include the
> irqentry bits and use the _RAW one for the 'funny' ones that need to do i=
t
> themselves?

I wanted to keep "state =3D irqentry_enter(regs); instrumentation_begin();"
in the dispatch framework, instead of pushing down to the handlers.

Of course, we could do it the other way if it is more preferred.

#PF is way more frequent than other events, maybe we should do an early
out for it in fred_entry_from_user/kernel().

>=20
> > +	} else {
> > +		return fred_bad_event(regs);
> > +	}
>=20
> Then all this becomes:
>=20
> 	exception_handlers[vector](regs);
>=20
> no branches, no nothing.

This does look simpler and cleaner at the dispatch framework layer.

Xin
