Return-Path: <kvm+bounces-35867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DB2A15808
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:16:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D82EA1883396
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B63611A8F84;
	Fri, 17 Jan 2025 19:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EiXbBvrD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A3B199FB2;
	Fri, 17 Jan 2025 19:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737141371; cv=fail; b=ui0sI7+2wfaNa3PpQ2KI5cm7GFcHNqOZu0jZLZCOnarZJeE99f6ktvuANwcElMgjzGh1rj+eA2tIX0ILLUQBULu7twP2M/UsYZ+LtK8au9sQWadEhTGL4pTMzwjsWJLCqTDsEfIOLLVORCvzVaa1YBBiVVV2bCT43DUDcZnRjSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737141371; c=relaxed/simple;
	bh=UCsNq5u/HboFDZ5xw4zuuuyIhmFI0hhmccNXhNH5ur0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HCLhrdPL26wil1ZI1UpSPZ1+3758FE+Gf9nPqo9pWYDSVls6NAvEDrWmiZ5/A1+iXgy13ecYyOAtAxonHGyuV/P2aTl6kRzyMYB2KLsg4vWUaUKwBsHAAnftGhRGsFPvf3A8b+a+UNM7FEubMg0cvOYdDDZgaRzGOS1l+TZwEOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EiXbBvrD; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mi14bFlNGQ9o9TEZ12kndYWzpkTVEwNPTC4t2lR7HZSOiTw+7cfOXULFRPF/2oStMKxfDBtCrfHamKow2uTIBaeuF9Qz4Uu8QPtt6DmJAfJF02fXXXH33yPNKPZ1G6g+BLloJZ+ZtMe4RlJ2CNtTClA4ZoD5j1puHnq0nxmYUX1BY1mTxm2bAA2mlJ91yzhkWs+PiVpED+hLlKwUUrYV0GDYoWh9f8wMgPzltKOILv5mqKMq0BWE81Iwoi0bBefjGeH6qqZgURWQ9cHnyuLSh++6iKobz87Isj/a+9NT5Fg/ULThIZcapSvKXbwEC4QnGMleyXGFlJiK9p2RdjcuBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrk+t7ZzXKchyFnpxjbkC4mMOcUe99HxqMCMXa+rRN0=;
 b=TZzEv6N+9GEM2/FORsPzhB6RAazZnEvvzM2c3rrWxT0tgkW6FAL/whul7EQPZDXa4tU64yT0H5VQnjD6dPwGgvyP/u+9nnJLe3T5LWJZg9AFu0Uds7zY1vSCGNB7rqbwg4tzeDoNvFC9FTFvBDlhFjYd3ujBZy0jVWxUCImosf1yhrpCEgis+xV4hPwjuHqnttgsYwEXQLwsfhBNP6pJi7U9htTqEIV3PZ3l0+d7LGEvOpOLl7GV3wXJy3WQzwCUSTUfrv8tLHMaqn2BelmCvwY294WP7y7WE22vJnebCNfEgTx82dKpPBfebs45A8RQNIuxo/bQT4gPcKNXfHBuIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrk+t7ZzXKchyFnpxjbkC4mMOcUe99HxqMCMXa+rRN0=;
 b=EiXbBvrDsEzn21BmBT6hn3ZzckDZo2PNKKn0uL/CvLgTgO4KFIO3zH2F4StRborZEtEB+SKHvltxaxYuatwaJggF7FywkguWOKdL+AdQ3uustmudiQ3uOWleJcZUg8Pq3s8Znh7HHXTd30MQaumTQqTUF5o5UWHr9ztG8BSIbuJyvrtE6CjQxfQjKhHM/KZhOwWZZDMdQ38q3HKTHHyqhInCLQ8YUf15aymhReIjYYQWXrZkSZbz7Gg9FkRLUsWL5dAsYBovRmqv2vv8ARdmwReDe++GxEQNneAwhTFakHOYBRg7x4ObNKCSIR2PCC5yjilG6o2GgQen+xswm673vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7684.namprd12.prod.outlook.com (2603:10b6:930:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.15; Fri, 17 Jan
 2025 19:16:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 19:16:06 +0000
Date: Fri, 17 Jan 2025 15:16:04 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, David Hildenbrand <david@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250117191604.GF5556@nvidia.com>
References: <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250113162749.GN5556@nvidia.com>
 <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
 <20250114133145.GA5556@nvidia.com>
 <SA1PR12MB71998E1E70F3A03D5E30DE40B0182@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250115143213.GQ5556@nvidia.com>
 <Z4mIIA5UuFcHNUwL@arm.com>
 <20250117140050.GC5556@nvidia.com>
 <Z4qm95LRizWiBPpT@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4qm95LRizWiBPpT@arm.com>
X-ClientProxiedBy: BN0PR07CA0022.namprd07.prod.outlook.com
 (2603:10b6:408:141::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7684:EE_
X-MS-Office365-Filtering-Correlation-Id: b99145df-3f79-4054-a0f7-08dd372b641b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6SeT8zSYn9QARflPZz9FF4mWhNq7/HSigPhL0ODYmAkf4kwVjoCHqxT+/VAd?=
 =?us-ascii?Q?WzUeHqOqzF6W+colnXcOBsZI+XpjfQWWUs2RLT1SBb1LcMob8kZZzIqunwwc?=
 =?us-ascii?Q?aQKMLVWKw5dqv/VFmkyTHpcRpDQq9zlGNZ6JaIp1Pff1UM3eQIqddlbsBoaJ?=
 =?us-ascii?Q?ci7SKFgKbWqPUAzZ4BpA9BtyNfXUdSxQuSRrCSwqKxBQZsIrQxmp1oWJf4q4?=
 =?us-ascii?Q?Dvt06z37BFmlLSoTJrVhLBBO+g0spyRIejrAmP8VwxABjdmZ5hT34HqgBW5z?=
 =?us-ascii?Q?HMAV2P4NrjgLGXsWP2SfkZZx+JpD+trTHqgCB58xT1qZyEUA9d++lwtqiBXg?=
 =?us-ascii?Q?R07zq8uU0iw4zEZe7+q8zBhKkJOKMGWm60S95zWuetIKz4EOhWaOzEZygVM+?=
 =?us-ascii?Q?w7JgfgY1+MC1xae7eOxTEHg0H+iynoGG+OieTaz3exRxFLWdIq4JYA9qkneJ?=
 =?us-ascii?Q?C8f6AYEH+Rsqw0N8L4G8yHBF42sX25fpq1TlOZ35XsUFq2FDMrkb9NUqYb3N?=
 =?us-ascii?Q?fcgt3zcAFDdCJgLGeWQIARqDhpq7xs014pyRnM5fP/rnydHZLTIJ0KijZTJx?=
 =?us-ascii?Q?yWcx2iAQ9YJNkPO/ZdWrGivmhxQJ+7Fcf/1GSLRsRRMXS2CiEA3XMPX46S0I?=
 =?us-ascii?Q?BxXEZ8GIURtm4J/CLSE+ju7Cda3xAm9eYTIqh4XDjC/KwiAMQCpUyVZUZ/qQ?=
 =?us-ascii?Q?EcGPJe0AWWKqiRrd9DbPSPMxYXAWk6nzvJzFE8iRQbczRkwIz6XFgjA2vICe?=
 =?us-ascii?Q?3oZSApPRtARk0htwUBv1cRts3VyT3fFQm7TOVyzC83JYLusw30QlgAQE8xyq?=
 =?us-ascii?Q?5coEjlg0SK3Ju+5GF0Qe0uccbYEmt0ireIKwp8uNBAa3areWUzMeMqvdEqLU?=
 =?us-ascii?Q?3+JFE4yO1HmvUaYlafz+c0rmnoYcPnKeUBpWw4XavExO80iyfN6eccftet+Z?=
 =?us-ascii?Q?P6gWcdmT6aWrYF9yTCA2vyXU71x8MMMcWG6qpfM9bOoPxTdVB9CrhkS75j8Z?=
 =?us-ascii?Q?DfmPV/fZENEZlnkbDHSV6kX+tGD9c06Qs4QaX5edaYglApEKW5DkB4Y0Mfus?=
 =?us-ascii?Q?p3HcVdzfih3bZM+1F2W1iFoKKINX8Omty9c8aJuV2xBp7ROy7gIMO7hwwetG?=
 =?us-ascii?Q?bKhuebE8DAAAbctmAKpn/BP11p7hQQGzmDf1elDz9FK8UyfeCudaRTkrXoKZ?=
 =?us-ascii?Q?LWFCtCZGuqQi6wOywdMwzuWtZp86SIwm7DGgivDIuZxX2ZIfP31r+zfMMP/t?=
 =?us-ascii?Q?wwz8XhalVDxtIRDmpzLdU40UUyWLhDg13RpB/kV1UsiTo5+frX76/C3JIgBn?=
 =?us-ascii?Q?sO0avtKDB5BkJFyZLS7MaffLab/h/8nJTNVJXQzoqqbxSG/xynWjU5Zd/D3n?=
 =?us-ascii?Q?tK3h8kE6nLUpDCeypvONZPiFpUMY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?93iZGv0RULOf5i0c6MQtp3+Dd6U5Z7j52sG+m9o0CZ94FKcJNRiRkrtcMLX8?=
 =?us-ascii?Q?JK4gLwwwaUg7VvURtgK9zl8EiBEv3t2wksMAwus/wshSuWp0ajm9UgXIA6yi?=
 =?us-ascii?Q?oFyNtfTyYEOsUZF63SM2DskWfTNbuTj7EoMS8JnzNae5dzXP97jaCICbNtp0?=
 =?us-ascii?Q?Ch2dqEhdrmFLKzQGlgjgYXCyb7Pkk8qFt0v/MerWG3sXS1ZTzAwXILNaAHuR?=
 =?us-ascii?Q?qym494hoB+AN5WvyReKvqqXvQ8orsQi8wCj/ZhwBY4203HKRcAZFWCvJ1L9n?=
 =?us-ascii?Q?S/MDN0+7VMGSqqAtuyD5PMMzzDbhep/tzvtfcOTgT6FbooBswK0jaZGS5Lkl?=
 =?us-ascii?Q?XAlDSAlcBH+EJjd+t0rGNrxXVtFrVRecHcxAo7KfDEDai70XNESu/iYbpXPi?=
 =?us-ascii?Q?D6cgJkhUnlGqnV6Fa2IUoQSx6iN9xvQFFTn6/cX9TwKGzfMydnImod/8ZXgQ?=
 =?us-ascii?Q?evUSs0WmNHO0FTiYHuISwnvxAv7GBVBHMaIpz9IfR0aaURG7jvFt5HrK3XXx?=
 =?us-ascii?Q?PjPgLpFhpqBgcRF0I5pZrTRTXfVGysPLLlGEQ1IhiFXvJzEH26zyXVFiCIOW?=
 =?us-ascii?Q?s9vG/Nt0uFP0EG3rXV1oG9mSrbXk/R/j8la/l4O1hxwXD6F+Y2IkUdySHWVR?=
 =?us-ascii?Q?a5muy+HgvQmqZazjykIu1dlrs73pjirZb9laCJLr3lkY11qCpz24urOvHYkE?=
 =?us-ascii?Q?t2/+WtR23XpJdHoZxzeQj+8Ujl39hbCafaH9KMqGj3nRwRzHfgQV39xHqhRO?=
 =?us-ascii?Q?Gf5I5SRD8Qt+pRYKcwxt+RGWy95BrTpH/oOhgsdGtsIs4vXPxfqRcqgxiBRW?=
 =?us-ascii?Q?NATS6ivPIkM2ypWdw8fQWMXq/7h7UqW+GXRhkSsaBiSrFVcunfcy+bSWt+JP?=
 =?us-ascii?Q?qgklGckpBCAX3/Vk4LrPbRrPzDh9V16GJNeOuh36gEw9U8B2bNOHPPGgN8Xf?=
 =?us-ascii?Q?gstzJ090bac1hcXWsNMYukUWGtC53/ahmEBXAaUCyXaDA/kkOqIdiQTP+4uV?=
 =?us-ascii?Q?gde/H4N65jKxjLl2ZN9+bpZMgven7ZWN66re2pQOTIruPsOZafaOg4LY4Dya?=
 =?us-ascii?Q?Z4KQ/CFd68HL3njuOdWBYGo1nqk/e4P/Xj3X67TvVIgu2cF0mhVGG6kZsIoB?=
 =?us-ascii?Q?ytu8Fc1LNIYjyZfjhINGxfgVvPChDBwhY++ZbErHLSYzHJZD1mhifcChHhn1?=
 =?us-ascii?Q?hAAX8LH8SFty8rQZCuTC7cc9krBBFdwR5MU9R7d+pA+EMKluO/tAYLpBfv6/?=
 =?us-ascii?Q?oLrLWWGVbrMJ7gsDqe7x3juUU7OAzRJCbwJx2Q/R+PRh1DB2jh5HfIJPDBYg?=
 =?us-ascii?Q?waoxMe998SHNKrDg26x7WJxYOkzniwNVhqzO6V8y0NxiPAVRlECATkGsDpGt?=
 =?us-ascii?Q?49bMpiu05kcnUq2k24NxV5liFtihU+cFmD0a+pi155HkG2av4VcndQNJCJlv?=
 =?us-ascii?Q?QHD8KcTkxmAldpRcgsMy3rKrjMjyfLhCoRpWrz0WrVM89S02Y9mzioLGhfgl?=
 =?us-ascii?Q?DeMXv6iZi2XKf8XUSd/kqVgRKhzQKUoZuzn0Zh3Hr6TYx8WpwNMsvn4i8lfe?=
 =?us-ascii?Q?46j5sgcT/43RwPCBrsqNUg+/kHPt0fApWEyeIbDP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b99145df-3f79-4054-a0f7-08dd372b641b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 19:16:06.2078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYqE2bAgK5LbIJjPWQcbc8Lyjj+lIJILlaeQzd8Dl4Tb1DpkZVENIFLVG27E+IEv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7684

On Fri, Jan 17, 2025 at 06:52:39PM +0000, Catalin Marinas wrote:
> On Fri, Jan 17, 2025 at 10:00:50AM -0400, Jason Gunthorpe wrote:
> > On Thu, Jan 16, 2025 at 10:28:48PM +0000, Catalin Marinas wrote:
> > > with FEAT_MTE_PERM (patches from Aneesh on the list). Or, a bigger
> > > happen, disable MTE in guests (well, not that big, not many platforms
> > > supporting MTE, especially in the enterprise space).
> > 
> > As above, it seems we already effectively disable MTE in guests to use
> > VFIO.
> 
> That's fine. Once the NoTagAccess feature gets in, we could allow MTE
> here as well.

Yes, we can eventually mark these pages as NoTagAccess and maybe
someday consume a VMA flag from VFIO indicating that MTE works and
NoTagAccess is not required.

> I agree this is safe. My point was more generic about not allowing
> cacheable mappings without some sanity check. Ankit's patch relies on
> the pgprot used on the S1 mapping to make this decision. Presumably the
> pgprot is set by the host driver.

Yes, pgprot is set only by vfio, and pgprot == Normal is the sanity
check for KVM.

> > For this series it is only about mapping VMAs. Some future FD based
> > mapping for CC is going to also need similar metadata.. I have another
> > thread about that :)
> 
> How soon would you need that and if you come up with a different
> mechanism, shouldn't we unify them early rather than having two methods?

Looks to me like a year and half or more to negotiate this and
complete the required preperation patches. It is big and complex and
consensus is not obviously converging..

If we had a FD flow now I'd prefer to use it than going through the
VMA :(

I have a vauge hope that perhaps KVM could see the VMA when it creates
the memslot and then transparently pick up the FD under the VMA and
switch to a singular FD based mode inside KVM.

Jason

