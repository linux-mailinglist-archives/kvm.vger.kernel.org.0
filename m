Return-Path: <kvm+bounces-14002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8D689DFAA
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:50:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE3351C21EFC
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 15:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A37813B592;
	Tue,  9 Apr 2024 15:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dMZ1lKLH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415811369AC;
	Tue,  9 Apr 2024 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712677785; cv=fail; b=D+hYjAPgWvGEx9A+pwAWXP1C7BwpLTZPe+cbH6MeltDVdEcdq2Xef4IsRyymi5yP2T8BHReW3RUX0W91zfwys9NM4uVtFDGYQbzrIVhao2TX0Wl2rcS7WnJyP02qHPj6T4Fx+1PNAZ7vVNEAgLCmK4dlQvrA0lBlpwddx6/nul0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712677785; c=relaxed/simple;
	bh=tv4aRq1EGhx8Lxf5TRLc2BhoHvw+2Lp+X0s5fOKyMxs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q5SoyKTViuLb5TtK4P8E+iO347ATmN3Yp8a+nFVZmM2IcdSnfpRQjor8Pl1VhRBbveu+eQnBHIkWvmhAXH1oNST0X1s5gUYbe8oVmanAMzRaJU/Tnyh6AOy9ID3XPFtLv0daUq4yRq7grLtFLgfZWcNHQ/aneS9e3diOg+JGyWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dMZ1lKLH; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712677783; x=1744213783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tv4aRq1EGhx8Lxf5TRLc2BhoHvw+2Lp+X0s5fOKyMxs=;
  b=dMZ1lKLHBDF9mMHnXeCECPp8CoyyQvnHwIPeiPjwOzKiV9fhtyyLU8MC
   z70tTTSmgmLl3OgrIqco+0/Bg0C79WsJvkaEhN0vuO3gedULsYh/uSoPy
   A22+oQdBdmpEj89O0BGpFXxi6mKAA4n2xwQBVJt5HHH/Nm7N86SZEi3hm
   2OPsoebixo8uOdGIKvnpJBQHUatkrFTlwbW3XlSY/yZDzuakE94EKMKQr
   OwgEGOmftFFfkpdpN6iQfFd78r627noiqnpk6Y2q5nNmI/tZ6sQE49/f8
   2Zas8N0AEtoGCXW9HXeZ/td6AoJo2W7QSOasLOGM5voZiLD+bv7skH68G
   Q==;
