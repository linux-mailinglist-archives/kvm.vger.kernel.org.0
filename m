Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9475464C489
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 08:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbiLNH5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 02:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiLNH5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 02:57:52 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFD11208D;
        Tue, 13 Dec 2022 23:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671004671; x=1702540671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5EGx2rrGNoBHFxRaG/ySuYrGao3DoNsHJZVDc4+/Q8I=;
  b=hl26l2VLCzcZcWlnJ36ZmW7zuEigeLxhGUip1sky4am6P0+K9S2eqg88
   AMucs4oR0Iow37OQ0B/Z/tBXLtige7nBvKhMDuFs8P/s3vwCb+esOjsrR
   ApaCbU4VtFqDf3e2K//f1JGky8jmbgEA66qygAI7ZoB8uiOyZSDwAfBlx
   gmpWDH/EUrHiXmplfROQCVw4/Te2KP6mHWrEgdU9PSB8u5Mn/9lGuBK9P
   V+nRhyfCO5GRtQZHBmBDV7oIaKO495i41ZE42SHRmz2O3raN0h99demN/
   cOWx4fbeedmA6NmWKUeDkANZocFVtYl7SaVHg1NkjsLkvKAvNRuWYlTPp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="298022874"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="298022874"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 23:57:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="823184907"
X-IronPort-AV: E=Sophos;i="5.96,243,1665471600"; 
   d="scan'208";a="823184907"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 13 Dec 2022 23:57:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 23:57:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 23:57:50 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 23:57:49 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 23:57:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnr+SjIF320Q6V40WBvdSi7VBhcRG3j5vQ9vQ47ARv5KnhDml5Z1oagQ0GOG1NuTPuhs37ahguOZL6wnvgYONiYlmD2+AKpmvbAvEs4kbISbIi9wafglSwyq6d+TUhaxoQ6nfuECjafM3dADS7KI9zw4pMCMT0VoQHiQja6e7YvCZXGeNzuBv/q77X2J4HlkEL0pQlmxnQPxddLGbIPm07xA8A+FqNsZcc+/ZsN93y/1gY2EHPGRE0UAggquuCynx904qK3YDJmeu7qMarJty/XM6Z3uY80DAmoAL3XRho10sLjbGFNEKnM35063qH3ry1k1OejY+U25zPQZw64FEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1eXSAVjP6pvcGNE2qtzfIB3G4FOQybdK9wFW3SaDOsY=;
 b=S8qItZFu6jtelu7tyoaxXvw+eKKUyLv+B5uKYtCsHNKYRaHCvQrVoZkgyfATeYmyv7Cor6C09m8NIlDFKanViVD2sZhXdDsD0KYkarCMDlypsNtlKXRjJwTy2UHPsl4nmSqJfuu0rK7QBW0kbR+nrXrbCSac9WeuPEN50NPpUKdCkQMtRfdUSR/IpvfHCGUVhYqY58Hq4rrn54XuAMtbtBxikfr5CyLALkqekwY9pBsiRc/tfO7pYgnIOPPi3uIWKcajCuabG8VZPYEhTaWdc2D0ioSR/TYrQ3HbuIOBD5Ad8uFKx0fHfTR9V5+D065/175neMewTaYzRnmcnaGosQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0031.namprd11.prod.outlook.com (2603:10b6:301:69::37)
 by MW4PR11MB6933.namprd11.prod.outlook.com (2603:10b6:303:22a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 07:57:46 +0000
Received: from MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5]) by MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5%7]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 07:57:46 +0000
From:   "Zhang, Chen" <chen.zhang@intel.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardware
 mitigations
Thread-Topic: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardware
 mitigations
Thread-Index: AQHZDLMhDxurDeM6YkqaqujyHlpxN65qtdEAgAJS9ZA=
Date:   Wed, 14 Dec 2022 07:57:46 +0000
Message-ID: <MWHPR11MB0031350E012516655F42F42D9BE09@MWHPR11MB0031.namprd11.prod.outlook.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-6-chen.zhang@intel.com>
 <20221212202334.ldrgv7fnkgjtsogg@desk>
