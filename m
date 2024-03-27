Return-Path: <kvm+bounces-12793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F8F88DB59
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:38:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 698EE29E3CF
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE2B381AB;
	Wed, 27 Mar 2024 10:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PEYoA3uF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD1711184;
	Wed, 27 Mar 2024 10:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711535876; cv=fail; b=u/9mTl6pjgPabD23ECbUGxh130Xgk1G00GbKZYaaPsS4jcEIwVlD1NXGTep79SYBdePd3OrnT0KHAvEXc5wRcOyZkIIHbhlo0iVzdHbvW9+iIwxMl6QQMvvz8mGMrXoYRwAPJGeXkcuhc9Pv23rLkj2APUcXO0EJS9Deb/I/OUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711535876; c=relaxed/simple;
	bh=6lZF6SMzdhNraP2i3nLi22nAbUk5ztM6PjfgNbpf9dg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d5lKNGFFGfBOGWkcfLxDVHH2d1E6h+IwxDquIFKyP5s3K9bYzW4M2Qe3sX56HmVIcnISWDe45Iap0LD1liPgyfWNc5CjV78yaWVOgshvtbYKmp9yoa4JxRv3HioEhjwE/JUPVhgximfIzV8r2bx/N2vyikmXX9DLn4bbuwBWUUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PEYoA3uF; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711535874; x=1743071874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6lZF6SMzdhNraP2i3nLi22nAbUk5ztM6PjfgNbpf9dg=;
  b=PEYoA3uFf4D3jMimL4tRSShvJg6TjbjCkvYmXGz6K1XnsRNxcy7B3tEz
   pHIOODKIffhHAe5ieG0dAie+xdOkAaBBxOpGNLhvhMKMxk9wEU9l5ocAh
   JyyMspqYo7z1ax68yTIuaBxjEH0tVEZ8hDQggfC+Fz5d+8QnnWf0nOSKI
   qfKryzT5SQ7ULuHFjZgD6i89Y+BKiHJBHfICQwHezBRuwm61V2MjdGOIS
   YAG0m2orH4svqLP6PmPfj+kGnfsRY65oPK/5G4JantFNjc/cSRHBGFf0k
   77dbZXT/g+9Mmz6hAtCS0RI8Bbbzp7fDXlc/7wS6VjbLN9Qs69zRxI8Uo
   w==;
X-CSE-ConnectionGUID: i1XwirjBSj+N6pmRsZy27g==
X-CSE-MsgGUID: 43KRbX51RkSTu2tL2ft4IQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="24071979"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="24071979"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 03:37:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="20959868"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 03:37:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 03:37:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 03:37:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 03:37:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 03:37:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsCAGHLaLEvRtkWOTyiTtBdQhrl0cdrOhvkIZ2Gy7Fq4CydpI+TdMxAh+6ObjhPyuXo3+nMk3D4fnS65DPcH2SxEEaleS8drfj2Su8pShiKgVVlYlYDamoZp/z0dS2Cp+UW/c1Gl+i5E48OqKDR85yboyGxjGPdnN+2/rWg7CbdQWmdLv06d1Ek1CESVAsvB6l+5ioLeyl8GcBypf0HnhMDPHjRVKFELyFvzVMJsvJZ7IBWBC32FHgzPhTM0DpKBc8dzfxHrwFoOcIarP4lmokXtXIw6PFrbpq9gRI8dlRFlaIf/g22OC7Y5BzYgoCJ3YqL3YvURna4b+bmL+RGDWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lZF6SMzdhNraP2i3nLi22nAbUk5ztM6PjfgNbpf9dg=;
 b=N4btLKxi23hHoyf5VrqGV9HD0H44shuOcFyacnTv/1ooO+elGQLDEW3wE1BJzzAt7OCs3YjpJE3qG5Heh7s2FDaVAVMBpxni79naHGf5x1lNKb3F95/LheXUehLpi9NHhRk7RKckU+fjqL1Jyhzyki3oGZMOqfbIXGyCbcjBm5hL2jaIBjXk5f4cLlAhu35M3RZTTpmMQcY45YgDDBqi2FuRRr81DOv3xCaf/NZSdX8ywDoZ+7P+ymoGC23qQgl37xA+wu67YSU4EdNcvwVnyhbatn1lPSKQftdWTsZvqSY2iZEQxraeJs3mIxXKNr8JIUSCE17EuB3rf+c1os6NPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8521.namprd11.prod.outlook.com (2603:10b6:806:3ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 10:37:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 10:37:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 4/9] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
 asm/vmx.h
