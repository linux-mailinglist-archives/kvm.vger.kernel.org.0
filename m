Return-Path: <kvm+bounces-20581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F339F919BA5
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 02:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9AF6281160
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 00:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE6A23D0;
	Thu, 27 Jun 2024 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QlUZlCaI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1D71367;
	Thu, 27 Jun 2024 00:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719447363; cv=fail; b=NdZkK+dc6zCfjP4KdBw/1gy/RSTe/dvmFl/iddyRSTLAA9mMCvpcgiJr6US4+a/82YVAr4gRtQkXI/EDHUAZVD3JA1GtNDnTLo/ghMFl2HqdLXLtHstJJMPqCNtIDqMZdMLKzPXlDqK4ViHbpyCtCpa/B/nrBaczJ+nQNfHmmtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719447363; c=relaxed/simple;
	bh=iodRP1FMDGy+vqLb/n5fJma+tK7FrGcm8l65PWEZDjI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f2Ce3AeXrUugax04AA3IJPbUfIqFfYV4YJ21einp+YMR0RfK/x+zyAJWdpeq5ONCRivzuRTPrG6afNLLG7quOKvPKRI1NHjFH+wsnQadjSXt+iGnL/eqMRDWe6n7wkS7CRL0QEhG+11kBwnUU+wVv8Kd8yZdPB7GpWWcUb1rces=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QlUZlCaI; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719447361; x=1750983361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iodRP1FMDGy+vqLb/n5fJma+tK7FrGcm8l65PWEZDjI=;
  b=QlUZlCaIJK6IfYiKErRw9JkO/oMHN+/cJvfeRj+mtwAug/JImiRsXa6z
   KbN+0pzIQTNIFWvQNSdO68I6VFQcwysPogDkXcYcsRWIL6WP9PfJGNson
   37GsW13Idd6PSZUqji0xp74e5UevCAZRq7ki/n2qYBpzZGjyGmEH6gh6m
   2yQokBfS6Ufowo7xR8zQgQOFICpxEBSpROFOQ19EHXM/OvnSVQf6BB1pu
   7UIPXA1CxkI8rDzL+ta+s9SiU27xI4nKjjrIMC8q3F0AtKUvsb6GsxJAH
   3/e5RwBpv7c7fVXMjz13IWpsZoMWn0vu6v4VLYKpXt50cqBOWL1s3Xq1O
   w==;
