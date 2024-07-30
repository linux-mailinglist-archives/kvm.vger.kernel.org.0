Return-Path: <kvm+bounces-22674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1D0941336
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 15:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBA2AB2726C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 13:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0461A08B2;
	Tue, 30 Jul 2024 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qn6Y8qPv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9E11A0719
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 13:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722346439; cv=fail; b=hXUigjvIcTk1z+IbyMfNJtBSgacTeTpPUgmH8EB6ZRv4XoGJIY4Kyb43pBPzleCFt5ndszCdvErNNdFaVz7FnARw3lB4wkG/dY3IWMA+n2w+Z0CRKCdaxSWDgbU7o19COzrONed1/PFG4K3hNpkuSGxyCYQUI8PqM1MPovb82Kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722346439; c=relaxed/simple;
	bh=pfEBN+MdSKWKU7os5eccCefB2gtvrd4CW+l3WsiGdV0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p6WTpcoLzkVib7mZC3kQ1JVYEIJnC7efB1cG11PUqs0f8vAvZGczeFIiJSxPakL2QG4ikn4kdl1wvwUjLsC5ZXT+H7Rd3Nyu027lYTdDVviniXym/R0ASp1K+OYhRxtQgb7ytbBWHyAba/3vXqHCUrl2bEuSe3Yc9et3wKyLlb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qn6Y8qPv; arc=fail smtp.client-ip=40.107.236.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S8bjJRUqBd3ODxRLXhJ+2muPBcDMcefdBwswDkNCbzjsy4xeIKf6eiNsWmU01xsO5wIgZ2paw2KiuGgsKUJxKxZtyuYlS8mCru41hLvva2ApiI3MhD/xX1VPTaFFbdEYYX9zWYFj6PxwFsNa5bLykTT3AayZt+Ru8i87t6JGOYPefUjBDykFdcQlrObaGz6V369AcmwoQxNsmRFCMga15PD1Fn+XAbbo4moKEq+8gYpfAs34nx/a9y+SOCvwxv/daWjt2/JgwgWSpJc4hcsWI6YwFIkYoMpdI3vzVS9hafND+4NLgmGJ6c34ce20+azXrmyFUD/1o9Z1iWdB5ToG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMlUjwW6lf1Jym/HW6MX9NE6dYvNtx3uj2pPSlwVBwY=;
 b=HGborSZakw8EzEAxRa9dCXU8/DFwU59tVkBiv4zvu3u1yAT5LzVbp3blQaUeGGDwULX2LZ5GGuUyfRhx+/U9/WklaNCw4tduBpVMOCA9+YA79Gj4exr/ICWYoDiER+oL2ocYLXtl1vGf/hAHiX8VJ0ibyyvLo6+cekiT/Dvgi4//YJPFUfwmNIXisWIr2Wj8qBPih5ll7AP2eJUa8rOYdLWqSEjqNnA6xeoeE1Ds4cpIBvIS8hiSx2eR5tLGCQg1N2xf9m3ea4ebzIOGQYIcWZJ1GfyUjs3lPYrqscb3nYw3nNsQASXP9wv0Da130mDWniqg7E3Az+zWaPWt0kx/Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMlUjwW6lf1Jym/HW6MX9NE6dYvNtx3uj2pPSlwVBwY=;
 b=Qn6Y8qPvDTqTagY38akAjbGQThKUV+2Bm2B4JtV6YenYvSS1uQuWZrS1z5YHc97/TACGckfiuEQHd3xKht4zeOybF+pKnIwEUlo8wsYzOIpxVdV4d0Qwwtnx5FO1CpMg9crippk0uBPQB7RkWEFzk+ZMpYNbv+HhQ2KVrhCXr+kRlUTl6CplqiqU65kq8VJTEUKTh4+Ddwqs6mmzzrMUxpyNahjuOf+Amc67BQC5kjbX1YPVyW0+UnvR7+uq5iSjRubL418IsWDNcuuo67lYqGHE76mFmyO7ZywDpbgnvnlanuPzfwgjegDyVZ/uLb/QI1inO7lT7IO6sMJG4thdAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13)
 by DS0PR12MB6535.namprd12.prod.outlook.com (2603:10b6:8:c0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Tue, 30 Jul
 2024 13:33:49 +0000
Received: from DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::e2a0:b00b:806b:dc91]) by DM6PR12MB5549.namprd12.prod.outlook.com
 ([fe80::e2a0:b00b:806b:dc91%6]) with mapi id 15.20.7828.016; Tue, 30 Jul 2024
 13:33:49 +0000
