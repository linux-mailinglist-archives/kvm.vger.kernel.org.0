Return-Path: <kvm+bounces-4588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0358814FCD
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 19:37:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66F591F24FE9
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 18:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C243DBA1;
	Fri, 15 Dec 2023 18:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ndDWHV6r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9959C2C6A3;
	Fri, 15 Dec 2023 18:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702665460; x=1734201460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=57mVtHS5ImLBrxXuVvgmhfYm11vBOdhv05t5OuHc7xk=;
  b=ndDWHV6rmbFUgMvNQUCtxIvaN+pwdSNMFbD0v764JV66jwKxS9z7l3UP
   2qCBBueGxz8WPQ01k0soqAihIxDYMeHCWd/ojHNEt3C2DLJ3L9N98d10U
   Qzyjs43YqN5uX19BAPZU2n6MIHC7eRCSGYRvq4injC93DsUFnKaEb2IsX
   4yiYRBTpsnCiF4jZLeF7qROK6GhYLzM0I95pTuMvFNKi3r814B8yc1GAb
   mHx49cgHFtkjuo0vYwzKJsTbpArfleECkZR2lBKRQUV1N7t4KAYKzzbRy
   XbCGJMcSVAs8QGsMPIVndjn2TipqdVUhW9W4bASOAsZG0PV1i7QLhIIC0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10925"; a="374814894"
X-IronPort-AV: E=Sophos;i="6.04,279,1695711600"; 
   d="scan'208";a="374814894"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2023 10:37:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10925"; a="751024617"
X-IronPort-AV: E=Sophos;i="6.04,279,1695711600"; 
   d="scan'208";a="751024617"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Dec 2023 10:37:38 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Dec 2023 10:37:38 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Dec 2023 10:37:38 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 15 Dec 2023 10:37:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 15 Dec 2023 10:37:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Okneq/NGkR5c6tC+dLAZpOle37kELLiXj5W7rocoaj7El6zsbwCnZuQwADyigFoWJs5T+W9ezjxSGOhgcjb3xebodoAUtybQ4hrN2C1D3hJzqmN+rScuI1UcaznmN20XPx1DvKZFjVFL76cWCPdPqydxl6C1KDBeIP7BQJAkDzeTU+zK4Khr/LkO5D+LYq7xa0Iq8D2IEc+J0fZhCEZF71yahX32HUGGzzxvrWrusgF4qT24RYuK72owxt7KsKAAMX1JZuaimZybo4WjR4G/zNazrpj8xEjch9h5SqHE6Vm16Fp6LcyxuJVJ33d89oza1/LdhhgXDe0BDvYMj1Vo6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57mVtHS5ImLBrxXuVvgmhfYm11vBOdhv05t5OuHc7xk=;
 b=T2EEcwutH2gvbJDCwfbX2hXRA3920YMaREhEIzG6LW6voeb+/3iJrZdff4tkp1ZBfQEywkvzRAHWf8T16q+u9yp+Q9xMrMfmvoGjD1dY1BUNoxneyWtXy9JWa805xAcHouhILrjXwgFxoed7vBqgc6kipIY+2LyBJg6KODXBB5NgRpD8UQ38onpWJQ+Qy2LrZ87dTeZhsGAsjDuAUCaebT8cnlOLKu+SzMmB9OWXvZj8r2dt75dBv1jSC02CMOQuV8st18uoWBNa+ydbVCaBFnWEzADQKHwuxi2h5Cm/pRtIPHH6UwFyE6VEh8VooIQ63kEbBX/ejemVdlnfF1BgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SA1PR11MB7062.namprd11.prod.outlook.com (2603:10b6:806:2b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Fri, 15 Dec
 2023 18:37:27 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3%7]) with mapi id 15.20.7091.030; Fri, 15 Dec 2023
 18:37:27 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Lutomirski, Andy" <luto@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "jgross@suse.com"
	<jgross@suse.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>, "jiangshanlai@gmail.com"
	<jiangshanlai@gmail.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v13 24/35] x86/fred: Add a NMI entry stub for FRED
