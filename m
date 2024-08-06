Return-Path: <kvm+bounces-23389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0050F949394
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC49DB27CC1
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0171D47AA;
	Tue,  6 Aug 2024 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NjJduVL2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282E3DF42;
	Tue,  6 Aug 2024 14:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722955550; cv=fail; b=YA02HpZeRdpG27UL6HrNOQUIoIOHQQKKqG9MMhUYuUUYlrnU0Cy4DBufVzm7BhsfEKFzTQW6P+Of7FtcZSrBs0ncKs8GlTdrqStysfhIAXOwzyXxWWRCFhTL3A+UZnwX7I7DVfuNQ97aqO2RAX61fM4/ueBwA+yDA9qXEevcgAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722955550; c=relaxed/simple;
	bh=b6MGg1N9bEgfjKLd2OjIvpVDAPVQLgxDnDAbIj+rWug=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bxpkSDniyl1CLxn+Zxi4tK5/qHRIXy3w62bydldPv8GgkhcWvJM7/2ZsDgbB1ZLYIreGHTeBV6LDCnjunqBNXH6NGarE1qs96jmwKz+A8h2tXZIQusiEnPIY2l/zpcQ9eljmWgsIJEU5cGZDpPd4BthktgnoTtA+gSYXKkfh5ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NjJduVL2; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zv6fDcqrZTI8RV8cQG/tGDriOQ2XYaV+ZQr47rF+Mxl7OhqFQMEPrE2+013HzyQ0AF0CIWLLr5SOYB7YbmODAHWkiHa9nmeY74gc2oH3iqLbojILN+OQVHRWAAKgIh1bgN+O+XcBlOP79MHy5u1Ue2kcLOia5PLlqIJYK5ZSzixoe4AKKEKl2tV6rsyJtkDoW9gX9wvxqeV52NJ37oIqjrKlnkDs3LS4T2LIGxJo5NW6nTWUE/NmhHOEx7/qo0dlH7DYOrfWkq09fcO154eIXwFAUrCaCctQPX12qZcuHC5Sj8QOVIXC8uyawViq13qUZgRq3BaVke7RVLlnR1EXvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8uU/72sJ+tn3MVWBcXmkC7b+dfBM9QXjE5lG6FkGnM=;
 b=ZZUJjwazgz5TvCtMyOtxumCBlCZL+DHYWbrsSUJnkLzskyG4W5eridvc0edtm/SDdRGouH9tCAAvO3J8uspZQhOMQljYDMZdIa0Hrl3NzQ/Il6z8nsNCcPU+RODeMi7Nzlg1w/O2zW1AWR/3OAAsPQ7tCG6YNCM4NydPLskmQwFMZBwhvZ9IWUc94Sda369fbJfjcVbQiJ4eONVnEUQymv4JG5NTsZEVdx3Qz4UlDVsKs7D0ZUTJGJfX/3Z5BBPEfzNTtfyplvb7SLcApxA8scVrdXL7eA+rReU6Diw9S1ZUJZS84mveTndmpxyfodfEDOD5myU5sgMOl82e2OmQLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8uU/72sJ+tn3MVWBcXmkC7b+dfBM9QXjE5lG6FkGnM=;
 b=NjJduVL2SCmvZQMcEpnVEgRxTySV7XN0xeYLxZ68hURFviGRTTWT3NX7OUsNmpNzyTs3e58xyFNuY1Lz9QeoBHoY3BeIHRHAPUkHz5B4IkqkfL+AFextoRC2imDEWNvSoYjY8tAl6KtE+FrJcPBZYOF4JpAj61zag4Rj3srTcH93BzwFrIsXDlYvP+uy2T990CX1vaFdFJrOd8k3an3HcpzLXh+uuuKEGTIc+SW0kDcRaCp+7fGVkHMp9slvAKNEwSSMtaoWgA7bkV5Tf0J4iKfwdOM8czjKrd9AzPETHcFRyiEhJ0mHb7+Ki/rAtCHXDY8nDyQQ8Cxf3jd8z3i03w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by CH2PR12MB4263.namprd12.prod.outlook.com (2603:10b6:610:a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 14:45:45 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%7]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 14:45:45 +0000
