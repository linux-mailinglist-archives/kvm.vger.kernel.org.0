Return-Path: <kvm+bounces-71209-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2EigDKpClWkYNwIAu9opvQ
	(envelope-from <kvm+bounces-71209-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 05:40:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ABDB11530C4
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 05:40:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E71033047E75
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 04:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 380872FD1BC;
	Wed, 18 Feb 2026 04:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K7eabFZv"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013014.outbound.protection.outlook.com [40.93.196.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD49274B4A;
	Wed, 18 Feb 2026 04:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771389591; cv=fail; b=HFEB4I8M8GNciWyTnAwJXBIbfO4xmqMuIptLZcOEvsbA4/uFqnJYuMsYZZTGGflzgVVHhtDY+zyR2jQuPoTYdR/taDvPgoOdjMVhN7bOw9RK5sKZzSjKZ4iyL+v4L/owvw1hGs73QE40HGNrKHGuOnWDNBm08Ov0Dm/pcPrAAQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771389591; c=relaxed/simple;
	bh=hlH6ej/gfCXKumv7LKWSLew37QoMyou/uSik6rg7QCM=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YdKLm8GLqIpDGwUZxmqdDvnP0c8//b958Y67WOLGlhFJvl9MRC4iNpO6TYQ1KF2aVk2+oxhUUwSZX1a8xhaMtXyyajtNUR+d+VutnJwuG2clq63KRLFFRogurpyrSbDuJH25pG0jWr3Y/MrgeLTwhdLNYN2A43MuT2CcuC8aLvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K7eabFZv; arc=fail smtp.client-ip=40.93.196.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZxyPta1J5/bUZJUgMfrrVAjTesaXxQCCYe2vTfxwUfNPpEz7Foz1uDA3DsNs6w6u49lQCurX/NI/T+WV0kyTfCG96JC5SZUQpRedgCOvwISt3GzrKZ7gYIu+s3x86epZxlylxdlvYN+r96qSHQeRvB5y3ccuxxkourBD1Jocdec9eKpJ7yYoeMEjwLt9efPqJv+y3UqogqHyz0vm1JdUq/vZfJ3UJBJnkYwVHld6LRtI2QNGT4mv2ZPlfrBLFqCpfcDG+oQ5Zd4YHyJ0C30yaeitM18NUJtQwfTsVIK7MHwgOepM9ciPBpAZZg7fhOQHRpgCSurcrlmFpMm/9BIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWPqpDj67DecnsCIvyXU/f3/MhtEM4sPFuU+QhhKEb8=;
 b=ShxyZn8NCbe6hFYzk0arSA18Uf7J3hzsunLd1CH6QjON84tzuY3yczpZVNDlGXAblZJD+wCyscPC4dhpg1BLKooFGImjtpSSuh8izFBZ0kNLgFvfiBvLbIi6ZwKhqBzgTF0hOZ9k3BLFQ6wcEhwnwtw8Cdmy7ZUEWBSp5FsmlS5Sn+RD02NB5q0LWW9yD+/vYyD3h9jTY12T0gbLutrWT+LvC0uODnPAKxW2VWeZm01BzT8Kr2Q1no9HoMZbzIPyZVuGV8prsAbzHxJWMxZ9cRuczIYFYHPR6QYZn8DB67wHzfHbEkHqbHcez+c9nxSm4Mp6PQK/SqzxrHCdyy1tGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWPqpDj67DecnsCIvyXU/f3/MhtEM4sPFuU+QhhKEb8=;
 b=K7eabFZvT4bA+3SmlvxM9Z/fPC3d7ZaYLjOSGEEQlaLPtpepKnTUJ782BrUJ+fNDFGijEMdevs30qnh4E0h26s0NRmRlI2EnE3N0sXKwILa91MC9BzTEe9Fq5+lLSUt97L1Ziopc/v8YQSe6eCKfkVWxHjBj/26xK69JHpiOOF4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BL4PR12MB9723.namprd12.prod.outlook.com (2603:10b6:208:4ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 04:39:47 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 04:39:47 +0000
Message-ID: <84c08e66-c0dc-4e2a-834a-67190b89bded@amd.com>
Date: Tue, 17 Feb 2026 22:39:42 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] x86/sev: Use configfs to re-enable RMP optimizations.
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <88ddc178dcab3d27d6296e471218f13a4826f4a8.1771321114.git.ashish.kalra@amd.com>
 <21250a3e-536c-4348-bf4c-a7356a13939b@intel.com>
 <e72165ed-c65d-4d21-bff6-9981b46311cf@amd.com>
Content-Language: en-US
In-Reply-To: <e72165ed-c65d-4d21-bff6-9981b46311cf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0397.namprd03.prod.outlook.com
 (2603:10b6:610:11b::30) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BL4PR12MB9723:EE_
X-MS-Office365-Filtering-Correlation-Id: a06b4428-1760-4bb4-af51-08de6ea7be5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1lqMWJnY2FkU0V3R2l1eG03OW85b3IyL1JxOVNmaFYxbCtTd1dyOHhXS1VE?=
 =?utf-8?B?VXRiVjcySFVXSjI1TGw5YVBBUXdCbWJpYjMvTzllbVkxcGJjdUFRZHRDNnk1?=
 =?utf-8?B?N2o4L1RlV1lxRmJtWmRuN282ZWVJREtrZW9zdG9PdGlyakhpMm5CeFltU2J5?=
 =?utf-8?B?MGJGUE5zc2U3MGpXakxRUldUaFZ6TGg4K0lIMy95Y2VIcHN6a1Zyc0dpMXBo?=
 =?utf-8?B?Umphb2pwTmZFODZ3M0xmcmt5c0tmeExaWnozRlhZSHpZaUhQOWM2aDJiY3lF?=
 =?utf-8?B?Qi8wK1NYNEUxZUIzKytiT1UxNVQxZjNYclgrdHdKYlRJbURjL2ZOdGR2eVJF?=
 =?utf-8?B?MTdVcVllaGZ4QW9oK3k3d3R1ZWVPenF3a3BlOWtGTTc0dXpBdHg3MFVuTHVu?=
 =?utf-8?B?T0VsZTFtL2pHNU5zdFRhem1rTzVZNERob01FWEhDQkRNZWR5MUVvVkoxemRp?=
 =?utf-8?B?ZDkrN0tkWFRPU0doa3UrZ0l3d09MVWdUck11Z1VzN3ZqcU1wZ3FqNkNRTG9L?=
 =?utf-8?B?Z3I5ZzgzYzV3VXE4VVRQbGJrQUhsTXB6MzcvRGVWSGdPeExWdTFqWWFzRi9E?=
 =?utf-8?B?dXdPVHNpUkVnWFZvMU1Va3BvUTlrTThoV0xmeW55OEthek9rVGw4QS9JY2F5?=
 =?utf-8?B?QWpuNG5vSUV6R1NBb3dHRlUvMXdoK1czM0lweXMxUmVQdE5VYjJsRkhzbHN6?=
 =?utf-8?B?ZkRLZ3NuY1BoZkdYN0dxdlNZWStZY1NkaWlHUDRqMkNJR3NOaWdtV3Ixd2dr?=
 =?utf-8?B?c2IvZVU4Y2YyTkJiVXdDSFgyTFBoNzhvZFZqOU1IVHpQL21Ib1lZbmVlRlUv?=
 =?utf-8?B?dGY4RnY4aWkyVlEwQnhNMk5HamJVVzZCMmxHYitPTzZFY3pXYzV1ZTgyZDdZ?=
 =?utf-8?B?OUlqM01wMHN2Vjd5R1F3UUgvT3B4SkhDQ0tpTEhMdStvYWZjWHg0aUQvenB4?=
 =?utf-8?B?RzZFbVA0ZWx1YjFYK0FvTVVDUXJwclpCcVR6SlpqbVIwYXJJRWN3b2VhNU9F?=
 =?utf-8?B?cngwWFhNVWZnT2Mzb1UrRG5yZlJOYWRtVEpaUHlZbXp6Nlh4YitzOE1NcWg5?=
 =?utf-8?B?dTIxOFEwa3ZpUk5lTkNSbFFzSzhudW5BaElhcXk2SFl2Y3FrV1AyWVdNcEl0?=
 =?utf-8?B?aVRTbmVEdlIyRDdmbnpxWW9iTytaSUhOc1NMQmRGRUU0ck5GZmZwVHdJUmtS?=
 =?utf-8?B?MmI1SE1DaGsycWRuMWxSeEZXSzQ4djdPV3ZQb1dBMDdXZWlGeE9aaVRWK2pM?=
 =?utf-8?B?bm5aOVg2OFlpeTBYQ3V6anhFSXhzOXJ0aFJ2Rnd4azJTTWdLZXViZVhZN0hM?=
 =?utf-8?B?RWxzVHg0NGQzVFdqMVlqRDMwbVZlZnovU2k2bUVvdTlTQlQzT3czZjlXSzVJ?=
 =?utf-8?B?MUwxYWFhdW5HeDk5Uk1UOHYyTVF5ZHlpQjlJcmkwOFIxbVg4NVBRS004Ujlk?=
 =?utf-8?B?d1pmZS81SVBVN3JhN0ZCSlhKZDdSeGY1dmdSaS85bm9veWJ0VXpqRmkrMlZP?=
 =?utf-8?B?b0wxK2RhaEFNZk14MExUUVJDYXNTSnZaaUtINFlNK3p5bmhCQzdQQldmK2pY?=
 =?utf-8?B?M2lENlUvUzY2VXFDQlVTeFNnNWZsS1k5OWpEUExFR3J6UXVmMkhzNkFyOU5N?=
 =?utf-8?B?NzRseXJCR3RvNWJoUU1yYm1jaElvUnRHc0EvM0VRdEN5Q1VKdGcxbEFIb0s1?=
 =?utf-8?B?WnBEYWdYRG5XOHBSdU5sbXF3NmJRTTJFdUw2Y3dHT2lCbkVobEx0bzB4ZWZN?=
 =?utf-8?B?aTBrVzJjNi9PaWhKKzhvWWpMWk9icDRMOVNhNW1DckJmektBYVdCZldpbkNI?=
 =?utf-8?B?M0pMbnkrcmF2bHArTUJEeVNvVVRob0hIOHdkZ2hYanJZV0NSWUF4c3FjQnNG?=
 =?utf-8?B?bHBtVkg5T1pzU3BXVTRQZGdCM29PUHAyZE1XTU0xNDZYWDYvZXkvYWRvYVpX?=
 =?utf-8?B?bWdqU01jaGJCMmIrdHNjMEx0UVd5UkxIbUpLcUo4VWg0NWJia3JPUUEvV2Z6?=
 =?utf-8?B?VTRBc0RtT09EYldJMnVyOC9XMzZNTUd1RlNUYlpyaEErY1FrNC9vU251UkVq?=
 =?utf-8?B?dytwSGZBU0JzL0Z0ZzA1TU0rb0I0WGM5MENqQmdnVTlQd2dBUWxhN3lCaWpY?=
 =?utf-8?B?UmFsN0pOS3MvdjhjdzhsNkF3amtUZHNFT0hCVE9ybW1LWlFhMjkxNkgxUVFx?=
 =?utf-8?B?dkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVZ2enAvcS85ZGNjWGlBYzdhNE1EZmx0VVRmQWRBWUtteHdNRzdCbXJQZXpv?=
 =?utf-8?B?V09kRXVZaFBKWDM2RWlZTHRuTVhhbGJIM0p2OXNSd3hDSEYrM0tEdEp0dTgr?=
 =?utf-8?B?Tmsvd3hYNW0vZkJxSlI2OVpJMXVodUVGRkpDRXpLcnhxa3E4QWZVT0lWbSsz?=
 =?utf-8?B?QWRxTlZQcXJ3Ryt2S3FMYU5ZSnZVZm9wTzJSZk5GWEZhSFRFdkpIY1ZiYjhV?=
 =?utf-8?B?TDF0OUdmTTAzcnpVNTV1L0l6Z2NkMmlXNTZMVGEwRE4yYWl6WlFtVUtLSXIw?=
 =?utf-8?B?bThLTEJmdTBPcjNVL3BXdm5FOVF4UUdzNGNVTHM2Qi84OGJFMERyS1ZzQVFl?=
 =?utf-8?B?aGc0c0F4UjJSRUs2UmlJdDZ0MTBCQ2lwN1I3Y05lMytxaWNhNGViRDhKNmNt?=
 =?utf-8?B?anJla3pXT2dOZXJKRWxHTmdsN09Qa3RGbFRxeHQxZGxHRldDU3VWYTRsZ1Rp?=
 =?utf-8?B?b1lHelc1MlZ6NXhMMWQyRmFDajhVckhhdGM0RlFBSzZ2L3N6bFdIaUVQRjVl?=
 =?utf-8?B?aWthczRJRzRZeldqNGdzTWtkZFhDNGlGTFZtYk56N0YydkU2QzZDVFhvaFE1?=
 =?utf-8?B?eFVBTUZTekZFYWRKeWdxZXVrSWswZmdyU2VpSXBQWFo0ajZYV0tEQ2FTbTAz?=
 =?utf-8?B?a2I4US96bU1HUVBuTE9MRzZxVGM3Q3ZEQnY1NXRXVDlHbFAxSE5ITWthN3kx?=
 =?utf-8?B?dXZuMXdIOEEydGVPWXRNN0hVeFg1M1lVeUphblJlQnN3OUdYZHRjaDB0bmJt?=
 =?utf-8?B?Ulo0aEFBdFhuLzFabUpkTEpWSG9nTW9tSk9MVW42YnpGK0dZODliYThDTmRi?=
 =?utf-8?B?d1JlSDBJbm5PVlI3dmRkUUZzcXRnQzVrN2tHRThpQ1dWdVZna3pIM2NoZy80?=
 =?utf-8?B?UzBOYWt6bXBxWmJOeTFubjNyVGJ6blh6aVlzTExnRXNOSWxMZE5IUVZCSEw0?=
 =?utf-8?B?QTFHS2hEQ0tYQjk2L2tIcEMvV3dYRWtZY1FtMWxGTUxNTXlTUDh2QzUzRHRD?=
 =?utf-8?B?ZExqVFRrRndkS25admFINkcxL1FSL2p3T0trWlpRb2plaVYvdHFDQzFSQk8w?=
 =?utf-8?B?R2hUVEdjK0kxSXR4Q1c1UUtlSDlNdUc3bEZMQXJ5aWlhS1JTZDllM0hWKzA2?=
 =?utf-8?B?UXBmOHJnR2w2ckN2M3ZzdDZjUEs1MnZHTFdzakJ2Vk84NVVKMHpCWVJReWsx?=
 =?utf-8?B?a0N3NzV2dGpoSTNFcndTeDFjUTN5Z2RCei8rMXVGTzFETTlxNkRqV1FTMG9G?=
 =?utf-8?B?UTU2UUM1bXpPZGErV0tBNDRybmlIeEJSMzJkeDExWU5aWFkyQTlXRCtOOWZE?=
 =?utf-8?B?VUF3bVdwUDZBUnVqVU5jSEcwL1dqQTJtc093UVVPcTAzTkFTdmRzRDgrVURp?=
 =?utf-8?B?ZmVzRjZZci9aQnBkRGNKUkQ5a3lyZ3BtRVNWWFJKRGN0QnpnQWg2emc5VEpt?=
 =?utf-8?B?VnlTYU84QWdEUTZRV2Q4ODRKWG9abis2NWdZTytUOWlVR3FQTENJb0tjSlIz?=
 =?utf-8?B?ekhUMnJYenUycjdvOWkrbDhNcW96cjdjcm5mUGI0MmdNMTUwbjVKMHAwZ0c2?=
 =?utf-8?B?N28yRDBoTlRKSmxtNDMwYWkzdVlPbTVrNkVCdjh1NlNpYXNYbDZWUXpwejZo?=
 =?utf-8?B?RjdJSFdKSDFSM3RpVTF5UUdnN0FHTW1nNS9OQUloRTRwSlU2UnVVMkRtdU93?=
 =?utf-8?B?bGIweUdqNFZjVENod1JjdVVCZFZSdlgrL1FpTHlZSmJPVzVsVmFiOTN5SlUy?=
 =?utf-8?B?VzhCcGR1RldXbTRCVXpCRktPeGpNOHRFcFZjVE85eWFWbWdldGxZbk5VMFBI?=
 =?utf-8?B?UzZBQ2FGRWVhZGhKdE00QWZDemlJdUdiRVpjOGdUdW1pUWNzN1dZZUo2aWdp?=
 =?utf-8?B?a3QwRldKdUNRQ2NnakFiV3NUY0EyaGxIaEN6QUpXVTFZZHFjQUJqS2ZFOFJo?=
 =?utf-8?B?WG8vak80cG9TUWJBdzA1dTNDY3B2c0JETVdMZXpramZYY0swYkMwaFZXRDB3?=
 =?utf-8?B?VGJhRnhTTFFsVDBCZ09wM3VodXpxbVZ6eDA0OWlLd28xS0h0N3JMcFdYTmxa?=
 =?utf-8?B?bTB3M0tQWHJPWGRaNDZNbzAwRUVuNWtSTnFVeFVxWXlqaFo4SllqSUdmT3Vi?=
 =?utf-8?B?V1RLZmhQcUJiQnloNnBNQUZ5UkJteTE2c1ZCTS9SSzhpbWVGZ0t4Z2cvMDVj?=
 =?utf-8?B?TFhOT2dvR0J6TDRMSmdUVTh0OTNnbG9qNlY2L0h0U3ZldmZQOWVSangxWTJH?=
 =?utf-8?B?UHFTMTR4WmxuUkxleGpIKzFBUDF1WEtZamJ1cXpXTmNwTHJ0cEVCZzVhT1lQ?=
 =?utf-8?B?NVJJUjZaQTBITjFPNVJYSXQxRXQxRHIySVJRYVJLSWFGNHJnclZKdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a06b4428-1760-4bb4-af51-08de6ea7be5e
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 04:39:46.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cfPdgc6OSZhQbLTkoA0J51OH/KHR9MbpZFEVJMFhN1/Peb/DxAITYdi8148oU9EZ60+VIuiL97jxuQfS2d5vGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9723
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71209-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: ABDB11530C4
X-Rspamd-Action: no action



On 2/17/2026 9:34 PM, Kalra, Ashish wrote:
> Hello Dave, 
> 
> On 2/17/2026 4:19 PM, Dave Hansen wrote:
>> On 2/17/26 12:11, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> Use configfs as an interface to re-enable RMP optimizations at runtime
>>>
>>> When SNP guests are launched, RMPUPDATE disables the corresponding
>>> RMPOPT optimizations. Therefore, an interface is required to manually
>>> re-enable RMP optimizations, as no mechanism currently exists to do so
>>> during SNP guest cleanup.
>>
>> Is this like a proof-of-concept to poke the hardware and show it works?
>> Or, is this intended to be the way that folks actually interact with
>> SEV-SNP optimization in real production scenarios?
>>
>> Shouldn't freeing SEV-SNP memory back to the system do this
>> automatically? Worst case, keep a 1-bit-per-GB bitmap of memory that's
>> been freed and schedule_work() to run in 1 or 10 or 100 seconds. That
>> should batch things up nicely enough. No?

And there is a cost associated with re-enabling the optimizations for all 
system RAM (even though it runs as a background kernel thread executing RMPOPT
on different 1GB regions in parallel and with inline cond_resched()'s), 
we don't want to run this periodically. 

In case of running SNP guests, this scheduled/periodic run will conflict with
RMPUPDATE(s) being executed for assigning the guest pages and marking them as private.
Even though the hardware takes care of handling such race conditions where 
one CPU is doing RMPOPT on it while another is changing one of the pages in that
region to be assigned via RMPUPDATE.  In this case, the hardware ensures that after
the RMPUPDATE completes, the CPU that did RMPOPT will see the region as un-optimized.

Once 1GB hugetlb support (for guest_memfd) has been merged, however it will be
straightforward to plumb it into the 1GB hugetlb cleanup path.

Thanks,
Ashish

> 
> Actually, the RMPOPT implementation is going to be a multi-phased development.
> 
> In the first phase (which is this patch-series) we enable RMPOPT globally, and let RMPUPDATE(s)
> slowly switch it off over time as SNP guest spin up, and then in phase#2 once 1GB hugetlb is in place,
> we enable re-issuing of RMPOPT during 1GB page cleanup.
> 
> So automatic re-issuing of RMPOPT will be done when SNP guests are shutdown and as part of 
> SNP guest cleanup once 1GB hugetlb support (for guest_memfd) has been merged. 
> 
> As currently, i.e, as part of this patch series, there is no mechanism to re-issue RMPOPT
> automatically as part of SNP guest cleanup, therefore this support exists to doing it
> manually at runtime via configfs.
> 
> I will describe this multi-phased RMPOPT implementation plan in the cover letter for 
> next revision of this patch series.
> 
> 
>>
>> I can't fathom that users don't want this to be done automatically for them.
>>
>> Is the optimization scan really expensive or something? 1GB of memory
>> should have a small number of megabytes of metadata to scan.

