Return-Path: <kvm+bounces-25359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E4A9647B8
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70CEC1F24C25
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E16C71AE04E;
	Thu, 29 Aug 2024 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZDrw9jQA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75C0190663;
	Thu, 29 Aug 2024 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724940852; cv=fail; b=KZQKRF7u0c1DKf9sufTjMtCRUKS6iwVvbsLdTLdLiBqNqBVMIlJ5X5Ag1Z1PBKsb+k+HCRz34+G8p5uclo8aS+s2ny5/bncqtf5HdLHHrZX6YI2+kVlzH9y24DMKyWj/jCQ/of2Marh0JtDBaMyVD6QuhjSgLsrEldYxckEtNkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724940852; c=relaxed/simple;
	bh=AUX07j5KjrH4aZ4l3jVyR085sbVyCkjVsztn6iHoBz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=afLNf1VVxJXZvqGPuJb/j4a5tWLKiGXM+5Tc7VrGqUkLYNm78zqwGBBDcXwsRw9dSzEeHsvUTOZxZ3rdmegSriwTwsIaQUVozBdnUCtaXmFaBwDzy5PPGYejpJJ5Sd+JsgZOWekvRZK5Jq6XPaOfV2ZxqX1FrabR+nhL48JjfL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZDrw9jQA; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eaEVDnzF/YemMImP8Wsrmgz/qhmJKSlPcA3dVordXYZqzXaRp3NzoXJxfECdnpcZUK+uaeEqM0zy4h8k5z9Qq3cOSeWbk3u7slH+wZKaaGKsuNT9aQ6gncDT9LlCcYYONXuFb5nE6ZC6j2KydVRKN7oVkIp3gTsN3YmVKp4Xosqvsxxx4zeUlMl/mRXDmOAYWOgTzP9tVwGLiTqCiSy7ocGnI08i6enYBq4IBYuvD/L9yE8SGyUsLK3yxymkV3+j928Kg7fWMeb1QACfyj++5IOcJY6vaDOKlxll0+U5Zkgv6LftCSTY4/uRTxQj6r95zOPlIclchf3/GjS7BH35hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1l7evDLFBHgttiKNTI9OxGGa19Vmkku32likByPHSU=;
 b=QAc1DGN/E4c9iZiExpLUf+i4IVzcrGmi1/MvIDtx1qHD++jxQn8q1X2mV+HOJOjQt0fhV/zAJkwhih05n/h0nY0trmNuuc+IpRgvJmZJQNPno14bv/YAh1Oryz+DsOq4znRLzGx8ePQMkYOON8pLGEqZWozzcbXDj5fZW0hbjjpb3Ph6e4WnqKo+Fyl1VJOLR5li7MMa2pimcJtzx4VtFEjZY9KVkyTVFQMluAQSTe8mXgL0vRPX6oy3KNp9NeOAR56kx95HKptKd3eqdLaMzT2dmK1VF6h5Mx972we/MuZA8hcQi+Fb35HVJALWrttBo/hRgPt9Y2KvfpZ/+pWlZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1l7evDLFBHgttiKNTI9OxGGa19Vmkku32likByPHSU=;
 b=ZDrw9jQAins4kUo8FC6LyI+HK4u9qRxI1yRlWNYek58vtWD4PhAGvsPueUPaswXlf74g42jRgPldDarYNkht2pX4/04YauVJDP7TfzpqZdsaZjy1xR/9oNgV9ah0n1KdUZfM5WH41LcRL1UP3PLvt+UzTf+/1Q1VzjsfClTsDf4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB7678.namprd12.prod.outlook.com (2603:10b6:8:135::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Thu, 29 Aug
 2024 14:14:06 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 14:14:06 +0000
Message-ID: <6cd62b80-9a8d-4f01-a458-4466dac6d27f@amd.com>
Date: Fri, 30 Aug 2024 00:13:56 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 00/21] Secure VFIO, TDISP, SEV TIO
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, kvm@vger.kernel.org
Cc: iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <66cf8bfdd0527_88eb2942e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <66cf8bfdd0527_88eb2942e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY2PR01CA0026.ausprd01.prod.outlook.com
 (2603:10c6:1:15::14) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: e7def3d7-d27e-42b4-7cb7-08dcc834d7b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c2FWRWhPZm5rWm1heUkzemlUTjJ0cUtDMkx6STNRZmtBcngwbTROcWk0Rmho?=
 =?utf-8?B?WnJKc2tFUHBvL21xeGttcnlMb2kzSzRLeFJEL1dlUFJNSm5LZHQ3Nlg3RGxy?=
 =?utf-8?B?QTZuQy9raEpVM25tY29lM3RleXJlRUpIVU9VOVVCcTdNMXpEeVNnVlZkb0pm?=
 =?utf-8?B?YTlhbmtjVXg2UEltZlhhZ245bWEwUDdPQnpYZm1mNHBzeFlGQWVOcHJnenN6?=
 =?utf-8?B?QkRJNnhrMTVQbjJkVGt5NGhJTHhtWWRjZGM5RzBhNDYrelM5UFJsU3VjMXRL?=
 =?utf-8?B?V2lURW9oUkJKQ1BQcUNXcnJWMmZ0OStRV3JjVFpBN1dqc296WXljU3V4VjA0?=
 =?utf-8?B?VUNWY1YzNXFILzJtK0lEUWY0WDJ0YTR2MlcvV2JFc1ZhME1SV3JSdXlnWjhX?=
 =?utf-8?B?OElONk9uSDBzanF4SXlzWGVlYWRkZDJJelhkdjFXSDhHMkYwcUNqQThZUUNQ?=
 =?utf-8?B?OHkwRUphUUJRRS9vcjJ6ampHQWgrUDVTbVhCeWhCK3dPYUs4dzdrZnZGeE1l?=
 =?utf-8?B?SitRVHExSXMwZlF5bTB5d0dacHB3UVA3ZEFsQUgvM1lDVjl0ckNENEt6aVp4?=
 =?utf-8?B?a1ErTjJqWHAxaVhtUlJaazJ0YmZJUVRwamlTaXhEcFkzYkxOOFJBckc2Uklr?=
 =?utf-8?B?QnBtdjRSM2c2anJEKzY5NEpXS3BDdmJCMnZobmZYYU16N05IUFowNCtBb1d0?=
 =?utf-8?B?dmsrUi9weXYyQUpyZnVnNVU5VmdEcHA3aHdKTEM4QkhSZkxNUG1mS01tbGpw?=
 =?utf-8?B?SjdWZzhsTmQ5VWsxS3NtYml3TmF1Zjg5cHVacFRyZlVPY1N4OUFJZGJLNHB0?=
 =?utf-8?B?S2gvVWt5dmkrSktUZDhJL1M3M3plN0VWV1BkSHNqUkQ1cXJKb29ZdjBoK3g0?=
 =?utf-8?B?QVdsclNXTUg3eHBmRXFCTSt0ZjJSV3doNmdZOVZXd01ORTR2aXZjcmxTQ0R5?=
 =?utf-8?B?ZVhNdHJ5K0dmbXhYdUQzUDlFUWZTRlFTTzNYQVFsVW9xcEJLdG01Vk5BZm00?=
 =?utf-8?B?d3UwNGh3WVdTdWNUZDIyWWRzb2drRzJuZ2R3RU54Wmx3NmxrVUZOeUViWTFk?=
 =?utf-8?B?V1djb0h5dHR6K1ZxcDM5VklReG4yaXE5WGp6Z2FzaENJcSt5c0dSeU8yTnQr?=
 =?utf-8?B?UEw3ZVZNMUVLZ0RwVFlOdlNMaktrNmI0M3VUcy9CQ1pKN0ZJY3B6WWxpckU5?=
 =?utf-8?B?SXpoSHc5eXV3eTAxb1UzRllhU3Y5ZXJmQkJkaFEwZHVPS2ovN1dRMVp0WGJy?=
 =?utf-8?B?bDRBcVlrWW9GZWJhTnhzSmFId3lyL25yd2xWT2NiNlkySmF4aFVCVTdPbjc4?=
 =?utf-8?B?UTI4dm4wVit6dzN2SllvWUJTellsTVF5NFpqaEk2dnRiRkJ6TVJvZjRzaVNv?=
 =?utf-8?B?K0U2ZHNUL2xIN1cwR0ZzS0g3dkFHWk1LTC84U1E1NlZlTEZLZW5DQnl2UVZ1?=
 =?utf-8?B?YlowYWpYYUFOWm93LzdFazhaaXFqRzVtL1FaTHRNVEZFUFUyWVpSM2Y2SWl2?=
 =?utf-8?B?ZUU0ZlNrSy9FL3hJbitlVFJPRVJhVWo4cjZjQTJuNEdOZmN6SFJ2NkV6Yy9l?=
 =?utf-8?B?SVUrVUxqUmpWYUYrS2ZRNVA0M3pjV3M4VWpQWmFPeXpYZlF0MW1mRHZWaG9K?=
 =?utf-8?B?aDZGOFduZlhKRVF1SWN4REs5NURuaHJTMVRtWmV2RDJiT0VMSVBlbVRRL2Ju?=
 =?utf-8?B?RGk2RHBOQW05ekJjaFlqOHNPb0hLamhUazAzNStwb05CSmtuQUx4OEo0VkFk?=
 =?utf-8?Q?LdRO+Oij9L/QIp46U3+N5LT7IYCQKcr2pUD6s58?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akg2RW05N3Vudm5SdkZZOW9pVHJwSnVhWXhXbzRUeXI5cWFPdUJQNkZkcUJa?=
 =?utf-8?B?K0JpdnFwalZtaFRseFRXRWVpaVpMNHNGZmErSmtXejhINkRpUUwwaHF2YTNL?=
 =?utf-8?B?WjdHVVppWWdjS0dFNHRHL2k3WTVXdkdHam52RDlIL29ScnRqcEhLVkJJbmRW?=
 =?utf-8?B?N0twYTBPQnd5L2tvV1NrNEdIeWxaN2hUN29oeVp1WENlNmtwbFpuRjhqQTlK?=
 =?utf-8?B?eHVBT0pZTUNxKzlXaWlFSGQvN1R4dFBRYUhhK05EYVhqdGloSmptUGJDVzR1?=
 =?utf-8?B?VG01TWdwVUZ1cFoxWUxGYTVXMWJKS2d1SHBzN2dnclJLaFBYQktLRlFIRWVn?=
 =?utf-8?B?ejR6T2QzMUl3NG1Nemx0ZzVsSjBqbU1tS2tXUm05aFo1WCsrd2ZmQXRFWjVs?=
 =?utf-8?B?Ym5DL0xKV255aFNJenN0ZGgrSFl0Skh0ak9hSjMwRmxDOW8rc1Q1cEgxWTFC?=
 =?utf-8?B?UXd1VnNDdnd0U0NuNG9pNVpFNzlhNFRtUnkwelBwTXZLckdLc01ST1h4UitZ?=
 =?utf-8?B?L2QxZ0FyUk5qUWFyY1VLTWlQS01aeE1lNDlGMkJ5NmhMdzl6aHVrR0xYM29m?=
 =?utf-8?B?bzUrZ0dHSG8vU2JkcFRhQUp3Mzd5dzJ4R1R6REljL0pQMElTYjdUbDgzWnNu?=
 =?utf-8?B?VDBnVUo2RFlVRmJtTHU4QXBtd3JqZEIvTUhCQ1lYOC9WZlluR3hEdG9YdWRT?=
 =?utf-8?B?UTVlSWM0L0owdEwvczBHWVMzMkRTaXI5aVVZRHpmU1diK2c2Q1RRa0hnQ3Fl?=
 =?utf-8?B?Mmp4RjREdTZPcTV2MGIzUDJlV3BBOEFWUk0rbG50SkJuQlBDTmI0OE1pSWNC?=
 =?utf-8?B?U2sxSUJHek55ZkIwemd0K0Y4SUltM2djeVB1S1JvcUt6TXhGaGRLTHV2aUpm?=
 =?utf-8?B?ZFJxSjV3cm1YT3pKWTRSQnpvM211dFhHTXFUUUdRNUdFRDVPMDZLNjJzNHJ0?=
 =?utf-8?B?THJwanVqVVB3ZDRJZk9XZnhQcVdVd09KdXlUOWVNODRGc3NmUExOdzdtdnlJ?=
 =?utf-8?B?cThOWW5DOXljTHpCM05TOXg2RVNOTUdqWDJJRGJCa1VnVHRjRDdDbG4zRzlh?=
 =?utf-8?B?OXJjWUg5cEF3M1hMMlVBY3lYTno2c2w1RDJGZks0eWc0WUptSjNUUm1XVjd1?=
 =?utf-8?B?ajhiaFFlUzBKVDlsU2wvajB0cUdaTU9tMVc2TDlQS2lrUmtHcGllRHRaRzlT?=
 =?utf-8?B?L1dOeWNxdFBJME1DMXl2MFEzbWFsYlI4R3RLRjV1L2VVYlEvelgya0JhanRr?=
 =?utf-8?B?b1ZRaXdwV1p3WEp2Tng1K1U5Y3h0QW81eUY1c1BOUTh6QUdvT05IMVNQWEVZ?=
 =?utf-8?B?T3pXWGNJNlRQN0RFS1FQM0NkOU9IZjhKS3lpbkhxUHIvdlcxQjlDNjlOZ0Zs?=
 =?utf-8?B?WHR4TGtQTUo5YzRIMW5IZzdPTC82a25YN3ltZVpUQmZXWTJiTG1EdVc1ZVQ0?=
 =?utf-8?B?eFM0T2NxVk1lelkvR2Y0TjF2ODY2ZFNUVzBaTStDa2tKNG13aFIxRGVIVWt0?=
 =?utf-8?B?S1g5U2dBSDBzM1RoWWdCWCtOZGxFZXIxUWNBdmgxVmRBZVFBTkwwLy9GNEdK?=
 =?utf-8?B?TWlkOGxYZHorZDh4L2VoaXdpdmNKY1FRdi9OVkJ0UmJBMmRhSmxNT1NhL09J?=
 =?utf-8?B?bDNnelFWMWtyRDRqdGNRTVlkTEJSaHV0VjFKMmpmMHUrNDhuY29LTkZiN0VE?=
 =?utf-8?B?YVMvTXk2eitLci9GNTU2b29kRW5tWVkwZzJhZWhHTkRPWTdVVmliaEJHWTB5?=
 =?utf-8?B?cDRPMUtBQWZoVXMzNFRLV3UrbUlyR1FpVjV4ejVXZzV4bEtFTVhoVFkxVENq?=
 =?utf-8?B?YUtNSE9KbUF4WTNoSEJ5UUtJS3ZsbGNjcmJxZm1QTWl2emw0MU9BRVYxaHhI?=
 =?utf-8?B?aVdNdzl1K1hnMWc5WDdJV25QK25kTEFrOEQrcUhsQXBSVm5xN1krMURvTVZl?=
 =?utf-8?B?S24wTnUwQWV3RVgzaFUycm5XajVLZWFzbk5yeE1jVUJ2N1lXUW1aR3E0S2k3?=
 =?utf-8?B?cUY3Q2tYeVE5eGtpTXQ3TEFTNVRlRWVKaDFGOVRXMW5JTFVtSHhQU2NNdW5E?=
 =?utf-8?B?SU0yMDQ1QWhwdWxzZytwOXR5aFlmSzZXUVc0M1o3UU9HZ0JlSHpsUVlFVFBL?=
 =?utf-8?Q?1A2cYHNW06BsAI8Q8+kuZGB8v?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7def3d7-d27e-42b4-7cb7-08dcc834d7b0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 14:14:06.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhpVg/G6EhwIyhhFtd01W7UlnwcENhxm4JCsUrqpfXATGg5s9KNoBv0n+jgYycg3q8rTqmz8MC1YjgGRFESmSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7678



