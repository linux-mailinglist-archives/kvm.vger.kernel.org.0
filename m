Return-Path: <kvm+bounces-42983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA13A81C48
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 07:44:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57033881402
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 05:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9679D1DDC3F;
	Wed,  9 Apr 2025 05:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Y/v1OlGP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE9D282FA
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 05:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744177422; cv=fail; b=O4kYfK/qK1CY04aw5ErEC/1VJvknqEBF8L8rIoI7/AriQxsXBVNVUagvTQ5llDR0uHbKAZVmrjMlObYegPQdnNFkpnQdSPkbIwBPUOQP4tT1ZSM1eoqtg9BC2QnkGW9o/K2e80hYnSsU8LcZtyhEgmymQAP3P4zyAdKNeuSz6lQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744177422; c=relaxed/simple;
	bh=GO5s6byNdX5AxynlQCNOfTBBy8eVfg04eGlrz6KOhpY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bmwE3/2OBtAU+bQLcyFonRHhEC+8QRWLbY/EDnaFujdOtoIGFTxauNmBNLyXu9dSe8tqOu8Nw2JpNOJIfk8Zje3bZHf0uzOzdK2gfU9eB37eOKpuXkhCHVIMEDEj16z8Bg+fezBl2Z5Ksvjp6nQjmyQyuX8r3rzlPXaINcO1RE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Y/v1OlGP; arc=fail smtp.client-ip=40.107.101.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pre8mJPT85/CM95P4eadh7MgqI8BiWgCajxsGhNz8GmLQlaHUMdwarfyeyK0gSPmh8eXuYPTcXudWyeeducJrYh5DjIvvvvdeaAWCrQgaCKM5QoEZvNgMcEKL5mzd7QNZO9XnPF7Ecgo8Ap5DxGM2/8YOr1BGuirs2K7+Dj8n3gBzNqYANnADh8AZ66mPJ8lp/1kfTsleFlCRc15HE2MEOqHMFF+3z/4An63p4HAM5Df269lxoBSiJ3ar2sEXrhoYIW9PmznTIZ+JSJ1s4PA3BkDt1uEPXTpQWjP87Er9PutJgApJ3TBpsr/ltDwmOG5Si4knPw+nZDySq+czhTkOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZW8UQL00zIs6eP3DMYzZyKfS4GuomXLz+2N5yaOuf8=;
 b=Y7JaZyD/sLT2Zym0Q0Q9sbIpzn39S3634rJgagqjW/WvWjVHIMzLQkjYKdGnNwR3/Djk1Kgp8K1Rbgh1MMupTLr1i6wdIc8yTQgTkeCLAcR+n3m1LJ9vm+Rae8Yr2IYDUoA+/EQ9dT9Up7VRu0aSC894X5Exp0EU2KoWju1UcImdmfJYH8ezc9WayW3F3KgZWt9C1c/QV4GpQF7066XtkBlVAltp3/v41cyUUIgUFjxPMSvpoXKGOgM6kRgQ9XO+vLACiAwp1++PZmugjyokKcSuuYfz3deqfrnZTHz3vn/Vi1OdLgP5LBUK6yO8lcC7+gZoQFzioboWIMgjTZtXRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZW8UQL00zIs6eP3DMYzZyKfS4GuomXLz+2N5yaOuf8=;
 b=Y/v1OlGPXBuv78/0rqRXpydLcccUDIvV9TLWVModp1cwvos7U/wSHzn2v+VflK6T06PiC2a5egOmQDjGIc6aFN4ikN39s0AsAqSNmjUEkF3rDzkV4HpDRVLRgULqt81g3T0ylqnvfMBwUJvR4hh+igc1ZLZSaig0RmVjkl1Oe3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB6695.namprd12.prod.outlook.com (2603:10b6:510:1b2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Wed, 9 Apr
 2025 05:43:38 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 05:43:38 +0000
Message-ID: <20936115-1d56-4504-9305-e023eaac081d@amd.com>
Date: Wed, 9 Apr 2025 15:43:30 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 03/13] memory: Unify the definiton of
 ReplayRamPopulate() and ReplayRamDiscard()
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-4-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250407074939.18657-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVPR01CA0012.ausprd01.prod.outlook.com
 (2603:10c6:220:204::17) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: ce149b23-f52d-4f97-72de-08dd77297a43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1dYSHI2QmFBdFVMQ0d6TXZFZjlyVnBQRFNaU0dmRjNwVFg5V0RnKzRSTzJU?=
 =?utf-8?B?d0tnRXNtWEg3REhhQ3d6QmM4V0RwWnZjZThVVm1VZkl5SkNSeGtMVndEWUgw?=
 =?utf-8?B?YmIzckVtRkZuNGFsVEg2NmswU1kxNGVUdVFFMmNzbUNzdVlIcjR4UndmSzll?=
 =?utf-8?B?Y01LYldoS1N0ZjlqdmpVSGpkZHlIbjVXWTBOa01TTCtVeGEwd3lpTHQxdzNo?=
 =?utf-8?B?cHdWY3hadkMzRlMydGhjZUdHd0xKV3loWG44cnBndU55eEQ5aTI2NFFodGZy?=
 =?utf-8?B?TE4wejhVeHN2UVZLZlhHenlYY0xncGF0VlVCMVRid1FhMEZTbEthbExBRHZE?=
 =?utf-8?B?KzVlTE1oZEw3d05KZnZ4SWpGVXYwcXdWcXlFMTdBNjl0ckN4UTBqaHA5eUFy?=
 =?utf-8?B?OTZTb3lqa0hHc014RlFLSmwrdTZUNGlNQkgvY2k1a0J1RFV3aGE0QTR4L3F5?=
 =?utf-8?B?ejVCTGxIaS9GQ291c2ltT3ZrSjhhaVNzeXMzWmRGZnBEckVKSVdsYUJ0OGJC?=
 =?utf-8?B?R0NXcUtUWFBOdjRNbzc3OTlsdGlIVExxOGlQR2VIaytPUWw0c3lLNndJeXp5?=
 =?utf-8?B?NGxseHR4UUpJcEl4ZFl5dE8wRGw2THZjallKdmpWNVR1MkVQRGhRN25neXRR?=
 =?utf-8?B?UVRJWVB2ckFHaXF4dkppa2dtS1ppT1VSNnpVQ3Q3NE9xRncrMjNFN3hRYVVB?=
 =?utf-8?B?MzJUcVp0TzF1d054Q0crMDZOaFVPT1FTRk1FbkZOWnN0d1NTTVp1OUdFMnJE?=
 =?utf-8?B?SzdKeTE2TVI1MWdzbzNUd25uMUdtS1lIY0dPQXVYdnAxQ2JHRkh6WGNBWnky?=
 =?utf-8?B?b2lES095NERxU1lCdGdJNWNHWlNteVNZeFVQWC9sMUlWRkRhdXk1R3hpQU5j?=
 =?utf-8?B?TjBxaVlaSXRNbTN6UCtPb2xaVTJPajVGYzBSWTBPaGlGSVNWSndiT3ZmU2FC?=
 =?utf-8?B?aUtRNVkxSDdKY1NVSzI0d3RFa2RmdDVjSklXRlJTK2lXOEdZd1JyR3NldEhQ?=
 =?utf-8?B?Vjhwck1paE82aEVYVnd1dGo3N0FjMDFibE44bm9pUElDMDFKUmFkb1JObStS?=
 =?utf-8?B?c0E1TkpQQlJzbGpKTVpkOVFvbk5jLzJwbGVGa1V3WWRkTXl1R0hSUGFHRkl5?=
 =?utf-8?B?RXM0dTlxU0plcnJZRG82V2orUE1TazBDVmNpMlVwMVNwa05VTHBKQ2lJMm1J?=
 =?utf-8?B?eEMyejFNczkyUmtOeXdwSUdhcXdrbFpkOVNrUTNkMXpMOUNJNkdGaksvdjdv?=
 =?utf-8?B?QkFlamJpa3pyT0FzQVlHWWg4WFBuZ1NScjRQZEtzQU04c2FyRWFPakJjRFFm?=
 =?utf-8?B?TWJWQ21iaTdoNUx1TGZYcW9QbTFaekdhbVVrMlFyL0c1ck9MbmZkR1BvRnlh?=
 =?utf-8?B?SExtZ3FPeGxoQUlsTk9jcU9UQlJsVXpNZVVnVHNaZE9qc3Vsd0tMa0IvbEZL?=
 =?utf-8?B?RVcva0hESDNJVE1XNGozYTNhS0VSMml1cjBjeXRZR05JcGNCb0Vqb0YzZlZy?=
 =?utf-8?B?aHU0SnZINDEwaFVzSEJQZXNjRjVsa0YrL3BsMGlHK0w4Y0lDd2tNWlhrdkdB?=
 =?utf-8?B?WHRvS1Z5MEVGOHRPMVZ3SlZpWXVFSWZWamdzNkZNNnhqSXRxZnl4ZnRkT1U4?=
 =?utf-8?B?QmNhOVVnVWEvdUYrbll1NkNyRkJSTElqSUYzaXc4OFJFaEN2Tm9DVWZ3Umxi?=
 =?utf-8?B?QTIwY21CZnNTTDM0K0UrZFJaWkkzTlhIS3NEdmd2d3VUOGF1SkJsK2Q2b0hB?=
 =?utf-8?B?d3JrNWpTSDIxbEIvbHBaUUFuaWI5MUZrcFczeS9lUmRaVEtUT2JyeWlYSkw1?=
 =?utf-8?B?dnRESHlIOEt6RitibEpoRU1QQ1BzL3JwSzd6MU00Sm9LSlQ1VjExUENrd2dO?=
 =?utf-8?Q?0KqUfzvGBIFr3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFB6RUxvRmVGTmxoM0U2bGZxSVBJR2pxaFJaWmpMWDUwWm04aFdmUExsdU5w?=
 =?utf-8?B?QWIyclhOMUR3cTBiZmR4UFk1L1ZtMCtZU1ZPZlRpWGtkN0RWTHFPcEdKNGtX?=
 =?utf-8?B?Y3RqOHpEbFZhcm1vZk5WVkFSd0JuaXIvZi9LVDFJdnhCNjZxNG1jQ1dnZnV4?=
 =?utf-8?B?S1Yvc1huU2hja3hidzhiWTJ0d1JsOVNSeVc3TzVjdXVJZElNYTNOUm8zeG9Z?=
 =?utf-8?B?b3JVWEI1bXdQL3NsRjljNVVuZk5Tb0RzdVA1YkZ5Z3N0UUJTdGhpejFRampH?=
 =?utf-8?B?YlJSWXhCa3dkdHN6dGdhSnl1WjE4SFVZdTBFc1dxT3J1U29YekJmWHlLOThs?=
 =?utf-8?B?SU94ckpSeHp3NldYcG16bEZkRlJGaElwb21OUFMwajM1M05aOU1ZYU1DeWZy?=
 =?utf-8?B?RXNzNWovYUxYcGJqejlQd0pkN21IdkRiTEd2Y2dUZHFRYlZ3VkJ0clF4MDhx?=
 =?utf-8?B?WWtEMjFqYTZtaXVHbDRqeGJOMWlNcGtSakZJYnVEdWMzbUdjUHRZdVlqbkVO?=
 =?utf-8?B?NnlJb3ZBTWZWelZ3eVAybHVLTHZjMnp0VFQxaWVTUVFaeWxKemtDU2VpSHo4?=
 =?utf-8?B?M0FMdWNUeHZ2VjNFVEZ6R1VrNkVPcnI5OGJiVlBLdUpDUjRJcmZwMjd6T29o?=
 =?utf-8?B?enFJblBLKyt6WkhUNm5zc1B1cWcwYWhyQm94YUNUUEJKaHV5OElvcEJhUks5?=
 =?utf-8?B?d2xucDJXNWV3TVhBYjIrLzJXendRb3ZiSXBIcmF2aDJ6Ty9pYUZiWFJuTkhG?=
 =?utf-8?B?bko0R2ZNUklhb3R3NWtnRzR1MHV3OHJ6TUhRVHRGeXVBWlVhYjEzT0ozTEVC?=
 =?utf-8?B?cnpJbGJJYWV1RENrWEJDWm9wMEpNNzhhSWlhSlVYSk1pNkFEdGF1S01ZMy9J?=
 =?utf-8?B?aWVPaVFBV1V4ZDJqejVsSFJCUjJob1E1VUp2RW9HSi9nUmwvelI5OUFTNTE3?=
 =?utf-8?B?allzYStBcHorNVYveW9QWXNjUEh5UDlieG1Oc2RBSWM4WVNsUStWTEo5bUht?=
 =?utf-8?B?Vy81L1lXdlJwRXRQQk5ycU5IQ1J5b0RVYzVUUzFNd0VpcFNrQzNvWVhIclVQ?=
 =?utf-8?B?ZTEvMEVDaEIrdkUzeFpaMFpPVFRCaHNiNndxNjRYbmRwWmQwNWxscEdWVnlG?=
 =?utf-8?B?SDJFSStWaDg3blEyWVZNYVprU2FBZHR0RXZyTjBKSUtIWlR3UDhaWlgxU0Jl?=
 =?utf-8?B?aUdDeElUblBjVitHUHFJWmJxdkFTcnJ3Q3Jtdk13VlVibE4zcVc4UDJUMkpI?=
 =?utf-8?B?YTdnRnN1NXpmaDlMdGUyMUVQdGx1U0NtNUF5RnI3QTltYmRjek9yblhIVHMv?=
 =?utf-8?B?eW5hOTRZWnoxb0VETGh1Z21TVnJMZmFnR25Uc090ODdYdit1N0lOekM4S2pB?=
 =?utf-8?B?ZDI3Z1pWNUlLMzdCVlVVN0ZZM0Q4MFl3TW8rQ09nUDNnSXY2WU5HWi8wa044?=
 =?utf-8?B?d01kNEpGUDhFUVJrdldEL2dsRWdKKzU5OE9teVRxS3hkSkZvSkdMV1NhTVVP?=
 =?utf-8?B?QlJJYTdHeXpQVUxqRkNidTdLUmRTRHJpY1lxa1dHY3F6MCtnc2Y3bFp6K3Fy?=
 =?utf-8?B?dlBoUTlENmZJNUc2alY0NUdQR002WlBiTmZ5UkliZEh1K1lEY1VtWWVzWSt6?=
 =?utf-8?B?bSsvUHFLV0NVa3VsZXAraDJmWEdjc0cvcDRjZXdIaDV3VkdOOU11c2xQYXFw?=
 =?utf-8?B?RUtXdkYrMzFqd2FCQ2tTR1ZCMHlCK0o0YzJJWSt4QXpRQUF4SmN0QXpZSEZ4?=
 =?utf-8?B?djBhQzF0eUNvbWVzME9udEVWNGZDb0ZIbTc1WHVaTFhyRVpXZkI3cHp4UHVy?=
 =?utf-8?B?MS9NUmY2UU9xUTl0cGQxdEdjVXV5MTNrOUQ2SkNIZUFMQ0txT05tb0NhdjE1?=
 =?utf-8?B?QVBmUnpZcnRvY1dyWkZGaTIyaDgrd0xxYzZEcFFGWGFudUpiaVpTMWRGdVVj?=
 =?utf-8?B?T0lDb1JqNjVFRTM2Q2ZOOVhDOTJiK2xyeWh6QW1YRzN6RU9UaWYvV2lMNE1W?=
 =?utf-8?B?am5sRkVzL1Q3U0ExRVRhYW9rWVNtOGtzSEIxUDdBVHdpQ1lpbW9yRmpTcy9p?=
 =?utf-8?B?ajBHUlBOeWpLTXJiQXcwc2dMRGo0TkdTbXFpZjFqWElHUzFFVUY2eDVVZTJ2?=
 =?utf-8?Q?eODHtraqcklQrwNlhjRDTywuH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce149b23-f52d-4f97-72de-08dd77297a43
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 05:43:38.6223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/jNMuFcNQtkpgYNPJSgJS/R7UCHSu2L11I2BDF6/9NQQNFp/JY2h5MakWanTvBVniKWNZbGix3WxL4JlkSZTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6695



