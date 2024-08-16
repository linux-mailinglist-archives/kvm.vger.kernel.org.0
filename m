Return-Path: <kvm+bounces-24443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C581955241
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C130283E42
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 21:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113CF1C5791;
	Fri, 16 Aug 2024 21:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b29L7JVv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F60E1386C6;
	Fri, 16 Aug 2024 21:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723842825; cv=fail; b=lQuYW/wxhGw8yFfeQMsPKlhD6qNMj2zBjjjrv62Tnn6b0hIUGcUpdM5k72OB4wwajsuEiYJMOruvP6Q5wu+trQGHK+l3kTsraoPIfL+qTtqMZInJn6fkzQDU0mQBz1MxxNrppG7u+TrvzLr3Fe9z0H36w5Xrl+b0qFQcGRJiTVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723842825; c=relaxed/simple;
	bh=7L2czX/gOz2JtpdRq/Ye54qRyXp2ugqxsCGhAXTc0d4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BswdArqnJferY9jR1Fohdvhgc2f3vjs/9yT7G8jESJWjPSTxB+PMioY7niKYrJQ4q2+hTFnHhY6LeqUGUvCCmFOI73osYUovPEuAuGOrBdtj5xSEBXo4mQwzOtKLBQj+xm2+2EqXmb5FPF64hhGj15Gp4yw8rVGOjKJJ3JO6teE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b29L7JVv; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9zQCMP/3xbpVFCH5vLLrgV7F8p9F3RBELUg36uwqThUMQsScEg+FaslYfSiQNyHNniTZl9oCf4vBlETcmxh9jL8lqDI1UlAy2FCLQTbFWWMEyDA9SRNA/2og+GzMfwVbNZvGh8vuFYxYFoqkDzqgP/51EHxnzEZfAdxLhaTmjHayFHYXoT37CBvVQAhsE7dtv+aG/l+LG/nQKGpC0HjODmgsorXYbdXe5UDK1aQdrGG5MAtS0Np0A2uuRb/OgAJNUFnmHH14tEaqgpcooZ6bb9cX3QxsWBh78ahqRPvSuoP5sXDtgQoMisaeTbO7KG+hNB/GAQ1aOAUfE8tzUdd0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZoTKqQnwFS02BjtvYctd/vaIf8hnol1M6u/XqC1nr4=;
 b=v7K42wOOeRkLZoZ7YUdMXB6J6bBJclKk6tiGmXnXTz2xEHB1KoV+hp/64gHRZH/Ev4brwnoGcNleS1znyMacVGCEwadhXNSSxzZNzW5XFjI0BDtPdu7ebKAhV5ejiyDlxs2lXLi/dykDXY/9ez1YYALyW+UwiAqXA6N2rciyrwHD53OerUHSNm3UmylWwZ5EFPtoVlPjW7M73VJo+L4vAW7xNE5u31wuOr+lLSSqdf9yzD/i2ekLOcOR4L7nFLokqWTIHALA27mx/z45njp6uGjlYBUcdED75CXp+Q4vU+RM4o6pTwutQF9OG8fVvvpMVk5fh8EJb6B1/fvhIbLC3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZoTKqQnwFS02BjtvYctd/vaIf8hnol1M6u/XqC1nr4=;
 b=b29L7JVvUxIQfoSk9XVodNNseXeUk/w/1UImNXxPX/PwtXKq4Lt9ppMtwpAwPtoHy9k7Xl4hpmYEfiCarb+I+Hk3LtQKViA0tSZzFqSkHiK+Xx/7GbmFEbkjVQDCSGSDjQITRhqgsOZuHWoLX+4zw6byRgHcjUj5v2EihznryQ2P8M6+o2IJiafuLwZA3bSoZQx1Kv/VWTuXAI9o0mqmhVU2+SzEFGoeRsd1MhYXR1ILD7qymBOMIG63h8YZFKZliVxnP6uTrGC7MPF0osORc9/3Uea9UjrJDIZ7m731uZ1J+5STVB/IDoGDe0nNwqMBKh8+kJlSwtQjcGGA9qkaqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8194.namprd12.prod.outlook.com (2603:10b6:930:76::5)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 21:13:39 +0000
