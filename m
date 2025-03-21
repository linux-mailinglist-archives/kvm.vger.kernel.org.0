Return-Path: <kvm+bounces-41716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7880A6C2BC
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:44:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E652E3BCB60
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D61922FE02;
	Fri, 21 Mar 2025 18:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ath8OUBE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DA51E8348;
	Fri, 21 Mar 2025 18:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742582640; cv=fail; b=m/Rw62RllYgqytCIqBypm4g7QAIyVp8P7oWQQeTBAndB5tF9Pi5K1YEn0dfrV/8IcnyzFhErBb6BdcWGB6a7JJu/cBGwYzP7GOUFS5g9lb6v5JVb4anR7ee8cPuBt3VkM9roSPTh7zCcqbBbIE3JIJb7FqW1mY+BhDaTOm27wmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742582640; c=relaxed/simple;
	bh=4zIgFb1UzK9Fvu6abhVZKO6eiiLPmFs6v/swVH6NRMI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NmYCd4ZRE0QGXjvRn00BzMm8Oa+26CwV+WsuZ4dLaj3DqCbSBlOnbyza0oXKRDK0FjeRmTqah7v3a3YimTOzANZTRQPPK01UA29/f/hgtXFNVbvBQYHYQXKISJFpoI/5c6EL0ctruJbPko4RaGxQm18v3G9wRi8OqKYxI/uRC5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ath8OUBE; arc=fail smtp.client-ip=40.107.223.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WsuVHlP2Hlyn71+KNF4Iv+Ymf9raLWbk7FL/J3y7p8EtPQbbzGTGxrEhJHRMbOmhizNnX5kLiq8RKlGk8lOXZnfJmARodX9D1cL9n9MFgkXc8LZHm2ZYItZ9flgcw4oYrmNl84QSr6P5YRAEYocFvGtoZU4gQU42KdM0SGoEXAoaaDdYs5H71Dpv5QWRV0zKvEfU3A1ZpiZbULfMBmuB4wfg5TCHlzS97FUZpNLvFTqhDBeu5DeWRTtNk27E7K1mq3d0bPKRyifiBh8erari7OH8FbLGgdPkQR1v4HZUrpQ7BX3HVcv48mU8Py4d7EL5TLr6Hj7gQ3GrJDMXI3PCUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MIEYMnhXc5ivBtMwJbRl4tJsM15A7wd6cgzGwfB3/o=;
 b=QGSmbc1IPPCg9kdlGp6N3+Dmi+HeisKpp6MGACGERgR3kmT2vfDsU3mdf2uMRlMipyOZWhVuS5JQnpAyUsRUCBE4zGhbqY1y9hOK22z7nGmvtafHPYOeiTI/Xa9xRfQA4/yL5NdE1z8Xxz8M1boAu+HymShlVp4iemXxEWV+zsmletbXbkH1e+xYtaQuE7p3U3XzfmwUfoFKZY6QLWaLg9VNziJXkKaannbRrcYMwA10BY2d5eeH2wyeY8Al8FEAQvaoKz4SGZjL7qlmCTTZGd2fxi/9wKW70r5NOwNdlsRp8u6lXqmA2TM0vA0VsoMZ9xBjkcRY1C1XBa5kn1pZcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MIEYMnhXc5ivBtMwJbRl4tJsM15A7wd6cgzGwfB3/o=;
 b=ath8OUBE76YDNr8IaqUmZDLPDGaO2MUHqv6plzOFxxPD/YeKCcpIFQC7PVU9w5oIwAD2mte7/bsfSuF1AUW7inUapuVRUElhiEGeb2uE8bMOsM//qDtw+noZVMvJBY96zMhmGjGaTJHgx4TTBY3rkZvtE6vzA1DTSE5ohsu3+O0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 DM6PR12MB4404.namprd12.prod.outlook.com (2603:10b6:5:2a7::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.37; Fri, 21 Mar 2025 18:43:56 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06%4]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 18:43:56 +0000
Message-ID: <e5d67d43-49c9-4c85-97fe-d8a8c61b0174@amd.com>
Date: Fri, 21 Mar 2025 13:43:51 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Provide SEV-ES/SEV-SNP support for decrypting the
 VMSA
To: Borislav Petkov <bp@alien8.de>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Michael Roth <michael.roth@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
 <20250320141707.GBZ9wjY42cY7_dQ4ql@fat_crate.local>