Message-ID: <9b147a34-4641-4b4c-a050-51ceb3ea6a67@nvidia.com>
Date: Tue, 30 Jul 2024 16:33:31 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/18] qapi: Smarter camel_to_upper() to reduce need for
 'prefix'
To: Markus Armbruster <armbru@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, alex.williamson@redhat.com,
 andrew@codeconstruct.com.au, andrew@daynix.com, arei.gonglei@huawei.com,
 berto@igalia.com, borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
 den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
 farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
 idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
 jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com, kwolf@redhat.com,
 leetroy@gmail.com, marcandre.lureau@redhat.com, marcel.apfelbaum@gmail.com,
 michael.roth@amd.com, mst@redhat.com, mtosatti@redhat.com,
 nsg@linux.ibm.com, pasic@linux.ibm.com, pbonzini@redhat.com,
 peter.maydell@linaro.org, peterx@redhat.com, philmd@linaro.org,
 pizhenwei@bytedance.com, pl@dlhnet.de, richard.henderson@linaro.org,
 stefanha@redhat.com, steven_lee@aspeedtech.com, thuth@redhat.com,
 vsementsov@yandex-team.ru, wangyanan55@huawei.com,
 yuri.benditovich@daynix.com, zhao1.liu@intel.com, qemu-block@nongnu.org,
 qemu-arm@nongnu.org, qemu-s390x@nongnu.org, kvm@vger.kernel.org,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-2-armbru@redhat.com> <ZqiutRoQuAsrllfj@redhat.com>
 <87mslzgjde.fsf@pond.sub.org>