Received: from CY8PR12MB8194.namprd12.prod.outlook.com
 ([fe80::82b9:9338:947f:fc9]) by CY8PR12MB8194.namprd12.prod.outlook.com
 ([fe80::82b9:9338:947f:fc9%6]) with mapi id 15.20.7875.019; Fri, 16 Aug 2024
 21:13:39 +0000
Message-ID: <aa9a6b53-cfc4-4010-83f5-ccfa396bb75f@nvidia.com>
Date: Fri, 16 Aug 2024 16:13:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/15] arm64: Support for running as a guest in Arm CCA
To: Steven Price <steven.price@arm.com>,
 Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <ZpDvTXMDq6i+4O0m@fedora> <09fdebd7-32a0-4a88-9002-0f24eebe00a8@nvidia.com>
 <27c942e0-0e7c-4e71-b1df-1a8f70df5411@arm.com>
Content-Language: en-US
From: Shanker Donthineni <sdonthineni@nvidia.com>
In-Reply-To: <27c942e0-0e7c-4e71-b1df-1a8f70df5411@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::39) To CY8PR12MB8194.namprd12.prod.outlook.com
 (2603:10b6:930:76::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8194:EE_|MW3PR12MB4441:EE_
X-MS-Office365-Filtering-Correlation-Id: a1a1dcaf-9686-49d1-f33f-08dcbe384c5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlhqMEtGRVR4SVlZQzNFSWlUblFWbUc1bGNPdnhlZ1pJNHZkVkxuV21lNmV3?=
 =?utf-8?B?NFJDUXcxM1lHamxXaTBMcUM0TjM0SnZPejFIR0tMclZ6UHlyQkVVNld5ZTVT?=
 =?utf-8?B?UjcvbXo3N1ZTeHRDRDFYZjNjaE5kUFBEN0dZdjdKR2tXeUtSMU1kS0VxYm1U?=
 =?utf-8?B?dS9nUUVndDBhWUgyeXBqS3IzOHl3SDhuUkxFbWZUWXVDS0RTejM4a2hENGRP?=
 =?utf-8?B?MHp5bm9vTVFsak1HcUlKTnhSVkVTVGNVOWtRQmtQVzlYbmxIeTRvYzAxZ0wr?=
 =?utf-8?B?MHJWem44R2lXZDhHTG9La3VGOEV3RFhyM2F3dEVQV3h0alRsVU4xMlk0MFJ0?=
 =?utf-8?B?RHFNQm5yb1dKUFEyMVFPeGltVGtCMWJ4dEJrSldabS9RN1Fna0wra09ESFJX?=
 =?utf-8?B?Ulhnd0lBWVZGc0NGbzd4N0pkZ0N4Ui9iMzZVY1Mwam1ubEZENmpJT3psZFdU?=
 =?utf-8?B?ZlNFL3dRRU55RXY5Njg2U2lGMkxrSzVwbVFsZ1VoZlE2anVGa3ZvNmcrS3Z3?=
 =?utf-8?B?Y1p5cVpMTmMwS2NzN0ROcDYrV2U2dXVEMFV6Q2gvZkJTOC9ONGEzc3hTY0RZ?=
 =?utf-8?B?VFhCTnU3bXJtZC9veHlpaWFLNVhPclJVMzVkMm9EeXBmRzc3OXIvUWhjeFJy?=
 =?utf-8?B?ZWNSTnZoNS92VXNvcUQ4T29wQ2JrTldaTGNQL1dYNCs0UXBLbS84OGQ0c0ZB?=
 =?utf-8?B?djlTMW9BVHVFNFBTc1pvOGwrSjZnbGVSUklMbGRCUnB6bHQ2aC9UN0FWQ1Jk?=
 =?utf-8?B?Rmc2dnhVTWtuMmkyTXc1cWdjdkR6WHc1Qk1QZ0xUdkcyWXRlVUJ0Y3N3U09x?=
 =?utf-8?B?UUx1eEFDaDk2aXFncm5nN2FrVW5Cem9DSi9GNTRzMzFxamQ3NCtSbGNSelE3?=
 =?utf-8?B?ejM2SG9hV0tYVURzUXFxYkJsY3VlSXVYUTZwbkNLdEYzVUthU0lIOFZhM01p?=
 =?utf-8?B?c3NPS1daWjVvWWNPT3NGQlZlTUhZcUZOdGNLbEdWUW5HMkNKY1Vlbk1LcFVO?=
 =?utf-8?B?UERUa2dETHZQYlNWRUpqWWZOeVR1bURhVG1ZMFU2NGxXYUZqb1A1WHdORnlj?=
 =?utf-8?B?WFhBMzRVZ0lmN1phVTQvWHhraWo4TEptMUUxRnovNk9ySUNUVHhKaVBOSFEx?=
 =?utf-8?B?TzNQQlM1TnFwUTBDUUZYbnVnMGJMWWkrYThXQjFsaE1XTFNLemZHRm9rOVho?=
 =?utf-8?B?U0ZiQUUzYW9YbzN2dUlFbVZQRWR2VjQ2TU5JOGEybGwrSTg2Wk40cDJCQXpM?=
 =?utf-8?B?aU43ZVYxQkVkVmVYMnY0NjJRa2Fjc1F0VjArazNFQjB2Uk5RZVNMaU51bXh3?=
 =?utf-8?B?WHFUQ1IyVzdsUHNCbnpFY3FtTFdjbWtjYlE4OTMvcWdMREhvSitCU1djb2pZ?=
 =?utf-8?B?SWVScURRRWU2TThDUXRiUlZnY1p2eDMyc0dncXdaeVF3b2drbFlJdE1NbGxH?=
 =?utf-8?B?TWNlckdwVnZpakN1UWFsL3VoanJZSk9rSGxROHRlL2VPd3dITWd0ang2STMz?=
 =?utf-8?B?UE40NGlnajhQbTAwQnJDUDhEU0lKZE5vNTFHSGwwOUtOeWs3dHQ5VFA4aXZN?=
 =?utf-8?B?Q3d6aC9JRFVwdGdSNmMrTXdhb0srUmR5NlVHY2Q2OGJCd25WeTdNRFlKSTlG?=
 =?utf-8?B?SmNjdEwzc0o5VUFCVFpNQWtWVzFxMXNYa1d1bnJKN08zT2N2RDROMVVhcGh2?=
 =?utf-8?B?bWpoblBObTY4U2hMU1lGcnZMa1lSSEZwTG05UjFFSDRPaDdENGZEOWlta0VV?=
 =?utf-8?B?OWVCbkhEV1ZaWmJLR01XQ0R6aXFKWXVnUzZ2aFZ5cDJQbHFkb0lTakc3eWw1?=
 =?utf-8?B?eitucjVNbmJIcGhyNkZoQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1BWTlF6WitMNHVDRFZWTlNEYWhHcGhrUDB4aVBQeUx4c1hWUEpkZThwQ3pQ?=
 =?utf-8?B?aE5Hd1c0cjJIZlVobkVsWGVEUkU3bDJrd01sNlhDbWd2WHphT0xVV1BkU2cr?=
 =?utf-8?B?cmlUNDRvMU9NYjFZelcrb3VRR3F4U0d1UlB4aWRSZGRzWGUwZnZ2Y3JSdE5C?=
 =?utf-8?B?MzVteFQ5TG1wZkJwVzJ4ZUVUNkRzeS9jOGM5M040N1RPV2hjTTVCY3NIM2lM?=
 =?utf-8?B?ek5PNWt6UFBOaER6SkpuTjdYS0hYYmloQkE4ZEhndHA3RHA4blhPbXV0Snl3?=
 =?utf-8?B?TjB6K2pUVEV0WUE0ZEUzNUxKcDQxTmJrRWRFdEowUmRSdjgyWGxrRVhPU25W?=
 =?utf-8?B?NE9hYndOZGNGMjBIRHk1bW5Ka1VpUk1haVl1dTNBUC84UnZMdTBPT1JlN0VC?=
 =?utf-8?B?ZHdjbUFvTkRTMjlnRmUweXJhVVhvS1p1Zmg2dDBSTmoydUZ5LzBTYzFqeTFP?=
 =?utf-8?B?bHNzUThjVEZhUnRKbkdIU3g3NnM1ZXNIOUFXaUN4ZlhJaGlKeFFVS3VGRHNo?=
 =?utf-8?B?d2J3UG93eDBTeU9XcXBIUjlGWlBaQ0FseVp6TGhZNHNQTzhTdFhLUXdsVUxq?=
 =?utf-8?B?RVVwcVN6TWZ2M2JCYWJRbHd2ZjVDZmRBbEZ0eXJzQVd1RE1FNFFDbFdmQkhD?=
 =?utf-8?B?c2xIZ2R5QTc3cTBwbG1xV3J5NmFPZ2k5YVZaUEdZRnc0QXpVWFFEZURPZGg5?=
 =?utf-8?B?bHZlT1R6M1BXdjYweXUycWNBVW5vTXowdktqTUxRU0haSi8yS2FlZ1hxUmNJ?=
 =?utf-8?B?ZXFnVDRuWnBKdGpYeHFCdU9VYkVlN1dQOVVBOUhYd1hTZ2RDL0N2YkJsc1ln?=
 =?utf-8?B?VE5kOUwxNFNEVjBQLys3aCsrYks4alRpMVBlS1IyV1pNb1AzdHdUM041SmY4?=
 =?utf-8?B?VjZJcjJPTm5waFowekpiL1NmRlgyRzNjeDZCZzdZVU02Sy95NGNsajc1UHZH?=
 =?utf-8?B?ek9IQTNzaVNQSEhOaUtrMnhQVmFRdDVRM2lSd084WFVWOUZUd21lS1U1R293?=
 =?utf-8?B?VEJmb3ZPTTFmbFZaOGNjZWZlQS94RUdxRmt3RThCZ0ZOT2JjZGp4akgxNDFz?=
 =?utf-8?B?MjlUSi9iQ2N3REJPM0ZGUE9DSVJ5aldmcFhudytHQk9rZTIrQ1FMUDB0cmMy?=
 =?utf-8?B?MGFuZjFWNHJTNzRQTnNOeGRpR2V2NE5XRktZYyt6b1FVa0x6S2NaOW1LcVNQ?=
 =?utf-8?B?dHpadHpZaG55SDNRaVZrNmFzQlYyUlJUQlExWHBqeWRXN25udFB2TUdKbCtJ?=
 =?utf-8?B?ZUNhSGYwRURMMTYyM21KRDNMTmJKR0J1NmJoYUlQSGFKWWVHRlRGc3FlZ3E0?=
 =?utf-8?B?U0oxV1BHMk52YU8xSlBCRE9hY3Z1ZDBGMUZ2Q1lGQWI0OUJQeDh2U2d5Qkx5?=
 =?utf-8?B?a2NRSUo3cWlSdXlReThKdnRodWFEdjJUa0ZYUWlYK28rYmp3a0ViRVo5dmFZ?=
 =?utf-8?B?dzRhbjEwckV2cTh2MVRSRENnZHY0SU5Dc0RWZC9FTW1BUWxZNEFSRWlUWTVo?=
 =?utf-8?B?RlBFRzBFL2U1TE4xa3dYTlJ5cnhuRnFjNkNsSVBIM0VkblA5RjlQQ1drQWZw?=
 =?utf-8?B?cWRpY2ZweFlKcFlld1BvbVNhSmVHNDlLWTRscHkvVk0yUCt2MENwQkVLR0Rv?=
 =?utf-8?B?L21aTFVqVk14bGJubmRCbDJibEt2SkFFMko2K3pNNlMrRTFVcUkxNGdVM3Bm?=
 =?utf-8?B?bjREUlZZeXFieVg1Y0VNMWZQWlZjOWhybGo5ZUtraUN6NTAxMUt4RE5hOW9L?=
 =?utf-8?B?OUQ0alhZMnBLK1c3K2dKdkdKa2ZtdzBUVUFuSmxvdFdPakFXVW1CSEVPemxs?=
 =?utf-8?B?NEpMRFZPaUo3cU5RakpQemVpS1ppcWdsZGE4UGc2UTZlQytCZC9DZ3dNVDVG?=
 =?utf-8?B?dXh3R0Q5ZzZiZnJYSS9EVy9WM29UYW00ZEJJQ3d3TUFYZzZzeEZNeU5nTE4z?=
 =?utf-8?B?czEwTFZyN1NkWWRvSHFrUFg0UC9QWS9xOUQwSEl2cUlUNzhnakxDekVOTnVn?=
 =?utf-8?B?YXNoNi80NXVYdHlKenhsL3ArRnBnenpjOWU1S09Xcjdqa0tLZHBGaW5XNmVz?=
 =?utf-8?B?QTBmTkUrK2h0WWZlSnR3NXVqaDRWVXZVeWk0VUVLR1JiVGI4V2dsRlJNbFAy?=
 =?utf-8?Q?VTaPVwSwIdrRBnuPFr6inLbJR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a1dcaf-9686-49d1-f33f-08dcbe384c5c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 21:13:38.9730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gxz9lE38hnHxulhts8Opk+eOIIyf8vJofBQTKukKJXHney7ZnZVVrXSfl9ekBu6+kNvYwlueMsbKoZ+Seulorg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441



On 8/16/24 11:06, Steven Price wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 15/08/2024 23:16, Shanker Donthineni wrote:
>> Hi Steven,
>>
>> On 7/12/24 03:54, Matias Ezequiel Vara Larsen wrote:
>>> On Mon, Jul 01, 2024 at 10:54:50AM +0100, Steven Price wrote:
>>>> This series adds support for running Linux in a protected VM under the
>>>> Arm Confidential Compute Architecture (CCA). This has been updated
>>>> following the feedback from the v3 posting[1]. Thanks for the feedback!
>>>> Individual patches have a change log. But things to highlight:
>>>>
>>>>    * a new patch ("firmware/psci: Add psci_early_test_conduit()") to
>>>>      prevent SMC calls being made on systems which don't support them -
>>>>      i.e. systems without EL2/EL3 - thanks Jean-Philippe!
>>>>
>>>>    * two patches dropped (overriding set_fixmap_io). Instead
>>>>      FIXMAP_PAGE_IO is modified to include PROT_NS_SHARED. When support
>>>>      for assigning hardware devices to a realm guest is added this will
>>>>      need to be brought back in some form. But for now it's just adding
>>>>      complixity and confusion for no gain.
>>>>
>>>>    * a new patch ("arm64: mm: Avoid TLBI when marking pages as valid")
>>>>      which avoids doing an extra TLBI when doing the break-before-make.
>>>>      Note that this changes the behaviour in other cases when making
>>>>      memory valid. This should be safe (and saves a TLBI for those
>>>> cases),
>>>>      but it's a separate patch in case of regressions.
>>>>
>>>>    * GIC ITT allocation now uses a custom genpool-based allocator. I
>>>>      expect this will be replaced with a generic way of allocating
>>>>      decrypted memory (see [4]), but for now this gets things working
>>>>      without wasting too much memory.
>>>>
>>>> The ABI to the RMM from a realm (the RSI) is based on the final RMM v1.0
>>>> (EAC 5) specification[2]. Future RMM specifications will be backwards
>>>> compatible so a guest using the v1.0 specification (i.e. this series)
>>>> will be able to run on future versions of the RMM without modification.
>>>>
>>>> This series is based on v6.10-rc1. It is also available as a git
>>>> repository:
>>>>
>>>> https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v4
>>
>> Which cca-host branch should I use for testing cca-guest/v4?
>>
>> I'm getting compilation errors with cca-host/v3 and cca-guest/v4, is there
>> any known WAR or fix to resolve this issue?
> 
> cca-host/v3 should work with cca-guest/v4. I've been working on
> rebasing/updating the branches and should be able to post v4/v5 series
> next week.
> 
>>
>> arch/arm64/kvm/rme.c: In function ‘kvm_realm_reset_id_aa64dfr0_el1’:
>> ././include/linux/compiler_types.h:487:45: error: call to
>> ‘__compiletime_assert_650’ declared with attribute error: FIELD_PREP:
>> value too large for the field
>>    487 |         _compiletime_assert(condition, msg,
>> __compiletime_assert_, __COUNTER__)
>>        |                                             ^
>> ././include/linux/compiler_types.h:468:25: note: in definition of macro
>> ‘__compiletime_assert’
>>    468 |                         prefix ##
>> suffix();                             \
>>        |                         ^~~~~~
>> ././include/linux/compiler_types.h:487:9: note: in expansion of macro
>> ‘_compiletime_assert’
>>    487 |         _compiletime_assert(condition, msg,
>> __compiletime_assert_, __COUNTER__)
>>        |         ^~~~~~~~~~~~~~~~~~~
>> ./include/linux/build_bug.h:39:37: note: in expansion of macro
>> ‘compiletime_assert’
>>     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond),
>> msg)
>>        |                                     ^~~~~~~~~~~~~~~~~~
>> ./include/linux/bitfield.h:68:17: note: in expansion of macro
>> ‘BUILD_BUG_ON_MSG’
>>     68 |                 BUILD_BUG_ON_MSG(__builtin_constant_p(_val)
>> ?           \
>>        |                 ^~~~~~~~~~~~~~~~
>> ./include/linux/bitfield.h:115:17: note: in expansion of macro
>> ‘__BF_FIELD_CHECK’
>>    115 |                 __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP:
>> ");    \
>>        |                 ^~~~~~~~~~~~~~~~
>> arch/arm64/kvm/rme.c:315:16: note: in expansion of macro ‘FIELD_PREP’
>>    315 |         val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps - 1) |
>>        |                ^~~~~~~~~~
>> make[5]: *** [scripts/Makefile.build:244: arch/arm64/kvm/rme.o] Error 1
>> make[4]: *** [scripts/Makefile.build:485: arch/arm64/kvm] Error 2
>> make[3]: *** [scripts/Makefile.build:485: arch/arm64] Error 2
>> make[3]: *** Waiting for unfinished jobs....
>>
>> I'm using gcc-13.3.0 compiler and cross-compiling on X86 machine.
> 
> I'm not sure quite how this happens. The 'value' (bps - 1) shouldn't be
> considered constant, so I don't see how the compiler has decided to
> complain here - the __builtin_constant_p() should really be evaluating to 0.
> 
> The only thing I can think of is if the compiler has somehow determined
> that rmm_feat_reg0 is 0 - which in theory it could do if it knew that
> kvm_init_rme() cannot succeed (rmi_features() would never be called, so
> the variable will never be set). Which makes me wonder if you're
> building with a PAGE_SIZE other than 4k?
> 
> Obviously the code should still build if that's the case (so this would
> be a bug) but we don't currently support CCA with PAGE_SIZE != 4k.
> 

I've encountered this error multiple times with both 4K and 64K, but it's
currently not reproducible. I'll update if the issue reappears. In the
meantime, I've verified the host-v3 and guest-v4 patches using v6.11.rc3,
tested Realm boot, CCA-KVM-UNIT-TESTs, and normal VM boot (without CCA).
No issues have been observed.

Additionally, I've validated Realm and CCA-KVM-UNIT-TESTs on a host with
PSZ=64K. For testing purposes, I modified KVM64 and KVM-UNIT-TESTS to
support PSZ=64K.


Tested-by: Shanker Donthineni <sdonthineni@nvidia.com>


> Steve
> 

