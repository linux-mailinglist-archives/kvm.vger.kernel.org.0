Return-Path: <kvm+bounces-29357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E715D9A9FA7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77A881F23A4F
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B2C19993A;
	Tue, 22 Oct 2024 10:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TdYnlwUV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3FA19005D
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729591794; cv=fail; b=fyOE8MO0SBmcVJRwGzNS+Mt2ZkDpqNP3juX/KLJV7YIOV8CN+7cSQVQlXEI+pjekrxIM7fB3cg005WWfHZnXfMETpnGvyYAsvqW988/gM7HByLanFJPx+tin3i1uW1ye6mW0SthCW3AY8adM7b2tYlbfVsUPBrkLFSUBu0Ad998=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729591794; c=relaxed/simple;
	bh=W6YyRBWWGzxj22aBP093rUW7/KmxXzLODQExRurLjm8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R/MjNibZ6Ul5QwOiWqMUgpDhgEJ/+yUA88Pyy6VyNeb+k9Aju7QJ5WBznyxIm9RLXmuFauyHhqPytX63IA/cFMwOTws3lWsGWoHtah6PlsV6v5z69yMjKgLZ0hWQiINoy4p+gJdrePjCrI5ByhaoR+9wpdiEsb/0nRCadA/icMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TdYnlwUV; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729591791; x=1761127791;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W6YyRBWWGzxj22aBP093rUW7/KmxXzLODQExRurLjm8=;
  b=TdYnlwUVIN42d80H06GUQ8rd2eWoTMpBanFswHrgW3v6UGdEbA/lL+S6
   gSqTFUXu1/8zVL46LGVA1XJaxV1C5ZhMmtPVvZuwbgssKHzTWUJN8IFpy
   U7aAqmeVobMDzBlOK7IlN0WVJURp0c91bvXr9rYAl3O4HuZNiugU5yHQy
   UWKzJGOStszVFMiIb6XG3l7z+xIA+56weaDMMl1YAa5A8Ay+wtl4aswin
   4eZBAJ7cUh7CQC59ejX8gFz2xAPFsoT6Z6rvS/SnnYRfmDFTal4sQUPBp
   9E6PX7HR8ImYVl8mTfyeBI61F2NMtV/HVu+xbi19M/wQNxmhZXd/35pOm
   Q==;