On 29/8/24 06:43, Dan Williams wrote:
> Alexey Kardashevskiy wrote:
>> Hi everyone,
>>
>> Here are some patches to enable SEV-TIO (aka TDISP, aka secure VFIO)
>> on AMD Turin.
>>
>> The basic idea is to allow DMA to/from encrypted memory of SNP VMs and
>> secure MMIO in SNP VMs (i.e. with Cbit set) as well.
>>
>> These include both guest and host support. QEMU also requires
>> some patches, links below.
>>
>> The patches are organized as:
>> 01..06 - preparing the host OS;
>> 07 - new TSM module;
>> 08 - add PSP SEV TIO ABI (IDE should start working at this point);
>> 09..14 - add KVM support (TDI binding, MMIO faulting, etc);
>> 15..19 - guest changes (the rest of SEV TIO ABI, DMA, secure MMIO).
>> 20, 21 - some helpers for guest OS to use encrypted MMIO
>>
>> This is based on a merge of
>> ee3248f9f8d6 Lukas Wunner spdm: Allow control of next requester nonce
>> through sysfs
>> 85ef1ac03941 (AMDESE/snp-host-latest) 4 days ago Michael Roth [TEMP] KVM: guest_memfd: Update gmem_prep are hook to handle partially-allocated folios
>>
>>
>> Please comment. Thanks.
> 
> This cover letter is something I can read after having been in and
> around this space for a while, but I wonder how much of it makes sense
> to casual reviewers?
> 
>>
>> Thanks,
>>
>>
>> SEV TIO tree prototype
>> ======================
> [..]
>> Code
>> ----
>>
>> Written with AMD SEV SNP in mind, TSM is the PSP and
>> therefore no much of IDE/TDISP
>> is left for the host or guest OS.
>>
>> Add a common module to expose various data objects in
>> the same way in host and
>> guest OS.
>>
>> Provide a know on the host to enable IDE encryption.
>>
>> Add another version of Guest Request for secure
>> guest<->PSP communication.
>>
>> Enable secure DMA by:
>> - configuring vTOM in a secure DTE via the PSP to cover
>> the entire guest RAM;
>> - mapping all private memory pages in IOMMU just like
>> as they were shared
>> (requires hacking iommufd);
> 
> What kind of hack are we talking about here? An upstream suitable
> change, or something that needs quite a bit more work to be done
> properly?

