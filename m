Return-Path: <kvm+bounces-28666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E1799B08A
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 05:58:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E849C1C213AB
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 03:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9092126BFA;
	Sat, 12 Oct 2024 03:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hgykQ7bG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9312746A
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 03:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728705525; cv=fail; b=IujpUU+stWA3tfKoMNAYbwRXbjTDbVTMGFob92Qy8VkZZQe2AP0iENeTLip/p+byahMiF2J5elYhkwwHlmHxH+uioeqKlAGV6L97b0RTSPCtZBRkeFTD8H11UrFkBMN/wd3NBplCRiBeBgzzn+LoQPFpG3bTH3Js6j8lj/E8ZzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728705525; c=relaxed/simple;
	bh=7WM8wZtC4zkYY0mgWJAXjdfJ/pS3YNICrQtvsTl6W9M=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ud661q9hGk1KVzYjAFxB8GYaRAGoFNF2Ieuj/JK+CEEGjqJEpVCqMPXDK95ZqJ8XJzesph2ZOLcY1a6I50PlLS3PPA9mXjDqNSwV/ffSx/Zuv0gd93e5ge4SE6afSxLWw2ufQRA32eAJMOl+IY2RYJ7qLmUosib9UXYoj9PJJFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hgykQ7bG; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3fZokwGiY0AuedL2G/2EDjlva748ZTDTYykYB/LNstsN8llMMVi1eBB70rtRmx22oj4F/UyxZ8RWgdst3SupkQYS4QdRwUbeCzaM/5Yy5z9P4IP+zWpcaWmAa31PfgD47RdDGuGQ2bVFRZlzKy+SJF35+br+uEtZ8q5JB+LJGCs7PRKRp9O/eV/yL2uxzeYnG0x7O2YoKSgcq30N+am62OOFteprac3ihZ+JY93Q8yZDFOtU/0l+6KFoKoCH070l4HYRuS46VphyokMrhKWe1Rl9fc5RlkRP4d1v27e1l5KHHa/hd5keVY3o4TepJjyqQEZoPNoNvdGKjP5dK3GyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnaXWH0HzSlArRiNh/tyPwiVQ8lv2ZK08aBQH2PLQlo=;
 b=IEHkVjB0De8Pq16OZz6vP6WhzTO3GBnmycc3My59OBY4lr9m6OrupFICXtcLXz5YSF62k/ZeDEG78AwRyqvYTS0Gw9bAhD35Y63ptdIdxHggGNccWXfWviBxPa9eLb8YQ5jqKGsvhn4z/ONd3CRTC+NKJKvhVWipl0TOMK5WKBQ4Kq89IgDjr0N4iTytFGeFLBGJWw2m8VOTHqhCn3DPfSxI5Thrd7wlWW132q6Evpby3/xdVfwqdgguH1nnFileH/Lts56syLQL8O6xW6Z/ptpjWMhRZxi/fMYMSSMl6Vmt7te/U5e7YHPX4DO3A7OmbaLl8D4J8l/UO7T1MHDMBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnaXWH0HzSlArRiNh/tyPwiVQ8lv2ZK08aBQH2PLQlo=;
 b=hgykQ7bGL/Z3s57/gzK9YMz9pV4MrUaomOrs1ui9jWglt89phcoId2D8lJQN1NEwUZMEivJbUhGKFDcUQpmE7/Sw7RZSc+Mh1EhNd1JD86ojBWyaBykq48mmn/9T8em6lWuaUw9OCTJw6t08omvmFmdkbSvPrcS2Y5tHAtznI+s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by IA1PR12MB8311.namprd12.prod.outlook.com (2603:10b6:208:3fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Sat, 12 Oct
 2024 03:58:40 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.8048.017; Sat, 12 Oct 2024
 03:58:40 +0000
Message-ID: <adf12c78-4021-b597-06e9-3f7bd6c6c73e@amd.com>
Date: Sat, 12 Oct 2024 05:58:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, linux-coco@lists.linux.dev,
 KVM <kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::9) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|IA1PR12MB8311:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a922442-254a-427c-f92a-08dcea72286d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dkJKK1BaMlJ4Z0Z3U3VOdnRZZ2ZHaFBIZHZ4TnFHQ1lVYUZEdnAwbVdHM1lv?=
 =?utf-8?B?aHV5Z3hLOE1RRnFNb1lVL1hLWVdoOGc2L21XQ0xGalhtRFdndFYzbFAxMUhy?=
 =?utf-8?B?NGNBcWswRkxNUk9wVDFMTlRZSDlGRDQ1akMzTmJvQitKYlBXSzhLWVpGMlYv?=
 =?utf-8?B?WEtaakRicWgyMm5TQmgzRG1pSEI3bWZlNEU5cktVZUpZbzdhb0F4cFV0amJu?=
 =?utf-8?B?NWx0R2hVN25naEl5SFFHTkVaRzMxaVhrZzk3VEhadTBhMUZnTlZxQWFqbkkz?=
 =?utf-8?B?dTJLNTVsT2dsUXdMYmNvRDVIREphNUVxa05lZVp3M2Q2Mnd4MDJXTDFPb0lp?=
 =?utf-8?B?bzlySHQrNkV1VlJUd1RQWnFpT2dQTTZFeUlpMGpxQncxSkh4LzRlY0N6QWM1?=
 =?utf-8?B?NEo2NjJWUlp1dU9rTW1iMFljaUozakR6QWVndWovUzdUbExFaDZtblk2WEUy?=
 =?utf-8?B?YU5QdHI0ZHlUUFRkekkvS1VqUTUwc1dad0FRMDZHeEdoT0RtZklEWm1Vbkhm?=
 =?utf-8?B?eER5Y3dudk43OFNNcUJxeC9DeVBTV25LZXpteTJocEU0TWt6SjFVOTdNdHpB?=
 =?utf-8?B?clBNdkYwbTZoL290ditmbjY4LzljT2FISXlPTmVNTUtBL0ZiR0V0c2tvbGt1?=
 =?utf-8?B?NWRUQ3YzNTg1cmJTY1ZzRm9LUmJjR2U4Y3lsdVY2UXRtbzZwSURIRmhrbVdV?=
 =?utf-8?B?cVJkUjJVWUxQYTFCVGUwWng5ZkVFemRoUkkwdk1EaWh6UGd2UlVqaW9PNDQy?=
 =?utf-8?B?QkQwVFVmVUNCSERwUE5HdkQ4cTZ6ck1HNEVmMW4zSG5IaDFZZXR5aG5kSzFE?=
 =?utf-8?B?azF1eG5xMlJ4dXJFaTVNYzRqWisyMXN2Yy90NU1xbUR5MjAyUEpTOUJYVXg4?=
 =?utf-8?B?czhUU2FCdjRFSXUzSVlGRXlDRTBXS3FCTlBweDdKaGxuNzBUYmg0WlpFbVJj?=
 =?utf-8?B?TXFJd294Zkt3RmRNNDRENzV0b2ppSzliUWJCb1BGZVVMK2lOZlg3WU5INTg0?=
 =?utf-8?B?ajJJbUdlZmpZdy9KQzRRL01icmJORTdRamVMZ0hWSVRCN3g5QUxXQzloKzFW?=
 =?utf-8?B?ekthL05pemxxTEgvVzRhUjNlOGxjd3ZOblhVKzYybmVDNzhJY2E4aTNvMFlp?=
 =?utf-8?B?WTNIQ1RNbkQ1QjFQeW1rVUU1eVNRc3B5eUFLYVNHMGJkVDdWa2lVZ012ckk3?=
 =?utf-8?B?dkdpaloybEprSVRGL1pqVUNCanJhY09ZL1Jyak94U2c1K0hHcUFEamxwdVhh?=
 =?utf-8?B?NUdLZUpkcllacXpTa0FlM1ZLaEQzL0xadXduMlhlRituZ3lBNVZUTHZoaVA3?=
 =?utf-8?B?YW9FU0pCaTNUYmRqRVl1RU5rVWRmL2l4VXB1VXBnMUwvd21tdDQzSlUvZTkv?=
 =?utf-8?B?anVxbUw4Q3hxQkxXV1pFVnVvb0ZNL1FOSG9lSSt4ODVhQlQweURJOTNZVUJ3?=
 =?utf-8?B?NFkzemZ5NHRZMDMzSWpyeFR3YU8vbkkvQk5PbXJOdjErcHRJdGFLTWRxZGFy?=
 =?utf-8?B?YTV4WVVIVFUvcHlSR3FjTTlSNnk4N1lvR01ZZGZqd2pTRVM1UG1sV1BoV1pr?=
 =?utf-8?B?MU1oVC9SQk00YkJVRE53VGQ1clJBNUp6WEJNYmVoWG1xNGdxSVJHMmFrUzIv?=
 =?utf-8?B?WDhNdEYwWkZSVDJWR0lVb0Qvc0F5UHk5dDZjWndMT1NVUnhGclpFTlJkbUtU?=
 =?utf-8?B?VkJiczFTQ3l0Zll6OFNZcCs3ejMrdG9nZzF5UTV4bU5wQUhDdlR5NmZYOWVo?=
 =?utf-8?B?QUtqN0VPa0Z3bVJscm12Ym51bDdIOVVqcDViYWdzNEF2RUZQY052S2FWb0tP?=
 =?utf-8?B?bWh2SWY4bEpzT0R5K212Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUl4OHlmb2xnRDBJUytOZ1MzUDVHeUd4VjdjTW54Y2s3eU84S0Z4L01zblJG?=
 =?utf-8?B?eDk5M2Y0TjM3NU9jMHFUQnhONTFRZ2paZHJ3OGdWU2FRaFdublJPWEpiZWxw?=
 =?utf-8?B?cjM0TXB4YmNVU0ZBV0lLblhXcnJoR2dTRUtKRkJRY0p5TEY2Sk9BbEhVd2Vt?=
 =?utf-8?B?ejExZEFMWEREQWZkS0FIbDI5dm54Qy95UU02RVRXRzJGOFJXN094c3hzMVN0?=
 =?utf-8?B?M2dTb1AxdmlKV2hqalRYZElwZ0kvV3BxYWNSREpnR1VnRE9MOFRpcUIyQWM3?=
 =?utf-8?B?MVVTUFVKQmFuZFd0QTIzK21WdVhzNlN6K0hkTHdIL0IrcDJDanBlV2ZrQTRp?=
 =?utf-8?B?OHFKM05Lb3lVQVN6RFlHWHlqSlhZREtoQ2t2ZUhJWkpQZDVjRWNXajFvQnFu?=
 =?utf-8?B?V2hnNUkzZzVLOTFkWTN5Zzd1NFZWSGhoV2xVdnhIVFZjZXhqRFl2U0hucFV0?=
 =?utf-8?B?TlRKODRpYzIzM3p5RURadElHazRhWTd3cmhoWi8wWldnaHRacXJ0dDZLZWdr?=
 =?utf-8?B?R1UyRzdCSkRkOGJkUlFjVnFNdGJiTFBLNmdNeHp3aUxQNlozcjJhQzVzUmdw?=
 =?utf-8?B?b3RYWlV3Y3RCc21SVTY4VjN4R3BnT1pETVdoSS9oQUxhTUpzZDJ3Q284My8v?=
 =?utf-8?B?Z2cvSDJiMXQ3TDkvL1lORDRsU0o2d1JDa295a0RIU3BPK1NoVUJwUUZONG9G?=
 =?utf-8?B?b2FxVk9JRGE0dDNneThaRG9qNjJpMEt3ZXVFV29VN2o0VE9Bc2lUYVkvcUR6?=
 =?utf-8?B?MXBiSGptNHZlbWV4RlFDL3NIWllSajFNc2R0bnVpbEFXWnFySzdvWG9NbkdS?=
 =?utf-8?B?Wk5SMlRaT0RMRld6N21iWFlUN0JiQnZUUE1WRzF5ZDBubktnVnVtc3EyQzl0?=
 =?utf-8?B?a2xDRkRVME1pTitYNjBIckJOT0ZxZU1IQk1FY29NNHJ1VmFBM2UzMWtSVDdx?=
 =?utf-8?B?WWxHSGlSeTNSWno0TkpxaHVid1V2Um95dURKRHBvdy9hSVJzNjA2MDdYSTc2?=
 =?utf-8?B?ajMvbG1mdXVCQzZjcDRZemdwbjd6TG9CTlN4UW9lU3BJcHZ0NzFINzExWkps?=
 =?utf-8?B?clZRYngwNWNJUVFrRDBGdFJDenVMdGZVcE1wK0R2c29QRXZsR3F6RWVla3NJ?=
 =?utf-8?B?Rmljd3FYRmRMaHo5N2ZWUmVPUmEvR0Vwa0dGa0llekM1dzV3cDZnaHRrdURE?=
 =?utf-8?B?OXBMOVBjQUFjcGtaQlBDeG8yVC9YTk4rQnA5bk12akM3MnBWNTQvU2J5SlVN?=
 =?utf-8?B?REF2dVJWL3lQZWZRL3ZMOTBOOHdOUUZVSC9SU3pTdzVpSHhQcmw5TVk3OXpa?=
 =?utf-8?B?VVpQSUI2bVVDakZ0UTFDTVF3WjFlSzBOOWplUy96UHh5RFNJcGNjK3VaYXRG?=
 =?utf-8?B?T2VEUS9yVkp2dzUvN2MySUtBRzREUWVBQ0dHOFFLdmZSWjYrMGVMeGpxUGp6?=
 =?utf-8?B?TWtLT3dOL1puSnFzdmhlN3Rwa1BLL2EvOVI3b1VULzU4Q3FKMDk2TjEyWjBp?=
 =?utf-8?B?bkZ1UlBURVBIcDJYbUZBd2pxVGlybVgzbTdlQW5hdXUzbFdXWGZPQVBFdDBm?=
 =?utf-8?B?ZWI5WmsxSTQ5L2Q5SnV5S1BsMklOVmZyZTlYeFV2c1JBZjB5d2RyUW45bkNW?=
 =?utf-8?B?ak51K202ZmxtZXNFdDdFeHBIYkM5eWVhQXUwZmRlUXhBQ1Ricy9jUjhzS2Jt?=
 =?utf-8?B?NUFFSXppM2dOYnpQbFQxeWdaSGUxNlg2RDZaZ3N0dC90UkJrSTVQeWgvRzE0?=
 =?utf-8?B?NEMzcmYwZ1JoRnduc0xtazl0dTNieUJncXluK0RxZkdwdG5FS3E1Zk9SN0lt?=
 =?utf-8?B?V3VrVzNNdGRnMnQ1NW1ETDhING1Rd0o0TTZIZDVBYllwNUE0MlU0MzZxc3Ry?=
 =?utf-8?B?Z1dUTFg5bERXOWdmV2gzbENkSmV3RG1WM3ZCK1I5Rk5vcFNHemN6QVcxSFEy?=
 =?utf-8?B?dUhweVdEaGlXTDJiUERYYTZiNW9ENHdoQjNjODd4WVgyLzIra2h3SUhWaTFB?=
 =?utf-8?B?dFM5VmZMdUI3QUtqT2NIeVZKTlBKdnJpakJxOW5idHlCV1FNL3NyUHZrbU5Z?=
 =?utf-8?B?QVZPMEM3Tnk1WG5BMHU0dnRBUTFtOUlENTMrRklqQm1XaVNGWjJSaVRWMHJw?=
 =?utf-8?Q?t/rtIrAU5V9H57OZazcZS9/pA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a922442-254a-427c-f92a-08dcea72286d
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2024 03:58:40.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1r+eTtzcY4A3eqT2CGW20Lihb293WYczg8n3yR02u398VJ5FHU/1IY2szcVL80A+GIMPqZSVo//z6zUOxB7AuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8311

On 10/10/2024 3:39 PM, David Hildenbrand wrote:
> Ahoihoi,
> 
> while talking to a bunch of folks at LPC about guest_memfd, it was 
> raised that there isn't really a place for people to discuss the 
> development of guest_memfd on a regular basis.
> 
> There is a KVM upstream call, but guest_memfd is on its way of not being 
> guest_memfd specific ("library") and there is the bi-weekly MM alignment 
> call, but we're not going to hijack that meeting completely + a lot of 
> guest_memfd stuff doesn't need all the MM experts ;)
> 
> So my proposal would be to have a bi-weekly meeting, to discuss ongoing 
> development of guest_memfd, in particular:
> 
> (1) Organize development: (do we need 3 different implementation
>      of mmap() support ? ;) )
> (2) Discuss current progress and challenges
> (3) Cover future ideas and directions
> (4) Whatever else makes sense
> 
> Topic-wise it's relatively clear: guest_memfd extensions were one of the 
> hot topics at LPC ;)
> 
> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7), 
> starting Thursday next week (2024-10-17).
> 
> We would be using Google Meet.
> 
> 
> Thoughts?

Thanks for setting this up. Want to join as well.

Best regards,
Pankaj

> 


