Return-Path: <kvm+bounces-54578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE23B24695
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 12:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B14A887963
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 10:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC002D63F9;
	Wed, 13 Aug 2025 09:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Om3zzpPh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA845212541;
	Wed, 13 Aug 2025 09:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755079007; cv=fail; b=hKIHRskqGgKXykpD/4UF4+SNDSZ4+E3/h7gl06H85/rfnMfQDAepoAg2B+tXTx3G7mCp4RnKj3GwgQYd0tJqrCg0jjTVtNs4ThwPaBbJ8D0jVAshRTwKzYITc8m87+L9X8wLyFl3Gk2d6C+zEcauTpWveARmrfrfsxg4t3VSPPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755079007; c=relaxed/simple;
	bh=AAeH9uMK/WcqeBSQs8Nqo8am+xKOhCkiQQ0BYFt/2ao=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kuTzEHSVP+8hxJW4A6uCHo4E11WCDasrqrCfKJ0rfhsH6iFaOfXmTB3s+xGAHw5tMA75GE2wJlDivzMfyh3oTYod20IshQgKDTg12A552rrpMdCKi4KC3iZxUvJwChb/1QSAwkX21qZ/wKA0GNFa9ct6R9cNR8OTdHsAKEYZDDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Om3zzpPh; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cxg0Pkg/ADnphpIGLOSTnBpmP1pt0CiTGVGFut25P6dWoMUtrdq1rz8EcOrm78cDZ+sDrCkS9LQCVqOdp6wNk6BYXqf54xmPrQB91qwrwnU/Q8UP6jFAutXwjMJZFXv6GzE9wOYmuAh6XbdljeSArcPxh4M7khE1Y2XmWwCpn8bI4s5vAc7is2J05BOIpXegZjEfWugsBOlSMV/HdIrGnomm19X0juuWj2lzW/Czb1cRUc91E4QqKHa2cZJ08yAOdHRAcgCclJavxu6Dg6tuDxeRthFY6VAzemZROk+IEJfFW+akpi/YsV2ZjJ3liV5hToH8W5fwMrnJ6axy0icJOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsFu0wmg0yqMFFcI8o/AY7bsorGjOPB1QYmltEFyKck=;
 b=Q35WHE4hfD5S8dmIkcTqqPyZTJW1q8xsIkqdZMLtX0ioeJ3Ikc3NHujK6PQ4tpXOebgs1hm0uj3A1/TES7hkWraNyoWhhO9Rq2Ra/8ui7u6X/heY8DLQmH7a0iu4cxFkdsOrw7GLArvR8UPh28lj5HBTF13lMrqB0oUmO433KviZvqOqbmNAS1GWfz5ZR/CjrdmYCYmZ1QnPv2rz1tC1IKQbFc1RS0+wYcghtb+GSUxf/yg3KE5y+WEega6Rgy/5Xx8eb/ffPWKBp6p1LHNQ/hnScWdlFyuUpTDZNu2IApc/oel9EgPWTbbsZAKjLq4Yhvmvl+jSokUgH0D2isKfow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsFu0wmg0yqMFFcI8o/AY7bsorGjOPB1QYmltEFyKck=;
 b=Om3zzpPhvsGha4e0h6LbIHHCX2Lc65JoGsRZRQZwRIn8dQBIfQQj3zEeYJ7Xs7++ahw3IQm1ww1B9tZQcXsskDHO3cqw7RG8/2PCVFRP8Si6emgA0h+fxQI6dW1fQsx7DMRxX7+TPB3K3JqNcL3JQ8j8akGYz+O6+fsTjLNbh8g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by CH1PPF73CDB1C12.namprd12.prod.outlook.com (2603:10b6:61f:fc00::615) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Wed, 13 Aug
 2025 09:56:43 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.9009.021; Wed, 13 Aug 2025
 09:56:43 +0000
