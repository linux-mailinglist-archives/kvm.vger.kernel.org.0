Return-Path: <kvm+bounces-32851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C099E0CC0
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 21:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 315C72820AD
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533CA1DED43;
	Mon,  2 Dec 2024 20:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cjZN5Fra"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA3955887;
	Mon,  2 Dec 2024 20:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733169910; cv=fail; b=s0+0I+6MaEANjaS8JQQ3ofYz3RlyabswjQR6IAub0Fk/5PJ/Fai4Z/KgLAARvNZIBYQpRu8TSWSnezYafN3c85j21KKv8eAXa9l/EOGhUIl23Koqe1cKwyOCE/Kmr3LUR791v7mvIGKrXY37mqBctcGE4+428UqYf6p2xd3j9FY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733169910; c=relaxed/simple;
	bh=7U10cvbb7dhL2lz6vtERLj5Z20r158v7L+DJeulyCz8=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=TgTurnbLan/eC0Lm+StnGWO5CGRAdVPWIIBrPNz8ZgYBqIyXG0l0+vBZVzDvs/GJSNCt36kTd1HESS+hfFqOe7eorDMZMlTd7Y5gZMPdwBBQ2fjb/L2usqTAq7WluwHBRrrtgBiOmRv25ecTopdcYUtYRnE3qqoKnAtN2CpxAQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cjZN5Fra; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vXL27/T58Unzv6Uhpy07nd2vFOlmt8Xl309NQiE9clMSEWxpCYRRBNd83CZHupzRqPdy6zo2oiX75oL4MkGYosFKICK+iwwWyhW6/XS+UwV0FOp4D3mpnoURPCxcNoYztb+KQ/sox9g3KmxkhqeLpDEPA3GSMRxrzyPdz1arPgmO1EzBtjQAzGEBqXWXmNxW3w+CGMDVwvkio+UjGlnyuM1vsRqtTd97KBTX480aDquxs0ssBabw3qwYEJxAEfaYpefiAbD6UK3aO1Cw93s9G+54el29TqI6H/S9+GkKwS9c0U5dhOgNWdIS0DGIA6bCtp98MSV0eUhO5fbTE8kSZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEfu1diXo8XB8xWjRQ8y4YHf1giV1/rdSpJmzWh/+/c=;
 b=c6bnn8dkfEaDSU3SJS80WvQ04/UcHoKJ9lnB5yS52iPFRNa0jOAaZb3FJ/he9L79opb36xQDWdaqpxGydbr91C27tXxygojtLIC65rJYdvGzwnG1dHZGWX0WRfQbtlLVQR3Mu0XpfcE2RzUhuN/MYcOp8+/yatTVWrp/DrESOxLT4U5T6oxFgqSvvQvqJdU/y0QFITcPB1gENetPP10dH611sMg2/i+twizjE4hp25HW0O+Pdwti+Hkqx6fK0fRGfar/HUfVJae2fU+LvG3Yoy3sY2OpKfbIYVz1FAZOLOyTxiKdXbdhjMslYwcNBdEVecjTzE6uIko8+5bDrI7FvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEfu1diXo8XB8xWjRQ8y4YHf1giV1/rdSpJmzWh/+/c=;
 b=cjZN5Fratd0C/gfL5dYWKIRyLWFUguvYyDByHrGuBwgOY2c/oM0y7x2CmL4dxm1k+8kQQfi3gkvbUcKK7VaQre+fDq37cfCZq8aSOdMNF5G/tzt91tKLKEleUzPENMwC3v6EbDFhuXVDJSXv8Gk9kGoMV5m0Ssj7I8cs+GBeRik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8208.namprd12.prod.outlook.com (2603:10b6:208:409::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Mon, 2 Dec
 2024 20:05:05 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 20:05:05 +0000
Message-ID: <04679c7d-cffb-5e5f-ac7a-d351f2e37c55@amd.com>
Date: Mon, 2 Dec 2024 14:05:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-4-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 3/6] KVM: x86: Move "emulate hypercall" function
 declarations to x86.h
