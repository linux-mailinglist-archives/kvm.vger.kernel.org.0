Return-Path: <kvm+bounces-55257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 972F4B2ED96
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 07:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 107143BB3A7
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 05:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F37D2C08AD;
	Thu, 21 Aug 2025 05:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S1jeA721"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060A8288C0E;
	Thu, 21 Aug 2025 05:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755754061; cv=fail; b=k2eSqUjZOVyUk9eAFOakRYBKqZi7qzSpeUg5TZoT8/St1V2L81usT7uoyswXz0CmnPAw5HvCs7YWI+gruACySamxXS9y1xBr/mx9dHZrU7KpcB7PJZbVZhjoiTBLNrETFUMgKa7udSfdIlpf3TjZfnTeNMVLYWNs+STaw1eyuc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755754061; c=relaxed/simple;
	bh=QEA87s9dqv5J+6RYYdJGCFFX5rpYvzf8KVvTfrg4Lx8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QJT7Z1p59KvtM1XvveTLOafcCDC5jaexADeVnfF3aR4UD0KCk0UQjMX2w4O126AwedyaqRX6Rt+S2IRSNdbcnXtFGdDDPOFyjh29I2up6ybjlkzbPbAX1yJV5j4QAuIjDyMUMBsg9thUnNP0OHrN81nVWDfxBTgsBaHcAHEjPyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S1jeA721; arc=fail smtp.client-ip=40.107.92.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sx0y2tzDVwrTrTykoM/7JqHk8OjU60H1KGtvBuXMGyOqmQjkVgbaRda2oe3q/pVSAh5j+OpxjZG8kH4WcJQUPrZAGQu7yfzT5Vk6o/PPJjjUvE1NM6gJs0e7vN31BksJMF5GZJFL225pyz+0y4ldrQVktv/ovmcI94UMXGNvODoV/E0Wl9cSAM5B9NBuSxbo1Z0/07iGeL9OmmKpYwyuaX82Jkoow69Ta3lU9dqj8pfQweP8RxVHdRJPicG7qxdyOpJh2aFxN46yySRnz2zrXdQIgAooGOruicYLV5DkDbvDdCr7IoFBIDYYkAepqv6gFiebJGRzk9rwj/DbgMrGJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roZ6h4coD3UPKwBlKkeRHBvoS6P9RqzmR4co8dWTsDA=;
 b=YnzuXM9k31OGVJBzfRh//geidMzgVvnu/yoqP5gpUWSN0jrbsF2r5EmaU1SvuyzUkJQHUIEdXO2AnK3XaAs3cr1ZxbCq/Nj1C2Io7k/F031md/yjqwuznS/Q2ToTe8h6VDZonrmQq8zxV+fo8yu31WcAw1cVzJGVvcuACwyk5N93CqDMhE+8TW8v/Rrb5RYr7sc/rusBs8SW6nHUIrtvij7s1J4v5BWf6D5IkeI4BE8/uovS9sc7Axfp4wJ5dydJ63gYpHKg03uq7YR0sbfGBGZ1Cqe7FhLLaPRfAO5eWxwakwO51J9tx5WmHUqvRDhbBdQN35SL3uhwb9iY67o0PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roZ6h4coD3UPKwBlKkeRHBvoS6P9RqzmR4co8dWTsDA=;
 b=S1jeA721nbiPzO2e4s1h195JXtY5hlLf9nCxeizGnzXV8qEWzdA78mtygRTbrMOAcqN4EImyfEh3UZ+kaAMynmhw/Dq6euODVx7B8cLtf3p3PbQeWTx2SlZYtW0x9e+D5lJ0HiVqeRjPGA2l82DnPXMIWZrwNBrJIO9G+Uh6ioM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CY3PR12MB9680.namprd12.prod.outlook.com (2603:10b6:930:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 05:27:35 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 05:27:35 +0000
Message-ID: <29dd4494-01a8-45bf-9f88-1d99d6ff6ac0@amd.com>
Date: Thu, 21 Aug 2025 10:57:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/18] x86/apic: Add support to send IPI for Secure
 AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-8-Neeraj.Upadhyay@amd.com>
 <20250820154638.GOaKXt3vTcSd2320tm@fat_crate.local>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <20250820154638.GOaKXt3vTcSd2320tm@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::7) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CY3PR12MB9680:EE_