Right now it is hacking IOMMUFD to go to the KVM for 
private_gfn->host_pfn. As I am being told in this thread, VFIO DMA 
map/unmap needs to be taught to accept {memfd, offset}.


> I jumped ahead to read Jason's reaction but please do at least provide a
> map the controversy in the cover letter, something like "see patch 12 for
> details".

Yeah, noticed that, thanks, appreciated!

>> - skipping various enforcements of non-SME or
>> SWIOTLB in the guest;
> 
> Is this based on some concept of private vs shared mode devices?
> 
>> No mixed share+private DMA supported within the
>> same IOMMU.
> 
> What does this mean? A device may not have mixed mappings (makes sense),

Currently devices do not have an idea about private host memory (but it 
is being worked on afaik).

> or an IOMMU can not host devices that do not all agree on whether DMA is
> private or shared?

The hardware allows that via hardware-assisted vIOMMU and I/O page 
tables in the guest with C-bit takes into accound by the IOMMU but the 
software support is missing right now. So for this initial drop, vTOM is 
used for DMA - this thing says "everything below <addr> is private, 
above <addr> - shared" so nothing needs to bother with the C-bit, and in 
my exercise I set the <addr> to the allowed maximum.

So each IOMMUFD instance in the VM is either "all private mappings" or 
"all shared". Could be half/half by moving that <addr> :)


