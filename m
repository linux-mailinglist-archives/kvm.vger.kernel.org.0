Return-Path: <kvm+bounces-3757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 749FA80787E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:19:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3B88B20EB0
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DCD66EB41;
	Wed,  6 Dec 2023 19:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kyOl5syn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BD88F;
	Wed,  6 Dec 2023 11:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701890373; x=1733426373;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1vQS6ukXMcuLdTbdA4YDtCeJQ34AsP+y7V2Za/Q1wzI=;
  b=kyOl5synB+eiqCGlOrEFMc2YxVOjJI998+tr2bGaxg87M4/J9bc+Fgwm
   eP9xFsc84HqcMME0UPBFmZeIZHYq8CThrOY3txEUfFRuuWDMBC1nENvyQ
   u7Y8lLkkiNfeTsaJ8vo/rY4Seq1rIzNByTcG6u7c2QyFl4wupFoWgH/Rf
   BmWkWT1VBPIIPu/PwBpQ0gT+p+n/8+IPZ6jLatTZWvMYgwcGJdd36rURL
   lzi0Q6AJQjL3DkmNqEcHSLlSQXm5DBRQccTuY0h5110e2V+3zwNJXU7i6
   qrSTzOVrilA8aKcH6kJ54LlUQYq1SRLbIrOUPdTT4lEmpGM02M9YKmXoA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1212841"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1212841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 11:19:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="800449550"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="800449550"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 11:19:29 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 11:19:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 11:19:29 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 11:19:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jAL2vLDRkzFPXAUZoi9fDSf05OT9E3jySM0rs44FXSW0doVTgbB0RopGgMDY/+qz94M414BLQs4427Qr5/NQXXcq84LtKi4+PiJvEEuV5un2lPfDU3y9yVCljj7PlDq93NV/9EOXSaNEIwr8dYqmTF2WaqdQSmJitTastQiitZ7xigWQQ19dGHJRUnCHtavMEz6jvGIyAOe3uy7FlCub9uvpsEtyL1EXIy9hEeNbeNYc2EaTqyCfevwwmFDAHld3Mt177rWCTGGY0dilomt2HUYQF07om8jlxvR5vSuZkbz9nYmn2gxJdtbkFjVp336ve5Ze5MKqOrzUjxDrE8nB4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vQS6ukXMcuLdTbdA4YDtCeJQ34AsP+y7V2Za/Q1wzI=;
 b=S1Z2ZVz9BiacI4YtZcnn7lGDpGFxalTLLikTieaaJ7b50j7B2CeyBqZWRaCXppfxuhk5hBLoBsPMOAvrYG65dQYwKgYgVh0oNe246zuAj8MqUyOf8/EfzIhLads59+PyjyKOn8IXRpcQPjuAm/0gRfrgKToJ+3HOHYMhSmzW8xYLssV9CF9JmZ3+VxDzSZ5ZMRVNxDauKM7cHG57LUxQbPbPUzjVmsU/HdTxncfsn4FGlU+2GoEtVxXErydiN8eXr29lXHd1GuWrSec6brJukuMSfLrR+9U12gYrXMTLDPymu9GJXDxMDs+B4zr7LrHOwFw/jb58GhK8JgokuK/b5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH3PR11MB8316.namprd11.prod.outlook.com (2603:10b6:610:17b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 19:19:26 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3%7]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 19:19:26 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Lutomirski, Andy"
	<luto@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gross, Jurgen" <jgross@suse.com>, "Shankar, Ravi V"
	<ravi.v.shankar@intel.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>,
	"jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v13 26/35] x86/fred: FRED entry/exit and dispatch code
Thread-Topic: [PATCH v13 26/35] x86/fred: FRED entry/exit and dispatch code
Thread-Index: AQHaJ215PhEOYu43sEObVSTXzfHZOLCanWSAgAE5e5CAAHaQAIAAUcKg
Date: Wed, 6 Dec 2023 19:19:26 +0000
Message-ID: <SA1PR11MB673472A25E72022F68882869A884A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-27-xin3.li@intel.com>
 <f260ddf9-be67-48e0-8121-6f58d46f7978@citrix.com>
 <SA1PR11MB67343544B0CEB6C82002790DA884A@SA1PR11MB6734.namprd11.prod.outlook.com>
 <4e41b658-f49e-424c-8a86-08c8ab8e384d@citrix.com>
