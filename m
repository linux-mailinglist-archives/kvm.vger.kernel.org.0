Return-Path: <kvm+bounces-56375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E232B3C518
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 00:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F8993A2966
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A21E2BE7A1;
	Fri, 29 Aug 2025 22:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jywtAvdy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D6128A705;
	Fri, 29 Aug 2025 22:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756507184; cv=fail; b=mli/dC9sAo44B04am47tMfTsLuWxMZdcP0rdWCld9KGgeCpsw3lW1Tw7dcpmrroExDTk0mzutMOitq0NQd3xRkZAdXkTPTse9tjEpOfFUUScBdRrdFS2ALApZzl4gDNbmBzXs2K2nelWsbOr4k/98NpXrLQaxx81z1NwlRC1HEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756507184; c=relaxed/simple;
	bh=6aaGBJDFhfn1hHAM9iUOaVDDdFWK9P2LXpvc20z3RAc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lt4jrhCfCb0uYQztpjjep4VrtFrzfk82RPmBht07/eIhEFJUnRUMOVP660+Zz22iMWAOsm8nIpkI6Rvy2wfHJEzZQzt4jt7c3SVowNzHL4ooAUTmeHM1mtyg030Mpn8ejh7r4zr1zxIpKzTv4paxfTT1/zdufml9zK5fVpkEFdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jywtAvdy; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756507183; x=1788043183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6aaGBJDFhfn1hHAM9iUOaVDDdFWK9P2LXpvc20z3RAc=;
  b=jywtAvdyyczPWL362Br3KEVAZ0EJ4FYm636mFPl2++wYqSNfZUY8VPPd
   SKzwtkPFv2lWTJdeNHvracXuk4wKyunPpElWitp5Dg6QhlzTPnJkGT/jz
   gaouW4jm8HTkO2GEqknHaJd3SuhLMw/lLgJBhEg1WkC3j5UWHdKuC/ybu
   8eYzW7qqC7f3AR6MxKAu77kVLR/xg8EaW9DNG4JPfR/XL/4ZCMOp57V1h
   U7uANeGusbiGfwXg+S6Oce0arBQwNfMAex1KeoMnWzPS4ky4L/443dRRT
   8/e1w+7d1vP48ahkbywdFqAiy9WuYxhKq0zT0PSPxA7KrgneLJPm2U8dA
   A==;