>> Enable secure MMIO by:
>> - configuring RMP entries via the PSP;
>> - adding necessary helpers for mapping MMIO with
>> the Cbit set;
>> - hacking the KVM #PF handler to allow private
>> MMIO failts.
>>
>> Based on the latest upstream KVM (at the
>> moment it is kvm-coco-queue).
> 
> Here is where I lament that kvm-coco-queue is not run like akpm/mm where
> it is possible to try out "yesterday's mm". Perhaps this is an area to
> collaborate on kvm-coco-queue snapshots to help with testing.

Yeah this more an idea of what it is based on, I normally push a tested 
branch somewhere on github, just to eliminate uncertainty.

> 
>> Workflow
>> --------
>>
>> 1. Boot host OS.
>> 2. "Connect" the physical device.
>> 3. Bind a VF to VFIO-PCI.
>> 4. Run QEMU _without_ the device yet.
>> 5. Hotplug the VF to the VM.
>> 6. (if not already) Load the device driver.
>> 7. Right after the BusMaster is enabled,
>> tsm.ko performs secure DMA and MMIO setup.
>> 8. Run tests, for example:
>> sudo ./pcimem/pcimem
>> /sys/bus/pci/devices/0000\:01\:00.0/resource4_enc
>> 0 w*4 0xabcd
>>
>>
>> Assumptions
>> -----------
>>
>> This requires hotpligging into the VM vs
>> passing the device via the command line as
>> VFIO maps all guest memory as the device init
>> step which is too soon as
>> SNP LAUNCH UPDATE happens later and will fail
>> if VFIO maps private memory before that.
> 
> Would the device not just launch in "shared" mode until it is later
> converted to private? I am missing the detail of why passing the device
> on the command line requires that private memory be mapped early.

