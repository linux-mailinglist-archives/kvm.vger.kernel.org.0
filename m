Return-Path: <kvm+bounces-31975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C37B9CFA3A
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 23:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34031B32E07
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 22:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F3C1FB8BC;
	Fri, 15 Nov 2024 21:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3eFBa5DD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FBA1E3DC4;
	Fri, 15 Nov 2024 21:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706153; cv=fail; b=JTFMcFf4ZsnnCL8GjckA1Z0ZjIPY12raYX2LqsMYkcHeiE/DyinV8Zj54nPvs4Pe+LtcmbBpUqrSiMCii13/IFxxUfYEqdvMrJfgl6SSdEPlMpXVqgHhi0OPPXj0VI4REWMoVsGzSSAzlnsRFSoMbwH0LPEkeHX8sNspPojqi7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706153; c=relaxed/simple;
	bh=/ucfaKqxoJ/gOUdJUy3TGXjzF7B8vdTTD1CbVtlF4vw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nkk53t+x1C39yCrakPAuCCfoDxryu+h/NkctJsBBDGg2Ee0+b96Ar/3n4evSH/kEcd7nmcnx1Hrb5+SB4DbRPwVY+VA0eFiWbNc1jvmINQNV/q6Eqk9rB3d79gtGgT2TWTcLGQvwh3FHNFGUV+RxYhnm8KjyZjKAO3Ir8v7buv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3eFBa5DD; arc=fail smtp.client-ip=40.107.237.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XFz1eTCtEvln3D+MabKVTNaSIiJ1ntwypcxJ+LsNcIazZA+rYe8sAisRiF7vuXjlcIi1y9pEV1gIDSCc4ohRBnB5DfudZKiopXWn+KC2fMITfZRIpLe+oOs0D8Njh577brhyhJKKDzoIotfqCKd9dCxmDeWPiR745VjfK62bwELGq4mF2Js1EBpF4jwAaowKNOcObPymmdlslg0gGN2E6ptrDKzx3ZF55Dcdd6lWd9UF1xAWjkJee0oxGvlusQQ1qD6+fSuGDzJ6S64Nrbw1oQC0Uv+Fk4zdIev0Kt6YS8OixMaukz40GK30AEy6sOlGzi/nFJvqRrGX6VCl953bjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SPjju1iKPKFsnTuW1mkQDmaXJUQEP5AvcxgZiueF/A=;
 b=lHv53danciVQG6goIB0EfMsTLL6GtLISdfqXaJ0ViFCza22bFR3BJlAKM6u+37alL6Dd+9uNESggiAlDmo2WOgOaq5kxOV3/DMHP46RsoXRgQeKp5MHMUHpqHyNiCdqgHzvpx9+V3y6KAV7F3fttny5bFOMAmo3hvYQ8+r1xUk6Ck+ID8RfRrV+Sr8Y5S7qcjCKfYzRF1IN4C9EJ0nO1F+c6+wbnoe+NTRKt4P0fT5gxcrvJLuiLATM/yXa7HglHPgKRMvNcjSbJLstnSQeG8S06/u5OKyrlQpQT88BMSJ0G6GEKqbshI37RSNSjH/nZ8Dh8jv6OEb6Gxgb2u28/0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SPjju1iKPKFsnTuW1mkQDmaXJUQEP5AvcxgZiueF/A=;
 b=3eFBa5DDjH7Z2b0dL0iQ7EzMENXZBVqyfkMMBTUVQ0AfNQZsZgpaAP50U5fCmsjmqDDSA41woLiKj51uPT/KHrOAUYyADez8Ux7bQ4a2q7/6CyqIRuS2J4FLp93B9y17AYYUCPsT33znP4FJqr2Z5BpHxZhMTTcMDqTpQ+wi3oI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by SN7PR12MB6981.namprd12.prod.outlook.com (2603:10b6:806:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 21:29:07 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 21:29:07 +0000
Message-ID: <3d182f98-d717-ff12-9640-f691a3840fbe@amd.com>
Date: Fri, 15 Nov 2024 15:29:03 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH 2/2] x86: KVM: Advertise AMD's speculation control
 features
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>, babu.moger@amd.com
Cc: Maksim Davydov <davydov-max@yandex-team.ru>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 sandipan.das@amd.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
 <20241113133042.702340-3-davydov-max@yandex-team.ru>
 <2813ba0d-7e5d-03d4-26df-d5283b9c0549@amd.com>
 <CALMp9eT2RMe9ej_UbbeoKb+1hqWypxWswqg2aGodZHC0Vgoc=Q@mail.gmail.com>
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <CALMp9eT2RMe9ej_UbbeoKb+1hqWypxWswqg2aGodZHC0Vgoc=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0196.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::23) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|SN7PR12MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: 60d4fadf-569b-4ab7-6eb0-08dd05bc8912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3M1WEVRMHQ1Mnd2WWdSUit3TUZOYUV4TVpUOXZ0anZGeEZtMlZadUsxU01u?=
 =?utf-8?B?K2xWVXBUamVZUU5qY0hZUnhQd0lwRWNPY2RGcU45ZVBSOWo1R0ViWFlRUk83?=
 =?utf-8?B?Z1hjNDRGMkpLejY5TnFraUdFUSs3UHlPS1VkbmNKVlpyVCtyVGNhTlIycWdZ?=
 =?utf-8?B?ZlVMUmwyalRMb0IwbHJNRmo1cy8rVmMvdHFtbFo1TEFHY1MvQ04vTnJIR1hL?=
 =?utf-8?B?WjVMVTRJK3JmQ0tKQlpXckNXMnB4MmtnT2lmRHY1aHRZTjJJd25FUVZKb0Qy?=
 =?utf-8?B?SkdPRVBzV05ra2wvU3dGV0R4R1FQd21lSUJ4MWw0NFBBanJMMFR3L3FWdlQ2?=
 =?utf-8?B?V0krbmlMQ2QyTWNzQjJaVGlBcml2VHFUQUtEQUhoT0FhNVF3NnN5cFk0bGJp?=
 =?utf-8?B?R3Z2OExFdjZ2ZjQyeElBYVpqMERML2R0Z3hGUEZ3eEdjMlJGdFplQytscU1Q?=
 =?utf-8?B?dzdRdXVUeE50Tm1VVlFYV1E4OUI4azRzL08vVlJGNC9Cd0RNRGhqcWhlbkdH?=
 =?utf-8?B?Rk9rS0t6VmJUOTZ1TUZwZHQ4UUhNWG9CSnBCcU80d21WaHQyblF4NWdhZmhQ?=
 =?utf-8?B?eFBNVTlpTzhNNitOWFNaZXFTZGZLbVhWaXNvSTNqS0UzNFdvUlE2YnU4Y1Ew?=
 =?utf-8?B?eXhNMW1YMHpieksxaEJVK2l4ZlZteE1kY0xaNVBORDM2VkFZeFhSSjFtMnZZ?=
 =?utf-8?B?bkZtbzlQSWMxdlAwbWJFVit3SnNvOEVra1doUVhic1ppSnU0NzVZMmNkSTc5?=
 =?utf-8?B?b25qVEttN3dpM01JYmp1YUJDTGxMUDdGMDh5dEY4aGR5S3I2S3hsRlhlUzBK?=
 =?utf-8?B?V0ZaOTJ3Q0xhU1JVL2JWTVpqNkYzcTFPUUp0UDNoUHR4OXJaS0JlY0llR3RU?=
 =?utf-8?B?bzNiY3BaYU1wcFI5aTZPTHdqRGYxTFVZRVV3QmdMY3BGTy9waWxZcW45bUw4?=
 =?utf-8?B?Z0E1VEUwUS9CUDBPVVo0U1ZncHVZdWJlcW5JRDVsZW4xdDlBMkZaNkMxd1Bh?=
 =?utf-8?B?RlFISHloRGZGRkc5bld1OGEzZko4MFFSQ01Bd0xMUFM4UERVeS92ZlpqY3Bw?=
 =?utf-8?B?MlB3T3ZUcUlVb0RFeHNNOWdGdzZqYVc5YlQ0Z2hCWjZ1UlZrMS85QVVpUE1G?=
 =?utf-8?B?VzBoY1BWZ1BsTW1VQWphck4zMFIxU2t3SkRKVE9QeG50c3A3UzY2alY5UE1h?=
 =?utf-8?B?a1hMWmkrRFZsNUIrMWtPdE56b0hhNTBsVTJZdjFNRHdTTytnNE9XR21jYlB5?=
 =?utf-8?B?STdOVTR2ZkRoaVBvY1g0NHppcFhzeFFpOUFzUGtraDluNGlVTHdDK1hWNm1a?=
 =?utf-8?B?YnBzUnJyaDZoZkZvU0ljb2gzVFlGUldIL3BURHpLSlhCY3VCOXFqbS9XZGRL?=
 =?utf-8?B?YkVES3RjYmNkdFhZL0VTOXc4bEhlZmZ5WWFLaVA5VWhlakh2bmRZYmZqWFhx?=
 =?utf-8?B?WkpkWU51ZVVWMGplY0E3YVpQdzdNWERueWVHeTVGMGFPUHVxRGxSRHZjSERt?=
 =?utf-8?B?ZlJJS2twU2N0Z0pWVjYvTGRTN1pnWllIL291Y3ZqNURCOWVtZEdSR2xZOTJv?=
 =?utf-8?B?dmRmdjFPUGVhR1dKWnpCNmt0dHRtUHRwUXpOVmlNSjhta0E5NDNOTC9QcnpN?=
 =?utf-8?B?RTc2OGhQNmYzc2NscUZwR2Q5WXhadzdMSUhKWWYxSmF5UFR4NVZWaVpBK2Jp?=
 =?utf-8?B?VVUxaWZWaEJpUlpzeUNyOXRnZHJFOFd4VUJvdzY5UmxmVSt6aHJHL29sblFQ?=
 =?utf-8?Q?o+5+BJudtBiSMHpgNKwZBomsgVwVz47XEHZNA7k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFZjYVZIZFkvMS9BS1VXUUVkMi9URDNsYkVZOHM2OFhGQkNvaUNDRHllTjFx?=
 =?utf-8?B?by96Z0RtcFpUOUhjS1JGYURzM3NEOTh3MnlWcU0xM2FCME41c0lhWFBQdGtW?=
 =?utf-8?B?akhneWlKK0R3RllnKzJLeUQraC9lc1hNMEsrSUo4NGk4MVUwQW9KR2t3YTNF?=
 =?utf-8?B?UHpMWEF2KzJDQ3IwSGtacHUxVmZZd3I3QWlkOEtVVEFLMWoxS1QydlNkNFVk?=
 =?utf-8?B?cUdFVDZKaTc0b0YzeUc2c0hqUkhHZGtOc1JRM2YvMk5MWUQrKy9DNnBFS0ts?=
 =?utf-8?B?TWJxeGN2Y295Ly9pRlVHaGRSSG01MCtJVjIycXBKOEthWENRWkxqaUJJbUV6?=
 =?utf-8?B?aWVmcHFYeDRGRDJjTkVMamVha1EzajR1NFBKY3F4VFluZjdMVGdZTzhqR1pK?=
 =?utf-8?B?L3UvRXpnZEswc3U4cC8vQTR3cXVaM0p3eHNUTHUyMzEvMVVFbWpJWXR1YWNO?=
 =?utf-8?B?TWxueG54a2cvRmllSVlIOTdaaDlpLytFWTJwRHNKajkvc0pONUVJR09LNHlj?=
 =?utf-8?B?a05QMFk0YnB6SE50cFJwL2tNMlRIL2R2WkFubENQT0h0bGtwQWpOZk5TMXJu?=
 =?utf-8?B?WVhLSVc0M2g2cXgzQlB2QUxNcDgxZWdsQ0JVVXFkQVhGSzROYlRFazE5YXdH?=
 =?utf-8?B?eFpXbnUzR1BCcjA0RlBWOEZveWZyK2o3ZTlkOHR6d2pRYmJpTVZ5Z0E2YlNG?=
 =?utf-8?B?Q2ttZXJ5cDlQVWZpRTNCTXg5OUxFZnBKaHI1YzI1Z0ZhWUE0anNCYVNsK3Ev?=
 =?utf-8?B?dVZWK2JhQnBzS0hNUXc2MVgvWGdORjgzM0NqY3MweFc2WVUzbE9FZC9XTUh5?=
 =?utf-8?B?elBoZlNaNnhVeGJ3OE9jWDdvWkFCaUl1d3hmTGtFYjY2dzB3TEdabnE3ajB2?=
 =?utf-8?B?VHBnb2pKL3AyUlZBZzBIQmt6Y0lZUlBFMW5DY1hVZURkSEx0YzhwRXVHVlcw?=
 =?utf-8?B?WjF3dTFsOEd0OTA0TDhKVnRZYW9aMFV5WE8vbmlIMXhpT1oyemxEK2QzTmVS?=
 =?utf-8?B?OUUzNFN2WGZ2SER0czBvNTd3WUw0blo4cEkxQ1RJSGVyNGZFczV3UW5hNkxG?=
 =?utf-8?B?dGdWd3BBMWFJd3hGRlB1RDdQMXpUUHl5MHk4cmJHZnRRWWwxZ2xMT3lCaUVC?=
 =?utf-8?B?UnZmd1FYQ3I0bTY4RXB3T0ZLU1IwSi95dExGSy9qVW1WWlFPMzdCM1BDZGQ0?=
 =?utf-8?B?Y3VuUTk1NDBFWDB4SWNMWnlSdi9uSkMxT2FNaGxoOGgxNGg0RTJITmhucDdE?=
 =?utf-8?B?M1ZFL0t4UDlRSC9wTVVwTElCVjZpZkR2QUFydXNzaCt4YUExMmRaemFKMDRX?=
 =?utf-8?B?ckwzMHVIM1dVYmFHWTRlemtDQ0Y4b0gxTW9vUkxoTzl5cHZaSmJ1WXJSRnVG?=
 =?utf-8?B?UHBLVEZPMStGbVJrZXJ5S2dYY29HVEtXbVY4KytocUcvQlA5K0JrZW5kaytO?=
 =?utf-8?B?ZG9uUzFDUTg1RnV1WUZkVTlFZmlmR2RnTlQrSzZnVDRLWE1JMmhXUnFnRkEz?=
 =?utf-8?B?N0FDalE4NFV6VlZRdGY1dVdNbjRMaU9oSTdGd3NzWUdrZ1BpTW1QSzk0cnpz?=
 =?utf-8?B?WENyZnpRbTBLVmNQR0ZDNE1JL3RKdzE0UHoxOXVIU1FvUUpuNmJ0cWEwMnZG?=
 =?utf-8?B?TDVrWEdqZHZBaE5zZUVkdFJxOHJHdHpkM2RobGJZZlI4VHN3bFVnSlZQaTN0?=
 =?utf-8?B?TUVCN3preVIwYkxpaGNONWZwRE5QMzQ2ZzR1K1pTb3JIZFR2eGEwSlNIN3VJ?=
 =?utf-8?B?UmRCN1pxNHJYYmpTenhsOWdaY3pKZGdsaDN0dDEyWXpUOUIyT2k5a2JBTUVM?=
 =?utf-8?B?SUZyTngrOGdnQTJVMmdNTEVFOWYraExJaEp3Vm9wVlEwcVRJT2kzL0hmSDNq?=
 =?utf-8?B?VUtFNWlId20xTmRmU0hndlB4c2dXTXY5ZDJiRVVEdE03TEM2YnduNXRFa0sw?=
 =?utf-8?B?OVk4aWdXWWUzWWlkTk56alNCUCtySnFCdzhwYVdRRlNIM0ZwenZwUDhMeEF5?=
 =?utf-8?B?b0pSTnNWNG01c0MrZGlXWVJkZmZXdFlPeGcyTFhUbXpZb3N2TmE4WUVqNzZ2?=
 =?utf-8?B?bENjTzdhQ3F0WGtVZFhKMGxaOExXVDlMYndqVnE0SEV4eUQ4MWpEMWJQbDhG?=
 =?utf-8?Q?49ro=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d4fadf-569b-4ab7-6eb0-08dd05bc8912
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 21:29:06.9699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vtdFUQ1BuQcQ/7nzzNjGA2kLWKNKuvPjxnK0+QFf8NrfGLbtT4CNp8mlG9e/8sY0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6981



