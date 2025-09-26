Return-Path: <kvm+bounces-58855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3733BA312C
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 11:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED3C51C02761
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 09:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E2127E066;
	Fri, 26 Sep 2025 09:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="puslJr0L"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013046.outbound.protection.outlook.com [40.93.201.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF06E22127E;
	Fri, 26 Sep 2025 09:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758877634; cv=fail; b=DyRDdOcrEcyOZhuFV9Va52UcEsD/gCOv34OW+nozdGuUk0vdGv3Oc642cs3fDEWqoXaM0BieOVxHcUB5h+rp85cZOhWdqQKOngKRxZHZQdmtEBHNz+BGredsI6D8kVHpm7e5FnsaCH93xab2OP9zsm2Bt6+FVmBjVQYEy+j5SDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758877634; c=relaxed/simple;
	bh=3ZQTbDF9S1F4sX6W5x04ZcU3p+aiHAIATuQn9Cjc/c8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ip3isNsYv0BN0qpCjxxvWyXdDiKnxw3AN5ykdb2rWd6RErERB+vmeDn7R60WUkiJYKn0MEsiu0cdW/Zwzhej13qWtgFxrwKON/LehgOtiCvCJXGzTGF1WFy/JijQgtsazbmXSJwPsoUnaOw0uzfFyfDX6cwSKa0ntKpZ6WDroS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=puslJr0L; arc=fail smtp.client-ip=40.93.201.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CvuophMuMEwdd7KucfgJlgavcHCFx0f9JxY45J9S2GeXj+4NUQD8g3nmixQXeEctL4bJpSgPMzx+A2zLN++N1TonetETU21hyHYUYSnGT4v83dNlI9mArdGIVtz8gOqlxkHmZ2RJDJJXB6120Gbj4bA0mgunxgpT6P1Fbb9KM49Co7staSGPgnLqT9rzPuj2dXYAuK6iMUGQ0a4F7kc1awS6Bj7TJ97CcelCu3lXprH/lrhDSHJqZZ6HUMZUiWldaltvlwbAgHn7FcLNIM/PR43nM1U+dz3tyMIqANEDWuQXhlvfUZWy2h1AIkXaoXi1wV5ESRLBkCPN15DXSz1Ovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKpCKPJkaiPfHM/lohw/hat8Q1iUC93PsTCwHj7mBbo=;
 b=pxix0yW5r4uB2CUzjjoldRaJn5FlPBgiwg+9EP/i9Bu1N4bWOpWa3HrWEL54eEdcn9qEbtarybqbQUpUiLksmwSHmPRjpPHA4QfA4p5xfoWv9nabugzcE81isTYhzCtf5HXJx2olp0wVi597JuusOmeRMlEO9VqAeo4IW0iBlq9eGi2WpfM9skDx2frx8yyEl8aBsi1J+cQZJGCUC7m8/w/+tnF66CaymxHtiQ/XZ+x/Ma6RKxY1jxN3igwV6qgBx3L/OshYZxqJrwQKcZN2VhfnrQGc4GpYihWL6XYMgcMpqbHgRyUaSK8IXDF3JZSHIzaoZAKc6d/ymvhXlnjJzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKpCKPJkaiPfHM/lohw/hat8Q1iUC93PsTCwHj7mBbo=;
 b=puslJr0L+zJs39n9VssVe5jRBLueUI76GplM5sOxb7E/8xF/LrKOuVnNeI5CVl1z+m6gMHzS8+RCUL4xr2ix9Ttzuz7gk1QO092OidtEW1zeHCfu4xOZwtjz3DQLMEdIeE7jwWScrFNvzH83R+KPOIJvAVrfWInQ20zVW/I82qw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by DM4PR12MB6374.namprd12.prod.outlook.com (2603:10b6:8:a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 09:05:44 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 09:05:44 +0000
Message-ID: <fc2ecc7b-df2c-4cfd-b898-5112b089b67b@amd.com>
Date: Fri, 26 Sep 2025 14:35:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 kvm-next] KVM: guest_memfd: use kvm_gmem_get_index() in
 more places and smaller cleanups
To: pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev, David Hildenbrand <david@redhat.com>
References: <20250902080307.153171-2-shivankg@amd.com>
 <ea4dae91-2e20-4e29-ba00-b73e6160332f@redhat.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <ea4dae91-2e20-4e29-ba00-b73e6160332f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0033.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::8) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|DM4PR12MB6374:EE_
