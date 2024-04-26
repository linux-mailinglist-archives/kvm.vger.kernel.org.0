Return-Path: <kvm+bounces-16048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7BB8B36C9
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 13:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1EAC1C20D53
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 11:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 011B6145358;
	Fri, 26 Apr 2024 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wN+uy7Ot"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2065.outbound.protection.outlook.com [40.107.212.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670471448DA
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 11:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714132606; cv=fail; b=dtG4C1o1i5QHfPefBVZPm14uaZP5wWtqTS+zmV3+UtzQu1lj8Gyp3YHr12bRYgn4URmN8pZiyy0ifUUUJfS7Gg+sSJ7ZEdxpFaFhBiiya1GUcWyzDLmHcTBiXoyqe9o8dslDc5GFenNp75IhOX6Hgw8TdUtX8klWlLddQ613WqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714132606; c=relaxed/simple;
	bh=qxphLwbfOrtl3TXuAkciL3b1nto08bUYHEtk61hRtMs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n9WCsQtD24FNmgJYE8GEsQpaTEudUw/22VGxOV0C4YKX22lX8nnNZ0tEYwqpQvL29CjpBF3bWYLi0k3cMAB7zZ1meW5JV7dJQhSJp8YusKBGILPPSxM+6RbNP381Kn8NsgCzMzajEi6pGwjpGgO8f9EWl5XNqCSqsLtdtki1/r4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wN+uy7Ot; arc=fail smtp.client-ip=40.107.212.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaXNNasDaIdwRP8LHv8o+QBEJOwJtTMiwia8ddH9P7rnyFhsLJj7VH6rROhG+Qb0zi9A2UxUT37Yix5eE1j8DHj7dCPYYR7tyQxOCF/a/93ffH0MTGHFkRlGIpcKg7dX1qHyeHJZ1vTIMStJldJUBBmjrBio3T2rQkAL3oHLC50RDvudRaHNzscWqk3KYh2+R0i03F4ozUMzbvKU2szKL6NOEBh3vpNQqJiZXcEc56MRSbc5hhRmxtpfhv6mXjAUa4wDt0krUlY7WznXragaiRvYsp/AUJnpbpxWrUOmLCqTxsnGXj2ipSVHFihbNr2DvjfleczqUFHnwBusc4lGFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nKwMqW+IY9QTtbw/q1YVC/iyp6BC9ZJL4pjgaeRXhU=;
 b=hbdvvRnjYHMpzoF5EZEYgjEg7Be/7N3WbHUOBzGSflq5KeDuHi1Sj5ZC9glGxza7szJ1kFEw5O75Dyco1tXk3tsqB9QFONulxQzEoXH0lqHt0YARQ3p2sz9fOM4FhVaDBGSXBRyjfLgDfB4K52BWkwcxU51PO6Kwip7IMFwUa5ZHhiPEl+WRcwZ1dPHoNwCBwIMOEIxk7eA24VYd191XSuSmHBZHC9LIXamYEckxzReb/3A6Ll/SOPYppRLA4i5RGCh1xJWyVnQihlgFhmNQ7+zcawH6RZUuqJFjl6gRVwA1TMxL3gnUTNVE98z4yJdGV96zrpDIHSQpoxUMI6s5Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nKwMqW+IY9QTtbw/q1YVC/iyp6BC9ZJL4pjgaeRXhU=;
 b=wN+uy7OtEB341xQShLVpvxAWc0cbp8Om/OSpaWehCuJg4vAxmiqhlsxDwBGl6GvX6361ECMEyrNFbdchDdXiVLx7JTo7Jt+nHWV75NEGDp8PReZWMKMzZxCTbRcnPfuPzjruFBZHi3++fsipCVhEq7cGWBshEZyHSap0QnGs//Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by CYXPR12MB9443.namprd12.prod.outlook.com (2603:10b6:930:db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 26 Apr
 2024 11:56:41 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::4435:4362:cb:98f3]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::4435:4362:cb:98f3%4]) with mapi id 15.20.7472.044; Fri, 26 Apr 2024
 11:56:41 +0000