A sequencing problem.

QEMU "realizes" a VFIO device, it creates an iommufd instance which 
creates a domain and writes to a DTE (a IOMMU descriptor for PCI BDFn). 
And DTE is not updated after than. For secure stuff, DTE needs to be 
slightly different. So right then I tell IOMMUFD that it will handle 
private memory.

Then, the same VFIO "realize" handler maps the guest memory in iommufd. 
I use the same flag (well, pointer to kvm) in the iommufd pinning code, 
private memory is pinned and mapped (and related page state change 
happens as the guest memory is made guest-owned in RMP).

QEMU goes to machine_reset() and calls "SNP LAUNCH UPDATE" (the actual 
place changed recenly, huh) and the latter will measure the guest and 
try making all guest memory private but it already happened => error.

I think I have to decouple the pinning and the IOMMU/DTE setting.

> That said, the implication that private device assignment requires
> hotplug events is a useful property. This matches nicely with initial
> thoughts that device conversion events are violent and might as well be
> unplug/replug events to match all the assumptions around what needs to
> be updated.

For the initial drop, I tell QEMU via "-device vfio-pci,x-tio=true" that 
it is going to be private so there should be no massive conversion.

> 
>> This requires the BME hack as MMIO and
> 
> Not sure what the "BME hack" is, I guess this is foreshadowing for later
> in this story.
 >
