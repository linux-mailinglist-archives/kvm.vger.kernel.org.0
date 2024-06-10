Return-Path: <kvm+bounces-19149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49063901914
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 03:00:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 594091C21583
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 01:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDAA1C20;
	Mon, 10 Jun 2024 00:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWyJaVGd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD27A29;
	Mon, 10 Jun 2024 00:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717981194; cv=fail; b=VQLUa62jngRO0LyppCDYUZaqLN/AqqymWiYdwFPlB0vVHL+kuSmnphtKwtXcQMzl2CtLG3nmIMo1Cg1b2oY9g/rGFX+HEgFqBc33ZKpq7ATOhLDHNFuLqiYYXKNTu0CoPUIrgQLKE9H2ubijbZIFYRpcG+xHsEp1mRG5jS4ZAXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717981194; c=relaxed/simple;
	bh=LYiWTGaKK7BR7eQPwAYNBWdXkK4CRfP1UFRqdHbfLOY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OEei9/7tpAjtiDc050xh6wsLxq+P8knCCz21ajexx+PjfPZoic2N9x08LrMBydf7UP/aaII6Hc43bBy/8nH2YQRKcZjVZhsZnnGcIhixu3lOVK43RoGZ/9e45Bgxo9xLpGu/efLIWF3gNYxDztTSt+T2tzCZBQ0kFp78fL0rjpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWyJaVGd; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717981193; x=1749517193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LYiWTGaKK7BR7eQPwAYNBWdXkK4CRfP1UFRqdHbfLOY=;
  b=QWyJaVGdk1z8EU/QdA9rrE0sVJ7G26Kn7SqugCHRYOBfr6tvDpCbAl4g
   t6DAKgrb2v9P95FYkUmcxtR9REiPB47SXhN2VZoc4WT0p4kbP/vKfNPp5
   XkrVhsXNss4ugyfrnlMds/s1Hs1yl71Zs6qhE7MVYM5SftHQ2s9gqEcv3
   jyKniQT29leZ/fxezVz6ztRau/ZwoGAO+Xdr9p+yMAgCb2s78NLlpVJE4
   yv51SxtRiLBzPucLfvFFuQkKkyuiG/4XQ4Ly5veL0aGHyv8kXntGgr6aI
   J4Wy6uceFB27Tr5R5QiSz03cHCu1y4bVgHXsDlOsDi+hh9SGZx+CD4M7b
   g==;
X-CSE-ConnectionGUID: 2BsxCtBQSn26GHvQ+pC5dA==
X-CSE-MsgGUID: 16THra37Ts20Y9VXkykFXQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="32120562"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="32120562"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 17:59:36 -0700
X-CSE-ConnectionGUID: 8v8S4mA6Stu/Kyw6WhWqUg==
X-CSE-MsgGUID: mM0Vx72zQyCK+DNeAjRlMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="38900901"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jun 2024 17:59:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 17:59:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 17:59:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 9 Jun 2024 17:59:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 9 Jun 2024 17:59:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9qG2MEn0xt1UU9qHCNvWR7VOc4xQ8phVrLYzhfbHkysueHsYJ7cVSBYHBSe9ztwcpEnkC+ILMM+ErhDC/uGDbidyGZMycOoxxkQ0kpMPBVh3vyjoyB4Mm0TqJpDprZ+1zEqFUUKHr5964BQ25WfwuZS9zYoJ9LON2ECGaldnrRpkuPC5X4C2Vvk6GJTsHCR8n6VT20rMnM60DUD6GiZJN7XjcTt4rbvdk2BgMpKFJtuWtaV8dUvfH1lnp5e1Jd/xfjvJmSr047ekNB6jNhbTMcZZ/QQ2Rxta447s/ewyIP7c96PSm8Nrm0byDGHOeljHhPw8chEfqPhA2XP/t97Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYiWTGaKK7BR7eQPwAYNBWdXkK4CRfP1UFRqdHbfLOY=;
 b=Rwdbq/Ilv0P9YITXoU/GgCD+Oeqk0apk+gDrQnmC17SR1JtFKQmL67//YP0D9f7+p/IqBVTRAnz9pf3oskTwH1y4ZpsMRdrBmBWg3H48FMs50IFYME7Ay94Vfanr9sv8XUYzXJRpsmmkGS9kk6mTw4QL/975ZLbOT4mCGDhGekj438xkH5WoCwtp47A3EqRTnqJ2CjtCGO66k8Wu6QI61V7KC4dluNKxiXyOq6lFslf925cwEDQPFYULcaC5rxP/JKo8Ns892dOb9sLM7MnigZIpzCYD6UxsKmM6ULKwASNIF8CVFRIJzWhx1MGM7rBGEYIKFWSm3H3A1C8qcLvuZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6885.namprd11.prod.outlook.com (2603:10b6:303:21b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Mon, 10 Jun
 2024 00:59:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 00:59:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 0/8] KVM: Register cpuhp/syscore callbacks when
 enabling virt
