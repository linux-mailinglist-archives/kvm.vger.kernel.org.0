Return-Path: <kvm+bounces-23473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D460C949F44
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 07:42:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FB7CB24C36
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 05:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9E919309B;
	Wed,  7 Aug 2024 05:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1msNMnI3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2049.outbound.protection.outlook.com [40.107.96.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D50193071;
	Wed,  7 Aug 2024 05:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723009343; cv=fail; b=UqgkYQ6hmwWIcOOOrAPVKlml7tR3FCgPf8ByX03CrxRCK/YKvGOjZBKoGyRrBC8STkOZl2zMcXhoJPd5QnIH+5rvInuL+yHVb/EvURpYTyt1SlvPWvnOpcUpb5pK+ni++2nLzkSstrm3KzT83UTZmcY3WIgtcGeNa2Zjllz9ZqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723009343; c=relaxed/simple;
	bh=vqsBMfkBMrp/mfoaaiZBxl/3w87h/rbiDT/W/Gy8Z+0=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ODqPxXJuT5lqHvNwAjHQEidavqsReFW7eCnsS6/eHFQMZFSolYOqjz1jfZODXpXu2r5aYhDwKVycoCbN+oIhnCAp3htgsJzg6ICgqva2US809opKj9IItmOTKQFF40nwm+iY77V/fIsp57jrnKh3dOhe6FMR79ZEJzWsBak1ZRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1msNMnI3; arc=fail smtp.client-ip=40.107.96.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPy2DjMbWoGyLuEuBO1+eYstuHpfuXIKsZm3yDBM6RKVAAJJG5LiDpmt+0VTMxRJVT24u7ZggKymq8Zjsc3fGQOanVCkNmgO8+ihFhV3ZlubnO23OCxzTykCEVCVt7KE/htYD5f/OCXs4Su0M72SU77XSdsqOFXP/tCIV8HLyYNDk+P3pf5In2Z+tJtkjtxpOs5BdRciq+x/LSZQ14Rn7SEoD4YJfOM1LB8tYOnvve1NZyF29m0g2KRBsu4ArVxrHBGiQrdXAtqhPNegNwZYZlY0CfD4HcfX3+aZerdwc/MLOYOa32h65adyEzjgsOhNoY8O7t9d4FtaIdXkyvL+sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpPAMRlfvp9VzTp1w0wIIzfG24VXcmThxuQF4IWV1NQ=;
 b=Zo5zkj36dqITaSuZv0GR8Xc5oLuw2c7tPCOalCcmTbMnAQoe/xR5Id+VWgsKqVIsMpO3lHzaTEBasO6xPb0rMTsLn9Ex+GNN2yQd+2DQsOmRWHWYRpuPg1vVEXGIB9WFLcDUXqhL4qNe7gDYrhXZ/IEbI+d78rw4dwYHSh7NU8b0NBLnQk+7y49jqQt3tTuWy42NWdPSOj6pNTBLzGV86UKrnPbqoN2jXO70jQpKCpTKE3+AMe8yZ1yHX1xkx4Rg9jxkL6lQiQHXCRfKLuxXpEW7thOZlQVCMXqZnxJhQBchhr+DrMb30kyOmrUFXtTIEGhFxhETWXxsxq44ajZ5mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpPAMRlfvp9VzTp1w0wIIzfG24VXcmThxuQF4IWV1NQ=;
 b=1msNMnI3L2h56DYbwERYBgXrOOcnbPgNZBc92qJMm1wb+7itUKnk3qwB7xJ/0yZA2VirkVRiYmvKyEC2JY+wZIz+y0U+8oVbYNCxOvHPiO/Z7C+b6MuPYmQNiLIR5y9JVcgL2i1GqoPYq1LdsJR1gksGwyIo1vXFRDivGASCa1w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by IA1PR12MB6113.namprd12.prod.outlook.com (2603:10b6:208:3eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30; Wed, 7 Aug
 2024 05:42:19 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 05:42:19 +0000
Message-ID: <ee91fb42-7a06-4082-80af-9bd1401e06be@amd.com>
Date: Wed, 7 Aug 2024 11:12:03 +0530
User-Agent: Mozilla Thunderbird
From: Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH v3 1/4] x86/split_lock: Move Split and Bus lock code to a
 dedicated file
To: Tom Lendacky <thomas.lendacky@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com, jmattson@google.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com, Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240806125442.1603-1-ravi.bangoria@amd.com>
 <20240806125442.1603-2-ravi.bangoria@amd.com>
 <878cae8c-4da1-ca80-7215-24cdcb80474a@amd.com>
Content-Language: en-US
In-Reply-To: <878cae8c-4da1-ca80-7215-24cdcb80474a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0134.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::22) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|IA1PR12MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 09216777-0d53-4d08-6b23-08dcb6a3b38d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VWpQYzhJY0s0ODBFUzRMV3U0TWlCNU9EYWQ2dGRabjBmbUkxM3h4TTNMT2ly?=
 =?utf-8?B?Q3Z2RW4yZnRwRmwwbTB4UjEyOHA5VGFCcnFkTmw4cEdxRXpkWG9XSG1CODMr?=
 =?utf-8?B?VWVJQ2lmclV3ZDlhaGthMWVmelI1MTJDbjZ6UzBxYk5tQm5ZbUd2em9JeDl3?=
 =?utf-8?B?NGxhTTZvcDJJYlpCeVRHSnd4U1NGWWxHNHFZeklZZXowSGlFZTd4VlNydDV3?=
 =?utf-8?B?V2VqUi9vYU1KeG4xbmVmM3Z5Tll2b3NKRHA1TG8yeXU1Q1VEYjdwc0pZaXhD?=
 =?utf-8?B?a1lJSktaZTUwdWNlU0tXcXpzVitpNmlPSWs2dnBNTnloY3ZLSmp5TDhVNDJH?=
 =?utf-8?B?eTAzRDFGWmw1QnpleC81SDg3bEQzeldabVA0cFlpOWkwUzRydGFMd0k2THlt?=
 =?utf-8?B?bmwyNEd1RXErRnlueEhvN3RaVzZ1WHE0S3JiZkxIQnEyZEhJOTFnQ1l1L0hW?=
 =?utf-8?B?NXMxYXVMN0JnbzByNGhnOFMwZ1NKOGNjU1JxTkhnUEptVUtUTGoxOVI3RlFR?=
 =?utf-8?B?bUxmTEI3TmNCTUxvTlVtYTB5UzdUWmhIL1NHSWxENFlFVEhaSno1VjZ3NHZG?=
 =?utf-8?B?aHdaOVZRaTRaS2ZRUW9mN0I0MnVqZWE3RWJxdHFNVElXOFBWcnIxZy9kQnRm?=
 =?utf-8?B?Yy9qQ1VLNktCck1PL1oyTkZUb013MmJORzlHVE83Y2cvaTFyVjBVUGlTQlJy?=
 =?utf-8?B?SlpMOWVlQk5wbHBBaHlVZVZVMjlwQnAydU5sRnJrVHFhazVqT3czY2tQUEd3?=
 =?utf-8?B?UVo3V0Jub01IL1VqSkxtaTYza283c3pOVGwvalJXNmUrazd6eHR6MzJPMDlP?=
 =?utf-8?B?RUN4VUdzZlNTc1RqOWt6YzVOSzYza2xZdzRUNXZLakp0S0RBQXh2cnFlc0g2?=
 =?utf-8?B?Wjl3MW9SREEwSzNTNDluYnp0ZmkzUi91OFYwdllrNVhiUVphUWZZV0hQaEZG?=
 =?utf-8?B?UXJycFo3eWhHWFZXNWhmVmlmejIvaUE4TEl4UGZLLzV2VUdZbjB0K2E2VjhN?=
 =?utf-8?B?WTZjTC91eEE3Rk5jaHlPV25uOXhGMG9US00wN2tGYmJRT0RGUlhtMnh2ZjhQ?=
 =?utf-8?B?ek5KWHJtVytzM054dm1WeVJ6czBROFowYnF1N1dka3duSWpJTlZDejdvOWwx?=
 =?utf-8?B?cUJ1MlFSWWdtQkxhOTN1NmZkcGNLZVNGaFdJQXBMUFZHdnlHMEZ3NDNQeGFH?=
 =?utf-8?B?OWR6RUlGdnA5RFlzUyt2blF6WDVqQTdKNXhxTkV6REVUd1ZyczREZ2lIQU5H?=
 =?utf-8?B?MmVsZ2Z2K3ZGWmU1SDNZcVJyY0NpampuTWdBbk9BUS81dGRpUWE1a0s2b2tu?=
 =?utf-8?B?dWFDZDhTSzVlbmsvOVdXdEJlWDhqNFR4dmphejdkcXk2R0M5bWsrZkhNVVdV?=
 =?utf-8?B?QXNDS3FNRVQxQytZd2RxYWsyK1pjQUt2VVltZFZtR09tQmNwMEt0WGJsY2la?=
 =?utf-8?B?dG1FWFJuZmVBRGs5dGhZbzg1ajA3YlpkSmJDUjduM1RHMFFOVzZEcE84WWps?=
 =?utf-8?B?UVJLamt3VDlQc0VVcklodVdoUG5WVC9abzJLVmtnWkNWZVQzdG9RY1pnVWo1?=
 =?utf-8?B?WUJiTjJ6c0Z1N1hFR3pydStRclRkUmRkRVF4UnpyUWtUUnM3UHJQK2lvUkM2?=
 =?utf-8?B?VlVWemExOVJ2Ym5wQXBNUVJ1MTVOSnNsc2JNVjNnSmJMUm5qa005WjJSUkRG?=
 =?utf-8?B?NWhzNG1mL3FMdTRJNXV1ZE5ZemI4anJxNW9NK1pvS0NaQVJOY0xDUGNPTzYr?=
 =?utf-8?B?OHdDLzQ0Ynh3bG5zM0xORU1sUW9acHEyU0JHMENGanlJQ2xTTTJFYi9xeVVR?=
 =?utf-8?B?ek1pd0swa0dVbmk2aWJ3dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUtuWmZURTdjN2JRcWFjbE4ydE16M3RrNVVyMk81NURUai9vbEJDOExUMnBG?=
 =?utf-8?B?QzFVWUZpcUo3VjFUeEh5Vk44ZHhJamVUUHM1VEV6WUliQkR4TWxueEJPdER1?=
 =?utf-8?B?Z0hHeFUyM2lhTmRPbnNDRDlSdzRRb0cvejB5VWlTQytLamw2cTRReE9mZ2Ja?=
 =?utf-8?B?bU5CbkZ6RkFDL3JoMytOZmVZK0FROU9MUTJMQW5qbWpFMkRuQy9wYjE4WnRV?=
 =?utf-8?B?K2x6S0Zrb0ZpbWJyd1R4ZEJOeFYvMmdqNkFUdGl3TzdueTJBaG1kU3BJVkJJ?=
 =?utf-8?B?T0dLZ0lRNTFUbE5oWlhHU0c0TmRYWFR1QzRCcUF1ak80RHpYdTVFblpSSVlv?=
 =?utf-8?B?b1VMYXhWb1NzZDAvZkoxZlJwUFpOUXdWQzhTd3dIaEFlMTVyYkZUenNFajRl?=
 =?utf-8?B?ZkZqdXdJSnY2dGxYTFByb0JMRXk2bXM2MFJMOGZqcEtnVjduS05TYWpIU1Y5?=
 =?utf-8?B?bHd0Tmd5dUE4UHZ5aEVsRlpUbmdCdFBpM0FMZ013bjZKMjFRQkN5SSs4UjRh?=
 =?utf-8?B?eHU0Q09HNmF1U3dZeWhpZ2RXbnlSZHFHYXFPMlNmVm55MklsZW8xSUFWNTdP?=
 =?utf-8?B?SzBVbHkvdlUrc0JYMmxWYVA1VmF3Ym91QjJoS251cm5uYXdYWktidGt6YkhO?=
 =?utf-8?B?QmlkNU5hbDFFdmpkL0NnSDZTYzA2RlNzOERnbms2ZnJOeXN6OUhqUnQrWmdh?=
 =?utf-8?B?SEZlMmRxUG5HSWE3ZmdVbnlBZHNrNk1oZ0V5VXNCSS9Qem4vZkdwalBCU29Y?=
 =?utf-8?B?Zy9DVmJ5Nmg5UUpRa2JmUXpLUGl1VTVOVFFlalJ6RVpheHhnSWxmNERFdFR5?=
 =?utf-8?B?MXVjbjU0SzdEUzBOMmhKSXpEejd6UDM1SStVaWt4U0NTSWVVTmNRVSs5enBw?=
 =?utf-8?B?ejNJTjY2QWxLZVZVMHliK2I2SC90dEZNeG40Y1lEdUkvT1VhQmtmN3hvNU9o?=
 =?utf-8?B?SU4xTEdvV2ZWY3BQVGhnRWtQZ2ZnWGNuVUdIV01BRGV1K1IvK1pDeXpXUUwr?=
 =?utf-8?B?eENudktIWndpY1ZWSWI5TzA0WTBaUlNnRUN3VEp4dCtSK0Y1SDNFS3pIaGpW?=
 =?utf-8?B?N2Vqd0QwVnY0dWdHZzB3VU53Vms0WjR3dmNBYUNvdm5vbStMNnJrbFFzNWVk?=
 =?utf-8?B?Y0JlSDRKaldHQTdxVzgxV3g3aVhWZXMxa3JnLzZaTjVWRmY3RjYwUFJybkVM?=
 =?utf-8?B?RHdZTGU1OWhyY0QzQXNsUFE0UDEwTXFlcjNPVDIxeVRTOGdmUjBPaURYamhT?=
 =?utf-8?B?b3FlZ1dmaW96TDhqTXBJTkJkM1pNUEszNWtEYnZiejlCTkU4a2t5ZUszaHRk?=
 =?utf-8?B?ZE4zZ3lRUGcrZnFyMnRMdG9uV0J2QVRycEp2YVUzNFY2QkNISGJMZFEvUWZw?=
 =?utf-8?B?cTFBS1R2aEpjbTcvNTNGbmpRalFNTHQrc01BTFY4SXdkUGo0anlvd3UzeDlr?=
 =?utf-8?B?ZU1ZSHNmSEJyTStNQlkxbnJjQ1krcnk1QnI5Z0oyMWNNaXJSVWs3ZTdwT1VT?=
 =?utf-8?B?WFFnVXFnR3F6TVBtVjQ2SGhheFBWcGovczQ0WTBxWnh2SncxeTZ3MUlpZTBH?=
 =?utf-8?B?S3lESS90VW5nTXQ0aDNLQ0MvTjA1VmEyaDB0NlArR292UTNOVHprNW93MVAw?=
 =?utf-8?B?L2kwRW9keGZWMTJNaG03N29ySGljOEVibUtVYmo4d2dTVzdzMEhUbzRDNFFT?=
 =?utf-8?B?Qm1uK3dIRkgzeGQ4bXFucW8zN3ROUExtVVJEU082T3RpaXl6VWhxUnhhUkFV?=
 =?utf-8?B?amh4Y2NGMGFDOXRnd1lRNk9LY0JlTldURFNGV0l0TGtSK1hiYTJLUWJ6dVZN?=
 =?utf-8?B?UWpEczg3bSt4U3Z6UEdDN0Q1YTZRQmRFaHd4TDBlTElqNUtYdk9hSHRvekpG?=
 =?utf-8?B?cG9vU3lUcFJuaHRsdUtvWG80ZFFzN01MNGwxSnBQV3lJYTdyNmJoT2g0MElL?=
 =?utf-8?B?cSs5c29OQjVzRXI2b0QrVWtVRDExRnpXRGdHdlZhMmV5a0tzUnZPdTVwclZK?=
 =?utf-8?B?SXN4Qi85QkRyQWZzcm04RWxPaHpTc0hzb1I5ek1xSXZDbjlPbVpWOGllQXRC?=
 =?utf-8?B?UDYrVnFnd2VLYkhVT3l6dzRNRUR6MXF4b3JFa0Z3N2N6aEo2bUJYb3ErbzEx?=
 =?utf-8?Q?PVRwcE8KYs6qcSDlm0+TN5kFD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09216777-0d53-4d08-6b23-08dcb6a3b38d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 05:42:19.1213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7w7tOPYeSQ5FdN3f8299Atb2J8VBEBf9bbYlu1nUC/mH2KJXqmDOou044fZKlI5jBn6H7oUNSdhymISQVTPN2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6113

>> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
>> index 5857a0f5d514..9f74e0011f01 100644
>> --- a/arch/x86/kernel/cpu/Makefile
>> +++ b/arch/x86/kernel/cpu/Makefile
>> @@ -27,6 +27,7 @@ obj-y			+= aperfmperf.o
>>  obj-y			+= cpuid-deps.o
>>  obj-y			+= umwait.o
>>  obj-y 			+= capflags.o powerflags.o
>> +obj-y			+= bus_lock.o
> 
> Since the whole file is protected by a "#if defined", why not just use
> that here and conditionally build it?
> 
> You could also create a Kconfig that is set when CPU_SUP_INTEL is
> selected and, later when CPU_SUP_AMD is selected, and use that
> (CONFIG_X86_BUS_LOCK or such).

New CONFIG seems like a better option. Will respin with that.

Thanks for the review,
Ravi

