Return-Path: <kvm+bounces-46349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E56AB5485
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 14:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67D097B410F
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECE628DB5C;
	Tue, 13 May 2025 12:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dAZoshjj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D145F21C9F6;
	Tue, 13 May 2025 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747138606; cv=fail; b=Ul10x5sSo+3OyQgRqhhnc9oq8aKCfWzVhpzddN0ALM37Gm+004aT80gYPffSuG5E/lt5X2MJrbu7mvit/tQvzSxhWe0BXKdhAGEDfQ8Nb+B/5dkD0nl4+nT8doihUnhPgabFhx5GcC6CqNuToNG5SrZrtX02atpmeUSAhyPuN1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747138606; c=relaxed/simple;
	bh=F9xAQEXJo5w8N/WaywD6kR6s79ASF5CjlBarA36dKB0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AvvPEjpGIRT/xfE9bgfr/Ro0ILAq/0WbpOc8xQawRxKI+QZh3yZFyE5/tJxQMgi2NADgioQ0af2+IeSBsxTL8LpZBdHyigeDidlETWfvvzgadmqwiDUOAob6rcwTOzD/3vDwgw+KQ4tBIZ0KDP0fRp5uJhDJLazHFRuth5MN0Y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dAZoshjj; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QdLZgfGi9DR17GSJccr7xHe/Gb7tJeF1MMZCbPMgGDLojPq8esykO/Y4kLiF7bQkofZTCLRrLhDpltOMld+9Ij4ZtMTLM8bFxvanU5dwqsPYcPyQNYkoBB8BPNeqr1ZVYLr8GL3zlK0WVmOseD2cEfJW1aVJtk8lDDoyCR/86xJo2QPQi7sn+S34Hw76+n8UTm1EzcalvbFNAAUBCYGO4Z23HbnqBikr9H29o5fCJzSqNe9zlo7p3oqq10SblKo625RKduDcl0tj/vpBc2vOHMZGCmjLBDZVYE/eWiTv5GVjJjg8nAmOp2WlKz4vBzhZk3WCa0DrPpT88BpuhezRJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2/nUfs8Tg6b/ca2Q1dunsudAoNSPXCvKQW1oEH0x5Y=;
 b=NEfO6nuS7XvVpQj2YiC1r5E06eRza9Ve10spibjLrn7CQ9Fbf6K55zeiORADrxeM2aIZJ7RA33pqQ3ukCwpIr2wf2tAj0H2AEh5I7udqKE8/J2GPEKdsrTBeWULrhel9/9SgVGkNiRihBbF+pPqu+r8JbiUKQTpCATuvQsHCkk+98MencqdkU+fOZQAr9rJbXXR8zaDSW1IP7n9++wlRqa7xy2m7aVDi1m0TaWxE3X5PmMzoeWxnjatkZhgJCSDybI5ps55eDf/+yyNmWelvCUJeM1m9DT7C3XcxZI50RVqoSpkNzo85gPakM2p4EnKMptCdKd0urByr0Ob9aZxdHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2/nUfs8Tg6b/ca2Q1dunsudAoNSPXCvKQW1oEH0x5Y=;
 b=dAZoshjjXkCHyl0HyLRETN+b+J53pEARk52g2uZY8HFvXB6sJGvnck7au3bpGb9owgiMsePr4Wrmf5U/XIkMvczv7A8fOsdPCuKDbVHHA13ImLAfXOq0Uxy3jOM55PU5aSkhM3eWWpzBdvTOy+lyHw86V8aU0FTIvYkkP9BowoE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by LV8PR12MB9110.namprd12.prod.outlook.com (2603:10b6:408:18b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 12:16:41 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%3]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 12:16:41 +0000
Message-ID: <b2b803c9-e8a5-45ff-a634-0d95992f2b80@amd.com>
Date: Tue, 13 May 2025 14:16:38 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] KVM: Use mask of harvested dirty ring entries to
 coalesce dirty ring resets
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
References: <20250508141012.1411952-1-seanjc@google.com>
 <20250508141012.1411952-6-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250508141012.1411952-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::7) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|LV8PR12MB9110:EE_
