Return-Path: <kvm+bounces-47028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B018ABC7D9
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 21:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 949B6188223F
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 19:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC171EB1BC;
	Mon, 19 May 2025 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="dkEO7pNZ"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020098.outbound.protection.outlook.com [52.101.193.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFED71DA5F;
	Mon, 19 May 2025 19:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747683075; cv=fail; b=ad1ynIgg6pRVTMCiZ7uYTq6m+cZD30Z6xGhuB7SytLVPn7uwdZui1Ijep4IvGhHJeOmjWYo43NCGboV/W97uFZMXjD9cuBeMeWP43/Pp7dNeZDwjIh/fZ6dkM32ritN7jeSEcYcTPyaXttiuDbayckUGZ8mDPwv2xwQ9Vi3YOJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747683075; c=relaxed/simple;
	bh=XL32JkVD4XOdtlE/kc0AwAkztIl9RKCnM9pJn3kxhHU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ivNXR1Yz1/3ngbI40Tgweir5e/GFneqZMmo8jQXJ/UOBjVik+gxa1lgHphwH6Ev9+jEfRPEYgXOR/rTTkhOntG0740bBRyAvdpUt3wauPC+0FletvnzRNfsQZE73xvVD7tQS1q+XrLIGVDadarYjwy7F2k4Og41li1JPJA9M+ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=dkEO7pNZ; arc=fail smtp.client-ip=52.101.193.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TDLrhs8zoJ+GF5BPjMNkfAabXMZVXl1tDpFMDmhXo5wSNvL7OwfM6FY5UKr3MjeRxbfQ6HVndgMn0JMC/17HBgSI6/Q8YKiDfMoVfp5O+d3Bbn85Yrtvnr1fy4j2609WH4QIwbQbWJ3TzqKAl1mibNHnMAE4mcpPsDXxXbOt9SHlwMAZW5LYXzuPaISE6KeqWs08YyscUw0qk6lsdT5y8MPNUuqqC9fOF4O59wzbTybM0U040TXjqZKwf75qt1IpZkUBsseUV8vh5Injal7WxCt2ZMWEVnlcCPER/rW2/SmSn+q9QqbR94kkSw6dBOXMqQm5BTYQ5KfrEFLlqH3/SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imhQWmpXHDh1+ecwLwhprNkjRooyWpfwLjrBOxmuWxQ=;
 b=yTR2R1xK3fDTD+gK9A4FDXS+ueiMUITRw8JIu1dkkqccmSjAjMP78TntIop7pxqkqkaFpUVsXnXeGfHLRCb+0o/ZI3nmxHglJEZ9JMSkLHzbT7Bidg9Lm+Pnx9ve10ta1hQiaiiqDgA+g0rJkxHWsinCMTwPmUNEMWeyYjKr6grUTcc0gUUxfhx2YHqscmYypfOSz8G15Ioqu2xJ/dXBYHxlOSW2cVWof56Z8s65+1EWuCnbi7QjWEk/t02teGn1U+z/m5YJ6AaE86eCXCh3pzZN+vIJbrWHdt/wgcgJNWkJyrYrdeGb5G6TrRi68nJzgYEZh4AnNlEvVeMX7DHdLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imhQWmpXHDh1+ecwLwhprNkjRooyWpfwLjrBOxmuWxQ=;
 b=dkEO7pNZVlAKKJPdt7YiE09aYv+cL7ylJx1xileDcDBlz5AZ6GYM5/bRlbtBTVVodMGkVG55JoixlyJcKNp+33MlbCRPBO9s/Wp9+OX0lZcM+wTca/JPgPPkjmzeK7WCu7kARUU6d7ATS9ft3bVIS9eLj50KdiaaFI8DMvOHc/A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 CH1PR01MB9216.prod.exchangelabs.com (2603:10b6:610:2ad::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 19:31:09 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 19:31:09 +0000
Message-ID: <f781e51a-b193-4bd1-abf0-71f816aa0d5e@os.amperecomputing.com>
Date: Mon, 19 May 2025 12:31:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Janosch Frank <frankja@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
 <bb9d43d6-9a66-46db-95c5-686d3cc89196@lucifer.local>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <bb9d43d6-9a66-46db-95c5-686d3cc89196@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0117.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::32) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|CH1PR01MB9216:EE_
X-MS-Office365-Filtering-Correlation-Id: 54f79ca6-6d79-4ffa-934b-08dd970bb511
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aEVXamw2bWpucWh0eVpja2w2NFdSa01XUkcrd2I2a3Q4MXNqaCtUUkZmQWNq?=
 =?utf-8?B?TUx5WnFUZHRRbWF0NDBHQjdPa3grVzZNMnRGYWhYSUU0UHZ0dG1QcDdMRHBW?=
 =?utf-8?B?N1ExdTdZWTg4L3F0K1ZpaWJiMUhHSVNYL3J1eFJyUDhRYVY2L2ZXUTVHUFQz?=
 =?utf-8?B?eUpZSVkxTzMvSnI0bG5Sa3VRZ2kydnVRMUZKZ2dXLzJhSjluaGJrM0lTc01M?=
 =?utf-8?B?eDBKb2pVNThQbGpmTEJ4Um5GbUdteUd4UVdVS0FsWXAwZWl4Z1lGMk1xa3Fw?=
 =?utf-8?B?R2ZYa1pubEI0ZEdFamJsWlkxY3RIRjlhOVR0K2NFS1krMEpOWWw1SXNSS1JG?=
 =?utf-8?B?YUJQWkhiR3lMcHh6SEZ3V1FVcnNkZ3BTYTJod0J3MkpyRXVoSytvcmFkcXdk?=
 =?utf-8?B?bzBWVE5GWTBjcThKam9yNVJqbVQwU1FuSkxiR3UrcGdMVEpTSjErWGhEQkxR?=
 =?utf-8?B?aEc5UTh4NmdlNS82TTltbUl5RHRGSXpYbFl1YW9vMVY0M0VrMDlGQ0U5azNz?=
 =?utf-8?B?SThpSG51dzZzblFucXFodVFhc0hRSFllV2lxOHFtVmV3SEFHbk80d01wLzEx?=
 =?utf-8?B?VEJ6dllybXJTNDBqMmVUSU1HN056dnBkV21BZFEvZXVzOEl2Wm1zc1dWWGkv?=
 =?utf-8?B?cWl2R1ZLeGpXRTV5aDA0ODFuVkpuem00QXkzUEY3ZTEwQ1YrbUZtMVoycUht?=
 =?utf-8?B?OEp6RXFSQnU5U045QXhnNityb1JoYndXUmVId2UyOE8wZ2xLMzlITVM1SXVW?=
 =?utf-8?B?M01NdnBZV2FkNnV2ZnBiNGtYeE1vWjA2VjFrc1RXdHZocEIxZ3gvd0xPZ2V5?=
 =?utf-8?B?WVNrNnZYWkt5MkJtWlRabzZrcVFrcE4zWW1BZlJsL00zN3ZIK09NSm8wRGE1?=
 =?utf-8?B?ZUFFNVhUcVRUZjJFUW9uNk1Kb2VTcTBPVDFGaGFqNFg1ZXR6QXEyS3BIY0NR?=
 =?utf-8?B?K2ptYzR6WXZEMHJ5SUZNOUVDRGZCbmd5SjArdUQ5RDZqcEJ1QU9BRlo5UHhs?=
 =?utf-8?B?enFYbE9xamZGYzYrQm5wWG1pY2MvUmk3Q3hsU0FXRGJSbXFGS2VMWHhNaUtr?=
 =?utf-8?B?TGhqNnJRdTVwaEpza1cxYUU3MnlXYVRZYXZTLzRPYTZQY2pIM1hseTVlNUE1?=
 =?utf-8?B?STRISGJ0cWJ6SXRZTnVmYnZXS0o2VERZSTBscTR6OGZQQzFBRHYyYkd0ZE0w?=
 =?utf-8?B?Wm8vVlA1MlBzTkI2VGVocnF0cEtBbHF0c28vMDl6K2ZRejFCR3VYbWlVWWQ5?=
 =?utf-8?B?d2VNR0l1ZGpzS0tmMVg3Y09taFF5cXA5NE53a0lLV21Zd2trRytXOFYwc0E5?=
 =?utf-8?B?VXMwcjgxT0tHR1dlZ2tZTUs0MWxmbXIzUXFwY0pHT3RBbUd0aVpoTDB3eTNw?=
 =?utf-8?B?N0xKbDZCaXdRT2ViOFNHWXJObmhheGpIMjFJSmpFcEhwTGdheFM1bzZaRkdn?=
 =?utf-8?B?eUc0SCt5ZW9pSWl1c2ZoMk0wTEVOR0k2MDlLbmE1RFI2eGRWbjlsYUxqYVcy?=
 =?utf-8?B?TlBWV3hSUm0xSEhDL3R4RmlZcnR5ekd3MkpscmlTM3BqNlhBbGp2Q0hWaDhy?=
 =?utf-8?B?L1hxNWJIYW9Oak5udThGU1A3Y0lqVDROVFNobjkybXhVVEVmZHczV0k3dEw1?=
 =?utf-8?B?c2ordmlHaFV6Q0YrRWpQK1J1NUVxbHUvZDY3OUNkbk1KdUw4TXRMY0FwSFVm?=
 =?utf-8?B?MmJhNDRDSzNDOXBsSmN1eVFFaURxSENuZm5CVXN4QnBtS3JNZDJFNG5acFNo?=
 =?utf-8?B?RWZWSitVZW5yZXNsOFBnVTExSUgzSkJWYVl0bTlKckcwWEFLMXk5cTBvMit4?=
 =?utf-8?B?a2hQUitoS3dDenFpR0JPQ1pjWGU1ZC9DYTY1V3d4bmthS3laU0xNVjlyNjdR?=
 =?utf-8?B?djFqZkIzK3lzOG1iRngxdS9qQitnUS9XblFuVXorQTlMY0JUL29SdlZRbTdB?=
 =?utf-8?Q?v4ZxGi264qM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1BmQnU5eFpuSkxwc29RTmNXMDVmVE5LRFFPeitPZmhTRHFSM3d1dDNRUHp6?=
 =?utf-8?B?R2V3SDNmRVNaTlNQTFZjUlk3SlVJMU53SmpJN2tLajFNb3I2REhEbXA1QmZO?=
 =?utf-8?B?UlpNQ0V6bmFpZFBVNjg3UE5EME5SRkJSZldqV3QzdmQ4TS9WRXAvMG9IRi9G?=
 =?utf-8?B?aDhiNDBxenRXNlpYS1RTZDhMVU14OXdvcEhhUy9XdHZ2NXQwc1hSWjZUeFFY?=
 =?utf-8?B?Nm11ZjJnc0hmbzBnWnRWZ3V3WWpmZDFYaHIwUHVvTnk1d25DZ1ZNNmhITndu?=
 =?utf-8?B?YjI2SVFyV0ZidWZjUUdMS3Q0N2xSQjhBMVVNSnBzR3crbVJCQzExcFV0Y0FW?=
 =?utf-8?B?NXBVSTEwdW04bVNUK3BDYmxqaUYwODh6WWdnY00yLzZhZFNYTTRBdG5HVEgw?=
 =?utf-8?B?UHQ0SE5UQ0xZWmY2ZE83b3Rzcm1UZ3FjeTlnSDFkSjE0ZVFIbVQ4dU81VEc1?=
 =?utf-8?B?TGNsVnQ1K0VqaTN4Z2FxZXhNcTR0YkdPVVhtWEZoQlJrZmpmQWJMeE5zMjcw?=
 =?utf-8?B?WW45NW1hak1wMCsrTW5JQzljT00xcjNsMldtdlRXQjhnWWpuaHNoTS9nK1dn?=
 =?utf-8?B?Z3g2RCtmY3cwRkVNaTV5RkhjclllOGt4Q05mRERzS2tOVkVsbzJmSUJId0dh?=
 =?utf-8?B?ZGxlQ1JDQVA5R1E4WXJDaEFDTWo3anlFOEtvK2UwQ0wvTGhHcldEd2Q5ZUR3?=
 =?utf-8?B?cDkvOUV5dFdNWmdwZkhQVC9DRXBibHN6ZXlud25kU2tJa2o2dmp5RFlsdjdx?=
 =?utf-8?B?MEJqSWNUK3FXQUgwbys2c3dmVmVWdlVkREdTcm84dVZzM3F2N0JDdkpvbWJ1?=
 =?utf-8?B?eHV6dzZJS2QxUmJZNksrMWY1MVlrY3NWVEdPOVpWZDFmbHpMVHM4TDBIR1Fl?=
 =?utf-8?B?ZnEzcFl5dVFKb2pRM25BdDhaaU9MVG9NZzNmSWpSM2FqSDRaZmhFWjNJeHM5?=
 =?utf-8?B?aE9CbGoyVUd5SVE0bnpBYUZpTVZMcElTWlEvTURCeDlvWlRBV2JHOENsSU1w?=
 =?utf-8?B?eTBxNWFTN1AzK1ZSZHMrL3RoY2RjZnZnK2UwWldJczh0cGREMGRTY09mV0Na?=
 =?utf-8?B?ckdkeGpSNDNaWTNPMk5RL2dWRk1pV0RVanZiQi9JRkYvd2dRU1lvbFNwV0Za?=
 =?utf-8?B?am9udFBaZTY5aXROZTl2WTZQQTUxc3IzaWtDUzBPUGh1U3ZwbktDOGxtU0Jr?=
 =?utf-8?B?WmxqT3RsY3lnSm03cmJZRjhuZlVxY1JpQ1JMa3FCdFpqOWJORFJPOG1zcEpi?=
 =?utf-8?B?ajhTQkpid3BFNjl6cE5pck1kR0k2T3ZaaXMvc1FJUFRpaFJyam4rY1NvVVFr?=
 =?utf-8?B?Z3kxS2Q4R0E3LzQ2Z1ArS0FQSlNzUE5nOTFRRjJOelRnVlNYSFp5dHdpTWR4?=
 =?utf-8?B?eUN4bU9KS3hBK1pzVDJ2NkFlVlgxUjYzcFNOemliOW8yWWEreEhXeFhaTU5Y?=
 =?utf-8?B?OFh2VVVHUzVEYzROYUhuTEIyblViTEw2QnpXbTFzOTljN3JmdWFKY00reFhp?=
 =?utf-8?B?UnB6UG0wY1cxQlR3cWl0WFZFMGhUaFBJbXA4QkY5UkN2c2JCK1JkbkoxMHUx?=
 =?utf-8?B?aENFWVRKbWtsNmcvd2M0NjVmSEhXL200aVRyRHFWemhTYUY3MWllbUpYN05n?=
 =?utf-8?B?UDFFbHY3aWpiVHlaZFR2Ykx3OGgyc2U2d083NFlQd29vNWlKemtOSU5UNnpH?=
 =?utf-8?B?NDRITStqekVWVmN2WndxMU5LMzZ1enpheHJBa1NiWXpqaDU1UzlzL3krcVRo?=
 =?utf-8?B?ZzNaOFFzRTBudEpHNEthckQzRENCRmpSRENqMVpsb1FOampmTWE4VVhMb25C?=
 =?utf-8?B?Tkd6am1pTzdSZFpXQ3pyL1NqU1F6N05sVC9wa1J2OVBiQk1PazJlTTU2U2sz?=
 =?utf-8?B?WGZPMW52UVpLb2lKMGd5SEtqcGVscGpveEE0ZC9uYW8zZVZXYlU4WXNnbEJz?=
 =?utf-8?B?dkRRditlY1BaMmRTcGZyYzljSmVzOU9uZ21yZjZsQThFeTdOTkNmQThFdmt0?=
 =?utf-8?B?Yk9ZMVNzN05SRVA0VHRYTzhKb1A3bjMzK3l4dUttbWZodnZicFhrcFpOWlFi?=
 =?utf-8?B?cGZwemdoNnNpQjljOEJNRDc3NTFIUjdPQmc2YXlFVmJjL0d6R2JCekVrWVFo?=
 =?utf-8?B?cUZqa3QwR3hyV25yZWJ3cW9wUGxZaGNEdHV1KzlhSDlyYVZqeDhNemhGanY1?=
 =?utf-8?Q?rMs1pXh9Ltt08f3tqK2L95M=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f79ca6-6d79-4ffa-934b-08dd970bb511
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 19:31:09.6364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dSjCJp/NcAYNJI/MleEycw31RVb6Jr8yN+jAnRhUbgzd0Z/QJcy+nKnOvHLVB3VcRdqmtIrP5TcaB0O4dHcVUgAjXyo3f72eBabEcYApqYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR01MB9216



On 5/19/25 7:43 AM, Lorenzo Stoakes wrote:
> Andrew -
>
> OK, I realise there's an issue here with patch 2/2. We're not accounting
> for the fact that madvise() will reject this _anyway_ because
> madvise_behavior_valid() will reject it.

Good catch. The purpose of this patch is to make MADV_NOHUGEPAGE a 
no-op, so we can just simply bail out early? The point of madvise 
behavior check is to avoid taking mmap_lock and walking vmas for invalid 
behavior, but it doesn't consider no-op (I treat op-op as valid but do 
nothing), so if we know this advise is a no-op, we just bail out by 
returning 0.

