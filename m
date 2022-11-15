Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABE76291CD
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 07:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiKOG0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 01:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiKOG0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 01:26:09 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3053E1EED8;
        Mon, 14 Nov 2022 22:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668493562; x=1700029562;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1PHSc28MLoqCNxc55bftmviMW6b76byQ3VC8Hj66d3k=;
  b=TAdMuLmyShPsit90mY2ntkEL+4TqF1LvL6OvZbLl1Y+JPufYOKyl61E5
   TDWHFyOIwzX28Otm7Ai4Dro/IQQyPfnP18u0gqCUGC7vEHFATAmQtqHw9
   HuT0k2iS5F2HRQ8EN/sDpzTv1vZg91v3yN/k5Ihnz5pVa5qG4035e0cg2
   xHBo3rwRpabhtuy7erCjgQPqUO0jwutCZpm1hcR0xxC8Ts80yv0xVxZNT
   2UiJZJIclZWlpERcw8TyryEpkuRziH5HVIvezdXHkJ4SdRS9Uwdi07Yax
   9z7lgQ7DZdXNcISJ8Ku76x+qEVmk+/Q2fERoxg4EQwN25RfMqywRrE8ir
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376442996"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="376442996"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 22:25:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702314830"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="702314830"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 14 Nov 2022 22:25:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 22:25:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 22:25:31 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 22:25:31 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 22:25:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cE+eUcceiJGC7bGVRqE1h12eVYNYXuAEwkUOZRWApxqnOkNFtoa/w0RPa1T9ohpys1r6pVWqkpwVfkc33Pqo4RuCkxK9OCqtpUj8Tg8oy1RBeAjJkSVDMGVmQVV0QZv9ui2KkWh2DYztSdjAZWHL2u1SAOMC9WgxzGUsDkHlQoV6ZbQyjfE/fYM0Rs6pWuQNnrYHkDaT6X/MGEIhpVYzAcPgGHphRKYk81lwhcaCuso2DtsX3O5GEOR6xK+3C3+nFZD3yc8R0RjRXauLXErxz7J9jhBJC5PsMxYUJWhn0ivkku/prq89GSVLNUusqUinPe2694GpYAC299RyMw4suQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4u529f7URe1ZPrRiFESVla3tw1q+KfhBaF7xj8iP/M4=;
 b=T+4ZRyFgGd6Bes2E6rsjedk2iQTvPD/RgGx/yokFPUknOQNtUhzRVa7mcnLsYGurwKi3hhFPKbN60WbBDUlsd/DIQ7G3r7UJhRQVR2nSb/HGDhp1IjoRu3acynp9YttDwebh8EzPbcLMlL+uLRUjj57igB5tKXwvGYyNtbIiBS2qRc2C9WLIqs6KzU36rTygJCHApy73+JWAKa8wgK3JAaIRr+50GK3LuU/QSNLOrAZS014XM2x9hXWi+W9pdqrpAsLWeAZrWNxtoPzXdu+o3E/Qtc53EuJ/CDyTLQVfXKeggNbSgjq29qL0Cn6Gj1HNKNVXC7d3EG/eE9/eNzMbgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13)
 by DM8PR11MB5606.namprd11.prod.outlook.com (2603:10b6:8:3c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 06:25:24 +0000
Received: from PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::83be:d8ee:31bb:4814]) by PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::83be:d8ee:31bb:4814%8]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 06:25:24 +0000
From:   "Mi, Dapeng1" <dapeng1.mi@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
Subject: RE: [PATCH] KVM: x86: disable halt polling when powersave governor is
 used
Thread-Topic: [PATCH] KVM: x86: disable halt polling when powersave governor
 is used
Thread-Index: AQHYyNSFRsRhvKGUt0S7LgkC+L5J3K4DWToAgADh46CAG1uagIAgTX6g
Date:   Tue, 15 Nov 2022 06:25:24 +0000
Message-ID: <PH0PR11MB48245F82B9F5352878FD84B5CD049@PH0PR11MB4824.namprd11.prod.outlook.com>
References: <20220915073121.1038840-1-dapeng1.mi@intel.com>
 <Y0BnKIW+7sqJbTyY@google.com>
 <PH0PR11MB48240C29F1DEBC79EA933285CD5E9@PH0PR11MB4824.namprd11.prod.outlook.com>
 <Y1gXseyl0f3IUnDh@google.com>
