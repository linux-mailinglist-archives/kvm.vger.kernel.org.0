Return-Path: <kvm+bounces-29264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CFD9A600D
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A5C41F2367F
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0F61E3776;
	Mon, 21 Oct 2024 09:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ut7SzoxV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4DF1E1C18
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503070; cv=fail; b=qs+XS+Bh8E4sFuHXCzTzAdpDHRmQlYb10sPltjqoCHuxrp2+/qE1PiRGX/6r6lmgwpItrBj4zFN5lTzyL8bNAuGfzfadELFHlSYNqJ92nlQLKPsgQD53uOPP5BDOsY7qHCGSIoOeTp+bWWIdWJ4d8VaCJaZRu81eWhQFfG6C3m0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503070; c=relaxed/simple;
	bh=CipwNyDbp1nc7zr/NO9yhG6PS5id6zRjvvFEp1ly47Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RKkwuPWz/nkC6s051oGIGd2BvEf31IU7LPWmjy6w8fI+e772OTYoeSxWOisSBGrV22A0UTnlNtO+Xt7BHqefOkZqBUbGEHYg7KuMphFQ6iWHJQH3N9D9WKLoCAMMP10iqCw16cW0vudYbgNsRHVs+vRkJEkjZpAdkGJk8HzvULQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ut7SzoxV; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729503069; x=1761039069;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CipwNyDbp1nc7zr/NO9yhG6PS5id6zRjvvFEp1ly47Q=;
  b=Ut7SzoxVVDZ0jkJyf6pvd+X7oLPThcUOru4MoVcJXFzLTzTfFt93fjWu
   vRSkiK5EPQrgP9IyRQJ4LwQyfEfgBYuApXyWeHbjavDwBN7nS4vozl1kW
   fxZTj3Ks+Evc4dxZ/Scn//2ymSfAaGxgxY1fcx0XqEEHCW8Nh9FyJ4izA
   XkissK8YpAUrhsSW9qfK0+OPgSOlYWnbYas/wbPKAzpauQ2yK8CKK5Lzz
   XQd5+PjXA4qaVG9bNrJvRS6rYtvnPF23LvX1jDEFrZriet+gUGvc0o6pj
   IsVzEiGOJhALC/k1CgCqPw620fIQCo2fi9Gj07XcrGFwV4ajspc6VqxXx
   g==;
X-CSE-ConnectionGUID: efxXHWXmQx6w67RIk5LyWw==
X-CSE-MsgGUID: mRnnbD3zRmCoGUC0AMSN8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="32664073"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="32664073"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 02:31:09 -0700
X-CSE-ConnectionGUID: TletqqtpQNimhVgBmm2yIg==
X-CSE-MsgGUID: kxDY7lDCR/GQzGFp1geUPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="84263293"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 02:31:08 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 02:31:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 02:31:07 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 02:31:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sCvPBpiPEVdInBl2PZVynIh82+pIDCQ2PW9iTzuIpggX/Zrx26cmS2npXQV/Ht3TuHgydV/rjdQBJU+VvYdSSVxshfvAt3rPmA/citLP4Q2Qm1naMlr8pulM0eet+UHUmawMs9mnPBmsjikpHPDCefTT4/944ztl65/5ZLXQmb7ZTr97JXpWFMA2UEQheaqAOj/KCpm3CcN/idAiCPNNdD2FBlvAbFWBLy2QJRgJKE+WvdFw3D7o4e054rVRNl6Xehkpmcj+rTUyrZaOx8KCwWcsK13k5P3QDNLN/Kx69A2CylNdkG0kaqhM9Rx64dQ7m2tu4a143zoTkb97ZfwbuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZEWDBIlktd6iH4ZRrdXQMHQEZx7IZ3rCo5roRnpqFo=;
 b=n+DpvFu2YifbwjuGqHGQPgUgYbQx5j+1vqVh65O8mMyhwn1iN6oocMTrxZ0FoTl5wom6fU+jJLQnfeB/IRnteYhsejRBWx844ZIkP4XQac+R2Pv5ownRdnvVnIlJBHX+bKW1BP7S2B+1lEnJtTIDwft8rydgSciwo0pQuo1kPQwhDnkRIB8jUPaIb2jIEf1KsWczo3CYpwvVmNbk8aVgGOWY2vmu1wk6Z34gN6Jl7jlvPiaWxHT8Ha/T7F1ihwb+fjLqefYkms0uw43BCCZCjUfwF01ostV3sjJA0ZHUbeU56TghWySNeoGjaMZkhvv6IHpzgyPzMb5Rdni2e/vUCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by CH0PR11MB5252.namprd11.prod.outlook.com (2603:10b6:610:e3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 09:31:04 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 09:31:04 +0000
Message-ID: <9434c0d2-6575-4990-aeab-e4f6bfe4de45@intel.com>
Date: Mon, 21 Oct 2024 17:35:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] iommu: Add a wrapper for remove_dev_pasid
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<will@kernel.org>, <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-2-yi.l.liu@intel.com>
 <20241018143924.GH3559746@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241018143924.GH3559746@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1P15301CA0066.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::14) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|CH0PR11MB5252:EE_