X-CSE-ConnectionGUID: JRTHifcUSEKU30AKaELeWA==
X-CSE-MsgGUID: 2+Y0vxzaT6+dvxmvcn+GiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="16695741"
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="16695741"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 17:16:01 -0700
X-CSE-ConnectionGUID: /9/WsH9KRuyZsJQUEQlyIA==
X-CSE-MsgGUID: p9NdCC3IQHG3AkiQT8yljw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="67413861"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jun 2024 17:16:00 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 17:16:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 17:16:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 26 Jun 2024 17:16:00 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Jun 2024 17:15:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrlY5cxw46T6velnZ62tSQPTGuAE+Von6e1P0V/oi79jXp2q1lPCZN4g/SZkedY/Jm/WwyVATbnexYldzcTsrGsacDxmBV1VyX7x6nCa8CT1Xqj9uBtaMsvFpBN8mhuQ+RCLCRslwg4O3orrFNZNrnBVh+sv7FAG18bRb83PGLCcBquq71pvbuoSPFBv0ULz2BvcLk+HyIo4vYWJQFapIKyujkUOgKJ+C+BmNS50NU0n3mj6qC9C3ZGw5cgILYMCa6K6QA28hZVJ20ey7yFK/9+kxnk+Sb3PHGuPtsC1ZaFU4obtXjhJTQjpXJqyxUqrt+SDdGnL8g3Pvh/JqTikiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iodRP1FMDGy+vqLb/n5fJma+tK7FrGcm8l65PWEZDjI=;
 b=JnuxxjrH63mct/dbxaG3rlTJHRD24DuHBaV6QtSlrU312JziTqEWxoEXI1ItQRzOjJiVcTh8yWk4AzbfTn7FM7oPW5I6SA+bTePwYZVPcy0HdzQUQs6S+VGFHl3gszlFYBsT5GF8MsZQ5Fs7dqxlv/ZCpwLgbqRii55/JH+TX7SLevUDlOCORYl62/AIO9VmwxGo+ttZX2zxkh7dmHuLCTn+y04ODxTEIeWU3vaK1M2he/gY30nO5h+r/QjExRopUgzIzSBi7qOEsnx0Nvo5UzAlgibDayO2PGvALWlMz9Dh+/Zdc6rsjKhJkeW/FA2gjxxxuGB8hnuBlA9WbusULg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6885.namprd11.prod.outlook.com (2603:10b6:303:21b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.28; Thu, 27 Jun
 2024 00:15:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.025; Thu, 27 Jun 2024
 00:15:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
Thread-Topic: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
Thread-Index: AQHadnrQBvAJmB6j80e0mbgOJfCyfbHYq/+AgADu9YCAAFO+AIAAWXgAgAEZPAA=
Date: Thu, 27 Jun 2024 00:15:57 +0000
Message-ID: <90462a2a660a94427a0bb30224bc067d9c0cc292.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
	 <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
	 <07e410205a9eb87ab7f364b7b3e808e4f7d15b7f.camel@intel.com>
	 <edfc5edc-4bf7-4bc6-b760-c9d4341acc9d@linux.intel.com>
	 <80d06351-3c34-40e9-aecc-524aaeb644f7@linux.intel.com>
In-Reply-To: <80d06351-3c34-40e9-aecc-524aaeb644f7@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6885:EE_
x-ms-office365-filtering-correlation-id: 1bb633ae-22f4-46b8-9a74-08dc963e512f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WnM4N1hVa24yc0pIcDNweUlOVklJKy8ySlNwbmZTSzdTbkFHMnk4Z0hPZlBH?=
 =?utf-8?B?MXQwSFRPNWgrRml6QzVtUlh5NDg5Y3dXT3B5OGNFMFhSTjlyRUNLM0NEcEhT?=
 =?utf-8?B?NjQrSkl4MUFubEpWMGxEK3dPZmdidmQ2aTJQcVpRRWlidThJbWNQbDdzeHZh?=
 =?utf-8?B?dFNhS3pKYSttUEF5Y0NWa0lpaUhJcmpaZmVoN0c1ZUl0Ly9BMzFpTnd6dTNU?=
 =?utf-8?B?NzFNYWFTSUZoK2lvVzFBWTY0WCtuM1F0UURtM0t6U3o1S2d0Mm5pemtJdVFs?=
 =?utf-8?B?cHBUVCtaUGtGcXdMQUdqY0krL2JYcVhqWXllY2lJbjEveGc2bVFNWmplellz?=
 =?utf-8?B?ak5jVFpXenhFRHZWenJMRlkwQlhyMzJHZ1BZNDg0alN0eWpmRm44b014VCtR?=
 =?utf-8?B?SWVUbHRSSmx6ZmtXQWpSa09yUmJvZlRTTUZJbnB1b2JuYjVQeDZSbkJwVy91?=
 =?utf-8?B?VDh1bGc4UXdzT1NBZEwrK054cy9YL0g4Z005dUNNTGhXcHM1Rkc5ODFrUTBo?=
 =?utf-8?B?OE9vYlVUdHVWTXJscm1OeTJyUEJJL2FSTHRMWnQ3a21EbWRoZUJ3WHM4dXps?=
 =?utf-8?B?cC9YVWdOdnIra28xS1E3dENJU3FPY1lZRGV0a2E0cnFkK3RtRlVQanpYN1Zk?=
 =?utf-8?B?aUp1NzNuSmtlUVdvTDNFamFSWk1GK2tidWFrV25mYXVrMzRZaW9mRWFvTllQ?=
 =?utf-8?B?ekJyc09lUW9YbnVwcVV1cUVQYmRvKzFDUDdXQXhqV3BZVXovN0FnVzJLc1lC?=
 =?utf-8?B?cit5OWtGTUg3Tktqd2RPU2Z6Mys2TnRhbFhRRUZKaW9CU2xuTEJTYkd2MGl1?=
 =?utf-8?B?NWY0VDVSbHFuT1JjOXZoMW4vNHZRT25tOTczVnpkQll4L0t4Nkt3RnNaYnlP?=
 =?utf-8?B?RTIvWXE5aU1ZRDB5bnV1S0hFUmlDY3VIWGFjRU05ZjZjaTBVRzVkemYxSVA5?=
 =?utf-8?B?WjZ1bXlXcTRpSmczQW5KRkVTd0JtUy81MlFvb2piTTFiczNac1V5Wm1VdFJ6?=
 =?utf-8?B?MU90d0REQzRjVmZzaWhjUWN1ZWUrcTRkNkFlSlFESS9hOWhIZlZJS3hRYjFv?=
 =?utf-8?B?aGRBSXhQTVJrQThKRVM3Tkw0NEVwcFpYY1VLd2lNekVOeSt2OFRabVFUV1Rq?=
 =?utf-8?B?YU93TUZqWTQ0ME5lL00rbmphYkNncmllcHg1T3VwWUdoWGRpL2NIQmwyT3Jz?=
 =?utf-8?B?NXVtbytZVVBxTDc3ZXpzdGR2aG1XQkttblpXeHJ0cHFwSDFzQ2FzV05QSXJt?=
 =?utf-8?B?a1R0Z1lLb0tUdEdsZ3kwYU1hTzE0eERjenNNQTEyRisvbk9lSEpNWUhIWlRh?=
 =?utf-8?B?U0kxc0k1bkx0RXVwTWhYK0Z4UCtFWkJ4ZDJ0aVFCT2VVS04rdVBIMGcwVnVk?=
 =?utf-8?B?U2JBT3FVakFPY2gyZkVHaDJOYmdQMGNmWDVnZXZ0YzlOenBvRkpFa2FkRUlh?=
 =?utf-8?B?eVZXYWQrU3p3S01XNDAvUUl2M0xZU2lJeXV2WDZQUHdSWktkaU1IaCtwR1hq?=
 =?utf-8?B?MUxPNGJJcS9Ib2QzQXJiZXFZZTJGZXJWZ0hmK3dqQWttNkhKZGNwNDJaUWVa?=
 =?utf-8?B?QUlHUmZEckVqNlJaLzVaTlJiVmcvV1Z1UDdab0RHdjYzM2JERFNrRkxHT0p6?=
 =?utf-8?B?L1IxS0pxeDhBaXdBaDRYTnc5UVdROGtFeWkvaWZYVDdGQjNJZE4wdThqQzZp?=
 =?utf-8?B?d1VaOGRsejB5SU1wMTkwTVREazd5TDhmLzRoeGtyUmg3R2RCQmZFL0l1THV6?=
 =?utf-8?B?OXpVOVZmWDRtOUpqUlhTczdzMjFEbGNEMVIvUFJzYzN3cXlZUVZrWDkwRVZ6?=
 =?utf-8?Q?QGEGtTdu9A1Ruz4hfMfrpR54q68+x8fhlMHC8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHBzaTFUZ1ZPd3R0YzloM0EvbFlwWVN3WFFHRUErOW5ldm8xWC9lVVA3RmQy?=
 =?utf-8?B?bXdTRHlEbVlXVkthWW1OeGxwNFRycytzWHMvQnlqUTBkZXhkb285ZG9iejI4?=
 =?utf-8?B?Z09QK0h0c21kakxDdTFsV04wTXBPZHRlVk5uNzNpL1pkdUZObjh4eHl5N1hS?=
 =?utf-8?B?dEdEOG9kbEZNUHZqeUNFbVhpcnBTd1d1R0dRSzA1eFk4dWtnbFcybm5oUjJz?=
 =?utf-8?B?QStpNUwzbUk2bjBkd1ZWNGd6Qi83dzFrbVQyeExpVXkvN0trK1ZNRWVwYnV4?=
 =?utf-8?B?SHVrdlBNL2xBOTZDeXZaRXN1RDJ5NEhaNG1xdzdpbFppUW9NMmVXYk9VTlJQ?=
 =?utf-8?B?K1pFOU1ZcVYxbFFac29SMUVYdzIrMVRVSmtJSjZ0M21lSmlTQk1SZ2FpaFR0?=
 =?utf-8?B?dzRSQzhYalF2a056OXFXTW04SjdBOTNuOUxrQmpqZ1Faelo4RjRWTGtJSktD?=
 =?utf-8?B?RmtIU3ZxbU9pMHV1T1BESU15OFE3a3NHRzM1K2IybUNZYmdLNmRRenorMFZ4?=
 =?utf-8?B?cDBNNG5WQVA2eUZuOGNsemVsd3BhMTI3WUJFSzVYSEZjU2IyZWQ3eG5wMnZM?=
 =?utf-8?B?cDRtQlRsRmdwSnA3QWcwVVIvWmRoRldJY0xKUWo1bWNTejhpWnNDQ3lqWVUx?=
 =?utf-8?B?VTJZNFhkU0FoamhLbUw1azI1Q0NtbXhicmdLdU9QOGVQaFYybkRFZkFCbVVx?=
 =?utf-8?B?YmpNd1FtZHd1MzNqYTBUVWR1Y0p2bTZqSnIrV2Q4U3d3cmIrSk1PS2IyckZ3?=
 =?utf-8?B?NlhRQXhtWjdoWmpPMW5QNEtzb1E4d1Bwb3Y1V1FCSUpwaUFQL0hHelN1dERP?=
 =?utf-8?B?L1NaRXVFeTYxOGpMSmlxUnlsTE1qbFpjclBQRzZMei81bFR0NUJjK1lYNmxj?=
 =?utf-8?B?MTAxOVp6TUZYbURUVG1XWVZNeFhLbk5OQ2N0RXZoZGsvdmJpMVphUENWTU9m?=
 =?utf-8?B?bmlTdlF1K2V5ZDZMUWNVbUxZZzZET2pCZFpLNnZVZTNveStFMWlNaEE3akkx?=
 =?utf-8?B?KzVnd1BGdjZZdlozcHU0WFJkT1VhWmJGT21kaElIalBkM245U1VDQ29KaHNy?=
 =?utf-8?B?SytDUTVUNjgyVHp0UmljdnU1bEd0RWhGKzY1bU1veStBQjh0MElJU00xOHBn?=
 =?utf-8?B?UHZHSlFJSkxFdTFZUHczMHN0ZWtuaWlZK2h6S3FhY2pxYjE4MEN5U2lFY29n?=
 =?utf-8?B?TDFVY0NuWDB0c0d5MWNHMy9DNC9GK0M1OTJzV1pBdjd3ZnUvYWZDdFVhQ1cw?=
 =?utf-8?B?NlhyMkZHdHh5VURmbktkVXRPSFpRR1Q0RVJLMEs4bUdBOWl1T1ErMG9RdDI0?=
 =?utf-8?B?dFE5aXc1QmRzbXBHMFB5cUR3dGlCS0ZEMjJES093b1ppSFFNZXUxbGI1KzFh?=
 =?utf-8?B?QXdNbnRwNmdrMjRXR2J4ZndOeHNoYWV2Qk9GT2JJRFZvRStJZVFwT3dvYlFL?=
 =?utf-8?B?TGloeHhmbVVrK25mSWxxWFhuM2tlb09mRWJveUdvVGZSdG1Ld2oyNGtPR3JF?=
 =?utf-8?B?OG9QNWFLcWdZWEpSZjQ2VG85bmUrMlNCY0M2QmwwSzh3Sm82L2J6NzVwNkl2?=
 =?utf-8?B?dGpXZzh3YlZuRFVlV3BMam5vcFRPVjlJSVNDYXpWOCt0VGVpLytTRC85Qkd4?=
 =?utf-8?B?QSsvNXlZcXVBMDNlTmlOcjhvRGR1OTRXcWNjR2NmOTRqaWZTankxZmVmbFVp?=
 =?utf-8?B?ZFo5ZmdNa3NhcUNad1h6Tm10djFNcDFwUHRHL3lNTG1KUzVSQkE2SFM0ZVpq?=
 =?utf-8?B?ZHJyNmZlejFRUGFPc2o0V2xZRHRqa01ZSEIxRmpyclIyUW9aWGJDd3FtRE9s?=
 =?utf-8?B?cms4ejQzRUZ5b1NTazdwbTVNSU1BQ1dNYmF3bmV6REl5cHEvd0orNVhsTVhN?=
 =?utf-8?B?a0IvbnlaSC9rdzZJMTZhUlRpKzdDQzh6SUZJRlBSK3BEZnpVeWF2angwZEpU?=
 =?utf-8?B?YkJKWDJ3UUZnL0lOcHZ4dkNWOWhvRmNKYlBqMUthMDZ2WTNZaVhidjlvYjhI?=
 =?utf-8?B?M2RwcUJWaU1GSDMyU292V0tmNXoya3BnSW1iVXdETG5QRmdJcXMyRzBxNEkr?=
 =?utf-8?B?QmpQMUloakgwWFFMTkZyUy9OWmo0bmJxOE1YWCtFZzFpZC9kalVQTXdxNnpF?=
 =?utf-8?B?WndSdldNZEFLMjdBZ2FWbEFiSjBoVVloc0paTFgyWlN6NUNYejM5Zi9uYXVL?=
 =?utf-8?B?dkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2DBB6A1A201CE4AB31B0E3EFDD68F52@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb633ae-22f4-46b8-9a74-08dc963e512f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2024 00:15:57.3370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VkvVkw0OTGmkd6ETohNsiiLtfDC+scGBPLFX1G+EiDMtXVdkgWYT/9WBL1xDaAF7O6ZPzrPZTcRfVWZZYQE4DGNxDZtD3wGXDqyV8/FZeiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6885
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA2LTI2IGF0IDE1OjI5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiANCj4gT24gNi8yNi8yMDI0IDEwOjA5IEFNLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4gDQo+ID4g
DQo+ID4gT24gNi8yNi8yMDI0IDU6MDkgQU0sIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0KPiA+
ID4gT24gVHVlLCAyMDI0LTA2LTI1IGF0IDE0OjU0ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+
ID4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdwYSA9IHZjcHUtPm1taW9f
ZnJhZ21lbnRzWzBdLmdwYTsNCj4gPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgc2l6ZSA9IHZjcHUtPm1taW9fZnJhZ21lbnRzWzBdLmxlbjsNCj4gPiA+ID4gU2luY2UgTU1J
TyBjcm9zcyBwYWdlIGJvdW5kYXJ5IGlzIG5vdCBhbGxvd2VkIGFjY29yZGluZyB0byB0aGUgaW5w
dXQNCj4gPiA+ID4gY2hlY2tzIGZyb20gVERWTUNBTEwsIHRoZXNlIG1taW9fZnJhZ21lbnRzW10g
aXMgbm90IG5lZWRlZC4NCj4gPiA+ID4gSnVzdCB1c2UgdmNwdS0+cnVuLT5tbWlvLnBoeXNfYWRk
ciBhbmQgdmNwdS0+cnVuLT5tbWlvLmxlbj8NCj4gPiA+IENhbiB3ZSBhZGQgYSBjb21tZW50IG9y
IHNvbWV0aGluZyB0byB0aGF0IGNoZWNrLCBvbiB3aHkgS1ZNIGRvZXNuJ3QgDQo+ID4gPiBoYW5k
bGUgaXQ/DQo+ID4gPiBJcyBpdCBkb2N1bWVudGVkIHNvbWV3aGVyZSBpbiB0aGUgVERYIEFCSSB0
aGF0IGl0IGlzIG5vdCBleHBlY3RlZCB0byBiZQ0KPiA+ID4gc3VwcG9ydGVkPw0KPiA+IFREWCBH
SENJIGRvZXNuJ3QgaGF2ZSBzdWNoIHJlc3RyaWN0aW9uLg0KPiA+IA0KPiA+IEFjY29yZGluZyB0
byB0aGUgcmVwbHkgZnJvbSBJc2FrdSBpbiB0aGUgYmVsb3cgbGluaywgSSB0aGluayBjdXJyZW50
IA0KPiA+IHJlc3RyaWN0aW9uIGlzIGR1ZSB0byBzb2Z0d2FyZSBpbXBsZW1lbnRhdGlvbiBmb3Ig
c2ltcGxpY2l0eS4NCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNDA0MTkxNzM0
MjMuR0QzNTk2NzA1QGxzLmFtci5jb3JwLmludGVsLmNvbS/CoA0KPiA+IA0KPiA+ICvCoMKgwqDC
oMKgwqAgLyogRGlzYWxsb3cgTU1JTyBjcm9zc2luZyBwYWdlIGJvdW5kYXJ5IGZvciBzaW1wbGlj
aXR5LiAqLw0KPiA+ICvCoMKgwqDCoMKgwqAgaWYgKCgoZ3BhICsgc2l6ZSAtIDEpIF4gZ3BhKSAm
IFBBR0VfTUFTSykNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBlcnJv
cjsNCj4gPiANCj4gPiBBY2NvcmRpbmcgdG8gDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
YWxsLzE2NTU1MDU2NzIxNC40MjA3LjM3MDA0OTkyMDM4MTA3MTk2NzYudGlwLWJvdDJAdGlwLWJv
dDIvDQo+ID4gLA0KPiA+IGZvciBMaW51eCBhcyBURFggZ3Vlc3QsIGl0IHJlamVjdHMgRVBUIHZp
b2xhdGlvbiAjVkVzIHRoYXQgc3BsaXQgcGFnZXMgDQo+ID4gYmFzZWQgb24gdGhlIHJlYXNvbiAi
TU1JTyBhY2Nlc3NlcyBhcmUgc3VwcG9zZWQgdG8gYmUgbmF0dXJhbGx5IA0KPiA+IGFsaWduZWQg
YW5kIHRoZXJlZm9yZSBuZXZlciBjcm9zcyBwYWdlIGJvdW5kYXJpZXMiIHRvIGhhbmRsZSB0aGUg
DQo+ID4gbG9hZF91bmFsaWduZWRfemVyb3BhZCgpIGNhc2UuDQo+ID4gDQo+ID4gSSBhbSBub3Qg
c3VyZSAiTU1JTyBhY2Nlc3NlcyBhcmUgc3VwcG9zZWQgdG8gYmUgbmF0dXJhbGx5IGFsaWduZWQi
IGlzIA0KPiA+IHRydWUgZm9yIGFsbCBvdGhlciBPUyBhcyBURFggZ3Vlc3QsIHRob3VnaC4NCj4g
PiANCj4gPiBBbnkgc3VnZ2VzdGlvbj8NCg0KSXQgZG9lc24ndCBzZWVtIGxpa2VseSBhIGd1ZXN0
IHdpbGwgcmVseSBvbiBzdWNoIE1NSU8gdG8gY2F1c2UgYW4gZXJyb3IsIHNvDQpzaG91bGQgYmUg
c2FmZSB0byB3YWl0IHVudGlsIGl0cyBuZWVkZWQuIExldCdzIGxlYXZlIGEgY29tbWVudCB0aGF0
IGl0IGlzIG5vdA0KZXhwZWN0ZWQgdG8gYmUgbmVlZGVkIGJ5IGd1ZXN0cywgc28ganVzdCByZXR1
cm4gYW4gZXJyb3IgZm9yIHNpbXBsaWNpdHkuDQoNCj4gPiANCj4gPiANCj4gSGFkIHNvbWUgZGlz
Y3Vzc2lvbiB3aXRoIEdhbywgQ2hhby4NCj4gDQo+IEZvciBURFggUFYgTU1JTyBoeXBlcmNhbGws
IGl0IGhhcyBnb3QgdGhlIEdQQSBhbHJlYWR5Lg0KPiBJLmUsIHdlIGRvbid0IG5lZWQgdG8gd29y
cnkgYWJvdXQgY2FzZSBvZiAiY29udGlndW91cyBpbiB2aXJ0dWFsIG1lbW9yeSwgDQo+IGJ1dCBu
b3QgYmUgY29udGlndW91cyBpbiBwaHlzaWNhbCBtZW1vcnkiLg0KDQpSaWdodCwgdGhlIGd1ZXN0
IHNob3VsZCBoYXZlIHRvIHNwbGl0IGl0IGludG8gdHdvIGNhbGxzIEkgZ3Vlc3MuIElmIHRoZSBN
TUlPIGlzDQpwaHlzaWNhbGx5IGNvbnRpZ3VvdXMgYW55d2F5IHRob3VnaCwgYSBndWVzdCBjb3Vs
ZCB0cnkgc3RpbGwgdG8gbWFrZSBhIHJlcXVlc3QNCnRoYXQgc3BhbnMgdHdvIHBhZ2UuIChhc3N1
bWluZyB0aGVyZSBpcyBub3Qgc29tZSBvdGhlciBIVyByZXN0cmljdGlvbiBmb3IgdGhhdA0Ka2lu
ZCBvZiBhY2Nlc3MpDQoNCj4gDQo+IEFsc28sIHRoZSBzaXplIG9mIHRoZSBQViBNTUlPIGFjY2Vz
cyBpcyBsaW1pdGVkIHRvIDEsIDIsIDQsIDggYnl0ZXMuIE5vIA0KPiBuZWVkIHRvIGJlIHNwbGl0
Lg0KPiANCj4gU28sIGZvciBURFgsIHRoZXJlIGlzIG5vIG5lZWQgdG8gdXNlIHZjcHUtPm1taW9f
ZnJhZ21lbnRzW10gZXZlbiBpZiB0aGUgDQo+IE1NSU8gYWNjZXNzIGNyb3NzZXMgcGFnZSBib3Vu
ZGFyeS4NCj4gVGhlIGNoZWNrIGZvciAiRGlzYWxsb3cgTU1JTyBjcm9zc2luZyBwYWdlIGJvdW5k
YXJ5IiBjYW4gYmUgcmVtb3ZlZCBhbmQgDQo+IG5vIGV4dHJhIGZyYWdtZW50cyBoYW5kbGluZyBu
ZWVkZWQuDQo+IA0KPiANCk9rLCB0aGFua3MuDQo=

