Return-Path: <kvm+bounces-70870-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WM9HBFGtjGl/sAAAu9opvQ
	(envelope-from <kvm+bounces-70870-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:24:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F47126148
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F2C5301F9A4
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC381E9B3F;
	Wed, 11 Feb 2026 16:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gIKedHio"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB3520299B;
	Wed, 11 Feb 2026 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770827074; cv=fail; b=WIrg4WwC+Hla+OQI/QlotomTHkB4emHdzvVTRehw702KlVDDoVrtP4wu9rr00r03IHfKzJLIvqiZ6UlAHgjk2sJdGNSigT/63APqkZN0tcCqElNwNydleCzGntqr4woNI2MSIeJSOxyuW4Bs8VpppgNvW9u/y2e5HsaWpPNuf7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770827074; c=relaxed/simple;
	bh=3N6ONzFKmf8ndJe5fZ/iXyScJelX8ID948LGVTsZTHs=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=nln5OX0WOTSpS/WH3kg+A5LL4HOLUPMzKClnDRxtd4QG+yCMT37IiD3cXUMgYKHdcXvfsxNs+C3js9vtecV4xe7W7CCW2cVcorDRutAu5xyrN+Bx2ox73vwSssyR24HpeB1y4AQ1RNiBRsfmBqeU6cxrlJV2LrrG47oJ2mdYTRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gIKedHio; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770827073; x=1802363073;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=3N6ONzFKmf8ndJe5fZ/iXyScJelX8ID948LGVTsZTHs=;
  b=gIKedHiomnykcJU8h4k+wq6dAidnfjemvHIRvIdOVQrFgOQMDuqaXs6X
   hEmZhHSD5BPpg8DvAHKjI2bZleCY3iHdzfHzkuz7/BjXGhyVI7mLoSrGv
   o269Wp0iZ2DlFjkfyCsmtLpEHqzZ4ZcX0x1ZgCAmcxeNnvfH1e2+jJwnn
   4TvZeUpIn7cumisHw1Md6wvTibNwmk3EdUZyGWdz2zxK3db4rNAlJGHbB
   460bRokLOw1clo1cgPvJEgk+EfwVbv4wFQ5Wd6i60dzIrIV2rquTeP7tE
   tkuYvC4j8y+aS4w3vOWfHZKFGWvDXRpCMy5sff/7CEdi7Lr/ew7TAXOzf
   w==;
X-CSE-ConnectionGUID: lhkmDTpRQNi/MtRZVObwNw==
X-CSE-MsgGUID: bywo3RCPSL2Ai+6yLaN/Fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="89569546"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="89569546"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 08:24:32 -0800
X-CSE-ConnectionGUID: eGtTtEkwREySjtkEkpk85Q==
X-CSE-MsgGUID: cBsKDttERPSX8ZAljCJAiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="242048654"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 08:24:32 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 08:24:32 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 08:24:32 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.16) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 08:24:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=stCLCjLUpDqBXEAA9ocwR1Wmj3dWe+xAmDSPWhSujBSDC+Hb92TnvFD1eTsRMkpW0b852SUXYEPUpmLlzQC/eDIKUaX5ddEESeRIiowchxU8lPw6dOiwcEFfRBJtTrHdcMkuV5FXh+YoVoxz5t9OSRoYrROwYHC0HRf4AoWP59T7HRPZ+Syo4qJ5mmqpCc7j4A4w/NxPXfxRWR4tov2tiRdFGQgs9sN6l82s/Q2C/XdjLXheRPF1tXslRWhkc3vnq9IHnPgMWqcQSPo5BCkGS+/PCfkPHKBbvpWzjqg1GZJWoDy02urwGMeIaJ99qCW73kn0lMRNbPduzcPGAjg39w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QObyFmkh8BLi11SyWC1opxqfnVOX3Ns1AHw7M9GAS2Q=;
 b=uNO2cBsuI11yK2HKjqDBpBlTMTLKc7agOoE/tKUUtLFrZ8MgxHukp4qArYdh0eewnW1+sPmbQItv+QqZ++a+/MqKjUNMf7U2GrGPS5p+M7rT4Xski+hLAN2XtZZ9uiNgVXpbHOl5A0bFa75duReNE8/ayyuVlJGXSA0Ge9gYLKDRKH+3aa6YvFPX6OHhy8CfZiqEPCYSFh+ONl4JrbBrV9Qe2vyEPL/DH8X58dbMqxaKXG62C9ezFAEtS9pHoQP6rQHZozoEdF2ul7pufyXP9N/p53btp5jbB1ofpSc4yhD+igsD0iBgPKaKH/9bFDhW5yQwkZqpdv/m5841sdfUSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 16:24:28 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 16:24:28 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 11 Feb 2026 08:24:27 -0800
