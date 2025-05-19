Return-Path: <kvm+bounces-47010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7673BABC5E5
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 19:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2D613B7708
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 17:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1F9288C18;
	Mon, 19 May 2025 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="htdPb8wN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71611F0E56;
	Mon, 19 May 2025 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747676978; cv=fail; b=fgb3XYR0HNYeD8RA6weN8SgcfL01Que+Y6Nfwzv9FVeC5xkqg7KYEPTGdLgL+UdikY4Y6HhdgQKVhkr1BFX5WV6eIqjyEtgxggmaFnkzM87dlzeipdeR1yMoZLPtqmrgB1qODiJ5VQi9rTT1+eKZaR7unnnRG5Gvx8shYkfqFUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747676978; c=relaxed/simple;
	bh=5+efspy6+KFt/ei5FOlndH7KfRME8vCwQcstBEzCrFo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CqId132SSPVOQIkItIlg555uw4C8LEhUG7ZeuG3JBY1wXGBXp/tyvbN1RQkn9W5GQquDJoDYHLDFkL5Rn8h5g31Gj21nHfiIxiycj9tDsbhGDQuBq6oBA0Y38uJ7CP/Ruv7OWltcSnRkWIUbq4Pd9zckxN8RzdhxNv1o0vAzzKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=htdPb8wN; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747676976; x=1779212976;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5+efspy6+KFt/ei5FOlndH7KfRME8vCwQcstBEzCrFo=;
  b=htdPb8wNV/a/3hZG5Z0kxwKAKyeHw+dS+3GBsxh+ZBWz3uTTXlfD+FEx
   k9mMalWOq0d9G3/YMP4gnknMtvzxoLwlgXqfEZ/Ql2b+bB52DVD+ATHom
   4lSaJX8/uuJR1eRlWXhVXpHZvtRuUA0pOn++/RxbjyS4sg2Tfr4vP/KyR
   UPt2scP5jVNI474aaJOwozLZESFMRBrxIYWJWAlgk1PUB9fBVGAXtquv8
   fMaOjBonpy49sd1iwtpKgnOyBhDmJDuR90QydK31HOELRDP8l/Y9QJrPK
   DV2R4YiQygkAsOqmDDa2yPSF1gKWJTkknQBP9r6QlHcg4yr1NePZ/z4/r
   w==;
X-CSE-ConnectionGUID: G4eLPbkjT9aGbJoGYpTVaQ==
X-CSE-MsgGUID: gqh5iB2YQ2qUDPH8oKbpQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="37203922"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="37203922"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 10:49:35 -0700
X-CSE-ConnectionGUID: qMbzZ8hrT0CeJ2bWDdpGLQ==
X-CSE-MsgGUID: d0GW0UuWSOCTglX121jAIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="139473508"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 10:49:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 10:49:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 10:49:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 10:49:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HUnTd1KBVRHgFDuIlo1UwwYw647IMpN3XfMT00eL4S+owPxgxMOloFQJZ3Y0oa9kPxmKESFT6dstzN1ehJNN9xq4FMq+Nums/hAU4LpuY7fii7SOG4wViFqx5xsTmsELpuBvlnaDQJqoDaVg9uQmW60Y2GtygsC/udhhWapbHJKSe6LuRwc1kAD19asvkzl3e3wegTJF3ANZkpbtq9AhEU2CIzO91dO7lsM58pB99WNC32GIfjY2+xkxXcQHfuork2/6BeW/Ph/Vo9bd2LCLgFH/A0XFQJoJLWFRbjw5oaNHSkhGImY+8KQCne6tTZeZVONKNkUBWkJL8bIwUXmycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGdOOGF+HODJ1DuW7nZnpPE4CVj5NIDsHdlnIlfNbPI=;
 b=VBYF0APv+0i2q3W4FpoqBTPC6QVNRbxWXjOV6+rWGE8fD0unwugZ8gGS2XhsZitF/okFOTByJXx4pC10n1K8SZAsH5RunecGRddKNJFNqSYFJ0D6iwS3JpYAcW4EiWDMTzxheZcfOMN+r+lfzHb74u2MRZm7qJ/pFy1O9P61O58zU1aHmA6dqaEmqbi+dGYBxwPvlsbpulSe4KzxOZy8JOeDCdPrABF/BCf44zZP1gGRbIN2NkGQQZ7kcei1C3BhwgLoWjZskDjPjrFo6po8KBCrYdZ4vK4/Ot1ht0iYuqyGbSbzACKeEhlHpZrHWC+o7bLxftQTPXxcvKtWj9Ku7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by MW5PR11MB5882.namprd11.prod.outlook.com (2603:10b6:303:19e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Mon, 19 May
 2025 17:49:02 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%7]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 17:49:02 +0000