>> BusMaster enable bits cannot be 0 after MMIO
>> validation is done
> 
> It would be useful to call out what is a TDISP requirement, vs
> device-specific DSM vs host-specific TSM requirement. In this case I
> assume you are referring to PCI 6.2 11.2.6 where it notes that TDIs must

Oh there is 6.2 already.

> enter the TDISP ERROR state if BME is cleared after the device is
> locked?
> 
> ...but this begs the question of whether it needs to be avoided outright

Well, besides a couple of avoidable places (like testing INTx support 
which we know is not going to work on VFs anyway), a standard driver 
enables MSE first (and the value for the command register does not have 
1 for BME) and only then BME. TBH I do not think writing BME=0 when 
BME=0 already is "clearing" but my test device disagrees.

> or handled as an error recovery case dependending on policy.

Avoding seems more straight forward unless we actually want enlightened 
device drivers which want to examine the interface report before 
enabling the device. Not sure.

>> the guest OS booting process when this
>> appens.
>>
>> SVSM could help addressing these (not
>> implemented at the moment).
> 
> At first though avoiding SVSM entanglements where the kernel can be
> enlightened shoud be the policy. I would only expect SVSM hacks to cover
> for legacy OSes that will never be TDISP enlightened, but in that case
> we are likely talking about fully unaware L2. Lets assume fully
> enlightened L1 for now.

