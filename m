Return-Path: <kvm+bounces-71461-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDQDM04dnGkZ/wMAu9opvQ
	(envelope-from <kvm+bounces-71461-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 10:26:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CB0173E1F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 10:26:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6CF1D30312D8
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 09:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418A534EF12;
	Mon, 23 Feb 2026 09:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g5iVvKxo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C34B34E75E;
	Mon, 23 Feb 2026 09:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771838759; cv=fail; b=jt96tZSkolBDXJokg2hWBJ0AueY+xZSUvpV6+YNYvtWYs61eFlnX0emS97T99dp9IuqQLxtjqZpwKXhvHu3OrYcvMls5uWe26Xs9i/eFTtOKuRdVjUnJcey55HxQrqZs8MUZqyTVUgM2rdm5kv4QYD/OzZRQJXliBTuZQ3UFAWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771838759; c=relaxed/simple;
	bh=FlBZGx8VVsPXivXhJR++/h0v/u3Dw/uhQ95YHx/vjZ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c5myDui/CrHQ/UutqnTvp1mbUDzqp9C1vQJVU/b84gzVr5Yo3QNIqXrV3JYIv6YcoX4sFZDDWXQi+oR8mF5jCA8s4qu7ttO2iQVdM58LgeaD4fxfI41RVX/jQfR2yCIamIysr+pIizXkJ0ML2hViW9Mk/39tuk++cSfnuDveI14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g5iVvKxo; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771838758; x=1803374758;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FlBZGx8VVsPXivXhJR++/h0v/u3Dw/uhQ95YHx/vjZ0=;
  b=g5iVvKxoY88GLNhn1hrUAFKM+ksaiVvW2mLxiTI56Zb3w2tqVlXurTzJ
   GglTHCQ9BGZ+10mvZwf09gbSP+pFJ6GSjMIM6hQkf6M1Vqq+dg5c6suLD
   SPkxNiq0bmI2pAPIoxYkywM9WnDmR9WtbOgeofYsZQKAnpQ2v9PBF3M0U
   sQRfUl+wnC4cpasBRJ38lcvsXrIAtWLvxV6nxhTj/RkIC2pipptiwxpe+
   AXUqcN1Rz/f1mGp0Yjc358gucZf1lyZKuJUosvX5EwerdQ6zbVXQPWONC
   2Bbs3PRsc1S7jbyFGtGBBQkrYnL4dcNcuKLp/XaCwBorV4GiW/3AhPoB4
   Q==;
X-CSE-ConnectionGUID: etvLqX6qSVuekESXg8kocw==
X-CSE-MsgGUID: v2MPwVGvQ/2a1SrJeckowg==
X-IronPort-AV: E=McAfee;i="6800,10657,11709"; a="76691494"
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="76691494"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 01:25:58 -0800
X-CSE-ConnectionGUID: IOzoQof7TiOWqYeCSBwIsA==
X-CSE-MsgGUID: NjbS9+4gTI+FoiNzMf6FPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,306,1763452800"; 
   d="scan'208";a="220051559"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 01:25:58 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 01:25:57 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 01:25:57 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.52) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 01:25:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DHEZBV0GHULInARCyqXyw4N/ylWOnWoLy1aOrSNzIXgL755r4+wqmyDKB+uzwQo0Xo83qdRoBteUKCJNIrbziL/b0H/0G74mR39SZWJERPzgFwGPbuwu1jpgoXKCKC2M/NEYrFr7aQrfQFI9ccM9VQmtC7kWm7j4acRSZcPxdUjgVPermx7RwO28qIw7gVH+P8W4GGfFjIhP8gl8MjCeQ2HqgZv5AeS2czDYMuu620B8c18KDbYNPWcS0NOkQN073sUPJcdUx8v8PQQWLuk7ViRtJFoRx2XLk6bCnpkw1kg8CId9bXwNWP3WvbFdCFdwdDipTdFjHk3tBORft4Wngg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlBZGx8VVsPXivXhJR++/h0v/u3Dw/uhQ95YHx/vjZ0=;
 b=q0lyK7RB0seh+58es1NGAiWTUHZXov1CbtktdU+oaXB4zIydOhcaspAtZMf8BxZW9op2Vf/SiDmA2Bl7bPxNHKroVtF7inNPeF1mNmT7aJoXRqhvx8IRoXn+K8fbVJCGteQgibXjo/1sBEGqBjoDNAMKVqFHamvOCk6Ix43o253/fxI6nMXgsoXWN2H9zKy8VRNTnJHmMXyRsSSGYJr5RhJJWooa9qRKsnoFS4n5dL0Xd+8g6wvjIAT7Y/wlhqHSTYBq11LbaM2WiEVuF5QSWGEtgjq9TWaYUIYR9Ds61iglCIm+ldE/pIhALR0VwawhI7crYOCSJ3pNZqIKi93tNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 DM4PR11MB6144.namprd11.prod.outlook.com (2603:10b6:8:af::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Mon, 23 Feb 2026 09:25:54 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 09:25:53 +0000
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
Subject: Re: [PATCH v4 11/24] x86/virt/seamldr: Introduce skeleton for TDX
 Module updates
Thread-Topic: [PATCH v4 11/24] x86/virt/seamldr: Introduce skeleton for TDX
 Module updates
Thread-Index: AQHcnCz7pXAAYWHOTkqjqq+NZZbXy7WQFHOA
Date: Mon, 23 Feb 2026 09:25:53 +0000
Message-ID: <14ee337df2983edb3677e3929d31e54374a1762e.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-12-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-12-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|DM4PR11MB6144:EE_
x-ms-office365-filtering-correlation-id: 0b66ddca-81a0-4bd1-19a3-08de72bd8af2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cmtxRHZxblFXMXhnQ2h3Qzc3RnhEWEdpdEphUDZ1REJiNExhdWszYjBKc1Rp?=
 =?utf-8?B?eUZvTU1sZzVRK2FnVzRKVmVORlhiNmk0M1lNcXNLYWdRTUU2SWFZSkxSZkxG?=
 =?utf-8?B?RHIrTzdWREtvSXRRVHRUQU9nS1ZUTWVPRkJoMUUzQ0Z0WWMxKzdsN1lvaXBM?=
 =?utf-8?B?cmY5ZUdWUWZ0RU5UeFZON1hzYXpXK1FJSVd1Vmx6ZTFjbmpmSURRVHEvVTdD?=
 =?utf-8?B?U0RvV0dZRDNYajZlZVBnc0k1RHJKMFNNa1J2RWZIK1EyMVI3dnFWdDZqalUr?=
 =?utf-8?B?enBVazU0VkthS1NTdVBHQkZsYWxCRURmVWZPUmxJUnIvTkc2TGFqemVWUGFp?=
 =?utf-8?B?RVF2MnBnZVFONkEzQUFZRlBpbU5ReERhWUp0THVXekxZT1lmVC92Snd4MGYy?=
 =?utf-8?B?SnFYY1pTN0hxSEtqOWhLdFB6eVF5em9MRWd2VjZGenEwNVJtM2FIcEV0UEZ1?=
 =?utf-8?B?Mjh2VStqcU9MR01LekhIVFlId0dGNEtidEpyTVhnbGdPOHNWY1YvdUUzUlFa?=
 =?utf-8?B?bHl1dWhWODFrUHR3cnFOQ29kK2xqd08rbEdiOWM4NWhVanBDTTZGUnR3bElT?=
 =?utf-8?B?U29GMjZPWm9GdEFLK1piZjQvQWFmM2U2RWNBTHpwa1drZjdzTmRjY1RCY3Fn?=
 =?utf-8?B?U0ZzZkVBaFJXREtZU0huc3Bkc002UHVmQzg0dXlYbnBrbWM5VGxKOEZLZ3g3?=
 =?utf-8?B?VU9tWjcrT2M2bXE4OER4V1BFYTJWQldnWWxEdFBLSy9KejVqVW1lMm1PNXJy?=
 =?utf-8?B?cDVWL1FkR2orSGhLR0Y2TzFaRlJvR21hSFNPeERXQVIvdGhxMzRWTXdBNlpx?=
 =?utf-8?B?NkREcjRyREtNSHVhZ3Bhb2Y1VHU0Unp2OGZ0Y09pMEZBOUwyUkN4Um1GdmxM?=
 =?utf-8?B?cTYyUFlLMjU0dEdjckN0VmkrSjRmVlFDRWNaVFB6RWN3VEUzMGxvZ2hOSjVD?=
 =?utf-8?B?TDQ5VTRjRWUveDI2REN3dEFhbloyeG16eDZidDBSZ09ZOGFJVlJQS1luQWFW?=
 =?utf-8?B?Y1Fnc2RyNWQ4MVYxUExrTXlROVRRTFYybklXNWtnNmFsSU93TTRkRkFaSWo2?=
 =?utf-8?B?emxrbzNIWXdFY1JsejZ5MHFzMWNyMU45THJLY1BLanNOaE5CcjVsVWZrWmhm?=
 =?utf-8?B?VE9lNTBmZ0RvMFJxSkt2UnpCc1VSRDZFREdPcWNuanVmb0RZQ2FRcll2cGxG?=
 =?utf-8?B?WHhPc2FYYnBQTDlNZ3YvdmErajNZV3JPRm04V2dJT2RNWDhiRVBOa29qUDFu?=
 =?utf-8?B?aWx5L0c0dVd0VkxlR2N3OWo2L240cWt5UnVvOU9SQlNCMTJMSUQ5Wll1U2ZO?=
 =?utf-8?B?OER5Z2J0dzRXRHowRWFjZno0aU50QlVYZHh3aEEvNHpnWjlqVlRYZ3hMaGgx?=
 =?utf-8?B?QnZZdDJmUUZ0Q1kySmpPQjl3REpHVDBMMlJmOG03NVhqeUdhSDZyQko2cDdm?=
 =?utf-8?B?aGNLbHprZWpCVHhsR0JiRzNseUY1S1pBMXQ3WjlGV0M4QWVQMWhnNnVQZnpX?=
 =?utf-8?B?WHFRTmlKMWUycCtsVzRlMlFVbGI2WkhGM1h2U3l2MktCeCs1RlVDN1h5ekFz?=
 =?utf-8?B?TGtLMDBZaitCUU9aN1pCTlZWcWQ0VVA5d05NQXc2cnRPNlVidkRlcENFZ1NU?=
 =?utf-8?B?YTVVQXhhMlRjdjdHQzFnUUtpUERFTmJDTDVCZUZTWkhLV2xsdkIzK2RxNkU3?=
 =?utf-8?B?WHduQXBGTXRvSWNuY0FHaG5jUzRoK0RKelMxRGdiMmd5NnJlSjFpQnRuSXB3?=
 =?utf-8?B?R2QxRXkwRDdpcnpLVTZkMkVIV2N4RXVPcnI1YkNOZHdNNDQwZkZGK1hOSUho?=
 =?utf-8?B?a24vZ1VKWUFQZmVia1JSK0lOMkdBc1VtUDFjRzRJL3ozNjhVem9zaEIxWXNu?=
 =?utf-8?B?bHVaQkxpSHBiSTdaNDg3U2lzWEpVbVBIY0NwWWh3a3VVbEtocXRpWnNDZllK?=
 =?utf-8?B?VnVFcG53ayt0YUYwR29YamZvVnEwMWlmdjdzaDE0L1RsYmMrWDMzWnB6czEz?=
 =?utf-8?B?cmZ1bW1ZKzdDT2U2Z2EyQWY1dmFYanVFbDl0OXhTMnhCWFdXbWNaQnlOTGNE?=
 =?utf-8?B?N2xYd2QyM0Q2M0g4R1k1dDJnaEl2RzJNZ0MzbnV4YnBCZ3BsbGo1MDBOZFpQ?=
 =?utf-8?B?YzhRK3hpbCtHbmtEVmpBTDlBa2M0eTJxcEJyMXp3Y3JnZjByb3A1cm41WS9E?=
 =?utf-8?Q?9/19jknqqqKOMqqRzdSilO0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmNjNDkvT0xuajdBRWxNb2pxMXhCbzNmeUJWUnFTQzNRdHBzTnRTdWFObCsz?=
 =?utf-8?B?bytqa05sUWVBQlFNQ3dJaG9pdnZJU2RlK2ZUWTdHbndkRGNTeFRMT1hIZVIv?=
 =?utf-8?B?dWRjcW1LL1BKMjB4YkowQlZ1aUdQSTFFMlJUYTBlRGpIOWJGT3VGMWY1ZU5x?=
 =?utf-8?B?ZVNnQnNiR2VSWUlaOWExTDF5dHpGZzQ4N0V2UnFkZUxnTXlQVndZSlRTSEJn?=
 =?utf-8?B?Qno5bzBWemlEaFZBS29BVE9QNmtpMkMrVnVjdGNhb01CaURmb1hvK256enVI?=
 =?utf-8?B?eXd4bXh5REpqMVY2U1BGWm1leS9xS0V3TnY1emJ3THhaRHkzRXZrSWp4Y0p5?=
 =?utf-8?B?V1JDdVowU1I1QnIweTFaYmZSYzVJSkVZYUgxVzF3VWNqRGxab3YwU0JKaHYy?=
 =?utf-8?B?VUlmTGdvWmt2WkQrUmZNZVpzMjlSMW5DT0RkTGdDMEJPdHh0UlBkaklzcXFx?=
 =?utf-8?B?QmlqaWZmYmd3dzhiRmhsVjJKZno0eDFJY2pUQWRyQm1rek1NemxGV3FOTFRP?=
 =?utf-8?B?T1RUcW0yMm5Gd2Fubis4QjVqUmNPNnoyUXVBdUtVbjlJMExCQzlyM1BwVGg5?=
 =?utf-8?B?ak83VVhwUFg3ZkRmNC94T2xtQkVFMDN6YkJIcFlEZVI3a2F0TlYyTWJ3bEZO?=
 =?utf-8?B?V3NHeklBYVlSdzZxTTlKbUNNY3lxanZtbkgwZFFQUEZQaW5HeWhhblE5U0JB?=
 =?utf-8?B?TG12MXZaSWdhYmdSZXN1ZWUycVBtcGtXM2lncUU5REZQZFhmbERwRE94TGFL?=
 =?utf-8?B?eWtTQkJVZmF6dXFkYWRMUTVyTUIzY2NmZlo1WjV0Nyt2V1d3TGcvSm9Lc2cv?=
 =?utf-8?B?N0doRTB5a0UwZ2xwM3NQMlJrWjNib1VEa2Q0a3pZcVNYQ0VuaGFCK2l4MG1z?=
 =?utf-8?B?eDZ2cjQ5VDJxTStVTWhWRjN1QlBJK0dNd29EVDk4SENhcXlpVCtDWlJLUkFs?=
 =?utf-8?B?ZWVUZXEyV3pCUmVIZTh4N1VUN0h1L2hmZFhiY29nTDl3cmFJVzlRT1A1ZjN5?=
 =?utf-8?B?akZrQmplWFNpenJMRzdWQmdPRlpGcll6bm9OL2p5WG5QbWhCUVI0cTc5Ly81?=
 =?utf-8?B?Y0FLVWlicUgzNWVxNDgvZ2hIZXZuRlJOeFZXQkQreUZTakdFbkQ5ZFpoaXJB?=
 =?utf-8?B?clVZK05LOHRaUncySWYxT1V5a2lOUWVLNG1qcXJ5N2dCSjdjTURVaDgzN2pO?=
 =?utf-8?B?YW0zelFVVmhidUs1eDFmSlZabXErL2ozRGVRL0hIVUplWmpaRFJLb1ptMjQy?=
 =?utf-8?B?cExGdjNwV3JFWGttMktvYVhvUUorK1RQS0Q2MFJ1eHQyVlNuSmcwTEpwQk83?=
 =?utf-8?B?c3Y3MzZ4anhMbTBpaXZ0TGVKMWhRYVJwZFZTd3d6Vkx0RC9YZnZQVU5KVThI?=
 =?utf-8?B?a242d3RnT0Zpd1BLdkVzME5hemg1dTFpYkhxa1hvOVlLbXdubGJOaHUxMVNJ?=
 =?utf-8?B?UUlkKzV2dEsvam5jU3Yyd2huWTJTZ3V2NkQ2czlvd1pVMWYySVVzZUdYclJq?=
 =?utf-8?B?dkxzb3RCcHlOV3lDUGRlWEFGQXcrUy9BZk9ra3JJM012a05ydXgwOXlvWXVD?=
 =?utf-8?B?VHVJRDhaTjRXbUZvc1hpZEdsOWhlS0xSSVFSb3Z0WFVRRjRtcXFwOWhIZXhu?=
 =?utf-8?B?U29PWXQ0elovUHhreDRrTWdnTjlwOHdRQ1h3R3FuZSt5ZUhlRGhWU1VVVEpi?=
 =?utf-8?B?WTByS2JqUnJnZGZrUDJXQ3ZOL3R3bmV3MFZCaFhUVXpqYzdib1BnanZvODc1?=
 =?utf-8?B?akg1Y21yaVhTK3BjMmxzR2lKbGFNVHorUmpXOHJHY2FGWmVQQllZenAzTEJ3?=
 =?utf-8?B?cEMxUFladzVBNGhJZDduSkxZdStvaGZGWHRGb3ZBajZ5eC9GNkVWQkUzempO?=
 =?utf-8?B?WXpvMjVQb1FVV2dvWWpBR25NNHhZdG9QM21jejUxUUF0T2UwdURhTGtuNHBX?=
 =?utf-8?B?N0RFQ0NYMlRMeEdCOFJSaFRrbDJ1ZEZ3c09Kd3doZFYzRkxpS3JnbWRVREVo?=
 =?utf-8?B?NUVzbUNkSUhQMEM4RTQzbnpoczIzRXI2V1h5QmYycklLRjRGNnRGUmZtZjBN?=
 =?utf-8?B?aHkrUUpFNjBpa3RJVWljUjJGcW9TYisyWmlJU2NoaCswNzFISWlWaXg2UUlJ?=
 =?utf-8?B?UVBzUXM1ZFJwc2dPd2lmcFJqRjdjNlZoVlBvWTNlVGJDdWtyMjFmRENGRGNn?=
 =?utf-8?B?VUM5N0VxWm16VG1NK1BybDB5UFpNQnEvNnRqOTF5dmdWMDQ4ci9HQmtpQVlv?=
 =?utf-8?B?dzBsSlNBT1ZadlJZMFBybVRSUDlvOTNvaUVTSFpxUGRRd1ZHcW5IcnoySjgr?=
 =?utf-8?B?THA3R1BJT0hSbGd2bGJUSUcxL3VyR2pEMC85WERnVGM0aE1sanFqdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <739EFA502853E84B99A61B7B1D4C2C23@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b66ddca-81a0-4bd1-19a3-08de72bd8af2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2026 09:25:53.8590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yWeiOPWZwAEpMWb8XZV6AYk+VqriCtj/dR+Zv3eop+2UB0vuJZsuqrA96vG7wbY7ggv9LfkghBBGH5HSoCryGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6144
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71461-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 46CB0173E1F
X-Rspamd-Action: no action

DQo+ICANCj4gKy8qDQo+ICsgKiBEdXJpbmcgYSBURFggTW9kdWxlIHVwZGF0ZSwgYWxsIENQVXMg
c3RhcnQgZnJvbSBURFBfU1RBUlQgYW5kIHByb2dyZXNzDQoNCk5pdDogIHN0YXJ0IGZyb20gVERQ
X1NUQVJUIG9yIFREUF9TVEFSVCArIDEgPw0KDQpUaGUgY29kZSBiZWxvdyBzYXlzOg0KDQorCXNl
dF90YXJnZXRfc3RhdGUoVERQX1NUQVJUICsgMSk7DQorCXJldCA9IHN0b3BfbWFjaGluZV9jcHVz
bG9ja2VkKGRvX3NlYW1sZHJfaW5zdGFsbF9tb2R1bGUsIHBhcmFtcywNCmNwdV9vbmxpbmVfbWFz
ayk7DQoNCj4gKyAqIHRvIFREUF9ET05FLiBFYWNoIHN0YXRlIGlzIGFzc29jaWF0ZWQgd2l0aCBj
ZXJ0YWluIHdvcmsuIEZvciBzb21lDQo+ICsgKiBzdGF0ZXMsIGp1c3Qgb25lIENQVSBuZWVkcyB0
byBwZXJmb3JtIHRoZSB3b3JrLCB3aGlsZSBvdGhlciBDUFVzIGp1c3QNCj4gKyAqIHdhaXQgZHVy
aW5nIHRob3NlIHN0YXRlcy4NCj4gKyAqLw0KPiArZW51bSB0ZHBfc3RhdGUgew0KPiArCVREUF9T
VEFSVCwNCj4gKwlURFBfRE9ORSwNCj4gK307DQoNCk5pdDogIGp1c3QgY3VyaW91cywgd2hhdCBk
b2VzICJURFAiIG1lYW4/DQoNCk1heWJlIHNvbWV0aGluZyBtb3JlIG9idmlvdXM/DQoNCj4gKw0K
PiArc3RhdGljIHN0cnVjdCB7DQo+ICsJZW51bSB0ZHBfc3RhdGUgc3RhdGU7DQo+ICsJYXRvbWlj
X3QgdGhyZWFkX2FjazsNCj4gK30gdGRwX2RhdGE7DQo+ICsNCj4gK3N0YXRpYyB2b2lkIHNldF90
YXJnZXRfc3RhdGUoZW51bSB0ZHBfc3RhdGUgc3RhdGUpDQo+ICt7DQo+ICsJLyogUmVzZXQgYWNr
IGNvdW50ZXIuICovDQo+ICsJYXRvbWljX3NldCgmdGRwX2RhdGEudGhyZWFkX2FjaywgbnVtX29u
bGluZV9jcHVzKCkpOw0KPiArCS8qIEVuc3VyZSB0aHJlYWRfYWNrIGlzIHVwZGF0ZWQgYmVmb3Jl
IHRoZSBuZXcgc3RhdGUgKi8NCg0KTml0OiAgcGVyaGFwcyBhZGQgInNvIHRoYXQgLi4uIiBwYXJ0
IHRvIHRoZSBjb21tZW50Pw0KDQo+ICsJc21wX3dtYigpOw0KPiArCVdSSVRFX09OQ0UodGRwX2Rh
dGEuc3RhdGUsIHN0YXRlKTsNCj4gK30NCj4gKw0KPiArLyogTGFzdCBvbmUgdG8gYWNrIGEgc3Rh
dGUgbW92ZXMgdG8gdGhlIG5leHQgc3RhdGUuICovDQo+ICtzdGF0aWMgdm9pZCBhY2tfc3RhdGUo
dm9pZCkNCj4gK3sNCj4gKwlpZiAoYXRvbWljX2RlY19hbmRfdGVzdCgmdGRwX2RhdGEudGhyZWFk
X2FjaykpDQo+ICsJCXNldF90YXJnZXRfc3RhdGUodGRwX2RhdGEuc3RhdGUgKyAxKTsNCj4gK30N
Cj4gKw0KPiArLyoNCj4gKyAqIFNlZSBtdWx0aV9jcHVfc3RvcCgpIGZyb20gd2hlcmUgdGhpcyBt
dWx0aS1jcHUgc3RhdGUtbWFjaGluZSB3YXMNCj4gKyAqIGFkb3B0ZWQsIGFuZCB0aGUgcmF0aW9u
YWxlIGZvciB0b3VjaF9ubWlfd2F0Y2hkb2coKQ0KPiArICovDQoNCk5pdDogIGFkZCBhIHBlcmlv
ZCB0byB0aGUgZW5kIG9mIHRoZSBzZW50ZW5jZS4NCg0KKGJ0dywgSSBmb3VuZCB1c2luZyBwZXJp
b2Qgb3Igbm90IGlzbid0IGNvbnNpc3RlbnQgZXZlbiBhbW9uZyB0aGUgJ29uZS1saW5lLQ0Kc2Vu
dGVuY2UnIGNvbW1lbnRzLCBtYXliZSB5b3Ugd2FudCB0byBtYWtlIHRoYXQgY29uc2lzdGVudC4p
IA0K

