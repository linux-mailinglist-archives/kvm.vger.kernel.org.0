Return-Path: <kvm+bounces-2551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5687C7FB0A2
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 04:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00D10281CD7
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 03:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C44D532;
	Tue, 28 Nov 2023 03:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gueCwKXv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8140A95;
	Mon, 27 Nov 2023 19:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701142694; x=1732678694;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OzxiLWdU7TdwnD1nk/DN9kO+TmxF9qSAp6x4I8h9Vd0=;
  b=gueCwKXv1/qqisM9vsJ75Ue5MIs83O5AW3pGe+w1pHcTAOekiOuYFJnB
   i3L3gwhfp2+A/vIV28yW1zO+oQWvzHHIb36Yr158QhPNWTK/iLSER+o6q
   spDwPN9BU10kx2awj5xzBfUf55GoGiwYMwWYA9BeCppIJbRJJOef9FQkr
   jF7WpiNy1AJj4vn/y0FWcTdmw7DPm2Ep2ylK3OL0olqFWIjy4KLxipVoY
   M747S/n3oB809JObutByAClJZpJ04bdVgtdnThprfWd0G5p9LyWxMkQ1w
   PFxYU1pgmvasajk5cctizIWhV4mUCefDfyV+Fbdc8jQCaNjRNuYUqrmmo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="479039546"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="479039546"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 19:38:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="718251790"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="718251790"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 19:38:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 19:38:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 19:38:12 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 19:38:12 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 19:38:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzQT9/r4Zx0h6jtWCWZZV7ZzAeWCWOSi40VsVo6ks9JlK7MSIYHGhfqTd19o9OpayMcf3oeAWpx7+/jxDdFQMIpQcrwMUqeAA8rk53TrlzAjl9mXOypxMMxgquzsGJ7tiwwRBVstWVchzGRl57ZR0dcm0AxRqp428pBEU5qSSFwpLo/ddicfCZuEhPDgAhjRgENyqjrB557KdgCH7dIGd+gOBViK7XOoElArml5NRqsDLTHYE6HP9cmY2T37Ocz44n7P/R94rdLjf2aKlb0nR/CrjvgKwZ7VTyo9IJObcDRn8m3N7xvaUNhWQo9OFlZq8dRXjNcwvWusoR5F13C3oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrK1FBTdAh4vpijXCmP9xSwxnqRwEZNZbvHNS4Zf3lM=;
 b=AzNwUQW4j1aMkQRY5LnXD8QFW6ljgVLVya0Z32ruoUtlOIeVidy8X8GLhsLwJT6vcSy32yhAxTTnynHj2+N4Q6k8dpCJvhppMsPO2Qoo/diXy23jZqqVYicrsaJ4CWeU6jN9vPAGdQivazPI91OF1n+kGSz6sYxk70qNLOOWS7uLBJZhPPB3xyM+lpFLblYIWcY5igftlt1/cnaWY5lPBNT2pq7NhxJjQ0SqbHPLwI3IuAkXvDcRLPKoVfegPHmFZ2oqT9Chr5JZLa9je9QRRLK85+RLaWxrMfExLkwTVdcvDPLFixcz3Thi7d3/sVM7XkAEuD5fzZtQHVrx6lfFlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by MW4PR11MB5775.namprd11.prod.outlook.com (2603:10b6:303:181::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 03:38:10 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3%7]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 03:38:10 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, H.Peter Anvin <hpa@zytor.com>
CC: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>
Subject: RE: [PATCH v7 03/26] x86/fpu/xstate: Add CET supervisor mode state
 support
Thread-Topic: [PATCH v7 03/26] x86/fpu/xstate: Add CET supervisor mode state
 support
Thread-Index: AQHaHqwhldLpRuLT6kCCwsIg9mJjhrCJOHIAgAW/5iA=
Date: Tue, 28 Nov 2023 03:38:10 +0000
Message-ID: <SA1PR11MB67349E7AF635F5DCDF0BD9E0A8BCA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-4-weijiang.yang@intel.com>
 <20231124094502.GL3818@noisy.programming.kicks-ass.net>