Thread-Topic: [PATCH v3 0/8] KVM: Register cpuhp/syscore callbacks when
 enabling virt
Thread-Index: AQHauTfFl+g1JWtmUEaahM+bopjov7HAMHMA
Date: Mon, 10 Jun 2024 00:59:31 +0000
Message-ID: <653c48d0d9e352d4adf5167dd9f45fa9dbd0032b.camel@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6885:EE_
x-ms-office365-filtering-correlation-id: a5560bdf-548c-4a48-3d25-08dc88e8965b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?aFVFWEtPRDdMbFZCbW9tM3FxUVd1TUdBY21aRGhsdnM4WVBxZHU2UmxueHlO?=
 =?utf-8?B?dU1ZMzhXN2hVb1hrT3JMSEs3YUNrdUNoajZHQ1FGRmwyYW1MbkVnOWs2a016?=
 =?utf-8?B?VmYzSWNiZEJpRmpReFlQVHA0U2VSell3RHpYYmRZVzVZK2JoN1c2dlJ0SHRv?=
 =?utf-8?B?VEdUUGZkblliSlQ0SC9jT0J6Mm9wU2IxV2kxeFV3VlVpNW5yV21KcmQvY2Fk?=
 =?utf-8?B?MUV4aFc3anhjOFd3WlFlSzZYZ1pkWDhtMTJtTE5XM2N3WDlvOEtUV0Jjcmk3?=
 =?utf-8?B?MjQ3R0VGSnRZcmRtdG5EZCt1Uk5iNnBmcHo4dDBGN1NZMjBVYlgwRUpRWGhw?=
 =?utf-8?B?QU42UnZWbnFQMHkxaERSeG9qZURTUG1nWGFJYldGdjdYSHFaSzV3T25GSkhR?=
 =?utf-8?B?V21adHJkTTh6anlqU3pSTTF2M21GRS9BVjdLanhYbVlKOGwyY2VZNU1Hc1Ns?=
 =?utf-8?B?aHFsRS9mWUdNZkVleVlxMGpDdys2MTdWL0U5d2lVeGVwcUVwVzdrM0t4c2tM?=
 =?utf-8?B?KzBTYjRBY3lWZC8weUpGbVl6V3hYaDc5amlNbjhnc0Y2WGFKUmJoNmhwUFFC?=
 =?utf-8?B?TXBnUDkrVDR5N2Z4eEJsU0tHNXlOVDAwTWM2cW9NM3BnTlpNamtYQ0ZNK0xP?=
 =?utf-8?B?K01EbkpXTWdlcDExMyt2eUIwcVpFczhKd0d0M3RmSzdQRE81U3JmSGxUdWMv?=
 =?utf-8?B?OUNTd2o0OFY4c3EzNGdCQ1JqTnZtMk5iRmpESEpCbHM4cDNWNUlwMS9MajJ3?=
 =?utf-8?B?Y24rcnpEeUh5MlRseklvbGl6T3ZKL0ZHTUhobWhSWXVFeGtYUFl1dTRVb1Ra?=
 =?utf-8?B?UjR1bkxPaGF1WVFKUXRrbnJxTk1FUStjeiszNnQ1Y1dUYTZOTmttUVVmQ2Zn?=
 =?utf-8?B?MmlIME5XRmtqbTMyK2NCZnhvNG90NmRrT1JFYUdWZXZOWmdtcVR2TU1yWDg0?=
 =?utf-8?B?U1laMys1NmFiWkJ1cmFFTWNQemMySlFMWGNNelFWUHB5TmdGRTFWVVNmL3ZT?=
 =?utf-8?B?MEMxaERXbTRHaUlaMGVKVUJ0T1Vlb1U3K1NBVmk1V1YvU2NjZFRsQlZyZ1ZD?=
 =?utf-8?B?RFdzSzJkVnBiMHdGcmluOHBrR1ljZi9pdkt3Z3l5UFp2S0h0S2dCcTFUUDVY?=
 =?utf-8?B?ZUhsem1rd3JhZElSeW1mMm1pR2VOc3BsQTdYVUNGZkxqZGEwSkF6cGtrbFpp?=
 =?utf-8?B?N3ZRYzVSMTQ2VTRxVHpKem96RGhqL1I0elRPWlVWZTJCQVFZUDgyZ0JnYWJZ?=
 =?utf-8?B?c0FvM2lkbzdRNFlOSHd2RDMweTdTMTFGSFkrQy9wZFZURnYxTldIS3A2N3Fs?=
 =?utf-8?B?N2o0eWhNUUpTMkZVcVRBelFVRExodEdXNkxnTmlWMTlYN215ckY3dURlL0V3?=
 =?utf-8?B?aGRlWDFlekFVWnBjZll4OTV2MHpvdkMvKzNkNUYzeXNMZ2hqSUkwaFBlZVJU?=
 =?utf-8?B?d01oMkJJL3BzbmpzQU9FZ3BhRkZ0SzNydlhrbDFZSmFEQzAzWm5NQnB2cFdr?=
 =?utf-8?B?V05YU3ZWZTVCU0NqbDRIOElVLzVCeVAvMlJ4ZkpWTlhvb0F4eWtvS2lvK1U4?=
 =?utf-8?B?dlVGa05rVHZhcWtTamVvUnV0MzlGWU93YVd1M2ZKaThyWHRHY3RaS0FWWElG?=
 =?utf-8?B?NXFPV3lqVWVFY1JMU2MzSkFWSTRraEd5cU9DQmtYWWRWUWhBZnlYbXh0OGgw?=
 =?utf-8?B?NEdSOVh5dUVGWFdMVm5sSnVqc0NHeGc0Z3dXa2NIM3J2VllhY1JFMEd3eTIw?=
 =?utf-8?B?d2xJUTQ4YUNVN1lvZWJhK1NUcVFiTEkwTmZDTFJaS09lZis5TXBFL1hFbE9K?=
 =?utf-8?Q?CWoWSuLIut1GOksW3JLH6r0NfPOXWOsU/gm6c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0pMRmtKeHNBQlpzYmtGTkRLV1NWREtUZVljeDFOK09GcjMrTzJZZk5KdFpS?=
 =?utf-8?B?VjJlZ0x0ME9jOVM3MkQ0YjBvN3podUxhVjdjTUk0T2RVb0dDMHhram1DcHF0?=
 =?utf-8?B?RVVtenhWVUVpb1lPRkgxcE1qM1JGTGZmU21QamhneE5raHZyU1BGekRUei91?=
 =?utf-8?B?UFBJdUV4VTJ3OUlNN2VXcWUwOVhVWkxTeDRMdVk5dUoxRzc0MHY4eW5nRjh3?=
 =?utf-8?B?dzJEOCtkT1RGV1Zob0ZtRnNqa3BFTXNFWEhGcVN3WEg4WmxVT3E3T1JCOUJV?=
 =?utf-8?B?Y1d1dWl3TFgwekVndW1NL2R5NEtPZW1xamtDSklJb0dMR2xxNlJYWnM2V29x?=
 =?utf-8?B?MmZyejY4TFk1Z3h5bXo2RDNycTJZM0RhVkROb0xHS3Y0dk5SUUdjalNZNldj?=
 =?utf-8?B?MC9WL1d2ZjVTcGRwZnZadXhiNGlIeE9XVmJ4cjZtbXc0aTVpV2JLMmR1VklP?=
 =?utf-8?B?QWdDdEovMnM3dk1uN3lFS1QwL01FSEFyKzlyZXlLUXZCZVhwTHprQ3VYM0RT?=
 =?utf-8?B?MnhGQ25tZUJsQjJZOEM1NUU2NUpxcG5JL0o2cGdQd3VqZ0ozcDV1Ti9sTCtD?=
 =?utf-8?B?UERyaFMrZTZlQlpKRGhybS9KUFllZlo1SnBaWTJuZTQzdnJvRUlablZCTldP?=
 =?utf-8?B?c2tOcm5GaVJUYmlxTEhuc1hRcDk3c2pvK0tRbFhDL0RGSzFkUEhBQVg1RWZv?=
 =?utf-8?B?QVNsZ2ZtZk1iV2txZ2gxcTBiVmYrNElheUxlS0NCRmRRVnQwYVRZSHljTVFo?=
 =?utf-8?B?RFVzMTI3SkpoVlhoamdtRDRSeVNJRmpyeDRnUmpJc2JpZjlRWHlYWDdhc2Vk?=
 =?utf-8?B?MW16NWR6OFAxd3M4Y0FBSWJIem9oUWt4dno0b1JJNHhheVNXRndkd2tmdTF0?=
 =?utf-8?B?UkZndjRPSTF1YzVtL1BrTXVvdzdRV09oOWZYMHZ1UW83WDhXVm03d3d3bHhu?=
 =?utf-8?B?c0owNXJzQVoxOXNaR0I1ZXdoMGxhQ3ZiS0pNTnRLTk5kTWlsNzdUZlA5MXB4?=
 =?utf-8?B?Y1BBdUF2aE5NUDY3WXY0ZEZmWGRkQ1FCR3laWCtLYXc4a3JqMG5rZTlZclU0?=
 =?utf-8?B?cDZIa3p4dklDWUYxQ1MrOE1jRytGMUllc2ZMdHlsMys0WnlQc2RqVFRZVnVY?=
 =?utf-8?B?TlJrQ3ZJQWtuMVZKQWFMTlhmR040Tkk5bjJGaDN1L2Rla0o1MmU0WWpMcXdR?=
 =?utf-8?B?NUhMSm5VcTNtajZWSGp1QlFGdGEwVjNpV1oxbDQrSStNbm9Hcm5RNHd6RVI0?=
 =?utf-8?B?WmE0ai94dEhsYmp0MnI3WUNwZGJqa2NxUHBvVTJqMEpMTDN3U2h3ckF0NWlq?=
 =?utf-8?B?WEtjVXJ2OFV3SmNYTjZTRHAwaGRXUHBiaUx0L1Y0bmFzSjkrL1YwbEcvSzhL?=
 =?utf-8?B?L2JtenRBejNFSkVucXppZkxNR1VDTk0zVWI0czd1NkdMNFhsQllya1FQRTVJ?=
 =?utf-8?B?WXFSV0FNRFd3c2xjclBNcUNVT0hVUEg1NTVEcm1kZ3BwS3hWTlpOVTIyS3Bw?=
 =?utf-8?B?UTQveVY4ZVdsZlVCaVRIaFQ2QWVsdDAreWg3dnZKODN3RVRzSTZOb0VTWnVs?=
 =?utf-8?B?elZvZ1dTWFM2YnlEYkp3TVRXL2tzdWJuL083My9CZXlCVnpyY1RSVW1RTkdj?=
 =?utf-8?B?NzJ2ZkR6Tm5IMzAyL1NBUzl5L2h1REdJeC9ic0tmZ2VtVWlIMFpEZVRjT3U3?=
 =?utf-8?B?bkFLWUJpWHAyUGY2cWFlRFoyamdjSDJHUS9hOTRENW5PQ1EvUlpGcU84WE9t?=
 =?utf-8?B?QnZ1d0RxZ0VZdmdYdXlRZ1BtOVBPeDhkUnZUQmJzWWsvYW9DaU1XZkZrM1Jj?=
 =?utf-8?B?eFRubTYvOGNDRjhPRWpRbE1iOGpuM0ttMlZsRHBjcis4ZXVBMVRYSGgxbnpa?=
 =?utf-8?B?OXJpZnNQTjNzdnh3Y1p2OTFCYzUrRGJQVWQ5YXdwQ3BBQlVNOUZQMEpQKy9K?=
 =?utf-8?B?b2tWNU5tZGQ4cVkzQ1FGbTFjOWFVa2hYQzdDWDVzZVJiSGhMUEk4ZVhTKzlL?=
 =?utf-8?B?Mll0b0h0N1BhMUxqZDJGQU1rQm5SWGFYTGpLSHVIR2cva2RIUk5jZTgrbXZD?=
 =?utf-8?B?NnY2c0poUDNGenFvNVZNKzlTUDBVZHUwNHRjbzdJQVNHTVdENHg5ejllNkFk?=
 =?utf-8?Q?8elRaBNr3zzf9k3jzlYR4dWkT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AB1EB47C25F7B449A3FCEBE92F95209@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5560bdf-548c-4a48-3d25-08dc88e8965b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 00:59:31.5762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UYfczhkLO+BWJYVFsUDLhD1NxV+3uzwFvo5wkrj5ecGneE+MG69OsYSon52mpe8f1jA+90WmqyFUGdaMiX//fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6885
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZWdpc3RlciBLVk0ncyBjcHVocCBhbmQgc3lzY29yZSBjYWxsYmFja3Mgd2hlbiBl
bmFibGluZyB2aXJ0dWFsaXphdGlvbiBpbg0KPiBoYXJkd2FyZSwgYXMgdGhlIHNvbGUgcHVycG9z
ZSBvZiBzYWlkIGNhbGxiYWNrcyBpcyB0byBkaXNhYmxlIGFuZCByZS1lbmFibGUNCj4gdmlydHVh
bGl6YXRpb24gYXMgbmVlZGVkLg0KPiANCj4gVGhlIHByaW1hcnkgbW90aXZhdGlvbiBmb3IgdGhp
cyBzZXJpZXMgaXMgdG8gc2ltcGxpZnkgZGVhbGluZyB3aXRoIGVuYWJsaW5nDQo+IHZpcnR1YWxp
emF0aW9uIGZvciBJbnRlbCdzIFREWCwgd2hpY2ggbmVlZHMgdG8gZW5hYmxlIHZpcnR1YWxpemF0
aW9uDQo+IHdoZW4ga3ZtLWludGVsLmtvIGlzIGxvYWRlZCwgaS5lLiBsb25nIGJlZm9yZSB0aGUg
Zmlyc3QgVk0gaXMgY3JlYXRlZC4gIFREWA0KPiBkb2Vzbid0IF9uZWVkXyB0byBrZWVwIHZpcnR1
YWxpemF0aW9uIGVuYWJsZWQsIGJ1dCBkb2luZyBzbyBpcyBtdWNoIHNpbXBsZXINCj4gZm9yIEtW
TSAoc2VlIHBhdGNoIDMpLg0KPiANCj4gVGhhdCBzYWlkLCB0aGlzIGlzIGEgbmljZSBjbGVhbnVw
IG9uIGl0cyBvd24sIGFzc3VtaW5nIEkgaGF2ZW4ndCBicm9rZW4NCj4gc29tZXRoaW5nLiAgQnkg
cmVnaXN0ZXJpbmcgdGhlIGNhbGxiYWNrcyBvbi1kZW1hbmQsIHRoZSBjYWxsYmFja3MgdGhlbXNl
bHZlcw0KPiBkb24ndCBuZWVkIHRvIGNoZWNrIGt2bV91c2FnZV9jb3VudCwgYmVjYXVzZSB0aGVp
ciB2ZXJ5IGV4aXN0ZW5jZSBpbXBsaWVzIGENCj4gbm9uLXplcm8gY291bnQuDQo+IA0KPiANCg0K
Rm9yIHRoaXMgc2VyaWVzLA0KDQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwu
Y29tPg0K

