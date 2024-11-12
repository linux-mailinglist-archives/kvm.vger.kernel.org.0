Return-Path: <kvm+bounces-31627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7849C5D12
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:24:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 979EE28238C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095BA205152;
	Tue, 12 Nov 2024 16:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gXYV+U56"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23C21B81B8
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 16:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428641; cv=fail; b=ktpCNUSwW8uIdmzJN9FVU3dt29p1HnoPiID3dnp1SGmdRLqfETvNdR+cR1wGLNkBMZ2dQTZapUnw1cRKitwihB2gTreuNEfz7D57wEHyJy3fpVkeWJUTlFrFCTB5a8leQIq0sKvyvdBDBY260PnZ+exZjCMAsKIQtj+2qM0NgWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428641; c=relaxed/simple;
	bh=sFX4TDI4iP/oCf6lMaaMevDtl7VRluHmrcj6IR33Qh4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QSRmmEUeAlpH23f7lbxqnkYm/uRfYR0ckNkfdmHHvUMM7EclaiubxEKvIJ/JhYKTponJ0OsqPB34dtwcVs95tWJgjrPRnkK04wJ6i0sLMW5eVQ/Uoq75bl48XsAbpBOXpy7gm5tH+ZTdjIz5JBfIl90XEKEFjIX9LWoyYDVig50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gXYV+U56; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEpba5DWHJdbV3vFkb87PBVDkM8xED8AWuWyyYZXWMNmYCKkj3DVGJugKMX4RcSLLbR7HyZm7Q019/kufb64guLez0Xc9+jeuloAvMOcVceGBUgDEypzg9Dp8MM0SbnP8W3ArNZOnAhOTZhLR9WN67uKFg1elzsxTINPlV8V+SIgI6wQIIFMQHLErpOb8k/a8ZZlxjoam2UAHrE1xiXHDc0sm7W+4SALELjh6wGC2gopuSwLkBYtfTxSjrrYJGkmgIRptK4qw37J9qXLCESQkL+5p8LRCHlzWLtcNZm5qghXhjJlFXD2MKeAVa6S8fWEeYVeYRRl6lfV39Hor/31xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycr+2cYAwCIKToCiUnwg6cEAHHJ9NRFyA3HizlIVPA4=;
 b=G8Qs7wIblMubgEvqHIY0nvPrJ69oqH4QHa/t1ThkFAqNRHuxspBAlWrkk/0ecEYwxzf1N6nTwdbyLMWqJ/o/NKgV3quZz0gnfZcMf6vCodMWhNwCO1w25p5RinaDg4FtBuTM35YgTi6rIT3ck4TDEuwIsNXpTyYYv/FZpCZVxVczSdaugNnJf50KvvoRFSbq6r08QBpeNBgT+CjJnXELCuw1Kw6hcvxsD6itAUNLrxucIq/H1np5hFUR4zyYO71LY44X/dJHVcCFldxbE+xKLSGQXgVMtuNgf3xi4HBIKspv1dqebwOcF5k57mzjwDMXl25isfS8bcInI9mPvylecQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycr+2cYAwCIKToCiUnwg6cEAHHJ9NRFyA3HizlIVPA4=;
 b=gXYV+U56miXf0WxmZ/RT+iynBfkmyi6CJQD4FcjjFws+X8WwDZxK0djB4UqcG3IxlkOywOT+D0sMjwZG2rGBk15QcHhMDh6l7gFnP2Dgb35TQ/l/6yiVZqf8nqU/j2TKWCoO3Lozu6Njfjdaf1IDsbU3Vgp8FdOBltRZ12KXZis=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 16:23:55 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.8137.022; Tue, 12 Nov 2024
 16:23:55 +0000
Message-ID: <7f7bf82f-c550-48c8-af38-e0992829f57d@amd.com>
Date: Tue, 12 Nov 2024 10:23:50 -0600
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v4 7/7] target/i386: Add EPYC-Genoa model to support Zen 4
 processor series
