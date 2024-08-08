Return-Path: <kvm+bounces-23592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C332F94B413
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 02:19:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30956B23DC7
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 00:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AAB120ED;
	Thu,  8 Aug 2024 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2k3cqI/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80AE645;
	Thu,  8 Aug 2024 00:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723076368; cv=fail; b=SqNxZQt0MAA0Nv/x3Vd3dcglPG+OU3QoRiaNMr2NbLpQ/Jc3phwDsQja2xMoV33CUWupdW6UtkYBp/4MWqBq0Vs+D4+xgKIktUgJoDxtfyfociyNoNb5pjlFai6Aa7ZItdB8E3NNZjSlbXLobEnW0UQbNrGDpwQlXz3rWQf7Y7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723076368; c=relaxed/simple;
	bh=Yta4qn7ZJ89tdOz9zw5Y91dr26soCoLfmQSOzMv/FzE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mt76t13jiDPR3hiOT7TP//qu438XhULA2nQIoHzHbmyiGkfhcY2tuXRB/XB0PcsgZb/GpIvOuPPITm/CeubZllEWuEhNW7PMj9bguJvMynjzxfcdVz/vCAOAEdXAjQjMx1Ay+QSEiEot9hkMbFwmaaqIscnXfTF7nKFzL0ecWcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2k3cqI/; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723076366; x=1754612366;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yta4qn7ZJ89tdOz9zw5Y91dr26soCoLfmQSOzMv/FzE=;
  b=d2k3cqI/7hXELGcMbq3lxc4iPhwHZeak4EwVHgj1MYvKOYtLDRzYKHZT
   VmO6cL7gJun65Gez+c0YT2pm4Chw+mbZEBREWp6LJI0mFVUON85cyhiEl
   b01WjTbagIwXNtbyqCtEfk+nFMR4gzf6I+V+72jlYjy6ivG40vz14f3Qy
   NgsNBPVuSntczGqCTpK1LVuEorZcDAZKKSfhQbKSf8v+n4rP9etpn09k2
   LnSNVWjoYx/VcHo8xD4rPy8HtDnIZ8HXZHjuXnCV9n4wjZEGy2SafQtXW
   swyBzFAGr5xWdv2u7+ivmBpdmzfXLwTY+x9FZYrPyqQ3kYwlp+bPYacZU
   Q==;
