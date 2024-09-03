Return-Path: <kvm+bounces-25696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1FB9690A8
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 02:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB1C2B20920
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 00:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BE44A0A;
	Tue,  3 Sep 2024 00:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZIRwsp+A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7B4A32;
	Tue,  3 Sep 2024 00:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725323435; cv=fail; b=fnJj0c4iyG6Uph5HAYxrjE9FOFafFp/G7wN+tUlnSRjdTZfqy8ginr0pnJOeT7rjRPgEjppaLQ5V6CYH5iaeAd0/02hbswTnQkq07YrcGrFMWezR4CbDLkLECGCtD/yNNXPePwS3S9V7VoG0cL8b3FE8qQMVdycrk4mda3L7ADk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725323435; c=relaxed/simple;
	bh=h3Ayj3lkIhSq1jG8OP18pjh9HRdrQTOs3xTdk0zB+os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Enm32fj7RmYd9icbdLcf5/QFZ2TMvxYdB1S9JeGM63ohovEGejjGyYelSNHFVKoMANtkSmsXPizzH+x2xCq8fMUXp/v/Hf5Tu8pI0rXhXlyutjAcz/5NU+r5ojZeDIoWdDjXWhHsOlR9Up/XqzNK8b5C52vjyBEkwKLpbj8dd0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZIRwsp+A; arc=fail smtp.client-ip=40.107.223.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lurmYTE6NqqRJeS6VPQjhF1eaqvP90t7LHKDpVgTnWcwIHoPXDVIWv3LwPvyNetPS3+rlePDf4+/6DOfHy24iAqcttyakUEUkHrDmPSQHlOkSrA7M0YjZz8cfQzmDxWIDIOBei0f61CxotbVMjs1d32qj9MGElvSLxq+QO0F/AlUqZ5EXkBZs/RW/X9Mi7H2ptgf508OCye+YxSDy0lhhU8nuByc2QXA0A6FNnIHQucSOoYGoRNhQ+Ygx+uQy78EFzacB+dzq6vpFr4RYhi383iRUNKIJr2/zpXc1LZCLL6N4CfQ02Y/sWpH7PkNrcJJobe9wPhc3j/ib9k3xvuOmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uXlCGvbMZoPiHR653FFyUen3xylXo/Tcu4VGfBL4CY=;
 b=vpulUhq1rfQf/z2RqvOCPyvSC9llJuKL4PFK9ZKXNUqiRJAXUEjE5XYoWI01O5ENu2CLW9LcCWZMEVJgztCj/EJWSNqPu6LQo00EGkcFN6GTBVYuE38l9nl1VJOuwYP2BsQ7sAiBP1VMqkWatSh5fry2eOIzpHAWf+Sflp+hxegS8J0W7RHmiiQN9WfFpayRrEBozQYiGFfrPZKRtEQLsThnYqj804MQcemtKBsWiQlemRraAYqF8UU7EWNzY8TP2u6LT6zz8KIR+np7zEeCqAKmFJ7FJW/jPwp23oa+4+A/GPhf1UZKvFG4+04By7EKZeWcTnvTDmZ6kcp4PiXafA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uXlCGvbMZoPiHR653FFyUen3xylXo/Tcu4VGfBL4CY=;
 b=ZIRwsp+AbJtOZICEb1cxxp+Uja8JZuS0m62v8VgVex3vb2r7FTh4H1SPxg6GLuGbqSTu2HFg7BoyNh51JMW2HRX94dcrPLEC3QqPEmt32MUO74hvgpC0m1fU3UGzcShv16yMpLIk3GOvKX6c67siKp2avnxvh331sHuUllArQsZCdWtUFfk+xcQoLpt8X2356qbHQdm5PvcWgy+AWC92JpW7Myrtw3zTR/2n+p/fMcSCPTBigL15yj7BjQCofwv5R/gcmAuBonvOAA9TFiY4ctmRZgGbO9Uh32kj34uXbmvP8hI8ZtdsyeUD7pbibc2qDEAcPG++DMHXl9coYCYQNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB7112.namprd12.prod.outlook.com (2603:10b6:510:22c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23; Tue, 3 Sep
 2024 00:30:24 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 00:30:23 +0000
Date: Mon, 2 Sep 2024 21:30:22 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20240903003022.GF3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
 <ZtWMGQAdR6sjBmer@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtWMGQAdR6sjBmer@google.com>
X-ClientProxiedBy: BN9P221CA0027.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::21) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB7112:EE_
X-MS-Office365-Filtering-Correlation-Id: 422a22d7-743d-4e55-391a-08dccbaf9991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGJlSHBFSFo5VjVValFGZWxLOGpMMFVySGEwdXUyMTgzejBMNzF5a3NMMVFG?=
 =?utf-8?B?emhFRDF0Q2NQako1TDl2NitFSEswQXZvN080M0UydGtKWG1lWm5tYzBRdzJ4?=
 =?utf-8?B?cXczdkVCN2Q1TVc1SXQ1T1RCSkVualY1QjJhRjluci8rV3VZUi82UEZaZ012?=
 =?utf-8?B?TnlUUThiVnlrelh6bTVuNThmditBZmtDRW42K01Tc3VkMGxLbFpVNGFZb2JO?=
 =?utf-8?B?cU9HQUFXU0ZQbmlETys4S3h1NWhRTVNNRW5XK3FwWTMrN2k0L0h1c0VGOUV6?=
 =?utf-8?B?bUNCU3l5aXkzNXM3UVIwTzBvWXV5YzhORThXemQ1NXppY1FtRmUvNG1TSUhQ?=
 =?utf-8?B?c1NvMUdMMzBxSW4rSkx1UkdIeE9SNGE4SGRTMHl1TSt3RGZ4cXBIMlcrSzJI?=
 =?utf-8?B?UzZJQzZEWS9HRy9VdXZZNHZCVWU0djFJQjlsYnUxSnlmbTBzU2V6REE1M0dL?=
 =?utf-8?B?YUF0YzJ0WWVRbTU0cElRMnhBK3dUUFZ1bndaMWM2bFlqS1JmVHhqWFdEc1Z2?=
 =?utf-8?B?YTNzK1hzRUV6RXVGUTlrMVlMejQrT2pEOXpINzRaTWhxbTQ3SURBRTkrQWt6?=
 =?utf-8?B?azg0TWttbm5acnVQS056MHRaY1pGTThpSHR0cUhscVdYUTZSTHZIOW9uRnVq?=
 =?utf-8?B?TndJSW9IemFTdzViNjZPdCtjVWpRWTFNL2xaTjdjSmhUcTZBZ0w4QmpjaXp6?=
 =?utf-8?B?eXpmM0lTMVoxa3FaOUZweVJRdHdiamF3Ui9rMzVIcjU2a2dGVEU2T3dneWkv?=
 =?utf-8?B?V1Y4dnNlYldHekhSMVlpdEdRMGwyL21HKytCNEpKZUhtbS9EV2JYK1diOHZY?=
 =?utf-8?B?Y3JFR0ZUUWFtcWh4YjR1ZFptck15Yk5TZnQ0UXFLV0NiZUdaS0ZUU0NoVHVE?=
 =?utf-8?B?Nit0dmlLY3JKRE5pVXo0eWlnc09mSzJzVGMxbTU0UTdNWDVRY20zTEo1NVJN?=
 =?utf-8?B?T3dnMk9sSGZoejNoQ3A0UlROTm5rdll2R2MrRDMyanovaTdIZFYvZzRBQjNZ?=
 =?utf-8?B?cEd2N1pXQW5yNWxyTEVkMzJQRzBCQitBZlQ0K0dhdk5IUjZkWDBTYXQ1SDFE?=
 =?utf-8?B?eTB0V0dKalpId0pteG9aMmJZOGVQbkhiK1cwWDJtSkhIbnV0WWdFS0FVNVQ0?=
 =?utf-8?B?U3FVRGhqeGU5UVhLc0tXU1JlZGJqOUU4NHRZV2RiK1cxSGhWbEltbXRNMXdD?=
 =?utf-8?B?REFyRy9sYmRmM2Z6TkR2amJXTlZFN3hsS1kyRnM2U2hPaUw5ZjlFNmZDT1F4?=
 =?utf-8?B?U040eEN2cHRDRTRtd21PQ2dwdWxLb0tFZGpCWkN1Zk9OSVNNb3hscWFrNnpq?=
 =?utf-8?B?Z2xoLzRyMkxDQS9nRXppbDNDRFlRSzZrNkMyejliNUk5d2UwNElHWFFJU21l?=
 =?utf-8?B?V2xXd3BldlpocmJVRHJCSy9kd1NKOStUaUdSQktKMUFZeHJCeU0zMExxSmVJ?=
 =?utf-8?B?bXZlOTJpeFduOEJsRThVa2xIVjRQV1o2TEdab1dNTXplcm04cmJNU2RkaDNs?=
 =?utf-8?B?UStPbVVIeVFvcS80cXRPNmVIQ1F6QzM1Z0tqY2p6TldVS0oyYVZic1Q1TlRm?=
 =?utf-8?B?WTZTQVpQZGdQZ09LZlFuSVBjRm8zZjZZT0dSMzhGcVBhWXRJbVhzUnBQUkNO?=
 =?utf-8?B?LzhWMHkzWHd3SVRaV0dQN3M4Y1JaTnFiSkhHQVlyNzh3cjh2ampadWRKdkIz?=
 =?utf-8?B?WkRHRlZoRkNIMWt0VzlmNlkzTXdFTHR1cWdscGwreEVWZVFjdWoxWFp6TWpv?=
 =?utf-8?B?cXh1V2U1UVJ2d2tBUFYwdk5zVEN5UXFtYkdjOXFreVFYVDNQbnpxSGRPYkJU?=
 =?utf-8?Q?CoL9p1Rr203iCjyyXalqN1Ynyvz18XoLqW/ys=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVJmWXB2QytLZFRrajJTa3B2WG1BeWNSczlwRVErRVdCU0JZdC9malFrRnJJ?=
 =?utf-8?B?UmUxSlFBZlB6ZC9lTkU4eDZmb2w4QTB3U3h4enVTWHQ4M3RBZ2djejZ2c2l6?=
 =?utf-8?B?NWtqZHl1clZWMGpERHlEaGJzRU1sOUI0RElUd1puQWxXNnpLNFVyK2oxMTBZ?=
 =?utf-8?B?Z1NvaHF0Z0wyT21Ud0w5M3RmR2Vmb3BZOXA4L3pnTzJ0L0w4VlNPZnkyRE9w?=
 =?utf-8?B?Wk5qajhQclZSK29DSXZ4eFJrYi9MU29QN3pub3NETW5Rbis3MlRaSjBjZDRk?=
 =?utf-8?B?bjBpbW5QL1JvNmlxa09Na1d6Z01MQWxYVDVoc1J6MkJKVGxkcjdvWGJFckpO?=
 =?utf-8?B?dC85NzI2cWtGa1BRL1U3bjkvVjgrUlNTYmJpSVhXamNFcENSSjdIWWhlQisz?=
 =?utf-8?B?YytwcnVEV2ZOMXg5RElueVBsdkFFWVJubHM5VVBFeTlIdVJTdStOV2k2SFVC?=
 =?utf-8?B?YVlINnlKcWNFazFzRlJoZ0FoTDlVUFpGTE1hbGpNSjFEU2kwQVYvWURqSUkr?=
 =?utf-8?B?bDI0UHhqbW5ma2JQMFFaS1lYbVFGcE1mUjVBanBuazVSSkFjZ0E2bGxNVXU2?=
 =?utf-8?B?azlaUExmSndteWl4amlDV3F3c1RxTk81dk9oK0RFWThNRzMxd0R3cTgvVTY5?=
 =?utf-8?B?TkRuY2VnbzIxZ0lucFBleGRncGFlY0lGRVlhT0kzUTRFVUNHVi9rdVIzeUUv?=
 =?utf-8?B?NHgxdytVN1Ivb3hVNHZ5Y2toUVcxMXovWlN3YWtUbDVSQkZGVnRmVENoWUZY?=
 =?utf-8?B?MEMzY2xxZm0vSmxmem85aTVFWkFYOE80VkllRjJzN3VKZ3ROVmlQRUJxMTFw?=
 =?utf-8?B?cjRVN1JSZEFNbTc4MW43akcwRTJHL3daRWRBa24yTzhxTXVNcjFHdk9rYWd2?=
 =?utf-8?B?OU9YeElESmhQT1gxMkVtTDBjSm1ESmxxcmhtVHNHZkIvdFhrY3FDSEJ6MHhI?=
 =?utf-8?B?MVdjUzlEb0VraGFSZnpycjNxb3BZQ1lEdVhjMksxWGZSTTh1U3Qrbk1jUHdM?=
 =?utf-8?B?WDZVV0p4SzljNVRreHNpUkRhMjIwQ3ZidjhQaUV2RG1mcklHM05WOStBLzJa?=
 =?utf-8?B?UWo4OFVsWjRGa3JNdHdlSUVtNmV2Z0tIVUUxNEV6ZzAzMmhtTXVNZUpSN09W?=
 =?utf-8?B?Z1R6V25oamsvb0lySGRQVjBRRStTREEyYXpWNGJJZkdGN3lEeFVBRW9mK3U0?=
 =?utf-8?B?QjM0bVl6ZjY3TnlvbzV0S1dyZTJoZEQ0c3Yvamc2elNmNldOaGlLRDlDK3lN?=
 =?utf-8?B?aEpIZTREbU9tTisrRjZHNndkdFRIUDdzdy9ZVzAyWHAvRVFEWCtGcnZhV2FC?=
 =?utf-8?B?S0lQN0NRMnFxcm1GcHpqeElDRERJWUJkQXVTa1NYTDBqeFpKUnBlQWJmQmtB?=
 =?utf-8?B?TVJDVWFVMG1qNEVub20xWS8reHlzUXNvUW5vV3F0blc2VmxsYUN3QUdUdzQ4?=
 =?utf-8?B?cnIyemlmRzRiOWtFaUgrbjJYcVNoS2xGU1B5b1g5SDFiYnpobTk0WG12ZjRR?=
 =?utf-8?B?TXQwSmZpdjJTd3VtbE9FZGUyYW1tTFlpNzEyNytTU0dVbm9YSzJyS3ZwT1R2?=
 =?utf-8?B?SUdLRWpJOTRSTHhNenY5WE5yNGZSYm9hUGdZbjlFWURsOVFycEJ1b3VzRm5H?=
 =?utf-8?B?YWxPODg1N3RnbitHNXJmY1dBK1VMVnNXNW1ncTVPdEdWR254VUtod083QVRM?=
 =?utf-8?B?a0xPTkxnKzJmcWgveGZ3SWVJMEY5TUIxcytFaFlpdTdRWmpsTnlxemcrek1S?=
 =?utf-8?B?a3hpaFQyU08xQ0tmQzhtMWtxNmZNZTN0Z0J4NWQyc1JzRTUzVktWazBudVNU?=
 =?utf-8?B?c0FmVGJLeXA4ZEk5NmxyakJTeWxFZ1kxVWFOMnRxZUlYbHBXbjNpL1IrWG1p?=
 =?utf-8?B?R3ZWdENkOVRvRnEyblQ4VC9DVUdEZktuN0YyVXp6Um1mcEdobXRFTzc5bGEv?=
 =?utf-8?B?SVNMSzhKemJCVlg2c3RMU0w0UWFKaGd2K1ZRVTU5WEFuQU4zT3kwc0oxdVhG?=
 =?utf-8?B?bDkzYmdRNTBXVCs5NDk5SWY0V01RV3lDZEZEOW1ZTjViWlZWTnU5K3ZiTC9x?=
 =?utf-8?B?T3N5VGc5YmRGN3VXT3VNSFhRV1kxZm9CcG1HQVl4VjQvR04zMDlNV29UV3l1?=
 =?utf-8?Q?fpmI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422a22d7-743d-4e55-391a-08dccbaf9991
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 00:30:23.7282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wbf0koE5tXgCm5fVx1PrP7Ca8rAzL5rJUFYsJcBJ+hJdBy4nXVXz/fgGmsMHphLG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7112