To: Dave Hansen <dave.hansen@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	<linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>
CC: <chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Message-ID: <698cad3b86a78_8c3210066@dwillia2-mobl4.notmuch>
In-Reply-To: <96d66314-a0f8-4c63-8f0d-1d392882e007@intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-7-yilun.xu@linux.intel.com>
 <96d66314-a0f8-4c63-8f0d-1d392882e007@intel.com>
Subject: Re: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for new
 TDX Module objects
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0116.namprd05.prod.outlook.com
 (2603:10b6:a03:334::31) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ0PR11MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: e21218d0-6e33-4463-c547-08de698a078d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZWVSY3ZwTDU1TnJJM2pyQ2tDSFRjMXRRVWlYZnNlSVZHM2k0WkVsRk00VU9l?=
 =?utf-8?B?VktDM252bjJEbGhIM254bGRFNi9lTmYraHN0NDkvaFB2RXF3SDVZQkhCSWkv?=
 =?utf-8?B?S3pDem9xNzdMdGtsdWdkQkNvbXU1emkvYlVJNEE2L1NES0VORS9NYnpFa2ta?=
 =?utf-8?B?b2dBTG50eWp6bWx6aXN4cWduY1NkZGE5QnJHY2djemtFUlVKNnRKcURDMExQ?=
 =?utf-8?B?UE1DZUl2eEVmeHVUb3YvUGx6ck5pa3dWZURaRG9zQzdUQXR3UUdmNWdUa3oy?=
 =?utf-8?B?UUpCRVBWcHBPNWxEZzNUM2FvNjRibk90RThDd2dnMStpb3JOVDdsbFRNL1ls?=
 =?utf-8?B?ajhsN2ZuWXJ4alQweU14N0FsNWpaRThsTGI3TnVQaHVQRkcwRGYrMURWcGx4?=
 =?utf-8?B?MGh1eW44WitoeXI1L3J3ZldhSGpRUG1iWUpJS1B3WGRHdVUrd1NESVlWZG1u?=
 =?utf-8?B?QTE4QU9NS1NJMUJnLzRWWUZFbkRVU2JPcnhGTldPRytROHVJSk5OZjd3d3RJ?=
 =?utf-8?B?bEJjZUFsKzdrUHpFdXg4cXhjMmdmME0xQXc5S2dXR1cxL29VaUhDdVg1OXNS?=
 =?utf-8?B?WEs0Z2dPRlhDKzZMUmY1VzlkMjE3eUdHMXg5Nm1GOE4wYXprZm5OZ0VvTEpu?=
 =?utf-8?B?Y3RERUNxTDZsYUNjcHFXVVJ3emtJRkcwZ3c3MWJnVGhaN1F1ZnQrTjNkaXhK?=
 =?utf-8?B?NG5WaWg2SnZJbmYvRFQrODRCTkprM2dRazYya2xGajYxWmdoSGpiY2d1OTBt?=
 =?utf-8?B?ZVdXR3VDaFZiem1DYVVMZWZteS8yYUpJZ0hrS3U3a29QN0pIei82M053ZnRl?=
 =?utf-8?B?eGlmTEFJOVduRzRiaUY0eGRGMzRrUFpCbTZ2U3lZb2tIZE01TUtOanRWU1do?=
 =?utf-8?B?a3dDY1RDOElwWnBSYnJlMXhpUkpmOUhzdmtPM2pYNUx1bVpWcFcvUVo5NVZh?=
 =?utf-8?B?ZVNacm55WlhIbU0xU0ZaWFJRNTdJUXVJcmV0c0RGTEROTjRFWERNQjlUemFz?=
 =?utf-8?B?SVc1c3hqREZta2xDNG1wVnlYNjJlYnl4alREaGRxK25KWFRMa3NBWUh6TFp2?=
 =?utf-8?B?M3NqYytNTFRRNjl6NEhTOHFLTGxBU2loRllVVFR0SHd4RUFFVnlRR3RDbTRG?=
 =?utf-8?B?aHE5U2hLOGVNLy92aTl5ejh2WTBLcE9rMDZCSHplVDdIY1lYT3AyRmtTMGJO?=
 =?utf-8?B?WkRkbkFIVk1QTkI2ckIxWi9OWCtwS0RYWThwVk8rZEJXOC8vUUhBWWZmVXVI?=
 =?utf-8?B?YjJwb1FPN0tWSUEwSWc2MmRObk1zaVNMMkpnZjVta2hpK1lQeFVaYUJFRTZk?=
 =?utf-8?B?RCtPTDQ4RnN4WkgvOWI1TGZzelRqR3VhS0FnTU1aTUphMjJJZ05LVUVCTmQ0?=
 =?utf-8?B?V2ZRZFFhVTRDVDFoUFNxbGVTanh1K2ZITUVXTjJoamFVOENiS1BadklmdWdB?=
 =?utf-8?B?bDZDNW9PTkptL1hGMDF0Y2hFM2YzZ0daU01pMXBWN1luelh1cDRxOWFJZjA1?=
 =?utf-8?B?aFNMSktLcXdJWGhXaEhDTGt5VW1QZkVjNWV6V3l6ZUlPb2RZQlFDNGs0SjY3?=
 =?utf-8?B?ZE9rdGVNT3NMN0RXamhQZEpRUzlPUVh4UlJQMXJRTUpDVFA2aVM0OGxKWmZr?=
 =?utf-8?B?TXFtcUtEdUprRXQ0WStLQ3p0cEo1VEtXZDMzaUZVbi9wWHVLU0dXVm1tSnM1?=
 =?utf-8?B?Wm1rRCtvRko3RWhnalFPUm1xU2tLalRTVm8wajVXT1RFRU02Lzhsc2VId2Nm?=
 =?utf-8?B?dTZIekdGZlpqSklEYzlUVWJPYURISVJyNVlaZGgyc2kvdTBPU3IzMGRsUDJU?=
 =?utf-8?B?U2FPT3lrNUsxNHFuRDIvTTExc28ySTExYlhPRkhBbW5wUmxwZ2p4dmpvdHEv?=
 =?utf-8?B?OGJTYWdJM04rVnordmh5YVZrOWtzSFZUamxvaHpVOWl0ZnRaQnRkNmpKRXdF?=
 =?utf-8?B?WTlhcUJQTG1rLzRkWEhzNFQ3Y3EyTDI5elRwVWlZSERWaWRKNkxoSHJrNDJ1?=
 =?utf-8?B?R1lQNnRzUExqN2szU0ljK2liOGE3ekF2MmtsTnJWWVhwNGVwQXU5WlJ4YVdq?=
 =?utf-8?B?WVVMTW4vV0M3VHJCT2NtNjJWVkVuemVjSkV6RjdOSkg0empMMFZVUUt5dm9Q?=
 =?utf-8?Q?fuDA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2RTYS8rcVR1TmJVTkVGcVRMVmRrTkNla1Y4eEpYcEZsS01iZDBRdnArQWRW?=
 =?utf-8?B?cDRZbnJmLzBLcjUxTzdMdjJLU2FjZDh6Y1JhSUFhSGFtR3hWTmVIdVFKL0VC?=
 =?utf-8?B?eFZlU1dDSVZUN1dXMTcyWkJyK3V5Mjcwc3NqVWZuS0phQlM5UjZGQllGVnV6?=
 =?utf-8?B?OU1DMy9nSTJCd2dVUHJGOXB5SmVHMVBqalkyaU8zaHFpcnRQc0tjM0Iyd0U3?=
 =?utf-8?B?TGRNbkF5U2hzVW5OY0Rzb1EyVXdCV2F3WnVJZkY3OG1yT0lYZUpQVmlnaytW?=
 =?utf-8?B?L0J1TVVkRy8rRHdxaFBHOWRhdWVxR1NjbTNZOVdnU241cXIwMjM4Ri9OZWY0?=
 =?utf-8?B?UE02YkpCSWpLMVRoYjNnbTJNTTN0MTZWeTJxTlJSaExaYlNYUHpBbHdNNzhu?=
 =?utf-8?B?Tnk2TXlMdk1zVzlyQTl5M1ZVaU5pR0VvRzhlZEFtci9Fek10Y2hVMmFyVTNT?=
 =?utf-8?B?SDhvNk5wYXRweEVaaFgyUnVhOUNudVYwbDJuMEZXK0dBT2hiVUU1WHcyeVpX?=
 =?utf-8?B?UmdEdWdTUVJsMHpOSTZUVzJjbTUzR2VPK0daYnFEKzkxd1ZqNE5DallQaGRs?=
 =?utf-8?B?MFlMQnVkMjhaRXBEb1JVelNzTWQvbjc4Y3RIV3N4YVU4cTFTampMZDJVYlJs?=
 =?utf-8?B?SC81aHZaNkcwRjhDVjdPUEE4NGdJNTFRdHQzVjBSeHlvSU56VUdCbGhLbnFm?=
 =?utf-8?B?WDI5bHRWVlpRVnVvbTh4TUFnMUpvdmh1WVM3M1d5THhsRTg2cXNENDBUQVVP?=
 =?utf-8?B?bFRpcjdlU0YvV25WRTVNRS9LVjl0Nmc0UGErQVpsTUlBTkdHbUgvTFVKeU8r?=
 =?utf-8?B?a3NUNEMyeXcvdHJsbTVLZ0VNSkxNV05SRnNmU1ZaL3JzQVViQ2ZvVmh6N3hs?=
 =?utf-8?B?MDlUMjFWSkh0Z2I2SkVGanNYUjh6N3RXQUVMVWJHNGRiYkJ0S05sSi94OC9k?=
 =?utf-8?B?NEUyWFltaEFXNE9RNFY1VVp0NG1JRVpDM3JIYzZNU3U4TXFKZmphWExYT05D?=
 =?utf-8?B?TVJKWGF6ZDlVYksvN3BwOHRaL3R1Vys4cExnblprbHErOWdxSk9TSEd5Uzln?=
 =?utf-8?B?K01VR0tzOFlFQUVhTnJKdi9VQVpybU00cjJBRlZtUUUrZ0tDZmVRUFhzSXJT?=
 =?utf-8?B?czRhRG5vMnVnUHo4aWlabU5NN1pwR2dYT01LQWFOMnF2QjUzT2E0dnROaVV4?=
 =?utf-8?B?VmYvQkJrQUVmZG1LN0xXSGMwc2FkblAyNzlOektMZDVnalVmYk1yOEI3TEJZ?=
 =?utf-8?B?QVg1NVlWc1Y3K1l0ZDR6SUU0eXZMM1JSQzBDckZ5cVk3Vy9Lb0Q3TVltTjRB?=
 =?utf-8?B?S1dtK2FQeUF2aHltV0Ywdk5CN0hTaldDTks5VkRpQWtOUDhyWko2QmpCWUxP?=
 =?utf-8?B?RGFjVk5HbTVzS3c1ZXNHK1d3eksxVVI5T3BSdHV2VkVoVTVRbHExQTRhMHJp?=
 =?utf-8?B?aUw1R1dEdENjVXB6T1c5dUE0QmtjOXZEQVdsQlk2ZGFvdHBhN2tZaS9tYXBJ?=
 =?utf-8?B?SVhOS0VxVS92MFgwTkxXY0NoTEM5eEphbTZ5bDV0VTdwcFhFMFp4ZzRyTDg2?=
 =?utf-8?B?ZUtXVFhiTDVKZmtHa2NTbVpSaFprSkErbWJEMFRFNlZSaXpCTVJTZytiejdW?=
 =?utf-8?B?MHNkM3lYdUpyR3Z3OVlrbjRKWUZKbFIzQXZVcTJwKys3ZVJMeWJTclJJdVRJ?=
 =?utf-8?B?KytCMTZTT2FNV2ZGRGpuRCt2dldBSkY0ak5Za295OTRpTUk0V3A2aXdvdTg4?=
 =?utf-8?B?WGpyZjJKQmZtdFBvV3VwNnJhZTVScElwVVNmdTNwMlFhTTcxYTZkYTd4L1Np?=
 =?utf-8?B?dDcvZHEwUGFCWHM3ZXFYTGtIV3dIOWU3QXdQRFJnNFlZZkVVTStPMDhMZlRM?=
 =?utf-8?B?ZGhIWlhZd3B4SWdLU2g0bFNiYzgvWWJRWklvK2lJSm5nWFZsVkZCTTFENDZQ?=
 =?utf-8?B?TWlFekRtbDRSNW9xRFREaEk4RVNCeklMbENmSU9SRTIxT2x4NmUvUEsrcmNy?=
 =?utf-8?B?ditTa2RVTUZXQ1pMMVBNWnRSNHptcVUvZ3MyRk0xb0ZTcHlKdWN4dXpuOGNa?=
 =?utf-8?B?RHRXc25sdVNwVW1pdnBlMGNXSXcyYUlZZFY1OHNPZW5OdmNZODZUQ1JTalc3?=
 =?utf-8?B?NHBkZms2cFppUE1ldk9GRHNaZUtmNDhVVjhwQmpXb1U3bTh1THVzcTlIaEpY?=
 =?utf-8?B?QktDVm5FMEd6eHd4TkNjODBXc0NGRGpLZ0RKbDNNYXZiV0NmbU0yTndYbURR?=
 =?utf-8?B?YkFkZ3VPdEg5YlAxRHJmM0RnRFZCRVVSZTRHYkU0b3BFTXcwN0kvei9jMy94?=
 =?utf-8?B?bGpzWit0SU5UOXZuajNRZllVWGZNVjlkM0ZYRmlabVpmVHloQytmcVdVRGcw?=
 =?utf-8?Q?k6MguFy7scqyNz8w=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e21218d0-6e33-4463-c547-08de698a078d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 16:24:28.8533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtrE8Ci7WKjsAhwWYlXRBABGijuAaD1DQALkNd8oqzxO/JrC/ROJUrCzXut/dXaX8wdsUkhVWjdp4Zs5+rpNHShPTV0kH/8KypXrFuf50Kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6695
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NO_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dwillia2-mobl4.notmuch:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70870-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 95F47126148
X-Rspamd-Action: no action

