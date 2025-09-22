Return-Path: <kvm+bounces-58414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 183ACB93658
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 23:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B07DE4E2A5A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 21:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB2E306494;
	Mon, 22 Sep 2025 21:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ix5JQQNG"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012017.outbound.protection.outlook.com [52.101.48.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CE42C21EA;
	Mon, 22 Sep 2025 21:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758577153; cv=fail; b=UsuAJ7sz7dx+a2nU2e1QKsah3UnW5VmnY89AkONUYoS99OEjFx+NxI06ft0w5gJ+u0gBLjRus65BeFrIvlOy9Aj21+8J2J1305Q5+c65U/FzNGKbkoj8dcaNzfUN4uzpIx5yDMWl7awAxiHn4eWao7fyK3vem2rhoDvEMfJ/Py0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758577153; c=relaxed/simple;
	bh=ILeuUndL2PspeHNOOKkjWaTuaNRtrctBRUv3bDsfcBk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=La4KRUnH91+rSeSSi52+kSh+dernOQmXn4UqveV2gkcX+yBSr1QIlcV9l/io/Af5KdoDpWVYmkw9gHWpi64u/PChMWR4edESoO/vazfgokx/QsKMXXdFTBvCDkj48YUvehKkSxEefLVzw0PGoK2lyy11HT2jl7m7e9ne5oh52Sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ix5JQQNG; arc=fail smtp.client-ip=52.101.48.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lJ9XqHweNH/eFzP4ebq0cq0Su98Rmv/ofg3tR51sR3OkgjFF5DCfzWJzjUTeroK2KvPa49u/Eq2icD4WBfXHMaZ29iplln3QmcBiaypTlFz513WGlLs5GRHfhgqR1kqi9AK6uX4NtIVwUzxREC9lk0kZz76RjoCFyG00c9bzuelkxgXs6kTgjpkzmgCHZ9d5SDU22Ib36hbRD2x3aUB6aIbGS6+yMYc+mmbQUcG0Fm0dAyOo4cVTwfmf4n4ZRn+YMyDJx+EPMBcrKC8DoogMSDbQGm34voMI8mZGKRWCXjQSxIHYbEJ9+Or22MqT1rAVU0LvdymSSOfgsZhSD/jyoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yXE/AQtwkboV/bD7Phr719mPQyvNarHWkGZOYpQ9oog=;
 b=ZL8OViEeYQkpRFLnzrQ+6cKbJ0Hi9elD2D4mkkG1xenSjRqzrEnN4ZaTsLJ/mHQnndmjBuzqAxwFvA2VEpTGcUx8WVUG1eRLiYaAa942tawFvKDomEOWtv4HbwKEchR8juHm3fKq9nLyzuFR5LVhTJ1mON6gaYIOWNows+kyCzUcIWRfZ9nhYEdXNo0nyLrU1tBPXNj048F5cJBh9X/8T34fJpno9b3x4d3+9Y5iX8kl2nYgJEUkKZBepk2H6XupQDSDefHpiA7ftaRKZw6CTZKxDirGS4UVuur0JSXD8x3iVvIeThkrcPWYsYXw6QaSFpHXHbkSstCMMddwwEC7LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXE/AQtwkboV/bD7Phr719mPQyvNarHWkGZOYpQ9oog=;
 b=Ix5JQQNGLkm6yHHsm5EdjSXAZluHlaLpFLIda+35Gzt979SX4jgAsYbJIWyctaueR5WPPcd2aTAf3BEtPvYmzvAzpvCUcwDCLAwu+bbUFRTXcCKQWS8vM802+QWIxNErEWTAmjm3EoS9F/5yc+SGQqtZ3VT66f8ybllQEPHiLk4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by MN0PR12MB6003.namprd12.prod.outlook.com (2603:10b6:208:37f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 21:39:07 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%4]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 21:39:07 +0000
Message-ID: <1637f279-9c89-e367-19e6-d2aae2bcd4fb@amd.com>
Date: Mon, 22 Sep 2025 16:39:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v16 02/51] KVM: SEV: Read save fields from GHCB exactly
 once
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z
 <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-3-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250919223258.1604852-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::13) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|MN0PR12MB6003:EE_