Thread-Topic: [PATCH v6 4/9] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
 asm/vmx.h
Thread-Index: AQHaccEVn6VN/MQaIEqpO+7ZmdCiNbFLghgA
Date: Wed, 27 Mar 2024 10:37:46 +0000
Message-ID: <0c8167f56b090641197436afa3d83fda9d88e650.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-5-seanjc@google.com>
In-Reply-To: <20240309012725.1409949-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB8521:EE_
x-ms-office365-filtering-correlation-id: 3e215d13-1908-4dcd-b280-08dc4e49f12c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QnHFWzL6vD5fVnwEKdSlO1GvHPSMW0INT/UPXzVtEl8jkMDx4JtUj85hvvczRwLzgSWSSTYphrqq9TDGoHs+x5yrDTFpxOFPgsPo3CCnDUccFZUNRbALA8ym6Fdr+hnKsWK3+hjFWmQxGKC7HfMi9zv0m3B9sTRrlsPVwp7bc805fLQKm29dVj9nclbR0sjroX/j/srKcXIFPfA0fxx9m3BTuu4DiDSsVF3+hpZN+iayKcaQqvy8PaKTeDJykgxKcu7yTHHqozznY2QsXh7ixUkYybMAI28TNRbm2/sXywWDD7Xme+lbGmJII2o6MbTq79/da++NWsY3LwVMmJFbSTc/huO0TzFAfbdMaqmfK/dcRnIsM0VtWVU6FdsSjJL6ovLZglbATraf/D3EIu/75QVxWWzViEGQlExsNIJaF0EkFkP9aS6K70hckClqBhk4LPd3Mh0IwJKDAGeaXPNAQPnYNBTUhirZa3OJOIu8C5T7rYTjGJwR/Bws9qUpBc2NBZO6tO4x1zYeCNzwUoaTqlvy9Sl9be7JCCb9KQKyb9NPtmL1Qs1iIv7GdPdCvkgbHLuHVOLoG9BqMd0a51Ry+X3rBURWcx5IcPyyq0MM0HzeqeScwdHycg3Qhxhu/GPM558TpbWHV3D5A12ZMkD6iL3ZPvq8fpoZv3cXORyRqURGA11Bx3Zehx+TB4efqRrZdhpgosCLs89laLgZhmqAjvQ3kkXd9FNVodTJUhesjK8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WElFaStIQlVkeElSUWk3Q1UwTEp4YWN3cEorZTJ4UlloRFhDa0Z0ZE9TQmo4?=
 =?utf-8?B?aEJ1ZzkreVZpelM1b09TWjFFaURucFpNcXhRY21LazZDY2plam1OL2JsYUt6?=
 =?utf-8?B?T3RmR3BndnRDSzFDcitWOCtHRFdVWkRtdmNMSjBzeC9sM2dlU2hXaW9yU2V1?=
 =?utf-8?B?NFhiaFE0OFl3dE1GRTY0Z1VOWlRVY25YVi9sanZYNitWbmZRcVpPelFRZEJu?=
 =?utf-8?B?WVkxK1pQS092Tkg1dTJRYzhPTnJQdmgxUGRtdnRJb0tTdzk1a05keVZpTVJp?=
 =?utf-8?B?b0VjbmpNZitoam5uSi8zbUJoSjJhTVBIL1pleC9HMExvTktKMkx1YW1VM1Bv?=
 =?utf-8?B?MUwvNWxqcW5Jc2NaeEt0N05BM3dOMWYrSXQxYkxlT2xZTDRuTXBuRkNDSFFF?=
 =?utf-8?B?bXJZbDlXS2NNZE92N3FTNkN0NkwvMC8vWXRZYmRsM3k0eFdodTVDQmRWeWw0?=
 =?utf-8?B?Y2VBRGpXSDgrY01oaGEwc0FkbllINmFuV2dwdlZtSzFxT1daaHVJT2VpS3lD?=
 =?utf-8?B?MmtHRkhhRTVJTlpkTWk3a0xIYWh3VzlUa2x6MmcxMmFnWm9iV3NOamo4dEhz?=
 =?utf-8?B?dUpCcTZBbDAySVREUVgrVERDM2gzZ2RWb2FzRnpyWFpqek5JY2lFaGNxWWYy?=
 =?utf-8?B?OVFNKytZcjIrZ3B6U3haM3NnN3l4YUh0OVdRc2dGVFVRK2JDZUF6UUxsd1hK?=
 =?utf-8?B?QVRHWThyd3A0NXh3UzhQTEpzc2xqeDFRc2lsanB0ZEpIYnFMODNhRmQ1Nkp5?=
 =?utf-8?B?UGJuOHFSKzdBcWQ2N0ROSGg4Q3VPTTlNdlRXRWF3bmRoMjdObG4yTTZEeHVJ?=
 =?utf-8?B?eFlZNTJxd3hjSlZncVI2c0puMDZGYmp2QjM5dk5hMGk4TUo1Z3EwcnZ3bndE?=
 =?utf-8?B?T25tcVZNNlNiY1ZLTnFGMjJXblhCWWgzbElSZnZtS1RhTk9hZWdJeVpzanYz?=
 =?utf-8?B?NW5wM2JHMnQrRXVibUtxakxDM0pCM3FmMVFsemxXOEVVYlFRRzBVSTVIQnVN?=
 =?utf-8?B?ZXZKVU1aYjE4ZzBQRmZGVitYMkRYdGN1enh5V1NGdVZzbGg2bmNldXpRV1Za?=
 =?utf-8?B?SG9sUE1wMFRDY052bGRNUklnU3pERnIxN0JFaHFaV01mNWVqZ3Ntc1NNMUxE?=
 =?utf-8?B?TlhPNHVvZU9oZ0xLSzhvVHA4S2M4elh6dllxWVBRN2NEZHdPc0NyTXZMODZ5?=
 =?utf-8?B?RCs4WGV2MU91WjZpMnZQbi8xTXBFZllpcjlUTE5lUncrcGxGanBwT2Z1Y0Ex?=
 =?utf-8?B?Rk9mYUNZR3h6WHphc0tDMGlCRm5GU081anR3bDdhdjR3dDA4WG02OXhmTXY4?=
 =?utf-8?B?bWpza0k4cHFNWWJUaEtwUVp2RGxyNmJPNmtDelpJbFMxeFcwaEFOMit4UWpY?=
 =?utf-8?B?YU1nQzZjdUlnNHdIM0RyYXZnVWdWOGFWbWRZUS9zRnZyQjlUemJGMDgvOUFF?=
 =?utf-8?B?L3V4SGxadmx5Z2wzVklWZkRHT0tHQjhKRHR0VzlNa0ZWV2c0RnBLZUozeVpF?=
 =?utf-8?B?VGdEOU9RTkdCZEMxMHdsU3pSY0REVVJra0dMN0pOc1BHcHJnbWxGR0J0d1ZO?=
 =?utf-8?B?ay9TWGhiOG5wNUZ4RzQ5YW0vdzdkdUt3dU1DN2pxRURCT0pPdjB6aWtqdW14?=
 =?utf-8?B?NUZSWUZSQnArTTB3ellXWlQ4WjBFajYwUi83dUVNSGhNQXU4QlNsbmpYcmty?=
 =?utf-8?B?L1pGQndvck1OazJjaFp3TUJhMFlQRE16TDhGeGI3STVuN2ZGZTg2K0NwT0VE?=
 =?utf-8?B?TlYzaHhyQ2RPd01rc084OXl2WWUzUDBPaWJoRm9kcnVRZ3dNd20ra2dleE01?=
 =?utf-8?B?MjlhVkZUNGtXN0JnN2Z2L2JkTjlZMkVyaUsxc0ZaSUcrN1IwN2VjeXJUZDY2?=
 =?utf-8?B?SzZrTG55Q2xaMmFCN054ZTVWemdmMldxWVdGYk5YamlFTVlYVnZYZWJtRmtp?=
 =?utf-8?B?a2s0YzRjZGd6MldpM2VDMnNlR1pyOXVDaytoTGhPZXVqTHVHTGd5cFVRTEI2?=
 =?utf-8?B?eldPQmMxd3JlNlZBRVNBV1p5Z2NiWjBsaERQd0lBYXViZG1xWUJ1cGViWDZi?=
 =?utf-8?B?RUYveHRyblJGNFZKaHVQMFFFM3h0Y3k4SERWcVZFMWMweDJkYnM5c0dIbjhW?=
 =?utf-8?B?QWo2YVUzRVV2VjNIaStCclhOVm5UUG80TlA4SDhhOG96djFMRXlKYS8xaDlB?=
 =?utf-8?B?a0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <801EA8328B54804EB2FF7A1FFD5B6FE5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e215d13-1908-4dcd-b280-08dc4e49f12c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 10:37:46.5014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qhD77ZsR5njv97dX8cyhxmfv7FSbHKpoIgdCm4K4Qnnl62g7LTJDxIxl1haN1sT0Zwtsp3e2ZlilmZvd37u1EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8521
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE3OjI3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBYaW4gTGkgPHhpbjMubGlAaW50ZWwuY29tPg0KPiANCj4gTW92ZSB0aGUg
Yml0IGRlZmluZXMgZm9yIE1TUl9JQTMyX1ZNWF9CQVNJQyBmcm9tIG1zci1pbmRleC5oIHRvIHZt
eC5oIHNvDQo+IHRoYXQgdGhleSBhcmUgY29sb2NhdGVkIHdpdGggb3RoZXIgVk1YIE1TUiBiaXQg
ZGVmaW5lcywgYW5kIHdpdGggdGhlDQo+IGhlbHBlcnMgdGhhdCBleHRyYWN0IHNwZWNpZmljIGlu
Zm9ybWF0aW9uIGZyb20gYW4gTVNSX0lBMzJfVk1YX0JBU0lDIHZhbHVlLg0KPiANCj4gT3Bwb3J0
dW5pc3RpY2FsbHkgdXNlIEJJVF9VTEwoKSBpbnN0ZWFkIG9mIG9wZW4gY29kaW5nIGhleCB2YWx1
ZXMuDQo+IA0KPiBPcHBvcnR1bmlzdGljYWxseSByZW5hbWUgVk1YX0JBU0lDXzY0IHRvIFZNWF9C
QVNJQ18zMkJJVF9QSFlTX0FERFJfT05MWSwNCj4gYXMgIlZNWF9CQVNJQ182NCIgaXMgd2lkbHkg
bWlzbGVhZGluZy4gIFRoZSBmbGFnIGVudW1lcmF0ZXMgdGhhdCBhZGRyZXNzZXMNCj4gYXJlIGxp
bWl0ZWQgdG8gMzIgYml0cywgbm90IHRoYXQgNjQtYml0IGFkZHJlc3NlcyBhcmUgYWxsb3dlZC4N
Cj4gDQo+IENjOiBTaGFuIEthbmcgPHNoYW4ua2FuZ0BpbnRlbC5jb20+DQo+IENjOiBLYWkgSHVh
bmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFhpbiBMaSA8eGluMy5s
aUBpbnRlbC5jb20+DQo+IFtzZWFuOiBzcGxpdCB0byBzZXBhcmF0ZSBwYXRjaCwgd3JpdGUgY2hh
bmdlbG9nXQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbT4NCj4gDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5j
b20+DQo=