Dave Hansen wrote:
> On 11/16/25 18:22, Xu Yilun wrote:
> > +	struct page *root __free(__free_page) = alloc_page(GFP_KERNEL |
> > +							   __GFP_ZERO);
> > +	if (!root)
> > +		return NULL;
> 
> Why don't you just kcalloc() this like the rest of them?
> 
> Then you won't need "mm: Add __free() support for __free_page()" either,
> right?

I saw a preview of what this comment does to the implementation and I am
not sure it is an improvement to avoid the __free() support for
alloc_page().

The seamcall prototype is:

u64 tdh_ide_stream_km(u64 spdm_id, u64 stream_id, u64 operation,
                      struct page *spdm_rsp, struct page *spdm_req,
                      u64 *spdm_req_len);

The interdiff of the effect of this review feedback is:

    @@ drivers/virt/coco/tdx-host/tdx-host.c: static void tdx_spdm_session_teardown(str
     +
     +  do {
     +          r = tdh_ide_stream_km(tlink->spdm_id, tlink->stream_id, op,
    -+                                tlink->in_msg, tlink->out_msg,
    ++                                virt_to_page(tlink->in_msg),
    ++                                virt_to_page(tlink->out_msg),
     +                                &out_msg_sz);
     +          ret = tdx_link_event_handler(tlink, r, out_msg_sz);
     +  } while (ret == -EAGAIN);

This is unfortunate because tdh_ide_stream_km() will just turn around
and call page_to_phys() on those arguments. It forfeits type safety and
inflicts the mental hurdle of "->in_msg and ->out_msg are direct-mapped
page-aligned virtual addresses, right, right!?".

So alloc_page() + __free_page() is more suitable than kzalloc(PAGE_SIZE,
...) as long as the seamcall requires 'struct page *' arguments. Another
path is the seamcall semantic is updated to handle virt_to_phys()
without alignment concerns, but it is a bit late to make that change. I
considered the concept of passing a "va page frame number" around, but
'struct page *' *is* the idiomatic expression for that concept.