X-MS-Office365-Filtering-Correlation-Id: 828faf3d-753d-40e3-a120-08dd921804aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WkRhL0xjaWtGc2gyazVlM3BlVklaM0YySjBWU25HMUNxN0wyVS9KZXZhR0ZQ?=
 =?utf-8?B?Zm5WTTVoeWcxeHozL0pUNFpxZGdwOXN0czhrTGVaQ003R29TYzRVMTZvazkw?=
 =?utf-8?B?Z3Q1cEMxUkRNbndOQnI4UGxRbmpmaFU3VkRBdkFXeGQrb0J2NkdVWTkrSFhE?=
 =?utf-8?B?UzJBaTNIM1BFMUNiOXlUaWR0eWRSTkl2dVlzdno3dmsrT1loZDZPdllPWkN6?=
 =?utf-8?B?U1lJc3h5d0pvaTFRbm9qZ0RMNlloY1RhK2tPQTNjVTVKWjAxcHB2WDJmWEFY?=
 =?utf-8?B?UEgwNkxTM3ljaU1aSWxxcU8vMVhiN1VZbVNWeFQ2YThwVkpWMmN3eWo0YVBR?=
 =?utf-8?B?VE1IZVc4T1RiNDBXdHVNVkJEQ3FNNEdnWkl5c1dkYTNMOWFFUTFhZER0Y0lN?=
 =?utf-8?B?WVBqWGx4dVNUVFE0RnRrUHZoQjVNUDAxbWppNEdXTWF5QWRBenFhYnZmRzdD?=
 =?utf-8?B?Q2E4dUJaaTJiaHpYMDJqMkgrUSthMURxaWZwZ2tnZUcrcERzRTN2R2pxV1Uy?=
 =?utf-8?B?ZzB6Z2grbkxPd01DRmROTndDNEh2cVFwcEhZMENLeStUbUMxWkJKODk2ckFz?=
 =?utf-8?B?d21NVXJXQnN3RVdjcHFSRVNPY1lZWUR3VjdoNEowVHBuU2trT3Z4dW4xUGxx?=
 =?utf-8?B?N3cvSVdFcHFlNEJibVNJZGFOV29hWmdDU3U4WTkwSlVhZXByaHZCSzJOZ1l3?=
 =?utf-8?B?eFhXSTJ6aDh2Sk9aZ1NQem81NytmVDRSNStqeWJZSFQ4c2x3ZU1FYnUwTklZ?=
 =?utf-8?B?cWJmVDFXY3hER3J0SSs2REtYSDEvR1VaZXRUWFhaNk12YnQ3VUhucjg2WlJC?=
 =?utf-8?B?eUQ1cXBzQnZjOVppOTNHcVBSUDlIZGFsUWlqV3NMN2loZk8yelZNam5XUEho?=
 =?utf-8?B?VjlFb1dtdnFteUFSTUdVeXJ1Z3JtQU4vTVBTaklRendZaE1XTERxdytlajJU?=
 =?utf-8?B?YWl3N2JFQTVldDVtcEViOGozOVlGckVQc0pCYXpmUG5CaDloR2NpdEQ2QytX?=
 =?utf-8?B?TWdKS1Biei84MXJ5SEtZeXRJTzZBSWFMU1hnb2I2ZVc3Nm5uSHVoK2xzQ2Vu?=
 =?utf-8?B?aTlYVk1McXdMRUwrRTBZRWlkZUVvLzIvOTc5cllZbzZnWE1scWpMNytnbXZT?=
 =?utf-8?B?SS9nb1VnbzJHa0MzbVg3dkh0MWIvY09PSit4cFRVZFh4T2xicjlyMDM4NUE1?=
 =?utf-8?B?NzdZK1VrKzEzY2QwMEZnbjdPcE9CeldBdkZFR250NmJTaVpNL0pxenI1L3E5?=
 =?utf-8?B?bmZINU52U2h6Ym5xOGRQWEhqUjhnWEszRzRoWUU3ZEExNm1mL1NXSHpjQkpV?=
 =?utf-8?B?ZVVRMytUcDdRUW44VEtTWHdlbGpKSjA3d2NBWXJOdTlRcEcwNXRsNjdwcDZk?=
 =?utf-8?B?YW9IZUluRzJlZHJrM0x5WCtDbjE4eWR6Rkl5VzBkamhhaWhmeWp2SGw4MS84?=
 =?utf-8?B?WHQyRExlUlNEWnhLeDVUblQ2dUVwalBXUTFLYlI5U0ZaeDRLeDUzbTVadUc5?=
 =?utf-8?B?V1hwWG1ILzQ1eVhJcFhOUVlITzNndEtJT3VHZXhhQnZ0ZnZENEFkOXVaMVBx?=
 =?utf-8?B?MEliZzhwTUNYWUFSbzRoWmRpNmdnN1ZXbWZOc3R1Mm15Z2tHVTRHUnovcEU0?=
 =?utf-8?B?UEYrVVhJOFkxWW42Rzg0VHJMeGJyMTNRbkJHd2RHNkFjUVY2eE9SVXduZXov?=
 =?utf-8?B?Tmd3dHZuekNKK3RNbzVwZnlwTVVxVGxreTZabEN3Tjd3T2hCUmpvMmlaSVVj?=
 =?utf-8?B?QXhERDZrQXdnWFdleGJLVnY0YTBxU3l0bWhTaE5iQStJMWt4RTdnV0hwNmR6?=
 =?utf-8?B?QlN1STkxUHZiSmFTUnFwY1Jnd1dvSjdXNVZKTE5TYnZhRFpBZnhJbEZtOXpq?=
 =?utf-8?B?YmhnamFzY0NWNU1yTVVyd2lENytKRkROSVZjZmROWkNsUU5QbmZCeEJXcEVL?=
 =?utf-8?Q?DVZ/7St+cUs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elljdjhuU2JEdElTeWZQelBTMDZuTFZvNVVPNkxvVGlGdTVUT1RLS1U4QTBG?=
 =?utf-8?B?ZTg0bVhBalErTGF3UE1sclFyNXJFenhQZmY4eXdIcGp3OFFPekIwK0krUWI5?=
 =?utf-8?B?L3BHSS9BWEJZMUtGQy9TN2RtaDVpaFVMcW9HZ0J6UU9JbGhIeU9GMHlWL0wy?=
 =?utf-8?B?MEFUKyswZ3pBR3U1YS91RHdGb293MHBmbDFrSExMTTVHcTRNQVFLWjR0enRj?=
 =?utf-8?B?WUg3U2x1OHZaNVg5OENGeGQ4VDlwOEN6RnQyU2wwYWFCZTh5WTk3NHk1ZlBi?=
 =?utf-8?B?TWJJQytSWmkzbU8yN0xaQU0zeUdaMFRyZkhOaERxdVMvR1BtdHNhMGoyNWpJ?=
 =?utf-8?B?Ty9yNUNLV1BnQWxrU0xUdjBGRlg4VVlwTno2YnBUa0xSeHo5dzlqa0xCc0tk?=
 =?utf-8?B?SGlRL0NXY1FNeXkrZGkyWklVa2w0YjZiUFJ2RThVV3E3dnUwM2xCdTR3MGk5?=
 =?utf-8?B?SGhOWk5MWTRpWE9mekJ4NjZIdE82MU1MSjdvSWhyZnUyRzhsRktmajQ4VzRo?=
 =?utf-8?B?VUZzaWFuaFFBb3BjWmdDQTZTRXdWU2ZIaUpxYVlTU3poVHdCSlBjV2JQMjlZ?=
 =?utf-8?B?WXU5OUwrcFpBQnJyY0h0WDFBVXdDaC81UzhKc3dvVmZYVWVEemVIdXdFQVZp?=
 =?utf-8?B?S09EeUdYbENvOFNreEtRdkMvOWZKY29ad3oxSmxIUk5DaWFIU2NMOFZnZEZ3?=
 =?utf-8?B?cTkwS0VTemZyN1ZKaXRIT0Z6eVNETjJKMzY2eGNISDJkQk9kYm9LMVByeTRX?=
 =?utf-8?B?QnNiOFRLZHdDUzlZMFhRNGQwcjJEUExIOWJLOHVZQW40NmhmMU9FRURtbmdK?=
 =?utf-8?B?RXpWYy8rbDVWci95ZnFZN3VneEhXRklvcmswVUNRNEZxK3FFZnZpdUVvNVRs?=
 =?utf-8?B?TkxFSk9SczRWcDRYZWF5SmpQeENkRU9ENTZxUlpoWURhRmVhTkQ2djY3Tnpk?=
 =?utf-8?B?YUdLMFZFdUg2Sno5NjlmQUVuOTB1NjIrRUdvckJadWwxT0lHYUpadGJIYm83?=
 =?utf-8?B?dFBrRkRjcGxXTWovaERlRmZlSERJdHZUMnFuNExFREJySWFYQUUrYTNaRG14?=
 =?utf-8?B?OUl2UEdIZXpabEQ3R01mVzltU2N6TUxzRjA0QU56RmpOeDNWYWxjb2IvWVRF?=
 =?utf-8?B?OHV2MHFjRFJYbmY4RE9BalQ1czNUcGJmRmN1SVFIeHNLdDlrLzBzMkVWTGRj?=
 =?utf-8?B?T01MditrSlp4SmxvRlErczZ5a0xrY0NDRjhqZng3Z2YyVHc1R2NBaG5WRXJr?=
 =?utf-8?B?bVpKUGtRZ2xHSU9UVXFkcWYxUE4vSEtRL044enpCTmdxUTR5b2xoUXFJaVhs?=
 =?utf-8?B?VGNFRzBkZnpZWDJ3aGQ4ZGtuUGVqRkUrc1NvYlZtZk1tQjZWOG4yc2ttakRa?=
 =?utf-8?B?bGVYOTBvTnJ3Q3ZpTFV4VUt5NFp5ZGUwMTJuU291Z0pmOXA1SGNTbndKNXIw?=
 =?utf-8?B?NEZES0gyVDZMUzZndkYzNE1IcUI0by82Y1NFSmRHSUVJUHhRYXZ5V2RxQm05?=
 =?utf-8?B?dDExUUhieDJYMzlhVzBuK1lSVVdSdW9XUmd3YmtPS3dmMXB0VGs1dVBrMm9m?=
 =?utf-8?B?N2ZwczFqdjlJU0FJQmt5QUdZN3d2dXo3VnRMMjUxbnY4dUExdkhyR2k4NTFX?=
 =?utf-8?B?QXVvbEdXeWlxVk5HK0tVL282ZVlIdW9QNFFET0JHL2VMZ1BlRkE4V2ZBZ1lU?=
 =?utf-8?B?alNrUnNSTk0xSW9vWWtNTms1VmtBZnJ1MUhzTmpnTnZhdmNHY01HQVFlR2wv?=
 =?utf-8?B?Q2M3bWEvMVNQVVQ3Y08rNjFBMDI3YVFvOXNBTWlFeU54UmRsWWh1NThoamN5?=
 =?utf-8?B?aW4zTlhLeEFUYWtjWnhwUmlBU3RYVDdWcU9zOEVqUktiNERmUGNvRThVRHZ5?=
 =?utf-8?B?SEV2M0I0Q21HRit5cm1DVkNhd2pjSlJRSlZmTy9UQ2FqMVlsT1BWS0lVN09I?=
 =?utf-8?B?WHNJSjVaT2kvUVFhWmxKVE45RGdvY2E4V3RYRVJaVldMTkJWSkVzSksvZVZK?=
 =?utf-8?B?aU9EY0tvMlYxYXNPUnZaWVY5WXREUE53amc4a0xXYisvYnhwT1ZFOTgzYmRD?=
 =?utf-8?B?ZGxpVlo3U0p4MHN0UWk2Qy9ub2V1Q1ZoZnVRcU11ZlNldFlMOUlQcURZazhy?=
 =?utf-8?Q?3H6No5EUiBlOLSoOYwBStW6Uv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828faf3d-753d-40e3-a120-08dd921804aa
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 12:16:41.4318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/yoO/z0ZS7DnZ1Ui0DPz9g1wToDhEEehdRXQCjUB3FrrJDa6D4rlvFm5J4ksziDY0WhXpxCZBRm2PScMjS7Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9110

