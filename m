Return-Path: <kvm+bounces-17556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC7C8C7E1A
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 23:46:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F23C128325D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 21:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7DD158217;
	Thu, 16 May 2024 21:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dl2R3C7L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D583219F;
	Thu, 16 May 2024 21:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715895987; cv=fail; b=CBGugxsEkNbYcZ4NsRVelmPX0G8/sS5apnkBDKNBBS+trGT/cGzCeXRnfJTZIIaTnQ8Jgs+CMCt+II90k6/ywRZZaErAr+4wb5e1MpOhLIjlBFj46l7iCgkQXS98nlBJNM3+RWSt8dLVdcbFacCCeuLiWv33RnfHVxXwOloaBmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715895987; c=relaxed/simple;
	bh=Bq+Zhe4sDTm6C4CY87WyyA1MuBhr9kkMWzQJtI0maWc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h0QVq+Kyc/34UHbBe1pWMYMbUwdNPQ7OOdNRGWHilBygz6RfzqVOS5XWihcPG51r9dVX7FjAewHvq7A20UGFN1LY1tLbl522E8+rG59KMHFvbwMCvNW1Jg+jMeFeEgwHs+dXKKi56gcrvYMV69WdNMfDN1/YIP5i9jgI9yaI+sQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dl2R3C7L; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715895986; x=1747431986;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Bq+Zhe4sDTm6C4CY87WyyA1MuBhr9kkMWzQJtI0maWc=;
  b=dl2R3C7LbTJyXLYVSPlBJfz51sZzT+G6mGJ9wdBKJ7zbZqTyS6RD3sxP
   Mh1DK3QA3VyzSVt1q/i+3frjIbB1WxE+P1Ft7XvmzrE7tuWmWYxZPY15O
   wAAB5oGOTYPHa1iB/b6twE18074vKoSkOWj1NeKfxIlHwNUYzWBgOMgI3
   YpZ4ee3p9JXa9EAtK7y3rHta/RLHP77ZPg43pSYB+tFNZNGBEJ4eZssMP
   A9Su7QgldHWaIh4Psx+RTSK5osMTcQZOqyTdDUDDO5MV4Mv1JFyn6n4CY
   aUFbiIn8two2bux8J1Ofue5ROzFrrxfebTTSdtYu1tq1ymJIahcA9Dlnv
   A==;