X-CSE-ConnectionGUID: B2Q93NVfSP+K3rv2f3c9aQ==
X-CSE-MsgGUID: /U5/wH0DQw6tlJ6u+F/cwA==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8100261"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="8100261"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 08:49:43 -0700
X-CSE-ConnectionGUID: U3XUZR9FRdSJocnPRSOYAg==
X-CSE-MsgGUID: P3R8tcfmTO6NeLG+wBcjCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="24944938"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Apr 2024 08:49:42 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Apr 2024 08:49:41 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Apr 2024 08:49:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 9 Apr 2024 08:49:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 9 Apr 2024 08:49:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oiw4Xiw1XhdweXUFwolXrwJeNsGSWzM3T5xPGvzXJH/D9klo287q/A7WBf4f0nzA1L/Et7fdvCGCcOyL6RSh1aLI9BeMw4QYYTs0e2zG9naqtTUQBCQqe+Qw+fywmj+CKTP7jpC1kiHKPCbXx+oWitAPCYqQBX/9NSm57dxnr7CZwToTWj+90PWjC26vhJbnQxx65xHl0ry+w4SVkmL8tANnKomF64TB9pwGYtstVO+3akBIX8ykXQf3fyGzH5FglEDLpijwoFkq+6FbKe49hHZ9PBuUVupEKyISWD4cGJCsKw5d5O9J5G/b6HUVrw9Om/SWKeiwexdVwgYCIP8jRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tv4aRq1EGhx8Lxf5TRLc2BhoHvw+2Lp+X0s5fOKyMxs=;
 b=XLvrdYPLorMfhQoag/gcYSeNgfEVkrigDDoysGyq0DClo/EAJVDKHI11Ry7XJOWomIiGQX/diXQPcMH6/+7Wt7F4j/Dgpcw59P63ttXAVZMqECnQbeLFJcWYKKE4/QYIBV/9OZ8jdBQm8uqgNDlpGYXHsOyqSSyMwwZpdciY9YLquDLV3y80BO/rzt3KJlEgJZ4K22qx/fHlk+0B+VKXcqHJJdMvXmH0K9T0Ewb6HE1KvTvwRJ/tcj12N8GeyvM8QbUuBnZqKhH4Z+DRT7aKxS+AW/C3oHQP6ZpVFfGGiIq/YID9VAfbKIPbrIpKxXREZJOba7ExJUOxz6BYw7HJ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8477.namprd11.prod.outlook.com (2603:10b6:510:30d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Tue, 9 Apr
 2024 15:49:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Tue, 9 Apr 2024
 15:49:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "srutherford@google.com"
	<srutherford@google.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qOMqOgejWDsE6lTffyy9yei7FcJJkAgAJt44CAABa0AIAAE3AAgAAzlgCAAAskgIAAE5mAgAAfEYCAANyAgIAACmCAgAAHM4A=
Date: Tue, 9 Apr 2024 15:49:38 +0000
Message-ID: <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
	 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
	 <ZhQZYzkDPMxXe2RN@google.com>
	 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
	 <ZhQ8UCf40UeGyfE_@google.com>
	 <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
	 <ZhRxWxRLbnrqwQYw@google.com>
	 <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
	 <ZhSb28hHoyJ55-ga@google.com>
	 <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
	 <ZhVdh4afvTPq5ssx@google.com>
In-Reply-To: <ZhVdh4afvTPq5ssx@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8477:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wpQSB/Y9Ik7WWh53fj1VvvQyeRGY+xdSvW7xSb/eLmq2MdhNpcbty5Nq6n/WiLdB8isEp3evd2qEGDs0iE/advzZJt7EDm/xP4F04YRW+GZhXTCWtnL3l/ERITfwaVsuZGj4JB9DYkYhCaAHKkdCQD4x6mhVbORnzm5GDflKQQLvl6TOCU9xnuML5IDgxz1MfkrovwdvSyRlm4uYnQhDCQELb4JeEdNhl1h8rcbjS661DYMJIyxkgBPHrnkS+WXWPkEVe+uIOt6e5LP97cBTCg158jTTX8DXAzxT9Bxf8z+v2WOb345gRgUuUaffLuyFpGYcKmciZoZ4fnfFpsVsFHOCT3RX16EM6Nuj0GWne2PGKXe0A3yQVTgvFu1wOFYLPoMf5FhCJbWbCWFqFnUKPvjNuCFqFoo+2Xfjmnm4ibxBzMKuMF5z50XoH8FdhvmSgX/BJKFonb2YRcezprvBLCcXjaS7JNdmfk5/VsoS+05eOSvSR8PIgeyIbU+yWZvQSTrkEtgldarY69cOKbeaAIafHfn+ckRFgM8GHe9i3XyQnYOae18QWokzfXnysPQ9L1A7cA4POxalQS57i+AP+S7OZItuSp6a9DnwQ9Oc8ekHg1VIimjVbxdJ5Ivjor5w7cKpk9wlcHMX4ayXlMT2DuazosZlBs+IBTl5WoIC7PY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0MraEh5UW9JWlptYVVhMU1LMTg1c1pmU1dlM0tqQlFXN2R1bmtURVgzYVlE?=
 =?utf-8?B?NU81eEZkdVRzMG1RUXNwUHZYSzRud3Q3VmdxOXdhNXh0clhGeHV1RGdUSHJN?=
 =?utf-8?B?RU9ETXNDUWlQTGVRby9jVlhwQmlmNXZ1NTFBczBRMHVjakpaak5UUndnaEJl?=
 =?utf-8?B?S3RqaTVVcjdDTkc3YlJ0Qm9SdUxyRkJCcTRHNG13TUNhL2ptY0FaeUZ2QS93?=
 =?utf-8?B?emxVam5EZWhScS9PQkFENnhSUnVrMk9GYUtNZC80N0t0dkZVUDZONkNMbWI1?=
 =?utf-8?B?bFBvTFZMbU1JT2tRWWRsMERlQ3hMSVRONUxUQ0FSQUxlZUUrd0I0aThIWEZR?=
 =?utf-8?B?andWYmMvdVdxUjdBbEYvTDBCaXQ0a2RqNDlHYlRETHhDcmxHRXlDY0xvdFV4?=
 =?utf-8?B?RzdoaUp1eFFzdFo5L0hiQjRsaXNlSC9VV0dOREt6UndJNkRzS3p4QXhuUEVa?=
 =?utf-8?B?VWpUblJuT3ZvcE1MdTdYZFlNV2hqZE9TekxWQit1dlBGOGNodVhrS0RlZHY2?=
 =?utf-8?B?L1hVU1A4UWFRaGh6bnJ1OWd1a3dmRGk2OE9YNFhxQ3AvU21aWk9HYy81SmxS?=
 =?utf-8?B?cTI2MzJ1UzRCLzArTGJaNnZ4MWI4bmo3RC9MUE9IMGFBdFF2VXQyYlBYZHUw?=
 =?utf-8?B?LzZEcGVhSnh2VkRQSVFQa0tlNVBuREZlVmFxUW41aGF6ZFJ2K01DaUNhclNv?=
 =?utf-8?B?MlNSanBaZ0ZOVVMyM2FiSGYwYXIzemc0ZENnemkwM29DKzBneHUvdmNVT0Q2?=
 =?utf-8?B?N1RiYlNjRmlLRjlxM0lXRFMrZWdGWGs1NEJxdFVMVHNzMnBHcExjUnZ2WFhB?=
 =?utf-8?B?aVlSV1VZci9wRUhyVmhhWmZDY2NGanM0VlVuUExkTG5uRHk4K2NhcE1LVE1w?=
 =?utf-8?B?eHhhSEpHVENpeWFQazJNNkg0NkVxWUx4WDFkbmJWMEJvYnE4T2NyZ1NLVm9y?=
 =?utf-8?B?NG4zWWZXWTh3bGNiK2lrNUpyaEpkbmVqdjZseVpZa280eTdxRXV0VTlKSGJG?=
 =?utf-8?B?b1ZIdUFIY2NlbmFXRXluZnd1Z1pGaU1OcFRBbWhpd1Uwdis1cFZ5elB0b2ZI?=
 =?utf-8?B?S2ZmNGt6VzM4ZUI3UUxhNzljb3JMMXRIc2ljUjljeXJOb2dQbGdzZGJHNXFm?=
 =?utf-8?B?QTg5RjlpTHhTOWlxMXNSWXkvaWQxZW4xL2NPNjdQS0RRTStmdXUvL2pqS1FM?=
 =?utf-8?B?ejc2bW5WQ2Y4aldEYjR6RkJ2UmNrRzl4ZWFYVW1ETlVtRG9OQkJBMFBVY1l3?=
 =?utf-8?B?TktSTUt1cU51V1B6cC96dVpmbVNUS1lMUHZKanBPRHVPYUlheFFiTWJiQVlH?=
 =?utf-8?B?S1RFMWhyaU5NN0M4em1LZFlEZHpvaVVSTk40OTljTExhVnJnWWZ2cFZpR2U3?=
 =?utf-8?B?Zlpac3RRc0ZmZUFlMWZwVHRkUUdScTAvc1grT3BXR0RRUDF0S2lOeXJtZVlo?=
 =?utf-8?B?WGxiamhRaFVxSEFxSENuN1VpblNPall2Wk9vdDdFRU1nQUlreG1qdmNnUjBl?=
 =?utf-8?B?K2hQUTBXaHVFakFJVVJ6MmZ4bFJXQmEzak4rN3AxM1pxcDRxVGhLTmxRN2dR?=
 =?utf-8?B?bEdIdEJDSjU1Q0F5alIxWkpEZ1JIbEVxZktMRm4rMlVlUU5iUGpPQWROclJ6?=
 =?utf-8?B?eGVGRUFkNzVtSmxUWmNNdm9Qb00zRTV0MGFiRDFqUS91clV3N3BVdlhRMDNS?=
 =?utf-8?B?cjVyYXIrajFJSFhXRTh1cmYxY1I4TGc4V050RU96eDRHanhFSlNIcVEvMU40?=
 =?utf-8?B?Uk1PRnYwRWV2VEpDOGF3bUZtNllya1ozQ0M5ZDgrMjZwMWtEb1E5dVBJN2pr?=
 =?utf-8?B?dGh3MzUzaGpyWHptYzBaNDFIYjAvODBMeFNtTTN1THEvR3Y2ZDZ3cU8xNnAr?=
 =?utf-8?B?TEFhMll3MDR3WllmLzk4V1BOZWtKZ21TZnpiVXpGcWwwaGRGWUxVNVFPVnZa?=
 =?utf-8?B?RndWV0Q0eDJNUXU3Q2JmL1lmeXV4UnkwUmpVVDhDSHlxNnFzd0lFRThRYnQ2?=
 =?utf-8?B?WVIyK1ZreXdoeEJxRWxrTCsyemZrOFNDbTZWeGdNVEM5SzhoaFFCL2hJZDJL?=
 =?utf-8?B?clRFamk2VUdKTVA3ZWlVYmEyNVFwYkFkRzJzTU1XREQwa243ZGxTZG9DUkFC?=
 =?utf-8?B?Z1k3UE4wZHd2cmQ4RmVaZTh1UlRoNDNYbjE1bWc0eHNJVTFOdU96R0c3VEdm?=
 =?utf-8?Q?RQxaGwKSAlyB3dK+ZcPi+9o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C9AE941427FEB4F90BC1F9CDAB402BC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d829a9-1aa5-4bb9-e7f8-08dc58aca98f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:49:38.2033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kTgHv9Gqt/V77g+KMOBBQAt6ADkJnr8N631DkrWQRbMndmS3EAS2Zy/TzSDfqIvqpOnBvwfJtqN8jkLGDMaWyuHsx5kGkpBKr/7MRiwpx/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8477
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA0LTA5IGF0IDA4OjIzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFJpZ2h0LCBJIHRob3VnaHQgSSBoZWFyZCB0aGlzIG9uIHRoZSBjYWxsLCBhbmQg
dG8gdXNlIHRoZSB1cHBlciBiaXRzIG9mIHRoYXQNCj4gPiBsZWFmIGZvciBHUEFXLiBXaGF0IGhh
cyBjaGFuZ2VkIHNpbmNlIHRoZW4gaXMgYSBsaXR0bGUgbW9yZSBsZWFybmluZyBvbiB0aGUNCj4g
PiBURFgNCj4gPiBtb2R1bGUgYmVoYXZpb3IgYXJvdW5kIENQVUlEIGJpdHMuDQo+ID4gDQo+ID4g
VGhlIHJ1bnRpbWUgQVBJIGRvZXNuJ3QgcHJvdmlkZSB3aGF0IHRoZSBmaXhlZCB2YWx1ZXMgYWN0
dWFsbHkgYXJlLCBidXQgcGVyDQo+ID4gdGhlDQo+ID4gVERYIG1vZHVsZSBmb2xrcywgd2hpY2gg
Yml0cyBhcmUgZml4ZWQgYW5kIHdoYXQgdGhlIHZhbHVlcyBhcmUgY291bGQgY2hhbmdlDQo+ID4g
d2l0aG91dCBhbiBvcHQtaW4uDQo+IA0KPiBDaGFuZ2Ugd2hlbj/CoCBXaGlsZSB0aGUgbW9kdWxl
IGlzIHJ1bm5pbmc/wqAgQmV0d2VlbiBtb2R1bGVzPw0KDQpCZXR3ZWVuIG1vZHVsZXMuIFRoZXkg
YXJlIGZpeGVkIGZvciBhIHNwZWNpZmljIFREWCBtb2R1bGUgdmVyc2lvbi4gQnV0IHRoZSBURFgN
Cm1vZHVsZSBjb3VsZCBjaGFuZ2UuDQoNCkFoISBNYXliZSB0aGVyZSBpcyBjb25mdXNpb24gYWJv
dXQgd2hlcmUgdGhlIEpTT04gZmlsZSBpcyBjb21pbmcgZnJvbS4gSXQgaXMNCipub3QqIGNvbWlu
ZyBmcm9tIHRoZSBURFggbW9kdWxlLCBpdCBpcyBjb21pbmcgZnJvbSB0aGUgSW50ZWwgc2l0ZSB0
aGF0IGhhcyB0aGUNCmRvY3VtZW50YXRpb24gdG8gZG93bmxvYWQuIEl0IGFub3RoZXIgZm9ybSBv
ZiBkb2N1bWVudGF0aW9uLiBIYWhhLCBpZiB0aGlzIGlzDQp0aGUgY29uZnVzaW9uLCBJIHNlZSB3
aHkgeW91IHJlYWN0ZWQgdGhhdCB3YXkgdG8gIkpTT04iLiBUaGF0IHdvdWxkIGJlIHF1aXRlIHRo
ZQ0KY3VyaW91cyBjaG9pY2UgZm9yIGEgVERYIG1vZHVsZSBBUEkuDQoNClNvIGl0IGlzIGVhc3kg
dG8gY29udmVydCBpdCB0byBhIEMgc3RydWN0IGFuZCBlbWJlZCBpdCBpbiBLVk0uIEl0J3MganVz
dCBub3QNCnRoYXQgdXNlZnVsIGJlY2F1c2UgaXQgd2lsbCBub3QgbmVjZXNzYXJpbHkgYmUgdmFs
aWQgZm9yIGZ1dHVyZSBURFggbW9kdWxlcy4NCg0KPiANCj4gPiBUaGlzIGJlZ2dlZCB0aGUgcXVl
c3Rpb25zIGZvciBtZSBvZiB3aGF0IGV4YWN0bHkgS1ZNIHNob3VsZCBleHBlY3Qgb2YgVERYDQo+
ID4gbW9kdWxlIGJhY2t3YXJkcyBjb21wYXRpYmlsaXR5IGFuZCB3aGF0IFNXIGlzIGV4cGVjdGVk
IHRvIGFjdHVhbGx5IGRvIHdpdGgNCj4gPiB0aGF0IEpTT04gZmlsZS4gSSdtIHN0aWxsIHRyeWlu
ZyB0byB0cmFjayB0aGF0IGRvd24uDQo+IA0KPiBUaGVyZSBpcyBub3RoaW5nIHRvIHRyYWNrIGRv
d24sIHdlIGRhbW4gd2VsbCBzdGF0ZSB3aGF0IEtWTSdzIHJlcXVpcmVtZW50cw0KPiBhcmUsDQo+
IGFuZCB0aGUgVERYIGZvbGtzIG1ha2UgaXQgc28uDQoNCkknbSBvbiB0aGUgc2FtZSBwYWdlLg0K
DQo+IA0KPiBJIGRvbid0IHdhbnQgSlNPTi7CoCBJIHdhbnQgYSBkYXRhIHBheWxvYWQgdGhhdCBp
cyBlYXNpbHkgY29uc3VtYWJsZSBpbiBDIGNvZGUsDQo+IHdoaWNoIGNvbnRhaW5zIChhKSB0aGUg
Yml0cyB0aGF0IGFyZSBmaXhlZCBhbmQgKGIpIHRoZWlyIHZhbHVlcy7CoCBJZiBhIHZhbHVlDQo+
IGNhbg0KPiBjaGFuZ2UgYXQgcnVudGltZSwgaXQncyBub3QgZml4ZWQuDQoNClJpZ2h0LiBUaGUg
Zml4ZWQgdmFsdWVzIGhhdmUgdG8gY29tZSBpbiBhIHJlYXNvbmFibGUgZm9ybWF0IGZyb20gdGhl
IFREWCBtb2R1bGUNCmF0IHJ1bnRpbWUsIG9yIHJlcXVpcmUgYW4gb3B0LWluIGZvciBhbnkgQ1BV
SUQgYml0cyB0byBjaGFuZ2UgaW4gZnV0dXJlIFREWA0KbW9kdWxlcy4NCg0KPiANCj4gVGhlIG9u
bHkgcXVlc3Rpb24gaXMsIGhvdyBkbyB3ZSBkb2N1bWVudC9kZWZpbmUvc3RydWN0dXJlIEtWTSdz
IHVBUEkgc28gdGhhdA0KPiBfaWZfDQo+IHRoZSBURFggbW9kdWxlIGJyZWFrcyBiYWNrd2FyZHMg
Y29tcGF0aWJpbGl0eSBieSBtdWNraW5nIHdpdGggZml4ZWQgYml0cywgdGhlbg0KPiBpdCdzIElu
dGVsJ3MgcHJvYmxlbSwgbm90IEtWTSdzIHByb2JsZW0uDQoNCklmIHdlIGNhbid0IHRydXN0IGl0
IGF0IGFsbCwgdGhlbiB3ZSBjYW4gYWx3YXlzIGRpc2FibGUgaXQgaWYgaXQgYmVoYXZlcyBiYWRs
eS4NCkkgdGhpbmsgZXZlcnlvbmUgd291bGQgbGlrZSB0byBhdm9pZCB0aGlzLiBZZXMsIGlmIHdl
IGhhdmUgYSBiZXR0ZXIgaWRlYSBvZiBob3cNCml0IHdvdWxkIGNoYW5nZSwgd2UgY2FuIHRyeSB0
byBhdm9pZCB0aGF0IHNjZW5hcmlvIHdpdGggQVBJIGRlc2lnbi4NCg==

