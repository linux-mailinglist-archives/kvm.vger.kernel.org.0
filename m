Return-Path: <kvm+bounces-24332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC87953D40
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 00:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8CAB1C21BE7
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 22:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FED415531A;
	Thu, 15 Aug 2024 22:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N689XOrl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E716F1547FB;
	Thu, 15 Aug 2024 22:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723760191; cv=fail; b=DcCH/lufcp9dn1KWuCbQAbpGHX8kVewLf1f335s88RQLxz+TC4/VbCwa2qjGR4qb/UdRO7VhQauaKeE0ivWRgcfIEZTYIMSLa1mIR+vqssXLbZFJ/062It8786P/4RiPe4qaBQS3zPHLaugp9pR1ikxN4TAeBF56J+editFMYg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723760191; c=relaxed/simple;
	bh=LH+/iO+q1DcTpyZydpiL/6uFAN0Cfra/XuTpmuqW298=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Omv9ZnwKrVUZGu89bxQyqjc2cWk792xeRkV4/xdhJwW/J5fvGjGj772s1TfhaSZMTa7Y8xF+oVDWZuXKUVc/xSYqe59nMQ3yxPS9+ZSnVpKgX10FDnHmspwjgwLUKMIch0qfku0+vZ+fSeUwCFnCJP7hlGhNkGYphlJQGnqSgak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N689XOrl; arc=fail smtp.client-ip=40.107.244.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WaUx7Qa2IH5znjZPU54O0Iqsm3/72Lmj9A116w4ObW3XTjd0GkRIsu7MQCLpa1ydMOa5vMbQ10HIAZVJbvHsUAm0RddxplEeqjsS0QPib4jbdRZhg9oeT9+JCctAoX0gO5BRe3mb/v+THuiOKj8mXk6wz31nxb1K9UposVoD+mFdbW947moswP3m2tr9P/72jNk+Q8cVjTfUaQ4JXOItxHlanvGPzJHKamx79/ZjXC4n5AFYOgFzOqkBWb/qkC+NZM5AMZblDIuOdnqazWVdnfewuMyiHhhA2DjicpQ2/Il5SALe6LDGlCzc6iy4peU0a+IYe2sf07UV7HaR4+AfYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=riXmhHj/+Ud+jiPO8Fu+HFIo6rHq2pTfLsGPBye3r44=;
 b=rNbOqh72WbZKpYY8K1QHcs3O2Zm48ALaqE69oSBEi5FACWcVEvhL9a+yXPBe3a7lqgdQ3vra7CmC0Exs2IY1o/UluVReOh8XpDExJBgAcyc17foy7QgoFb5vce7I6V+mEez6qOnCzDmn1T2otfcRulzKR+J2SZK6Mj6Bq9RDZ1BABmikUQrLoTmcdowr8L8OxSZmo0yHjYBZnkkAGhE1/dSnTSitth3a8VjqYIBKGU6LSEsrt+/N04jCx3/+H5hl2xJK0k90a086CpxNft9kt3DitkJs74TwOz0JDCFr8CKKD4ROjO1Z+ZhXpMFnMRnMgXJTRuaC7WfIFjI/n25hcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riXmhHj/+Ud+jiPO8Fu+HFIo6rHq2pTfLsGPBye3r44=;
 b=N689XOrlNP8Ut/Gsf+MBO2NlrMNgVRncamapzl8y7whLUHGajveCoX+q+4cO6RKXjI2c+YjpjGxf/M9NMomvvIYrLC6Hn4G6IyX/7mKBvewBP9OgJ0Pyf11QTlWaN2Oao+tRehgfxiPDNZdCtS4sRB8iwVpnvcD4syvfzHrYVbAdeMLPOWA4sON1drqBVzXY8++Y4xFdY7g8S6E7ARfjxvyEAZEO0rz4+hQiEF6l98ccWgQHVZp7dSWBpXRrfk7LsVqP+uTNyoJaz89clBBa1y9D1aIYv7WjeH8h3HzZgSp49ATjeK5Ff9+UFgANFoJXPaL68P3E7kVidhdV5fiIxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8194.namprd12.prod.outlook.com (2603:10b6:930:76::5)
 by PH0PR12MB5677.namprd12.prod.outlook.com (2603:10b6:510:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Thu, 15 Aug
 2024 22:16:26 +0000
Received: from CY8PR12MB8194.namprd12.prod.outlook.com
 ([fe80::82b9:9338:947f:fc9]) by CY8PR12MB8194.namprd12.prod.outlook.com
 ([fe80::82b9:9338:947f:fc9%6]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 22:16:26 +0000
Message-ID: <09fdebd7-32a0-4a88-9002-0f24eebe00a8@nvidia.com>
Date: Thu, 15 Aug 2024 17:16:22 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/15] arm64: Support for running as a guest in Arm CCA
To: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <ZpDvTXMDq6i+4O0m@fedora>
Content-Language: en-US
From: Shanker Donthineni <sdonthineni@nvidia.com>
In-Reply-To: <ZpDvTXMDq6i+4O0m@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0114.namprd05.prod.outlook.com
 (2603:10b6:a03:334::29) To CY8PR12MB8194.namprd12.prod.outlook.com
 (2603:10b6:930:76::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8194:EE_|PH0PR12MB5677:EE_
X-MS-Office365-Filtering-Correlation-Id: 83bc3284-1ff8-46c2-a312-08dcbd77e7b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWE3TDhkRzVUTWNSTE8vOHo4U0lDQnQ2dUVkQzRjSXlJcTZSSW1Ya2hUMlRE?=
 =?utf-8?B?VlV3emE2czFJb3lqN2h6STlhMTJoLzhCZkJFUjlvLys0SUdMZXgyMEJsdmlt?=
 =?utf-8?B?T0EzcGtCVzB5eEZTbDEzcHhvdjJIbktzKzJpSTBINk5IZXUwN3V5aUN5NDRH?=
 =?utf-8?B?RE1uTnJVUzVDTjc2cVNrRzJCM1I0UU1nUjV4QXYwOElmT1g3UTdFY2UxdFQv?=
 =?utf-8?B?MXRlR0NqOGdUZHIxQ0JibHJIdlcwVzdpWTNyZUg4STg5eWNKMFFjZ1VQQ3Jh?=
 =?utf-8?B?YXVkU09FTmYrVzJhOGttNlJMdTlISEs4OTR2UkRGc2xPZzhOQmJtc2NpZE9W?=
 =?utf-8?B?U2psUFVaNFFTN2MveWVUUlJxQkVWUFFDcEYyeHRuVU5QM2JvYW1zWFk2amdz?=
 =?utf-8?B?TWFsY2trdWtIYitHeGtTUTl4NWszNGZ2cllmSjRUenJlRzdzcmxBZU9iREI2?=
 =?utf-8?B?Y3cyL1lGd3FvSHBhRlNIdXBXaloxaTYxUnZNeWJRaFRKckk0ZWVGRkdxWElZ?=
 =?utf-8?B?a2orMWVSU1I4SGlWOEF3N3VKbFkvaHRvK1FFaXlQZkE5WDZIVC9NQjR2QUdY?=
 =?utf-8?B?MG5oeGx3YlFucHBCUHRxcXA5VXRFM005S0tpMmhSWTZLYkNNRm1EUVpqdzdw?=
 =?utf-8?B?eE44dEVxTmdERU1KOGdOblNmSHdIZklxa2JtYUN5anhJM3JTcyt5amQzWXA4?=
 =?utf-8?B?QlRuM1V3L29xUjdONkxhU2tYWXg1SXRTSFpVOXJ1VURiUDU5ZXdua1VFQThU?=
 =?utf-8?B?Z0xzWEk3bjA1OEN4UXhOb09wb3JwZkVnNlh0VTgvUDBoV1BpODVyMmcrTVJu?=
 =?utf-8?B?a0o0enN3QnRRbThqMFp5dlVGTkc0UWMxWkoxZTVCaXFta1UxLzYvSDFCbHpz?=
 =?utf-8?B?enl1bU5rRmJHUDdVVnpFWmFReE5NLzBpeWRMQlpYT2x3ZlB2ZUdacUZlK2xi?=
 =?utf-8?B?RlpOTHhNK05KNmZXR09NNlZhQ1JydTZTT1B1NmZ0N2xSNVVLNVhqcHhZWk1L?=
 =?utf-8?B?Zmh5TTdVS0ZGbVhlR0JmSysrdnBSS2MyeDJ1dkFiWWdkUXBKUWJWSlVqc005?=
 =?utf-8?B?TTVWczNGWTdWWFFpQVlkUndqNlluRHY3eE00RDAwVlFtdWlyNUNxV2JIei8v?=
 =?utf-8?B?ZXpIbDM3OEwyY01tZ3ZYYVdORVpDNGZBUzJsK0c5dlpqZHB1aXJOU2M2b2hj?=
 =?utf-8?B?dFlJUGFxVDUrbFBjcm1NTm1LR3NwdFM4MGZyc1hsN2tQc083VUpFU0tNSjJ4?=
 =?utf-8?B?ZHEvVlNOVE0yY0ExRTVuWTdtRWlIR3JVendrTGN0Ync5cXMzM2lTcHZjbkpX?=
 =?utf-8?B?M28xOXQ5TkZTUS81bXdBQXJPWHU4QXNPb3hKSjVtVmpoSFN3TnZINXp3SnZH?=
 =?utf-8?B?OWNIb05DalBwb2JUWnF6R1lFZHNGUU9jY2ZKSUlNWDhTTzV1cUNzRytDM3B3?=
 =?utf-8?B?eWhHQko2QVEwOVVpNUREYzFocDlxc3RadDZSbFk1OUYvZlpQWXBVckR6c1dv?=
 =?utf-8?B?dVdZclVKNmpWOGZtbENIdnNyRzdhbmFPR2cxQ0VhY0hwNnZlV3poUEJpNWEr?=
 =?utf-8?B?WGxnT0VFci9sQjhzQVc2cktxek0zMmh6ZlBWVnprM29JZ1dwZTA3WHB3L1c5?=
 =?utf-8?B?SURGUTAvM0pza01SOGlXOGhiVU9QWHo0ZFMzYVZhVUhzb2ZsQmZJY1NnWi93?=
 =?utf-8?B?YnpkellNY2drY25YT0lIVE1oYVNaQW8zSmtGZzFxVTlUYlhWMTlCQTM3bzZ0?=
 =?utf-8?B?bkdjMER4VWdqU3R5a3VsR1dWb1FoWUp1ZW90LzF4WnlSSlBINVF4eFJ4Q1NC?=
 =?utf-8?Q?sHY12xAzOHqqMH4wUJIIgOr2nC17KV0DPCWSk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXh6Tko1WVg5MU9jWVFQemJPQ1RLMjk2ZzZaU3pPM2ZlSVpieWNiN0FLbWlP?=
 =?utf-8?B?YnBncndqUSsxRTVIa3M4d3FQN1Raa0k5TkxackpoNU4vVVR1a1o0SGh4RFZ4?=
 =?utf-8?B?Ry9vZmtIRXZ4TVE0MlFVY1cyTDlXUCtBRFVETUFXNnY5TnJCUEdXSDcva094?=
 =?utf-8?B?Vm5JS1BHNTRYWSs3b09tdnQ3VjhBcTR2SXhabDhwY2R6NmMyQ2hUdFRKZG9C?=
 =?utf-8?B?VncyVFJaalNJLzFtUXBoUFIzV1lZMjhBMFlaSTFSTEQxSjc5bjE1SnlwTzVt?=
 =?utf-8?B?c3V2QTlVTUw3b25GbVBLZjU2Y3V1MUhVNXpaZVJhOGEyUXRTVExrVXEwaFdk?=
 =?utf-8?B?MHJkaHh5WFdZc2J6SzRVQ2RYcVcwRFhuUTlBMERtTTk5clRJM3h6NllTdUx5?=
 =?utf-8?B?cnBIcHpkNUROeStnRUU3M0xWenFiSWFBdnhFZHhiM3pRVTFOTHdaRjNBTUJY?=
 =?utf-8?B?ekIvS3JlZ3JZWm1HeXNhOGxjbTZTTE42RjJUaFpiT1g0RzlUY2pJeit4UjlJ?=
 =?utf-8?B?SjhwUDNKMzZzQXJ1VmwxeTJOaC9MeWYyclpOTDFFakJZT3lSb3JCRzRtVWND?=
 =?utf-8?B?aFBvZXY0Q3JrcjduTTkrMDNZYVdHSG43aDF6bjJ1N0Vvems2cGMzOVphODN4?=
 =?utf-8?B?VUJ0eVpnUFlTOTZoTTJZVm1ETVc1bU9pZ2FtOVJmWGhrRUcxbTZ6MG1xZjVm?=
 =?utf-8?B?U2xmdzF2dEN3YkoxMU5kaWd4TlR6N3NNWWVRdTRRcXF2bkhCWStXSlE1VnFP?=
 =?utf-8?B?R2svNGFhK1J0RyswYUI4VVJDajJDRVcwVWMxaHhWNGhMdkFzQmhtOWQxaFNZ?=
 =?utf-8?B?cGxGaldmcEZMOEJNTDR0N1g4N0FvNGl3N0dxOGZvVHc4MEIyWGtQZGpCNy95?=
 =?utf-8?B?MWNUY29od3hPTUprQi9uSFNqdUVUTXpRTjhyakZtdWo1cklsZGh6M0tiTXRl?=
 =?utf-8?B?T2ZZdWRHaEFHWjBleGNxV0pUM0lobkVwT2laMDZqclVoY2RoMlArRlpBRVhk?=
 =?utf-8?B?ajl5ZXpMQzVrekdkcmMxanlIMExGL1hPVlJZNkFLanZ6TDFnNlhIb2VidURO?=
 =?utf-8?B?MlFzVFNwczR0eXE5WWNvamI5OWZDdERRL0xrOHVRQ1JINkU0RllEdUFOb3dz?=
 =?utf-8?B?WnFpWDhWeTVOd2ZNSFdnOWs3MG9xMmZEdzFEclZSS0IvR2NhTEJXaGpNb0lO?=
 =?utf-8?B?bTdMdzFFSWVvMG1YQWI2eHBMNytWTHFVeE9mVCtZS2t6V1JtNWVSa2Nhazl6?=
 =?utf-8?B?c3ZzcjRBVFNIU2RBc2xmd1Y4bFJwRDYyUmI0L2F3SU8vTkZSNDYxVW9wb0lF?=
 =?utf-8?B?NVRFU3dzNExkSjl6OXA3T2srOTBmUTBiYlFTVGNuUnc4VDVxUnd4ZENOV0Ey?=
 =?utf-8?B?NVpGQU1lNGhtY1JxYld3N29nRmRCVTdmTkZYQjBJWE1aUHJ5K2doQTAzbDh0?=
 =?utf-8?B?aHBkVUQ0NkhmR0M3clpreGJsclpVL1ZFdnJZanJFVUdYTzVmNkJhTkVZNTkr?=
 =?utf-8?B?MHBLSFRJK0ljWjFDNnFqdjVHSk9HREI5MWlMSUIwMzZFeUhkMWhLSDZnK0s4?=
 =?utf-8?B?ZHRzaDBSN0ZubWh1bHdXZTN3b3pzajNydk1VRVBIbm5OMTczQUkwYUxMOTdN?=
 =?utf-8?B?ZldIbndKQWZ1eE0yYWdCa2pjN0V4RWF3SHdUNGZDWXRoOGU1eVBEMWk4a0ll?=
 =?utf-8?B?cUNUaGxac2pwMUFka3BlQWhYdG1sYWdNcUVjbmNlSUt2SUZBOTUwQWZvTXZO?=
 =?utf-8?B?dkJES21JT2lwOFZhVlBTQlNWRUtHR2cwUE1uUmpOZzRyZXJ4ejM0OHY0cFRx?=
 =?utf-8?B?bzJycERkRGEyRW9QMENpTjkwN1F1U3p3cDNpbjBVblN6blZvcmhiTGYrN1FE?=
 =?utf-8?B?OVRHdWNxRTZ2TDBPVmNZRHpKTVd3czdkQVZhOGdYMXl0clRQTVRaYlJCTzFl?=
 =?utf-8?B?a1hkalFCekxRWWNTZXF4b1pPZ1FRbTZMbzM0bEd0TFFuWHBIelV0SERkWkFB?=
 =?utf-8?B?dEoyNG5PNHN2OVk3RmhPczJkVC8vMDNSelBtQjZVOHlUZnptN0hnKytqUC85?=
 =?utf-8?B?WUl3dXJGS1JMSm5lK2ZmZDlyTlJURTRJeE1nYWhKZlJtcGdEcXMrVDU1QUVu?=
 =?utf-8?Q?7iTBCkH+o/bm4LBgckyQsl6Ep?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83bc3284-1ff8-46c2-a312-08dcbd77e7b4
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 22:16:26.7278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PpBji/Evhd3OBtmD38tlYZR8ZHz3IEzWtaNZKkWeNxWeISndGwPqeU+14c6+c0pT4UmTc3E1VxjSDZ13XtuT4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5677

Hi Steven,

On 7/12/24 03:54, Matias Ezequiel Vara Larsen wrote:
> On Mon, Jul 01, 2024 at 10:54:50AM +0100, Steven Price wrote:
>> This series adds support for running Linux in a protected VM under the
>> Arm Confidential Compute Architecture (CCA). This has been updated
>> following the feedback from the v3 posting[1]. Thanks for the feedback!
>> Individual patches have a change log. But things to highlight:
>>
>>   * a new patch ("firmware/psci: Add psci_early_test_conduit()") to
>>     prevent SMC calls being made on systems which don't support them -
>>     i.e. systems without EL2/EL3 - thanks Jean-Philippe!
>>
>>   * two patches dropped (overriding set_fixmap_io). Instead
>>     FIXMAP_PAGE_IO is modified to include PROT_NS_SHARED. When support
>>     for assigning hardware devices to a realm guest is added this will
>>     need to be brought back in some form. But for now it's just adding
>>     complixity and confusion for no gain.
>>
>>   * a new patch ("arm64: mm: Avoid TLBI when marking pages as valid")
>>     which avoids doing an extra TLBI when doing the break-before-make.
>>     Note that this changes the behaviour in other cases when making
>>     memory valid. This should be safe (and saves a TLBI for those cases),
>>     but it's a separate patch in case of regressions.
>>
>>   * GIC ITT allocation now uses a custom genpool-based allocator. I
>>     expect this will be replaced with a generic way of allocating
>>     decrypted memory (see [4]), but for now this gets things working
>>     without wasting too much memory.
>>
>> The ABI to the RMM from a realm (the RSI) is based on the final RMM v1.0
>> (EAC 5) specification[2]. Future RMM specifications will be backwards
>> compatible so a guest using the v1.0 specification (i.e. this series)
>> will be able to run on future versions of the RMM without modification.
>>
>> This series is based on v6.10-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v4

Which cca-host branch should I use for testing cca-guest/v4?

I'm getting compilation errors with cca-host/v3 and cca-guest/v4, is there
any known WAR or fix to resolve this issue?


arch/arm64/kvm/rme.c: In function ‘kvm_realm_reset_id_aa64dfr0_el1’:
././include/linux/compiler_types.h:487:45: error: call to ‘__compiletime_assert_650’ declared with attribute error: FIELD_PREP: value too large for the field
   487 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
       |                                             ^
././include/linux/compiler_types.h:468:25: note: in definition of macro ‘__compiletime_assert’
   468 |                         prefix ## suffix();                             \
       |                         ^~~~~~
././include/linux/compiler_types.h:487:9: note: in expansion of macro ‘_compiletime_assert’
   487 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
       |         ^~~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
       |                                     ^~~~~~~~~~~~~~~~~~
./include/linux/bitfield.h:68:17: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
    68 |                 BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?           \
       |                 ^~~~~~~~~~~~~~~~
./include/linux/bitfield.h:115:17: note: in expansion of macro ‘__BF_FIELD_CHECK’
   115 |                 __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");    \
       |                 ^~~~~~~~~~~~~~~~
arch/arm64/kvm/rme.c:315:16: note: in expansion of macro ‘FIELD_PREP’
   315 |         val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps - 1) |
       |                ^~~~~~~~~~
make[5]: *** [scripts/Makefile.build:244: arch/arm64/kvm/rme.o] Error 1
make[4]: *** [scripts/Makefile.build:485: arch/arm64/kvm] Error 2
make[3]: *** [scripts/Makefile.build:485: arch/arm64] Error 2
make[3]: *** Waiting for unfinished jobs....

I'm using gcc-13.3.0 compiler and cross-compiling on X86 machine.


-Shanker

