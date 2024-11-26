Return-Path: <kvm+bounces-32488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 037C89D9060
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 03:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A562B2429B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 02:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C95536127;
	Tue, 26 Nov 2024 02:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9+a9woU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E9B1CFBC;
	Tue, 26 Nov 2024 02:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732587627; cv=fail; b=smw1JnpNiOf7Vwpyl2hJRCo+ikNzSbViBps8n1MjcWZm2G8f24Phmh6pNhq7EtE4hcpjx4M4EYKbqCm46W/6MyW02FSk/ET5ie3v84HdTRHpM8bGDsrl3hOJSAJ/CUixFnv/egNGjol0pCZMSoIRIAQb1d+vcUIJsv5WBugsimM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732587627; c=relaxed/simple;
	bh=k+xyPO4Ztv+kHXm1eKOVy+8gBP2a62apjPHpxalRSdY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BCDmy6eZ5LGI6Nd4gdMpmefgjIX63lHMY2T+cQBLvUpcBDc3LvgbiaoaL/JAG02ry8Qusk7iuZezwmXl5h6D4jcuQ4SEG0OGD87EPQDC5QLtmut2bTne5UK8tB2khXYSnv61UaiKHFFBhW07KnrRlL3sfwF8ueNrzLt6R5vEBMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9+a9woU; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732587626; x=1764123626;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=k+xyPO4Ztv+kHXm1eKOVy+8gBP2a62apjPHpxalRSdY=;
  b=e9+a9woUmn56s0BMii8WPwO6+rolJfwD2uqhfkd1YKV0dSjfWIOAFlEU
   lP1ocDbhvgACV+qHYnSQdygBA9gaxttbMQsRXC8hNYhWNIBx5GJSC4US1
   xu47o+Th3CICBAYk/EpOHJ+0YF3yDOL/Q/jwNLKwB2qC2Z2bI5i0E2AaI
   5pGeQrolclXDHzaL3g1bapgyqQI5gfM33RPl/IPK2dGP1NpQr9cvt40P8
   7zZh7GDSv2iglzA3D0OHt/6veqSu/HIaXeplm3lPAffZFxyvfvfCWF7zQ
   36foareZACy+44s0Wa25WPhCQsrkt1ryMDfT/HZstRqS3XmCms7L65j7u
   A==;
