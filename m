Return-Path: <kvm+bounces-69498-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id I4NKOTi9emnp+AEAu9opvQ
	(envelope-from <kvm+bounces-69498-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:51:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3391AAE3F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EB10A300D73D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941F82FFF9C;
	Thu, 29 Jan 2026 01:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C9I1NSSc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AED2BDC3F;
	Thu, 29 Jan 2026 01:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769651499; cv=fail; b=ns1eYYVsciJTydqR/z+DV0BlQRZcCBLS04SRmZED3L/2+rGSVXoqYmvZxElKFLMzYPPc4Ex7Nehayi1mnmOa4sSgTI38crUI1Le1nUiIV5satEOl+K4O/AtIBOT13GoyNzqwKtFwHJHYVTzIzzmziVzq9QRkBQCh8biI8NXOXqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769651499; c=relaxed/simple;
	bh=sB03Z0a1GnNBUcV/012ozIJQFMOa6ylOhlGt9dAbIsE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dayf9K7C7zkovfk+fiEKc7BhL3aK+3ymnlDR3Z+vYE6R7HYJqIllS+CmTKkfYIahE20rCL8rgEVZwqXZSbfL2yq8d0XCaa1CTO1KxnEWWC7b6QSmgHfW7FYoONdflQuqSYEnf3+M/x+XhCk9el1O8qKb1B0+gewQtT9VSXoK/g8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C9I1NSSc; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769651498; x=1801187498;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=sB03Z0a1GnNBUcV/012ozIJQFMOa6ylOhlGt9dAbIsE=;
  b=C9I1NSSc63VOhYQhwzyszMl4tfZymvL6ZLYFaS7h9nhiXMZxiXYvTvNg
   ERrAW2vU2xdHmKbyWZ3w0jTSv0VHoCMOfaJ6Ju6pIp+aWwildk/Vb/Vg/
   jMK9YY4/MlaJ/EH74feAW2VcBUOOyWh1Dv27wIbjm/1aMngnd4SytgomA
   gJirC0WF4b1yoFacpfu1I4xRZLovPASdLHzXnvcQjqn9NLdVj+iU5xvN4
   geVycWs7wuk6nKnIqWNXb7g8HzIfFEWCQSqFFhzFqIfVl4gOXzg5+rlwW
   xLoDS3GGbV76W4OMoMtPffqzBq9qT9Aj1DydsepE2yR+EOjv4mQz8a2ms
   w==;
X-CSE-ConnectionGUID: iFzo5TiyRdOREsqYpl7ZRg==
X-CSE-MsgGUID: aRQWWlJfTY+svy1GiSwG1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="70782061"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="70782061"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 17:51:37 -0800
X-CSE-ConnectionGUID: TxGtpL9bT3yYQvpAcVYGig==
X-CSE-MsgGUID: HyZs9JwrQQKv81CEaDA17g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="208666411"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 17:51:37 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 17:51:36 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 17:51:36 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 17:51:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gKnxV0coOROS6PI87oOx/vn98OCpfZteQliKNgPn4n8EfHmRmgEaOcC4nCUm0iLAQq8jc2pCK0hgXnCaTrwSp9/qrhNRHkq2Qm4hsPObzvcNJQ5uSB4qR9C7+mzXmoyV6prx5G+LLbnBideg3RhnZvFOFjKh+YEbvf+LJsyuXCQGgHTLhJWZ6xEtfgNewH8scvZXaxHZscrGGrSUY7KYfK9JLZP4erAbUKHpU2ff8LO29Ud+GjMFaqFM6mMNsMQb13VIxP3NHv7BiwwaKwb9CJxr0NIoziafE9D/FiwZ6mzn93le2+V/A98Se7+OXWUJbZnEtx/ob2nNYja3sE7cHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCdfhQAWYwk0C54MBDERbQZvsIcWX3xlZkGm+BUd1gI=;
 b=JcHlSkSRsbag4WZGKOkGurGnZLyhoBCNWrAimhrj3UNmBvR/auEpnRnadMxNbGAQHdrctzUUqqYJsHoAoWB1SbE0JfsOlQfT75KwLG1Fhj/7R/pnfMauXgkK7fw/5aBjUGcQAcQ29q5j0Ewhm/FyTr7vhEYu1vu1vWrqFxShoOwaxm/FYNFlnBvAH217x79gEJiehenZSrX/3LM4JEQZsfB3l84e7tQC3Ou4dB3jFMEvgh0HVar/3K2ay9ALK1GsOt5EyMM02p2q/xDC4iYPrtmbE+8AtBLYtmLNIO2Acm6gsO/zjq6Mv2Np1VzLjnw5+LHZ54vFZJMcMO/RGr4yBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 CH3PR11MB8591.namprd11.prod.outlook.com (2603:10b6:610:1af::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.7; Thu, 29 Jan 2026 01:51:34 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::fde4:21d1:4d61:92eb]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::fde4:21d1:4d61:92eb%5]) with mapi id 15.20.9542.010; Thu, 29 Jan 2026
 01:51:33 +0000