On 11/15/2024 2:32 PM, Jim Mattson wrote:
> On Fri, Nov 15, 2024 at 12:13 PM Moger, Babu <bmoger@amd.com> wrote:
>>
>> Hi Maksim,
>>
>>
>> On 11/13/2024 7:30 AM, Maksim Davydov wrote:
>>> It seems helpful to expose to userspace some speculation control features
>>> from 0x80000008_EBX function:
>>> * 16 bit. IBRS always on. Indicates whether processor prefers that
>>>     IBRS is always on. It simplifies speculation managing.
>>
>> Spec say bit 16 is reserved.
>>
>> 16 Reserved
>>
>> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
> 
> The APM volume 3 ( 24594—Rev. 3.36—March 2024) declares this bit as
> "Processor prefers that STIBP be left on." Once a bit has been
> documented like that, you have to assume that software has been
> written that expects those semantics. AMD does not have the option of
> undocumenting the bit.  You can deprecate it, but it now has the
> originally documented semantics until the end of time.

Yes. Agreed.

> 
>>> * 18 bit. IBRS is preferred over software solution. Indicates that
>>>     software mitigations can be replaced with more performant IBRS.
>>> * 19 bit. IBRS provides Same Mode Protection. Indicates that when IBRS
>>>     is set indirect branch predictions are not influenced by any prior
>>>     indirect branches.
>>> * 29 bit. BTC_NO. Indicates that processor isn't affected by branch type
>>>     confusion. It's used during mitigations setting up.
>>> * 30 bit. IBPB clears return address predictor. It's used during
>>>     mitigations setting up.
>>>
>>> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
>>> ---
>>>    arch/x86/include/asm/cpufeatures.h | 3 +++
>>>    arch/x86/kvm/cpuid.c               | 5 +++--
>>>    2 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>>> index 2f8a858325a4..f5491bba75fc 100644
>>> --- a/arch/x86/include/asm/cpufeatures.h
>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>> @@ -340,7 +340,10 @@
>>>    #define X86_FEATURE_AMD_IBPB                (13*32+12) /* Indirect Branch Prediction Barrier */
>>>    #define X86_FEATURE_AMD_IBRS                (13*32+14) /* Indirect Branch Restricted Speculation */
>>>    #define X86_FEATURE_AMD_STIBP               (13*32+15) /* Single Thread Indirect Branch Predictors */
>>> +#define X86_FEATURE_AMD_IBRS_ALWAYS_ON       (13*32+16) /* Indirect Branch Restricted Speculation always-on preferred */
>>
>> You might have to remove this.
> 
> No; it's fine. The bit can never be used for anything else.

