Return-Path: <kvm+bounces-58192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC48EB8B414
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB7A7587D21
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689BF2C325D;
	Fri, 19 Sep 2025 20:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2irko/qJ"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E14274FEF
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 20:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315444; cv=fail; b=cwygQJ1mfTh8H7cCB+u5MO5+ajX2DVgjKR8wrZwhDRaZXnSxsnBzuNE73AnyzdJvuz/He1sldUHDnWWQCkv6Jq2mGftuJDnXuWYt+Au/kRf7KgEymElYvON9zz5v2866Crg8jnPVInghKm4Eta4hkiGf0WyMBtS7+hxbY2Bjn8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315444; c=relaxed/simple;
	bh=Jmoumf2KD+crYhiKvJwlD+BXeLWMnA8EIW/mlzhzWrk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mGO6qFbu1Yp5jWjJQ8u98skzDx94YCxCBy9MClBUyxf/kvEs0UjnyFXb+xHravrJyRRZ293l7a64q+RIa9yfEBGF/W+9NrvYbFeyIbIujirVgNC1cweu6jNnUyT8+TwbT/VetxhZQsf1cw+m0oKBcLl2p6f/4uS//CIT61p0iXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2irko/qJ; arc=fail smtp.client-ip=52.101.56.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y2GRlCHc1SpM5AkLa7zO0i2RiK6cSoUp0RmRIxm7AeVH4aXaW2OuRIRk39jc0DGDjt0+H5tMHpdVgA+h3XaWwHz4nVomSdlKLUhIoiiOEIwkBCh9m0GXcG3KwY9KVYDSILVlmIX3ApVXO94+F4/DaecLLRRKsVvLhiyDfOR0dBKeXxeYWG5j99JP9t4TvDyVzRFRJaIPOeno61CPOHn34NOQXI1s0GrDmcSKrY/Zu+G1Ut1/yDDsG/7/B0iEpB6pOAcbRHHHghuRf2AR1PDFBNZA/IUHo4R7Vc/FDYrvfIyR3p3au+yWZOVDq4a2eeTCpOtNiwpUOAWPndnvNIym4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPTGzBKEy2uq1lSBP/I6zT38rtuF/2tiOkAtmDomSno=;
 b=tcqoIbCj6sNW1eC0q+S+Rhx9ziVdWXrNcD5uoCfsgwpv4dQ90Wm27l7JhE13w2U0OaMCqU0UNRTvnDrO3L8M9RoL0CE4RvFK5xO5FjxOAnIZ0sjDPEP+OsmagVepRkA8viTf2pDL6RsowqW379qAa3zB5f2lJNr4T+ImDjNKFU17LooKjg3muT86QIsCbI6NZ4IMxvciozA8Vmm9GpCcmxnY/BaDuRlYYFYpmOKK1LEXKJKMuoZpuU4nG87s+R8N/+OiojBXZaEHJUGAvA6XE3XD9X5K98Q+8WzYRNJLdKE0kOXCkcTf/3Ao3dg6pVI5bj1A1SZh5P9y1eEtEpDueQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPTGzBKEy2uq1lSBP/I6zT38rtuF/2tiOkAtmDomSno=;
 b=2irko/qJf7vDYUKfrMbT2TtWWyy7T/4aZKMdu76HwEQ2kCNep4Pw9jjm7CXfQJFZJ9Yeqa/BC7KEjgzYUeKuEH1tF0AVL89Dwu+eWwxehNsl0hfecIAB3gSpIlVUgKbSDLhfS/XYIFbGlVJuWOdmrLqDjSIf+6sS8TL03iEbdww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB6959.namprd12.prod.outlook.com (2603:10b6:806:261::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 20:57:19 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 20:57:19 +0000
Message-ID: <b8b395aa-29de-4271-b0e8-0669c7e97b3a@amd.com>
Date: Fri, 19 Sep 2025 15:57:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] target/i386: SEV: Consolidate SEV feature validation
 to common init path
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 Nikunj A Dadhania <nikunj@amd.com>, "Daniel P. Berrange"
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758189463.git.naveen@kernel.org>
 <eba12d94afd504ff87d25b9426a4a4e74c3a0c70.1758189463.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <eba12d94afd504ff87d25b9426a4a4e74c3a0c70.1758189463.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::33) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: a72cb013-1d44-4916-957a-08ddf7bf1ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0tXdm1QUWxFUDVVWStCckx5Nk9RejhDR3l6cjF1akJqdG5ER3VTYjJvWmlR?=
 =?utf-8?B?c1ZvVk96R3IrUWpNc2pkR2pwT1VkQ2pYUWMwV3NlRnlSMzlBRVA2aHBGQjBn?=
 =?utf-8?B?OWhVV0RYUUwzdUJTQ1FpWXY5SHJKeitOc0I3anVvbHgzUk9CUUNLTzNtVGV4?=
 =?utf-8?B?bVJCZS8wcWFLV05yU0wzVjRkWVNMamZxMFRVQTRaTFg3b2RtbThjQzUrOHdS?=
 =?utf-8?B?RE9ocXpqV1RSSmZ5dHVla05jU1VzaklTamUzVlBacUdZcUtsSm9DZnZheWFU?=
 =?utf-8?B?VnVLWjlmT3NNcEV0aWZkNk80QWNQRjk1Ukx3VEZlRDZPNUtWaFRoRVBVd0gr?=
 =?utf-8?B?TFkrek4zMWpUckx3c1BVN0cwcFlkSGs4U25GSk40WlY0MzRCOWFnT2FzQ2pS?=
 =?utf-8?B?Z21BVnNLYUV2cE1YYUpmK2E0WFZDNmNWblJBMWxEbkxrd0tJYzd3SU9sZy9F?=
 =?utf-8?B?TkhmRCs3cjBZUzJrdGNrQng5QS9vUThzbVgxemxDNmYrUVBIZjVXOG5ISHVO?=
 =?utf-8?B?ZzFlWStMNi9NMkwwdkQ4cnlxNHpBaUFrRFFVT3NsMWtUQXhvWnp1WnQ3SnNS?=
 =?utf-8?B?S1o3Wk9hNWl1RDRBemQrcDl3cTczemNrYUp3d2RsS09JL3V4THhkSnI0akVT?=
 =?utf-8?B?UGdOY0JmTFh5Z2hiUFRacjlvdjA2Rm84Q0ZWZmRadUNCMFppYXZNanVqK3Ex?=
 =?utf-8?B?KzVRc3hWN3czUmNNZ1JsWHcwZXRzazlwWEcwOHUwNU1wZ2NNUUg4OG9aMW9P?=
 =?utf-8?B?dU0wS2NDUU9qVnFNZW5reFBhMEtvaEVIWHZsR0pzOGF5ek1oY0tFbEF0d2ZJ?=
 =?utf-8?B?ZzB1WE1seldpY2VNbHlxd2xXUW1yNFJ1T0M5ZWpVOU1HYko1bndrTlkwSGkw?=
 =?utf-8?B?VVY0aVNhT1Frb1N3Qi8yYlN6OWE1NFp4VmxZUndraDJteGtUUEduSzMwc09M?=
 =?utf-8?B?dlhRNzc1anp5cnNTM2U2NnJ3SXJPd0FKRjFvVXk5NytBckZEOUpNMXl6ckpS?=
 =?utf-8?B?bm9OeEZ3S1NMbG1EY3FvQWV4VDBMSE90YklKSVZtWFd4MlFNampOUldNb0ZE?=
 =?utf-8?B?bkRody9JTzIrMEh2OHFvaVo2UTI4cnpwcU1RSlRrVUZXekcwclZMbzNPMWdN?=
 =?utf-8?B?Vkx6SFFQRXJ5V2VHclE2WmxDQ0xSRFFYSkpiNHZzcU9aSFFuajFqcUpnUWpp?=
 =?utf-8?B?NjY5Z0J2cm04WUZPeEhBUTU4RXk0emsrV1l1d2FoTnhwdDJaQjJkK2xLdkxI?=
 =?utf-8?B?OU5mL0k4M3NaT09nMnFHOVJ0T0pUWDNoWE0vNjJVUWVtVG1JWFJrN1B4b1pD?=
 =?utf-8?B?WGFlcUdXRDdMU1R6ZVU2ampycWhlQzdXRUFCMHlyWml3QTQ1czhJSFdEYnFK?=
 =?utf-8?B?c3UyTEZWN3ZNWjJvcWdGeWpCcHhkUm1Sckpha1FURXI0V3dsVjJzdUlJRjZm?=
 =?utf-8?B?azlhM1Foa281WndYWExZcVJaQ3VZTlBWVmd3VVltWEgwNDRwS1JFZEQ4LzUz?=
 =?utf-8?B?ZnRMbnF1cFpGNThjNzZwRXZxMUJ1RzJTOEZsTDhkOEwreWIvMEZRM1JVZmlD?=
 =?utf-8?B?NFhzaFRYUU0rbzdURzJEYjlPSjlRVHppOERsR2g3aFk3R2JDVUYwaVc5WXRy?=
 =?utf-8?B?dnh3bmg2OVIwMGdxK2hOcUg3dWFhV200Y2EwcStndXBIZ1lPenZiZ1VyQ0RN?=
 =?utf-8?B?YWVXVkhkQnFWd3lpV2tPbnF3ZWNubEVGYm1GUWRRMVVJKzhUU1UxaUc3aGVP?=
 =?utf-8?B?Q3Z6ZU5pNlh6azZiWnk3cjlPN28vM1R1cGJSYXNPQ1RwazdqbGVHYjluckhv?=
 =?utf-8?B?TWM1Zk5pRjE5UDZJVFkwU1RVclJqSE84V0dlYlZhTTNGNHIzWVgwNXNLZGFH?=
 =?utf-8?B?ME1lbzZEU2ptVUJkNjU4dmFvMlVCSVhtcmVtTUJXOEo2bm5CSGNUck9Kcy9Y?=
 =?utf-8?Q?MmCgkz8/ZWc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3M4U2JDZGNEYXJqMDZTR2lNelRySmFEeVlKZjZKVzZOT0hyNzNIYVJjTksz?=
 =?utf-8?B?M2dId0VBNVI5OStyVlhhWlN5Y2ZGSGtLUWZtOHBsc002L0VqVjNPTXJ2bllL?=
 =?utf-8?B?dXp3OGVMa0JpTGQyWk5DZisxNnF0RGpwcEV6T3V1UzdoL0U4N2Jmbzh2RjVr?=
 =?utf-8?B?SGJhYXRQWWlZRVE1bkhEb2hjTXkvQjdUcG5oT2FrQ1dNdXVVYkxLVzZTQ1px?=
 =?utf-8?B?dGhISkxKV0hoQndNL1Zna1hqNmp1Q1VxU0JXcVhhVGRLMTZsSVU4a210cUp4?=
 =?utf-8?B?QjBLV0MwaU5TY1gwaURpVjkwN3RlbHpRV1hqNkpGaE5sa1lUY1FQNHhnSjlP?=
 =?utf-8?B?U3MxMjF5dUVORFBKY1RERlE0MjVLTUxTbzlJK1RORkJGa1pmVndnZmNkeXBH?=
 =?utf-8?B?c0Z4RFZFOUNFT2xSbXp5dDU4cHdMdUExelZ5OUNheCs2SkRTSTFTZnlwVnIz?=
 =?utf-8?B?VUhNSFhSL1lwWmViMUlDNWNVYjBKMVBvRG82TW56YVorN3U2K3ZzeFM1WjRs?=
 =?utf-8?B?Ry8xZm1KbTM5REc1dkV5YlNVTE9LT0liaWl1aWdrTTBFTDdJRjBTYUZSM2Vl?=
 =?utf-8?B?YWp5UlNBVEtNeFZVclI1VzI1WXhsaXU1ZUpkOTJadjg3b1JIYmdFYlVwWXdo?=
 =?utf-8?B?eWp5QVQ2SmYzU3J4U1A4WFg0NU9OWHB0amI5VWcrd21jTnpub1BRM21pbGNI?=
 =?utf-8?B?c3UyNzlnMU5neGp2WThCa01nMzNVb0d5WmZBQUdwNGU3SjhQc00za0xONnpp?=
 =?utf-8?B?V0FrcyttMWMzdWJQR3hweTY0NGl5RVpEdTkza0F1M3lienlQK0NMbi9PNVQz?=
 =?utf-8?B?VFFER1ZtL3NhTWx3S0xDL1l5Zk5UNWVDY1dtY3dBNmphQmI4SDJrWVhPMDFu?=
 =?utf-8?B?Q0RrMzcyRDFhVUFOMWM4aXBHaGJVQ1JiSjFsRk9JeVg5MGU0bnA5QzMvRTdR?=
 =?utf-8?B?ZHhzWWNVRTg4bTBWYlU2ZWlXVUFkajhqQytrRFpVZjQrckRSZWdWUk82UVd1?=
 =?utf-8?B?bUZrNDlyaHhPQW5DVGNRQkp0SjJuS1hJRThqZi9hUThoTElTZzcxQi9SVUVC?=
 =?utf-8?B?NjBjZXpLOWpJeUNEcFlYdjJyOTdVWTcvS2dpM2Z6TmVwellJbXlwYlZQKzEy?=
 =?utf-8?B?Z0xQRitjbER5UmxWMnlHamtOMFZnQXliSnlYVTZHbzhoR1ExcVZhb2hLb0lp?=
 =?utf-8?B?R29WZ1dFWDdhSklRUkxPSWY2NlVSSDB3RFFEU0JtNlBrK2lmcFZDMWxQL0g0?=
 =?utf-8?B?OUxmNXBKZi9mZ2U4NHU2K0hYNHhXRVpkcWl6NTFmc2NuNnhIYkFnYndEMUJU?=
 =?utf-8?B?MDNSd0lrakJYY3Bwd1liK3dJazJydHVDZ2tEb0dWaE93b3U5Z0pFMVdGSjJF?=
 =?utf-8?B?T1pydzdDOEJtMzdUNU1sTnZWZERKY0dVc2M1bkRoTDhuYlFqZE1KMW5IWStQ?=
 =?utf-8?B?Tm1Oa1NlQ3Z1MnR0MUEzZEVDTmxsWXd2bXBMVVRCcUFCQjEzNEpaTFpCZGNu?=
 =?utf-8?B?VjBmakhkSm5KSDBYRjBpeU5vYnhtY25hRjZNeUltdGRpU2tlNXhMZHp0c1Zm?=
 =?utf-8?B?TC9LQW5VWGtESFpxZnFxNXhVSVF6Uk9nWFl5c0NzemNRWVVML2dValY1QTY5?=
 =?utf-8?B?Tm11Y2tJUmZRUEFuUGxWcUpQajNpRmRxUWs4MGUvMWdoYitmWnFRYnVEU2Fm?=
 =?utf-8?B?UEo5UlJXM0NzaW81K24za0FUTHRmUnJBYTc4TGhUTHBHalpEamI2YWlEVFdx?=
 =?utf-8?B?YVdWeklSOGFOendTRThMaVA2OHdHZHk4YzkvRW1weEgzcFJ2RHRJTlRBNkQy?=
 =?utf-8?B?K1VTdXdBbm9OUExCanN0VThYSCtRRXg3VXlRQ2dreXNuaStlWG5BUnVsQnl4?=
 =?utf-8?B?RXViMStLajJQeE8wMzNaR2xCUC8zNllTV1B6ZzYvZ2RKZ0E4S2NEOWxoTm1m?=
 =?utf-8?B?MnZZS0lxSHRTdGJydEw0Rlp6OFVaTXN1aEo2UmI2bnRZOERtME02WGdhaDlY?=
 =?utf-8?B?RUtpcVcrR2x1KzdJRkQ5VCsyNUdTR0VQclkxS0N1a2NPbVYrYVI4WnZVK0Rt?=
 =?utf-8?B?Q3lOUldUR1VLczZmSlYySEpBZVJBd0VVRFZ6NFZYWUEwemlqd0FUVjAyL1Iy?=
 =?utf-8?Q?Thi9ztrT0ijlwmbZZyt8d4HiR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a72cb013-1d44-4916-957a-08ddf7bf1ee4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 20:57:18.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: grLYVNc/yJkjg5vk8SJQuWGWzsmY3eKxB30/2j/kUSM1UnYbcEy4oA6XVIS5xSUqXxcyinRM7VKfRZox1yjgmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6959