In-Reply-To: <20221212202334.ldrgv7fnkgjtsogg@desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB0031:EE_|MW4PR11MB6933:EE_
x-ms-office365-filtering-correlation-id: d705a3a8-de5d-49ab-5553-08dadda8e36d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dwaww1bRoBylySoDDCuGoiL/FcmPNfL6Z7qepWN0wjpjZqTrPKXyu2yvl6OklH9AzhiWHCdLs6kiDsK8v6eMEHhgz9wtqAAM9EviP/qY/uszDRP0YLy8BqiewfV+tC2MLbRna2d/eeLiqS1ODdbFzMIQoxxnuqn9FtigFG9dB/pTDgG1t5izpdAX4qyxfKmJg8ex2DSJwMT9S6GDay97GmbcL8NHHu2o60gEqt+QAX1Quj2PztPRXsdiZkpTuox0M9RyzPIMo432h/FXpXSH7TlaZqIDyIewB04ISxrXTXFs0m7xS61FUcQ2xZAPWG7B/pyd9VmiQt2iIDS4bifkdq0XonwVs2Y4NtaEST6yfKMkN6muGXdTbob0UO0+PyslsyWRB1TJBmcpp5vFFuAkbPbKmNG5K2Wiqaa2kyH1qqU0hoRV4wAbWK5jg38toWs5TFa+UWZrxfX+k/Nizp4sGW+L34tQkC2apxodTxP2S4Mnk3/lRI6kX933e7Zy9yOmQfRAnE3AJ9VF6pH0lKUN3+8wvGu9jAYFt6oVtcKBlyXHUH7fUql2z+lS14hOsj4dC0DoQfK9p1rnMR9a+VAchizeixoH/xzGmhpX8tNbbfvEwkmLQpXWclCOgDoadaYF+daVe8jIJX95Z3FAeRdozFsCU1yMqbvKCJNXFvAOVBDlwRDhfoH9O5YddcqlCcVWxZDS/pDMQsmlX9ZxiDwVtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0031.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199015)(83380400001)(55016003)(186003)(82960400001)(2906002)(38100700002)(122000001)(86362001)(33656002)(9686003)(71200400001)(7416002)(52536014)(41300700001)(38070700005)(5660300002)(8936002)(316002)(26005)(6916009)(6506007)(54906003)(478600001)(76116006)(66556008)(4326008)(66476007)(8676002)(66446008)(53546011)(64756008)(7696005)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WoBuVwCR2FERK9hpCPIXAWsFsegT+/JAZNFZfnOcYDbKoYL3tR+j03hopOZo?=
 =?us-ascii?Q?CN7Kcz5oIUm4A5MZvIaPolBcgDxc/dmU+7FZwZ24LuJUYshn0+pWOgxZsQsG?=
 =?us-ascii?Q?ZoQ/sZNpIgleMdKaw3sGvs+tGTbPq41No16QYFlzMDkR4FYm70BuzTZAX1SI?=
 =?us-ascii?Q?g8br1OfzSmaxddEaa1cHUZ1dyzQ2m6oNXgoU+TDGZOWIraxZWxi+1NbOTEWt?=
 =?us-ascii?Q?+gmnJHsmF6p8T279NSnz3VhchF00xVT/+FKr7iR5IW6ou60kTqjbDnURpxj+?=
 =?us-ascii?Q?sXMDlSmKERjAd7KyKMZbt8tbIxRDBEgGi2LAvjz59lJ8Is6Bw9VfeabG5ZbF?=
 =?us-ascii?Q?y6OsY1JCvGbCdwuMdP4RrnErFUoYm/ObG17XC0yJm8oKnANpDjRXgLmBu0f9?=
 =?us-ascii?Q?ugt2ERuGVEl88xaVIfBO8rWHTtHYVo08q6azi/3HiuwP8o6fcGqDHnEmCZE0?=
 =?us-ascii?Q?Z4hP3nPh9qxSiE1SGxQg9hUni/c8SNNShSlHOAjiwS5EniGlcNhfOaDmF7AO?=
 =?us-ascii?Q?DK8jCODqZQVyTKFCZ1LEAaSyWH99EzSIVztMhI5axsjttQqzVvTHoiIy3lmT?=
 =?us-ascii?Q?q1EuPzEQgrpGTmfOnVkHPexGmAfiMeg3hZkwmrgf8VR0wLqFy6wwO9HC1apz?=
 =?us-ascii?Q?vCMQXOFMgPiHCFJX3AwPIt1Tu2ZOn8BVrU2V4viuo6T6llmc6zivg240ThiG?=
 =?us-ascii?Q?xg7j0grKHdiYLXx1wc1Z1PxPu+2xJQWcDE/evsiW1trCuW25FKWEdbQko0Vr?=
 =?us-ascii?Q?VljuNdh2TIMZYLd6Fhn4FKXmopfajsel+lg0Dk/2lPhvxuqdea65A1npeWLP?=
 =?us-ascii?Q?81/kGcA1p8x8xcSoicdg5wpdnbVGTt+3/orFXE/MA+23zyf1OgDFB/8o4uRs?=
 =?us-ascii?Q?c8qYndvGIDqwWVGh6EQvXgK3+/0sNbqLJ2MkicsbLXnIZkm0E3bHEMBO6e/w?=
 =?us-ascii?Q?hQlsKeyd9So0wyddXa/2Pp/38YqLXe5fbRklD4aK0p1H93ZPIvmEbxtRrhzL?=
 =?us-ascii?Q?FEFMJrnX3qHGBU56u4hKz96oi+IA9Tp+r+F+e5/YSyNE+px0vrry172IaLO0?=
 =?us-ascii?Q?cZDbWoJBIoYLiR4Kmk+XLV6R2vnidrnSTK5dzC/U/CF1EVFPnoIevMw6Y80P?=
 =?us-ascii?Q?jcWCxqAW27l9wBjQMznxG83BkKZBebhIXQjw0d5YOel1Z+euMC1b4NwbTADc?=
 =?us-ascii?Q?7lWirpPAFrAB2lLiDIsydX6duTXhy1g+puZ67iNYNs6g9IzycHxHut2jCThi?=
 =?us-ascii?Q?n72Ms+v1sh30ZLOny6HNQ0rymL6tLlgCNw9TFzZ8NYpTX1W3VEFhToAw+Vwq?=
 =?us-ascii?Q?teQLG1A+nw2YJGU0E1pHS3AWqhloSw0UXz46oyZpsuUsoBsBJcJPCHIg1pEs?=
 =?us-ascii?Q?tlNqGrYJaqZHYDK7r2ZAUU8JLZ1XwXkZAuJ5EJ1OO13KsJnS/ZFWkeuLvqVH?=
 =?us-ascii?Q?VDhgRPQqn65RQvBLcId0IQAx+82gtmbQiQn34Mu4dD7qH6oBSt/xpxPFkO+I?=
 =?us-ascii?Q?Z0IGAWJkECNiyiftp4rqr3k44a4baYMzQfSq/3gBzBEWx7ij7sOwiF8j5gIx?=
 =?us-ascii?Q?vhU/2DooO/4b2229WVQKz5ZUrk7c4Fj9nD1Pc9RJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0031.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d705a3a8-de5d-49ab-5553-08dadda8e36d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 07:57:46.5559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fyMWGQ6BRbNkcUpy90p3GhPdieV9DN8yvS4l+P/FgpyJtG/kpvbqM5uTQtaJYNIQUI8ESfoyP+N6Sv2GV7N2Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6933
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Sent: Tuesday, December 13, 2022 4:24 AM
> To: Zhang, Chen <chen.zhang@intel.com>
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Ga=
o,
> Chao <chao.gao@intel.com>; Paolo Bonzini <pbonzini@redhat.com>;
> Christopherson,, Sean <seanjc@google.com>; H. Peter Anvin
> <hpa@zytor.com>; Dave Hansen <dave.hansen@linux.intel.com>; Borislav
> Petkov <bp@alien8.de>; Ingo Molnar <mingo@redhat.com>; Thomas Gleixner
> <tglx@linutronix.de>
> Subject: Re: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardwa=
re
> mitigations
>=20
> On Sun, Dec 11, 2022 at 12:00:42AM +0800, Zhang Chen wrote:
> > From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> >
> > Guests that have different family/model than the host may not be aware
> > of hardware mitigations(such as RRSBA_DIS_S) available on host. This
> > is particularly true when guests migrate. To solve this problem Intel
> > processors have added a virtual MSR interface through which guests can
> > report their mitigation status and request VMM to deploy relevant
> > hardware mitigations.
> >
> > Use this virtualized MSR interface to request relevant hardware
> > controls for retpoline mitigation.
> >
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  arch/x86/include/asm/msr-index.h | 23 +++++++++++++++++++++++
> >  arch/x86/kernel/cpu/bugs.c       | 24 ++++++++++++++++++++++++
> >  2 files changed, 47 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/msr-index.h
> > b/arch/x86/include/asm/msr-index.h
> > index 1143ac9400c3..1166b472377c 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -165,6 +165,7 @@
> >  						 *
> IA32_XAPIC_DISABLE_STATUS MSR
> >  						 * supported
> >  						 */
> > +#define ARCH_CAP_VIRTUAL_ENUM		BIT(63)	/*
> MSR_VIRTUAL_ENUMERATION supported */
> >
> >  #define MSR_IA32_FLUSH_CMD		0x0000010b
> >  #define L1D_FLUSH			BIT(0)	/*
> > @@ -1062,6 +1063,28 @@
> >  #define MSR_IA32_VMX_MISC_INTEL_PT                 (1ULL << 14)
> >  #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL <<
> 29)
> >  #define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
> > +
> > +/* Intel virtual MSRs */
> > +#define MSR_VIRTUAL_ENUMERATION			0x50000000
> > +#define VIRT_ENUM_MITIGATION_CTRL_SUPPORT	BIT(0)	/*
> > +							 * Mitigation ctrl via
> virtual
> > +							 * MSRs supported
> > +							 */
> > +
> > +#define MSR_VIRTUAL_MITIGATION_ENUM		0x50000001
> > +#define MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT	BIT(0)	/* VMM
> supports BHI_DIS_S */
> > +#define MITI_ENUM_RETPOLINE_S_SUPPORT		BIT(1)	/*
> VMM supports RRSBA_DIS_S */
> > +
> > +#define MSR_VIRTUAL_MITIGATION_CTRL		0x50000002
> > +#define MITI_CTRL_BHB_CLEAR_SEQ_S_USED		BIT(0)	/*
> > +							 * Request VMM to
> deploy
> > +							 * BHI_DIS_S
> mitigation
> > +							 */
> > +#define MITI_CTRL_RETPOLINE_S_USED		BIT(1)	/*
> > +							 * Request VMM to
> deploy
> > +							 * RRSBA_DIS_S
> mitigation
> > +							 */
> > +
> >  /* AMD-V MSRs */
> >
> >  #define MSR_VM_CR                       0xc0010114
> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index 3e3230cccaa7..a9e869f568ee 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -1379,6 +1379,28 @@ static void __init
> spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
> >  	dump_stack();
> >  }
> >
> > +/* Speculation control using virtualized MSRs */ static void __init
> > +spec_ctrl_setup_virtualized_msr(void)
> > +{
> > +	u64 msr_virt_enum, msr_mitigation_enum, msr_mitigation_ctrl;
> > +
> > +	if (!(x86_read_arch_cap_msr() & ARCH_CAP_VIRTUAL_ENUM))
> > +		return;
> > +
> > +	rdmsrl(MSR_VIRTUAL_ENUMERATION, msr_virt_enum);
> > +	if (!(msr_virt_enum & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
> > +		return;
> > +
> > +	rdmsrl(MSR_VIRTUAL_MITIGATION_ENUM, msr_mitigation_enum);
> > +	/* When retpoline is being used, request relevant hardware controls
> */
> > +	if (boot_cpu_has(X86_FEATURE_RETPOLINE) &&
> > +	    msr_mitigation_enum & MITI_ENUM_RETPOLINE_S_SUPPORT) {
> > +		rdmsrl(MSR_VIRTUAL_MITIGATION_CTRL,
> msr_mitigation_ctrl);
> > +		msr_mitigation_ctrl |=3D MITI_CTRL_RETPOLINE_S_USED;
> > +		wrmsrl(MSR_VIRTUAL_MITIGATION_CTRL,
> msr_mitigation_ctrl);
> > +	}
> > +}
> > +
> >  static void __init spectre_v2_select_mitigation(void)
> >  {
> >  	enum spectre_v2_mitigation_cmd cmd =3D spectre_v2_parse_cmdline();
> @@
> > -1485,6 +1507,8 @@ static void __init spectre_v2_select_mitigation(void=
)
> >  	    mode =3D=3D SPECTRE_V2_RETPOLINE)
> >  		spec_ctrl_disable_kernel_rrsba();
> >
> > +	spec_ctrl_setup_virtualized_msr();
>=20
> I think this also needs to be called during secondary CPU initialization.

Yes, we need setup virtual MSRs for each CPU.
I will add the " spec_ctrl_setup_virtualized_msr()" to the "start_secondary=
()" in the arch/x86/kernel/smpboot.c  next version.

Thanks
Chen

