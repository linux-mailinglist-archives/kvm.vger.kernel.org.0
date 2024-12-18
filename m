Return-Path: <kvm+bounces-34023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4BA9F5BD9
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FCE818966B1
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B0EB3597A;
	Wed, 18 Dec 2024 00:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nL/LFMDt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A810F2F2A;
	Wed, 18 Dec 2024 00:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482358; cv=fail; b=uN7M0MwYfJY5SWn2vrpw/G7ApSnAWNpNrqC5ozQLc2IAZOHpZwPBVHMMeWZGIe5T5pvdmM9F6fU+xdcPznyXBgVDVXql5mUGnxk4kBX6fdEhHUZWt3sRg15Jj8r+DVv8d/hIhnuI8F+DqvvLAd+ZPp27tMxkGs7Jik+PHFrUtpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482358; c=relaxed/simple;
	bh=k4emgQKbI0uaFGhn2+gKP7TWf4c/PVMgbaMr24hwICo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KnvgdTgS5J1eRi7ggpN1DN09aj5xFeoAEWMVwaTCr8y2rMWYhKMgFInxFB8pZ3qsAS2hzHHcJ7rnQzQ/6A1IIqY/dwMu9oRJZRA76ghRNL9tyL2nHuyFIpz1BGqUPYOsOXvBLVbeDS3+/dv5nV/Pg4bxHJsQQGDMo3w/Td/+exM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nL/LFMDt; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734482356; x=1766018356;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=k4emgQKbI0uaFGhn2+gKP7TWf4c/PVMgbaMr24hwICo=;
  b=nL/LFMDt+Xzux9kntNKkQEltVyjUHf1yy75Cmw/zyuMVtoDQGOil2MN8
   Aut7gOlrXbeg07PNKa1BtqCbOqwtNSJp4YDncktZdJ5VDRWT5RMmpq3ui
   T3rmncAofdmD4/lRfkkmLa/icS7JoR1bJmu8K+WDp1bLBDzlA4sfr81Hu
   VEdht/4z2euxWBMMpcNGvY7GBjDDE1P8YFrvGI/pJdDUAxx2bnvFEHY/t
   b1CPSkjgPwtKxxlRx1gwIufsPMiYAgAikg2xPFWMECoHya5a0jSjMf1mO
   SG20HEy9VF6GnnFpZ/S8SD9BcsGpQs39egECMAxlMURH1/GJUy4+tfk3J
   Q==;
X-CSE-ConnectionGUID: FUUWTYamR4msxJOvGOnMaA==
X-CSE-MsgGUID: kONbosmCTWqVW/HVX8RIYQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11289"; a="52343782"
X-IronPort-AV: E=Sophos;i="6.12,243,1728975600"; 
   d="scan'208";a="52343782"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 16:39:09 -0800
X-CSE-ConnectionGUID: /Cv9t7aeRhqOjvbtvZRZOA==
X-CSE-MsgGUID: qNFuyDSpS62l0RVHhOJ1+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,243,1728975600"; 
   d="scan'208";a="98275997"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Dec 2024 16:35:12 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 17 Dec 2024 16:35:11 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 17 Dec 2024 16:35:11 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 17 Dec 2024 16:35:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r46z3tN88IfJCwFoJ5HJFae7nb/jHeBl3oM62HJiVtJhr1PXUwuNTuxO5qyBgcRe3q7746tzXjzeHmH7mxGrEPKOM5YpQpNupXcC/pXUvg0iBG/PQVgnEkdktUJmgz2g4NVQnni3DRydPeGe+ZtrIZ6lIkIgJ+MUPp3pj1OGTb6KlYeUvEMQY91YwgXsimPelVX6CP9X+HWGcnOmg3zsRLQtRs/RDdtljqWlujgJdDXwfZ3FApMPRHAdWJgtf0fURpg0VPb1Pr9iZBif+X6ukmgFCBL5Q7Ra+0QVaMHmfAQio7Pa3oFkEfhgBWuBHWN4ittRKlvZv+ZUKx4wlAgR0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4emgQKbI0uaFGhn2+gKP7TWf4c/PVMgbaMr24hwICo=;
 b=zD5cwlUBnIaKURV61gSBBdoGI3L0ipqcCQxCUYFAb9ZvIymTPLcHZ0MXV5scCnOMW6NsVRQ6Yc2HwXgocYS9BHbI6467c8IA0dM7lfoIxhoHQjnB3B70o2pp/+nVmAzjh9owjGF4lb3hLH9k9WYzD3asxXEKw7AAnNwgt6L4V2AGxVSjyLlq94Jy0JLNI1NJjkbt8oo6scB9ukiIPUA9AN3Ez6H73k0bbiSMuWXFNgSpTk8DmHwZnTvNjjs+a8T3eoR60cUL722X1FFiQqz3KZgANhq1cfhrfk2nNsd8+um+sCcYQa4cghSp6j4CIcCbJ1DfNdpZY7zCuISjGtzgNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 00:34:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 00:34:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 00/18] TDX MMU prep series part 1
