Return-Path: <kvm+bounces-38803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B7DA3E7C8
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 23:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56FF2422CB7
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 22:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46E7264F8A;
	Thu, 20 Feb 2025 22:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Igsmd4k1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C935F1C5D67;
	Thu, 20 Feb 2025 22:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740091870; cv=fail; b=sv2Q3ftluL1dqdeSXK9MLq6hsnugWGBsOQ1aY7nGzZuxu1RMiFLJ7dwoxRSG5BQ4hbaerBT+JZfbHA5k/Xrzm+gI9wRDiJYK5KZ1WfEN09BtMujx1ZbBCzrkuaULc7wH8vHbiWfs1t0oNql7zm54t3OE/gUqc+Q3H0nM6SiLYz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740091870; c=relaxed/simple;
	bh=aBMvUgn9hcbp+VnrPKGAxGg3iCPL+AG0nMYm8uHSyT4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LJ9iX5EI7q7EnTgQfEFxnZSWSgl1JHIjreqdM8g+NJ69pniO76Yrnm9sU1LMxr/Uh4/OoGHt6K8V/u/zPTn8cg1vFz/fJocV1zIAtOeIJquGgN9IHIxi8njivWgOC0NJ55MdFpDZ6JSWHqDcgOitXv7JLCJ7ad6FdD7pn1lVhqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Igsmd4k1; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V86eLQSUnQmE8j3AteJBuTqbUTFnNjaG/+yvARemAwhIT7qt5Fe6IN3zVmRbgpvNhyQP0jQqvLjACZ20U7rcfrUMQ2t3+n8197f6K7t+/Xw4XDkoBFyYZuSotm61GP2s+dsGlrbbrI7fEWPbTKzgNx6waQIb67a1+kYnKrdLwQ3JOHV81fBQdt4kSyrPDRQ9lVRAAmPHzjPGAoBB+ShSMxanFrFygfuElF7HqgL2R2ikOXUv7BoicXlUUnukhPQl3zBGO3C88k3GlcJYPB+bydIspsF6UZFMHD8lAbPF37xcDPQMEd017QfPSQqzVYlV+OIeQ7vQVoTWCUgNdtS5ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFWxDaJdVT8XVO/wVOHRfv8zuDXj4/yGMAxuKSRRFCE=;
 b=rxUY4ZmWeeYGQ+oNqbNRSedY7heAATH4K7M3Y4j9SqUnvIUCGQe9tzB1etkk4j92ItgSPW+RYq6psiF4QZ3nOysNjvoN0eBxD+gkS89Xj3jiRu/x+MUBbvtYm7wUm7bQ9rew9Gqdipdat/EF0PI/hq1BhK79sWrVIEFVduG1BdbYsRTmyXsdvUZiiAeRpEvTNtXc+82V3KiKI2B96MntYhHR4vZAy2m2JRuqFfjl6q86OnPsOHWgRGqAyNaLMG7oFxq1SVOapOApizjulWBORHmmqpgh94leDmqy/ssA/LZ1Xnt9ZYI993JqFfRO+qHL6KLxfgPDs2V0lQAIfgcerQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFWxDaJdVT8XVO/wVOHRfv8zuDXj4/yGMAxuKSRRFCE=;
 b=Igsmd4k1xluGGktP4IH6itMC5sSoM31cVW5a7Y2zYRC8XmOt7sHh4wlx6rF0ncpr5lFDMRQKg+6fHUEVfNH3m1QbwKGoOjyT6b+1pm6L5F8h35Jx7nvty9YwVwn56AELcRZhjGf8UlKT5iXvhz5Tvao0U320/1akukAJX0TiSIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN0PR12MB5907.namprd12.prod.outlook.com (2603:10b6:208:37b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Thu, 20 Feb
 2025 22:51:04 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 22:51:03 +0000
Message-ID: <a9d70abe-d229-81cb-4d9a-6106cef612a4@amd.com>
Date: Thu, 20 Feb 2025 16:51:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 00/10] KVM: SVM: Attempt to cleanup SEV_FEATURES
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250219012705.1495231-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:806:20::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN0PR12MB5907:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fba0a7e-cef6-41f3-7a5f-08dd52010dc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHRmRXFwV1F6OUdHbTlGdWU1NVU1MmRKbStiTWYyL2o5VENUS3ppMWJMWTgr?=
 =?utf-8?B?ZGl3R0Zvb0M2cUM1OTlHQUhLUnR5c3FJaDhJckUvRmJJSGdadlR4WTJ6UFVM?=
 =?utf-8?B?emJ1eWF4NnFNWERIeXl0bks5WENGdElXYyswSm5iNmdYVFpla2crcE1tSExB?=
 =?utf-8?B?Qk8zVVZaaGR3OXNuK1RFS0QwVVVuenE3Y3YwandzNFFyd1A5Rk5XQlhSeWhn?=
 =?utf-8?B?TnBzdDZaVmJIM1Y1NjBJUG1lNitkM3ZmR3FOMEN3WjV3Z0Fwb0N2WlpRMzdF?=
 =?utf-8?B?RlZJcGdxNE8rbkIxbEdaVUtLejFmNjk5dHJQZlZ1cDJ1aFZkbDRDV0pPdWZK?=
 =?utf-8?B?NnEvVFlSbHhzK1lIUE05aWdZd1BoeUFmcnY5MFNoRTdxUER6MjhuQkJPWFRC?=
 =?utf-8?B?Y0R5cWxoZzRpRTNsMXBiMG56SlBJaXMxMTJJVWVOZGM1V0cwUVN5WDRURmgv?=
 =?utf-8?B?OXRrbGd2NE4vbWUrcDdFZzA5V24yK2lWczNvb0dFbDhKVm9qT01YWmtLN1dm?=
 =?utf-8?B?UkFRWHU0T3N1Z2RCTkNuWlNDN0RrQzFjUW52N1ZoSU1YTzljZzNVMFlxL0JL?=
 =?utf-8?B?bDI1SUl3NXlhNGt3NWVoMVhaR05DR3lyVUJZWnBVZmdDanc2L1gxV2J5bk9t?=
 =?utf-8?B?SXE5U0xlTUlId25kV3Axd3BPa2dTN2dPZTlMMHhhenVuYTh3TDYvNWY2U2dG?=
 =?utf-8?B?NHMxMkZaeW81YW9CQVcxUVd5cGhVZ1FXZzAyQXhKK2gwMW1iWG96YnBub3BL?=
 =?utf-8?B?anRKekdrb0tVd25JdFZuazErRGVDckpaWXR1UzlaSnhxQktONHBnWU52Z1o0?=
 =?utf-8?B?cm5ONytYUHBVbGc4VXNLdDFFRnBnOXZCK3BrY1lnS0g5TkFYbEpSNXFlcDNa?=
 =?utf-8?B?NDI5WnVXNUoxY0FXS3MvalJqdlVTK0pwSS9ldC9VTWRWYklWRkJyRlFLSERj?=
 =?utf-8?B?Ty9xWTM0NzlNb0M3c2l5b1lmSDdhL082R0pzRlVaVjAzMFdQZThTYWkzNll0?=
 =?utf-8?B?THV6dmsyZWN1SzN1Qmlac3JqZkNuTjdBSURTa21NenFjOGR4L2FyNi83Zkgw?=
 =?utf-8?B?VXlieS9EQjY2U3haOUhYcVVuK1NoeDRIOFFVVzFqMUMwc1dnVS9Pd3BYektE?=
 =?utf-8?B?ZEJVTDlsV3k4ZUJ3WExyNWpRQnBvM0NXeVFlUk5idXVEalZDT0xkYTZNMU5K?=
 =?utf-8?B?MEM2Q2JuOWNoajdPcC9MeUtiMlZlaWxiWkYwUE9pWTE1Wkp6cXVMWkE3Mkd1?=
 =?utf-8?B?cFA5bVZPVWhpdUhFbDBhQVMyYmU4Y25NSndoVzdhMkxHZm9iR21rUGk4bzNj?=
 =?utf-8?B?bE5QcHJsQXdLM3N4MGltRWhIT1FqRVdPRkpsaEhWcFN3bTVQc2xpSnRFK0c2?=
 =?utf-8?B?MW51Wnd4Y0JCRUcxSUM2UW1lTVpGbzdlS3phcnVlTkRoRTVuQWprUHU5ZHpi?=
 =?utf-8?B?azlweFZuR2thcFlsOS85MHBNTVBhZ2V0dEF3ZE43dnEyaFZ1NkpQd1d2dkE3?=
 =?utf-8?B?NXRWOXZDT2tiNi9KdlltZUxHZkExSDdoeFZic2crUjAvSG9VSlBRUld3UlVN?=
 =?utf-8?B?VDd6eDZDRDhNNERSdWlNa1RzMXQ1Mk4vZVplcmIwaG1RM1RzcEQyUWFTcXI5?=
 =?utf-8?B?NWR2ZDJsQlFCQ3BHbzZlWFdWUXRsdDdMbEMxMUZyK0RZZWprZjRXZ0Mrclll?=
 =?utf-8?B?MVl3TjA5cjZTbDNEaWpoTVREcSs1OTFQN0diQm53eVhkY0EzTXpzM29jdjZD?=
 =?utf-8?B?TC9OUnI3dFNmNHdFbjFldjNWT3Aza3BiZURSL3hjSEJyd3hSNDdYZHJKaHNa?=
 =?utf-8?B?aXdPelhWYUoyMytRQndWcDdxL004RFZrNjlFSW9uTi83bi9qWEEyNVZCS1R6?=
 =?utf-8?Q?C96Exiv2gDqIt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHNSTXlHYzZNWk5CSVZvdVJIa240eVNZS0gwbWo5dnZ0MjMyY2Q2WU1jK2x0?=
 =?utf-8?B?c0FDL09wOU4xVEZ6RGhpRXRYVHR6UFZwdllTeHhqdWk2Uk43bzF0b1RXRlVH?=
 =?utf-8?B?NTVNWnE5SXdBMEZoWjRZNnRXVFEycEZKSUZ4RXJkbEx2OEF5YTN2aDQ4OUNM?=
 =?utf-8?B?MDVURURIQWYzc2p5bU1XeCtaRlRGMEU2aGxJSGpRdXd1THRSemNjbWZ4VTk1?=
 =?utf-8?B?OWZMemtWOENETlIwOGZtVGpNR1BsN052OVhmaXZxYk5XdU10RmZTbU11ajVx?=
 =?utf-8?B?OEdlMWNFL1BtazBZd0xNcm94NjZrRVVJMndObTRpTXIyZjR0VFlEcm93Zklx?=
 =?utf-8?B?VUJPVnFObldJeWpsb3ZOVXBCdktsSFJ2R1FPaFdnR3Q3Q1VJeDUxbVlJR09l?=
 =?utf-8?B?VmZGSmEvSHg1MEMzN2JvL1l1c2JvZVpEYWViNDFpc1FrdXpvNEYxM0lOQXFQ?=
 =?utf-8?B?Qzd1Y1NUUmVSVDd5dmtON0p3WC8weitsTW1GbG12NlgrQzhhTVEweUdMQXpV?=
 =?utf-8?B?ajBuOEc3R3JxMjd4NjZ2WEtwMXI1UjlJby85SnptNHNPLys1RVFDcHEwLzNJ?=
 =?utf-8?B?OFVxc0xMWkExVWVNbzRHMUJ2dE93OWw5b1h5RC9rSi9Xa0lQbHdUMGxrNGMx?=
 =?utf-8?B?UVBmcUpNU1JhbVpBZ1IvdU1WU1lyYTR2Um1zWGFwc1hWQmRHUW45THJTWUNP?=
 =?utf-8?B?U3JyREZYcDBXZS9seFA2a01KdUpZYnVoWE9vVm0rdFZ4bXpJN0d2TU1tUTlI?=
 =?utf-8?B?eW5heFQ5SDNXSDhldE4vVUNiS2VCOVBYT291bWExSFhQSGJ0ZVh2SmpmWlda?=
 =?utf-8?B?TW5ONjFjOEMvYmZpNk93aGJtV3BoNjd1YnYyaGdwc1Mzc21pa3FmcjRQRndB?=
 =?utf-8?B?RGZzYVdkaXJsNklub2tmSVp0UWRjYW80d2ZGb3NvSFJua2paQitDSjhEQ2Vl?=
 =?utf-8?B?bk96algrUmF1bzhTZHNTNmFtdklCd1pTTit5eGZjTTJEOXg0QStTWlNPZnAr?=
 =?utf-8?B?YnlLSDluVUNYU1RnSlN3eXVCd2NET2RXRlEyemVDaU9yNnJHTi91WnpMb1VE?=
 =?utf-8?B?dDRTVWwvOWYvWndwWHBNa2djU1F0ektxK3NkLzR0Wm5YY25VOVIzeDkxYTJP?=
 =?utf-8?B?V1crQVArcnJRMlhBcUZFK2dwQjJuVTBCM0xaZjJScW1YK01KMEtNaHBVUEhj?=
 =?utf-8?B?cnV6a2hqTWVubTFuL1RHMnRXVFNUVEUrVU1zR3h0QUN0OWQwUHZFbzl2dVZk?=
 =?utf-8?B?ZFlPZEZRNTBYNHlIQlRnZEFxNXh5cGR6elpKVVBnbk81NFkrRGlTbVZCTGZl?=
 =?utf-8?B?WTRjcGc0WUhJSFZOVmd6bFhNNWlUb3d3VGVLQVU4ekRLK3djRCtjSS9zVy9D?=
 =?utf-8?B?cFd3RGxsaFFmTVM4aEE2bVQzZmZUL3lkSVBYcGdod1ZzV1dxRmJsRlpqRS82?=
 =?utf-8?B?RDNneUlLWkRKbFFGejY4K2gwTVBUamwwRnNhVDBMaFpYRG40bjhwQnd4UlJI?=
 =?utf-8?B?QUJPdDBIVzFvR01HemZQQ3BHeEo3YmJHUVVTWmFmVDhuTFN3SGZjRVdFelAx?=
 =?utf-8?B?Rk9qNEY1YnYwN0pFWVh6VXNlQnMzR1daUzBmQ0hkT0ZqdU1McVNXaUZhcm9B?=
 =?utf-8?B?cG1TTVpsTTVxLzZLOGVBTTVja0EwRnM5ZEJkaDVqWmV5d3dZT3poM0R1K0FX?=
 =?utf-8?B?a3I1Y1hhVkhwcjVJOUt1azBLYmR0amdWUWZENjVSOXo3clJCU0VlZ1d1ak9z?=
 =?utf-8?B?ZWdKRG03a2pmVm9NSDRRUXlaYjB1UG9kTklGOVZYbmgvSjJVRkJiT0tpMVNI?=
 =?utf-8?B?YXdBNW0yQTE3bGh2dUlpcmNHUHkwN2RyTHVMSFlNU0xsZnpXb1U1dFdhaGVz?=
 =?utf-8?B?OGY3OFY1a2tOWEpGd0gwaWxuTzhCc2FjYWlHZGZRVHIwZHM1ZlU2cHZtVGlL?=
 =?utf-8?B?SzdjdVFMRGxYYTBOQjBWWlBsNzBCMVUvYUJ5RXpaL3Q2THFOQmR4MUVEUVlR?=
 =?utf-8?B?b2pESnNJdnRvQVR2Z0I5ZWtMcmZQUXdlV09hUS9oaGhxQlFuS0c2NnZmUkFP?=
 =?utf-8?B?aUVnRVRMaTcrMmMvMndBQ2p3ZEZvSnczVEhWY1lZclZ6T0lLWDBBa2gxQWpo?=
 =?utf-8?Q?HHf0MzLv0f+ROTEYFQkctDqAP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fba0a7e-cef6-41f3-7a5f-08dd52010dc3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 22:51:03.7701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jF1lodbbmey2jG1Pqh4G+3C2zOJFxzzqqjuLDAyAj69JFcACoXt07vqTuuWDfm0WPleJ1sb8+Z/4enqT65pplA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5907

