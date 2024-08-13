Return-Path: <kvm+bounces-24012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CE695084E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:59:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CDB71F217A4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF15919F479;
	Tue, 13 Aug 2024 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jELnpK1r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D23D19E802
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723561146; cv=fail; b=FQj8JbeEzKjEuK7RbN8C8lIsPVujXUngxWO/gNElPBqYcanaggENFMikY+bOYwyiUmfIhIN/Nm3U5mTW9jx4GFfNgXmquly2J0MLPXZGnJhY1cNfCINnAmJz9B55hpoBdi9HdXS8ctgFDYSFxZAto4S9WCAaOBypG6Jz3VQvlYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723561146; c=relaxed/simple;
	bh=q1kC3BIsXJ+MIsBMlA1Q44AnaiI88EpLQl1IMg5Pr1E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FteclS3/1NGWL4BXK4pb8EsSaS+XBZDPhIclPiGTrzCc+QcmyKoUwDVI2MhrYwcFoZcAx9butBh9fX5XDngqDxrFwM0NE8BNz0W3//rVcTxBd4PFkGcjcnaltT91mUyivaoyayvPso/OOCvapPEtOE60A29uri1+Y6qrQpu0jtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jELnpK1r; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723561144; x=1755097144;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=q1kC3BIsXJ+MIsBMlA1Q44AnaiI88EpLQl1IMg5Pr1E=;
  b=jELnpK1r8JUBCwex3by2Einkq6MaeMSukc01fVDRTHsd+Z+16pLdF4cn
   QDCDjjWfpBhpWJXSTg650mOChJBzW90i71/NGon2EKkJGAj7tc/dLG7W/
   Ga/TiyGrH+IWBJ/9Gr3svW576SDW2EipgRbxhsKU2LXOt2Rn4Bll4KmU8
   Arxy9hxOfBz86M8MTyfTjSZMGdTPoe57mAk2Xypp/Am5p3L3vNBZQT6XD
   dTtNWJtcapdwMEXKdZqdGqpafYAsTKzWyaO3NF3n9A5WLP1ueys6YjuNH
   KqHaI7hYSW69Jv+XG5Cj7ihs3kQBK8KRnGg6hNiSo1TJyfqcDAm1aVHSe
   Q==;