X-MS-Office365-Filtering-Correlation-Id: d10ce46d-39a7-4106-8688-08dde0736f1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTRFOVZXTUxGZ1dOQkk1S0RFWnJsZmM0VGRoaWMweWNkVDEzNERScm02cGRU?=
 =?utf-8?B?T2R1N3htaWFLNXhqQmQwVnB0aDBhUy81NXgrNmNUR3pLU0ppSkIwZHhxOWRW?=
 =?utf-8?B?YUlVK1V1dFgybkd4UzZJajRjWTNXandxdXVWbnFLTERXNkJpM1lZQTZlUUFo?=
 =?utf-8?B?S0VNMlNOUk1SWlpNMWVITG16ZHh6NTU3SFRGa3g5NHM2NGUweFJUVlQxbXQ3?=
 =?utf-8?B?ZVNVSE0rQXYwSDVlS3FjZDJ1MW1GbHh4QTJiUUQ2eDlGaXlZMVBNb294Z2hU?=
 =?utf-8?B?UTJBc1hxcFNjSVNBOWwrQXJkdkVtZ0ZyMitHWGtqeVNxVkZXQU9OZFA4YWJh?=
 =?utf-8?B?UzNQbWt3MEhkVy9Kd2MxQlorZGUwb0MyOXhFUlN5UWJPZEd1aUxPY09iOC9I?=
 =?utf-8?B?RTR4b0JJSjZSY2tYVnhlZU5EQ3BvUEtXUC9URUI2TTF6ZEcwQkFacTZBN1FY?=
 =?utf-8?B?cUdreVh6blFOTGJ0Yk9rdEYzMzhMREcvRmNZaHJXUy8ydm5zd01CaEh4TTBI?=
 =?utf-8?B?NWgxaitrTlNURmRKcUdYWjFHOVBpSy9YanByaUtXUUxaTW4wTnViV1I3blpq?=
 =?utf-8?B?WUVQYkgvNWdIY2Uzc1NrOS9HdkljYVUzZEpGdktGd0ozVjFRQ2plbSthTVly?=
 =?utf-8?B?RG9lTG9aa29UWU5WU1hpTnBtMFhzV2hNS1pLdnpLL29QUHNTRmUzTVYvSmRo?=
 =?utf-8?B?Um9QbXpGcS9CRkdmcENqYktad2R2TFRNZkFodFJaMUNwOVg0cjUrWFBOb0tp?=
 =?utf-8?B?clpGdDFTY1VILzdnN0FHSnFTem9TSnFvT0ttVzJnRUlBSVMwTzJjUnBhK1Rw?=
 =?utf-8?B?Y0hmUDg4anhGMnFjOXpNZGpXT3JvL0dWWEYzNzh3blZaMy9xbnc1bEZHdGpt?=
 =?utf-8?B?bXVDTERNdSszV0RiL3FvaE9uWkdHMVVidnJTUVJOSUEvMU9QNDFzZnJTdndU?=
 =?utf-8?B?UkdsOVdOcjJoTFR3R05jT0xPQnVFeDhLUEpPYytUUW9kQ1Z4cUR5ZHoxc2tk?=
 =?utf-8?B?ejlMQ1FMQm1Qb1k0c0gvOGp6VkdqWUR4M0NVbjZpNDZ5cHM4b2NVcG1aWnhl?=
 =?utf-8?B?dmVOSnJqbEFMWkxYZTBHck9jRis5QkFZdjVEcXhQSS9XcWRPdlJlZVNlSzlM?=
 =?utf-8?B?aGtnUmhGdDN3V21oU3MrOFFzdTU3c3RMNUhoYThIbWVLMFlHSlBOYVE5TVdS?=
 =?utf-8?B?NVMyMmIrK05PVlB1a0pUQ2ZSL29WOGhlV1NkWEFyQlhJdGI5dk5nS0VIckJp?=
 =?utf-8?B?cnhGY2xnMHgvdm1ud2JWejdmVDNKa3YxWkhJb2s3dnNMT0MzWHZHNTU1SnYy?=
 =?utf-8?B?V043R3FFUEhKd2I2N25MeUZCUWxJSi9RdnlCakdRcVR6d3lFSGVCQkpGYVQx?=
 =?utf-8?B?KzJYQ0ROZm12ellCdEdScWVZRHVKdFRyL2Y0Wnd6dFpvOTdVUWNnamw3LzVF?=
 =?utf-8?B?NXpYdk4vYlhhZndkeThIWlRTeFJTV3dtSjUzS3MyUExteEQvL2s3d3hlVmNU?=
 =?utf-8?B?aHRRY0J4NXBHOGJTdS9IT1pyMlFDa3Z6NEZIaTY0WExnUG1BVDlQZFpuYlVC?=
 =?utf-8?B?bnhFbktyMVJsc0svZkZzVTRRRnNOajVNQVZvbHFERzZzVExMUkp5Q1l5QUVX?=
 =?utf-8?B?RlU3aTZySGJ3VG9jMk5oVzhPdGlsNUhEUklCM29uc3J0NTVPNUdPV0tlcitY?=
 =?utf-8?B?ZmZBRmc3V1JDbjY1WFZxL0JvaFUzZE1uOUlER05JT1NBdFdRYXoyYWQ4UzJJ?=
 =?utf-8?B?SEVxdUVYd1NHNEorWGRLbnFnTnN1ZWxmTDByMmdGNGdGMzNvOXdsU0YvNHlU?=
 =?utf-8?B?WlBKYTJKT1JudkJYSUY2cWJpQnpyYmVDMlYvUldINERtVUt3dGIyZlNBOWR3?=
 =?utf-8?B?amQ3QmhSV1FsWmtNaHdlMDNVOGdQZHJVL1M0YTdFYVpmNE94djZLNWNIUmgr?=
 =?utf-8?Q?qh2cRNq7NTQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3FJQVlKcnY0bXhxdzNRemt4ZTQ5eXZqMlViaUV1ZnY1R2VXTXM5bWFHemcr?=
 =?utf-8?B?dFVXZER5TzVFWEdCd21DVXI3eG5aNDIwWXVUc0R6emJaVFJ1akVMT3BLUFJa?=
 =?utf-8?B?RlJmK3k5RDVJRU5DRFNtYlpmMmlZWEZuaXFzRXBOTkkrVHkxbmJVYlE0dmtL?=
 =?utf-8?B?V3NXajJZakxoeTR4WG4xUUlPejh2MEFKcUU2SWpqVCtmSXNENXhXQVpCYUEz?=
 =?utf-8?B?eWszNWN4TUd3OXFqTitHUDZkVDVpR0tCMzhzK3czQU9VY1Vidkw0RHk5Y3Jl?=
 =?utf-8?B?UUVsWm5GVUcyY21NWm5GRmxmZm4vYVI5OWZqWnJ3dUdQNDIxT0hURC9sQUFi?=
 =?utf-8?B?ZFB5SGVRYnZCNmU1SUduZ0ZaV1o3N28rV3RHdk9ocHJmNEFxRUNJaDlMNGY3?=
 =?utf-8?B?UnVKK0VCdklZaUxqcWRqd0xjUnZhdTVTYTBIR1dFSFJIWloxWFlNRXhvcGlK?=
 =?utf-8?B?eTN1dzN3eXB5REllV20ydzRBZ0RtTFNmRFp2ODBwTlhMRk1SOUxFa0l0QjhH?=
 =?utf-8?B?dEtZdzc2bjJDdm9pbjFXOTVXT3BwcjZCWXg4cjAwUFZqRURjZlhxVndQZnNr?=
 =?utf-8?B?K3grQm1xR2JXcUkxNzBGMldvK2NLcnZjMXgyVWd1U0RGbmhsTFowaW9qVTda?=
 =?utf-8?B?VDJLL01rTC9kamlRWnJjUHpUWS84akppVk9ITHllQ2VXVlhzdTNEQ211NC9I?=
 =?utf-8?B?R01NMW1kN0REaVQ1c2tPMzNGN1NJT28wWEgzcWd3OWRWZ2xxdzlNWHo1aWJm?=
 =?utf-8?B?bHNPNjdDUFYwUE9DNEZqYTJEK3dHcVZONjRDMXoxY3luWU9Gd0RCQWZCQXBI?=
 =?utf-8?B?WitVQ2ZVOTJyVE4rTS9NaE5samJoc1JwSEZsM1ViOUY2MHBlWWFZYm1CNDFi?=
 =?utf-8?B?b0JzVHF5ZVdRbUVZNlc4QjQxRHNFOHVEOVpaZk5BdFl3WENreGE4YjVlSGV0?=
 =?utf-8?B?Q3k3NXFSVnFPTnBYTU5Cc1RidzZiZSt2bmluVWRocjRkMy9UUU9vYm9ZSTJB?=
 =?utf-8?B?Uk5yKzl6Tms4Z1JDa1FKTXdtNFAzK0xSMXFyelVoL1pwWWNHNjN4RXc5RTh3?=
 =?utf-8?B?REVHWFNyaitaTVZXRndtc0Ntc0Fka0ZxK0dZWWQ4cDFZODBJcEVxWjlob1gr?=
 =?utf-8?B?dzFjMFhCOXBERkkybjAwTVpvUklPQ3FzMjRDZFB2Ky9UUU1IRkNMWGdwM1d4?=
 =?utf-8?B?TXBCQk1la25uOXFLYjZNT0ZvRHh3YjZMUVdOWDdKVGNUb1NRN3JTeDJpbmFt?=
 =?utf-8?B?eG1qY3R4cGQrbktQRXl0VkxTdkxBVHNmR0crNmgzWWVlcm0wSjltT040OGwz?=
 =?utf-8?B?eUdBeUFyNHFsU09HZnhrRTFPVHVncHlmMUVxamQ0R0M4WFRwN3p5RXVhMm5J?=
 =?utf-8?B?cWNmSmFKLzBZbUZpeU9HMUx5c2JyVVRYaDNLbjkrYlhaaWYxNlhCT1plRGUz?=
 =?utf-8?B?QWNqTkgvN3NtejQ1UGswQ3pubkJncDY0OE5IbEVRYU43TG50bzNmY3lZeFFE?=
 =?utf-8?B?KytFc1k3bG9hUi9kcHBtWHgwZ005ZGhxQ0E2Ly9ZVnQvNzgweEhBNWVhWlJ4?=
 =?utf-8?B?ZWtOd25DQUN5SG9NeUpmNTFFM1llT1RhK3JnZWVSY1N5aEZ5L0cxbmVkL252?=
 =?utf-8?B?TlFWaHJxenFpS1RsTTVOVEpRRG5NWVZxTjNNa3pnVThZejFGM0YyQ3lDUmZy?=
 =?utf-8?B?WVR1T0ZOa2o3WnBIT3VKYzVuUk8vUDlVU3BiMHhtdmNNMFdMQnlJdFZpOCt6?=
 =?utf-8?B?S2p5aWRtaVNYTzl4YTFCM0tkMi9JTFd4a082UzNVL28zb2xUcXJwc1VheGgr?=
 =?utf-8?B?NlAwdXVSOUJrdjh1OEhhdDRycGR5SFVsV2ZPc0haMytwcGxrNHV3NXlCWWFq?=
 =?utf-8?B?RXBCSTUwSzhqR2lYWUFWc3BnZThoUmZCV1BVRlQzUFdnU3IrcFlHR3RNdGFz?=
 =?utf-8?B?R2U4VXFwUnI4R2VCMW1aaTM2eU9pTXZxMlZtdjJEQnpiMlRRbU5mam1HckJU?=
 =?utf-8?B?TXVNdkRTVHFoeGt1VHRRSmQ3b3YzSUtpZy83MTJOSldKN09GR1cvdEsrRkp3?=
 =?utf-8?B?R0pvNUNlcVRXSXU2SVBFY3J2b2tISlNNcFNvU1VzK3lVaUw1Wk9UM050clA3?=
 =?utf-8?Q?YTOEajoYBnfK6JO8smzvxAfSg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10ce46d-39a7-4106-8688-08dde0736f1d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 05:27:35.1553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTsFZuV8hi8NVkoevpz5/lYH1Pv1mma1ACb5oteCBQrV4rlgg+yv8sjWyn4c/ufnFdTmYIBTfurhQZUJ9LdPQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9680



