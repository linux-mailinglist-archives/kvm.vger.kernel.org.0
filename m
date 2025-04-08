Return-Path: <kvm+bounces-42876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AAF6A7F1B3
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 02:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98E863AD94F
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 00:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817AF25EFBF;
	Tue,  8 Apr 2025 00:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ac01WVk1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB5C2F44
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 00:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744073435; cv=fail; b=FQwy2agVNi53bUqTX1+VqbgLbsNA9dFQZMpMntT95bWOzmbB/+763qR7sV9prxP+B8SE9ijmQTvyg8l6g1sUpuji8nD2bOKTlWNaPT4kYwKK8LgZ6QGwpAHotNp09jC4qpLMZbL1gZTvDZhrEZ5Mch1ATx4tg3oS81OpoNw/42o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744073435; c=relaxed/simple;
	bh=eNDiCtNnqssTWdOIAaZi/dkasV1mKowDQignZcZVngk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lRnMBaUljHxS36iSIl5+Y9CW46ftTT0TcBycYDfDhadS52Q8zLMgbN7Yed1z5uTMC7BJKQ0RDIDs8/BSlJt1ItUto1RLp3ht1ZskZhMGP0/zBDOwarHdC0K/Q5yuDRBIXIQjmlx948yqbetAIIMuVSAVjWmWiKsX7pTGu6dFVTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ac01WVk1; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744073433; x=1775609433;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eNDiCtNnqssTWdOIAaZi/dkasV1mKowDQignZcZVngk=;
  b=Ac01WVk1AtMsGHRK6wEkok6iNZeNqcipc5d4JHCSmwF1nsaJEDfwRzzx
   MvQdCZq6XAWmjmexCBad5V3uZKI/TXIQRlW2oZ67pTUu2QG+PcH59oisW
   xODfNEzLOp0Uysq/lZGRoSoMGHRo2dasoNoBHKfYVWaYGv2+dWTlg4S2Z
   5unKYVM9LjbTkCUzEvFaNsu2PUpqDTmW/yyqdHhDrIVezy9ndJciq5UyS
   0Q6rcs8FtqxoWh3D1Tttjxc1DO9nll/1i4Fb2vXusx7ntg9S2+6TrPum5
   F/PigvjQ60K5uV0ELGOTFUMp+fl4aelpTvPXhzm4zYYfibP0tA/XhArAt
   g==;
X-CSE-ConnectionGUID: EahJbB6fRymdNeMlTiAD/g==
X-CSE-MsgGUID: VISDlwJ1QsuMNZBwNAzmaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="45372987"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="45372987"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 17:50:33 -0700
X-CSE-ConnectionGUID: RTmNJCWDQGmeLKqqFMBdlQ==
X-CSE-MsgGUID: /zXYHovsQ0umukfIAKKvfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="127980552"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 17:50:32 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 7 Apr 2025 17:50:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 7 Apr 2025 17:50:31 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 7 Apr 2025 17:50:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPkv/g/GpgONPpT3ENW+Oj6lW+oX+bfY1SPPqwxHzwGtVs9WWkA1QIfFbfvyMgn/MDQQBq3qs1mb2MovIgDJOjPhlIHdtnyDWUE/2+cm7tSbWxr60WWUIbvUAu9xGRql0JNmP61+xO4n4zBs3fH7n2e0RY9lBUxlb+x9CxK9fZfLCLEU9HQkezzBg7hY5c3aNgSdZZPX8uEgeOdyLV7m6C2eu4he4Qm1S1NFcBKMgAg37jYT/9XdVNhPFL27X5vBVlLcuZ+8qInv1gJrwo6PubzoWxMwcJDK/HiK1G5CudGQZGQKz5eVl1n1rcAs9peLbOgOHByF1s+SZyjuzi2HuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+2wbi1dJTdjt+MZ7VMxgIt1ULA2UR1eCMNNYWBPeJk=;
 b=rlcrOMK7RmSDYNUswdDVDGjadr9MHWU+iVIEJxdbmTLRe/JslCBcB6KxKuBBaMbjhEldaUR9v4Fhb0qnwW6Y6gw0OrmUijOxS+cY6v4gMpZYA3wE2foPBalKC/RsTvjsyWzt6BlkH7REZtsBpE9td6pxlM1XaxXLv5Aa2+OgoHKV9CxiXBujyosEEnFYGqAuusuqNor1g8ColdZxiiGdrWcYjTmq4puAYk5xGHuZkWmdNzkXZdR2jB245neVev9V/4OFvvt/mHiOmNf7JIHjvtzoBkHlAGlc0A15E0aR0Yygbi351/Zo60E994guusVPj8FV4ndhW6cHrTIwCZd6CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SA3PR11MB7625.namprd11.prod.outlook.com (2603:10b6:806:305::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.29; Tue, 8 Apr
 2025 00:50:29 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8606.033; Tue, 8 Apr 2025
 00:50:29 +0000
Message-ID: <a83613dc-a668-4e23-ba91-9cfaa94520ea@intel.com>
Date: Tue, 8 Apr 2025 08:50:20 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/13] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>, "Gupta
 Pankaj" <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-3-chenyi.qiang@intel.com>
 <81a45a5e-f0a6-4f82-867d-57d5bda3c73d@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <81a45a5e-f0a6-4f82-867d-57d5bda3c73d@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0132.apcprd02.prod.outlook.com
 (2603:1096:4:188::15) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SA3PR11MB7625:EE_
