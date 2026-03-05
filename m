Return-Path: <kvm+bounces-72795-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHwvJQorqWkC2wAAu9opvQ
	(envelope-from <kvm+bounces-72795-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:04:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B6C520C1F5
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:04:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 129FA3031F0B
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 07:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98484313543;
	Thu,  5 Mar 2026 07:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iKPCOynW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7485F296BD6;
	Thu,  5 Mar 2026 07:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772694269; cv=fail; b=nwF0O+HDulleI08hRb54mVrOdA9/iPrgP7LdBCgw8UrS2YIy0kLQBZgaZ44G1ROo2zGkY/o5MKjcEk+G3/Kvj1/A7s2QXMtGcIcnTnPJVnink4bpuQgiLaC18e71G0PEN9YReYVCt16BFCqMme/ITjPTkcy8HXnDOtq38TLh3ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772694269; c=relaxed/simple;
	bh=Awz4vyllxmspgFr0Scesq0knPQ5uTAfqmxVhBcPwh8o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QiYww0TG7N1tHeLjBgBjalVXNreaFMfC2M3eJ2sCRxEYIQkCxNggn7lpqlqTxStKxbxZ4c1B0jkB37lK5+nVFF0q1IP0b8aXJi9LrrBwqVuo9zjfLJZSdBYeqB8rMRcf6SrjCpiKV3/zTqsFqTWzG5whmXOxReqzecq4XSqDAa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iKPCOynW; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772694268; x=1804230268;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Awz4vyllxmspgFr0Scesq0knPQ5uTAfqmxVhBcPwh8o=;
  b=iKPCOynWCMjSh8HT0hNCSsGioAEUnfi5RZx+SfNQ7GzUZ6SsvyUVAOUx
   nEAAtr6ogX8yDcfDgTIepnTn4letLcUOGUYe/K0r+W7DGgM+S8vgF78BK
   /cXX1VvpCTxp9OT048k+kzsnA6CEy1i8H0O8FpZVySbPSIfYbgQigqVS5
   6uabuUXN0ceZLiERBJxX11+Sq0+i0EeB6dnGjX/XWJii0UZ///puTwTWS
   XghqpEkVD7A13cQABzNW0OedKzY5Bir3/H+NpGxx1bffZt50rumAh1a1q
   8X6tVo9fMQFijvrneUVNwhZ3P2ODeU6MrQBHxQG+ywzUz2ynKHgubb7yg
   A==;
X-CSE-ConnectionGUID: tJeETMNYROS9CJO84wENaA==
X-CSE-MsgGUID: nzkZ5p7DTxenLaphYm+bug==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73962683"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="73962683"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 23:04:27 -0800
X-CSE-ConnectionGUID: Cgx6wo0JTkGh2qaR6YNu+g==
X-CSE-MsgGUID: rnSJ6lN6Q8OzbvAlZT/2Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="223267521"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 23:04:26 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 23:04:25 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 23:04:25 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.8) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 23:04:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dGjhJMjSqlrRc/ZhmywLhvlXKIm2b4CCOLF7WTbtCG4Rx6R9KTke+hiAejrpz5VU4ZtQPzBX4CLGe44C63isS6nE4UJ1hE6pFUwAkR5ECXPFGEN9VtcegcTptKjjHL8MSD0d+ShhOLAaTA9CXhDCZKeVnz4MRNAXzCVuQ/Ml+DWOuNIJ/tTUdIA1H0aVUeTXbKf4Wn2fhkYksJuUQCALlMhqh2EuITxps+/gE423g0SZivC2f3Gfd3hVJ4bwHwNqFfbd74OyiK1IxcaV7Qgn9Z+PkjHSYCKabVKZOZ6B9axgMjUT1XM4yCHhc/M/y1G9+cHQpR3gTTRD0X+M0/JzoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Awz4vyllxmspgFr0Scesq0knPQ5uTAfqmxVhBcPwh8o=;
 b=sfQ92Hd0tPY6aBKr6xpmimOIOyDj20RDHAK7/L0r48paNufN9KoI19RszUYbJV7VGxyzRc99nPkLOlJxHDG7yfWC+gcgxtDP1TrqL9Nha4cVODami7ejvBFd6NgJQXHg/gefbCBQklIhyfPYgBnH+qBozbnm8DtH6ivSBMEKAyCGPAZphetl/fvf4hCqXdSKwNR8718N6GY/uEgYIt2EJMoBflDQHfJFZ2uwk3ASte4SW2KHHZbLVt3ncuH0byl3bFXHBfwh9Q8U9G9iIgU71LSKjjd/uJAsLgCLfZR0XiMUCD+l3v/+RejpoMTHOGlHptbVgCihevuqgwJna+fYeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SA2PR11MB5179.namprd11.prod.outlook.com (2603:10b6:806:112::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.17; Thu, 5 Mar 2026 07:04:22 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Thu, 5 Mar 2026
 07:04:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 09/24] x86/virt/seamldr: Check update limit before TDX
 Module updates
