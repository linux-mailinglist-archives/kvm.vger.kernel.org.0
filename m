Return-Path: <kvm+bounces-39892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECBDA4C545
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 16:36:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37DC3188691C
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C8A20FA9D;
	Mon,  3 Mar 2025 15:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="st9SPkrb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2051.outbound.protection.outlook.com [40.107.101.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35BB15855E;
	Mon,  3 Mar 2025 15:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741016158; cv=fail; b=gpinRc69biNXEVXIyfHgDRNafiq4T6HMc3xdUHx+7rlmZG8ifzo14zXhqm8x+tJhywJDURlMI4xqTF/aahMTFY+UPLlY1gwydVvESgxXC8z1QbAw6uVnX1dzCnl1VP5Ub6aNmye2A25JFrKEj0onOwHthzTYwLhMJDwh4e6ej78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741016158; c=relaxed/simple;
	bh=km+jJQ4HyjD6FUQTUBO2Kp+LZBkreFjuKtRkbAGZElA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=NNghZG2HFfqqh5VXmIJhkiYi6z5ZLBYbUPVVquhequ7k4C9hj5yi7PqdQXsgsC+pI4KwhmFiEaZzkrd3IqWaCHLe45sgH+QxVOKC/Tz098JNQi1B63Du4VKQR2Gb5cB8rrjewV0cUq6aNqPaPr9SjH+iqs8DqclU28dpdatusYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=st9SPkrb; arc=fail smtp.client-ip=40.107.101.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+0AzoaIOGQs9UBa3181x4/ngxQp01jKUpXRcMLgys/o2SgNAX98w8YHWB+2QOnhRhEG4fvRDlgDhqA07wxm0DixuuVkLSfW2ID1o7gRYUIEyYUWGohAswzPQjI9UM4/Bb/J6stTUGrnGakppjBqHZWCVcqW28i70yhpkNfGDISvQEIwrR//VXNEtINSAyKw1eIToIqnffY2keRUY8Z0cWNmV6VGqsXsFsbOXDBQ1R0DL7c7NUYLRIpzCZDPl/9ky/j1Mc1w97ku0PHHTRdXnM/2HegF4lRVv2tiM6QXJ/xt7lgwE0UedeXCorOrN9BH46mHANbwDX+g9+LgyJBTqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4du8ljfuhMr/P+D7sVdaogkOHdetV7k4sAzdWnogH5Y=;
 b=dgcwTOSYGryLI7YwWYPJhSXaIzhWBu4UR0tXLV2FN2n4tSdrw2fffE9BRliErtxEodnLtU3IbqmWdOszDOCVCFVgc/ihTkWR/hxVmTtEtJ0Wxao0OA1ndR3k34B7z7wVq24RNxZew72wvml0chd967TZcyXaMkzTUzYbEIIDu120m5qsdWO1Q4UkP6GHSjMZJd/LUVdZ5fMYshQrAMMxGnwk2YUwHmLwiDClu6OvqdUCbIv5qE9h5B3dMjpsRuZcFCd37hWRrJGlsnYsht9y2Mz0hy3hKoaPj4509WULpOLIbINq0QtIs24AoG7/jQYDM5c3Qvix+FE1j/wcr3vNGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4du8ljfuhMr/P+D7sVdaogkOHdetV7k4sAzdWnogH5Y=;
 b=st9SPkrbFcZjp4H/GIS57OnwAKXuIxZNByx8BkacjF94CsJxM7gEQJXXlFsOu4sE8fR/Pxmyih9oQ/gXoYkH8P2sb8or+VDWe62OsUap6tUl2I5VnGUIzqIVpdxtAVqs9mCTJJxu5FFDQrhS2sLqmmWIEY7BVRrWBe6VJP1TNg8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL3PR12MB6642.namprd12.prod.outlook.com (2603:10b6:208:38e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 3 Mar
 2025 15:35:52 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 15:35:52 +0000
Message-ID: <98945b3c-5669-1bc4-36b3-53380173b631@amd.com>
Date: Mon, 3 Mar 2025 09:35:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <6c8dbb978e0785ee5a33165a9c43d555991fc505.1740512583.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 7/7] crypto: ccp: Move SEV/SNP Platform initialization
 to KVM
