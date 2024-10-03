Return-Path: <kvm+bounces-27839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84E1198ECA4
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 12:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D181BB234CF
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 10:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F93149E13;
	Thu,  3 Oct 2024 10:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mJ6Ot5Dz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE2784E0D;
	Thu,  3 Oct 2024 10:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727949810; cv=fail; b=AlqG7w+5AT73mc4DWz33wG7+rKl/zBLNZrbDl89uaALUhlRRKPe6PvgqWTW2yUh3niL4bNeN8MgnLqPHOEj/7HSWj0y2Nj0vCk0o0o2zoutL+q9lQz+/2rN21F0/QalW1S9tB6kYWQI3Z6eFb979xKrOjwUgPqTRKQMNYPZu7ZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727949810; c=relaxed/simple;
	bh=t0kw5AWMLP9bxDTsgcoi9zkIVsKZR4SimU2YcGKIV18=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kfT+8R/VMuSL7T51Db3reaAtVEH7tc6EnDUmG0NI3yv51wPk855LPKCvDOdsB+TRMCnPwHs/aG/FRXN8tzAnI0v4tSGRkhpULPLPKPU5Slpa8CJ5cuviQGvnJkkz85N9X6U/fZOObIChA1lecIlhHPs3GPgvCFugZOMrnVnxOwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mJ6Ot5Dz; arc=fail smtp.client-ip=40.107.95.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kBk4++Su6U2o8YTQBtLG+egMrO+vluXy5p99ckuz+kSrTvrFK1eSJazXOY6A6KFcCFHCUoi/eXVs61TEMVF7PUS9NAglmjpJ80Mdw9OdaqVMFZbeTZTERI8/9AJ8fdatjfhrYnYaXUmhvIyFVkp7BRlZunjbBTtQhZwPLWRXzapPkHisRCplZyPcChmelbDv6Mlt7Pk+w+5UkaX6uI6OdwEvqrnVTsgSJqx3v+euYM6eKLd2ZHKiYNWAXsKl0u5t9JrtNFIprZC3c0hFndBZivbJdefKLs8uKRgjNxaJ5s9vXtB/93KlGJOLB5e6zEg7Hb0Y5doQkuI2tOvzrlpn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiR/PmkSO945KA7i074R0fwP0ZriXDTIz22znEEVkr8=;
 b=kqF5zQe900ZvyvH70WsMlPijsIPHzfnjnbsTGvlp/bSeaKT6Dm4wLCfLHTV3mI5sQEwU3+uZP5+KqWI5vFrGerSUKI5PG5rLoRmce2WLYJV8jHZ68ka7+pykUsra3B4p7GcohOzYnTp2Xd3fQyj9I32u1yqIMILGyyGDVZ/Q2CzrOSA2W4UhyqWeeXTb9ynJlNE+suPmd7k7flhCkQqDf/vUZKaJWfPkg7fARjfkKrZ9spG56BwMW1HlWqdLkDISmWRSyT3Tqxu5a2uIe1Y8E6sOUUXOcc16AFcn2e7nYo8av0ErUC8iP1JVOFEqdYe+tjpdwuRHYm6nDeBP940YnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiR/PmkSO945KA7i074R0fwP0ZriXDTIz22znEEVkr8=;
 b=mJ6Ot5Dzke1ePzqkaqqYQWTEoAUoiLPHNTF6TKg3q4m166H0LyX5oisx8pNwm/0NgE0IdSsKoTVNn8CyuRTLnIayo5X1ibs5/2R0K3B8vjIxf9+FpGH+/RlhIkkngDT9ll9w5MdH6u1NOrKt09YtWJbSUuBJveV827rpU8T8byg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SJ2PR12MB9085.namprd12.prod.outlook.com (2603:10b6:a03:564::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 10:03:26 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.8026.016; Thu, 3 Oct 2024
 10:03:25 +0000
Message-ID: <01d8f872-a7bf-2fea-6f00-34fce18498b4@amd.com>
Date: Thu, 3 Oct 2024 12:03:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] vsock/virtio: use GFP_ATOMIC under RCU read lock
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Luigi Leonardi <luigi.leonardi@outlook.com>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Marco Pinna <marco.pinn95@gmail.com>, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, netdev@vger.kernel.org
References: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::18) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SJ2PR12MB9085:EE_
X-MS-Office365-Filtering-Correlation-Id: dcca446a-e32a-4d25-e765-08dce3929f43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXlSZ25Dei8xZmVEOUVBK0NwMjRGR1ZiSElsM2ZnTXJTMVF3OE5LM0V5S2l2?=
 =?utf-8?B?NTBQa3l5UVUwNElBYXl5ZlhaTm9LZC9jZFM0WkthYmNEMmJERWhuNmpGRlV1?=
 =?utf-8?B?YldWZkRPTjVSM2Q1T1RCeXZyNWJCNitpRFgwcjFEM2VQQ1dJNzlocDMwSC9z?=
 =?utf-8?B?MzBCMlYvSnpVNVlOWnR3aDR6S0tKaWJvT1lGKzBSNXRQUnZqbTJxMFlsSEh6?=
 =?utf-8?B?VTV6a2RMbXF1ZmRYalNWalFsWlJqSEJLbFR3eU9sdFRndm9YYlF5V0pFR0dt?=
 =?utf-8?B?VURrQk9uOW9NM2xvSWhaN1U2YS9WTi9JbW41TEdqRTFRZXp6UlIwMHhtSTJS?=
 =?utf-8?B?SlV0SXFuSXR2cWNhMzB3VW1OL3ZtNlJ6dVZkTC9RQWg3ZFMyZVhXUVJJVE9k?=
 =?utf-8?B?aFFDUk16UHljbjJWVWlhRGxMS25XRmpOK0hiWFlKUWUvRjF2VVVWZTZOL2F3?=
 =?utf-8?B?ZWEra1dqWi9FcGpwNmc5S091SXhVd1R2emtyeEIrZVNnSmI1eDI3Ymo1OUMz?=
 =?utf-8?B?c2Z5VDIwZ2c3QlFmOFVwcUh6TEIxWm8vQTJDUW13dk5XS3hRRld5TXFIdVZ0?=
 =?utf-8?B?UkhKM3cwKzFVV001eFRtdjVsOFVzQjJnTDhGNlBEaGh3S3hVbkY3MVVDY3da?=
 =?utf-8?B?eDcxTVA0UlVsZXliOURKMmF6dW05WHFDRFpUcjR2NkRLenA4OVR5WlRVR29K?=
 =?utf-8?B?WW02THZJdThWajQ3SVZxUXplcGgyTnBmamlCZWVIL3J0aW1pejlKYjNZcUlo?=
 =?utf-8?B?MTV5QWRqaFpBam9qUko5amFDbjRXYzhyRCtjV21qZkV1OC92bTVXVHhCL1lK?=
 =?utf-8?B?Q3VSTXdEMEMzVVE4dExsVWhZbGJPdi9Da1NoWnZDQWlCWTlKTU1FNzZxc3lN?=
 =?utf-8?B?VWRJNUhOZ01xMlpHYk9yb1BYbFExZ1JuSWgrNlpNTFM5czFjekpKcEhMRXRE?=
 =?utf-8?B?dm4wQ2lqd0FMRVRTOUc4MDJSUjg5WlY2UGhwL3FiMkI4V2xhVDl2V2hoRWtk?=
 =?utf-8?B?UUU0dnRRMW96RytxY1VUcVJPdUFsRldrTUZscnlTZzFOeDh5UEY4enpWcDhU?=
 =?utf-8?B?MzJUcEJ1RSs2dytCUTJFU1ZQUTJ1bjJvc3BKbk9VMzNtS0ZzQis3cFc2Y05D?=
 =?utf-8?B?ZUZKNG1oZGNQaXluUzgyc0l4RW5Kb3Bna2VYQWNvN3RVT1RNVmRRWXUveEhn?=
 =?utf-8?B?NlpMbm11TnpVcDk3ejV6TUhpSFBRQXVkUExGRGxVTVdia3oyYVdlS1gvNG5C?=
 =?utf-8?B?Z3NnZTBpK1JHclRQNmN1RnkzVXdLb3cvQUU2VW5wQkhZWUQ3eVc0K0hJMWJa?=
 =?utf-8?B?OURXVGlLRGRYdmFFK2k2QnJ6SnpxRUtrZ1krTVdsYmtQNGJOREFpa3pJdlh6?=
 =?utf-8?B?eFhoTDl0azZTUlFNMTdZbkVNb3JyUlFmT3RCcU5rZVRSRzNFRlAyd0lQUUl5?=
 =?utf-8?B?QS9hVFhYbGFVTUhxVTVkWnY2NDM2d3c4dkhUS2Rsemk2MkNwdWNFNnJJejk0?=
 =?utf-8?B?VEN3eS9xRjhscHRBa3pLY21SY3ROYlNyaTJDMDZsbGU5aHE5eXNjUVFnMlJn?=
 =?utf-8?B?cE40d2s4dGE0bng1ZjlWbVdMcVk5TkpCdk1TNFkxcDB2Z1BMTmtUUEVOQjJF?=
 =?utf-8?B?VFNlL0NRbTVhMjdTMzFsUzR6YlZZU1IzdG53TXRJcmpRT3VKcU5NWnUwSTZx?=
 =?utf-8?B?c2M2QVIzbVVDcXNFWmxCcXpmNzgwSlhrNGpjOUR0NjlQbEFzSkhGUTFBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cndraTd4TE9lVTltUDV6a01VbEJRU0h2K2pTWk15L0RpNzBGQmQ3TjRPVHUw?=
 =?utf-8?B?cXNFeVVYNkZ0SW1sdzZMRmtBSldkemtoY1FPREJUME80REJUTzVzN0tWMDg5?=
 =?utf-8?B?eWF6eXQvU1Zyb1Q5YU9lRm1ua09la2VtOUEzaWVWWVc4U0FWZXJDTmZaVkVJ?=
 =?utf-8?B?b3ZydHRnTXZOZ1RncnBZNU9TaFlNVmZ4ZFRId1lLR0xUTy9yYUZiY0ErMjVI?=
 =?utf-8?B?Qlg5Z09JWmVlRWlaN0VjWDdzdDNNZW82UXFEQ0ZpdGMvYWdmRXRMRGRlTTRW?=
 =?utf-8?B?THExY1pjcko0TlRiOGp4OWZhWXh3NXJ1VmRVRXNDeXJyYWxQNnZxSGpzQklC?=
 =?utf-8?B?b1A4dnhkOHl6NGxuMk50R3IwbkVVUi9FOFVQWnU0UlNqL3ZKMVVTdGdOTTI1?=
 =?utf-8?B?a202WE91VXF4NG9nWHBJTW9uaW5HemNReFlocUdRUmFFOE15NXhSRlNKalg2?=
 =?utf-8?B?YlpjdTFBOURGODJkVW5UZTN5VXJQVkMzbURGUWh0T3FOZk1rWEpHZzVFcWU0?=
 =?utf-8?B?OFdkbWdRV2swOTJwY2xWWlFxeVJCYjBHZXdxajJ3QTFJUmhabjkwbSs5OTUz?=
 =?utf-8?B?SmREalZtcWdyRHlXbjJjN1dWVTMrZGZrR0x0WExqTGw2eWdvM29SSzVFbDQr?=
 =?utf-8?B?Q200czFldi84ZW9FZmp4aittUGY4a3F3Q3E0THRYQzQyQXJDQy9zSG1ONlVp?=
 =?utf-8?B?TGpLK0dVSkd6R05qVmQ0bTBMU09Vbit4TUQ2ZG5yV2hSTklPRkJVMWkwaExN?=
 =?utf-8?B?S3JZcVpCVUNvOU51VXF4cnlJajc2cGNWbmNVS1VxNGZDZ08vdXR1SkcyaGpL?=
 =?utf-8?B?aHhaWmkwQ0c5emFzWlZTOTNVZXZ6d29wdENsVW1FYUQ5c1YvN0tmejBKNHlt?=
 =?utf-8?B?ZWtDUEZTREYrZG42K1FjdHhzenNvY1Jvc1lsL3JFRW9KUVUzZFBSeVFPWUZk?=
 =?utf-8?B?eXRLZGpVNDFHZithcGFUYVM4TldjeWFsVmpIM0hFYXpjMFBFaTZvdDVEUTVV?=
 =?utf-8?B?ZUhhZ2pNdmpXOWx1V1g4R29pRVhyc0hGWTdFSDdjbGNORWZlM2JiMzI4WURC?=
 =?utf-8?B?bzViT3hTR3c3VlR2TVdvMjNiL2lUWDdIdDZ2cDNiS2NpZ0lTK3p1cjA4OHNF?=
 =?utf-8?B?RldZVUZ4OU80U25qbythdFJINWYwa0VmZXd3NVNrUjVxdGVXTlJORWJCRUdD?=
 =?utf-8?B?NDBEUGdTQkVpRkNtYVVHNnRRcWdlYzF6c00xN0tzdTl3M0NkSVF6alRGQkt2?=
 =?utf-8?B?c0dWaGU0L09oUkt3aXdBVVkwTERBVSszdmtsQTBKUi9idk15eiszL2QxVnI1?=
 =?utf-8?B?MW53ZlAvYWliNFVqSEtLRWk3TXJ6MTRIOFNiYUlld2VmTDBsbUdieTVwTGJ1?=
 =?utf-8?B?RXF2bmpac2hWYk9SYktVRTlKUUFOQU55ZVpJN2FidGxPUGhsamwvaU9MNFF1?=
 =?utf-8?B?dXJ0a2NpK3VZSWRucFd0UTA1VXQ1c2FvUzh0ODdMR2lEU3d5T2t2TStxQzBQ?=
 =?utf-8?B?TFR1TWdaTFBIdm1Zc0FaS3lhWnBqQ3g5RGxqWXEwQ0toSjA3S0dzaFZsTjNz?=
 =?utf-8?B?ZUhVV0tHR3I1WnVkd1ZKa0o4WHRUYTU1WllVRGFCTm9kenQ5d3phSjZhUVNa?=
 =?utf-8?B?U2l4bmZsNlArUWNHL01PWmgrbTJObkhmNDI4MzZtWGVnaDY2dmxuZmdXMU4w?=
 =?utf-8?B?eGkzMnArWEh5cWRQM0lIM3JmZUFxY1FNd1pNR2pXM3VMSzIxblZJSzZ4d3Zk?=
 =?utf-8?B?QjJML0htL29Zd29xOEZSL0lQc2V2ZDNJWFByR0NNZzdiRW5TWVZCTDc5RXh4?=
 =?utf-8?B?N05JQ1RuZ1pLcDcvVkFvVjk1dlRiZzVuNVVPUFQ5QzZEWU9hK20xTW1uNElO?=
 =?utf-8?B?RUpMK1FNY1Y4eHY3Z2VzTGpaWEpSa3drQm9LTGE5U3BoMDltL0dGQjdJNWJi?=
 =?utf-8?B?UDdWRTdIaGRvWkk2a3ZycGZ3OE5MZ0Y1ajJMdnZERjVsdU9JcjdNRUo4ZDcz?=
 =?utf-8?B?R0hweXM1Q2JCRzVhZEswKzRVNjExZEZRS3E0eDZMOE9jeW5PWFA2YU1SU0Ny?=
 =?utf-8?B?WTBrWndEMlNiUFR6VmpaWnZsbENuN1pnT29oenVWMFRUVjcrQjdYUzVRM2tm?=
 =?utf-8?Q?LDTaWN9r0KEb0Vs+wDwpbsLdB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcca446a-e32a-4d25-e765-08dce3929f43
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2024 10:03:25.8564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKTrUI8AuAeZQI/cb9RbrLv7VuT3UA15m3ynekcQZhacACZE0WdLtURFo7id++l3RVdLUDML8EIDQmXCVUj4Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9085

