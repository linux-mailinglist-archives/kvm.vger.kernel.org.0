Return-Path: <kvm+bounces-11837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C126E87C4CC
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:40:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBD4B1C213AB
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E855768ED;
	Thu, 14 Mar 2024 21:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bu7qQGn6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F7733F9;
	Thu, 14 Mar 2024 21:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710452404; cv=fail; b=opQ9KcXXDAsdJ7AmIk5nwvS/nnq1ME+9UUUAw4GoGJ4KSuBDoXNHnQpvyCyyngONIetgoCkVf6CxR5a1KfCv4HakqazLnPQ816M6Eg9ajvgXnd7vUeJJtslFPPCFELDRJI+7d9Xw7r334YVTrDoPe5cTxWnHATpp8ZemD2DUxY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710452404; c=relaxed/simple;
	bh=2iKpOwY+VXa7triK5sBnW8LqDHSNnN+/KHprKUTasig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iCFoS5KI0YdXCnnNUZh0j3gfFRgN1ni3WkbRb+emse/xKVzHJ8evQRwILFSPjb1iNGI/35yLtJqxJzxfkCI6/3fl5yJiX3iX44l9gogaN4PZfVQqEzzG/NZIYb7PIqIz68dPl5cRQteNFT+HbMlSDdzdfiXKQ3fYr4myR2s7Skw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bu7qQGn6; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710452402; x=1741988402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2iKpOwY+VXa7triK5sBnW8LqDHSNnN+/KHprKUTasig=;
  b=Bu7qQGn6SNG5GxF5RRbEB5bO4GlS/ezEwg1VZ451A7MYVo+C87Gu2AGR
   /YGauehwHRSX/hEsYmz7SUkbFoO22Q6NJLsOqs4S7S+hSsHoLydr6pbb0
   jeKR+FPgZBDZQJ+SKEtCP7DXYtI9UAF/jF1Sbz79lKXLeiReH0S5+Z3r3
   y7CRGn0U6mCFiajIgyWWXZD1hT2KNpNB2KZnumkcJHpb01Wi7+c2VwINL
   adEA6a7bXGNyjDWfsVhkoqEdbskuMOU0DGTRj2/rSCNK1wTRfnyl+ycVZ
   l7WQLn9HMz2Nc7FLEHTP2VZZINheZB0cRC7019mzpUVSKENYwltHCgP0r
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5502924"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="5502924"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 14:39:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="17049184"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 14:39:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 14:39:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 14:39:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 14:39:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maZ46ojTtLeHyPnbGoe+BkOc7hdG+YPImvTixxdiCCfhdPto9C7w4nXfTW9Vox6wT3v7F2FJACgNk1z8sAZ/tOAwTn0v5rX6XgIfwVVu978zjEKo4dx7dhF1fCGRmgXkT7VWhlapowP0Omklr6n9ERQXLuQE5ybyDGs7jQj1Jp8g4W1PI6sbwHysiVJX5MUXD3/gQzGSmcb9ySbzOGh9zWCtQdvrqJd/N52Ce9dbCpCKUv56MIwbUBPiFN2SC37Gb7MHML1s8aQWWjwfjP4sy0eQFz6PY2x68xYYr52ybuJ3wHvsaum/odagjgSHXOhqzuIbOvaj4wuQQ9cyMo22dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2iKpOwY+VXa7triK5sBnW8LqDHSNnN+/KHprKUTasig=;
 b=Z69ilolqte0IMubx91eNFzS6UmvlWgRvl7NP/01wTJPJHd/BWUWe7RC8DMxarZiFi/OH663IqIZl8xA5ELFgBfavsQ8/WDB5y24CrhyLR2v402uiOgDYjiuPS0sCa/qf9xkcsX4tmy0RAiCWNkvsChsPGF36Xjiypjmeo2casUE94Gx5rU0pubqw4nDKP/JfrvZeGBUkeY9bplWzIL/FJ07TCMJlvuTWuDxBHsx53ATDY3Vg9fBU5ypZlSxve0HFQRjvvOtcH4d1gx/detmyNIJJRlBCCqOCQv5EZvt3AjvKIMEDVMGVYm0LkMO6caV2OCZjWPEtwG1jc8LdOTXXag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by CH3PR11MB7769.namprd11.prod.outlook.com (2603:10b6:610:123::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Thu, 14 Mar
 2024 21:39:34 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6%7]) with mapi id 15.20.7386.017; Thu, 14 Mar 2024
 21:39:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Thread-Topic: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Thread-Index: AQHadYhHvzdNxEnyc0eILiymig0CabE3ipcAgAA2FoCAAAR2gA==