Content-Language: en-US
From: Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <20250320141707.GBZ9wjY42cY7_dQ4ql@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0022.prod.exchangelabs.com (2603:10b6:805:b6::35)
 To DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|DM6PR12MB4404:EE_
X-MS-Office365-Filtering-Correlation-Id: 643c50d0-c9ef-4f83-1363-08dd68a85607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RkJHMmdYc3hSRnh2UnpEQklRYmlCTnl1d1h4NXhFWU5Wcm4wdjRwQVdrSVR5?=
 =?utf-8?B?VzNJeEtNemJmdW81SHdlckVvUFlUUERwdWZVR0o1UE4yRWE4bjBjSUt6NVAr?=
 =?utf-8?B?ZTBsMDdZN1RoU3M0UmFvSFpzWk8wSUpnTk1FTm1yc1hPRWRheXVzd3p1Qy96?=
 =?utf-8?B?SE5GQkZsYmpTQWJBSlJZNmdtUTllR2FMUTUzM1hmWFFHVGhWOVc5UEU0OVV6?=
 =?utf-8?B?SkZlSWxmSEZkbjdBZzF1RVJSZFR3WTVGWVRZN1FJUkpkVDFXVUQ2bktLK3ox?=
 =?utf-8?B?VmwyQ1BJamI5WnZERGN4L3pHNWNKNm91QzdaNkZPQUVKRWRlY2xJczMyVG9x?=
 =?utf-8?B?Qncyd2tuSGlVK2xaME01WFpSZ0F4dXY4RmNFc2xvQk5MTlhsdklHMWpmUW4z?=
 =?utf-8?B?aXlLSWRIMklnODZLYjc5NjB0cWdleW9wdXkzcVNrWG5ZWFVhSzR4ZGlIZXd6?=
 =?utf-8?B?Vm02bDZYbW9zek9XWTJIVFlUQXJlSjZScEhLeVQ5dkVLc2x5Z2dCd0RrUGdo?=
 =?utf-8?B?dXExNFZvTGxmYUlJaDlzY1dwWTdYY3k3cStLZEtGNkJPTXlFekpoQWVkK1ly?=
 =?utf-8?B?VEZEQnJ1VmFpR1FoanpzYjRzU3JCMCs1aUp2aDNHRElWM0NvN2tmeTlWODZh?=
 =?utf-8?B?NzdxRStYQ2RPVk5SbERXRFdsblI3dmVLcWlBWWtVVXM2T2NwSnM5b0tHT2pL?=
 =?utf-8?B?UVRDVHRCRHJkNlBWcWoxTHhxS242Z2s4azBBem4wc2FlWUkxU2hBdTh1Mk9q?=
 =?utf-8?B?RGd5UlRkVWxua0RtU2JhdFFCa1ZjcVA4dTltNjdTZ0djVHAvK0FCV0lmc2xu?=
 =?utf-8?B?RS9qZmtwZE84QUNHZEVYV0x6cDRtTVZnbE0vMW1abGxhN0R2a3RiVkU2N0x1?=
 =?utf-8?B?em9QRHAvVG56bE1sOXA2ZnBqWTN4UFNmdUVRT1UzMTUxVXBkVkpwaDNsV2tJ?=
 =?utf-8?B?SzNKRmpiUk14SkRpQlM2VEtlbU5lS2xkakc2THpjTXROcVVsZldQOTdCamkr?=
 =?utf-8?B?YXM5Yms4dDhxdCtvQVcwM21vdE54cjV2M1F4bTlsWlozdWo1Qm9FclYvT2RW?=
 =?utf-8?B?QUVDY3pYR29ZSlBpbHUvS1R4VjJwV1J3ZWMrOW5VeWxvbnJVWHZENVVNM3J2?=
 =?utf-8?B?Q2hJVVNpS1RHeGJhWlZ3c2pVKzhHRS9rMHo4eEZvMXBNd0hJcTAybmFGaGIv?=
 =?utf-8?B?UG92RFY3RTRhRFBLY1lmanQzVTAxTUNpZWUyVDcxNUJzZW8zLzBXR28vNENC?=
 =?utf-8?B?Vm0zdW9teGRhOVE1RWFOK09QM2JOQnJZNWZGaFdNdytGbWtzTkdlUE9tOUtn?=
 =?utf-8?B?YzJ3NTcxSVpLNjY1UEU5dUhoZW1hZTl6Sk5wVlVrNm90V042THNWaXRLYk5B?=
 =?utf-8?B?TUsreFJuVkhqSGY5ZkdZTDUvL0hIaVRyWExsV3U2c1NnbXRLVkVCQUZxdU91?=
 =?utf-8?B?amJpQ0hncTAwWGtXYVgrVnJHVXdpbmtWTEExRldrKzU0TnlGWC9abW13QjlQ?=
 =?utf-8?B?UCt2SUxBNC9BWHZIQSt5L1hWbmNmMHlpVnRzRUdRQjh4eml6MTFGT1orTVFt?=
 =?utf-8?B?UlpCcnFkeTVZZDZ4ZHpsMzdtUC9rVGdsZVFtN2p1bmxMNDZDbzgwc2x0VEJt?=
 =?utf-8?B?QWhPeGMzUmJRZGNCQkFkbHMzemI5YjdqVmRZMWJWczU5RnVZQ3Vhb2ozMGMw?=
 =?utf-8?B?WTN2MHp1NS8rdWF5ZlJaYU1yYnhocDZkQ1lxVk5rNWtiUEpBbW1KV3dWK0dm?=
 =?utf-8?B?bVF0K0FxaDBSRDlIb2ZiYmhYVkgrVUpwY3h6ZVZEWUxDNkZLMWdaMjlwSFZD?=
 =?utf-8?B?MW5EV05qUHFPMkI1ZGZLVWJ3eWhBejN6WTh0Vk5QSFVqZ2pzOHdaOEZXMFJC?=
 =?utf-8?Q?8I75eEYdysXj6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlVWQXp1R245c1EvTTR3TUFMRUpZSHgwb2daMDJhU0JMbGVGZWJIU1dqa3ZK?=
 =?utf-8?B?SURmN3Z3REhZM1JDSWdIRU04UlJVY2VZcXg5UDJOK2NYYnFWbzEyZEdwclpD?=
 =?utf-8?B?My9oREhxMHFFUHRjNXNkcW9YQkNpcCtJTm41emRxVlpTZXVIQjBEdUQwbXcz?=
 =?utf-8?B?ZE8wNzdGWCszUnNVQlVaUVpKTW03cGhlajdvajRqaC8xWjRXcTBwZ3hPY0gx?=
 =?utf-8?B?MHBUWnpDb3N2RFNlWEZPczcvb1JDSDd6eXJsWDc2MEo2YlB1NnFaRDhheGs1?=
 =?utf-8?B?aWNxajZsanhTTG1BVU5jRmNGVmZ0NjJmZ2Y5QXNqdTFWUERURzJjSkN1U05r?=
 =?utf-8?B?TlMzeHZmUzNJajhuMTdXUTZzOTUvVzZzcGZFTVJVWUJmb1BORHhlTmtqSXEw?=
 =?utf-8?B?a0t5bnA4dXJrdTN6ZGh5WnRBejJ4aVhwNTBhTysvWWpsYzVKekpleW5rWWFq?=
 =?utf-8?B?RWNWSVBVa2IvV1BGZnozaFZoOVZ1N3lYdUhOVnoxVTUvVEZMUWdiU3h4THll?=
 =?utf-8?B?V0JQbjk0VkV1cVV0ekRqbktpZmVRODhRck5yWWp4QzRoV3VtQzJYRzB4eHZL?=
 =?utf-8?B?Mjk1SGEvTHF2VktEaHRZZDNyZWVQdEpFS2t6djhVUmdYdHlyZC9wZG1JM0J6?=
 =?utf-8?B?bVhHUU5mRFBNbGxiNnlnUEdGMGFuL1krNU8wbTFVWW1aOGZndG96Q2cvaGcz?=
 =?utf-8?B?Wmh5VnVJamlSbUpKZnV0Y21QMkR5TlRQakZLcDhNNXFnZzFTVEhRQnFrUzZz?=
 =?utf-8?B?dlV6cjg3UDdHWGMya3FVNkEycFgwKzAwUEo1b2FRL25UNUt0UmJjcE5tK3o3?=
 =?utf-8?B?Unc4TG91cEIrNUtjNytrbnQ1V1BQYWczVk1EVUVjSkl5VUhTd0g5Z2VSL3Rl?=
 =?utf-8?B?L1RrRVN2aE56VHUwMkVzYUpGV1hVY2hYSEhLWEZ1cFRIRlhLOEE5S2w5Mm9Q?=
 =?utf-8?B?SDIvaTBGNVBGVXhhV2hzM1JjWnZ2NHZRTXovT01VUzZka09GMHBuV3lFOGdo?=
 =?utf-8?B?disyYVIzME9CaW9rcUdibU90ajAxT3MzZHhhLzlmMno2YjFZOG1VMHBScTEy?=
 =?utf-8?B?ZmlIU3pucU9ncHViTlVuWjJUUUJnbG0vRTUzMlhYSGpIZm5pd2M3K1FFRGlt?=
 =?utf-8?B?c0xmam1VYmFzT3JMZ2g5V2ppV1gzQkNNcVYxTHRRZDllR001MWZKekhxVFZ5?=
 =?utf-8?B?eURjcU1mOHNuOEdUdXBlUlRFbDZGS1J1dU5ZbDhGZHY1S3VNcWNocXFQMXRJ?=
 =?utf-8?B?S0phUDNOVVNZTXJQai90d1I0WEtkL1ArYWN4ZThsNTFSMjNnWU03Qm4wdnNL?=
 =?utf-8?B?S3ZRVDBCNnNNTkFjZzMzOHVGaHZoZkpxZXZZMlJUcjNIUEVvMmxFZ0g5QUg0?=
 =?utf-8?B?YkJ6Vnd4OUVGYTJ6YnlHZG5hekU0Q0NMb29ucVc3Wk5tOXhWOTdZazhVczQw?=
 =?utf-8?B?b1pDbDVSMWRJa28xeDJCZWRPb29JWlJUVFV0Ynd5bzlwR0pOd3A2U0lGUjdI?=
 =?utf-8?B?VitUc2lERHlFYVlOWlFGUk9QRUZpak1HK0k2SU56aitOL2hiYXFJdmxKNlNY?=
 =?utf-8?B?R0JpbkhESVVWci9EUThTbG84d2FWL3l5SUlld3cvT2JxOGNDR2dMdnlOV2Z4?=
 =?utf-8?B?RVl1WFErd3pqYTh3dW1kalJESFlQQkdheE8yemtOK2ltNkZNeE1FSHVMeXdW?=
 =?utf-8?B?QjJFSHcwV0lNMmVLZUxoOEs3WWp1d0s5cGdTRGYyWm9tMXVEN0NIV0w4Y2hy?=
 =?utf-8?B?OHg3UjJyenFwWlcxQTU3Y2xVNjNwODE0ZzhpSkFBcVhUblQ0MXlhd0gvSXNw?=
 =?utf-8?B?ZkJhT2NpSGdXcDc1RHlkNVZBWHRLQk1IVVZmK3RaREUzeUFBNE5oLzFURFZi?=
 =?utf-8?B?Smc0SDhLVWxra08vNkhqTE5IQi9hYi9XTWkwaDA2YU5rUHB6VnNSQ3VpL2Rh?=
 =?utf-8?B?TkY0T0xpNE84Z045UDNpV21kZTMzZGdlRDh3RzgwRUJZWDVKOG9CWFdwbERT?=
 =?utf-8?B?WjVyNTJrWWlZN3NNL3RZbFJoblgyREhHYU5yVi9EYXV1MUZtYlppNGdvYi9a?=
 =?utf-8?B?cE93R3F5dU5ibkcvbVFoZ1VZSVVvS1NPL1VvSkEzdlRDeU1tekI1VzdrbDEz?=
 =?utf-8?Q?/YOCo4iT22KX2bgO1rgiAWs5+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 643c50d0-c9ef-4f83-1363-08dd68a85607
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 18:43:56.5493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZrIQBWkmY1MHcIabmHv4O8jnaRLK4H6zfLQDNPPQwUjiVaqy1EGj2FeULLUFEeP2KAgHYAGyIC025+MKFdn8dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4404