X-CSE-ConnectionGUID: hf6jAdchQ0ejy8hOxiBShg==
X-CSE-MsgGUID: IkICw3pVRryLLgSEvIimCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32671649"
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="32671649"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 18:20:24 -0800
X-CSE-ConnectionGUID: xSOXHC5WQAOCA4KCa7yB1Q==
X-CSE-MsgGUID: 4FtBxPb6Q4igFTlpuRV3jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="91583662"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 18:20:24 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 18:20:23 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 18:20:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 18:20:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHcfahLMISb1PDabml3oxW09Ah8xBtgm9ZHVPH5870K5HKc5c2bp0bRAvRP5Q2XM1haZHQgIXQpMVt4sBHK9YjaAZkz10KuG+z8O6Pgt3lc04h6LtcrZo+CqwFBnsTArf7b0B+oiOzd1xyx5Ix764CiJF5528oN4KjxZ3eZVL/r+abQRt2ckSQRFJYD7GhlywvktuwRvcBZ6RZ5VeSXP9/jAZU3+QqtsLHQXTFYqU1LPfoI5bGwt4TIowLDjunDQqcnWuyOv3b/IWtRMNK2N+oDAPrG4G491e+cR/puWYbGJnzENQC9GP7YlMN8FbvY3gxr4O+OlRgb8NBATDvNUdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dd04MjjEXj2TPd9Gk0YGK3RTZKwz/jqgMeX37k5hLNA=;
 b=eyK/brd8yNTAhalKgVT9ehlQqXg+h5wGa7yJ/l7wE0DgvbRDPhKMKzVxhVLWoPYTJMcLpTDs5PuD+0DUFIDqaCPLFxSEUxK4gVTOkMXEbWjhA5RaMLbMqalxfAH+fbqtnja78i5UjxZWxMGgFOIE7R8o/njBWSSI3j0YYrPA7Y87+DPHcL+VvFkHRBAL2ThQsBSuY06eMmR1agvKpMDTw6HFEEXSAlzpfsX4Ry2RJeFPhWd9NlYjta8QLhHxZm53XMXSGSv41O2ZdbDb0rfdPH33cTq2uACehSlCZwxaOJ3OVtrU8DxwJkkZ621+80gid4MgelB2A94eTsYBDT6x1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH0PR11MB5266.namprd11.prod.outlook.com (2603:10b6:610:e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Tue, 26 Nov
 2024 02:20:20 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 02:20:20 +0000
Date: Tue, 26 Nov 2024 10:20:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <yan.y.zhao@intel.com>,
	<weijiang.yang@intel.com>
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from
 the guest TD
Message-ID: <Z0UwWT9bvmdOZiiq@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com>
 <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
X-ClientProxiedBy: SG2PR03CA0118.apcprd03.prod.outlook.com
 (2603:1096:4:91::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH0PR11MB5266:EE_
X-MS-Office365-Filtering-Correlation-Id: 73c7258b-5baf-455a-f818-08dd0dc0e04d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aWh6K1AybVVOVldwTzk4bHpFdGd6RG44ZTdpZmdCTHAzUkhKM3Z1R2R0MHRz?=
 =?utf-8?B?NDI0bzh6eDlZbmRoSlo5T2VyVkZtQmRlRVZjanhaQTJlSlRHSXpPNWRhZ055?=
 =?utf-8?B?UnMzOUF0NE9YMGE0bHZSQVpaMjZ5NERGOFQ5S3dJWkQ5ajhXMlhOZUgveFdW?=
 =?utf-8?B?Y3FHelB5K05xd0M0NTdqdmthSGt0Nk51UkVnZkRUQjM1U0pRa29rSXlLZmxM?=
 =?utf-8?B?L21IdzJQVS9tNkp1S1U2MWVjRURyQmN4eHBTbXdMaDhMSUdSZjV4SS9GZE1P?=
 =?utf-8?B?VlF1dXIzZFFxMHZUT0lEclNCNzJNVW9oNTRHanl6dmVjeVFIdjRxcEppRk9j?=
 =?utf-8?B?OEhKclQvb1RiT0ZVRXg2S0xsNmtEQ2FlSmpqWWxIVUl4UjRSRnAyTTIzMVkz?=
 =?utf-8?B?NjRiYjdwdzNPS25oQitOOEpyWDVySnArNW9yZ1NzVDFHUnhhSi95cko2Ty9i?=
 =?utf-8?B?TVlaZnpBcmIycjVWT0FYUWtVUGhCOFdodjJVODB1NnVTeXArSmluTEVmMC94?=
 =?utf-8?B?M3NQQmxYbXdMbGVULzdHT1JHMi8xZDJKVk5OWVBZUC9BbXRLdUdieXE5dHpn?=
 =?utf-8?B?Y3NNK3ZzSVM5Ymk0TEwzRURnb3RQYStKelpYVmMybWRYdkcwbEJWazhnWC9I?=
 =?utf-8?B?aVo5eUlrUGJZN3gwT2dNWEVPSktZVHkyb08xcGhQVUtsRDlJK0xVSmY0WVMy?=
 =?utf-8?B?MUdkekkrV2Y0clpCNEFkbVhiTGdTcUQ2UkhNZS9WbWJoSzRaVFcxYURpZTV1?=
 =?utf-8?B?N3pGd1FzQVRuS3I5K1I0blRKUDNod3RGMjZlM25NbkRGZCtXbUJBRW0xejc4?=
 =?utf-8?B?YUIyWmxTbXd2cVZvcTRhUWllTE5pQkFuSFJmRmQyZW5JbHRibEg2dUNndGI4?=
 =?utf-8?B?eXBRamE4bTJIcStDVE5hV09hODFDVC9ZcmljaWFLMExzaFhMcUZyc3V0RW83?=
 =?utf-8?B?Z1Q0NXArYVhoVUxhcUhwK3NHWGh1blpPNDlHUEYvNS9oVDFYNzNIcGhTU1My?=
 =?utf-8?B?Qm5EKzhpNVEzMXNMRjEzSWdHRWYxTDVGb0dEYzJFVmdIQnU5TUJFWGw1TkZM?=
 =?utf-8?B?aHlzanU5dTBxUGdhRFY1RWpONHNpTWp1UzAvdWNTTURwTEZEWXdpUGg0dkJX?=
 =?utf-8?B?YktPYmZyOG9vSTQ5bGVVTjZwRHpmR1NWenR3N0VNOXBRRHdqd0hmTWZpZ3Qz?=
 =?utf-8?B?azhndTMyVUJtcE9wRkdRby84TXVEYjNPY2RUY2ZueWlRdGhyM2RPMnJpT00z?=
 =?utf-8?B?eXk5NUs4eFBtcHUvUUtvL0ppVUVObTRwdXMxcGNvSXdTVDl1OVlPdG4yVnNU?=
 =?utf-8?B?V3packRwZHU0dXdHTFVva2tGWE1BOEUyc0Y0U2ovY0hTZklIYTNOVlJwYUI3?=
 =?utf-8?B?ZGM4TVB4ZUY1LzhjTSsrMFVyV1lFSmFkSVR2NFBzb1BRZXhVZU5VVXpqbGZL?=
 =?utf-8?B?Zll5NzJGYU5xQVJvWVAyWE54QnRRVzdicjNqam9kVE5LVDF1SnhBaWhZMXJa?=
 =?utf-8?B?dkVrSXdTV0RCQWhxNXFITFk0dHZqNkk0SCtHMUt2QVlHN0VXUW5HOHM4ZnZP?=
 =?utf-8?B?VDJzeTdMTFVtNlJnL0JhK3k0OWVQZlBXb1FDQzFYY3hUL3A5OW1zMWZpV2Vj?=
 =?utf-8?B?cGdLOUt2K0t5ZjlCb3RXems2TUVUR1hvczBTYldDaEhCMVVVd29Cbnh5SCts?=
 =?utf-8?B?NDZydWdibUVOelNaSkV0WHFrM1U4MVFraFJpczI0dXRkTkhrL0pXYmcxeGx5?=
 =?utf-8?B?cGFoeFBUR2theXMrSXNVUXhhWVBnU1hlRjZDNGwySCs1RXVVVnFKZk1WVHVm?=
 =?utf-8?B?Q0xvR3JGdlR2QWZTK3RXUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFJOM0dmUE5ieFBoTy9VdnRhOVk0blU4L1Z5WUNlSERtMWVqOElhYU5ERUd4?=
 =?utf-8?B?WWV0ampPckpFRTlJWnZFeWFOZks1c284K2h4azBMbTBGOHFJc2hEVEE4RDRC?=
 =?utf-8?B?U1RCMEcraUxKc3FRMlJjZnZId1lqbGt5N2drSDB5OHBYbEtkSThsamJJS2xq?=
 =?utf-8?B?R3BuaWE5ZERHNE5EVjV4UmtvclRvNmdhMWpqaG8ycHVWZHVoeXZFQ2F1WXdL?=
 =?utf-8?B?ekQ2Wm1KaFdiVjZFWFNUL1FKNkRvRWNiaEVFeE1zVFQ5UVVuaHFBSEZRcEFp?=
 =?utf-8?B?cnlIbHZKejlENkhCME56QjVBU01GaGFKU1k4eS9sTlVtQXVpY29OZnNwNzhP?=
 =?utf-8?B?bThLZXNPM05MeWZKVDlvRkRYRDB0KzBtMEVWWlRhSEo4UmJYVVFPaE9Nbnlo?=
 =?utf-8?B?cXpKMkJ2YXdXQlN6dDVTYTJwZFVBOUhZQXpKc25LZkQ1TXRoZHgxUFF6VU50?=
 =?utf-8?B?aHlIanM5WkJ2VGVCSm5CbGNCMmJ1K21kVUR4dFpuSGMzQ3E1dVIvcHl6TFdn?=
 =?utf-8?B?SWUxMFJqTHc3MzZLTjdUcnorUURKc3poWjF0bVpxcFFsRlNkNkUwcTVlMXZ2?=
 =?utf-8?B?WE1kem5aNUQvRjZQUThXR0VKcUM3L0ZHWUxGdUMwVVF0bEcxdlVCWVI2Vy82?=
 =?utf-8?B?cjl0ZFY4aVp0cko5MlZpNCs5dkx6RnZHS3c4NzFaZTluUzdtL01EN2tYOXZn?=
 =?utf-8?B?dTY4dThHOU1vTnljUFhOS3g0ZEg4dk5JTWlQQmtibmVsNjB2c2tVMHNlcVF2?=
 =?utf-8?B?VUFvbmt4TnBWNmlKU0ZheVl6U2lPWVY5b2VZanNhcUZSOTdFRDl4UzVUVXF3?=
 =?utf-8?B?QWhjU2EycVE3VG1ZWHl6YVhCaFB0dWEyb2YwZ3hPRWNNd01iWXoxR2ZkMkto?=
 =?utf-8?B?M2N2R2JFODZwbFZqU1VINFhYbUJhdTFiODF3NXF0c0txTTdpYzhGaDdsK0s2?=
 =?utf-8?B?K3l6MEs5c0dIdzlSRll5Wlh0R1VVSktoV3JjUzNtWVYzRUJpRlVJdW1UTTYw?=
 =?utf-8?B?aFV0MldSUGFMYmVseU5PRmN2eVRoREJaalBlYnJYSnZ4SmJld203c09JNWQ1?=
 =?utf-8?B?aEtpS2p4bkdmWGE2aEpGSnA2MzFYVFByWUN1WmF6eFJJM2lTbVV4ZGpaaTQ5?=
 =?utf-8?B?Wi9QcmNkTTI2WkJ3ZDUzTStHbmQ3bXNoSjVNak9Zdnk2UjVPZk13RnhURnJ6?=
 =?utf-8?B?WEZ4VTJNSmQrZkVkMmgrUGJ4U2hqOGRCZ05xaFRqVmd1YXdjUEx1SUg3Z1Vr?=
 =?utf-8?B?Y3A3dWhaYTIvRmxQR0Q2aEZyNzN0S0Q2L1pUaWJna1dzWmdaWElVYXkvejRL?=
 =?utf-8?B?aUJpK3h0ekM3YmJ4dEcvMWFUbnlWTGE3WmIwbUVlbmkzQ1FZMVBBaXg4cnFZ?=
 =?utf-8?B?RmVrQUF6QitEck4yZDd3Z2g3SUhYTnRoMFlZZFRKaWVXek43UU5qUlRoT0R6?=
 =?utf-8?B?SERhNmhuckRRVHZXM21qM2FGTzI4S0FKM1QrcEFnT0NwejQxZmJieG9OTmg0?=
 =?utf-8?B?bS9XWFpsSHp2Y2drUDk0ZzU3KzlMeHpJMmxWNnZheEV4eVpjTGQ4a0twMU01?=
 =?utf-8?B?UlBaOEZCTmRkeWkyUVRQUk5Tb2R3TTEzUlRaanVDQitZWThiN0hXaGFKRks3?=
 =?utf-8?B?ZWlZNlZEL0hvcXV4MU83YkdrbU1kQ21vVCswS242clhob2pKWnZ2WUhLZlNG?=
 =?utf-8?B?bk9qenNJSVQ5U2J6OWN0RElpTEhCSTFxbHlxcGFGVEUvbWtzbi9GZVAxeXd6?=
 =?utf-8?B?RG8rR1hsZmdwazVFYjFXNTlOOExBVFdDRXZkTTU1ckhaUFMxQVdCYisrMk9M?=
 =?utf-8?B?aytwZHJuQUNKazBnYy9qeTJFaDBKeHR0MHpPbUFlb2phckF4NHhmZ1RrVUdn?=
 =?utf-8?B?Yzg0cXRGRkpPTnN5SmxvSDlGeUg1R3lnWkNkaDRXN3FLZ05wMmRlVXNGT1c0?=
 =?utf-8?B?Tzc1ZlliZTc4VzZZdFI5eFhLaWdjZ1drVElqTzVSc3V0U2l1dThwL0ZYelJy?=
 =?utf-8?B?a0Vwc3JiZDg5Rlp2ekZxVUcvc0dlMmMyOEhJVDU2NVQ1M256Rit1alNWSVk4?=
 =?utf-8?B?cTNueHRTOVJDMy8waEhqbTlnNU5aSUdUZjhzQXZ2MlJzZmRVVEtWWmxlYXJV?=
 =?utf-8?Q?w/+wRsogpdbidEeuOAeMf5nby?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c7258b-5baf-455a-f818-08dd0dc0e04d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 02:20:20.6029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUx8xS8v+abHlr2aqwcZDNY4B9Ex0770LhZvOt5mA5eIWlgyjWDDLraf8NWqJSDa1EbsATWDFPSEXUWycD+1jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5266
X-OriginatorOrg: intel.com

On Mon, Nov 25, 2024 at 01:10:37PM +0200, Adrian Hunter wrote:
>On 22/11/24 07:49, Chao Gao wrote:
>>> +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>>> +
>>> +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
>>> +	    kvm_host.xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
>>> +		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
>>> +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
>>> +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
>>> +	    kvm_host.xss != (kvm_tdx->xfam &
>>> +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
>>> +			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)))
>> 
>> Should we drop CET/PT from this series? I think they are worth a new
>> patch/series.
>
>This is not really about CET/PT
>
>What is happening here is that we are calculating the current
>MSR_IA32_XSS value based on the TDX Module spec which says the
>TDX Module sets MSR_IA32_XSS to the XSS bits from XFAM.  The
>TDX Module does that literally, from TDX Module source code:
>
>	#define XCR0_SUPERVISOR_BIT_MASK            0x0001FD00
>and
>	ia32_wrmsr(IA32_XSS_MSR_ADDR, xfam & XCR0_SUPERVISOR_BIT_MASK);
>
>For KVM, rather than:
>
>			kvm_tdx->xfam &
>			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
>			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
>
>it would be more direct to define the bits and enforce them
>via tdx_get_supported_xfam() e.g.
>
>/* 
> * Before returning from TDH.VP.ENTER, the TDX Module assigns:
> *   XCR0 to the TD’s user-mode feature bits of XFAM (bits 7:0, 9)
> *   IA32_XSS to the TD's supervisor-mode feature bits of XFAM (bits 8, 16:10)
> */
>#define TDX_XFAM_XCR0_MASK	(GENMASK(7, 0) | BIT(9))
>#define TDX_XFAM_XSS_MASK	(GENMASK(16, 10) | BIT(8))
>#define TDX_XFAM_MASK		(TDX_XFAM_XCR0_MASK | TDX_XFAM_XSS_MASK)
>
>static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_conf)
>{
>	u64 val = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;
>
>	/* Ensure features are in the masks */
>	val &= TDX_XFAM_MASK;

Before exposing a feature to TD VMs, both the TDX module and KVM must support
it. In other words, kvm_tdx->xfam & kvm_caps.supported_xss should yield the
same result as kvm_tdx->xfam & TDX_XFAM_XSS_MASK. So, to me, the current
approach and your new proposal are functionally identical.

I prefer checking against kvm_caps.supported_xss because we don't need to
update TDX_XFAM_XSS/XCR0_MASK when new user/supervisor xstate bits are added.
Note kvm_caps.supported_xss/xcr0 need to be updated for normal VMs anyway.

>
>	if ((val & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
>		return 0;
>
>	val &= td_conf->xfam_fixed0;
>
>	return val;
>}
>
>and then:
>
>	if (static_cpu_has(X86_FEATURE_XSAVE) &&
>	    kvm_host.xcr0 != (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK))
>		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
>	if (static_cpu_has(X86_FEATURE_XSAVES) &&
>	    kvm_host.xss != (kvm_tdx->xfam & TDX_XFAM_XSS_MASK))
>		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
>

