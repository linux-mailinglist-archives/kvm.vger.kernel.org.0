Return-Path: <kvm+bounces-26829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D4E978530
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26808289C9E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 15:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330B26F2E7;
	Fri, 13 Sep 2024 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TXZ7NoU2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D782EB02;
	Fri, 13 Sep 2024 15:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726242744; cv=fail; b=g81Aur6dJ+/AXQdw8c7RGSZ/BipIPqrG3Kjlo3sMwx67kgKH9IHit59HN6yeq3DGXXH7PAW5OqiifSa+2jONHQ8bwneS+r445hf60oRLqJJ+fUE7ELy1K+JFx1Qcb/rRRDWV8O7yjE7FwpSQoAUBL4rbZqQl3A8ILT9Cj7hNWX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726242744; c=relaxed/simple;
	bh=C57RYundqNeRLKvuJTS62OJtiyBbQitfVPBxPuJi5tY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JmZP7UOpX30aAVHk58o+1El5umxED9/Mp24TZrmuRIAlvSgqpis/pW6Hy6GS0B57MEBNSNLHmbo1XHezNhj2bcFONQ9Jr+6HLz9vPWqDKEGjG6OyEz+70cknAZgm5dPv047xAiCL+waai8FwEj4AJraWhzbP1ABrIyyvsj5KhYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TXZ7NoU2; arc=fail smtp.client-ip=40.107.93.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vcZMkywEW7/R3LupTEVejkb4Xk73FWcQtLHNaAhm5JJ1qjdj6m5+dVTnpnWUs/QXtsKQdXS8RH+9e5Vx1x2vj3bhhGVm892pFR0Y0zDzdKsV0C8d2cHHugwbnh2RmXR8teW5X46Nm1/Yo3Jd9sVnyQEDUR+6kOmgTtt92sIpIoczsVoFMNED3IlM++uwv1pQ81lrTy0/xX2cIex8s4y6OtMLGWSG1NlW4hbd0QQHED8XEFdAI0y9s2ZQ6iOpQXyhLwjvKJYxR7AW6AZ3TTxOVWfqYCU6C8/XTPtHUD8LmkOdta4lSCkuWtmOqID2pRObgUhhi8bEUAVQU+tKoX2z5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHJYN3kV6z3ilTOdn+TzE35uWiO3QHT3No6BI7hWhMY=;
 b=RXY3DwkqJyPO6uRtRUkX/NWuoPUJR+wXsxKRazxK9oKav25X4kIXQfAfnsVpYFQ7TjLaDul2c3M79qmPUx7bBt6neueuZhrITHWfKZLI/y4DzWrnZC1oEqP/ysBiwb/dzSEymrDExrsceMQniF2793RrTdjlc1ZDn5yLiz6RokaXZV7JOIjwdBpZ7bw4EZjKLY7ggoPhpYwu3A4x7Ix0w2gzS78OJwjpXEbRGQPRh1fwkkHyUAdnbtLg//d6WCh4SqdcL/CDRPuYUlIyGiK+6V+uN3bMb/csM+Tj1a2aK+Wbf3WfsYQ1/+krSKda2cGtjP6KPDYpXJ5auF6nEOmc4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHJYN3kV6z3ilTOdn+TzE35uWiO3QHT3No6BI7hWhMY=;
 b=TXZ7NoU2FJq0/x2hHZitxE18Ax4XRV/d0tmNbDgq676k872Ln7Dub3XJTczgtu1cu91WtdKNcM1+qcdCUELLOMlh90K3UVSafWmKTJl7S08sMUVHTVsAAf8rEFlfyHGnCddw/rnwuWU+Id8seB4tp4mtwVMwUP5G8tsuABnCijo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV2PR12MB5750.namprd12.prod.outlook.com (2603:10b6:408:17e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Fri, 13 Sep
 2024 15:52:19 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 15:52:18 +0000
Message-ID: <8824e7fd-4dcb-7d2c-0455-ae85d481331e@amd.com>
Date: Fri, 13 Sep 2024 10:52:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 10/20] virt: sev-guest: Carve out SNP message context
 structure
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-11-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-11-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:806:130::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV2PR12MB5750:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d73fb3-b98a-467c-c110-08dcd40c0bf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGxVWjUrOUMrd2dMZjl4Q0RtVExMTzA1QnZjY21hM0thUVAzNjJlWi83YURE?=
 =?utf-8?B?K3RXd2lVejZmOVFFb2RHOTdzbWRwcTJaU0ZaSjFWb3V1amZ0ZXpKbnI4RUgw?=
 =?utf-8?B?c0oweTkxckE4ZjdwRzVsaG9nb0NFbkdIRGNKNmI5WDNMSU5nRXEvV3hHUmpI?=
 =?utf-8?B?NzVBcnFOemZZaDBVanNSNUcwSlJKN3hqOVl5eEJ1djVTN2lUWmVHQVJYdmhD?=
 =?utf-8?B?VktacFZIdm9LT1dtWTAyUFM4ZlU2TzliSENzOUJoYWV2Y3R2SEdBSE1Ka29i?=
 =?utf-8?B?T2tqdWgveUlvSzhneFArQ21lendHa25tWmt0Z2s4UUNNTENrYTcvQ2lHcFZy?=
 =?utf-8?B?MW9lYVNCQWREL1FaR3Iwekw0UFcyMys0RlVZUDlxMFRFUjFyS2M0em0vOVdC?=
 =?utf-8?B?YTZ3cXBaYm9lYWYvQWtsckFCalpJV0tzZUNkaTNCZlUwS1AvdkFDeEw4b2hr?=
 =?utf-8?B?RHI0RW4xRWx2Yy8xTUZSMVBsTmhNSm1oZWtlbE9ncExpMk4zRW1tQWRUeW5u?=
 =?utf-8?B?WDNrYWtpVXJrQ2UxeFN0anppa1J4V0ZJUnphbG1ncWxUeVBCdXF4a3lURXJw?=
 =?utf-8?B?RVczajJzRURkRUw0V21tQ2FaWVZ0eWthL2FoRFlaV1ptbUtoMWh4SWtQTDlu?=
 =?utf-8?B?b1ZiV3R3SjVENjBwc255aDB3a2p5UzVnZlUyT3ZvMTIybFY4U1hmZVN0WDA3?=
 =?utf-8?B?YnU5WkJ1N3lKU0lWVW16b01JTjZFWG9lbTVnVFE3SUtsRzhObENLRUpDQTRO?=
 =?utf-8?B?YmN0R1lTOXNmdVo2NWJoMTJBNUUrcnBuRld2d2NTSXJTT01iaEZMWHUxaDVT?=
 =?utf-8?B?WjNEVGRTU2dIcUVxamYyU24xUHlTcWh6dmp1UVFWWjFoNVNjYU5LQkJobmdz?=
 =?utf-8?B?eFNycjM1am1rRjlyZWc0VS96QXdDdkx4bk5wdGVSbHllcWt2aGlETTdpemh3?=
 =?utf-8?B?TXNQaGcwUXdlUlhDWFE4ZGlpQTVuMjdUWis5K2pXSGsvcUFLeWFjS2RJaS9w?=
 =?utf-8?B?VFF2U0cySUp2N0FWbTA1WCtXdWFWS2NzNzdTeCtnWWRLUDhSYmw2bTFzNzRB?=
 =?utf-8?B?QzJUcnRXRFlLL2loM08va1VHV2NFNGMzTXlyWWxJcmxGUUlTeFdmMW5uRGF1?=
 =?utf-8?B?UmFmdFVReG1jSDNacXFSbjJENExJT1ZxQ0pqOFh2NHlDbFo0TDduckVFeVhl?=
 =?utf-8?B?aEJoSnpwSTJSM1gzUGg1aEhzVnFJWEdvQmNvZ29JMllPNnIrSHlLRVVrdURD?=
 =?utf-8?B?a21OOU90UjJsUkd3NDZNd2lyMDdVZEI0bFIyNGluOWk2QmlHcUpBZmpwWEZK?=
 =?utf-8?B?eGplZEMxK3ZOL3d1RzVXVk1LRE5JT1dQbTNYZVd3UXFMYTZrTi9mdHJad2o5?=
 =?utf-8?B?VnczejFBakxXSlZLT2pWbk5STXRIYlE5WEZNeFdGSnpqUzN3V0FudVgrNlF1?=
 =?utf-8?B?b2xuK0hUNjFtOWN1RmN1cWJiakRWVDVqMGZKWDhhbEZCclF1MFFWcGxvcHhw?=
 =?utf-8?B?Ym5GaURwZ1k3a0E0TWFucHpSSmZxeDl1Um1pSFgrZm1OYWRHMWtlZ2NIZXQx?=
 =?utf-8?B?MTZGMEJadFJnUTFzeTZKOFVTU0hvZncyYk8wMWE4OWQ0anNRVFo4RktCdHNV?=
 =?utf-8?B?U0s0TXFPZDZDVUk1cloxNldJeDRkaWUyUmRsMWdwcndtc0taTjlTYUVBOXNY?=
 =?utf-8?B?Vjcra2hJZ1RWMmswZ084QzJDR1QwejcyYlJLQlV0SGU1VGY3MFpnYWUyQjUr?=
 =?utf-8?B?M0NIOGF3L1ZlYXZybm4vUlpEbDAxY202T3FiYnM2MmZxQktzVTBnaDNDM0Jt?=
 =?utf-8?B?TEVLV09kMnNpSTVLblN5Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDhBTjZiK2gxMVNDeEphQUtMTHc0YklGemgvVFBkTkZLdllpZjhBbjVKVVFD?=
 =?utf-8?B?Z0xEUS9naDJ6Tm9wTkpYdjY5QlpBSjVGdWd3YzZheUtNYTFwcmV2UWR4dnRP?=
 =?utf-8?B?TFFVRUlZenJvNEVtSTRZM0J5Z3ZNSXQxekczU3YxdlU2MDBtbkljbytXMks2?=
 =?utf-8?B?Vi8wRkpPVGk1MmpIMzRDRWJEOUxTaHgyZ0h0VzNkSm1iNXVCYW5UZTY1aXNp?=
 =?utf-8?B?bmtOTVExdUEra0xlZnE0T3NjTGozZTkzVTYxTmQrVTVqd1BnRmdOQ29iRzZK?=
 =?utf-8?B?ODZMNmpFNzRIUm5ZeGVISml1TXQzUHVyVm1UOWJtVWo0cldDVHcyZ0FqT1JL?=
 =?utf-8?B?RHdWRWhyRVRNV3VaZ1ZpdEgxV2NNYStTOHpjamJGOE1IcVlhcEpFeDh4NFlT?=
 =?utf-8?B?ZGRPOWhFdU9NNFdnS0VpMnJKSUo2TnFFNmNEN0lXcVhiVWJvT3ZBYmlONmxZ?=
 =?utf-8?B?L0M4V2NaRC9LZkxYNTlDQkZQRVRHTXo0bkFibGQvNnB1VHJtWnFna2V3NFpu?=
 =?utf-8?B?K1VHTk9WZlRIaFFxTmFLV2xMVzdldUhIQXV0bjNQME55TVBhMnpHVk91Vld4?=
 =?utf-8?B?NmNKVzRQUVlHVlpqNmNJN0RaUWNtYVVWeXYrWUpHZ1N1dXpOR1RQOEUxNkFh?=
 =?utf-8?B?RDhTQ24yRjh0bkJseG4wdXd6TUp5T2taaG01dEpnSmhxZ2hSWjhrTEw2c1p5?=
 =?utf-8?B?bThINUF5TWV5QStpZERWTkM3WXJiT0VTOTdCZjRrY1NIVEdCQkNrck5SQzg1?=
 =?utf-8?B?dmlFR3RMVVgzYW5LOFI3NkQwanRVUFF4Sjl5c28wSEljQmREdmoxaGpEQXdj?=
 =?utf-8?B?eFdDamNleW1sWVg3Y0NUdVRoMTdvZWl1OHl2ZWFTOXNSY1NJK2pvdk5uLy9H?=
 =?utf-8?B?cENyeXpOVGJhUnFzNGY0bmIxaEI3bVZmYnpIamx3SkFxdEVvRDhuZU9nNHgw?=
 =?utf-8?B?Z2pxUzF1RytrRkdmRzdZOW9CYk53c2tFRkQveDhiVVVYZFp4YzhRY3o4ZXhw?=
 =?utf-8?B?MEMvTXp2QWtkQXZxUE0rTm1TWllRMTkxMTMrWGttM3FtNUxHNm9mZmJhM0VH?=
 =?utf-8?B?V1YySll2SlE4K2lranFiUEpXRDBCcDBsSFZhdXZWQXdrVjQ0ZkJXT2Zidkcw?=
 =?utf-8?B?b2JyaS9GT3ZrTlI3QlU3cWVIVVVEV0s4VEpXVUc5bEVmS28xd2t2WWw0aG5w?=
 =?utf-8?B?bnc1clVUbWxsOUxtSUFieUp6OWZ0akFKNFA1aXMzODhZc2d0UDhJRXlWdU1N?=
 =?utf-8?B?Zy8ySDYwckFMVkZaVEd3TUFNYTZTeDBha0NQd2lyQitBMmVId1RHV1BEeFMr?=
 =?utf-8?B?Vk44azkrQVZwbW9WVXpFMGFHb043VHRncFVoMkpoT3RXWE5aRWlCTDh1RU1y?=
 =?utf-8?B?UmdoSUtLSUZmYm9lT000eTV1VitPKzNIMjkrN2tQb3JMNXk5U2paOUwyejJR?=
 =?utf-8?B?eVRzVkdxenBrZHpmSHNxNkY0bDZYckQxL2FGMVJQaFBuMVZkR3N5MktPajhq?=
 =?utf-8?B?V3FPRXdVR201cThJVjJlUVd5Z3VlMWVMajF3MVh5MG5lSWxTdmY5UUhGeEJM?=
 =?utf-8?B?WWRWdzlzZWliYTV5WjlOeWVwb1RLTHJxTjVaZWd6Z0pMM0VlR1ZMbUUrUjdL?=
 =?utf-8?B?ZWNsUTdta0ZpME1HY3FFdmxoZG45NXJUMVBLQjYyaXU4dkwrYlNqTml6SEkr?=
 =?utf-8?B?UXpsNkhFaUp0Vi9Hb3JHc3lFMUt0cjZ0UXY2Q3dDSHlVRUhnWmR3T3hBTnFq?=
 =?utf-8?B?TENwWUZ4TUNpamdjQ0hwa2RieGMvb01nQ0hXdmdOclMxTHJYM2ZqV29FNlJX?=
 =?utf-8?B?VFNuK0M5K1NuK3B0RXZpa2tUY3RsQVI4QTlQYUc3TWZFbEFIZVh1K292OE03?=
 =?utf-8?B?bFVaWHdtRDh2MGk2QldCT29UaWU0WXg4Y1ppS3N6WGNzb09UWjNFSHZKOFRY?=
 =?utf-8?B?bGlBdUtLaEt1MEEySksvRm9BcHdiajRpMitMKzNESFM5L2lzQlIxKzRJZnYz?=
 =?utf-8?B?K0p2c2pSOHd0ZGcxZHlBcG5qcDFOaUdkanFaejFpV1l2eFBQbzhqeVVYaTVI?=
 =?utf-8?B?dFBrdlgyTnpnVGNJeWJEMlRKMjBoS0ZZSjVOMkQ1ZmpHTmFWYUV4cm9JOUJX?=
 =?utf-8?Q?gVdv9AoRjZvqKBx3bmfVFN8cb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d73fb3-b98a-467c-c110-08dcd40c0bf7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 15:52:18.7465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZWsjOfy9t0uJg6KSsugkU5l9VKWD/w0dnM5yCOqRbGRssBl9RJ13Pe9Xk/039dFyYo7Pillgp4n0zHbC4eiOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5750

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> Currently, the sev-guest driver is the only user of SNP guest messaging.
> snp_guest_dev structure holds all the allocated buffers, secrets page and

