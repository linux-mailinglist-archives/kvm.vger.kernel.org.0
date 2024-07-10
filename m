Return-Path: <kvm+bounces-21306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E66D392D19E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 14:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 834BA28366D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 12:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A689191F8E;
	Wed, 10 Jul 2024 12:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fn506YBa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17201E4AF;
	Wed, 10 Jul 2024 12:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720614658; cv=fail; b=sp1g7rQV+lsaog4N2n5t07Wl+N9LxKFaQf6xmEOR1e0F2YKG0yC7wV2Y/MDevNcwKwNBW9prLBVV6vhA+5MHgxncL4MvWSrYrpx078HOxLe5PJW795aKJoI6BvHq+99qALCTIR8rcydOkKN1NKMn5WCK4J0rlP+4VRLW4al6lqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720614658; c=relaxed/simple;
	bh=R/IT2asRGujw8ZHx5NtFpWIATgwHi4iyQPKpmSstFJQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aZ8zZndcE9qHPgIKEdM/v2QIQqZktoKt437oAX9Sr+Ax+NULgLEB2S6J8+2T1Ym0KXbkOVCnqafUnoA6RxG4d51DzzU7y1Vq2KtqXSGg7/DOz3mlz7oM/VbML/AW39HLfhIFTRofkvLEHrL27oi4kpLLWRU02HLZa4FfoIXFTYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fn506YBa; arc=fail smtp.client-ip=40.107.94.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAL1HVRiGHc1Ft3mtxEmxfUvxTezXiWqOt9/igylVRs/QB/wzud5uuHY4ZzH5KP+Whdcqt+QEqbRpyaFL25jAMLGAU23MwU2K5cuYElGnOrfmKi3j3A8qzXKcPM4areblN9sZnEfoc11Hs19fqX782b1LQyv4xy34EHdol9DDTrlo+8f0ntQ2IM+evAT0f/XbrpqUdvDK0U9JDzEL8ZKUILJC9KDUxoz3anZVhz9VAdlovaCI9UNbSFOqMl8zG2MSYjhd3BNktnsSCvwQ7d17wCtyPvkdsIVNiVOE/3AF2SAsBE02Ufmiuo9D/R4TZE4HlK0rXMCsEO/ergfiKUlxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+rAk1LSgioEanmBPcucRVwlTXyBHlktBvMkGGA6Abs=;
 b=JcfHnRIcqA8EZEJFriGbMYzfsr63XyZIEnI5OgsFpV4iqxIXZe8RJiD+BNnZz1XGPQ3RYCr5fxWFPy70Gfe1fGc1Hc5zdG+OpdLbLIWvYc237J4XhuxB0cQlwmiic3BAIW+cHuXm53862+w5sFQM3eTRqwcda1pSVQwOQTcf8Rq/WVpntjAsouEBcnsWxbY3wdrVpg7dGCOZWpZfZ1nfZeBeDi9FbM0ZJxg/cdrJfURKldOm/qmSBq86DuLt2UKuYoEnq3Vgf+lvdv50V65rHe8oacXqc/J5IScux6tdRxfmj76GYsL6oIOdZusQfOKMbyBk7YuWMS74lmz9G0YS5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+rAk1LSgioEanmBPcucRVwlTXyBHlktBvMkGGA6Abs=;
 b=fn506YBa3RUPADVTiy8EyyeSxS8c40ufWNADr9dPbrxzifG0TQAvce+P25umPfaaEpRqK/rEFH6lB0Eb2ZB6X+yqfxpCoaqMEIr4y9cQZDnRcQR80yDQC8eYI0/FGLa1ED0SE3cEJSnFmOk0iseMgnZQmd4k6Pqm7k57wnWju7Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by CY5PR12MB6430.namprd12.prod.outlook.com (2603:10b6:930:3a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Wed, 10 Jul
 2024 12:30:47 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.7741.027; Wed, 10 Jul 2024
 12:30:47 +0000
Message-ID: <d0809bd7-7f31-4698-b04d-bec0ec303068@amd.com>
Date: Wed, 10 Jul 2024 18:00:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 36/54] KVM: x86/pmu: Switch PMI handler at KVM context
 switch boundary
