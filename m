Return-Path: <kvm+bounces-3408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA718040A3
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 22:01:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A13C41C20BAC
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 21:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F4435F1D;
	Mon,  4 Dec 2023 21:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ERj2GGLd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF341AA;
	Mon,  4 Dec 2023 13:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701723671; x=1733259671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Gx/qvjy+Kp6C3FT9r3sGT3PBQrpTnGFEWDqqKsatDMc=;
  b=ERj2GGLdFRYkAjfmbjUyoNWkDWwqhwM0KYGHTawBbk4h/DbtxiM80jb3
   FpqI0KrqH1bOI83GaGIZc4gi85AkoumDX7V+G7Y26BbfkyE2KZFCutUIZ
   /t22SK1i4+Ul/4u2OUJ9Z1fCj7OfTDUqwVPfisOzgYtSY5VI9JlxY7aqE
   s7PKFjv02uw3UCiwKC9Q02ac1v8562u1jwlWNr2EKQeHLQO29PFpMFnNf
   4pQ10HlJv1WcRRsx5M7cGEwleHjlJUK6iLQrUgO23QRkqnz+AFX90cFdw
   gTnmKCXizAna9biV6aX8+d7u1jbjWSnNMOUAjuhZbdNdx/nv197W67FvA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="842102"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="842102"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 13:01:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="720447086"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="720447086"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 13:01:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 13:01:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 13:01:09 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 13:00:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crkrHvUTVSEErmcQ4mAv/ntq14hF1iRIIAZIeEDnGGGyCCToXWZTgz3s3PR9qFm7sSVGYuLHdoekW+1Bqtx6paYZvq4Ot5+PoiwciM2CGnvaJdOFgRHxjr6HvJVKrAwei3qCK0bzVz8YeVxpUoYP4T6oI2TiN1+wzfBu08OFt1U8GoKW7Mrmt7eapZjvvq2Cq0+7AvtpprLPJcBKSJusVP57OuHnjUJxXJs5WJwdqc0mInxPdNA7D3Dw+N/d1g6AYdQKkmUoHZMLeJe09yzXzp+UHbYnm0MLyh9HFFuXgidMjoiSh+Wb2C2PJPhSQuHTZC0yI91cp51OIEUGVjkEOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gx/qvjy+Kp6C3FT9r3sGT3PBQrpTnGFEWDqqKsatDMc=;
 b=gQdEAhAsjwmZYzA/4RkxHbfpEsMm+975FqRC+z8xJcYgHoxWF4fqCWzrOX4KytjP+B3xoCx1faIzl8favMhjFQ5DfpDp/lZ+NPMQegBYoljRMLAaO2OCNPDQs0uJpJGB/5LspyoQawt5+/2dtV4OnJ4b+6FDKweeznbmVcQqZJsiSVx7XklbcX3+CpRCtPvf7GpIv8AlzDdV/hG5fzURcTqSqIJS/3afC/0ZMTXasu7VY4cgiyCE+d64yZh9eCr8cbjsmbNQQxbUVN9yy5GHQOpu4Or62jd7kaGdb1GiyCnXXMHXQoQKL8JSwOqKhMB1PdCYeZhRno3osgjFSJcRjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5218.namprd11.prod.outlook.com (2603:10b6:610:e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 21:00:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 21:00:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>, "david@redhat.com"
	<david@redhat.com>, "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"ak@linux.intel.com" <ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"Brown, Len" <len.brown@intel.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Huang, Ying"
	<ying.huang@intel.com>, "rafael@kernel.org" <rafael@kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwHtT+sYH5Rms0yY5S8b++o88LCVBfCAgAKQDACAAeyrgIAAQREA
Date: Mon, 4 Dec 2023 21:00:13 +0000
Message-ID: <dfbfe327704f65575219d8b895cf9f55985758da.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
	 <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com>
	 <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
	 <bcff605a-3b8d-4dcc-a5cb-63dab1a74ed4@intel.com>
In-Reply-To: <bcff605a-3b8d-4dcc-a5cb-63dab1a74ed4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5218:EE_
x-ms-office365-filtering-correlation-id: 5470f8c9-4128-48f1-3b06-08dbf50c028b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y6c6HwMF65Sr9eRkDlL9Q4YSjz8UF+zj+8Rs66H4UIkUmXKM0Gm6hmHhk8efqhVYCpmYvPpO8OTutCRg01YoYfzgC4QGVUkoGK1ujVulR5q0XZd1G2fx/lP5yZGsh47dGukOjDj3beQ2lGlsp5BajOc0yEL1m4zO7IEuT8+nl8BMVVbrWc7CvCUMPUcElJ5TL53ZB4VdGwnsf71QDNRGt5JasCVQLTcQlcgcHx/qG/A+LQ/xOze4rsa7pldsBr03yRKSkIZcpcQSdGjvgaj/8wYcLh9ogdB9tMm2YZ+MKGYhd+w2HtBtI+I931lEiVdGWeShgAvmQubO1XF2RhM+4djwJPrQW6DuDiV322hgLsfT5A+UKMqKKB5E1/RWtt22SA11sr0aNpxV3DCoO8886VEkswDyuksWsV48ImV2Nvum+eV85tmtMhWV2PnwXYzqtA9ryLvcCk1i/9w0JEattpJLn0upKDn+odoz7kOeNeCREB/xASJMNVhJReCm/52nG3PhyS9imigyE2PDhYBjDWy/hIaU+Y/ZM0jdydNUwzg9Ruu+Cl76cWSookWEo+ljcSUFv8yfAZidz0D7Hg83yjIvIZIsqygAmNIIoemo3nqyYAePu/BIyYwf1eBdDN6Q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(346002)(376002)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(5660300002)(86362001)(7416002)(4326008)(8676002)(8936002)(2906002)(38070700009)(41300700001)(6512007)(36756003)(2616005)(6506007)(82960400001)(53546011)(83380400001)(6486002)(478600001)(26005)(71200400001)(38100700002)(122000001)(110136005)(316002)(91956017)(54906003)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0JFWlQyWWR1cTF5cml4VDF2TCtqMkJvVXUwZWUydWw0WndvNExNTW11bW0v?=
 =?utf-8?B?cXBtZU9vd3F1VG1iUUpxUzJ2RnJMTVErYUVUb0k1NUlqdUI2eHdEb01CcE5Y?=
 =?utf-8?B?dU9VdjZQcWJLY2prWnBIMHh1cnhxMzFkU3JSN3p5SjRtUVlhNlBJY1dDK011?=
 =?utf-8?B?N0NTKytRbDdWZDVvcjZzeUVjcVJPL0Z1Mmg1L0dlWFVrbFVtQlZTeWpnMzMr?=
 =?utf-8?B?RFBvWUk5eFVDTE5pcDBXQzdtakFycThVVHlhbWVFSnVXNFVMNlp5RXRMamxW?=
 =?utf-8?B?SHdGdUQwTld1MVJnQkpJQVlFUmJXYlBHKzZTci9PRnJ2MzRnOFdGY3JXd3g4?=
 =?utf-8?B?SjdMYWlxcUh3MUZIeTg1NEVudDdLSERKdjVWNTlIejlwYWZseWR4bTMwR2Rx?=
 =?utf-8?B?M3laWVZvcXRHMFFLWmd1ZHhyQ21HSVA1T0o5blVWbDdtOUhUUVgxbVd6dERH?=
 =?utf-8?B?bHgrbkVobGZ5SGxueklVZTVONjExRzFHQTU5NjlYbUtPM3UwTVdGdGFWTU9h?=
 =?utf-8?B?ZHhpZ0FRR2tMaWxYNUoxVkFuRU0wSWgwMU1UenAvYVpVUGlNM2R3bFA1MXg2?=
 =?utf-8?B?d0NjdnFUbmdHMXBkek5wSUoxYWd0eE9PbXVqbEZOWWFuZVc3SGgxaXlKbVA3?=
 =?utf-8?B?aS9XcHg2dGxybE5jTUw2MzZaTldxT3V3Tit4MEJablBjZFVFMXFucEN0Z00y?=
 =?utf-8?B?cFRjWFFjSXhxeFpCcWkyc0RaZk5RNy9Ca1JpZmtvWnZzV0NLdERsNFFRWXc2?=
 =?utf-8?B?UCt2T0o2b2EvK3p5N292alIyajM1SW8xekJDU2g0L0MrOGxnOHdITzVIdnRy?=
 =?utf-8?B?UDhqWlI2VUh2MEk0QndFRnZMbGRCejJFd0xlM3I5ZTAwUUU5TlF4UHNNNXNN?=
 =?utf-8?B?elBlOGRlR3hvUzlRa29Gb3lFc1k3blhRUksyT09VVjJWUWdla1RoNFpoQ0h5?=
 =?utf-8?B?VktiRm1Kd0tGNjFkYS9vc2ZObjlhbFhCYlNqY1NyM285QkFkN3dSRURSbzBW?=
 =?utf-8?B?Qm9QTTdVdHJ0YlJDUm02dmUyQXlBbUVCTElEZWdXc2NNK296OVkzbGd4dS9i?=
 =?utf-8?B?NHlNbFY2dThFbWRQcUpFdTVVclRvT2src01UeStqNVltMnlpYm1jbHEzTkRs?=
 =?utf-8?B?QllYclBPaW1Tc3JvQ0pxR3hyZGs1ZkxTTHVHQUxINUlSYXBnSXJIdDlOM2dW?=
 =?utf-8?B?UGRXSDVqblBoM2dVc2pYY0J2U3plSllUaGhtS1BHSGk1RDNlN3R6ZTBsVytG?=
 =?utf-8?B?M3hQTG84eDc2eWZVYVg4WExtcG45TkVFdDM4aGErN05VRXMvQnk0aFdmUld4?=
 =?utf-8?B?NWloQ2djMnVCSGpyMVczQnJOQU44RW05dWFGQWxZZ1QyT2xPWTBpbzFQazVT?=
 =?utf-8?B?MkgxOWdTU2VJVTFTQllEN1RESEQzTHFJMzBMbEF1cHYwRWd2RFlXR3RIUE1n?=
 =?utf-8?B?ZWl2NnlpZlNKWkd1T0NRVWlySGZRWFFrWUoyeTZXZ0pqaGd3TEVIWWhTMDNI?=
 =?utf-8?B?N2tJanZIS2x0cElaK0YvbVQyZDVJMVFQY29SQzM3c0hzSVE4V2RjQjcxaVNL?=
 =?utf-8?B?VjJjMmF0ZDNSK0xVOGJiRC9aQit0cGE5dGc3ZjkyZzNXQkdWcUU2M0JxQU1m?=
 =?utf-8?B?STBsdURkQ0RGME5WZnNzNS9CdUVxMTNFQUFKTDM4Ukp1UVg3VmZwU09DMExK?=
 =?utf-8?B?bEhEMXI3a1NuSklNaDNuTGM2VDYvWlpweUdHa2JCbGYwMlc3MEdkRGMyZi90?=
 =?utf-8?B?eDBoc3Y5YmlsTGowa2N6UkM1RG9FOFJuZFQ5MEo1OVAxUlJWcldPVk85dGcw?=
 =?utf-8?B?eWtWK3dOdUJJNGJyeVJja2IxNk02bjVReWdkQ2FnTTBhc1ZDV0EyNVJCdG9N?=
 =?utf-8?B?eDFuRmdkUlFpSkZMaTZGWGd6NHg4YXVvRktQNVRZWXdLa1MrZnB0b3BhUFgr?=
 =?utf-8?B?MXB2NGkvcDJZcEVNajBWNjBKeS81VlJJU3VxUWpzUW1PbUFZTGZsam5XVlk4?=
 =?utf-8?B?NlhpVnczd1BJM0YvQ0tjUzlmZ0xjOXo0ejF3aHdITlN1UUNIQmhkbUJZMGFm?=
 =?utf-8?B?RkZTZTNxc2RvYzJ2aWdNZzVEZjE3Umx6VHJNSEoyeEdYeW5WZGx3cUlKN08w?=
 =?utf-8?B?KytvbGZqaW9aUVE1UHBuemtZT2ZTSDRuMURaSEVkaThKVTlaT2M2YXNIUHcv?=
 =?utf-8?B?Ymc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <117552376CDED045A6912104A27C9226@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5470f8c9-4128-48f1-3b06-08dbf50c028b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 21:00:13.3947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5UdRnTHXawFcAd6JE+30eTIGYKA3QAFFdSclJOVj5LfUlOfw5DJUgqnKeLVh8IWYBixlfY7ELhE8FhzEw4Ajyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5218
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTEyLTA0IGF0IDA5OjA3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvMy8yMyAwMzo0NCwgSHVhbmcsIEthaSB3cm90ZToNCj4gLi4uDQo+ID4gPiBJdCBkb2Vz
bid0IG5lZWQgcGVyZmVjdCBhY2N1cmFjeS4gIEJ1dCBob3cgZG8gd2Uga25vdyBpdCdzIG5vdCBn
b2luZyB0bw0KPiA+ID4gZ28sIGZvciBpbnN0YW5jZSwgY2hhc2UgYSBiYWQgcG9pbnRlcj8NCj4g
PiA+IA0KPiA+ID4gPiArICAgaWYgKHRkeF9tb2R1bGVfc3RhdHVzICE9IFREWF9NT0RVTEVfSU5J
VElBTElaRUQpDQo+ID4gPiA+ICsgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4gPiA+IA0KPiA+
ID4gQXMgYW4gZXhhbXBsZSwgd2hhdCBwcmV2ZW50cyB0aGlzIENQVSBmcm9tIG9ic2VydmluZw0K
PiA+ID4gdGR4X21vZHVsZV9zdGF0dXM9PVREWF9NT0RVTEVfSU5JVElBTElaRUQgd2hpbGUgdGhl
IFBBTVQgc3RydWN0dXJlIGlzDQo+ID4gPiBiZWluZyBhc3NlbWJsZWQ/DQo+ID4gDQo+ID4gVGhl
cmUgYXJlIHR3byB0eXBlcyBvZiBtZW1vcnkgb3JkZXIgc2VyaWFsaXppbmcgb3BlcmF0aW9ucyBi
ZXR3ZWVuIGFzc2VtYmxpbmcNCj4gPiB0aGUgVERNUi9QQU1UIHN0cnVjdHVyZSBhbmQgc2V0dGlu
ZyB0aGUgdGR4X21vZHVsZV9zdGF0dXMgdG8NCj4gPiBURFhfTU9EVUxFX0lOSVRJQUxJWkVEOiAx
KSB3YnZpbmRfb25fYWxsX2NwdXMoKTsgMikgYnVuY2ggb2YgU0VBTUNBTExzOw0KPiA+IA0KPiA+
IFdCSU5WRCBpcyBhIHNlcmlhbGl6aW5nIGluc3RydWN0aW9uLiAgU0VBTUNBTEwgaXMgYSBWTUVY
SVQgdG8gdGhlIFREWCBtb2R1bGUsDQo+ID4gd2hpY2ggaW52b2x2ZXMgR0RUL0xEVC9jb250cm9s
IHJlZ2lzdGVycy9NU1JzIHN3aXRjaCBzbyBpdCBpcyBhbHNvIGEgc2VyaWFsaXppbmcNCj4gPiBv
cGVyYXRpb24uDQo+ID4gDQo+ID4gQnV0IHBlcmhhcHMgd2UgY2FuIGV4cGxpY2l0bHkgYWRkIGEg
c21wX3dtYigpIGJldHdlZW4gYXNzZW1ibGluZyBURE1SL1BBTVQNCj4gPiBzdHJ1Y3R1cmUgYW5k
IHNldHRpbmcgdGR4X21vZHVsZV9zdGF0dXMgaWYgdGhhdCdzIGJldHRlci4NCj4gDQo+IC4uLiBh
bmQgdGhlcmUncyB6ZXJvIGRvY3VtZW50YXRpb24gb2YgdGhpcyBkZXBlbmRlbmN5IGJlY2F1c2Ug
Li4uID8NCj4gDQo+IEkgc3VzcGVjdCBpdCdzIGJlY2F1c2UgaXQgd2FzIG5ldmVyIGxvb2tlZCBh
dCB1bnRpbCBUb255IG1hZGUgYSBjb21tZW50DQo+IGFib3V0IGl0IGFuZCB3ZSBzdGFydGVkIGxv
b2tpbmcgYXQgaXQuICBJbiBvdGhlciB3b3JkcywgaXQgd29ya2VkIGJ5DQo+IGNvaW5jaWRlbmNl
Lg0KDQpJIHNob3VsZCBoYXZlIHB1dCBhIGNvbW1lbnQgYXJvdW5kIGhlcmUuICBNeSBiYWQuDQoN
CktpcmlsbCBhbHNvIGhlbHBlZCB0byBsb29rIGF0IHRoZSBjb2RlLg0KDQo+IA0KPiA+ID4gPiAr
ICAgZm9yIChpID0gMDsgaSA8IHRkbXJfbGlzdC0+bnJfY29uc3VtZWRfdGRtcnM7IGkrKykgew0K
PiA+ID4gPiArICAgICAgICAgICB1bnNpZ25lZCBsb25nIGJhc2UsIHNpemU7DQo+ID4gPiA+ICsN
Cj4gPiA+ID4gKyAgICAgICAgICAgdGRtcl9nZXRfcGFtdCh0ZG1yX2VudHJ5KHRkbXJfbGlzdCwg
aSksICZiYXNlLCAmc2l6ZSk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICAgICAgaWYgKHBo
eXMgPj0gYmFzZSAmJiBwaHlzIDwgKGJhc2UgKyBzaXplKSkNCj4gPiA+ID4gKyAgICAgICAgICAg
ICAgICAgICByZXR1cm4gdHJ1ZTsNCj4gPiA+ID4gKyAgIH0NCj4gPiA+ID4gKw0KPiA+ID4gPiAr
ICAgcmV0dXJuIGZhbHNlOw0KPiA+ID4gPiArfQ0KPiA+ID4gPiArDQo+ID4gPiA+ICsvKg0KPiA+
ID4gPiArICogUmV0dXJuIHdoZXRoZXIgdGhlIG1lbW9yeSBwYWdlIGF0IHRoZSBnaXZlbiBwaHlz
aWNhbCBhZGRyZXNzIGlzIFREWA0KPiA+ID4gPiArICogcHJpdmF0ZSBtZW1vcnkgb3Igbm90LiAg
Q2FsbGVkIGZyb20gI01DIGhhbmRsZXIgZG9fbWFjaGluZV9jaGVjaygpLg0KPiA+ID4gPiArICoN
Cj4gPiA+ID4gKyAqIE5vdGUgdGhpcyBmdW5jdGlvbiBtYXkgbm90IHJldHVybiBhbiBhY2N1cmF0
ZSByZXN1bHQgaW4gcmFyZSBjYXNlcy4NCj4gPiA+ID4gKyAqIFRoaXMgaXMgZmluZSBhcyB0aGUg
I01DIGhhbmRsZXIgZG9lc24ndCBuZWVkIGEgMTAwJSBhY2N1cmF0ZSByZXN1bHQsDQo+ID4gPiA+
ICsgKiBiZWNhdXNlIGl0IGNhbm5vdCBkaXN0aW5ndWlzaCAjTUMgYmV0d2VlbiBzb2Z0d2FyZSBi
dWcgYW5kIHJlYWwNCj4gPiA+ID4gKyAqIGhhcmR3YXJlIGVycm9yIGFueXdheS4NCj4gPiA+ID4g
KyAqLw0KPiA+ID4gPiArYm9vbCB0ZHhfaXNfcHJpdmF0ZV9tZW0odW5zaWduZWQgbG9uZyBwaHlz
KQ0KPiA+ID4gPiArew0KPiA+ID4gPiArICAgc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0g
ew0KPiA+ID4gPiArICAgICAgICAgICAucmN4ID0gcGh5cyAmIFBBR0VfTUFTSywNCj4gPiA+ID4g
KyAgIH07DQo+ID4gPiA+ICsgICB1NjQgc3JldDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgaWYg
KCFwbGF0Zm9ybV90ZHhfZW5hYmxlZCgpKQ0KPiA+ID4gPiArICAgICAgICAgICByZXR1cm4gZmFs
c2U7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgIC8qIEdldCBwYWdlIHR5cGUgZnJvbSB0aGUgVERY
IG1vZHVsZSAqLw0KPiA+ID4gPiArICAgc3JldCA9IF9fc2VhbWNhbGxfcmV0KFRESF9QSFlNRU1f
UEFHRV9SRE1ELCAmYXJncyk7DQo+ID4gPiA+ICsgICAvKg0KPiA+ID4gPiArICAgICogSGFuZGxl
IHRoZSBjYXNlIHRoYXQgQ1BVIGlzbid0IGluIFZNWCBvcGVyYXRpb24uDQo+ID4gPiA+ICsgICAg
Kg0KPiA+ID4gPiArICAgICogS1ZNIGd1YXJhbnRlZXMgbm8gVk0gaXMgcnVubmluZyAodGh1cyBu
byBURFggZ3Vlc3QpDQo+ID4gPiA+ICsgICAgKiB3aGVuIHRoZXJlJ3MgYW55IG9ubGluZSBDUFUg
aXNuJ3QgaW4gVk1YIG9wZXJhdGlvbi4NCj4gPiA+ID4gKyAgICAqIFRoaXMgbWVhbnMgdGhlcmUg
d2lsbCBiZSBubyBURFggZ3Vlc3QgcHJpdmF0ZSBtZW1vcnkNCj4gPiA+ID4gKyAgICAqIGFuZCBT
ZWN1cmUtRVBUIHBhZ2VzLiAgSG93ZXZlciB0aGUgVERYIG1vZHVsZSBtYXkgaGF2ZQ0KPiA+ID4g
PiArICAgICogYmVlbiBpbml0aWFsaXplZCBhbmQgdGhlIG1lbW9yeSBwYWdlIGNvdWxkIGJlIFBB
TVQuDQo+ID4gPiA+ICsgICAgKi8NCj4gPiA+ID4gKyAgIGlmIChzcmV0ID09IFREWF9TRUFNQ0FM
TF9VRCkNCj4gPiA+ID4gKyAgICAgICAgICAgcmV0dXJuIGlzX3BhbXRfcGFnZShwaHlzKTsNCj4g
PiA+IA0KPiA+ID4gRWl0aGVyIHRoaXMgaXMgY29tbWVudCBpcyB3b25reSBvciB0aGUgbW9kdWxl
IGluaXRpYWxpemF0aW9uIGlzIGJ1Z2d5Lg0KPiA+ID4gDQo+ID4gPiBjb25maWdfZ2xvYmFsX2tl
eWlkKCkgZ29lcyBhbmQgZG9lcyBTRUFNQ0FMTHMgb24gYWxsIENQVXMuICBUaGVyZSBhcmUNCj4g
PiA+IHplcm8gY2hlY2tzIG9yIHNwZWNpYWwgaGFuZGxpbmcgaW4gdGhlcmUgZm9yIHdoZXRoZXIg
dGhlIENQVSBoYXMgZG9uZQ0KPiA+ID4gVk1YT04uICBTbywgYnkgdGhlIHRpbWUgd2UndmUgc3Rh
cnRlZCBpbml0aWFsaXppbmcgdGhlIFREWCBtb2R1bGUNCj4gPiA+IChpbmNsdWRpbmcgdGhlIFBB
TVQpLCBhbGwgb25saW5lIENQVXMgbXVzdCBiZSBhYmxlIHRvIGRvIFNFQU1DQUxMcy4gIFJpZ2h0
Pw0KPiA+ID4gDQo+ID4gPiBTbyBob3cgY2FuIHdlIGhhdmUgYSB3b3JraW5nIFBBTVQgaGVyZSB3
aGVuIHRoaXMgQ1BVIGNhbid0IGRvIFNFQU1DQUxMcz8NCj4gPiANCj4gPiBUaGUgY29ybmVyIGNh
c2UgaXMgS1ZNIGNhbiBlbmFibGUgVk1YIG9uIGFsbCBjcHVzLCBpbml0aWFsaXplIHRoZSBURFgg
bW9kdWxlLA0KPiA+IGFuZCB0aGVuIGRpc2FibGUgVk1YIG9uIGFsbCBjcHVzLiAgT25lIGV4YW1w
bGUgaXMgS1ZNIGNhbiBiZSB1bmxvYWRlZCBhZnRlciBpdA0KPiA+IGluaXRpYWxpemVzIHRoZSBU
RFggbW9kdWxlLg0KPiA+IA0KPiA+IEluIHRoaXMgY2FzZSBDUFUgY2Fubm90IGRvIFNFQU1DQUxM
IGJ1dCBQQU1UcyBhcmUgYWxyZWFkeSB3b3JraW5nIDotKQ0KPiA+IA0KPiA+IEhvd2V2ZXIgaWYg
U0VBTUNBTEwgY2Fubm90IGJlIG1hZGUgKGR1ZSB0byBvdXQgb2YgVk1YKSwgdGhlbiB0aGUgbW9k
dWxlIGNhbiBvbmx5DQo+ID4gYmUgaW5pdGlhbGl6ZWQgb3IgdGhlIGluaXRpYWxpemF0aW9uIGhh
c24ndCBiZWVuIHRyaWVkLCBzbyBib3RoDQo+ID4gdGR4X21vZHVsZV9zdGF0dXMgYW5kIHRoZSB0
ZHhfdGRtcl9saXN0IGFyZSBzdGFibGUgdG8gYWNjZXNzLg0KPiANCj4gTm9uZSBvZiB0aGlzIGV2
ZW4gbWF0dGVycy4gIExldCdzIHJlbWluZCBvdXJzZWx2ZXMgaG93IHVuYmVsaWV2YWJseQ0KPiB1
bmxpa2VseSB0aGlzIGlzOg0KPiANCj4gMS4gWW91J3JlIG9uIGFuIGFmZmVjdGVkIHN5c3RlbSB0
aGF0IGhhcyB0aGUgZXJyYXR1bQ0KPiAyLiBUaGUgS1ZNIG1vZHVsZSBnZXRzIHVubG9hZGVkLCBy
dW5zIHZteG9mZg0KPiAzLiBBIGtlcm5lbCBidWcgdXNpbmcgYSB2ZXJ5IHJhcmUgcGFydGlhbCB3
cml0ZSBjb3JydXB0cyB0aGUgUEFNVA0KPiA0LiBBIHNlY29uZCBidWcgcmVhZHMgdGhlIFBBTVQg
Y29uc3VtaW5nIHBvaXNvbiwgI01DIGlzIGdlbmVyYXRlZA0KPiA1LiBFbnRlciAjTUMgaGFuZGxl
ciwgU0VBTUNBTEwgZmFpbHMNCj4gNi4gI01DIGhhbmRsZXIganVzdCByZXBvcnRzIGEgcGxhaW4g
aGFyZHdhcmUgZXJyb3INCg0KWWVzIHRvdGFsbHkgYWdyZWUgaXQgaXMgdmVyeSB1bmxpa2VseSB0
byBoYXBwZW4uICANCg0KPiANCj4gVGhlIG9ubHkgdGhpbmcgZXZlbiByZW1vdGVseSB3cm9uZyB3
aXRoIHRoaXMgc2l0dWF0aW9uIGlzIHRoYXQgdGhlDQo+IHJlcG9ydCB3b24ndCBwaW4gdGhlICNN
QyBvbiBURFguICBQbGF5IHN0dXBpZCBnYW1lcyAocmVtb3ZpbmcgbW9kdWxlcyksDQo+IHdpbiBz
dHVwaWQgcHJpemVzICh3b3JzZSBlcnJvciBtZXNzYWdlKS4NCj4gDQo+IENhbiB3ZSBkeW5hbWlj
YWxseSBtYXJrIGEgbW9kdWxlIGFzIHVuc2FmZSB0byByZW1vdmU/ICBJZiBzbywgSSdkDQo+IGhh
cHBpbHkganVzdCBzYXkgdGhhdCB3ZSBzaG91bGQgbWFrZSBrdm1faW50ZWwua28gdW5zYWZlIHRv
IHJlbW92ZSB3aGVuDQo+IFREWCBpcyBzdXBwb3J0ZWQgYW5kIG1vdmUgb24gd2l0aCBsaWZlLg0K
PiANCj4gdGw7ZHI6IEkgdGhpbmsgZXZlbiBsb29raW5nIGEgI01DIG9uIHRoZSBQQU1UIGFmdGVy
IHRoZSBrdm0gbW9kdWxlIGlzDQo+IHJlbW92ZWQgaXMgYSBmb29sJ3MgZXJyYW5kLg0KDQpTb3Jy
eSBJIHdhc24ndCBjbGVhciBlbm91Z2guICBLVk0gYWN0dWFsbHkgdHVybnMgb2ZmIFZNWCB3aGVu
IGl0IGRlc3Ryb3lzIHRoZQ0KbGFzdCBWTSwgc28gdGhlIEtWTSBtb2R1bGUgZG9lc24ndCBuZWVk
IHRvIGJlIHJlbW92ZWQgdG8gdHVybiBvZmYgVk1YLiAgSSB1c2VkDQoiS1ZNIGNhbiBiZSB1bmxv
YWRlZCIgYXMgYW4gZXhhbXBsZSB0byBleHBsYWluIHRoZSBQQU1UIGNhbiBiZSB3b3JraW5nIHdo
ZW4gVk1YDQppcyBvZmYuDQoNCg==