Message-ID: <dcdb3551-d95c-4724-84ee-d0a6611ca1bf@intel.com>
Date: Mon, 19 May 2025 10:49:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault
 retry on invalid slot
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>
CC: Yan Y Zhao <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
 <20250519023737.30360-1-yan.y.zhao@intel.com> <aCsy-m_esVjy8Pey@google.com>
 <52bdeeec0dfbb74f90d656dbd93dc9c7bb30e84f.camel@intel.com>
 <aCtlDhNbgXKg4s5t@google.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aCtlDhNbgXKg4s5t@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::21) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|MW5PR11MB5882:EE_
X-MS-Office365-Filtering-Correlation-Id: 614a865a-182d-452c-ec9b-08dd96fd7106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V3g4bHMwWU43SkgxZTh5MkxUbThReHZweXFJclRvczF5czhjT1AzWFlBRFdU?=
 =?utf-8?B?SGhvRGY0dU9ybzU3SnZoczJOU2EwRHFUMFozRFpxUGNvVXhjYk0zanRHSUJG?=
 =?utf-8?B?Q1hGUklVZHZTa0FkYnEwRzVmcjhIVTdXdno1Q1RvQlpjNVpRM3pGL2JRZlRv?=
 =?utf-8?B?ZGl4dGFvMXJQL1RaT1dRZmNpQ05Na3pvMCtPYkdsNmM5U2Nsa0dMRW1hVElY?=
 =?utf-8?B?dGo3cDZkR0pVRnRuY3N0cGZoMU44WSt0ZDFGaVNlTG9KOUk0bG5ZKzUxTERP?=
 =?utf-8?B?R20zLzJRMWlwNVA2OFBxTzEweTRHWU9yTUdPY3hxL0JWV0hNTGVrS1NnRTd1?=
 =?utf-8?B?a0QyRm5hVDBRSlhOREhkeDBLWERBYzNHdU8zRkRtUVFBY3d1eTBXWkZZYUsz?=
 =?utf-8?B?NHFhWllqQklKMnVJT0RFZC9HaWlheE14MERuQlVaeGlTYnRDR2diKyt1WVNI?=
 =?utf-8?B?eDZwVGdxZEk3V0t2MFdaM2FJU0tDV1R6cmFlMHJvUzNGdjNTLzZhNzZEbVRY?=
 =?utf-8?B?N0RocnZqc2F1L3BUd05yS0RHQjdEeEZaL1ZYalgydzF5M2drZE1GUTBabU12?=
 =?utf-8?B?ZmRIdVZFZmdXb2F4ekt0Q3pTY0MwVFFOSHNGSGFEMFYxeldFK3J0WmRnbHk0?=
 =?utf-8?B?eEpLRmdMYU9GVWJ6c0NHSUtkZ25MNytxTnVNTjNFelpWNThEKzVHZDVqSEov?=
 =?utf-8?B?MmEybTRGalNNOEpkTTlVSUpDSHFzSnlIZDMrZWNLRTFrRUxwUmhnaGRYY29G?=
 =?utf-8?B?OFlaSHpvU0J2YmJPSVBWdFk2QWtPNlJxS2dvd29GMXZ3U2lzdm5xUllreVlM?=
 =?utf-8?B?RDI4SFZLampJQnJOcVdXZkF4anpHanlWMkEwdjZqS1JET2JidFhad3VtdUpI?=
 =?utf-8?B?STAvbGxIMDYvZzNtUnFWRFkyUkFPN3d6MDZRelp0TXQ4aGpaQ3QzQTY3dHpF?=
 =?utf-8?B?Z2dIS1JyMHdFMnZWS1BGSTB4MTJkaFQ0dGRkWGxiVlJMdVE0WlZOZmFMTVlK?=
 =?utf-8?B?cGFQZHZNcXp0Sk84RE5xZWxDTDdSdHF0aGllWW1OdkdZL3IxY2swcHRmNHgw?=
 =?utf-8?B?aE4yQ2loOU5yUjgrWWo1eGVLYnl1RG13Wnh5Y3NCbVB5Q3Q3bHkvbjlmSmRy?=
 =?utf-8?B?NEk5b0JCUHhTdFpyTzZkQkJPUkN3bE1MTE5pWHR2Wkx1aWhUTjl3UjJYdkw3?=
 =?utf-8?B?WVJ4RnZRNlJYaE5GemE0SXIzQnZCVStBWENya2ZLTTlpSnREbmkrbkZVV1pD?=
 =?utf-8?B?cXVEL2g3VlRxYnVpdGpudktOOVhWakdneDRjU3NuVUVRNU56akIvSkJselV3?=
 =?utf-8?B?MmpjeSszdjRabHFGYmZlQXIwbWFudVR3c0E4REgwRGsvS1VvcXRXMEUxN05o?=
 =?utf-8?B?V0loVCs5YTRhM1VyQ0ppTVlGclRuRHAxSHVhQ1NlaGlDMXVscDNMWjcxaFlr?=
 =?utf-8?B?aDNXNFZHNFh6VENkZUFCNTNqZkZnVGdZR1VTUENKdkNTM1BVSzVEbW5OMTNQ?=
 =?utf-8?B?dWJPYW84ZUl5RUllQnhoZExQakZqYWFCU3ppZUgzMFptUmtHU2p0YURGMFdK?=
 =?utf-8?B?YnJQNEFyVG1nY3h5bXJ0d1ZVRlEwVmtKMng3YVR5RW94QU5JNWtpNDBkN0Rl?=
 =?utf-8?B?Zk1qUC9hWGRsMzNjejJCd2JyNGFqMlNuZVVQUEhkYkI2OFVXZHFKZ090NXZG?=
 =?utf-8?B?R2VpMVRZVkpzbzhLVDRkWndOZW54WkpGVWVxaVZ4bWR5bVloazFoUTFMUXZL?=
 =?utf-8?B?dWdQSUVMaTN6U0ZaK1liN1RyRkhZeHN1UVM4allJRndEaEtaWTNtelk4ZlVF?=
 =?utf-8?B?YzljVWM0SkhzTHBxaUc2b0Z3RU02TUE4aWhGNVlML0RHbkg1WUJjWDNHb3NM?=
 =?utf-8?Q?yC5pFNAgfHvzk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cS84bER0ZXl5RmpHMmd6bU5vOVRyUDI0YnRnWFcrcWJsYWZ4L09rM2wwSmFk?=
 =?utf-8?B?WnQ2N2RQd0JZYXQ4dS9DSUlRN3Y1T1FOS3FVaDVoVlFad2VnKys1Yi80OXBH?=
 =?utf-8?B?cEhkeTBQV2VzZUkxQXkxeXJ4LzVnUllQTXVBOFhEWEVlM0V1Rld0M0lOeGo1?=
 =?utf-8?B?RDJlaGVkSkQzNFBzM3JvbTRHakxZM2ZMOGtQTEVQQldSR0FVM01QOW9pekRP?=
 =?utf-8?B?UGthVGx0Vm1JakFydzFNS2dISk5ZRVVaYlBlNWVCQ3BaaWpYRFV5Q2RMbG9Z?=
 =?utf-8?B?blE4RnFUbFdKM0ZxeVhoVW5sQkp3bVJxT014WVdSUTBXcFZDN24zeEF0Z09S?=
 =?utf-8?B?MFE5UmR4ZkovcDVKcW92UnRhT1FKSkFxd0poQmEyc1dHVjNxWHNMbHVOekhi?=
 =?utf-8?B?dk9BMmV5R1hkNERRa1RpdzNkSVNyK1lsb0lTUmt2SzFSYWdUbU9FS20zWjhl?=
 =?utf-8?B?WDRGNitoYlpzTEM3dUdQdCtLU0tJZkoxL1lDN0Vra1I5aHBBbVl1SDltdTJC?=
 =?utf-8?B?QTJwSnpyVnBZb25yamFMaEFPMThwM3FYNVRlN045RzBaTEw1YzE3OEhtbm52?=
 =?utf-8?B?MWVubktEM2NUOEN5alRGUXBkN1RPcDdFRXhic0dTaHR0MDJVblJhQ0xUTkVN?=
 =?utf-8?B?ZkhlZTUvajIxK3hIMkRGZnh0NlhlenYrSGV6cUhEVm9ubWlnMElnT2lvZWJn?=
 =?utf-8?B?UlVQbENYbEZ2UEJNSi9iMWRtUGhJeHRzNlowV09xOUFFVmhORzFvcWtWZ0dN?=
 =?utf-8?B?NDhyUmk4Yk55a1UwazQ4eUJXdjNYWGJYYTlzSXMyRUdnUTVoNkJ1V09YN2hl?=
 =?utf-8?B?UCtKNWx4YVRGVFhYT0ZrdUJRd1JBSWdJd2YrNUZCTG51QytjTlBsQlMwc09Y?=
 =?utf-8?B?VkRwalJXQzB0b2pXMy9MMk1OTmY1YXZCY2FuNHd4SmdNWTIvcTFnRXUweDZI?=
 =?utf-8?B?RDRFSzIzUG93UktaYzJRUW8raHJlajFFVDlrREttaHViRFp6bWd0Q1g0RVdL?=
 =?utf-8?B?MGQ2bEtySW16YXJsUjJ2ZGZOOEtXRzZCYVNSSUpobnBrRHNDc3pjR29aZSs4?=
 =?utf-8?B?NFlvQzE1Tm13SkNSWFlrVDhVelljdEptVXU0Q3lOb1M4RkJxTEQwL1lsT1lU?=
 =?utf-8?B?NlpNYU5hZFQ5c3c3RU9WRHZoVG8zYVBCUkVwS1E5bXNnUnAzT3NpRnppT3h4?=
 =?utf-8?B?cTc4d3NZRzdIajZNUCtXVTdDSXRyZmFhbG5LSThyKzZsZEhxMFgzaFJpa2pI?=
 =?utf-8?B?Q0lOekdhcGNLZ3dTeXdrQ2lNU3RRdnhkVTNVS3F6U3BFL0h1WVZLTUJHV0Yw?=
 =?utf-8?B?UWlhZDF5aHV4bmkwY3BqVndwaHE5MkRhRmVGSmo0c1dOeEl4SGZjN3pDUGJ4?=
 =?utf-8?B?Nm0vZkllc0FKVkNLcmFRZ2tiUkI5blpIWkt3TWo2VFBwMWlNd0Qzc2FVd0Q5?=
 =?utf-8?B?MEdEZndjWEF1MDhXQldzcEV4WFJXbjN6Rk1oc2M4a3VsYVdaZXhhOS9pRHFM?=
 =?utf-8?B?Q0I1cStucnJZYXZBOXZuMERBWnJLQjhvRWR5UE9saTRWM3NpYURiQTBYK2hB?=
 =?utf-8?B?MnBNcEU1MEdIOHkvalMzdUQxRDdYUXRqV2ZFU3Y5Y0VCV2pPOWZkVVBMTi8r?=
 =?utf-8?B?aDlXRmNmTUJ1MzlNYjlsVFZobTRrekhjckx6SU5VT0wzYVdodmZxclE3SDVG?=
 =?utf-8?B?ZTdBZ0dTbElJU0FxV1NnZkhqa3lUa3ErNzAxY0tIcXdRRU96MzFvak5Lc3JX?=
 =?utf-8?B?ZGVRYW5pME5ybTBlbWlpSUMrZEpHSmwyMjE5YlRHUktFbUZnUy9uUmVtZXg0?=
 =?utf-8?B?WmY0NndmY21yRXo4WWxyRlFZZkp0TUZyYXBrLzZCaXZhdGF2Yys0ODdXSCs3?=
 =?utf-8?B?OG9UQTBBalVmWGRLb1pabGRCcWV0WDczNnM4WVJYZG9YUmxkTVVaYnZZdFpZ?=
 =?utf-8?B?Q09hWHBjZnc3aXJVWFFxUTB6aENhVEdyYkU3d3VoaDJuSW5GUldMeE1yZFg0?=
 =?utf-8?B?WnJpMUc0T2szQkxzWWQxeEFXemN1SXJ5c2o4N1hiUTI0OWtGUmdQMkkvWVJI?=
 =?utf-8?B?ZmI2dkFaWnd4YjdiM296R2FlcG95cjRMdUNEakVsdXYzYkJyTjlybzFBcEZZ?=
 =?utf-8?B?QkJnYldySGpsZkhyN2h1YXAxRFVJZ0ZxTDBVcVI3ZE4wWDZCejJlQ2t4VnNG?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 614a865a-182d-452c-ec9b-08dd96fd7106
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 17:49:02.5556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGH+Y0SiV3UvXeN1dPWdHKIvEk3rconbnV18pgCi8WrIZgVlxm33SAP8Ov26uQ9ey3+xYUGyh05LMe5zUwxSgziY0reaiukwFL1FPnKNcgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5882
X-OriginatorOrg: intel.com