X-CSE-ConnectionGUID: DOWIP43wQROrGhaIPBJ8yA==
X-CSE-MsgGUID: qIOfCshXQ8mBa+T8TQawMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21861775"
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="21861775"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 07:58:56 -0700
X-CSE-ConnectionGUID: jFHgvVv/SsSEkE1xr1no0Q==
X-CSE-MsgGUID: PeeZeZ9BR1Of7LKJo+K9ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="62841777"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 07:58:55 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 07:58:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 07:58:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 07:58:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wi5uV/+J972Sl+REniYm6Gh/f3cj248Mu2xMGr5qCvPWzDvaKbOcqo0dyVhMVy7xnUGAXQ6Vyl56vFy3r34l1yGNCeZPn5HhktTUnS91oVYGdxhXrfP78xUH9obqECs1/jrm5T8X09+/WflEZTWtePQ6F3PCOWPDupHOnAOqVdaWG8YZQB5QhFIsESDo1FOVCZVaXCluvCCLryjexb/EwZKGnljfWuMOBnlpE9qgHQ2NrcUDKw4mPXZNh2mbobJMVAwSKOb7xJVavZqS1gFg51EpAy+/68QNmHXGRMWMCM8OAek4Rg6S8MIQ6x0IFqIJXi11a8gGNPqyM4i64MAaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1kC3BIsXJ+MIsBMlA1Q44AnaiI88EpLQl1IMg5Pr1E=;
 b=P2/bnAzcgsHNekNX4OvOLBhss2xcILaniaoFaXojJKO6sl33uLTPBznxdjEVprLvxIohjo5Pa7Yyg8PVIHnPNZNlsQYMx3V3OJOpyU2xUfjk7mwDxDOTtNT290WuAXEIvLPzdn6ThZAsgAPa/gra262wKF6jbhnveedjoMg97RxoQ+b2BswQHw+di4m9mmsPzjCe3YSWh1qzWybn+7qjLw+ZFco2p1fi2YVURIeUQSetGg6lFaIABYbw7IMfKHn0fcfFu8wOg3B0fKKxT7+Hw5Zoo37iNlnBGbqY1I0yvRHcsbrOpj0c8JJuPjCkfYnNxabCz3boFse5CQTh9rSc4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6782.namprd11.prod.outlook.com (2603:10b6:806:25e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33; Tue, 13 Aug
 2024 14:58:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 14:58:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Li,
 Rongqing" <lirongqing@baidu.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "mikelley@microsoft.com"
	<mikelley@microsoft.com>
Subject: Re: [PATCH][v1] x86/kvm: Fix the decrypted pages free in kvmclock
Thread-Topic: [PATCH][v1] x86/kvm: Fix the decrypted pages free in kvmclock
Thread-Index: AQHa7T3Lf5fjA+ROmE6L8k4RGzcLALIlSB+A
Date: Tue, 13 Aug 2024 14:58:49 +0000
Message-ID: <b0290543ac375b0f72195c0d54100ff25399b4f6.camel@intel.com>
References: <20240612111201.18012-1-lirongqing@baidu.com>
	 <ZrroWLvQ_0zXMRhg@google.com>
In-Reply-To: <ZrroWLvQ_0zXMRhg@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6782:EE_
x-ms-office365-filtering-correlation-id: 4f1f32f6-e2ff-4b8b-97f7-08dcbba870c5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?REpnaGx5Y0J5RGVZMU5CRURhWUl6QWpuTkIrWE80Wjh3dnZtMjUrR1RTSnpv?=
 =?utf-8?B?bFdVL3EwcWtQOFhKUEM2RVZ4NjNkRTE5K2hxbzZpaFZsaUdTWWdZT3VvTWNn?=
 =?utf-8?B?Y0pEckFnbXRjVXhoS3lTb0EwR09tYmtoa1VKMlQreVNaWTJzREh0cEZnSlNW?=
 =?utf-8?B?dE0zRGgwNCtIYnhtVzlXNWgwbnNQMnNzUE1kZTR5blovVGg1ZS9rbmFlQ1Nk?=
 =?utf-8?B?blRXK1FER3UrdlRsR2NSQUVUZmVaQzdwR0FxNTlpZDh3SThZcmVqMWdLR1RJ?=
 =?utf-8?B?WmE3NTY3MHJXREE5NzZLU2Z0c25GZkhCZVBRTkZpZEMveUtKNm9QNy9vSTVy?=
 =?utf-8?B?dDZPc2lTZFZyNUFOaWkxRDJUS0pVSUlaMHZtT1VHazl4VEx4b0x5dVF0Ulp3?=
 =?utf-8?B?WVNSV3hBd1YzaWVHbC9Kb0dOR2NZU3FoSVN6M0QvUHJUQjgvS3dKTzJ5YndJ?=
 =?utf-8?B?K3pUSFNocUJIQ3hzamRBK3cxVVBJUVZ1Y3c0b2RHcW5Kb1RxdDMveWJjakJR?=
 =?utf-8?B?UXJvczlOREx1SFF4VktjWE1JTlhFQ0xuNHNscTVBSjFuR0pvQjhaQ2Y0VHQ2?=
 =?utf-8?B?K0JETDFLd2xnSFBUR0ZkcTMzRG9vekdYZFlTRmdhVXdkUTlGc0paOGtRYnVr?=
 =?utf-8?B?WlJLNzJmZjV3RFkvNTBjNms3WHJZYnZXREFCK05MV3VHaDVlNlJrT1FIQjdw?=
 =?utf-8?B?WGdMKy82b1FkTTVYUE5PWFRrUE5uVytETm1IbUIxRElKcm42STRvdGhaUGpG?=
 =?utf-8?B?ckgzTE1ISXNzNXhwTHc1Z0FJT2RITE83MjJ6aWNWdzA4RldoRExCZEVhdlpn?=
 =?utf-8?B?ZFhuZnRpTjJkc3NCWGZ3OUxid2Mzc2ZmWUFBUXpnUDhtUFoxOFFrUjVkWmFl?=
 =?utf-8?B?N1U3eVVEMXEzZUZReDFWb0piQlNWeEFJRk5VdWFNd0s0enJUOUxTOVI5SWZB?=
 =?utf-8?B?NWptU0xRaHU5bXA1eWdpMnJjemVMMEwrRHdiY0JzMHp1QnFscDNPVzVNSGhu?=
 =?utf-8?B?WFdnL3k4KzE5djhMcU54RHBFeTltT29kUG9DMjVGZFoxWE8rMUVJejI4OXZr?=
 =?utf-8?B?dWRqRi91bldmN1hQeXhPMzE4MWtJRnB5dTU1NGNXcG9hL3djTXF2ak1nWGNO?=
 =?utf-8?B?alpPVFNCWXRLU3hKNG1saXgzRjBmak4wUm9udXRyc1lsOVNIUDRTenRmT0hE?=
 =?utf-8?B?dWJCaU5nZjJ4TkwrVzBQQktDMGp6QUFKR2x4S0FBSmNQUXl1NkF6dWlGQXRO?=
 =?utf-8?B?Y0JPQTd4ODFpcTlhRXkxelNBSWF0b1dSMXpkZm9CZlUzTDdDUjBkTGxjV015?=
 =?utf-8?B?aTh3TUpZZXJ6MlU2T3pEZ2M2TkNSQlNHZXdkcW8vMCtPNHBQOXA1a3krZHN0?=
 =?utf-8?B?SFo5Uyt6ZGZXLzdVdlUwYTdzV0FqcnQ0bVZGdjJVRFBWU25hNTZ1aWxkM1BT?=
 =?utf-8?B?aTFkUFdkS3hpYy82NnVTNE5NTXRhTWhlREJZbzJkOEtzTHM2MzBkdEJsMVVB?=
 =?utf-8?B?VnJVR2pjMHlxZVBjd083NncrNi9aeEZEcCtpRFU1SUFpSlBGT1h2Y0xpNlJI?=
 =?utf-8?B?OUdKZ3NWem1UNmZFMG1uOUhvWTlpOUhLcTRFcnBpY0VMSGNGSXNFM0dtamo4?=
 =?utf-8?B?TWk2YVFQMG1tZkxJeTJUdi9WMWFnWVhmVFNCZmp5N1oxejBhRFFvbU5GcHg5?=
 =?utf-8?B?ZVZ4YjZjWXgybXlaUHVoelorZ3FwSU51cjA0UlIxLzhrK0RtTEhIcE41bnU1?=
 =?utf-8?B?VHNWK1M0bDRSem5EQW1Na0dPMjJ4NVgwUGdnc0RDeTdCdm05M0s3bjdJY1FK?=
 =?utf-8?Q?xaE5mSecXL8HMxHuoHPLbSfz9yAKDtuM9VQtI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWh5clA3em4wbDAvdEtjQi95bC9IU0RIYmUzZjl6R0dGNjdYVXIydXhpY0NQ?=
 =?utf-8?B?YWRXdXdiN21XRmRhNnV1TEc1eHNSYXR2ZGZWRXRDUzg5MmFRQ2txcGxqbnVB?=
 =?utf-8?B?NUkySEN1MDgzSllQMjVMMHpkTWZ5TFJpRDZ2RHRjeFNOcUZoazdUdEs1YnNP?=
 =?utf-8?B?ZW5ab0EwZU1wMHJsZkUwZFIxYW93VlM4ZzZvV0RuQ2x0T0k0U2FrWjlaVGZJ?=
 =?utf-8?B?ZHQrRDRGbUFGUHAwVTB3UlhKUXAwQWxOa09hRWVNS2IyVjg2OW0ySWdVTjBo?=
 =?utf-8?B?eWNEUjhQZlhBSlpmNlBHVWJQOTFqblBSclZwNGZyNkZxYmVLNFNVc1gwZk1j?=
 =?utf-8?B?K2tDR0ZQcjBSVEpZakR0M1MwaG9YeDJLQjFXOFQzVDB6cms0NktmQ2RwWU9J?=
 =?utf-8?B?bXFFcnpJOVViaHg5WEJzcmdrb29KbW9hVTBQSlhDTnUxOFZFbjZTVmhDN1hJ?=
 =?utf-8?B?dWRwdDRmay9aTE45SzNhK2Y3eDN3ZnVUajNWYmExbnBBNnQxV0tmWUk0cFZm?=
 =?utf-8?B?TWRDbm9ya2p0bjV4TmdJQjJBY2tJbW5INXVkMnBKVktidVFKOTE0MmhKWHFk?=
 =?utf-8?B?WnA5Vk1WMXAycjdjLzlHYzF3ZlhKRTdpdDlFTENlRUQrV3U1V3lwN09oR2pp?=
 =?utf-8?B?c1dEYU1kVHBQRVNYVnFiY2tGci80NGpsRE9nNUgrRUVGMDRwakFiYlNrRFNM?=
 =?utf-8?B?bUF1ck1pNkoydFdmR0JYTHY2RVFIUGtCdmQvZ21ndE55VHkyN0psQW42dHY5?=
 =?utf-8?B?eXcrbytKZXo3WWgvZnRZYnJPcFY2VnAxSmNHSWpRdENxVXNzVE5ZaS8rckxz?=
 =?utf-8?B?MiszeXlaZ3c4V3d4ZjFlQWFncU5oaC9HbmRTMXB0TU9pSE9Cd0FtN0RoWmF1?=
 =?utf-8?B?bm1aVGxhZFh2Z0NrLzN3MVQxdU5ITTQrTlA1a1VGQUVhaGlRQ3QrUktvRWxN?=
 =?utf-8?B?akVhZDFBQmVCUkovSkRlTlh1V2lqclc4S1l1eWRwY0x2WCtQZ2FkS0Zmbm5L?=
 =?utf-8?B?MHNBZHBRL09FLzZ5cEM5Vnd1KzlxYjNCTVk5Y09CUmVEbGltYXlFRHVZdWV4?=
 =?utf-8?B?Ym1LeXZ3L3d5RDlrSzJzRHZ4OG1YV2llT0N6VUZuRFlrWThabVorL1VyZWhY?=
 =?utf-8?B?YS9pUkRlSGVtajdmYW9VcG1kN1dPeVVkV2FUeTU0ZVBMN01pWXdkcXNhS1Bq?=
 =?utf-8?B?WXU5M3lEU0FwNXhoWmNDcnllYk5HK1ZkaGRmZVUrREJ5V0hPQm1hdkpmNjVO?=
 =?utf-8?B?cCswREtLdExlckRLU0V6VEVHY2FndDRBMXZnK2xvcWgxN2dWalpiVEIrb0c3?=
 =?utf-8?B?NGtLc3dRbkZaSFVhWVM3RFpkNExCK1h3a0s3OWJqeFV1c2xjUEdEL0JlWjVs?=
 =?utf-8?B?NUdDZHpnQThLc3AxY210U3pWQWFxcHVxRWdsOVVsZ1hxMUd2OGMwK1dXbDdP?=
 =?utf-8?B?aTV0L2lOcEMyUmJvNjEvTmRzNXNhSjVtNkRlUkdvTHVzY1l4NXNoWlkzMGlt?=
 =?utf-8?B?dVkxamVTa1lCeGM4cnpRM3pKUjlhMmh6aEN3b3V1UHV1ZHdzaVBXNXVsbGpk?=
 =?utf-8?B?d05YSWFEYnVyVnhtcFdPbmxHNkNxcXJDNWdrTVIxUVZyTUtDLzlJQk84VVFx?=
 =?utf-8?B?NlpGNWVpWmdtWk1ncHlZaEJpTHVRbFhyUUVIWmtCRUtETDdhaHZ2aDUwaG13?=
 =?utf-8?B?eTVDMnRTeG1OT0c1VDJyZjFYNHN2WmU0ZlVEZmFYZkZtM215RTA5bUYvZ2xM?=
 =?utf-8?B?NnQ1enlxZ1hTYUllK1FzUGpMeUhOcEpOQXFmK1VxZzhKZ3Q3dGd1dlUxdjdZ?=
 =?utf-8?B?dEdrY09ocElWaDRBd3dZdE9SSDFTcUFOUllmZW50bDg0aUZnVDRnVXJDeTNC?=
 =?utf-8?B?dWpaNnEvL3RsUWlNeURCSDF0Q3JBRXpGNXJLRXkwdVErRi80ekNpQW9pdmJL?=
 =?utf-8?B?ZS8zNE5CRkloYXQ1L3RtQTkrcjJCc29DcGY0ZWNRWUNndlIxMmJBY2U4c2NC?=
 =?utf-8?B?SGw4NEpyZUZ3RTlHdWJRUkpuOVIwZngwbEpoOE9vVlIvNFQvNWlhN3ljcXZP?=
 =?utf-8?B?UXZUVEh0MGkwU29YNm9ERDRwbkJEaTFxSllJMHFYUS9GbnFPMHgxOGNGV0l0?=
 =?utf-8?B?QVY2VTdJUVpMbDBWNm45RUZWNVR6ZGZFbE1EWDFLZWJHTkVwUmlrblhBUFlN?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D34295EA3A4494BA16AB9A9AEF8EB17@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f1f32f6-e2ff-4b8b-97f7-08dcbba870c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 14:58:50.0135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R1Shk4lagmDVWOcmMgjEUrQV+TFNhClhZoAfjb6inTrX/EFFxSBI4hUZDrBblm8he87s3tvsCSeRwGMtb5hxCZOC1v3d0JW/mtVuzPzMYVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6782
X-OriginatorOrg: intel.com

K0RhbiwgRWxlbmENCg0KT24gTW9uLCAyMDI0LTA4LTEyIGF0IDIyOjAwIC0wNzAwLCBTZWFuIENo
cmlzdG9waGVyc29uIHdyb3RlOg0KPiArbW9yZSB4ODYgZm9sa3MNCj4gDQo+IE9uIFdlZCwgSnVu
IDEyLCAyMDI0LCBMaSBSb25nUWluZyB3cm90ZToNCj4gPiBXaGVuIHNldF9tZW1vcnlfZGVjcnlw
dGVkKCkgZmFpbHMsIHBhZ2VzIG1heSBiZSBsZWZ0IGZ1bGx5IG9yIHBhcnRpYWxseQ0KPiA+IGRl
Y3J5cHRlZC4gYmVmb3JlIGZyZWUgdGhlIHBhZ2VzIHRvIHJldHVybiBwb29sLCBpdCBzaG91bGQg
YmUgZW5jcnlwdGVkDQo+ID4gdmlhIHNldF9tZW1vcnlfZW5jcnlwdGVkKCksIG9yIGVsc2UgdGhp
cyBjb3VsZCBsZWFkIHRvIGZ1bmN0aW9uYWwgb3INCj4gPiBzZWN1cml0eSBpc3N1ZXMsIGlmIGVu
Y3J5cHRpbmcgdGhlIHBhZ2VzIGZhaWxzLCBsZWFrIHRoZSBwYWdlcw0KPiANCj4gVGhhdCBzZWVt
cyBsaWtlIGEgbWFqb3IgZmxhdyBpbiB0aGUgQVBJLCBpLmUuIG5vdCBzb21ldGhpbmcgdGhhdCBz
aG91bGQgYmUNCj4gImZpeGVkIg0KPiBpbiBrdm1jbG9jaywgZXNwZWNpYWxseSBzaW5jZSB0aGUg
dm1tX2ZhaWwgcGF0aHMgb25seSBXQVJOLg0KPiANCj4gQ29tbWl0IDgyYWNlMTg1MDE3ZiAoIng4
Ni9tbS9jcGE6IFdhcm4gZm9yIHNldF9tZW1vcnlfWFhjcnlwdGVkKCkgVk1NIGZhaWxzIikNCj4g
c2F5cyB0aGUgcmVhc29uIGZvciBvbmx5IHdhcm5pbmcgaXMgdG8gYmUgYWJsZSB0byBwbGF5IG5p
Y2Ugd2l0aCBib3RoIHNlY3VyaXR5DQo+IGFuZCB1cHRpbWU6DQo+IA0KPiDCoMKgwqAgU3VjaCBj
b252ZXJzaW9uIGVycm9ycyBtYXkgaGVyYWxkIGZ1dHVyZSBzeXN0ZW0gaW5zdGFiaWxpdHksIGJ1
dCBhcmUNCj4gwqDCoMKgIHRlbXBvcmFyaWx5IHN1cnZpdmFibGUgd2l0aCBwcm9wZXIgaGFuZGxp
bmcgaW4gdGhlIGNhbGxlci4gVGhlIGtlcm5lbA0KPiDCoMKgwqAgdHJhZGl0aW9uYWxseSBtYWtl
cyBldmVyeSBlZmZvcnQgdG8ga2VlcCBydW5uaW5nLCBidXQgaXQgaXMgZXhwZWN0ZWQgdGhhdA0K
PiDCoMKgwqAgc29tZSBjb2NvIGd1ZXN0cyBtYXkgcHJlZmVyIHRvIHBsYXkgaXQgc2FmZSBzZWN1
cml0eS13aXNlLCBhbmQgcGFuaWMgaW4NCj4gwqDCoMKgIHRoaXMgY2FzZS4NCj4gDQo+IEJ1dCBw
dW50aW5nIHRoZSBpc3N1ZSB0byB0aGUgY2FsbGVyIGRvZXNuJ3QgaGVscCB3aXRoIHRoYXQsIGl0
IGp1c3QgbWFrZXMgaXQNCj4gYWxsDQo+IHRvbyBlYXN5IHRvIGludHJvZHVjZSBzZWN1cml0eSBi
dWdzLsKgIFdvdWxkbid0IGl0IGJlIGJldHRlciB0byBkbyBzb21ldGhpbmcNCj4gYWxvbmcNCj4g
dGhlIGxpbmVzIG9mIENPTkZJR19CVUdfT05fREFUQV9DT1JSVVBUSU9OICh0aG91Z2ggbWF5YmUg
cnVudGltZQ0KPiBjb25maWd1cmFibGU/KQ0KPiBhbmQgbGV0IHRoZSBlbmQgdXNlciBleHBsaWNp
dGx5IGRlY2lkZSB3aGF0IHRvIGRvPw0KDQpZZXMsIHRoaXMgaXMgbGlrZSB3aGF0IEkgdHJpZWQg
dG8gZG8gZmlyc3QsIGJ1dCB0aGVyZSB3YXMgY29uY2VybiBvdmVyIGNyYXNoaW5nDQpvdmVyIGxh
emluZXNzIHdoZW4gdGhlIGtlcm5lbCAqY291bGQqIGhhbmRsZSB0aGUgZXJyb3IuIEkgYWdyZWUg
dGhhdCBpdCBpcyBlcnJvcg0KcHJvbmUgdG8gcmVseSBvbiB0aGUgY2FsbGVycyB0byBkbyBpdC4g
QnV0IHRoZXJlIGlzIGEgc3Ryb25nIHJlc2lzdGFuY2UgdG8NCmNyYXNoaW5nIHRoZSBrZXJuZWwg
YW1vbmcgc29tZSBmb2xrcywgZXZlbiBmb3IgaGFyZGVuaW5nIHJlYXNvbnMuIHBhbmljX29uX3dh
cm4NCnNlZW1zIHRvIGJlIHRoZSBvbmx5IGdlbmVyYWxseSBhZ3JlZWQgd2F5LiBUaGVyZSBpcyBh
bHNvIHRoZSBwcm9ibGVtIHRoYXQNCnNldF9tZW1vcnkoKSBlcnJvcnMgYXJlIGh5cG90aGV0aWNh
bGx5IHBvc3NpYmxlIGZvciBlbnRpcmVseSBndWVzdCByZWFzb25zLiBUaGUNCmZ1bmN0aW9uIHJl
dHVybnMgYW4gZXJyb3IgY29kZSBhbmQgc2V0X21lbW9yeSgpIGNhbGxzIGRvbid0IHJvbGwgYmFj
ayBwYXJ0aWFsbHkNCmNvbXBsZXRlZCBvcGVyYXRpb25zLiBTbyBvbiBiYWxhbmNlIEkgdGhpbmsg
Zml4aW5nIHRoZSBjYWxsZXJzIHRvIGhhbmRsZSBlcnJvcnMNCmlzIGEgZ29vZCBvcHRpb24uDQoN
Cg0KQlRXLCB3aGVuIEkgd2FzIG9yaWdpbmFsbHkgZml4aW5nIHRoaXMgcGF0dGVybiBpbiBhbGwg
dGhlIGNhbGxzaXRlcywgSSBzdGFydGVkDQp0cnlpbmcgdG8gZml4IHRoaXMgb25lIHRvby4gQnV0
IGl0IHdhcyBwb2ludGVkIG91dCB0aGF0IGt2bSBjbG9jayBzaG91bGQgbm90IGJlDQp1c2VkIHdp
dGggY29uZmlkZW50aWFsIGd1ZXN0cyBmb3Igb3RoZXIgcmVhc29ucyBhbHJlYWR5Og0KaHR0cHM6
Ly9pbnRlbC5naXRodWIuaW8vY2NjLWxpbnV4LWd1ZXN0LWhhcmRlbmluZy1kb2NzL3NlY3VyaXR5
LXNwZWMuaHRtbCNrdm0tY3B1aWQtZmVhdHVyZXMtYW5kLWh5cGVyY2FsbHMNCg0KU28gSSBkaWRu
J3QgY29udGludWUgZm9yIHRoaXMgY2FsbHNpdGUuIFRoZXJlIGhhcyBiZWVuIGxlbmd0aCwgaGVh
dGVkLCBtb3N0bHkNCmludGVybmFsIGRpc2N1c3Npb24gb24gaG93IG11Y2ggdGhlIGtlcm5lbCBz
aG91bGQgaGVscCB0aGUgdXNlciBzZXQgdXAgdGhlaXINCmNvbmZpZGVudGlhbCBndWVzdCAoaS5l
LiB3aGV0aGVyIHRvIHB1dCBzb21lIGd1YXJkIHJhaWxzIGZvciBjYXNlcyBsaWtlIGt2bQ0KY2xv
Y2spLg0KDQpPbmUgb2YgdGhlIHBvaW50cyBvZiBzdXBwb3J0IGZvciBndWFyZCByYWlscyBoYWQg
YmVlbiwgcmVnYXJkbGVzcyBvZiB3aGF0IHdlDQpleHBlY3QgZnJvbSB1c2Vycywgd2UgYXJlIGdv
aW5nIHRvIGNyZWF0ZSB3b3JrIGZvciBtYWludGFpbmVycyBpZiB3ZSBkb24ndCBoZWxwDQoqZGV2
ZWxvcGVycyogdW5kZXJzdGFuZCB3aGljaCBhcmVhcyBvZiB0aGUga2VybmVsIGFyZSBleHBvc2Vk
IHRvIHJlYWwgQ0MgZ3Vlc3RzLg0KSSB0aGluayB0aGF0IGlzIGhhcHBlbmluZyBoZXJlLCBzbyBt
YXliZSB3ZSBzaG91bGQgcmUtb3BlbiB0aGF0IGRpc2N1c3Npb24/DQoNCj4gDQo+ID4gRml4ZXM6
IDZhMWNhYzU2ZjQxZiAoIng4Ni9rdm06IFVzZSBfX2Jzc19kZWNyeXB0ZWQgYXR0cmlidXRlIGlu
IHNoYXJlZA0KPiA+IHZhcmlhYmxlcyIpDQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1Fpbmcg
PGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+IC0tLQ0KPiA+IMKgIGFyY2gveDg2L2tlcm5lbC9r
dm1jbG9jay5jIHwgMyArKy0NCj4gPiDCoCAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9r
dm1jbG9jay5jIGIvYXJjaC94ODYva2VybmVsL2t2bWNsb2NrLmMNCj4gPiBpbmRleCA1YjJjMTUy
Li41ZTlmOWQyIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9rdm1jbG9jay5jDQo+
ID4gKysrIGIvYXJjaC94ODYva2VybmVsL2t2bWNsb2NrLmMNCj4gPiBAQCAtMjI4LDcgKzIyOCw4
IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBrdm1jbG9ja19pbml0X21lbSh2b2lkKQ0KPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgciA9IHNldF9tZW1vcnlfZGVjcnlwdGVkKCh1bnNp
Z25lZCBsb25nKSBodmNsb2NrX21lbSwNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxVUwg
PDwgb3JkZXIpOw0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHIpIHsN
Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9fZnJl
ZV9wYWdlcyhwLCBvcmRlcik7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBpZiAoIXNldF9tZW1vcnlfZW5jcnlwdGVkKCh1bnNpZ25lZA0KPiA+IGxv
bmcpaHZjbG9ja19tZW0sIDFVTCA8PCBvcmRlcikpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgX19mcmVlX3BhZ2VzKHAs
IG9yZGVyKTsNCg0KVGhpcyBpcyBhIHJhcmUgZXJyb3IgdGhhdCBjYW4gb25seSBoYXBwZW4gb25j
ZSBwZXIgYm9vdC4gSSdtIG5vdCBzdXJlIHdlIHNob3VsZA0KaGF2ZSBleHRyYSBjb2RlIHRvIHRy
eSB0byByZS1lbmNyeXB0IHRoZSBwYWdlcy4gV2UgY291bGQganVzdCBsZWFrIHRoZW0uDQoNCj4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBodmNsb2Nr
X21lbSA9IE5VTEw7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcHJfd2Fybigia3ZtY2xvY2s6IHNldF9tZW1vcnlfZGVjcnlwdGVkKCkgZmFpbGVk
Lg0KPiA+IERpc2FibGluZ1xuIik7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuOw0KPiA+IC0tIA0KPiA+IDIuOS40DQoNCg==