On 5/8/2025 4:10 PM, Sean Christopherson wrote:
> Use "mask" instead of a dedicated boolean to track whether or not there
> is at least one to-be-reset entry for the current slot+offset.  In the
> body of the loop, mask is zero only on the first iteration, i.e. !mask is
> equivalent to first_round.
> 
> Opportunstically combine the adjacent "if (mask)" statements into a single
> if-statement.
> 
> No function change intended.
> 
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

Thanks!

> ---
>   virt/kvm/dirty_ring.c | 60 +++++++++++++++++++++----------------------
>   1 file changed, 29 insertions(+), 31 deletions(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index a3434be8f00d..934828d729e5 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -121,7 +121,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   	u64 cur_offset, next_offset;
>   	unsigned long mask = 0;
>   	struct kvm_dirty_gfn *entry;
> -	bool first_round = true;
>   
>   	while (likely((*nr_entries_reset) < INT_MAX)) {
>   		if (signal_pending(current))
> @@ -141,42 +140,42 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   		ring->reset_index++;
>   		(*nr_entries_reset)++;
>   
> -		/*
> -		 * While the size of each ring is fixed, it's possible for the
> -		 * ring to be constantly re-dirtied/harvested while the reset
> -		 * is in-progress (the hard limit exists only to guard against
> -		 * wrapping the count into negative space).
> -		 */
> -		if (!first_round)
> +		if (mask) {
> +			/*
> +			 * While the size of each ring is fixed, it's possible
> +			 * for the ring to be constantly re-dirtied/harvested
> +			 * while the reset is in-progress (the hard limit exists
> +			 * only to guard against the count becoming negative).
> +			 */
>   			cond_resched();
>   
> -		/*
> -		 * Try to coalesce the reset operations when the guest is
> -		 * scanning pages in the same slot.
> -		 */
> -		if (!first_round && next_slot == cur_slot) {
> -			s64 delta = next_offset - cur_offset;
> +			/*
> +			 * Try to coalesce the reset operations when the guest
> +			 * is scanning pages in the same slot.
> +			 */
> +			if (next_slot == cur_slot) {
> +				s64 delta = next_offset - cur_offset;
>   
> -			if (delta >= 0 && delta < BITS_PER_LONG) {
> -				mask |= 1ull << delta;
> -				continue;
> -			}
> +				if (delta >= 0 && delta < BITS_PER_LONG) {
> +					mask |= 1ull << delta;
> +					continue;
> +				}
>   
> -			/* Backwards visit, careful about overflows!  */
> -			if (delta > -BITS_PER_LONG && delta < 0 &&
> -			    (mask << -delta >> -delta) == mask) {
> -				cur_offset = next_offset;
> -				mask = (mask << -delta) | 1;
> -				continue;
> +				/* Backwards visit, careful about overflows! */
> +				if (delta > -BITS_PER_LONG && delta < 0 &&
> +				(mask << -delta >> -delta) == mask) {
> +					cur_offset = next_offset;
> +					mask = (mask << -delta) | 1;
> +					continue;
> +				}
>   			}
> -		}
>   
> -		/*
> -		 * Reset the slot for all the harvested entries that have been
> -		 * gathered, but not yet fully processed.
> -		 */
> -		if (mask)
> +			/*
> +			 * Reset the slot for all the harvested entries that
> +			 * have been gathered, but not yet fully processed.
> +			 */
>   			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +		}
>   
>   		/*
>   		 * The current slot was reset or this is the first harvested
> @@ -185,7 +184,6 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   		cur_slot = next_slot;
>   		cur_offset = next_offset;
>   		mask = 1;
> -		first_round = false;
>   	}
>   
>   	/*


