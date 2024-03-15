Return-Path: <kvm+bounces-11881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE3F87C868
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 05:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 287BE2826E2
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 04:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A581094E;
	Fri, 15 Mar 2024 04:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TbXue0ih"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3221FBE8;
	Fri, 15 Mar 2024 04:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710478686; cv=fail; b=QKlZRzS1/OKZLEIFgBk9ZcGkDqtNhQPafRf9+s6ATcOQq4Gel4FvxRVL5sf50QCdkH+rnEuiNhOm1Iq72PqwX3WeCu8U3KoDnDMoWyy5VmoV9+OX9FBSJ9VGQrj+x1w+aL4UkDOq50xgYWtnqp3axh3E/iwvyfhAgZ2ve+MZq6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710478686; c=relaxed/simple;
	bh=N6PT9OshU9HiLp2NpDqFoDozZLSFu/cNvTqBeB2aJiE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DVi8Xmz1oD34WAWngY1cFnBsE1MK0p7gxvxCK5Gz8qJx376vF6S85Y5hHd5I6u+1MmeYp6qIc7G6vGFd03UgiFViaZqPrEmL0b5YPISDeGx2PfjsKRnN0bIbPuMFvnheaTFW+ncGLOR7hNxXFDNAe1uTRRmeLFaXtLG62Uu/fVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TbXue0ih; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710478684; x=1742014684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N6PT9OshU9HiLp2NpDqFoDozZLSFu/cNvTqBeB2aJiE=;
  b=TbXue0ihh2kPQZ4t1KJsSrviufcc7NNLTT7OA74JN+ViMY95iOiyKJ7e
   kZYKvLeb4Lp+WcfpPBWwmlWRMtp6g0K2Y+bgbRJmCBtzA5EHzjHZ/c1a0
   5hglQN6aXbxN1v7xBmccxQHSLDxZ2o8FB7T5as3t1HR+AgZix2f2eJAhL
   5kNa2C4/Q01rk7qX0+VyRib14a2YnNt3BEGS1n5VHzSaDTq7pGfFGbEWi
   gOD149v9ne1DxAEuC20IPASZi4RB8PjswxZGpiR3nDr766QovJM9SiggK
   L2WDhLgkSCQSwgX2ZSurw39C1fgGz12Wx7BucVNG3363P8gdh1UppefoZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5182027"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="5182027"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 21:58:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="17139050"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 21:58:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 21:58:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 21:58:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 21:58:01 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 21:58:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5PsgDSwPlaNTBSQvzXNvNA4Wwvmpdk0xxaFhiIMJT/mMecQmbJ7vR/n/9o2SNOiwP1Xlpj51fsoxnQemXbX8M6Y6n/Pe3P4oq2/07G5+U63Gt7ZDWFWxOMlxsjG/fTGfMPVAGrt+4QMS7V21jKtONTMl8orq6mwJbzECefpeuB+9EZJyfz/WIlLmxD7bl9LhzgLCNTrG/4Bal6IV9rfi9BkwzAzNCITHZkWAY4z1o8SLPP5wFxjzxCNfkEzd+99QmoTLbXtSEmC+z3mTdX13qAvflVhbm85CDFKiqL92J3uPGrls5wERWMpQEIdxYg/pAYH36L1Y+qo+7xINGLIsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N6PT9OshU9HiLp2NpDqFoDozZLSFu/cNvTqBeB2aJiE=;
 b=gJqudrMnlh5SdmgNyFY2Anqp3xKsg1GjOn9QfabYiD5rC2lTtSOvWaP+JEHzcSkwpv0E51FfhOnW6R8mG2O9/lhZR8bp3HgS9rNH+62AZGxp3pUFQHKucr9FuDK6pYZziOxHPjH6LZFFLdHuyxXxslpUIww7M0994rFgb9ZvHy1hnLnxERBkhs0saXNaQoVoIaXx6ohbf4G4CupWU4k35F8FMOvW7/L3p7+HJZEgy95QHeUPm3fstrNzbAM/Hylcafe02iYnK3eIcFkwcclm275VTSIQGTnAKxQXfqOr5+hzcx6QbiPamPcbEG2FwYmhqpoCC98pfY63RyQSygo3xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4863.namprd11.prod.outlook.com (2603:10b6:a03:2ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Fri, 15 Mar
 2024 04:57:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Fri, 15 Mar 2024
 04:57:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX
 module on initialization
Thread-Topic: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX
 module on initialization
Thread-Index: AQHaaI26NdKryYpZXEuSi/e9HKO5abE3+DmAgAA06gCAACxugA==
Date: Fri, 15 Mar 2024 04:57:59 +0000
Message-ID: <aa1ed4c118177e3e341eebccecac3b07bf75a47d.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
	 <e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com>
	 <15a13c5d-df88-46cf-8d88-2c8b94ff41ff@intel.com>
In-Reply-To: <15a13c5d-df88-46cf-8d88-2c8b94ff41ff@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4863:EE_
x-ms-office365-filtering-correlation-id: ee149f7a-d7b4-490c-39d4-08dc44ac7c59
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rpaWubwwPuet9C5Idlib4fKB+jqBgHg9YNh74lR8Xt/KkrfroEWgR5RTEQln7ycrzPBdzmwnS4Z49t45/HRIuqXkmd5ogRMQITsKUINOO7eOvzFg+CTo5tqkYmZWAnmigYabfzUQok4CM5ghLrnXOyB2srimW0pxawEFUOwE5vUtHrI/W6iS0wvP2Q7hlAf67OsXpbkb59QxYABTg5eP85PYKYMZFTr/8aDu0FyhE3mwdFT1ruCpkOvcvjNQSIkbHGOjRwG8y4pAt9pgpigtSrCZ7aax//Pc6zOBAtfthzaw+0yoc7bQgv10ESniZbOpfULSOKhBMpjqNYtL2yYGPCovjHhS7WPdsqnG/dMzBwtjMZV+/g8IQvIQqQj0W4newezUwMnZJbi5Q1o7EdZZId7IwQHQp64iKKZPa3FWkCOHs9DzMnC2PX8uwfdoaNk0K/GaqsJsS7HIUeTt/3PuvXwQ1BsinfMn4MGUN2ZhGh/mOKZJPlPE3x/0zdNWup+9xZTMbVsG2ubMHksya5eFKpGCI5Z4YnTNppPNv9gQamSVNPz7qkh0cZgRA9q457bCKk8/0pMTsJ1NqPVTISoOnVkXkkYJz8VKH3bcYSqAcKMvycSVefYe4oQFKUo8VTMdjJZPl2GZhr+U6dkQx3RIqxri08Etkc2c7Gs+CszKbxwF7FBUda3CRT1rnf+zRSGhPmp4q0zz8UtCnJPYoMPYsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFA2eTkwbEdIRmg5STJ4VnhMenh2RkJOblFldHI5Y2hYWCtybnpXVlN5TEhr?=
 =?utf-8?B?ZW43cnJnOWI1SDQ1VThXV3hhSlBCTGZRWlRhS2dRWlNiaVphUWEyNmVtYm5H?=
 =?utf-8?B?MzVJcEk5UndTSW1wZXZDS1lmbmEyeUZSbTNyT3JsKzM3SXZ5bmFYcEZLRDJh?=
 =?utf-8?B?TDR5ZVdvTCs1NVl1bGdwVjBNWUtDbVRXZW50VWU0QVBXMHFCbUlRcmxYMFA3?=
 =?utf-8?B?L29MaE41NHMxTDViaXBYVlAwWXRIWjBvYzIrcW0yc2VIbHY3MEhLYXUrZ2ZR?=
 =?utf-8?B?V0h5bkt4V3hLSVVrRVNkYXJjV3VISkhubk8vWnlEcnltOEE1TG5VWjNsN0d0?=
 =?utf-8?B?YVVLMkFLYVI3TExvZUkvZi9TbHZVQlFjbjNHQWVodW5JRUdsK3Y1YU9TYWxI?=
 =?utf-8?B?YUVjbzk2YzRKU2VDUXhKdGx1WmQ0MDJaVGJSMitPZVpZNUUyK1hZWTU1RSt2?=
 =?utf-8?B?ckU0aEJyLzVTOGViUkhyckNIeG1ZV3RTYksyODI2NGM3SjM1aktLa2pVbklp?=
 =?utf-8?B?dmNvc3MxZFh1R3ErRWhjTmMzMFdWc0VUN2JyM0gyYmdUbnFqclRpYTArN2VH?=
 =?utf-8?B?MURvcUZjdlBZZTRZdHhuS21iSXJCcEg4RDRkZW11dFBRM1RFaWVsV2U4NDho?=
 =?utf-8?B?cXlZYzQ0ZjdoMGlXdVQzTzNkbUFnd3lwc3VkRFE5MlRTelBXckxtQVJWaDNm?=
 =?utf-8?B?dFZYUERhS0RRMFNjWS9tSWVWYUhyU2t5b2JwWEI1NzlVdUltL3hDL0U5TDgr?=
 =?utf-8?B?Q3UxQTRtMkc1Yk9Nb1FHU25Sb1kzbjhTRlVId1F3SGFJdi8rMHF5Nm1zNkxG?=
 =?utf-8?B?WndxZ0lHckJMWjFvL29RbytXYk1ueDlQWGNmd29hYlp2RVZaRUZQNFdESmFi?=
 =?utf-8?B?RjZpbEJoTVJUZWE5d0N3N3JQaWJoZGdmTmxyNEd1dGFuWVB3RFdNVXRYMmQx?=
 =?utf-8?B?VFA3c2JmMStId2NvVHFFb28rOGdZVDBLZ1pBRllhM2plYUIrZzJPd0crU3RB?=
 =?utf-8?B?a0ZDYWNjZjRMcDE2RTk3RXJTRllCUmd6UlM2eEFxZ0ZCeUJGWktsVVZJQjJV?=
 =?utf-8?B?N2t0blBxSUtIYWhxMHdQWXlldG9xZ2lGd1BoQ0dod1RkTVpIa3N6SEZsY2Fx?=
 =?utf-8?B?d1AxYmZ1UUJ2c0pBNHJpa1R4T2h5YStoUVFKVXV1YkV3S2Q5RzVEdU1qK3Rk?=
 =?utf-8?B?bmlUdXNHUGlXRFQyUUFjelZrUjRLMUJEcVZmK0tOQkYxUzVVQXo1WGJCY2cx?=
 =?utf-8?B?NGJyT01yc3NDQ0Y2aUZEWWdoaU4zNEI3WFUrTUMxTUdoWUtVcTRWdk4rbXdQ?=
 =?utf-8?B?OU5DeEVkdStzTmVVeFgyM09IV01neHZRRFRrVWlUNUdmcXhNR2l1MXlNMnJF?=
 =?utf-8?B?Umt0WEhsWWhpSHA2ejd0RDlQT0czTGlKMWQ5bDZ3d0RiK3laZ0hzTXc2a29m?=
 =?utf-8?B?K1pWaHMyYmhIOHFHaHVicDhNWG1HUC8wd2VsdjZsU0pVcGFTNVRSQUZOSkdz?=
 =?utf-8?B?UHNSb0lhbk84a3F1ejk3WVpYUGFDcDh3WjRvY01sNGpzQzZyUWp4VDRaenl5?=
 =?utf-8?B?ZGlYSjdnVXZoc3RIM1A1cFpxZkhmaEVyYmNqTlc1bUxxSytxc2w5YUxrSXFx?=
 =?utf-8?B?Wm9WRzFYT3NDd2M0a3FMRXFWcDNvOFlUVHNybUJWUWZmWHh6NEhMeFFVQVIw?=
 =?utf-8?B?S24venJzakZlTUpwb3N5Nk9NUDRaWTMzSEZQTVlpQWErbG0rTEhPb3BpR2p6?=
 =?utf-8?B?cHQrdE1OZ0JCQkI1Ry9VZnpJVC9jNzUxazVCMTA3L2xRTWlUTzNBTml2Vndw?=
 =?utf-8?B?QzN0ODZjWTVpTXB4WWFCMGlLbFZoMVFHRUpnMTlNa0QzbGRmOXY0NGZqdm80?=
 =?utf-8?B?Qkp5OHdrQWVteTVyMXhBRjU5blJsQWU5ZVUybDE0cit2UUpsUm5JN3FHL1ZX?=
 =?utf-8?B?SHRhNlJDdmIxcHRTVXd3bTNsaDduQ29KSU02eElMMno0Vlp2WlljcTJ0Zkhy?=
 =?utf-8?B?UWN3eUxvdTF3MW1kcEloNklwT1ZHMjI2Q0RNUXJ1SWpsMFdVYWFUNUYzZGkw?=
 =?utf-8?B?OGpjSmlBQ1FMcmVxeW1wQ1VVeGlBZmVSU3lvbGNEWDNiYUQzd05sVEt6Yjg2?=
 =?utf-8?B?RDNYSk1qcWZySHFUTVdqWXZtZUJycUtNazg3WDQ2Q2VuaG9pOWFFWWYwRzVI?=
 =?utf-8?B?MUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98DC257F4E219040B4413B6E4BAA9E33@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee149f7a-d7b4-490c-39d4-08dc44ac7c59
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 04:57:59.0525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5DSlfp6+5abcaOm3d/twwLgpMSzP4nw3zWskiuH3rFALvt6N3rfgIsDc/UGw6vFJxcdM+oUpUePEPYxTOdODPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4863
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTE1IGF0IDEwOjE4ICswODAwLCBMaSwgWGlhb3lhbyB3cm90ZToNCj4g
T24gMy8xNS8yMDI0IDc6MDkgQU0sIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gDQo+ID4gPiArc3Ry
dWN0IHRkeF9pbmZvIHsNCj4gPiA+ICvCoMKgwqAgdTY0IGZlYXR1cmVzMDsNCj4gPiA+ICvCoMKg
wqAgdTY0IGF0dHJpYnV0ZXNfZml4ZWQwOw0KPiA+ID4gK8KgwqDCoCB1NjQgYXR0cmlidXRlc19m
aXhlZDE7DQo+ID4gPiArwqDCoMKgIHU2NCB4ZmFtX2ZpeGVkMDsNCj4gPiA+ICvCoMKgwqAgdTY0
IHhmYW1fZml4ZWQxOw0KPiA+ID4gKw0KPiA+ID4gK8KgwqDCoCB1MTYgbnVtX2NwdWlkX2NvbmZp
ZzsNCj4gPiA+ICvCoMKgwqAgLyogVGhpcyBtdXN0IHRoZSBsYXN0IG1lbWJlci4gKi8NCj4gPiA+
ICvCoMKgwqAgREVDTEFSRV9GTEVYX0FSUkFZKHN0cnVjdCBrdm1fdGR4X2NwdWlkX2NvbmZpZywg
Y3B1aWRfY29uZmlncyk7DQo+ID4gPiArfTsNCj4gPiA+ICsNCj4gPiA+ICsvKiBJbmZvIGFib3V0
IHRoZSBURFggbW9kdWxlLiAqLw0KPiA+ID4gK3N0YXRpYyBzdHJ1Y3QgdGR4X2luZm8gKnRkeF9p
bmZvOw0KPiA+ID4gKw0KPiA+ID4gwqAgI2RlZmluZSBURFhfTURfTUFQKF9maWQsIF9wdHIpwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBcDQo+ID4gPiDCoMKgwqDCoMKgIHsgLmZpZCA9IE1EX0ZJRUxE
X0lEXyMjX2ZpZCzCoMKgwqDCoMKgwqDCoCBcDQo+ID4gPiDCoMKgwqDCoMKgwqDCoCAucHRyID0g
KF9wdHIpLCB9DQo+ID4gPiBAQCAtNjYsNyArODEsNyBAQCBzdGF0aWMgc2l6ZV90IHRkeF9tZF9l
bGVtZW50X3NpemUodTY0IGZpZCkNCj4gPiA+IMKgwqDCoMKgwqAgfQ0KPiA+ID4gwqAgfQ0KPiA+
ID4gLXN0YXRpYyBpbnQgX191c2VkIHRkeF9tZF9yZWFkKHN0cnVjdCB0ZHhfbWRfbWFwICptYXBz
LCBpbnQgbnJfbWFwcykNCj4gPiA+ICtzdGF0aWMgaW50IHRkeF9tZF9yZWFkKHN0cnVjdCB0ZHhf
bWRfbWFwICptYXBzLCBpbnQgbnJfbWFwcykNCj4gPiA+IMKgIHsNCj4gPiA+IMKgwqDCoMKgwqAg
c3RydWN0IHRkeF9tZF9tYXAgKm07DQo+ID4gPiDCoMKgwqDCoMKgIGludCByZXQsIGk7DQo+ID4g
PiBAQCAtODQsOSArOTksMjYgQEAgc3RhdGljIGludCBfX3VzZWQgdGR4X21kX3JlYWQoc3RydWN0
IHRkeF9tZF9tYXAgDQo+ID4gPiAqbWFwcywgaW50IG5yX21hcHMpDQo+ID4gPiDCoMKgwqDCoMKg
IHJldHVybiAwOw0KPiA+ID4gwqAgfQ0KPiA+ID4gKyNkZWZpbmUgVERYX0lORk9fTUFQKF9maWVs
ZF9pZCwgX21lbWJlcinCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwNCj4gPiA+ICvCoMKgwqAgVERf
U1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBzdHJ1Y3QgdGR4X2luZm8sIF9tZW1iZXIpDQo+ID4gPiAr
DQo+ID4gPiDCoCBzdGF0aWMgaW50IF9faW5pdCB0ZHhfbW9kdWxlX3NldHVwKHZvaWQpDQo+ID4g
PiDCoCB7DQo+ID4gPiArwqDCoMKgIHUxNiBudW1fY3B1aWRfY29uZmlnOw0KPiA+ID4gwqDCoMKg
wqDCoCBpbnQgcmV0Ow0KPiA+ID4gK8KgwqDCoCB1MzIgaTsNCj4gPiA+ICsNCj4gPiA+ICvCoMKg
wqAgc3RydWN0IHRkeF9tZF9tYXAgbWRzW10gPSB7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqAgVERY
X01EX01BUChOVU1fQ1BVSURfQ09ORklHLCAmbnVtX2NwdWlkX2NvbmZpZyksDQo+ID4gPiArwqDC
oMKgIH07DQo+ID4gPiArDQo+ID4gPiArwqDCoMKgIHN0cnVjdCB0ZHhfbWV0YWRhdGFfZmllbGRf
bWFwcGluZyBmaWVsZHNbXSA9IHsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCBURFhfSU5GT19NQVAo
RkVBVFVSRVMwLCBmZWF0dXJlczApLA0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgIFREWF9JTkZPX01B
UChBVFRSU19GSVhFRDAsIGF0dHJpYnV0ZXNfZml4ZWQwKSwNCj4gPiA+ICvCoMKgwqDCoMKgwqDC
oCBURFhfSU5GT19NQVAoQVRUUlNfRklYRUQxLCBhdHRyaWJ1dGVzX2ZpeGVkMSksDQo+ID4gPiAr
wqDCoMKgwqDCoMKgwqAgVERYX0lORk9fTUFQKFhGQU1fRklYRUQwLCB4ZmFtX2ZpeGVkMCksDQo+
ID4gPiArwqDCoMKgwqDCoMKgwqAgVERYX0lORk9fTUFQKFhGQU1fRklYRUQxLCB4ZmFtX2ZpeGVk
MSksDQo+ID4gPiArwqDCoMKgIH07DQo+ID4gPiDCoMKgwqDCoMKgIHJldCA9IHRkeF9lbmFibGUo
KTsNCj4gPiA+IMKgwqDCoMKgwqAgaWYgKHJldCkgew0KPiA+ID4gQEAgLTk0LDcgKzEyNiw0OCBA
QCBzdGF0aWMgaW50IF9faW5pdCB0ZHhfbW9kdWxlX3NldHVwKHZvaWQpDQo+ID4gPiDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4gPiA+IMKgwqDCoMKgwqAgfQ0KPiA+ID4gK8KgwqDC
oCByZXQgPSB0ZHhfbWRfcmVhZChtZHMsIEFSUkFZX1NJWkUobWRzKSk7DQo+ID4gPiArwqDCoMKg
IGlmIChyZXQpDQo+ID4gPiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4gPiA+ICsNCj4g
PiA+ICvCoMKgwqAgdGR4X2luZm8gPSBremFsbG9jKHNpemVvZigqdGR4X2luZm8pICsNCj4gPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVvZigqdGR4X2luZm8tPmNwdWlkX2Nv
bmZpZ3MpICogbnVtX2NwdWlkX2NvbmZpZywNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIEdGUF9LRVJORUwpOw0KPiA+ID4gK8KgwqDCoCBpZiAoIXRkeF9pbmZvKQ0KPiA+ID4g
K8KgwqDCoMKgwqDCoMKgIHJldHVybiAtRU5PTUVNOw0KPiA+ID4gK8KgwqDCoCB0ZHhfaW5mby0+
bnVtX2NwdWlkX2NvbmZpZyA9IG51bV9jcHVpZF9jb25maWc7DQo+ID4gPiArDQo+ID4gPiArwqDC
oMKgIHJldCA9IHRkeF9zeXNfbWV0YWRhdGFfcmVhZChmaWVsZHMsIEFSUkFZX1NJWkUoZmllbGRz
KSwgdGR4X2luZm8pOw0KPiA+ID4gK8KgwqDCoCBpZiAocmV0KQ0KPiA+ID4gK8KgwqDCoMKgwqDC
oMKgIGdvdG8gZXJyb3Jfb3V0Ow0KPiA+ID4gKw0KPiA+ID4gK8KgwqDCoCBmb3IgKGkgPSAwOyBp
IDwgbnVtX2NwdWlkX2NvbmZpZzsgaSsrKSB7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqAgc3RydWN0
IGt2bV90ZHhfY3B1aWRfY29uZmlnICpjID0gJnRkeF9pbmZvLT5jcHVpZF9jb25maWdzW2ldOw0K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgIHU2NCBsZWFmLCBlYXhfZWJ4LCBlY3hfZWR4Ow0KPiA+ID4g
K8KgwqDCoMKgwqDCoMKgIHN0cnVjdCB0ZHhfbWRfbWFwIGNwdWlkc1tdID0gew0KPiA+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgVERYX01EX01BUChDUFVJRF9DT05GSUdfTEVBVkVTICsgaSwg
JmxlYWYpLA0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVERYX01EX01BUChDUFVJRF9D
T05GSUdfVkFMVUVTICsgaSAqIDIsICZlYXhfZWJ4KSwNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIFREWF9NRF9NQVAoQ1BVSURfQ09ORklHX1ZBTFVFUyArIGkgKiAyICsgMSwgJmVjeF9l
ZHgpLA0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgIH07DQo+ID4gPiArDQo+ID4gPiArwqDCoMKgwqDC
oMKgwqAgcmV0ID0gdGR4X21kX3JlYWQoY3B1aWRzLCBBUlJBWV9TSVpFKGNwdWlkcykpOw0KPiA+
ID4gK8KgwqDCoMKgwqDCoMKgIGlmIChyZXQpDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBnb3RvIGVycm9yX291dDsNCj4gPiA+ICsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCBjLT5sZWFm
ID0gKHUzMilsZWFmOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgIGMtPnN1Yl9sZWFmID0gbGVhZiA+
PiAzMjsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCBjLT5lYXggPSAodTMyKWVheF9lYng7DQo+ID4g
PiArwqDCoMKgwqDCoMKgwqAgYy0+ZWJ4ID0gZWF4X2VieCA+PiAzMjsNCj4gPiA+ICvCoMKgwqDC
oMKgwqDCoCBjLT5lY3ggPSAodTMyKWVjeF9lZHg7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqAgYy0+
ZWR4ID0gZWN4X2VkeCA+PiAzMjsNCj4gPiANCj4gPiBPSyBJIGNhbiBzZWUgd2h5IHlvdSBkb24n
dCB3YW50IHRvIHVzZSAuLi4NCj4gPiANCj4gPiAgwqDCoMKgwqBzdHJ1Y3QgdGR4X21ldGFkYXRh
X2ZpZWxkX21hcHBpbmcgZmllbGRzW10gPSB7DQo+ID4gIMKgwqDCoMKgwqDCoMKgIFREWF9JTkZP
X01BUChOVU1fQ1BVSURfQ09ORklHLCBudW1fY3B1aWRfY29uZmlnKSwNCj4gPiAgwqDCoMKgwqB9
Ow0KPiA+IA0KPiA+IC4uLiB0byByZWFkIG51bV9jcHVpZF9jb25maWcgZmlyc3QsIGJlY2F1c2Ug
dGhlIG1lbW9yeSB0byBob2xkIEB0ZHhfaW5mbyANCj4gPiBoYXNuJ3QgYmVlbiBhbGxvY2F0ZWQs
IGJlY2F1c2UgaXRzIHNpemUgZGVwZW5kcyBvbiB0aGUgbnVtX2NwdWlkX2NvbmZpZy4NCj4gPiAN
Cj4gPiBBbmQgSSBjb25mZXNzIGl0J3MgYmVjYXVzZSB0aGUgdGR4X3N5c19tZXRhZGF0YV9maWVs
ZF9yZWFkKCkgdGhhdCBnb3QgDQo+ID4gZXhwb3NlZCBpbiBwYXRjaCAoIng4Ni92aXJ0L3RkeDog
RXhwb3J0IGdsb2JhbCBtZXRhZGF0YSByZWFkIA0KPiA+IGluZnJhc3RydWN0dXJlIikgb25seSBy
ZXR1cm5zICd1NjQnIGZvciBhbGwgbWV0YWRhdGEgZmllbGQsIGFuZCB5b3UgDQo+ID4gZGlkbid0
IHdhbnQgdG8gdXNlIHNvbWV0aGluZyBsaWtlIHRoaXM6DQo+ID4gDQo+ID4gIMKgwqDCoMKgdTY0
IG51bV9jcHVpZF9jb25maWc7DQo+ID4gDQo+ID4gIMKgwqDCoMKgdGR4X3N5c19tZXRhZGF0YV9m
aWVsZF9yZWFkKC4uLiwgJm51bV9jcHVpZF9jb25maWcpOw0KPiA+IA0KPiA+ICDCoMKgwqDCoC4u
Lg0KPiA+IA0KPiA+ICDCoMKgwqDCoHRkeF9pbmZvLT5udW1fY3B1aWRfY29uZmlnID0gbnVtX2Nw
dWlkX2NvbmZpZzsNCj4gPiANCj4gPiBPciB5b3UgY2FuIGV4cGxpY2l0bHkgY2FzdDoNCj4gPiAN
Cj4gPiAgwqDCoMKgwqB0ZHhfaW5mby0+bnVtX2NwdWlkX2NvbmZpZyA9ICh1MTYpbnVtX2NwdWlk
X2NvbmZpZzsNCj4gPiANCj4gPiAoSSBrbm93IHBlb3BsZSBtYXkgZG9uJ3QgbGlrZSB0aGUgYXNz
aWduaW5nICd1NjQnIHRvICd1MTYnLCBidXQgaXQgc2VlbXMgDQo+ID4gbm90aGluZyB3cm9uZyB0
byBtZSwgYmVjYXVzZSB0aGUgd2F5IGRvbmUgaW4gKDEpIGJlbG93IGVmZmVjdGl2ZWx5IGhhcyAN
Cj4gPiB0aGUgc2FtZSByZXN1bHQgY29tcGFyaW5nIHRvIHR5cGUgY2FzZSkuDQo+ID4gDQo+ID4g
QnV0IHRoZXJlIGFyZSBvdGhlciAoYmV0dGVyKSB3YXlzIHRvIGRvOg0KPiA+IA0KPiA+IDEpIHlv
dSBjYW4gaW50cm9kdWNlIGEgaGVscGVyIGFzIHN1Z2dlc3RlZCBieSBYaWFveWFvIGluIFsqXToN
Cj4gPiANCj4gPiANCj4gPiAgwqDCoMKgwqBpbnQgdGR4X3N5c19tZXRhZGF0YV9yZWFkX3Npbmds
ZSh1NjQgZmllbGRfaWQsDQo+ID4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGludCBieXRlcyzCoCB2b2lkICpidWYpDQo+ID4gIMKgwqDCoMKgew0KPiA+ICDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gc3RidWZfcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoZmllbGRfaWQsIDAs
DQo+ID4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnl0
ZXMsIGJ1Zik7DQo+ID4gIMKgwqDCoMKgfQ0KPiA+IA0KPiA+IEFuZCBkbzoNCj4gPiANCj4gPiAg
wqDCoMKgwqB0ZHhfc3lzX21ldGFkYXRhX3JlYWRfc2luZ2xlKE5VTV9DUFVJRF9DT05GSUcsDQo+
ID4gIMKgwqDCoMKgwqDCoMKgIHNpemVvZihudW1fY3B1aWRfY29uZmlnKSwgJm51bV9jcHVpZF9j
b25maWcpOw0KPiA+IA0KPiA+IFRoYXQncyBfbXVjaF8gY2xlYW5lciB0aGFuIHRoZSAnc3RydWN0
IHRkeF9tZF9tYXAnLCB3aGljaCBvbmx5IGNvbmZ1c2VzIA0KPiA+IHBlb3BsZS4NCj4gPiANCj4g
PiBCdXQgSSBkb24ndCB0aGluayB3ZSBuZWVkIHRvIGRvIHRoaXMgYXMgbWVudGlvbmVkIGFib3Zl
IC0tIHdlIGp1c3QgZG8gDQo+ID4gdHlwZSBjYXN0Lg0KPiANCj4gdHlwZSBjYXN0IG5lZWRzIGFu
b3RoZXIgdG1wIHZhcmlhYmxlIHRvIGhvbGQgdGhlIG91dHB1dCBvZiB1NjQuDQo+IA0KPiBUaGUg
cmVhc29uIEkgd2FudCB0byBpbnRyb2R1Y2UgdGR4X3N5c19tZXRhZGF0YV9yZWFkX3NpbmdsZSgp
IGlzIHRvIA0KPiBwcm92aWRlIGEgc2ltcGxlIGFuZCB1bmlmaWVkIGludGVyZmFjZSBmb3Igb3Ro
ZXIgY29kZXMgdG8gcmVhZCBvbmUgDQo+IG1ldGFkYXRhIGZpZWxkLCBpbnN0ZWFkIG9mIGxldHRp
bmcgdGhlIGNhbGxlciB0byB1c2UgdGVtcG9yYXJ5IHU2NCANCj4gdmFyaWFibGUgYW5kIGhhbmRs
ZSB0aGUgY2FzdCBvciBtZW1jcHkgaXRzZWxmLg0KPiANCg0KWW91IGNhbiBhbHdheXMgdXNlIHU2
NCB0byBob2xkIHUxNiBtZXRhZGF0YSBmaWVsZCBBRkFJQ1QsIHNvIGl0IGRvZXNuJ3QgaGF2ZSB0
bw0KYmUgdGVtcG9yYXJ5Lg0KDQpIZXJlIGlzIHdoYXQgSXNha3UgY2FuIGRvIHVzaW5nIHRoZSBj
dXJyZW50IEFQSToNCg0KCXU2NCBudW1fY3B1aWRfY29uZmlnOw0KCQ0KDQoJLi4uDQoNCgl0ZHhf
c3lzX21ldGFkYXRhX2ZpZWxkX3JlYWQoTlVNX0NQVUlEX0NPTkZJRywgJm51bV9jcHVpZF9jb25m
aWcpOw0KDQoJdGR4X2luZm8gPSBremFsbG9jKGNhbGN1bGF0ZV90ZHhfaW5mb19zaXplKG51bV9j
cHVpZF9jb25maWcpLCAuLi4pOw0KDQoJdGR4X2luZm8tPm51bV9jcHVpZF9jb25maWcgPSBudW1f
Y3B1aWRfY29uZmlnOw0KDQoJLi4uDQoNCih5b3UgY2FuIGRvIGV4cGxpY2l0ICh1MTYpbnVtX2Nw
dWlkX2NvbmZpZyB0eXBlIGNhc3QgYWJvdmUgaWYgeW91IHdhbnQuKQ0KDQpXaXRoIHlvdXIgc3Vn
Z2VzdGlvbiwgaGVyZSBpcyB3aGF0IElzYWt1IGNhbiBkbzoNCg0KCXUxNiBudW1fY3B1aWRfY29u
ZmlnOw0KDQoJLi4uDQoNCgl0ZHhfc3lzX21ldGFkYXRhX3JlYWRfc2luZ2xlKE5VTV9DUFVJRF9D
T05GSUcsDQpzaXplb2YobnVtX2NwdWlkX2NvbmZpZyksDQoJCQkJJm51bV9jcHVpZF9jb25maWcp
Ow0KDQoJdGR4X2luZm8gPSBremFsbG9jKGNhbGN1bGF0ZV90ZHhfaW5mb19zaXplKG51bV9jcHVp
ZF9jb25maWcpLCAuLi4pOw0KDQoJdGR4X2luZm8tPm51bV9jcHVpZF9jb25maWcgPSBudW1fY3B1
aWRfY29uZmlnOw0KDQoJLi4uDQoNCkkgZG9uJ3Qgc2VlIGJpZyBkaWZmZXJlbmNlPw0KDQpPbmUg
ZXhhbXBsZSB0aGF0IHRoZSBjdXJyZW50IHRkeF9zeXNfbWV0YWRhdGFfZmllbGRfcmVhZCgpIGRv
ZXNuJ3QgcXVpdGUgZml0IGlzDQp5b3UgaGF2ZSBzb21ldGhpbmcgbGlrZSB0aGlzOg0KDQoJc3Ry
dWN0IHsNCgkJdTE2IHdoYXRldmVyOw0KCQkuLi4NCgl9IHN0Ow0KDQoJdGR4X3N5c19tZXRhZGF0
YV9maWVsZF9yZWFkKEZJRUxEX0lEX1dIQVRFVkVSLCAmc3Qud2hhdGV2ZXIpOw0KDQpCdXQgZm9y
IHRoaXMgdXNlIGNhc2UgeW91IGFyZSBub3Qgc3VwcG9zZWQgdG8gdXNlIHRkeF9zeXNfbWV0YWRh
dGFfZmllbGRfcmVhZCgpLA0KYnV0IHVzZSB0ZHhfc3lzX21ldGFkYXRhX3JlYWQoKSB3aGljaCBo
YXMgYSBtYXBwaW5nIHByb3ZpZGVkIGFueXdheS4NCg0KU28sIHdoaWxlIEkgZG9uJ3QgcXVpdGUg
b2JqZWN0IHlvdXIgcHJvcG9zYWwsIEkgZG9uJ3Qgc2VlIGl0IGJlaW5nIHF1aXRlDQpuZWNlc3Nh
cnkuDQoNCkknbGwgbGV0IG90aGVyIHBlb3BsZSB0byBoYXZlIGEgc2F5Lg0KDQoNCg==