X-CSE-ConnectionGUID: XR55sPtlRxqOxGDzMDgmSA==
X-CSE-MsgGUID: sV+OC54DRwygiTwN/9JJNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="46371001"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="46371001"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 15:39:42 -0700
X-CSE-ConnectionGUID: UB8jaKARTaONtj0a6i6asA==
X-CSE-MsgGUID: Ht5uNHH1RFGgMA+qUhM7jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="171285869"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 15:39:42 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 15:39:41 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 15:39:41 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.63) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 15:39:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uVyggimcgpz83P268wNmPOmlG3uerCylDwsqDQSymsPMavQJhiO3QwrY5I9xesrM/wwmRAKGYXWIkTVHpfF3iht95VEtMxITjUAUP9BIWd+3w7D1BsZ5w5xan6H4WmWMoQSMZESQyqAFwJBELjmLcZdszmCLIz4p753ttiZuIlOqYjykE3Bj5GRxhZ1JJP8Gs528v/tTtT3ROt6kssgDpsR4o71IIje4dbDvcIJDe9LZEqFVAcGn5cJW/9Q7/wNXjhYs6BAB/4c0Vu0JHIh6ZfRC6Ll8hkkGF9qFJ34z0KFtZq44HOopXnXenO/jR79KmRFnzcEQlCtlGeIxwjHr7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6aaGBJDFhfn1hHAM9iUOaVDDdFWK9P2LXpvc20z3RAc=;
 b=xFkXLoIEKRM0LDVhsVa0OKHGb6jIATncqtxUXjjSncx+MZO0elZpA+yEJW108w7mKECsABiBKQqY7mq+seJu5NsPinWrZunK3ontKS6rLasi5dcJeGoQKWBsPoob7NqWqYzSuQYmMhANMWS5/SSplg23SzriwP2HNazL/WMU2BvequgSjD3z8PnUJI4z1cVtsdeIzIfT5SE9V3G15K7PUTlP3t17ROT5tj9wWcxDUz7pljUVoCkCe0AXiScFMNdLFOD2yBF62GxKxnXETHMuPbD40mogPCEYUkKX173DyDG1i+uMPuIBXHeGzayY5HwmvxRhR4C2llAXQ43TFl+C/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7883.namprd11.prod.outlook.com (2603:10b6:208:3de::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.25; Fri, 29 Aug
 2025 22:39:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 22:39:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the initial
 measurement fails
Thread-Topic: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the
 initial measurement fails
Thread-Index: AQHcGHjSRjNmRiPKf0OfM3rq5B2s2rR5SfIAgACnMICAACApgIAAKVYA
Date: Fri, 29 Aug 2025 22:39:33 +0000
Message-ID: <c8352e1a76910199554bce03a541930914ff157d.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-13-seanjc@google.com>
	 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com>
	 <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
	 <aLIJd7xpNfJvdMeT@google.com>
In-Reply-To: <aLIJd7xpNfJvdMeT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7883:EE_
x-ms-office365-filtering-correlation-id: 50c1b30d-85a8-4d6b-1b65-08dde74cecb2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bEFHUjVSTkZOMklqTDBuN2JPRVd5eXd6WXJqbGpBd2pzaXNNUGFnNE9xVEZT?=
 =?utf-8?B?OEZIbXpGc1MzNEt2OEhSNnQ2dlJGeEFNbng4NjgvM2psM2V2NHZSVmxFbEpT?=
 =?utf-8?B?N1ZGZXFyTXhaK1drS3krYXNVTXp5ZndkcEJZTWlLa0tCaU1zQit3bWJVTjM1?=
 =?utf-8?B?ZEcwMTVxU1FxMXFzdHVCeUxRUktGaWtoSS9HLy81aXdvUlZNWkxNYmx5ckhP?=
 =?utf-8?B?R2YvbnJnbzB4OEFsRTMvM2Rra2xZVE1wTXB6TUxvZUcyUFBZMjNTTm42Uit5?=
 =?utf-8?B?cXFJc3N0dzR6WnNRWjlRY0kyREdLQm5GWlpSTU1tREVTTTloMTRERXNSWEl5?=
 =?utf-8?B?MEEvamdVZVRhQzZ6L2IxQ2l6N3hFODF2N2owQlVEUWlKb1dzRjltaVV3cmE3?=
 =?utf-8?B?a0d4OXNId3VPQVNvcjIwTSthL3UzeStxRW9WNU8zbFB2YWNKbVFhU2d5eE1j?=
 =?utf-8?B?Z3NYbzRidmFjVndWeFRaY0V4b2FoMGdsdHF3bDNUcVJpdEJPRGlPQTJZQjVV?=
 =?utf-8?B?cTdDL1pKd20xYXJSZ1ZLNkdqU1VqdFBYSG4wVjhESnZnYkJBMlVGY3RSTEZT?=
 =?utf-8?B?MWdiUmIvTGI1ZE9oaU5vUCs4bEd4c0lYZEtXT0xjd3FSZjhucmJOVCtiRTRQ?=
 =?utf-8?B?U3k2U3VBU0hMUmZscDdobUh0U3d2VFBpSDNRQTMreDhVOC9uSGs4bDJQempO?=
 =?utf-8?B?aG52Wnp0c1o3ZUtsU0VDSTV0dU04cFRTdVVEZnB5QitxbXhRRlk2OW0yUnZJ?=
 =?utf-8?B?L1cwbGF1Ni9mMEE0TTF2c3F6NHh0Y2laU0llbTd6d21kV1VIa1p3SnpqMXQ4?=
 =?utf-8?B?SGlEb011WnZmd08zRERKdGRUTG5tRmRhL2JiNHdlWnZlMk1zN2N3MkRiWjJU?=
 =?utf-8?B?MkYwaDFieEFKUlVQRVNDSmtjWGtQYW5yaVU4TDkvTVhhUXE1NkhDQmJjWWVV?=
 =?utf-8?B?bXhKTVA4ZDN3WnhFcThLa2xrYm1qc0Fxb0g0dThlZG1vdTdwUnN0UWVza3gy?=
 =?utf-8?B?ZDRjU2tFaUsyWUVQS0t4TVN5YUkwa0VEc2tLVzJZQUxZNkdOOTliVkhCNUtY?=
 =?utf-8?B?RGZYbFQwdm54U1UwY0pkWVR2V043ZkN4U3hZLzlIaWd3TmRuYmlvQnEyaGFu?=
 =?utf-8?B?MUliZDRaSGVtaDFZR0thVGFYem1pYlFtU0lyeVZWdHJ3aXVUTnZ2QlRtMzVk?=
 =?utf-8?B?RmsrVkd4OWlPZ2FNd3NqQ0pJNk1xL28zSW1QTTRjcjJtcmhXUFUxL0tlTm4v?=
 =?utf-8?B?by9DQkFhZys5QWxWekw5ZkU3SmVld1BSVklBUHdjeVNhMzdnbXNmQTJCUDNn?=
 =?utf-8?B?Zy9sNks2WXdZSHJSQU5zaVVrYlhWMUZKa0JSR1dOZFhtTXRBZU1HREFhNW04?=
 =?utf-8?B?bXBEM0ZIeXgwWTNHQmpadHZiZG9ZRk1Gc2VjakNxYUkvMytUZ0kyMWpNc1BN?=
 =?utf-8?B?ZVhaTURsc2swNXdVL29QZE93cVVnNFhobzBkcU1PTmt2MC9sSzdUaEkvRUpH?=
 =?utf-8?B?bk9oc2Y5MlYvazJKQm01ZlNmMzVOd29WZzFYUEtqcXlMMzkyUjRkM0JNem1i?=
 =?utf-8?B?OFdhR0E1aTdzbHV4QmxEaXozNW1OKzdWSEtyQUNqVDIyald2VGVkY2YyWGs5?=
 =?utf-8?B?blY3ZVI3dDMvdzhlMEQ3ZnRPRmxYYUMrQzNWeFQzQzdJa0hVN2dwWjhlcUZN?=
 =?utf-8?B?b0tlZkhiMU5waXlZM2htWm4wVWhrbld2b2htU1hpd3N4bkxTNTBzNzZvUDg0?=
 =?utf-8?B?MGtGa0RCZHMzVWh4blVERVBkZ3huSS84OG0veFZ6bEYyNTNvY1BhZmlrYXYz?=
 =?utf-8?B?a1VqTTdKZy8yWGtDUXUxY3c0dXM1V0tDVUMveFVzQ3JZdDBkeU9xb2k2MVQ3?=
 =?utf-8?B?d0lvaXFFSHpFV0dzY2R5VDB4Mm5xZitKOWx4R0Ruc3IvMHZvUFo4bU1oSXNu?=
 =?utf-8?B?VEZyMVJ2YlM1dWlYeWNXV0NPTStEWlJxTHJRdGRXU0pxaUc2eG9IUmhPSVRq?=
 =?utf-8?B?T1dlNG1XSStBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkZZUkJIY3F1anpOKzl4WGZDSFJqeEhwWmJuR3BjRldWblJWdFpONDRsY1c4?=
 =?utf-8?B?RFllWHhuT0dPMktpUjByZWhjV2N3VUQvNzlIVk1PdjBjVFRTckFDamhZdTBD?=
 =?utf-8?B?WVhQVVJCQjlWbTh6QkFuT2pxZUhzNWt3R3FOT2tTUVVTL1Q1bEpDaTZlL3pw?=
 =?utf-8?B?cTRYcmcvenk4LzkwQTNqTHJkdFB3K0E2MzdCRkJvZjlGSTlWaTFjUGVPTzZ6?=
 =?utf-8?B?NmgvNHd0MExJUEx6S3dvaUNmdlA3RjFxbDZUU21aM2lYOU5kWld3aXhKV1Jk?=
 =?utf-8?B?SlI3OExDQTU5VW9jM0txS0cyaG1QeVp1bW9zVHRmQ1FHbmk5REY4YkUxdU9E?=
 =?utf-8?B?cVc5NVVxd2hVQkJJOVFBM2hicWlFQnYyZFF3TmxVUi9obW9iYXVCMzZqbHBK?=
 =?utf-8?B?azhqSU1Gb3NoRWl3ODNaeTF6TDhqVkhTWWo5ZWlLYklLSXlKV1ZkRTBXbUJr?=
 =?utf-8?B?K25GYkZvNGxoQ2FMMC94Z3dhQVJUenJ1Si9yakxJVitvTk9kNXJOUWRUODhZ?=
 =?utf-8?B?KzRBUzhrOVAvbEtCd0pzc3NFd1lQSG5TbzlnOE52R3VaNThrVkZJbkxleHVE?=
 =?utf-8?B?aWtkdEpkeWRtWVg4dHNFaEhPVG9mRjd2QktWczh2WXJldnEyRTQ3VUUyR3hx?=
 =?utf-8?B?WlFsV1psaFlJT1JISGZEdEpGSG5UQ250VWlHcnV5ZDlSaThSeVhHNEZBUmxU?=
 =?utf-8?B?SlpoYzRPMG5hUVZrSG9RckM1eUFGRW9JUDVjMzMrMFdpQmd0WkpXbzZCL2Jp?=
 =?utf-8?B?K3FGMUdEWk94OUt4ZXMwaTB2UTF6Wm15MUVmR0FSRmt3Ylc2NGVvaEJ6a2JE?=
 =?utf-8?B?cEk4bWpzYU84Q0Zrbko4N3RRaWsxRnd3RWNlcVJKUUZUUDJ4bklZM1VTVDls?=
 =?utf-8?B?M1p6WGNjNWJ6ZkZKVXJHdWtsUHVaQjdya3FXKzFXcU9TSm1UK2VRT2t4cTlE?=
 =?utf-8?B?S3A5S04yMnQ3UVFSS3ovU2FIcHd4RDVrWVdNMzhSWXlYM0ZTanVzaWlPOWZ3?=
 =?utf-8?B?ZWhPd0hZaW85eTBwcS8ramp2ZGVxdVltQUVETm9HenhhSEMrQ0pmSmxkZG1S?=
 =?utf-8?B?Z2I0dzlsbG5jcnJjZkZPUmpTbFU1SVlrbVR6QlB4TGlYTnNmQUwwVFpRUGhv?=
 =?utf-8?B?Qm12UUoydWJHK3c3bTNWSGUyL2xrVkZaQzZjMVg3YmtPT2oyVVhGSHV0NVY2?=
 =?utf-8?B?YUM0QkFzOElhcHhmRzdua2luamQ3a1JGYm5FRDN2S1NJVGRndTljeG85eHhL?=
 =?utf-8?B?bmo3VHJibDh5TkY4dWk0a3FWNWlPOW1NTHduclM2VHFJSW1qNzBNVi9hV2xl?=
 =?utf-8?B?ejAwN011bVV6K3FpTi9NVlAwTGcyalRtL3o5ZHBTZGIvMFFBaURVYkNhZnZn?=
 =?utf-8?B?anM0Y1ZpMEtKRlRoZWppVHJZNXdUbGY5dlNpUDdRMzAzUFhHWnNhcDJSdkdE?=
 =?utf-8?B?S2VCVEhtR0VIdkZ0cUxnM1NEM3JFU0N5THViWFZvcWlWSnVSbm5VSHJRY0E5?=
 =?utf-8?B?VWtyUHJtcDA2MTVsOER2NnhoemtYQkNTb1BRakxJZi95RlJFT1pQWXBVRWRr?=
 =?utf-8?B?MEdMTVI1TmNIZ1RyaE14OGQ0TVQxWDZhdHNncTZKWlVYOEF4V0VvNWhVMm5E?=
 =?utf-8?B?OFhIUHlMaUhYVnFoMmx6TUFXUmw4K0xEUUJXTmgyS2hTU3VHLzRZNHlUM205?=
 =?utf-8?B?OTRKd0dBNGtqQzNhL1k4QTRXV3ZqQ3MzU2FMNjRKNXd2WnlnU04rL1FIWC9R?=
 =?utf-8?B?Yzd2b3QxOFQwL1B2cndXL0Z5VG5hS3ZVVzFMakNkR1FvVzMrK0p5OHRwTkJH?=
 =?utf-8?B?R2crZXVidW5MQ1cyY3hNM05ZWjhrcFJITU5Td2V0Y0FuZlh4aVFnOVZPSlUx?=
 =?utf-8?B?bFBzTGxuWjkxNjVKZm14M1l2T0Z2UVlvR0xNODZkaElBbmd5QWJGOXhOVUJD?=
 =?utf-8?B?ZVNKZkYwUEdZMW9TSFZlaCttb3gwK0JnYnoxWVpaTC8wTW1YMWpmSkhpUGdo?=
 =?utf-8?B?RTlsSUR4Q3hndzRTc242VTJBcjdPcXgvMU1seDAzaU5LUEEwYm53cnBNMzcr?=
 =?utf-8?B?cDV6Zk8xd2w0RGtEbHpDcmtNOFNYVURBZGdRK1dETllZTENrNWwwUGJJVkpj?=
 =?utf-8?B?LzRlblJ0aC83UVgyaTRtYS8ydVV0bDc3UFpNSm1GWUx6TTRFMlZJVGhsT29J?=
 =?utf-8?Q?pMBT0ZrCTiJgOKvL8W/pfZw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66143A32764A0946A8F7C8F2EB8F851E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c1b30d-85a8-4d6b-1b65-08dde74cecb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 22:39:33.0592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9eBV0zB9HabXr4e4JL9IV3lam5u6QEwVuaiQT3XG3rQQnJJ7zP0LyHJd5Ui66gPfmQHfiYs6XVoIwxYS5FXlBiRV9G3ymfHVOvHdb28ZBuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7883
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTI5IGF0IDEzOjExIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEkgZ3Vlc3MgdGhlIHR3byBhcHByb2FjaGVzIGNvdWxkIGJlIHRvIG1ha2UgS1ZN
X1REWF9JTklUX01FTV9SRUdJT04gbW9yZQ0KPiA+IHJvYnVzdCwNCj4gDQo+IFRoaXMuwqAgRmly
c3QgYW5kIGZvcmVtb3N0LCBLVk0ncyBvcmRlcmluZyBhbmQgbG9ja2luZyBydWxlcyBuZWVkIHRv
IGJlDQo+IGV4cGxpY2l0IChpZGVhbGx5IGRvY3VtZW50ZWQsIGJ1dCBhdCB0aGUgdmVyeSBsZWFz
dCBhcHBhcmVudCBpbiB0aGUgY29kZSksDQo+ICplc3BlY2lhbGx5KiB3aGVuIHRoZSBsb2NraW5n
IChvciBsYWNrIHRoZXJlb2YpIGltcGFjdHMgdXNlcnNwYWNlLsKgIEV2ZW4gaWYNCj4gZWZmZWN0
aXZlbHkgcmVseWluZyBvbiB0aGUgVERYLW1vZHVsZSB0byBwcm92aWRlIG9yZGVyaW5nICJ3b3Jr
cyIsIGl0J3MgYWxsDQo+IGJ1dCBpbXBvc3NpYmxlIHRvIGZvbGxvdy4NCj4gDQo+IEFuZCBpdCBk
b2Vzbid0IHRydWx5IHdvcmssIGFzIGV2ZXJ5dGhpbmcgaW4gdGhlIFREWC1Nb2R1bGUgaXMgYSB0
cnlsb2NrLCBhbmQNCj4gdGhhdCBpbiB0dXJuIHByZXZlbnRzIEtWTSBmcm9tIGFzc2VydGluZyBz
dWNjZXNzLsKgIFNvbWV0aW1lcyBLVk0gaGFzIGJldHRlcg0KPiBvcHRpb24gdGhhbiB0byByZWx5
IG9uIGhhcmR3YXJlIHRvIGRldGVjdCBmYWlsdXJlLCBidXQgaXQgcmVhbGx5IHNob3VsZCBiZSBh
DQo+IGxhc3QgcmVzb3J0LCBiZWNhdXNlIG5vdCBiZWluZyBhYmxlIHRvIGV4cGVjdCBzdWNjZXNz
IG1ha2VzIGRlYnVnZ2luZyBubyBmdW4uwqANCj4gRXZlbiB3b3JzZSwgaXQgYmxlZWRzIGhhcmQt
dG8tZG9jdW1lbnQsIHNwZWNpZmljIG9yZGVyaW5nIHJlcXVpcmVtZW50cyBpbnRvDQo+IHVzZXJz
cGFjZSwgZS5nLiBpbiB0aGlzIGNhc2UsIGl0IHNvdW5kcyBsaWtlIHVzZXJzcGFjZSBjYW4ndCBk
byBfYW55dGhpbmdfIG9uDQo+IHZDUFVzIHdoaWxlIGRvaW5nIEtWTV9URFhfSU5JVF9NRU1fUkVH
SU9OLsKgIFdoaWNoIG1pZ2h0IG5vdCBiZSBhIGJ1cmRlbiBmb3INCj4gdXNlcnNwYWNlLCBidXQg
b29mIGlzIGl0IG5hc3R5IGZyb20gYW4gQUJJIHBlcnNwZWN0aXZlLg0KDQpJIGNvdWxkIHNlZSB0
aGF0LiBJIGRpZG4ndCB0aGluayBvZiB0aGUgYmVsb3cuDQoNCj4gDQo+ID4gb3IgcHJldmVudCB0
aGUgY29udGVudGlvbi4gRm9yIHRoZSBsYXR0ZXIgY2FzZToNCj4gPiB0ZGhfdnBfY3JlYXRlKCkv
dGRoX3ZwX2FkZGN4KCkvdGRoX3ZwX2luaXQqKCkvdGRoX3ZwX3JkKCkvdGRoX3ZwX3dyKCkNCj4g
PiAuLi5JIHRoaW5rIHdlIGNvdWxkIGp1c3QgdGFrZSBzbG90c19sb2NrIGR1cmluZyBLVk1fVERY
X0lOSVRfVkNQVSBhbmQNCj4gPiBLVk1fVERYX0dFVF9DUFVJRC4NCj4gPiANCj4gPiBGb3IgdGRo
X3ZwX2ZsdXNoKCkgdGhlIHZjcHVfbG9hZCgpIGluIGt2bV9hcmNoX3ZjcHVfaW9jdGwoKSBjb3Vs
ZCBiZSBoYXJkIHRvDQo+ID4gaGFuZGxlLg0KPiA+IA0KPiA+IFNvIEknZCB0aGluayBtYXliZSB0
byBsb29rIHRvd2FyZHMgbWFraW5nIEtWTV9URFhfSU5JVF9NRU1fUkVHSU9OIG1vcmUNCj4gPiBy
b2J1c3QsIHdoaWNoIHdvdWxkIG1lYW4gdGhlIGV2ZW50dWFsIHNvbHV0aW9uIHdvdWxkbid0IGhh
dmUgQUJJIGNvbmNlcm5zIGJ5DQo+ID4gbGF0ZXIgYmxvY2tpbmcgdGhpbmdzIHRoYXQgdXNlZCB0
byBiZSBhbGxvd2VkLg0KPiA+IA0KPiA+IE1heWJlIGhhdmluZyBrdm1fdGRwX21tdV9tYXBfcHJp
dmF0ZV9wZm4oKSByZXR1cm4gc3VjY2VzcyBmb3Igc3B1cmlvdXMNCj4gPiBmYXVsdHMgaXMgZW5v
dWdoLiBCdXQgdGhpcyBpcyBhbGwgZm9yIGEgY2FzZSB0aGF0IHVzZXJzcGFjZSBpc24ndCBleHBl
Y3RlZA0KPiA+IHRvIGFjdHVhbGx5IGhpdCwgc28gc2VlbXMgbGlrZSBzb21ldGhpbmcgdGhhdCBj
b3VsZCBiZSBraWNrZWQgZG93biB0aGUgcm9hZA0KPiA+IGVhc2lseS4NCj4gDQo+IFlvdSdyZSB0
cnlpbmcgdG8gYmUgdG9vICJuaWNlIiwganVzdCBzbWFjayAnZW0gd2l0aCBhIGJpZyBoYW1tZXIu
wqAgRm9yIGFsbA0KPiBpbnRlbnRzIGFuZCBwdXJwb3NlcywgdGhlIHBhdGhzIGluIHF1ZXN0aW9u
IGFyZSBmdWxseSBzZXJpYWxpemVkLCB0aGVyZSdzIG5vDQo+IHJlYXNvbiB0byB0cnkgYW5kIGFs
bG93IGFueXRoaW5nIHJlbW90ZWx5IGludGVyZXN0aW5nIHRvIGhhcHBlbi4NCj4gDQo+IEFjcXVp
cmUga3ZtLT5sb2NrIHRvIHByZXZlbnQgVk0td2lkZSB0aGluZ3MgZnJvbSBoYXBwZW5pbmcsIHNs
b3RzX2xvY2sgdG8NCj4gcHJldmVudCBrdm1fbW11X3phcF9hbGxfZmFzdCgpLCBhbmQgX2FsbF8g
dkNQVSBtdXRleGVzIHRvIHByZXZlbnQgdkNQVXMgZnJvbQ0KPiBpbnRlcmVmZXJpbmcuDQo+IA0K
PiBEb2luZyB0aGF0IGZvciBhIHZDUFUgaW9jdGwgaXMgYSBiaXQgYXdrd2FyZCwgYnV0IG5vdCBh
d2Z1bC7CoCBFLmcuIHdlIGNhbg0KPiBhYnVzZSBrdm1fYXJjaF92Y3B1X2FzeW5jX2lvY3RsKCku
wqAgSW4gaGluZHNpZ2h0LCBhIG1vcmUgY2xldmVyIGFwcHJvYWNoIHdvdWxkDQo+IGhhdmUgYmVl
biB0byBtYWtlIEtWTV9URFhfSU5JVF9NRU1fUkVHSU9OIGEgVk0tc2NvcGVkIGlvY3RsIHRoYXQg
dGFrZXMgYSB2Q1BVDQo+IGZkLsKgT2ggd2VsbC4NCg0KWWVhLg0KDQo+IA0KPiBBbnl3YXlzLCBJ
IHRoaW5rIHdlIG5lZWQgdG8gYXZvaWQgdGhlICJzeW5jaHJvbm91cyIgaW9jdGwgcGF0aCBhbnl3
YXlzLA0KPiBiZWNhdXNlIHRha2luZyBrdm0tPnNsb3RzX2xvY2sgaW5zaWRlIHZjcHUtPm11dGV4
IGlzIGdyb3NzLsKgIEFGQUlDVCBpdCdzIG5vdA0KPiBhY3RpdmVseSBwcm9ibGVtYXRpYyB0b2Rh
eSwgYnV0IGl0IGZlZWxzIGxpa2UgYSBkZWFkbG9jayB3YWl0aW5nIHRvIGhhcHBlbi4NCj4gDQo+
IFRoZSBvdGhlciBvZGRpdHkgSSBzZWUgaXMgdGhlIGhhbmRsaW5nIG9mIGt2bV90ZHgtPnN0YXRl
LsKgIEkgZG9uJ3Qgc2VlIGhvdw0KPiB0aGlzIGNoZWNrIGluIHRkeF92Y3B1X2NyZWF0ZSgpIGlz
IHNhZmU6DQo+IA0KPiAJaWYgKGt2bV90ZHgtPnN0YXRlICE9IFREX1NUQVRFX0lOSVRJQUxJWkVE
KQ0KPiAJCXJldHVybiAtRUlPOw0KPiANCj4ga3ZtX2FyY2hfdmNwdV9jcmVhdGUoKSBydW5zIHdp
dGhvdXQgYW55IGxvY2tzIGhlbGQsIGFuZCBzbyBURFggZWZmZWN0aXZlbHkgaGFzDQo+IHRoZSBz
YW1lIGJ1ZyB0aGF0IFNFViBpbnRyYS1ob3N0IG1pZ3JhdGlvbiBoYWQsIHdoZXJlIGFuIGluLWZs
aWdodCB2Q1BVDQo+IGNyZWF0aW9uIGNvdWxkIHJhY2Ugd2l0aCBhIFZNLXdpZGUgc3RhdGUgdHJh
bnNpdGlvbiAoc2VlIGNvbW1pdCBlY2YzNzFmOGIwMmQNCj4gKCJLVk06IFNWTTogUmVqZWN0IFNF
VnstRVN9IGludHJhIGhvc3QgbWlncmF0aW9uIGlmIHZDUFUgY3JlYXRpb24gaXMgaW4tDQo+IGZs
aWdodCIpLsKgIFRvIGZpeCB0aGF0LCBrdm0tPmxvY2sgbmVlZHMgdG8gYmUgdGFrZW4gYW5kIEtW
TSBuZWVkcyB0byB2ZXJpZnkNCj4gdGhlcmUncyBubyBpbi1mbGlnaHQgdkNQVSBjcmVhdGlvbiwg
ZS5nLiBzbyB0aGF0IGEgdkNQVSBkb2Vzbid0IHBvcCB1cCBhbmQNCj4gY29udGVuZCBhIFREWC1N
b2R1bGUgbG9jay4NCj4gDQo+IFdlIGFuIGV2ZW4gZGVmaW5lIGEgZmFuY3kgbmV3IENMQVNTIHRv
IGhhbmRsZSB0aGUgbG9jaytjaGVjayA9PiB1bmxvY2sgbG9naWMNCj4gd2l0aCBndWFyZCgpLWxp
a2Ugc3ludGF4Og0KPiANCj4gCUNMQVNTKHRkeF92bV9zdGF0ZV9ndWFyZCwgZ3VhcmQpKGt2bSk7
DQo+IAlpZiAoSVNfRVJSKGd1YXJkKSkNCj4gCQlyZXR1cm4gUFRSX0VSUihndWFyZCk7DQo+IA0K
PiBJSVVDLCB3aXRoIGFsbCBvZiB0aG9zZSBsb2NrcywgS1ZNIGNhbiBLVk1fQlVHX09OKCkgYm90
aCBUREhfTUVNX1BBR0VfQUREIGFuZA0KPiBUREhfTVJfRVhURU5ELCB3aXRoIG5vIGV4Y2VwdGlv
bnMgZ2l2ZW4gZm9yIC1FQlVTWS7CoCBBdHRhY2hlZCBwYXRjaGVzIGFyZSB2ZXJ5DQo+IGxpZ2h0
bHkgdGVzdGVkIGFzIHVzdWFsIGFuZCBuZWVkIHRvIGJlIGNodW5rZWQgdXAsIGJ1dCBzZWVtIGRv
IHRvIHdoYXQgSSB3YW50Lg0KDQpPaywgdGhlIGRpcmVjdGlvbiBzZWVtIGNsZWFyLiBUaGUgcGF0
Y2ggaGFzIGFuIGlzc3VlLCBuZWVkIHRvIGRlYnVnLg0K

