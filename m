Return-Path: <kvm+bounces-24073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB459510C3
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF983B2128C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 23:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2221AD3F3;
	Tue, 13 Aug 2024 23:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J0G4ErIJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCB01AB50A;
	Tue, 13 Aug 2024 23:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723592898; cv=fail; b=SrImvwBRCBcaYNTjQoJnTFhbSDay+qtu4w8q3fIXF0EkQL8I263RGVqa1qPLbPQQa6X8V93EjvY+1wcBFmSYkjZPKa/qzC8gaL1dtCeTu2iFxW23pVkICW8DqlyqOx9soGeiSe5S4Wf4wFR2ahDF+yZWKd+BX+NB30B+IAzUeeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723592898; c=relaxed/simple;
	bh=7VkSwFgHx2Z4GyUCZQjwaHXOd8Q3x8VwoUzo3IGsRwU=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LXpHRe/pSjplK3lNGaYMDUvm3mFn/YK4fSLc8BXDZBOZ8OyR1sHaTGO2UNBSF02yH1Rx7XeKxF60zlUXrBMZioyIbch6TXBgln/XOibftDlwrOGZLOpYnbTKOSSXnEiJayWh1Ync8gHGcFithMpnrSIn9AL/ZPFR5Xrou7UEMMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J0G4ErIJ; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723592896; x=1755128896;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7VkSwFgHx2Z4GyUCZQjwaHXOd8Q3x8VwoUzo3IGsRwU=;
  b=J0G4ErIJL+KAVF7FgOxog0YLA2QmPu/zI4Nl0Szr69c5SutnzhVin7Rn
   YKv9qsVxoeS2QLCJgxOp7c3EiiY3VL9P/RQlkI4v1ir0yhtrxa9T96XD4
   XXUj++00j/FCsZ5JdbLI2OJuchtmvN+tCVoOfO3lC3Kn+zbl1Hf4yaB1J
   ZsSv+GZx7MA94a43FeOyjsisa4w4NHJaT2/8tu+K5LdK7AQtoTHQOXUuB
   4Eod3IPWFnSBpva0YaPhdrETWY6yz985X0sw7UGMtktDWwHR3Y1E+VHWm
   3HoMQMA1PB+qiRTspSRoP2q+dVwxi0r8Wqz3y2eIf0/N/VvjvvU9aR1uv
   w==;
X-CSE-ConnectionGUID: DtN9+I94RGKW03yG+eyvtQ==
X-CSE-MsgGUID: AJvFHPNRSfu3j666J5Ujsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21647450"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="21647450"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 16:48:15 -0700
X-CSE-ConnectionGUID: jGGbb1uaRjOZO5jCrpm6xw==
X-CSE-MsgGUID: eT8qEPG6Qe6iVyJu73c2Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="58520930"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 16:48:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 16:48:14 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 16:48:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 16:48:14 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 16:48:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jhNDPZwZAqYsWX5Sxmbo+eMUZHg9hRSF5L7YhUE3d2nNcs0xlKrdOHPTymtzJzQCqHXow09iergZfiFq2G04seGhcde8WpNZRdr/jyZwy+a5AsVQY+XJ9mKdxNQq/zHHUt9kaN9qQz6uiP/WiYvK9/dFhZioYFKgmpzdrA9OoRor4SeRTEqBBXIXekspKogqYjVLXfXX6RbubrbUV9hCdQE0bj7o4Xp8lB50WZH7zOisUoia/PY1+utZh7Fb9a62yLAEsq6DmPxf9qrjffpLSTPD5qAfca4uqwN/W9W1+SoUQtk2tb8QPrkpixUq9bmIisPKNdlA/qO5BKM6GQR/gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odtZFzUzsczPa9fESYf+mQAIgRIsE3TLqPjR91AbZ6w=;
 b=Jv/8j+WA1gyFdUNKwXIh7QdbrMtY8sZWf/Qj/CmVZOQW7fc3Q9T5IhDJ4FyZ8R+XsHrjlyNjF/sO/ZEGGqWuuYyNqAHP4dqB7TcXFb3GpgJkBF0X0Q9H6d/MwGLnbywVABGziwqAzVOeoyBIiSAsHG5O0BNQBToYP3e0cEmh5+Q56WOopOO4+BAblJlKYR/F5RNdqtJcY+jHsEe64WEXhBsZxUGDGrY9QJunEzZtfgjsL8lRNcBB9g3X7AnEj4AVvJeTRG1T8J0WQqJCE1O1rhBSYz2skAjy509pvEq1K9NSaJ5Uk4SK+u4WU1/6HUhZAWM3yRneuVNPHCLPoN0g6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB8302.namprd11.prod.outlook.com (2603:10b6:208:482::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33; Tue, 13 Aug
 2024 23:48:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 23:48:06 +0000
Message-ID: <4273c812-9ca4-4cf8-a3cc-921db5f3828e@intel.com>
Date: Wed, 14 Aug 2024 11:47:58 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/8] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
 <20240608000639.3295768-5-seanjc@google.com>
 <7e12a22947bdaf7fb4693000c5dbcf24a20e6326.camel@intel.com>
 <ZrrFgBmoywk7eZYC@google.com>
 <c3205ac001776585d2a1fd14ebfec631d8ff7d3a.camel@intel.com>