On 3/20/25 9:17 AM, Borislav Petkov wrote:
> On Thu, Mar 20, 2025 at 08:26:48AM -0500, Tom Lendacky wrote:
>> This series adds support for decrypting an SEV-ES/SEV-SNP VMSA in
>> dump_vmcb() when the guest policy allows debugging.
> 
> I would really really love to have that so
> 
> Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

Me too.

Tested-by: Kim Phillips <kim.phillips@amd.com>

Thanks,

Kim

kvm_amd: SEV-SNP vCPU1 VMCB 00000000759a48a5, last attempted VMRUN on CPU 7
kvm_amd: VMCB Control Area:
kvm_amd: cr_read:            0000
kvm_amd: cr_write:           0000
kvm_amd: dr_read:            0080
kvm_amd: dr_write:           0080
kvm_amd: exceptions:         00060002
kvm_amd: intercepts:         bccc8007 0111ce43
kvm_amd: pause filter count: 3000
kvm_amd: pause filter threshold:128
kvm_amd: iopm_base_pa:       0000000148e44000
kvm_amd: msrpm_base_pa:      0000000276e3e000
kvm_amd: tsc_offset:         ffff6b01ea8aa6f6
kvm_amd: asid:               3
kvm_amd: tlb_ctl:            0
kvm_amd: int_ctl:            07000200
kvm_amd: int_vector:         00000000
kvm_amd: int_state:          00000000
kvm_amd: exit_code:          ffffffff
kvm_amd: exit_info1:         0000000000000000
kvm_amd: exit_info2:         0000000000000000
kvm_amd: exit_int_info:      00000000
kvm_amd: exit_int_info_err:  00000000
kvm_amd: nested_ctl:         7
kvm_amd: nested_cr3:         000000022fc06000
kvm_amd: avic_vapic_bar:     0000000000000000
kvm_amd: ghcb:               00000000bfeda000
kvm_amd: event_inj:          00000000
kvm_amd: event_inj_err:      00000000
kvm_amd: virt_ext:           3
kvm_amd: next_rip:           0000000000000000
kvm_amd: avic_backing_page:  0000000000000000
kvm_amd: avic_logical_id:    0000000000000000
kvm_amd: avic_physical_id:   0000000000000000
kvm_amd: vmsa_pa:            00000005d35c0000
kvm_amd: allowed_sev_features:8000000000000001
kvm_amd: guest_sev_features: 0000000000000081
kvm_amd: VMCB State Save Area:
kvm_amd: es:   s: 0000 a: 0092 l: 0000ffff b: 0000000000000000
kvm_amd: cs:   s: 9900 a: 009a l: 0000ffff b: 0000000000099000
kvm_amd: ss:   s: 0000 a: 0092 l: 0000ffff b: 0000000000000000
kvm_amd: ds:   s: 0000 a: 0092 l: 0000ffff b: 0000000000000000
kvm_amd: fs:   s: 0000 a: 0092 l: 0000ffff b: 0000000000000000
kvm_amd: gs:   s: 0000 a: 0092 l: 0000ffff b: 0000000000000000
kvm_amd: gdtr: s: 0000 a: 0000 l: 0000ffff b: 0000000000000000
kvm_amd: ldtr: s: 0000 a: 0082 l: 0000ffff b: 0000000000000000
kvm_amd: idtr: s: 0000 a: 0000 l: 0000ffff b: 0000000000000000
kvm_amd: tr:   s: 0000 a: 0083 l: 0000ffff b: 0000000000000000
kvm_amd: vmpl: 0   cpl:  0               efer:          0000000000001000
kvm_amd: cr0:            0000000060000010 cr2:          0000000000000000
kvm_amd: cr3:            0000000000000000 cr4:          0000000000000040
kvm_amd: dr6:            00000000ffff0ff0 dr7:          0000000000000400
kvm_amd: rip:            0000000000000050 rflags:       0000000000000002
kvm_amd: rsp:            0000000000000000 rax:          0000000000000000
kvm_amd: star:           0000000000000000 lstar:        0000000000000000
kvm_amd: cstar:          0000000000000000 sfmask:       0000000000000000
kvm_amd: kernel_gs_base: 0000000000000000 sysenter_cs:  0000000000000000
kvm_amd: sysenter_esp:   0000000000000000 sysenter_eip: 0000000000000000
kvm_amd: gpat:           0007040600070406 dbgctl:       0000000000000000
kvm_amd: br_from:        0000000000000000 br_to:        0000000000000000
kvm_amd: excp_from:      0000000000000000 excp_to:      0000000000000000
kvm_amd: sev_features    0000000000000081
kvm_amd: rax:            0000000000000000 rbx:          0000000000000000
kvm_amd: rcx:            0000000000000000 rdx:          0000000000000000
kvm_amd: rsi:            0000000000000000 rdi:          0000000000000000
kvm_amd: rbp:            0000000000000000 rsp:          0000000000000000
kvm_amd: r8:             0000000000000000 r9:           0000000000000000
kvm_amd: r10:            0000000000000000 r11:          0000000000000000
kvm_amd: r12:            0000000000000000 r13:          0000000000000000
kvm_amd: r14:            0000000000000000 r15:          0000000000000000
kvm_amd: xcr0:           0000000000000001 xss:          0000000000000000

