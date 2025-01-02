Return-Path: <kvm+bounces-34489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E47DA9FFAA6
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 15:58:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB9D6162953
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 14:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B811B4140;
	Thu,  2 Jan 2025 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="diZkEcFd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B6F1B3959;
	Thu,  2 Jan 2025 14:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735829888; cv=fail; b=C3mOaZN4oRqfL3hOI+lcR6+9mWPg7M62ZtLhJk2AMmb5HPv67hLHz8cAtoH4yvqyFlUOZ8l39Hq4ui0naTb2ubXKiQrFkyIyT5dQQ4lBQUJ5pUFW/GTiXMmHZNGdYEnJYDMMBEAhfcXM+o9pT/bnIlRhhdaZYu3z8BW83TV7gIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735829888; c=relaxed/simple;
	bh=B+a0kZMG//ZmxIXdJIWdIeFa6j1ouyS1xKvz/lLpxPE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XJf/iUaOZhHpTx5/T5C3uGbaWt1vOk7zeDBN3rsxuKThTtsTBP6wNdIbE8Nl0XBP5+zfmFOoZL5L+FFUDKVDU9goh3fSL2Jd9Q8p56lk1twW4QwF2g7nfDWuGFsuaqkIWB8IsPchkVZz4bZEn6iURhOu7C5TE+ZKzLVRAgjLq9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=diZkEcFd; arc=fail smtp.client-ip=40.107.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qvxcM8XBDZ8CftXredxmI1tzUIFX9+0JTdVDYXzhY/6xYvbiyqUTTB7uml0cZUV4L+GcfwS16ERvyEi2oaDf3CUJy+oHxt4FbSBUcV1e7j1QwU9XA8gcLykdK+P/v8fd3QPfvovaoKxKFVasEjMs+juEas8QASK/Rkib1WwnOqd5WG31jUz7tLO5AEtsYbBBHxpFgRC+zLTCge8fs04Fy8iU04tQz4AJrwcoQsVy39fjYiNufKHQehbd3/0MwPRt1xbovi7xGRNymFY4DJgNXr4QgxU7BBYZl04/PwpZpRQl5q5oklyP50b29P63wODzdSRBQyvO4yQjcn2rowF8pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duMSaSzvB7nS6ANUpxf4ONIijJqXdOVrF7qxV8XKHRM=;
 b=MBQzFGtYp9xddAhM1yLb+eR9EnScoxEsalmYAfIWcf3zfsq9kJtmvVjmkTMcMImGOrdOqCZM7clebPN/E/dap5q5d+g4YZJZlMrCCVTrNhn9h93u4Wydmsa9gfueHYKNxkP70L9vd3lknel4ZIuWGRg3Ureuln7hKXrEN6VaOWADZlitcp0mkrEEUxQBaWKDIaDl0E6viTSiveU3JqqBr5m3BJZ12p8ituxMBDGm7RCd0QxUHgae14naDY5Mdw0avpizjaWkrYHIE20Y7QdorK7lbbTCnKGA4QO03nPV9LB+UNoNKh3YOheQGtZcUuwdsA2+7ft6yb1UiUxrb4QcCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duMSaSzvB7nS6ANUpxf4ONIijJqXdOVrF7qxV8XKHRM=;
 b=diZkEcFdn5SDQVvRPhjh8K/vIA/NUZSbJZNy6c3MOStycmJ1xMtmPxlM7veE334KR8YKVMYN/uHEGk5m/67SaL8pSgNL341TJ8YO3xWTA/m4Odsnu6M0uVy6Z6TKqmxoNZ7iUEZvOdjuCpwZhrqNlH7x+taCEiup3/NOfZ+UzAY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by SJ2PR12MB7799.namprd12.prod.outlook.com (2603:10b6:a03:4d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 14:58:00 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 14:58:00 +0000
Message-ID: <f1234447-279e-4a46-94d1-2b72fe41add8@amd.com>
Date: Thu, 2 Jan 2025 08:57:59 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Use str_enabled_disabled() helper in
 sev_hardware_setup()
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Paluri, PavanKumar (Pavan Kumar)" <pavankumar.paluri@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241227094450.674104-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20241227094450.674104-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:806:22::14) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|SJ2PR12MB7799:EE_
X-MS-Office365-Filtering-Correlation-Id: 62a62274-88b6-4113-7dd2-08dd2b3dd9ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVljWTRud2EySGwwK0tFZXJONGtUcXh5a1VSUEN2d3Z4cDNWV2FlVHR5S2dS?=
 =?utf-8?B?VG0yLzRXQ2J3eWZ0ZlUrRk1vUU1pQnY5OWtSWkxpN3V1KzdHd0haaldYZXpD?=
 =?utf-8?B?VWhRaG9xQXh0ZTJIVmFEbWlWaUt3a0x2cFJ4dExhRGtOajgxdEFNU1FHRkJX?=
 =?utf-8?B?dTBqcDR6aElzdUxQRms0dVpGVE9TbE5LOEdjUituelZBbFF4WVJhWVd3dnU1?=
 =?utf-8?B?L1YzTWlzR21rYkJIMllPSUNMcG9vYXF1YktzNzVocTBIT3N0WXRvaCtRY2NL?=
 =?utf-8?B?SVVDUGJOaHBpMnNyaEUxbkpvN21XOUNUUUlYYUVUN2hXc2dpZ3M0OXJIUXor?=
 =?utf-8?B?N25XR2xrZnNXZkZhblRWaE1KU0RwK0tWYmVwRzN6c3lrc1A0aXZkWXptYm5K?=
 =?utf-8?B?US8xV1YyMGU4RkNpR3orVUZ2eHNEck56MGQ3MEZxUEpvUTBMcVgvMUlFZFU5?=
 =?utf-8?B?RmEvODJ3WUhtZnFWNXR0Wlc0ejczUWRndytNVCtIL2dnS1l6U0xPL2RITXZD?=
 =?utf-8?B?c2Z3UGw3eEtwZDZlQmlTbTFRaE1Oa00zeXVhYXpkVkRlTkNBRzd0QjNFTkFX?=
 =?utf-8?B?TlJZM3pPWHV6dHBIZmhaSFFYNVVUekhDaWlwK0Y1VEd6MXZEVXBWNVZ1cDZn?=
 =?utf-8?B?Q3lDbWw5RTl2cVB0Y1BHZmdoRXhLS0JnYlppZXFsYWh4Wmh6cHdiaENxTitO?=
 =?utf-8?B?ZE5KZkw4WGNIV0o4ZEN1WFNKa3hwU29JaU1nUldkZmR1OWJCSklVSXFlUE5j?=
 =?utf-8?B?dEhyUDd6L1RXeU9pcGpDUmpQd09ac1FaUDdLKzY2TXkzTFhCS0E3YVRUMXk2?=
 =?utf-8?B?NHpkcVlwaE5CTXhrWjlCOU5ob0VMRzdQMjU0Yjk4dzljSERUaFlXZExjRjBp?=
 =?utf-8?B?d0VObE5BTnQxS3V3MnVMYSt1ZGFBZWZ1dURaZm05Si9ZMVJ5Z2JISWdNU3VF?=
 =?utf-8?B?MysrWXBPNml4SDRLdEJJMExGK0FiUmpBS3VPK0JSUGFEaUltdWIvTEpNSlNH?=
 =?utf-8?B?SktscU1WUWRnTlNCR21TZ2lDdzRodjN2aTBXS013c2h6ZDcyUVAzUTJmcWlw?=
 =?utf-8?B?SXQ2YzdVZXFzcDE2MUdmL3VmTGZMMWpBYWlmNTZhUCttVGg3ZXoyalFQWDRs?=
 =?utf-8?B?YW1jUmR5amh1aDFsOUwraVVQZUExdGxkbEltUmV4MzBLcjExRi9vYkUrSk84?=
 =?utf-8?B?OEZjOUoySklUY0EvQjVnNHpNcit0L01SSEg2M0I5Y0xMcmc4WFhTcng0NnR4?=
 =?utf-8?B?ODNLNUdUWUt0REZmN3JBYVg0SExOZVRoVXFmUWFYMVFtaHY1VjdxdVBGU0t0?=
 =?utf-8?B?ZnRzVUxEbWJKVWJURTRHVFlqQ2RhY0RxTVN0eFdpR1NOeTJlMlErMUE1a2lm?=
 =?utf-8?B?WXRRb084alR6dDljNC9ydG5PckNnRW1QendHSVBjbTc5cjlLTUt5eVVzU0p6?=
 =?utf-8?B?c0RSaGJYTTdsdGtNQ25oK1V5aTFHbHFjMGtSUHFBejFSMWE2Q0FsbTgzeG03?=
 =?utf-8?B?RVRuaU1ZSnhUSGpMc1F4WVZncDlnOFljb2piSm5HaVAwUzlVYTJKdGEvWWcr?=
 =?utf-8?B?M1F4NDdscUliRDhUamMvQXhkNHU3UDlOU2VFSkptcEVJWWdua2lPZHNnTXA5?=
 =?utf-8?B?bTBNbGc4RUVPLy82ZEJzOE1oUmhXZjZhL1psempTY0FYRS9VM08rRXd3cGNw?=
 =?utf-8?B?QWI0bDRoOUdBN25ucmlHUVVHS1g1VnNHR2xnVlMyRmtnMWxCSmV2d1ZraFhF?=
 =?utf-8?B?TWxWSWlNMGJYOVd4YnJxdDBEM1hxSjR3eG1TRThGVlRxRVJaVFZ2My9nU1o4?=
 =?utf-8?B?SElqSWlnNlc0cHFlazdyNi8vRlk5UEx4SmN3dmN1aGgwbTFpOFNOeFMvclZO?=
 =?utf-8?B?c2JXWDlOUTVDUVorZUFMVDhSdjhhM1JTRFBCT1dSTy9YREVqZ21uMG9pdWgx?=
 =?utf-8?Q?heZRKJvBN3U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGlNbnU5Vi9Nb3B0ZExMYlRJUW13emVyWnUvNGRjeDR5aG1EU0FNU2QyY3A1?=
 =?utf-8?B?emJoV1pJMWJYdmVhTjVSYU1ZcHE5UlAxVzNoVGJKL1JZbE00UHd2WU5Gb3JV?=
 =?utf-8?B?VTU1ZWVlWm8xMFBOendXcjRRYmRLeDkzTENzMmZCMzRsdlVZYWdHTzJ5T3dG?=
 =?utf-8?B?YjJIN3lQcnE4VnVyV1Rub2MzZ1I2a3JtRStEakxFa25mLzM5MXJxVHZDVTN4?=
 =?utf-8?B?OFU0d2k3ckg2Uy8weDQ1MGYvUVpmY3FoQk9nZlV2WGpqcW9Ka1U5d0F3WWJp?=
 =?utf-8?B?aUJDakZGUGVnd2REaDlHbElIV29laWdSeGk1SVpGNUpWOG9KVW1vQ3FGQVNn?=
 =?utf-8?B?ekpWTmxRd2xRczJ4bktzTHIvaFo5czg1MDM4Y2VsUDh0TE16Qy9uaEh3L3Ur?=
 =?utf-8?B?YWdLUVNVWkk4MG5TdHpjd0xYMUMrRkVBa01ISk1jeFM2cnFuNXVJbTZFZzNo?=
 =?utf-8?B?eWwwc3o2K0hkMG9BYnRkcmdiNWhOeTdGci8yRHRZdEVlcWVpOXNlem1oLy9N?=
 =?utf-8?B?YTNTSFV6WEdjVGkzTnB1a2tkYStkRmpXcmJLdjIxdUk4cHN3bjJiditaMSt4?=
 =?utf-8?B?NDYyNlU3MDhVRVpsdnYwd3Rodks3M1dVV1ZCM2k4OW9zc1VmcW5XKzA1WG9Y?=
 =?utf-8?B?OHhhNXdSQ1poeWMrVUxsVTY0ZTdjMENoZys1aVlBdERVVmxMZHBKS2QxRFVp?=
 =?utf-8?B?R3QvaEl4eTR0Sm9lZWNDc1BDVjVMRTJlZEJZcStkYTJzNlpsRFRtTnUyVmxq?=
 =?utf-8?B?K01qT2Y3bGdEUkN6dzFwTEEyU2d4MGdmYk9vQ0RWTjNCWVpoQnRJUzdENmpL?=
 =?utf-8?B?WFJEakZrK1ljNGk4UktyRkdmalQvdG5IWWVvOGdMa3d6Rk9ta0czTjJDTVdT?=
 =?utf-8?B?bzZ6ckdGUjhFbmJCZ2NsSEdvNFdMNmE5aWpuNktNbk56bmRWVjd6dlVtK0NX?=
 =?utf-8?B?cVhIWnVkNGlDaDRCUlJpWHE0MzdFSXR2b2ZJeThuenVBTWF5aDdsQ0FJeDNY?=
 =?utf-8?B?b2RJd2FBNitibm9DQWpoSWoyelhkeUlIakJTU0txY2V3TFp3N2VWWDQ1a1Zu?=
 =?utf-8?B?QldxblJldWlvbWlzdm1rZmFvVFR6WXhuMGJPN0hSQ2NnTU5BNmVncW1QR0pM?=
 =?utf-8?B?YjNQUEJDM0JNek0yb0JQUDZPbGhhOW9tUnhnQ2lMMmxMVGhVZ2FSdFA3VWpi?=
 =?utf-8?B?Y0FwZUlkK3ltT2thWHBISCtDUFNjZ1RuM21OQmZiQnpZaCtQVmNtUFFXMVFG?=
 =?utf-8?B?NlJEZ05OZjFqaytDbnFUSUVNNzU3U1pyemIrVWEvYzlIQmhacTNWMVQrd1BL?=
 =?utf-8?B?b0t4eTdaY05YaTUrUlc1bmt3U21rVG42bWhjZlRVYnlBcG1TZVFkaDcvQ08x?=
 =?utf-8?B?bVlKMEJDaEM2dzdtNXUyRlRTT0s5TDVBVjhucllJRUFYWnhWNjAxbjlPM3dw?=
 =?utf-8?B?SXp2V0lRNlBTcy9vZThXaVhsVS9uNG1pTXlwVjRsRjNGUjB1N253eHVMOENF?=
 =?utf-8?B?ekZDVUhCY1NBZk5qSHNNUG5RSW9uZ1RiVkIwVm5LZ2ZGK1h4TFNXM3dPVXB6?=
 =?utf-8?B?ZEJxSlVYd2xPblhBN21oSUFqczN2QWhZRG13LzliUkdUeFQzUEp4SHh5U0My?=
 =?utf-8?B?VW02bWtnSThVeHQ1cEIySm8xOGRuMEhtYmx4M2N2RERQQVdxd0RBSi9qc2Fa?=
 =?utf-8?B?Unh1VktUQW1oc2R6Y0lPTGhYVCtGQWlDSjk3bXlQdmpZKzRqdUtORVE2cXZv?=
 =?utf-8?B?R013ejFzb2xWVXlZRU1iK3hzVVVJTXMzamdQNWF2YWluaVRmSnRubWpQbGpV?=
 =?utf-8?B?SFR1SGtNOWpPNVVzUXNMNGFnZi82SzdyMndQWWdWWGswQ1kreGd4OXY5eUwx?=
 =?utf-8?B?NTRlZ0t0UHgyaGZFVVFreE4ybFZWM3NPcXduK2hvQlN1TVFyUGRNNDNrdklR?=
 =?utf-8?B?L29PT01ocDhnYVB5YjI1ZGxHdFZUYStvb2xrUStnMStmWERDY3MxVE9jZlpT?=
 =?utf-8?B?dGEvVklQK2tEaGNuYkkzMDBWOHpmZXB4cnhHWk5FR0VUZFBhV2N2cG1idmFn?=
 =?utf-8?B?bDJ2UWwvblB5anBYSnd4YnpiUDA3bkNvT2FZaE5sWUl5bDBIQTBibXNxYVZm?=
 =?utf-8?Q?1/9sB7GJ3d8oH50Wx+CyNdIhK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a62274-88b6-4113-7dd2-08dd2b3dd9ed
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 14:58:00.6682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXit8873ovioekwm45Jy4tT+3zhYoSK9ykhpJXIGjWE5EpkrlfoNnD0hru1mm2lL2YM19P439vDteZ4LXuFP1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7799



On 12/27/2024 3:44 AM, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_enabled_disabled() helper
> function.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

LGTM.

Reviewed-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd074a5d3..87ed8cde68a7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3051,11 +3051,11 @@ void __init sev_hardware_setup(void)
>  			min_sev_asid, max_sev_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> -			sev_es_supported ? "enabled" : "disabled",
> +			str_enabled_disabled(sev_es_supported),
>  			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
> -			sev_snp_supported ? "enabled" : "disabled",
> +			str_enabled_disabled(sev_snp_supported),
>  			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>  
>  	sev_enabled = sev_supported;