X-MS-Office365-Filtering-Correlation-Id: 554509d8-1bfb-4e83-2410-08ddfcdbdfa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGt5ZFZKTytIcFRkT0pLZXNpOEJ3Mm5YMWlsTXFpUU04eTNFZVZwQjc2TU9K?=
 =?utf-8?B?TVVGQmdSU3I0RVBtVXhKWWN1WmNRZXdSVkUxVkpKQ2RVQlIxQU9kWXc5d1pB?=
 =?utf-8?B?WVZEMWJmR3RpcjJGNzJjdXZaNGhvRmxWZjl0bVZNTVBLOGxIclVqS3QyZlhI?=
 =?utf-8?B?bE9nM1dYMlpBdEMvZVc0TDlCOURDRnpDQk5RK0VGWWFjamE3YzQvVklOaE4x?=
 =?utf-8?B?S1hzcEtIbFhTSENhaGVQRzh6QTQ2WVRRSjliSy83M0xMR2x4cXRqSnZQc3dU?=
 =?utf-8?B?OFB6ajZZMW9aY2diQkU1SWt6RnFldGMxbWVkcHJmV2NtbFMyNFJySnhSdDJp?=
 =?utf-8?B?RHlXRWg5OGxsWGwxdm96YmVwbFZDRWVJaVdTMjQ4VlpzbHJLTmpuUWhJTGpk?=
 =?utf-8?B?R0tFTFVKazgxNXZwY1VyN0h4NytZUCtmRGZrNGgxN1QyTVZkUGRSR0czMDg5?=
 =?utf-8?B?SkhXUmFrZnRQNmJhT2prbDdsdGtON0tCemlEQ1FWa2Nhc1hBbjRWZmdHTGRR?=
 =?utf-8?B?cDJMbGhNaDRRNDRuK1RlK2t1ZVM2M1dWVXl3Wk03S1F4c2prUjNIWmtsdHVM?=
 =?utf-8?B?bnlVdm1nZkpzV3hQNVVaZG1ZakU2K3YrS2trekNOeFBVSFdvQ21KUkE2WC9D?=
 =?utf-8?B?NG5nY1VDTVZCOFBFcTk3dEVoMm1PTUoxWE9rQzBRUjRBQmNmV2R6RXlDeENB?=
 =?utf-8?B?ZjhIaGlOaHVwNmJQSnU4QTFIRWI4MDhNOHkrZGY3cXovNkdlN0dLdkVudjZF?=
 =?utf-8?B?RjlBdldvWDY0M0hHTHRpckZHRGdoRkViS284dXJpUFNXTjlqb0NUWVBxVGJW?=
 =?utf-8?B?Rm5Pd1RaWW01anBCUTJ5eEJxK3JSdCtwZG13b0xFeHUzblR1YTdNaXhwWVhz?=
 =?utf-8?B?eEtzNkV3V2xtUFVhK1NRczl5QzBsTDVscnFOTzQyYktEN3cxejdXeUJUaWFZ?=
 =?utf-8?B?enVUemMrUDk5ZkR4T1lVZ1lrVkNKT2xHZncxTFQrTHVGNWkweWllMHRtM2Y3?=
 =?utf-8?B?K1dZOEMyNHlyT1dTWnFiSjdEZmlxZEUvd0hsWlhCZzZIKzY2cGs0YWk0WUg0?=
 =?utf-8?B?ZWcwV01MVHZRTElnQnFyaXdPZ0x0ekRlZjlybkFBdEt0YzRua0toclA0TUFX?=
 =?utf-8?B?UHY2V0FpbXZZWWxnT2wrNFBPVjdDVGl0aG1qVGNucTlxSGpPT3FQNUFmbGZa?=
 =?utf-8?B?QU9nZlNaUUlCYUlpc0hKdkFGVXl2cWEyekhxUW9MYXFoTW9VT3VGRy9QT3Nw?=
 =?utf-8?B?bE12OFRHQVBheFJvZkVmdGtXalk2ZWRKeDBxQzA5VUdKU3FJcjg4dlJDZXZp?=
 =?utf-8?B?dGRUeXRsYk5pWTYvN25VVUdBbXE3ZDhieTlBQ0ZuUVJOM1BYcWxzaGdnay9u?=
 =?utf-8?B?bjRaV3k3ZGpDcGhNTzltUjczZU0yZmphRm9pS0ZUVmhCOHpHd0hhQVNIU25G?=
 =?utf-8?B?UGR5OXg1RTYwNHhGVmY0a0U4cktOcUlYbHloRE0zK0hDblczRWU3VmNEN2xH?=
 =?utf-8?B?bGY0Vms4cHEwY1NPOXNlK2E1VDZJUTIwNVhuVmpRd0Y4SnZHZlBHU0tvbGh1?=
 =?utf-8?B?dkpJTXRhUXdMSEZJM1UyYzdjQ3ovRXdaWVdtVmIvVFNoUUd4NHZMdWNxS0Yy?=
 =?utf-8?B?K2hrT1pGZkZsY1dDM25ucUhBd0tDaHRLL1BEcXVjOFhhcFpIb1llaHFPczlC?=
 =?utf-8?B?c3lyNDAvanA3VkZFalF1cE1WQzNXVFB2anptcUJXOXlPWkFTSnNWbFVjRGRq?=
 =?utf-8?B?ZU5CcWd0bVlXMGhGUlRCTThJTGtQQk5TTVpYRVl6RUpiS2pRNk01VGNxSG05?=
 =?utf-8?B?bUNmbmJieU5qdDd6ZUZTR1FEVzlxaHoxOEc5ZVV5MUI2REtpQWpiay95OXFn?=
 =?utf-8?B?b1B1UTg4RFViTE1WZGRVSmxRU1k1WkdqZFVHaHo0SHM5U2hMQTVyYjhaTUQx?=
 =?utf-8?Q?GVTk8Ppduz0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGhkOGI1VDdlNHVtZ1pwS203VWZHNGUrQVR0T3BZbWhGNStOUC9oTmRhc3Fj?=
 =?utf-8?B?djhMQ1craklXZ2FFbE5JeVdpZ0tzeWxRQ1poQjVaYWJoOTAvYkx3cWo2cXhH?=
 =?utf-8?B?YTZ2dW5qWWMxUlNRNFdhWUtlYlVFdW5qMXN0T2F5MGZTSzNZT3BydlJWOFhT?=
 =?utf-8?B?MXpvMDdvSmN5Uys2bU44MWg0RWcrSlNwZWhpMFVMOVJubHMvbEZ2MzlGRXhD?=
 =?utf-8?B?VFZFYWFIM1RBWVBlSHNSTkpKRmNUUFFKNjYxWEM4MWg0UE9BWkk1aGgwWWpZ?=
 =?utf-8?B?T2JCc2ZpL3JuSStldHVLNUVzd1FDdFhycTMxY0JDZ0JiUDdSQjd1NWlDbmdx?=
 =?utf-8?B?MHczcGZGODhqclFnRmE3cjNkYk5HaWwzTEE1SGQ5NVVyMFBOQUVNYmgveXdt?=
 =?utf-8?B?UloySS9QVjJ4QW01dXJkcEJ2ZlF3MHNQdmQ3eGVnNW14b2FUODZTOU9mSmdP?=
 =?utf-8?B?aTNVOUZhU2tIS2dReVpKajUveXpEVWFza3VTbkJEdUlZa01WcFk5TWRvR1Iv?=
 =?utf-8?B?SEUrUnNhSzdjNEdHcUQvU05aTWVSV2lJU1VxY1JmYXZ4VGIwTmludVdjc3B4?=
 =?utf-8?B?VUlLNDdxVGR3VWdzMmMvVXdiQm4vWFNYTXhERXZmZWQvUU5UdkFWZVR1ZGZz?=
 =?utf-8?B?NEhWL1NmVk1KSEdVMzBXQ3lnNlJnTXM3d3hVVzlXTjFER0VsNXRGa2xWZmJv?=
 =?utf-8?B?Vzk1UUxvYlFURjd1SXR3cURoalBONGV6d3h0d0ZHdWVUclRvTlBuOC9mb1NU?=
 =?utf-8?B?ODJqUHZtYzZnTjEzOTlLT05DTldDdWIxT0Y4dkpYN1lGeTdFTzZubFphZVBQ?=
 =?utf-8?B?aWlaVHB2R0djY2RIcHFyWDV5eVc1TFlKUnZkdmg1RC83Um45SDRNdEdCWlkz?=
 =?utf-8?B?ZVVtUTJvNXF0eVBuZXd4b1BqK3czQWZGNWI5S21tN3FtVDZSYVA3ZzBvQTJq?=
 =?utf-8?B?b0tDNmJybFVteUdaa2hIYkg3ZzhDeWw4emdXdDRkVnlUNHFYbHpKRzJNY25H?=
 =?utf-8?B?ZUFvSTdtK1lnTFJMSFYvUm1tQXh5bitseTAvdno1bURQRmIvMkdXYS9YK283?=
 =?utf-8?B?TGNaaURLb3M1M1NYejlYZHhpbm0vM0E4bW13QkFLRmMrcnlLTmlBNEZuMmVP?=
 =?utf-8?B?dHJuVnRNZmFvdUdtdUF1L3Zwanc5cjhlQzc1dW9ONkF0OXdVczVyKzF0ckx0?=
 =?utf-8?B?UW5SRkJBajk1aE1McVdUb0tCd1ZUVDBRcU5jZmgwUVNCYzNKR21qblJ3RTJ6?=
 =?utf-8?B?S29XV2hzbUMxSHcrK2lrZjQvWkdTdGc5SHh4YjZMWEN6OWtiaTBGQVBNU2E4?=
 =?utf-8?B?SW9KYzZEaUxDME14VjR5WllzVVRwTVRPY2RGWkVmd2szWUZrTFpKaWVqSnhq?=
 =?utf-8?B?a3VOVTF6YWxrSVNybVFPL1ZHS3VUUVZ0aEx4ejdTWmtjdkNKa3dIWTh3bEV6?=
 =?utf-8?B?UWhLMG02TTgvZStDQjkxYmsyUDc3SEZpNDVoSDd0TFptYlNmemdkL3NOcGtC?=
 =?utf-8?B?YVo1OW5oemRxd0l6NVVRU2xpblMrSFJqYkdOM0VOQnNCbHIwMTRGbnZxTW4w?=
 =?utf-8?B?LzUzS0M0WnBFRkF6dm5JOTBhNFpJSUljUlhOSnphN0ttL01yZW1OWTdUUEZ4?=
 =?utf-8?B?L0tyTjl4ZUx3eS9rNTlzc254R3JtQVFIdDRmUjFCalJSRW5wQjA4ZTNXS1lU?=
 =?utf-8?B?WFgzQkZMcm5wSlJjaHRFdnhjNS9GbHpCWWxmeVQ3RElmaEEwcERQR1V6eWJn?=
 =?utf-8?B?TjA1eUhvWlJ1V3R5RWppK3RDeVpFYUJ5THNRdnBhS2pZdzJFcFhQVjE5dFUv?=
 =?utf-8?B?ZU9KS2dZNlBiU0czcnppUlM4TjlPODJ1aE9KWFJDMVRZTEh5YXM3bUxDR2l2?=
 =?utf-8?B?UU1jQWxTMWprR0p1Q0NDVDJMV0swMXZHcGlTTThIRk1MT0hVOURBNHBmZzVt?=
 =?utf-8?B?TWl0dCtlV0QwOXhRenJ1SFFOejBNdWJnZ0N5a1d0K3hjazJOVHgvV2ZiOVQy?=
 =?utf-8?B?NnhON0NkOXcxZmxoM09oSHZiTzFpRmExWDR0Nll3cit3OE5FL3NHR21mektH?=
 =?utf-8?B?UzZMTnV1S1oyRW0rVDNMZWl4SmVaekt2ZU55K2hzMWhoWWJzenRtbXZsNnJR?=
 =?utf-8?Q?phAff2boTtEoBIYTDPSuy1eEc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 554509d8-1bfb-4e83-2410-08ddfcdbdfa1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 09:05:44.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XUiE14pEy/SnGZD2ten42iFIoONjIN24zUnKPIJhOsP9+g9UEYivfO63+DBtcfPdGRAt8ca8VE3QzVhXA3j1VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6374



On 9/2/2025 1:42 PM, David Hildenbrand wrote:
> On 02.09.25 10:03, Shivank Garg wrote:
>> Move kvm_gmem_get_index() to the top of the file and make it available for
>> use in more places.
>>
>> Remove redundant initialization of the gmem variable because it's already
>> initialized.
>>
>> Replace magic number -1UL with ULONG_MAX.
>>
>> No functional change intended.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 

Gentle ping :)

Thanks,
Shivank

