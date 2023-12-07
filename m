Return-Path: <kvm+bounces-3833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D99918084E6
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 10:44:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06FEE1C21FE4
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 09:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE13935277;
	Thu,  7 Dec 2023 09:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mzE7eLBn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF192C9;
	Thu,  7 Dec 2023 01:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701942239; x=1733478239;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WNnPxIIJWCmGHNFIiWcMTcI2rTwzXssQEx23Y6JNKvo=;
  b=mzE7eLBnLDckGHPWQPiEFbhkya8q+2qKRBwjn7eOXOCLmtMtXh+Yr/qE
   jfZ7GiFaeUKBrzDfnAYFaHrBxWqkGszcOZgiVjXFLVRHlCZ7WVIWE9gMK
   5oX9QPCS9nIZfh1V6o5ilo8r27gJxYDV2aBJZot/C97wa0bw6xaMw5VM2
   PdWKL9IdVef5Fc2MWobZOQL8u3EElbvcWPN0YCTmGic2fG8MYH/PGp3d5
   s4gQmbZvki7gNXUsVp6KSNHY2CFb/8Si1mSS98F0epEf9YJaL9RXSEN+y
   YFxvBWrWBREWkw4JDrKgjAg4bWS/WaGDA0oVZu0FjrtMpxEAzV6ZbvGPM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="391379369"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="391379369"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 01:43:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="944976025"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="944976025"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Dec 2023 01:43:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 01:43:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 01:43:57 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Dec 2023 01:43:57 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Dec 2023 01:43:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6SLy11qllYDmKsX3OP+RzP5DQMG+49YdzZYjlgdLz2pIWbhUpqFw89Z64itTYiewQFGVxsF9tcIHK1ubJcZ4M9C+CajBr+8Yr2VV+9mS4rLCxnEcCfdmV2XKmVsAyrB1/pKXTrK/Q7xqYc5ssiQKsYzICPqBFQs5eG9bINVxIC3vbS+A71llJqMz5k0Q5kDN1kgpn0wuuoFh6cWK76kjz91j/n4vgQZO7RYTM6yrU90KTK7i41oi8jhmTXEXEOthmslmN9frME2Lzi/ID1pHRr8R93IougEYzTyuSC1CqO/hKjwQ+EkfwFFKwHVHOxg0bNqAKgX6GhRW3Io1MXNJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNnPxIIJWCmGHNFIiWcMTcI2rTwzXssQEx23Y6JNKvo=;
 b=i/ySjFHv/OltPUEi/FW6AVZORYkqTJA/Ft0PwMS22dkrTgHFMpRU4WaumTSTn5r1be3l078fxKKGTAQFnALhoe6ORMetjt3oSj8rujJJsiuwFBfXqS9X7/p059rtCGSb/Awsc/a1SStR+dWXyWvxelLDOiPxZCgEjWSH6H0TqmrNVG5SOmAoC5bB6ef2SJQ9ozoRlQxFPXlmlqQQbiblSP2leCcaAkZYCdjKGn8dArKAsb0T1yE7s+obuPbqyZ+gChnzN5FwdZPcOqBIl45egYOq3lsjLGXJi8e37QpPnqNTgQox1PerDBaNypyf8s28bnA1cH+jVwGR5OUBA4KJlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CO1PR11MB4979.namprd11.prod.outlook.com (2603:10b6:303:99::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Thu, 7 Dec
 2023 09:43:54 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3%7]) with mapi id 15.20.7046.034; Thu, 7 Dec 2023
 09:43:53 +0000
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
Thread-Index: AQHaJ215PhEOYu43sEObVSTXzfHZOLCanWSAgAE5e5CAAHaQAIAAUcKggAD07nA=
Date: Thu, 7 Dec 2023 09:43:52 +0000
Message-ID: <SA1PR11MB6734ACF7F90649CADDC82C6EA88BA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-27-xin3.li@intel.com>
 <f260ddf9-be67-48e0-8121-6f58d46f7978@citrix.com>
 <SA1PR11MB67343544B0CEB6C82002790DA884A@SA1PR11MB6734.namprd11.prod.outlook.com>
 <4e41b658-f49e-424c-8a86-08c8ab8e384d@citrix.com>
 <SA1PR11MB673472A25E72022F68882869A884A@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB673472A25E72022F68882869A884A@SA1PR11MB6734.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CO1PR11MB4979:EE_