On 8/20/2025 9:16 PM, Borislav Petkov wrote:
> On Mon, Aug 11, 2025 at 03:14:33PM +0530, Neeraj Upadhyay wrote:
>> With Secure AVIC only Self-IPI is accelerated. To handle all the
>> other IPIs, add new callbacks for sending IPI. These callbacks write
>> to the IRR of the target guest vCPU's APIC backing page and issue
>> GHCB protocol MSR write event for the hypervisor to notify the
>> target vCPU about the new interrupt request.
>>
>> For Secure AVIC GHCB APIC MSR writes, reuse GHCB msr handling code in
> 	     ^^^^^^^^^^^^^^^^^^
> 
> say what now?!
> 

Is below better?

x86/apic: Add support to send IPI for Secure AVIC

Secure AVIC hardware only accelerates Self-IPI, i.e. on WRMSR to
APIC_SELF_IPI and APIC_ICR (with destination shorthand equal to Self)
registers, hardware takes care of updating the APIC_IRR in the APIC
backing page of the vCPU. For other IPI types (cross-vCPU, broadcast 
IPIs), software needs to take care of updating the APIC_IRR state of the 
target CPUs and to ensure that the target vCPUs notice the new pending 
interrupt.

Add new callbacks in the Secure AVIC driver for sending IPI requests. 
These callbacks update the IRR in the target guest vCPU's APIC backing 
page. To ensure that the remote vCPU notices the new pending interrupt, 
reuse the GHCB MSR handling code in vc_handle_msr() to issue APIC_ICR 
MSR-write GHCB protocol event to the hypervisor. For Secure AVIC guests, 
on APIC_ICR write MSR exits, the hypervisor notifies the target vCPU by 
either sending an AVIC doorbell (if target vCPU is running) or by waking 
up the non-running target vCPU.