In-Reply-To: <6c8dbb978e0785ee5a33165a9c43d555991fc505.1740512583.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:806:20::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL3PR12MB6642:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b436f60-2b80-416d-18e3-08dd5a6914bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlhDa3lZYjk0OERaSkIvamxBQmlBRHl1a0U4Y3hxTnh6VDM2dTIzU1dOTFlP?=
 =?utf-8?B?cVdkNFJBT3BwSFE3RnQ4US9haEpIU3REMzBDaCsxREM0TDZ5dzBjQ1F1emhV?=
 =?utf-8?B?cGVkK2ZNT1RSbDAzNGZtL2JjSnVLR2xtZkEzT2dUU0g2YkpyUTBDclFMUDhV?=
 =?utf-8?B?UC8wdWVLQm5aYVdsL0llZ2h5dkE1R1hOd2Z5b1lneTl0Ujh4VGZoaEYwcUtO?=
 =?utf-8?B?cmlqN08ya1FFek1kdWlTOVRCcFZScUZ6SG9NOGtMMWlMejI1YUxTeEd2WkVs?=
 =?utf-8?B?SXN4K21seGZENWlKbER0WGpxSW90Z2ZaU1k3K21SY0sweWVIbmZuMWFYano3?=
 =?utf-8?B?VUR0YkZxRkFtUHQwVXlaaU9YQkoxcVVsaE1OcTdISUpIR0lRdnpXYS9RNENj?=
 =?utf-8?B?OVplUW1jcVZsNnJnd1kyRW9ncG1HZ0Q0eHZDZEpzLzU2NWFLSWorYjFSeFBB?=
 =?utf-8?B?Q1ZZWUxFb1RudmVCdFJjNFBBT0xsak5ScXB0WFRrV1k2MFh6OHlPd2JKWmtF?=
 =?utf-8?B?SFBnMEpmK215elJMaEdhdVJWOUpybHFCYVVVbkoxN0Z4bHBQZGM3QndFR3VQ?=
 =?utf-8?B?VmFvd1o1aStNT0xIOC9maDkveE8zUUpURGhkdm5WeTVkUWpVWmJWRjBubkwy?=
 =?utf-8?B?MC9rUzkwVWl4aUlwNEx4aHAzT2ZGYnR3R2JiZGoxYkJxTkdHaHNMdXRuOENr?=
 =?utf-8?B?ZDJLWmV3ZUV0U216MGY5UnVHN0FrbjNWcTA5UmJZb2FSaEZjb2pEWmcrbDNU?=
 =?utf-8?B?bEJHL2xsbmRmTHJUVVFhY3FtMlo3Z0RhaWw5bGdwRjlYT2llNFVObWZiSmM2?=
 =?utf-8?B?c1FrcTdJL1pSRkpZQ1hVWnl0Sk8xcVozR0UwN2ZrRmpzZys3S2V3c1pBUjg0?=
 =?utf-8?B?azJzNVBFdnFaYnVIRlMwKzJmZ1RxTTNPa001YkcwVHRiUkp1MFhPSEFLaDM4?=
 =?utf-8?B?TU4xY0tZUUM0a0pXZG95SHdQeVJrOXNiSDhpOG5IdzhXSHVxY3FZNTllTTJx?=
 =?utf-8?B?Yit6Y1BCVkxGWEw0Nlh0M2ticWl0OE1NcS9LMjVGTWdDNk1PcXhuMHpPbDlQ?=
 =?utf-8?B?MmJBUG5hdHRRak9yVkY0M3d5aVUxbFNaL2VEOVRSNyt4ODFPTmgwZ0NITDB1?=
 =?utf-8?B?WDhzZklkeXRmZ0x4M25tbTk0V2duNk1idGlwUitCbmZZcWFsNWJySFdIQ1d0?=
 =?utf-8?B?ZmVCNWpZbzVJb1FUdWQvZXZqQW44RU5xQjl3UjdqclFEUzhYUHRjUVRyWDVz?=
 =?utf-8?B?QUk3anphNkVIUndRRTRBZUhRUWJsS0ZrNW5UWVRBMDc5N0lOWEZTUW44N1My?=
 =?utf-8?B?ZWFHZVhQblZldXpSM3FhK013S0pwWGU2VTBkaVRiUXVNZWtZdHIvK2FlN3V3?=
 =?utf-8?B?aGtaMG14cDdnKzlwem9hNzIzVHJSM0FYb3p6TFh3UnlEWEEvYmV0ekJkZmNB?=
 =?utf-8?B?NTFuS2Y3WVNFNmR5VVJYZHNIbU53WHhFb09GZzNyQk5lMllZY1Axd3NiN2Vi?=
 =?utf-8?B?ejhiejNBdUp1cThEeXZ6c3JOUzc0dG5lUGp5UHdpSlgwcUVjbG9EOThBSHE3?=
 =?utf-8?B?M3ZabTh6aStWZFhMZkcyYmM0Yk5WdGxWMUt1VkFDb0gxdTNFamdDUi9oRTFx?=
 =?utf-8?B?Y1hSdjhRd2U4Tk03ZkdpNmNIOFRGMmNLQVQyL0E4NDg0WndCU0tkeWVjWkRC?=
 =?utf-8?B?SHRXd1Q3QzBNaG5GeXNvTGZCQTF5UW02WDB4QVZxUWg0RWdzOEF5bVRoajZt?=
 =?utf-8?B?NVB3U1NKbXJRQ0hHNXg2NUVYdjhpZ2RzRUJXbEdkaUhNZ1B6MnpMNGRRNGh5?=
 =?utf-8?B?Ykpmd0swOTgrdHU1WTNzMXgzNmIzb0ppdDZKK04za1loR29sa1QwZzN6aC82?=
 =?utf-8?B?ZThaQXRGNjMzQUJHUDhnZWpHbncwR3NuKytOWHZIZFVYbUdOUjhjZ083TGhG?=
 =?utf-8?Q?yZFg0zx0jvU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3NaZEUzOGZmbVlsd2tkNnIzaENjSWwvS0taVVMybzBkeUpCWTFVSU41bzBK?=
 =?utf-8?B?MHJnKzRIM25BaXlrck1IbEt2cklPRDBtQ1o4RUM3TXE5dmtLMVZzV3RpSE9K?=
 =?utf-8?B?ME5ENTBWaGo5MlVSQWtZcXA2U0lPUnFnd2ZqMkdIRG9rR3hLMHVVQkpHbmRK?=
 =?utf-8?B?ektndHBnMDQwVGZqbmlZajBnSTB3Q3c4cjAwNVRiTjBYenc4QW9PRmRzMlk2?=
 =?utf-8?B?UXIwYWZQUTJhd3owREEzSHFUc3o2aTRrd2xFcHdGU056eGs3UUVBQ25KSHcy?=
 =?utf-8?B?Y3IvQXZFUU8rcjJScitQYXJjU3N5RVM2SDQ0ZVA3cHd2MkEwdG9udTNjUXhO?=
 =?utf-8?B?dDlCS0VoUTFKTXRnNkNYWUY5WEt0YXk2eHMvRVNneFdDbHJmb3hNY01oc3lO?=
 =?utf-8?B?VHg2YXVRYzk0WGw3WmRNckRReDVieG1xTmZzSVJJMGtVdFhBNzZyZEdCL2lU?=
 =?utf-8?B?Z1pId2dBN2U5RTQ3dlpma0hkWUplN2owWi9Oc1k2cEcvOHo1R2FjQ3U3d0xZ?=
 =?utf-8?B?K2h1NUN4MkRPS01aN1pEaCs4VjFaUFc4ZVNVUnlEZm14R1hzczl0OWJFTGht?=
 =?utf-8?B?NEhwMkd5K3NPTHYyOHRNU3p1OFFIL1dkUDdvUEFjR0hMbjdQNW5Fc3orVzho?=
 =?utf-8?B?T2t0WTdIcTgvVkdoRmZ5bzBuZzd5MkdaV0JvYUxTY3ZyWEpZaEFtZ0RkbmRF?=
 =?utf-8?B?cXl2aEhuckZTdWdZemhFQnB4Uk1rQmJnNFdVQnNnZHdqc0xBYUxkSEZJbjZI?=
 =?utf-8?B?WnJudElvTzd4eXNtQjMydk5wbjhWYkc2dmtJREdFUFJUYVAvaU5pcjc0Nysx?=
 =?utf-8?B?RzY4ZEJXbVl6SkxGYUp2RGM2WWpEdk9IeDdrNWZEbC9EdTJPMUNwdmNtVGVK?=
 =?utf-8?B?SUlwL3cwNURpYmRCRGpDeGI5SUVsQjR5dndxcHdrOGxmeWRRTlNzME5iTkM3?=
 =?utf-8?B?VzJSR0hGRWpVanFnWlY2NStrWUVHR2JoNEFYN0VNNzVwMk1ON1hvcTR1bGJB?=
 =?utf-8?B?dGNSMDZWNEMyOEp0MDNUdWhyRmE3dUNpaVJsMzhEbnRtVnJEZ0grR25TSzUz?=
 =?utf-8?B?WXA4aFExb01LaVVDV1lCN2N6Z0Rac0NNMkYyeUdoNCsvQWZZYTl6Sk80bmRv?=
 =?utf-8?B?V2JmdXVYd0FuNVJlVWtnN1R3UFg3NGtjOHoxYmtjWXIyZnhVUmQ0SkFhVTQ0?=
 =?utf-8?B?U2xyYWxuRzZHZGFEYThnMHRuZklEbE5KRWZuUVoyRWdmM1ZBTmZKVkQ3R3dV?=
 =?utf-8?B?QWxoRDdkNkdmK3p6bmE3eldmbXp3SFVibHpDdk9BenVMQlZ2N2kvcWVFYkNE?=
 =?utf-8?B?V3dySzUwK2xZRVVBSFp1d1dTRHlIeGt6aVlrbjlYTmhIMDEzN2RGYnFpR050?=
 =?utf-8?B?ZlVFaGtTU3pCYWFPcDcwbU5VRElpVFJsZjZIRlFPekE2WUZjT2NwMVFINU9H?=
 =?utf-8?B?QWlYQTVQS1ZrSUlvSXo3QTIyY3I4L2tRcmEvMUh2NWNRTjFnQkc2Rmszcmht?=
 =?utf-8?B?VmUxYnpuOFpFTmxFMndBbnR0akdldXNFaEZYczR4ZUwrVVdaSDM1VGxQT2p3?=
 =?utf-8?B?MlVjSitNQ2NmcHdtNGF4dGpjRDlTU3RycFpkTDNHVjF3YnhXWFkrdnlVU2xF?=
 =?utf-8?B?ZHJweHE3Y21RMkV3ZTM0aW13MEY2M1JiMlFaelV1V1NlYkNvcnFVMXExTk1v?=
 =?utf-8?B?cGxqOFF5Mk1ncXIxWTlrUlNoRnlVL3AzZzgzMktRa0JuYmFOanduNEo0RURU?=
 =?utf-8?B?d09mK1d6NEp2ZElIbjlsSEt1ZlhpTlM3dVFNd1RqNWlqWjNBNm54NFNMbW9T?=
 =?utf-8?B?WE1IVy9YMm84cE9xZ3VLTFhCVFR3ODlCckVkUDBmS0wreUxoNW9WbFZvR0hi?=
 =?utf-8?B?c2E2VFNkM0l5Wis5R3FJUE9tSHp3VU90L1VPbWlOR21IUWlrOTNmR09yNXIr?=
 =?utf-8?B?dFovZVJHamNVSVgrekxVL1lsRkN4ZTNTRU5keGxXQ1V6dlMwS0lDRzhudGdy?=
 =?utf-8?B?K3ZMRDdKRVRma0tWQmRmakN5K09iekpXNUQrcDNnUkZQWmlOR2dZOGl1cnhI?=
 =?utf-8?B?MkpBQURiVC9hcFZZZ0kzemVTd0VqRFl5a0NnSi9PbWpOUnlQakVZOStYQ2U5?=
 =?utf-8?Q?c7X/7kaHpfVSixxaJ4cEug1KL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b436f60-2b80-416d-18e3-08dd5a6914bd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 15:35:52.4182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VL1Qov0puud3Eum/sJBF+QeL8BU1WPpowkCTE/dmn2k1WXhN5MZLi62FTqvzw2MWIdyGCmBLZvzodHsv+3tJKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6642