X-MS-Office365-Filtering-Correlation-Id: 843e11c2-a920-46c9-617c-08dd76375ba2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SmRlWURXS3ZSYVRGdkd6eEoreDZLaVVVSzNsQ3ZNdEI2NHpUbXdjMEtWWDBY?=
 =?utf-8?B?Y3A3RXJ2dUVhbkxMVjkyWStVNW4vOXRxYnkwaDdsZ29hUzV2ZGRpc3p3RnNz?=
 =?utf-8?B?MWw3ekZ0SDBXUDhsRlkyR1QvemNXV0FKUHc5M1pKTjl1OFRWRzVVa0tBK2E3?=
 =?utf-8?B?VWp4aGJyL1FxL2tCdWs2Z0pMbEJrR1FKSjdZOEF3dkJmOHJEZmdOVU9xVEVv?=
 =?utf-8?B?eXQ0OTRjTk5MMEhEbTFPdGhqNkNBcDI1YWZaQWpFU3dqTnE2ZEMwRElKZ2VK?=
 =?utf-8?B?NEw1Q0lSblQxNmVhREhmUXFxcFM1Y1BSNE9NYUIyQTMzaHl2Umdha2dPL3Iv?=
 =?utf-8?B?bStVakZ5VGo5K3Vxbm8raFJoNXIvUVlCc3luWnRVODdiSVBMSS9GMnBsbk9B?=
 =?utf-8?B?RjB1Tk92WTVlSDRRd0M4VzVkN21jb2FGNVJVdUFaeDY5eGV5UGFIVkl4Wkd2?=
 =?utf-8?B?b0xFdS9RZFdabWwzT1JnNDNESG41aG04azFXK1JwNHdtRWVDelJjcHpRSnc2?=
 =?utf-8?B?dlhvLzZ1dk84dGFEYVZNWFB5T1phSXdBRWg4SlJsRklDcExLbW9vdWlubkNz?=
 =?utf-8?B?L0hjZTdPb3RXNnJqcllOQ3ZvbU1CVGdTd1pXU2lSSjRBYWVzY0wrSmJ5NFlK?=
 =?utf-8?B?VkVraG93UHp5cGp5UHhyYmVlRjhWYTBGUENmK1NXbnY1dU1oSVhjUW1JOWtz?=
 =?utf-8?B?UDl3djZvaFY5TFhwRCtWRCs3Y0JGcndZMVU5c3RFUGZnU3dVTzJ0Yys2R2hJ?=
 =?utf-8?B?YW5KSWt0L1F2eGppZElLeDhWcXZjcG5OZytqN0tzZjhwVTBBVExGRG50QzZy?=
 =?utf-8?B?eWdaenJHck1qQzhiL1JTQzlOcXk2TzFsTGJTU1oxL2Vta1BHbGE1RENTQmdk?=
 =?utf-8?B?VEsyUkNVTDdWT0FJZEQ0MlZqR1ZWKzZWdFhhOUllNEtlWWV5WG9YYjExcE1W?=
 =?utf-8?B?TWY2ekNMampCTmgzbGxoL1BIbEJHMWNsUEs0VXcxdmVFTkdyMlVRVDQrQmJ1?=
 =?utf-8?B?bWlkeFJtNGliR3BYcVhtQkVGOU5WeGNlbyswZmwyZzF5MGFoK0xGcURPNWE3?=
 =?utf-8?B?NWJQeU1uUkVYN1BDN1ZEci9Ea1ZOQ1hRYm1lWHlmd1hqVDhTbWxUVGNKbzd1?=
 =?utf-8?B?bDZ1MGdTNGFJUXhKNUo4ZzI3VUxJcThCNXJ6R3BzSGZwaHFJMmZKNWVHdlNq?=
 =?utf-8?B?T014Y3Vmakl3WnpqKzQ1RmhINkVMRWh0QXNWSXVDc3k4YlZFcXAyTjZEZjhs?=
 =?utf-8?B?Y2tJZi9obWlxRUJWS2tLejUzSXB6MHBMRnZCUmlaaUhPRXA0N0NxaDd4eTFQ?=
 =?utf-8?B?VUJaMHlYd1dHMnlrN0NsV2hvZ2x5RnEvcGZERUljWHNhVThRQnVlN20vNXlI?=
 =?utf-8?B?ODM1SUJpMytZVmlTcyt3c1JndFlGY1gzdHBLSTFQTklKcThlV2Zncm0veUpF?=
 =?utf-8?B?Q2Vtc2wxdWZWMHh5WGxiQ3QrRWc4THlCQTNrREo2VlJOSXdmMG0vQ05qVlNj?=
 =?utf-8?B?ZWp5TFFVVkFwN3F1a1Q0eTJmNi84R1lNYjBEbWdtNXZWNzVIdk9TWnY3S3Fm?=
 =?utf-8?B?T3dBa2V5ZUdnaDUzSVZmK2c5c0U4QlVXV2d2RFpGbDF0V3dCbGpMVVdUcy9Y?=
 =?utf-8?B?U3hqc0NiSE95Q3hnbXRNdjVCSUp1bmRFMjd1MGp0ejBtN1VXZmNiemtwcHUr?=
 =?utf-8?B?ZkF0VEFKamdaOWtVS0xoT2dTS09vZVJMNWJXK1JqcUtVcGdnL0lYSUlCdFp1?=
 =?utf-8?B?NG9ES1ZDcXBkRTU0ODdmVlZ4QkRKcUgrOHh6c00yNHl2LzRESUJSWlU1T2hE?=
 =?utf-8?B?eFlSMlZheDljTlEwU2V3TGVOakY1bmFEaEJpbW13c1piR0JnWmxXZlh6NkZw?=
 =?utf-8?B?TTh2akZYeVFCSEJzRndHZjVWN0FBSVlaenM5M0FnZThCYXlKZVVKU3ZzNGVX?=
 =?utf-8?Q?pG5rtKmLA9Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlF3eWpOVzYyTlpsVG41Snd5TmJmU1BkTkNkU2VvVGZ2M0ZpZVVTaWdCcW55?=
 =?utf-8?B?Z0NWRnRmRE5sYzN4ZmU4TEo4eHRTaG5VRW15ZGJXRHpCYkU4TjZReWRPRHBB?=
 =?utf-8?B?ZDFXUGFLU0dnanNDSFJHTFNwczdmVnNlMmtvS2ptTExUTFZ4UnAwV2VDakh3?=
 =?utf-8?B?aU4rQUJUWGN6OG9WSjNxNUVpQmxFWkNoL29UVVdHWGtXVWlITktjR0t5Rlhv?=
 =?utf-8?B?a0ZYaEFLWE5Tc3JuL3dpdUJCVVhOd3ZFZXhkaW1GRCtyNHVVWVdyQTRKTEhp?=
 =?utf-8?B?d0pFY0RtZjJGS1psdEo0Nmhiajg2Qkh4UndtOGQwemlLY09iUWlyeVNNdmIv?=
 =?utf-8?B?RmJNTjFXcjExWkVZYkN2ZnZibk5hQXUxam9UaVZJV2V4bm9tRzBUZ0tpNlZW?=
 =?utf-8?B?SjQ0WkMxWHhRRHlGM21lNEwzejlZSHRtNHk5d3QwZFBKRTNRbXRXVkFBSFBI?=
 =?utf-8?B?QjhrQkxHeU9HWDVMVjM0d216T0Zzbk5laFN3TElQWlREem5UbmhiUlhSRUg5?=
 =?utf-8?B?Um1HbjU0azR5ajJsbDhXd3ZPSWM4WjRzazR2enlLZmllL1ZUS3lIZkRYRFpV?=
 =?utf-8?B?RVZIKzNnaDRhbUg4TytmalJ3Q2RSSWdPTGxUemJEZ3VuY1R6OGNvT1lQQjJ1?=
 =?utf-8?B?eGc0MnpXeGVDMWp3aVZpSndmWWMwTHN1K3ltcHVWTGptTzdENnU1SnZCK01B?=
 =?utf-8?B?dVM2bnZRZ2lkM1BWcXlRRmNTdE1TSTc1ZWgyTlozZXFZRStJUnVpcVBxZ0Y0?=
 =?utf-8?B?OVhZU2R6Wnl5NnpkWlpnOEhUVGZ1YjRzeHpXWUlFcDMwK1BudURRTGsyaWx5?=
 =?utf-8?B?L1hiSVhrOGE1UVJQQ2dKd3kyeFlRSVZwNFNBejAralQ2bkFhZVpyYUljaVhZ?=
 =?utf-8?B?TGh0TmNzV2djenZscjBDZnkzTVFka2RUQ05vSThxcENFTkw3am14Nkowd2Zs?=
 =?utf-8?B?ckVPNm50Z2FjQ1VMKzFKUlM2dElXMGx6SXVvQTUwQjdoSEdUbU81elA2Ynp4?=
 =?utf-8?B?NWx3R3Z0cVhyTjJCVlhBcDJVamR4aFo2TkUwbXk4WkVrRzFxMVplaXhvdXVv?=
 =?utf-8?B?V1M1dHNmaDVkNTUvanhlcXpIcGhlcUQycDhwaHhyb3oyMEF4VmJEbVNXSHZH?=
 =?utf-8?B?MjduNWxFc2ZHN0NEbG9MdFZhbzRoZWJxSzF4Uy80L0NqUXVVcjh3VkQrU3dY?=
 =?utf-8?B?L3NsUjVnbldCOUFPZDloZGpxS3g4OW1WSmM5SGt6WWVzWGhYUDhlcWxNZ1BL?=
 =?utf-8?B?QnBWQXJXakdyV3NWTTk1eW9XRkNyOS9KNU5vQS9WMk52RjRyNmNBK3lncEYy?=
 =?utf-8?B?eWY2T2MwWFVKRitJOWxJSzdlSlVBc040V0pHWmtzZzhEZlJvZkNlVU9udTRB?=
 =?utf-8?B?bDhxMWx5QytYZjR2cEFndTZVS3JBSi91Y25GT3htOUFwdWxZZXlWbjNFWTVl?=
 =?utf-8?B?N3haNDBOckdoWkFOanc5TWtWMlhoanA3UDQ5Yk9OV0ZTeHg2K1ZPNFB4eHo3?=
 =?utf-8?B?Q3Vad1BFYjR3Y2JDZVhGS3pVRnNjR3hjSnliYzNYeFZMTzk3SE0zTTFBNyt3?=
 =?utf-8?B?blRuak1TR1Fkck1HMzNXalJONE1oT0E5NEhTWCs3Y09jZVg3R3c4K1FlclFL?=
 =?utf-8?B?SzNuc3VQaFl4Z2ltSzZNY2NMTHp3UG9kTjhsczlKaFJHaHN3SFZFRmFLZ1Nx?=
 =?utf-8?B?VHNQZVl4Ulp4NlQ5dE5tVVR4MFJTOGxyeEl1Q1h2VVZBMFNyOW5JdWFHMStm?=
 =?utf-8?B?ZUhNb21sbHdCeTZBcWVHK0lTWklyTDVyRjdmTThiSzgycXd0T2tEUFFsVkdJ?=
 =?utf-8?B?aGJUblZYT2I4T2x5emdMR1dSZkVxSTNzeEdCNFNBRUw3WFFuQitVKzd1UlJh?=
 =?utf-8?B?VWF3ZWNoRFRzVVBhUXMwQi9IT0FtRjBacG1aWFhJVjZQTGMxczVUSEFSZ2NV?=
 =?utf-8?B?OSthL1VHeVhYeVBEVTJuaFlETXFvZ3VtZmxVQ1Jxd2dHQ0lFS2ZTanJrWm1H?=
 =?utf-8?B?MVdDOWJGUkpOcGIrUEFPYWlGTktPS09jVzVDZEtzM3d0ZnV6SE4rV3hHZTRV?=
 =?utf-8?B?WUNteVJ3dmZiT1FRZmdJQUdrV0w2TzIyYnZ0UncrNTRaSmpaRmNyZlRhMnNm?=
 =?utf-8?B?LzRRbkM4ZmpMOXBlYWVpN0ZqL3c1SnhpaUMrUG4wUzFoZFlNWjBQczVYTWVF?=
 =?utf-8?B?Ymc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 843e11c2-a920-46c9-617c-08dd76375ba2
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 00:50:29.2378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 41rgfb2L+3TbJk9pDJQDQ1Nsn1SAeVDNsCUnHTMHTczeD7QmgIj6sEsquC73tgPeJJG7pv+/L8fHDvI4RP7W2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7625
X-OriginatorOrg: intel.com