X-CSE-ConnectionGUID: 309wl6QbS/SS4//hEiyxjg==
X-CSE-MsgGUID: gHdL229dTXqgKVUhvcEKKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="32807981"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="32807981"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 03:09:49 -0700
X-CSE-ConnectionGUID: S82//sA9Sh2Ou672NKkaVA==
X-CSE-MsgGUID: o0t2t0voSLaWBQnQL1BsBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="79890638"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Oct 2024 03:09:45 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 22 Oct 2024 03:09:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 22 Oct 2024 03:09:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 03:09:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sG7ll2hA4majwgEwUxp82sTY4QOLwaFVMeSEMx6geicPNv3QInpmUGHN/bNUkuvJfXvcS7GLB9kMXetuTw6aPBc5b7lV80Vdet/lybrLQyAhBiMRP2cTRY8I7b11QRCNp8SpnY84qX+QOX7koh8hHbaz/TYxcLNWMVW/bR6/MPH21G8fD7I/bEeui+Kv4rMLySDVLTOHfFGDxUdIgpLVrJLh8GNcqrA1Zpbk4oVdkKHjBoGssU015PydE4XzciWx23eIc9u0dnyQQ4/OGslpGbk2FXDB9dJp5CO2sst98nugCW2P8bVlZ83FiWoxW1TSeh0bKZ5aMOqMMSzfQSTjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBtF1WQ8AutlWxWwofWefvUeQWhGMkJBRkXdcEDS5R8=;
 b=HmWtTN9sqHtzKR/GVLAMK/bjDv40hO+B7tVTettKHWAwXvvC9W83y6nxjGK7rTYoc55ZKvp20/CWGpzJe/C8ojYGB5HNGcz8njgF/4bPpbmJSLPWHfHJr/YLP0uKG/cRq4JJ3YrRZ5LAf16EkLZqR+GQZ0muAVvKvNuA5DIHcZYuT4GNmx18b+VFYPsJTDlqTFywJo2QTGaaCyc/G+jJMbLG1HgHLfw2fMZQH0GLD64trQK5LJcta4NmtlNSZGMyrU1OeqingDOteKA+O6d0FvbwDRydMPno35B3jFI/A5JdS/bY3k3XJhyz+SS1UsFV6kz7lpydVAS0JRml7MG+xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB4995.namprd11.prod.outlook.com (2603:10b6:303:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 10:09:42 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 10:09:42 +0000
Message-ID: <3c381896-fa24-4445-aefc-6320965d9b0b@intel.com>
Date: Tue, 22 Oct 2024 18:14:18 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Support attaching PASID to the blocked_domain
To: Vasant Hegde <vasant.hegde@amd.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>, <baolu.lu@linux.intel.com>, <will@kernel.org>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <b6f7f648-c509-4e95-a697-f2c09b1cbf6e@amd.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <b6f7f648-c509-4e95-a697-f2c09b1cbf6e@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:195::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO1PR11MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 380108c2-51ad-4e22-3f78-08dcf281a560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MGlCcjFXdHJta1JHcXMwL2JHeUljdG1rbTFCYkt4cGg2UTYzemp1VVZ4cnZx?=
 =?utf-8?B?MUlBOWxjYWpiWU5wcDZyZUJaUUdtKzFHWGl0T3JEdEtJUXhhcjBiRUFxRlBy?=
 =?utf-8?B?c0NXakVxNHR4L2h1UE4xVEtZNkdYbEQ1VVUzZ0Q4MnFqWnEwZzFLajNudXdS?=
 =?utf-8?B?ZjlxenA0SlIrTFprR3JqZlRtZXpUN1Fpby85MjV1anRSRVNDK3ZiYUhNV1Bs?=
 =?utf-8?B?SnJqeHBJZmlLSXYyMG1SVVZUb0tIRjIrb3pqM2Y3SlA1UmVnN0cwUnVUTE01?=
 =?utf-8?B?a2VlRUNoUk90Q0x4dXBpTnpmQlc2dkIwSG1OR0pOV0hhWStwcnM3TGNrcTlF?=
 =?utf-8?B?bVlVbG1QazB3enFnT0ZKdU50aTFqVGtURkNEUlRuK1ZhemI1RmJiV1c1d1dm?=
 =?utf-8?B?ZG9iSGdub1FRRzF2ZzhrVTJMMm5xK2hZOFZCSzAxRzVkWXkrMSsxZlludnI4?=
 =?utf-8?B?Y29ZZVB2NGh1VWdqck81TjZwbHBvcFg0M3BTSkZSV05vUEV6bDhEaE03WEFS?=
 =?utf-8?B?WDFlRU4yRWFZdXZxam1UZ2NkNit5eisxbEtwL0pGR0R2WTJKSjZoR0FDUTRD?=
 =?utf-8?B?MzdqNHhQcndLSkRyTkp6eFBka2ozYmhVQ3RPS21ORlg5eEF4V09IQ0F0bDFv?=
 =?utf-8?B?bCtMU0xlNG1JeG1pakR5OTVINW9oOG1aL0paM1F2cGlkQUpLY3FkSEh0Wm1M?=
 =?utf-8?B?N0Y2RnNIZENrVjQvNVA4MTNpVEV5aFM4c3RBRVE5bWJlTXl4NzlZdUJDM2Yv?=
 =?utf-8?B?bSthQzB5Tkl1Vy9XWFFrQzJmNWZuSFE4RHRBL1FhTll1dnBGY1FIdUQ3Qzdw?=
 =?utf-8?B?MVZLdjR0dThXb2MzOFN4NUFBUXVJaWdsbXRBL2lTNFdKZGd6OEwyS3VhSjdJ?=
 =?utf-8?B?MkRvQVF3L1NkT2s5SEY2R0E5OVozclZjQjNBL25OeXV4cm5mOWMwSjM3dHZ6?=
 =?utf-8?B?SUhwQVFDQ25iUXRUMUI4V0NQb3NIQ0E3OVVoN296ckd0bjFqdXNEei9OTi9m?=
 =?utf-8?B?TXdsNnNNUTVWWjYyT3VDd1h2Q1d5WEJMNDlBVURaRTRoNXBSbDRDcnE1WWto?=
 =?utf-8?B?eDBndm1NcWRmRTZqN285eFd2cVp2aldYM1QrQTZpK3BoeUdEblNZZkk0YzNv?=
 =?utf-8?B?QWsyUGF1emsyRk5RMzJXK0VDVFYzR1pmRlhSd2RqOWdYU0ZwbGlGbXVZNUg5?=
 =?utf-8?B?Qkk2UWFJcytNc1VqeHUwWVA0T1NpY0FIM1FlN28renRGRUVYc1I5QXlkK21s?=
 =?utf-8?B?ZzJQNmhCM1dhM2xVMk5ldUhxdEhmU3lNNzlhcFo4OGtsWnd3djhJMm9GNHg3?=
 =?utf-8?B?TTl6LytIOFFGbTN0c1Ryc0sxeXNZZTFqVi9KMy9SMXVLSlluMC93RDlDMDYz?=
 =?utf-8?B?Y0NQc1A5Z250Uy9aUlVXRXFzU05hbTh3a0crSnViclRVUDNQUC91bjAyMmdN?=
 =?utf-8?B?dkRRTW9UYUtXeUpuTDd2elpabjFta0tnTkw5SFJIUkxCdDM1Z2dJTENFUmpB?=
 =?utf-8?B?bC9rT1ZWQUg2SUFaRlkyby9rTjZmQzBucjBraXgvUzNpZkx6cnA5dGFvdjBY?=
 =?utf-8?B?UGJ2SkpkZlZYMm9KUHpvZ2ZVZlRZWDBRZW82cnlLRGN1L05LcDNwY0oyd1Fl?=
 =?utf-8?B?c3pvVmFoRTNyWmkrYVJCcGxydnpNbDUwZkZ4MlY0OEJ1S2dHdmgzRFBHb3Nm?=
 =?utf-8?B?djF3M2VwTm5vdG9YRVNpamUrczVWZ0FkQlUrZ2l3N1prU2dwM0R6eWpNdUNM?=
 =?utf-8?Q?P3WQThoz7JDS9YByvIwpwxsH+z/XpQulhWT3x9j?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1cyUG5oUzBla1dYQmhWV250U0h2ck9XNGx5cWtQZlNTblp3bUNxV0EzSnNN?=
 =?utf-8?B?QUl0TWg5TnFDYTdsLzVLQ2FnWEl6YkJoUWE4UURZcFVvNjRaU3E3cFdWMlFR?=
 =?utf-8?B?cEZDbXcyeWgzUzdnY2pldmtqZ2ZUS2U1RUczdHZOUVhkWFJDdGRFaFJYOXhI?=
 =?utf-8?B?NVVoRHd0WVlpMDJGVVhXR2xRRS82RmFYWFByeVkzVERidDM4Qmhjc081R1dF?=
 =?utf-8?B?eE9jMm5UQ2ZEbE92OUNXRVNKV2VZQUIwSWVHejh0dUpKN1ZJNDJ6ZzFlU2Yx?=
 =?utf-8?B?QVZxaXRjbGVXTVpoYVJKNVQrUXc1WVpMaDZSejZ2c2prL2Nad01IVW5CUmtP?=
 =?utf-8?B?VWEwZURMQWNlK1UyL1Z3N25uSXVMampUNGJSOWZKWHYzTXlJWGh1djlBc3gw?=
 =?utf-8?B?ZkhoT3lYdVlHUjdkSWlIbjZMcTdyRUNUOFFpdWZxMFI5L1UwZ0RSdVo4YlBB?=
 =?utf-8?B?Z0pXSnBlUFl6MUdSbHBSajJxV2ptS25id3JTMlZVY3cxWjNXbFVqK1g4MlV6?=
 =?utf-8?B?TVJDaXQ4ZkRwbkN2RWVmTDE0WHo1NHl5R0kwMkV5cStmT2xSanNBN0NNRkdn?=
 =?utf-8?B?UHZNVVlBUThiNDMvWnpldW5BaS9PT3N1dzhqKzd1ZHBwTW03YlMwY0JRS2pr?=
 =?utf-8?B?Qmh5M29JQmhpeHZFL3ZGa2NHOVpXcGpGbmVqK1llVzFTYzNWd0NGbE1tdDQy?=
 =?utf-8?B?c2c1Q3M5QmEwcGpzVUZ1c2xvTmJEVXdacnZ2Wm41b1BPTTlwVGxFR3VyY2JV?=
 =?utf-8?B?Rkd2S0lBMTErYU45ZFNIOURJOFdWVFFiS1hjNXB5V0dNL2RUb0NUMy9jY0Q4?=
 =?utf-8?B?aFVRUzJVOFQ2WmFMYTcwTGJXOFMrczZqWjJhNWpYdFpKV3JyWDFseHhIWU1a?=
 =?utf-8?B?SHhoVEtVQXZKa1B1b04zdnFtVUlYVVlONVRHbSt1ckZWU09FTVlod0o3L1Fu?=
 =?utf-8?B?Y2NqdjBKdFFwbEp5dGZWcVFOUjNtUVFEOUxUNzlmTWFRMGdqR2lBb250YlBG?=
 =?utf-8?B?MTE4SHVzclF1MlYzakxhY2lYdCtwQ0dzUVpiV1VUbE1LazlwUGZ0Q0E4TUla?=
 =?utf-8?B?RlFWaU1GVDVXWldJcEhSdlVrL24zZHAzY3RNanpSYlFES0NkTUp1S25sY3hO?=
 =?utf-8?B?NVRjbE0vZGJXRU1SQm1JcDQ2b29SRzNzWHdpRHZEUG91WmYwSStUSmxkNDFx?=
 =?utf-8?B?TDgrMlpLcnF2UWlhdVVKQjN5QnRhK2t4OUIzdFdySzdIMUlUYXNxc2FIN1p2?=
 =?utf-8?B?a0t6YkdqTk9YNitQZkV0NjFRR2lMOVVIcXVlVXhLdDJnQlZxZDVBczhtdEg3?=
 =?utf-8?B?ZE1GN2xmT0xCUUplL2tqaDFnVjVuSFZUaTZicjZHYUVGcDNnRTNpMm5BK1Ji?=
 =?utf-8?B?NzdXRkJVSjhwaStvZ0lJaXlzcG52bXR4QmZXWmh2T3c1U3Z1SGxpdW5NeXhF?=
 =?utf-8?B?SDNybkZmL3pZOTRoakNCZy94MFQrUGNheVIwUXZnUWFTZ2F3cFJ4QXFwVVpB?=
 =?utf-8?B?bkdlQUZMWVAxSGRBOUU3WXBnQ2JFRW9WY2JKd1RLNEo1dW1HU3NxSlVURTBn?=
 =?utf-8?B?UWV1bkF6RFFFOEhhNTNUNFF6V01PUk5tZHFSMGR2dm4yN0dDSURUUjIycWtB?=
 =?utf-8?B?ZnhSTXZMUUpjaXJ3c2s4ZWNINGdSSmFPNzZMTkN2a0lnY09qLzkrZlRVV3Zy?=
 =?utf-8?B?Z2QrVVNDbzQ1QkhIcE1TNWtST1RwdlFxckh0N1JaVWxHbjhWN29jK0J5cGRT?=
 =?utf-8?B?VWFtQjAyc2NNeEFhZVlmT0VIQk81VVFvZmk4L1lJR3VCM1BVSVlOaWt0K1pt?=
 =?utf-8?B?VWRsNU1PUzNaTXNVZ3RkengwdVRpc0QyaHkwY2JMTjFYYTYrZUVQaHdQVWQz?=
 =?utf-8?B?bXBiSXZOMFprUk1YVlREaElFSGxpUy9sVWl2aTJINnd5MjkvL1I0WFVRTVJD?=
 =?utf-8?B?TUdQem1nVm5kdS9FdlJKWkh0UmJBSTcxRDl5Qk5ibzhRbXcveXYxV3ptNEg5?=
 =?utf-8?B?QTl6VDdZNjRBL3o4eUNXdmplbTVtYmJqdEFpdGkyU20yUXdNeEw2TkhrTXFF?=
 =?utf-8?B?ZXVVL0wwb3lqR1VRSzB1L0F5aU9ZSE1rVnNOS0g0YVAreDJxVEtXMW1EM0RF?=
 =?utf-8?Q?bkV2ukn/lnlMd5qCz+6AKbNQq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 380108c2-51ad-4e22-3f78-08dcf281a560
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 10:09:42.2257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66Z2lb89ElXWFjCQlhAb1WZPV+mLJdapLQ6h2nIgZTMpi0RYJ7yRhypXEfYlWi4mtJ3uSne/w6NRsDVPfOi0Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4995
X-OriginatorOrg: intel.com

On 2024/10/22 17:44, Vasant Hegde wrote:
> Hi Yi,
> 
> 
> On 10/18/2024 11:28 AM, Yi Liu wrote:
>> During the review of iommufd pasid series, Kevin and Jason suggested
>> attaching PASID to the blocked domain hence replacing the usage of
>> remove_dev_pasid() op [1]. This makes sense as it makes the PASID path
>> aligned with the RID path which attaches the RID to the blocked_domain
>> when it is to be blocked. To do it, it requires passing the old domain
>> to the iommu driver. This has been done in [2].
> 
> I understand attaching RID to blocked_domain. But I am not getting why
> we have to do same for PASID. In remove_dev_pasid() path we clear the entry in
> PASID table (AMD case GCR3 table). So no further access is allowed anyway.
> 
> Is it just to align with RID flow -OR- do we have any other reason?

yes, this is also my understanding.:)

