Return-Path: <kvm+bounces-36320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7C2A19D72
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 05:00:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ECF03AC9C0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 04:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AEC5139D05;
	Thu, 23 Jan 2025 04:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sVTY2NX/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072.outbound.protection.outlook.com [40.107.100.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F6019BBC
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 03:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737604800; cv=fail; b=OWgXVi7xx9qMM+s03FUf+ploahc/W8gHHlS3CLfbGl9KF1DQoxdoNAG7HC8CPBvXDY5wNpum/cMoyXzXUiAHuJJev1i/Ct/SDLwz7KlkwsAib7QRLLpNs1QjpJgMzXpzWhDfTp7vtfYS8jboAOh8xW8WML6D6cEqg5+hTXduNvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737604800; c=relaxed/simple;
	bh=kqp9KXSfjgk4HsepAFnxTDzPZq+jojg6IqDa5mHdGhM=;
	h=Message-ID:Date:Subject:To:References:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SODZgfrbOrcAFYJ1UH3Ojmh7620xGDLxuCUDmc82eAi25zLj/yHT9rzIIYk511+v03WEuTOeeeQZAsCG3hSyntI3U1mFprT7qmLaCJf1JKX/UQRJYQT2IvkbzwlrmBAjbvfwG5A08D7B5oB4aL9zULhK+dESlxTZs36ZM1tCiwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sVTY2NX/; arc=fail smtp.client-ip=40.107.100.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dFFmV9EZC1XePO5+6fVKDb0/7yROqqFFPX5wTnnIQkiU8Dqw0n1/4KP/4gHWcgrJ7X8M14YEXPwST4L8rxxYGVbbruFhKQfGQLnKHOo4cWtHUNwDYbTgL7QcRUAW2fSCGLrMhglKbW65t1E8PkQued3mM4Srbr4Z/7Oe/tO4YKL+SqMHIO9rVGiZDKrdO04XWcwnePa5YONTv6ChAOku0T5lnkrWrFiI1ILmxQIuC54QcVy7vqbEt0xGHauWmCpbKGfuX4VAuxtEjrj7qf9Y2YDUeeZex71BOKvPsQSjwkA2mO9EUYcoNerO/9tKFRSTJhzPVmFzqxcHgpfdCjAvlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HSR887roryhmphtpiofaTXVRizFETm+Eigtid6l37II=;
 b=u36JiLh7kuXimpgQJe0DyKkGQuag8xtChOF6F8vFuBkNpa5ewTs/+E7xnPNa3U7+j33XtpWuDNQT0teR8E01JZPcBzjQE8D167bMTrCrhaPWkkCA6eYom0UoWwPLVKvSnyTUo3AeTxN6sXspMxmMeK2Yl0+sMrrYvbLagc6mBdieCd/GgAPmWHUrbIqgwrebyI9JBnXrq+bH25qJgaK5Ceg6fwWX+o6qeQHs7R2cMdJP2U+YQcOyA0dZQDDi/h9jBH7z8CeAiUxABeFVVC/3/42myUwyb/o0ulaDlg5BCCsywR40YihstYRE1iaI6VuM7Sa3tNs37gEwkabqsa8lTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSR887roryhmphtpiofaTXVRizFETm+Eigtid6l37II=;
 b=sVTY2NX/R7jLoJ5zL0xxYfhgOmjQb/PoXbQlDzF2cSTXbb5jgZYjeQbgHn8KN3gY1v1Lhbh6IODrk/3jqbjp2cgGnc7E2VESYXlyCt7YgDCgHuhY1Eb4S6UyvCcaZ/vKWjErkesLGPdmgUKYRJlLr2I+Hxnus8VM6aqjgsZKJ3A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH7PR12MB7795.namprd12.prod.outlook.com (2603:10b6:510:278::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Thu, 23 Jan
 2025 03:59:55 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8356.017; Thu, 23 Jan 2025
 03:59:54 +0000
Message-ID: <6f2b2e66-9721-4127-b771-881c6fecab65@amd.com>
Date: Thu, 23 Jan 2025 09:29:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: use kvfree_rcu to simplify the code
To: lirongqing <lirongqing@baidu.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 kvm@vger.kernel.org
References: <20250122073456.2950-1-lirongqing@baidu.com>
Content-Language: en-US
Cc: Uladzislau Rezki <urezki@gmail.com>
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250122073456.2950-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF00000184.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::4a) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH7PR12MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cb36bb3-1d8b-426d-8db9-08dd3b62650e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHRReVFRNDJZeE9pZWtTV21KZC84ck9GY25NK1FDSzduc1kyV09hdUdBTGpW?=
 =?utf-8?B?MkFqOUxZTCtWTE9Pb045N0ZaVXBneEZneHRlNTNhbkkzb3dKV25kbGtyQ2Fp?=
 =?utf-8?B?TUE2dTc1dFErcDRYdUNkQ2ZiQ3NJb096Tm14Nk1EdWhJZ0JWQzB0Q2JxZFZR?=
 =?utf-8?B?amdGbS9lRlRTdlkzNEFXVk9jODdLY1kvc1RHME02S3lma2ZEb3BmZmhLQlN0?=
 =?utf-8?B?ZVRvYWVuM1RSWlYydWEzVmYwb042VTFKVkx2dWRLdXpjTGkyR1EwaUZpVktE?=
 =?utf-8?B?TThTeTlHU0RwRkZ1Ym1tS3JnWUtxclQ3UzN2TUxhNWw1dzJiWjh3YkhnRkVF?=
 =?utf-8?B?MUJ0bW5DL2duSEZLMFBJbzloSkZYSktjRkc2V2tFVzAwK0NMR21yVlpwbitG?=
 =?utf-8?B?bGIrNmxER2p3d0FWZC9hay9MQk1Ddm5YUE5IVkxveFR0all4VjgxZy85ZWpv?=
 =?utf-8?B?cDMzUS9pUzQyOCtsa3o3SFUxZHJFS3pub3drLzV5L1BNYTFBSTMxUGJXVzRF?=
 =?utf-8?B?cjRSaGRPdTNQNkhacnoxbzhFTGdvK1RwMmFtRjduQjlSUElEbENJM21mY1Q5?=
 =?utf-8?B?WHpKUk8ydExFQVlsbllnc2FEOXR4MXNHZVIzZEdJT0dnTEpRYVdrV1FzN2RH?=
 =?utf-8?B?SXo3T0FXNXl0VCtLQWRWSklZbzJ3bVJZWjNBUkJPSyt1djlNTlNXUnQxTm1C?=
 =?utf-8?B?cmVKcW9OZjJsbjIzbDRrVFVhcGNxNTQyNlRzZWg0bE55TnN6eWo5eG83Yk9n?=
 =?utf-8?B?cHFLZUowclN5UlIwNFpuaEJpNGFOOG5XRnZnay9yS1h2enhZM3VkekJKQXd3?=
 =?utf-8?B?d2RNTVRrUHFCVHpnS3h1bjhjcm5pcG5EUzhRRDY3eUQyTGxjakZqdWQyZWxx?=
 =?utf-8?B?YVpyRXNPb1RienZ1dTU5MVVJSGplbTBPb2tXSnh3R1pDajcvUHZ4TFpQWDRo?=
 =?utf-8?B?WWtSTEhPNTlyeEVWOWhQR01QaExGdHpYdFFrNmpzMlY5cy9ZYnpOZmF2aXgr?=
 =?utf-8?B?ck56eXJ6MWFMN2NqVit0UDk4OWZaUk04OEd6UUJsUFJOaCtHV0NFZnBwVDFT?=
 =?utf-8?B?ODhZOFppOHM5UlhacWdEbW9aL0p2YnRYYWpMY3l6enUwMmFvd2xUK0VUUk92?=
 =?utf-8?B?a09GdDdPRks3dTE3UFdDREJUWWRtMjY0R053UkhQVXFvdmVnb3hQWE1Sc25F?=
 =?utf-8?B?VW9qM0xjOXVaMWI2ZzlXbWpUTUVSeWQ1SzE0UGZLWkgyVWsxL1ZadVliZkI4?=
 =?utf-8?B?ZTJsZWNydS9FR1NucXRaZG9zK0Y4V2RpNFBZWFg4eWI5MUNFR0g4QjZyZ1Z4?=
 =?utf-8?B?a1ZnSVZZN3F4NVRtMEdoWlpBa1d0em1veWJrN1IzRk01S0ZlcmRFTFFuREgz?=
 =?utf-8?B?dXptZG5RSXZQOXlwYkY0ekpKaERtQWpTcW9HMHZnczFPSEp1a0FiREN6Nnpv?=
 =?utf-8?B?T1h5azl4TXMwOU8vbkRNWVE0dWxIU0c2MlVqTXRKd2ZPT01taGJOc0hvaHJU?=
 =?utf-8?B?SE1YM1I3NXVtRGZtWHlmcjBoVmMzUlhhNHNnTFcyY2MycDVQYWpUcHlKYzI1?=
 =?utf-8?B?YW05cWRFa2xhZkxIR3FqTzNIUWlMbHE0OUJFeEhIOVpvdmpoT2lMU1loNTRJ?=
 =?utf-8?B?T0VNZW5hSHlYdnFPaHhyQTJnZzYrODBhNW5uQW5zT2QrNUsvSHloM0t2Znlt?=
 =?utf-8?B?M3BJZ0oySHFnRWoyVzhHL3hGWnhyVFBpemN3WXJGLyt1MnFPTk1aazdKV0Ux?=
 =?utf-8?B?R3pCRW5LT3JJTERiS1ZPKzJMNWFQYnFCUVJmdjBWZnF4TUFMTzZtdzN1bGg0?=
 =?utf-8?B?MnE2djdVbmZzL3pnaVdkRVpkbVRCT1NtSzFPRWU3OWw4bEdkR2I0Uklpc3Qr?=
 =?utf-8?B?MnM2V08wZzg1c0NKN0E4QlB5R3JkeDdFdk0yTngyQ1lIaUEyeUIzbjdva0Zz?=
 =?utf-8?Q?6rLX5MAcZeg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aytxM0wrbHhKUTVoRXNJYzNoeXp1Rm52dVRGOFZkVHJuR2pZL1JUZXBGc2gx?=
 =?utf-8?B?RTJndkJvSHhWWHlXWkhVV0U4d1gvSDczMkhGZlZUQlRPcXFjY1dVaUNHaWVN?=
 =?utf-8?B?MkpQdXRRaEtYYzlNdDk2L1lzS1plU2lyUG9wOGpwVzNxaHdsbkxpeDZvUXhh?=
 =?utf-8?B?VEJlRGZOVWVIT25tQWRMVU1CVVovTFpETXM2Rmd2dTYrZVNGZ2ROZ1g4MXM3?=
 =?utf-8?B?Mk05V09VTlB2alJsUElubDRHZnVjMnZubVR0Mk4wTUorRSs0aktvU2Jub0h2?=
 =?utf-8?B?WStNOW1FSU5OUW93NG9tUnN1bmJLV1UvZkhTbWpoRDltMXdocVdnUisycW8z?=
 =?utf-8?B?SUdHbkJkUFNPLzdyZWg0TUh5RmphdlJxY0xqTzdXWmpyYzNyN2dmRnNKcVlr?=
 =?utf-8?B?M2xiMk9WRFZlRktWMkthcUU1RERpNkNkNjFKQnQvVGFyTTZjem5ieCthTGoy?=
 =?utf-8?B?Tk9IMzBsZHNVd2F3akNYcEc5UG12SEFoY2FkeE9EbWt3ODZ3MUJJanMwTURi?=
 =?utf-8?B?V1dnbG5sN3NwWkRBa05VczlKL3M1VFJNYjhLS0ttODZ5dEFUcWV0QmtVclFD?=
 =?utf-8?B?K0RYNlEvb0VMV28rQ0NiZ3BOK25zOE9lQU1EZ3A5bGJKbXRhcWhWSC82b3hF?=
 =?utf-8?B?Y3dKdC94T242QXZjenJES1RxNzRobEQ3WWpEVGI2Vk9haWh3UnN6Q0FqZjRo?=
 =?utf-8?B?eTVrZFlCeS9TZmdaTWw5bnM2bFdtczF4a2hBeDhXa2tuL3ZtQmhBaVk0WU12?=
 =?utf-8?B?OHFpeEx1YUdDRnFrR3BqVm0rSERMV3F2bEFLMnpSUldqbjRDU244aDZOTlFW?=
 =?utf-8?B?Sk1yTVFRRDhmdUR2WVpCTnN0R3FQU09JdFNyOGJDVUl2OVNLQkhnU0U0NUxr?=
 =?utf-8?B?RHFFR1VORnhsc29JMFg4MVBlanZRTEhrQ25MNFVpWUZBN2liYllhMDB6Z3JV?=
 =?utf-8?B?bkZRZXRNR0FXNWpscW1WS1A1b2NSQVpVTi9ZRkZ4R0JzVGYwUUl6a0VkSFdQ?=
 =?utf-8?B?MWpOY2NjM3hqN253djlrNy9PbTdoM2cvTzVxOWJEQndCeDlvM0RPb2ZJYTho?=
 =?utf-8?B?Skx5b09YaDlERjNHVzFKZGRFWnpnSENJRStoQUVKTGl1WVZzblZRK1l5bVRp?=
 =?utf-8?B?LzVhVElvQURIR25KQ3JtSkd2cVMySFRVR0xPM1ZLd1VHU0hrKzJhWDVRaFhl?=
 =?utf-8?B?N2dnaWJnZlNSZzlLdWIyTXlWU28xVGZwamFDenVWd1VLUkJ0cWxZQ0FBUDB4?=
 =?utf-8?B?OTNvOFJWQmFqdnQzQnM1S2pmalh0elh0b2lNUUxnc1pYVU92bTlnSFBUbHNR?=
 =?utf-8?B?RXFMVmxQK2JJOXUvRTBxcWdUbXBKZlJOcnU2MDVacEZEdmlNUk5vQkViUnFF?=
 =?utf-8?B?aDNsSW1iaXpsSHJTVHhDSm1vTnZmY2UrWEovRHBkQVNRNFoxNUUrZUZXWHNJ?=
 =?utf-8?B?QUdUMDM2Szd0YlNJZHQ5R2p2RFVoZzJzbFhMOHBSMTZkczFsSW4zQy90a0do?=
 =?utf-8?B?WHVMRFhLNHVHN01ILzNuZ0l4L29VUGZwcHpETGpITDd3UXZMVURoOFB2NXo1?=
 =?utf-8?B?UzAxbEVuK3cxTWVmZGRyLzZYYS9LYkJEcFVyT1JjdlJBdlEvdjdwVnM2ZnlR?=
 =?utf-8?B?cnVaVmk3Z3VoaDZMak1vMUtOZnB4YnBwVnBPdlNTdkxtTmtjMnFXb2t6NEZs?=
 =?utf-8?B?Wk14ZFRhelFmbHovejZ5R1E4SEZySTBjMTZqaDZzc3U1RWdOZU1PYXh6c3JC?=
 =?utf-8?B?aTdtVUdZWWlTeU1mOHVKUHhPYndXaVRKWnBpamczL1UzWjJqeVFLT2UvRzdj?=
 =?utf-8?B?Q3JreC9rd3Y3bkRMbkNZazdHNjc0UEoxb3oyM0dEYkFta0lTRWRHaGswczN4?=
 =?utf-8?B?NzhONzhKbFRZdytQNDR5VmVmeHNGdm5lVURSWlIyYWkwaUZXWlJJOVRkVFhi?=
 =?utf-8?B?ZE5STExCQWFpOEJhNmZpeTVYam4vSDVidHVxc25NUzZONVBGR05wUllrcnlk?=
 =?utf-8?B?aEdMbUFOTjRYZk9xZklCMTVkR0xKM0FJdzM2aEl5MzdrdVEyRmcxYjhMQ040?=
 =?utf-8?B?ckFmYUFuZlZ6Sjc1QytYUmVmRm82aFdVQWR3bmtubUd3ZlZEbUM4Z1pmQ21Z?=
 =?utf-8?Q?ew+rOb4A9TEcWg6ZQQx/P2bic?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb36bb3-1d8b-426d-8db9-08dd3b62650e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 03:59:54.8342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9HZRchCL3hOBrZn8jCjRSQOkW9J2QtzdcGr8gHcaL6cz86AO7W6DaT4bnYCSJh2X7pQsV4t4Zu6FrQnRXAcAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7795

On 1/22/2025 1:04 PM, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The callback function of call_rcu() just calls kvfree(), so we can
> use kvfree_rcu() instead of call_rcu() + callback function.
> 

Reword to imperative style?

The callback function of call_rcu() just calls kvfree(). So, use
kvfree_rcu() instead of call_rcu() + callback function.

> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/lapic.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3c83951..d6e62a2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -221,13 +221,6 @@ static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
>  	}
>  }
>  
> -static void kvm_apic_map_free(struct rcu_head *rcu)
> -{
> -	struct kvm_apic_map *map = container_of(rcu, struct kvm_apic_map, rcu);
> -
> -	kvfree(map);
> -}
> -
>  static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
>  				    struct kvm_vcpu *vcpu,
>  				    bool *xapic_id_mismatch)
> @@ -489,7 +482,7 @@ static void kvm_recalculate_apic_map(struct kvm *kvm)
>  	mutex_unlock(&kvm->arch.apic_map_lock);
>  
>  	if (old)
> -		call_rcu(&old->rcu, kvm_apic_map_free);
> +		kvfree_rcu(old, rcu);
>  

Reviewed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>

Just a note: rcu_barrier() does not wait for kvfree_rcu() callbacks to complete. It only
waits for call_rcu() callbacks. For kvfree_rcu() callbacks, kvfree_rcu_barrier()
is required to wait for previously enqueued kvfree_rcu() callbacks to complete. As
rcu_barrier() is not used for apic_map free callbacks, this looks fine.


- Neeraj

>  	kvm_make_scan_ioapic_request(kvm);
>  }