Well, I could also tweak OVMF to make necessary calls to the PSP and 
hack QEMU to postpone the command register updates to get this going, 
just a matter of ugliness.

>> QEMU advertises TEE-IO capability to the VM.
>> An additional x-tio flag is added to
>> vfio-pci.
>>
>>
>> TODOs
>> -----
>>
>> Deal with PCI reset. Hot unplug+plug? Power
>> states too.
>>
>> Do better generalization, the current code
>> heavily uses SEV TIO defined
>> structures in supposedly generic code.
>>
>> Fix the documentation comments of SEV TIO structures.
> 
> Hey, it's a start. I appreciate the "release early" aspect of this
> posting.

:)

Thanks,


>> Git trees
>> ---------
>>
>> https://github.com/AMDESE/linux-kvm/tree/tio
>> https://github.com/AMDESE/qemu/tree/tio
> [..]
>>
>>
>> Alexey Kardashevskiy (21):
>>    tsm-report: Rename module to reflect what it does
>>    pci/doe: Define protocol types and make those public
>>    pci: Define TEE-IO bit in PCIe device capabilities
>>    PCI/IDE: Define Integrity and Data Encryption (IDE) extended
>>      capability
>>    crypto/ccp: Make some SEV helpers public
>>    crypto: ccp: Enable SEV-TIO feature in the PSP when supported
>>    pci/tdisp: Introduce tsm module
>>    crypto/ccp: Implement SEV TIO firmware interface
>>    kvm: Export kvm_vm_set_mem_attributes
>>    vfio: Export helper to get vfio_device from fd
>>    KVM: SEV: Add TIO VMGEXIT and bind TDI
>>    KVM: IOMMUFD: MEMFD: Map private pages
>>    KVM: X86: Handle private MMIO as shared
>>    RFC: iommu/iommufd/amd: Add IOMMU_HWPT_TRUSTED flag, tweak DTE's
>>      DomainID, IOTLB
>>    coco/sev-guest: Allow multiple source files in the driver
>>    coco/sev-guest: Make SEV-to-PSP request helpers public
>>    coco/sev-guest: Implement the guest side of things
>>    RFC: pci: Add BUS_NOTIFY_PCI_BUS_MASTER event
>>    sev-guest: Stop changing encrypted page state for TDISP devices
>>    pci: Allow encrypted MMIO mapping via sysfs
>>    pci: Define pci_iomap_range_encrypted
>>
>>   drivers/crypto/ccp/Makefile                              |    2 +
>>   drivers/pci/Makefile                                     |    1 +
>>   drivers/virt/coco/Makefile                               |    3 +-
>>   drivers/virt/coco/sev-guest/Makefile                     |    1 +
>>   arch/x86/include/asm/kvm-x86-ops.h                       |    2 +
>>   arch/x86/include/asm/kvm_host.h                          |    2 +
>>   arch/x86/include/asm/sev.h                               |   23 +
>>   arch/x86/include/uapi/asm/svm.h                          |    2 +
>>   arch/x86/kvm/svm/svm.h                                   |    2 +
>>   drivers/crypto/ccp/sev-dev-tio.h                         |  105 ++
>>   drivers/crypto/ccp/sev-dev.h                             |    4 +
>>   drivers/iommu/amd/amd_iommu_types.h                      |    2 +
>>   drivers/iommu/iommufd/io_pagetable.h                     |    3 +
>>   drivers/iommu/iommufd/iommufd_private.h                  |    4 +
>>   drivers/virt/coco/sev-guest/sev-guest.h                  |   56 +
>>   include/asm-generic/pci_iomap.h                          |    4 +
>>   include/linux/device.h                                   |    5 +
>>   include/linux/device/bus.h                               |    3 +
>>   include/linux/dma-direct.h                               |    4 +
>>   include/linux/iommufd.h                                  |    6 +
>>   include/linux/kvm_host.h                                 |   70 +
>>   include/linux/pci-doe.h                                  |    4 +
>>   include/linux/pci-ide.h                                  |   18 +
>>   include/linux/pci.h                                      |    2 +-
>>   include/linux/psp-sev.h                                  |  116 +-
>>   include/linux/swiotlb.h                                  |    4 +
>>   include/linux/tsm-report.h                               |  113 ++
>>   include/linux/tsm.h                                      |  337 +++--
>>   include/linux/vfio.h                                     |    1 +
>>   include/uapi/linux/iommufd.h                             |    1 +
>>   include/uapi/linux/kvm.h                                 |   29 +
>>   include/uapi/linux/pci_regs.h                            |   77 +-
>>   include/uapi/linux/psp-sev.h                             |    4 +-
>>   arch/x86/coco/sev/core.c                                 |   11 +
>>   arch/x86/kvm/mmu/mmu.c                                   |    6 +-
>>   arch/x86/kvm/svm/sev.c                                   |  217 +++
>>   arch/x86/kvm/svm/svm.c                                   |    3 +
>>   arch/x86/kvm/x86.c                                       |   12 +
>>   arch/x86/mm/mem_encrypt.c                                |    5 +
>>   arch/x86/virt/svm/sev.c                                  |   23 +-
>>   drivers/crypto/ccp/sev-dev-tio.c                         | 1565 ++++++++++++++++++++
>>   drivers/crypto/ccp/sev-dev-tsm.c                         |  397 +++++
>>   drivers/crypto/ccp/sev-dev.c                             |   87 +-
>>   drivers/iommu/amd/iommu.c                                |   20 +-
>>   drivers/iommu/iommufd/hw_pagetable.c                     |    4 +
>>   drivers/iommu/iommufd/io_pagetable.c                     |    2 +
>>   drivers/iommu/iommufd/main.c                             |   21 +
>>   drivers/iommu/iommufd/pages.c                            |   94 +-
>>   drivers/pci/doe.c                                        |    2 -
>>   drivers/pci/ide.c                                        |  186 +++
>>   drivers/pci/iomap.c                                      |   24 +
>>   drivers/pci/mmap.c                                       |   11 +-
>>   drivers/pci/pci-sysfs.c                                  |   27 +-
>>   drivers/pci/pci.c                                        |    3 +
>>   drivers/pci/proc.c                                       |    2 +-
>>   drivers/vfio/vfio_main.c                                 |   13 +
>>   drivers/virt/coco/sev-guest/{sev-guest.c => sev_guest.c} |   68 +-
>>   drivers/virt/coco/sev-guest/sev_guest_tio.c              |  513 +++++++
>>   drivers/virt/coco/tdx-guest/tdx-guest.c                  |    8 +-
>>   drivers/virt/coco/tsm-report.c                           |  512 +++++++
>>   drivers/virt/coco/tsm.c                                  | 1542 ++++++++++++++-----
>>   virt/kvm/guest_memfd.c                                   |   40 +
>>   virt/kvm/kvm_main.c                                      |    4 +-
>>   virt/kvm/vfio.c                                          |  197 ++-
>>   Documentation/virt/coco/tsm.rst                          |   62 +
>>   MAINTAINERS                                              |    4 +-
>>   arch/x86/kvm/Kconfig                                     |    1 +
>>   drivers/pci/Kconfig                                      |    4 +
>>   drivers/virt/coco/Kconfig                                |   11 +
>>   69 files changed, 6163 insertions(+), 548 deletions(-)
>>   create mode 100644 drivers/crypto/ccp/sev-dev-tio.h
>>   create mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
>>   create mode 100644 include/linux/pci-ide.h
>>   create mode 100644 include/linux/tsm-report.h
>>   create mode 100644 drivers/crypto/ccp/sev-dev-tio.c
>>   create mode 100644 drivers/crypto/ccp/sev-dev-tsm.c
>>   create mode 100644 drivers/pci/ide.c
>>   rename drivers/virt/coco/sev-guest/{sev-guest.c => sev_guest.c} (96%)
>>   create mode 100644 drivers/virt/coco/sev-guest/sev_guest_tio.c
>>   create mode 100644 drivers/virt/coco/tsm-report.c
>>   create mode 100644 Documentation/virt/coco/tsm.rst
>>
>> -- 
>> 2.45.2
>>
> 
> 

-- 
Alexey


