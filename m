Return-Path: <kvm+bounces-54574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 961D4B24626
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 11:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63AAF1BC7150
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 09:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E07B2F546F;
	Wed, 13 Aug 2025 09:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2plrLN+I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4C22F0C7B;
	Wed, 13 Aug 2025 09:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755078327; cv=fail; b=FyoiFgKN9CNgpc3xiXznp0X6e59aNKYxbywZNXCyTK7yYsENmpVKWVZm7HqHQFx5TyoGJmPFpiIojz4splXZUIfDH1VoTXYAOOHXz5wQJKY2jU664q/qYbuOK84V7ZLyTaQrEE6x6VCiits8TgfIFAmT1BCrg3padeqnxiGDj98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755078327; c=relaxed/simple;
	bh=xtm+46TPrLtYNwKgrXcqlWCDNWWklINgtCFZkougcdA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rr9w9G5JM0aBV9v7f/RfRb0Vu5F61BnhJJaSNqfd4a7idqOXaWgfTZgxE/53k/1JtLrQ93Ezqb0TVxBeDIiYZFZEBZ8w7QE3vMoguN1fv/QhuXLjNt5pkBvOSLKbukMkiUJPkgnShYbPMKJG34L6rsJFOu1Je5FKLB+fyy25Rzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2plrLN+I; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQDV/YPDsgOo6EYKcJo3qfS9mwtuwxBEqUPM8cuyiJFJQtHH85Qgp8V63LPFzv/TkkU1PbRX2fwqT6kXj1maT+x8j0uamaQstg/p80VQsbHyROw5SyGFXZD+l1zOeR4JqO5g3WDttkjEeNSTsJ3U1We1/I422H91bXVovbQ74TVaFzHyE+i6OjAnAOb7ORm4y1rBHSpdXwUzKPW9NfPqcXp6ZqMwhNDlPtdTzmv8Yuz+WeY60U4whOhIqfjR1MLdNwT/N3nfKqauIxUmvE5dFuT7VWX9RUfEPxywBrS+D4YoYkP4Gv48tFB7Hd2dDqtalgInwTFwKKq6KTSagQ126Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBfJsMhQ0i4DRO0Kssp0QO1kb/Mn7gusEwwQERJifZk=;
 b=X3Z6S4vFaQ9+GSdrySKjb5A3d2BQN5tT9c9sqNueGDIWKMdYvYaeuXyZ/2TPkEnaP4zHaoqNWlb9L5r3hzz71fEShB0klfXOUcrxvehnpGhj17Izmb7/K2Zigo9Z7HxKOTiRTJc1ZlQlFHxjJcWbIyMUhvNCzmegHScr2+oprn05M4KUn62lU5biMCyHbl0DTz17+Wq5OJSp9ZN81nw+jT6QqWUBwQcXJlBIbI5sDmS2ovV8Vdgfg//2cynuDYD+54Dkk9n7+ZuBtW7+AbTkAEgvXTvFu22mdmdFX2fn4AfzRQeAcFTjbBtFDdnetCnLJ++ceCfHx2UjdXwQVlvTrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBfJsMhQ0i4DRO0Kssp0QO1kb/Mn7gusEwwQERJifZk=;
 b=2plrLN+Ixc5sNWiYxkqgpSeNe3V7a/oNrQnnmxoAZ+J2nVKmTkcJge3JEm8ZYlCPmq7tdccrJvn3MzMYU6XlTR36/Q+lczY5OByWvVr6vkHDj5VHOOPgCx6jbhRitkzd2s2B3ExpzLgL3+qGjAbEGnY2cNsMaYbs5c0rbEuqXIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by MW4PR12MB7438.namprd12.prod.outlook.com (2603:10b6:303:219::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Wed, 13 Aug
 2025 09:45:22 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.9009.021; Wed, 13 Aug 2025
 09:45:22 +0000
Message-ID: <7df64e7c-73aa-4296-9879-cb97047823bd@amd.com>
Date: Wed, 13 Aug 2025 15:15:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/44] KVM: x86: Add support for mediated vPMUs
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
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::20) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|MW4PR12MB7438:EE_
X-MS-Office365-Filtering-Correlation-Id: adb187d6-1272-4026-c899-08ddda4e1ef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3VHbXFGSWNuNkhBUWZNVW1wZXFzSlh6VXVUSjEzdkpWNWpwWVdESmhCdVlD?=
 =?utf-8?B?WEJabHVuUGx1ZTF1dUpNWXBaa0RNUDRSWTkwa00yclQ0MU50L1p5T1VkOXBi?=
 =?utf-8?B?Y2JyOE5BWFFyb2RQazcyY3k4MEx4cHZ1R3NEK0FkS09Cdm5iWFBCMnk5bDlX?=
 =?utf-8?B?eFZ3TzVGL1JmSy9hZnhZUDN4OVlhMlZUYVdtK3ZPeVZQUENtVmFoMDJiOC85?=
 =?utf-8?B?UWs3bkRoZlpOdHlPZWNSRENKT3BKeEhwYWNkSnIzdEZhSGFvWU1IM1B4WUF6?=
 =?utf-8?B?cEtEaDdXcE16cjBpUjd2ZG5iRXM5RWNvc2pDRjVScTY2bE5iY0hCYUJ3SjJj?=
 =?utf-8?B?ZS9pR0U4MEZUd085bzlxZXBJMmtBMnVmOTNyTkdKRTFEc2ZldTNDS05lMnJS?=
 =?utf-8?B?eFd3QkRwZi9kWkxGbXFtRlNDVnFSZDVYYnZJN293a2kzakRxVlhUa0w4NE9M?=
 =?utf-8?B?QTZTKzlzUmlIWkNwREFqNlU5dDN5c2pJTVQ2QXVyOURIQVlxbUpjUWVCYTJt?=
 =?utf-8?B?MGpRblRONHJwZGdtbFQ1MmlLYnVPT3lWSjZGamhjQyttS2NZc3dQQ0JmVnFv?=
 =?utf-8?B?d0l0QXZUSTJyamNqQnhVbWw3ZnhvSmVObmlOMytsNkdjclFSQnpKSUVaQStQ?=
 =?utf-8?B?UDRLcnI1NldOZ01JRlpGeUtMU29odE9qMUh4OVpncC9uZ0RYaGVrbVFVS0JH?=
 =?utf-8?B?dHZFMWNudy9wbkEra3VEVDEwR0lENW05RmhmUGhOOGxNZGtaZ0d5NHg0QWFY?=
 =?utf-8?B?SjhvMlRITTNqaEtLTUN0TGF1NDFaSXYvUFRTQzZFZ3NNSlFMRjAwOUZIRzJ0?=
 =?utf-8?B?WFRDMU56cUJqNHBCZ1UwbW1iTisva213MnlsY1lDR2FLbW1vSzBsa0hhM1Nu?=
 =?utf-8?B?Wlc4cHRQVkRhVk1ZNVJ6R3ZsYjIrZ3B2Ti9vU1NDNG95YTVHN2V3cW8rUTZQ?=
 =?utf-8?B?NjArekw1Qlgwc3I3L1JubXpFRW5VRTg1YUo5SWtCRnJreEhuR3BsemdHU3FQ?=
 =?utf-8?B?Y3ovTndITGxXd1BSdU9OdnUwd0FoOHE4cTI3L1hQdk8zcktvcHdpOHk0eGxG?=
 =?utf-8?B?L08xN0tWbk5EUVdvbW11TndLc1JVbVZHOUJOeUZlUS9wbWRoUEIwNWF1VzNI?=
 =?utf-8?B?am9BNG5MUFlCdnNpcnRRRm02aWo2OG1hVjBINzE3NGZWazFDMk0wR1h6UktC?=
 =?utf-8?B?T2xMaTNCNHdkSU4vR2M0eXEzNXJETE1RbENTWWJHOUVXdy83Z1lRVExwOC81?=
 =?utf-8?B?bjB6QTdaQnRJemtmRzBCZS93S1NXOGxSZHZFVU9nN0gzbVRVTDBWTGhBdjQ3?=
 =?utf-8?B?VE1PMFdEQnBzczlvS0tqdEMzUlB1d2wzSmlFd1JFT0RuWHEzbm1xOGxSVEtE?=
 =?utf-8?B?OHMrSFYzbGIwdVBKYk00RlJtMndjZE13RXl5WEs2dkpObUdsT2JDZ2ZXbkRi?=
 =?utf-8?B?cVRGZ0IrVzlEdzFrMWp5SG8wS21zK3h3bjE3UDlFNmh2Y3FiWTFxdzZxdHVI?=
 =?utf-8?B?cy8veXRoOGpYOHROck5lbmFEdkRGcVZFRnF2UmJsTEUvd2o2WTZSd2NGUGFx?=
 =?utf-8?B?NC9Ob3hOTnpkOHJLM3ZXVnl0THFMcVk0OWVYM3YyM0syb1k3Wk5ORmFlazFj?=
 =?utf-8?B?a2dqUmxsSHYwb2hMckpUVkdzbTd4cUNXZkhvWURybkMwcVpxUEtXbUx5SDEz?=
 =?utf-8?B?eTVmTFBRRGYwVzBVakx4Y2dMWjJMaUhDYVN0L2U0UGQvZmF5NGhKTEgvSExn?=
 =?utf-8?B?eThicWNjelRWRUFPZlE4T3hITEdNQk5PTWZWQmphVVVva25nOTNZeWVZUzg5?=
 =?utf-8?B?dFFyMlNHdUdIY1VrcGFhZzRrdUplSEE4TkhmQnMwK2Y0NUloUkFTV0lUdVd6?=
 =?utf-8?B?NlpzTmhkTlNXWHNGaWxUZkpjMndHVEtEdy9uTG9LRGpvUFpzTlhMZVVCMmhw?=
 =?utf-8?B?VXI3UGFna0ZsMWZzTEhSVm5xbDVZWWJxM3JmaWM4bzVsM0dueXRNbVVmdHpX?=
 =?utf-8?B?ZzNLOTVNNHZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2tST2NVaDJRajBaOHlGakp0L3JNTHA5R0VqdDNvY1R0Tk9pV21lRGpQUW1i?=
 =?utf-8?B?VUg3d0ZsTmkxU3cvYlRKcUJWSkRuampoZmtaKythQ1JEK2RjQVNkcnNxRWd3?=
 =?utf-8?B?Ri8vQTRhWEI2d3pFQzU5YXQvbGMySmZMVkYyRnpUNS9WSkYrc2NXNEtSTFRW?=
 =?utf-8?B?VFBpbXRrUjJ3RXIwK1cvdHExL0ZoaUpxRlg4U2Y2R09xYkg1QTdDTVpPaUJV?=
 =?utf-8?B?bHRjZC8vNlgvUGUwR2RwdnFCZkNQbURobmhkZFE5VklCWWQwWHF0U2JWTTNT?=
 =?utf-8?B?Y2NGTjYyK1pLdW02aHF1bGlvZWpIMldmdzhKUlJoUUxYbXVWYXdvVWRjT09M?=
 =?utf-8?B?cThydGQwWTJRK1daKzJDMm1wekNDMUprVmxJbzFCbXJSSDlqZ25ZcXpEdDFG?=
 =?utf-8?B?NFhpTk42dThzRnlpZ0ZDdks2WVhpUis1TFNvSkxPSjU3MTZGbE15VC9aZWVE?=
 =?utf-8?B?ZllTM2lpU2k0Q2s5MHBQSTBEOEtlbnk2NnJDUUFRVFRqSXdWbDZFa1ZlTTRx?=
 =?utf-8?B?aCtYY0VQNldCYW40OXhIQ1VmTmhKK3RkWHRhVHMzaFdLN0hSQTNCdGRualpl?=
 =?utf-8?B?YjRVQVA3dTJSYWJFUTRydUwrYmdWaURHR2RxRU4rTUZsa1lldzlxRG1Samx5?=
 =?utf-8?B?R0JSS2YrM09Gd1ZQN2FyeHhkZnJ5eURYejc4MlRyckx1aFJQNVQwR2ZtSGJQ?=
 =?utf-8?B?bytWV0NYOTFYdEpSZy81RW9wTi9WNjhUTnI3SmR6VjNwaTNKamJGT2FVVWs4?=
 =?utf-8?B?WXdsc2xTUVA2RTlnZVBTQi9Ld3RFWElwSTBTR0ZkMTMwc1Yza2pJeEFuNmFi?=
 =?utf-8?B?bDVjQUUvaGloaitqaTNLSzJDdTdka0x2ZVMvSk40dVZwQVRINWxsb1E0MzF5?=
 =?utf-8?B?dEg1YVo4S09pcWlqMlpwTjRLU3VBQU9Pbzd5eDMxTFdUZGdiMU9TRGpFbFVW?=
 =?utf-8?B?eWlBaVAvajA2UmZzRldJbHdjaVROWU84V2ZOV1lRU245UGY0VGhLeUtTNDA0?=
 =?utf-8?B?RmoyaFR1NklJNStEa2RkMWRkN0EzR055SW1BbVpBZElYTERiSUhmZ1VjVjlQ?=
 =?utf-8?B?dnBUbUhQMnN6YXdncnVMQUtCRkJmUmpUeEE2SnVhSE94UFVMVVUrcVlTa3pi?=
 =?utf-8?B?T0ZpcXkraUtkSmhDVnNYM0IvVU1idE5tRzBIajRWaUF3aHVKUGJ2dGdhS3R2?=
 =?utf-8?B?OVZXKzVWUmpjWDc2YldzRVpGSDYyaWtJRHlZM3plTGorREtybnlqanQybXE0?=
 =?utf-8?B?UGxOVVRJNzNjaUxMZmN5bld5cnErWnF4Uk90Ujk1US8rWDJXdVdZUVpTTlVJ?=
 =?utf-8?B?NXJ4NHVRa2MvbzI0WTlBaUJoOVBVWWpqZTR4anFDNmVpVE1memhlemZUVkh5?=
 =?utf-8?B?c1ppYXFYN3BsNTJyVjVmVUlsdmxhQ2Z5VG5wVjd6Z211dXRkdmZVTG1RejVu?=
 =?utf-8?B?a1lUOTMwSC9jSUNoUVc4REt5WHdPemQvREFmbEhTaS9McGNkNThvMTg0SkxH?=
 =?utf-8?B?U201SDVDVXpFQ3l3aTFjUXNDYmVzakxvNVVoQmdqbTh0OU40c2ZpZWZjMnJy?=
 =?utf-8?B?L2xqUndZUW54bFNvSlBCMW1qMGFITGRicWZScVNDS3AxSEpnMDg2NTR2VkVz?=
 =?utf-8?B?czBrMWk1STFUZWJ6enAycSsvVWxhTUtIRHhKbXBWNmxiUmxWVnJSUkUrcXEv?=
 =?utf-8?B?a3VqZVpFK25vaVlzMmxIUlR2dkkvdWFNcU94TFpxdUpwZE12MWUxVmR5RllL?=
 =?utf-8?B?ODVHTHVQUy9yQU5USEZiRklUd2NLcGIzRjgrSzR3bk9vWEVKL1kyblFNbkJ2?=
 =?utf-8?B?ZURMd3I3QzNhQjdzV01ha3pXU2cyS0QrYzZUSzVaVm9McnNPMDJMMU1yb0Zz?=
 =?utf-8?B?TUpDWGRBeFNOM0o4ZlgvYS9mQ2wxYVpDRUVGL25Gd2FrS2FDUFlKS1dCUGxG?=
 =?utf-8?B?OTNxZ2M1U29ZTVppbTJ5ZW9KSThmbXU1YkpjSkpWeHNKWXpKK1FhWTV6THFp?=
 =?utf-8?B?SitPYUdEKzlHUS9FL3k2Mm9TaUtXY0RLQm55R21rTm55dVprQmhxbEZNemZs?=
 =?utf-8?B?QXhUQ3pmejQwSXpzek1KOWlhMit5S0ZDUWNZVmRyY2V1ZWp3NnI0V0F4OUNl?=
 =?utf-8?Q?cfKPvywWpshEFaBehOSuiOBCy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb187d6-1272-4026-c899-08ddda4e1ef2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 09:45:22.2047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xn1BHYGqYyiJW1R26sNSxeWZU+oW42oWzI1F779mnymB+F1koheKvlo1AM5SBUPNqdAF0P/DZr0BwoZm+1dGdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7438