X-CSE-ConnectionGUID: GS3HcSzrSwiIiUf4VrLbqQ==
X-CSE-MsgGUID: QymVpci1T2+H5vb4bV8ZZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="21327893"
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="21327893"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 17:19:25 -0700
X-CSE-ConnectionGUID: 5k6TQPY0S8K8/i3YRSbi0g==
X-CSE-MsgGUID: mvBFwgsuTli86oNl4zRJHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="57735748"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Aug 2024 17:19:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 7 Aug 2024 17:19:23 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 7 Aug 2024 17:19:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 7 Aug 2024 17:19:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 7 Aug 2024 17:19:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YkErtV+3y15kXJuRk84tJb33nKPCp7RIalwE8ETF3QGeBu7oD+zEF3EGIxYuLO/tY3bJHAwHo2+eIYbh9vbutxbgFiXCGGeYQevekLlhPERKKO6mh9PqHJwEdEPIcitdESl7qYSu7KGUhhhFr8NlljJtChpr6x9Vjx/6+zJUd0BgRqxv9DqD8/sye8/zdsTAOR32kQPcDjjV2JbjgNHBm3dTBk8jAY1SedSjhhpMGnpBCTy92YINtW2gjc3v4y63o4lG8jiz97P8uY0voASJqBvdJkMENMiwBDC6PoOCQXWSikD7dr9QcmPIR2A/pkmed1KIvMbmwn94v0/84C0eKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lgob51G8nu2M5C2Ha6d2ug4r/O8fy8sAr7mfC86azqM=;
 b=a9MwievcwdvHwEgLzKNxThN1TbXrWwY46FLtnMp1QhQ9QTaZDaMeIe4XV2w8nFsmMTsPtPrsKDmFuzUXcTestUQmj2CBHRiXQFjMIGcG/6MHHR/nYmpYVQ2DBSV78P3y3Ig+h9Vxru8l7gEx8kmfTrCWn1IRO4oCWC3TivklSP4D1S/IMghVIjBcW8ahsjQ7RaEcLNTfZbbE4WhniStBBcXup6uHx9Z1QDg693pdhgj80ImhPaSBBTE+gBY8SW1Ygsi3SRYBTNuNFrd5PgGXB82fxCKwv34nC/gauouh7oVG7VSxJrEeas+iE1c/a49+sn5HlAFAY1APqNjWnc/oiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7479.namprd11.prod.outlook.com (2603:10b6:510:27f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.25; Thu, 8 Aug
 2024 00:19:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Thu, 8 Aug 2024
 00:19:20 +0000
Message-ID: <8adf5979-54b8-4706-b0e0-1d7b13ea452d@intel.com>
Date: Thu, 8 Aug 2024 12:19:09 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
To: Dan Williams <dan.j.williams@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
 <66b153f3e852f_4fc729488@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <66b153f3e852f_4fc729488@dwillia2-xfh.jf.intel.com.notmuch>
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
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB7479:EE_
X-MS-Office365-Filtering-Correlation-Id: 35bc47bc-6df8-43e1-05c7-08dcb73fbf2d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WnZIY1ZNZHpPMnEyWGZIN2srU2dDME9LeW5jVHR3WHFQUzZjZ0ZiWC9YK01H?=
 =?utf-8?B?VFF0VWs2cjY3ZDI0UllURHlzbVVCanVvcSsvNWYvcmZJRE1tVHk0REJuWXhX?=
 =?utf-8?B?NWNKU0oweE1mLzZ1VmdrWW0vMWVQWDJuUktoSVhhQzYrQkhkVGU0UndZNkgz?=
 =?utf-8?B?SHF1K0ZYbFJlSDdaTnk2bkdCY2hHblA2THZOWWJ4VFM5cXo4RnRweUdrSjJr?=
 =?utf-8?B?ek5mTzQ1K2lYYmtKbmRDUGNzTWQzcE5obmdJTXFBdUVkVi9ja0ZBYmJkQmsx?=
 =?utf-8?B?bmNsMnBySmQvSzV6UHo5VjdIN25vZ0VPb1VqOFd3elpPZnJWTy9JTXZkSnpx?=
 =?utf-8?B?RHZiMXE4U282NUNQeC9WSk51a1hBZUwrbm1sK1VLT1JWRTMxOXpEdEJ4a2VN?=
 =?utf-8?B?UDl5OTUwV243d0dKN2wwcDZIRHNpbkZhMS9NRGp4WGNzcE5IWDNKakFlUjZy?=
 =?utf-8?B?cjRJYzlyTHNKQXQ2aGhSR0JZclhyWXhxRlZieWFjNjZNT2xFUjZQSjh6Qlhv?=
 =?utf-8?B?WE9Qdnd3M3dmcDROVkNqcTMzQklqZWtTV095YmIySjcxQzBTM0VkbTR1Tito?=
 =?utf-8?B?NnZlYVpjaTZHVXRKdk43TWIyM1hxTW43bllBUWJpY2hkWGppZEpzNFVic25P?=
 =?utf-8?B?WURPMDFHLzRrdXFTL2RpK0pTVDAzb1QxdnVkU05TV2FxNHh4REp2UFNmMkhi?=
 =?utf-8?B?aHZwZGhRM0ZuUkp5N2QwdFRhTnBzZEdyL2YxN2c1cHN1YUg5b1FLSVFoZ2ds?=
 =?utf-8?B?NnJRZXRIdTFqbWNIYkFkYXRXSlQyWDlXL2kxOWdxYUVTVWUwcHFEWlZpRFVE?=
 =?utf-8?B?QVhhcmlUQXF5NmIzNUJJeUk1UGJTUmRXRjNUMUxwNjBrMW0rRHZYOFdHY0x4?=
 =?utf-8?B?Z0VmOWgxcFFJalBCZ3dLVzRBcG0yaFFLNTRwNVgxSUJyY0UxRVBtWGtNOVBw?=
 =?utf-8?B?ZHZsb2ZWeDVlTFpja0tKQmRRQVh4TE5EeGxKN3JYOFFZRitweGhSSDBXcmdL?=
 =?utf-8?B?STlVdE5ia3pPc3ZvWnQ5VUdVU1pOTDdsLzVaOHBOd3RkMnMwb2wwVDhSZkNU?=
 =?utf-8?B?NzFGNER3eFZ2ZHVRTk5hMkVva3c3MEN4WXVhdWNCNFBNbXpwdlk3aXYwakZt?=
 =?utf-8?B?VFJiK3ZURVB3b0xNYVM5Y3d2Q1NIbGt5L2ZxcW9mYXBnTDkrOWRKM3ZJZG1R?=
 =?utf-8?B?ZGxLaVl1bG1JMnFncUtIWk1wM0FXR2pubWVuWis2MmdNMUpYUzhPOG1nREdK?=
 =?utf-8?B?MnI3TGlveDhua1hnczA0Z0tjdUJMZHVXaHVjU2Q0M0xHV3Z3Uko5TnhCS1Fi?=
 =?utf-8?B?b3JMWklLRi80VEVERy8xTURvUEdCVkIrZXNmWFV6ZmhhY01SWkN1V0xqSksv?=
 =?utf-8?B?S042K2d3dkJsdTVCRFd4YVdmdWFYcTdUYStSSDlrM3BFeGVlbkM0U2FHQU5s?=
 =?utf-8?B?VEpUUWVXZGxhZWVSQzJ6SGRSNTJLSUR1S2pmT1JUcFJrbHFZdGp6SWFyVjhZ?=
 =?utf-8?B?MGRaMjJUV3diT05yL2x5NFhidloxZVp5aFpSS0h5ZENyUFBTTUQyZnptaWxT?=
 =?utf-8?B?MGhEKy9qOEhIQXNTRlRTVzFvUFhrVUxZM1MwSk9JdDhJcjFjWWlSbm84c2hq?=
 =?utf-8?B?WmRkNlZFcW1QNHdmRWlSL2RGZnlpZmE2dkJoMWZGdGd3UURIakd1T2NQT3ZS?=
 =?utf-8?B?TVFGcVVrRnVud3JSK3JmRW53dEk3R2IzOVRHZ3VVamxnRThjR1k4YWZXVURL?=
 =?utf-8?B?SkhJYVAvemsraUw0dzUwN0dGY3hUMXRXV01oWHNWaTZ4YjM0R005UlZ3Ui9j?=
 =?utf-8?Q?HRMJadJzTtqQY7bn0bAGsWlZaCOKCJK44fsU4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnhWRmF4ZTFCUk1aRTgvY2x2MjBhb205d0FLTzlaV2x5aGduNjhtZU9aamJ2?=
 =?utf-8?B?Yi9MdHdwRkRDV1hpRHFGWmExWEwyVFhTS2poMXdnUWw4U2FaWlBLT09EcHdy?=
 =?utf-8?B?MWFyNWcyU09YelRxb3RZV1MrUUZHWDV1UzNobFVvcHdmRG92T1dCWnlValNW?=
 =?utf-8?B?cW9qY1pzZ0hCQnJqZzBJWVhkN1RsUGR3NW9hMERtOEhTYU5DQSt1T1Bnbndu?=
 =?utf-8?B?TGkwQ0hzYXdsR3BYWmltaW5jaGx4ckZlRDJDSlVuWTZFTnhPRnFGV3ZoTUZh?=
 =?utf-8?B?c21TUloxK1R2ZFZ3UFYvN0tCak0vOVdXUk5NUHQyNy96dDlFNjFjN1dwK0J4?=
 =?utf-8?B?MGc3cEt2bDd0TE5BQ09oTXl3MEI2U1g5Vm8rMENXeDBndUN3SWUyRVFtTC9T?=
 =?utf-8?B?RHRzZzdKMUsveXNpenpkdmk4YTlxbHpXSXpzTUpLMnRoVmlVY3JqZVNodW1X?=
 =?utf-8?B?ZDMrRVlLK29nK2RLczYzSlpFeVFLdTFrM1RobDIvcURWZG0rdldsRVNGenRL?=
 =?utf-8?B?dWhKVTVKRXk1L0x4QkJKeFEzNkljK012SGJHQ1F1VXF3dVFKQWdOajJ0U25J?=
 =?utf-8?B?QWRkZmZPbElGYk0xNmpkek1lbnFWa0FvZThnUEFTZytKRDdYQ1BxbjdDSng4?=
 =?utf-8?B?NTZGVkJIRUJhNkJ2NlR6cWdzUm5BV2wwQ2txdDhobXhPd04rMStpUkdOQkNa?=
 =?utf-8?B?SWZ3dFRZMzVJbEg0L2o0TTlrMHNiU2pONEo2VGRzSmhXeDVBbkh6REFzWGk5?=
 =?utf-8?B?TEtmdUluL0dhRUtEa3RBMzBwS2hlQ0VJbEtYTHNIMTdXRnRSMFJESlMySzYr?=
 =?utf-8?B?anhVaGliYTVUeS9lb3AweGRTaFV3SUdMRjdMRTBOcTY4TlprTlU4b09jUEE1?=
 =?utf-8?B?WVQ4NXZxaENFK095ODZoL212WXllRUVVUEUxcjQxS2tSN1orcHVjZHBTcHM0?=
 =?utf-8?B?QzdxalFtL2dHZmV0UWtqQUt4NFlTZDYzODI5TFFkcnNhVGtiR1JTVGs4QzZT?=
 =?utf-8?B?T1g0a3ZiVzYxMGExVUY3T2ZWbUM1cENBajFlSkE1eW80VVFiU2ZVMXNvaFpa?=
 =?utf-8?B?UysvNFQrZDN2UlhKamptWHIxYjJhaWlVaWhSaHB5U3pCV1h3di9QZnNiejZR?=
 =?utf-8?B?MjQ1dHJGc2Z4ZzJCcEc4NVN5ZllvTlI1QWxjUmJWTlJtWE1OT0ptd0JyS1Jp?=
 =?utf-8?B?ZWY4SjVacWRKeURObFlaU2Jva1lkOTFESnh2TndyaEhUeHNVeFB5RGNNYnE0?=
 =?utf-8?B?dDFFUFFJWmhvdGxFUG5pOGV4RW5Nd1BTME10VHJRTnFUOTNPOS9XeVZtYmU3?=
 =?utf-8?B?RzhpclRJNGtxR2VNakEza01VNXFvY3krMVFqNDcvWjJ3eWpTdzlxRUJsSi9D?=
 =?utf-8?B?aWV3cWhtcHN4enFkREhWTytUUW15TnArUGloMFNNMjNMNVNCeDlRV3RoajZN?=
 =?utf-8?B?empOVTJYRFh0Nm1ZMWFqcU1OSU1ndzlDbWVlbUZISW1zRllyN3E1eWtvS29w?=
 =?utf-8?B?aE0xSjNsNi9pYkRuUFVPOTI3V0VYS3NkVERlelIzSzJpNjBUdWVkWUxaMVJW?=
 =?utf-8?B?TkNOWnJ3UHd3YkNJUm1nSUJpend6bytBbjBtUFFjZU5YUlhLKzZLeFVpb1Z4?=
 =?utf-8?B?MHdpbXh1REVsY2tFTmR1bGl1NTBMVktXTC9nOTV3TzlrUGhKUC9KR3dqb2Nr?=
 =?utf-8?B?UEJZdVRPbXFNQS9PcG0wTlN0SXd2V1ZzZjk2TTVrZnNjNllrNnZkd1FmMU9q?=
 =?utf-8?B?QzA5blVXQ2lUdzlkb05Fbk1HaitMOFJoNzJhMTd1Ym1sVi9VSWM3VU9Hd3I3?=
 =?utf-8?B?K3ZhdVRsc05WRTlvMWRuMVllU2V5NkFtMjBvRXh6RlM3aXZ4WE1JdHFvN3hQ?=
 =?utf-8?B?cVU2ZXFVdjA1cnVOUFhJa0hlWmFjcDY1eFNiYkUxVk9tNFBiNFFNMjVySjdY?=
 =?utf-8?B?L1dqMWE1Z2JNSUNHNzFSUzBiU1IxM0g4RmZoYW5nQWxDMENxK3BtZHh1dWMv?=
 =?utf-8?B?RTRYM0Z0MVZHejdZckRxcUJXUkY1UlpjU3BKR0hGeTFrVnRoNy9HV2NRUlZy?=
 =?utf-8?B?ZjZ2RG5UZnFzTWEwZ2VYellFNVJGb0tYdmc1cDFobXlzRVN4YzNIODlGcjNj?=
 =?utf-8?Q?gyq7+dlqXE8uwcqDnFQufiMLc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35bc47bc-6df8-43e1-05c7-08dcb73fbf2d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 00:19:19.9748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PL7t/XYur/m2pPAn310syRRUz3lbeBoiMZpC7CAc4AyeWBN5Jh95jw47AqTF9WUuCm3x1bdE5D//ydprjXilg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7479
X-OriginatorOrg: intel.com



On 6/08/2024 10:36 am, Dan Williams wrote:
> Kai Huang wrote:
>> TL;DR:
>>
>> This series does necessary tweaks to TDX host "global metadata" reading
>> code to fix some immediate issues in the TDX module initialization code,
>> with intention to also provide a flexible code base to support sharing
>> global metadata to KVM (and other kernel components) for future needs.
>>
>> This series, and additional patches to initialize TDX when loading KVM
>> module and read essential metadata fields for KVM TDX can be found at:
>>
>> https://github.com/intel/tdx/commits/kvm-tdxinit/
>>
>> Dear maintainers,
>>
>> This series targets x86 tip.  I also added Dan, KVM maintainers and KVM
>> list so people can review and comment.  Thanks for your time.
>>
>> v1 -> v2:
>>    - Fix comments from Chao and Nikolay.
>>    - A new patch to refine an out-dated comment by Nikolay.
>>    - Collect tags from Nikolay (thanks!).
>>
>> v1: https://lore.kernel.org/linux-kernel/cover.1718538552.git.kai.huang@intel.com/T/
>>
>> === More info ===
>>
>> TDX module provides a set of "global metadata fields" for software to
>> query.  They report things like TDX module version, supported features
>> fields required for creating TDX guests and so on.
>>
>> Today the TDX host code already reads "TD Memory Region" (TDMR) related
>> metadata fields for module initialization.  There are immediate needs
>> that require TDX host code to read more metadata fields:
>>
>>   - Dump basic TDX module info [1];
>>   - Reject module with no NO_RBP_MOD feature support [2];
>>   - Read CMR info to fix a module initialization failure bug [3].
>>
>> Also, the upstreaming-on-going KVM TDX support [4] requires to read more
>> global metadata fields.  In the longer term, the TDX Connect [5] (which
>> supports assigning trusted IO devices to TDX guest) may also require
>> other kernel components (e.g., pci/vt-d) to access more metadata.
>>
>> To meet all of those, the idea is the TDX host core-kernel to provide a
>> centralized, canonical, and read-only structure to contain all global
>> metadata that comes out of TDX module for all kernel components to use.
>>
>> There is an "alternative option to manage global metadata" (see below)
>> but it is not as straightforward as this.
>>
>> This series starts to track all global metadata fields into a single
>> 'struct tdx_sysinfo', and reads more metadata fields to that structure
>> to address the immediate needs as mentioned above.
>>
>> More fields will be added in the near future to support KVM TDX, and the
>> actual sharing/export the "read-only" global metadata for KVM will also
>> be sent out in the near future when that becomes immediate (also see
>> "Share global metadata to KVM" below).
> 
> I think it is important to share why this unified data structure
> proposal reached escape velocity from internal review. The idea that x86
> gets to review growth to this structure over time is an asset for
> maintainability and oversight of what is happening in the downstream
> consumers like KVM and TSM (for TDX Connect).
> 
> A dynamic retrieval API removes that natural auditing of data structure
> patches from tip.git.
> 
> Yes, it requires more touches than letting use cases consume new
> metadata fields at will, but that's net positive for maintainence of the
> kernel and the feedback loop to the TDX module.

Thanks Dan for this.  I think I can somehow integrate your words above 
into the changelog.  (It took me bit of time to digest though due to my 
bad english.)

> 
>> Note, the first couple of patches in this series were from the old
>> patchset "TDX host: Provide TDX module metadata reading APIs" [6].
>>
>> === Further read ===
>>
>> 1) Altertive option to manage global metadata
>>
>> The TDX host core-kernel could also expose/export APIs for reading
>> metadata out of TDX module directly, and all in-kernel TDX users use
>> these APIs and manage their own metadata fields.
>>
>> However this isn't as straightforward as exposing/exporting structure,
>> because the API to read multi fields to a structure requires the caller
>> to build a "mapping table" between field ID to structure member:
>>
>> 	struct kvm_used_metadata {
>> 		u64 member1;
>> 		...
>> 	};
>>
>> 	#define TD_SYSINFO_KVM_MAP(_field_id, _member)	\
>> 		TD_SYSINFO_MAP(_field_id, struct kvm_used_metadata, \
>> 				_member)
>>
>> 	struct tdx_metadata_field_mapping fields[] = {
>> 		TD_SYSINFO_KVM_MAP(FIELD_ID1, member1),
>> 		...
>> 	};
>>
>> 	ret = tdx_sysmd_read_multi(fields, ARRAY_SIZE(fields), buf);
>>
>> Another problem is some metadata field may be accessed by multiple
>> kernel components, e.g., the one reports TDX module features, in which
>> case there will be duplicated code comparing to exposing structure
>> directly.
> 
> A full explanation of what this patch is not doing is a bit overkill.

