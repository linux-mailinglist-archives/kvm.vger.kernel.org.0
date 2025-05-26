Return-Path: <kvm+bounces-47673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D81AC3825
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 05:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7782C1710ED
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 03:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8202A192D87;
	Mon, 26 May 2025 03:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UJjuNeyU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534F72DCBF0;
	Mon, 26 May 2025 03:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748228484; cv=fail; b=Cm1yGOkVQOMAqzjRmID+aJ8cXgf+HYs9pk+QBml0UFkLpflJjtyAsRXpIRfSMpw0D4s2qO5nIM6YwonrIbIkIQlQgEQ5BpG99X+CknSLoq7/mZykfp4pM+DjLzZWJDyZKFD2vIs1QA465EqnfVqSRODcy2JaaCioWuZLzXK+u6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748228484; c=relaxed/simple;
	bh=GhHmMb7sfgKGbzDcVkq5bp26/zb+vf8eveGSzloPHUk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FWONO1uwb6FpOjcxSgFQ5MovUCtQeihClaM3JTX+dHSMg/2KyHA4l9eTL/+tB3RLsuOvVEypC9IWeKAukSy3mrRF4e6S2xfreQktmVsQeU7mGbbNzGSR+RpO4cZzUC8UYyxG/3ZHnXzsAgBat0W73bEzAOjt7G5ZJIQrNgTgV5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UJjuNeyU; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4kTywUnvwcA6KLBAftxNlB/Pd0dS/XzK1KUtoZUJUvQJ9pFoJrsgOMiTn4M85ig2jEGnwklCmv9D1qJvhKU6G7hqSffCPFyYD5MljefD8ealqfXAM/Wkzm75xrIALX15n7lxGbO92qxqtjvepQjgzkRTdZZX8KxCCcUTDRtBKFk9TEXlRLBOJ3ktPfULcg0HMyF2XZ4Am4aC72RyopdlqheNfXdLBBniBsnQ1T6oNYacDWftB329bZ1EapP07ktJ8MqtXlYhwlO3R3M9nPQTumFIBYPeQFLkvMFPIFU8nSAXoY/PlGRhTtInskqXAvenfPu/zt9FF1MSB6JJMDxFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjYpQCAItg6MQzaEvkEJavgv9Cvq+KYIjeMCoomaP4c=;
 b=oGaLjLHRzrSFMXOp12pe+V/1lN3O3Uo5iZN9/KwUIJubzfdRIAU3yJfus5ysqxC3zJ+VD8k6mY7wR6uEcB84KZwqZknZl2RBm+GjZa09vMcFLBDHD4ELjDugAF7qQoO1TeNHE0DB4KuKIRs7Z4znBZs8aBNaexpK5Hl0pmONg/iIIljA1SWfxLvOtlKo/1yRpzAH4I16qiu+/GFej6oerctScsx9t533s0B8vs8Fv6ohuPJRDWqwQaWWzBj/Yq15S8KOSyEjoi8MhsLPPdjNmULYPTC6BOrofPwTcsEKNWCTeiFIXNJBFL1q5Z3EbRpsCTLYTKeBXAetlOMypzGIfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjYpQCAItg6MQzaEvkEJavgv9Cvq+KYIjeMCoomaP4c=;
 b=UJjuNeyUjOKPk3MUVQdIVinSSBwH2GTq2QxrupWbgzl6TloiX3269UkOluqegGCt/UnZgqgS4YCJhDU3MpUNARu+jL1tCNIqKuBztcKcRE/7MdsKIule6C9SI/3prBvTU9Dhle1MIWqG6/36jPaEF1WIX+Z+gophZeDwEl+RGiA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 IA0PR12MB9048.namprd12.prod.outlook.com (2603:10b6:208:408::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Mon, 26 May
 2025 03:01:20 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%6]) with mapi id 15.20.8769.025; Mon, 26 May 2025
 03:01:20 +0000
Message-ID: <42a855a3-eb61-4322-92e3-264d3fae7c5d@amd.com>
Date: Mon, 26 May 2025 08:31:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 08/32] x86/apic: Remove redundant parentheses
 around 'bitmap'
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-9-Neeraj.Upadhyay@amd.com>
 <20250524121423.GLaDG4H7R2-QVygIXa@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250524121423.GLaDG4H7R2-QVygIXa@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0012.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:272::15) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|IA0PR12MB9048:EE_