On 9/18/25 05:27, Naveen N Rao (AMD) wrote:
> Currently, check_sev_features() is called in multiple places when
> processing IGVM files: both when processing the initial VMSA SEV
> features from IGVM, as well as when validating the full contents of the
> VMSA. Move this to a single point in sev_common_kvm_init() to simplify
> the flow, as well as to re-use this function when VMSA SEV features are
> being set without using IGVM files.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

Looks reasonable.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  target/i386/sev.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index c4011a6f2ef7..7c4cd1146b9a 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -595,9 +595,6 @@ static int check_vmsa_supported(SevCommonState *sev_common, hwaddr gpa,
>      vmsa_check.x87_fcw = 0;
>      vmsa_check.mxcsr = 0;
>  
> -    if (check_sev_features(sev_common, vmsa_check.sev_features, errp) < 0) {
> -        return -1;
> -    }
>      vmsa_check.sev_features = 0;
>  
>      if (!buffer_is_zero(&vmsa_check, sizeof(vmsa_check))) {
> @@ -1913,6 +1910,10 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>              }
>          }
>  
> +        if (check_sev_features(sev_common, sev_common->sev_features, errp) < 0) {
> +            return -1;
> +        }
> +
>          /*
>           * KVM maintains a bitmask of allowed sev_features. This does not
>           * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
> @@ -2532,9 +2533,6 @@ static int cgs_set_guest_state(hwaddr gpa, uint8_t *ptr, uint64_t len,
>                             __func__);
>                  return -1;
>              }
> -            if (check_sev_features(sev_common, sa->sev_features, errp) < 0) {
> -                return -1;
> -            }
>              sev_common->sev_features = sa->sev_features;
>          }
>          return 0;