X-MS-Office365-Filtering-Correlation-Id: 261e7ba8-2471-4231-0001-08ddfa20750d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGN1VjVUeFFoZWVjdnF3MGpaVU11TllYUVVqb3dmaERnck1kSk9Sc24rWlJI?=
 =?utf-8?B?WFY5Rm5MREE2SldYcmtCZWZrL1JiaXNNYndJR3gxbU8xem1zbHkwT3dXcmdz?=
 =?utf-8?B?aFpQQkhJUkFISFRmVCswSXhBNG1OV1IraXZaR3h2YWpweEM3SVBsNnZ3REty?=
 =?utf-8?B?SXBjRjFzV1lldFJzN2FoQ1FDOXBmN2tubHp6L3pmYzJHbW5YMW00VWtIVjZP?=
 =?utf-8?B?V0o5cGhGemhOSEI1SmNyL2lvbGNmUXBXNjVydXBIRUtDT2xvbE50RlVvS05P?=
 =?utf-8?B?MklZUkk1YVRjS0Jmd3VoOTVuMlFrbEVmemZjYmxnaVFaWkUrZjF0ai9LUnh1?=
 =?utf-8?B?K2JhKzNPQzEwNHlzYW8wOTE1N3NFTkV6VE5JSmtsa1UvZFFYbkpCNkdnQWZG?=
 =?utf-8?B?VlZma1dQc1lvRkZzRmF5MTlncXYyQk9BL2dkQzJZcHI1Tzl5TG1GWWsxY1lk?=
 =?utf-8?B?RVh2VnJLaEkzSHhKcE5hRlFMaGNUaThab0NsTkhoYXJydU9MVXkvMzh2R0Fj?=
 =?utf-8?B?TDc3Y21JSjREWTd5V3Q3eXZBOGxZWkl4L2NUblZ4djJzSEEwOUVhN2pKZWtU?=
 =?utf-8?B?R0JEVEVsYXFGMTJ4eEJ1d29zZ2toN09RUDVkcXlMQlZaVTVGa1JDYVVFK1Js?=
 =?utf-8?B?bnJ3UlVSWWJUKzVpZmlOVmU5TXdBVU1iM0xHRzl0dHRVYkRIcXQvN2FaSXl3?=
 =?utf-8?B?M3pjelZrMFJCUjkyWGd4Q1U3UmZGM1U1L2RpNmo4UUtIanpXNkdSR3Y5QXFk?=
 =?utf-8?B?QW1QTjBWWmNobWkrOVRLZmlXZzAycm1WejFTQVZlZUhZQW5BMUVsWmZteVBt?=
 =?utf-8?B?RnMvS1JhNys1eWRxNFU4b0xueGtZSXVSWE5FaVVIQlR3L0Z6Zm1hNC82U3I4?=
 =?utf-8?B?c2dwbzBLRXo1WmwzSjRiUEJMbEYvTlBnUzZ6cU80a2hEZ1A0RE1BRTk1MWo0?=
 =?utf-8?B?QUdjTHVoZmZnVks4SStPVFJIKzhVUlZJbWZBN0lvZE9PYlYxYlhhTkhSZ3o5?=
 =?utf-8?B?cW1xRmtwQmxPd1JHRU95cklGdmJReEFnTGQvaGZFeTNNRVVZV0crdlZpdXli?=
 =?utf-8?B?QkFsV2ZEQkxXekYrR1o0QlRoVW1SK2FuQ3UzaElJQ2ZCaXA0eFhpRDR0Nm5U?=
 =?utf-8?B?S21Hek1HWTRKWHNLbm5pWkJJZjcxbkozNzh5K3hqSzRXdkduMjkvZUVvTkVS?=
 =?utf-8?B?eGlYa3ltdmxWdm11SWVWUDJoL0hobnNqRDlPQVNwcDF3VE1RS0N1a3FLbmlU?=
 =?utf-8?B?ZFVpbFk2LzNwNXhLaEdCS1pxMS8xaWxuVnEyMFdXR0diWmkyNCtiQXZObFRV?=
 =?utf-8?B?M0xCbEt2UVQrQUMycGlpR3BMK1BhWjFScURsRExGc0lobVZvQ2c0K3ZRai9E?=
 =?utf-8?B?VXhwaTNrMkJsQlh0b3k2ZVo1NkZqNC84TTFIUjVPMFJLWlVCeDE4UmdDRG8z?=
 =?utf-8?B?ZE9ML0dLYk9nT21WSVNaNEU4UGUrYVYrUm53UTN5Y1ZpQmpnbDBpRU5pR1RI?=
 =?utf-8?B?NS9QVjFiMU40R0VHZWhFY0l1M2NGU0JiblZwY1dsV0ZLeVhZRkNVamg2M0RR?=
 =?utf-8?B?eVpjUmZESnVFdTk3MUJZeFFqaWVTcUlqWDVmU1ZvV04waXU1c01neVI0bVV5?=
 =?utf-8?B?VkJOdGQ0NnREeWN2Rk9DVHJ1ZSt4MFAwWWpCMmdwTUh1Y3N1ZHk5R3hlKzIw?=
 =?utf-8?B?cTQwSkRoT3lzSS96cGwxRUxyUGllTElzKzIzS2NEelBWQjJtQ1dWR0xwZERk?=
 =?utf-8?B?T1NOSHdMOThMak5TeTJYZDdacTJmc2p0ekpRNTVLNVNwWW1UYnBPQXFZdXRG?=
 =?utf-8?B?VkU4RHMwamVWMXk5NHlheEJ6YXVwRkxmc3pWOG82MVZlbWpGTm1helAxd1A3?=
 =?utf-8?B?OGNaa05Ic3FIODd3dkNaWkp1TS9DRGlQUUsycWV0Y0YydXhrQjlCYy9XYlYv?=
 =?utf-8?Q?dvr63YEQUdQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emxSQUZOYTB0bzNkb0Qvd1FoZlRlWXB2V3AxN0czZFdmRmNnWXpWd2RXTTFv?=
 =?utf-8?B?bGRiMW42RDh6bm9MdTFIM1AzRDBvTHpTNWFUaHJDNUplcG9vOGZqNUVzZUVx?=
 =?utf-8?B?dXlSaTZQQWYreGJCUkM5V2c3c3FLSnFtQVRBcGEzUzJBYm5EOVZWQlhLVnFE?=
 =?utf-8?B?SUlZUzkzZklpR1ZkYmNjdjQ1YmoyaWNzT0xOSTZGdGNicnpxYzQyWCs1Q2ZS?=
 =?utf-8?B?WktmR29OZDFlTm9tT3kwTllMb2d1a3pIeFRtclNRYUhWY0I0RmZsWUl6MFZR?=
 =?utf-8?B?alFBVFoxUkpYdkNyT1c4TVV6SHQrYlRvRzBXTmV1MlJuQWx4bmMrNWdJN002?=
 =?utf-8?B?WXJWbGQyYzF0YTE0QXEvMUZKNE01cmZJclh6NGIzdE9XKzE5cjBpQkh1V01V?=
 =?utf-8?B?Mk5XWGNYdFRCdzlrUFVyWllPem1vSExGUTV0ODZwL1RKRFJWNE8rdHVhZkVQ?=
 =?utf-8?B?ZTVsRFMxWmZIblJqcWFMWmtQVzQ5c2hublRxcy9MMVgvRC9Zcm1TOVMxbGpF?=
 =?utf-8?B?TnQ3RkpjZjdHQzJ0Qnh4cDl1bzYrV041R1FxNndvRFFzZVlwRmZPRkxOSFdz?=
 =?utf-8?B?dkRsMUtzeUFyNE5mcnJPUW56RUJuM1h6WnRFOUhDZDMwOFQvYUpKaS9TaGdV?=
 =?utf-8?B?RXJlNzNQR1pxU3N2SUFXU3EwWXY5NSthOXFFUmc4YUFUV056amp2NEJrOUUv?=
 =?utf-8?B?NWYyOXZrUTkyanlsUSsyVXUxWDJiOE9KZG0xdXBod05ZTzBTZytMZkJaSldn?=
 =?utf-8?B?VmJoZlhhMkFSblhmd1hFYWg5VGc3eXcrK1NCUlhBYm8rbUZIL1FpRVRzdTUy?=
 =?utf-8?B?ZWk5TjFmYVNaRktFaEp5U1B0T2R6bGJZQlNEWEdYVFlKUm1FVjRxTUk0dTZ4?=
 =?utf-8?B?TjFXR0JPTWhDU1RMR2JKbkRvTFg2T2NWQ1RCWGd2NmZEckFCRTQwNkk2Y0cw?=
 =?utf-8?B?Nmh0b2F3eVpEYURLeVo3TVdMUDF4K3JPZmxydnR6UTh2ekR1YUFUY1VoS290?=
 =?utf-8?B?dkNMUzF4S2F0SGg3Y21NZ0F1UzdqWXFXRUxjMGNVSGcyWlhUdEtrU0k5QUJH?=
 =?utf-8?B?QVpObW5rOWV2VXhWUVZreFZ5WjBWZUhrZzEydjdCaWJmS1lUZ0VXdVFqUG9X?=
 =?utf-8?B?aEhYZEJMZUZ5aFZacTd1SWJJY0pNek9TWklqQy95cWNTNUM4bTNHeWN6bVJC?=
 =?utf-8?B?bEdodm5oc08vN2Y0Ulp1RWI1ZEc0by9Lekk0KzR6NXR6SFRmOTRNOG1CZDlX?=
 =?utf-8?B?OHZadVd5QjVIVXY2bGkyVGdtT2xYV1dlN2tQYm5MNysvbmM2NGZvVVZPVXNQ?=
 =?utf-8?B?VXJ1K1RJY1VGVGJoREw2OHhYdC92SHQyM3k2R3c5Y2diVFpiOFJLZFBZLyt2?=
 =?utf-8?B?SVluOTBGNkpjbDBySkJQWU9JOUkxZzBVZ05wZlR2YnpsUUp0V0FQeUQwa01s?=
 =?utf-8?B?YUdEemV2K2ROeTZiUDdCbzh6TEFRQVZvalZQa282Kzl3ODF4bm84ZVhDSkli?=
 =?utf-8?B?dUF1WDB6blgwR0RLS0RYSUxZcW5jcmVuV3lNcTRxcXB6UDBjK0dhQTRIWlM4?=
 =?utf-8?B?NmNJTWYvcXVWTnZ0RkoyclVEaTJjdHh2azhrblBSWFpSNlJ0WTJMa0VLRWVk?=
 =?utf-8?B?clUxdmtOYWtaV2ZJb0lCd0d1RzRrOW5FVFhhOERaSE5JQjE2UkI4bm1JeGxu?=
 =?utf-8?B?cjZaL0ZCNGFQTVdWek5OWm5HK1h4RDh6Y3lvbnNreGkxNWY1NkZrNmljNWdF?=
 =?utf-8?B?VjNWRnYrK1dOQXB3Y1J6c0RoV0F2S1FONE5FVzg1eUV1Z2NlUEUxMmZaYjBv?=
 =?utf-8?B?cmVyL0pxNkIrKzlhMlFvUjJQRHJjbFJJaHZORy9hZ1JoN1VQZkdFUlBWRXR2?=
 =?utf-8?B?OGJPdTFaeEhINkZ6Y2dBMTNPcWY5VFcxT2FSME5iYmdvMnB2ZWFVWFg5eEdC?=
 =?utf-8?B?a0UwbUptUnFMVnVmRzE4VUxuMmF5cE1LQWFuNU9vTWdMaFBvVnNCRnhxd2J5?=
 =?utf-8?B?M1hVcEJUUGJRTGM1NGlVOVk2d0pOTWNCNUNiQ0JUTFZNemZLV05nQ0p3dnd1?=
 =?utf-8?B?RDBwSFJaRjJFVHJmaDYwYjNYS1VNS0dYcnFtOG95aVozMm5wZ1FvNFVmQjJB?=
 =?utf-8?Q?ZRfeGJeQWoDn6bsLA0LS0QxGa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 261e7ba8-2471-4231-0001-08ddfa20750d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 21:39:06.9742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JukMdwpUBqc8L3Wi3RitaLLnLxpvw+NjNYkhry28TO84LFanYdoHjrVwZBl0v05TUSd9XFi/9hGtw8cLlpDNIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6003