x-ms-office365-filtering-correlation-id: 87209f08-64da-42ed-1add-08dbf70905f7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VNDYADazJwG3OQCo+pwjUTu/I0Bt7SCbaiZkpo4/Ecgbf/tbWTdNgtLG6eLWKmA3N9fqQfIN5Nr9Jq9D1ttd/2aEInHZ9bbzpoVbataMds5KJXLFyBrK1rXmezFwmlX7oQaLSpYR+0rKTf7M0UYrHcO+D3VoiX8JRsZQuk1WiH8i86s72Q45eZJwWNpea6rWIYfe3bGZY+OO6XHnr0TlnkwOFJo9UONG5IBJoeH0NX1ZvROio2Lm92MBoukBkzmP2MBjp80xRZ1YbVjkYmc4/eGrHuQ7uRiXw3rCWBAUz2fBVi+Oa7Q2N7ZzHqs0NoCuCOzYkkDJ4+3cqtD2F+AGGtBR6FSu3P7BkH0aeDS4gBIX5r/AXkooB32DXqiF+1p0+Mbm4q2Olc5qbEin/oY7Z+/0fRxMm8kvzaW3E3z750ewEKkeKfNOTytiYQhFsiqNO5g6jz29oU7ynBxCAao6qerrkEvDxivrT+B2okJWsWee7kqiZhg11J0RrhbFKi5nefy1ffJ9DWAyN5Rngz6wAKdANdMa2f7vyapL9IDhIannjnEK1dyoN32/nE0+z4QOt9k2L8lV+uxcrAox+LCClfW19ohRJwoLiOHoOEBpsj+r4JemKrdyOwTrlInvL5N1n42gg4A/kCwFI+vUj+JF04puOuedjnx80sMy5/LKh2g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(366004)(376002)(230173577357003)(230922051799003)(230273577357003)(451199024)(1800799012)(186009)(64100799003)(66556008)(38100700002)(66446008)(478600001)(76116006)(64756008)(66476007)(110136005)(54906003)(66946007)(122000001)(316002)(7696005)(8676002)(71200400001)(4326008)(8936002)(82960400001)(38070700009)(86362001)(6506007)(26005)(7416002)(2906002)(83380400001)(55016003)(41300700001)(5660300002)(9686003)(52536014)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDg5MUxxNnRxYTdUREJTaW5jRlVxWjNnRlg3YSt4U3BHdUlGUHhZSWl5ZElw?=
 =?utf-8?B?Y2pYK1h1T0lkcEJ6dW53VFI1RmkzdGNDYUlVQ0JReXZhT2RBK2VDRWwwZUFG?=
 =?utf-8?B?VU1pYjl5bW5JOVU3dlJqWlI3SHFNWmh6SXZkQlBTSXFlMHVkdndYU3BFUmdP?=
 =?utf-8?B?MzV2UEI4M29ubHNqQXFPczRTVWFLdW51QVMrTjhLNG9lcm1wQVRxNmlnWVFH?=
 =?utf-8?B?T3JFUlp5d0paYXFNSG9sN0QvOGtyelB2UmlDSy9jZG5zT2E1ekkzNjFJRlEy?=
 =?utf-8?B?dkRtTitjL0ZNZytMLzFXdDB0ODZDWFpqZ0ViRmRoK1Azb2M5N2RRTGdtWU9B?=
 =?utf-8?B?cWhQKzBrQ0YwYkdLMDBTa1BUbDUycE1xMlVLUnJRdXU1encyODF5VXQ5cndM?=
 =?utf-8?B?SlUzRkN4R3ErcVQ3VXVhek9CRlR5OGFsYVpyVlVVbzI2d3ZIaThacGhPQnNY?=
 =?utf-8?B?a0ZlRm1nSjdEYzVtTU0rcGFNN01jUDJEZkhnZnc1cE9oRXVzMUUxdExJWDVo?=
 =?utf-8?B?L1lkZjRiangxVWUrbFAwdmNNby9kY1VoWFpDNVJNdE9IYTliYjI5cEpKS0I2?=
 =?utf-8?B?QWxDTVZqdUhnZUhvcTBlZHdieGQxVkdBdHJnK3JxQjFHdEpWUHJ6V09tMlZl?=
 =?utf-8?B?MXAvVVRDQ0lUL2RiZTlUZlpVOVFDL2dKcnJPSVpic3lUb0o2alNEeGxuYkhW?=
 =?utf-8?B?dUNIajBWamVyQjVHNWowWC9VcUNkVWxRSjdZRHJvQzZXVTZ4cU5saGk4TU5D?=
 =?utf-8?B?UUpKMEIxcmpVc3NGR3R2YWR6WXF1V3pXQWljWFpDVVl5Mks3bkxEMlI4bmJD?=
 =?utf-8?B?eTM2dGRVWjUyVnpIMEw1VGN4dlVEbnV5RVpKT2FhaEVpeUhhK3hpdGlObGtH?=
 =?utf-8?B?L0Z4bDl0a0VFK0UwYmFCeUhaNVJsdlJicmkwYjRESlE3aG9CTkdIZ3VMMkVh?=
 =?utf-8?B?T0dTVFpiWEY1WUwyMXFxL3BEUWZVWDRxaC85bk5wME9aMHQwOUNpZERweEJw?=
 =?utf-8?B?QVk4VnhLTmZPSWlwOTJVd1BMS1RIVDlzQTgyb3pBWWJJaUFxTlRBY2krY3U4?=
 =?utf-8?B?bERhZ0Y3ZTRpL1kwL2Nnc0VWVExndHhGdm1oWXd3UUJhQ1B3bGV4bG0ydWpF?=
 =?utf-8?B?cTJPYURVVlYzS2x4TmZMaDUvUHo0NFFVeFlHM25XYXVvc3RhUG5kcXRKaWJu?=
 =?utf-8?B?dGt5Q1I5YldxdHd1amliKy94YlNqcE9LcFp1cmJvdVdIdDNRUTVkVHA1bldo?=
 =?utf-8?B?a1dFaDVpYXVkRjZxelYxQ0NyaHo0eVdhU3FadkxHUjJVdm93amNmYjBwYUVE?=
 =?utf-8?B?ajJzc1V1aTkvVFNONDl5K2ZjYXFqYzd5QTA5WU9EcVl2QzNOUGJjS0dWeEE2?=
 =?utf-8?B?ajhrWmhrVEZPdjBlQ21DK2pUKzJaSjhPL3VVUEdiYVU3QjE5eElXdEg2MlU5?=
 =?utf-8?B?ZFhqSWJTOHZOeldTbWxwdlpSK2RUVU9tZW01OE50amZ1NDQ1dEJwb1dCbVVL?=
 =?utf-8?B?eUVEbFpjUXlzVzkwSW9SSjNTd0lUOVJkRVoyY0ZWcjc4UUJxYko4RmtpeGc5?=
 =?utf-8?B?dS81SlRnOGdlMGVYcWcvTXJoYzBYRWNWV0JjMmdOblVQN20rM2hveWgxTTBx?=
 =?utf-8?B?M3NnUXFDZ0pObmdBNmdWVlBaQWtsdXVpdjhXajJLdXdVemZpdFhMRXNTWjJY?=
 =?utf-8?B?RnBYWjZ5QlVOSk5WYVdTbkpzRHhBbEwzdEZtdXpzMTg2MEswS3NKakN0VmdK?=
 =?utf-8?B?cnpvOEE2dm5RSW4rSm5EV2NpYWdYN3Q3MUgrM0g3aE0zcURBdFRySmw1NzB6?=
 =?utf-8?B?Tmg2amF2S0RKK3pxSEh5bHIvOFhmYm9RYVo4MHhDOUVXcVhYd0dNSkhEam1F?=
 =?utf-8?B?MnpsT0Y5T0VIMGVoWHJkOWRVZ2d5ak1iNE9LRHdGOTcxSmswaUlQWXlvb2Nk?=
 =?utf-8?B?c2JwaEZQeTFHR2p5ZG9rZWpBN1JlWEVBQi9SNnh5RnZlMWpIM0VReXNkWjZY?=
 =?utf-8?B?ci9odExlVUwwWldVZnJBOEt2T0lMWHBWdzkrNzZDR1UzSUdZOHpzQTBRcXRq?=
 =?utf-8?B?U3d5NDZYNGJ6V2p5WmpGRnV0WFZ0dzdYQjUramE5MzVndFE5Z05oUURuZXQz?=
 =?utf-8?Q?ygiY=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 87209f08-64da-42ed-1add-08dbf70905f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 09:43:52.9719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y0h/PZfiWbAqX5Egpma9qnZzahRrs9SbpvMT4juplHadKZD3VUWPr0CQ/W3gOEcpVsdTOFaJcD+jtrYrxoy6+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4979