In-Reply-To: <Y1gXseyl0f3IUnDh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB4824:EE_|DM8PR11MB5606:EE_
x-ms-office365-filtering-correlation-id: c5d9e427-fbe0-43ca-83e1-08dac6d22e0c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ed3Uh+EHuAXlfGYbm1wBtZQbdgSVNpVJj+YLCqXLmddF+htoV/goxvUbjfjrYPC9hwbolxjgsJWF/TApYvwxlBUoylpPVoF4fKYC2KVDYEkAfCp08al8NMs973eQz5Fer+ClR4nle02DKdZOlkEeKdmRyiExs2LJHty9ljizUhdx0PQ2NxgujyAJ4IwKRtBj4KeJoAd17/xs5LJzaSOv0L8FsfprEhzwDBw6Q+0PjkC7SzTpVfSNkj8kf3BIdu6Axia/KYAoNurooQaTOvZ+DvfZxM18Wqi3RZ9ckZvaWAt6If58iHhU1AHZ2r7V3dXS77VTJKSE6XECsjlJSBrDhAye1NRZSxYz99Z9HZffc3HFxrIpnvYqzAVtzE9e+1PRbkgd3bXEiUs5r0o15W8gYFZw5Eto+pPhnJkSBpmfWnY+/bOz0rudaQve6zZ47CZFRJLH4AO6x7T3c1ZAlATGOL4zn5lbnkYmlKoxi0kFFHQ9wNYYWxyMGJwIbO4vWCBBZgI4RE6n/MEd88gvG/p1sYG8+z7M47x21ruAWtAJ4I+ilru0n3UcTFDa8A9djdb3DR5M3cK6C0kihvEqkIvwfdU/B4BZEydhlKPB/DMs6qLoMOhB//ZEEbV1jKqO2QIVT5eoAhlW2MXIa8nIeypQhoRCVunx/zqWNEx+x25UH76J+OuPS0+E+HFsDFIG960PDF/bqo9lp3Si8gN5hBPKT/Iig+TCidKJ7vjBQY5t2V1MrcEqC9EQlAS2trLlXFjkXn2YQLfEnFL7oNtBJqsqeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199015)(26005)(82960400001)(9686003)(316002)(86362001)(55016003)(33656002)(2906002)(41300700001)(76116006)(66556008)(64756008)(66946007)(66476007)(66446008)(38100700002)(8936002)(4326008)(8676002)(52536014)(5660300002)(186003)(122000001)(478600001)(71200400001)(54906003)(6916009)(53546011)(7696005)(6506007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aN8b7m1aFUwS4LzT2MV1ABA3FZ8NaZsgtEnUM/br5HFEQ/UaXZ4ztfhx/bYs?=
 =?us-ascii?Q?0O+MwCxQMi75V71RI8wI1BM4aejDR67AlO3JJkhoTvX50shCxw/ZtoJ+OaGI?=
 =?us-ascii?Q?FirzVmaFtx/84rSMYw8gFfj1IwCYWsHNK8UJbpJ8K9CTo3O/uO/1UjjX4VeH?=
 =?us-ascii?Q?q40TTh+Sz0jSYYEjFDEbYtdM8hZhKKSdRfNhOU7OTbgb83VIYJbRPBRsRzxA?=
 =?us-ascii?Q?Zq8DceDcO3iUS42wuIxFc2aI4b2OqJf/xEfk9u4Ig+ictkJAGLOKNnztS3tB?=
 =?us-ascii?Q?gMEnBOgP6lp5aTj0TqTedPqNn4gjzhA9xCeTomyU8JGtltGSdS4Z/BG3752F?=
 =?us-ascii?Q?CJHJMRPUJ4CbnUfbmJHG9cP7PwylGKLzSNX1Rd3Ty33FxTW3i0XOtKwqKgXo?=
 =?us-ascii?Q?WbbRZ/nm3yLGQTwGMUZU/mBMfeRM7pMdCKV82qC0pRTT3tAb+5fNAkQYBID+?=
 =?us-ascii?Q?SNfv8SKrJHtJlzEiSj/O+TyFAKpsJ+iPVEr8nmXUle/hq2Y9rhQl/54MUDiJ?=
 =?us-ascii?Q?Bfib1HVYx8CToWEkA17giyUt0S3uWxTwiFBS1Rqb6BS6z8XEXCNDbBMaHQ7y?=
 =?us-ascii?Q?F1+vZTOF+ME3LUez+DtZz+Yl8gnnSOqpx2GRZND1WIcQoZtoQ7lMHuPM74MC?=
 =?us-ascii?Q?RPnJfHKnmGL+/qgQ6drvF/d0L9IQ4tUcqIFo24WGkOP1KDXCUzkRfCHMHZ9D?=
 =?us-ascii?Q?xBt8zllmCCC5mgrAIMMFE6WVYN/gLV0xe+F8RJv5a5G2Mi76wQTaf+8oxXDf?=
 =?us-ascii?Q?iwpG8GWhue8Qu76mA0QTQhO8mjUx3S4GYuKDbO/dG5RKYKD/IquGPPBwdblD?=
 =?us-ascii?Q?JuDRpOQ3oOzaUSNRP/CFVdj9q1vCT6iKc7ucNDtWtn0KHCnbD++yQKV6BdYo?=
 =?us-ascii?Q?sNON0OE2GipdVpYCgdmz1jzbiyKs3V43UoRrAv3ES93RB05VWeTtc5ArV2Kb?=
 =?us-ascii?Q?uDYcGtRemROOXlnsivhNeSnOT7V7o3/A6Qw7713YlQ0Kxo7ntkuFqjwd2pDj?=
 =?us-ascii?Q?ROwFyA7nQSxxBuKOrIur2Wbqb0GQNfvCbX5USEHOrzpvTo/S05mo0QaY6Jhj?=
 =?us-ascii?Q?O3TUnlqf8I/VrP4OKJHntUdSuetmSdSLW5Eb16h09Orpk3q8V2mkZVGkzrCS?=
 =?us-ascii?Q?bEFqY0/umyqMOwIgH1+sFskpon5z6xffEnhTIz1bMe6Jd5vytlxKTUmn9M/Q?=
 =?us-ascii?Q?11fAafoyUv/hej+DOFvmMfB+3jqPVFQR8WZDyTnYQET8K6n2cR9MEHrzl0Zb?=
 =?us-ascii?Q?vzZSYFXZftyYIQMLNryD/cZXZe76QJlvbVGuQQrBbnibyvmMmOGpqbEdQG9V?=
 =?us-ascii?Q?Do4F5X/aRlmfQlTk4/1zOb3G+3PnyS6AsKqdC9EsTZN7lGQigEzp2aEFAWg5?=
 =?us-ascii?Q?6tuXza0oNv5WMQ/CbPqF6EgBadFacMAwJvYkMokJbJUAXefq732wuYlD9hpQ?=
 =?us-ascii?Q?J+XzaUyaGUgBUB6oLlugkeObdsDwKxwd+zlG+e/Fh0UmM7mmlIOtV1TSC/GF?=
 =?us-ascii?Q?w+bCR3w6xg/8pSFVLtGarX1XK3tZsYsWwctexO2xPvqnoXsOHGgWhydYfYYs?=
 =?us-ascii?Q?6qsBgbCCxEjKLEv+ea7MYuVBN0MH6s/1rdip/OAS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d9e427-fbe0-43ca-83e1-08dac6d22e0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 06:25:24.4194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D4ta8OGC702CLYZ1BP6DhG3FRQNq9pwM/U9y+S+slCQHUJkqbBL+BQ5JB0NR0rdVGr+Xoqf21TaiR9/qWTqj1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5606
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, October 26, 2022 1:07 AM
> To: Mi, Dapeng1 <dapeng1.mi@intel.com>
> Cc: pbonzini@redhat.com; tglx@linutronix.de; mingo@redhat.com;
> dave.hansen@linux.intel.com; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; zhenyuw@linux.intel.com
> Subject: Re: [PATCH] KVM: x86: disable halt polling when powersave
> governor is used
>=20
> On Sat, Oct 08, 2022, Mi, Dapeng1 wrote:
> > > > +				!strncmp(policy->governor->name,
> > > "powersave",
> > >
> > > KVM should not be comparing magic strings.  If the cpufreq subsystem
> > > can't get
> > > policy->policy right, then that needs to be fixed.
> >
> > Yeah, using magic strings looks a little bit strange, but this is what
> > is cpufreq doing.  Currently cpufreq mechanism supports two kinds of
> > drivers, one is the driver which has the built-in governor, like intel_=
pstate
> driver.
> > For this kind of driver, the cpufreq governor is saved in the
> > policy->policy field. The other is the traditional driver which is
> > independent with cpufreq governor and the cpufreq governor type is
> saved in the governor->name field.
> > For the second kind of cpufreq driver, the policy->policy field is
> > meaningless and we have to read the governor name.
>=20
> That doesn't mean it's ok to bleed those internal details into KVM.  I wo=
uld
> much rather cpufreq provide a helper to get the effective policy, e.g.
>=20
>   unsigned int cpufreq_cpu_get_policy(unsigned int cpu)
>   {
> 	struct cpufreq_policy *policy =3D cpufreq_cpu_get(cpu);
> 	unsigned int pol;
>=20
> 	if (!policy)
> 		return CPUFREQ_POLICY_UNKNOWN;
>=20
> 	pol =3D policy->policy
> 	if (pol =3D=3D CPUFREQ_POLICY_UNKNOWN && policy->governor)
> 		pol =3D cpufreq_parse_policy(policy->governor->name);
>=20
> 	cpufreq_cpu_put(policy);
>   }

Thanks Sean for reviewing. Would do in next version.