On 2/25/25 15:02, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> SNP initialization is forced during PSP driver probe purely because SNP
> can't be initialized if VMs are running.  But the only in-tree user of
> SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
> Forcing SEV/SNP initialization because a hypervisor could be running
> legacy non-confidential VMs make no sense.
> 
> This patch removes SEV/SNP initialization from the PSP driver probe
> time and moves the requirement to initialize SEV/SNP functionality
> to KVM if it wants to use SEV/SNP.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index cde6ebab589d..42988d757665 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1345,10 +1345,6 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> -	/*
> -	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
> -	 * so perform SEV-SNP initialization at probe time.
> -	 */
>  	rc = __sev_snp_init_locked(&args->error);
>  	if (rc && rc != -ENODEV) {
>  		/*
> @@ -2516,9 +2512,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>  void sev_pci_init(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> -	struct sev_platform_init_args args = {0};
>  	u8 api_major, api_minor, build;
> -	int rc;
>  
>  	if (!sev)
>  		return;
> @@ -2541,16 +2535,6 @@ void sev_pci_init(void)
>  			 api_major, api_minor, build,
>  			 sev->api_major, sev->api_minor, sev->build);
>  
> -	/* Initialize the platform */
> -	args.probe = true;
> -	rc = sev_platform_init(&args);
> -	if (rc)
> -		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> -			args.error, rc);
> -
> -	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
> -		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);

Should this dev_info() have been removed in patch #1? Because it looks
like this would have been a duplicate message after the first patch, right?

Thanks,
Tom

> -
>  	return;
>  
>  err:

