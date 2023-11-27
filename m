Return-Path: <kvm+bounces-2538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C50387FAD05
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 23:10:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E0FFB212F9
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 22:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D7D47776;
	Mon, 27 Nov 2023 22:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e4Izx4Fy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599B41BC7;
	Mon, 27 Nov 2023 14:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701122989; x=1732658989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=wMDvBHu6Gh0P+mQntZc5KcvU1lJYdyLq7Gu+lWy4mGI=;
  b=e4Izx4Fy4Zjsci/IxnsOK5OJPFnTuBmBJxTN3kN6MkHyrtwHzagYTdEm
   EUWqPDHumD2A/i5W20FY4CGCpz46PCMbxsG2ncNmYZMpUqtO6M7pIbtan
   8djlsoTq8GStdtwOAONRC+IswphrEjCauBwDMHK3NIFG9e6Wkcn3N7sTO
   ZZZY5fppnoA5bKmW2VQEQ7eBpZqyKHy8Y7Jcz164xUqNCMG1KPIiyG3pC
   sE0USKNCeAASGN4Mhl6Z3yQVb5Dw47oUrqV5e+CNs98Q7knaRBRvFwOkX
   kDangoNHtMxVoFc1FdTJKp/njGGxlWdwdMTgA/4gr1jXTLy6QrV880DBf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="395617032"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="diff'?scan'208";a="395617032"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 14:09:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="859198444"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="diff'?scan'208";a="859198444"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 14:09:47 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 14:09:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 14:09:47 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 14:09:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2rq+Y9NUUULx2CplPUPjw4jt1q7G4UtKxHlW1Ps0PGRILt76kYjP3bGU4itIa16TW++o1lELVFSxmSNt8qTbPHl4PkLi6zaydlzTDoMZd4yHF2bgnj8He3YxEmL4FtIHiFZcUrNKtPTmL9IG6CQ2pmmmjsRbYobMgwgM89QWazqBuunFHYh0xboKjCYIamf7H81fhOkPcsr0L9DcMPHcg+Lv1D6z9Bj9/pXBbZNxPiwnucVWf9hqWkwKyaaSiCTZC6W3UC3j5OqxTSIjOAJx9Jg0P0PdayO5iALthAJF4JZ5m3SWX8MJBK/0fuYRYNoX9eOydSWWL7WxALia9Y+qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJWPJf0HYKPIUuc5Meij2nwLoxc9S0o8+4gBlGkpfQ4=;
 b=P5dBRssxGTz9c/nDRJmIjXHZ2keTvT4HB/+qRnH3hhjQWpTT+WkPaM2+J5FNDEHDrD9Wm4aUZ0+5ojc1yYbWYcX8rjEC9ZWaod7XS7blZ2tFAEj1GJAjC79ubTVC+6hKLWB131CicWVPEiZvCuzZkgi6rXJ/fr12lhD0J6CQyofbVXYXmxxD+8u1YhQl+49su7cEMSIqiC8D2E3G8l7D1o3VH9lx6Y6m18IwO9qwCSGy1EsgsTZwaRddotDXgI4LUKNCD7AUg0oRuvA2uNuYDirZNGx5ZH29HazLWtmbhJZL1G8IRMu/sdHj1PAlD0WrzvLNBN7SU9iwKq07s8nMtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Mon, 27 Nov
 2023 22:09:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 22:09:44 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "rafael@kernel.org" <rafael@kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
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
	<ying.huang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Thread-Topic: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
Thread-Index: AQHaEwHp2HWZl9Al5EWrZJMGp6I1arCOlOeAgAAWWQCAAAj5gIAADSMAgAADugCAABG8gA==
Date: Mon, 27 Nov 2023 22:09:44 +0000
Message-ID: <dce6db4fa3c9801ce03cd0c700bd8b686de3ecfe.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <2151c68079c1cb837d07bd8015e4ff1f662e1a6e.1699527082.git.kai.huang@intel.com>
	 <cfea7192-4b29-46f9-a500-149121f493c8@intel.com>
	 <e8fd4bff8244e9e709c997da309e73a932567959.camel@intel.com>
	 <4ca2f6c1-97a7-4992-b01f-60341f6749ff@intel.com>
	 <f74375b44d86f11843901a909e60bed228809677.camel@intel.com>
	 <20266111-2f25-49c1-8cda-69eac40ad9f0@intel.com>