X-MS-Office365-Filtering-Correlation-Id: bfed7cec-b969-4c0b-68bf-08dcf1b31550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TVNxKzJXMHpWMDFqa2hUUnlUbTJWU2QyWGIyc1MvNVpiVzhKYVlNaVdhN0Ez?=
 =?utf-8?B?UHlXdmlQUEo1Zm5vSEhrUUJKMGR1ZWoxSmgxSUxMVzNKSkJGbndvcThIL0dV?=
 =?utf-8?B?RXl0NWRNRHJ4bVVVN1ZyV3ZsRzg3UEhWU2VlRGdpR1dxcGt4K0xiL2ZvaFEr?=
 =?utf-8?B?Z1V5V2VoWnVFMkEwM1FLQmlxN1JxemtZdU9hQ3hEWTlKT1MxYU9TejBZVXc5?=
 =?utf-8?B?cnpUZm9tcm1GNnhDcys0QXdDb0pCVlBmMVVxVzZHU2MyOGMvM2E2a3psaC9a?=
 =?utf-8?B?dkxSc2YxS2Urdi9pSEt2NGpRL0dpV2ZFanZZVzFObDNqNXV4Q25ERzFxc1hn?=
 =?utf-8?B?eSsrdVFzL1dxa25HT1l5bjd6RHpyTWRqaU4yQ2dKUSt4b2RCZkxEb3ZKVlla?=
 =?utf-8?B?UE9MaEhwMUZzYVJYd0hJc3VjdDQyOThDUnIva1pvMDRLYjVFQ1JlUldKK0Rn?=
 =?utf-8?B?TVBXdmFGeGQ2b1F4YVJEVHdXTkUrT2tJMlRzQlpob1FJUFc3N21WR0RodThR?=
 =?utf-8?B?RjNiT0p2VG9FcEp5ZTM1MXMrSmFlZytrQjdZbjVRQ3djQ29wWDNtbXRwdFdy?=
 =?utf-8?B?OFhET0lMWXFsOGpyaTRlYTljRzVOQXpkd1loaVV4WjhRM1c3RlBlZkJNS1hB?=
 =?utf-8?B?cWFoRzRhNGdpdmd5dGZSVzE1dUt6dTg3aXMvaGp4MjNGalZRMHRpM3NuV1Bj?=
 =?utf-8?B?UnF5QWR3MnZRdWtTZk1JMGVacDRoWnFpekI1TnNOZVdGNFVRYWdoSElzVFJz?=
 =?utf-8?B?WFRydy90K1lIUnJ5OE9lMGFTcVhwZXpwZjYrSDI1TXI2ai9oWEVvWDEyd0dD?=
 =?utf-8?B?aGVGM1FRbVlBbUJXZ1pzYWxVbDJuV3I2a3kyOFJldkl6ZHpLUHZ6VG1IN0Ri?=
 =?utf-8?B?cWgySnVrUE85QUdOL28rdzlKV05zV2xsQm1JcGhhd0psbGIwVjNXMjNOWDJY?=
 =?utf-8?B?MDQ0MExaTjZ1TnBmWWNmYW5Ia01WSUFSejVMTTBvdnNRd01YeDJ6VnFieG5y?=
 =?utf-8?B?bi9la0Y2OVB3aUlGdDlDcmFTY21FYTZESzBkcHNjRmsyeUdXMGdwOHFJVkd2?=
 =?utf-8?B?dTAwN3NGUzNVejRhRUtGclE4SFQ1ZVBZR05ZNklhSStvYkNXQmhhOUtJSFBl?=
 =?utf-8?B?OUk4WW1vM2psYnorZUNPQ1pzNGFtblBCTmVMejJxTHVjcVJud2w3RXVoUXhp?=
 =?utf-8?B?d25FYzVBTDB1enR1aS9Ea0M3N0h1cUVpU3Q0elJjb1M0THEvUWNzcmttTXJQ?=
 =?utf-8?B?S3JsZktKRTZuMmVzN1lWVlVEMCs2QWJjdFk5QmRCRHBEVTNuRW9wOUhZSWM2?=
 =?utf-8?B?TlBLQkNSSzV6Z3JiOGk5SHA0R3pSOW95ODdQZWR5VGR4VUUwYWw4OVRGWGlo?=
 =?utf-8?B?ekFtTXluNnF5VVp5NEVPbGNTbWdqM0NHYmxRWFFuUExMM3pKMlM1VW5oZzRV?=
 =?utf-8?B?bnJFazdBMG9ZVlQyWTdwWElWZ3Yrd3cvVGhEZU50eGVQT2E4Q1BxZXNVbjNM?=
 =?utf-8?B?MlByQ0dsVS9EQUZIQytneFp1YTZseUlUNTV2SnI4eE9vM1pWdWFDT0ZuZnhO?=
 =?utf-8?B?WkgvSDdVWlBMQnFRME4zVm1JT3oyM052Vkk4dGM1S1Fsdjl1WFA4RCtKOFZs?=
 =?utf-8?B?dmVMT084Q3RlZ3l3dFE3SHBidlAxSGVVT0pHdDJtQnZyOXpxRTlXZVpNd0Vm?=
 =?utf-8?B?UjlrL2FxNTRLMEgyenVDTHpEbkxLSElWdjF0RG1vVmNXSlgzM1VXNnNWRkxa?=
 =?utf-8?Q?/yVTjVH2Bg8HpV5BZM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzhMNjlSODBQbW5NeFFxb1lCRVA4VzFtSEwzQTBaQzYwUE8zNGJvR0piTGor?=
 =?utf-8?B?d3lERWxJalpvTTkvMTBmeHJoaFpWdGRsVGpWREZkOXF5L0NiUWs1cjFjdHpM?=
 =?utf-8?B?VDROaHIxNWd2VTVzcnlLVmxDWFh2cDF4eTN5RGFSSzFWUlNSd3c2ZXp3NWFG?=
 =?utf-8?B?ZGdyTlhVeUxUbmVONXJmWUJDaG9Lb2N0MU9EcWoxcEFHbFlPeVhjQ0hFWXlI?=
 =?utf-8?B?dnIvaVJOQS9sdld2Q1ZvSEM3QTBROHJMM1gyU1hNMGkramhBdDJ0SDdTc3FE?=
 =?utf-8?B?M0ZOQ1NtNVpyT2xEM3lvSU5MYURqbGlSOEhKaXo2SFBMWGFDR2liSzRjNWds?=
 =?utf-8?B?TmkxdGpWYURwdXR4cmE0V0pQVVU0VTVpSllaMlVUQVU4SU9zQmZPTGsxcHda?=
 =?utf-8?B?NTdOK1duay8ySjNGUmgzNzd5R3kxS3R3Z3pDT2N2TzZJUCtWUGpGbEJQZHhj?=
 =?utf-8?B?R0creE1VYVhldUtEUk9tSnN6VjVNbUMxNXBLRmc2RE14cVhzd3hDOXdYZ29q?=
 =?utf-8?B?WHloVGEwaEN1Rldib0ppMW1DcUhLUjFFcm4waWR5MDBqcXBJRUZrbmthQS95?=
 =?utf-8?B?QTZSV0c5aVR0T0x4RCtvdWJwVG5KRkNWRVJrL0RkOXZpUWhSa2kvN3BDOUN5?=
 =?utf-8?B?VytZT1JKSmxVS0VsVjV1ZW1GSkFiNG03dWt5VkhQaFZnZllTWEkrT2orUE5L?=
 =?utf-8?B?dG9zdHF4Q2J3S1JWNDBOclg1U1ZuZzVwRkZrcUJsemN2aGJxSDFNTjVOQy9o?=
 =?utf-8?B?MVFGeUpvKzJ5dzVnRDQzeUNkTFN1WGtPS1lSN3pMdVF6cDE5ajdibW9ORjNM?=
 =?utf-8?B?WUpFMzNBQnR4amMrSXdwdWJwZEZncFdJb3FKUlNETmR2ajNTQ2xNTzNUZ20y?=
 =?utf-8?B?MVZYcXhiL2U2SmphMkVuaFhwY3huZTVVMWF5S3pUcEprYVkxQ2syTEZZSlVx?=
 =?utf-8?B?M2FkZVF6NzFYaVNwQ05UU2pFQUFQenVvbHk3dXBnL3RoLzNONkpyRWI1V0dv?=
 =?utf-8?B?YmdaWmVSdEd2STdJai8rcC9rZTF3RnlrakJzTm4rNmxSVDBTelZ4M1hSdDhH?=
 =?utf-8?B?Ym5UOHZ4eFY3eWJWL3JuMkttckxIVm9waXpjK0dCckFYWndiTjNPaVhmcWVz?=
 =?utf-8?B?ejlqRXc1MmNMMkl1Q0hCd1ZGVXpERlNsWGVFUk54SzAxdDNhY3dMbXBjTHNF?=
 =?utf-8?B?Y00weGpWL21qZ05hVVgyVjNpUXluS1ZRbVNxVlRxd1hDY0U1ZGRMdzFSaHN1?=
 =?utf-8?B?M1JpVUdpeGVZSko4d3FGYjhxVWp3L0VaWUtVcnVSN3h5NUNXUXRRa2ZleEFL?=
 =?utf-8?B?d0pEV2FFQ0MrYnYreGZyT080STJDdUVJdWI0bEdYTUQraHhhYkd3bmxYZDlz?=
 =?utf-8?B?Z05pL2VZSlI1UkZjUitGY0s4ekROWTQrU3pPK3ZEZzJ2UzdmVGxtczF1WEVV?=
 =?utf-8?B?bXp0S0NodnhZZFFtbzNNQnFXNlhhL1VIMXBFTmsyRXJkQWhlbkN5Rk9EZFMv?=
 =?utf-8?B?WE9GT0Z0Y1RnekZ1L2JyV1VXVmJKYjdhNitjVXI0dFkzeEFlOFpOSksrOURP?=
 =?utf-8?B?cEpUbUJSYmh5Z00yRDUreVFxV2pTUnlSS1orcDhodG51b0ltcFp5L04vZUFx?=
 =?utf-8?B?TlJLYk1pR1cvMHBFS2M2R2tQd2c4UGlzREVqSDZyMHA5MWtLRWQ4Q0doMFpa?=
 =?utf-8?B?MElUMzZyT1FXcTFjYVgvY250bjUrdnEvMlNJcXN4eEFUM1cwejFUa1hkbWEv?=
 =?utf-8?B?dmZTR3VpTjd6Z3NjTW56TC9OTVlIeVhyblI5ZUJGOHFiK0RiRjFqOGJvVmt0?=
 =?utf-8?B?VUFmd0VEODhoUTNtSHBKam5GRnlpcEdFMVBHTjhlNzZ1RXl3RWJHb04ya3VX?=
 =?utf-8?B?ZUhNb0ZVVWlyYUtyQ1RJYnZFMXdDRTVhekZ2WmFOaHg2L00yZUMyRWVqRHNa?=
 =?utf-8?B?cnZYeW00Zys3dDhEQm1PQ0ZhRy9CRnhwbSsxL2hQYXFxMjNzeU5Mc2JXSkZz?=
 =?utf-8?B?dmZ0eGZwbC9RbTdnRUdJOHJiakdiZkNlRlRpS1lod21xTUp1SEZiZkt1Qlhu?=
 =?utf-8?B?MEZUQVRFUFZ5RWJ2TDZRODRpd09UeW9ydjRRVlFSYWlHWHNRNmFFT0gwdHlJ?=
 =?utf-8?Q?pQC2XihDKY10H73qCgDtwFLDa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bfed7cec-b969-4c0b-68bf-08dcf1b31550
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 09:31:04.2063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHZ5ZYax9WBxqYu6J4Ml/+V88OwvsfZG124PlMDN8fDoBIxTzufnuM3te44xOP4liKO/vFrdh1c4Dgji0IuOyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5252
X-OriginatorOrg: intel.com

