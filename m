Return-Path: <kvm+bounces-36467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD210A1AFF5
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 06:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 801B53AB728
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 05:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 791101D7994;
	Fri, 24 Jan 2025 05:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Saxq+XR1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59917FE
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 05:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737697009; cv=fail; b=Tiz0u38ZsfpLcW+t2av3X1k8H8x4H1nmjUK2+1Bkz5icjOx/9xKU8vbtYHBdmIKBYcocRwJDfLvYY/KeUazD8euKk8j/HYhlP67AX4vD/kkFY49uvrLYpOOtsoEDS5B04lV4+ma8lYadJy0w1Dq+YSL9A4YAe/6rAZnkmlx9cp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737697009; c=relaxed/simple;
	bh=PFID4S/s6yeg+ryipQG6V6YdD+VjYn+1R1AfYZI6qYs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QMlRQKaC5Ckle/mPJtVXYjxkV2GcJkAbth2XEaAMm1Zx4ARDiprMDpv4Ke5UUHoAdI/O3FDTrxKl83UHdfPTFw6We4HeBgQFOoJTWPyN2YLVXO0lbTpIcaBLhiQEDlosc0AS3WmyeuHMVHTZ1d4vWPec71ih3vFhTNQWkzWf+8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Saxq+XR1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737697008; x=1769233008;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PFID4S/s6yeg+ryipQG6V6YdD+VjYn+1R1AfYZI6qYs=;
  b=Saxq+XR10IS3/gMzXx6OFS5cX3qM7fpwjWaHheWIj56z2Ju7BUk+p6Iu
   1bqh/+6dCz44QFngYqfK6Hz8XjAzUr7hRlnL3TKLbemlhGiVovO9DZQzR
   KGsB12DYvtuK9Zy8V1FzVytE8FyQ5oOk3Y+NC+60G8iPCshLJaukRjgKH
   qJDggX/mUU8NKbN0pgU02Ero06bKpQD012ReDPBijFcLTHjZ7uDvFfsc2
   67xyWmUo12wTr2klgZNGr8GN3jtzDpyTph1An24e1sMDeREKq5Lsqiug1
   IP3fzo/NuZz0rmWPdhYmpDiDQTTw81zhcUo5mjjEpVjRiRuhntbZciGBi
   w==;