To: Maksim Davydov <davydov-max@yandex-team.ru>
Cc: weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
 paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
 mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
 marcel.apfelbaum@gmail.com, yang.zhong@intel.com, jing2.liu@intel.com,
 vkuznets@redhat.com, michael.roth@amd.com, wei.huang2@amd.com,
 berrange@redhat.com, bdas@redhat.com, pbonzini@redhat.com,
 richard.henderson@linaro.org
References: <20230504205313.225073-1-babu.moger@amd.com>
 <20230504205313.225073-8-babu.moger@amd.com>
 <e8e0bc10-07ea-4678-a319-fc8d6938d9bd@yandex-team.ru>
 <4b38c071-ecb0-112b-f4c4-d1d68e5db63d@amd.com>
 <24462567-e486-4b7f-b869-a1fab48d739c@yandex-team.ru>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <24462567-e486-4b7f-b869-a1fab48d739c@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0145.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::29) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 52dbbfb1-92ae-41c5-2123-08dd033666af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WnYxWU1rK2YvblFTalBMZmJPcytrUTZYbXdYdUcrZnprUUhiajUwS0lVY05j?=
 =?utf-8?B?cGg3TlFENjQwajdnOG5ndmtGRXNmS3Rwd1U3TU8weTVlVy9WYTQ4K2tSY1J2?=
 =?utf-8?B?NUtWVldhT2ROd0pTcm54OVBpekFhUVBYVzJXb1M1cFRwZG91bTV0TXRRTkpC?=
 =?utf-8?B?enVCRUh4NXFBSVNsS1ppUDlvd0lpaUFtOCtIcXdTWXZSTUtqMUNuMFlUeVVv?=
 =?utf-8?B?S1hvdXBJYmtlalJLeDY5cVZKdk5IMlRGKzBqOS9HZEx6WStIUDBINGFiT3Fk?=
 =?utf-8?B?NmZPZmluVGlwUTAzcUVCTTdjQTMwNlRzM1A0ZmJRQXh5dUcvOU4yZHFWOWV6?=
 =?utf-8?B?a2d0SDB2ZmZtSEhhNnNEQW5lLytpTjdudEhORXo1WVVSRXpWRFlIOTBpUS8y?=
 =?utf-8?B?ckM5RHB6T2JEZVhJTnpmTVdpUUxRYURWSlB2cTdsTG9leG12eGxHenFmNlBI?=
 =?utf-8?B?TlNDUTk2QkdlTjYvM3c5ZzBHZDlHYXYrZkxyakpRUjA3K1krcEJ2SHN6ZUoz?=
 =?utf-8?B?cXJhbkVBem9uNzlBMmNmOWw2UFI0TUhHcXMxOE5hamk5eGRHWFY3akFLWjh2?=
 =?utf-8?B?RURrdzh0emNqRU45VUR3TnkrU1ZuOFNWaFdFeFZQRmRObmduRmdtUEpENEZu?=
 =?utf-8?B?dlpPUTVPcEFnRUVnTHBjUVZvQUhDOE1qOHBNcUkyN1BXdjU3WTltcFRzVVFG?=
 =?utf-8?B?TzNQTXNLVkRkbU9qZEhOVitaaUdhbVZQRzVTZCtzUlo2NFFlN01jSmd3TDNP?=
 =?utf-8?B?VE92QjBUTmV2UEhFR3B5K254eVgwNFh2OVhDOXFLREVwUnE0a2hLekJUWCtQ?=
 =?utf-8?B?cUpDem54dXhWN0FwRW9mcFJGL0RBMkFORnpPaFJSWkxRTFRNMkZkRlZYbkRH?=
 =?utf-8?B?aExHSXFTdU5MejdlbmlrRzNhN2dQMTRsR3JCOXpjbFRHdUltd2ZQV21qTWE5?=
 =?utf-8?B?bHUxdFlna01hVnlRUDg5RHExOVJ0ZUFWVDlIV053eUlCYmFtVzZMQ2pBYXdn?=
 =?utf-8?B?WlU0UWIvRGZqei9WUCtQVGpmUVpBLzNmRm9WcFZoTkppR1J5M1hjVVNOdFZ5?=
 =?utf-8?B?UW9aRHc1c1hqY0pXa1RYY0g5Rk1lYzBpc3E4Z1hxdWVTWGViem5nL3ByZFVZ?=
 =?utf-8?B?aUdLUndObmpueGt6L2M5TCtDMCt5T0NRQ29TVVE4YWpabllYTjQzWGVqWHdG?=
 =?utf-8?B?eUJjVXF5ZlY3b3pKVmIyellJZ1RUeGg1d0ZidUx2U0RzRCtxN1VhQ2drSWlp?=
 =?utf-8?B?V1U4WUdhbkZueHd1OGlESWtna2ltTWhWWlFaNEdwalRjODY2S3piL0E0Zmdp?=
 =?utf-8?B?N0J3RnlsWXZ4TkF0MDVYdHVBUnFFOGdNZlJFNGo0eU5pZ2p0ZmxVVndSQmZk?=
 =?utf-8?B?R2RKWXg3cHpDOUd1V0d5RlFhenJ4cURmZnJEVFh6TkZRSDZWWFpsYUVHT3lT?=
 =?utf-8?B?a0JkSWRsVHM0YWVkVk81UXpEWXowZnZ4dTc1Y2VQcTFyczhSKzdIK0VjdkJ4?=
 =?utf-8?B?THNkM0hLSkxpd0UyTmx1dEJNQ1IyMTVvYnZROFNaaTJ6YVZ2ZnVSTk92Y1g1?=
 =?utf-8?B?Z1Y3Myt6OGJTRTVFNCtXL1ZzbXdDNkgvWGRQbnBTQmlPeXpaWjV2UlRSaVVr?=
 =?utf-8?B?Ykc0ZHVFWFFNZ2l0cUx6b0MvRnNTVUtYSm44WG80L1lQYjMreHFQQlZPQUUr?=
 =?utf-8?B?ekVDWk5lTHNnVlJHS3oxTjRsR0xvMlljWmJSWEJaRWo3dElBdWJnRVp4N2hw?=
 =?utf-8?Q?89IXPli3+IcjguFuCWivT/IucoGaRhseBRmY/rN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0dFb1R2TkJjaGFKZGYrOXNpRzZvU1dQU0RhVXdPbHFXc04reDhSRzdFcGox?=
 =?utf-8?B?L1NWNGFEWmwvTFZkWUk4QUFBVW15bmJjZ2YzUHE0UmJDV3MyMWh5d3YvaVVt?=
 =?utf-8?B?Ni8vV1Y1bEdzV01rYmNuRVlGaHNoemttTDF2bzNxYVFzaVlFWGlGMVRFRXJw?=
 =?utf-8?B?VDBtZlJ4NHpGeGxORUZRMXlnZ0xxSDIxcnFHbHI4MXN2bjZnVW9qRVFSc1pG?=
 =?utf-8?B?WnRkR0ZpeDc2RCtwd0YvQlAxSk5hMFpOdVF6YWVTZnYzakN0MWRoWjZYTWJy?=
 =?utf-8?B?emkxL3ovdXNMamYxMmhrdUJRalBJK24yTnYzdmIrZVRXdlU3TVNYQkdkbUQy?=
 =?utf-8?B?UEkxMHd0Q0M3RU5ERklzUkd3OFVVVklxRXgzNmNtSFhaREdmNkRPTFNlODFB?=
 =?utf-8?B?VUV1U0hZSW9rNDJQeDFDbnFSSkFJZkJaQ1YySmhndEgwamFrYlYvRHNVbitj?=
 =?utf-8?B?aGo3cUVRM2tpa3FsaHhrbWUyM2ZBZnJBNTlsVk5ZYVE3WUNYYkhiRXRBc2g1?=
 =?utf-8?B?YmQzUm9CNktGRitGajY4Z3l6ZnhNMXZPMWdscVFPemgwKzZxN2JySWhjOUlN?=
 =?utf-8?B?SnJnT1ZkN0NFamtkYWRVUzJCdnJrQytPa3pFY0o2KzR5dGtmWUZnbmhqM0Zi?=
 =?utf-8?B?ckxOd0Nuby9jV0gwVDhyMHN3cSt6c1QrM29Pb2VRVlJuQW5KVFozb0dxakxa?=
 =?utf-8?B?UHBXQlN5WDBjWXNBeStHQUlSWlJKWTlPN3M1YVBwSXlwL09nTlB6Vkw1ck9Z?=
 =?utf-8?B?SzZlT2hWRzJEQi9CVi9DYnBSWnhqMyswWVpkY2ovWnhJbEFRODhmMWNnS2tI?=
 =?utf-8?B?cUpReEN4Qy9VZjZHWEpya0tOSGl3bGZkMFl3bnhBT3RRaXRYaklIanFXMmJ5?=
 =?utf-8?B?SkpkY0kyc0VDeVJrbW9ON3REeGMva2JqSU04Zk5SVTJLK0ZEOE1HUUxWNThY?=
 =?utf-8?B?amovUEJnbGtPemhQUHdrRHRXMFI1UUYzWmYxdHNIREx1T0JSOFo3YVZodG5z?=
 =?utf-8?B?ZTVrRWM1QjlMN0F1a0RQdlZNc2UrSjk2UlliYnEzN2libitKdkF5ajhPUCt4?=
 =?utf-8?B?QlozZ1JzSXN2T2lwOEszWnZFNWk2M1oydC9qbDRrbG9wb3hKQzFmYlc3dVl1?=
 =?utf-8?B?OXA4YU9PVnpxMGxMeDF2MmNRc0JFZjlzQ090VXBBbGlIZ1h5Y2l1UGdFYUcy?=
 =?utf-8?B?MnVOcHZPeGpwcjhwNFpla3hZRzljSXhiajFPR2Jub3pwcytFOVJDMzcrOTZX?=
 =?utf-8?B?UDdVaGhXSGZ5bWZUOGJQRi8zYS91a2hIQmZJbTY3bTFoQWEydjl3TGdyT1J3?=
 =?utf-8?B?MU04a0I3eUpyY1RlbjZXZExMQlpGV1ZWK2RVbWg5R3VTc2hRN1JJbXpFYVNM?=
 =?utf-8?B?Ukg0dStISDlFREdZbEdBVHljaEJka2hwQjJnemJLTFJZMU5IWVcxQUxlRDZ3?=
 =?utf-8?B?Njdud1VaM05jTXA2RFBrR2RRNEtMQTc0MU5sempOcU5FcXFYRmJvWitqSy9P?=
 =?utf-8?B?V21hSnYwNG04b01UOUFoUDR0QVdVb0Vnalh2ODdiRy9lc1Q5UENSTS9oOGhQ?=
 =?utf-8?B?UW5KOVYyaEFNZ0xSRG9rdjYvd1Z1Y0tRenlzTmNkLzlKNHFibEFxQ2pLVXo2?=
 =?utf-8?B?Sk96dG9SdFR4SzZPNlQ3OUROcytVemIyemdZaTRjUEFKSWtybFExS3dZUG96?=
 =?utf-8?B?aTlHQXo0UVF6dHFGZklVNlFTZUV6RDVzNnNEcEtjVkZvMExkTUdyakRiU0JR?=
 =?utf-8?B?ZGNlaUMxWkZiZHVaUWs5QU9nanhnRlZrTXVCWGlvSEtFUjRqM3VINjY2d3Q4?=
 =?utf-8?B?ZGF4VmhkZjV4SXFxdzBBQ3o3MnBGNUdUTXMrTjN0MVE2MnFwbUlhOVgvNGQw?=
 =?utf-8?B?UGFDN2Z0Vk8vTk9OQTk0NHhqWDZ5U1lwb1JCdU5GSW50RVVlOTMrNHpaRTM1?=
 =?utf-8?B?QWZSV2U3WG1uaUZVNTJDbWl2WW5jdTRMRkIwQkdRL0pTSk9pU0ZKU2E4WUdn?=
 =?utf-8?B?WGdEdnNkdktDaXVNWjIrUS80endNMGt4WktXRGhHMzFXOHNhRFdrMDB6NEgx?=
 =?utf-8?B?SldwdzEwckNxRkJuaGxKcDZGT0dhSGl6MU5oTG9ac1h2SHVEVUVKRUF5TkRZ?=
 =?utf-8?Q?vF8o=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52dbbfb1-92ae-41c5-2123-08dd033666af
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 16:23:54.7375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdDEt3YOhZEEg6B5wN/u6btuVZA7ZNYtLY0JbnvQGwgWWzdn2KKsGx+Pf3Tdtwry
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406