Message-ID: <f564e6f0-6a44-dee5-9f04-d44f063c9b30@amd.com>
Date: Fri, 26 Apr 2024 13:56:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6/6] target/i386/confidential-guest: Fix comment of
 x86_confidential_guest_kvm_type()
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20240426100716.2111688-1-zhao1.liu@intel.com>
 <20240426100716.2111688-8-zhao1.liu@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20240426100716.2111688-8-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0146.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::10) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|CYXPR12MB9443:EE_
X-MS-Office365-Filtering-Correlation-Id: 531f2d01-9d82-4d84-d912-08dc65e7ef63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEM5dEsyYTZyRnJlWGptWDRKYlV0MC9SZmRIMWMzOFNFaStDa1RWL2kyeU83?=
 =?utf-8?B?K2NZS1lYdmdjT3N3dFF3cnNFTm1YcmluV2svL2F6N2hyMWlxYkJOVVZwQnYw?=
 =?utf-8?B?enBoUE82SVV0Y1RlaTVEYm5hL3BBQXlyMUxqZTJjY1NIaVQvRm1jS2NLUmRh?=
 =?utf-8?B?NlM0aDN4TWk4K0F5VWs3aDlZOUNsaURndEF6QU9udkRIRDZlaWVUNTBpcXln?=
 =?utf-8?B?MWZqb2MwZTgwenhzZmlDQUthWjgxb1ZWKzZIZDRkRlhOR0RLdDNtanl3WnJN?=
 =?utf-8?B?dlBac240UzRLd2xkNkJYRSs5Z1FhLzdPNFRFRHcxM3JiVEptWnlPTXRLVk1k?=
 =?utf-8?B?cTdWRVphSzR6VlNDeWp0a2pvcUZrTTZ1MHF1dDBtRThkODB5K2lsNndZeExx?=
 =?utf-8?B?Y2JFeElqQVZBVVR1ak9wRzJvVWJMYWUyNHRPVW1qdzZxVnpEOXVqUmZWdlp3?=
 =?utf-8?B?QnZrMVBkdExCdEFkSlNDVUhXbFR2QTNQRk16T29INDZQYzgzTUg2WnNERUkv?=
 =?utf-8?B?Y2tBUWEyTFYwM2xZOVZxd21KZDRQMEZxcUFtRzJ1QWJlckdrdDl4YmNPTHVS?=
 =?utf-8?B?WGg2bVJLb0o1NGZodllkTjg0M1MvMUQ3WDhhVlZ2UmFrK1NzbW82ZGRINjYx?=
 =?utf-8?B?MUJpd0FPUElyUS9lQnQxdnk4SjJaZW9HbS9DSS9yMTVJUW1BN2FPNEtFVm9D?=
 =?utf-8?B?VjJ6RlVJZzlCVzg0RGxMUWtxZi8rK2Y5SEZiRDZqVmJtTWhnVzBlQ1hSZFJ4?=
 =?utf-8?B?cmQxeTk5NEFIVU1aNkM0bUJheVptaGx0eitEM1NiNFQ1TkRaUnJqSjdwdFM4?=
 =?utf-8?B?WjBvQ21KSVJZSC9TM3MwL25uNHo5REs4OEhsRlorZm9GdEZHMzhEY3cwWG02?=
 =?utf-8?B?VHZaWVFWLzMrMHRvL2lnUEpES24rZUhWVGQ1WWVZNnNEMjgvZVV6bGpTYjRK?=
 =?utf-8?B?alhNdHdkMm5xKzBkaHlhOFowMGhyOHNtQmNvNGhSZmRoZWpwTlRNL2RTT3R2?=
 =?utf-8?B?VEVHUEhYTkhrVytKb3Rvblo1a0k4aDFEcCtIRFhKMHBiMDBCL3VrWDNLdkEy?=
 =?utf-8?B?L1k2UThrMmwwSy9KaDhheDE2by9sMFlDZEN5WjUvd1pXcDdDdFdkWTVjVk1Y?=
 =?utf-8?B?dXEvNzJNUXBycnVFNnBWNnMxNnlxNWUwNWZ6VVBWdFp1ODFBQ2cwQ1hYWmpS?=
 =?utf-8?B?R2srK2l0MnRKWWhkbEYrSEhWS3pKcGc5UTIwRnh0eFlzVCtTMHovVXA4by9F?=
 =?utf-8?B?NGFRZjdJWW4waHJjNTg4SDFxVHFRU3hUTVhyczUwL21iUDlnU0ZnK2xlQis0?=
 =?utf-8?B?elZEOExFQnBkcC9XNDl0ak93eitLcEJnZVBNQ2cyN3dVczFFcFhGQlR1ck9I?=
 =?utf-8?B?dVlsUjA3YzJ5MUVvMHkrZWJVNHkyekFzVE9wOFE3WUpKMitLcDZ1OEZFeVB1?=
 =?utf-8?B?cENlQzZmQWg0cWRybE00OE1mSVBkVmJkK2dBdFhEcUlNUkUyNDNJSEMrVmV0?=
 =?utf-8?B?TzdyQXBKekxsc2MrQ2kwdjNzaGxzbHpkVGtnSmFXS2lIbU56ZGlrbndGV2h0?=
 =?utf-8?B?TzNDZ2Nhdy9uekt1STE2alB5TjZid080WEF2Y0R5VUNYNjVZaGdIRFMyZmZw?=
 =?utf-8?B?UlN4dVcxN3pRcjIzV0FkMmtpNlhaZHd3YkRuQVY0ZWk3UU52N3NEbXJnWUlR?=
 =?utf-8?B?c2JIVUYxQ3dhMXZMQldHMEdNWjlqZFFLNEZXamFkWkdBUkFZVi9vcCtBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnZtamFuR1ArdlJoYjhxS1B4SEw1YlZlaG1paTd2RWFyeHR4ZW05VnJNcTEy?=
 =?utf-8?B?UkpkODFmdk92NUp5enFRS0FaU3ZhTUptSHBGTkNKTWdvSmlkY0RzRG1vQi9v?=
 =?utf-8?B?cUlLZzJvYk41cDVGTGI3NUVIVTBTRWpVdnRHWXhJOHh4dEhwWXlUNFhRa3JK?=
 =?utf-8?B?dk0xb2hReXZEYmhKRUVSN2puOGxVV1N2L0RTTUpQMjUwdGw5QktKcXVyclcx?=
 =?utf-8?B?S2Uyb0RlaVN5TlN6QzBJbE5Tb3RqaWV6QWFmSWNPZkl0N1RlN016clRMZ2FM?=
 =?utf-8?B?TDRiSUJwenlRK3lTYkErTGs0eVVpRnhYZDgxMCt4SG1PNzZhYjIvSm9sbEdV?=
 =?utf-8?B?Z2xubkFOSEZKUlR2TDRONGdBOTBhVlk3T2l5L25palAzY1N4b2VRTUNmckNi?=
 =?utf-8?B?bzVsVlBxeDhZOHIzNTFzS3lPUlVNUXFGMGlQYzZuRU5PRzJIYzg5ZmdpSXJx?=
 =?utf-8?B?OGNmNzJIUHFmQUY3U01NVnVKK2tzUVFtSHFNQzFleFdyQVZ5aVNzLzU1Slps?=
 =?utf-8?B?MXR4bE1peHJrbWNsM3I1eS9SZ251Lyt2Z0J0bTEyRXNRY3BSK25JRTYrbVFo?=
 =?utf-8?B?YlZ6QjNYWUxiRWlld1NpczFJTWtDQzQ3cWVLUzFuM1JKNVJSb2IzMHFvWW8x?=
 =?utf-8?B?cEY2K2EybEY5UVNhV1BDNU5rNU5rQnlQVXdJT0ZWWi9HMTllczVXZHd0akI4?=
 =?utf-8?B?RmtjZFNnNUY5bXlrZFNWWWlwTWJ6YUtGL3k3RGNwbmJZZEFXTWMzYXE2dlp0?=
 =?utf-8?B?VHlJOFJ0cVNoWFNJQmpaY2tqRGRicWRPNlJKZ1EvS1hBOTdqbUc2WXNNNTRt?=
 =?utf-8?B?N2lGN2dRaUJ4Wml4S29aWDRBTzVsbSs3dFNQc0hZOTZvZTlPTVBWTzA3L1g1?=
 =?utf-8?B?NytPNXRtREYrbnBXNzVoYzk3ckJGWEVoaXZjWHBFQzJuSEQ2WENZRDBpeGV2?=
 =?utf-8?B?SWlUYVgxR3hkZjFHakJvZ3BoNWU2WUtLNHF5TVJJTy9QcWN4LzJvWDZGLzdI?=
 =?utf-8?B?Zi9aNDdOckk3Z2ZzWVVaZEFzRWVOVjNXdms2NEx1Q1pPNC84YytuNmY5VXlo?=
 =?utf-8?B?RERuUXR0YWNMZk5ybzFRQ0ZzS1hzVXVsTVF0cEN0Ri82UUtURGJiZVpyc2ZD?=
 =?utf-8?B?NzUrSGwvTHdQMzJHMTYxTmdSUTFzR0x3dElENmg5Q04yTk9DK203SkVDYXN4?=
 =?utf-8?B?bmJUT1Y2ODJZRFh6UXIxZkpEZ0VEOVFrTVpranUwdzBxcWd1R0tIOTBuTERI?=
 =?utf-8?B?V0NnUXpGSjhCZFNIQW4yMUVZVmpIVGpqS1ExM3JGc2xlVkV2RW9udE8wVWs0?=
 =?utf-8?B?RHZ4dGt2anFVVnNIUDV0TnJDanRlWE4rMllheTByMzZYVkg5d3hGQWRDL2cx?=
 =?utf-8?B?T0s4NUxGKy84VXp5NzJkU1d4UGFtdUFkQTY0K2dSV096dk1zcDQxTVdJRS9P?=
 =?utf-8?B?L2dhY3F6ZUlQZlRuYm9TNHFBTEJ4THFyUFVFTC9TV3FFMkVlMnppNW1YQ1Vv?=
 =?utf-8?B?a1hNcWtGbVRJcFdxRGk3VkQvdW0vMlppaE56bnpLNytoZW5XWGNmMmVwbFl6?=
 =?utf-8?B?R2RQS2JrVXFrNWJsdmZITmhFL3F3S0xoZmlweVZCSkVhM2xRWVM4MS9LSGtJ?=
 =?utf-8?B?MkdXZHIzaEczWUFwVU9LZnZkR3Q1K3lBS0pEcE1OQm5lVlBqaEtUbDluQ09N?=
 =?utf-8?B?SEwxZGp3d2hrOHYybnNHa1pWN2pwTFU0ekE0eDgwZnpQUEJmUWt1azJhWnRp?=
 =?utf-8?B?bWJSWW9PTEFBcGdPUVJmeTZLMTZLajd4Lyt0MTR2S0FXR2h6emRXRFU2RTVn?=
 =?utf-8?B?YlIrVVZEU2hGUUxtVVIxT01jZFlrTkhaT3JaSVdjRnRMRTZUY2VURGs1QXIy?=
 =?utf-8?B?THVGMFdtTEYxU3FtSm1YcXNGYVVvSExsZFdjcmUwUEVZY3F1TFBFc3dXdXZO?=
 =?utf-8?B?Y254WUR5VUVFZ2FscmIyR24reXovck5zSUxjVFRseHZDdXFSb01vbDVLRlFL?=
 =?utf-8?B?SVoyUERabEI5bkcwSzlqZ0pRSFJzSDZWVDBWL3hiTVRRYVZhTWp4UTJCK2Qr?=
 =?utf-8?B?dWhYbkZJblM5czR6bzhTSUg1OFR4VXBqRWFqLzJKWnJVWnFWUE5pQ1Z4dVJk?=
 =?utf-8?Q?3a5hwAuHThOczjOcoMsjeuCH6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 531f2d01-9d82-4d84-d912-08dc65e7ef63
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 11:56:40.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QpquxyRZTSgqdH/lVNMjVZcl1EXvC09z9bU1zQrobsetaz/lIzRrsDz6VMyxfkANsyjjnFkYmdoZfMvtCk1ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9443


> Update the comment to match the X86ConfidentialGuestClass
> implementation.
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>   target/i386/confidential-guest.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
> index 532e172a60b6..06d54a120227 100644
> --- a/target/i386/confidential-guest.h
> +++ b/target/i386/confidential-guest.h
> @@ -44,7 +44,7 @@ struct X86ConfidentialGuestClass {
>   /**
>    * x86_confidential_guest_kvm_type:
>    *
> - * Calls #X86ConfidentialGuestClass.unplug callback of @plug_handler.
> + * Calls #X86ConfidentialGuestClass.kvm_type() callback.
>    */
>   static inline int x86_confidential_guest_kvm_type(X86ConfidentialGuest *cg)
>   {

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