Thread-Topic: [PATCH v13 24/35] x86/fred: Add a NMI entry stub for FRED
Thread-Index: AQHaJ21um304Ih/3wke5WdAmrxBB47Cpo3eAgAEUIxA=
Date: Fri, 15 Dec 2023 18:37:27 +0000
Message-ID: <SA1PR11MB673465C969A6554B8574157EA893A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-25-xin3.li@intel.com>
 <c0c7c605-d487-483e-a034-983b76ee1dfa@zytor.com>
In-Reply-To: <c0c7c605-d487-483e-a034-983b76ee1dfa@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SA1PR11MB7062:EE_
x-ms-office365-filtering-correlation-id: 021c973f-2884-44de-dba1-08dbfd9ce356
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GHI9S5GeYdVT2kaXFI9wxFJxC0n5K0A+gvggDzWO6pYIt8Dh7tCib95HSlqk/Dv1G7R1UXBVeTWrAVKmoCy5ZFIvuUEftCq5SD24EV38OyVK8MHcPhwrWT/SZSWTI9YhlqICbacI44Tpbhjyj7boOWUP9YfiOl/P0z4knqWrdfq5qLggsJrhIAbz6A4JSbgsLRl8hMN5WQP4mbMb7x0hkIuzl4HG8u4PyhncjRg8+Rifwwlt7etLPlaoiEIaXG5vxx5bWepHSJOKSHp6PhfVP/Qhk83qEOb75tEOPAm5PVz9UmiidYFabCGjysYVEC+r2Oh1n6mK1BbK1iuvr9ERiKNLwY0nn9PPnJjnYWJjwNI7L9uHTlHKHIqA1bL5R/+w+L1P0twOPMAMR8L0qJi7OqjZ+loXkzrpqyPbvrhG4q+rFy/aFdeOTLoq2eyqFV1nM60na4gC3yOsf5ETJnQDZoJwPFLz3ekS+LEVUR137zvI0B07tXkBNvcaIvkglkjaea86nw9YNZzFgZkEQ51FSunwPBnh66Eu/SzJtZe19hN2HUWiGTzPgpvIIieMkgILzQ//lNC8muWB1te+oxRdxGqFTl+Y9kdqBj46prCWoio=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(26005)(83380400001)(82960400001)(122000001)(86362001)(38100700002)(41300700001)(5660300002)(7416002)(8936002)(4326008)(110136005)(7696005)(8676002)(52536014)(54906003)(66556008)(66946007)(76116006)(9686003)(64756008)(66476007)(966005)(2906002)(478600001)(6506007)(316002)(66446008)(71200400001)(38070700009)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUdzNWtwOXprQUFkZXByTk5JRzNyeUpnVnpMR0tXKzhjaWJoRm41NGtMTUpq?=
 =?utf-8?B?ek9yUU9uMXR1cHpIVVAvSHZFdUJMQzcxeVBKVk9NYnZJYWs4RldVaDMzTWpq?=
 =?utf-8?B?dHJtZEJuUDhqdVhxeS85dlcwVEFmeVIrWWxudGpRMGgxcURrU0MrWHZJVXZC?=
 =?utf-8?B?eWVIdlZLdlJaeTVId1ZQNkp1U0NES3NnQWRzV0N6WEJ3MThPZFROYTRmVENp?=
 =?utf-8?B?dmVKQXdPaWw1aW4yOUJ1VG51UzVuN2FEUHFKS1hZdU1sV3RZUmZVYngwSndU?=
 =?utf-8?B?STIxRjVkTjBwRzJBcVNyK1VOVmx4SFVQazY0NzJ3cWFWd1VEYm5ya2NPT0Z6?=
 =?utf-8?B?Zm16TXAySEdUZDk3eVc3emU2VlJJZFhmV3drcmdJYWtXYkN4QU9yREExT1hM?=
 =?utf-8?B?TVMrQXdleEs0Ulh1NFkvR0prdjZXSjg1QVBzcHVWdDVmVnFWbUVadFBXYkhY?=
 =?utf-8?B?ZjJWWGM4UE9VQUNDUFFRb0hKRmltRFJPL2dhTmNDdUk5ek96dnpLN3BFNTl4?=
 =?utf-8?B?V2VtVElrZmFUcjdOcFRGZlJpcWhiTXhTNyttckRHUUlxaURwbGoycHBSRDNF?=
 =?utf-8?B?QXMrMWhzVHVESng2enI4Q3QwS0x6K0p6R2xoM2VtRlZvKzdzVmtTeUFVckwr?=
 =?utf-8?B?SGN2SnN1SmdZRzJ4TE1mVFZ4WHhNRXRvcjFXR1kycStxeHUxaDJCOEhDT0tI?=
 =?utf-8?B?V3RnSnp1TlhsWXlVdUhCYitZZGxiTklqU05xK3I2TWFWTWlMT2V5bFlRa1U5?=
 =?utf-8?B?NVdXbU85NW4zell4YzR1YWpIZ09zdWE3SjZ2UkZVcmtoajAxRDJlOFpreG55?=
 =?utf-8?B?VUdYVmhpOHE2Wmp5ZUNBdWMwV1RlQW1wUTFLNFp5cndBekxjWllrbHV6dzFt?=
 =?utf-8?B?Z0hwdG9hTnVsLzdaWGsrVWdycGdXcStFcXJqZUNvK1MrTkZwUHo0ZE9ETmVP?=
 =?utf-8?B?QW4xSDhkRGtsSVhoNyttazNnd0pEL1hlQ1Fodm85ZXUyMW1OeXlMZi9WMGxi?=
 =?utf-8?B?MUw4aUM5dlJKY1JqdlJST0tLL1o4S2pWb051L2U0REs3a1FiTEd2TXhFTHlH?=
 =?utf-8?B?WDJNTWlpWGZGZUFvWXVGMERTY3MzRVJXcmdOOUVsbS9CeVUrZHIvMlVoL1F5?=
 =?utf-8?B?VStEaE9EdmlZK1J5TnNybFdtT2lGVmo5aGVKNVRVMXRDSlNBOENCSk5wWXhT?=
 =?utf-8?B?YVd2aWR0cE4rYk5tc2J3d1piUm1wcEtpdlI1TkMyN1FTamc3SUg2QWFGZWFO?=
 =?utf-8?B?VjArbE1hd2h2L1J1bE95a3lmK25sNnVibnFCdHo4WE1PV2w5aHgwVnhvUE5r?=
 =?utf-8?B?L3AwV2QwU2t3ZDFHTzZ3TlY1ZFIwNjZGTEpMU2k1WFV1WWFBS0lJNzhVUDlB?=
 =?utf-8?B?OS9WVnBXYmdyUXpjOXNNbUtVTnQrZ2pEV0tpaUNSSGx3MERrSStrRjFXeWRS?=
 =?utf-8?B?Z0RqbWVYejV6SmltTHZscmU2Y0RaYlUrTU8yWXNDZThjK3A2YitxOE1hSGdm?=
 =?utf-8?B?clNuU1VGb3cyWHcwZVphVjlsWXE5MFVxT25kclIyVVlldW95K2dxWTBaM3I5?=
 =?utf-8?B?V1JjeUdSM3pmTUloNDkyNkJNZkZPUXJvWFJrT2xkcHFqT25UNFRMY3hTSmR5?=
 =?utf-8?B?Y0dOMS9pT3pxaS90d3dGSVRwa1kvQ1h1c3E2U0tUaUN4bXYzNHRYNU9YM2RH?=
 =?utf-8?B?ZUVyVFlMd3BqRHV2NlVqV2dHaFh3MnBpMkFrZWxOT1NEelBSb0d0MmtTNDVC?=
 =?utf-8?B?bXc0NEd5eFBuU3BKOTJ0bHRNb21BV1lQS3lnMFphbEhwTHhxc1ZQTzZhM1Vo?=
 =?utf-8?B?cllDOUJJY3UrTnN2d3EzMDByWUtVRVF1NVZXY0kwclBSdDArYnUwclZQYU83?=
 =?utf-8?B?b21nY2ZUa3A3czcvb1k3U05iWkhxWDFIYW8xM2xySndxSkpZQ3NDTkxueWxR?=
 =?utf-8?B?djhVdHRYdzBnKy9GeEorb0doNHhVYTU0MTBtbWRmZ1JWUEIvdHh1MkxqYTM4?=
 =?utf-8?B?RmczNS9TR1NBSVhJQkV3aEZlZ0tJb3JGZ3pTb2d5VXcvK1dRVFZmRjJhSm1H?=
 =?utf-8?B?alREK1VNQm9CQ0p0c0JIYWpZYkZwRGhIYld4ZzhHem5Gc1VrakZjUGlveFRM?=
 =?utf-8?Q?YaYs=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 021c973f-2884-44de-dba1-08dbfd9ce356
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 18:37:27.3639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kJV7tt6zUx7CJVXA9YqH9aRI6glqYwI2EATrXbVWz/dHxwCwaY9kWl1NMV5EcvWIkEgmh/eghnVpQPxX6xQzNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7062
X-OriginatorOrg: intel.com