To: "Zhang, Xiong Y" <xiong.y.zhang@intel.com>,
 "Zhang, Mingwei" <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>,
 "Liang, Kan" <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>, Ian Rogers <irogers@google.com>,
 "Eranian, Stephane" <eranian@google.com>, Namhyung Kim
 <namhyung@kernel.org>,
 "gce-passthrou-pmu-dev@google.com" <gce-passthrou-pmu-dev@google.com>,
 "Alt, Samantha" <samantha.alt@intel.com>, "Lv, Zhiyuan"
 <zhiyuan.lv@intel.com>, "Xu, Yanfei" <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
 Manali Shukla <manali.shukla@amd.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-37-mizhang@google.com>
 <18ff4f7d-3258-4fbb-8033-8edbf3fed236@amd.com>
 <SA1PR11MB58269828BC46772E32CD1C9BBBA42@SA1PR11MB5826.namprd11.prod.outlook.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <SA1PR11MB58269828BC46772E32CD1C9BBBA42@SA1PR11MB5826.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0086.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::11) To MN0PR12MB5713.namprd12.prod.outlook.com
 (2603:10b6:208:370::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|CY5PR12MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b75dd9c-441b-43d9-17c4-08dca0dc1f24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MlFJa3JGUnlHMFFqWmxGR2F1V2E5RDN6RmtGWHlWYjRvUW5ONWJOOUx1bm1r?=
 =?utf-8?B?cG96ejk0a0w0S2ZDdnBzaVpaM0Nsa2U4ZnUxbGs3dUQyTkRmNnlOTkg3Q3U4?=
 =?utf-8?B?Z0hkd0JDSHdFQUdKaEY5MVFldWw5SjBDTHJVc28rblpEM3ZPTlc3NnV5YXFH?=
 =?utf-8?B?QXZIZnUyMytDT1lzUFFGSDY0c0JqVE41c3g3bHQwazlUNnZ2djFOSUtLcFQ5?=
 =?utf-8?B?aDYzdVNYc0FtbDMzdTgrM3V1SmRkYTd5WEdHbEFNMUNlRHRkRmp3SnJ2QUlO?=
 =?utf-8?B?OVB5dXk4QTZ4U3llWmRYQUkxdWRkOE5yb1h5c2t3TzhKcGpVazBKdnJ1eG5o?=
 =?utf-8?B?QXlqWXBYVEdaTms4ZldrSTZZZHk5N3VMZVppNEkxQ21xOVkxTW9iQWo1b0Iw?=
 =?utf-8?B?Vm5hL2M0ejQ4ZVpvelppbGFvTG5tUUVoQStuTXBsTzJrb2ZiVGdRdnUvRkZF?=
 =?utf-8?B?cmRxelI0THhCdUJIK21NMWhHMWc5VkQ1Q1dMSHZhNVFhWjB1OTl6TXRuYWl6?=
 =?utf-8?B?Wll1U2lKK0FxZGc4QkFBZFFwbkJXcjNucFZCUGl0S2tIdDZDVi9yKzB4eDda?=
 =?utf-8?B?c3VnWksrdGJNMDhranZYa1FGbjBvUi9HRUZ0U0srelkxS1dHa2dEWXkzVkNw?=
 =?utf-8?B?Mmo4akhPRnppbmllR2RJU2tJZnVPaUVyZEVFZ0dDdzVtN002WnBNOGZLcTFj?=
 =?utf-8?B?elVKUjJ2NXlxaHFPS3V6NXBHb0NmcUc2dndUZjgzUFVRTDdJOGdoN21Ldkkw?=
 =?utf-8?B?UDdGc0NxdzFINnNnbWxpeGxyaUE4c1RRcVJQc01oY1VhQkh3Ynp4THI4bml3?=
 =?utf-8?B?YytlQ2VVcVJiK3hQcURXK1pXZ3JyUldwbUVlWHFIK1N1SUpKbXRzVkMrYnY1?=
 =?utf-8?B?RDJmbm5zL1pQY0N0cnZNanplTG1JQTNMSTlLWFlzbU5CejUwYnkxT09SVHdz?=
 =?utf-8?B?RWE3aDlNTEIvclE4L1IrazBuSXc5bFQvUHh3VzdOSWVhaE9PbHhRV3dwUEtq?=
 =?utf-8?B?dkZnQnlTeXdQSkpCOGJGRHJWOVQyQnE1ZnN0eHlCOFVZZWpIa2dwdUNwTzBs?=
 =?utf-8?B?cW9PbXNGVjROWVFIWEdqMW03cHRFRkNpMG5wd3M3cldROTRMM0cvejZCOG5L?=
 =?utf-8?B?UHhxaHRqclUwY3JBWEE5YzBKNFUrcWJKRkhKTmM5NHpaMjVFcm1LamQ1OEEr?=
 =?utf-8?B?cGtXMEtPa1A2blkxcGp3eFYwRDBPOEhOME1GMzVzRXI5UlBiTTFPT1pYUC9l?=
 =?utf-8?B?R2s5cC9wYlY4bnBXMWI2LzZUV3BvYm1vSlh1TzMweGo1NDJtTWxXVEZHV1JM?=
 =?utf-8?B?QncyTFpEa0ZtNUdqdHJYdTRlSXE0Z0xGSi9qU0xsd3B4b2FnVytDNU4yTkxW?=
 =?utf-8?B?dW1ZcUwra2Qvai83N2RVQWJ1NDgzRHJNUS9EelhjS2Q1Z0F0UElMNGZHbDlN?=
 =?utf-8?B?L1VNTTFhcHFHczNuL2dXWUpuNkt3NjRpaU82UElWd3ZFbFFrcmJld1p0U21R?=
 =?utf-8?B?dEZ6Ym8xUUNsSVAvZjBhcWFDMXJLeS91VktuRjk3dG1DNTdyRXdFb0FSMmc1?=
 =?utf-8?B?NWJONlgwWkd4ZklzTDBOUHZJcE01QnVVK2FNQU90L3d0dWJVRjAvcUtqdUp6?=
 =?utf-8?B?N1N6MlFXeVNVR2JWcE5TQ0p0OEhiOHRWNWlKNFdNbmRzYnBTMy80TDhTem9M?=
 =?utf-8?B?VWhZaW5MU2NZbEJrYXpIRjk2M3pLMzdaUXVOWFMxanVjUTR1TnU4YmxWVkxT?=
 =?utf-8?B?T1FPdHVPTS9MUmpKc3dpTVdJaVNkM1d3cC9sTVlqbzNRSjNvZktJbkhSbnQz?=
 =?utf-8?B?ejVmOFNaVGtTOXhGM0taUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnNEUWxOTXRSaDdaZGRoa0lCVXFJcUxFcDM3dXhwZGJISmMvTGNWblVZa2xE?=
 =?utf-8?B?K0d5ai9IcjVaZ0FzenptbS82c2dESnEzdGVpbmtnWU5pd2Q5WWhLQ1ZkK3Fu?=
 =?utf-8?B?UUt5bnNHZGRpS3dhaWpuQTBzN3lTU1d1Ynk0U3dKaFlVd3NKcXZIMWR0SjY1?=
 =?utf-8?B?MWgvaUcvVlNtU0hvcmRqY3d3ZG5xa0ZtekMvVmRIV2JvaGNGbVFVU1U5V210?=
 =?utf-8?B?MnlpNmNBdEV1WXNSU2lISnJRc1RKTlVIUGtyeEhDbUxvVEh6dCtiUG9jenhN?=
 =?utf-8?B?L2kxUmx4dHFybzJVTzZsVXZXVUJMSUF6NFc1TVQwRDdoaWdNSFFRUmdRWjJz?=
 =?utf-8?B?RERwOEMxTER1eHEyMnkzVW90RG5OakFUVy9VNk1VZUVqV09HeG5OcmJKK2N6?=
 =?utf-8?B?RUcxUjZBWm92S0tMaDNhRWkxcCtRMXppM0M0TVBTNlRzdlUxQk1hU3MzckRP?=
 =?utf-8?B?Tm9ZZW15TUpzKzRKc3huekFhNE0zQm5uZXJBbDdMSUNxdENUc3htMDNvdUVa?=
 =?utf-8?B?QWxGbkFVWmRkbXdxT052QWJYdE1DZmlraVgzUVd3clV5Ly93RisyNG1VZUMv?=
 =?utf-8?B?UzBDQ3NwakRaVmF0RUx1UGd4R2JyUVBOTlRPWnZ2SFRmbnBWU3hwd1BJdmFF?=
 =?utf-8?B?dys5M290RkpYMVZVeEdaSWpMNCt5N0lEa2V6eU1HR0RjMWpoaTYvNHNLdjIy?=
 =?utf-8?B?MkltNWxvalhORVVEYzhrNnF4d01ocjY3TU0wUk02dzI5TUhVdzlDYUNmelV1?=
 =?utf-8?B?Y3JFdmxYeXJnYW4yMUhpTE1Bc3p3RVEzZHUxcFJTZ0xQeTh0b2E3V2FUTGlT?=
 =?utf-8?B?bnBtSUhkaHZFa0VOUlFkdldNU2ZodlZzb2YyUXZYdU1EWDhmMHhlYVRrMXR4?=
 =?utf-8?B?M1V1ajNQZTFwNEdNQU1UU0pYdXlQcnFhZy9EUnFkZFRFRHFjaFQ3UDBzdnVV?=
 =?utf-8?B?NjRKSEVtK24wZlNweUI0cXFEY1hCN0t5M1pVYWZaamdtQXl5VGFtZ2xJZmZJ?=
 =?utf-8?B?ODMwd0tKL1owMXRJbXlmcGh1ZW1zWVpTT3NMN0ZNNjVBZDZ0Z01jelgxbWR3?=
 =?utf-8?B?NHk1eWI1RFBpeFBna1ZIUTRqcFhzS1dUQmNLQjc4K29rR28vdVN3RC8rN24v?=
 =?utf-8?B?K3kvM1NKQzZBbE9adTF1b1VVN1lCZjd6RUJPYWE0ZzRiV1JLWHlOVlBMYm14?=
 =?utf-8?B?eVVHWFAveEZ4NStDV2VqckllY0JYOGEwRlZySVgzYmhqT0xPdjR3dUR0aHpp?=
 =?utf-8?B?V3NobnNPL29hVjBwQmF6QnMxUlFud1VjcGRkUFZHVjVodTNYOFdheU9KOTJN?=
 =?utf-8?B?Z3BLTnhQekJLT2IrVUw2TWY5cmg0WGx3NlV4MThzc3JWU3ZwLzBsNUJJNm1q?=
 =?utf-8?B?SVhMdEk2cHFZaFMvUGsyMFZNaGREZFpaS1RqVU9lWXhIMnFUa204SmxOS25i?=
 =?utf-8?B?VFhEbTBTK2MyYnBzQmlSakpFc1VxczJKRlJDUHZvcHdxUTgxMjQvVWd2bGxw?=
 =?utf-8?B?YUt5MGFPUkhUbTdUOGpEblZCQU1zcE5pNGdHWnI5VlNoL3hNcUJ1citVd0VP?=
 =?utf-8?B?a054VStzYUc1OGZxMzUyL3d1bFNyVVQ2OVNrZnFHWXpuZjI3cVpRNk1rWVFS?=
 =?utf-8?B?b1h4ZlY4Nzl2NVNSSFErd0ErbS9UWnVia2g0R1JpaU5pdkdqTkZvN29xTUF5?=
 =?utf-8?B?OUdWc0hqaUUvandlbzJqUW5LeFNvU1luRVJLTUQwa1U4cVRZcy95ZHg5OWM5?=
 =?utf-8?B?ZnRtSGowb2VUUzk0QmV1YS92aTlMUlhYeU5rNSs0K3hpMUZ1VHBqZTBFUzlK?=
 =?utf-8?B?eFIwSXU2eVNqNEJpWEx0enVxSm1XVFBsd3JERnh0WnBXb3JCYWI5R1JYeUpG?=
 =?utf-8?B?eGN3MVFHUldFWWRmek1ielZqdjhkVUgrNnJjbzFLb3E4ZWJSdm1SSXpJTDVp?=
 =?utf-8?B?Nno1dTdDMHZQSXBPRFN1cS9adjRKczRUbzJrbkR6SWgyam41aUlEdFVmbE91?=
 =?utf-8?B?RmNnSktUKzNBSEpMQ1RrWm1tWm1CWThFSi9KVmkyTU9nQlI2YXZBbkEwZWta?=
 =?utf-8?B?aW4wMEIzUzBXa2RTWmhSVmlzZDFTeUhLTzV0N0V0YkhvQ0YzTC9oZy9HS0pU?=
 =?utf-8?Q?Rpi+XgC+CEDq6y2q6G4rwuDLG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b75dd9c-441b-43d9-17c4-08dca0dc1f24
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5713.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 12:30:47.3929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FK2qp86KiE+Tn1hr36w4JUGaNb0zj0VwPEMvDCbmpVsAEAcyQCYi2AIp3bcUPtkxEj7jPUphIgsrmHES3fTrnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6430

On 7/10/2024 3:31 PM, Zhang, Xiong Y wrote:
> 
>> On 5/6/2024 11:00 AM, Mingwei Zhang wrote:
>>> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>>
>>> Switch PMI handler at KVM context switch boundary because KVM uses a
>>> separate maskable interrupt vector other than the NMI handler for the
>>> host PMU to process its own PMIs.  So invoke the perf API that allows
>>> registration of the PMI handler.
>>>
>>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>> ---
>>>  arch/x86/kvm/pmu.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c index
>>> 2ad71020a2c0..a12012a00c11 100644
>>> --- a/arch/x86/kvm/pmu.c
>>> +++ b/arch/x86/kvm/pmu.c
>>> @@ -1097,6 +1097,8 @@ void kvm_pmu_save_pmu_context(struct kvm_vcpu
>> *vcpu)
>>>  		if (pmc->counter)
>>>  			wrmsrl(pmc->msr_counter, 0);
>>>  	}
>>> +
>>> +	x86_perf_guest_exit();
>>>  }
>>>
>>>  void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu) @@ -1107,6
>>> +1109,8 @@ void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
>>>
>>>  	lockdep_assert_irqs_disabled();
>>>
>>> +	x86_perf_guest_enter(kvm_lapic_get_reg(vcpu->arch.apic,
>>> +APIC_LVTPC));
>>> +
>>
>> Reading the LVTPC for a vCPU that does not have a struct kvm_lapic allocated
>> leads to a NULL pointer dereference. I noticed this while trying to run a
>> minimalistic guest like https://github.com/dpw/kvm-hello-world
>>
>> Does this require a kvm_lapic_enabled() or similar check?
>>
> 
> Intel processor has lapci_in_kernel() checking in "[RFC PATCH v3 16/54] KVM: x86/pmu: Plumb through pass-through PMU to vcpu for Intel CPUs".
> +	pmu->passthrough = vcpu->kvm->arch.enable_passthrough_pmu &&
> +			   lapic_in_kernel(vcpu);
> 
> AMD processor seems need this checking also. we could move this checking into common place.
> 

Thanks. Adding that fixes the issue.

> 
>>>  	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
>>>
>>>  	/*
> 

