Return-Path: <kvm+bounces-55090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E0B8B2D29F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 05:34:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93A221C24D54
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 03:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE078228C9D;
	Wed, 20 Aug 2025 03:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hfetoi7n"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF963BB48;
	Wed, 20 Aug 2025 03:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755660848; cv=fail; b=IoiPpfjuRDa/xektFOQYgrNhUSmDjxolPRPyp2JPK5CiuOESEtOxfEs/gfMPbydh9tludERldfSRLFdLYjDFxWuATTduA1Lyu2+6hBJoINQDZYU/tX4jeXxOv020sajN88Pi6ykjcAIf6/59Xq06wNxBd4qBQophYtRtWy7iV4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755660848; c=relaxed/simple;
	bh=Su4wbN+7oG8xMtzoruPoux5/mLJpSAEhX/mSxVG1wUg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K2go6Ic4d3ftqvi7AgpSyAw9w3G6V6iUJTPR3j03mijNNp1dhjXzW4EHxWV/38moHKy1W0tans+PrjFBXnijLDpIt8wtObShzZrEYVLeiGGxzkX7jRiCd4KlwNOnxZsYkNhw7Q5HEiemfyquRWIKmQ4K20kYearYUe2/SYDXudU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hfetoi7n; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gOOd4/t0Zsp6Tz+ZfelSWIqAU3MQXUCEdc5JwkDlUra6WT32Jq2BPqpSA0JqCit7wA/pG59/f10r4VyLftkZrAuXeNW8Z7SZVo2DdOHbkEABUV3dMQBcsAslEGPqwwonJZ2+ibaJc4MQV/hcJKXSiMFZFJmVJNWWZDzo3VGFp7JILZyx9gGMK1wbsBqLepC1rCIsDGFg5xi+GQsm+Khzk57vUQpc9JsJ8zIgDjVhHg1qIK2M9vIJogDASywsBSA/6MbdRq7KNCM4lbijv/P0l8PfONo7ZE5Rr6qIt+RDcicXS35/wEpx603a++qFL3znOH96uru6E/CQ0TzjkrV++w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWOU07+IW1RY5AbyrQrYs+5hCaqLZs5wv7tNp51u7ls=;
 b=PSPmt6vnihRI9nylM8hvj62janFhgDtAJ34RgnH4uxxh6NyAFQoMuGGutq4YB7806l3X4r6qBdsb/BpP8zXSLpAuZSxbHO3KLWwFaSvrB+zyoIkfIUmTEC7/tUBrhACQbWwHfowbrRrueQRlv3dI1xs/3cFcWXGvW51fR0XPddrzhm7XprgvTuTT0YQLsCn9UfB0d20r+1GM18Au9NXNlGZAgpTFEZIMrlMxSISyxyuAu0Xd1hr5ePETtqPdap4EqC3Sjg1ZxcbIfXxZ0f3V4a3QfTyPR12N28AZFWiYep0/lMteexN7o3KcyKJCsLJuuKg8OmwUJTIxOZKYh4RCbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWOU07+IW1RY5AbyrQrYs+5hCaqLZs5wv7tNp51u7ls=;
 b=Hfetoi7nq7e44VN0fCNuCuNhRgFNd8yE+VA6tKkJge6rLvjSbUH/ZChy28Y4Occp7HeDTgqPW2IpFoZk3N47i3r7Ev1D2tJznuP1YzKSbIkVffl9SJwM6qLnGHT3LVSB/nokK3iJRpkIbFYbXvAIlWEFY1+d97pfG+4EBklMo18=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SJ0PR12MB6688.namprd12.prod.outlook.com (2603:10b6:a03:47d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 03:34:03 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 03:34:03 +0000
Message-ID: <43bb8dbe-8213-4c12-b9e8-0182f808dd9c@amd.com>
Date: Wed, 20 Aug 2025 09:03:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/18] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-4-Neeraj.Upadhyay@amd.com>
 <20250818112650.GFaKMN-kR_4SLxrqov@fat_crate.local>
 <964f3885-059e-4ab0-b8fc-1b949f0b853b@amd.com>
 <20250819143214.GKaKSK7rABhHAldbbR@fat_crate.local>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <20250819143214.GKaKSK7rABhHAldbbR@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0145.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::15) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SJ0PR12MB6688:EE_