Thread-Topic: [PATCH v4 09/24] x86/virt/seamldr: Check update limit before TDX
 Module updates
Thread-Index: AQHcnCz6qK7bEH8xMkStZUpNRRnekrWfpDkA
Date: Thu, 5 Mar 2026 07:04:22 +0000
Message-ID: <9dec85fd60949a120531c5fc6e746cbf2ba2ae97.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-10-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-10-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SA2PR11MB5179:EE_
x-ms-office365-filtering-correlation-id: 42dcd9fd-3aee-46a9-a78b-08de7a856dca
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: Y2p0rRKFaEykfHU2ervFWdysMsl5iuct2ezHzffCb8Nv0PJIHRDi5QrCATgTlPIS4Md41Jbk2yhL2DxsfPH4+22To2ZTDNnuCyOwQ1puvbDXE+K3aA3fzxDnQY8OGHPkvd2QF2g/bd+dnHqOOi9afoxdZU31P4/8E9GSuP2x4TlgQjZkEVSkojfLPNAbO84+UxO5z/mKZIDX3JXFUcBCx8hx/Ucjqh0HsQ7BsVBmBwc3Jy+9NtBVmKILg3PEdk5gjopf1gTC/ciqXf2lFtg4jf2XiCKxcqt/z1P5fnk45uFOhuxk+e/W3OuxjpKVzYcbiv8PA/7y2R72Cx+AuOf0t8vGIIJ6Y2ZUejO6BIloLv+a1u0qV/rG2tWks+gNffCllPM6MM3J3usj3HSxbSTt3SK5mFWCwNfT11rXiO+a6hylnNrkR41DFKBMB6jXVgJZmiY08VKeosi/33uS58gImsKXWqTtPZe+cp147UW6G3EtJoXkoqwjNWgoNWa+Th2zzcp+sQpkYIPGypQjl9d3OdLSGxEggm2NX029ZyJ6H3QmX4eZWcY+S16Fkk1H+2cRwh3Mj/cX7Hkl2d1QXasKTWhbIywsLgDQp0+Rmruz0+x8B4IEkrRhkR8m8/2OVvEoNYSn0pPnVQAwtJs32J3wZ/F3guIH2K8zO2iCcU+s1/feNPbYyE1KgA2gzr2JAtgQfI211N2cTstz1m8KOwv+AyRN3KodGYPEntW9EqdPNEKEBlNHrlenyS+J04skj+d+qOiKdMhRH9mIbQ3HYIVvN+RzOV1oAHMr3l+82So96PU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1liejNXcStwMnFkMGpWbzl3NUNUOUI4THFVNkkzUHdCUnJXVjM1NHkzNVc1?=
 =?utf-8?B?TmtCTnNoWllGUjVsdTI1WVhpeFl4N0dwL1NONElsU3ZsVlY5QXFkdHl5ZEQ4?=
 =?utf-8?B?Tnc5Y05RRk83MW9RZWhld3lISkwrMTJ6eE1Zd1ptOGhqL1h5WnlJYzVxSnlK?=
 =?utf-8?B?Vk5ZVTB1cmY4ZHFIR1IwcVhVb3FEaFlBK0VXWUg5a2lHc1ZhVHlieUV0ZHdC?=
 =?utf-8?B?T2N4QnBWVm9oMXVlQjhWTHZ0Q0RwZW4vQXZVQTVIVTFDbGZYTHNZMTdyVjhq?=
 =?utf-8?B?aU5JOU9rdFpwKzYzL0l6LzlGMWUvaC9vY0JDT05HU2JVSHJLQXlSZkhjV3hL?=
 =?utf-8?B?YURLNjBWcXArK3pMcXlpbmpTQkVnK3ZXeWhjdkZSdXlXNjdHN0VvYTBoUjls?=
 =?utf-8?B?bVNuT0ZhUFIwUThlRDJ3RHg5VEhTYzhTbDJNTjZBQ2NJTEh2NEwxeGg4blAy?=
 =?utf-8?B?VWNTUmRaMFNXRHAxdGJpUFgyclRVODd4TmpLUkErd2VZMHR4d2dYdjdQTGtY?=
 =?utf-8?B?Rk1YMlpEMFllTEI1eVJ1bHNOV1JxMkcyS3E2VFdjcHlGUzBiaGIzNzBGQ1VJ?=
 =?utf-8?B?bEpwNVBhWHREUkJzbjl4S0dwQnM3RlpsbVdXWU0rbHh3SC8ralRreDRBRm02?=
 =?utf-8?B?bEl1Y1Z5YzU5bFZFenMwbWxFeHRJVVRyUHFxZ1BKT2lwc1lvd2xJSjVsQ3pB?=
 =?utf-8?B?UGlNeGthZTFzUEJDKy9pbEFzbndtdlJEU2pEL1d2a2RuWnZSdkFhL1FTYWZw?=
 =?utf-8?B?eUFEcnk0ZE9yTnF6eHhPaTJySFpvSjFvU3UrbUFCQmxVc3N6b1Bqb29YVVZB?=
 =?utf-8?B?VCsyMm1McEI5NEx2SHkwWEhWU09zMjd6c1FHdkYwRG9DTmYvSTVmOHhnb3lY?=
 =?utf-8?B?TkVqc0JWWFdIbzNYb29tWlczaEJIRDdmMmdlRmhuaDF0aGcwWVlrUHZ5dkhu?=
 =?utf-8?B?clkyN0tmNWU1QTZ3cmZmWEg5YkZDNHRjWE1tL3F3RFIzUlk4aFJHWStNUTRB?=
 =?utf-8?B?MjcxS2ZkRW1UNktobmEwa1QwTzV2TE5tNEtVVnF1ZHdldjFCajBoRm13eHJ1?=
 =?utf-8?B?SGlWbGwvMkxoLzFrVy9qYkE0d3lzMXRmdUU4b1U3YVpQSWxweXJTbVcyeUZp?=
 =?utf-8?B?a2dxNjc1REJWRXZpR3FqS281TUdNMWFmV2NFTGFkdCtMRCtyRW04b1o2QVI5?=
 =?utf-8?B?WERmT3h5S1I1NXhiRnZqZVpIeHJaeFJLZFRmQ0ZlcVloejFreEhQTkZBU3Nm?=
 =?utf-8?B?ZE9pWWJQTFUvVHZ0ZlBBZlg0dEhuSHVuSUo1aS9VSGtsdzl3aHhsSUlXMmhM?=
 =?utf-8?B?b1JmMUp0MHNPWXdqaDJOamsxRVdKTHNBVkoyUlJzUy9PbmJVbGZ0WDVCdWo3?=
 =?utf-8?B?UE5oZnZ0K3h6b1l4aTN3bUdhM3U2YWZoWFBZMkZDbzViSHlDMXRUbHlJNURQ?=
 =?utf-8?B?d3hPSTI5ZHhuNmxGOTBrNW02MElPV3VjUFArajdBZ3llYUdlK0duWU1VREN2?=
 =?utf-8?B?R1N2SjRIcmhhYXVlSkt1QlhjVzJHSUxFRXRVRnRibVlEZjgvamczcnNtQzhZ?=
 =?utf-8?B?ZzNoeWdwTDllM2hFWXF0OWI4KzFyeUg4LzR0a25PK2VjTnpMaGZDOWUyd3VJ?=
 =?utf-8?B?SFhyS1hVSGNMbXRlNW43MW5WQkJLREpteU1ISTREUlEvNm5WZkV2c21XSWxz?=
 =?utf-8?B?a0FUWjRuZzJaLysrc25KaW5JUzhXUEVIQVpWbHJyUzlDQkFrWmNjM0FrTVFh?=
 =?utf-8?B?NlBPOWRLS3pKWHVuRzM0a1dOZTNLci9uUWRFM1VvYWoxdVJnQmRiYXgwNkMz?=
 =?utf-8?B?OWV3QTg4dzdrMVR3UHBKUGFoTWhORmwrbzM0L0pVOGxhRnF5UXByYWNOSHNP?=
 =?utf-8?B?ZEJiSnpUUm1tbXcrNklGUWQxd0NXZU1xcVBVMVRlYXhTNzdjSWtOYkQ2WWRM?=
 =?utf-8?B?bjZXT05ZelphZlEvRUwwbEQ3M1VMODA5ZmljaTlmUkw4WW1DSUdvY2tITVc3?=
 =?utf-8?B?ZFRUc0N0cUlHNXJTZW1haDRadXNQNW5hM0Fxa3dFN0NYQXM3N3ZNS1hpbGdm?=
 =?utf-8?B?NmlCUFNxeVFxcXU5MCs0M0VhSVJ4YTZNZjdhbmxXc3dxWThsaGNnQmt3aTRH?=
 =?utf-8?B?c0lqdEFHRzVIbGNITE1pVk9uQWdkbHVDN3FlUGQ4bzVXOGdiN2pMMW1CZnhS?=
 =?utf-8?B?WTMzNFBtWGFZYXM5NlIxeFdXMFhSNmRPdzRrTDlEaWxIYmM5aDhLMmtvSnY1?=
 =?utf-8?B?QkRuWGFrYjYxdnRWcG95T01uNXU5akw1cEdySUtVOE9KYnVSSUp3MGxkbkRw?=
 =?utf-8?B?YnJxNXN0YXZrUEJ0SzdDZG04ZUZ3WTBNalZURktaOE54cm1QckN2Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <430B95E42CBB8A44A3E1BB66319EDDA2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42dcd9fd-3aee-46a9-a78b-08de7a856dca
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 07:04:22.4265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5SuKreu2Pa40lp074XmQdo5dR7iJC3nCdyi4yHN9m1vR8X7jiHnzibZeI2Z2soyinsy99n+rbVXPUvRWZbwdQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5179
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 0B6C520C1F5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72795-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gVERY
IG1haW50YWlucyBhIGxvZyBhYm91dCBlYWNoIFREWCBNb2R1bGUgd2hpY2ggaGFzIGJlZW4gbG9h
ZGVkLiBUaGlzDQo+IGxvZyBoYXMgYSBmaW5pdGUgc2l6ZSB3aGljaCBsaW1pdHMgdGhlIG51bWJl
ciBvZiBURFggTW9kdWxlIHVwZGF0ZXMNCj4gd2hpY2ggY2FuIGJlIHBlcmZvcm1lZC4NCj4gDQo+
IEFmdGVyIGVhY2ggc3VjY2Vzc2Z1bCB1cGRhdGUsIHRoZSByZW1haW5pbmcgdXBkYXRlcyByZWR1
Y2VzIGJ5IG9uZS4gT25jZQ0KPiBpdCByZWFjaGVzIHplcm8sIGZ1cnRoZXIgdXBkYXRlcyB3aWxs
IGZhaWwgdW50aWwgbmV4dCByZWJvb3QuDQo+IA0KPiBCZWZvcmUgdXBkYXRpbmcgdGhlIFREWCBN
b2R1bGUsIHZlcmlmeSB0aGF0IHRoZSB1cGRhdGUgbGltaXQgaGFzIG5vdCBiZWVuDQo+IGV4Y2Vl
ZGVkLiBPdGhlcndpc2UsIFAtU0VBTUxEUiB3aWxsIGRldGVjdCB0aGlzIHZpb2xhdGlvbiBhZnRl
ciB0aGUgb2xkIFREWA0KPiBNb2R1bGUgaXMgZ29uZSBhbmQgYWxsIFREcyB3aWxsIGJlIGtpbGxl
ZC4NCj4gDQo+IE5vdGUgdGhhdCB1c2Vyc3BhY2Ugc2hvdWxkIHBlcmZvcm0gdGhpcyBjaGVjayBi
ZWZvcmUgdXBkYXRlcy4gUGVyZm9ybSB0aGlzDQo+IGNoZWNrIGluIGtlcm5lbCBhcyB3ZWxsIHRv
IG1ha2UgdGhlIHVwZGF0ZSBwcm9jZXNzIG1vcmUgcm9idXN0Lg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFRvbnkgTGlu
ZGdyZW4gPHRvbnkubGluZGdyZW5AbGludXguaW50ZWwuY29tPg0KDQpSZXZpZXdlZC1ieTogS2Fp
IEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