PiBTbyB3ZSBoYXZlIHJlY2VudGx5IGRpc2NvdmVyZWQgYW4gb3Zlcmxvb2tlZCBpbnRlcmFjdGlv
biB3aXRoIFZULXguDQo+IEltbWVkaWF0ZWx5IGJlZm9yZSBWTUVOVEVSIGFuZCBhZnRlciBWTUVY
SVQsIENSMiBpcyBsaXZlIHdpdGggdGhlDQo+ICpndWVzdCogQ1IyLiBSZWdhcmRsZXNzIG9mIGlm
IHRoZSBndWVzdCB1c2VzIEZSRUQgb3Igbm90LCB0aGlzIGlzIGd1ZXN0DQo+IHN0YXRlIGFuZCBT
SE9VTEQgTk9UIGJlIGNvcnJ1cHRlZC4gRnVydGhlcm1vcmUsIGhvc3Qgc3RhdGUgTVVTVCBOT1Qg
bGVhaw0KPiBpbnRvIHRoZSBndWVzdC4NCj4gDQo+IE5NSXMgYXJlIGJsb2NrZWQgb24gVk1FWElU
IGlmIHRoZSBjYXVzZSB3YXMgYW4gTk1JLCBidXQgbm90IGZvciBvdGhlcg0KPiByZWFzb25zLCBz
byBhIE5NSSBjb21pbmcgaW4gZHVyaW5nIHRoaXMgd2luZG93IHRoYXQgdGhlbiAjUEZzIGNvdWxk
DQo+IGNvcnJ1cHQgdGhlIGd1ZXN0IENSMi4NCg0KSSBhZGQgYSBjb21tZW50IHRvIHZteF92Y3B1
X2VudGVyX2V4aXQoKSBpbg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjMxMTA4MTgz
MDAzLjU5ODEtMS14aW4zLmxpQGludGVsLmNvbS9ULyNtMjk2MTZjMDJiZWZjMDQzMDUwODViMWNi
YWM2NGRmOTE2MzY0NjI2YQ0KZm9yIHRoaXMuDQoNCj4gDQo+IEludGVsIGlzIGV4cGxvcmluZyB3
YXlzIHRvIGNsb3NlIHRoaXMgaG9sZSwgYnV0IGZvciBzY2hlZHVsZSByZWFzb25zLCBpdA0KPiB3
aWxsIG5vdCBiZSBhdmFpbGFibGUgYXQgdGhlIHNhbWUgdGltZSBhcyB0aGUgZmlyc3QgaW1wbGVt
ZW50YXRpb24gb2YNCj4gRlJFRC4gVGhlcmVmb3JlLCBhcyBhIHdvcmthcm91bmQsIGl0IHR1cm5z
IG91dCB0aGF0IHRoZSBGUkVEIE5NSSBzdHViDQo+ICp3aWxsKiwgdW5mb3J0dW5hdGVseSwgaGF2
ZSB0byBzYXZlIGFuZCByZXN0b3JlIENSMiBhZnRlciBhbGwgd2hlbiAoYXQNCj4gbGVhc3QpIElu
dGVsIEtWTSBpcyBpbiB1c2UuDQo+IA0KPiBOb3RlIHRoYXQgdGhpcyBpcyBhaXJ0aWdodDogaXQg
ZG9lcyBhZGQgYSBwZXJmb3JtYW5jZSBwZW5hbHR5IHRvIHRoZSBOTUkNCj4gcGF0aCAodHdvIHJl
YWQgQ1IyIGluIHRoZSBjb21tb24gY2FzZSBvZiBubyAjUEYpLCBidXQgdGhlcmUgaXMgbm8gZ2Fw
DQo+IGR1cmluZyB3aGljaCBhIGJhZCBDUjIgdmFsdWUgY291bGQgYmUgaW50cm9kdWNlZCBpbiB0
aGUgZ3Vlc3QsIG5vIG1hdHRlcg0KPiBpbiB3aGljaCBzZXF1ZW5jZSB0aGUgZXZlbnRzIGhhcHBl
bi4NCj4gDQo+IEluIHRoZW9yeSB0aGUgcGVyZm9ybWFuY2UgcGVuYWx0eSBjb3VsZCBiZSBmdXJ0
aGVyIHJlZHVjZWQgYnkNCj4gY29uZGl0aW9uYWxpemluZyB0aGlzIG9uIHRoZSBOTUkgaGFwcGVu
aW5nIGluIHRoZSBjcml0aWNhbCByZWdpb24gaW4gdGhlDQo+IEtWTSBjb2RlLCBidXQgaXQgc2Vl
bXMgdG8gYmUgcHJldHR5IGZhciBmcm9tIG5lY2Vzc2FyeSB0byBtZS4NCg0KV2Ugc2hvdWxkIGtl
ZXAgdGhlIGZvbGxvd2luZyBjb2RlIGluIHRoZSBGUkVEIE5NSSBoYW5kbGVyLCByaWdodD8NCg0K
ew0KLi4uDQoJdGhpc19jcHVfd3JpdGUobm1pX2NyMiwgcmVhZF9jcjIoKSk7DQouLi4NCglpZiAo
dW5saWtlbHkodGhpc19jcHVfcmVhZChubWlfY3IyKSAhPSByZWFkX2NyMigpKSkNCgkJd3JpdGVf
Y3IyKHRoaXNfY3B1X3JlYWQobm1pX2NyMikpOw0KLi4uDQp9DQoNCj4gVGhpcyBvYnZpb3VzbHkg
d2FzIGFuIHVuZm9ydHVuYXRlIG92ZXJzaWdodCBvbiBvdXIgcGFydCwgYnV0IHRoZQ0KPiB3b3Jr
YXJvdW5kIGlzIHNpbXBsZSBhbmQgZG9lc24ndCBhZmZlY3QgYW55IG5vbi1OTUkgcGF0aHMuDQo+
IA0KPiA+ICsNCj4gPiArCWlmIChJU19FTkFCTEVEKENPTkZJR19TTVApICYmDQo+IGFyY2hfY3B1
X2lzX29mZmxpbmUoc21wX3Byb2Nlc3Nvcl9pZCgpKSkNCj4gPiArCQlyZXR1cm47DQo+ID4gKw0K
PiANCj4gVGhpcyBpcyBjdXQgJiBwYXN0ZSBmcm9tIGVsc2V3aGVyZSBpbiB0aGUgTk1JIGNvZGUs
IGJ1dCBJIGJlbGlldmUgdGhlDQo+IElTX0VOQUJMRUQoKSBpcyB1bm5lY2Vzc2FyeSAobm90IHRv
IG1lbnRpb24gdWdseSk6IHNtcF9wcm9jZXNzb3JfaWQoKQ0KPiBzaG91bGQgYWx3YXlzIHJldHVy
biB6ZXJvIG9uIFVQLCBhbmQgYXJjaF9jcHVfaXNfb2ZmbGluZSgpIHJlZHVjZXMgdG8NCj4gIShj
cHUgPT0gMCksIHNvIHRoaXMgaXMgYSBzdGF0aWNhbGx5IHRydWUgY29uZGl0aW9uIG9uIFVQLg0K
DQpBaCwgZ29vZCBwb2ludCENCg==