X-MS-Office365-Filtering-Correlation-Id: 6db87bc7-4a08-4cff-8d13-08dddf9a689f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzkxYTJLdEo2bWJQYmYxVUZSbm1WTFBBV1hibWRCRzZENzZJQ0xXWWppMm05?=
 =?utf-8?B?b1JTQ0lNS1pyUVFTamduejR3Z3paaTVmdTZnQXc3ZXFKdURhMmZpM2Q2YThK?=
 =?utf-8?B?SmY3RlBjRnhDRWdKSFZOaVNrcnBFN3VjNE9QSFVWVnlMVmowRHVpYTg3eFpU?=
 =?utf-8?B?MDlZWW0zUmNEWXhiTEUzMkZBRTJFZ0loRlh4b2x1L0V5VzE1cDdVdllyeFRk?=
 =?utf-8?B?MUJIYXRZMHdLWVhmMjJUWlVxNFp3ZDduU091U3FybGZWTWhmaWwycUJzQ3BI?=
 =?utf-8?B?Zk9tZG0xY1FxUzdSUis0RUxWOUxUOTdraDNqNXE5amgzQU1zUitqUW1NNytL?=
 =?utf-8?B?ZlNwLzc4RThvVFQrN01aQ0dYMVl4WjJlOURHZzUzNEs1YjZwZmJ2Rm9xR0pq?=
 =?utf-8?B?YXkwL1NGNkMycWpQUzFTWUVXOTlRVzhTVEtlalBPVTFpYXNuenJqWWxOaHR1?=
 =?utf-8?B?d0NYWlZlN0N4QndDRm1wSU9WK3hYQ3U5MWhYWFppS2NQRG03UkZWL2JnSkpo?=
 =?utf-8?B?OEZwR3h0dUcxL3IxMW5saUNmQ2NTbU9IajFFclQxZ21Ibkx3Y1h3eThMWnp3?=
 =?utf-8?B?UHJISi9abkhYeFhmYTZQNUYwOTN6THpPZWRKRDA1aXFMbHZaUWpQU0RSSmV1?=
 =?utf-8?B?Z3V2VXVJQWUrZlRST000V1k3Skl3ekhDS3NtQTAyRGRCN1N0UzQ3c2RMa0dI?=
 =?utf-8?B?dmx4clJWU01jNVRYUkJJcCsvQXBma0o0K1cwMS9Fcis0LzJPbGhld3VnaVkv?=
 =?utf-8?B?NTVsZHl0b3BEOWZrSlRUM2lzcE42c3VIRnVXVGhnZTJLUWloVkIzcFhqQ1lJ?=
 =?utf-8?B?OWJPVi9KVW55YXJOWi8vYnh1SHBIcEVuVFNqQnlYNnA4OTZPQ0tQTWJ1QnRN?=
 =?utf-8?B?Rk1yY0gza1FlVlpvakFuMS83NVorRm50MFFTT0h4b2xVSzB0dkVJVGZ1UlhP?=
 =?utf-8?B?bXM2WE4vMUlOazV3Z3Y3VXF3Q1ZYZjFGb3JUc1FLbkNqbTkrRUtYeWxOY1g4?=
 =?utf-8?B?bzcxL2ZKWnBjZ0tYeVBFUVZYTDlEZGNpSnJ3WHA3dG0ybE1ORUR2Z0MwMzhR?=
 =?utf-8?B?dEN6emtLb0pIZnZ2TVF1cnc2RTlhU21oaC9vbUNib3crenNWdWtDd3pMclJ3?=
 =?utf-8?B?bUVTd0RpTDRxRmtjR3plRmFxTWY0Q1ZMaytDR3dKam1ua1g3ZHg2QUhoVkZG?=
 =?utf-8?B?aERQOEpLNzJ3ZG1jUGRjUEsvQ2E2MFZnbmFLNTNib0hQNm1ZN1orU1lERzY2?=
 =?utf-8?B?Nk5qaXlURlo0Y1JSd1FXMXlZQ3o5dnpsUmhiUjI5NlNVV1hPUFpDQjhTWEFy?=
 =?utf-8?B?VGtoZUdkYjU2c0QvMis0bHovelRwS2twQVRadHZ4dndFMDJiSlc1WWlwYU14?=
 =?utf-8?B?ZHdoSG9NQ1ZJbm1HYmtOY3NGbFNGMml5MzVuakZHODBSSEZmQ1k2cGJVRWtz?=
 =?utf-8?B?aFZYc2FjeGV1SzlDNmNoKzFIWFo3YWhlNFc3V0dlV3JMQU9HTWR2ZGs3eW1G?=
 =?utf-8?B?ZER4YnpSVUZFL0dWd3pndDlqUG84VTRhcUpSNEZ1eFhlSGJpWGQ1RDE4R0NQ?=
 =?utf-8?B?MUd5WUNTL0NMdUF6WjFkdEpOM2I4NW80ZVI3ZmwxYTVvN2RMWkc5ODBRVngr?=
 =?utf-8?B?THZQY1locElGMDM4bkY2UUNGTWdGcVZNV0psblJRdmxNd3JncTcxUUdZaDhl?=
 =?utf-8?B?dkIvYmd6YWM1NFM0MFRDcHlXbVF1dkRrcW1JZmdVYll3MzR6WTBjQXlhT2Zi?=
 =?utf-8?B?aHBHUnhHMDFtb1RZbTZVbVNTVDlZa25MN2xvVHBWaTIrK3JlOFNBZVRSWEE5?=
 =?utf-8?B?cm5FS0ZTaGNSVkh5N2FHVjlVNGNYNmQ0SXJaUXZ2NWVkdktXRDRXaDN6Rm56?=
 =?utf-8?B?QXg3NGk0ckk1WVo5aHdZd1dGUnViQWNCMlFva0U4OGN3YmtMNlEzU3l2SnY4?=
 =?utf-8?Q?VeEKoAXFz8E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2NoK1hBMlBZdFdwWEhOWVZERnJhSlhyRVplNHIxYjBwcWgvTTByOEk0SFJk?=
 =?utf-8?B?UGZZRW10ZCszQkxucHM5L1cxQ0hrOWlPTUNRSmhsTld6eGxKekd6WjZlRDFR?=
 =?utf-8?B?ckNRM0UzUHB3aEdqRUd4ei82UGdkeThDeFNmY3E2cEdKN1FsbTFxMnFDRDQv?=
 =?utf-8?B?OGNuQ3NJaDJiNHQ2dlZTNmpkaUF3QWFNT2lmZVJWcERiUXhwbTE2blFBWmdI?=
 =?utf-8?B?a1ZUM1h4QUgxamYvbmZtZnFZb0xHSTdaTGJmMEZ1MkpPb1FQUWdGSTFzd2VG?=
 =?utf-8?B?T2laQlZrcjBnM1lPZGFJdkZjWlpGRDU3NmFFL0Z6dWlzY1hSVlpzSjZobmpK?=
 =?utf-8?B?Ylg5ZkFsd3dFcUU1cGVJNnh6bmE0WmlQSkxtdDFkMWM5bGJYOFdxT0NvdjUv?=
 =?utf-8?B?QmVrNmpDcHYxN0x4UG1jcUw5WGJMOGZTTU5UZFZVQjZoektTZWJyNVFZOGxt?=
 =?utf-8?B?T0FLMUN2UE9UcXRFU3FndEp0L2JweVRqTnRzYysvMEI0YlVVZ0JuUmJRWDZr?=
 =?utf-8?B?WEZaeXBhMlhXdTA4eG1pMmlnMHFxREVNQ0VvM0RDYjZZdHRuUmphRFJqZkJO?=
 =?utf-8?B?a0hNeGZoc0V5UWpzMjVhTFNBTXdHdUpKVjBZZEF3elMxbjdkVGRjUVFiMkdn?=
 =?utf-8?B?Ukg4UXJNa0hod1Ntb1lLVXlrWVk3bTZWM2pSMXhkcWdiQmEyRG1qN083OUtZ?=
 =?utf-8?B?OGtiN1ZnenZRUjdkRTFvWGZHblBZVE1VZzdqaE84VDJua0JYek0rdlRvMjd4?=
 =?utf-8?B?UWZUbjhEditUL0V1bXAvMk54Y1M1cmZpbDFHN01mTW0zc0JUUkVYeVhmRExH?=
 =?utf-8?B?YlJBcTFWV0hzWWhWeUx1YnJZS001QndJWEt0SVZJNENBZVBCNDArVzhidy9u?=
 =?utf-8?B?RWdhdW1kWWxEaXJMQU0rOTlEbEoveTIveFRSK0xzejJhVEhWSUpBd2R6eGoz?=
 =?utf-8?B?ZUY5d0ZVT2FDdHhCWXRWMHYwQzBBTGVoM0daQUdtNFFXeFU2NUJvLzNoZVlh?=
 =?utf-8?B?SE9FT3U3cmJLQmVsanNxb2pWby81aDU2VEdacGVwZW5ycnRBYWZublQ1NEYr?=
 =?utf-8?B?eG1uaVNVMER3R2xFa2pCKzQxMnBuSU9HYkVlNFVRNk1CRFVXOXh4L0t2cmla?=
 =?utf-8?B?NURpTFlOQkhWWUhrNGt2MW1wYzFGVkJ0RmRkbFZ3WEtpcVpWNGF5NHV2cVVK?=
 =?utf-8?B?enhWUVErWHpWcjhrSjNkeHdwSWg2cm5WdkZ2L2pTWFpiRU9MaXJMdW1pQ2dQ?=
 =?utf-8?B?a1dmcjZ5emdjVGJoOEhGRVlEVGdKZHdxbXJodEliYXNySWtrTUt2UXVoaUkv?=
 =?utf-8?B?a3B6ZEQ4NjdjenExNkNsRTVxMjdLT1JwaUdaaTJUL1FOd1NDM3NIUGF1bm5P?=
 =?utf-8?B?VlFKaDNnd0tIQWRtbGJIV2FJUmV1Y1dqQzJncFdXSDlYYVhTMnY2dXloYVZw?=
 =?utf-8?B?UzVvaStBdCtPUHEzRUVFV05lc0lLWjE0Q2cwdlRWRnI2N3dhcGhmekZjbWFy?=
 =?utf-8?B?VzYrcGUwcDM5L3gwb29DQ3NaaittcnlHYmVMRm9Ydkp6YzRWU2lIOGdvbUwy?=
 =?utf-8?B?R3c5ZkJrM0JTU0tvNjduNmp6d1pSbTJTRkhFTHA3RlFZc3YvbVQxRWRoSnZ4?=
 =?utf-8?B?dThwd3UxVE5JUUUvQS9VVDFnd0xJdDFITmREWEpWRlExVktlTm1ORTNGMEVi?=
 =?utf-8?B?RkszVDlVd1htVUU4L3QxR3BaUDBLTEUxM2lZZ1pHNWNyREs0bk9XL2JxcDZE?=
 =?utf-8?B?c25JakJPMCtQbm8ya05wenR5SnVHSDJsV2pUaEl3R3pvdXBXRmdsejZjS2U2?=
 =?utf-8?B?aGJ6MWFBT2tqejBnbGlrNkRPQTdBR2l0MWV1ZlhLVnpuajJ5NVF0ZFIvcVMr?=
 =?utf-8?B?RC9EM1ZwVEFWcFByYlZNQnJBa0dsUlZLV29VWmVHaTBGUHVzdVN6czkrb0Ex?=
 =?utf-8?B?VjBOWG41WXVrbmNxaDVaVTVmaXk4SGFHcnpyVWROVWZDaUViTkRFd2o1ZDcr?=
 =?utf-8?B?OFpGalJxWVI0a1pwMUFmcGM2MGI0ZWYyazJ5c3NhODJzN291clFPbSs0UFlm?=
 =?utf-8?B?UnY2a29pRDhaQnc3bjBLODB3RVZka2EyVVhieGh5b201dFRRQ25YZHFxdjVr?=
 =?utf-8?Q?Qde1pE3JMHSbEN0d5ZbaSFf5O?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db87bc7-4a08-4cff-8d13-08dddf9a689f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 03:34:03.5287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9AEuZ32zUxlgN4m1+vA0V0A1M0d4O9QZApDySLXHrPJyChdRVkEFrt3woMF7s7Tkzkc5qUDhIsKh6nO1K60IiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6688