Regards,
Yi Liu

> 
> -Vasant
> 
> 
>>
>> This series makes the Intel iommu driver and ARM SMMUv3 driver support
>> attaching PASID to the blocked domain. While the AMD iommu driver does
>> not have the blocked domain yet, so still uses the remove_dev_pasid() op.
>>
>> [1] https://lore.kernel.org/linux-iommu/20240816130202.GB2032816@nvidia.com/
>> [2] https://lore.kernel.org/linux-iommu/20241018055402.23277-2-yi.l.liu@intel.com/
>>
>> v2:
>>   - Add Kevin's r-b
>>   - Adjust the order of patch 03 of v1, it should be the first patch (Baolu)
>>
>> v1: https://lore.kernel.org/linux-iommu/20240912130653.11028-1-yi.l.liu@intel.com/
>>
>> Regards,
>> 	Yi Liu
>>
>> Jason Gunthorpe (1):
>>    iommu/arm-smmu-v3: Make the blocked domain support PASID
>>
>> Yi Liu (2):
>>    iommu: Add a wrapper for remove_dev_pasid
>>    iommu/vt-d: Make the blocked domain support PASID
>>
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 12 ++++-----
>>   drivers/iommu/intel/iommu.c                 | 19 ++++++++-----
>>   drivers/iommu/intel/pasid.c                 |  3 ++-
>>   drivers/iommu/iommu.c                       | 30 ++++++++++++++++-----
>>   4 files changed, 45 insertions(+), 19 deletions(-)
>>

-- 
Regards,
Yi Liu