Maybe MADV_UNMERGEABLE should be no-op too, it returns 0 for !KSM anyway.

Thanks,
Yang


>
> I've tried to be especially helpful here to aid Ignacio in his early
> contributions, but I think it's best now (if you don't mind Igancio) for me
> to figure out a better solution after the merge window.
>
> We're late in the cycle now so I will just resend the 1st patch (for s390)
> separately if you're happy to take that for 6.16? It's a simple rename of
> an entirely static identifier so should present no risk, and is approved by
> the arch maintainers who have also agreed for it to come through the mm
> tree.
>
> Apologies for the mess!
>
> Cheers, Lorenzo
>
> On Thu, May 15, 2025 at 09:15:44PM +0100, Lorenzo Stoakes wrote:
>> Andrew -
>>
>> I hope the explanation below resolves your query about the header include
>> (in [0]), let me know if doing this as a series like this works (we need to
>> enforce the ordering here).
>>
>> Thanks!
>>
>> [0]: 20250514153648.598bb031a2e498b1ac505b60@linux-foundation.org
>>
>>
>>
>> Currently, when somebody attempts to set MADV_NOHUGEPAGE on a system that
>> does not enable CONFIG_TRANSPARENT_HUGEPAGE the confguration option, this
>> results in an -EINVAL error arising.
>>
>> This doesn't really make sense, as to do so is essentially a no-op.
>>
>> Additionally, the semantics of setting VM_[NO]HUGEPAGE in any case are such
>> that, should the attribute not apply, nothing will be done.
>>
>> It therefore makes sense to simply make this operation a noop.
>>
>> However, a fly in the ointment is that, in order to do so, we must check
>> against the MADV_NOHUGEPAGE constant. In doing so, we encounter two rather
>> annoying issues.
>>
>> The first is that the usual include we would import to get hold of
>> MADV_NOHUGEPAGE, linux/mman.h, results in a circular dependency:
>>
>> * If something includes linux/mman.h, we in turn include linux/mm.h prior
>>    to declaring MADV_NOHUGEPAGE.
>> * This then, in turn, includes linux/huge_mm.h.
>> * linux/huge_mm.h declares hugepage_madvise(), which then tries to
>>    reference MADV_NOHUGEPAGE, and the build fails.
>>
>> This can be reached in other ways too.
>>
>> So we work around this by including uapi/asm/mman.h instead, which allows
>> us to keep hugepage_madvise() inline.
>>
>> The second issue is that the s390 arch declares PROT_NONE as a value in the
>> enum prot_type enumeration.
>>
>> By updating the include in linux/huge_mm.h, we pull in the PROT_NONE
>> declaration (unavoidably, this is ultimately in
>> uapi/asm-generic/mman-common.h alongside MADV_NOHUGEPAGE), which collides
>> with the enumeration value.
>>
>> To resolve this, we rename PROT_NONE to PROT_TYPE_DUMMY.
>>
>> The ordering of these patches is critical, the s390 patch must be applied
>> prior to the MADV_NOHUGEPAGE patch, and therefore the two patches are sent
>> as a series.
>>
>> v1:
>> * Place patches in series.
>> * Correct typo in comment as per James.
>>
>> previous patches:
>> huge_mm.h patch - https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/
>> s390 patch - https://lore.kernel.org/all/20250514163530.119582-1-lorenzo.stoakes@oracle.com/
>>
>> Ignacio Moreno Gonzalez (1):
>>    mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
>>
>> Lorenzo Stoakes (1):
>>    KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
>>
>>   arch/s390/kvm/gaccess.c | 8 ++++----
>>   include/linux/huge_mm.h | 5 +++++
>>   2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> --
>> 2.49.0