On 4/7/2025 5:53 PM, Xiaoyao Li wrote:
> On 4/7/2025 3:49 PM, Chenyi Qiang wrote:
>> Modify memory_region_set_ram_discard_manager() to return false if a
>> RamDiscardManager is already set in the MemoryRegion. 
> 
> It doesn't return false, but -EBUSY.

Nice catch! Forgot to modify this commit message.

> 
>> The caller must
>> handle this failure, such as having virtio-mem undo its actions and fail
>> the realize() process. Opportunistically move the call earlier to avoid
>> complex error handling.
>>
>> This change is beneficial when introducing a new RamDiscardManager
>> instance besides virtio-mem. After
>> ram_block_coordinated_discard_require(true) unlocks all
>> RamDiscardManager instances, only one instance is allowed to be set for
>> a MemoryRegion at present.
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v4:
>>      - No change.
>>
>> Changes in v3:
>>      - Move set_ram_discard_manager() up to avoid a g_free()
>>      - Clean up set_ram_discard_manager() definition
>>
>> Changes in v2:
>>      - newly added.
>> ---
>>   hw/virtio/virtio-mem.c | 29 ++++++++++++++++-------------
>>   include/exec/memory.h  |  6 +++---
>>   system/memory.c        | 10 +++++++---
>>   3 files changed, 26 insertions(+), 19 deletions(-)
>>
>> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
>> index 21f16e4912..d0d3a0240f 100644
>> --- a/hw/virtio/virtio-mem.c
>> +++ b/hw/virtio/virtio-mem.c
>> @@ -1049,6 +1049,17 @@ static void
>> virtio_mem_device_realize(DeviceState *dev, Error **errp)
>>           return;
>>       }
>>   +    /*
>> +     * Set ourselves as RamDiscardManager before the plug handler
>> maps the
>> +     * memory region and exposes it via an address space.
>> +     */
>> +    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
>> +                                             
>> RAM_DISCARD_MANAGER(vmem))) {
>> +        error_setg(errp, "Failed to set RamDiscardManager");
>> +        ram_block_coordinated_discard_require(false);
>> +        return;
>> +    }
>> +
>>       /*
>>        * We don't know at this point whether shared RAM is migrated using
>>        * QEMU or migrated using the file content. "x-ignore-shared"
>> will be
>> @@ -1124,13 +1135,6 @@ static void
>> virtio_mem_device_realize(DeviceState *dev, Error **errp)
>>       vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
>>       vmem->system_reset->vmem = vmem;
>>       qemu_register_resettable(obj);
>> -
>> -    /*
>> -     * Set ourselves as RamDiscardManager before the plug handler
>> maps the
>> -     * memory region and exposes it via an address space.
>> -     */
>> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
>> -                                          RAM_DISCARD_MANAGER(vmem));
>>   }
>>     static void virtio_mem_device_unrealize(DeviceState *dev)
>> @@ -1138,12 +1142,6 @@ static void
>> virtio_mem_device_unrealize(DeviceState *dev)
>>       VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>>       VirtIOMEM *vmem = VIRTIO_MEM(dev);
>>   -    /*
>> -     * The unplug handler unmapped the memory region, it cannot be
>> -     * found via an address space anymore. Unset ourselves.
>> -     */
>> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>> -
>>       qemu_unregister_resettable(OBJECT(vmem->system_reset));
>>       object_unref(OBJECT(vmem->system_reset));
>>   @@ -1156,6 +1154,11 @@ static void
>> virtio_mem_device_unrealize(DeviceState *dev)
>>       virtio_del_queue(vdev, 0);
>>       virtio_cleanup(vdev);
>>       g_free(vmem->bitmap);
>> +    /*
>> +     * The unplug handler unmapped the memory region, it cannot be
>> +     * found via an address space anymore. Unset ourselves.
>> +     */
>> +    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>>       ram_block_coordinated_discard_require(false);
>>   }
>>   diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 3bebc43d59..390477b588 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -2487,13 +2487,13 @@ static inline bool
>> memory_region_has_ram_discard_manager(MemoryRegion *mr)
>>    *
>>    * This function must not be called for a mapped #MemoryRegion, a
>> #MemoryRegion
>>    * that does not cover RAM, or a #MemoryRegion that already has a
>> - * #RamDiscardManager assigned.
>> + * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
>>    *
>>    * @mr: the #MemoryRegion
>>    * @rdm: #RamDiscardManager to set
>>    */
>> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> -                                           RamDiscardManager *rdm);
>> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> +                                          RamDiscardManager *rdm);
>>     /**
>>    * memory_region_find: translate an address/size relative to a
>> diff --git a/system/memory.c b/system/memory.c
>> index b17b5538ff..62d6b410f0 100644
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -2115,12 +2115,16 @@ RamDiscardManager
>> *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>>       return mr->rdm;
>>   }
>>   -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> -                                           RamDiscardManager *rdm)
>> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
>> +                                          RamDiscardManager *rdm)
>>   {
>>       g_assert(memory_region_is_ram(mr));
>> -    g_assert(!rdm || !mr->rdm);
>> +    if (mr->rdm && rdm) {
>> +        return -EBUSY;
>> +    }
>> +
>>       mr->rdm = rdm;
>> +    return 0;
>>   }
>>     uint64_t ram_discard_manager_get_min_granularity(const
>> RamDiscardManager *rdm,
> 