Content-Language: en-US
In-Reply-To: <c3205ac001776585d2a1fd14ebfec631d8ff7d3a.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0129.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::14) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA0PR11MB8302:EE_
X-MS-Office365-Filtering-Correlation-Id: dbf0b433-59e1-4c37-fe74-08dcbbf260fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VndMYmVhWE1CREw3SzN3RUFCVDR1ZnMvQXFxSWQ2clRrd1Z3TkErblUva3Fz?=
 =?utf-8?B?QmxIVzkwUHBTQkZjYWNQMmtOYktocmhFU1E5cFp1TlpFUmZZQmZmbVZPcC9q?=
 =?utf-8?B?Zis2Q1RFajlvSHc4c2JWdytSNHo4SnhHbm9TazJ0S2tLeXhQbXU5Y2gwYlV0?=
 =?utf-8?B?MmozMXp1Y1lwWloxVnViNzdNdWdqdHJDK0tXb0pwSTRuTjhLbUg4SnpNSE0v?=
 =?utf-8?B?bDFSQmoyYzNiYjhqVmJEaHhNWUh3THRxdEdPeC9EbDIzZ1Axemt0eTc2K0p6?=
 =?utf-8?B?RlF0SnZrRXF1eGIxcW5mUXNhQmlrbDNpd2krSUpuNkE3cXUzaDhNV0NBY21K?=
 =?utf-8?B?eFFzbnkrRUtHZGc2Z3FwaEw0NXlRM1M0a1pucmFQRU9WL2dDMWtmRExoWXVu?=
 =?utf-8?B?ZzVWZWl4SVlTYkl3dVBpa1pqUzJoYjJvS0N3aWlqOWVhWjlIdjQyKzlBNjhw?=
 =?utf-8?B?Sm93dnkzenpiWnQ0RU9mNnB0N0hnY0dWNHBudUZhSW9ENzJjNVZSenNUdzc2?=
 =?utf-8?B?Z2lVdTlFOUdrZk9vR05KZFRWcW1QRUJjSlJWMnBvS1NlanlKS29PM1QyMTlX?=
 =?utf-8?B?NFRDeFVNQ0N0K2gyVGJDS3dWL3FrdmpkQjFuZytLeXJJYnN2empzTFpFVlJB?=
 =?utf-8?B?b0lLYXM2MkZWNDNyYnVQbHorVmJ5ckdkM1JOa2Z2OVR3NDJyRVhDM0tMcDli?=
 =?utf-8?B?YkVWWm5LdWRMT0cyYnNhZzltZVpTYTJvb0tCaFhyQ1JVMUFJOHJleHFuMUk5?=
 =?utf-8?B?VVJiSGQxcGNIMnUzNmxWdTIzQ0x3R3hxWWovNGhKRjNIbjBwQVNPQlRlNWp1?=
 =?utf-8?B?WTIweklsdi9zS1dtQS9qU21CVnlLdldRZzdTSGFBaFducm0rMWQrMlJkZDdS?=
 =?utf-8?B?aFlLVnRPSzhzVGtIR3VQTVY1LzQ4YlRrek9GeFNySlN0b1R3dUVBSGVQNTZm?=
 =?utf-8?B?VnFDNDd6NE90NmxvYzB0NTVmbTFOcGVBYUYydFY0dXJiRW1IREFoN2hXeHp5?=
 =?utf-8?B?VFo2VjNJL2J2V1FBazFqV2RwMUJpQlg2V0JrNkhvMjhHdjR4dVV2VGQ3VERz?=
 =?utf-8?B?SGFoZ2JlT1J3dkV3ZkVIdGN0NlluWlZrd2dRUFA5VDdOR0tOQ2ZNcDRWNkli?=
 =?utf-8?B?bHRqemZIczAwaDVFR2lCb3d0dTE2S1h0dEQ1eWw2cmdidUx0VjlkdXdnVHdk?=
 =?utf-8?B?bHd4bkNPN2taOWlTT2xUMStDQ0IwTTZpZlVtQmMxMklUMHpCaVRwNVJVd0M3?=
 =?utf-8?B?MHJ4WUxDd244M2ZmRHRiakx3a1BseGRDaG1QK3lRUDBtUHRyN2dVS0s2Qkpr?=
 =?utf-8?B?UXFmM3R4Z2FDaU5lckxSSzloQmluazVXNUNjbzlLYlA4YkI2VlBoVU82SmVi?=
 =?utf-8?B?eFh6M2g4KzFUR1Zvdkd6MUJzYVl5YVNKcVFidyt3RGNKODFkd2xmUCtqdXlG?=
 =?utf-8?B?R1hTbXd3MVhGVTZraHRHWmRGZ3dUSXhzOUVjT0xxS21UOGlWZmw4QVR3VVZL?=
 =?utf-8?B?bFA5TnhhQUQxa21tQnMzTHE2UnhTb0Q2ZkJnVW9BcGljeDgzVnJRWmE3alZW?=
 =?utf-8?B?N0MyMkFsVkF5akpIME9UYVFYNXFkS1R1dGVJT0hLbmYxTHZXRmdsMVpkQ0Mw?=
 =?utf-8?B?K0NBQ2xQbUVCRkJlenNHTzBaNnlWQzRGRHI0N3dzdWZwdVorems0Q2gvc01X?=
 =?utf-8?B?QVI0bk9UVExRUlNZLzhPalk3YXQ2QmpmZTM3L1hrZUYrNVhxcFZtOGgySUJT?=
 =?utf-8?Q?ed0NfTi+rsZKfxAuK7KA8jg1wD2mBUz5NiQdUme?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUF3ZHVJUDhMcmpnSllML0RlQ0IwRDdBWVhkOS9QT2VmM0VlS2JYNjVLYWds?=
 =?utf-8?B?MnlUWEE4Yi8raDR5aG8zU0JFeDh4WWtGWmNwb2I1c3Bxc3RuOW4zY0tzcmpX?=
 =?utf-8?B?aU5SYXJ1dUtkNXRYNWs3bHRodzRQcDAyUW9COWdnV3cvV3VUM1BzOW9jZ0Vs?=
 =?utf-8?B?c2t5aEFmSFpseHlkWkEvd0x3WVZKTkU1SVBMWC84ZTFTR2hvWmp1ZUY2SmUx?=
 =?utf-8?B?cWJHaWlSVzkvZmRLNVdwQkN3ZVdweUZOSHQwTVpoT3AwWS92Vm0rQ0loVkZR?=
 =?utf-8?B?bnErbEVadUlhUWVJMk1PclVUYjRmNnlKUEFIakRDV2g3RW9Fa2FGTzhBNEtP?=
 =?utf-8?B?TVEreVE1L0hHSmFaZXFWNEgwUkMrS1ZURVV3OUk0Q0tkWTF6ZTVmZGxlYjBV?=
 =?utf-8?B?N0xtOHlLM3dZdG8zWUFWVmlrL1ZwaXdCdU1CZG5jVlV3T1dTM3BaVm1vTUZV?=
 =?utf-8?B?RVQwTktGRlJFdE15L1dyQStHSU8wMjRCQ0p1TFhlcm9NUDcyOUY4UklHMFJR?=
 =?utf-8?B?dUJUTXhOeWpXNGRScXk4LzdDcEtPWVUrTXBjS2R5Z0o1QkF5WnZxdkhZMFcw?=
 =?utf-8?B?K2ZiUHNseUtXSTF3bjE0TzFTVlN3dWNVUzlQNE1YRFk2dHFkbVlyY01aV3BO?=
 =?utf-8?B?YzlXMTBvdmFwU2xvTEJEclZRUk1qcVlNTGxiVTRBUjJUS2hlRTJhR084WkpT?=
 =?utf-8?B?V2tuRWtKRzV3VGVINXlZYXpweGtvSHhPZ3A2YkRuWnZHSUtmWDMyaGtJNEIy?=
 =?utf-8?B?VytwTG5sMlBYUHlNZGFNMWc3aUdFK1pnMEF1b2gydDlCK2RCT2R0MjZLOXdi?=
 =?utf-8?B?YlkyVXlqNlVrdFpuTlhCV1g5MHh1OHdQWW1jWk5QQUNqa3FDQVZjd1M3Y0dJ?=
 =?utf-8?B?cTFJdlJqbXlPUlQ1dXRtVXNJL21MMXI0RXVlcXZVUlArYWViaWpsNVhQUitU?=
 =?utf-8?B?T2M1WktkWit6Y3V3YmZMTy9WRVpvT1AwUFZDL2dISGxpWSt5aTZzeThoZFZW?=
 =?utf-8?B?TzBpbWpOamtPRmtYYXBNRDR5TkZvdUFKNjA1RzQvWFVWV0YwL2ZFdG9lV0lJ?=
 =?utf-8?B?ZDFyclZCTmNob3JiNDJ2WlJEdlJaWklTTTE3OSt0ZExGZkFHQUFUZkZSajdI?=
 =?utf-8?B?TDdFdiswbmcyTFZSUWNKN2lmLzhTS2FVUkJTVzNycDJMbmhsdTY3aVJnQkhy?=
 =?utf-8?B?S3hiYnJXQXRYWEIrN1EwY1lvalpMRW83OExKYi9Qc29zdzVpbDhDOXlNeWls?=
 =?utf-8?B?aE4rMExuZmRWOHBNZHQ3aitKK3VvUlV5TXRPWUVxZjNaNjJDeUdiOHpuTVhh?=
 =?utf-8?B?emNzWVBzcklKWFdZNGwxOHpCbVZZZ0ZFL1dqQkg4VU9mYnNBU0NRMHM3UE0v?=
 =?utf-8?B?OXF0TVBNSm91Sy8xbGxQQlNDNVF6aGFRMGNGa3VoMlJ6RUp0clA3QThoeWcx?=
 =?utf-8?B?bU95ZjFHeitNckZ3MGRucG8xazFaVElwWjVJb0ZIdTRGZ2xLWGUxRGgyMEUv?=
 =?utf-8?B?QVlKcDBzSDVxWFcvYk1UUWRvdU5VblV3RDNBWW1sVDgwYjFybzNjSnN3RmZa?=
 =?utf-8?B?MUJ0UXcwR3FQbTRsS2xHS1lIUGVMSkVrcnF2MUUyUllDNTFGbXNZS2NUS0w0?=
 =?utf-8?B?UU1BdVZsdHpHWHY2Q2tlMmtJb0RQcDVoK0dsN2plSkVRWHhpU1pObVhFODNn?=
 =?utf-8?B?d1g0Zi9kWU5nTzNHNjRuN0xRbk9oc0RFRVVEYzlCVzZmWHcwaC82V1duTENL?=
 =?utf-8?B?RnBaMDUxaDcySXlBbG1OTjB1aEwwait5UUQ5MFRxTnUvbXJnQXIySFZpTGZo?=
 =?utf-8?B?MHhxRkhsMmZxeStmT0xnbTlrZnVWOUdzd0JoemJqYmlqN1VtZ1YwYk91dUpn?=
 =?utf-8?B?SjRQSDZMelJQblQ3RkVrNHJ3QUNNOEh2N0QxbVZYT0FnODhEWExCYUZzczBO?=
 =?utf-8?B?Y3d6dktTRzZ1K2NhTjluK3BmMXl6b2JwNTVDV0VzZTIrMDM4S01RTWhCdE1k?=
 =?utf-8?B?UVUzdjhHN21GR1VIUzllWkpuQkVXMWpxMGwwWmRMMEx2dTJsZk9zQThOOUxu?=
 =?utf-8?B?emNPS2VhYXo0UVVsYnpQN251QVhxQkh2bDBqNlM3L0dVL1lIRGxNaSt5MHBE?=
 =?utf-8?Q?OOZu9oraF0Co18Y8sozQaaMa2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf0b433-59e1-4c37-fe74-08dcbbf260fa
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 23:48:06.4740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MAulAQoOozXTUWxGCG8QU83Y6otCBik7e1rFWNjGfybzmcywjh0cpKl2nIEbuSQQsaZPLTWztGRCAPpVRggr7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8302
X-OriginatorOrg: intel.com