In-Reply-To: <20266111-2f25-49c1-8cda-69eac40ad9f0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4664:EE_
x-ms-office365-filtering-correlation-id: ba0d8cb4-74c6-4b00-c284-08dbef958faf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PwuJkmFOEoEepET64R6AyyAQtTnpeYNS7vWKlBJa+lc1emRfdenYFiG7HWTbXh0U9kSVFFQo7SLjG/nPSORjVLkQhKLzu+Ce0wbXyjU7bTW+7+WcjKcFgQQBb1F669kdUgb4ocEPhtqIvNX29BQGd7HyFjRjTZzpZtAayXcMKiInecU0ljV6h48yebKNMkVYCMjoTsLO9crccSQ1RPYcyjrXpwKJFVGwMsFlZZsRxF3CQRxYOP4ccfBslX36S9J3Ie4PiUkCAPGAhLBF9Pc3+HUiFnoilIe6k/WhgAvALW7BfZloVwKsBlOlQ1Df/doYxt7e6C+mXFsCQnFOkGHbbpTjVWGqjrmHUEgDoRsmOI0m/Hr1cF6KMRtpCw9NGIMK2qv2thwVnvZBGJO/cHMOe5z9S2VmDBK908ZYgxEDBhV9JqErrr8YralfOubdLn6mRySQg4JIiTE/8CAmfkYLmm+mE3piaZQQbfTVfvWV/rHbBg8QIuSkXb2lH3TPgXA343k16QAR5c+1jaViiBbwk7qgqI/wu+z164+PPpckj53NP7HiWEe9hRHteTrXK1wWVDsurizSozgXL+zeHHYoBfGnZyAp4HvWZacv4J5HIaGntDqKrAthhF/t0elTuRdT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(396003)(376002)(136003)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(71200400001)(2616005)(26005)(53546011)(6512007)(6506007)(478600001)(122000001)(99936003)(38100700002)(38070700009)(86362001)(82960400001)(36756003)(4326008)(5660300002)(7416002)(4001150100001)(2906002)(41300700001)(83380400001)(110136005)(6486002)(91956017)(76116006)(316002)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mm9Ud2dPVzdhSTd0N3llK3d2RVI5aVR5Qmc5SVlMZEJQMENhdmpEUXN1Zzli?=
 =?utf-8?B?eGZ3bUtKRU9PZ0xINk1jSndBdjcxWmtXQlNEU2dvZDAvdjF3eE45TVNXRTJL?=
 =?utf-8?B?Yi9KRDZkZWJQbUEwL3hTU1NMeDNKQnVyWWp1aWthclRuTDRSNUIyemVCSUlO?=
 =?utf-8?B?Y3JmaXczU0JmbEM0L1F6cWxiNHVQM1JiWEgyZVQ4WnNTTDJPM0pKQnJKYVJD?=
 =?utf-8?B?dVUwa08wSllpZ3pUalVGckZBQUk2RG93ZUJlbU1XczJLeFluOFFaMklxaDFo?=
 =?utf-8?B?ajhUOEMvV2hqZC9wOHJaZWJwODdjR2xWQXE5TG1BR1JaY1BEMCtYY1pTMUFB?=
 =?utf-8?B?cDM4bEdMbnNJS1NVWHQvazgvaVdOanFZakhYaXBKamE5azFSVkQvSW9jYTZk?=
 =?utf-8?B?d2NLVU5JdjhJa1lDd0E2TFNybFVZb3dhMHgzK0g2dkJpb1A2R1RzQlZ4cWRs?=
 =?utf-8?B?VkNDS1duOGttRjJ5OW54TzFRQTQxeS9kbG0vcnkxeWhZN1NGVzVVZi9zc3U2?=
 =?utf-8?B?R1RsRklSdXJSQjJhNHpzanZDYnRCeUREbERSb2hCL0RLbzBFN3ZIY2dqbndt?=
 =?utf-8?B?T3ZtY0dwWjJvbDlTdXc5MEdFU0lPQ1RFRzB5S2kzSFdXMkhzb1ZpR2tWR2VW?=
 =?utf-8?B?d0V3UjVTTU9sWHF1L281RWlQRFYvd2VXZW1KWnppVTdKNldyc3lnQXFzdEl2?=
 =?utf-8?B?T2xKd0FDSUh1VTA3ZmZIQU5oaUFDSGFzSkFkaXQ1aFUxLy8rcTlmczBqeXhF?=
 =?utf-8?B?YVVZMmFxZ2UvREJxRzIzcmxQY1JYUm0xaWdyZktXT3JTWk45Sks4eGp1MHc2?=
 =?utf-8?B?RUdQNlBrRkhpd1YzSjl3di9ma0YzRjVlanl3SkNFOUJwNFI4aEM5MU5GT3VK?=
 =?utf-8?B?V3I3WFo0dnpTUzFqOXJOTWRxV05HSlpWVVJjMFRRdURyN2NyM2h2VkZJRFp4?=
 =?utf-8?B?OEc2NmFqWVFNVGVrSWJxQVVhb1g4c1VpRjl0eWx0d1RES1V5S2dpOHdjTlFK?=
 =?utf-8?B?OW1zV0hSWllsMzQ2VlVVb2VMNUdCK1hKT0VaTERpaWNHZzFmTTFYc0FrL0RG?=
 =?utf-8?B?Ync3ZHRRRGlFb2E5VE5oYUI2M3N3b2ppRThuWjlYb0ZQajBCQWdkeTB3cGJD?=
 =?utf-8?B?S0ZCVjFpbEp0b0RsSzYxNHBUdFRycnIvQnhlQkJ4V2xrc2hLaEc1Q3dFMnQ4?=
 =?utf-8?B?bDU0K3A0TEhRZGZ4M3cxeHlEV3hYVUdleVhJcmJ4dUhDOGEwOVREaEVHY0ZU?=
 =?utf-8?B?UkIzamduR1cyMkg1Q2NqNWgwRWdkcERvcGlReGFQZXJyQVJTSjZjb2M3czFE?=
 =?utf-8?B?NlkvbFBkUnRSc0lrWkZPd0NmYU5xWjJ6cVBBMm4yMHU5MEtDVC9KR3M4ZFJy?=
 =?utf-8?B?NTFOcUFieDZrYWZXdWN0Qi8xL2taL3l4V2dEVXNGTFQ4bDVidXBMYnd5Z2h4?=
 =?utf-8?B?cG5OSDFnblNWbzNqcUhYMG40cEh6TG4yaXdFZ1J0ZW1jSHhNOUpPcHBpbEdk?=
 =?utf-8?B?Z09QUlF5YU9memxCbmYrcExqaWJZcW1jd3pKVlFxVnd5VjFLSUFQMERYcytZ?=
 =?utf-8?B?UnpjWnRzNU5FdXl4a2Vjc0NtZTAvd2NaVWlrVkhkdE5jbENYZEZ3ZDkzT1BW?=
 =?utf-8?B?d2w2VjRabE5WZXhXR1U2cVl5VXpwSHEwK0lsVXNUM29SbTlWODVKbHZtVk82?=
 =?utf-8?B?UEZEUjVIOXdvSEZXdmtwcmRCNmZCT3BQQURiK2NwWU02Z3FzUE8rUWtXczR1?=
 =?utf-8?B?elBQVEU1OTJBOFJXTU81SXNCV3VuZTF4blMrUVlGOHBpcHF3WThGeTBmZmtG?=
 =?utf-8?B?a0dOcU96MWlRR2RWQ0svZUpjUTB5QVRCQzhDUDd1V2JqMko4UHM5aWEzS3pP?=
 =?utf-8?B?WEw2Q044djB1RVk0UzBOalNYMFJRa3I4L09HbjIwZmhDSUl2WktMTm56YURO?=
 =?utf-8?B?UHNBQXF5WWRMMjhUM2p3bGEzaGlOTUdVbFBKMHNFa0VnTFVnSEpwUkx4R0lF?=
 =?utf-8?B?ZFdZbjZDSGJMM3krUHc5WjlZT25aMHppVHRRK2M0aDZSQXBCd2pSSkhwWndm?=
 =?utf-8?B?Z3gwS3BldVNUN09aeEdVNnVZcUFNMVBiZzU4RWgzalVvTUpDT1ZOc0t3UFM4?=
 =?utf-8?B?eTEyN0xLcWlGT0FySC9WcnRBblNlbm1jVGxZS3p1VXJoMW1jOXhxdDlFVDJ3?=
 =?utf-8?B?UVE9PQ==?=