Message-ID: <ebd33ad5-6a22-4155-9525-87937ee3c4e2@amd.com>
Date: Wed, 13 Aug 2025 15:26:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/44] KVM: x86/pmu: Snapshot host (i.e. perf's)
 reported PMU capabilities
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-18-seanjc@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250806195706.1650976-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0015.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::32) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|CH1PPF73CDB1C12:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f22b3ef-003f-43d9-b03d-08ddda4fb4ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S084MU5reHJOMUVidEw5SDdxZTA1dWV2Qk1JUWxkeTNiYzhjVWJsZ1d4QXk1?=
 =?utf-8?B?VXFpaWJjZzBmdGIrTVY4bEk4dVhJQ3piSzRZNU9XbEVONDR3K2dTNFVESXJo?=
 =?utf-8?B?eDJwZGhVeUNESUltZEh0aXRQTy9KSFRpM2VGSWp1SXhCQkl5VUhEaU1VSnMy?=
 =?utf-8?B?YTBNdVhQbXV0anlCS05ZT1J3TE05amxDL2VBWWlrQWVDbTlSa2czUlppMnJn?=
 =?utf-8?B?ZDRieG05TTNkOEoybEdGNjQ0QmFxcjUwUUFZVi84OVRLQ25TOVJhRm84RmVP?=
 =?utf-8?B?dmoxQnorOHE3RXZBQ1YzdHRBL3FyQThid0EyM0JoTEVDdnZ1RVNxQWhIOW03?=
 =?utf-8?B?NW11eGJ6dm5udUVaTVA5bHFqYVlWcUVVbDdVVThyeWU2KzBhWS9hUFhkRnpC?=
 =?utf-8?B?U0tuMW1wcHNPWGxSNkJPZmhPYjRjSTNOT0lLdDFMc3R5b2w1NUNWUzdldFFm?=
 =?utf-8?B?ek50UXRUMXc2RDkwcVNVb2VrbFZtZjhVNkVLa0RLU0d4UjNmbnk4QWNTMEVR?=
 =?utf-8?B?bitRczg0TjNmZUI3UWM4YkFZVXMvOE9Uam12cjc0cGUxTGhIQXF2WjJUeHZi?=
 =?utf-8?B?SFNRWDdKRmRxU1B4ZlRDbGEzODZCOGdLaitIa2xoSWhERGIvYllEOUNpRGxB?=
 =?utf-8?B?dEJnYmNNMTdnYU1pWGt6Mm9qWGxYQUZhQWxKREIrVzZmTHpha2NvcGxNRDky?=
 =?utf-8?B?bVdnUTFsZkdpdFc1T2Nray8yU1l4UWNmalZ6RDM5a1E2T250UHJiNkt5UURL?=
 =?utf-8?B?NmVuNHpSMGx5dko0QVFqM2N5OTg0K3JmbnZWNUcwQ0FBZzM0c085VEU1QWtm?=
 =?utf-8?B?cVcyaHR3NXc5ZUdpZlZyd2I1UDhKMmJvdEhNYWQ3STk1NkoxeTdLMlJ4WHdU?=
 =?utf-8?B?cmNnNTA1NkF5OVNVQk5HVm5NVUhybDA5RnJIVXRobWsrSFBLMWI4LzBoa0lM?=
 =?utf-8?B?WnQvdWxWdnhMZExHWStSaFpPNUlQbGRDM0RDaU9WRmgxNnoyVDhyWi91bXRr?=
 =?utf-8?B?MndMS3pxM0IwNE5CNmU2T0JNc1ptcUhaTHRQWVRWNWNPUGROdlc1dFZXdklh?=
 =?utf-8?B?eC9YUmVhOWdpVUFjUlRkTFp0ZnFsenR5Um1TT24zNzJQSVl6dWhxRUxXSGFW?=
 =?utf-8?B?dytPRUprWHZwYlNkUlgxcjEvK0xzOWRDZ0h0YjIxRWV6WWUwMWZwR3lLa2FX?=
 =?utf-8?B?Wjg5U0E3SzhiY1dXS1FSUkVtUnJNdUlyZ2NrT3dYMkdLNENGa05TUUh2ajZu?=
 =?utf-8?B?SWM4M3Jid2hlWWVMMGY1aHpkWFNSZDlIMjQzK1laczNOWWp1eXY1NXd6S0gx?=
 =?utf-8?B?WFNZOGxmam81aWV2c1I5a0k4YmtxNWdBbUdJaUZDR3hzVU9HeWlMZ3ZjSmVa?=
 =?utf-8?B?LzJzWHNoemtNZk12dEpxKzhqMitDbDNnbEx3VGhyYW9kMzQyeHo1aWVBSFp3?=
 =?utf-8?B?UGluOTlVTkhvV3VKaXJROENMSzQ2MzBMSGRoTG9rL0dCZkNUZk5RemZybGV6?=
 =?utf-8?B?dmFpZTZBTktGOXpCMEpiSGZhVmtIbU00UnNBQVdDOWpMZko0QTBIRENCdjVi?=
 =?utf-8?B?TTRKSVA2bUNtVzdSQTR6dUpyblQ4TEw4OWFmUGxNYkFpL0haOEw0NlBKeUQr?=
 =?utf-8?B?Qmc3U2VaS2pUdVBzT1V2bjVaNU52bkY2N3psTmtnMkd5Z3NxNk9MMHhwdGVt?=
 =?utf-8?B?VjQvOUpsblltS2lXRXAyMGE2K0ZVSURTN0xsMDRzVEx3MVlxRVUyR1RMRDV0?=
 =?utf-8?B?RTVEbkRZYVBoNEFrZXR3RWhQOERjdVo2eGpSWEQwdko1YlNjMXhEU3grTFVW?=
 =?utf-8?B?OHVSeWxmMGd3Y0IrWjNQUm1WT2d1bXRsL0I1aGlyVUw0THhJM1BibnpQWm9T?=
 =?utf-8?B?SmVLRi8zQ3RZL2VUa2FWcm5LMlUxWGxxeHI0cFZHSmdHc2RvdWk0ZEN6ZTAy?=
 =?utf-8?B?azVqMVNyZnhvcTZ6K2x5amVLM0FRVXJNSTdEZlBJZlVZT2h2TWlTTzRsRHQz?=
 =?utf-8?B?TWFMUHNqMG5RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmFmeHJjRTk0ZEF4K2VJSmJrVEEwNGNrVm1JanRXUkZVa1lDMmhINldhcDJk?=
 =?utf-8?B?UjlCR2RrcjhwWHZJM0dXU2pUT0h5UlhKSmxmcStCZ3dLcVVvRDBvZ1loRExv?=
 =?utf-8?B?bWM1M29pQWpiNEloeml0dHZCNFBVS25peVZGQnk0SkN4T1NSRExtT3gxNXh4?=
 =?utf-8?B?MDkreXBoZThUNHExM2cvOTlXZ1JKQWhnZ05LR0ZKRWx0akdpU2pZSXdBczZl?=
 =?utf-8?B?OEJXU0lYUUZJdi9vZ1dWZkpLU1pmbHlWNFVXWENnT1FOc3pRbzlHNGpnYVFL?=
 =?utf-8?B?My96cU94N0Z3R1l6T054Wk01TmdIME01Nm85alg4MFdEQjRsTHpwTkhRZGZ5?=
 =?utf-8?B?WFAwbEJwMFVOUlBWWE1DKy9YL3VaL0tQOTJiaFJKaFdidDNHdTdmTW1PM01w?=
 =?utf-8?B?Wlo4RWp0ck1FdWZxUjZFdEdKSUJiK0MzL0hlL081M1NqYmMraks0YVhkTUt6?=
 =?utf-8?B?cmhqM3dmUGJCUnNkbThsc2EvN1FsbTdmWVpqa3U1YzVJdFAzUW5JZkplUTR4?=
 =?utf-8?B?UElhNlpva0VpV2pzWkJxNDBwSC92NnVjcGl1a0ZOOTRPcDFhTnZrbG13QWxU?=
 =?utf-8?B?RHRmVjFkZ1RvRDJNZXhFZjdMd3pPUUlRQzlKOWJuQmtHV2k4ODdyNEMxL2Zu?=
 =?utf-8?B?VjhBR0FkcmZUTmdEVmtyR3ZsTGRrZUR0UkkySElGenAvTkp4WWJDeE5WRlFa?=
 =?utf-8?B?dndFUkgyMCttRXd2STBrbTcwR0R0bzM0VnlqeDAyOXBYWlM0NEUzeEhsUGZm?=
 =?utf-8?B?UHg4UXA3TGlabzdJOWF6UTZjaDZxcjZRbStZa05FbjQwS2p5UXloUTM4S1ps?=
 =?utf-8?B?QlVIaTZhZm1xUXpXQkRadXBTSCtuSG1VbUl6a2E1WFVuenhMQWM2eUhrejA5?=
 =?utf-8?B?KzJoNWE2djBCdlRPUjlTWEIwa1ZMZjViWjgwVE9kVWJXWUhKc3ZtUHNqOUdp?=
 =?utf-8?B?QzUvWGwyRU9xeithN2l4MFlXajlFNzRuaW1kc3lJVEdZZGhmQnluNGVndXVw?=
 =?utf-8?B?eE5EMklRZVlvT29veXhzS3lpR2RVaUlwdjNKcEJma04vZzJBZ1RieXdFb21H?=
 =?utf-8?B?dDVINU10Zlp4WFV1QjIvYjRJdzliTVRsQ1BZVFpERmVndUs4UGtFcHlBcWl3?=
 =?utf-8?B?VTJvSjdPdCs4YVpIUXFxZnpxVmxETXI0ME1leG14ZzFNaDFZdXpGcVRSWFdu?=
 =?utf-8?B?cjQyU0dhbzYxWW1YdDZ1d2pLVU56M3lLdlNxSzZNZ3pFb01Nd1AzbnZ5NVIz?=
 =?utf-8?B?OW1udFF1QUpZNmkxQU4vRXRTbUVsWngwcnY0NWZEaktoVVdiZjJGWlZvRmlM?=
 =?utf-8?B?QktnT01va1dHNWZzQ0pFZlhIQ1lqN0J3enlEUTRKR21BZnJJOStZbHFXbzd1?=
 =?utf-8?B?QmtyR3RkUmcydUZiU2JQbTcyNHdKS20ralFWeERGRjNvMUVXeU1RTlc2bFEr?=
 =?utf-8?B?LzJYc04yMG5wb2NndmdLazRuOXFTVFQ4RkxxcEhkQWJQZERSdWU4YXg1L01j?=
 =?utf-8?B?aFNsWEVSakxKRjl1OG9GVlAyY04reHJnaUtrNGszSEZQUnVxZm5PNFZIUWor?=
 =?utf-8?B?eHZJZmlmcVp5Tkg2MzRPa3piSjlDVFI5UmNlNnlOZTNuUEpiN2p4ZkduaS94?=
 =?utf-8?B?cWcvbkpnalBmVy9FWXFWWklTT3JDeDA3ZlZBZ0ZlUC9YdVc5OFpHZVBWdHFo?=
 =?utf-8?B?Zkp1ajFzakRnRHhxMURISkhwYUQ2VjZMNmcrMDRaQXRBc0E1c0QrMWN2QnQ5?=
 =?utf-8?B?SmFZMXVtNlk5eWJicEpLTXdnbXR1ZnVNb1dHaWE2aG0rdUhMWWJDdjMrYW1w?=
 =?utf-8?B?Qm01K0ZQZXVKcHJUUlhsemZXWHltaXhRakhjOFZXL1M3b2haT2lGNGFpRlpo?=
 =?utf-8?B?OUFMdGZtbm9xbE9RSVdtRll6WnR4SHFyZjExV1Qrd3ozUXpmY21xa3RRNXh0?=
 =?utf-8?B?K3FHZmdiOFpJZlhhNFVsNjlmQUk4MnUxaWI1ZEdPSFI1YWN0WXNuSW40d3Rm?=
 =?utf-8?B?MUpBZXhyK0lvcGdIVUhScm1uL2JmVTdxdWFPeEx2MGlvLzNaUGhocGhETlZq?=
 =?utf-8?B?OGVsQnduaTRyb1BWZ2duaXk5SzhoS0d3WHJsQUQ0TTk1UGFGcFNIYlFsUHVp?=
 =?utf-8?Q?sMtgvcB8x8yOjMv6pslJxvVG2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f22b3ef-003f-43d9-b03d-08ddda4fb4ff
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 09:56:43.5134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmmTJoo9+tyQS0EhnZuQhXWLly+WVVTwNHnFbeTkF/+siOTyGqTP0UM1CnYPSXG+RYfP9FYvaRvrRALNECPJng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF73CDB1C12