Thread-Topic: [PATCH v5 00/18] TDX MMU prep series part 1
Thread-Index: AQHbTZlB0sMzumHwCE+OtdZK4iH/jrLrLgwA
Date: Wed, 18 Dec 2024 00:34:41 +0000
Message-ID: <2db0db045563378d224ac9af9c8211b8da15ec2b.camel@intel.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
In-Reply-To: <20241213195711.316050-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6054:EE_
x-ms-office365-filtering-correlation-id: b21b9cde-f96d-4cc7-4d06-08dd1efbc2d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L1NBcDZzMW5ZSGNnQytQU1lvUjZuZTdNN1VhVnp6YjFaMG5lQVZSUFVuTWpQ?=
 =?utf-8?B?S2tNMXVHUGNWdVZUa3JpOU5oazBvaTVDZXorSDhNYVhQYWpra2haZlp3RDQ3?=
 =?utf-8?B?WWpQdVBYZVRvcUVjUGw5c3pMTzZYZXk3WVlpSTY3ZTRqWmswVi9WOGVUbVpq?=
 =?utf-8?B?cnZpWWdEU2M3U2EybE5lWllFcm1sNGJCSENnTDh1K2dWaDROZkZZRlFsbVB3?=
 =?utf-8?B?Mkkza0czRW92L2cvTk1XcGNZODk1UzJmZFFkUmdKMG5DZ2hEOVF3dUROMDJ0?=
 =?utf-8?B?S0F1dERvSW5COThJQTlON1hRWTl3QjZkSG9NM1NTZlJJQ0tkcmlROEswVGtv?=
 =?utf-8?B?bGJOWGFUVlFheHlBMFNFY0hOeGVQZWx5Z3VOTVY4KzFxTnFRcnBTbXRYTnVU?=
 =?utf-8?B?L3YzaDEzUU54WFBvRWdmZnMwcldSbjR3Uk1XRHZ6aDNuZHNwQlMxaTYyZzU1?=
 =?utf-8?B?SFFjWTA3MFd1S2kyU1VaSE1HKzJ4dTNPVE5wYjJZMy9uRG0xMmdLbXMzOXRT?=
 =?utf-8?B?RXQxRUc5ZDl0NE1ISC95cHJnZHZrOUZENzgzREVxVUM0akhueFA5YmdOMWFv?=
 =?utf-8?B?NngzUXhRSlE1SG5RVnp1a3VHWGl6NzJ1SjlrcVFtek91aGVMTXR4SzFHdEZQ?=
 =?utf-8?B?OWluVXlGQkFtdlhRWkJxU3JtZ1JPckpDVitpNmNwZk1zZ0FSNDhpMlMwYVE3?=
 =?utf-8?B?NkExUWp0Yjh1U25tUGk3UVJOUnh5bHU2N0Fuem5NbHc1WmNkNVRXT3J2VzFT?=
 =?utf-8?B?OXNDTEovYllnQUk3VjA5bTMvNk1QYVUrMmhCaFRmd2s4MXIzTU1ZTnFka1lS?=
 =?utf-8?B?YTB3SDlabWdLTjF1RlI1eUxMTWMzVWM5TUhjT1dzQVA2M3EvU3pZbEhIOGk3?=
 =?utf-8?B?N0wrWXZpamNMYWVrc1BKMTVrMzgwejAzemZuWmEvWXl1WXpLYlJ3Y1FqKzUr?=
 =?utf-8?B?dHB4Yk84d3RNZlYrU3VpNDAvSGRzTktEUnRPWGZQV3pFeVJiWTZVd0syV2Z5?=
 =?utf-8?B?TU9kSFpvN2pEQXhUdFJ1amxUQ3RIdGFRSUNGQkxodTI0VnNJeC9ibWRQQWpS?=
 =?utf-8?B?YVREQ1BzWk96am1FVmtyeUtIYmR3SWkxSzZXaXdoczV2N0pianN3eXRQTGNU?=
 =?utf-8?B?OUN5RXEyajdoak1DdXlWWStpUnB4WFNBZzJ3MHIxYWc2ZGtmYUViMzcveHFr?=
 =?utf-8?B?RXZlSUJ1UE9BVHVDMHdCeWdDWi9ITlFtdTgybU9QU1hyVVNhVHI1Qm8rRHU0?=
 =?utf-8?B?dXFSSHJvdkxQME1JOEt3UXFQRjJ0dG54dWZqZkdZMGxQM3pvTlBXdU5FeXBu?=
 =?utf-8?B?Q2VYVVIxZXAvZG1uNFlBRHlsVnFvYkNoakV1VndNV3dzYzl2cnlPSnZSSnJD?=
 =?utf-8?B?Zmc2TWVMMGVVWTlKcGZGb0VxTmV1d0Y5ZXhpR0xGR2dUTzNKSVJndTkwRmw4?=
 =?utf-8?B?Q1RrSnBkMEd5MmRwWTZQVlltQVZ2Nk02eTlTOWZpRXE3ekpNYmUxdG05dnlT?=
 =?utf-8?B?ZFJLVk9UNTg1WWdCVTVEeHNhZkgxaVRGK3kxQVRIcVhqTlpMMStVanlkS3R0?=
 =?utf-8?B?M2U2N1h5V1dLdm5BWEtBdVA3VDJiZzdhK1B4c2pBK09WbHBtQWd3M2x0dkZo?=
 =?utf-8?B?UHRTMjFQY0VNNkYxamovRjlmdXlreVJGR1kvTEkzc1V1S3RTeDRXK2hWL0t6?=
 =?utf-8?B?NFFORmdqbFdVN2NIelNLTHhXOUYvYlpmcFlSNjU2MlNudzcrYmhRZjBKL0ZM?=
 =?utf-8?B?cUdHaEt4QnpzRnRQR1BYZUEwSjlrRS9JcWpVc3VuOUkxQlEwaDB0NWQ0M25j?=
 =?utf-8?B?eldBblkxOWZody9qdC9oem5zWjZGcHhtZUpEaWJ2UFpsL1NmVDNUSGMrSHkw?=
 =?utf-8?B?VURGc05PTCs5ZitFVDJFMXlyWmtaVGRMeEhuWDdnS0draXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckZ6eEFxQlJFVmUxaW9rdHZRQUVlY1RJdDhndXdZTUFMM1AxNlRvVHZIc0dH?=
 =?utf-8?B?T3lGZVdlWS9DclpFL0NiVVIwbzdGcWtwS3VzV0hVTjZCRm5tNWNzbGR2Qmlz?=
 =?utf-8?B?VEpUSGtibnN2UUNQRXR3a1dMVlo0NFZQdW82MG9BeUxiUjBxTDMwT3hnS2Nr?=
 =?utf-8?B?YWljV21zcmI0VUxJYW1RZ2xpK0Q3QWdWamE4OU0vNlI1cFpkdjF0Ri9zZUV6?=
 =?utf-8?B?Z2crZk5pdlRiTzBLZ2w0NVRBTGMxRDZJN0M0cU9Tc0JTVjFpNmU2eTQxeUdO?=
 =?utf-8?B?cGJxVFkzN2E3cHNTaXpkVXZqeVVKU09JUVgwMy8xSUlva0FVK2F4cnAzdEps?=
 =?utf-8?B?Ni95emp6L1QxWGhMZnFndlNFZXpwMUNLV2paVnI3bjNCeFBmcW5yTmxVWUtZ?=
 =?utf-8?B?amxxK0MyTFliNWQrV1U1c0RnbHZDTUxmWFVlLzhVeTVrY1BpblpSMmxLV1dZ?=
 =?utf-8?B?eE5lZG9nY0d3ZEJJbW5KYVNSQkoyNHRraXZNaWxtWDViaHREdzFPdys5YzVi?=
 =?utf-8?B?VnVaVEJZeVNVTE4xdm90czVFc0t6cURLMS9ZaXlMS2Z2anptMWRPV1VZMi9R?=
 =?utf-8?B?dFBPSmxtOXNRaVFxSGk4Vkh4SWRJbW1PamxGSkVza1ErdTZydTVFRFF3YWlp?=
 =?utf-8?B?ZHhLbnozNldRMm11MkM5TTRqOXBsWGZSNDJndDhEYmVCRlgvMml1RWJ3UDZP?=
 =?utf-8?B?NkJBWHpzK3R6MWUxcXd6OEszdE5NaFBvbmhJWEhTQ2s0UFpJRzRrR1JDYzBh?=
 =?utf-8?B?WGsxY2FwS2oxV1lJdlB2SVBQQ1JSRVJkSnBjNTR3SFh1WGREM1RlZ0ZvU3BH?=
 =?utf-8?B?TUZYeElxZmdyUDc3aWd2QW04VTVwb1lBcjZNMCtuRmRwd1M0WW9CYk54Z282?=
 =?utf-8?B?RjNwM1V4bWgyNGdhR1V2MlZrQWErb2t5R0wxVTFvbTM4NHFrZFhEUXh2Z1BS?=
 =?utf-8?B?RzljRGZlUXptdHM0aFJKbE9UcC9IcHQvUEw0S1BhN3RnMUJJakR1c0VwZVVP?=
 =?utf-8?B?Zk41SEU0bUQwNjVBdHdvSVFsWGczZXZucFNKclRyU2lYcmloeGFLNjNIOWtI?=
 =?utf-8?B?Y0xjekxWSGFCUmZWUUcwQSs0OFpVaWxrUEYxWkZrYnNzVlU4aVp2VkptV2RX?=
 =?utf-8?B?dTRaYkZGVGpQNTFSTEM5MmE3MWJRUStnUm5OZTE2VW9XQS9IcFR2YzV4YjJQ?=
 =?utf-8?B?NnRFY1hqR0llTGZuVDBFanA3U3dnRVN4OE1SaTlHTXJ1VVhNVGUyV1o4Ylhv?=
 =?utf-8?B?VjZLTnRIU1JrdVdHZmVFUlNUSzFYU2Vva2pSU3E5SHRRU0hkNGd2NHVuK0JQ?=
 =?utf-8?B?ZDB4NmM1cU5UZ2hxeDZQRzNCbDRFRHFFcU9nMlZCaWdSUkJzYUFteTNrYnkv?=
 =?utf-8?B?VUNLVy9CZ1pFTlFGaDBrKzZxeGN0RlZQSXBicFRwWUR1VWJBUENpdWxQMWQz?=
 =?utf-8?B?aSsreUhpSGhGMzJXUXJRcFdrN2Q2ZUV6VURrSmMvWE1oUnJoU0NBYkV3c2JI?=
 =?utf-8?B?NDRzMHhWSmpWeVRYSk1KK2Vza1BtRWUzYnBBb2NoN1dsUkVCT1VZbXVuVkF3?=
 =?utf-8?B?WjU2UlNCUFoyRWZ6aHRWQlZWVm9IMitCbzNibGd1MkZFYTdwcDk0TEI1Wk1Y?=
 =?utf-8?B?c2ZOYzNxbVRlcndLeVl0ZHFVcTBFMjl4QnFiTEtJTGorQm1CQk9xQ3ZPVWtx?=
 =?utf-8?B?MkRBWWtzcnJhOG5XdUlxSk5zZ1QwN3BteHJjanpoQ0pjelNVd05KRVpKMmxD?=
 =?utf-8?B?RXU3MmxhUEJQc2ZGREdCNnBTUVdkbk0wQ3c1bkRlQm5XVThOU2VVdWZwUVYx?=
 =?utf-8?B?RVY0L0ZQUVJTR0lLeEhNY0tod0RLclplMHljU0duUkg3cDBkVlZzVDhIVTF0?=
 =?utf-8?B?TzNPZDY1azVKMzF5aWhhVDBGbHRaZE5Ka0JvUWs3MDlZbENqQ1djTFRhMWRR?=
 =?utf-8?B?WnBheWwzWmZuSytNeHhtZU4ycE5kYUV6MFRsc0JLVFBHYzJKVDNmYWxmVHI2?=
 =?utf-8?B?K0tYN0hCZlh4NmhqTkg5dmJsZWFsejRiOVlnc0c2NGQyWUdQeGo5UEppcndt?=
 =?utf-8?B?UFpROXdEb2lieFNTSG5xbk1TMnlHekJjY0JTVTFCWUpEUk9IL3VRcE8vUGQ1?=
 =?utf-8?B?NXdYSG1pWDJrbWlXNVd5UlhJUXNMZ2d3UTF3YXNzeEN5c052Z2FBMEJ4OXBm?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BB0414BD96D1048ACAD6F94B35C9A85@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b21b9cde-f96d-4cc7-4d06-08dd1efbc2d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2024 00:34:41.0493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o2FofLwQxh4bcHgZkoltRTuMzLY9JCov2ItdyWIPYhey2qFIJRCUjyerqxLNhKokDJfkRiTd8Pg3bS8GuimZlYYLC9RusPIjW2xHw7FuFuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6054
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTEyLTEzIGF0IDE0OjU2IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBIaSwNCj4gDQo+IHRoaXMgaXMgdGhlIGVzc2VudGlhbGx5IGZpbmFsIHZlcnNpb24gb2YgdGhl
IFREWCBNTVUgcHJlcCBzZXJpZXMsIGZvY3VzaW5nDQo+IG9uIHN1cHBvcnRpbmcgVERYJ3Mgc2Vw
YXJhdGlvbiBvZiBFUFQgaW50byBhIGRpcmVjdCBwYXJ0IChmb3Igc2hhcmVkIHBhZ2VzKQ0KPiBh
bmQgYSBwYXJ0IHRoYXQgaXMgbWFuYWdlZCBieSB0aGUgVERYIG1vZHVsZSBhbmQgY2FjaGVkIChp
bnRvIGEgIm1pcnJvciINCj4gRVBUKSBieSBLVk0uDQo+IA0KPiBUaGUgY2hhbmdlcyBmcm9tIHY0
IChodHRwczovL3BhdGNoZXcub3JnL2xpbnV4LzIwMjQwNzE4MjExMjMwLjE0OTIwMTEtMS1yaWNr
LnAuZWRnZWNvbWJlQGludGVsLmNvbS8pDQo+IGFyZSBtaW5vcjoNCg0KRG8gd2Ugd2FudCB0byBp
bmNsdWRlIHRoZXNlPw0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjQxMTE1MDg0NjAw
LjEyMTc0LTEteWFuLnkuemhhb0BpbnRlbC5jb20vDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9r
dm0vMjAyNDExMDQwODQxMzcuMjk4NTUtMS15YW4ueS56aGFvQGludGVsLmNvbS8NCg0KVGhleSBz
dGlsbCBhcHBseSBjbGVhbmx5Lg0K

