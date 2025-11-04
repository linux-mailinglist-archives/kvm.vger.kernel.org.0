Return-Path: <kvm+bounces-61979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B6B63C30EBD
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 13:15:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C11DF4F59CA
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 12:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D992F290B;
	Tue,  4 Nov 2025 12:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nI6OPvbH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28372D661E;
	Tue,  4 Nov 2025 12:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762258362; cv=fail; b=skmXKtVYYQTJsRvH3EcJroDNTDmeJ+LzwO8Ys6HQ0opSx9hWWuVjMvQApmxe5RYLwq8F6nYq7y17kKAn0otBgM0RakMaO2dgCasPtUTpbHRPR5QHFcs7Mt1Wb2SPvzKOUBWtobH/qiOaI44t8a2C9COLW+nS/liMVKKZ88DDnJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762258362; c=relaxed/simple;
	bh=40oLnQRVMVIAPJ80GAhcc36rRXYM8h6nsuFHNRSMj8c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gQwrkokvd8yeqCPMh8rpikvozKrKML4iCddgMc4gIDT6Nbpmxc3x3XGH9PG5xgJFwVYGftEWN3Q4RULei0tpzFto6GS+UjJTWISlYWyMq4S29DU/AqgASjVTfQ0eprZE+paQccA33Y8E5oko8A08Rd9so1I6TTljnlsmnzdR1Qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nI6OPvbH; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762258360; x=1793794360;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=40oLnQRVMVIAPJ80GAhcc36rRXYM8h6nsuFHNRSMj8c=;
  b=nI6OPvbH7QD+dqwHEqXXUBOliwca0MPJ7b5R+o/kSimNvnXl84ERBR85
   EMXXn6edyBWkOq8N68EfSUuM88HZ9kOupoS/vB6+kywZUeug2rv63Ptpe
   L1gzJM2dv+WMcZyF0QZv6Pa/EN4C2pN8dGlYmDOsgjc14QoJ+jympy57p
   +ark5L8ZPhtARPVFfBvreJ9hD1XN6aHWDb8y0M7RB1oEub1MOpaVDMZhx
   ngOCRvof7Lg7ctpQAn3UOj/6kJ27FfgnqWOl4FEaReVi5c1exFv4zlCom
   /2iAU35cZvT9bFKcSKj30QxxdhNgR2eRA3yaSSDi9UUwxjahIGk2LBbID
   A==;
X-CSE-ConnectionGUID: DnwXJeTcRD+TuzF4cw2b2g==
X-CSE-MsgGUID: uVhIlp+XTmmJKXOsbhBzSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64267167"
X-IronPort-AV: E=Sophos;i="6.19,279,1754982000"; 
   d="scan'208";a="64267167"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 04:12:39 -0800