On 2/18/25 19:26, Sean Christopherson wrote:
> This is a hastily thrown together series, barely above RFC, to try and
> address the worst of the issues that arise with guest controlled SEV
> features (thanks AP creation)[1].
> 
> In addition to the initial flaws with DebugSwap, I came across a variety
> of issues when trying to figure out how best to handle SEV features in
> general.  E.g. AFAICT, KVM doesn't guard against userspace manually making
> a vCPU RUNNABLE after it has been DESTROYED (or after a failed CREATE).
> 
> This is essentially compile-tested only, as I don't have easy access to a
> system with SNP enabled.  I ran the SEV-ES selftests, but that's not much
> in the way of test coverage.
> 
> AMD folks, I would greatly appreciate reviews, testing, and most importantly,
> confirmation that all of this actually works the way I think it does.

A quick test of a 64 vCPU SNP guest booted successfully, so that's a
good start. I'll take a closer look at these patches over the next few days.

Thanks,
Tom

> 
> [1] https://lore.kernel.org/all/Z7TSef290IQxQhT2@google.com
> 
> Sean Christopherson (10):
>   KVM: SVM: Save host DR masks but NOT DRs on CPUs with DebugSwap
>   KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
>   KVM: SVM: Terminate the VM if a SEV-ES+ guest is run with an invalid
>     VMSA
>   KVM: SVM: Don't change target vCPU state on AP Creation VMGEXIT error
>   KVM: SVM: Require AP's "requested" SEV_FEATURES to match KVM's view
>   KVM: SVM: Simplify request+kick logic in SNP AP Creation handling
>   KVM: SVM: Use guard(mutex) to simplify SNP AP Creation error handling
>   KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
>   KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates
>   KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure
> 
>  arch/x86/kvm/svm/sev.c | 218 +++++++++++++++++++----------------------
>  arch/x86/kvm/svm/svm.c |   7 +-
>  arch/x86/kvm/svm/svm.h |   2 +-
>  3 files changed, 106 insertions(+), 121 deletions(-)
> 
> 
> base-commit: fed48e2967f402f561d80075a20c5c9e16866e53