In-Reply-To: <20241128004344.4072099-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0128.namprd05.prod.outlook.com
 (2603:10b6:803:42::45) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b1e7d13-e5b9-456f-f0e2-08dd130c9d26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXY5b1V6Mm8vb0svbVRUTmtBZW5tUytHN1BwSnZSM0h1dm5RTE1XQ2hYcWlI?=
 =?utf-8?B?UkhyUnlDdHdyUnRaa2NBMzNDV202T2tqTU5vSVMvaUQ5c3lEczBuckN5THVk?=
 =?utf-8?B?VzUxVnN3WHJQb01EQWdJd3d5SmdtMXpWNXp1Nm9odmNEa1B2dUhSZzl5ME5l?=
 =?utf-8?B?bVFycWJKOHV0bjRRZDA0MlZwbi9PSGNEdFRKOTRCU2hpd0V5REZEcS9QeXFI?=
 =?utf-8?B?TVRjc21OTlBpb1hjaXJVOW9IUnJDSUVoNGQ3UkVZZmFsRGk0V3pUM1p1eUpK?=
 =?utf-8?B?bExWais2RjV3SkxHbUVRR01uWjlPRGN4ZVJyNzdJKzJVRXRiYTBNOTdMbGdl?=
 =?utf-8?B?UjNjNFJuTk9sYXdubnVQZ1FzcFZ2QkhoeUtvSUhDUTJPOXNPWDlkZWpOMStu?=
 =?utf-8?B?MVJmNUNpOEwxdVkyWWM4alZLbEJpbVRUQWNMMjRsL0FUeTY0eWpBdkNmUkFq?=
 =?utf-8?B?WGpCd0JXVy9HY0g3WGkvMFB1RVV0YlEwMmxrajVZaVoyWEZWRTlxQmd6YzJB?=
 =?utf-8?B?emMvSzRKeVlaKzU2VWFXeGFhQ2NVSTRuQnJRdUJUdlJ2a2t3NE9oaTRvd1VI?=
 =?utf-8?B?NENwVFhZaUdSYXgzb0JPc2tMQjdQSXEvSkRKYjVBSUtId3NRWVB0SzJ2WnVX?=
 =?utf-8?B?VkpmTXQwZktnd2p3ZWNPU2xIS1BnK2I1UVBmMEVaTXcvdGZuTWlqUXhjWlc2?=
 =?utf-8?B?VVpQZjdMaGVUcUJXZldzZWNna3Y0R0hsRUtneG5QYVYrWkFWRUN3Zk4xTXZB?=
 =?utf-8?B?b2lwZGxqUkxLVzZDSUJ4d2ZGR1VzelYzTkhSUVFIUUVzQXc3REVSSldXTDBD?=
 =?utf-8?B?N0dJRUlkV3FUclk0ZDZRT1M1aWxhcWRLNFhiMy9aV3lQMjIyZFI3YW9OeDgr?=
 =?utf-8?B?MGZGd3JwQm5oSk1MYm0waUYvYVVKV1p2ZDdqSzVWYklFVW9aVW9ITmtDRHY2?=
 =?utf-8?B?cjdhaUlNeXdtTk0xV2pWU21hcHRwT3pYY1JSTTRhVlMxd2dhQlZJTU94WmtH?=
 =?utf-8?B?cklWV3puK0wvMVNJOUhUVWR2RkdIejE3WlFtZ3JkeXUweEZZcVZBSXNoSkxX?=
 =?utf-8?B?NjhZcnUrRm9GU0R3aUZQQ25ZVWliQ3JNSGVFOXUyQ1hLMFRZUzlWNWdyZmNn?=
 =?utf-8?B?VUJoU05ucFd3QUF4bjlTU1BteDBUNXZrY0pSUGtFUGkySE9pTWJjQWRRVVQx?=
 =?utf-8?B?bWNydlZ4ak9KaUlQNHpCaW55amdkWm1tNEFydVRkV2x1VGlKREVJeU4wZ1Uw?=
 =?utf-8?B?eFB5NVp5cVFoY1J0R3F1ZEtySndEQkIxcTB4ZXd5TldDcXVSSlRVSERyRyt0?=
 =?utf-8?B?a0lGakpFRFQ0RFB1OGw1bmJxTDFlVUVFWDVHRUM0NXFxV00xR1BWRXhhMCtx?=
 =?utf-8?B?M1FsK1I4enBnOEN4UnRZdE9mYkd3NUxUa0dpaGwwNFNLUlIzZGpsRXhyQWhF?=
 =?utf-8?B?MVd4YW16NGRWaEZqYlc0eHQ0Q0hXZlk1T2E0VU1tTllZZWFRNDlhdE5mR2M2?=
 =?utf-8?B?Q1hZK3lxY2F5dmRrZW1taUJMV2VoTXVDWFBnSTRGcWtxOXkrTk00dkRCUi8w?=
 =?utf-8?B?TWgvRUJXbS9sUDF0KzM0MjdzQ09RVmtQODNJTXFWL0ZlWjFXMkQxOFZrZEJN?=
 =?utf-8?B?bWkyYlltZm92eGF4OGI0UTNBbTB2NHBwNHFwR0VHWGNJVk8rL1pRemdaMEhU?=
 =?utf-8?B?Z1c5eTR1SHJpMWFXZkV6a2JqTG94SUZ2eWFuQnJQeXhqRFRqNngwL0RXYzZI?=
 =?utf-8?B?TmVFZGdiT0RlcnBoaWN0L0s0cXRtUlhHSmtkTFN3M1E2VGYyUTBMVlJWYmNP?=
 =?utf-8?B?L043Q2pxN25ud3d1OTR5Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejJkSDA2UE4zZ2V2UVEvcVNTVVAvMlh6N1d1U0lvTXhTYWdGbDl2SEpnWkQ4?=
 =?utf-8?B?MHhxZjNackRzSDRtb2JibFY0YU1ZMFN6TzdXdVdDUks3aDdWeXM3V1IrRlN6?=
 =?utf-8?B?azVIZElyc2hBSFZaMndUa1dBYXZlS3hxWjJ6dCtwekd2VmRGUTJITHl3OVlr?=
 =?utf-8?B?aitFVFozNHgzMDQ5L01iOXN1SHFvM2hWWUo0bVUrMUVmZ1FUUlNTL3VEUXlE?=
 =?utf-8?B?MGRLOCtSaCtsZExiVjZHcEIzRGxmYXJFb0lWR0x0TXhkR0dJV1h2M2ZEMURM?=
 =?utf-8?B?S3VGa2JQMWs0ZHVtYjJlL08vUUd3Z1hQUC8wVnJyOHpsWk1qa1BRR3RGYit5?=
 =?utf-8?B?azhOei9iNWtjRk9wM05VRlBWdTFXTE84TEs5QXZrQ1JXYWFOMCtybUt0TmhR?=
 =?utf-8?B?TUwrMEhFUFNPRlA1VGpKZVVzK3c2RlV6bUw2Q052dHVDZE14YS9ZdTBLUUQ4?=
 =?utf-8?B?K0sxYlp4VEJLOGJGeHZGckkzdjZvalBueURwQWRKOU81QVNiSjljMmViVFBq?=
 =?utf-8?B?V1M5WW84ZHBVWHExVkdQZm03RytoM3VrYmp1U2xiRjdCZ0NQcE4vbTl5MG1y?=
 =?utf-8?B?WlJ5Z1FJRzJZYlV2MjYzSWhpQTZPTGQzTC96L0V6emRKUXR1M1ZyZnAyaG8y?=
 =?utf-8?B?Q09jYzhiRDVrWndsZkUrcURQYWNhOG1WVXRDdmhnMXlIQ0gxeTkySCtDWXcr?=
 =?utf-8?B?Mm1NcWY1SmtKLzFKTUtqcGwxeW91aHd4Vm1SOXJtdGhBRmVlYTFDR0lkQnhq?=
 =?utf-8?B?YnBiekUxak1YMndqTHZ4aVBrQndKTDFLSitPWTNnSVhaZmJXUkZ0dHJsK0hX?=
 =?utf-8?B?Y1VPdGYybWl6ZitPa0p2a0FweWNjS2VYaEhKZGs0M3RYb01qSHl6aWk1dWh6?=
 =?utf-8?B?VllFL21QVWdERU14SGNrSjRVa0J3cUFXNUtrVDIrRGh0cm9yYmVSekprQnZu?=
 =?utf-8?B?VCt3amlxVTNzRGRIaDdkNkNqbFcyU3E0TGlSMCtJbzF4WkRRUDZsOVMxQkx6?=
 =?utf-8?B?S0JVN1hMdjREa3lRMWhlNEYxSnB2K3FpbTh6UkFqZ0NlN2lYWlkwQ3p4b3Zz?=
 =?utf-8?B?NllBeGVFRzNnWHZ0UllSVGlWZmdCQzh2bDdpWnZ5RHRZUzhTdjJsRm5wd0ZZ?=
 =?utf-8?B?KzNvOHFGSko0eU1CMVdNc01qS25XUkZ5T0k0d0lIaTducVRrN1pXaC9VQnFK?=
 =?utf-8?B?UDlJWkNhQ3RvYlBLdWVwN2lIUkRUVDAvMUZWSGw0NCtUdnhWaWUwMFlCL1Za?=
 =?utf-8?B?UUpqMHppMWJyODg3alovdVlsVkoxT0cvd3NaeWFLdlpOOEJqSmFtQjcwNTFI?=
 =?utf-8?B?OW95UWkzOForcGpibXN3TEtqRFpXVXdObnpuTitmVDlmMUp6R2E1ZDBZc3Ix?=
 =?utf-8?B?a0NIL0QrSVI1ejN6UTN5Um5FOGdYVllvSUg0Yy9jdTlNV0poSjdaZVF3VldX?=
 =?utf-8?B?am5SSjJWYmFSM0hVWlptK0NDa0w3L2JDOFdaRkFwbDBHd1Vjd1EzYUZsNm4z?=
 =?utf-8?B?b2FHaXlaSThNMlphdU82M3lzMktNTzNVTVh0am5hRlkyempvQ1E5alBqMmQ1?=
 =?utf-8?B?QjBMMk1DRjErS2JoeGpiK0ptcHRPclNmVlJwUS9sQnNWTEtHaUg1NXJtNmNZ?=
 =?utf-8?B?aEVPa2EvajhPd2ErNGk1Zm5vWlVXOFJTemlmL0VRR0puV2U4QUhGWG80SUFw?=
 =?utf-8?B?RUtIa05VaTVrN01KZVE3N2QyV01IYTg3U0JGNldwKzVaWkpPQysvVy92QTNO?=
 =?utf-8?B?eDlOUkJyMXBIREVYalpCV3F5QUlkeVhEQWpKb0Q4N0tLZUlrT1M5THUzTGli?=
 =?utf-8?B?SkJFRkkwbnM0dVNnTkd5WDkzMU8rcW5EV0prRzJpZlNHRTUzeDA5bjVtcUQv?=
 =?utf-8?B?NlA4aU5EL1psYzVVWWh0VzhGRzNnNDNUWmppbXpQOXkyVHVRSk5kVzhvbDdY?=
 =?utf-8?B?OWpYc2tIdkltdXRoMW5raTVqTFRtNnFZdHNQTDA1NjAyYkJoVDB2cXZaQkNv?=
 =?utf-8?B?SlIvaXhVNGIwV25PRUtMeGhQK2hRT2E2cVAyRnZyUmdkbGcxNjhzZ1B4VEZR?=
 =?utf-8?B?SVc3M2h0SFBiL2ZncU0vekVrb3NlbkQwU1I0bEwyZ3dpSWw5b1cwNFpjQWtB?=
 =?utf-8?Q?vIIfSdYJq5IFM1dhME8/AFvfz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b1e7d13-e5b9-456f-f0e2-08dd130c9d26
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 20:05:05.5623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YjyX2vOZGKGM+DdemCPr0vPkXNQXepUI02zbm+NYnnHfLnOA7HIiMsi1vVkH3I2jz/7GaKHM6SwtYnfqgDG4nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8208

On 11/27/24 18:43, Sean Christopherson wrote:
> Move the declarations for the hypercall emulation APIs to x86.h.  While
> the helpers are exported, they are intended to be consumed only KVM vendor

s/only/only by/

> modules, i.e. don't need to exposed to the kernel at-large.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/kvm_host.h | 6 ------
>  arch/x86/kvm/x86.h              | 6 ++++++
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e159e44a6a1b..c1251b371421 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2181,12 +2181,6 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>  	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
>  }
>  
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl);
> -int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
> -
>  int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  		       void *insn, int insn_len);
>  void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 45dd53284dbd..6db13b696468 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -617,4 +617,10 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
>  	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
>  }
>  
> +unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +				      unsigned long a0, unsigned long a1,
> +				      unsigned long a2, unsigned long a3,
> +				      int op_64_bit, int cpl);
> +int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
> +
>  #endif