In-Reply-To: <4e41b658-f49e-424c-8a86-08c8ab8e384d@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH3PR11MB8316:EE_
x-ms-office365-filtering-correlation-id: c29a1c6c-b34e-4ba2-8ac9-08dbf6904316
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NUuKmn4dllaOhkfrj+zV5qjuqmC3Td+yzJZ00as/39MeZrs/z6/4Ogj5qGyCwNV0pogORt1lqATc+NeQj7xTxDyzn/9AQ8bS23kkZipezPY1XYNFxoebmjceq+qvmjuJpbT4Xx70CxhxlVx8GtyLX+NCBFfzm924EYxd6NamCCd/NEZwKqCsIS3P7eFHs2NV1ryiZPMaU4psgm5iCTPpOko4pWCR50v9cqEb77XMwzL8uyf7odsQKGJLmNZ86hv4mB3QSxhbY4HN4SsomsSK3qpA9yRluvY+h3aFC5kBGMWvdN+7OOPnFMbEsDJ4KQbjdfsypbEDU2gIRRIbfkLx47Duym1IBmfdEsPuWrEU/n406EirGMEWwn5adRT4oZYGGvwVfG/7rNzmt9HxQLdr+P4d25Eetve/PrUKjn3iUIKddI6HD4F97PcPnV28Uz5vPZcnyPqxs68lr+NFS/EGjnL4Cun/v/p1/sY+MBlRywFA+h2IivJH4Idu1nYVXdn4u6j+7jitqDDnOMmLwiYXN9ChhCY3IL7ltwyyzeiAVbGKqH1OPjm0R4nxc0ME3nJ5D4eBOPP4WUK1Bd13zaEqI74olkegv1ui+gxZKD8DVCadVtjpQstgQQ+t6AqRNAUo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(136003)(376002)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(83380400001)(7696005)(71200400001)(9686003)(6506007)(26005)(55016003)(316002)(66946007)(76116006)(110136005)(66556008)(66476007)(66446008)(64756008)(54906003)(38070700009)(5660300002)(33656002)(2906002)(7416002)(4326008)(86362001)(8676002)(8936002)(122000001)(52536014)(41300700001)(38100700002)(82960400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDlVYW9VZ2FCeXR0RXBLTTRySFpYUXZtQllWcldoZVFzZWpXVWp4amt3OWM5?=
 =?utf-8?B?TjZJemQxTEhMN0lDWC9rQUlhYzhFS2lFTjcxeGJZRW1HUkdUR3NuU1ZlMzd4?=
 =?utf-8?B?b2pORkxUclhET2NFYXRibDNXeGp5bTkrRGxoRE5jVXQ2Y0ZqZkJTbHhISE9y?=
 =?utf-8?B?cHdiTDNxUk5HeHllRmpKeElkTHhiZkw5b1F1bmNocE1MTHBVMGpybWdYZTQy?=
 =?utf-8?B?ck84S2phZlp5dUpXbzdiTXN2cTdVTHg1QWdydW9YUGJkTXBpWm4yMm5UQUMx?=
 =?utf-8?B?dlJ6NUw1V2poWXNCdDJQVVZGS1RkNENNUEtPWHU3R1d6eXQ0VEVVL2l4WTVk?=
 =?utf-8?B?WGJJYnFrT0FhdHVHNUZ5OW1EUEdaK2NUcU9WK1NiNW9wNUp4eC9FRW1lbDNJ?=
 =?utf-8?B?YnF2SjBteWRZZlpYamFIOUFmbWllTWtsNG1qTmRaeVpvL2NscjdFZ3ZlNnQw?=
 =?utf-8?B?cEkzWkhwN2ptNmRrUG92bmxnRmdEWEx0dVRSMEZFbXI3a21Bc1ZZZEhpdjN2?=
 =?utf-8?B?VEtxbnlqaVVuRi9YZGhKc1BxQ3ZZWGNGMDhuR2pHZ2RqRUFTbVVjKzRuU2Er?=
 =?utf-8?B?b1BhdjM2a1BNUmZESS9BZUhOaG5aQlBPWlRROU1MQStDblN2aXFVakFLUjBw?=
 =?utf-8?B?M0V2T3lsV0pER29YQ0VibGtYLyt1elk0emtvUDFubDZFWGlyVlJMckhKRTJU?=
 =?utf-8?B?YmhTWFpGWDV2TzI1c1dzMlpySThNcTJqSFZuUmdZVXR0Y1F0OGNxKyt0RVZO?=
 =?utf-8?B?T0ZXdnM5Y3VDd1R0QWoxN203QzNZYTUzWUpJWko3ZThWY2l6cS8xZlBSemx6?=
 =?utf-8?B?YmoyQzdWVlNaaE9FdnAwTENPcGs0ZUNBRXFjczV3alY4QURFdDl3RDJwUzU3?=
 =?utf-8?B?Vy9QdFJQWjFHMDBIZU13dXczVis2NXpaaVFPbm1rMnhyd1dpNWFtSlgxbEdU?=
 =?utf-8?B?TmkzKzBZRTFlQjJDemd1Z0lSc1hhcmt0NlAwTCszakgxVFZVeUxOeUlMK2RM?=
 =?utf-8?B?YkJUaVVGTVNqTWpERUJ2VWhtQ0lQMFdzNllCcVAvVmxhYnVuSHpmcFlIL01Z?=
 =?utf-8?B?QWxNNHZCS2czeXN5WnRFRitkWFhlaXZUczNxRzFTM2s4MEhsemppOFkzdUZ6?=
 =?utf-8?B?RUVGMVhPeGpITy9uR2E0MmRwTUc3S3ROVjdhVDFYaHNscnlqT2o3OHM2UnZI?=
 =?utf-8?B?KzEwZkRRUC9lQ0tGa0MvUkd2dWF0UGcrSWlGb1RGR1cxakNCRUE0bE1aUUY5?=
 =?utf-8?B?dUdaUk1PSStEeEhZMWw1OFdZcGFsd2p6dWM3V3YycmR5dTY5bEFDZGUvQjdi?=
 =?utf-8?B?YWg0Q0lsM2pUeGRkSG5uK3FEdjhxZXo3eFdFcklaem10NUN3ZVMwQmhEVWo1?=
 =?utf-8?B?dGhHSWxvTnJzVHZoVnA0RWR6Skp1SnlPcnZycjdjeWF0NEpEdFZwR1hNd0x0?=
 =?utf-8?B?MmtRWUJrL1NkVVJmamI5R1FlSlN6VGFPMEpJK28wM1RRT0M0cFpoeTV0ZFkx?=
 =?utf-8?B?WUEvdkljM2kreDI1SVNPbGdLa0NHWU1IWE1GSEdpZmQwd3U3cWF0aHlObW41?=
 =?utf-8?B?Z0VRQ2lTOEZCNzNzN3JkRnQ1alVnRmlCcEs0QnNzUWMzMTJ4akRBZDhhZUhE?=
 =?utf-8?B?cktCUWxjTkFjRTFkdDZ2bnlldms4dXJqdHNrWnFTL1FBQ0lCTG5WK2trVXJ0?=
 =?utf-8?B?S2VsME1BcGxmQzVzbzdaY2pUSDRwTTRQZk52d2FGVzRaSU1JRW1mQVNUOGVJ?=
 =?utf-8?B?ZmR4c1J0N3NiZEVRR2tNdVJFSlJXRzNKT3VEZDMyaEx1UVpnVk53MmFsMzBJ?=
 =?utf-8?B?Q2h0M1dSRytxWXVSaG1RYTYzRWF4QzJybGhwalVnZ2JXZW9tVnYycm83OUI5?=
 =?utf-8?B?Y2VEMkhKQlJWeXpTTElVc0NwUFIrSFU0WUdxUEFOTVAzeXVkejdHYURtWCt6?=
 =?utf-8?B?WUJEbmowc1o0V205TWZyRnlGUW14TGNZM080ZWo0L3hsbTJDZnlicmJsdHQz?=
 =?utf-8?B?SWFjemVibU1hVVkvUDlRekJUZnZSYWkxWDhSZGUzOGlBUUoyMHhLKzAyMWVH?=
 =?utf-8?B?Vm1RVkxwaFNpeGpVNVhreWtGbXRjZjc1T0QzY3dISEh5Y0lVVlFSVWh6M0ZV?=
 =?utf-8?Q?s5dU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c29a1c6c-b34e-4ba2-8ac9-08dbf6904316
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2023 19:19:26.3669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t898gUy+pxrMnxlORz38ZpFvtGOwrrVSYhgcJ3DmSRSL1aj6STiHfz6Op+Rqba3D6rtDmskIFCwdaXTfYYXcGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8316
X-OriginatorOrg: intel.com

PiA+Pj4gKwljYXNlIFg4Nl9UUkFQX09GOg0KPiA+Pj4gKwkJZXhjX292ZXJmbG93KHJlZ3MpOw0K
PiA+Pj4gKwkJcmV0dXJuOw0KPiA+Pj4gKw0KPiA+Pj4gKwkvKiBJTlQzICovDQo+ID4+PiArCWNh
c2UgWDg2X1RSQVBfQlA6DQo+ID4+PiArCQlleGNfaW50MyhyZWdzKTsNCj4gPj4+ICsJCXJldHVy
bjsNCj4gPj4gLi4uIG5laXRoZXIgT0Ygbm9yIEJQIHdpbGwgZXZlciBlbnRlciBmcmVkX2ludHgo
KSBiZWNhdXNlIHRoZXkncmUNCj4gPj4gdHlwZSBTV0VYQyBub3QgU1dJTlQuDQo+ID4gUGVyIEZS
RUQgc3BlYyA1LjAsIHNlY3Rpb24gNy4zIFNvZnR3YXJlIEludGVycnVwdHMgYW5kIFJlbGF0ZWQg
SW5zdHJ1Y3Rpb25zOg0KPiA+IElOVCBuIChvcGNvZGUgQ0QgZm9sbG93ZWQgYnkgYW4gaW1tZWRp
YXRlIGJ5dGUpOiBUaGVyZSBhcmUgMjU2IHN1Y2gNCj4gPiBzb2Z0d2FyZSBpbnRlcnJ1cHQgaW5z
dHJ1Y3Rpb25zLCBvbmUgZm9yIGVhY2ggdmFsdWUgbiBvZiB0aGUgaW1tZWRpYXRlDQo+ID4gYnl0
ZSAoMOKAkzI1NSkuDQo+ID4NCj4gPiBBbmQgYXBwZW5kaXggQiBFdmVudCBTdGFjayBMZXZlbHM6
DQo+ID4gSWYgdGhlIGV2ZW50IGlzIGFuIGV4ZWN1dGlvbiBvZiBJTlQgbiAob3Bjb2RlIENEIG4g
Zm9yIDgtYml0IHZhbHVlIG4pLA0KPiA+IHRoZSBldmVudCBzdGFjayBsZXZlbCBpcyAwLiBUaGUg
ZXZlbnQgdHlwZSBpcyA0IChzb2Z0d2FyZSBpbnRlcnJ1cHQpDQo+ID4gYW5kIHRoZSB2ZWN0b3Ig
aXMgbi4NCj4gPg0KPiA+IFNvIGludCAkMHg0IGFuZCBpbnQgJDB4MyAodXNlIGFzbSgiLmJ5dGUg
MHhDRCwgMHgwMyIpKSBnZXQgaGVyZS4NCj4gPg0KPiA+IEJ1dCBpbnRvICgweENFKSBhbmQgaW50
MyAoMHhDQykgZG8gdXNlIGV2ZW50IHR5cGUgU1dFWEMuDQo+ID4NCj4gPiBCVFcsIGludG8gaXMg
Tk9UIGFsbG93ZWQgaW4gNjQtYml0IG1vZGUgYnV0ICJpbnQgJDB4NCIgaXMgYWxsb3dlZC4NCj4g
DQo+IFRoZXJlIGlzIGNlcnRhaW5seSBmdW4gdG8gYmUgaGFkIHdpdGggQ0QgMDMgYW5kIENEIDA0
IGJ5dGUgcGF0dGVybnMsIGJ1dCBpZiB5b3UNCj4gbWVhbnQgdG8gbWVhbiB0aG9zZSBoZXJlLCB0
aGVuIHRoZSBjb21tZW50cyBhcmUgd3JvbmcuDQo+IA0KPiBWZWN0b3JzIDMgYW5kIDQgYXJlIGlu
c3RhbGxlZCB3aXRoIERQTDMgYmVjYXVzZSB0aGF0IGlzIG5lY2Vzc2FyeSB0byBtYWtlIENDIGFu
ZA0KPiBDRSBmdW5jdGlvbiBpbiB1c2Vyc3BhY2UuwqAgSXQgYWxzbyBzdWdnZXN0cyB0aGF0IHRo
ZSBTV0lOVCB2cyBTV0VYQyBkaXN0aW5jdGlvbg0KPiB3YXMgcmV0cm9maXR0ZWQgdG8gYXJjaGl0
ZWN0dXJlIGFmdGVyIHRoZSAyODYsIGJlY2F1c2UgZXhjZXB0aW9ucyBkb24ndCBjaGVjayBEUEwN
Cj4gYW5kIElDRUJQIGRlbGl2ZXJzICNEQiBmcm9tIHVzZXJzcGFjZSBldmVuIHdoZW4gVmVjdG9y
IDEgaGFzIGEgRFBMIG9mIDAuDQo+IA0KPiBXaGlsZSBDQyBpcyBmb3IgbW9zdCBjYXNlcyBpbmRp
c3Rpbmd1aXNoYWJsZSBmcm9tIENEIDAzLCBDRSBiZWhhdmVzIGVudGlyZWx5DQo+IGRpZmZlcmVu
dGx5IHRvIENEIDA0LsKgIENEIDA0IGRvZXNuJ3QgI1VEIGluIDY0Yml0IG1vZGUsIGFuZCB3aWxs
IHRyaWdnZXINCj4gZXhjX292ZXJmbG93KCkgaXJyZXNwZWN0aXZlIG9mIHRoZSBzdGF0ZSBvZiBF
RkxBR1MuT0YuDQo+IA0KPiANCj4gVGhlIFNETSBnb2VzIG91dCBvZiBpdCdzIHdheSB0byBzYXkg
bm90IHRvIHVzZSB0aGUgQ0QgMDMgYnl0ZSBwYXR0ZXJuIChhbmQgaXQNCj4gZG9lcyB0YWtlIGVm
Zm9ydCB0byBlbWl0IHRoaXMgYnl0ZSBwYXR0ZXJuIC0gZS5nLiBHQVMgd2lsbCBzaWxlbnRseSB0
cmFuc2xhdGUgImludCAkMyINCj4gdG8gImludDMiKSwgYW5kIHRoZXJlJ3Mgbm8gcGxhdXNpYmxl
IHdheSBzb2Z0d2FyZSBpcyB1c2luZyBDRCAwNCBpbiBwbGFjZSBvZiBDRS4NCj4gDQo+IFNvIHdo
eSBkbyB3ZSBjYXJlIGFib3V0IGNvbnRhaW5pbmcgdG8gbWFrZSBtaXN0YWtlcyBvZiB0aGUgSURU
IGVyYSB3b3JrIGluIGENCj4gRlJFRCB3b3JsZD8NCg0KRmlyc3QsIEkgYWdyZWUgd2l0aCB5b3Ug
YmVjYXVzZSBpdCBtYWtlcyB0aGluZ3Mgc2ltcGxlIGFuZCBuZWF0Lg0KDQpIb3dldmVyLCB0aGUg
bGF0ZXN0IFNETSBhbmQgRlJFRCBzcGVjIDUuMCBib3RoIGRvZXNuJ3QgZGlzYWxsb3cgaXQsIHNv
IGl0DQpiZWNvbWVzIGFuIE9TIGltcGxlbWVudGF0aW9uIGNob2ljZS4NCg0KPiANCj4gSXMgdGhl
cmUgYW55dGhpbmcgKG90aGVyIHRoYW4gcGVyaGFwcyB0aGUgc2VsZnRlc3RzKSB3aGljaCB3b3Vs
ZCBldmVuIG5vdGljZT8NCg0KSSdtIGp1c3QgY29uc2VydmF0aXZlIDopDQoNCklmIGEgdXNlciBh
cHAgY2FuIGRvIGl0IHdpdGggSURULCB3ZSBzaG91bGQgc3RpbGwgYWxsb3cgaXQgd2hlbiBGUkVE
IGlzDQplbmFibGVkLiAgQnV0IGlmIGFsbCBrZXkgc3Rha2Vob2xkZXJzIGRvbid0IGNhcmUgd2hh
dGV2ZXIgZ2V0cyBicm9rZW4NCmR1ZSB0byB0aGUgY2hhbmdlIGFuZCBhZ3JlZSB0byBjaGFuZ2Ug
aXQuDQoNCj4gPj4+ICsJCWluc3RydW1lbnRhdGlvbl9lbmQoKTsNCj4gPj4+ICsJCWlycWVudHJ5
X2V4aXQocmVncywgc3RhdGUpOw0KPiA+Pj4gKwl9IGVsc2Ugew0KPiA+Pj4gKwkJY29tbW9uX2lu
dGVycnVwdChyZWdzLCB2ZWN0b3IpOw0KPiA+Pj4gKwl9DQo+ID4+PiArfQ0KPiA+Pj4gKw0KPiA+
Pj4gK3N0YXRpYyBub2luc3RyIHZvaWQgZnJlZF9leGNlcHRpb24oc3RydWN0IHB0X3JlZ3MgKnJl
Z3MsIHVuc2lnbmVkDQo+ID4+PiArbG9uZyBlcnJvcl9jb2RlKSB7DQo+ID4+PiArCS8qIE9wdGlt
aXplIGZvciAjUEYuIFRoYXQncyB0aGUgb25seSBleGNlcHRpb24gd2hpY2ggbWF0dGVycw0KPiA+
Pj4gK3BlcmZvcm1hbmNlDQo+ID4+IHdpc2UgKi8NCj4gPj4+ICsJaWYgKGxpa2VseShyZWdzLT5m
cmVkX3NzLnZlY3RvciA9PSBYODZfVFJBUF9QRikpIHsNCj4gPj4+ICsJCWV4Y19wYWdlX2ZhdWx0
KHJlZ3MsIGVycm9yX2NvZGUpOw0KPiA+Pj4gKwkJcmV0dXJuOw0KPiA+Pj4gKwl9DQo+ID4+PiAr
DQo+ID4+PiArCXN3aXRjaCAocmVncy0+ZnJlZF9zcy52ZWN0b3IpIHsNCj4gPj4+ICsJY2FzZSBY
ODZfVFJBUF9ERTogcmV0dXJuIGV4Y19kaXZpZGVfZXJyb3IocmVncyk7DQo+ID4+PiArCWNhc2Ug
WDg2X1RSQVBfREI6IHJldHVybiBmcmVkX2V4Y19kZWJ1ZyhyZWdzKTsNCj4gPj4+ICsJY2FzZSBY
ODZfVFJBUF9CUDogcmV0dXJuIGV4Y19pbnQzKHJlZ3MpOw0KPiA+Pj4gKwljYXNlIFg4Nl9UUkFQ
X09GOiByZXR1cm4gZXhjX292ZXJmbG93KHJlZ3MpOw0KPiA+PiBEZXBlbmRpbmcgb24gd2hhdCB5
b3Ugd2FudCB0byBkbyB3aXRoIEJQL09GIHZzIGZyZWRfaW50eCgpLCB0aGlzIG1heQ0KPiA+PiBu
ZWVkIGFkanVzdGluZy4NCj4gPj4NCj4gPj4gSWYgeW91IGFyZSBjcm9zcy1jaGVja2luZyB0eXBl
IGFuZCB2ZWN0b3IsIHRoZW4gdGhlc2Ugc2hvdWxkIGJlDQo+ID4+IHJlamVjdGVkIGZvciBub3Qg
YmVpbmcgb2YgdHlwZSBIV0VYQy4NCj4gPiBZb3UncmUgcmlnaHQsIHRoZSBldmVudCB0eXBlIG5l
ZWRzIHRvIGJlIFNXRVhDIGZvciBpbnRvIGFuZCBpbnQzLg0KPiA+DQo+ID4gSG93ZXZlciwgd291
bGQgaXQgYmUgb3ZlcmtpbGxpbmc/ICBBc3N1bWluZyBoYXJkd2FyZSBhbmQgVk1NIGFyZSBzYW5l
Lg0KPiANCj4gWW91IGVpdGhlciBjYXJlIGFib3V0IGNyb3NzIGNoZWNraW5nLCBvciBub3QuwqAg
UmlnaHQgbm93LCB0aGlzIHBhdGNoIGlzIGEgbWl4IG9mIHRoZQ0KPiB0d28gYXBwcm9hY2hlcy4N
Cj4gDQo+IEluIG15IG9waW5pb24sIGNyb3NzLWNoZWNraW5nIGlzIHRoZSBiZXR0ZXIgYXBwcm9h
Y2gsIGJlY2F1c2UgaXQgbWVhbnMgdGhhdA0KPiB2aW9sYXRpb25zIG9mIHRoZSBhc3N1bXB0aW9u
cyBnZXQgbm90aWNlZCBtb3JlIHF1aWNrbHksIGFuZCBob3BlZnVsbHkgYnkNCj4gd2hvbWV2ZXIg
aXMgd29ya2luZyBvbiB0aGUgbmV3IGZlYXR1cmUgd2hpY2ggYWx0ZXJzIHRoZSBhc3N1bXB0aW9u
cy4NCg0KWWVhaCwgSSBjYW4gbWFrZSB0aGUgY2hhbmdlLg0KDQpUaGFua3MhDQogICAgWGluDQo=