X-CSE-ConnectionGUID: xMMlvyx5S3uocSzt5Ui5bQ==
X-CSE-MsgGUID: ahbBW50sQtWPbUcMtVI5jA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="38323695"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="38323695"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 21:36:47 -0800
X-CSE-ConnectionGUID: mUoLboYBRhau03FPxC7YSA==
X-CSE-MsgGUID: xc/3eRUiSwGVd9OmRcu2Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,230,1732608000"; 
   d="scan'208";a="107597954"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jan 2025 21:36:47 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 23 Jan 2025 21:36:46 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 23 Jan 2025 21:36:46 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 23 Jan 2025 21:36:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O0xbxB2ma6eNpllisK5qew44iywO9lDXscF4lQbf32a8QKZwzA7M8CcyzY1/uYVgaUikOtQmoyHAU5w3jzk95joCGzzxS0MHP88Ae8qt6tIOV0G1/eKNXzK72FxZnUbgxpC3vb/TJW+C0QnI/ep2L6voefmcl1NTSW8liFJlr7qKekcZSvUj+QmlcUtCXL+7TfecGeXczbhQy0Y/i2jRTrS2qoKAkC/lBCmmGPBRnv3KJ4nr1QXX2SqMomNsC89gO9mPQEGRivhDnptk1otRixNT+lg/HqZHvwn+xOQS0SMoZFDEm4twPT0KvxKUD1F1l0ksObaNMphV0IKfmZPB/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6neuIez3Jn6X8S6sz+7mrL3S+k6Ut60kEFhJkqJfB8=;
 b=drOYxm9yFoREZkijMwJUM8QI4KtbZpgN4NLTnvg3GLAzgOdOyhy+lrKD56v/djpj8CydbXjA8W527yuxk1UYmOqkL6WgTc59m6PEeMMVg7EatoTr3RBbtdMN09B9jRfbF+QNXJYH8n2tBLK6r5orYdEHp9LYStNjFd/phUHLFTCAFiwd+C53kug9AAr2zQ+KRDTz5egTTzxoQAQuJR1yud8ted+U3YYsc4Ku0Oh27/kIU+y+o7o/8ohHiJUZ/ota9f0/7GrxRXParlEtcqViJyG9dX/sGjNXn8IknVSKEm+xXFH7yojk0KJsgD72fGe6OyGTpzbQnSetz/YvHzDyOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS7PR11MB7886.namprd11.prod.outlook.com (2603:10b6:8:d8::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.17; Fri, 24 Jan 2025 05:36:44 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 05:36:44 +0000
Message-ID: <57ce5eba-189a-44aa-b451-1d4dee452dc3@intel.com>
Date: Fri, 24 Jan 2025 13:36:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] memory: Register the RamDiscardManager instance upon
 guest_memfd creation
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-6-chenyi.qiang@intel.com>
 <2582a187-fa16-427b-a925-2ac564848a69@amd.com>
 <5c999e10-772b-4ece-9eed-4d082712b570@intel.com>
 <09b82b7f-7dec-4dd9-bfc0-707f4af23161@amd.com>
 <13b85368-46e8-4b82-b517-01ecc87af00e@intel.com>
 <59bd0e82-f269-4567-8f75-a32c9c997ca9@redhat.com>
 <5746187a-331a-4e8f-a7ab-9273fcc64e9b@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <5746187a-331a-4e8f-a7ab-9273fcc64e9b@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::32)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS7PR11MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: da379d55-5cf6-4d12-7ec0-08dd3c39166d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WktJYTZQbXVaNE5Kc0U4VnJXa2ZOT1BzeVhmZDM3d1ppVHgvV0F3SGZiYTB1?=
 =?utf-8?B?UzFuNnRHY1pYVjQvclMwelNTT2xrbDBKK2FnNW1CcWhXVDlhSlNVWk1QYUZz?=
 =?utf-8?B?YmZZQWRCSWNnQXJlOTFYOWREUUdmMkY1S2dvblBYZEgwMmowK2NpRGRucWVK?=
 =?utf-8?B?REZPSWhnZkYrNzZuNTVCRys2MDgxUGRmUzNPTVZ6OUpIdUFUdlZGSkNjRXR2?=
 =?utf-8?B?OW9UVC94K0cvL29ZYmErMVFBMlljS0d2djcwNzJyOFdjRjg0Y29IUVZmaHJH?=
 =?utf-8?B?YldmR3F3UjQ1RnErRlRvOExGc1dqcWI3MmlzbjV1ajZwb0lvT0owbjBpN1dG?=
 =?utf-8?B?eTNpYWp1SUpncFdqaXo1TkZRRUhDS3pqVHJHZGhKOFQzWmRFSzM0RG00YUdS?=
 =?utf-8?B?ZnBTL0tpZVg1Y3hUM0ZXNER6Z0VaeXY3OUc5M2tmVlZZMU5xbkEzR2M3dDB6?=
 =?utf-8?B?b0tqMGVGOHQzbitMM3AxZDI5ZGI1azU0NFVyMzdINmdIN2xpcnIyV2NDSFhC?=
 =?utf-8?B?YXBjTkxHOXg0b2lCQzl3NzltQ2dqWFBJUXdGeis1M2hWOVVpS0ZBVE9VaGNV?=
 =?utf-8?B?ZlF3SEJQYm1YRUgyb3pFRXdWUC9hc01iY092T3RBNGFxdGF4V0o1dWlNK2Jy?=
 =?utf-8?B?MXZyRGNNdkdsQ2xyTTRSMDJyU244dlptZTY0dXBGQWdpcDRWQTlZZFE2M2ds?=
 =?utf-8?B?YlFYSVpubEZHZXlvdTgvTFhVR1R1L2loZ2NBQXRVWXhJbW8wbWxtbVIxK2pM?=
 =?utf-8?B?Z2FUbC9aZXlNNTdkRk1mdysyaXowUlZ4STNiZEluZUQ0Q1lTdnRYUVBLSVcz?=
 =?utf-8?B?QmFuSG1GL1FGZjZjdkprMUhUaXhnakk1NGRqSHVLTjdRcE1sVk5wSWovTDN4?=
 =?utf-8?B?aWNCTERHVExzV1VYbE9sUjlSZ0d6NTZuaCticHcwZHBmdE0xZDc3VVgvMTZu?=
 =?utf-8?B?VzFJYi8wOVRYVmg5V0o4UnE2QW1FVnUyVU12ZkJJZVJLYmpZZExBQWpBOTJY?=
 =?utf-8?B?KzFGUFAzY1dTM0prUkpKNkhiT01JK1ExRllRVVFqWnI0Y2g2NmdvenVQV1ZD?=
 =?utf-8?B?QzhIeERUYi9BckZsN3VxdUFQV3l3ZFpzSjMwZUJ3YkIyN1J4bGsrM2FpZWFt?=
 =?utf-8?B?TW85UVgwU0Z0TktJRlo5cS9pTXdXZ2QrWkEyUW53SlFGa28zUm9CdFZZOE1T?=
 =?utf-8?B?N2JjTnlPRzZwYjdSV0ZPb1BFRjJod0VLNm9xWkFiaHdRZk5nUVZESTNZOU1B?=
 =?utf-8?B?ZzNkRzZmS21wbkhMK0wvSytMNnd6VjNITlVEaTg4aDRJeXZTU3dTZHVVYnB3?=
 =?utf-8?B?bjB2dmoyUTlWU3JyS0VPQnp2MDRUTnpVQjNSbUlUa3FLYSs0clo1K3RiVFF6?=
 =?utf-8?B?QkN3Y2FnQzNlVGRTNTNrQkljV093Z3RGNTdiSEllOGEzaTNIQ0V0Snl4Z0RT?=
 =?utf-8?B?UFNQM1o3QUlhcGNrWlE3Q252ckwwMTNsZ2wxSzNvcWVqTUFMaUROZmg2MXJs?=
 =?utf-8?B?bnFIaXNnZHhWR21SZ1hHbHBWK1h2b2J3QTJrWGpTTk9iQVE3RTZ4UGxWODMy?=
 =?utf-8?B?VWhVUWpVdEIyVkdTeldBS1cwa3kvb2xtblF5QlZubWdoTTEwUDVqbmFaRTNR?=
 =?utf-8?B?M3RCRHR4SmVHczBjbEZMMDV6VzFkZ3c4eGJmbytGY2RJcFN5Q3B0cFVodlBK?=
 =?utf-8?B?aElGWDdhMndJaG1valBKalJHV3V5L1dLZGN6R0ltWERnMllnd1dGM3lwMHU2?=
 =?utf-8?B?YUJRTVRtM3FFbmJSNWRoWjE0RGJTTDk1anR1RUZtV3FOVkJEV2hWbEFyVU84?=
 =?utf-8?B?SGNndDh0d3k4QnhOS0dMMzNWbERDNEhGQXVRYXMzdHdTS29LQ2ZlNkU2aGJi?=
 =?utf-8?Q?HvY5F1QsNkSTK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2JtRzVpSEpCM2QrbEVSMXBNRW9LNDJsdVZzK2lSU0thUFBaZGROQ3FRSHVQ?=
 =?utf-8?B?Zy93aVEzV1dFUGt6Tm0zYVo4THdHRjBua1JmejgxNndHUWJXdWVFb01jZld3?=
 =?utf-8?B?aFJKblBGdzk4VkFCb0lxWUNMeUovRlh6dnlmTVpsbTVFcnFYd0R5bG1jV0tK?=
 =?utf-8?B?UGc4MWQ1RWUzTWxrdXpWUDFzdGdGTWhPd0tZSmprd3hwdDBrWEs1NkpPLzBV?=
 =?utf-8?B?MW4vWEhDME1MQlE0b0hFMWsvQXU5NFVYUTNBNXRwdkpLWjYxZVNIOURzSXV5?=
 =?utf-8?B?SkVTN0g0ZEpuNFc3SytEYVZuS2hPNGJZRXdKM2JXVGVHNUhuNktpbnVHMjNv?=
 =?utf-8?B?KzlzR0NBTUc1Smx3YXVZb2k2YkIxVzZ3V2x0TlFZaG0xR2p4NlpBMkw2RDh3?=
 =?utf-8?B?NmU2Sm9vQ3RFdk0zS1dNSjZqS0huL3lqSjBYY29LSEV0R2V5TEJtb3o3aDBS?=
 =?utf-8?B?VmFUa242dG5NTE1SWjJLTlpubm12U0pXcHppcmFqQ2dXSU1na2J2dWs2VGQz?=
 =?utf-8?B?dVo4UVQ0MExRNmo4NXExV2tDaVVaandPL2ZUYTJ1TmZJck9hQWtkdEZWSkhp?=
 =?utf-8?B?SmswWCtyZmF4Q2RMajBMcDFKdG92TEYwSGFWMDhjbjd5VEJZT3lEbjJKcWFk?=
 =?utf-8?B?VUI2bWNiQmZJQU5kWnRDdzUwN09EMDJ6SmpPUTN2QkZxT2JGdkgxUGM0eEZx?=
 =?utf-8?B?OEVXR2k2SFM1TzlleE5xR2U3SmRFVjZNMFJUZjhWRXE0SXR4L3NJNEgyS0k4?=
 =?utf-8?B?TkpBM1ExYzJrY1RBM0J3ZkdNTHllMEJyT0NjTHlkZlFpMmpLaUJ5cndQd2d6?=
 =?utf-8?B?VXNtdU1TN0Q5L3lQSkxuQ2pQOGVaQkxjdERtS3pRL29tM1FlN2NibSt0aDNO?=
 =?utf-8?B?dkx1VzlSdklwUXpFREhrZHU3bCt5aHpUeG1USHRJTEdBcTRQVEZ5WlhCUS8w?=
 =?utf-8?B?dFloMG5hZzl5T3luZzhReDVCdld0WHQ0UDV5Z25qK2p4WWFNSVFycmpXTXUv?=
 =?utf-8?B?TWhzRDRaaWtPOUtaQU5wMlVFbXJybERTVWdodG8xWkp1Z3YvMnJhbzQ5d29X?=
 =?utf-8?B?T3ZBcHFvU3o1SmJGMmpMaWlzT1RlR0U3bEtGVDZlYVJvS0JaSzh6TXVaT3dl?=
 =?utf-8?B?VTJkMnJMZTBQc2tpYTN1c1lGcC82WERsR0VLQ200YzVlVndrbHYvUExWV2Ix?=
 =?utf-8?B?YU9laHo3ZjI1R3o2akpUNGtkcTFGdEVtL3BtK1BxaGxxU1ZhVWQweThLSmZJ?=
 =?utf-8?B?aDBPNHVEZm1ZNnJ0VDlkQlFxODNnY3lzYWFtcUFhRTFvSWNVQjN0RG9WSSsy?=
 =?utf-8?B?WStUUXdkdElxN09XYmpvMWNrc1Q4aWE5ZnlzL3R6eFZZY3RoTFJ1dGh1VnhY?=
 =?utf-8?B?OUhWUG9qVXNFYkg2d3lsbzNzUCs1cFZvSlArRkpCS200NFd5Z0UrVHFnektP?=
 =?utf-8?B?cEpHbkVqMzZmUG5EdVZOaWtsS2JiMUZJbFZWU1NON2NoMzJzbVVjRGRHeERR?=
 =?utf-8?B?NnFHSW55RnRyYnBVR21MWmI4TEZZczNGMVArZ3c1RlpHMTNJckpKVXZ2OC9P?=
 =?utf-8?B?WGxkT0hvbklBSHZxbCt1b0MzZnU5Q2pXdkdWWnpLTWdhcFhqdUlNVVp5dFlP?=
 =?utf-8?B?ZWUxNDlJYTR3RXFjdlVsbEdOcVF5MU1CM1N6NXZDL09CcXVDemhvVmthWmRP?=
 =?utf-8?B?QnRaUVVpNXBNTUcxSHVIUXc3UFRWZnFlNW1Sc044M2kyd2R6cW9NTm11Nytn?=
 =?utf-8?B?Tk5xYVVtVXphY0dPVlhBcUxqWW5yUUM5VkFmS2hPSE0wRHRyTjZzckc1dmZI?=
 =?utf-8?B?Nk5nMUJMSCtNTnBOS2F6REhRTDVRbGhBaTlTWFRxVkxCU29aYmNnQ1FOVUtY?=
 =?utf-8?B?eWZZWHAyY1Bqd0lORXEwU1dKZW1XZ3hCaklyQnY0TDY5UFpScS9PeEh6RTRy?=
 =?utf-8?B?cUFWamFaYkRrVkZ3alpQeVlacDc4c2M3VmRveURVR3AyRVA0TVZkZ1lPL1ZI?=
 =?utf-8?B?LzdzUmZla1BlaFl1V2M1SnFkNlRVWjRXaHhJL2VWL05oOHNoeXVaOEtlYWpm?=
 =?utf-8?B?a2FtVFkyQ3Z2U1IrUzhQdUNOeWlVdjNQekJTM3VCU2JYTmtzeVhVNlRhWTA1?=
 =?utf-8?B?NmtEZXczb2hHVlhucmVza3ZKZm1oaEk4Sm50clU4MFhiWmxGOUl0SGpDOW9O?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da379d55-5cf6-4d12-7ec0-08dd3c39166d
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 05:36:44.6845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uRQFs86SsgnZVC2M7idGQFil2I+gfzikK+yteYGKMOwxrFjg1DNJKGk3cCXcxPQiD620lG/2OnbVzjoOfEIujA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7886
X-OriginatorOrg: intel.com