Message-ID: <69850046-6b14-4910-9a89-cca8305c1bb9@nvidia.com>
Date: Tue, 6 Aug 2024 16:45:40 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH vhost] vhost-vdpa: Fix invalid irq bypass unregister
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Jason Wang <jasowang@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "mst@redhat.com" <mst@redhat.com>, "eperezma@redhat.com"
 <eperezma@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240801153722.191797-2-dtatulea@nvidia.com>
 <CACGkMEutqWK+N+yddiTsnVW+ZDwyM+EV-gYC8WHHPpjiDzY4_w@mail.gmail.com>
 <51e9ed8f37a1b5fbee9603905b925aedec712131.camel@nvidia.com>
 <CACGkMEuHECjNVEu=QhMDCc5xT_ajaETqAxNFPfb2-_wRwgvyrA@mail.gmail.com>
 <cc771916-62fe-4f6b-88d2-9c17dff65523@nvidia.com>
 <CACGkMEvPNvdhYmAofP5Xoqf7mPZ97Sv2EaooyEtZVBoGuA-8vA@mail.gmail.com>
 <b603ff51-88d6-4066-aafa-64a60335db37@nvidia.com>
Content-Language: en-US
In-Reply-To: <b603ff51-88d6-4066-aafa-64a60335db37@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0241.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::6) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|CH2PR12MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: d787d717-0ceb-4845-6590-08dcb62673dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmNOcWc1Mjd6bkpNcmY5OC9LZ2xmTlR0ellyRU4xY3BSYnl6ZnplNkNiK0Ix?=
 =?utf-8?B?ZFN0SGlyNEU3RzFUNmJUK2tzcUNjaUFuVzdndDhyMGdkM2NmbVllQWMvbE9M?=
 =?utf-8?B?YXN4WW9FeG1FejZoSVhZREg4YVNHV0dJVERZYXNucFNuVklVNnZkanhOcGNQ?=
 =?utf-8?B?LzdJbmF5cjdOZVFtSnlXcHVFUGNCaE1sb3BTb2hGZEo0MTlNZW1SQ2FHSGZi?=
 =?utf-8?B?MjE2ZkhobnpHM1FhVFJUNUg5VVpzNjB0S2U0eTRJZ0k5VEJxV2RmNUJvcFRY?=
 =?utf-8?B?VWZrYWh4ZVBFSDVNdzkxWitTTzdFTy9LUk8wM0tjU0Vwa1Y1NDU0dFJadjBX?=
 =?utf-8?B?alBESERmYmJ4dWdMdGRuNFR1YTRpN3k5cER3NmlaS3RYK0QrM0FDdjVBcUgx?=
 =?utf-8?B?QlI0ZUVwNytKdmFQTHowRTllMklwK0tTUElEMVF0a2hMdVNMenI4VFJucXNJ?=
 =?utf-8?B?cGhWVUViakJyNXhTaTVoSWRwM2xtbW9xMFZKbjFYeWdONVdYYjR1Q1paT1FU?=
 =?utf-8?B?UU1ScFRFQ1ZJdUhpN05qS05TdHQxbEE0Z3pjd0RPaXJMT0NFeXVDNEx4UTY3?=
 =?utf-8?B?dW5qQnRjLzRJTDB3YWtzc0pkVGRzRmRBMGtzdEt4a3dvVGNPVm5GTHVMcnNP?=
 =?utf-8?B?VTFEdEYvQjZ5WFBxTExlNllhV2FSeXJrK2JQWVRwNkcvb0JSaGM1dEFGTjJw?=
 =?utf-8?B?cC9TdlJXS2xXK2dheFNHSkVFdWRERWxyZVN4VGJhWkJSU2x5ZmFWSDRlVVF0?=
 =?utf-8?B?VU8wVVJrT1ZEeXRXYnp5cUFUenlaUDNFcURDQUFMMXBnQWdhR1RVMUsvdE5s?=
 =?utf-8?B?d2RkeGJOOHdkcG5PdTcxVk9UdVBoZFEwVUNRTytSVWE4WkRNYitJRlZnMzNC?=
 =?utf-8?B?cmlhdTgrMjBjdUR3RVZPTWZyNUIyVjA2T0dSRGQybWtQTlhQUHd4WllmUEdC?=
 =?utf-8?B?L3JTWXRsV2RJVlFoOVcwWGtacnRZclk5N2toWUQ4NVNGWGE3UUY4RWF5RDV0?=
 =?utf-8?B?cGVROU1XcE9mdmVxdjZVRUNrVWRPamJKaWdia3pCdFo5WTJ1bW5YZjVnZ1Q1?=
 =?utf-8?B?QlNCUzJOaGwwaG1jVVdMRTBVUFdzb3ovYWRjK0xFVGladkZYcWwwN2tuc1ly?=
 =?utf-8?B?TjQ5N0ZrdFhvWjMvRCswQmZ2dmlmUVFwRXFuNWs5L2tGVlpOMllXNXFIZnVV?=
 =?utf-8?B?aWNWMjRVNWFHd0pqQ2hObURxSEhpOWFRT0IrenlobXIxaXo5aVpHWWYzazkr?=
 =?utf-8?B?eTdXRG5sSldDM2ZWUk9PMWd0SFcwNlRSbzF0NEJvN1JuL0dxa0V4UGYrT2pU?=
 =?utf-8?B?TmlUQWJoUllVSGR0ZXphcTFyWmIvS0UvVkxpSlVXdW9vNi9QVVJ4WE1QVUli?=
 =?utf-8?B?b2lPL2NqY1ZWcFdmeXFPdXdjcEpvWGx3clZucFo4SzhKSHQ2UXRCWENURG5i?=
 =?utf-8?B?WWpzakNrZ1JDWEJtTVVSOTJNUG0wakJIMS9nYTMxWG05QURMMW4xWUFjaElV?=
 =?utf-8?B?QSttQWJHVU12YmI0aEluOU9VS1ZzRVI4VWl6cGZYUmtDVkRYNFdnMS96VjUx?=
 =?utf-8?B?TUN3bGxqamQ2QytOSWZBU3d0aFdjeGVTVEJqcS9Xd3VSdVRoVlhlYi9qaGJs?=
 =?utf-8?B?OTAxb3kvbmtaVmsvcCtKenNvZThRYnc4cmFGa01GaUFXOG9XaVIvaVIvMUFX?=
 =?utf-8?B?ZWRoNHUrVnNneDlXOXBWb3V3Z3JseHhsbUNsQ0tDYmh1cDdGZ2RMclhRM2cx?=
 =?utf-8?B?dDZPYlJlK1hwMTgyNlBzYlRJVlhpL09jRkJRNllMRk9PUTVidTF6Q0s1QlVo?=
 =?utf-8?B?eU5CSS81alVTSVBJUUpvQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkpabE5rakMwWlBXYUZkejB1bFc3Q1NwTGpQM2tIbjZGSnkvUWRkK2lWcWpa?=
 =?utf-8?B?NlZpYWZhM1hpajNuMGt3empFS3dKc3JMaldEN25QMkVMR1RFNUNiWVJaVEJo?=
 =?utf-8?B?K0hJZWpVb3NMQ015TWJsMXdTNDE2V29uaitxZkgzdzRPOEo1cGRiQm11d3lX?=
 =?utf-8?B?NkhXNGk0R0JnKzFhbnljKzNqYWMrNVpQaHNqaVhOTnRUd2VqY0pjWHRoUEFi?=
 =?utf-8?B?aCtZRE1CbHprSDE1K3NPOHR0b2pES0M2RjhIbm45anlnYXBYWlBOWTMyWjdj?=
 =?utf-8?B?aTFsL2VEQUtyQ2NUMU9sNHoyRmlvL3RGQTlCL0xIZmdxbVcwM01Qb1hrdWhs?=
 =?utf-8?B?b0syQVBlUU9wY3lmZGpFK1RpRmxsd284V2YyQ2wxbHJuZDJROFE4THVMMTBt?=
 =?utf-8?B?TzFIcXFSbkM0dzkvMkloanY2OXpDdC9uVkpVV2NSV1Q3OVRKWHp2VGtzSUhM?=
 =?utf-8?B?VDZrcDIzdjlSUnMvYkdXRHg0ckpPbXU5dG5WRWQ4NjJhMTBscW55M1NYbWw1?=
 =?utf-8?B?Q01NeU5lRnNXTE4wQVZncXdwRnlrL2RBaDdRL2JVMFFhQ1BBNlFxZ0xiMEFS?=
 =?utf-8?B?UlVxVmt2N1NJbmtnNWFRRE40c3duN2UrNTRlNWFPWTN1akViNWZGeGVMejVY?=
 =?utf-8?B?RlRwa0ZXS1MzZWVKMG4vcUg4aHcvRnVGemVlTllQMmhtTmRDdU5RWnFqWjRE?=
 =?utf-8?B?VnlsMmJJMHhHaDZOK2pGb3FTbXkxV0cydTdaVzJSL1RRV3IxT0RVVVJHanRw?=
 =?utf-8?B?bnJuUVNVRWRyVVo2aHhreUpXZWNBdUhiOXIycmY4UWlGOU1BMUFLZWFJQitn?=
 =?utf-8?B?b0xYTGRzUHlJYS9tZzVVYUhmYjdjWU1lRjhDUW9JdVpPUlN6TmhzRWxFajFs?=
 =?utf-8?B?TjdYU1pYQnpVNGdFTy9hNDlNcUlYd2FlR2gyNW1ncHcvVHJld1JYMUdBTzVi?=
 =?utf-8?B?bENWVWpJUXZDem9YWDhGRitpeFp4M0lvSHZubnJ6aWljUEdsdWp4S0xRUVBa?=
 =?utf-8?B?d2IrRGlvMHhtZGJlYmV5bGVxUmRHK1dqQkJqaVNnRUVOMW02L1J2aDV4bWtF?=
 =?utf-8?B?MTRyMjlkL1F4bjRqZHk3Y1U0WTZVWFBablNSVDVteHpxVlhoVXBDQXNSS1dF?=
 =?utf-8?B?U0dBZGtTOVBTdkRqRGtsMHUzelYzSjRxMy9Ob1RHZlZvakFMY2xXZndEYVRB?=
 =?utf-8?B?a2lBVG9IMkVkVWpZU2gzS1RTU1dvcWJLOUlMSVNRWTEyY0NuRzgzSEZxN1JZ?=
 =?utf-8?B?VDU1TzhSSjBwdmZ2SmNINjVsMTlWb1YreXU5ZTV0bUVzcG9aUWVuSWJsb1JS?=
 =?utf-8?B?OWlCM283YUNMOW1wQTZxZHpmTmxEZ0pqMVh3Uk54blBmYW1ORnlrYjE0dEFW?=
 =?utf-8?B?S1FqMWY1MUNnTFFQNnR3SkFLaU9SRVBaN3JnTy9QL2gzemo2c1FLemh2YTF6?=
 =?utf-8?B?V0lVbTN4UVM2SFBQRkJ0N2VxTVQwaGZoUXFVQnorSjBqc2xJMHcwS213YTM2?=
 =?utf-8?B?dURhVjNxL29wdXFnN3lZMjlOOEJqUzlsc0xHdTZ4dE95c0NSU2NCYnBaNisy?=
 =?utf-8?B?bGNTMHBtUHF6aEVqbzNpeDFTd2YwQ0FkSkxOb09UVXVVNVFrZVh4VEpNQ1Zs?=
 =?utf-8?B?MXdIQjF0dThwZUh0dDAvaDZTN2ExK0ZlNDkreTdsb3ZLZS9GYnRtdWJLakIz?=
 =?utf-8?B?cnlkK1owQ0ZzNTlZMTY1bXpZYnFjRDkwcVFRcHNNWnJzTlpnWThXN1FGaFdj?=
 =?utf-8?B?d1JRT1AxWGIrMDRLVEJhY2t0OUNoWkdWa3Y0VC9nekRDdGpnQkV3NTFManhp?=
 =?utf-8?B?TXhsZ1pia1FJWE9jL1ZhS3d3U2lHelRqY1prQ0UxL0JvZmxTK3pCUU44ckt1?=
 =?utf-8?B?RmlvNTVlL3NURXdWM09KSUs0cHVmWEFTemdrcUFPTnR5L1FndE82ODlFV0t3?=
 =?utf-8?B?aVBlTXpWVWNyQ0FZSTJsNnBJc2ZBZS96cHYrYTduRHY3QW5PU0dZMWROdmQ0?=
 =?utf-8?B?NXQrYmpkV0xWQmE4M24wYnAybnVPSm9uMGZhM2dpQjJlSjMveHNPTmQ4eElk?=
 =?utf-8?B?S2dnbXM5Ymw4b3pvSC92bUZMK3pjaEgwZGM2R0N5eTRNcHZ0QjlTWjIxai8w?=
 =?utf-8?Q?9qThhgIL38i09JTYa5aTRZEXb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d787d717-0ceb-4845-6590-08dcb62673dc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 14:45:45.1198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R5q89+DchdQQGGYaCZRvG0YEu4xXx2sMmHSHyrMdHYxqlGFmjy7Uk1On70FxOkXOLkRI4wmAsL5KuL15VuZWTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4263