X-CSE-ConnectionGUID: OITPggbHTAeAfC2+xBDbEA==
X-CSE-MsgGUID: ZMz2nv0fRT+Xxn7a41C9Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,279,1754982000"; 
   d="scan'208";a="187092502"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 04:12:39 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 04:12:38 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 04:12:38 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.61) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 04:12:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=alqQKi3/F++twcBty6uZefcxulptKuyLZtfBMxTOlHJlSR06KiC9+02SMNh7Hp14oJQ/eGRnIPEq+ld/GX/FkqL8JII/vv92a4Csq41D50crvx3oFPIzgYeCJwOELGH+q6mVmxXPUSrcR/ztL0HpNc0z6Hqf4lujIECtsrC2nmV5ViTOtpVyyGVfkyxc+uCMqj7s2+lD+k0uf3eJfOFYVzEM6V/LMHBaszQkXwKFvsHA/xCftx/hDNDL4FeKIiTnUNpbJKCCmyx1nxhM9ChCQqJFGEVQFNePMFjPmDB5X2SpztuxkLK6YeR38L8hm5RdSTc8ocpKpfzb8f24pOlIjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEx5BhpYrV3elDZH56Rqa7TAFIfyjorq/qJEo2Pyidg=;
 b=iFFGxmlYjNPya+ZSZZNJMzwiGXppAEqyfOSWINaCO5WbXph5lSQ0IMC3u065i0m17CQca1R71cIeo6S2+JgKLgqh7T0KkWmaxYPA5Fw0xVhC8F+gS7BErat1PRIhjvujuFeuEc7OdgQR4wylcSo4G9FM5AuNypIVK1F5j66RiBKbPGT/SzP9sBaGOqea44D/MYodhgD3gDxld9bPgJCjw5nlfljclE4LwJlH7DhzBjUK/37cElny8ks9oIzWtEzhJ/IabqmCPj4dhaLun3Jdt1RzQDdKS/ZIB8uNLxpwYLIDfrrI6F6jQlTxzKBi+zCrvw8WCMx4W0E0kjFts363ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 CH3PR11MB7323.namprd11.prod.outlook.com (2603:10b6:610:152::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.16; Tue, 4 Nov 2025 12:12:31 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9275.011; Tue, 4 Nov 2025
 12:12:31 +0000
Date: Tue, 4 Nov 2025 13:12:27 +0100
From: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
To: Michal Wajdeczko <michal.wajdeczko@intel.com>
CC: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>,
	<dri-devel@lists.freedesktop.org>, Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin
	<tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Lukasz Laguna <lukasz.laguna@intel.com>, Christoph Hellwig
	<hch@infradead.org>
Subject: Re: [PATCH v3 18/28] drm/xe/pf: Handle GGTT migration data as part
 of PF control
Message-ID: <6yf4u3i5ufcuyidqhopnwf2ieq3hsb7w32qamr4jbdjpo3zitq@zpz6iy3odt5g>
References: <20251030203135.337696-1-michal.winiarski@intel.com>
 <20251030203135.337696-19-michal.winiarski@intel.com>
 <e7b4a23f-3fc9-4eea-95f0-03c1d7acab28@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7b4a23f-3fc9-4eea-95f0-03c1d7acab28@intel.com>
X-ClientProxiedBy: VIZP296CA0004.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:2a1::11) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|CH3PR11MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: c40e2d59-1757-4056-34b5-08de1b9b6de3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NHpOU2lmblk5L20rRDFEazdRRDc4eFRqZzNoVUo3WmNtaVpBV2xyK24wK3FM?=
 =?utf-8?B?WUs1ZWViN3FSdkNBaXhDSGQxRXJCVmhsNHpGSHY3KzRCaUYrNWdFUVdSUkU0?=
 =?utf-8?B?L0NubHdZTGt5VUJiS3FWTE9mN1phZ09wYXhSOUlPN2ZlTVBoZDhUNjlwM3ht?=
 =?utf-8?B?TGRIOGs3aStNdUpVS0FhK1Y1Z3dLMzNwbnZiSUY0cVpUekM0U3pUWDFUek5p?=
 =?utf-8?B?WFVzcjdnYUJjUlFsVmIxOWNGTFM5Q2ZCM3gwS2M3Q0VDeDJvSG1jclh5RDBI?=
 =?utf-8?B?WGt2WTNOMkE2Q1k1SC9rVUY0b0gxaThHQWUyMG9DSWY5M0dpTlI1U01SdFB2?=
 =?utf-8?B?QmYwSEdnOHNSSTVXZDlrQVd5YUFuc3BDazBuTjZZQUtneGFtVDBXODEzN0Nn?=
 =?utf-8?B?NmdqMjVsVFVRNEExNGtlKzNFZUsrZjFhTk12c2k2bE91U1pqL2FmcVRPUGpP?=
 =?utf-8?B?SkVzeFQ0ckNGRkx0MFVPK2txMUlRaWluN2E4UnhPN0wxRytsamFDVWgzWDIy?=
 =?utf-8?B?ak5jZE55MHptNWJ4YlNHejVhZ0plbjZVYUkwZTVYbDZCWnd1T1FmWnBMYkhC?=
 =?utf-8?B?ZGhTQ2EzcUMzcHpsWUV4bGhQaHRkSVFvVFU1ZUdSVHdjVERhYk5LT1FtdTJB?=
 =?utf-8?B?amY0eHdOSTZFZC8yNUg5Um1GS2ozWk96TkZLd0dtem9oZHNJUlA1clVhQUVK?=
 =?utf-8?B?K3lxL2tCUjBvbkRSendUTjJGc21yay80U3lieE4rSjVnR2txTFUydVNUQXNx?=
 =?utf-8?B?VHRXUjVJQ1NTZFh3RDRTdkhteTlzR2E3WElZV05BT09NaXRGOURoazkzTThE?=
 =?utf-8?B?NUxHN0ZJTVoyYVl5M3NmL1FsSTc5R0VYbURLaGJXVmNBUmprbTRmOHl6bVpR?=
 =?utf-8?B?NEdqWnJHKzlQS2tpUjNsUEZEMWVadEFLQ2ZncHFnZ094SWdrOFo0NjVGQW1y?=
 =?utf-8?B?YTlCR1I2dXltaHRWbmp5VU5jVlpTb1h5MHU5MDhDOUF3V0cxQ0swREVjOVF6?=
 =?utf-8?B?a29SZHovYjNseUtJcTNrUlRTK1grcmJYNUNHK0MwcTRkQmVzRHRUV2pXS3R2?=
 =?utf-8?B?N2l6K0ZyNGdnU1loL09FUU4xMnVKQzV1VmNtTXlWeXluTDBMa05ZOGhJME5h?=
 =?utf-8?B?M0N2engvRXlKSGd1MVdFYUVYaVNJZm55YkUrRm4vZkZQQlV2VktISk9oWHpT?=
 =?utf-8?B?L1hxNkFUNEluN09TYmR5ZjJ1d25BYTJESm5QMFRYdEovUk1qZDBob1NIcitI?=
 =?utf-8?B?SzBTWSszY1ViYXN1TTRaUkZlL3V1bFFydnBGcng1NnF5Q0FXeDY2YkZqRmdv?=
 =?utf-8?B?UTR5MytHQzNsRWszNUk0a2tVaWdTRW94cWtWRFJVSFdsSWt6ek42VVk3ejAr?=
 =?utf-8?B?MlNGejUxL2p0bExqMzhDdk8rNE85WFdibnY3UnA1M3Y1T2VGU1NneTlUNlZE?=
 =?utf-8?B?YTNBdTRiNzhWeHV3R0pTZ2hQOHFtcDRaeWRMcU1VOVM0SVRLLzZYVWduQXR6?=
 =?utf-8?B?VFpFdk5oN0Z5RlJvZHNuTE8xdVBOTTkydVIwY3RaWlA0Sk9IdGV5MGpBaU16?=
 =?utf-8?B?N1cvODlTS2NTemZXWXc2bjlZNkdVWXBMSUdmcDMzK0l5ZC9DQUwyVDcrN2pu?=
 =?utf-8?B?WGE5ZjZDZmZXQ21aNTd0a0l6dVE5Q3l3RVRtM0RkS2JaK3NyUEZiaThsMXdu?=
 =?utf-8?B?S1VydkhiWWRmbTlUZng4U015U1NWak9YSGFCSXdUTnMrUnBaTmh2ck95QzQ1?=
 =?utf-8?B?ZjRNT2U0YWZrdHZKdVcya0tZWDBudlNKbkY4MmdPSWtQMXhYZzBEMTFqSURi?=
 =?utf-8?B?SXJJMXdIZnJFb2xOeVpwRnhBWWtiUmswTmswREFJV0diQWZieS8yMmpma0t3?=
 =?utf-8?B?SCt3ejlaVnIxQURmZWpXVTZKY0R1WkdFZEtTeFNTaVcyUnh5aDhBeE1UVUxs?=
 =?utf-8?Q?K9ULwQKQ2KrYTwOW65YnOfBTZRAukLyi?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UE5YUS9FZDhVcXhBV0JzNEt6Z095NGFRUW83bUhoVDBFbURMeG01OWNpV1Jo?=
 =?utf-8?B?VFdEVjBlbVAxRm5TRUZKdVFBWVc1U05VeGdxanhQSE1ZRU91dlN5L0hSY3VD?=
 =?utf-8?B?ZFd3dDltSzlWVE95OUp0eitmdXozY2ZpZEpidWs5TlZPWHJKQ3Z1SkxTdUNQ?=
 =?utf-8?B?dUFUTUoxc2ZLby9UOGVoa0J4RHJseHo4UnA3dC9pMVhsSEwrelBYbm8xV2VZ?=
 =?utf-8?B?U1FSQml5YW5OcDJIamVMOEE2TkYxM0Fvb3I2YTgya05GUmNZYSsyMWtwY2Ro?=
 =?utf-8?B?WjJqaVo2VGRKQ3ZMTU1RTnRSaHFsckNKa3ZLQmRKcWhiWXgxdjUvc2QvaVNC?=
 =?utf-8?B?NWxqOFBHTFo5THVKd21CYXRMNXoxem5zN1F6bVlic0lud0Q4Q2RQRGJVaFRk?=
 =?utf-8?B?ZVFlZ1A4RTdlMlEyZ0RXL0hMUEJuWXBLSlc3V3BzekR2ZytTUU00N2M3OXBV?=
 =?utf-8?B?R0dnVGg1L3ZhRTZWYmkwMHNmRFIzU1NUOWJmMmdvNG9uTnFIcUFUT3dTUm1v?=
 =?utf-8?B?QXV4VXV3WHdNTjIzLzFleERJMGhhN1oxVFpQSjQrekVZNDhmeTRBMWZoZnZV?=
 =?utf-8?B?ejNHbHhqcGltNXBreExmNlRIeWpWRHgrYXBzMHl6R2ZSbzZ4TjF2eTFLK3FX?=
 =?utf-8?B?MTFYSFdUV0RGT1JWa2k4aDBHY0N3MUp5VFhqWUJpbnpQRUtVenQ0YzRuUTVD?=
 =?utf-8?B?YWlFNzVzcXVKMWFnOHVDS1NCTlZXUGtkZkFBUURReGsxT2toTzl6N1VDcTVm?=
 =?utf-8?B?NzhpR3NLc0crWDRMQWFkVlZwRi9CNkt6LzJEV2NCV3FhQVlRWFZoUkttUFRn?=
 =?utf-8?B?OU9MeThkd1B1aTI4UFdsYjUxZmU0aFJaNDU5L1hIQmI1eVVCY0JBK3FISjFy?=
 =?utf-8?B?NldkMmtpdUlKY00ranlodk4zSGxmUkhGYm5ZSzVnbnR4M1hQS2pYc1pENW4y?=
 =?utf-8?B?TGZHWThjR2xTeHJFRFhhU0M1aDIxVTBRcW1ZTWljZi9QamxqTi9iTll0OVdt?=
 =?utf-8?B?aGxHb2dBNUJ6TDBXOGtSVFNmVmRSSkYwQXRMRWEzRi9PRUE4bXRpN25iUHVu?=
 =?utf-8?B?dDRqQkxZUEtkN0RuS0ZQRXE5dTNLL3V5cEtxbzNPb1FaN0VpUWxnNlFLSUFH?=
 =?utf-8?B?T3BSSGlaUzhxYmxSK3hqVmNoZ1BrQXlDZTE2S3lGWHFMcVJWSUJUaVd3dGhV?=
 =?utf-8?B?Vjd4eXBVczRMMkplTXllYW1ZZmJyTkFsWCttREE0eTM4cXdLNDFUakU5bzlL?=
 =?utf-8?B?ZzdUUG1CYVQrS1A3c2RhS245SWJDUDFtaTFDL203YzJxN1d4ZkcrTk5ydjda?=
 =?utf-8?B?Ri9UNE9sMFQwRTJlVXpoUHA3R3FwbFFsbEt4ZFFmdHBPaWREWnBlTm1lTXha?=
 =?utf-8?B?TWdCYUpEVEg1bGlJUFVuODZhVXVRbGp1d1QrQWtxdWxQWmxtaXBkMWdSWUZW?=
 =?utf-8?B?MjJMNGQva0ZpblRaTXNhZ3NIK09rNkFJMDYzaEtlMnlmWFd3Q0htazNnN1JE?=
 =?utf-8?B?QkZTek9lNXJmN0k4RzAvbDJxNFFPNU54RlBTd2NxMDVreWJzNUtsSVg2VXcz?=
 =?utf-8?B?OWwvdkNjQVlRNlgwUHA5bzJHcll1cEFTaUZIVnNkSHFHMmxtM1VndVhxMEJR?=
 =?utf-8?B?dzlyZzFMdTRCV1ZpQ1RmaXZNRmFlY08zVnNwaENOcko1czhGL0duNmZRRVZl?=
 =?utf-8?B?V3R3WEtRd1IzRWF4cEo1VGphZmxnSExMakVPcjR2RGo2VTBJVll5ajNidmZy?=
 =?utf-8?B?a1JHZmhnN3FpN0VjUVkxZ2RFRjBHZ2JqcmpYazFSSDdxeGRVR0UraVBUeFNk?=
 =?utf-8?B?U0F3ajdXa2VvakQ3QXRBM1hDZjZ6TE13V1lIa1kybXRCZjJMclgvaDAzUC9w?=
 =?utf-8?B?MzNoZGtqWXp5MGtEQ1N3dlJ0aVU4OXo4YXVZQU9yRC9IMjZvVWludmFZSEZk?=
 =?utf-8?B?REZGazltWXJsWEhjZFBPOWpNTGd6UGplcmtDZm1vaWx1UE1sK1NsY1NLc0ZN?=
 =?utf-8?B?aTJvNXk5dTRHVkk2Y2FvQjl6QmVEU3B1Y21kSkQzVGRXZnlqVGR2REkxWXUx?=
 =?utf-8?B?SnkyN2p4OTJkSkd2UGZSbGFGSkYxRy93QnZvdGJYZVZJdHRFTGVEd3hqRER3?=
 =?utf-8?B?eDBFdUlOWk4rN1VWN0V5UW5hOEdQaXJqbEF5RDVwMmF0VFAzT0tLa3FQRmxr?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c40e2d59-1757-4056-34b5-08de1b9b6de3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 12:12:31.1947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3JJVJukiUdq1diKwfg74OhSGePMJudHEU/2GVYFbD2XicJKig2Mregpg5I3MKuhSyFOEciFNE9qYFSPOCXYyjDFCPCaiSzX7+01zsnwu+4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7323