Date: Thu, 29 Jan 2026 09:51:18 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sagi Shahar <sagis@google.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <vannapurve@google.com>, <paulmck@kernel.org>,
	<nik.borisov@suse.com>, <zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Borislav Petkov
	<bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
	<tglx@linutronix.de>
Subject: Re: [PATCH v3 00/26] Runtime TDX Module update support
Message-ID: <aXq9FjfgSRLmT4tb@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <CAAhR5DG7EOpmKYV4WmiyNYr14rKMNuTcqgvoaeZt5-==kSPmuw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhR5DG7EOpmKYV4WmiyNYr14rKMNuTcqgvoaeZt5-==kSPmuw@mail.gmail.com>
X-ClientProxiedBy: SG2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:3:17::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|CH3PR11MB8591:EE_
X-MS-Office365-Filtering-Correlation-Id: b674bfa4-23f5-4453-9764-08de5ed8edf5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y3l6MG9HazhDaDQwd2NKdnVvTE9EUWNNREFXQlU2MzBaWXUyblVUQmg3dG9S?=
 =?utf-8?B?Ykw2SWk1T09FL3dRQ0ZTa0ZmUUhDbmQzL050bkFBektUYnFQZU1HMHBuKzUw?=
 =?utf-8?B?R0c3SUVDWWEydlQzcGZUODZyNXQwdFNkc3R3UDhqS042T0Q1c1FMSldrMEpj?=
 =?utf-8?B?U1VQNUR0blNBbUxKeUZJQUlrRHFZQ3pLSHE3bGw4Y0h5UEIvcVhyRjJOaS9o?=
 =?utf-8?B?TU1qblBsVitFd1BZSXp0WjFwSCtsV1NmK0JaYlY2MVJla2tvMVJOTmh5UWF0?=
 =?utf-8?B?YWNvTnJKMklxVnI2QUVHZDNKVlZUclJaUGF2SjBNNWlwZUxYdHNYRWlJYXpI?=
 =?utf-8?B?MmhMKy9JTEp1V21DUCtrQWlHQjV2bDJ5aFRFUzVlWWxyQVJ1eXptTlZTVElx?=
 =?utf-8?B?b3VRWWowZ3JGSzN4K3hKcE44dlJJU1oxNE83SThSd2RMNU9XbnhDaDJjZXBp?=
 =?utf-8?B?aXJZbUVEN3RWZ2phQTU2anBKbGFGb3R2OTB1S3dPNFN0Q2ZjVVQySDl2d0lI?=
 =?utf-8?B?SUZHVFBoU0xuSm9UY0FzRTFySC9OVFQ1OG9ndmNkYnVrRHRHTEs1RS96bWVh?=
 =?utf-8?B?NCtEU0czWUN0WmJWSTdmUnNGZVRJWXdRMnBCbWxheVdSYWpKSk9rUEkvYTho?=
 =?utf-8?B?VDhRNjFxZXhLN090VE1rT2FxSFFZN2wvUjEwLzF0bkMrQkl6M2tCOW1Uek5E?=
 =?utf-8?B?aXFVY0NubWE3OFpLYWJqYXFoRytGd1NETTJFdTl0UVh4ZW1Od2FlelZndVdP?=
 =?utf-8?B?aWhCWVdyTTNhTmdMWUtrTGtsaVF6VlpnWWZHTlBEMU5DY1BRbGw2ZE5EUnFC?=
 =?utf-8?B?NEtjWjc0M1hQQmxXbFcyZWdHRUN5Y2dwSTZ5R0czUU1xUmFaUmpWSUErcHVr?=
 =?utf-8?B?TGxJb0IvT2o2K2VkVy9KUzBDRE12bGo4Nm10MllsbFJWYWFaV2tqbFNCSW9n?=
 =?utf-8?B?R2V4eVp1cmJDRnNyKzBhbnF5QUJqam8ycUNDamtLTGZjbG9rSzNNLzBKSGJt?=
 =?utf-8?B?ZklTY21jdytxbm1GV2F3bENScjVyYUdtL09BZlNLS3A2VHc4elRGZnJya0Ur?=
 =?utf-8?B?ZjhiNExLMFprdW5xZS82d0J6c0VhUkV3V2pTYjdvOFpsa0lRUnVFMm84TUxz?=
 =?utf-8?B?QTA1WFFLM0loSXg0cURySWpEQjJsQkpsMTJMZUlHdmxQUk9LMFNsL0hVRHIv?=
 =?utf-8?B?NE5CVzVObmpYOHNBWVlUSUdxQnpYUk1oa3AwZ0dGbHM2MnlEbDJyRURaa0JU?=
 =?utf-8?B?Z1R4QU1hM0svY2VNemU4T2FPenB0NmdiajRmLzI0QU5MUzhpcVh0SEZHUHhR?=
 =?utf-8?B?RmVQWTZDL3U4ZzB1U2xid3VseWlGNS9QdU1oWGx1T25vS1JjOGVQTW5PZS9B?=
 =?utf-8?B?a2RCdmNIWFpBVk1pNyt6Y1ViTFpjajNzTlo4QXlBdk9TTitnenZDVzVEZGZ0?=
 =?utf-8?B?QkQvOFQ5WGh3TS9Ccnd4aUhyKzd5d3ZEVnptTGhkTVBpcVU5SXI2bHgxQXhh?=
 =?utf-8?B?UnRCRi9MajJZWENnR2l6dCtBdUIwYjFHNHZqWXk4WmJXMkt4QTlNUUdxUmNl?=
 =?utf-8?B?QzVxbUU4eXFHSU9JT1JqVXdNU3duZklYbjRNNzczS3FybnJEOERGcGU2eG9w?=
 =?utf-8?B?aG1aZUVGZW5qUkk1ckZVbWV3ck8rQk1FcE1IOUNuajJ4OVNFNXJWUkVQSlVO?=
 =?utf-8?B?Y095S1JzanNJWnlIWkpia0hRN1Bra0R3VHlwQlUvMGE5TWRaZkZLa05ybEtx?=
 =?utf-8?B?Y2MrUW9sOWsrUnNBaFIwZUhSZW12ekpVaTRCcG9ORW5abm1odTFTUHo0T2tl?=
 =?utf-8?B?UmF0WjIxSWhUZGxqMXBQZG9OaGRoUlFLaFo3WXpZZUtOcFd5bVY5ZDNtenpN?=
 =?utf-8?B?RktsVXJtc2RLTEsxRmtEejFtMnZWWUZvSEJUTEFpYXZvMVQyZWJKa3QzQW1o?=
 =?utf-8?B?SjBSMkdRTmVmYlAyTjlYcnVNUDBhMVh2bStEbG1zdGRiTHU5cWpuVTI5Um1L?=
 =?utf-8?B?NVI0Wnk1d0MrNFF4VmNSNDNxdXVJTnQxSHdzMWQwcWhPaStEejQxTVd3Zkpw?=
 =?utf-8?B?eHdib2xBL2E3Qk00VTNDUkJPelhMcVBJVW4wNFN5by9uTWNvNG95OE9KVFFi?=
 =?utf-8?Q?yHv+rjciL9NsWjmyX6HvCY5ox?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVJEU1VqUU9Ib1d4M1ZkblZrNk5MRW14eHZUenFWVTN1ajIzc0hqVG56SEJh?=
 =?utf-8?B?TDJxOUtPZlRvd05oWVlpMVFxT1RnQ1UycU5GWDFhbTBscXh0SUZJM29SMGVT?=
 =?utf-8?B?eFZ2eThTaE1DbXMwSVh6MFgwWkZQdXlrWmlmQllmaHkycVhLNnJTWG1yMWhl?=
 =?utf-8?B?dEZVc0ZtV2NmQ0kxdmIyYVZTSEo4VzV1QjJnUW9uYkFDZ0F6MzU0UzU5ZzZU?=
 =?utf-8?B?MnlFTDJLelRLRmlQQVdvemF6UFF5dmlxbWZ4dDRvLytkZVZIM3c2V3FOUm81?=
 =?utf-8?B?TjZrOTNlTTVxUndISlI2YVRLWG1CcXZkcC9rVE4vaEc1aVNtNFRFa2xPaFZ0?=
 =?utf-8?B?WWZMVHp5aEl3ZGFGSkhhYTFJY25PTXlxUHU5Sko5MnBaZjBMRDhKaFBzN1ps?=
 =?utf-8?B?TFo5cjNiWm95M1lWKzE1c05IWHg2U1d6SE1yMGVwZTQ3Rk1sSWlQdzZEa1B1?=
 =?utf-8?B?RDQyWDRJaU1qRTBMckM4OHFQQmNNRWZOQmlVUU84VlBUSk4zWjc1MHB3amZR?=
 =?utf-8?B?RlRCWDMwWkcxTVpuZ2w1YlBBV3k5eXMySFZuY0UrUUQ3cU9wa2lPMytYWnhx?=
 =?utf-8?B?OHpoMWJRcWtUeDZRaXZaaE01dVlwdDRLVXBzdVZ2UzI3OXV1K1BVL3RrdzB1?=
 =?utf-8?B?cTdTREk3NHViZEk1SmlGektTVkRwWHBxM3pQMWtvTmUyMkhGVFUyMFdyNVJ6?=
 =?utf-8?B?WU5CVzdya2I3MkM1ZVhPRy9WUURieFowVHJxUGgxcWVSSXd4Sy9qWVhTOERx?=
 =?utf-8?B?UUE4ZTdQcElleVRzNGpNSkhxbkV1UWFMTTcvNmFWMmNyU1l1Ly83bldsR0dh?=
 =?utf-8?B?OWM4d2pueW4xZTA1MWJlZnFNNnR5R0xPZDhUK1h5Q3NsWThWRk9meXlybU1H?=
 =?utf-8?B?SjhHSDJnMy9RQ2ZsOEZXZDRyamVnOTJrNkhtTThpSnpRK3NudmVEaWhwNzQz?=
 =?utf-8?B?RTZyWlV1OXdXRVRMRk9lRVNiYTI3Y2FQTnhDMmp3QnZlYUVSZnFnSHFyemlr?=
 =?utf-8?B?TFh3c1RHMTFQUDdXRy9BaUNnL1FWNk1hM3NXTC9OdytKTjNZTlV2Ym9SSXA3?=
 =?utf-8?B?cHlVVEhOYXNPU1NYWEZjSW5IS1dvYzdPa1hGbllMTXBHS2VYa0s3M2pmN2Yw?=
 =?utf-8?B?bHJLTnRXeE5hTXdkU3RpLzA1bWYyTVJtbWVpQncwQ3ZWNERKZmRJbmtrM3Fs?=
 =?utf-8?B?TXRHOWVoUGMvR2FWb3h0TkpIbnYzZW9qYVdqNGhYODJtSzVVdHB6NU0rNWtE?=
 =?utf-8?B?aENpbHpVdDBGNEdOaDZ1aEV3UUhXQWdrUkxwM3ZNMlZaTWJvRGxxMmp4YzBB?=
 =?utf-8?B?TE05R3dhQjB3TE9LZmJ4N3hnN0ZLeUpyMzNmNWNET3N5Q25HZmRSN0ZBKzY4?=
 =?utf-8?B?ZXhTUGVCMjRSOUdEZW85eldmaWFONmJHNVU2Qkh0NW5FUEtTVkdjRVR5bVh5?=
 =?utf-8?B?S1dHNlMrekpncWZhbmp1LzU5T0xPZER0ZndqU2hQaW95UzJpWEVFdXQ4cFNG?=
 =?utf-8?B?TEQ4T2NtSWtwRi9XZkdka0h0WHpwemhWQkF3NlVCQjBMZVJiNU00V2VBUTdl?=
 =?utf-8?B?WStsVlgydFAvbUFLWnh0ZFNFUS94bmU1WVNSVllWd3lzeDFSeS90elM5c3N4?=
 =?utf-8?B?QmIvNnAyME5WWHEwMDRzNmw0bzJSZ24xeEFFQnF1Qm5rV2lyaFBBV09oc1Vj?=
 =?utf-8?B?Q0l5cnp4cUxKUzJNSmRDdFNzQmIxOGJ2cHNFZ3hFV2pDWXM1bmhuQWsyZXRL?=
 =?utf-8?B?YmlmU0JUTXhyOThuNDVNaVg3emYvYVJJMU5jTU1DcTlDRUh4elYzTXR2TnVp?=
 =?utf-8?B?SVcxN1BPY1ZOS09HNysvR0JrTzN6WWRhUHJLbXdUdFhYSVdhdXYzWTFROGNj?=
 =?utf-8?B?QnpSamYzZkZET3F0Y1lOeHJlMzFUMng3bW80bkEwWXhoTk1RS2pIMTI3eHVO?=
 =?utf-8?B?SjZ1US9Yb3pQWkkyZ1UwMlAvTlVoK2t5aXI5VU5WaG5UeXVPMndRWjlQN21F?=
 =?utf-8?B?MkQ0VTVBUUtyRThScjYzMWxVRXowbWFSOVAxeXQwOThIdUtBUjRGL1AyeDE3?=
 =?utf-8?B?SnpRd0Fuc3J5bTYzMEVWWXcxWTVCd213WWZGcFYzRmF6MUpnemlwQ3pPaDdM?=
 =?utf-8?B?YXNsc0hKU3BBdmlhVEhJZ2xjbUZRcUUvWSsxY3NSUzRKY21XV0RaTC9LUExQ?=
 =?utf-8?B?M1hPR1hJV0N1R2x6QjE2UUl2SWxtRDFHeDVmSTdlNnRGeVJhN2tGK0htVkRO?=
 =?utf-8?B?MTA5VUVKUWhieDZsLzVvQ01jWGJFS0U5NDhUK2dXQUhXMG9UN24xclpDVEZI?=
 =?utf-8?B?MEMwWGNOVFlTcXhOQ3NDa0dFWGpza1dxM2owc1dKMnQvcGV3L3Zwdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b674bfa4-23f5-4453-9764-08de5ed8edf5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 01:51:33.8692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hy1IsL3JqxIGQH8QDhMUKpXYjx/fxz4QWbhKGmznA//zfZVN+rSL35lvwqaYCxAfs0AIuu064sIIiKCwGChU5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8591
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69498-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B3391AAE3F
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 11:52:57AM -0600, Sagi Shahar wrote:
>On Fri, Jan 23, 2026 at 9:00 AM Chao Gao <chao.gao@intel.com> wrote:
>>
>> Hi Reviewers,
>>
>> With this posting, I'm hoping to collect more Reviewed-by or Acked-by tags.
>> Dave, since this version is still light on acks, it might not be ready for
>> your review.
>>
>> Changelog:
>> v2->v3:
>>  - Make this series self-contained and independently runnable, testable and
>>    reviewable by
>>
>>    * Including dependent patches such as TDX Module version exposure and TDX
>>      faux device creation
>
>I see "x86/virt/tdx: Retrieve TDX module version" and "x86/virt/tdx:
>Print TDX module version during init" in the github link but I don't
>see them as part of this series. Were they posted/accepted as part of
>a different series?

Yes. https://lore.kernel.org/kvm/20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com/

