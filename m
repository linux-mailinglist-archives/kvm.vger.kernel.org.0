Return-Path: <kvm+bounces-2533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FBDA7FAC0F
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 21:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24743280FE9
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 20:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932913DB81;
	Mon, 27 Nov 2023 20:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="flIowkwJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E11187;
	Mon, 27 Nov 2023 12:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701118380; x=1732654380;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SQt5MS5QpYNomlKcBprANazYIvLAJMaR61NLhViWq1o=;
  b=flIowkwJdeQNze2YD0Lda8wEvSJIIL2GeSeJgmjD7GYdXFlqQXBSB4hP
   Q4YeuOGZJX22YsKrzmTrldAfZnjQt4bz9ENWuOprPZqFNTME5l1XhCJwJ
   Wc4RRd93hoQZmt+F/yZ+xCRFL9ZJ5skIRv9SiO7I92bKLRAMXY4JiMjVQ
   aKtUDhROf5H8pK/TBuBfSC3sslOJnFznIJMb+bEgZDT9cjPMKZIqGfz2f
   SeLVjuax20+BmLla5pXNGgwFJKYJbF4YQFtlIKefGX+YPCN9DOg+Sn+Mi
   kfx7RnOPi963Um0xe30w+c66OclNT2fwVkxOJPH3vNU8c8g0VV4ZRtuHq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="377818430"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="377818430"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 12:52:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="744682054"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="744682054"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 12:52:59 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 12:52:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 12:52:58 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 12:52:58 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 12:52:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IP4AvedAXRX5Z7Sv5jwXrHl38tLA8kpzTXAINnw3uP8/KOVwMoBOCNnCgwowwJVB+sL1N+soW9dD/Guryx2oNkNNfA7d6glAgMWjJAb38yXQxpsOHrCHnCfVZMg1US1k+J55QwSPlNN2/OIEtYbDO2ec6StXRkIRG2+YEl8pGPtkEkLcgJtbucesE+YRJUUYg8tSgo3KpaM/PdHT921fZRWuR1Pknv996BcAaodIYPSRm2JAlbEfZAeOSJnXwpIuJz14dyNxXvxM/GHqmY90+RRmNpQtx6O1d/hICiztWFircOlPnnr4Epud5no6UZSzNCoumHTjyJoH/wZbZCdLkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQt5MS5QpYNomlKcBprANazYIvLAJMaR61NLhViWq1o=;
 b=HUXwbzuCOe4g2NTmQVVUt9iYh/C5vDTXgi54acJaPKJWXs6MbZhnMlBGnf0mK4P83GkG1kehNMVQmsLfwr67J+ML1nb4hKJtRc2lWhywg0G7pjK3zPldr/rpBojIVzgYhhoSZUaGtdnTK0A/V1ilx4Plq9Tpiyt6VuYAFSWO5eOvRR8to3uzRCN7a1b8vKQRrsIcQm+E+iwg1b+crx888mkzf1hqHIdq3U2S0CJxnaM4BYOyGyjB7U0YnXHfAWEdJkJZfVUc0fMX9k9z+RBToWLKpI8OvDwASCB3gDpQMKuQfTeA+P6Yj1uBowiLQUwSzWeK2YCiAlhsX2jvo4zwkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB7029.namprd11.prod.outlook.com (2603:10b6:303:22e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.27; Mon, 27 Nov
 2023 20:52:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 20:52:55 +0000
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
Subject: Re: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Thread-Topic: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Thread-Index: AQHaEwHp2HWZl9Al5EWrZJMGp6I1arCOlOeAgAAWWQCAAAj5gIAADSMA
Date: Mon, 27 Nov 2023 20:52:55 +0000
Message-ID: <f74375b44d86f11843901a909e60bed228809677.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <2151c68079c1cb837d07bd8015e4ff1f662e1a6e.1699527082.git.kai.huang@intel.com>
	 <cfea7192-4b29-46f9-a500-149121f493c8@intel.com>
	 <e8fd4bff8244e9e709c997da309e73a932567959.camel@intel.com>
	 <4ca2f6c1-97a7-4992-b01f-60341f6749ff@intel.com>
In-Reply-To: <4ca2f6c1-97a7-4992-b01f-60341f6749ff@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB7029:EE_
x-ms-office365-filtering-correlation-id: 8a221200-a07a-4096-7c7f-08dbef8ad463
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e5xNWSQHYBQ415Y+jSYf9EmaEtBV8p3TJ/NvrusCHeaJjr9twRbyeMBLv/4L+1V3N8t37w0eJDzdLw00c46K4cpQZSg2+egSN1NyNtk8PXFL+PJEkhe9e7xPEtBEsiZd9x3STBZh3KAbdfXv802WS2m2O/hHGokMLU6EBmMacMW01Gy6+1JLeqFinR/So9RbhNOCVbO/nyaofirMhEj6UrtUlVGLLLudGlA8VlCaFtG8VNcH6N7pctafT4vPs4CFhl1A+NnggcfmWAsCf19e3C9hRPQ4cCucGpAndMvcbY8SKN4PdH1BnW79EW8kVF/AH52mho66n5e6Pe8Ei2L4DvUG2LOUs+vOIRfrQQIqfGYiK/Y+Xg60Il9rEDA1CbKsFxqX2knORmEg+GmB9BbSZZ2ksPdZ/XrAJPzHsLFho+d0BWsQ/AOYeJ3GR6ggXOqeKA5LZLAmfYjIpk45a/ryZk87LVzehwZD+nZT/lfqbPY7C8G0DOwtbDAoE7m6SFFeSxNJqqmWg1UD2JF/XXFXLA8JSjBPOUWV9NPvBi0ucRLRuACjftPUsQMQH7xiw3nx5SgDm4mYbeWUpItSsiVEz2AOvJyWcQ1mqUg48aMWis8o7EheNFQMbYNFoJh8acz+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(346002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(316002)(66446008)(64756008)(66476007)(66556008)(54906003)(91956017)(36756003)(76116006)(110136005)(6486002)(71200400001)(2616005)(6512007)(86362001)(53546011)(26005)(82960400001)(38100700002)(66946007)(6506007)(83380400001)(122000001)(478600001)(4001150100001)(2906002)(38070700009)(5660300002)(7416002)(41300700001)(4326008)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHRPem14VjBMNnQ5bXpIRFJLa1Yvem5WOXByNGRlL2NicmRORGY2U0ZJdzhh?=
 =?utf-8?B?UlFKS1RBVkk1WW53TWdaNWVZd1NYZTBpODJDSGhzbkt1LzZ4S0lkSk9jTTIv?=
 =?utf-8?B?NGZWVForZCtlL0J0a0RFOUhRWEtTMCtKdDlxbVMyUUtkYllMSXRxOFdQSHB5?=
 =?utf-8?B?ZXJIMXZpT1BjRWpYYTNzTlZGakMxaHNJcW51eFFNMnpwakNpdHI0djE5dXZj?=
 =?utf-8?B?MDUydG51VmdaYmZYd1BmUm1SWERYcVROTzQ2V3NQZ0VRY2hiWHZlaHFCNHBw?=
 =?utf-8?B?TmJ6RVhhNDdreWFhSDRGMHdKdDVFb0tKY05Pai84NENWRkVIUEU0ZXZZZ3dk?=
 =?utf-8?B?WGxGZG9MWFhIUlZjM0Jhdm12SW4ycDRuV0V0NGhTR3gzVVh3VWorNUZEaGRp?=
 =?utf-8?B?RkE1Zk1lQjJ2T1dlTk9KenhyYklXeW1NWHJlVlZjcFV0R0diRkg2TUQ3MnBx?=
 =?utf-8?B?NTY1N1B3QVNVRFJhN1dzcWR2ajRUZUorZVU2REdIdEhWUTY0cDVEYjlKU2Y2?=
 =?utf-8?B?eW5NYVN0SHFmQXlmOFU2TitYemp3WE1UV1pNV1puelViWDlMb0k0UTZ0cnZj?=
 =?utf-8?B?dkdFaEJqbTVtK0owUzYwM2pWWDNuRGJ4QUxyUXBlYVhhaE80amJReWY2Mmd1?=
 =?utf-8?B?cVJ2QzRsUklMNHA1Z0JBWUQvdWZmSHF3RC9BSzJnN25EYVRUamlUbko1QlZV?=
 =?utf-8?B?SzlCK3VHSHR5VmtTMXhiWlpWZUpTY2lDbHh6bUxKZFpxY2ZzbGNoUWxZUWlB?=
 =?utf-8?B?ekJvb1Z5UEZzT1h5K1lIa2pjc3BscTZIbDZpTXRSMEZjYUNsTUhRNC9PSlYv?=
 =?utf-8?B?aUJkTkNLVHFuQWRxdGYrMkthUlI3MTBLWDdJWlJZTDBwNTc2Zkl0MmtqWTFB?=
 =?utf-8?B?OFMvMVcwQmpDUytsRXZnREFrMit2TmtTWkh5VUZUTWl6Y25Dc01GRVVsWmdE?=
 =?utf-8?B?aCtrRzdDcWhodXAyVnVXcFBKdzRmVEhCWXI4eE5zZDQvbXBzaVMwZWNhQVVQ?=
 =?utf-8?B?UnhjZXdOblI4L3VXNlpzRThxc090d1hNV0VIVDQ5T0xtUmo0TDVEN3ZkY2Rr?=
 =?utf-8?B?Y05ocm1QY0Z1NS9IaVRUNG5JVGpzTHphNlc1eWROQlRMUGlDNXkvbEFpUWls?=
 =?utf-8?B?UnVGY0xXVnRTb3lrZWpMVklTcDZiYkpITGcxUzFmWFpzME1UT3l3QnZoc05M?=
 =?utf-8?B?TUgzVGlFZWFVZDIrYlZNUHo1YitMSFBwMGVIbVptMWVLR2N5RjRwMzJCWWZQ?=
 =?utf-8?B?ZFFpeHpwbWpNdVNPYmFsRWRtSEptNW1iU2NoeVBUaGF2VHl5eGNqbVRDUWlB?=
 =?utf-8?B?MytVMjFPNzl5MGgvSlNmcVBnV2EvblNoVy8zUDlIcHVPSlVMYjFqdjJsR3c1?=
 =?utf-8?B?Wng4OFF5RDlxUWN1MmVLWFNPRnd3NVMyTm1Ra2NtSVJXRllQbkdRd0g4VUxU?=
 =?utf-8?B?WEFCTTJDUG56WXBiN0JITGJVeEVvZ2ZWUlYyK0ZKL3RyS2RzMW04WVdMU3Rp?=
 =?utf-8?B?TW9QTXUvOVdleXRCb0xoYVFXejdBb2ZJVUZNU0c5VXEwRDgraUdDZEdHQjFr?=
 =?utf-8?B?Mi9xWjYvVDF5SlBFa3VmYjJNVGxNME1GMVoxa1M3R3h5a0VmNVNINmFBbjNy?=
 =?utf-8?B?RWlqYzh5TVBxK0JTMVhnUmViUG5IWEQvdVBNSVRvd2J2d0VMQ0NmNlNiWDF6?=
 =?utf-8?B?Tkd5aUNNL0NoZ25oSXJBRjh1QnIwaHpEbi9DUW02dVdSdVozMVBVQSsrUXVv?=
 =?utf-8?B?bmtBaVdpWWJLd3BKRU1CRkxwbmNsVUZVU1diZmZmUUYxN3AwMVlCczRQY1M2?=
 =?utf-8?B?MXlyNHE1OGtla1dkQyt6UVBJRVQzaENqZHd2UFRCb1lhbWVUU3FxRVNqcmw0?=
 =?utf-8?B?cHdFbDNHYlZlQlNic3QrUlJIS1pZdHZ6SWZCVTlZYVl2YVVVYjUrc29hR3Jv?=
 =?utf-8?B?bmxNbEV1S3RrRW9id0M1Q3NDdUxHelIwcFZ0aHZoN014S3gyUTlqZU9yOUJE?=
 =?utf-8?B?VjZIbXBLbE1DSUFCN2J1Z3JGaTdER09naFRxRTNzbU9NbWpDZGVjQTRXRkI1?=
 =?utf-8?B?NDg4VTdnUE5SM1RtNk5INnV0eFNRQThwajBRWE5kYnBEWkI0cXJ3UklGSzFo?=
 =?utf-8?B?MkEvaG1MK0tncmRVM1NVSVljMGpjYjhRWTB2MGlVMms2Z1JkaDhlNFpHeE1N?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F92602A9EFC96E47AF61C2E77B46B5F8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a221200-a07a-4096-7c7f-08dbef8ad463
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2023 20:52:55.0672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HuCiDDxx/NLD59P87ujqAEgCMGhgPeCTjQ4zzBgUZGeYh7/xgcao1W5rcyuOgEiVdqrR7FduSF+tLzHeRASUEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7029
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTExLTI3IGF0IDEyOjA1IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjcvMjMgMTE6MzMsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gTW9uLCAyMDIzLTEx
LTI3IGF0IDEwOjEzIC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+ID4gPiBPbiAxMS85LzIz
IDAzOjU1LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiAuLi4NCj4gPiA+ID4gLS0tIGEvYXJjaC94
ODYva2VybmVsL3JlYm9vdC5jDQo+ID4gPiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9yZWJvb3Qu
Yw0KPiA+ID4gPiBAQCAtMzEsNiArMzEsNyBAQA0KPiA+ID4gPiAgI2luY2x1ZGUgPGFzbS9yZWFs
bW9kZS5oPg0KPiA+ID4gPiAgI2luY2x1ZGUgPGFzbS94ODZfaW5pdC5oPg0KPiA+ID4gPiAgI2lu
Y2x1ZGUgPGFzbS9lZmkuaD4NCj4gPiA+ID4gKyNpbmNsdWRlIDxhc20vdGR4Lmg+DQo+ID4gPiA+
IA0KPiA+ID4gPiAgLyoNCj4gPiA+ID4gICAqIFBvd2VyIG9mZiBmdW5jdGlvbiwgaWYgYW55DQo+
ID4gPiA+IEBAIC03NDEsNiArNzQyLDIwIEBAIHZvaWQgbmF0aXZlX21hY2hpbmVfc2h1dGRvd24o
dm9pZCkNCj4gPiA+ID4gICAgIGxvY2FsX2lycV9kaXNhYmxlKCk7DQo+ID4gPiA+ICAgICBzdG9w
X290aGVyX2NwdXMoKTsNCj4gPiA+ID4gICNlbmRpZg0KPiA+ID4gPiArICAgLyoNCj4gPiA+ID4g
KyAgICAqIHN0b3Bfb3RoZXJfY3B1cygpIGhhcyBmbHVzaGVkIGFsbCBkaXJ0eSBjYWNoZWxpbmVz
IG9mIFREWA0KPiA+ID4gPiArICAgICogcHJpdmF0ZSBtZW1vcnkgb24gcmVtb3RlIGNwdXMuICBV
bmxpa2UgU01FLCB3aGljaCBkb2VzIHRoZQ0KPiA+ID4gPiArICAgICogY2FjaGUgZmx1c2ggb24g
X3RoaXNfIGNwdSBpbiB0aGUgcmVsb2NhdGVfa2VybmVsKCksIGZsdXNoDQo+ID4gPiA+ICsgICAg
KiB0aGUgY2FjaGUgZm9yIF90aGlzXyBjcHUgaGVyZS4gIFRoaXMgaXMgYmVjYXVzZSBvbiB0aGUN
Cj4gPiA+ID4gKyAgICAqIHBsYXRmb3JtcyB3aXRoICJwYXJ0aWFsIHdyaXRlIG1hY2hpbmUgY2hl
Y2siIGVycmF0dW0gdGhlDQo+ID4gPiA+ICsgICAgKiBrZXJuZWwgbmVlZHMgdG8gY29udmVydCBh
bGwgVERYIHByaXZhdGUgcGFnZXMgYmFjayB0byBub3JtYWwNCj4gPiA+ID4gKyAgICAqIGJlZm9y
ZSBib290aW5nIHRvIHRoZSBuZXcga2VybmVsIGluIGtleGVjKCksIGFuZCB0aGUgY2FjaGUNCj4g
PiA+ID4gKyAgICAqIGZsdXNoIG11c3QgYmUgZG9uZSBiZWZvcmUgdGhhdC4gIElmIHRoZSBrZXJu
ZWwgdG9vayBTTUUncyB3YXksDQo+ID4gPiA+ICsgICAgKiBpdCB3b3VsZCBoYXZlIHRvIG11Y2sg
d2l0aCB0aGUgcmVsb2NhdGVfa2VybmVsKCkgYXNzZW1ibHkgdG8NCj4gPiA+ID4gKyAgICAqIGRv
IG1lbW9yeSBjb252ZXJzaW9uLg0KPiA+ID4gPiArICAgICovDQo+ID4gPiA+ICsgICBpZiAocGxh
dGZvcm1fdGR4X2VuYWJsZWQoKSkNCj4gPiA+ID4gKyAgICAgICAgICAgbmF0aXZlX3diaW52ZCgp
Ow0KPiA+ID4gDQo+ID4gPiBXaHkgY2FuJ3QgdGhlIFREWCBob3N0IGNvZGUganVzdCBzZXQgaG9z
dF9tZW1fZW5jX2FjdGl2ZT0xPw0KPiA+ID4gDQo+ID4gPiBTdXJlLCB5b3UnbGwgZW5kIHVwICp1
c2luZyogdGhlIFNNRSBXQklOVkQgc3VwcG9ydCwgYnV0IHRoZW4geW91IGRvbid0DQo+ID4gPiBo
YXZlIHR3byBkaWZmZXJlbnQgV0JJTlZEIGNhbGwgc2l0ZXMuICBZb3UgYWxzbyBkb24ndCBoYXZl
IHRvIG1lc3Mgd2l0aA0KPiA+ID4gYSBzaW5nbGUgbGluZSBvZiBhc3NlbWJseS4NCj4gPiANCj4g
PiBJIHdhbnRlZCB0byBhdm9pZCBjaGFuZ2luZyB0aGUgYXNzZW1ibHkuDQo+ID4gDQo+ID4gUGVy
aGFwcyB0aGUgY29tbWVudCBpc24ndCB2ZXJ5IGNsZWFyLiAgRmx1c2hpbmcgY2FjaGUgKG9uIHRo
ZSBDUFUgcnVubmluZyBrZXhlYykNCj4gPiB3aGVuIHRoZSBob3N0X21lbV9lbmNfYWN0aXZlPTEg
aXMgaGFuZGxlZCBpbiB0aGUgcmVsb2NhdGVfa2VybmVsKCkgYXNzZW1ibHksDQo+ID4gd2hpY2gg
aGFwcGVucyBhdCB2ZXJ5IGxhdGUgc3RhZ2UgcmlnaHQgYmVmb3JlIGp1bXBpbmcgdG8gdGhlIG5l
dyBrZXJuZWwuDQo+ID4gSG93ZXZlciBmb3IgVERYIHdoZW4gdGhlIHBsYXRmb3JtIGhhcyBlcnJh
dHVtIHdlIG5lZWQgdG8gY29udmVydCBURFggcHJpdmF0ZQ0KPiA+IHBhZ2VzIGJhY2sgdG8gbm9y
bWFsLCB3aGljaCBtdXN0IGJlIGRvbmUgYWZ0ZXIgZmx1c2hpbmcgY2FjaGUuICBJZiB3ZSByZXVz
ZQ0KPiA+IGhvc3RfbWVtX2VuY19hY3RpdmU9MSwgdGhlbiB3ZSB3aWxsIG5lZWQgdG8gY2hhbmdl
IHRoZSBhc3NlbWJseSBjb2RlIHRvIGRvIHRoYXQuDQo+IA0KPiBJIGhvbmVzdGx5IHRoaW5rIHlv
dSBuZWVkIHRvIHN0b3AgdGhpbmtpbmcgYWJvdXQgdGhlIHBhcnRpYWwgd3JpdGUgaXNzdWUNCj4g
YXQgdGhpcyBwb2ludCBpbiB0aGUgc2VyaWVzLiAgSXQncyByZWFsbHkgY2F1c2luZyBhIGhvcnJp
YmxlIGFtb3VudCBvZg0KPiB1bm5lY2Vzc2FyeSBjb25mdXNpb24uDQo+IA0KPiBIZXJlJ3MgdGhl
IGdvbGRlbiBydWxlOg0KPiANCj4gCVRoZSBib290IENQVSBuZWVkcyB0byBydW4gV0JJTlZEIHNv
bWV0aW1lIGFmdGVyIGl0IHN0b3BzIHdyaXRpbmcNCj4gCXRvIHByaXZhdGUgbWVtb3J5IGJ1dCBi
ZWZvcmUgaXQgc3RhcnRzIHRyZWF0aW5nIHRoZSBtZW1vcnkgYXMNCj4gCXNoYXJlZC4NCj4gDQo+
IE9uIFNNRSBrZXJuZWxzLCB0aGF0IGtleSBwb2ludCBldmlkZW50bHkgaW4gZWFybHkgYm9vdCB3
aGVuIGl0J3MNCj4gZW5hYmxpbmcgU01FLiAgSSBfdGhpbmtfIHRoYXQgcG9pbnQgaXMgYWxzbyBh
IHZhbGlkIHBsYWNlIHRvIGRvIFdCSU5WRA0KPiBvbiBuby1URFgtZXJyYXR1bSBzeXN0ZW1zLg0K
DQpZb3UgbWVhbiB3ZSBjb3VsZCBhZHZlcnRpc2UgY2NfcGxhdGZvcm1faGFzKENDX0FUVFJfSE9T
VF9NRU1fRU5DUllQVCkgdHJ1ZSBmb3INClREWCBob3N0PyBXZSBjb3VsZCBidXQgSU1ITyBpdCBk
b2Vzbid0IHBlcmZlY3RseSBtYXRjaC4NCg0KU01FIGtlcm5lbCBzZXRzIF9QQUdFX0VOQyBvbiBi
eSBkZWZhdWx0IGZvciBhbGwgbWVtb3J5IG1hcHBpbmdzIElJVUMsIGJ1dCBURFgNCmhvc3QgbmV2
ZXIgYWN0dWFsbHkgc2V0cyBhbnkgZW5jcnlwdGlvbiBiaXRzIGluIHBhZ2UgdGFibGVzIG1hbmFn
ZWQgYnkgdGhlDQprZXJuZWwuDQoNClNvIEkgdGhpbmsgd2UgY2FuIGp1c3QgZG8gYmVsb3csIGJ1
dCBub3QgYWR2ZXJ0aXNlIENDX0FUVFJfSE9TVF9NRU1fRU5DUllQVCBmb3INClREWCBob3N0Pw0K
DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvbWFjaGluZV9rZXhlY182NC5jDQorKysgYi9hcmNoL3g4
Ni9rZXJuZWwvbWFjaGluZV9rZXhlY182NC5jDQpAQCAtMzc3LDcgKzM3Nyw4IEBAIHZvaWQgbWFj
aGluZV9rZXhlYyhzdHJ1Y3Qga2ltYWdlICppbWFnZSkNCiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICh1bnNpZ25lZCBsb25nKXBhZ2VfbGlzdCwNCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGltYWdlLT5zdGFydCwNCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGltYWdlLT5wcmVzZXJ2ZV9jb250ZXh0LA0KLSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCmNjX3BsYXRmb3JtX2hhcyhDQ19BVFRSX0hP
U1RfTUVNX0VOQ1JZUFQpKTsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGNjX3BsYXRmb3JtX2hhcyhDQ19BVFRSX0hPU1RfTUVNX0VOQ1JZUFQpDQp8fA0KKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcGxhdGZvcm1fdGR4X2VuYWJsZWQoKSk7DQoN
Cg0KPiANCj4gT24gVERYIHN5c3RlbXMgd2l0aCB0aGUgZXJyYXR1bSwgdGhlcmUncyBhICpzZWNv
bmQqIHBvaW50IGJlZm9yZSB0aGUNCj4gcHJpdmF0ZT0+c2hhcmVkIGNvbnZlcnNpb24gb2NjdXJz
LiAgSSB0aGluayB3aGF0IHlvdSdyZSB0cnlpbmcgdG8gZG8NCj4gaGVyZSBpcyBwcmVtYXR1cmVs
eSBvcHRpbWl6ZSB0aGUgZXJyYXR1bS1hZmZlY3RlZCBhZmZlY3RlZCBzeXN0ZW1zIHNvDQo+IHRo
YXQgdGhleSBkb24ndCBkbyB0d28gV0JJTlZEcy4gIFBsZWFzZSBzdG9wIHRyeWluZyB0byBkbyB0
aGF0Lg0KPiANCj4gVGhpcyBXQklOVkQgaXMgb25seSBfbmVlZGVkXyBmb3IgdGhlIGVycmF0dW0u
ICBJdCBzaG91bGQgYmUgY2xvc2VyIHRvDQo+IHRoZSBhY3R1YWwgZXJyYXR1bSBoYW5kaW5nLg0K
DQpJZiB3ZSBkbyBXQklOVkQgZWFybHkgaGVyZSB0aGVuIHRoZSBzZWNvbmQgb25lIGlzbid0IG5l
ZWRlZC4gIEJ1dCAxMDAlIGFncmVlZA0KdGhpcyBoYW5kbGluZy9vcHRpbWl6YXRpb24gc2hvdWxk
IGJlIGRvbmUgbGF0ZXIgY2xvc2VyIHRvIHRoZSBlcnJhdHVtIGhhbmRsaW5nLg0KDQo=