On Mon, Sep 02, 2024 at 09:57:45AM +0000, Mostafa Saleh wrote:
> > > 2) Is there a reason the UAPI is designed this way?
> > > The way I imagined this, is that userspace will pass the pointer to the CD
> > > (+ format) not the STE (or part of it).
> > 
> > Yes, we need more information from the STE than just that. EATS and
> > STALL for instance. And the cachability below. Who knows what else in
> > the future.
> 
> But for example if that was extended later, how can user space know
> which fields are allowed and which are not?

Changes the vSTE rules that require userspace being aware would have
to be signaled in the GET_INFO answer. This is the same process no
matter how you encode the STE bits in the structure.

This confirmation of kernel support would then be reflected in the
vIDRs to the VM and the VM could know to set the extended bits.

Otherwise setting an invalidate vSTE will fail the ioctl, the VMM can
log the event, generate an event and install an abort vSTE.

> > Overall this sort of direct transparency is how I prefer to see these
> > kinds of iommufd HW specific interfaces designed. From a lot of
> > experience here, arbitary marshall/unmarshall is often an
> > antipattern :)
> 
> Is there any documentation for the (proposed) SMMUv3 UAPI for IOMMUFD?

Just the comments in this series?

> I can understand reading IDRs from userspace (with some sanitation),
> but adding some more logic to map vSTE to STE needs more care of what
> kind of semantics are provided.