On 2024/10/18 22:39, Jason Gunthorpe wrote:
> On Thu, Oct 17, 2024 at 10:58:22PM -0700, Yi Liu wrote:
>> The iommu drivers are on the way to drop the remove_dev_pasid op by
>> extending the blocked_domain to support PASID. However, this cannot be
>> done in one shot. So far, the Intel iommu and the ARM SMMUv3 driver have
>> supported it, while the AMD iommu driver has not yet. During this
>> transition, the IOMMU core needs to support both ways to destroy the
>> attachment of device/PASID and domain.
> 
> Let's just fix AMD?

cool.

> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 9e25b92c68affa..806849cc997631 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2437,10 +2437,18 @@ static int blocked_domain_attach_device(struct iommu_domain *domain,
>   	return 0;
>   }
>   
> +static int blocked_domain_set_dev_pasid(struct iommu_domain *domain,
> +					struct device *dev, ioasid_t pasid)
> +{
> +	amd_iommu_remove_dev_pasid(dev, pasid, domain);
> +	return 0;
> +}
> +
>   static struct iommu_domain blocked_domain = {
>   	.type = IOMMU_DOMAIN_BLOCKED,
>   	.ops = &(const struct iommu_domain_ops) {
>   		.attach_dev     = blocked_domain_attach_device,
> +		.set_dev_pasid  = blocked_domain_set_dev_pasid,
>   	}
>   };
>   
> Jason

-- 
Regards,
Yi Liu