> virtio_transport_send_pkt in now called on transport fast path,
> under RCU read lock. In that case, we have a bug: virtio_add_sgs
> is called with GFP_KERNEL, and might sleep.
> 
> Pass the gfp flags as an argument, and use GFP_ATOMIC on
> the fast path.
> 
> Link: https://lore.kernel.org/all/hfcr2aget2zojmqpr4uhlzvnep4vgskblx5b6xf2ddosbsrke7@nt34bxgp7j2x
> Fixes: efcd71af38be ("vsock/virtio: avoid queuing packets when intermediate queue is empty")
> Reported-by: Christian Brauner <brauner@kernel.org>
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
> 
> Lightly tested. Christian, could you pls confirm this fixes the problem
> for you? Stefano, it's a holiday here - could you pls help test!
> Thanks!
> 
> 
>   net/vmw_vsock/virtio_transport.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index f992f9a216f0..0cd965f24609 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -96,7 +96,7 @@ static u32 virtio_transport_get_local_cid(void)
>   
>   /* Caller need to hold vsock->tx_lock on vq */
>   static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
> -				     struct virtio_vsock *vsock)
> +				     struct virtio_vsock *vsock, gfp_t gfp)
>   {
>   	int ret, in_sg = 0, out_sg = 0;
>   	struct scatterlist **sgs;
> @@ -140,7 +140,7 @@ static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
>   		}
>   	}
>   
> -	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
> +	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, gfp);
>   	/* Usually this means that there is no more space available in
>   	 * the vq
>   	 */
> @@ -178,7 +178,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>   
>   		reply = virtio_vsock_skb_reply(skb);
>   
> -		ret = virtio_transport_send_skb(skb, vq, vsock);
> +		ret = virtio_transport_send_skb(skb, vq, vsock, GFP_KERNEL);
>   		if (ret < 0) {
>   			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
>   			break;
> @@ -221,7 +221,7 @@ static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struc
>   	if (unlikely(ret == 0))
>   		return -EBUSY;
>   
> -	ret = virtio_transport_send_skb(skb, vq, vsock);
> +	ret = virtio_transport_send_skb(skb, vq, vsock, GFP_ATOMIC);
>   	if (ret == 0)
>   		virtqueue_kick(vq);
>   