X-OriginatorOrg: intel.com

On Fri, Oct 31, 2025 at 07:26:29PM +0100, Michal Wajdeczko wrote:
> 
> 
> On 10/30/2025 9:31 PM, Michał Winiarski wrote:
> > Connect the helpers to allow save and restore of GGTT migration data in
> > stop_copy / resume device state.
> > 
> > Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> > ---
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   |  13 ++
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c | 113 ++++++++++++++++++
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h |   3 +
> >  3 files changed, 129 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> > index cb45e97f4c4d9..e7ea9b88fd246 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> > @@ -860,6 +860,16 @@ static int pf_handle_vf_save_data(struct xe_gt *gt, unsigned int vfid)
> >  		return -EAGAIN;
> >  	}
> >  
> > +	if (xe_gt_sriov_pf_migration_save_test(gt, vfid, XE_SRIOV_MIGRATION_DATA_TYPE_GGTT)) {
> > +		ret = xe_gt_sriov_pf_migration_ggtt_save(gt, vfid);
> > +		if (ret)
> > +			return ret;
> > +
> > +		xe_gt_sriov_pf_migration_save_clear(gt, vfid, XE_SRIOV_MIGRATION_DATA_TYPE_GGTT);
> > +
> > +		return -EAGAIN;
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > @@ -1066,6 +1076,9 @@ static int pf_handle_vf_restore_data(struct xe_gt *gt, unsigned int vfid)
> >  	xe_gt_assert(gt, data);
> >  
> >  	switch (data->type) {
> > +	case XE_SRIOV_MIGRATION_DATA_TYPE_GGTT:
> > +		ret = xe_gt_sriov_pf_migration_ggtt_restore(gt, vfid, data);
> > +		break;
> >  	case XE_SRIOV_MIGRATION_DATA_TYPE_GUC:
> >  		ret = xe_gt_sriov_pf_migration_guc_restore(gt, vfid, data);
> >  		break;
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
> > index fbb451767712a..6f2ee5820bdd4 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
> > @@ -7,6 +7,9 @@
> >  
> >  #include "abi/guc_actions_sriov_abi.h"
> >  #include "xe_bo.h"
> > +#include "xe_ggtt.h"
> > +#include "xe_gt.h"
> > +#include "xe_gt_sriov_pf_config.h"
> >  #include "xe_gt_sriov_pf_control.h"
> >  #include "xe_gt_sriov_pf_helpers.h"
> >  #include "xe_gt_sriov_pf_migration.h"
> > @@ -39,6 +42,106 @@ static void pf_dump_mig_data(struct xe_gt *gt, unsigned int vfid,
> >  	}
> >  }
> >  
> > +static ssize_t pf_migration_ggtt_size(struct xe_gt *gt, unsigned int vfid)
> > +{
> > +	if (!xe_gt_is_main_type(gt))
> > +		return 0;
> > +
> > +	return xe_gt_sriov_pf_config_ggtt_save(gt, vfid, NULL, 0);
> > +}
> > +
> > +static int pf_save_vf_ggtt_mig_data(struct xe_gt *gt, unsigned int vfid)
> > +{
> > +	struct xe_sriov_migration_data *data;
> > +	size_t size;
> > +	int ret;
> > +
> > +	size = pf_migration_ggtt_size(gt, vfid);
> > +	xe_gt_assert(gt, size);
> > +
> > +	data = xe_sriov_migration_data_alloc(gt_to_xe(gt));
> > +	if (!data)
> > +		return -ENOMEM;
> > +
> > +	ret = xe_sriov_migration_data_init(data, gt->tile->id, gt->info.id,
> > +					   XE_SRIOV_MIGRATION_DATA_TYPE_GGTT, 0, size);
> > +	if (ret)
> > +		goto fail;
> > +
> > +	ret = xe_gt_sriov_pf_config_ggtt_save(gt, vfid, data->vaddr, size);
> > +	if (ret)
> > +		goto fail;
> > +
> > +	xe_gt_sriov_dbg_verbose(gt, "VF%u GGTT data save (%zu bytes)\n", vfid, size);
> > +	pf_dump_mig_data(gt, vfid, data);
> > +
> > +	ret = xe_gt_sriov_pf_migration_save_produce(gt, vfid, data);
> > +	if (ret)
> > +		goto fail;
> > +
> > +	return 0;
> > +
> > +fail:
> > +	xe_sriov_migration_data_free(data);
> > +	xe_gt_sriov_err(gt, "Failed to save VF%u GGTT data (%pe)\n", vfid, ERR_PTR(ret));
> > +	return ret;
> > +}
> > +
> > +static int pf_restore_vf_ggtt_mig_data(struct xe_gt *gt, unsigned int vfid,
> > +				       struct xe_sriov_migration_data *data)
> > +{
> > +	int ret;
> > +
> > +	xe_gt_sriov_dbg_verbose(gt, "VF%u GGTT data restore (%llu bytes)\n", vfid, data->size);
> > +	pf_dump_mig_data(gt, vfid, data);
> > +
> > +	ret = xe_gt_sriov_pf_config_ggtt_restore(gt, vfid, data->vaddr, data->size);
> > +	if (ret) {
> > +		xe_gt_sriov_err(gt, "Failed to restore VF%u GGTT data (%pe)\n",
> > +				vfid, ERR_PTR(ret));
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * xe_gt_sriov_pf_migration_ggtt_save() - Save VF GGTT migration data.
> > + * @gt: the &xe_gt
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * This function is for PF only.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_gt_sriov_pf_migration_ggtt_save(struct xe_gt *gt, unsigned int vfid)
> > +{
> > +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> > +	xe_gt_assert(gt, vfid != PFID);
> > +	xe_gt_assert(gt, vfid <= xe_sriov_pf_get_totalvfs(gt_to_xe(gt)));
> > +
> > +	return pf_save_vf_ggtt_mig_data(gt, vfid);
> > +}
> > +
> > +/**
> > + * xe_gt_sriov_pf_migration_ggtt_restore() - Restore VF GGTT migration data.
> > + * @gt: the &xe_gt
> > + * @vfid: the VF identifier (can't be 0)
> > + *
> > + * This function is for PF only.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_gt_sriov_pf_migration_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
> > +					  struct xe_sriov_migration_data *data)
> > +{
> > +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> > +	xe_gt_assert(gt, vfid != PFID);
> > +	xe_gt_assert(gt, vfid <= xe_sriov_pf_get_totalvfs(gt_to_xe(gt)));
> > +
> > +	return pf_restore_vf_ggtt_mig_data(gt, vfid, data);
> > +}
> > +
> >  /* Return: number of dwords saved/restored/required or a negative error code on failure */
> >  static int guc_action_vf_save_restore(struct xe_guc *guc, u32 vfid, u32 opcode,
> >  				      u64 addr, u32 ndwords)
> > @@ -279,6 +382,13 @@ ssize_t xe_gt_sriov_pf_migration_size(struct xe_gt *gt, unsigned int vfid)
> >  		size += sizeof(struct xe_sriov_pf_migration_hdr);
> >  	total += size;
> >  
> > +	size = pf_migration_ggtt_size(gt, vfid);
> > +	if (size < 0)
> > +		return size;
> > +	if (size > 0)
> > +		size += sizeof(struct xe_sriov_pf_migration_hdr);
> > +	total += size;
> > +
> >  	return total;
> >  }
> >  
> > @@ -340,6 +450,9 @@ void xe_gt_sriov_pf_migration_save_init(struct xe_gt *gt, unsigned int vfid)
> >  
> >  	xe_gt_assert(gt, pf_migration_guc_size(gt, vfid) > 0);
> >  	set_bit(XE_SRIOV_MIGRATION_DATA_TYPE_GUC, &migration->save.data_remaining);
> > +
> > +	if (pf_migration_ggtt_size(gt, vfid) > 0)
> > +		set_bit(XE_SRIOV_MIGRATION_DATA_TYPE_GGTT, &migration->save.data_remaining);
> 
> btw, does it make sense to save GuC data if there is no GGTT data on the main GT?

Not in a sense that such provisioning is usable, but we do not want to
have any dependencies between data types, and we do need to handle this
corner case (not fail the migration if GGTT size is set to 0).

> 
> >  }
> >  
> >  /**
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
> > index 66a45d6234245..bc201d8f3147a 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
> > @@ -19,6 +19,9 @@ int xe_gt_sriov_pf_migration_init(struct xe_gt *gt);
> >  int xe_gt_sriov_pf_migration_guc_save(struct xe_gt *gt, unsigned int vfid);
> >  int xe_gt_sriov_pf_migration_guc_restore(struct xe_gt *gt, unsigned int vfid,
> >  					 struct xe_sriov_migration_data *data);
> > +int xe_gt_sriov_pf_migration_ggtt_save(struct xe_gt *gt, unsigned int vfid);
> > +int xe_gt_sriov_pf_migration_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
> > +					  struct xe_sriov_migration_data *data);
> >  
> >  ssize_t xe_gt_sriov_pf_migration_size(struct xe_gt *gt, unsigned int vfid);
> >  
> 
> only one nit question about corner case, so
> 
> Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
> 

Thanks,
-Michał