On 8/19/2025 8:02 PM, Borislav Petkov wrote:
> On Tue, Aug 19, 2025 at 09:45:02AM +0530, Upadhyay, Neeraj wrote:
>> Maybe change it to below?
>>
>> /*
>>   * Valid APIC_IRR/SAVIC_ALLOWED_IRR registers are at 16 bytes strides
>>   * from their respective base offset.
>>   */
>>
>> if (WARN_ONCE(!(IS_ALIGNED(reg - APIC_IRR, 16) ||
>>                  IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)),
>>                "Misaligned APIC_IRR/ALLOWED_IRR APIC register read offset
>> 0x%x",
>>                reg))
> 
> Let's beef that up some more with a crystal-clear explanation what is going on
> here so that readers don't have to stop and stare for 5 mins before they grok
> what this is doing:
> 
> 	/*
> 	 * Valid APIC_IRR/SAVIC_ALLOWED_IRR registers are at 16 bytes strides from
> 	 * their respective base offset. APIC_IRRs are in the range
> 	 *
> 	 * (0x200, 0x210,  ..., 0x270)
> 	 *
> 	 * while the SAVIC_ALLOWED_IRR range starts 4 bytes later, in the rangea
> 	 *
> 	 * (0x204, 0x214, ..., 0x274).
> 	 *
> 	 * Filter out everything else.
> 	 */
> 	 if (WARN_ONCE(!(IS_ALIGNED(reg, 16) ||
> 		 	 IS_ALIGNED(reg - 4, 16)),
> 		      "Misaligned APIC_IRR/ALLOWED_IRR APIC register read offset 0x%x", reg));
> 

Ok, looks good. Thanks!


- Neeraj