The snp_guest_dev structure...

> VMPCK details. In preparation of adding messaging allocation and

s/of/for/

> initialization APIs, decouple snp_guest_dev from messaging-related
> information by carving out guest message context structure(snp_msg_desc).

s/out guest/out the guest/

> 
> Incorporate this newly added context into snp_send_guest_request() and all
> related functions, replacing the use of the snp_guest_dev.
> 
> No functional change.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev.h              |  21 +++
>  drivers/virt/coco/sev-guest/sev-guest.c | 183 ++++++++++++------------
>  2 files changed, 111 insertions(+), 93 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 27fa1c9c3465..2e49c4a9e7fe 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -234,6 +234,27 @@ struct snp_secrets_page {
>  	u8 rsvd4[3744];
>  } __packed;
>  
> +struct snp_msg_desc {
> +	/* request and response are in unencrypted memory */
> +	struct snp_guest_msg *request, *response;
> +
> +	/*
> +	 * Avoid information leakage by double-buffering shared messages
> +	 * in fields that are in regular encrypted memory.
> +	 */
> +	struct snp_guest_msg secret_request, secret_response;
> +
> +	struct snp_secrets_page *secrets;
> +	struct snp_req_data input;
> +
> +	void *certs_data;
> +
> +	struct aesgcm_ctx *ctx;
> +
> +	u32 *os_area_msg_seqno;
> +	u8 *vmpck;
> +};
> +
>  /*
>   * The SVSM Calling Area (CA) related structures.
>   */
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 42f7126f1718..38ddabcd7ba3 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -40,26 +40,13 @@ struct snp_guest_dev {
>  	struct device *dev;
>  	struct miscdevice misc;
>  
> -	void *certs_data;
> -	struct aesgcm_ctx *ctx;
> -	/* request and response are in unencrypted memory */
> -	struct snp_guest_msg *request, *response;
> -
> -	/*
> -	 * Avoid information leakage by double-buffering shared messages
> -	 * in fields that are in regular encrypted memory.
> -	 */
> -	struct snp_guest_msg secret_request, secret_response;
> +	struct snp_msg_desc *msg_desc;
>  
> -	struct snp_secrets_page *secrets;
> -	struct snp_req_data input;
>  	union {
>  		struct snp_report_req report;
>  		struct snp_derived_key_req derived_key;
>  		struct snp_ext_report_req ext_report;
>  	} req;
> -	u32 *os_area_msg_seqno;
> -	u8 *vmpck;
>  };
>  
>  /*
> @@ -76,12 +63,12 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
>  /* Mutex to serialize the shared buffer access and command handling. */
>  static DEFINE_MUTEX(snp_cmd_mutex);
>  
> -static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
> +static bool is_vmpck_empty(struct snp_msg_desc *mdesc)
>  {
>  	char zero_key[VMPCK_KEY_LEN] = {0};
>  
> -	if (snp_dev->vmpck)
> -		return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
> +	if (mdesc->vmpck)
> +		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
>  
>  	return true;
>  }
> @@ -103,30 +90,30 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>   * vulnerable. If the sequence number were incremented for a fresh IV the ASP
>   * will reject the request.
>   */
> -static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
> +static void snp_disable_vmpck(struct snp_msg_desc *mdesc)
>  {
> -	dev_alert(snp_dev->dev, "Disabling VMPCK%d communication key to prevent IV reuse.\n",
> +	pr_alert("Disabling VMPCK%d communication key to prevent IV reuse.\n",
>  		  vmpck_id);
> -	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
> -	snp_dev->vmpck = NULL;
> +	memzero_explicit(mdesc->vmpck, VMPCK_KEY_LEN);
> +	mdesc->vmpck = NULL;
>  }
>  
> -static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
> +static inline u64 __snp_get_msg_seqno(struct snp_msg_desc *mdesc)
>  {
>  	u64 count;
>  
>  	lockdep_assert_held(&snp_cmd_mutex);
>  
>  	/* Read the current message sequence counter from secrets pages */
> -	count = *snp_dev->os_area_msg_seqno;
> +	count = *mdesc->os_area_msg_seqno;
>  
>  	return count + 1;
>  }
>  
>  /* Return a non-zero on success */
> -static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
> +static u64 snp_get_msg_seqno(struct snp_msg_desc *mdesc)
>  {
> -	u64 count = __snp_get_msg_seqno(snp_dev);
> +	u64 count = __snp_get_msg_seqno(mdesc);
>  
>  	/*
>  	 * The message sequence counter for the SNP guest request is a  64-bit
> @@ -137,20 +124,20 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>  	 * invalid number and will fail the  message request.
>  	 */
>  	if (count >= UINT_MAX) {
> -		dev_err(snp_dev->dev, "request message sequence counter overflow\n");
> +		pr_err("request message sequence counter overflow\n");
>  		return 0;
>  	}
>  
>  	return count;
>  }
>  
> -static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
> +static void snp_inc_msg_seqno(struct snp_msg_desc *mdesc)
>  {
>  	/*
>  	 * The counter is also incremented by the PSP, so increment it by 2
>  	 * and save in secrets page.
>  	 */
> -	*snp_dev->os_area_msg_seqno += 2;
> +	*mdesc->os_area_msg_seqno += 2;
>  }
>  
>  static inline struct snp_guest_dev *to_snp_dev(struct file *file)
> @@ -177,13 +164,13 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
>  	return ctx;
>  }
>  
> -static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
> +static int verify_and_dec_payload(struct snp_msg_desc *mdesc, struct snp_guest_req *req)
>  {
> -	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
> -	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
> +	struct snp_guest_msg *resp_msg = &mdesc->secret_response;
> +	struct snp_guest_msg *req_msg = &mdesc->secret_request;
>  	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
>  	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
> -	struct aesgcm_ctx *ctx = snp_dev->ctx;
> +	struct aesgcm_ctx *ctx = mdesc->ctx;
>  	u8 iv[GCM_AES_IV_SIZE] = {};
>  
>  	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
> @@ -191,7 +178,7 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_gues
>  		 resp_msg_hdr->msg_sz);
>  
>  	/* Copy response from shared memory to encrypted memory. */
> -	memcpy(resp_msg, snp_dev->response, sizeof(*resp_msg));
> +	memcpy(resp_msg, mdesc->response, sizeof(*resp_msg));
>  
>  	/* Verify that the sequence counter is incremented by 1 */
>  	if (unlikely(resp_msg_hdr->msg_seqno != (req_msg_hdr->msg_seqno + 1)))
> @@ -218,11 +205,11 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_gues
>  	return 0;
>  }
>  
> -static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
> +static int enc_payload(struct snp_msg_desc *mdesc, u64 seqno, struct snp_guest_req *req)
>  {
> -	struct snp_guest_msg *msg = &snp_dev->secret_request;
> +	struct snp_guest_msg *msg = &mdesc->secret_request;
>  	struct snp_guest_msg_hdr *hdr = &msg->hdr;
> -	struct aesgcm_ctx *ctx = snp_dev->ctx;
> +	struct aesgcm_ctx *ctx = mdesc->ctx;
>  	u8 iv[GCM_AES_IV_SIZE] = {};
>  
>  	memset(msg, 0, sizeof(*msg));
> @@ -253,7 +240,7 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_gues
>  	return 0;
>  }
>  
> -static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
> +static int __handle_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>  				  struct snp_guest_request_ioctl *rio)
>  {
>  	unsigned long req_start = jiffies;
> @@ -268,7 +255,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
>  	 * sequence number must be incremented or the VMPCK must be deleted to
>  	 * prevent reuse of the IV.
>  	 */
> -	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
> +	rc = snp_issue_guest_request(req, &mdesc->input, rio);
>  	switch (rc) {
>  	case -ENOSPC:
>  		/*
> @@ -278,7 +265,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
>  		 * order to increment the sequence number and thus avoid
>  		 * IV reuse.
>  		 */
> -		override_npages = snp_dev->input.data_npages;
> +		override_npages = mdesc->input.data_npages;
>  		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
>  
>  		/*
> @@ -318,7 +305,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
>  	 * structure and any failure will wipe the VMPCK, preventing further
>  	 * use anyway.
>  	 */
> -	snp_inc_msg_seqno(snp_dev);
> +	snp_inc_msg_seqno(mdesc);
>  
>  	if (override_err) {
>  		rio->exitinfo2 = override_err;
> @@ -334,12 +321,12 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
>  	}
>  
>  	if (override_npages)
> -		snp_dev->input.data_npages = override_npages;
> +		mdesc->input.data_npages = override_npages;
>  
>  	return rc;
>  }
>  
> -static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
> +static int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>  				  struct snp_guest_request_ioctl *rio)
>  {
>  	u64 seqno;
> @@ -348,15 +335,15 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
>  	guard(mutex)(&snp_cmd_mutex);
>  
>  	/* Get message sequence and verify that its a non-zero */
> -	seqno = snp_get_msg_seqno(snp_dev);
> +	seqno = snp_get_msg_seqno(mdesc);
>  	if (!seqno)
>  		return -EIO;
>  
>  	/* Clear shared memory's response for the host to populate. */
> -	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
> +	memset(mdesc->response, 0, sizeof(struct snp_guest_msg));
>  
> -	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
> -	rc = enc_payload(snp_dev, seqno, req);
> +	/* Encrypt the userspace provided payload in mdesc->secret_request. */
> +	rc = enc_payload(mdesc, seqno, req);
>  	if (rc)
>  		return rc;
>  
> @@ -364,34 +351,33 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
>  	 * Write the fully encrypted request to the shared unencrypted
>  	 * request page.
>  	 */
> -	memcpy(snp_dev->request, &snp_dev->secret_request,
> -	       sizeof(snp_dev->secret_request));
> +	memcpy(mdesc->request, &mdesc->secret_request,
> +	       sizeof(mdesc->secret_request));
>  
> -	rc = __handle_guest_request(snp_dev, req, rio);
> +	rc = __handle_guest_request(mdesc, req, rio);
>  	if (rc) {
>  		if (rc == -EIO &&
>  		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
>  			return rc;
>  
> -		dev_alert(snp_dev->dev,
> -			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
> -			  rc, rio->exitinfo2);
> +		pr_alert("Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
> +			 rc, rio->exitinfo2);
>  
> -		snp_disable_vmpck(snp_dev);
> +		snp_disable_vmpck(mdesc);
>  		return rc;
>  	}
>  
> -	rc = verify_and_dec_payload(snp_dev, req);
> +	rc = verify_and_dec_payload(mdesc, req);
>  	if (rc) {
> -		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
> -		snp_disable_vmpck(snp_dev);
> +		pr_alert("Detected unexpected decode failure from ASP. rc: %d\n", rc);
> +		snp_disable_vmpck(mdesc);
>  		return rc;
>  	}
>  
>  	return 0;
>  }
>  
> -static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
> +static int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code,
>  				struct snp_guest_request_ioctl *rio, u8 type,
>  				void *req_buf, size_t req_sz, void *resp_buf,
>  				u32 resp_sz)
> @@ -407,7 +393,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>  		.exit_code	= exit_code,
>  	};
>  
> -	return snp_send_guest_request(snp_dev, &req, rio);
> +	return snp_send_guest_request(mdesc, &req, rio);
>  }
>  
>  struct snp_req_resp {
> @@ -418,6 +404,7 @@ struct snp_req_resp {
>  static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>  {
>  	struct snp_report_req *report_req = &snp_dev->req.report;
> +	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
>  	struct snp_report_resp *report_resp;
>  	int rc, resp_len;
>  
> @@ -432,12 +419,12 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>  	 * response payload. Make sure that it has enough space to cover the
>  	 * authtag.
>  	 */
> -	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
> +	resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
>  	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
>  	if (!report_resp)
>  		return -ENOMEM;
>  
> -	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
> +	rc = handle_guest_request(mdesc, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
>  				  report_req, sizeof(*report_req), report_resp->data, resp_len);
>  	if (rc)
>  		goto e_free;
> @@ -454,6 +441,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>  {
>  	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
>  	struct snp_derived_key_resp derived_key_resp = {0};
> +	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
>  	int rc, resp_len;
>  	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
>  	u8 buf[64 + 16];
> @@ -466,7 +454,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>  	 * response payload. Make sure that it has enough space to cover the
>  	 * authtag.
>  	 */
> -	resp_len = sizeof(derived_key_resp.data) + snp_dev->ctx->authsize;
> +	resp_len = sizeof(derived_key_resp.data) + mdesc->ctx->authsize;
>  	if (sizeof(buf) < resp_len)
>  		return -ENOMEM;
>  
> @@ -474,7 +462,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>  			   sizeof(*derived_key_req)))
>  		return -EFAULT;
>  
> -	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_KEY_REQ,
> +	rc = handle_guest_request(mdesc, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_KEY_REQ,
>  				  derived_key_req, sizeof(*derived_key_req), buf, resp_len);
>  	if (rc)
>  		return rc;
> @@ -495,6 +483,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>  
>  {
>  	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
> +	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
>  	struct snp_report_resp *report_resp;
>  	int ret, npages = 0, resp_len;
>  	sockptr_t certs_address;
> @@ -527,7 +516,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>  	 * the host. If host does not supply any certs in it, then copy
>  	 * zeros to indicate that certificate data was not provided.
>  	 */
> -	memset(snp_dev->certs_data, 0, report_req->certs_len);
> +	memset(mdesc->certs_data, 0, report_req->certs_len);
>  	npages = report_req->certs_len >> PAGE_SHIFT;
>  cmd:
>  	/*
> @@ -535,19 +524,19 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>  	 * response payload. Make sure that it has enough space to cover the
>  	 * authtag.
>  	 */
> -	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
> +	resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
>  	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
>  	if (!report_resp)
>  		return -ENOMEM;
>  
> -	snp_dev->input.data_npages = npages;
> -	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
> +	mdesc->input.data_npages = npages;
> +	ret = handle_guest_request(mdesc, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
>  				   &report_req->data, sizeof(report_req->data),
>  				   report_resp->data, resp_len);
>  
>  	/* If certs length is invalid then copy the returned length */
>  	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
> -		report_req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
> +		report_req->certs_len = mdesc->input.data_npages << PAGE_SHIFT;
>  
>  		if (copy_to_sockptr(io->req_data, report_req, sizeof(*report_req)))
>  			ret = -EFAULT;
> @@ -556,7 +545,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>  	if (ret)
>  		goto e_free;
>  
> -	if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, report_req->certs_len)) {
> +	if (npages && copy_to_sockptr(certs_address, mdesc->certs_data, report_req->certs_len)) {
>  		ret = -EFAULT;
>  		goto e_free;
>  	}
> @@ -572,6 +561,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>  static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  {
>  	struct snp_guest_dev *snp_dev = to_snp_dev(file);
> +	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
>  	void __user *argp = (void __user *)arg;
>  	struct snp_guest_request_ioctl input;
>  	struct snp_req_resp io;
> @@ -587,7 +577,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>  		return -EINVAL;
>  
>  	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(snp_dev)) {
> +	if (is_vmpck_empty(mdesc)) {
>  		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>  		return -ENOTTY;
>  	}
> @@ -862,7 +852,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
>  		return -ENOMEM;
>  
>  	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(snp_dev)) {
> +	if (is_vmpck_empty(snp_dev->msg_desc)) {
>  		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>  		return -ENOTTY;
>  	}
> @@ -992,6 +982,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	struct snp_secrets_page *secrets;
>  	struct device *dev = &pdev->dev;
>  	struct snp_guest_dev *snp_dev;
> +	struct snp_msg_desc *mdesc;
>  	struct miscdevice *misc;
>  	void __iomem *mapping;
>  	int ret;
> @@ -1014,46 +1005,50 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	if (!snp_dev)
>  		goto e_unmap;
>  
> +	mdesc = devm_kzalloc(&pdev->dev, sizeof(struct snp_msg_desc), GFP_KERNEL);
> +	if (!mdesc)
> +		goto e_unmap;
> +
>  	/* Adjust the default VMPCK key based on the executing VMPL level */
>  	if (vmpck_id == -1)
>  		vmpck_id = snp_vmpl;
>  
>  	ret = -EINVAL;
> -	snp_dev->vmpck = get_vmpck(vmpck_id, secrets, &snp_dev->os_area_msg_seqno);
> -	if (!snp_dev->vmpck) {
> +	mdesc->vmpck = get_vmpck(vmpck_id, secrets, &mdesc->os_area_msg_seqno);
> +	if (!mdesc->vmpck) {
>  		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
>  		goto e_unmap;
>  	}
>  
>  	/* Verify that VMPCK is not zero. */
> -	if (is_vmpck_empty(snp_dev)) {
> +	if (is_vmpck_empty(mdesc)) {
>  		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
>  		goto e_unmap;
>  	}
>  
>  	platform_set_drvdata(pdev, snp_dev);
>  	snp_dev->dev = dev;
> -	snp_dev->secrets = secrets;
> +	mdesc->secrets = secrets;
>  
>  	/* Ensure SNP guest messages do not span more than a page */
>  	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
>  
>  	/* Allocate the shared page used for the request and response message. */
> -	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
> -	if (!snp_dev->request)
> +	mdesc->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
> +	if (!mdesc->request)
>  		goto e_unmap;
>  
> -	snp_dev->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
> -	if (!snp_dev->response)
> +	mdesc->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
> +	if (!mdesc->response)
>  		goto e_free_request;
>  
> -	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
> -	if (!snp_dev->certs_data)
> +	mdesc->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
> +	if (!mdesc->certs_data)
>  		goto e_free_response;
>  
>  	ret = -EIO;
> -	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
> -	if (!snp_dev->ctx)
> +	mdesc->ctx = snp_init_crypto(mdesc->vmpck, VMPCK_KEY_LEN);
> +	if (!mdesc->ctx)
>  		goto e_free_cert_data;
>  
>  	misc = &snp_dev->misc;
> @@ -1062,9 +1057,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	misc->fops = &snp_guest_fops;
>  
>  	/* Initialize the input addresses for guest request */
> -	snp_dev->input.req_gpa = __pa(snp_dev->request);
> -	snp_dev->input.resp_gpa = __pa(snp_dev->response);
> -	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
> +	mdesc->input.req_gpa = __pa(mdesc->request);
> +	mdesc->input.resp_gpa = __pa(mdesc->response);
> +	mdesc->input.data_gpa = __pa(mdesc->certs_data);
>  
>  	/* Set the privlevel_floor attribute based on the vmpck_id */
>  	sev_tsm_ops.privlevel_floor = vmpck_id;
> @@ -1081,17 +1076,18 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto e_free_ctx;
>  
> +	snp_dev->msg_desc = mdesc;
>  	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
>  	return 0;
>  
>  e_free_ctx:
> -	kfree(snp_dev->ctx);
> +	kfree(mdesc->ctx);
>  e_free_cert_data:
> -	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> +	free_shared_pages(mdesc->certs_data, SEV_FW_BLOB_MAX_SIZE);
>  e_free_response:
> -	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
> +	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
>  e_free_request:
> -	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
> +	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
>  e_unmap:
>  	iounmap(mapping);
>  	return ret;
> @@ -1100,11 +1096,12 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  static void __exit sev_guest_remove(struct platform_device *pdev)
>  {
>  	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
> +	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
>  
> -	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> -	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
> -	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
> -	kfree(snp_dev->ctx);
> +	free_shared_pages(mdesc->certs_data, SEV_FW_BLOB_MAX_SIZE);
> +	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
> +	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
> +	kfree(mdesc->ctx);
>  	misc_deregister(&snp_dev->misc);
>  }
>  