On 07-08-2025 01:26, Sean Christopherson wrote:
> Take a snapshot of the unadulterated PMU capabilities provided by perf so
> that KVM can compare guest vPMU capabilities against hardware capabilities
> when determining whether or not to intercept PMU MSRs (and RDPMC).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/pmu.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 3206412a35a1..0f3e011824ed 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -26,6 +26,10 @@
>  /* This is enough to filter the vast majority of currently defined events. */
>  #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
>  
> +/* Unadultered PMU capabilities of the host, i.e. of hardware. */
> +static struct x86_pmu_capability __read_mostly kvm_host_pmu;
> +
> +/* KVM's PMU capabilities, i.e. the intersection of KVM and hardware support. */
>  struct x86_pmu_capability __read_mostly kvm_pmu_cap;
>  EXPORT_SYMBOL_GPL(kvm_pmu_cap);
>  
> @@ -104,6 +108,8 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
>  	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
>  
> +	perf_get_x86_pmu_capability(&kvm_host_pmu);
> +
>  	/*
>  	 * Hybrid PMUs don't play nice with virtualization without careful
>  	 * configuration by userspace, and KVM's APIs for reporting supported
> @@ -114,18 +120,16 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  		enable_pmu = false;
>  
>  	if (enable_pmu) {
> -		perf_get_x86_pmu_capability(&kvm_pmu_cap);
> -
>  		/*
>  		 * WARN if perf did NOT disable hardware PMU if the number of
>  		 * architecturally required GP counters aren't present, i.e. if
>  		 * there are a non-zero number of counters, but fewer than what
>  		 * is architecturally required.
>  		 */
> -		if (!kvm_pmu_cap.num_counters_gp ||
> -		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
> +		if (!kvm_host_pmu.num_counters_gp ||
> +		    WARN_ON_ONCE(kvm_host_pmu.num_counters_gp < min_nr_gp_ctrs))
>  			enable_pmu = false;
> -		else if (is_intel && !kvm_pmu_cap.version)
> +		else if (is_intel && !kvm_host_pmu.version)
>  			enable_pmu = false;
>  	}
>  
> @@ -134,6 +138,7 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  		return;
>  	}
>  
> +	memcpy(&kvm_pmu_cap, &kvm_host_pmu, sizeof(kvm_host_pmu));
>  	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
>  	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
>  					  pmu_ops->MAX_NR_GP_COUNTERS);

Reviewed-by: Sandipan Das <sandipan.das@amd.com>