That is true.
But, Hardware does not report this bit yet (at least on my system). So, 
I am thinking it may not be required to add at this point.

> 
>>>    #define X86_FEATURE_AMD_STIBP_ALWAYS_ON     (13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
>>> +#define X86_FEATURE_AMD_IBRS_PREFERRED       (13*32+18) /* Indirect Branch Restricted Speculation is preferred over SW solution */
>>> +#define X86_FEATURE_AMD_IBRS_SMP     (13*32+19) /* Indirect Branch Restricted Speculation provides Same Mode Protection */
>>>    #define X86_FEATURE_AMD_PPIN                (13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
>>>    #define X86_FEATURE_AMD_SSBD                (13*32+24) /* Speculative Store Bypass Disable */
>>>    #define X86_FEATURE_VIRT_SSBD               (13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 30ce1bcfc47f..5b2d52913b18 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -754,8 +754,9 @@ void kvm_set_cpu_caps(void)
>>>        kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>>>                F(CLZERO) | F(XSAVEERPTR) |
>>>                F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
>>> -             F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
>>> -             F(AMD_PSFD)
>>> +             F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_IBRS_ALWAYS_ON) |
>>> +             F(AMD_STIBP_ALWAYS_ON) | F(AMD_IBRS_PREFERRED) |
>>> +             F(AMD_IBRS_SMP) | F(AMD_PSFD) | F(BTC_NO) | F(AMD_IBPB_RET)
>>>        );
>>>
>>>        /*
>>
>> --
>> - Babu Moger
>>
> 

-- 
- Babu Moger