On 9/19/25 17:32, Sean Christopherson wrote:
> Wrap all reads of GHCB save fields with READ_ONCE() via a KVM-specific
> GHCB get() utility to help guard against TOCTOU bugs.  Using READ_ONCE()
> doesn't completely prevent such bugs, e.g. doesn't prevent KVM from
> redoing get() after checking the initial value, but at least addresses
> all potential TOCTOU issues in the current KVM code base.
> 
> To prevent unintentional use of the generic helpers, take only @svm for
> the kvm_ghcb_get_xxx() helpers and retrieve the ghcb instead of explicitly
> passing it in.
> 
> Opportunistically reduce the indentation of the macro-defined helpers and
> clean up the alignment.
> 
> Fixes: 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 22 +++++++++++-----------
>  arch/x86/kvm/svm/svm.h | 25 +++++++++++++++----------
>  2 files changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f046a587ecaf..8d057dbd8a71 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3343,26 +3343,26 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>  	BUILD_BUG_ON(sizeof(svm->sev_es.valid_bitmap) != sizeof(ghcb->save.valid_bitmap));
>  	memcpy(&svm->sev_es.valid_bitmap, &ghcb->save.valid_bitmap, sizeof(ghcb->save.valid_bitmap));
>  
> -	vcpu->arch.regs[VCPU_REGS_RAX] = kvm_ghcb_get_rax_if_valid(svm, ghcb);
> -	vcpu->arch.regs[VCPU_REGS_RBX] = kvm_ghcb_get_rbx_if_valid(svm, ghcb);
> -	vcpu->arch.regs[VCPU_REGS_RCX] = kvm_ghcb_get_rcx_if_valid(svm, ghcb);
> -	vcpu->arch.regs[VCPU_REGS_RDX] = kvm_ghcb_get_rdx_if_valid(svm, ghcb);
> -	vcpu->arch.regs[VCPU_REGS_RSI] = kvm_ghcb_get_rsi_if_valid(svm, ghcb);
> +	vcpu->arch.regs[VCPU_REGS_RAX] = kvm_ghcb_get_rax_if_valid(svm);
> +	vcpu->arch.regs[VCPU_REGS_RBX] = kvm_ghcb_get_rbx_if_valid(svm);
> +	vcpu->arch.regs[VCPU_REGS_RCX] = kvm_ghcb_get_rcx_if_valid(svm);
> +	vcpu->arch.regs[VCPU_REGS_RDX] = kvm_ghcb_get_rdx_if_valid(svm);
> +	vcpu->arch.regs[VCPU_REGS_RSI] = kvm_ghcb_get_rsi_if_valid(svm);
>  
> -	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
> +	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm);
>  
>  	if (kvm_ghcb_xcr0_is_valid(svm)) {
> -		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
> +		vcpu->arch.xcr0 = kvm_ghcb_get_xcr0(svm);
>  		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>  	}
>  
>  	/* Copy the GHCB exit information into the VMCB fields */
> -	exit_code = ghcb_get_sw_exit_code(ghcb);
> +	exit_code = kvm_ghcb_get_sw_exit_code(svm);
>  	control->exit_code = lower_32_bits(exit_code);
>  	control->exit_code_hi = upper_32_bits(exit_code);
> -	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
> -	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
> -	svm->sev_es.sw_scratch = kvm_ghcb_get_sw_scratch_if_valid(svm, ghcb);
> +	control->exit_info_1 = kvm_ghcb_get_sw_exit_info_1(svm);
> +	control->exit_info_2 = kvm_ghcb_get_sw_exit_info_2(svm);
> +	svm->sev_es.sw_scratch = kvm_ghcb_get_sw_scratch_if_valid(svm);
>  
>  	/* Clear the valid entries fields */
>  	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5d39c0b17988..5365984e82e5 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -913,16 +913,21 @@ void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted,
>  void __svm_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
>  
>  #define DEFINE_KVM_GHCB_ACCESSORS(field)						\
> -	static __always_inline bool kvm_ghcb_##field##_is_valid(const struct vcpu_svm *svm) \
> -	{									\
> -		return test_bit(GHCB_BITMAP_IDX(field),				\
> -				(unsigned long *)&svm->sev_es.valid_bitmap);	\
> -	}									\
> -										\
> -	static __always_inline u64 kvm_ghcb_get_##field##_if_valid(struct vcpu_svm *svm, struct ghcb *ghcb) \
> -	{									\
> -		return kvm_ghcb_##field##_is_valid(svm) ? ghcb->save.field : 0;	\
> -	}									\
> +static __always_inline u64 kvm_ghcb_get_##field(struct vcpu_svm *svm)			\
> +{											\
> +	return READ_ONCE(svm->sev_es.ghcb->save.field);					\
> +}											\
> +											\
> +static __always_inline bool kvm_ghcb_##field##_is_valid(const struct vcpu_svm *svm)	\
> +{											\
> +	return test_bit(GHCB_BITMAP_IDX(field),						\
> +			(unsigned long *)&svm->sev_es.valid_bitmap);			\
> +}											\
> +											\
> +static __always_inline u64 kvm_ghcb_get_##field##_if_valid(struct vcpu_svm *svm)	\
> +{											\
> +	return kvm_ghcb_##field##_is_valid(svm) ? kvm_ghcb_get_##field(svm) : 0;	\
> +}
>  
>  DEFINE_KVM_GHCB_ACCESSORS(cpl)
>  DEFINE_KVM_GHCB_ACCESSORS(rax)