>> +void savic_ghcb_msr_write(u32 reg, u64 value)
> 
> I guess this belongs into x2apic_savic.c.
> 

Ok moving it to x2apic_savic.c requires below 4 sev-internal 
declarations to be moved to arch/x86/include/asm/sev.h

struct ghcb_state;
struct ghcb *__sev_get_ghcb(struct ghcb_state *state);
void __sev_put_ghcb(struct ghcb_state *state);
enum es_result sev_es_ghcb_handle_msr(...);

>> +{
>> +	u64 msr = APIC_BASE_MSR + (reg >> 4);
>> +	struct pt_regs regs = {
>> +		.cx = msr,
>> +		.ax = lower_32_bits(value),
>> +		.dx = upper_32_bits(value)
>> +	};
>> +	struct es_em_ctxt ctxt = { .regs = &regs };
>> +	struct ghcb_state state;
>> +	enum es_result res;
>> +	struct ghcb *ghcb;
>> +
>> +	guard(irqsave)();
>> +
>> +	ghcb = __sev_get_ghcb(&state);
>> +	vc_ghcb_invalidate(ghcb);
>> +
>> +	res = sev_es_ghcb_handle_msr(ghcb, &ctxt, true);
>> +	if (res != ES_OK) {
>> +		pr_err("Secure AVIC msr (0x%llx) write returned error (%d)\n", msr, res);
>> +		/* MSR writes should never fail. Any failure is fatal error for SNP guest */
>> +		snp_abort();
>> +	}
>> +
>> +	__sev_put_ghcb(&state);
>> +}
> 
> ...
> 
>> +static inline void self_ipi_reg_write(unsigned int vector)
>> +{
>> +	/*
>> +	 * Secure AVIC hardware accelerates guest's MSR write to SELF_IPI
>> +	 * register. It updates the IRR in the APIC backing page, evaluates
>> +	 * the new IRR for interrupt injection and continues with guest
>> +	 * code execution.
>> +	 */
> 
> Why is that comment here? It is above a WRMSR write. What acceleration is it
> talking about?
> 

This comment explains why WRMSR is sufficient for sending SELF_IPI. On
WRMSR by vCPU, Secure AVIC hardware takes care of updating APIC_IRR in
backing page. Hardware also ensures that new APIC_IRR state is evaluated
for new pending interrupts. So, WRMSR is hardware-accelerated.

For non-self-IPI case, software need to do APIC_IRR update and sending 
of wakeup-request/doorbell to the target vCPU.


- Neeraj

>> +	native_apic_msr_write(APIC_SELF_IPI, vector);
>> +}
> 