X-CSE-ConnectionGUID: qb72/JAWQkWtG620R/sFvg==
X-CSE-MsgGUID: KiOxsUc5R+um4DwnWzLoEw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11852620"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="11852620"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 14:46:24 -0700
X-CSE-ConnectionGUID: sZfNcdsiTjOGisLyI6I8zg==
X-CSE-MsgGUID: zjNRY9BfRcWgy2OSmM7zOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="31985881"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 14:46:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 14:46:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 14:46:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 14:46:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXc+hELsaITP8SOUdgr8rT5FhRMCuNXfBdPYHfVXUwjiB/jUdOAMUdimO+3WyYmmvUeHz5OZzdXwInOnIKTVqWHcQSgtPuxCrDZyHgkqqbnwAl+yf6JEgVd9Dhv4yID13pSfYFxr4sJ7HFcmOXH/0OF+nAtxYDVqaR97X4riDGBzWqeF54vbpodoWGdmi2sEU1c90eJ33XnPSqIpx5q4r7xPsuAgnbD3igZ6Y9+I64M8blRpPT8BSaqu7rUOzzQsoDnVDgx+ik5Wul9/z+ZXkwrPlpjgLFU0I29pe/yZxeyOZZXBdk6wu0GPp5uPyriZjY8RatRFWi8AxHfRPcPOgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bq+Zhe4sDTm6C4CY87WyyA1MuBhr9kkMWzQJtI0maWc=;
 b=VFzqXi7NZc/0REfT4CD1jSc0iBHifDfbqHTuJQCSYR8YMAjmCKG0cbVexZsqcXeZnne2y+7KN86rRay+hjUiLODhY7YyksVpPIY+iRozc6vrzgHaR14i9HfUdWBiB7SgZgZbrAJ8Jcx8ct9/1nmTJDi3W7afQbPvIO4uA1el5SxBB1JFb4tpMX1UL/Az/1JR1HB8U6oQZT+0uEFCpZ9WJ/Ls61AnTBa5M+c8Mk/Z0G5D+0O12WHobx97VqfD4EJx12laZ8LYSYBA71Lqe4T+wCXxyHEvKERhDmyXV9eXY8ENsJwC4fYrjKygpfIsJjR5tpn01qr36tv5q9BPYsYPWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB5910.namprd11.prod.outlook.com (2603:10b6:303:189::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Thu, 16 May
 2024 21:46:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 21:46:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGaaC+A
Date: Thu, 16 May 2024 21:46:18 +0000
Message-ID: <aa8899fd3bba00720b76836ec4b4eec3347d43dc.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
In-Reply-To: <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB5910:EE_
x-ms-office365-filtering-correlation-id: c4540736-85ec-43b1-c6a4-08dc75f19e84
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Zld4dk5Id2VrdDFyeUI4VEtxTDB2SXJoQUZPTE9yRlZsdStGcUsvRW43bTFS?=
 =?utf-8?B?ZUFMUGdsT1VkRVFib0NWUHdZYkhOVExMMVdmdTBYbE5hanpBbGd2U003UXU3?=
 =?utf-8?B?disreFExa3Y0all1ZTNXYWlHS3dJLzBkRVo5QVlIaHRzM2R3U3NiVnhSRVp5?=
 =?utf-8?B?Y0hzR0RzRTNkc0RId05SdVdUVWlsZTQ4dVdXdlFGSkpNOUhNU3dtRUlyWStj?=
 =?utf-8?B?WHZVajNJUGFiQjJNRGsxeDV5SmJ3UVFEOWhDOXJINzBNSmdLdE1uOVVkMEw0?=
 =?utf-8?B?aEVSaWpyWkpRZ2RHaVNDZjY4OW9HN28xTWdwQVFyVit5SFFWai9PbSt3ZXdJ?=
 =?utf-8?B?VnQweVZEWk1NOE5ncDFBYVhiN0lYUnhBNXRSREZ2Y0N1TWdKOGxwRXByK3ZP?=
 =?utf-8?B?MWpRbU5ZaEltUUFLTHcrMVJHOWpUVmxnWlV0U2JrK3htdlNPcWpjazViSTlm?=
 =?utf-8?B?eDJFYXhvTC9DQXZIdzJncFZnSllWcmt1Y0VwZWdZKzBPQ25KOEhOeUx3R3BV?=
 =?utf-8?B?dDhsS09XMmFod3ZHUHNKK01vY3hHVnJsSnlxTGsreVNWTlJVY0dUd3p2TGZi?=
 =?utf-8?B?SjRiMkhyNTlsQjdNTk8vcXVmY3l6K3pRSnhOdWRSRDM3dE1yZnoxbDBhSlBN?=
 =?utf-8?B?OFBRckEwSU0ybis3Yzg1QWVIRGxNT011L05oWEdsaGJ1YlNxSzQvN3RKdFpX?=
 =?utf-8?B?enZJcWFQdTFWZFJsR241SUxkSWRabUhrQXZBTE1tVU9SZWs1NDk5U2diWDNR?=
 =?utf-8?B?WXB5RFhZaG1RWUpYaG1iYUNaTU81K283YmRhWWJLYzRHZEpWeFFxTDhCYzMx?=
 =?utf-8?B?Z3d2WlBFcDJ5VUIreWpxb3VvSG9KWUZObEd4UVpsdE9uZFBGWGU5b3ZJd2Fi?=
 =?utf-8?B?TTJPdGxPUXJIOFVNbk56RjNFTGpjeWFWc2tKMFZDSEZFNml5RjkrSnpYMi9v?=
 =?utf-8?B?Si91b2JmNWR2WDM3ZlVBZTFKRjQxZGovK0VIbHFLWnB0RDhJenkybUxwbnBN?=
 =?utf-8?B?OStnQUFMcFVMeVdvRW12OHpNczZOZXk3ODRCbFJqb0RwQzRjY0UrcWkzR3JZ?=
 =?utf-8?B?VmEyTWRaY01udktFNmtjL2NNa3BzNklyUFcxazNrUlM1STdxUnBoSXBpTUdL?=
 =?utf-8?B?amdCQmc1eVUwZGxXbjAvUWYvNDJGK2tHREwzSDk1K3E1UFR4R0pjRFpITkFG?=
 =?utf-8?B?MTNTN1JlMFBRZUhSb1BhUjJIOHJCTlpDYjZ2dHgzaC9PYVB6RUpJTEpubnlw?=
 =?utf-8?B?Uzh4N3M4TGp0MjN0STduckNYQW5xVkJuQlBXRENhUTFrNHhtZ1Bwd2hjU0VI?=
 =?utf-8?B?aEhQdnJFTUlQVWZpL1J5WTZqNEFQL3h4RFd0Z09CNGo1V2VobWRIZWRTMzlI?=
 =?utf-8?B?eGZoOGRLVE5ucnZ4UzNoVVNYc0dNVEU0L1Zuc0I0TVJMWU9mM0o0VE9yOTlG?=
 =?utf-8?B?S1VscVNhbXJLeHlvZnVFOStsd1ZkOGxpY0g5QlFNZFpOQ2xBTXM3SnlKaGNi?=
 =?utf-8?B?bkJoOVJxTmVOZFJxMUhKQzkwcGxZbnpYSGl0MU9ZMCtWS21yclpOYlRwUUEv?=
 =?utf-8?B?RmoxWVk5ajMyNkg3Q2pCci93UC9Jd3JaNE1ncHM5a01kU2RkSFJSaCtkSHdl?=
 =?utf-8?B?cFdkcXhLajNGMHI1dFNqK2RSbzlCNERhTjYybUNOSFMvT3RuS1Q5dzRJNDRV?=
 =?utf-8?B?SWRYU1kyVE5TODlsU29jWlQ0OS80NGFPL1pYSHlFN0J1OTNWWGlnOXdRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUZBWTV2azRRVmJJNGtpVWRrYnFCNzRLRmhOVEJtZ09EMFB0UitFMkgzeC9r?=
 =?utf-8?B?MDFEZVZnUTZYWVI1WjZKMytIeGk3UFFKRTFxdUdCZ0ZUSmtXMVZVQmRzNnRY?=
 =?utf-8?B?TjRUdmNqVFRUUm0wREdLSTh1QUZLaWtsZDJQbnBOOFFvTDNMS1dBcFhPYnZj?=
 =?utf-8?B?eDVDb2RJaXNiQjNlRWM3U25IWGFhTjRhL21SakpDUHpRV0xoTVpVUU13dGlF?=
 =?utf-8?B?bGdUM1ZwY1Q2dSt0azRWY1BMbXRCd29WVGNLQWNlTVJROEh4Sk1aNEcvL2xp?=
 =?utf-8?B?ak9zdXlja05wNXcwZTF3TExvdjlmZXNsdWE4SFJXb2sxciswTGZFMGVZWDF5?=
 =?utf-8?B?bkpacktiUmxyc3l2K2dmbUJuOUVUZVNVcVl5NWFVM2pHSUlaeWNhWm5DQ3dN?=
 =?utf-8?B?K2Nab3dScE1uZG1ZNzBwaFVTcUxTblFsc3lRRitUR1NtYUxmbEpQVWd4QW4z?=
 =?utf-8?B?K0hReGRlZUhnWTR2b3Q1UExsNTN4NHBYZUhyVlRNc2ZhK0hCR1doNU5EdWha?=
 =?utf-8?B?WjR5T2luOUgvWlZBS3puZURuREhUTEU1T1ZaOTYvWXJNcTVqWnJuRW04OVBV?=
 =?utf-8?B?blhIay9nK1gvMmdVRFRhaWRKTW5DVjBZSEFaenJtdGZLRW14ckdUb2IvWStu?=
 =?utf-8?B?a1pZb21FT0g5eit3QzN0SFFheUFJaGZGYmNJbjdIU1pnWUZZQ2FHcmp0cG00?=
 =?utf-8?B?bUFGMTJLb01jNGVjTk16RkZyUEt4R3RpTWNRalNlZGgwSTQvQktOdGVXVSs4?=
 =?utf-8?B?OHJEelZrRFFZQi9HSDMxRG11MXIzS2gxTE1jTnhJWkRobDRCS0lCS2V1OTRT?=
 =?utf-8?B?NGYrcGU0dEpyUndIMW1BUkg5NEFrUURoYjJrVkc1MUpZcXpRa21oQU80aTZm?=
 =?utf-8?B?R2E5RlYwRTdoMHh6Ny9uUXBsakJCRkRFQ2N6THhnSjBTY1F3cDhrY1ZxMFJu?=
 =?utf-8?B?RmxLbXB4Qk5KeFYvdFN4WDVLYlFNQlYzbWFDTUh2cGhBbFU0VFNRVWhKTlVL?=
 =?utf-8?B?RExsU2VDYzZhWUJJSitVbncxa1V0UWVsTytIcVB0Vnlaek5jV3N6QVRpR3Q5?=
 =?utf-8?B?N0lKS2xlN00zL3NyMnhWakJmYVEvTzJpbU4xdGpNd3N1dVhzbGI2U0wxajk2?=
 =?utf-8?B?RytWcmpOK080eEpPSzJIQU9kSmxoU2JGV2NSaWhkR2dqbTZVNStjU3RTK0hC?=
 =?utf-8?B?WDVqTnJSZExIZHA3WXlDOWt0Y0g2dW82V2VyNXRSLzczcmFhZDgyaEZDQmtX?=
 =?utf-8?B?enJuOVg0cG9Gcks4dHBVN2lrVE1ldk52SnZkZzJ0TEhIWi9XYk1BUks4Zmo5?=
 =?utf-8?B?aUkrTThtYjZTclFsTDQ5YWVvQlZSOHJrajJuWFlPTWtHY2JORjd0QnU4WGxQ?=
 =?utf-8?B?VllHSTQzOXVFU3pFem9RQm9WK0tjckpRVGFjcmJVMGJ1NkhkdE1McEc3TkFt?=
 =?utf-8?B?NEIxWTd2ZnNtVUQvYkowdWZVck9JYURjcDhEaDNCbmRDaTg1dVpPc2h1d0lt?=
 =?utf-8?B?Q3RNNit4QkY5REQzWit2SW9RNGVaYnJrVVVxUHFkbUlRb0hKMlJtMVR0NUth?=
 =?utf-8?B?UG9qMnNMYzdML3pBeTZZcUlhL2NCRVFrRlY2U1FIcCtDMjhjb21JSkVYaSs4?=
 =?utf-8?B?dDhwK3Q5czRjQzUrclBvRHYrNnZxSzFCcW8rdGVqM1B1Q3ZyYXFHK0x2WVpD?=
 =?utf-8?B?Z2VseVdpN0tFVWRWTHlSb09tMlFkQ2IzSlRXUnl0cjEzNjdVVndpQXVhdGZq?=
 =?utf-8?B?eGJjK2J2Z01ETTI5NHprcURzbVVpRHVRWlF2TTJQdXBYVVpONjNBMWc4S1Nx?=
 =?utf-8?B?MDNzNzIxeXhEcmlGRXZrTHFKNXpzZnErenVML1c2OEY0TkNzcnlNM2JkL1pM?=
 =?utf-8?B?bnJpVzFJdWRCYXNUT1lQcnlKTm05RS9BZWIvMlhuZFlCUHRsOXFyN3RURU5h?=
 =?utf-8?B?RkxYbmw4Qlk0cXVtNG5wUlovMUhWbVpNN3BtWUpiLzREdkJhWnVXbjcwcmZC?=
 =?utf-8?B?akZjV0ZpSWlkaVNvZ01QVGJocFdtbEJTby9FSExISlIxYi9WMVJWMmk5cUh3?=
 =?utf-8?B?VFpVcEZlSXBCNWxTaFlFd1BQckVKTW1zS0ZwbHdkOXdzTThxSWkwMlRTWGtK?=
 =?utf-8?B?U0ZsZ1dMQ0VJWEJxcUlKekQ3VHl2aDc2anN2S1Z5c0ltelB0WWh0eGhWNzVT?=
 =?utf-8?Q?eVVuskPOjto8QVsRCPYICq4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <753631D8F538064789A464E6745042DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4540736-85ec-43b1-c6a4-08dc75f19e84
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 21:46:18.6481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RC6TKkAVwgxgS3qarCIoGHYpelBfG+txWeTbv6zlF09ABoKej9ERGmmKyHICdX+6fUSN7jLySE9RjfMFzt5GMOaKcteyCho62InVlh5qIAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5910
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTE0IGF0IDE3OjU5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gDQo+IEZvciBsYWNrIG9mIGEgYmV0dGVyIG1ldGhvZCBjdXJyZW50bHksIHVzZSBrdm1fZ2Zu
X3NoYXJlZF9tYXNrKCkgdG8NCj4gZGV0ZXJtaW5lIGlmIHByaXZhdGUgbWVtb3J5IGNhbm5vdCBi
ZSB6YXBwZWQgKGFzIGluIFREWCwgdGhlIG9ubHkgVk0gdHlwZQ0KPiB0aGF0IHNldHMgaXQpLg0K
DQpUcnlpbmcgdG8gcmVwbGFjZSBrdm1fZ2ZuX3NoYXJlZF9tYXNrKCkgd2l0aCBzb21ldGhpbmcg
YXBwcm9wcmlhdGUsIEkgc2F3IHRoYXQNClNOUCBhY3R1YWxseSB1c2VzIHRoaXMgZnVuY3Rpb246
DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNDA1MDEwODUyMTAuMjIxMzA2MC0xMi1t
aWNoYWVsLnJvdGhAYW1kLmNvbS8NCg0KU28gdHJ5aW5nIHRvIGhhdmUgYSBoZWxwZXIgdGhhdCBz
YXlzICJUaGUgVk0gY2FuJ3QgemFwIGFuZCByZWZhdWx0IGluIG1lbW9yeSBhdA0Kd2lsbCIgd29u
J3QgY3V0IGl0LiBJIGd1ZXNzIHRoZXJlIHdvdWxkIGhhdmUgdG8gYmUgc29tZSBtb3JlIHNwZWNp
ZmljLiBJJ20NCnRoaW5raW5nIHRvIGp1c3QgZHJvcCB0aGlzIHBhdGNoIGluc3RlYWQuDQo=