Content-Type: multipart/mixed;
	boundary="_002_dce6db4fa3c9801ce03cd0c700bd8b686de3ecfecamelintelcom_"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0d8cb4-74c6-4b00-c284-08dbef958faf
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2023 22:09:44.2810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: caskUx7dPZ9lJtXn22TV2yJL+zyIXAINdRgYEDM1aS3D6Eknf7o3j6biZPzMacjV6DdgD7jFlG+jiM1NX+u/Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4664
X-OriginatorOrg: intel.com

--_002_dce6db4fa3c9801ce03cd0c700bd8b686de3ecfecamelintelcom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8CCDCA53011164A90422E3B76F9FE38@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

T24gTW9uLCAyMDIzLTExLTI3IGF0IDEzOjA2IC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDExLzI3LzIzIDEyOjUyLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IC0tLSBhL2FyY2gveDg2
L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvbWFj
aGluZV9rZXhlY182NC5jDQo+ID4gQEAgLTM3Nyw3ICszNzcsOCBAQCB2b2lkIG1hY2hpbmVfa2V4
ZWMoc3RydWN0IGtpbWFnZSAqaW1hZ2UpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKHVuc2lnbmVkIGxvbmcpcGFnZV9saXN0LA0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGltYWdlLT5zdGFydCwNCj4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBpbWFnZS0+cHJlc2VydmVfY29udGV4dCwNCj4gPiAt
DQo+ID4gY2NfcGxhdGZvcm1faGFzKENDX0FUVFJfSE9TVF9NRU1fRU5DUllQVCkpOw0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNjX3BsYXRmb3JtX2hhcyhDQ19B
VFRSX0hPU1RfTUVNX0VOQ1JZUFQpDQo+ID4gPiA+IA0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHBsYXRmb3JtX3RkeF9lbmFibGVkKCkpOw0KPiANCj4gV2VsbCwg
c29tZXRoaW5nIG1vcmUgbGlrZSB0aGUgYXR0YWNoZWQgd291bGQgYmUgcHJlZmVyYWJsZSwgYnV0
IHlvdSd2ZQ0KPiBnb3QgdGhlIHJpZ2h0IGlkZWEgbG9naWNhbGx5Lg0KDQpUaGFua3MhDQoNCk9u
IHRvcCBvZiB0aGF0LCBJIHRoaW5rIGJlbG93IGNvZGUgKGFsc28gYXR0YWNoZWQgdGhlIGRpZmYp
IHNob3VsZCBkbw0KYWR2ZXJ0aXNpbmcgdGhlIENDX0FUVFJfSE9TVF9NRU1fSU5DT0hFUkVOVCBm
b3IgVERYIGhvc3Q/DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9jb2NvL2NvcmUuYyBiL2FyY2gv
eDg2L2NvY28vY29yZS5jDQppbmRleCAyZTJkNTU5MTY5YTguLmJlYzcwYjk2NzUwNCAxMDA2NDQN
Ci0tLSBhL2FyY2gveDg2L2NvY28vY29yZS5jDQorKysgYi9hcmNoL3g4Ni9jb2NvL2NvcmUuYw0K
QEAgLTEyLDYgKzEyLDggQEANCiANCiAjaW5jbHVkZSA8YXNtL2NvY28uaD4NCiAjaW5jbHVkZSA8
YXNtL3Byb2Nlc3Nvci5oPg0KKyNpbmNsdWRlIDxhc20vY3B1ZmVhdHVyZXMuaD4NCisjaW5jbHVk
ZSA8YXNtL3RkeC5oPg0KIA0KIGVudW0gY2NfdmVuZG9yIGNjX3ZlbmRvciBfX3JvX2FmdGVyX2lu
aXQgPSBDQ19WRU5ET1JfTk9ORTsNCiBzdGF0aWMgdTY0IGNjX21hc2sgX19yb19hZnRlcl9pbml0
Ow0KQEAgLTIzLDcgKzI1LDkgQEAgc3RhdGljIGJvb2wgbm9pbnN0ciBpbnRlbF9jY19wbGF0Zm9y
bV9oYXMoZW51bSBjY19hdHRyIGF0dHIpDQogICAgICAgIGNhc2UgQ0NfQVRUUl9IT1RQTFVHX0RJ
U0FCTEVEOg0KICAgICAgICBjYXNlIENDX0FUVFJfR1VFU1RfTUVNX0VOQ1JZUFQ6DQogICAgICAg
IGNhc2UgQ0NfQVRUUl9NRU1fRU5DUllQVDoNCi0gICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsN
CisgICAgICAgICAgICAgICByZXR1cm4gY3B1X2ZlYXR1cmVfZW5hYmxlZChYODZfRkVBVFVSRV9U
RFhfR1VFU1QpOw0KKyAgICAgICBjYXNlIENDX0FUVFJfSE9TVF9NRU1fSU5DT0hFUkVOVDoNCisg
ICAgICAgICAgICAgICByZXR1cm4gcGxhdGZvcm1fdGR4X2VuYWJsZWQoKTsNCiAgICAgICAgZGVm
YXVsdDoNCiAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQogICAgICAgIH0NCmRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgv
dGR4LmMNCmluZGV4IDczY2QyZjdiN2Q4Ny4uMWFlMjEzNDhlZGMxIDEwMDY0NA0KLS0tIGEvYXJj
aC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQorKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMNCkBAIC0xNjM0LDYgKzE2MzQsMTMgQEAgc3RhdGljIGludCBfX2luaXQgdGR4X2luaXQodm9p
ZCkNCiAgICAgICAgdGR4X2d1ZXN0X2tleWlkX3N0YXJ0ID0gdGR4X2tleWlkX3N0YXJ0ICsgMTsN
CiAgICAgICAgdGR4X25yX2d1ZXN0X2tleWlkcyA9IG5yX3RkeF9rZXlpZHMgLSAxOw0KIA0KKyAg
ICAgICAvKg0KKyAgICAgICAgKiBURFggZG9lc24ndCBndWFyYW50ZWUgY2FjaGUgY29oZXJlbmN5
IGFtb25nIGRpZmZlcmVudA0KKyAgICAgICAgKiBLZXlJRHMuICBBZHZlcnRpc2UgdGhlIENDX0FU
VFJfSE9TVF9NRU1fSU5DT0hFUkVOVA0KKyAgICAgICAgKiBhdHRyaWJ1dGUgZm9yIFREWCBob3N0
Lg0KKyAgICAgICAgKi8NCisgICAgICAgY2NfdmVuZG9yID0gQ0NfVkVORE9SX0lOVEVMOw0KKw0K
ICAgICAgICByZXR1cm4gMDsNCiB9DQogZWFybHlfaW5pdGNhbGwodGR4X2luaXQpOw0KDQoNCkkn
bGwgZG8gc29tZSB0ZXN0IHdpdGggeW91ciBjb2RlIGFuZCB0aGUgYWJvdmUgY29kZS4NCg==