On 07-08-2025 01:26, Sean Christopherson wrote:
> This series is based on the fastpath+PMU cleanups series[*] (which is based on
> kvm/queue), but the non-KVM changes apply cleanly on v6.16 or Linus' tree.
> I.e. if you only care about the perf changes, I would just apply on whatever
> branch is convenient and stop when you hit the KVM changes.
> 
> My hope/plan is that the perf changes will go through the tip tree with a
> stable tag/branch, and the KVM changes will go the kvm-x86 tree.
> 
> Non-x86 KVM folks, y'all are getting Cc'd due to minor changes in "KVM: Add a
> simplified wrapper for registering perf callbacks".
> 
> The full set is also available at:
> 
>   https://github.com/sean-jc/linux.git tags/mediated-vpmu-v5
> 
> Add support for mediated vPMUs in KVM x86, where "mediated" aligns with the
> standard definition of intercepting control operations (e.g. event selectors),
> while allowing the guest to perform data operations (e.g. read PMCs, toggle
> counters on/off) without KVM getting involed.
> 
> For an in-depth description of the what and why, please see the cover letter
> from the original RFC:
> 
>   https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com
> 
> All KVM tests pass (or fail the same before and after), and I've manually
> verified MSR/PMC are passed through as expected, but I haven't done much at all
> to actually utilize the PMU in a guest.  I'll be amazed if I didn't make at
> least one major goof.
> 
> Similarly, I tried to address all feedback, but there are many, many changes
> relative to v4.  If I missed something, I apologize in advance.
> 
> In other words, please thoroughly review and test.
> 
> [*] https://lore.kernel.org/all/20250805190526.1453366-1-seanjc@google.com
> 
> v5:
>  - Add a patch to call security_perf_event_free() from __free_event()
>    instead of _free_event() (necessitated by the __cleanup() changes).
>  - Add CONFIG_PERF_GUEST_MEDIATED_PMU to guard the new perf functionality.
>  - Ensure the PMU is fully disabled in perf_{load,put}_guest_context() when
>    when switching between guest and host context. [Kan, Namhyung]
>  - Route the new system IRQ, PERF_GUEST_MEDIATED_PMI_VECTOR, through perf,
>    not KVM, and play nice with FRED.
>  - Rename and combine perf_{guest,host}_{enter,exit}() to a single set of
>    APIs, perf_{load,put}_guest_context().
>  - Rename perf_{get,put}_mediated_pmu() to perf_{create,release}_mediated_pmu()
>    to (hopefully) better differentiate them from perf_{load,put}_guest_context().
>  - Change the param to the load/put APIs from "u32 guest_lvtpc" to
>    "unsigned long data" to decouple arch code as much as possible.  E.g. if
>    a non-x86 arch were to ever support a mediated vPMU, @data could be used
>    to pass a pointer to a struct.
>  - Use pmu->version to detect if a vCPU has a mediated PMU.
>  - Use a kvm_x86_ops hook to check for mediated PMU support.
>  - Cull "passthrough" from as many places as I could find.
>  - Improve the changelog/documentation related to RDPMC interception.
>  - Check harware capabilities, not KVM capabilities, when calculating
>    MSR and RDPMC intercepts.
>  - Rework intercept (re)calculation to use a request and the existing (well,
>    will be existing as of 6.17-rc1) vendor hooks for recalculating intercepts.
>  - Always read PERF_GLOBAL_CTRL on VM-Exit if writes weren't intercepted while
>    running the vCPU.
>  - Call setup_vmcs_config() before kvm_x86_vendor_init() so that the golden
>    VMCS configuration is known before kvm_init_pmu_capability() is called.
>  - Keep as much refresh/init code in common x86 as possible.
>  - Context switch PMCs and event selectors in common x86, not vendor code.
>  - Bail from the VM-Exit fastpath if the guest is counting instructions
>    retired and the mediated PMU is enabled (because guest state hasn't yet
>    been synchronized with hardware).
>  - Don't require an userspace to opt-in via KVM_CAP_PMU_CAPABILITY, and instead
>    automatically "create" a mediated PMU on the first KVM_CREATE_VCPU call if
>    the VM has an in-kernel local APIC.
>  - Add entries in kernel-parameters.txt for the PMU params.
>  - Add a patch to elide PMC writes when possible.
>  - Many more fixups and tweaks...
> 
> v4:
>  - https://lore.kernel.org/all/20250324173121.1275209-1-mizhang@google.com
>  - Rebase whole patchset on 6.14-rc3 base.
>  - Address Peter's comments on Perf part.
>  - Address Sean's comments on KVM part.
>    * Change key word "passthrough" to "mediated" in all patches
>    * Change static enabling to user space dynamic enabling via KVM_CAP_PMU_CAPABILITY.
>    * Only support GLOBAL_CTRL save/restore with VMCS exec_ctrl, drop the MSR
>      save/retore list support for GLOBAL_CTRL, thus the support of mediated
>      vPMU is constrained to SapphireRapids and later CPUs on Intel side.
>    * Merge some small changes into a single patch.
>  - Address Sandipan's comment on invalid pmu pointer.
>  - Add back "eventsel_hw" and "fixed_ctr_ctrl_hw" to avoid to directly
>    manipulate pmc->eventsel and pmu->fixed_ctr_ctrl.
> 
> v3: https://lore.kernel.org/all/20240801045907.4010984-1-mizhang@google.com
> v2: https://lore.kernel.org/all/20240506053020.3911940-1-mizhang@google.com
> v1: https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com
> 
> Dapeng Mi (15):
>   KVM: x86/pmu: Start stubbing in mediated PMU support
>   KVM: x86/pmu: Implement Intel mediated PMU requirements and
>     constraints
>   KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
>   KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h header
>   KVM: VMX: Add helpers to toggle/change a bit in VMCS execution
>     controls
>   KVM: x86/pmu: Disable RDPMC interception for compatible mediated vPMU
>   KVM: x86/pmu: Load/save GLOBAL_CTRL via entry/exit fields for mediated
>     PMU
>   KVM: x86/pmu: Use BIT_ULL() instead of open coded equivalents
>   KVM: x86/pmu: Disable interception of select PMU MSRs for mediated
>     vPMUs
>   KVM: x86/pmu: Bypass perf checks when emulating mediated PMU counter
>     accesses
>   KVM: x86/pmu: Reprogram mediated PMU event selectors on event filter
>     updates
>   KVM: x86/pmu: Load/put mediated PMU context when entering/exiting
>     guest
>   KVM: x86/pmu: Handle emulated instruction for mediated vPMU
>   KVM: nVMX: Add macros to simplify nested MSR interception setting
>   KVM: x86/pmu: Expose enable_mediated_pmu parameter to user space
> 
> Kan Liang (7):
>   perf: Skip pmu_ctx based on event_type
>   perf: Add generic exclude_guest support
>   perf: Add APIs to create/release mediated guest vPMUs
>   perf: Clean up perf ctx time
>   perf: Add a EVENT_GUEST flag
>   perf: Add APIs to load/put guest mediated PMU context
>   perf/x86/intel: Support PERF_PMU_CAP_MEDIATED_VPMU
> 
> Mingwei Zhang (3):
>   perf/x86/core: Plumb mediated PMU capability from x86_pmu to
>     x86_pmu_cap
>   KVM: x86/pmu: Introduce eventsel_hw to prepare for pmu event filtering
>   KVM: nVMX: Disable PMU MSR interception as appropriate while running
>     L2
> 
> Sandipan Das (3):
>   perf/x86/core: Do not set bit width for unavailable counters
>   perf/x86/amd: Support PERF_PMU_CAP_MEDIATED_VPMU for AMD host
>   KVM: x86/pmu: Always stuff GuestOnly=1,HostOnly=0 for mediated PMCs on
>     AMD
> 
> Sean Christopherson (15):
>   perf: Move security_perf_event_free() call to __free_event()
>   perf: core/x86: Register a new vector for handling mediated guest PMIs
>   perf/x86: Switch LVTPC to/from mediated PMI vector on guest load/put
>     context
>   KVM: VMX: Setup canonical VMCS config prior to kvm_x86_vendor_init()
>   KVM: SVM: Check pmu->version, not enable_pmu, when getting PMC MSRs
>   KVM: Add a simplified wrapper for registering perf callbacks
>   KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
>   KVM: x86/pmu: Implement AMD mediated PMU requirements
>   KVM: x86: Rework KVM_REQ_MSR_FILTER_CHANGED into a generic
>     RECALC_INTERCEPTS
>   KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates
>   KVM: x86/pmu: Move initialization of valid PMCs bitmask to common x86
>   KVM: x86/pmu: Restrict GLOBAL_{CTRL,STATUS}, fixed PMCs, and PEBS to
>     PMU v2+
>   KVM: x86/pmu: Disallow emulation in the fastpath if mediated PMCs are
>     active
>   KVM: nSVM: Disable PMU MSR interception as appropriate while running
>     L2
>   KVM: x86/pmu: Elide WRMSRs when loading guest PMCs if values already
>     match
> 
> Xiong Zhang (1):
>   KVM: x86/pmu: Register PMI handler for mediated vPMU
> 
>  .../admin-guide/kernel-parameters.txt         |  49 ++
>  arch/arm64/kvm/arm.c                          |   2 +-
>  arch/loongarch/kvm/main.c                     |   2 +-
>  arch/riscv/kvm/main.c                         |   2 +-
>  arch/x86/entry/entry_fred.c                   |   1 +
>  arch/x86/events/amd/core.c                    |   2 +
>  arch/x86/events/core.c                        |  32 +-
>  arch/x86/events/intel/core.c                  |   5 +
>  arch/x86/include/asm/hardirq.h                |   3 +
>  arch/x86/include/asm/idtentry.h               |   6 +
>  arch/x86/include/asm/irq_vectors.h            |   4 +-
>  arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
>  arch/x86/include/asm/kvm-x86-pmu-ops.h        |   4 +
>  arch/x86/include/asm/kvm_host.h               |   7 +-
>  arch/x86/include/asm/msr-index.h              |  17 +-
>  arch/x86/include/asm/perf_event.h             |   1 +
>  arch/x86/include/asm/vmx.h                    |   1 +
>  arch/x86/kernel/idt.c                         |   3 +
>  arch/x86/kernel/irq.c                         |  19 +
>  arch/x86/kvm/Kconfig                          |   1 +
>  arch/x86/kvm/cpuid.c                          |   2 +
>  arch/x86/kvm/pmu.c                            | 272 ++++++++-
>  arch/x86/kvm/pmu.h                            |  37 +-
>  arch/x86/kvm/svm/nested.c                     |  18 +-
>  arch/x86/kvm/svm/pmu.c                        |  51 +-
>  arch/x86/kvm/svm/svm.c                        |  54 +-
>  arch/x86/kvm/vmx/capabilities.h               |  11 +-
>  arch/x86/kvm/vmx/main.c                       |  14 +-
>  arch/x86/kvm/vmx/nested.c                     |  65 ++-
>  arch/x86/kvm/vmx/pmu_intel.c                  | 169 ++++--
>  arch/x86/kvm/vmx/pmu_intel.h                  |  15 +
>  arch/x86/kvm/vmx/vmx.c                        | 143 +++--
>  arch/x86/kvm/vmx/vmx.h                        |  11 +-
>  arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
>  arch/x86/kvm/x86.c                            |  69 ++-
>  arch/x86/kvm/x86.h                            |   1 +
>  include/linux/kvm_host.h                      |  11 +-
>  include/linux/perf_event.h                    |  38 +-
>  init/Kconfig                                  |   4 +
>  kernel/events/core.c                          | 521 ++++++++++++++----
>  .../beauty/arch/x86/include/asm/irq_vectors.h |   3 +-
>  virt/kvm/kvm_main.c                           |   6 +-
>  42 files changed, 1385 insertions(+), 295 deletions(-)
> 
> 
> base-commit: 53d61a43a7973f812caa08fa922b607574befef4

No issues seen with KUT and KVM kselftest runs on the following types of
AMD host systems.
- Milan (does not have PerfMonV2, cannot use Mediated PMU)
- Genoa and Turin (have PerfMonV2)

Tested with all combinations of kvm.force_emulation_prefix and
kvm_amd.enable_mediated_pmu. The issue seen previously where RDPMC gets
intercepted on secondary vCPUs has also been addressed.

