Return-Path: <kvm+bounces-63383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 89424C64D22
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F308F368BE6
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 15:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13FB1336EC7;
	Mon, 17 Nov 2025 15:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Lf8LqIKP"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013031.outbound.protection.outlook.com [40.93.196.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B058B32F74D;
	Mon, 17 Nov 2025 15:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763392053; cv=fail; b=ASmNdIctrAPMumGWbbBGUY7Y72bbx6/TfBR3ZWafcRCnNaDsPEV7o/8+Lp58fQ4nHUDu4eqsnVE6fblUGvU9lF9Oh+WCox1AsIe0uQ8PA9lPIsnd7UJ1nBmVn4hZHAchaPrnStADBKjllOd4AagfJOv4z/3Ctrzpt05XROoOw6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763392053; c=relaxed/simple;
	bh=3ND/h8cF6VA7Tql6a/jSXrcU6Uwpp8OA1zTSWTcHNJI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kap+2UE+5bNNSzZ8v12mWb94F4Hc7DYI3LsARZa5k7gIIL4J+pW1Np02XdpzXozUAuz90gudAw+Rsj74tai/tOFwvaG8fb6RRxw/OU4rIdN4uxyy/So245uaIEpzZ8nKoEhHZUdpRmQw/votmdyebM9neRUV9oGGd9PUuIlPiXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Lf8LqIKP; arc=fail smtp.client-ip=40.93.196.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ueFtdCCT0jKKq+cjiLG8L2seqm3sxqaupnQuWZOJV3vHIkEbpak7dVr8V20NTMqi4ucNZY46lVbAFGHUzZuegbfhEvFey3KIi/YvaXtEw7T4jl/DnXrbTdfOLPR/FwH1UmEqEuOwqBxwXQfovrGRYL1p0NxE13NKpRcE9IoYEA690Ime4S8coNGEwcM8fma8TUjB41OYWOXJUy2djKi9Gb0NcyHXnWrfP8gNznmQQj7PxsXfLyYC+prVe9DX2xylbOx2f91j711NnYJrbvGOAlFPU6tJIpG2SrbZYb7ZCK5tztgtvkD7965F8cdFWjfJxq9gZDdshgCuY26aay9IEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lH3m09XO240rahE4Ho6Qy3cJWkhJBOknmQZxRr0j5tU=;
 b=jqK4kLwfetQrnBPeTq2+SMjWiwRE+Yj2D/J2AhNVW7qpUc2Ma0vKkuJjjFHPD8TNt+pXelmLM7naPp9kIRGI11as/4sxZQyIjEXm67lS2K+A6rMzU7PmcepNZprIe/+a0EbQYbPZFKKaUuNUq0dn42PhLp6T77DfGmVyeWKdYH/8feIHB3zcpu9n0ga3PR8Nl6wROV0D2PuEOkGFYmfiTIF7+6V/sGxDbWVHgy1KSP14sMQdTSGlC7lvN6gfbL77VvdOZPuwTmubj29WDHTne5nkxnNuOb746ffJBy15s8bzMDJN4L0I2r5NScpoYvx2wkJv/V4m2tDxiDNqh54R2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lH3m09XO240rahE4Ho6Qy3cJWkhJBOknmQZxRr0j5tU=;
 b=Lf8LqIKPZ7UpS18uq36bdj1opzuf3+cJwBaceO4CLcDQ0t63cXeqprXHgfIoeJP1xDhAd8CUxb1CeP0ub6qCIm5ZPa30+3V5F1g8pN2kUmCcPcCOJ0cjXmiFleBFYFBU0KGLChZtCV+dXx511spqH3LsOWdIScd0k+uabUnNPx0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by DM4PR12MB6085.namprd12.prod.outlook.com
 (2603:10b6:8:b3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 15:07:27 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 15:07:26 +0000
Message-ID: <4102be40-7334-4845-b812-8481fbbc62ca@amd.com>
Date: Mon, 17 Nov 2025 09:07:20 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
To: Drew Fustini <fustini@kernel.org>, Babu Moger <babu.moger@amd.com>
Cc: corbet@lwn.net, tony.luck@intel.com, reinette.chatre@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com,
 akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
 pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, seanjc@google.com, thomas.lendacky@amd.com,
 pawan.kumar.gupta@linux.intel.com, perry.yuan@amd.com,
 manali.shukla@amd.com, sohil.mehta@intel.com, xin@zytor.com,
 Neeraj.Upadhyay@amd.com, peterz@infradead.org, tiala@microsoft.com,
 mario.limonciello@amd.com, dapeng1.mi@linux.intel.com, michael.roth@amd.com,
 chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
 gautham.shenoy@amd.com
References: <cover.1757108044.git.babu.moger@amd.com> <aRoJAbfn+oBkc/sb@x1>
Content-Language: en-US
From: Babu Moger <bmoger@amd.com>
In-Reply-To: <aRoJAbfn+oBkc/sb@x1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR01CA0021.prod.exchangelabs.com (2603:10b6:805:b6::34)
 To IA0PPF9A76BB3A6.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|DM4PR12MB6085:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c4e4550-eb4f-44e9-210e-08de25eb04d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mnk4KzBhQVR5cDNqY3VHamo2bXk0ckl6cEt0NC8veGdMWE0rTFFNS0FVUmlE?=
 =?utf-8?B?VWtYaHg0dVA2OFlqbndPa05yakpUcE5QTUdSZVk4alBpVVhDRm5aaUVDMUR2?=
 =?utf-8?B?WTdKUWMwVWwrTXh5cU1LMmxaSUFHV1hDQzlJeUQxK2JLTzdLRzcxZlhpaWo1?=
 =?utf-8?B?eWZsSjR2a1pGbXVFRHAyMzFqL2M0cGh5Zi9oWGNKOTVtdjhXa3ZPUzRaYno0?=
 =?utf-8?B?RUxaVktjS3hIQm5jR0Uya0xUTGpaMDFJSjc2YTBLc2NtZTNINTJSQ2t0Z3Rz?=
 =?utf-8?B?cHAvWHp6ekJxRmtPMWdnU3l3SGs5ZmVZeDJsYmo1Yko4eXErd25lNnlxZkJS?=
 =?utf-8?B?c0RwcmNvVEdEWW1TU1BUMG40R1Nvb2NrdElOanhQZVNwYkxUVWx1eDFnMnBs?=
 =?utf-8?B?enJQN3NxbldEbU1hWEZqNENReXZkd25IWE9QRFZNMERNQWZwM0oySUxRd1VU?=
 =?utf-8?B?WUlKTXhyRHJWMXFCZUZnOEthUElaOTJDTTZrN0VORFhJVG51STlueU9hQjBX?=
 =?utf-8?B?Y0FzSWFJR2lpcFBYR1ZrQ0tmdmZBaUVob3c2VzNQMFJLSnlHVHJoQzNVdURw?=
 =?utf-8?B?dG9BRXhtSWxnUGZCL2hXd3VONThBTjd2K1FCdktneUh0NEdVWmVqQ1VCLytG?=
 =?utf-8?B?bTdMNzAzZ1NVU3MxYUp1NDhpaXJJMDc2TnozYTlsWXB4MDIvNnhIeGNpTHVw?=
 =?utf-8?B?dTBJZVI0UHJZMjRHbmJBRHpqdWJaQjY2MHlOMzExS3QzN3NSSklpWlF1a2No?=
 =?utf-8?B?MHorV1JhUFRPWHlWaHpNRGYwV3ozLyttV21CeFcyaGNpSFBkU3Q4K2FlQmtK?=
 =?utf-8?B?emZMTm5lTXJIN1BCTXJBd1RYQUExSmhEakFMdDErUTRtSmt2NXRBZUNhZ3lm?=
 =?utf-8?B?NkVFNDlQRG5lYW91THFhaStQclg4MFZCbVFHZU1Bd01uVUIrZU5WV3NwZU9P?=
 =?utf-8?B?M3RXYmJrV1QwcVVzaGUyWEJnaVBxZEc2b0lyTndIN0ZuNUJKdE1IbWZVZUpu?=
 =?utf-8?B?amlCTThIWGRYd3lhbFVUZUZVcElDaC92QVlPaTJJZHBOVzRLOFlMbkxiOGpL?=
 =?utf-8?B?ZjRTUkVWZWRid00vVFNsQytiNTV3TzFQbUFQdkJFaTUzeVVuVU8rY01CaUZx?=
 =?utf-8?B?OXozZGRnL2lLV0JaVDE1MWZtcjFpOWpSYVFqaHJrSjdEM1B0T1hhWU12R1Jp?=
 =?utf-8?B?YjlnWk9YS1oxbUtkRERzb2NWbjVYclJ5YVFYOWVLamhmOXNweUlseExOSFox?=
 =?utf-8?B?WW43VnhyTlZISFQraVVIV3MxakJ6anIraEdPaFR0MHBSSnNSWDBVN0lyYWtq?=
 =?utf-8?B?MStMVDBXSDlvK1pWN1lhT005WVhXS05CSjkyeUNIZkU3dlBoQzZYenJtcG1V?=
 =?utf-8?B?NUpjcDdWYWxCM0dxcHRFYWhZMXdpb2JQSS9NS21CZW1YTklVNExrOEFYd2pt?=
 =?utf-8?B?TVd0b2ZrVk5hbnhuV1grdXR5ZzYzSTJWOTlYOWdRRk5PVnBJcHZvQmNIY09I?=
 =?utf-8?B?S1JtSEJ5RHQ4T1F0OTE5TE5hRCt6SXdsQTdtdWhEdWFwNVdXMGdLK2tJUzRD?=
 =?utf-8?B?aFhNVXBHZUZqNzJicEhFQmk4ZGRXMi9WRExubDVpVXdYWjNqdVJnM3dvRjBI?=
 =?utf-8?B?ZWcyRkk3THBBZEVpeHBXU0wzOFBldWtBWTk0bjN0eFc4MVhZVlZSRk8yWUlR?=
 =?utf-8?B?ek16bjZJcTFPekJ5TTB0b3M2TG9Pb1EydUZ6VjNmaGdlMmVDVXIrakZiS1M3?=
 =?utf-8?B?UnlwVkNTQ1ZwMUpSMUNCMzhkdTJaOUxRVmlwWkxnTmhaUG43UUJqK2hZaEtV?=
 =?utf-8?B?VnN5V3Z2YkV5N2VDYmprTmpJbEl5RmNPeFlYbzZ6THRGNURVVkJiZ2V5RVJS?=
 =?utf-8?B?K3ZtN2xkL05sMU0rTVdXbjJPOExIYkFtYUl0V21JUUs1YjRTZ1VkRTFQRHdU?=
 =?utf-8?Q?cV4CTOo0Et6P8HdCjzzJC1xyZy/WtE87?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NE55cWcvOXRxRUFyc3llSy9qUTNPcURGeGhLUWg4R21KTFR5NElFR21jelJR?=
 =?utf-8?B?T0hOY2Y2TFdEU1AvNi9oM0xRUUlRS0xMZ3o0ZHJjS01WcEFic3BTcHp4Mms3?=
 =?utf-8?B?b0FWbkkzSCt6UlBkcVF4aHRTWGQvUENBT056dFlSa2QxeFc5REZlMDNCdDJa?=
 =?utf-8?B?UHhSWi9zaHo1c2VCSkdPdTZYL1NFTTlUeDl4ZytpclQrTEFOMkQvMGdZc0Nw?=
 =?utf-8?B?Z1pRZW40dWM5SWEvYWkwQ1dwdDZ5VU84MFIxK0ZweWFTQ2FRT1E3ZHhXWTVH?=
 =?utf-8?B?ejVnV2Nhd3UyK1N4bUFrdzU2SS9mdENlSDFSZm1hMEpMYUpQT1FRN2ZBTzhV?=
 =?utf-8?B?aStSMXE3ZVN2dTl4SGZTZERST0V2aDBndkFpUVVlRXArWi8xNm8wWjZiZkwx?=
 =?utf-8?B?ZkZPbzZUN1JaZG9kMU0vTVBOS2ZaUmFDY3Z5MDNQRTlVeTVqZ29ZWDRlcFd6?=
 =?utf-8?B?aTM5MVJNRktYdjQrYmUvUmoxT2xtS29JNTRBK2NKNWh0RnA2cG9JSGM1TVpG?=
 =?utf-8?B?Uzd2YTR2UWYvVzE3UFM2VXFIdGcyYThaTHdETVFmdGV3NU1aL0lpdzVkMEoz?=
 =?utf-8?B?aERJM0J5bnlnbnpGV1ZxeUIwZU15MzQ5bEN5Tm9hejJkbjByZ01WSnFXbEV0?=
 =?utf-8?B?dWZaN3lid0VTWS9ETnMydjg2cElDNEZYWkVlWGhPTy8yV3MzUUFPZ3RWQ1E2?=
 =?utf-8?B?RXFFa2o2MGxEMUY2eXNZT28vY1d5aUhVcmtqYjdnTk95RUUvakZueWpuVGw1?=
 =?utf-8?B?L3hoMGJIZzFMRzFXNTByQTNOcnNkdEdxV2V0SnpRUjRTeXZ0TjlyYjNrbHJD?=
 =?utf-8?B?YjR2bEdrcEhBd0dQWjVzNmpUVWRpcDB6QllXQVZMcXp4SFRWZ1BSK0huZVFk?=
 =?utf-8?B?ajZIanJuTFhsdElONE9KN204NHBLRXQzZHZ2MFNaRngxVHZWODRKVzJtUDdT?=
 =?utf-8?B?NnhPeEhOM3ZvVzB3KytpZTI3UnZDQ0M1V1M4S2Y2SjcrRUtZcXJWTWJIbE1u?=
 =?utf-8?B?V1JmV1UvRkJrTmhSdTVUTUhSaEZCMUtaMnRGTjRIQ1pVbEdOWG14VG5PcVdK?=
 =?utf-8?B?Vk92Z1ltMnYwN2ZhaFFZRE9KQVRPM1Y3OGlXZjV4NldPSkFyZ2RMYzgvbjdR?=
 =?utf-8?B?b1M5ZTU1blNIN3hacllrNFpqRnNpYytVOE82T2wzd2R0V1BRVCtmeWdGTFlr?=
 =?utf-8?B?MnpmZFBDUU5QMWZvRElpa1dRblp2ZGQzU3lBNFJUUCs0L1I0bC9zSVZSZGhB?=
 =?utf-8?B?N1JPR3MxbytyTlJmWUIzYjE1WkxWNFV4ZEpvWjFHbWpqbnJQdGI2NnAxeXdn?=
 =?utf-8?B?ZS9TcTQ2SlNrY3hwbHF1RmFKZ1VqWjZScUdBc1plTW9NU1NRY1JRTmh3b204?=
 =?utf-8?B?VW9jWnBTZDlYWHd6bW9wUVNncDVKVFN5RUdieUdlR0xMS01kYjFYTG1RSlRk?=
 =?utf-8?B?Y0x2K2VlWDl5S2NyWkNzc1BNTEErWCtwSTZGTENleU40THpmSXAwa25MZ0Ry?=
 =?utf-8?B?dm9VTmtIcnpMc0xaVk9TMjZ2TXBJNVJOaHJBU0tWYTdIU29FK2JlaGpIb0FM?=
 =?utf-8?B?ZjlHQmtMYzRHaGRMaE5JNVRrR1Q4Y2p0Y0JKV1hUK3k3NmpCdHNmeFRiTFVK?=
 =?utf-8?B?QkJXNmN3Qm1Rc2d0SVppdkFacm9saStrcVAvbWdDdHZHNTRnK2ltR3BWTVJM?=
 =?utf-8?B?STByb1NJQXNUdVQ2eHNLd2ZoTVNTOW1sdVFCN2kyNitTcTRGSk8wb0lMMStQ?=
 =?utf-8?B?SWQxZWxKSTc1Tk1TVmpwaUxrL3pPa1BYQmlxS2ZaVVg1UWgrOGQ1cmJDZmhJ?=
 =?utf-8?B?RjhlMWdXMURnZEFLVkN5dHBKUGdBQ0p2RnZrUys2Sm5jV2prbUk2TEl4djdP?=
 =?utf-8?B?TkxYN1VNRmV3UjVSdW5ITG4yNkU4QnFSVEVTRW1kYUJqVXVvQ3RvT280eVpD?=
 =?utf-8?B?MWY5NHRIejF6akdSY2dWeGcwSkphMTQ0U0M2b2I1TFo3K1JaSzRHUUh2Yit5?=
 =?utf-8?B?NStvTnZiRTBZV1E3YTgvSWZXNUpzOXZLU0JJd2lrVFRjdytEK2R1bUlORUhu?=
 =?utf-8?B?WlZ3ZUlaYnBmWi9OTEhTY3R2OGN3WE90bldTSi9aZHhSUVExdk8rR3JBUDBT?=
 =?utf-8?Q?H5z8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4e4550-eb4f-44e9-210e-08de25eb04d1
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 15:07:26.4153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGlz4kuikaUkcppIPqzGd1MFyFkNhe5XaxDEDCGiOpQaz8MMoRIPHpSvBzhc9Toe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6085

Hi Drew,

On 11/16/25 11:25, Drew Fustini wrote:
> On Fri, Sep 05, 2025 at 04:33:59PM -0500, Babu Moger wrote:
>> This series adds the support for Assignable Bandwidth Monitoring Counters
>> (ABMC). It is also called QoS RMID Pinning feature.
>>
>> Series is written such that it is easier to support other assignable
>> features supported from different vendors.
> Is there a way to find out which EPYC parts support ABMC?
>
> I'm rebasing the RISC-V resctrl support on 6.18 and I noticed there are
> a lot of changes to how events work. I've been reading the ABMC code
> but I would like to get a better feel for how it works.
>
> I found an EPYC 9124P on Cherry Servers which I was able to experiment
> with using resctrl on x86. It has the following in cpuinfo:
>
> cat_l3 cdp_l3 cqm cqm_llc cqm_mbm_local cqm_mbm_total cqm_occup_llc mba
>
> It also has SMBA and BMEC based on the contents of /sys/fs/resctrl.
>
> Ideally, I'd like to find a bare metal EPYC server that has ABMC, too.

Looks like you are on Zen 4 system. ABMC is available on Zen 5 or later 
servers.

#lscpu
Vendor ID:                AuthenticAMD
Model name:            AMD EPYC 9655 96-Core Processor
CPU family:              26

Thanks for trying.

-Babu Moger