--_002_dce6db4fa3c9801ce03cd0c700bd8b686de3ecfecamelintelcom_
Content-Type: text/x-patch; name="tdx-host-mem-incoherent.diff"
Content-Description: tdx-host-mem-incoherent.diff
Content-Disposition: attachment; filename="tdx-host-mem-incoherent.diff";
	size=1276; creation-date="Mon, 27 Nov 2023 22:09:43 GMT";
	modification-date="Mon, 27 Nov 2023 22:09:43 GMT"
Content-ID: <BF5FD4F349DCFD4B82EC95A018CBD014@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2NvY28vY29yZS5jIGIvYXJjaC94ODYvY29jby9jb3JlLmMK
aW5kZXggMmUyZDU1OTE2OWE4Li5iZWM3MGI5Njc1MDQgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2Nv
Y28vY29yZS5jCisrKyBiL2FyY2gveDg2L2NvY28vY29yZS5jCkBAIC0xMiw2ICsxMiw4IEBACiAK
ICNpbmNsdWRlIDxhc20vY29jby5oPgogI2luY2x1ZGUgPGFzbS9wcm9jZXNzb3IuaD4KKyNpbmNs
dWRlIDxhc20vY3B1ZmVhdHVyZXMuaD4KKyNpbmNsdWRlIDxhc20vdGR4Lmg+CiAKIGVudW0gY2Nf
dmVuZG9yIGNjX3ZlbmRvciBfX3JvX2FmdGVyX2luaXQgPSBDQ19WRU5ET1JfTk9ORTsKIHN0YXRp
YyB1NjQgY2NfbWFzayBfX3JvX2FmdGVyX2luaXQ7CkBAIC0yMyw3ICsyNSw5IEBAIHN0YXRpYyBi
b29sIG5vaW5zdHIgaW50ZWxfY2NfcGxhdGZvcm1faGFzKGVudW0gY2NfYXR0ciBhdHRyKQogCWNh
c2UgQ0NfQVRUUl9IT1RQTFVHX0RJU0FCTEVEOgogCWNhc2UgQ0NfQVRUUl9HVUVTVF9NRU1fRU5D
UllQVDoKIAljYXNlIENDX0FUVFJfTUVNX0VOQ1JZUFQ6Ci0JCXJldHVybiB0cnVlOworCQlyZXR1
cm4gY3B1X2ZlYXR1cmVfZW5hYmxlZChYODZfRkVBVFVSRV9URFhfR1VFU1QpOworCWNhc2UgQ0Nf
QVRUUl9IT1NUX01FTV9JTkNPSEVSRU5UOgorCQlyZXR1cm4gcGxhdGZvcm1fdGR4X2VuYWJsZWQo
KTsKIAlkZWZhdWx0OgogCQlyZXR1cm4gZmFsc2U7CiAJfQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jCmluZGV4IDcz
Y2QyZjdiN2Q4Ny4uMWFlMjEzNDhlZGMxIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90
ZHgvdGR4LmMKKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jCkBAIC0xNjM0LDYgKzE2
MzQsMTMgQEAgc3RhdGljIGludCBfX2luaXQgdGR4X2luaXQodm9pZCkKIAl0ZHhfZ3Vlc3Rfa2V5
aWRfc3RhcnQgPSB0ZHhfa2V5aWRfc3RhcnQgKyAxOwogCXRkeF9ucl9ndWVzdF9rZXlpZHMgPSBu
cl90ZHhfa2V5aWRzIC0gMTsKIAorCS8qCisJICogVERYIGRvZXNuJ3QgZ3VhcmFudGVlIGNhY2hl
IGNvaGVyZW5jeSBhbW9uZyBkaWZmZXJlbnQKKwkgKiBLZXlJRHMuICBBZHZlcnRpc2UgdGhlIEND
X0FUVFJfSE9TVF9NRU1fSU5DT0hFUkVOVAorCSAqIGF0dHJpYnV0ZSBmb3IgVERYIGhvc3QuCisJ
ICovCisJY2NfdmVuZG9yID0gQ0NfVkVORE9SX0lOVEVMOworCiAJcmV0dXJuIDA7CiB9CiBlYXJs
eV9pbml0Y2FsbCh0ZHhfaW5pdCk7Cg==

--_002_dce6db4fa3c9801ce03cd0c700bd8b686de3ecfecamelintelcom_--

