Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD76E652C68
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 06:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiLUF3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 00:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiLUF3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 00:29:30 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2D8C01;
        Tue, 20 Dec 2022 21:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671600569; x=1703136569;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qyQ0bPXDeGidyrNdoJpzdAwjtmjPFUPcdkxX7wuInek=;
  b=WkACtjeTa8ZXjUADtkpM59Nem5JNImFiE+ZeOImq/AMgy0b193UGHFX+
   1nRXhGf8vxryOPTUb8ULwEQul0Nlno4Mb3ziwF3MApsMIw3zsZY27s0zr
   QsoV2IM3/IzQQb4v1ps2ai5bO87mbO4fJeCZ/nMWO4IiIB+57FfvRkyLg
   EM0agnl998/yk0h1hQ5vO9RjJEOCuzx9e6IipG069mV9+3VLyTLYpFeLQ
   N5PpwGGTK0kbYLloauKoJHD6A7ok4PsEDeNNPSuK51OoZ6YgvDuP3AYWB
   VxEaBI3CkhwvolB/t4dgX1dTSTMxlBzliv5scr5W/BXcvYwRLI29FWPKg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="346911398"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="346911398"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 21:29:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="896742467"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="896742467"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 20 Dec 2022 21:29:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 21:29:28 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 21:29:27 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 21:29:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 21:29:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkHuMqCwCR6Ml7RFG4wOaYMT1oEAf/zD4TGe+kkrp8nrTdrD6Ad3wesUqB71Q3fnq1BrR/Kb+WxLV4d+6OXhoY9bd/g5hL+RJcKGF466Uv6tkMwug557ZMWREOwuaCw9+hOfnqs5tJvMUygZkHcwjTtD6QYityXx/WtwLiPq3EDV2ffSFLMWhN7zl3a/KwEzN/g/dXSzEccwhrxDDwqr1/KOsFjn2NIoaKsI00hKJ5coVXeCyj6zLEtWl1IxNw2qaXv1Lw9Lc67asMrCT0F8e8Ak4mPN799fkMoI2M1DfHYxp//+3nCCFuitbPxx0UvTDJgST2suT8MQSsmILxmOUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSiK6MKrHLlV5/PiAOoD0FJ8s0CRty1S9J7NOnbw+A8=;
 b=Nc1T8yNKXsnxEgEHBTcmzvC74k3ZjYgBT9ZU4Rf857T53kNF1C4ErIMQwWGd1PhxANxUxOPikkqxZGkR72Cp//zYG9xSI6pyyeF1w69ifpnl9aUf6ARNXiZVW6YGt6AH2ma42OFoM89v6JQwxXDFpPtKTpjsJI3XzE9Vwu3ZwOLNbEtRod5yXdeNn71MEJTgqMRmB8Leam0lJogweVopnjq7vZzU0eM33OWMAnWNKhsomzW544tXGviQlfxEfBVqEJx0Rr6yEWETQIpbxEnfqIc2bxu+Ecuc7DAXCqS8SYqIWkmROESH4P9Rj3Qcjl8a3GPLanig/atvRNdoWLUZqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 (2603:10b6:405:52::15) by CO1PR11MB4993.namprd11.prod.outlook.com
 (2603:10b6:303:6c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 05:28:52 +0000
Received: from BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130]) by BN6PR1101MB2161.namprd11.prod.outlook.com
 ([fe80::5cbf:a669:456c:e130%6]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 05:28:52 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [RFC PATCH 22/32] x86/fred: FRED initialization code
Thread-Topic: [RFC PATCH 22/32] x86/fred: FRED initialization code
Thread-Index: AQHZFEEuSpGeNAxXE02epndn3lbDCa52hwiAgAAC2YCAAAH1gIABQ0VA
Date:   Wed, 21 Dec 2022 05:28:52 +0000
Message-ID: <BN6PR1101MB2161C51C6068026D9C442460A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-23-xin3.li@intel.com>
 <Y6GELyEJeKY3dEqJ@hirez.programming.kicks-ass.net>
 <16972e64-7d7b-ad8c-f8dc-6dcab69e629e@citrix.com>
 <Y6GIN5Uf7Qd43A9U@hirez.programming.kicks-ass.net>
In-Reply-To: <Y6GIN5Uf7Qd43A9U@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR1101MB2161:EE_|CO1PR11MB4993:EE_
x-ms-office365-filtering-correlation-id: b0e36786-5c71-419a-39d4-08dae3143f08
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1unRo+ly73hYIHoq5hmD2Za5dKTbtTFlgh0YZWMTcxxRC3Rhc6buqDAhZbnvxUsy0mUjBJCi1PITg3VFshmB7ule2pTnE81u1FUqE84BYk1mGrBbF6IAi1Drj2jDMVxQmZVAviNGjY7iRB17dmeWDjdFzxzpIPapYFv5LwbMJa+dsggN9K/pLlW4kzhQnCkAJK1JBA0cWu1o53JrCKYbYztwzUiRdiTi/V6MJ6EEJxvd9KsyKGHowY5sVQLqqiANLh40m8b0W40x7HpUbD+QSJFxrOcaXDHyj+C6I8PvaWOpQCz2vjIeag4s3mQ4r5JDLhZuyOg40L1diQOF52cspJerp4zgeIE8lslT+M3EqIK4kIUXHjWa1XfJbpZbdeJlw80FR/mCK/VPSoKkISzlU0wbFSI4xJYW7mZmReImaXmWIVAvM0leGabOyoUC0z2GMRugnRGrYK1KMj1WOx1UKYEo2+MFTIqexPTIQKH8084cQwNrYW/VBjOh+QaPNWgqGRSWRwU98nEJvcdDdKz2XJJZN90qZTym3QLRp/yTeF+/EHYQGq80wVJJ2wn+SRCxt+oJ1x9RnUdJxANEdAD/zNF8M69/PIJb6PqHVNBAeRNzKMYfoi8AxPe+Ck/lp9S6h2I8oNLMdL1/PIUAOaraXh2TeYxhNEsnOHrQrudguVEQmTsqMiXR2hiedTnyKOV4HETFprou2F8euH0Us89C/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2161.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199015)(82960400001)(66946007)(316002)(8676002)(86362001)(55016003)(66556008)(66476007)(122000001)(38100700002)(4326008)(66446008)(76116006)(54906003)(110136005)(64756008)(41300700001)(8936002)(38070700005)(2906002)(5660300002)(186003)(6506007)(26005)(9686003)(7416002)(478600001)(7696005)(71200400001)(52536014)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?B652j4Ammo0w23NGj/BOqCC/SoT6jqt4uisbHO8D9+udj6sPZ05pRXLx5V?=
 =?iso-8859-1?Q?GIj7PX8Divp/ECiAQpynqGv+v4CJIlESzRJa3Cd+ajA/BwsvHUDeHG7DD6?=
 =?iso-8859-1?Q?ZKAGCym8lFjmKN6Zi1REzfhmAgaMuSYt/iqZD6gCVbl8r/+e0GfA4pV9eM?=
 =?iso-8859-1?Q?ov2Dy0GxDomqPXmhiwq+b3wGw0ww/NPUD6KK+hPd1VX64eYjGNA5DYifoz?=
 =?iso-8859-1?Q?+FJGgurtbRxhD7rrK0KzmCSgrdeldH5n3gVTMDTxbWT1wBrRQW/tZ3rLO1?=
 =?iso-8859-1?Q?H9SMQtWuEV/RTB22O7dNPfMFPueYgFu4DTc1ph+1aBfoSzBAaeRFrWMBGF?=
 =?iso-8859-1?Q?PDyv5GbBxMsiTN+oBPdUwneH4CglT3N/a1FHtGaCS519c+L9uVNb5z1Ooz?=
 =?iso-8859-1?Q?B0PRHDC534uBEr2kudTBM3cip+o4bJ/5emXrdp861ssuvyUMUCzSwRhEnz?=
 =?iso-8859-1?Q?HFkUVz18ytfBgFzCXdM0ne64vNnsWcezi8CuqIyCoGWRZNAu9xEF1eYxYO?=
 =?iso-8859-1?Q?ckoOgBtUbDimxC/q9Fif0M852p9wGp4j9edYO5TQlgYoKaMkgIAE/IlXkp?=
 =?iso-8859-1?Q?ZHSF6AQk8JLncaos0BiEz0JUibtoY5NARMQEO1y9yHbmSsMjZ8JiGp7u2v?=
 =?iso-8859-1?Q?1DubLuN5M/SncEVOEevA0sz6Wqcpk9IkYFk1oNH5KnfOL3WfWakuPECwbT?=
 =?iso-8859-1?Q?JlH36I5AeNmw+shYZqnS0V7Xu3PCVZBk+26fyRUZZw3EuE+uKegWXdq5XZ?=
 =?iso-8859-1?Q?0mtdkC0kDkORm2XbT4DXU94hWPzt+h0PWx75rLuC0KuTV1ZJWe46tNiBEZ?=
 =?iso-8859-1?Q?p1yGoP0Z/f4+qF6g1YG04EJ8JgHALu4ec2IqsQcvk8qu1yYZAcOU8xNg+2?=
 =?iso-8859-1?Q?ZZBJMWZ6ntLKt6jLQbwcC2ioYkAO2m4FKmL4n9hpKfesqMgKNZM/LQBWgf?=
 =?iso-8859-1?Q?wjCAGRcaqK5K+166Dss6ka7r+D5AWHhzovhLf+HpQDUGvUjRwjpvA8L2vd?=
 =?iso-8859-1?Q?CD59D8MbNAjgLxd4dhKOfmhhi0Y4jcu0PK/yVgp4nBQBzgoxv9sRbJXo44?=
 =?iso-8859-1?Q?A0WgY30fv3u4WlZ4sRWpfD3Yl4LYVhZRH3LRCR2YDCIjDMkHHLo4k5lIOt?=
 =?iso-8859-1?Q?v2fJI4HmG6BXQ8IBuRB3yh7m1uzbuX6yFVzXlm788POm+1oZo1GRIXlFnc?=
 =?iso-8859-1?Q?RrE6J5vy/HUni0+gF/SRRh3JcyPka8JuSmCicfG8qrTSKZPWJJS5NYKxRH?=
 =?iso-8859-1?Q?669grlwFMs+K/5o0nir8A4794KpZiXIEQptQsJksTgHYQdoxi299BHPZ+G?=
 =?iso-8859-1?Q?d6zVTyqBYtnqoRwplbSOGJYTSbMPFcuGQVn+aBXSdWPFUu6FB3faKx8Uf6?=
 =?iso-8859-1?Q?iMfKGU7kVQola73P2/m8Ku8CCK+a9zl//SbTcTPmWAoGNeX5vYzc+f3KC8?=
 =?iso-8859-1?Q?1Xh0z9UKsXvy1+j3fbVYXYZITYHNQyDWkm9EyzsLLE4j9dcJsK/GNd+Qb9?=
 =?iso-8859-1?Q?SkRZOSThGaokAcx2ir5FYcgGCJjfpoAi0wOFTqf4Yct3X6ijx0qAxZZSPK?=
 =?iso-8859-1?Q?TE8ad39Bl49gv6CJnWBcUDClV7HJbYTURBuTlYSzCRP6ro3qfyxzvZhUho?=
 =?iso-8859-1?Q?UtOQFUG75P0wwff+PLIw+yPtYcU3cqrKLn?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2161.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e36786-5c71-419a-39d4-08dae3143f08
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 05:28:52.2076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dI6UoIK90K/FaX9bbpCkYw8SeFcMVG+WG/5RI/aaSXikDYmrURIqOXpTyo8MSiGCqj8PPAAvFc9wQ4HrOPG+rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4993
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > >> +	wrmsrl(MSR_IA32_FRED_STKLVLS,
> > >> +	       FRED_STKLVL(X86_TRAP_DB,  1) |
> > >> +	       FRED_STKLVL(X86_TRAP_NMI, 2) |
> > >> +	       FRED_STKLVL(X86_TRAP_MC,  2) |
> > >> +	       FRED_STKLVL(X86_TRAP_DF,  3));
> > >> +
> > >> +	/* The FRED equivalents to IST stacks... */
> > >> +	wrmsrl(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
> > >> +	wrmsrl(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
> > >> +	wrmsrl(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(DF));
> > > Not quite.. IIRC fred only switches to another stack when the level
> > > of the exception is higher. Specifically, if we trigger #DB while
> > > inside #NMI we will not switch to the #DB stack (since 1 < 2).

Yes, current stack level can only grow higher.

> >
> > There needs to be a new stack for #DF, and just possibly one for #MC.
> > NMI and #DB do not need separate stacks under FRED.
>=20
> True, there is very little need to use additional stacks with FRED.

Pretty much.

#DB/NMI from a ring 3 context uses CSL 0, and their CSLs increase only
when happening from a ring 0 context.

>=20
> > > Now, as mentioned elsewhere, it all nests a lot saner, but stack
> > > exhaustion is still a thing, given the above, what happens when a
> > > #DB hits an #NMI which tickles a #VE or something?
> > >
> > > I don't think we've increased the exception stack size, but perhaps
> > > we should for FRED?
> >
> > Not sure if it matters too much - it doesn't seem usefully different
> > to IDT delivery.=A0 #DB shouldn't get too deep, and NMI gets properly
> > inhibited now.
>=20
> Both #DB and #NMI can end up in perf, and all that goes quite deep :/

Can you please elaborate it a bit?