In-Reply-To: <20231124094502.GL3818@noisy.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|MW4PR11MB5775:EE_
x-ms-office365-filtering-correlation-id: 4aba0673-af8c-4877-d8a4-08dbefc37145
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BzF8BURnY9vI0zR47Fvzyrf7pZkx7dRdTnh7I9DV6Wa75HCkxxKU/2ZtxOTuU4MSlppXyAXxLZS800lOHtWdnouBjrIUoUqJmgi9y8m778DEQcr4TmHDFbYPZaZXIgRvBHzF/EI1xijNf5PjhisarFq57Hn8AZmSUwck/z36Zq7DBmPgfW9RhGCnPowJ2KrVIrcAXwMkyUj2/Wj/si3KO802XYVdiZh1DSMdQvOEKTAQj8qCioouMD17Trv4gzyxsu629ilGMIB+2LRy4P3RnjT33owgnheBX37hP6kplljV55UXzezZORSyIwcQ18hkw9FZjJsdDEHoS8pQCFD7nLpWEIUIUrKKQCDQkSixkBjxUlgRPwGD8e0W9N4N1J46qWdGPrjedwHj1FVURtizHALgLONs/4+/oqpc4JQJ2enQaZ4RQIUw0yYqg6u0pQENPHvbcYtljolFwBHZyHFmAfqd/Ow0kMWT/84hpL8IUmLghqK80j31N8A1QvF1Xt9unARETkcISDKZ9EGcq4bfbbZeZNwWvnWlpT26zKfis4IQ2/tvmQRwHA6Dw/0f0V0w1FoIr5AwZK3tEQFHqifOy670rTVxL/+OYI6cCuKaT+pINK7r2xJnDHqWZqgBwIam
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(396003)(346002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(38100700002)(33656002)(38070700009)(122000001)(82960400001)(86362001)(64756008)(54906003)(8936002)(316002)(66556008)(66476007)(66446008)(8676002)(76116006)(66946007)(41300700001)(9686003)(55016003)(110136005)(71200400001)(6506007)(7696005)(478600001)(4326008)(5660300002)(2906002)(52536014)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jNgkfldcUewPhj2IvXVEL7rofNralOJqihb8thrC3kpg/FMVLaqSCaRvJBJO?=
 =?us-ascii?Q?WU/VDlCAgKXVVkMGWvt0GahEI2T1q7OOkVly8Syu7RIFPrDt88LlQoff51Rm?=
 =?us-ascii?Q?YJ74L6X0Pnku1vBbTzJnpyTzmGaA+Ctgxa4ikoHT8YbmvkQDRvoH/e+vWnlm?=
 =?us-ascii?Q?0Lrd+dvidXgVZYXuZz/T35I8xHJMl8FFJk7sHjYGKDr1x9dHOYf9PEkiiFQR?=
 =?us-ascii?Q?tna5b738zs9p43Egm1Rv4i4Y8Yw9CKV2jdRkRo9WDjY6TjmrYbkXg7VbXwkV?=
 =?us-ascii?Q?VEKrO0kwq8RvbR7v4IAD4JuKE2jwnCaXvKyxqXTDfHnMMnM4BSkwzBDvpCUy?=
 =?us-ascii?Q?m+nkq2M1taxgL2BE4WtQzx9dBIsq1qpYX2hrsR7u/yhKalATBZ368LDqe5E4?=
 =?us-ascii?Q?nKkYYtpxBG6xGnx9JukrhanVxlOljgya8YxbpfriuTGRu+5mBji/gUv3Kkmo?=
 =?us-ascii?Q?CIKiYa7/596CzjWxoQ4/LfqpVcN3Ck1XVRjj0YkkSRSu1+cga8/N+dbmY6+1?=
 =?us-ascii?Q?azd2BOjtyXcgfYi4ymwuC/aTFesUUdZPe8EGoktb58hCU9Sag1MFkIYZQynW?=
 =?us-ascii?Q?1LQkjcZNOhwMUHFDLk3zZJsQtJtKLVEUNOxqzsueecE0wWsQa0hUKZkyWPVY?=
 =?us-ascii?Q?KjVIRlBGaDhB7pCGenIky+MnPnpjAuXvIysxA04x7xOy0hY8jFJz8D04iUD2?=
 =?us-ascii?Q?rIrUBA+BNUTuln1wh5VtGjtI9ElNVcD0SIgvmx0zzvoI1JRUKx907rmm7J0B?=
 =?us-ascii?Q?Ozsm/C2eVKc/M9mekmp3ebDe3Ah+KTvgEDUXqJBTo5XjCPvr8s3kNEyESwyL?=
 =?us-ascii?Q?GnIsIdKMETKXR+kXcBVrUHeoqdS91ZTBZOhrcrE+lpZZrJW+gWgcgr3FTTmE?=
 =?us-ascii?Q?Seyg1TIAgWmYASwHhhYbcns710i01SDGfpy/FjvmqzzSWjZAXN6AOCaBp9eg?=
 =?us-ascii?Q?vhiFciLqrJBoQXs58frOTLdtsXBrqDjUdssErN3F1yuHedPFwJvQEXf9+6bE?=
 =?us-ascii?Q?053dPzc6RWPH08H2scBkMvwlQyT0V34Nuhjxa73adLP5PnqUEwhxto7wYkcF?=
 =?us-ascii?Q?I8JAIsa04WYVRfBC11zLAGP1dPeARI2b+w5ahPBeai6CzMvlM9IYMymtG1a5?=
 =?us-ascii?Q?xgCItlOkfR5mBfQryRbxlxLgCTQoYQEDfbrFSc31DEpvX1PHtM+28ySlVhS+?=
 =?us-ascii?Q?6FJ1MTZqxTMQrfT3KP29LbuByRATxBDu5o/mbAnuxe/Yq1dUfBnYPieVZGhy?=
 =?us-ascii?Q?PuAAQswjTGj2HPqdxF62DXdmmf2+yrAtN6N6YcrDp/SPnBOBHcfZwqNtJ+wa?=
 =?us-ascii?Q?pr2CBIPm4XcK8aHFsMyif3qpdpmGActBoumgayyO9DiXWETtDrOsBsnYJuIY?=
 =?us-ascii?Q?8M7uANG4ZH6RLksrO2X1TflSp3/xwZRZQRVqSePPcBI/Gnz4LF+MpXVcUfLJ?=
 =?us-ascii?Q?cQsU5CpvfnEulXBgj+clZm9FBiOmDXS2iw1uFM3zmofyiTviGYMDhJAxzciP?=
 =?us-ascii?Q?mBj3W0LTTaJfl7tqzz2/Lixl/6QKTnPVfwT//71BKTVBPKi5iRfFDDtYKG5h?=
 =?us-ascii?Q?GIEJVyGJ7T4XPXbzLLw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aba0673-af8c-4877-d8a4-08dbefc37145
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 03:38:10.0581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxVR32Z8cPQQOLMmGCs2++EMruUM6I4YZ/y2gcoFa4HrxyxYSlzBxheJn5bf/JCTGAVL6ADJGPd8e7jtnhV1Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5775
X-OriginatorOrg: intel.com

> > Note, in KVM case, guest CET supervisor state i.e.,
> > IA32_PL{0,1,2}_MSRs, are preserved after VM-Exit until host/guest
> > fpstates are swapped, but since host supervisor shadow stack is
> > disabled, the preserved MSRs won't hurt host.
>=20
> Just to be clear, with FRED all this changes, right? Then we get more VMC=
S fields
> for SSS state.

The FRED spec 5.0 adds new VMCS fields for SSS state.  As a result, minimal
changes are required to enable FRED for KVM regarding SSS.

The FRED spec 5.0 defines 4 MSRs related to SSS: IA32_FRED_SSP[0123] (
the numbers 0-3 in the MSR names refer to the corresponding stack level
and not to privilege level).

IA32_FRED_SSP0 is just an alias of IA32_PL0_SSP, while IA32_FRED_SSP[123]
are new.

IA32_FRED_SSP0 is referenced during user level (ring 3) event delivery
only with FRED, thus it's fine to run KVM with guest IA32_FRED_SSP0.  And
I think this is what the change log of this patch tries to clarify.

However, with FRED, because IA32_FRED_SSP[123] could be referenced right
after VM entry/exit when SSS is enabled, VMX adds new VMCS fields for the
3 MSRs in both guest and host state areas, and does the IA32_FRED_SSP[123]
context switch between host and guest during VM entry/exit.

Got to mention, there is no additional VMX controls to have CPU save/load
IA32_FRED_SSP[123], they share the same controls for IA32_FRED_RSP[123].

So I would say, regarding SSS, *logiclly* FRED enabling for KVM needs no
change besides what are done in this patch set.