Hi Maksim,

On 11/12/24 04:09, Maksim Davydov wrote:
> 
> 
> On 11/8/24 23:56, Moger, Babu wrote:
>> Hi Maxim,
>>
>> Thanks for looking into this. I will fix the bits I mentioned below in
>> upcoming Genoa/Turin model update.
>>
>> I have few comments below.
>>
>> On 11/8/2024 12:15 PM, Maksim Davydov wrote:
>>> Hi!
>>> I compared EPYC-Genoa CPU model with CPUID output from real EPYC Genoa
>>> host. I found some mismatches that confused me. Could you help me to
>>> understand them?
>>>
>>> On 5/4/23 23:53, Babu Moger wrote:
>>>> Adds the support for AMD EPYC Genoa generation processors. The model
>>>> display for the new processor will be EPYC-Genoa.
>>>>
>>>> Adds the following new feature bits on top of the feature bits from
>>>> the previous generation EPYC models.
>>>>
>>>> avx512f         : AVX-512 Foundation instruction
>>>> avx512dq        : AVX-512 Doubleword & Quadword Instruction
>>>> avx512ifma      : AVX-512 Integer Fused Multiply Add instruction
>>>> avx512cd        : AVX-512 Conflict Detection instruction
>>>> avx512bw        : AVX-512 Byte and Word Instructions
>>>> avx512vl        : AVX-512 Vector Length Extension Instructions
>>>> avx512vbmi      : AVX-512 Vector Byte Manipulation Instruction
>>>> avx512_vbmi2    : AVX-512 Additional Vector Byte Manipulation Instruction
>>>> gfni            : AVX-512 Galois Field New Instructions
>>>> avx512_vnni     : AVX-512 Vector Neural Network Instructions
>>>> avx512_bitalg   : AVX-512 Bit Algorithms, add bit algorithms Instructions
>>>> avx512_vpopcntdq: AVX-512 AVX-512 Vector Population Count Doubleword and
>>>>                    Quadword Instructions
>>>> avx512_bf16    : AVX-512 BFLOAT16 instructions
>>>> la57            : 57-bit virtual address support (5-level Page Tables)
>>>> vnmi            : Virtual NMI (VNMI) allows the hypervisor to inject
>>>> the NMI
>>>>                    into the guest without using Event Injection mechanism
>>>>                    meaning not required to track the guest NMI and
>>>> intercepting
>>>>                    the IRET.
>>>> auto-ibrs       : The AMD Zen4 core supports a new feature called
>>>> Automatic IBRS.
>>>>                    It is a "set-and-forget" feature that means that,
>>>> unlike e.g.,
>>>>                    s/w-toggled SPEC_CTRL.IBRS, h/w manages its IBRS
>>>> mitigation
>>>>                    resources automatically across CPL transitions.
>>>>
>>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>>> ---
>>>>   target/i386/cpu.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>   1 file changed, 122 insertions(+)
>>>>
>>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>>> index d50ace84bf..71fe1e02ee 100644
>>>> --- a/target/i386/cpu.c
>>>> +++ b/target/i386/cpu.c
>>>> @@ -1973,6 +1973,56 @@ static const CPUCaches epyc_milan_v2_cache_info
>>>> = {
>>>>       },
>>>>   };
>>>> +static const CPUCaches epyc_genoa_cache_info = {
>>>> +    .l1d_cache = &(CPUCacheInfo) {
>>>> +        .type = DATA_CACHE,
>>>> +        .level = 1,
>>>> +        .size = 32 * KiB,
>>>> +        .line_size = 64,
>>>> +        .associativity = 8,
>>>> +        .partitions = 1,
>>>> +        .sets = 64,
>>>> +        .lines_per_tag = 1,
>>>> +        .self_init = 1,
>>>> +        .no_invd_sharing = true,
>>>> +    },
>>>> +    .l1i_cache = &(CPUCacheInfo) {
>>>> +        .type = INSTRUCTION_CACHE,
>>>> +        .level = 1,
>>>> +        .size = 32 * KiB,
>>>> +        .line_size = 64,
>>>> +        .associativity = 8,
>>>> +        .partitions = 1,
>>>> +        .sets = 64,
>>>> +        .lines_per_tag = 1,
>>>> +        .self_init = 1,
>>>> +        .no_invd_sharing = true,
>>>> +    },
>>>> +    .l2_cache = &(CPUCacheInfo) {
>>>> +        .type = UNIFIED_CACHE,
>>>> +        .level = 2,
>>>> +        .size = 1 * MiB,
>>>> +        .line_size = 64,
>>>> +        .associativity = 8,
>>>> +        .partitions = 1,
>>>> +        .sets = 2048,
>>>> +        .lines_per_tag = 1,
>>>
>>> 1. Why L2 cache is not shown as inclusive and self-initializing?
>>>
>>> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
>>> * cache inclusive. Read-only. Reset: Fixed,1.
>>> * cache is self-initializing. Read-only. Reset: Fixed,1.
>>
>> Yes. That is correct. This needs to be fixed. I Will fix it.
>>>
>>>> +    },
>>>> +    .l3_cache = &(CPUCacheInfo) {
>>>> +        .type = UNIFIED_CACHE,
>>>> +        .level = 3,
>>>> +        .size = 32 * MiB,
>>>> +        .line_size = 64,
>>>> +        .associativity = 16,
>>>> +        .partitions = 1,
>>>> +        .sets = 32768,
>>>> +        .lines_per_tag = 1,
>>>> +        .self_init = true,
>>>> +        .inclusive = true,
>>>> +        .complex_indexing = false,
>>>
>>> 2. Why L3 cache is shown as inclusive? Why is it not shown in L3 that
>>> the WBINVD/INVD instruction is not guaranteed to invalidate all lower
>>> level caches (0 bit)?
>>>
>>> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
>>> * cache inclusive. Read-only. Reset: Fixed,0.
>>> * Write-Back Invalidate/Invalidate. Read-only. Reset: Fixed,1.
>>>
>>
>> Yes. Both of this needs to be fixed. I Will fix it.
>>
>>>
>>>
>>> 3. Why the default stub is used for TLB, but not real values as for
>>> other caches?
>>
>> Can you please eloberate on this?
>>
> 
> For L1i, L1d, L2 and L3 cache we provide the correct information about
> characteristics. In contrast, for L1i TLB, L1d TLB, L2i TLB and L2d TLB
> (0x80000005 and 0x80000006) we use the same value for all CPU models.
> Sometimes it seems strange. For instance, the current default value in
> QEMU for L2 TLB associativity for 4 KB pages is 4. But 4 is a reserved
> value for Genoa (as PPR for Family 19h Model 11h says)

Yes. I see that. We may need to address this sometime in the future.

> 
>>>
>>>> +    },
>>>> +};
>>>> +
>>>>   /* The following VMX features are not supported by KVM and are left
>>>> out in the
>>>>    * CPU definitions:
>>>>    *
>>>> @@ -4472,6 +4522,78 @@ static const X86CPUDefinition
>>>> builtin_x86_defs[] = {
>>>>               { /* end of list */ }
>>>>           }
>>>>       },
>>>> +    {
>>>> +        .name = "EPYC-Genoa",
>>>> +        .level = 0xd,
>>>> +        .vendor = CPUID_VENDOR_AMD,
>>>> +        .family = 25,
>>>> +        .model = 17,
>>>> +        .stepping = 0,
>>>> +        .features[FEAT_1_EDX] =
>>>> +            CPUID_SSE2 | CPUID_SSE | CPUID_FXSR | CPUID_MMX |
>>>> CPUID_CLFLUSH |
>>>> +            CPUID_PSE36 | CPUID_PAT | CPUID_CMOV | CPUID_MCA |
>>>> CPUID_PGE |
>>>> +            CPUID_MTRR | CPUID_SEP | CPUID_APIC | CPUID_CX8 |
>>>> CPUID_MCE |
>>>> +            CPUID_PAE | CPUID_MSR | CPUID_TSC | CPUID_PSE | CPUID_DE |
>>>> +            CPUID_VME | CPUID_FP87,
>>>> +        .features[FEAT_1_ECX] =
>>>> +            CPUID_EXT_RDRAND | CPUID_EXT_F16C | CPUID_EXT_AVX |
>>>> +            CPUID_EXT_XSAVE | CPUID_EXT_AES |  CPUID_EXT_POPCNT |
>>>> +            CPUID_EXT_MOVBE | CPUID_EXT_SSE42 | CPUID_EXT_SSE41 |
>>>> +            CPUID_EXT_PCID | CPUID_EXT_CX16 | CPUID_EXT_FMA |
>>>> +            CPUID_EXT_SSSE3 | CPUID_EXT_MONITOR | CPUID_EXT_PCLMULQDQ |
>>>> +            CPUID_EXT_SSE3,
>>>> +        .features[FEAT_8000_0001_EDX] =
>>>> +            CPUID_EXT2_LM | CPUID_EXT2_RDTSCP | CPUID_EXT2_PDPE1GB |
>>>> +            CPUID_EXT2_FFXSR | CPUID_EXT2_MMXEXT | CPUID_EXT2_NX |
>>>> +            CPUID_EXT2_SYSCALL,
>>>> +        .features[FEAT_8000_0001_ECX] =
>>>> +            CPUID_EXT3_OSVW | CPUID_EXT3_3DNOWPREFETCH |
>>>> +            CPUID_EXT3_MISALIGNSSE | CPUID_EXT3_SSE4A | CPUID_EXT3_ABM |
>>>> +            CPUID_EXT3_CR8LEG | CPUID_EXT3_SVM | CPUID_EXT3_LAHF_LM |
>>>> +            CPUID_EXT3_TOPOEXT | CPUID_EXT3_PERFCORE,
>>>> +        .features[FEAT_8000_0008_EBX] =
>>>> +            CPUID_8000_0008_EBX_CLZERO |
>>>> CPUID_8000_0008_EBX_XSAVEERPTR |
>>>> +            CPUID_8000_0008_EBX_WBNOINVD | CPUID_8000_0008_EBX_IBPB |
>>>> +            CPUID_8000_0008_EBX_IBRS | CPUID_8000_0008_EBX_STIBP |
>>>> +            CPUID_8000_0008_EBX_STIBP_ALWAYS_ON |
>>>> +            CPUID_8000_0008_EBX_AMD_SSBD | CPUID_8000_0008_EBX_AMD_PSFD,
>>>
>>> 4. Why 0x80000008_EBX features related to speculation vulnerabilities
>>> (BTC_NO, IBPB_RET, IbrsPreferred, INT_WBINVD) are not set?
>>
>> KVM does not expose these bits to the guests yet.
>>
>> I normally check using the ioctl KVM_GET_SUPPORTED_CPUID.
>>
> 
> I'm not sure, but at least the first two of these features seem to be
> helpful to choose the appropriate mitigation. Do you think that we should
> add them to KVM?

Yes. Sure.

> 
>>
>>>
>>>> +        .features[FEAT_8000_0021_EAX] =
>>>> +            CPUID_8000_0021_EAX_No_NESTED_DATA_BP |
>>>> +            CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
>>>> +            CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
>>>> +            CPUID_8000_0021_EAX_AUTO_IBRS,
>>>
>>> 5. Why some 0x80000021_EAX features are not set?
>>> (FsGsKernelGsBaseNonSerializing, FSRC and FSRS)
>>
>> KVM does not expose FSRC and FSRS bits to the guests yet.
> 
> But KVM exposes the same features (0x7 ecx=1, bits 10 and 11) for Intel
> CPU models. Do we have to add these bits for AMD to KVM?

Yes. Sure.
> 
>>
>> The KVM reports the bit FsGsKernelGsBaseNonSerializing. I will check if
>> we can add this bit to the Genoa and Turin.

Will add this in my qemu series.

>>
>>>
>>>> +        .features[FEAT_7_0_EBX] =
>>>> +            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_BMI1 |
>>>> CPUID_7_0_EBX_AVX2 |
>>>> +            CPUID_7_0_EBX_SMEP | CPUID_7_0_EBX_BMI2 |
>>>> CPUID_7_0_EBX_ERMS |
>>>> +            CPUID_7_0_EBX_INVPCID | CPUID_7_0_EBX_AVX512F |
>>>> +            CPUID_7_0_EBX_AVX512DQ | CPUID_7_0_EBX_RDSEED |
>>>> CPUID_7_0_EBX_ADX |
>>>> +            CPUID_7_0_EBX_SMAP | CPUID_7_0_EBX_AVX512IFMA |
>>>> +            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
>>>> +            CPUID_7_0_EBX_AVX512CD | CPUID_7_0_EBX_SHA_NI |
>>>> +            CPUID_7_0_EBX_AVX512BW | CPUID_7_0_EBX_AVX512VL,
>>>> +        .features[FEAT_7_0_ECX] =
>>>> +            CPUID_7_0_ECX_AVX512_VBMI | CPUID_7_0_ECX_UMIP |
>>>> CPUID_7_0_ECX_PKU |
>>>> +            CPUID_7_0_ECX_AVX512_VBMI2 | CPUID_7_0_ECX_GFNI |
>>>> +            CPUID_7_0_ECX_VAES | CPUID_7_0_ECX_VPCLMULQDQ |
>>>> +            CPUID_7_0_ECX_AVX512VNNI | CPUID_7_0_ECX_AVX512BITALG |
>>>> +            CPUID_7_0_ECX_AVX512_VPOPCNTDQ | CPUID_7_0_ECX_LA57 |
>>>> +            CPUID_7_0_ECX_RDPID,
>>>> +        .features[FEAT_7_0_EDX] =
>>>> +            CPUID_7_0_EDX_FSRM,
>>>
>>> 6. Why L1D_FLUSH is not set? Because only vulnerable MMIO stale data
>>> processors have to use it, am I right?
>>
>> KVM does not expose L1D_FLUSH to the guests. Not sure why. Need to
>> investigate.
>>
> 
> It seems that KVM has exposed L1D_FLUSH since da3db168fb67

Sure. Will update my patch series.

> 
>>
>>>
>>>> +        .features[FEAT_7_1_EAX] =
>>>> +            CPUID_7_1_EAX_AVX512_BF16,
>>>> +        .features[FEAT_XSAVE] =
>>>> +            CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC |
>>>> +            CPUID_XSAVE_XGETBV1 | CPUID_XSAVE_XSAVES,
>>>> +        .features[FEAT_6_EAX] =
>>>> +            CPUID_6_EAX_ARAT,
>>>> +        .features[FEAT_SVM] =
>>>> +            CPUID_SVM_NPT | CPUID_SVM_NRIPSAVE | CPUID_SVM_VNMI |
>>>> +            CPUID_SVM_SVME_ADDR_CHK,
>>>> +        .xlevel = 0x80000022,
>>>> +        .model_id = "AMD EPYC-Genoa Processor",
>>>> +        .cache_info = &epyc_genoa_cache_info,
>>>> +    },
>>>>   };
>>>>   /*
>>>
>>
> 
> So, If you don't mind, I will send a patch to KVM within a few hours. I
> will add bits for FSRC, FSRS and some bits from 0x80000008_EBX
> 

FSRC and FSRS are not used anywhere in the kernel. It is mostly FYI kind
of information. It does not hurt to add.  Please go ahead.

-- 
Thanks
Babu Moger