We can enhance the comment if you think it is not clear enough. It
lists the fields the userspace should pass through.

> Also, I am working on similar interface for pKVM where we “paravirtualize”
> the SMMU access for guests, it’s different semantics, but I hope we can
> align that with IOMMUFD (but it’s nowhere near upstream now)

Well, if you do paravirt where you just do map/unmap calls to the
hypervisor (ie classic virtio-iommu) then you don't need to do very
much.

If you want to do nesting, then IMHO, just present a real vSMMU. It is
already intended to be paravirtualized and this is what the
confidential compute people are going to be doing as well.

Otherwise I'd expect you'd get more value to align with the
virtio-iommu nesting stuff, where they have layed out what information
the VM needs. iommufd is not intended to be just jammed directly into
a VM. There is an expectation that a VMM will sit there on top and
massage things.

> I see you are talking in LPC about IOMMUFD:
> https://lore.kernel.org/linux-iommu/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com/T/#m2dbb08f3bf8506a492bc7dda2de662e42371e683
> 
> Do you have any plans to talk about this also?

Nothing specific, this is LPC so if people in the room would like to
use the session for that then we can talk about it. Last year the room
wanted to talk about PASID mostly.

I haven't heard if someone is going to KVM forum to talk about
vSMMUv3? Eric? Nicolin do you know?

Jason