Hi Sean,

On 5/19/25 10:06 AM, Sean Christopherson wrote:
> On Mon, May 19, 2025, Rick P Edgecombe wrote:
>> On Mon, 2025-05-19 at 06:33 -0700, Sean Christopherson wrote:
>>> Was this hit by a real VMM?  If so, why is a TDX VMM removing a memslot without
>>> kicking vCPUs out of KVM?
>>>
>>> Regardless, I would prefer not to add a new RET_PF_* flag for this.  At a glance,
>>> KVM can simply drop and reacquire SRCU in the relevant paths.
>>
>> During the initial debugging and kicking around stage, this is the first
>> direction we looked. But kvm_gmem_populate() doesn't have scru locked, so then
>> kvm_tdp_map_page() tries to unlock without it being held. (although that version
>> didn't check r == RET_PF_RETRY like you had). Yan had the following concerns and
>> came up with the version in this series, which we held review on for the list:
> 
> Ah, I missed the kvm_gmem_populate() => kvm_tdp_map_page() chain.
> 
>>> However, upon further consideration, I am reluctant to implement this fix for
> 
> Which fix?
> 
>>> the following reasons:
>>> - kvm_gmem_populate() already holds the kvm->slots_lock.
>>> - While retrying with srcu unlock and lock can workaround the
>>>   KVM_MEMSLOT_INVALID deadlock, it results in each kvm_vcpu_pre_fault_memory()
>>>   and tdx_handle_ept_violation() faulting with different memslot layouts.
> 
> This behavior has existed since pretty much the beginning of KVM time.  TDX is the
> oddball that doesn't re-enter the guest.  All other flavors re-enter the guest on
> RET_PF_RETRY, which means dropping and reacquiring SRCU.  Which is why I don't like
> RET_PF_RETRY_INVALID_SLOT; it's simply handling the case we know about.
> 
> Arguably, _TDX_ is buggy by not providing this behavior.
> 
>> I'm not sure why the second one is really a problem. For the first one I think
>> that path could just take the scru lock in the proper order with kvm-
>>> slots_lock?
> 
> Acquiring SRCU inside slots_lock should be fine.  The reserve order would be
> problematic, as KVM synchronizes SRCU while holding slots_lock.
> 
> That said, I don't love the idea of grabbing SRCU, because it's so obviously a
> hack.  What about something like this?
> 
> ---
>  arch/x86/kvm/mmu.h     |  2 ++
>  arch/x86/kvm/mmu/mmu.c | 49 +++++++++++++++++++++++++++---------------
>  arch/x86/kvm/vmx/tdx.c |  7 ++++--
>  virt/kvm/kvm_main.c    |  5 ++---
>  4 files changed, 41 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index b4b6860ab971..0fc68f0fe80e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -259,6 +259,8 @@ extern bool tdp_mmu_enabled;
>  
>  bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
>  int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
> +int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> +			  u8 *level);
>  
>  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cbc84c6abc2e..4f16fe95173c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4851,24 +4851,15 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
>  {
>  	int r;
>  
> -	/*
> -	 * Restrict to TDP page fault, since that's the only case where the MMU
> -	 * is indexed by GPA.
> -	 */
> -	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> -		return -EOPNOTSUPP;
> +	if (signal_pending(current))
> +		return -EINTR;
>  
> -	do {
> -		if (signal_pending(current))
> -			return -EINTR;
> +	if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
> +		return -EIO;
>  
> -		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
> -			return -EIO;
> -
> -		cond_resched();
> -		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
> -	} while (r == RET_PF_RETRY);
> +	cond_resched();
>  
> +	r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
>  	if (r < 0)
>  		return r;
>  
> @@ -4878,10 +4869,12 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
>  	case RET_PF_WRITE_PROTECTED:
>  		return 0;
>  
> +	case RET_PF_RETRY:
> +		return -EAGAIN;
> +
>  	case RET_PF_EMULATE:
>  		return -ENOENT;
>  
> -	case RET_PF_RETRY:
>  	case RET_PF_CONTINUE:
>  	case RET_PF_INVALID:
>  	default:
> @@ -4891,6 +4884,28 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
>  }
>  EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
>  
> +int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
> +{
> +	int r;
> +
> +	/*
> +	 * Restrict to TDP page fault, since that's the only case where the MMU
> +	 * is indexed by GPA.
> +	 */
> +	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> +		return -EOPNOTSUPP;
> +
> +	for (;;) {
> +		r = kvm_tdp_map_page(vcpu, gpa, error_code, level);
> +		if (r != -EAGAIN)
> +			break;
> +
> +		/* Comment goes here. */
> +		kvm_vcpu_srcu_read_unlock(vcpu);
> +		kvm_vcpu_srcu_read_lock(vcpu);
> +	}

added "return r" here.

> +}
> +
>  long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				    struct kvm_pre_fault_memory *range)
>  {
> @@ -4918,7 +4933,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	 * Shadow paging uses GVA for kvm page fault, so restrict to
>  	 * two-dimensional paging.
>  	 */
> -	r = kvm_tdp_map_page(vcpu, range->gpa, error_code, &level);
> +	r = kvm_tdp_prefault_page(vcpu, range->gpa, error_code, &level);
>  	if (r < 0)
>  		return r;
>  
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b952bc673271..1a232562080d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3075,8 +3075,11 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (ret != 1)
>  		return -ENOMEM;
>  
> -	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> -	if (ret < 0)
> +	do {
> +		ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> +	while (ret == -EAGAIN);

added closing '}' here

> +
> +	if (ret)
>  		goto out;
>  
>  	/*
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b24db92e98f3..21a3fa7476dd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4266,7 +4266,6 @@ static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
>  static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				     struct kvm_pre_fault_memory *range)
>  {
> -	int idx;
>  	long r;
>  	u64 full_size;
>  
> @@ -4279,7 +4278,7 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  
>  	vcpu_load(vcpu);
> -	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	kvm_vcpu_srcu_read_lock(vcpu);
>  
>  	full_size = range->size;
>  	do {
> @@ -4300,7 +4299,7 @@ static int kvm_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  		cond_resched();
>  	} while (range->size);
>  
> -	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +	kvm_vcpu_srcu_read_unlock(vcpu);
>  	vcpu_put(vcpu);
>  
>  	/* Return success if at least one page was mapped successfully.  */
> 
> base-commit: 12ca5c63556bbfcd77fe890fcdd1cd1adfb31fdd
> --

Just reporting on the testing side ...

I just made two small changes to patch as indicated. With these changes pre_fault_memory_test
(with changes from patch #2) hangs (with KVM still responding to signals). fwiw,
pre_fault_memory_test also hangs with [1]. 

I also tried out the TDX stress tests that you do not (yet) have access to. The stress tests
passes with [1] but hangs with this change.

Reinette

[1] https://lore.kernel.org/lkml/aCsy-m_esVjy8Pey@google.com/