On 06.08.24 10:18, Dragos Tatulea wrote:
> (Re-sending. I messed up the previous message, sorry about that.)
> 
> On 06.08.24 04:57, Jason Wang wrote:
>> On Mon, Aug 5, 2024 at 11:59 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>
>>> On 05.08.24 05:17, Jason Wang wrote:
>>>> On Fri, Aug 2, 2024 at 2:51 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>>
>>>>> On Fri, 2024-08-02 at 11:29 +0800, Jason Wang wrote:
>>>>>> On Thu, Aug 1, 2024 at 11:38 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>>>>
>>>>>>> The following workflow triggers the crash referenced below:
>>>>>>>
>>>>>>> 1) vhost_vdpa_unsetup_vq_irq() unregisters the irq bypass producer
>>>>>>>    but the producer->token is still valid.
>>>>>>> 2) vq context gets released and reassigned to another vq.
>>>>>>
>>>>>> Just to make sure I understand here, which structure is referred to as
>>>>>> "vq context" here? I guess it's not call_ctx as it is a part of the vq
>>>>>> itself.
>>>>>>
>>>>>>> 3) That other vq registers it's producer with the same vq context
>>>>>>>    pointer as token in vhost_vdpa_setup_vq_irq().
>>>>>>
>>>>>> Or did you mean when a single eventfd is shared among different vqs?
>>>>>>
>>>>> Yes, that's what I mean: vq->call_ctx.ctx which is a eventfd_ctx.
>>>>>
>>>>> But I don't think it's shared in this case, only that the old eventfd_ctx value
>>>>> is lingering in producer->token. And this old eventfd_ctx is assigned now to
>>>>> another vq.
>>>>
>>>> Just to make sure I understand the issue. The eventfd_ctx should be
>>>> still valid until a new VHOST_SET_VRING_CALL().
>>>>
>>> I think it's not about the validity of the eventfd_ctx. More about
>>> the lingering ctx value of the producer after vhost_vdpa_unsetup_vq_irq().
>>
>> Probably, but
>>
>>> That value is the eventfd ctx, but it could be anything else really...
>>
>> I mean we hold a refcnt of the eventfd so it should be valid until the
>> next set_vring_call() or vhost_dev_cleanup().
>>
>> But I do spot some possible issue:
>>
>> 1) We swap and assign new ctx in vhost_vring_ioctl():
>>
>>                 swap(ctx, vq->call_ctx.ctx);
>>
>> 2) and old ctx will be put there as well:
>>
>>                 if (!IS_ERR_OR_NULL(ctx))
>>                         eventfd_ctx_put(ctx);
>>
>> 3) but in vdpa, we try to unregister the producer with the new token:
>>
>> static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>>                            void __user *argp)
>> {
>> ...
>>         r = vhost_vring_ioctl(&v->vdev, cmd, argp);
>> ...
>>         switch (cmd) {
>> ...
>>         case VHOST_SET_VRING_CALL:
>>                 if (vq->call_ctx.ctx) {
>>                         cb.callback = vhost_vdpa_virtqueue_cb;
>>                         cb.private = vq;
>>                         cb.trigger = vq->call_ctx.ctx;
>>                 } else {
>>                         cb.callback = NULL;
>>                         cb.private = NULL;
>>                         cb.trigger = NULL;
>>                 }
>>                 ops->set_vq_cb(vdpa, idx, &cb);
>>                 vhost_vdpa_setup_vq_irq(v, idx);
>>
>> in vhost_vdpa_setup_vq_irq() we had:
>>
>>         irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>
>> here the producer->token still points to the old one...
>>
>> Is this what you have seen?
> Yup. That is the issue. The unregister already happened at
> vhost_vdpa_unsetup_vq_irq(). So this second unregister will
> work on an already unregistered element due to the token still
> being set.
> 
>>
>>>
>>>
>>>> I may miss something but the only way to assign exactly the same
>>>> eventfd_ctx value to another vq is where the guest tries to share the
>>>> MSI-X vector among virtqueues, then qemu will use a single eventfd as
>>>> the callback for multiple virtqueues. If this is true:
>>>>
>>> I don't think this is the case. I see the issue happening when running qemu vdpa
>>> live migration tests on the same host. From a vdpa device it's basically a device
>>> starting on a VM over and over.
>>>
>>>> For bypass registering, only the first registering can succeed as the
>>>> following registering will fail because the irq bypass manager already
>>>> had exactly the same producer token.
>>>> For registering, all unregistering can succeed:
>>>>
>>>> 1) the first unregistering will do the real job that unregister the token
>>>> 2) the following unregistering will do nothing by iterating the
>>>> producer token list without finding a match one
>>>>
>>>> Maybe you can show me the userspace behaviour (ioctls) when you see this?
>>>>
>>> Sure, what would you need? qemu traces?
>>
>> Yes, that would be helpful.
>>
> Will try to get them.
As the traces are quite large (~5MB), I uploaded them in this location [0].
I used the following qemu traces:
--trace vhost_vdpa* --trace virtio_net_handle*

[0] https://drive.google.com/file/d/1XyXYyockJ_O7zMgI7vot6AxYjze9Ljju/view?usp=sharing

Thanks,
Dragos