On 13/08/2024 5:22 pm, Huang, Kai wrote:
> On Mon, 2024-08-12 at 19:31 -0700, Sean Christopherson wrote:
>> On Fri, Aug 02, 2024, Kai Huang wrote:
>>>
>>>> +static void kvm_uninit_virtualization(void)
>>>> +{
>>>> +	if (enable_virt_at_load)
>>>> +		kvm_disable_virtualization();
>>>> +
>>>> +	WARN_ON(kvm_usage_count);
>>>> +}
>>>>
>>>
>>> Hi Sean,
>>>
>>> The above "WARN_ON(kvm_usage_count);" assumes the
>>> kvm_uninit_virtualization() is the last call of
>>> kvm_disable_virtualization(), and it is called ...
>>>
>>>> @@ -6433,6 +6468,8 @@ void kvm_exit(void)
>>>>   	 */
>>>>   	misc_deregister(&kvm_dev);
>>>>   
>>>> +	kvm_uninit_virtualization();
>>>> +
>>>>
>>>
>>> ... from kvm_exit().
>>>
>>> Accordingly, kvm_init_virtualization() is called in kvm_init().
>>>
>>> For TDX, we want to "explicitly call kvm_enable_virtualization() +
>>> initializing TDX module" before kvm_init() in vt_init(), since kvm_init()
>>> is supposed to be the last step after initializing TDX.
>>>
>>> In the exit path, accordingly, for TDX we want to call kvm_exit() first,
>>> and then "do TDX cleanup staff + explicitly call
>>> kvm_disable_virtualizaation()".
>>>
>>> This will trigger the above "WARN_ON(kvm_usage_count);" when
>>> enable_virt_at_load is true, because kvm_uninit_virtualization() isn't
>>> the last call of kvm_disable_virtualization().
>>>
>>> To resolve, I think one way is we can move kvm_init_virtualization() out
>>> of kvm_init(), but I am not sure whether there's another common place
>>> that kvm_init_virtualization() can be called for all ARCHs.
>>>
>>> Do you have any comments?
>>
>> Drat.  That's my main coment, though not the exact word I used :-)
>>
>> I managed to completely forget about TDX needing to enable virtualization to do
>> its setup before creating /dev/kvm.  A few options jump to mind:
>>
>>   1. Expose kvm_enable_virtualization() to arch code and delete the WARN_ON().
>>
>>   2. Move kvm_init_virtualization() as you suggested.
>>
>>   3. Move the call to misc_register() out of kvm_init(), so that arch code can
>>      do additional setup between kvm_init() and kvm_register_dev_kvm() or whatever.
>>
>> I'm leaning towards #1.  IIRC, that was my original intent before going down the
>> "enable virtualization at module load" path.  And it's not mutually exclusive
>> with allowing virtualization to be forced on at module load.
>>
>> If #1 isn't a good option for whatever reason, I'd lean slightly for #3 over #2,
>> purely because it's less arbitrary (registering /dev/kvm is the only thing that
>> has strict ordering requirements).  But I don't know that having a separate
>> registration API would be a net positive, e.g. it's kinda nice that kvm_init()
>> needs to be last, because it helps ensure some amount of guaranteed ordering
>> between common KVM and arch code.
> 
> I agree with option 1).  We just allow arch code to do additional
> kvm_enable_virtualization() before kvm_init() and kvm_disable_virtualization()
> after kvm_exit().  I think it's kinda normal behaviour anyway.
> 
> And this is exactly what I am doing :-)
> 
> https://github.com/intel/tdx/commit/2f7cef685527a5ef952346ff5ab9adbb8bb6f371
> https://github.com/intel/tdx/commit/6c76ffa47a98ca370fad389271dc3cedf304df2d
> 

Hi Sean,

Forgot to ask:  I assume you will post v4 with that WARN_ON() in 
kvm_uninit_virtualizaiton() removed, correct?

I am not sure whether you will include the patch to export 
kvm_enable_virtualization() and kvm_disable_virtualization() but either 
way is fine to me.

I am thinking if we can get this patchset merged to kvm-coco-queue then 
we can actually start to review (and try to integrate) the "init TDX 
during KVM loading" patches.

I appreciate if you and Paolo could share some plan on this.  Thanks!

