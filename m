Return-Path: <kvm+bounces-71547-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SCpQBuDhnGnCLwQAu9opvQ
	(envelope-from <kvm+bounces-71547-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:25:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B709217F53D
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:25:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EBAF5300E58C
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13EF537F75B;
	Mon, 23 Feb 2026 23:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YuYPOiIr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1868F3783C9;
	Mon, 23 Feb 2026 23:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889116; cv=fail; b=gt/jDOa7sc7zQNsfR0BvtJJZ5ArqbU1+G67/nEgVSkrOVlkvrFVLJHkUj86SGI1GGsNtbv0Zq40nCxdz+Qs5VCTJ/p480UgErPXfnA7FlEbtwD/+bZ5+/cPwclbhyLlqo0RJEmXgQi7iyqlG3azh/N7PZLl+olo9292kPazaI38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889116; c=relaxed/simple;
	bh=L5mYqxVxWypemg70BJJVe8eEAxGfOVIhY3ddu0yszcQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X+TbA8dDYgeR1KXtxFrI20oa7DXgXpqFEQ/KZ9rhDU3sld2LGRUq0qbpP1vyWIRPXBuaSNBGgmL80Q0ZMpmwjYNGyVncaLbPzwuQzaffiePpcMheU4oy6dHWhTstxLW6YeSAcweo0WVpVNdzYKsd/aLq5h81tmhJBYObhtrSImE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YuYPOiIr; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771889114; x=1803425114;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=L5mYqxVxWypemg70BJJVe8eEAxGfOVIhY3ddu0yszcQ=;
  b=YuYPOiIr+L1MVqLVAXLVOISgkrPUH0rlQzottut5sJLYYECffkcdXEt2
   YFKrmKVOAQ1XjZpI51CFrRbX51LjjAzQjZC++Toy4X51SEOG0qMsCgI9k
   u2lG3/atqf7MyYlaqvzRAJQAIcLNBoOZiWgNbr1uqo7RGxEwszZ5Az8NV
   fl+5Z6WPbBUMTpktLbvx48XM8+4B/zAhcs/ycQg+P4NBYO01j/DO6Noyu
   x3CHbVtqc8o9Qj+01rLO80evlgk2nnmYdPmNmiMn+kG3ObQCWzdRQr3bY
   6M/nGGksr/j7CQ+8LVlyi5J8J3EmG9ZewUmw9wGLR7VxgjjmIEuZtRtgz
   w==;
X-CSE-ConnectionGUID: Gbzvdo1DQBqtYYdBcJe00w==
X-CSE-MsgGUID: Dl7hajynTzWOkbJT6d2Vvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="60473222"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="60473222"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 15:24:59 -0800
X-CSE-ConnectionGUID: dgMaezeaRUy9k9tyUEnIIg==
X-CSE-MsgGUID: UT+1zp8XSG2C3OF+Cb2pIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="214096714"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 15:24:58 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 15:24:58 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 15:24:58 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.1) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 15:24:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o+ANYMGU5u6bns7xI8srlK7cVIa1zEIlE/Phn9hbREjp8SDc9XbKARyiIFuAFKebmv4m+oTUFbtXwGxfn0WhpEUxz4pIUtTNMyO8uYRSAvfeALFtJNpGzrDJr8zWgiAcVLuROukfpYrnXI3e5jddb5bZl/L57DQ9bwBnOXOan9X7aQo02lJ+zd9mxxklJWmKbGtt3crrPSTGi0MAxUZ3fIe5MeXZqDCgtgxMN/0YKuinVpmnJo5Y+O83IfyMPdX6zYkJwt9snGJNoMChDUJKRiAnhStSt0epa7T4VwujPtpItA+q7jHCyBVxTCX+fJr9dzPzZmru+NEyV0LMLD6EJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5mYqxVxWypemg70BJJVe8eEAxGfOVIhY3ddu0yszcQ=;
 b=Cd9QgX8XrFikFvNZsMTxP9OVwEy795lzpbPSpyxJqTvsHo69r75e5qygC+QMatw3o4MCvlTqsemmw6LVqJWILiw7vbzt2eKvvt1J5Y9Ax0x5BCXsIFNek7uSAWiPRbnH4d03Qm6Gz9VkRucUaWMlag65rNmbROKEp47UfeZEQWLJvPFs0cTQdyY4DxaF4MeXFObKWGIfE6S85zR6mi0SzdA8uyNJv5i/DxcUNzcbRalRbfmP8AIXHUlLQoEAjVCy9JmzbxjzGu/v4KSai59mo9ZtAMBtyyrPxB/iGOlLLWakJThu6dkw/wKZmTF+zeRg9en2yWYyl2RzYTkawiWamA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7770.namprd11.prod.outlook.com (2603:10b6:610:129::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Mon, 23 Feb
 2026 23:23:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Mon, 23 Feb 2026
 23:23:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Topic: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Index: AQHcoTXoP5tM7QU8XUq1kA8eNcmjl7WMShkAgAALQwCABJ94AA==
Date: Mon, 23 Feb 2026 23:23:41 +0000
Message-ID: <f4dc2f2fd2c2201c9e5d141c0c83c203e1f57975.camel@intel.com>
References: <20260219002241.2908563-1-seanjc@google.com>
	 <7986057373abcb20585c916804422a13f51d5e55.camel@intel.com>
	 <aZkBBlrMd2-P-kKK@google.com>
In-Reply-To: <aZkBBlrMd2-P-kKK@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7770:EE_
x-ms-office365-filtering-correlation-id: 3c550ac3-2bb6-4741-0c53-08de73329498
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OE9GcHVvby9zV2FvL01mdXo1SkJ4Z3QvM0ZlT0FtWUo3V0N5Z0lIS0Q1RkhT?=
 =?utf-8?B?WXZQT2grTHl2RmEvck5JbGo1a3dUcnJFZTREck5BWEVjZXNMZmZ2aGNTSTZF?=
 =?utf-8?B?Yy83dHB1Vm9UZlhLcFdmbUp4dnNZNHlqa3BGTWVETEc2WnJDVHhMUzl3eDJj?=
 =?utf-8?B?SHhpNWZHcDRhcWV4Yk8xWnVZdkt0dzh3aHpzdm1NdWVtN1Z0UTRJZERMN2pW?=
 =?utf-8?B?ZXBVTDFRMER6MzR6NG42QnRBWUtIdXJ3UmtqQmM4T1JNKytKS25yQk9MOVdW?=
 =?utf-8?B?bjFQRDBjdnZkdUdwYTZHZC9ycjhYc2JZaEFVbFFraTFCbUNzMzZ0RFRhendT?=
 =?utf-8?B?SzZuSWhHUjM3WFpqcEYvSENOSERpa0w5Rm5VZVJNRENKT0tRUEFGZUFzclIx?=
 =?utf-8?B?V2lPTUUxbFc1SzJwOTZvakRaOFIwVU1ONHR5RFVyZUFMaGkrVTJHUENrYVpS?=
 =?utf-8?B?ZDZneklNcU5FM1Y3RTVwZ1JHQjZhMGkxcDVWR0RwZXdPaXNjaUZmZWZURzZ3?=
 =?utf-8?B?QXNqZUhzSm9zc0wyck9HWUY4WXhTU0huL3lqb2FKa2dDL0Q3MGYvYmFaMzV4?=
 =?utf-8?B?ZmEwVU9EZU41UitEQlNpV1NqbmE4SnVXRHFiSWZIZlN6NXBjRmJpK25OSnk2?=
 =?utf-8?B?SzB3dTJzRDlsWU5RNTJKYmxVVE1aRDE5Nmk2Z1dLN2ZsRGNWRW5jeTFUQkpJ?=
 =?utf-8?B?ajhnZjArNHVUenEzVTJIQVNJNDJZd2hWUjNYSnZwNUlyTjV6T20yQ2h1K2xS?=
 =?utf-8?B?aXYzYW1ncWlXNWRmOGZhV3luZTJyaXJUNCs2dFZteTJ6Q3lqQVIwZys4N1JG?=
 =?utf-8?B?ejBCeE5KVFFUdXF3YlJWMjF0SnZQQThPWGN0NHN4aHUrVU54VC9EWkhwWHRy?=
 =?utf-8?B?L3ExL1dwRVhpbncxNmVuNFRFRHJYamRZbWtOaTBjMkgrc0diNXBldXAvVlAw?=
 =?utf-8?B?Y3hVQytIOHF2dXRSSmtTVjlUS1pJcnIyWC8wWjJGRnY0ajREWUJraUNCemVZ?=
 =?utf-8?B?SGxxa2FrZEcrMHUvTjZ4aGJFVDVvQ2F0bFNzRmRVRU1GWHVSTW02SUhGV1hD?=
 =?utf-8?B?dWJXaTNFWlc4WVlDN0ozOEZiaVRZa3ZuczBFZGduNzBXckRkUVYzMXVSVjJa?=
 =?utf-8?B?RGdSUUNJREpJK0NRVVBYMjJEMjAyWVdqYzNLZDdyZGFPYWhTN01JOEt2STRR?=
 =?utf-8?B?TDhWbm0yMFJqSmtaT205MUxIeTg5VzJHdVdQZEsvUDdiY2FrZjNqdTVFOVpu?=
 =?utf-8?B?WEc3Zk0vQS93TDV5TUozLzVnd0hhVlRmTDJNbHgvMDliYzlTMnVSSkM3WHdY?=
 =?utf-8?B?cjc0MnVJaWJITFVKeEtUVTRucXpIMnBJMjNPREliQVJ1RkdydUxlK3dBYnM1?=
 =?utf-8?B?bEFMK244WW1nV3c3Z21ZK1ZLQkI5ZlEza21KekhFM1ZBZFlTWExPd1dhWEty?=
 =?utf-8?B?RlBCcU9iWWE1Yzd3N2FtQ2M4bFZuWFkvelpYbERZSXV1VWpLV3U3QkFud3RV?=
 =?utf-8?B?anVYd2N0MUpwY2xnKzFpNlNIQUFnUTJaWnZhdEZxWjBSUGhkQkllMGRJRlNw?=
 =?utf-8?B?Nmdwc2xpR2ErTTNJQXUxTHBpdHFyWUNaZUJMWnAyYU5NWmpNZDRwZTFET1Uy?=
 =?utf-8?B?VUE0ZnhvOUN2NTVQRTltMFJ1b1pYSldRc0tqeUFOaFhVYXAxaEpjdGtFMWpV?=
 =?utf-8?B?eUJNUytIcUhlMEdXUFdhQVhOOEtvKy9uc2hUVmJVQ2lXZVg0NkkrTXRwQ1VB?=
 =?utf-8?B?dUNPK2NMTXR1WnQxc25sUkZHZkQ2YjNHS1JBUzNncVlGdTR3SXQvRmxDb3Jq?=
 =?utf-8?B?VERWdjNyT3lLUy9QL0diYklnelF4UjZHWXYyeUFvVmNhc3BFZnlLMGwzcCtP?=
 =?utf-8?B?VWMvU1l4OFZYRnBoLzJ2ZVNaVk45akl3ck9QR3ptcWlLUFVHUlJFeVFoaHBO?=
 =?utf-8?B?aTZtMzdOYWM2WHNDclpiM2xFaFZ5Q2NUTmROdVNNZzZuUmxQUGxadzA2aXpq?=
 =?utf-8?B?YjJmTzZzcjI1YnV3YWZpN3kyMmNWRlM0WUJZb3E5bE1ZeXIwdldsTGpVMHNq?=
 =?utf-8?B?NTN0UVZ2SmpnQlMyaDZkZXl0ZjEyOURxblNyTFFNTHJ0eVRTRTUwbFBEYkRz?=
 =?utf-8?B?Z25IUjMwc0VOWlk4YnZ6OU5iV0NIL2djYW80VU1FcDVmMTlmR1JMaDR0RTNL?=
 =?utf-8?Q?RJYOKwYF4AGJvhXtQ/3StCQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wkc1ejgzQ1RTdDE3bVpKcnZFZXNEeTl4eGMwdXZIaUdpMmdqc3prVmxtc282?=
 =?utf-8?B?U3JsbWVBSU5EWjZwellSeCtOcDNkbys5REVQbllCWXJDb0lvMUt2cGtTUGtk?=
 =?utf-8?B?MzIwQUg2VXFiMnlGRlp2WTJyU0poOEN6WEJ6eWl3eGsxRXJFNWFDTlZoa29F?=
 =?utf-8?B?R3d5UWhyZnJjQ2JISExDQkJJZE81dTdQT3NOVFhkSDZtM09jNHhzTG9uZlBP?=
 =?utf-8?B?VG1HZ3p1WE1jQVBSR2FOT01lOTE2alpLT0RzYWRhd0xQWm02eWl3Zzh5aTRy?=
 =?utf-8?B?SVZlL3hoQkhxZmdYM1VzR2VLQ0RYbHNOaWM2WWVFME9ldmJOcXlxZDhhNEdt?=
 =?utf-8?B?cHp0Z3hHQ0hZYnhIK2Z1K3ZFM0tJbmFTUDV5SzFybmZUTDkvd3FZdVlsZi9J?=
 =?utf-8?B?STQyNUx3U1VGSUdkQmYwVFRhWUlPemM3YmZQcEJkS0NaUWJLdzQxY1BPZVA0?=
 =?utf-8?B?RG1sZjFJSFhkVlJhVFdrVDBLZ2RnQmhUYnhzdGdPVEVUVWh3bkFBUitZbnNJ?=
 =?utf-8?B?ZllyOTB2TWc1aFVnNmpDK3dKcEh1cUlJODJnZ050ZXFWUnVzS29ndkRJUm54?=
 =?utf-8?B?czh5UEJ1dml1UStPZVkwcWVjTjlJS1JNaVJOek9pa0R0UjljNEZpbTVHSWpt?=
 =?utf-8?B?ckNSdGdIamczN1o4WDBMdU1jYWk5OXFuNGxGS3UzMHluM1pIejMrY1pvZHhI?=
 =?utf-8?B?YURjL1pKaHU4YmxZQ3ViKzdXZ3hnY0RPUU5UVGplZU9DczJ4ekU1dDNEMmMx?=
 =?utf-8?B?aE43QmZCM0Rha05lTkEvQ2pyckMzS2R5VkRPOHFJTTZHOC9LU2dLWldta3c1?=
 =?utf-8?B?T0pnM0NLTW9MZHVOSVpWZm42TkgyeVVLQlV6ZFJXbklPcFhoU0lUaXpxajVY?=
 =?utf-8?B?czBkOW9Ib04xNEZTTU44b3hhaFF4RGJIdWYrL0ZBT01Sbm1RTElXYlJnYThO?=
 =?utf-8?B?UW5VRFNwaG5icDBHT1NycjF2bzVYSUpFcE5Vb1dYVjlzVXkwTUQzQldLSURM?=
 =?utf-8?B?SFU5NVNYdkNOUlVjMkhTb0VRb2tGblFlcHZBZWZGditSZWsvRWJGN0ZsY09I?=
 =?utf-8?B?TTZtWExaZDdQekRiQWlGYjJuMGYzdzhESjdLd2NvTStaTXNlVzV2bTZPKzFO?=
 =?utf-8?B?SzBNZFh5SkNGV2VPekUvMzZ6K2hzRTJUSjBSZGRYMjZjV1YrSytXTjAxMGFo?=
 =?utf-8?B?TlhDMmhOdmxtQXg0ZDBZbnpzM0luVDZzQy9qL0oyNVZ3KzZaWmF3Z3dKRzBL?=
 =?utf-8?B?SldnWG9kcndTVWFOdFluU2ZlNE9hSU9Wa0w4Nmx0eVF3WlF4eXI3S21pWlhH?=
 =?utf-8?B?Vm5ZOEgxQnAxV1NzYWJtMTZnTHRVaUN0UndHU21LbVMrV0ViN2NFMElQN1FR?=
 =?utf-8?B?S21WcVlmRUhjOVQrQWt3TjNRejYrVWQveVd6cmQ3Y1NNcGpKSzZVSS9MOWlQ?=
 =?utf-8?B?SE1DemhYRlFHOFFUN1FWMk1rOU5LaTJRamFHeFFDT1VMZld6cVc0MDBlV3VN?=
 =?utf-8?B?MmErTmxRMzdqV2N0NTZsbElZeWYvYkliY0xRZEx4WG5FTEhTaFNiOFpCVTFv?=
 =?utf-8?B?VDRWb05lTnd5M3l3NjJFZGhnMkZYUnFBQy9UNU1jbTRMRDg4UmVjbGNpM2Er?=
 =?utf-8?B?Y0NkR2FUR0VxN200OW42My9UWVBRS0hGZVpvT3ljMnY2TlowN21STERwa2dz?=
 =?utf-8?B?ZnJyeHNoQWxiM3BlSm0rdlkyVEtNNHMxK3BQQWJHbkNsV0R1SnkrOGRMS2hX?=
 =?utf-8?B?ZjFCZkhCckhRSENweUoxazRTRWRuQ202ajQ2M00zaXNCMWFxKzQ3Vmlzelc1?=
 =?utf-8?B?UHlLd25OeG5nRHNYQmVtdk9GNW0xZHprV2FKTmg2Y1VGRGlDM2NUOXZKTExz?=
 =?utf-8?B?cDBsOVg3WkVmU2owakFSMXJhNURlZUZpUGFQTUNYQkJUZ2lrUHlOTk5vVkQ3?=
 =?utf-8?B?R05WeHErdWVoS3IwaUh1WW91ajhoS1lEUHZ4TC8wNUVEU0VMWmt1Vkd1R1lQ?=
 =?utf-8?B?NURtQUpFMnFveWZsREdpa29IS3RHZ3dra1FwdnRUdGtXZXBZUGRHeUFBRjN0?=
 =?utf-8?B?bVp5bENSTUFveGhwbTQ1SVFqclhPTzZZWVZ2QXlGZkdMU21CSlZ1WjBwdlps?=
 =?utf-8?B?M2tmekl6OVVyZHFNNVVsUlRuTEQyTGdZK0wzczFISEdIMEo0dUNLMHdvTVNB?=
 =?utf-8?B?cUJiQlFHb2IzVmpCZUNuVmJKZlBWZGVxZ1Uzdm5XK3lhKys3MmtvdDR2V1hM?=
 =?utf-8?B?TzViSkJFcFp3RTh6eHJjYnRqdEVOSzhpSVcxaUJDN1JBS2lhSXA4STRLNzJn?=
 =?utf-8?B?RVUxQlVvTWVLR3Q3YnZPTHdXK1pjZyt6TWhscmZhMzJmNk9oUEgzMWtObCti?=
 =?utf-8?Q?hZaMoL2EPxpE7iAk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81BA3FFF2215C04484E3B84DECE2D031@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c550ac3-2bb6-4741-0c53-08de73329498
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2026 23:23:41.1651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3mfVdAEOflAf+wr82BoyiDq2SW7bPZs8Wt9xrr+YaCyyaBM5Ic+PaZ9dYSJH8prJ7WLonTDtDNnVA3e+MneT8mWBxo8vqM+FARpbzCxOVPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7770
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71547-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B709217F53D
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAyLTIwIGF0IDE2OjQ5IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBTYXQsIEZlYiAyMSwgMjAyNiwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBXZWQsIDIwMjYtMDItMTggYXQgMTY6MjIgLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiArc3RhdGljIHZvaWQgcmVzZXRfdGRwX3VubWFwcGFibGVfbWFzayhzdHJ1
Y3Qga3ZtX21tdSAqbW11KQ0KPiA+ID4gK3sNCj4gPiA+ICsJaW50IG1heF9hZGRyX2JpdDsNCj4g
PiA+ICsNCj4gPiA+ICsJc3dpdGNoIChtbXUtPnJvb3Rfcm9sZS5sZXZlbCkgew0KPiA+ID4gKwlj
YXNlIFBUNjRfUk9PVF81TEVWRUw6DQo+ID4gPiArCQltYXhfYWRkcl9iaXQgPSA1MjsNCj4gPiA+
ICsJCWJyZWFrOw0KPiA+ID4gKwljYXNlIFBUNjRfUk9PVF80TEVWRUw6DQo+ID4gPiArCQltYXhf
YWRkcl9iaXQgPSA0ODsNCj4gPiA+ICsJCWJyZWFrOw0KPiA+ID4gKwljYXNlIFBUMzJFX1JPT1Rf
TEVWRUw6DQo+ID4gPiArCQltYXhfYWRkcl9iaXQgPSAzMjsNCj4gPiA+ICsJCWJyZWFrOw0KPiA+
ID4gKwlkZWZhdWx0Og0KPiA+ID4gKwkJV0FSTl9PTkNFKDEsICJVbmhhbmRsZWQgcm9vdCBsZXZl
bCAldVxuIiwgbW11LQ0KPiA+ID4gPnJvb3Rfcm9sZS5sZXZlbCk7DQo+ID4gPiArCQltbXUtPnVu
bWFwcGFibGVfbWFzayA9IDA7DQo+ID4gDQo+ID4gV291bGQgaXQgYmUgYmV0dGVyIHRvIHNldCBt
YXhfYWRkcl9iaXQgdG8gMCBhbmQgbGV0IHJzdmRfYml0cygpIHNldA0KPiA+IGl0IGJlbG93PyBU
aGVuIHRoZSB1bmtub3duIGNhc2UgaXMgc2FmZXIgYWJvdXQgcmVqZWN0aW5nIHRoaW5ncy4NCj4g
DQo+IE5vLCBiZWNhdXNlIHNwZWFraW5nIGZyb20gZXhwZXJpZW5jZSwgcmVqZWN0aW5nIGlzbid0
IHNhZmVyIChJIGhhZCBhDQo+IGJyYWluIGZhcnQgYW5kIHRob3VnaHQgbGVnYWN5IHNoYWRvdyBw
YWdpbmcgd2FzIGFsc28gYWZmZWN0ZWQpLsKgDQo+IFRoZXJlJ3Mgbm8gZGFuZ2VyIHRvIHRoZSBo
b3N0IChvdGhlciB0aGFuIHRoZSBXQVJOIGl0c2VsZiksIGFuZCBzbw0KPiBzYWZldHkgaGVyZSBp
cyBhbGwgYWJvdXQgdGhlIGd1ZXN0Lg0KPiANCj4gU2V0dGluZyB1bm1hcHBhYmxlX21hc2sgdG8g
LTF1bGwgaXMgYWxsIGJ1dCBndWFyYW50ZWVkIHRvIGtpbGwgdGhlDQo+IGd1ZXN0LCBiZWNhdXNl
IEtWTSB3aWxsIHJlamVjdCBhbGwgZmF1bHRzLsKgIFNldHRpbmcgdW5tYXBwYWJsZV9tYXNrDQo+
IHRvIDAgaXMgb25seSBwcm9ibGVtYXRpYyBpZiB0aGUgZ3Vlc3QgYW5kL29yIHVzZXJzcGFjZSBp
cw0KPiBtaXNiZWhhdmluZywgYW5kIGV2ZW4gdGhlbiwgdGhlIHdvcnN0IGNhc2Ugc2NlbmFyaW8g
aXNuJ3QgaG9ycmlmaWMsDQo+IGFsbCB0aGluZ3MgY29uc2lkZXJlZC4NCg0KQ29uZnVzZWQgTU0g
Y29kZSBtYWtlcyBtZSBuZXJ2b3VzLCBidXQgZmFpciBlbm91Z2guDQoNCj4gDQo+ID4gPiArCQly
ZXR1cm47DQo+ID4gPiArCX0NCj4gPiA+ICsNCj4gPiA+ICsJbW11LT51bm1hcHBhYmxlX21hc2sg
PSByc3ZkX2JpdHMobWF4X2FkZHJfYml0LCA2Myk7DQo+ID4gPiArfQ0KPiA+ID4gKw0KPiA+IA0K
PiA+IEdvc2gsIHRoaXMgZm9yY2VkIG1lIHRvIGV4cGFuZCBteSB1bmRlcnN0YW5kaW5nIG9mIGhv
dyB0aGUgZ3Vlc3QNCj4gPiBhbmQgaG9zdCBwYWdlIGxldmVscyBnZXQgZ2x1ZWQgdG9nZXRoZXIu
IEhvcGVmdWxseSB0aGlzIGlzIG5vdCB0b28NCj4gPiBmYXIgb2ZmLi4uDQo+ID4gDQo+ID4gSW4g
dGhlIHBhdGNoIHRoaXMgZnVuY3Rpb24gaXMgcGFzc2VkIGJvdGggZ3Vlc3RfbW11IGFuZCByb290
X21tdS4NCj4gPiBTbyBzb21ldGltZXMgaXQncyBnb2luZyB0byBiZSBMMSBHUEEgYWRkcmVzcywg
YW5kIHNvbWV0aW1lcyAoZm9yDQo+ID4gQU1EIG5lc3RlZD8pIGl0J3MgZ29pbmcgdG8gYmUgYW4g
TDIgR1ZBLiBGb3IgdGhlIEdWQSBjYXNlIEkgZG9uJ3QNCj4gPiBzZWUgaG93IFBUMzJfUk9PVF9M
RVZFTCBjYW4gYmUgb21pdHRlZC4gSXQgd291bGQgaGl0IHRoZSB3YXJuaW5nPw0KPiANCj4gTm8s
IGl0J3MgYWx3YXlzIGEgR1BBLsKgIHJvb3RfbW11IHRyYW5zbGF0ZXMgTDEgR1BBID0+IEwwIEdQ
QSBhbmQgTDENCj4gR1ZBID0+IEdQQSo7IGd1ZXN0X21tdSB0cmFuc2xhdGVzIEwyIEdQQSA9PiBM
MCBHUEE7IG5lc3RlZF9tbXUNCj4gdHJhbnNsYXRlcyBMMiBHVkEgPT4gTDIgR1BBLg0KPiANCj4g
Tm90ZSHCoCBUaGUgYXN0ZXJpc2sgaXMgdGhhdCByb290X21tdSBpcyBhbHNvIHVzZWQgd2hlbiBM
MiBpcyBhY3RpdmUNCj4gaWYgTDEgaXMgTk9UIHVzaW5nIFREUCwgZWl0aGVyIGJlY2F1c2UgS1ZN
IGlzbid0IHVzaW5nIFREUCwgb3INCj4gYmVjYXVzZSB0aGUgTDEgaHlwZXJ2aXNvciBkZWNpZGVk
IG5vdCB0by7CoCBJbiB0aG9zZSBjYXNlcywgTDIgR1BBID09DQo+IEwxIEdQQSBmcm9tIEtWTSdz
IHBlcnNwZWN0aXZlLCBiZWNhdXNlIHRoZSBMMSBoeXBlcnZpc29yIGlzDQo+IHJlc3BvbnNpYmxl
IGZvciBzaGFkb3dpbmcgTDIgR1ZBID0+IEwxIEdQQS7CoCBBbmQgcm9vdF9tbXUgY2FuIGFsc28N
Cj4gdHJhbnNsYXRlIEwyIEdQQSA9PiBMMCBHUEEgYW5kIEwyIEdWQSA9PiBMMiBHUEEgKGFnYWlu
LCBMMSBHUEEgPT0gTDINCj4gR1BBKS4NCg0KSSBhcHByZWNpYXRlIHlvdSB0YWtpbmcgdGhlIHRp
bWUgdG8gZXhwbGFpbi4gVHJhY2luZyB0aHJvdWdoIHdpdGggdGhlDQphYm92ZSBJIHJlYWxpemUg
SSB3YXMgdW5kZXIgdGhlIHdyb25nIGltcHJlc3Npb24gYWJvdXQgaG93IG5lc3RlZCBTVk0NCndv
cmtlZC4NCg0KPiANCj4gPiBCdXQgYWxzbyB0aGUgJzUnIGNhc2UgaXMgd2VpcmQgYmVjYXVzZSBh
cyBhIEdWQSB0aGUgbWF4IGFkZHJlc3NlDQo+ID4gYml0cyBzaG91bGQgYmUgNTcgYW5kIGEgR1BB
IGlzIHNob3VsZCBiZSA1NC4NCj4gDQo+IDUyLCBpLmUuIHRoZSBhcmNoaXRlY3R1cmFsIG1heCBN
QVhQSFlBRERSLg0KDQpPb3BzIHllcyBJIG1lYW50IDUyLiBCdXQgaWYgaXQgaXMgYWx3YXlzIG1h
eCBwaHlzaWNhbCBhZGRyZXNzIGFuZCBub3QNCnRyeWluZyB0byBoYW5kbGUgVkEncyB0b28sIHdo
eSBpcyBQVDMyRV9ST09UX0xFVkVMIDMyIGluc3RlYWQgb2YNCjM2P8KgVGhhdCBhbHNvIHNlbmQg
bWUgZG93biB0aGUgcGF0aCBvZiBhc3N1bWluZyBHVkFzIHdlcmUgaW4gdGhlIG1peCwNCmJ1dCBu
b3cgSSBzZWUgaXQgaXMgdXNlZCBmb3IgMzIgYml0IFNWTS4NCg0KPiANCltzbmlwXQ0KPiANCj4g
DQo+ID4gU28gSSdkIHRoaW5rIHRoaXMgbmVlZHMgYSB2ZXJzaW9uIGZvciBHVkEgYW5kIG9uZSBm
b3IgR1BBLg0KPiANCj4gTm8sIHNlZSB0aGUgbGFzdCBwYXJhZ3JhcGggaW4gdGhlIGNoYW5nZWxv
Zy4NCj4gDQo+IFNpZGUgdG9waWMsIGlmIHlvdSBoYXZlIF9hbnlfIGlkZWEgZm9yIGJldHRlciBu
YW1lcyB0aGFuIGd1ZXN0X21tdQ0KPiB2cy4gbmVzdGVkX21tdSwgc3BlYWsgdXAuwqAgVGhpcyBp
cyBsaWtlIHRoZSBmaWZ0aD8gdGltZSBJJ3ZlIGhhZCBhDQo+IGRpc2N1c3Npb24gYWJvdXQgaG93
IGF3ZnVsIHRob3NlIG5hbWVzIGFyZSwgYnV0IHdlJ3ZlIHlldCB0byBjb21lIHVwDQo+IHdpdGgg
bmFtZXMgdGhhdCBzdWNrIGxlc3MuDQoNCkkgZG9uJ3QuIEFzIGFib3ZlLCBJIGdvdCBjb25mdXNl
ZCB3aXRoIHNvbWUgd3JvbmcgYXNzdW1wdGlvbnMuIFRoZQ0KbmFtZXMgc2VlbSByZWFzb25hYmxl
LiBUaGUgc2hvcnQgbm90ZXMgYWJvdXQgdGhlIHRyYW5zbGF0aW9uIGlucHV0IGFuZA0KZm9yIGVh
Y2ggTU1VIG1pZ2h0IGJlIG5pY2UgdG8gaGF2ZSBzb21ld2hlcmUuDQo=