X-MS-Office365-Filtering-Correlation-Id: 47d19755-48cb-4f81-2dc0-08dd9c019717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z09lK1U4ZmNtUWcvZFloUUdvZjkzajI2eitmRURabW9ZNk9XME04N3o4YUI1?=
 =?utf-8?B?Ui9XbS9KeE10blJISnVqcVdXYm52UTdXYVJWb0V1cnpuZ3lsQ05McDVjNXhS?=
 =?utf-8?B?Yjlocno0VFN4WWl2WE9ZcWMzenJZNWVQWEJicGdDcU5hMmlDUW1Yd3BrME5F?=
 =?utf-8?B?ZXFLcDJTMEhGa3dESmg2YmlLUkwrb05TQ0k1K3lMazh5WUZmQXNJRTEzNlNv?=
 =?utf-8?B?SFowZjFncDN4aFNIbmRkVnlzTmVmVkpOUlRWbG1TQmpONWNkejZyU2RDWHZI?=
 =?utf-8?B?eG9TRmtjTzdPYlFZQjhaamlrVVBnVGh1ci9rVy9zUE56OEwyb3dseGVUV09a?=
 =?utf-8?B?Y3RVRTl5dllpcC9wNEI4a29YRWJMMUF5Ri93VmxKTlJ6dXQyc2VZOEFpSEJo?=
 =?utf-8?B?RW9YQTF6bjl2SE1YUFJQL2xWVTIyQTBHaUg4WExEV3dqWFNVbWhEcUh1cTNF?=
 =?utf-8?B?OCtuVGxRTE45YmxNU2R0d2h2ODVTSGZuYUdnSCtqN3VCT0plcGVoU1dBaU9B?=
 =?utf-8?B?VlNvNVRURlFsRTVmQkp0ZFY5aDlXRGFoU2YvUG94NUI5QjFJNFVtRmJTWjMv?=
 =?utf-8?B?RTJZTlBOTkJpdFJvVC9Yc3V0VHBYdEM4OEtISzN0bThEOU56WVhvb0NSQmtq?=
 =?utf-8?B?bk9ONGo2cDlsZFk2RUNCbVYwdzVxb0JicWUyNVkvZUZCWEFrcFRUVzNrNEph?=
 =?utf-8?B?aVNpVGxuWVVZUXRUOUdaWU4vUXlRM0tOWXFwLzQyb2FTc2pFNDV5dE9VckZB?=
 =?utf-8?B?Z09OWUszMzRaZ2prTVAvZWxhRmJFdmJzNUJINGxiZm1VcHIyNGREYjdtQWZl?=
 =?utf-8?B?cm9RcjM0NXVwTXN6c05DWEZFVVdiMHZ6ckV3UndJeXFXQlpkejIzd0RLWlZv?=
 =?utf-8?B?c1NEWDNkWjlCU2hPUCtQR2RtQXJOZ0l1dTlaSkxnakYrUHNGQ0JLK1RPZjhI?=
 =?utf-8?B?ZGIwWlpVTnhNcVpmeElaNXdub0wrd3I0UGRYS0gzOXJFZ0M4UnRpYTZVcW5K?=
 =?utf-8?B?ZVdDbXlTWGhqTmhFL0g1cXdqY3k5YktTNDBvajFiVEh1bHpvUU9FOWxUREZy?=
 =?utf-8?B?amhRTE1KV2hXYlpiVUFjNkJxcVR4dHRUWmNWWVFFc2pRUCtJN1hpVzk0d0JU?=
 =?utf-8?B?VkF0RWkyM2psWkxQL2RDRWRkaUY2NWNTTjVkcXZSYTludkxIRC9rTlZLLzFC?=
 =?utf-8?B?NklZNnhKM1dnVUVneUFZMmh4RVhRbWNoallMWEhaOStZa2ZZMnRlWnlGWk5h?=
 =?utf-8?B?WFR6OCtsR2c0M09oU01DdmZFMUNmQ0xQMU9lbHRjM0RwOHRhSTR4R0JJd25R?=
 =?utf-8?B?N2ljS3B0eEc3UEdxMldzRWJHUWlmNmdPSHpJS2ViSCs0ZmhTeDlWZXBZdVJ4?=
 =?utf-8?B?U09kRmRudERWZEVHRU14TldHL1UvRHgzTW1MRW5VL2d5NjNDaW1YU3NUMWp4?=
 =?utf-8?B?VVE4UUIwd2J5RExKVXlBdWJtVzdHQWxGUFVhUUl5Q2pDSXNXWnJDSHZTamdk?=
 =?utf-8?B?VHZIMU94NlA2cVovZUlFS3ZJL0YzL1BSeGg3TUVUSXBlUEhDbUw4a2tBTXV3?=
 =?utf-8?B?TExKMUdGaDk1bzdGUXM2a3lQWVFpWDhjMHlsWkZibUx3RVNucWRCdWFLMStR?=
 =?utf-8?B?dHczQnNZTkIrbS81U2RmZ2lZTHZiUDBxUnZ5NUZhOENFdTlVRVZHOFZYT0ti?=
 =?utf-8?B?NWxSZlpRSXJya25uKzNHNjErbGpNaEpsVTE0SjZhaVB1bUlSQldzV1BOSFFK?=
 =?utf-8?B?T0hiRHhrc3M5Vk1ydW5FM1VzQlpaQ2s3T3RqMTFQQTBhWVh0TklsbVY3ajB6?=
 =?utf-8?B?aDNvdXUxYWIwYnFYZ0J4NWZBazlFeDQrL1ZGRFJYRXY2em94VDNwT2UwV1h2?=
 =?utf-8?B?WVZHUHRybnhObEVFVTFJLzVnVnd6dXRxKzVFbVBDNEl1TzRvTWk2eHhLWkg1?=
 =?utf-8?Q?4eUcISoHDQk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGZTNlduK3MzVEh5VUlWQ2lFNUY5cjYyd2xoYWZVcFNiYngrMTdCTzc1U0Ry?=
 =?utf-8?B?SjhZSVgxNXVCaVV5M0lCUUlpMUZFcTIzdCtnVDljR2NsSExFYjU4c0xodGd1?=
 =?utf-8?B?Rk0yRXluZ3IrSDNkSEZqcDNTcmtLaVJFb24wWjZJZ3ROL2ZkT1RraVcrNmJH?=
 =?utf-8?B?TVd0Q2k5dWtONE9BelYvblNZcjluaWNMOHc0MWlwVmFYa0NKNGJERGJDZlE1?=
 =?utf-8?B?MHVlTGhyZk5CQ1E3ZnVtNEtLU1FwaHhqa0UvZStFOVJHSFkzY3FlRWFWU1ZT?=
 =?utf-8?B?YkpjYzk5WjZ1U2dHQ3I3WFpHbTdVQW52UkZHY0xoNU0zS2x6eDJyUUhpWFFk?=
 =?utf-8?B?OGg5RTVGd1E3NHIxeURRb29jUXhhOGVXeUFWckF0SGY3U0FEU013WFllTVBP?=
 =?utf-8?B?dWxuLzhXdkdrbk9FRVk2dHFYS3pSNW5GY1pScTVBMk5mU1I5YTIzMXBmMlo5?=
 =?utf-8?B?Zi9EcjJUZm1MdSs5amNwVDlzaEtibEdsb2ZYNTRyTFF6eE9lbzcxSkZhelJv?=
 =?utf-8?B?ZnorNDVsY0Q0TGgzRFlSY2E2R2VkS1N1by8yL0UwMVNBNzUxSnJXLzN6RnNL?=
 =?utf-8?B?QlFaUzV0Qjd0dU0zVkswT09veXg1V29tam1TZzZtWUxBQVB3LytvR2t5bDRh?=
 =?utf-8?B?YWYxUXcyRzFRbG9hVEVUTHVWL0tuWWNlUE1Fc0d5Mk5kU0dzcU41WERieUdp?=
 =?utf-8?B?RUFjWWI4ZUJtc1NEak5ZUFNYenFycVBnZDZZUzhxOVZsdVBUN0VOTWlUTUts?=
 =?utf-8?B?MFN2d0djNXpSYlB3eFhOeHp0d2VIaXFVWnJ4Q0kxVE03RzhhcGZ5cUxLQnp1?=
 =?utf-8?B?amFJem9KcXpWY0s1QzhUaXgvdnk3aEJiQTVBQm5pVG44VzNNTHBWOStoTEty?=
 =?utf-8?B?ZkFoUVVVak9Vb2ZlbXhFUmUvUVN6V2JNalNHc3l2YTVvcDZRSDBZWEszNVVu?=
 =?utf-8?B?RnNCbHBKektPblRHZGFYUmk2ZjYyTHJnVlIzbzJPamI3MEEwdWt5dG1BZytV?=
 =?utf-8?B?NlNOR1Q2Y3ZHY250TmdWRmJNalIxaThEdjQ1RUpqeFNWZzhSSWhnMXpsaHlS?=
 =?utf-8?B?R3ZZRytNNEVxOWwzbW1BVFJUZWtCajhwajFZQnFhV0tlbVprSlM5a0JJQXZV?=
 =?utf-8?B?eDg5QUtzYkNUaVdEb2QzeHIxWk9vRzZQdzJ1dWpkeGM5SEN5NXNCRmFGR2V6?=
 =?utf-8?B?eVF2ZzBSMHYrd2l4dngwb3N4cU9vV0dGdjhQcUM2NUowcjBGbHg3MnJwc2o1?=
 =?utf-8?B?YmQ2T09mT0swR3Yzd0tkbTdDTVlzeHNZZWcxZ1hlcnc4Z21nQ3hBQVk5L0to?=
 =?utf-8?B?VXNJNWhPbGhrOWZIc3ZhTmdJWWJ5K1Z4WlFmZm1DRnNYbEVvai9jYjJlTnNX?=
 =?utf-8?B?Y3FqSXhJNXZkYzJwcVpNZkZ3alMvTEw5UVhJZ3kyQ3BJMXRJeFpNMElmc2Va?=
 =?utf-8?B?Vmd2b2k3UDd0L1JWM3NocjA4eWRJWXBneTE1cThPNlJRQjJyTWdVVmx3anlr?=
 =?utf-8?B?UFFIeXg0L05KcUlxN1Q1b2dvQWd2Z2JrSE96TjlhY1hIYXoveHJGOTdEcjRk?=
 =?utf-8?B?ejRTQTJvRnJJQ2hKaXVhOCtPZUU5TVQ1Q0VKSmJDZ3EwRmh3S0NHdWUyQ0F2?=
 =?utf-8?B?ZFNmM2JFeXdLOHZkNjJPTFl5eFdXdDhEaGhnTzdORXBFbDljMzcwU0NUZmpN?=
 =?utf-8?B?RGNqZHJMRXowQk1jaWkwOS9JZkNweElVUjlRaXZiMDd5ZWcyUWE3Wmg2RExj?=
 =?utf-8?B?a1NabW1lNlJTQks3YVhYdkt1NEtIaHRRaHhPcjFNL252NW5wZlgzazhONmlq?=
 =?utf-8?B?RHcyM0xJaS8zYU12bEQzbDVzcEVMMGE2WFNVbmhDQ3RWZW1uRnRybnNySlZE?=
 =?utf-8?B?MFNoRVRxdEgyVGk2bllsdjdadnQwY0VpbGNYNm9kV2lsR2VTdHFUWFhFM1JU?=
 =?utf-8?B?aEFNUXBScUJIRU5zako5VzdnbHp4VmFSNVBKN0twZThET3h6MlAzV1l3R21h?=
 =?utf-8?B?OE42TG9sQ2M5V1pwR1EyU2NpOGVuRUU1cEpJWUpPMm95Z2tsMFFVSmJPaUwy?=
 =?utf-8?B?VFhiNFNUOEhJdWxkYWlFbjRFR3I2Z3JsRG84VzBtakIvVE56VUpEd2ROSVg1?=
 =?utf-8?Q?f9pArXlNPHq0uhUUDPw4NB6Vx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d19755-48cb-4f81-2dc0-08dd9c019717
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2025 03:01:20.4893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUZqus0CrLsfHOwFQOOtXXzaLELGg72oyPQ4mJm+KEOqYBq3TzkNQthXIx2rpPPfo9JqwZxz7a2weqiPsZkjKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9048




>> -- 
> 
> This change needs to go first so that it gets picked up first since it is
> a cleanup.
> 


Ok will restructure it in the series.


- Neeraj