On 1/24/2025 11:27 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 21/1/25 00:06, David Hildenbrand wrote:
>> On 10.01.25 06:13, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/9/2025 5:32 PM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 9/1/25 16:34, Chenyi Qiang wrote:
>>>>>
>>>>>
>>>>> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>>> Introduce the realize()/unrealize() callbacks to initialize/
>>>>>>> uninitialize
>>>>>>> the new guest_memfd_manager object and register/unregister it in the
>>>>>>> target MemoryRegion.
>>>>>>>
>>>>>>> Guest_memfd was initially set to shared until the commit bd3bcf6962
>>>>>>> ("kvm/memory: Make memory type private by default if it has guest
>>>>>>> memfd
>>>>>>> backend"). To align with this change, the default state in
>>>>>>> guest_memfd_manager is set to private. (The bitmap is cleared to 0).
>>>>>>> Additionally, setting the default to private can also reduce the
>>>>>>> overhead of mapping shared pages into IOMMU by VFIO during the
>>>>>>> bootup
>>>>>>> stage.
>>>>>>>
>>>>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>>>>> ---
>>>>>>>     include/sysemu/guest-memfd-manager.h | 27 +++++++++++++++++++
>>>>>>> ++++
>>>>>>> ++++
>>>>>>>     system/guest-memfd-manager.c         | 28 +++++++++++++++++++
>>>>>>> ++++
>>>>>>> ++++-
>>>>>>>     system/physmem.c                     |  7 +++++++
>>>>>>>     3 files changed, 61 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>>>>>>> guest-memfd-manager.h
>>>>>>> index 9dc4e0346d..d1e7f698e8 100644
>>>>>>> --- a/include/sysemu/guest-memfd-manager.h
>>>>>>> +++ b/include/sysemu/guest-memfd-manager.h
>>>>>>> @@ -42,6 +42,8 @@ struct GuestMemfdManager {
>>>>>>>     struct GuestMemfdManagerClass {
>>>>>>>         ObjectClass parent_class;
>>>>>>>     +    void (*realize)(GuestMemfdManager *gmm, MemoryRegion *mr,
>>>>>>> uint64_t region_size);
>>>>>>> +    void (*unrealize)(GuestMemfdManager *gmm);
>>>>>>>         int (*state_change)(GuestMemfdManager *gmm, uint64_t offset,
>>>>>>> uint64_t size,
>>>>>>>                             bool shared_to_private);
>>>>>>>     };
>>>>>>> @@ -61,4 +63,29 @@ static inline int
>>>>>>> guest_memfd_manager_state_change(GuestMemfdManager *gmm, uint6
>>>>>>>         return 0;
>>>>>>>     }
>>>>>>>     +static inline void
>>>>>>> guest_memfd_manager_realize(GuestMemfdManager
>>>>>>> *gmm,
>>>>>>> +                                              MemoryRegion *mr,
>>>>>>> uint64_t region_size)
>>>>>>> +{
>>>>>>> +    GuestMemfdManagerClass *klass;
>>>>>>> +
>>>>>>> +    g_assert(gmm);
>>>>>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>>>>>> +
>>>>>>> +    if (klass->realize) {
>>>>>>> +        klass->realize(gmm, mr, region_size);
>>>>>>
>>>>>> Ditch realize() hook and call guest_memfd_manager_realizefn()
>>>>>> directly?
>>>>>> Not clear why these new hooks are needed.
>>>>>
>>>>>>
>>>>>>> +    }
>>>>>>> +}
>>>>>>> +
>>>>>>> +static inline void guest_memfd_manager_unrealize(GuestMemfdManager
>>>>>>> *gmm)
>>>>>>> +{
>>>>>>> +    GuestMemfdManagerClass *klass;
>>>>>>> +
>>>>>>> +    g_assert(gmm);
>>>>>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>>>>>> +
>>>>>>> +    if (klass->unrealize) {
>>>>>>> +        klass->unrealize(gmm);
>>>>>>> +    }
>>>>>>> +}
>>>>>>
>>>>>> guest_memfd_manager_unrealizefn()?
>>>>>
>>>>> Agree. Adding these wrappers seem unnecessary.
>>>>>
>>>>>>
>>>>>>
>>>>>>> +
>>>>>>>     #endif
>>>>>>> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-
>>>>>>> manager.c
>>>>>>> index 6601df5f3f..b6a32f0bfb 100644
>>>>>>> --- a/system/guest-memfd-manager.c
>>>>>>> +++ b/system/guest-memfd-manager.c
>>>>>>> @@ -366,6 +366,31 @@ static int
>>>>>>> guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset,
>>>>>>>         return ret;
>>>>>>>     }
>>>>>>>     +static void guest_memfd_manager_realizefn(GuestMemfdManager
>>>>>>> *gmm,
>>>>>>> MemoryRegion *mr,
>>>>>>> +                                          uint64_t region_size)
>>>>>>> +{
>>>>>>> +    uint64_t bitmap_size;
>>>>>>> +
>>>>>>> +    gmm->block_size = qemu_real_host_page_size();
>>>>>>> +    bitmap_size = ROUND_UP(region_size, gmm->block_size) / gmm-
>>>>>>>> block_size;
>>>>>>
>>>>>> imho unaligned region_size should be an assert.
>>>>>
>>>>> There's no guarantee the region_size of the MemoryRegion is PAGE_SIZE
>>>>> aligned. So the ROUND_UP() is more appropriate.
>>>>
>>>> It is all about DMA so the smallest you can map is PAGE_SIZE so even if
>>>> you round up here, it is likely going to fail to DMA-map later anyway
>>>> (or not?).
>>>
>>> Checked the handling of VFIO, if the size is less than PAGE_SIZE, it
>>> will just return and won't do DMA-map.
>>>
>>> Here is a different thing. It tries to calculate the bitmap_size. The
>>> bitmap is used to track the private/shared status of the page. So if the
>>> size is less than PAGE_SIZE, we still use the one bit to track this
>>> small-size range.
>>>
>>>>
>>>>
>>>>>>> +
>>>>>>> +    gmm->mr = mr;
>>>>>>> +    gmm->bitmap_size = bitmap_size;
>>>>>>> +    gmm->bitmap = bitmap_new(bitmap_size);
>>>>>>> +
>>>>>>> +    memory_region_set_ram_discard_manager(gmm->mr,
>>>>>>> RAM_DISCARD_MANAGER(gmm));
>>>>>>> +}
>>>>>>
>>>>>> This belongs to 2/7.
>>>>>>
>>>>>>> +
>>>>>>> +static void guest_memfd_manager_unrealizefn(GuestMemfdManager *gmm)
>>>>>>> +{
>>>>>>> +    memory_region_set_ram_discard_manager(gmm->mr, NULL);
>>>>>>> +
>>>>>>> +    g_free(gmm->bitmap);
>>>>>>> +    gmm->bitmap = NULL;
>>>>>>> +    gmm->bitmap_size = 0;
>>>>>>> +    gmm->mr = NULL;
>>>>>>
>>>>>> @gmm is being destroyed here, why bother zeroing?
>>>>>
>>>>> OK, will remove it.
>>>>>
>>>>>>
>>>>>>> +}
>>>>>>> +
>>>>>>
>>>>>> This function belongs to 2/7.
>>>>>
>>>>> Will move both realizefn() and unrealizefn().
>>>>
>>>> Yes.
>>>>
>>>>
>>>>>>
>>>>>>>     static void guest_memfd_manager_init(Object *obj)
>>>>>>>     {
>>>>>>>         GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>>>>>> @@ -375,7 +400,6 @@ static void guest_memfd_manager_init(Object
>>>>>>> *obj)
>>>>>>>       static void guest_memfd_manager_finalize(Object *obj)
>>>>>>>     {
>>>>>>> -    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>>>>>>     }
>>>>>>>       static void guest_memfd_manager_class_init(ObjectClass *oc,
>>>>>>> void
>>>>>>> *data)
>>>>>>> @@ -384,6 +408,8 @@ static void
>>>>>>> guest_memfd_manager_class_init(ObjectClass *oc, void *data)
>>>>>>>         RamDiscardManagerClass *rdmc =
>>>>>>> RAM_DISCARD_MANAGER_CLASS(oc);
>>>>>>>           gmmc->state_change = guest_memfd_state_change;
>>>>>>> +    gmmc->realize = guest_memfd_manager_realizefn;
>>>>>>> +    gmmc->unrealize = guest_memfd_manager_unrealizefn;
>>>>>>>           rdmc->get_min_granularity =
>>>>>>> guest_memfd_rdm_get_min_granularity;
>>>>>>>         rdmc->register_listener = guest_memfd_rdm_register_listener;
>>>>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>>>>> index dc1db3a384..532182a6dd 100644
>>>>>>> --- a/system/physmem.c
>>>>>>> +++ b/system/physmem.c
>>>>>>> @@ -53,6 +53,7 @@
>>>>>>>     #include "sysemu/hostmem.h"
>>>>>>>     #include "sysemu/hw_accel.h"
>>>>>>>     #include "sysemu/xen-mapcache.h"
>>>>>>> +#include "sysemu/guest-memfd-manager.h"
>>>>>>>     #include "trace.h"
>>>>>>>       #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
>>>>>>> @@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block,
>>>>>>> Error **errp)
>>>>>>>                 qemu_mutex_unlock_ramlist();
>>>>>>>                 goto out_free;
>>>>>>>             }
>>>>>>> +
>>>>>>> +        GuestMemfdManager *gmm =
>>>>>>> GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
>>>>>>> +        guest_memfd_manager_realize(gmm, new_block->mr, new_block-
>>>>>>>> mr->size);
>>>>>>
>>>>>> Wow. Quite invasive.
>>>>>
>>>>> Yeah... It creates a manager object no matter whether the user
>>>>> wants to
>>>>> us    e shared passthru or not. We assume some fields like private/
>>>>> shared
>>>>> bitmap may also be helpful in other scenario for future usage, and
>>>>> if no
>>>>> passthru device, the listener would just return, so it is acceptable.
>>>>
>>>> Explain these other scenarios in the commit log please as otherwise
>>>> making this an interface of HostMemoryBackendMemfd looks way cleaner.
>>>> Thanks,
>>>
>>> Thanks for the suggestion. Until now, I think making this an interface
>>> of HostMemoryBackend is cleaner. The potential future usage for
>>> non-HostMemoryBackend guest_memfd-backed memory region I can think of is
>>> the the TEE I/O for iommufd P2P support? when it tries to initialize RAM
>>> device memory region with the attribute of shared/private. But I think
>>> it would be a long term story and we are not sure what it will be like
>>> in future.
>>
>> As raised in #2, I'm don't think this belongs into HostMemoryBackend.
>> It kind-of belongs to the RAMBlock, but we could have another object
>> (similar to virtio-mem currently managing a single HostMemoryBackend-
>> >RAMBlock) that takes care of that for multiple memory backends.
> 
> The vBIOS thingy confused me and then I confused others :) There are 2
> things:
> 1) an interface or new subclass of HostMemoryBackendClass which we need
> to advertise and implement ability to discard pages;
> 2) RamDiscardManagerClass which is MR/Ramblock and does not really
> belong to HostMemoryBackend (as it is in what was posted ages ago).
> 
> I suggest Chenyi post a new version using the current approach with the
> comments and commitlogs fixed. Makes sense? Thanks,

Sure, thanks Alexey! BTW, I'm going to have a vacation. Will continue to
work on it after I come back :)

> 
> 