Date: Thu, 14 Mar 2024 21:39:34 +0000
Message-ID: <ada65e3e977c8cde0044b7fa9de5f918e3b1b638.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
	 <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>
	 <20240314181000.GC1258280@ls.amr.corp.intel.com>
	 <bfde1328-2d1c-4b75-970f-69c74f3a74f9@intel.com>
In-Reply-To: <bfde1328-2d1c-4b75-970f-69c74f3a74f9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|CH3PR11MB7769:EE_
x-ms-office365-filtering-correlation-id: ee708e2a-8a2b-4d24-02d6-08dc446f3db1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MAprhaVgEacJpxJy6QU4j+vg14L11qaRSotZmhhkVqSnNniMbdeJCUcFXh/T+fsBRBQAmKW6jNWnyCGdjUel0nAyEu5YTC2I+iTx+tQ4hC+WOtMbz+5TjcGbPHDwxWkUwuMHuefNDOKiCy6AkFz2NJdbRTwIUonIbitJcpg+pDkPqimOJUcRY+bWx27gZrftYCHqo3s4ZzPpxct9r66CATCiWitopX3ZpDK1Ywl6FqTTPAXajEPHgX5lUSRrK7/rqbMMu8vj7O+f3zK34vcSrx2ioztoBrIWKvFKYaAoyHGLUc42oTv0/v+XkQmPXXrmOkJATkNrg7cW9/cuNtoPPg25TsWMhMZUUj9tBPfNWB/KuK87cf3pl8vlV58ssiQ5NH++e0Dn2HuAbh0kI3JKSWxEjFHUsIFbmlcGWZB3azCMwIdgv+E+ZWvGsfR7IOTKCsI5smholm3gBoiDrG028ypDs9d4rA6prM5ghTegD1dOt5DcRKpX2CLOkRrqb+KfyjPUvckKD1taHgDU0uTRctDUNEnVCHNW/dzMrzWI3OeXB2WAEeZrlJ+p6W3gh45nxP0sUss1KniQ6yKHrIaD3lZ0tywrWqQly8JgQJy8hBzVpP9wBI9dH8rkEBebQNtZ0bogSy9BRAkFy/rqaF0xT513VK2n9c7SxaM3+RQlO3SydSkwjRywDeGkArXDrtWw+fd1MXKQtuEO0DhzYG5x2Ls+uwIvw/EVPBgLOgNCQpE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3ZSNUM1RVJYTDN4SjFPRTVKaVByQU5ieWJTRUN4R3REL2pGRmQxVGVDQ0Rk?=
 =?utf-8?B?QzRuNkxwdlEyUjgzR05CN0I2L05uMzNpNmRHTW9wTXh4WjJJR3ZGY2dJVVZy?=
 =?utf-8?B?NlNBY0VBM2s0QnZTcVlHTTdxSGVjdkd2V0Q1OXpsQVMxZldKOEIyelFQQWll?=
 =?utf-8?B?S3l2L0hETDhWakh1RjVrVVJxV09zOWQzbEJ6TVUzeXlBTFpkWTQ4RUFLY2NQ?=
 =?utf-8?B?SE02M2RNcWErQlhqdjREV20vTUhQd29KVTlvQlBrNlc2ZUM0VE8yaDRTQmtv?=
 =?utf-8?B?Y0pBMkhBZkludkhMditkZUNvZHFZK0syZFBBK0tjTVEzTXBTVXhyYkZSdG1j?=
 =?utf-8?B?RXE3dThnYlpUZ1FIdjZwMXB4NjNrdGR4OVN0YTFTYUp3TEtzOW1kMlBCWFhG?=
 =?utf-8?B?U1lWUHRDUnhNQmk3NWxESlJES21yR3ZHbDBPK3lKZSt0ODhaL3QwUVYvekJn?=
 =?utf-8?B?ZWFPYW9SeUUxNkdQY2pjUHdHckx3ZDd3WEg3eG9qZ2FvQVR6Q3hUNVdFRFFN?=
 =?utf-8?B?WFg2a1lYZml2SmM2QzJkNWFtcEJpbjR3T2ZYWUdvRUppTFhMb3lrQ2c1cDNH?=
 =?utf-8?B?OHRXUEpMTlVQeHMrNk1kOG81ZmR4NVViYzVJZ01ETlY5bGZ2MnNKYjd1UXo2?=
 =?utf-8?B?dk9pY0NkVWFDSnNiUUk2UHgyQnViMlJNMXBrNml2dXZPOEpFajU4Z2hvR0Ft?=
 =?utf-8?B?SFNWRmRiQlBXUTc1dW1WZmd1ZktxaU9SQ0FmaStDYnMvRTZtK2RzNDFKeENh?=
 =?utf-8?B?MTY1UnJaT1dreXNSU3lUaU5iNnY5V053c3hBVUxqWUMvUGVackozWTBaVGMz?=
 =?utf-8?B?eFJLU1VxclNWc2ZaUzVjL3JLeXBRRXB6QzJxS1FDQjErTFEwa3FkWVBwd1dj?=
 =?utf-8?B?SjJCUldRbFg1WDRVeUQrcmdsZ2xMbnI2YWtxTGFoU0JlRVB1Um5NS0ZtUGdk?=
 =?utf-8?B?NGpjbDljRERVN1FGTEV3UFJjYTFxWlFGZ0pZZncxVFBCeStBQW1IVXUxVitz?=
 =?utf-8?B?RFI3bW5mQmhMNnZRaElKRUtNZ0VOVDlNLzNYaXVaeWc5QytPMWI1SWdNTkg5?=
 =?utf-8?B?K3VrSE1YcXlwSGdRTUNBMXZlRDltZFR2TGkvRkVHd3dISjhkOFJkcXpGL0or?=
 =?utf-8?B?Rk80YXQxN1NhKy9SYXhQMW5uRzRLSGZGSlN3QS9Gd1lBQ1haZVFhbFFDc3Qx?=
 =?utf-8?B?ZUlWbUVJejBtb1BIbENleURiWmFncjJReXlrQXQrNDV4QVQwNzNpeVg4NkdC?=
 =?utf-8?B?RmJOend5aW9UM0gwUU4wbmxWM0wzejJTMkZ5aXphSjRjRGllNEU5S0J1dUxB?=
 =?utf-8?B?QTdxMDdxYWNFUXdHR3JiQ1JSMnJxNkdHMVB2aUxKbUtqQ0o5RkhqWnEwUGQ0?=
 =?utf-8?B?NURTc3pyaWJyU2RyM1RGWTBjbFhoVVhsZ1Zib1UrNHBia0xmU3I2YUdtOUNP?=
 =?utf-8?B?Ny9nVk5LbGlWd1hyanZjQU5zajM1d1FJcFhUR2hxUWRmVlZsUVFzbVpEOGJW?=
 =?utf-8?B?TERTZFhIbTNuTlhNaU82RGxGQUxkZkJYbWtQKzMzZEMzeE1Wd2lURTBnSGpr?=
 =?utf-8?B?NFRqTldVdFB5OHpuVTM1N0MxOEJPZzFXenQ4S1lpZmRoT3F4TXNWQm43bGlz?=
 =?utf-8?B?Ym9zT3JvS3VOYTIxSlpJYklqSC95Vk5jYTlYZWp0anFEUDRqbDBwMWl0ZkNw?=
 =?utf-8?B?Y3d1SlhHY1hDSFlLMFFpTFBad01aVUYyanprZmREQWVlT0JoRkhjdFM3bUVJ?=
 =?utf-8?B?amdnTzVhUS9Jdm93WGErbHlIbDJBUy85RUYrZXlSUGg0dkZVVnJkbWgybEhn?=
 =?utf-8?B?c1VmS1B4TEZhc2dGd2xOakl1cnR6VVB5cG5DN1d1dGVLMlNNbWdQTWc0T1k5?=
 =?utf-8?B?RzRlZmprZGJKMGRGall4YWUwTGJIOGd6NHVUTzJ2MDAxaCs2Y3ZmRlBSc3ZJ?=
 =?utf-8?B?OUp3akRoTHRoOUpmeXNuU25qUFA4bWszNE1wRHNSaEJiMzQrNy9DNDlQelVl?=
 =?utf-8?B?YjNEZTlwd3QvSS90Rng4alkwb0F6RzNTMENRY01OL3EwVGhEQzlHZ3VzbzBT?=
 =?utf-8?B?Zm01alo1bVBlUTFqNjE0UFlrU0k5RG5DeHNsUk5EZmFlMTlQUkpVdEgrelVX?=
 =?utf-8?B?TWYzamVJTEUrT05NeVROdjdldjhrNmZkM3Vna3lMSjdmdVFYaVJWMFRqV1A0?=
 =?utf-8?Q?YBAXrHKzWHKEpbvu3+ry9uM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D567CD8EFE27E45BFF7B031BDD20A37@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee708e2a-8a2b-4d24-02d6-08dc446f3db1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2024 21:39:34.6431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlZJpnKWKfJpPKZvLkI7swzN1bOlLAsB3TvpWtpES1erjK5MboJ9zeiq8h7ASjWElzg0d2+Q6d7K65dfDhiq8Nx2hNjllQfV06bw8rfjFME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7769
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTE1IGF0IDEwOjIzICsxMzAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBX
ZSBoYXZlIDMgcGFnZSB0YWJsZXMgYXMgeW91IG1lbnRpb25lZDoNCj4gDQo+IFBUOiBwYWdlIHRh
YmxlDQo+IC0gU2hhcmVkIFBUIGlzIHZpc2libGUgdG8gS1ZNIGFuZCBpdCBpcyB1c2VkIGJ5IENQ
VS4NCj4gLSBQcml2YXRlIFBUIGlzIHVzZWQgYnkgQ1BVIGJ1dCBpdCBpcyBpbnZpc2libGUgdG8g
S1ZNLg0KPiAtIER1bW15IFBUIGlzIHZpc2libGUgdG8gS1ZNIGJ1dCBub3QgdXNlZCBieSBDUFUu
wqAgSXQgaXMgdXNlZCB0bw0KPiDCoMKgIHByb3BhZ2F0ZSBQVCBjaGFuZ2UgdG8gdGhlIGFjdHVh
bCBwcml2YXRlIFBUIHdoaWNoIGlzIHVzZWQgYnkgQ1BVLg0KPiANCj4gSWYgSSByZWNhbGwgY29y
cmVjdGx5LCB3ZSB1c2VkIHRvIGNhbGwgdGhlIGxhc3Qgb25lICJtaXJyb3JlZA0KPiAocHJpdmF0
ZSkgDQo+IHBhZ2UgdGFibGUiLg0KPiANCj4gSSBsb3N0IHRoZSB0cmFja2luZyB3aGVuIHdlIGNo
YW5nZWQgdG8gdXNlICJkdW1teSBwYWdlIHRhYmxlIiwgYnV0IGl0DQo+IHNlZW1zIHRvIG1lICJt
aXJyb3JlZCIgaXMgYmV0dGVyIHRoYW4gImR1bW15IiBiZWNhdXNlIHRoZSBsYXR0ZXINCj4gbWVh
bnMgDQo+IGl0IGlzIHVzZWxlc3MgYnV0IGluIGZhY3QgaXQgaXMgdXNlZCB0byBwcm9wYWdhdGUg
Y2hhbmdlcyB0byB0aGUgcmVhbA0KPiBwcml2YXRlIHBhZ2UgdGFibGUgdXNlZCBieSBoYXJkd2Fy
ZS4NCg0KTWlycm9yZWQgbWFrZXMgc2Vuc2UgdG8gbWUuIFNvIGxpa2U6DQoNClByaXZhdGUgLSBU
YWJsZSBhY3R1YWxseSBtYXBwaW5nIHByaXZhdGUgYWxpYXMsIGluIFREWCBtb2R1bGUNClNoYXJl
ZCAtIFNoYXJlZCBhbGlhcyB0YWJsZSwgdmlzaWJsZSBpbiBLVk0NCk1pcnJvciAtIE1pcnJvcmlu
ZyBwcml2YXRlLCB2aXNpYmxlIGluIEtWTQ0KDQo+IA0KPiBCdHcsIG9uZSBuaXQsIHBlcmhhcHM6
DQo+IA0KPiAiU2hhcmVkIFBUIGlzIHZpc2libGUgdG8gS1ZNIGFuZCBpdCBpcyB1c2VkIGJ5IENQ
VS4iIC0+ICJTaGFyZWQgUFQgaXMNCj4gdmlzaWJsZSB0byBLVk0gYW5kIGl0IGlzIHVzZWQgYnkg
Q1BVIGZvciBzaGFyZWQgbWFwcGluZ3MiLg0KPiANCj4gVG8gbWFrZSBpdCBtb3JlIGNsZWFyZXIg
aXQgaXMgdXNlZCBmb3IgInNoYXJlZCBtYXBwaW5ncyIuDQo+IA0KPiBCdXQgdGhpcyBtYXkgYmUg
dW5uZWNlc3NhcnkgdG8gb3RoZXJzLCBzbyB1cCB0byB5b3UuDQoNClllcCwgdGhpcyBzZWVtcyBj
bGVhcmVyLg0K