On 7/4/25 17:49, Chenyi Qiang wrote:
> Update ReplayRamDiscard() function to return the result and unify the
> ReplayRamPopulate() and ReplayRamDiscard() to ReplayStateChange() at
> the same time due to their identical definitions. This unification
> simplifies related structures, such as VirtIOMEMReplayData, which makes
> it more cleaner and maintainable.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v4:
>      - Modify the commit message. We won't use Replay() operation when
>        doing the attribute change like v3.
> 
> Changes in v3:
>      - Newly added.
> ---
>   hw/virtio/virtio-mem.c | 20 ++++++++++----------
>   include/exec/memory.h  | 31 ++++++++++++++++---------------
>   migration/ram.c        |  5 +++--
>   system/memory.c        | 12 ++++++------
>   4 files changed, 35 insertions(+), 33 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index d0d3a0240f..1a88d649cb 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -1733,7 +1733,7 @@ static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
>   }
>   
>   struct VirtIOMEMReplayData {
> -    void *fn;
> +    ReplayStateChange fn;


s/ReplayStateChange/ReplayRamStateChange/

Just "State" is way too generic imho.


>       void *opaque;
>   };
>   
> @@ -1741,12 +1741,12 @@ static int virtio_mem_rdm_replay_populated_cb(MemoryRegionSection *s, void *arg)
>   {
>       struct VirtIOMEMReplayData *data = arg;
>   
> -    return ((ReplayRamPopulate)data->fn)(s, data->opaque);
> +    return data->fn(s, data->opaque);
>   }
>   
>   static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
>                                              MemoryRegionSection *s,
> -                                           ReplayRamPopulate replay_fn,
> +                                           ReplayStateChange replay_fn,
>                                              void *opaque)
>   {
>       const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
> @@ -1765,14 +1765,14 @@ static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
>   {
>       struct VirtIOMEMReplayData *data = arg;
>   
> -    ((ReplayRamDiscard)data->fn)(s, data->opaque);
> +    data->fn(s, data->opaque);
>       return 0;

return data->fn(s, data->opaque); ?

Or a comment why we ignore the return result? Thanks,

>   }
>   
> -static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
> -                                            MemoryRegionSection *s,
> -                                            ReplayRamDiscard replay_fn,
> -                                            void *opaque)
> +static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
> +                                           MemoryRegionSection *s,
> +                                           ReplayStateChange replay_fn,
> +                                           void *opaque)
>   {
>       const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
>       struct VirtIOMEMReplayData data = {
> @@ -1781,8 +1781,8 @@ static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
>       };
>   
>       g_assert(s->mr == &vmem->memdev->mr);
> -    virtio_mem_for_each_unplugged_section(vmem, s, &data,
> -                                          virtio_mem_rdm_replay_discarded_cb);
> +    return virtio_mem_for_each_unplugged_section(vmem, s, &data,
> +                                                 virtio_mem_rdm_replay_discarded_cb);


a nit: "WARNING: line over 80 characters" - I have no idea what is the 
best thing to do here though.



>   }
>   
>   static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 390477b588..3b1d25a403 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -566,8 +566,7 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
>       rdl->double_discard_supported = double_discard_supported;
>   }
>   
> -typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void *opaque);
> -typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
> +typedef int (*ReplayStateChange)(MemoryRegionSection *section, void *opaque);
>   
>   /*
>    * RamDiscardManagerClass:
> @@ -641,36 +640,38 @@ struct RamDiscardManagerClass {
>       /**
>        * @replay_populated:
>        *
> -     * Call the #ReplayRamPopulate callback for all populated parts within the
> +     * Call the #ReplayStateChange callback for all populated parts within the
>        * #MemoryRegionSection via the #RamDiscardManager.
>        *
>        * In case any call fails, no further calls are made.
>        *
>        * @rdm: the #RamDiscardManager
>        * @section: the #MemoryRegionSection
> -     * @replay_fn: the #ReplayRamPopulate callback
> +     * @replay_fn: the #ReplayStateChange callback
>        * @opaque: pointer to forward to the callback
>        *
>        * Returns 0 on success, or a negative error if any notification failed.
>        */
>       int (*replay_populated)(const RamDiscardManager *rdm,
>                               MemoryRegionSection *section,
> -                            ReplayRamPopulate replay_fn, void *opaque);
> +                            ReplayStateChange replay_fn, void *opaque);
>   
>       /**
>        * @replay_discarded:
>        *
> -     * Call the #ReplayRamDiscard callback for all discarded parts within the
> +     * Call the #ReplayStateChange callback for all discarded parts within the
>        * #MemoryRegionSection via the #RamDiscardManager.
>        *
>        * @rdm: the #RamDiscardManager
>        * @section: the #MemoryRegionSection
> -     * @replay_fn: the #ReplayRamDiscard callback
> +     * @replay_fn: the #ReplayStateChange callback
>        * @opaque: pointer to forward to the callback
> +     *
> +     * Returns 0 on success, or a negative error if any notification failed.
>        */
> -    void (*replay_discarded)(const RamDiscardManager *rdm,
> -                             MemoryRegionSection *section,
> -                             ReplayRamDiscard replay_fn, void *opaque);
> +    int (*replay_discarded)(const RamDiscardManager *rdm,
> +                            MemoryRegionSection *section,
> +                            ReplayStateChange replay_fn, void *opaque);
>   
>       /**
>        * @register_listener:
> @@ -713,13 +714,13 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
>   
>   int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>                                            MemoryRegionSection *section,
> -                                         ReplayRamPopulate replay_fn,
> +                                         ReplayStateChange replay_fn,
>                                            void *opaque);
>   
> -void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                          MemoryRegionSection *section,
> -                                          ReplayRamDiscard replay_fn,
> -                                          void *opaque);
> +int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> +                                         MemoryRegionSection *section,
> +                                         ReplayStateChange replay_fn,
> +                                         void *opaque);
>   
>   void ram_discard_manager_register_listener(RamDiscardManager *rdm,
>                                              RamDiscardListener *rdl,
> diff --git a/migration/ram.c b/migration/ram.c
> index ce28328141..053730367b 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -816,8 +816,8 @@ static inline bool migration_bitmap_clear_dirty(RAMState *rs,
>       return ret;
>   }
>   
> -static void dirty_bitmap_clear_section(MemoryRegionSection *section,
> -                                       void *opaque)
> +static int dirty_bitmap_clear_section(MemoryRegionSection *section,
> +                                      void *opaque)
>   {
>       const hwaddr offset = section->offset_within_region;
>       const hwaddr size = int128_get64(section->size);
> @@ -836,6 +836,7 @@ static void dirty_bitmap_clear_section(MemoryRegionSection *section,
>       }
>       *cleared_bits += bitmap_count_one_with_offset(rb->bmap, start, npages);
>       bitmap_clear(rb->bmap, start, npages);
> +    return 0;
>   }
>   
>   /*
> diff --git a/system/memory.c b/system/memory.c
> index 62d6b410f0..b5ab729e13 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2147,7 +2147,7 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
>   
>   int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>                                            MemoryRegionSection *section,
> -                                         ReplayRamPopulate replay_fn,
> +                                         ReplayStateChange replay_fn,
>                                            void *opaque)
>   {
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> @@ -2156,15 +2156,15 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>       return rdmc->replay_populated(rdm, section, replay_fn, opaque);
>   }
>   
> -void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                          MemoryRegionSection *section,
> -                                          ReplayRamDiscard replay_fn,
> -                                          void *opaque)
> +int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> +                                         MemoryRegionSection *section,
> +                                         ReplayStateChange replay_fn,
> +                                         void *opaque)
>   {
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
>   
>       g_assert(rdmc->replay_discarded);
> -    rdmc->replay_discarded(rdm, section, replay_fn, opaque);
> +    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
>   }
>   
>   void ram_discard_manager_register_listener(RamDiscardManager *rdm,

-- 
Alexey