I'll remove the structure/macro/function details to make it more concise.

> 
>> 2) Share global metadata to KVM
>>
>> To achieve "read-only" centralized global metadata structure, the idea
>> way is to use __ro_after_init.  However currently all global metadata
>> are read by tdx_enable(), which is supposed to be called at any time at
>> runtime thus isn't annotated with __init.
>>
>> The __ro_after_init can be done eventually, but it can only be done
>> after moving VMXON out of KVM to the core-kernel: after that we can
>> read all metadata during kernel boot (thus __ro_after_init), but
>> doesn't necessarily have to do it in tdx_enable().
>>
>> However moving VMXON out of KVM is NOT considered as dependency for the
>> initial KVM TDX support [7].  Thus for the initial support, the idea is
>> TDX host to export a function which returns a "const struct pointer" so
>> KVM won't be able to modify any global metadata.
> 
> For now I think it is sufficient to say that metadata just gets
> populated to a central data structure. Follow on work to protect that
> data structure against post-init updates can come later.

OK.  Will do.

> 
>> 3) TDH.SYS.RD vs TDH.SYS.RDALL
>>
>> The kernel can use two SEAMCALLs to read global metadata: TDH.SYS.RD and
>> TDH.SYS.RDALL.  The former simply reads one metadata field to a 'u64'.
>> The latter tries to read all fields to a 4KB buffer.
>>
>> Currently the kernel only uses the former to read metadata, and this
>> series doesn't choose to use TDH.SYS.RDALL.
>>
>> The main reason is the "layout of all fields in the 4KB buffer" that
>> returned by TDH.SYS.RDALL isn't architectural consistent among different
>> TDX module versions.
>>
>> E.g., some metadata fields may not be supported by the old module, thus
>> they may or may not be in the 4KB buffer depending on module version.
>> And it is impractical to know whether those fields are in the buffer or
>> not.
>>
>> TDH.SYS.RDALL may be useful to read one small set of metadata fields,
>> e.g., fields in one "Class" (TDX categories all global metadata fields
>> in different "Class"es).  But this is only an optimization even if
>> TDH.SYS.RDALL can be used, so leave this to future consideration.
> 
> I appreciate the effort to include some of the discussions had while
> boiling this patchset down to its simplest near term form, but this
> much text makes the simple patches look much more controversial than
> they are. This TDH.SYS.RDALL consideration is not relevant to the
> current proposal.

I'll remove this section.

Again thanks for your feedback.