X-OriginatorOrg: intel.com

PiA+IEluIG15IG9waW5pb24sIGNyb3NzLWNoZWNraW5nIGlzIHRoZSBiZXR0ZXIgYXBwcm9hY2gs
IGJlY2F1c2UgaXQgbWVhbnMgdGhhdA0KPiA+IHZpb2xhdGlvbnMgb2YgdGhlIGFzc3VtcHRpb25z
IGdldCBub3RpY2VkIG1vcmUgcXVpY2tseSwgYW5kIGhvcGVmdWxseSBieQ0KPiA+IHdob21ldmVy
IGlzIHdvcmtpbmcgb24gdGhlIG5ldyBmZWF0dXJlIHdoaWNoIGFsdGVycyB0aGUgYXNzdW1wdGlv
bnMuDQo+IA0KPiBZZWFoLCBJIGNhbiBtYWtlIHRoZSBjaGFuZ2UuDQogDQoNCkhpIEFuZHJldywN
Cg0KRm9sbG93aW5nIGlzIHRoZSB1cGRhdGVkIHBhdGNoLCBjYW4geW91IHBsZWFzZSBoYXZlIGFu
b3RoZXIgcmV2aWV3Pw0KDQpUaGFua3MhDQogICAgWGluDQoNCg0KZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2VudHJ5L2VudHJ5X2ZyZWQuYyBiL2FyY2gveDg2L2VudHJ5L2VudHJ5X2ZyZWQuYw0KbmV3
IGZpbGUgbW9kZSAxMDA2NDQNCmluZGV4IDAwMDAwMDAwMDAwMC4uZmQzNmZiOGQyYTE5DQotLS0g
L2Rldi9udWxsDQorKysgYi9hcmNoL3g4Ni9lbnRyeS9lbnRyeV9mcmVkLmMNCkBAIC0wLDAgKzEs
MjUyIEBADQorLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgKi8NCisvKg0KKyAq
IFRoZSBGUkVEIHNwZWNpZmljIGtlcm5lbC91c2VyIGVudHJ5IGZ1bmN0aW9ucyB3aGljaCBhcmUg
aW52b2tlZCBmcm9tDQorICogYXNzZW1ibHkgY29kZSBhbmQgZGlzcGF0Y2ggdG8gdGhlIGFzc29j
aWF0ZWQgaGFuZGxlcnMuDQorICovDQorI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KKyNpbmNs
dWRlIDxsaW51eC9rZGVidWcuaD4NCisjaW5jbHVkZSA8bGludXgvbm9zcGVjLmg+DQorDQorI2lu
Y2x1ZGUgPGFzbS9kZXNjLmg+DQorI2luY2x1ZGUgPGFzbS9mcmVkLmg+DQorI2luY2x1ZGUgPGFz
bS9pZHRlbnRyeS5oPg0KKyNpbmNsdWRlIDxhc20vc3lzY2FsbC5oPg0KKyNpbmNsdWRlIDxhc20v
dHJhcG5yLmg+DQorI2luY2x1ZGUgPGFzbS90cmFwcy5oPg0KKw0KKy8qIEZSRUQgRVZFTlRfVFlQ
RV9PVEhFUiB2ZWN0b3IgbnVtYmVycyAqLw0KKyNkZWZpbmUgRlJFRF9TWVNDQUxMCQkJMQ0KKyNk
ZWZpbmUgRlJFRF9TWVNFTlRFUgkJCTINCisNCitzdGF0aWMgbm9pbnN0ciB2b2lkIGZyZWRfYmFk
X3R5cGUoc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIHVuc2lnbmVkIGxvbmcgZXJyb3JfY29kZSkNCit7
DQorCWlycWVudHJ5X3N0YXRlX3QgaXJxX3N0YXRlID0gaXJxZW50cnlfbm1pX2VudGVyKHJlZ3Mp
Ow0KKw0KKwlpbnN0cnVtZW50YXRpb25fYmVnaW4oKTsNCisNCisJLyogUGFuaWMgb24gZXZlbnRz
IGZyb20gYSBoaWdoIHN0YWNrIGxldmVsICovDQorCWlmIChyZWdzLT5mcmVkX2NzLnNsID4gMCkg
ew0KKwkJcHJfZW1lcmcoIlBBTklDOiBpbnZhbGlkIG9yIGZhdGFsIEZSRUQgZXZlbnQ7IGV2ZW50
IHR5cGUgJXUgIg0KKwkJCSAidmVjdG9yICV1IGVycm9yIDB4JWx4IGF1eCAweCVseCBhdCAlMDR4
OiUwMTZseFxuIiwNCisJCQkgcmVncy0+ZnJlZF9zcy50eXBlLCByZWdzLT5mcmVkX3NzLnZlY3Rv
ciwgcmVncy0+b3JpZ19heCwNCisJCQkgZnJlZF9ldmVudF9kYXRhKHJlZ3MpLCByZWdzLT5jcywg
cmVncy0+aXApOw0KKwkJZGllKCJpbnZhbGlkIG9yIGZhdGFsIEZSRUQgZXZlbnQiLCByZWdzLCBy
ZWdzLT5vcmlnX2F4KTsNCisJCXBhbmljKCJpbnZhbGlkIG9yIGZhdGFsIEZSRUQgZXZlbnQiKTsN
CisJfSBlbHNlIHsNCisJCXVuc2lnbmVkIGxvbmcgZmxhZ3MgPSBvb3BzX2JlZ2luKCk7DQorCQlp
bnQgc2lnID0gU0lHS0lMTDsNCisNCisJCXByX2FsZXJ0KCJCVUc6IGludmFsaWQgb3IgZmF0YWwg
RlJFRCBldmVudDsgZXZlbnQgdHlwZSAldSAiDQorCQkJICJ2ZWN0b3IgJXUgZXJyb3IgMHglbHgg
YXV4IDB4JWx4IGF0ICUwNHg6JTAxNmx4XG4iLA0KKwkJCSByZWdzLT5mcmVkX3NzLnR5cGUsIHJl
Z3MtPmZyZWRfc3MudmVjdG9yLCByZWdzLT5vcmlnX2F4LA0KKwkJCSBmcmVkX2V2ZW50X2RhdGEo
cmVncyksIHJlZ3MtPmNzLCByZWdzLT5pcCk7DQorDQorCQlpZiAoX19kaWUoIkludmFsaWQgb3Ig
ZmF0YWwgRlJFRCBldmVudCIsIHJlZ3MsIHJlZ3MtPm9yaWdfYXgpKQ0KKwkJCXNpZyA9IDA7DQor
DQorCQlvb3BzX2VuZChmbGFncywgcmVncywgc2lnKTsNCisJfQ0KKw0KKwlpbnN0cnVtZW50YXRp
b25fZW5kKCk7DQorCWlycWVudHJ5X25taV9leGl0KHJlZ3MsIGlycV9zdGF0ZSk7DQorfQ0KKw0K
K3N0YXRpYyBub2luc3RyIHZvaWQgZnJlZF9pbnR4KHN0cnVjdCBwdF9yZWdzICpyZWdzKQ0KK3sN
CisJc3dpdGNoIChyZWdzLT5mcmVkX3NzLnZlY3Rvcikgew0KKwkvKiBPcGNvZGUgMHhjZCwgMHgz
LCBOT1QgSU5UMyAob3Bjb2RlIDB4Y2MpICovDQorCWNhc2UgWDg2X1RSQVBfQlA6DQorCQlleGNf
aW50MyhyZWdzKTsNCisJCXJldHVybjsNCisNCisJLyogT3Bjb2RlIDB4Y2QsIDB4NCwgTk9UIElO
VE8gKG9wY29kZSAweGNlKSAqLw0KKwljYXNlIFg4Nl9UUkFQX09GOg0KKwkJZXhjX292ZXJmbG93
KHJlZ3MpOw0KKwkJcmV0dXJuOw0KKw0KKwkvKiBJTlQ4MCAqLw0KKwljYXNlIElBMzJfU1lTQ0FM
TF9WRUNUT1I6DQorCQlpZiAoaWEzMl9lbmFibGVkKCkpIHsNCisJCQkvKiBTYXZlIHRoZSBzeXNj
YWxsIG51bWJlciAqLw0KKwkJCXJlZ3MtPm9yaWdfYXggPSByZWdzLT5heDsNCisJCQlyZWdzLT5h
eCA9IC1FTk9TWVM7DQorCQkJZG9faW50ODBfc3lzY2FsbF8zMihyZWdzKTsNCisJCQlyZXR1cm47
DQorCQl9DQorCQlmYWxsdGhyb3VnaDsNCisNCisJZGVmYXVsdDoNCisJCWV4Y19nZW5lcmFsX3By
b3RlY3Rpb24ocmVncywgMCk7DQorCQlyZXR1cm47DQorCX0NCit9DQorDQorc3RhdGljIF9fYWx3
YXlzX2lubGluZSB2b2lkIGZyZWRfb3RoZXIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpDQorew0KKwkv
KiBUaGUgY29tcGlsZXIgY2FuIGZvbGQgdGhlc2UgY29uZGl0aW9ucyBpbnRvIGEgc2luZ2xlIHRl
c3QgKi8NCisJaWYgKGxpa2VseShyZWdzLT5mcmVkX3NzLnZlY3RvciA9PSBGUkVEX1NZU0NBTEwg
JiYgcmVncy0+ZnJlZF9zcy5sbSkpIHsNCisJCXJlZ3MtPm9yaWdfYXggPSByZWdzLT5heDsNCisJ
CXJlZ3MtPmF4ID0gLUVOT1NZUzsNCisJCWRvX3N5c2NhbGxfNjQocmVncywgcmVncy0+b3JpZ19h
eCk7DQorCQlyZXR1cm47DQorCX0gZWxzZSBpZiAoaWEzMl9lbmFibGVkKCkgJiYNCisJCSAgIGxp
a2VseShyZWdzLT5mcmVkX3NzLnZlY3RvciA9PSBGUkVEX1NZU0VOVEVSICYmDQorCQkJICAhcmVn
cy0+ZnJlZF9zcy5sbSkpIHsNCisJCXJlZ3MtPm9yaWdfYXggPSByZWdzLT5heDsNCisJCXJlZ3Mt
PmF4ID0gLUVOT1NZUzsNCisJCWRvX2Zhc3Rfc3lzY2FsbF8zMihyZWdzKTsNCisJCXJldHVybjsN
CisJfSBlbHNlIHsNCisJCWV4Y19pbnZhbGlkX29wKHJlZ3MpOw0KKwkJcmV0dXJuOw0KKwl9DQor
fQ0KKw0KKyNkZWZpbmUgU1lTVkVDKF92ZWN0b3IsIF9mdW5jdGlvbikgW192ZWN0b3IgLSBGSVJT
VF9TWVNURU1fVkVDVE9SXSA9IGZyZWRfc3lzdmVjXyMjX2Z1bmN0aW9uDQorDQorc3RhdGljIGlk
dGVudHJ5X3Qgc3lzdmVjX3RhYmxlW05SX1NZU1RFTV9WRUNUT1JTXSBfX3JvX2FmdGVyX2luaXQg
PSB7DQorCVNZU1ZFQyhFUlJPUl9BUElDX1ZFQ1RPUiwJCWVycm9yX2ludGVycnVwdCksDQorCVNZ
U1ZFQyhTUFVSSU9VU19BUElDX1ZFQ1RPUiwJCXNwdXJpb3VzX2FwaWNfaW50ZXJydXB0KSwNCisJ
U1lTVkVDKExPQ0FMX1RJTUVSX1ZFQ1RPUiwJCWFwaWNfdGltZXJfaW50ZXJydXB0KSwNCisJU1lT
VkVDKFg4Nl9QTEFURk9STV9JUElfVkVDVE9SLAkJeDg2X3BsYXRmb3JtX2lwaSksDQorDQorCVNZ
U1ZFQyhSRVNDSEVEVUxFX1ZFQ1RPUiwJCXJlc2NoZWR1bGVfaXBpKSwNCisJU1lTVkVDKENBTExf
RlVOQ1RJT05fU0lOR0xFX1ZFQ1RPUiwJY2FsbF9mdW5jdGlvbl9zaW5nbGUpLA0KKwlTWVNWRUMo
Q0FMTF9GVU5DVElPTl9WRUNUT1IsCQljYWxsX2Z1bmN0aW9uKSwNCisJU1lTVkVDKFJFQk9PVF9W
RUNUT1IsCQkJcmVib290KSwNCisNCisJU1lTVkVDKFRIUkVTSE9MRF9BUElDX1ZFQ1RPUiwJCXRo
cmVzaG9sZCksDQorCVNZU1ZFQyhERUZFUlJFRF9FUlJPUl9WRUNUT1IsCQlkZWZlcnJlZF9lcnJv
ciksDQorCVNZU1ZFQyhUSEVSTUFMX0FQSUNfVkVDVE9SLAkJdGhlcm1hbCksDQorDQorCVNZU1ZF
QyhJUlFfV09SS19WRUNUT1IsCQkJaXJxX3dvcmspLA0KKw0KKwlTWVNWRUMoUE9TVEVEX0lOVFJf
VkVDVE9SLAkJa3ZtX3Bvc3RlZF9pbnRyX2lwaSksDQorCVNZU1ZFQyhQT1NURURfSU5UUl9XQUtF
VVBfVkVDVE9SLAlrdm1fcG9zdGVkX2ludHJfd2FrZXVwX2lwaSksDQorCVNZU1ZFQyhQT1NURURf
SU5UUl9ORVNURURfVkVDVE9SLAlrdm1fcG9zdGVkX2ludHJfbmVzdGVkX2lwaSksDQorfTsNCisN
CitzdGF0aWMgbm9pbnN0ciB2b2lkIGZyZWRfZXh0aW50KHN0cnVjdCBwdF9yZWdzICpyZWdzKQ0K
K3sNCisJdW5zaWduZWQgaW50IHZlY3RvciA9IHJlZ3MtPmZyZWRfc3MudmVjdG9yOw0KKwl1bnNp
Z25lZCBpbnQgaW5kZXggPSBhcnJheV9pbmRleF9ub3NwZWModmVjdG9yIC0gRklSU1RfU1lTVEVN
X1ZFQ1RPUiwNCisJCQkJCQlOUl9TWVNURU1fVkVDVE9SUyk7DQorDQorCWlmIChXQVJOX09OX09O
Q0UodmVjdG9yIDwgRklSU1RfRVhURVJOQUxfVkVDVE9SKSkNCisJCXJldHVybjsNCisNCisJaWYg
KGxpa2VseSh2ZWN0b3IgPj0gRklSU1RfU1lTVEVNX1ZFQ1RPUikpIHsNCisJCWlycWVudHJ5X3N0
YXRlX3Qgc3RhdGUgPSBpcnFlbnRyeV9lbnRlcihyZWdzKTsNCisNCisJCWluc3RydW1lbnRhdGlv
bl9iZWdpbigpOw0KKwkJc3lzdmVjX3RhYmxlW2luZGV4XShyZWdzKTsNCisJCWluc3RydW1lbnRh
dGlvbl9lbmQoKTsNCisJCWlycWVudHJ5X2V4aXQocmVncywgc3RhdGUpOw0KKwl9IGVsc2Ugew0K
KwkJY29tbW9uX2ludGVycnVwdChyZWdzLCB2ZWN0b3IpOw0KKwl9DQorfQ0KKw0KK3N0YXRpYyBu
b2luc3RyIHZvaWQgZnJlZF9od2V4YyhzdHJ1Y3QgcHRfcmVncyAqcmVncywgdW5zaWduZWQgbG9u
ZyBlcnJvcl9jb2RlKQ0KK3sNCisJLyogT3B0aW1pemUgZm9yICNQRi4gVGhhdCdzIHRoZSBvbmx5
IGV4Y2VwdGlvbiB3aGljaCBtYXR0ZXJzIHBlcmZvcm1hbmNlIHdpc2UgKi8NCisJaWYgKGxpa2Vs
eShyZWdzLT5mcmVkX3NzLnZlY3RvciA9PSBYODZfVFJBUF9QRikpDQorCQlyZXR1cm4gZXhjX3Bh
Z2VfZmF1bHQocmVncywgZXJyb3JfY29kZSk7DQorDQorCXN3aXRjaCAocmVncy0+ZnJlZF9zcy52
ZWN0b3IpIHsNCisJY2FzZSBYODZfVFJBUF9ERTogcmV0dXJuIGV4Y19kaXZpZGVfZXJyb3IocmVn
cyk7DQorCWNhc2UgWDg2X1RSQVBfREI6IHJldHVybiBmcmVkX2V4Y19kZWJ1ZyhyZWdzKTsNCisJ
Y2FzZSBYODZfVFJBUF9CUjogcmV0dXJuIGV4Y19ib3VuZHMocmVncyk7DQorCWNhc2UgWDg2X1RS
QVBfVUQ6IHJldHVybiBleGNfaW52YWxpZF9vcChyZWdzKTsNCisJY2FzZSBYODZfVFJBUF9OTTog
cmV0dXJuIGV4Y19kZXZpY2Vfbm90X2F2YWlsYWJsZShyZWdzKTsNCisJY2FzZSBYODZfVFJBUF9E
RjogcmV0dXJuIGV4Y19kb3VibGVfZmF1bHQocmVncywgZXJyb3JfY29kZSk7DQorCWNhc2UgWDg2
X1RSQVBfVFM6IHJldHVybiBleGNfaW52YWxpZF90c3MocmVncywgZXJyb3JfY29kZSk7DQorCWNh
c2UgWDg2X1RSQVBfTlA6IHJldHVybiBleGNfc2VnbWVudF9ub3RfcHJlc2VudChyZWdzLCBlcnJv
cl9jb2RlKTsNCisJY2FzZSBYODZfVFJBUF9TUzogcmV0dXJuIGV4Y19zdGFja19zZWdtZW50KHJl
Z3MsIGVycm9yX2NvZGUpOw0KKwljYXNlIFg4Nl9UUkFQX0dQOiByZXR1cm4gZXhjX2dlbmVyYWxf
cHJvdGVjdGlvbihyZWdzLCBlcnJvcl9jb2RlKTsNCisJY2FzZSBYODZfVFJBUF9NRjogcmV0dXJu
IGV4Y19jb3Byb2Nlc3Nvcl9lcnJvcihyZWdzKTsNCisJY2FzZSBYODZfVFJBUF9BQzogcmV0dXJu
IGV4Y19hbGlnbm1lbnRfY2hlY2socmVncywgZXJyb3JfY29kZSk7DQorCWNhc2UgWDg2X1RSQVBf
WEY6IHJldHVybiBleGNfc2ltZF9jb3Byb2Nlc3Nvcl9lcnJvcihyZWdzKTsNCisNCisjaWZkZWYg
Q09ORklHX1g4Nl9NQ0UNCisJY2FzZSBYODZfVFJBUF9NQzogcmV0dXJuIGZyZWRfZXhjX21hY2hp
bmVfY2hlY2socmVncyk7DQorI2VuZGlmDQorI2lmZGVmIENPTkZJR19JTlRFTF9URFhfR1VFU1QN
CisJY2FzZSBYODZfVFJBUF9WRTogcmV0dXJuIGV4Y192aXJ0dWFsaXphdGlvbl9leGNlcHRpb24o
cmVncyk7DQorI2VuZGlmDQorI2lmZGVmIENPTkZJR19YODZfQ0VUDQorCWNhc2UgWDg2X1RSQVBf
Q1A6IHJldHVybiBleGNfY29udHJvbF9wcm90ZWN0aW9uKHJlZ3MsIGVycm9yX2NvZGUpOw0KKyNl
bmRpZg0KKwlkZWZhdWx0OiByZXR1cm4gZnJlZF9iYWRfdHlwZShyZWdzLCBlcnJvcl9jb2RlKTsN
CisJfQ0KKw0KK30NCisNCitzdGF0aWMgbm9pbnN0ciB2b2lkIGZyZWRfc3dleGMoc3RydWN0IHB0
X3JlZ3MgKnJlZ3MsIHVuc2lnbmVkIGxvbmcgZXJyb3JfY29kZSkNCit7DQorCXN3aXRjaCAocmVn
cy0+ZnJlZF9zcy52ZWN0b3IpIHsNCisJY2FzZSBYODZfVFJBUF9CUDogcmV0dXJuIGV4Y19pbnQz
KHJlZ3MpOw0KKwljYXNlIFg4Nl9UUkFQX09GOiByZXR1cm4gZXhjX292ZXJmbG93KHJlZ3MpOw0K
KwlkZWZhdWx0OiByZXR1cm4gZnJlZF9iYWRfdHlwZShyZWdzLCBlcnJvcl9jb2RlKTsNCisJfQ0K
K30NCisNCitfX3Zpc2libGUgbm9pbnN0ciB2b2lkIGZyZWRfZW50cnlfZnJvbV91c2VyKHN0cnVj
dCBwdF9yZWdzICpyZWdzKQ0KK3sNCisJdW5zaWduZWQgbG9uZyBlcnJvcl9jb2RlID0gcmVncy0+
b3JpZ19heDsNCisNCisJLyogSW52YWxpZGF0ZSBvcmlnX2F4IHNvIHRoYXQgc3lzY2FsbF9nZXRf
bnIoKSB3b3JrcyBjb3JyZWN0bHkgKi8NCisJcmVncy0+b3JpZ19heCA9IC0xOw0KKw0KKwlzd2l0
Y2ggKHJlZ3MtPmZyZWRfc3MudHlwZSkgew0KKwljYXNlIEVWRU5UX1RZUEVfRVhUSU5UOg0KKwkJ
cmV0dXJuIGZyZWRfZXh0aW50KHJlZ3MpOw0KKwljYXNlIEVWRU5UX1RZUEVfTk1JOg0KKwkJaWYg
KGxpa2VseShyZWdzLT5mcmVkX3NzLnZlY3RvciA9PSBYODZfVFJBUF9OTUkpKQ0KKwkJCXJldHVy
biBmcmVkX2V4Y19ubWkocmVncyk7DQorCQlicmVhazsNCisJY2FzZSBFVkVOVF9UWVBFX1NXSU5U
Og0KKwkJcmV0dXJuIGZyZWRfaW50eChyZWdzKTsNCisJY2FzZSBFVkVOVF9UWVBFX0hXRVhDOg0K
KwkJcmV0dXJuIGZyZWRfaHdleGMocmVncywgZXJyb3JfY29kZSk7DQorCWNhc2UgRVZFTlRfVFlQ
RV9TV0VYQzoNCisJCXJldHVybiBmcmVkX3N3ZXhjKHJlZ3MsIGVycm9yX2NvZGUpOw0KKwljYXNl
IEVWRU5UX1RZUEVfUFJJVl9TV0VYQzoNCisJCWlmIChsaWtlbHkocmVncy0+ZnJlZF9zcy52ZWN0
b3IgPT0gWDg2X1RSQVBfREIpKQ0KKwkJCXJldHVybiBmcmVkX2V4Y19kZWJ1ZyhyZWdzKTsNCisJ
CWJyZWFrOw0KKwljYXNlIEVWRU5UX1RZUEVfT1RIRVI6DQorCQlyZXR1cm4gZnJlZF9vdGhlcihy
ZWdzKTsNCisJZGVmYXVsdDogYnJlYWs7DQorCX0NCisNCisJcmV0dXJuIGZyZWRfYmFkX3R5cGUo
cmVncywgZXJyb3JfY29kZSk7DQorfQ0KKw0KK19fdmlzaWJsZSBub2luc3RyIHZvaWQgZnJlZF9l
bnRyeV9mcm9tX2tlcm5lbChzdHJ1Y3QgcHRfcmVncyAqcmVncykNCit7DQorCXVuc2lnbmVkIGxv
bmcgZXJyb3JfY29kZSA9IHJlZ3MtPm9yaWdfYXg7DQorDQorCS8qIEludmFsaWRhdGUgb3JpZ19h
eCBzbyB0aGF0IHN5c2NhbGxfZ2V0X25yKCkgd29ya3MgY29ycmVjdGx5ICovDQorCXJlZ3MtPm9y
aWdfYXggPSAtMTsNCisNCisJc3dpdGNoIChyZWdzLT5mcmVkX3NzLnR5cGUpIHsNCisJY2FzZSBF
VkVOVF9UWVBFX0VYVElOVDoNCisJCXJldHVybiBmcmVkX2V4dGludChyZWdzKTsNCisJY2FzZSBF
VkVOVF9UWVBFX05NSToNCisJCWlmIChsaWtlbHkocmVncy0+ZnJlZF9zcy52ZWN0b3IgPT0gWDg2
X1RSQVBfTk1JKSkNCisJCQlyZXR1cm4gZnJlZF9leGNfbm1pKHJlZ3MpOw0KKwkJYnJlYWs7DQor
CWNhc2UgRVZFTlRfVFlQRV9IV0VYQzoNCisJCXJldHVybiBmcmVkX2h3ZXhjKHJlZ3MsIGVycm9y
X2NvZGUpOw0KKwljYXNlIEVWRU5UX1RZUEVfU1dFWEM6DQorCQlyZXR1cm4gZnJlZF9zd2V4Yyhy
ZWdzLCBlcnJvcl9jb2RlKTsNCisJY2FzZSBFVkVOVF9UWVBFX1BSSVZfU1dFWEM6DQorCQlpZiAo
bGlrZWx5KHJlZ3MtPmZyZWRfc3MudmVjdG9yID09IFg4Nl9UUkFQX0RCKSkNCisJCQlyZXR1cm4g
ZnJlZF9leGNfZGVidWcocmVncyk7DQorCQlicmVhazsNCisJZGVmYXVsdDogYnJlYWs7DQorCX0N
CisNCisJcmV0dXJuIGZyZWRfYmFkX3R5cGUocmVncywgZXJyb3JfY29kZSk7DQorfQ0K