Content-Language: en-US
From: Avihai Horon <avihaih@nvidia.com>
In-Reply-To: <87mslzgjde.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0013.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::9) To DM6PR12MB5549.namprd12.prod.outlook.com
 (2603:10b6:5:209::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:EE_|DS0PR12MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: b635dc1c-a7d9-4b12-776b-08dcb09c3e88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bDYxNkk0bmJVbnZXMEVSRkxDTGJZMTVQaHNjSHh5MVViak1FenBOaGg4RWdT?=
 =?utf-8?B?NXdQbmQyQkIzTWtYSlhaMWNXSmE4eFRidTBVUGYvZkxDWnFscWhSNlErSkc1?=
 =?utf-8?B?bzljTE04dTFWdDQwbzEyZHhBL1FrZk51T1d6YWhUeXFibVYydll1dXN0T2Iy?=
 =?utf-8?B?OU5jN2dsekZ3MVJtVmlxUTd6VjJCSDdBTHRPYnZFQW9kMkRuQ1hVZXVTLzZL?=
 =?utf-8?B?WEE5U2duK3UvQTZwQjNCSDJBcTJzM0UvbnVtS2Y0dytvV1R2c2tKZTNSTys5?=
 =?utf-8?B?aitram1zZ3NIN01TNDVLM3V1cDNVTVFGbjBCaVV4YmhqM29XdVZVeXNJbzZD?=
 =?utf-8?B?aTcrU2xFeCtnSXRQTktQV01vVThDQVJJdExwUUFHSEUxdzdXQ1R1QmQrcklr?=
 =?utf-8?B?VVFlbGlSOENSZkR6d3BhTkpmQzVNWnNnMExRL1F1TjBlMWhYQ0hqUnVMUFN2?=
 =?utf-8?B?eElrMDFFOGJHSFRDMzNuSGdjOEZVeUlOLytRcW81ZGtvMTFEd1oyb05pNGdn?=
 =?utf-8?B?czV6Nm5uK2dmZ0tFZEFQY1REYS9XejU3N1REM2ZOUzErVHZqMkVmQkFtdksw?=
 =?utf-8?B?QlUrU24vU1ZnTWJGN0xoRjhiMGFoYmhhaVRZYzcxbTJzcm80MU5tdGhic1BH?=
 =?utf-8?B?dGIwVCszZ1IyNG1PR1pGczRLL05MQktPdVIrOGRQNEQ2aytsNGJ6QTJ4ck5F?=
 =?utf-8?B?bUNUbHh3NkxIcCt6OXNXb0dnelVQRldmZGJsSEFnZEc3eTZmWmFMb2ZkYmMw?=
 =?utf-8?B?cEFDNUpvemcrN2lUSXNoOWd2ajB5d01WK2FKT0J0Tis4bWhQcXZmRU5pWWNV?=
 =?utf-8?B?WXE2cmd3aVhoa0xZeThYVXZqV0xiaUg3bGxiV1RvbXdMNUJEUjBlektCUUVL?=
 =?utf-8?B?ODJTMjhNdW44QVpBeGMxdDh3eVFPZEViaFFldzNwL0FBbE5wWEdJZFdNa1ZY?=
 =?utf-8?B?VjNxZWI3cytIcjdOeDl5V3pLNUZHQ2FRUUFNZlptVjczdkhaVTc3WFdmTHk4?=
 =?utf-8?B?MnRhTkovRWg2YmxpQXJiaHZYUGQyWHBrQ2NNNnQ3VGNYWnpwYnNPbFJ2TExQ?=
 =?utf-8?B?WmVzQ1JDeFRyUnJnYS9qeWxKbkkxZExjYVdPK0lzQ1M1eEFqSWk4Nk83ajMz?=
 =?utf-8?B?NjE1aitFYStic1NQUjErVnBmNjlwSUVRV0NjeVBvNzZkT3hYbnZyc1pRNlBt?=
 =?utf-8?B?TjJHQjZlYzNTdG4raW1uZ0RMZTJnd2xGSG1sUFduNFhHOGNEVDVZQ1k4b1Vu?=
 =?utf-8?B?UnJrMXVzbmovRStNQndyYWtMT05aWm5La20vcEVjRlF4V3RTMmQ2SFdrTmJW?=
 =?utf-8?B?TUd6b3oySnpPSFU0bThTVmlEeHVpT21KZHlkZDRPeGZnaEswNVlsdTg5ZzhN?=
 =?utf-8?B?WElPaGFvNnZXQXhOMnM4cHNRVUkvRjcyTlNXVW9UWjlKNXRSZGRxVldnV0li?=
 =?utf-8?B?K0RHbnRoZ0RzN252YjRyY0FiaWJxM2FrbUtVUnpFOGNTakFycEN4bFZTVVpz?=
 =?utf-8?B?SmxJTCs2VkFOV09INkMxcDI2MnZBdWt3cG5FSGxJYzFwaGxwQUJEV3I1SVVS?=
 =?utf-8?B?dExPbjJ6OFJYaElFRytKYmNmODBnMU1MTVMycDhmWWNSUUdYRFFJeHozQTVD?=
 =?utf-8?B?V2JIVlFWNHdmNzVaNS90c0FKVG5CaXpQRmxENi9FYXZZMm5yS016d1A2R01N?=
 =?utf-8?B?Ri9iTlFSNk4zamJYemx2WjFZRkFOeTI1dVgrNHNTMnYxS1NWZTh3ckR3S1V2?=
 =?utf-8?B?REtEbmRMc0plQ2F6UG5xZFdYOWhXajJ3RFg0SDN1MUxGZElYdmo5dS94bStY?=
 =?utf-8?B?eGd1NVJmL2oxdEYyZ3YvUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5549.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KythcWNwK0poelFHb3o3MHNUejNlWXpiZWgvTzQyNHZTYnBJdXFubUlwVHlB?=
 =?utf-8?B?V2liTUZ6TkswRWtjUmpwY01nRVhrazViMlZqU2E3QkZEMWVGNi9GcG04bkN5?=
 =?utf-8?B?QWEvRUQ0czIraGtRVW1ubTVRanpta3VvRlBJN2c4QWlocGFlZlZ0ZkNpbHE3?=
 =?utf-8?B?QkVmRFBZcXBERUZnMmRqWDMvSHhick96eUVXaXB6ei9uTDM2WVhlSkk0V1RM?=
 =?utf-8?B?MTBsSE5LRXdPMjJqRTVQdnBsWVZOK2JBSVV0VEFCQ1NlZ2hHS1dBNml6a0Vn?=
 =?utf-8?B?NmdQSGpTaDhiNGNVdStBcTh1U2hBYUsvU1dtNHdvWFA1NWduZnl4WjAxZ08v?=
 =?utf-8?B?R1lQNVFHc01UdlRjdDZrRTdwUWZnQytuempNeWJobVZkSUtET3lFMG4yWFZR?=
 =?utf-8?B?ZWRiaGZNTWMyeXk4cDFCSXRKVGRSMUpscVF5TE5NSEdNZ0VvM1lpclp6dUVV?=
 =?utf-8?B?K1Arb09nRnhqSGNqSDUvSjA4Z2pmSjZraW5uTTh5UWtSc1FSUGRCTTJDZERY?=
 =?utf-8?B?bkdtcGhiK2dVYnhXMGlvZ2lrOHJ1c1NPMi9GbWxqL29tN0FQc0lHZ3prUW9G?=
 =?utf-8?B?RngrZmpjMmdKazJOMzRiZE5qdFVSUGJydEhJSjF3QXplQzlMVTF5QjV4OFZD?=
 =?utf-8?B?SSsrL1hUTVh1VjQ5MVp4RDkrZmJPc1BnYkYvdGZaNlllWlMrVnpqRmRKczJQ?=
 =?utf-8?B?VEovS0NlYW5DU3BjMzRza1FtWEFiMmtUcGg1MVRITFpqVDk3VXhWUUk5Qlpt?=
 =?utf-8?B?YlVqVWRJekZDVDIvUGVpZUEwMjkzc3RJa25leTlIWXhRd0xXcjBvV0o1eFBM?=
 =?utf-8?B?b2xtcG9qREpFNzdERFdiaDY3Ui9JeVA4RXlvVnBZODQrSlYvY0p6aVBzWm93?=
 =?utf-8?B?aFJIajVubFNucVU5cVFrNSs1SkRKRkliWDZvemdvdGw1RWFCSXpZWkxFM2s4?=
 =?utf-8?B?V0RGNnUxZFhXOVBRWElCU0JCd0FCZFhvSmtES2FqSXY5UHc5UndDVEJMUXBH?=
 =?utf-8?B?b3d2VTVKTmE0c0lKdlJRNk5ST0NWT25OVUJqc0cwTFJiRTJsSHdqWEIrQ3Vr?=
 =?utf-8?B?dGh6T29ERTNaVzJ0SlRNL1RnYTlVbnJnMVI0cGNkMHArcmoxMmFQcDY5Yjd1?=
 =?utf-8?B?VzA0RkxJQU1meEh5NGtaRmtMb2ZmSEdZdEp1bnFNL1VCcVB6ZmNHbzRFWHRS?=
 =?utf-8?B?QVRGanRxdDBTblJnWnZaVlFad1M4RTFQMU9VWGRSUDAyandLb1pFTHFGbDE0?=
 =?utf-8?B?WXdMdnZHS3lzZWJIclZETlRnY0pnS093SGdvcnFjZlVvdmZuSTBkNHcrd0d3?=
 =?utf-8?B?RFJQK0krbkp6RW53OVdIVjBTbmUwd0RnWUdyUFZ4RkJMU1krRFFQUVJuN0dp?=
 =?utf-8?B?Q3gvTEQ0NjdYdEQyNEJ6Y2JCTFFFQ0lJcWJvRXhDSEFzcUt5NFJReWhJalk5?=
 =?utf-8?B?c2dnK3pMdHUvYVBXbFp0TVpKVTFiWmtIUHlVZ09KM2U3dE5hWHErMmFJV3U0?=
 =?utf-8?B?b0RRVjNLeUNlRUhUVmFyR21KMlROUDZ5TzFZbnNTWHIxUXdTTE1LWWdsb2JT?=
 =?utf-8?B?TVpkb0JMS1BEZ0hIa0U0RmZlcElYazE2SDNzNWQ0b0o2aVJrQy9MeEwxUGxz?=
 =?utf-8?B?M2pDZjBKdHEwbklmNE53b09HOVZQbTZiMWg2VWRsN1Q0R0t3V2VzaGVvd2JS?=
 =?utf-8?B?amhmT1VpYzRGY3VocmJHNW1La3FqTTZjU1MxNm9KdGdLaWt5SStVdWlvdVRu?=
 =?utf-8?B?YlRNd3ZZTkNqQjZscm9QTyttWERUZXBNMEFKZWc3WmdaUmdhdGNYK3JhMFMz?=
 =?utf-8?B?M3BxUnZiV3ErQWtXY3VqeCszZW12VkgrUjNZNkNGNzlhdytsUStyNUhQN1gr?=
 =?utf-8?B?Qjd6V3YzckpYYlVaWCt4UGVVRHBvQTBrYnp4UVllVUZLeERIVmZNcGhrZDdi?=
 =?utf-8?B?Mi91eHJ3b2NuUEx4T3lFTERyVUIvM204RDhCR21iQWZqcFUybExFbEVkdVRK?=
 =?utf-8?B?dDIyUDNEQlNrdXpHNGZIOFdPU2Qxb1FneWF3SWhCVEtGTFhLQUdsUktLRmRH?=
 =?utf-8?B?RE5ITFgxdEN0UDJNOXkxOWZvZEROc3h2RC9qbC9pbXBtamRUK2x3MnhyZXQy?=
 =?utf-8?Q?KCgNE1NT8GlwoXo7suf3Wo431?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b635dc1c-a7d9-4b12-776b-08dcb09c3e88
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5549.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2024 13:33:49.2835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9+baKPkIvMWRNd6dRd8/O0VT97Kx8ULu/TemtZb5g+tgQYBCdnC0o2bi4cjBu3kNihMjaJMpgKXCUOxtsrYXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6535


On 30/07/2024 15:22, Markus Armbruster wrote:
> External email: Use caution opening links or attachments
>
>
> Avihai, there's a question for you on VfioMigrationState.
>
> Daniel P. Berrangé <berrange@redhat.com> writes:
>
>> On Tue, Jul 30, 2024 at 10:10:15AM +0200, Markus Armbruster wrote:
>>> camel_to_upper() converts its argument from camel case to upper case
>>> with '_' between words.  Used for generated enumeration constant
>>> prefixes.
>>>
>>> When some of the words are spelled all caps, where exactly to insert
>>> '_' is guesswork.  camel_to_upper()'s guesses are bad enough in places
>>> to make people override them with a 'prefix' in the schema.
>>>
>>> Rewrite it to guess better:
>>>
>>> 1. Insert '_' after a non-upper case character followed by an upper
>>>     case character:
>>>
>>>         OneTwo -> ONE_TWO
>>>         One2Three -> ONE2_THREE
>>>
>>> 2. Insert '_' before the last upper case character followed by a
>>>     non-upper case character:
>>>
>>>         ACRONYMWord -> ACRONYM_Word
>>>
>>>     Except at the beginning (as in OneTwo above), or when there is
>>>     already one:
>>>
>>>         AbCd -> AB_CD
>>>
>>> This changes the default enumeration constant prefix for a number of
>>> enums.  Generated enumeration constants change only where the default
>>> is not overridden with 'prefix'.
>>>
>>> The following enumerations without a 'prefix' change:
>>>
>>>      enum                                 old camel_to_upper()
>>>                                   new camel_to_upper()
>>>      ------------------------------------------------------------------
>>>      DisplayGLMode                   DISPLAYGL_MODE
>>>                                   DISPLAY_GL_MODE
>>>      EbpfProgramID                   EBPF_PROGRAMID
>>>                                   EBPF_PROGRAM_ID
>>>      HmatLBDataType                  HMATLB_DATA_TYPE
>>>                                   HMAT_LB_DATA_TYPE
>>>      HmatLBMemoryHierarchy           HMATLB_MEMORY_HIERARCHY
>>>                                   HMAT_LB_MEMORY_HIERARCHY
>>>      MultiFDCompression              MULTIFD_COMPRESSION
>>>                                   MULTI_FD_COMPRESSION
>>>      OffAutoPCIBAR                   OFF_AUTOPCIBAR
>>>                                   OFF_AUTO_PCIBAR
>>>      QCryptoBlockFormat              Q_CRYPTO_BLOCK_FORMAT
>>>                                   QCRYPTO_BLOCK_FORMAT
>>>      QCryptoBlockLUKSKeyslotState    Q_CRYPTO_BLOCKLUKS_KEYSLOT_STATE
>>>                                   QCRYPTO_BLOCK_LUKS_KEYSLOT_STATE
>>>      QKeyCode                        Q_KEY_CODE
>>>                                   QKEY_CODE
>>>      XDbgBlockGraphNodeType          X_DBG_BLOCK_GRAPH_NODE_TYPE
>>>                                   XDBG_BLOCK_GRAPH_NODE_TYPE
>>>      TestUnionEnumA               TEST_UNION_ENUMA
>>>                                   TEST_UNION_ENUM_A
>>>
>>> Add a 'prefix' so generated code doesn't change now.  Subsequent
>>> commits will remove most of them again.  Two will remain:
>>> MULTIFD_COMPRESSION, because migration code generally spells "multifd"
>>> that way, and Q_KEY_CODE, because that one is baked into
>>> subprojects/keycodemapdb/tools/keymap-gen.
>>>
>>> The following enumerations with a 'prefix' change so that the prefix
>>> is now superfluous:
>>>
>>>      enum                                 old camel_to_upper()
>>>                                   new camel_to_upper() [equal to prefix]
>>>      ------------------------------------------------------------------
>>>      BlkdebugIOType                  BLKDEBUGIO_TYPE
>>>                                   BLKDEBUG_IO_TYPE
>>>      QCryptoTLSCredsEndpoint         Q_CRYPTOTLS_CREDS_ENDPOINT
>>>                                   QCRYPTO_TLS_CREDS_ENDPOINT
>>>      QCryptoSecretFormat             Q_CRYPTO_SECRET_FORMAT
>>>                                   QCRYPTO_SECRET_FORMAT
>>>      QCryptoCipherMode               Q_CRYPTO_CIPHER_MODE
>>>                                   QCRYPTO_CIPHER_MODE
>>>      QCryptodevBackendType           Q_CRYPTODEV_BACKEND_TYPE
>>>                                   QCRYPTODEV_BACKEND_TYPE
>>>      QType [builtin]                 Q_TYPE
>>>                                   QTYPE
>>>
>>> Drop these prefixes.
>>>
>>> The following enumerations with a 'prefix' change without making the
>>> 'prefix' superfluous:
>>>
>>>      enum                                 old camel_to_upper()
>>>                                   new camel_to_upper() [equal to prefix]
>>>                                   prefix
>>>      ------------------------------------------------------------------
>>>      CpuS390Entitlement              CPUS390_ENTITLEMENT
>>>                                   CPU_S390_ENTITLEMENT
>>>                                   S390_CPU_ENTITLEMENT
>>>      CpuS390Polarization             CPUS390_POLARIZATION
>>>                                   CPU_S390_POLARIZATION
>>>                                   S390_CPU_POLARIZATION
>>>      CpuS390State                    CPUS390_STATE
>>>                                   CPU_S390_STATE
>>>                                   S390_CPU_STATE
>>>      QAuthZListFormat                Q_AUTHZ_LIST_FORMAT
>>>                                   QAUTH_Z_LIST_FORMAT
>>>                                   QAUTHZ_LIST_FORMAT
>>>      QAuthZListPolicy                Q_AUTHZ_LIST_POLICY
>>>                                   QAUTH_Z_LIST_POLICY
>>>                                   QAUTHZ_LIST_POLICY
>>>      QCryptoAkCipherAlgorithm        Q_CRYPTO_AK_CIPHER_ALGORITHM
>>>                                   QCRYPTO_AK_CIPHER_ALGORITHM
>>>                                   QCRYPTO_AKCIPHER_ALG
>>>      QCryptoAkCipherKeyType          Q_CRYPTO_AK_CIPHER_KEY_TYPE
>>>                                   QCRYPTO_AK_CIPHER_KEY_TYPE
>>>                                   QCRYPTO_AKCIPHER_KEY_TYPE
>>>      QCryptoCipherAlgorithm          Q_CRYPTO_CIPHER_ALGORITHM
>>>                                   QCRYPTO_CIPHER_ALGORITHM
>>>                                   QCRYPTO_CIPHER_ALG
>>>      QCryptoHashAlgorithm            Q_CRYPTO_HASH_ALGORITHM
>>>                                   QCRYPTO_HASH_ALGORITHM
>>>                                   QCRYPTO_HASH_ALG
>>>      QCryptoIVGenAlgorithm           Q_CRYPTOIV_GEN_ALGORITHM
>>>                                   QCRYPTO_IV_GEN_ALGORITHM
>>>                                   QCRYPTO_IVGEN_ALG
>>>      QCryptoRSAPaddingAlgorithm      Q_CRYPTORSA_PADDING_ALGORITHM
>>>                                   QCRYPTO_RSA_PADDING_ALGORITHM
>>>                                   QCRYPTO_RSA_PADDING_ALG
>>>      QCryptodevBackendAlgType        Q_CRYPTODEV_BACKEND_ALG_TYPE
>>>                                   QCRYPTODEV_BACKEND_ALG_TYPE
>>>                                   QCRYPTODEV_BACKEND_ALG
>>>      QCryptodevBackendServiceType    Q_CRYPTODEV_BACKEND_SERVICE_TYPE
>>>                                   QCRYPTODEV_BACKEND_SERVICE_TYPE
>>>                                   QCRYPTODEV_BACKEND_SERVICE
>>>
>>> Subsequent commits will tweak things to remove most of these prefixes.
>>> Only QAUTHZ_LIST_FORMAT and QAUTHZ_LIST_POLICY will remain.
>> IIUC from above those two result in
>>
>>                            QAUTH_Z_LIST_FORMAT
>>                            QAUTH_Z_LIST_POLICY
>>
>> Is it possible to add a 3rd rule
>>
>>   *  Single uppercase letter folds into the previous word
> I guess we could.
>
>> or are there valid cases where we have a single uppercase
>> that we want to preserve ?
> Not now, but I'd prefer to leave predictions to economists.
>
>> It sure would be nice to eliminate the 'prefix' concept,
>> that we've clearly over-used, if we can kill the only 2
>> remaining examples.
> There are a few more, actually.  After this series and outside tests:
>
>      enum                            default prefix camel_to_upper()
>                                      prefix override
>      ------------------------------------------------------------------
>      BlkdebugEvent                   BLKDEBUG_EVENT
>                                      BLKDBG
>      IscsiHeaderDigest               ISCSI_HEADER_DIGEST
>                                      QAPI_ISCSI_HEADER_DIGEST
>      MultiFDCompression              MULTI_FD_COMPRESSION
>                                      MULTIFD_COMPRESSION
>      QAuthZListFormat                QAUTH_Z_LIST_FORMAT
>                                      QAUTHZ_LIST_FORMAT
>      QAuthZListPolicy                QAUTH_Z_LIST_POLICY
>                                      QAUTHZ_LIST_POLICY
>      QKeyCode                        QKEY_CODE
>                                      Q_KEY_CODE
>      VfioMigrationState              VFIO_MIGRATION_STATE
>                                      QAPI_VFIO_MIGRATION_STATE
>
> Reasons for 'prefix', and what could be done instead of 'prefix':
>
> * BlkdebugEvent: shorten the prefix.
>
>    Could live with the longer names instead.  Some 90 occurences...
>
> * IscsiHeaderDigest
>
>    QAPI version of enum iscsi_header_digest from libiscsi's
>    iscsi/iscsi.h.  We use 'prefix' to avoid name clashes.
>
>    Could rename the type to QapiIscsiHeaderDigest instead.
>
> * MultiFDCompression
>
>    Migration code consistently uses prefixes multifd_, MULTIFD_, and
>    MultiFD_.
>
>    Could rename the type to MultifdCompression instead, but that just
>    moves the inconsistency to the type name.
>
> * QAuthZListFormat and QAuthZListPolicy
>
>    The authz code consistently uses QAuthZ.
>
>    Could make camel_to_upper() avoid the lone Z instead (and hope that'll
>    remain what we want).
>
> * QKeyCode
>
>    Q_KEY_CODE is baked into subprojects/keycodemapdb/tools/keymap-gen.
>
>    Could adjust the subproject instead.
>
> * VfioMigrationState
>
>    Can't see why this one has a prefix.  Avihai, can you enlighten me?

linux-headers/linux/vfio.h defines enum vfio_device_mig_state with 
values VFIO_DEVICE_STATE_STOP etc.
I used the QAPI prefix to emphasize this is a QAPI entity rather than a 
VFIO entity.

Thanks.

>
> Daniel, thoughts?
>
>>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>>> ---
>>>   qapi/block-core.json                     |  3 +-
>>>   qapi/common.json                         |  1 +
>>>   qapi/crypto.json                         |  6 ++--
>>>   qapi/cryptodev.json                      |  1 -
>>>   qapi/ebpf.json                           |  1 +
>>>   qapi/machine.json                        |  1 +
>>>   qapi/migration.json                      |  1 +
>>>   qapi/ui.json                             |  2 ++
>>>   scripts/qapi/common.py                   | 42 ++++++++++++++----------
>>>   scripts/qapi/schema.py                   |  2 +-
>>>   tests/qapi-schema/alternate-array.out    |  1 -
>>>   tests/qapi-schema/comments.out           |  1 -
>>>   tests/qapi-schema/doc-good.out           |  1 -
>>>   tests/qapi-schema/empty.out              |  1 -
>>>   tests/qapi-schema/include-repetition.out |  1 -
>>>   tests/qapi-schema/include-simple.out     |  1 -
>>>   tests/qapi-schema/indented-expr.out      |  1 -
>>>   tests/qapi-schema/qapi-schema-test.json  |  1 +
>>>   tests/qapi-schema/qapi-schema-test.out   |  2 +-
>>>   19 files changed, 37 insertions(+), 33 deletions(-)
>> Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
> Thanks!
>

