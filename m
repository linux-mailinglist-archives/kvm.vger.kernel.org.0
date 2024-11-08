Return-Path: <kvm+bounces-31327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7513E9C26DD
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 21:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7336A1C22E41
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DCA1E230D;
	Fri,  8 Nov 2024 20:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AllFM2ti"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D79412D1F1
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 20:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731099418; cv=fail; b=t7BJ6wxpduXsAlt/hwHlp7vZWoh1Dw99r3x8EWz4jSsDxedc4/yoFqS2qaaywW09/WkriiilvLOcZWRX6F6gZ5JLeUn9UIGqv1RAFTzgXJ3+O3SF+P0ClvX130ElKgZAi4imFI5EBypSdckhjanLv5zyQWL8Hopqlwmi2oGQHeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731099418; c=relaxed/simple;
	bh=ntcZJjL8gEYYkrZSaaXYtauv94dGaTsvQEV/ejj0+Os=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P9s0cmpg1Lx+br43X8WiGTjvRjbSFXb6dFR5KyeoExbGxbFqjRZnsrqWpCU2mW4J2sNaeD6gml6srEKw5y5jEWYsf3AiawNqYF3a+BgNbeSsiJnhcWfK5YT/qpbVS1OhViLI9tMTyAf9dbS45bP+mWRCI3kOMwwFCssbE0rF6aQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AllFM2ti; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=auo6950NiobsSUOhLlMGRsIC9omd5uLL+3ANBxyQbJqUFO7B8Sn2mH5qpbSAMwGzchyoCzAdp0R1W0i8rbyPORMjmTMx9Hd6eE3Y+LI0iT8mWd8aeiqkQESQsSEQ7jOgwoQHHFwui29qjl96FnM2j6x/b1XWeg94Oes6TZi6qTAKLN4qU8If3sMuJTkPgrtFmGA6rQxuR+cg6pYFsZA2XK74dStXdZ9mGWDUVqDgJddAxeoTJGf3PtXZjwSt2ljfzXEh6aNM6c42tK7ouYrZ6t1ThAhqUv+5fJorSInTCYgrua2vuqZInL5/7k/neOWQBmaxed6o8FpUMoKzoy4rZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcM/DGm7UhcT852rUv3jjXIieJ/lMpi9nI0D3lunTY8=;
 b=k6tNICw26XDF15B3bSqypSPLsS6w+mFD3Fmx1tZoc2oHnuMVEvt3rw5ZRBrw2UzYdLtfGMhEFJ0PxZh4+vWMfhVcbuDQtZYYgk8GsQcyJz7vf/MQjt80uPCOzO4zVw1TnVYLNaXZh8rfJ9SfT38vuMSImP8bYd0XcCAPCIC5Mk6SzJqaM1oC91ZR1z3elBSMsMrdRLgVvRJ47Su5tFRxG/ANccQoXDODwQDZexfbT95ut+vWXRH15Qfw9t7ZedAdePmVfA6x8x7rCXNolpi87bPL8HuVHiRvah+loJP91qti7Ntb2RjyKtxPw1277NjBo1nsfH57mHbsGcQJsQKHUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcM/DGm7UhcT852rUv3jjXIieJ/lMpi9nI0D3lunTY8=;
 b=AllFM2tiFpR9asUvCW1IG/VEwp6mnOVfut3vHFdaGPQ44IcNpet2FjogjdI7etn8HkfykM0i1UmMq3PKJoU2zAqSKEGK4Yu1jl4TMUnE5u9fsxqFL1PIHopfnomgglEgCU4NXeDC93tdNdR6y6I7iC2uEFf3utVNmkhdeLtWwYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MN2PR12MB4424.namprd12.prod.outlook.com (2603:10b6:208:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Fri, 8 Nov
 2024 20:56:51 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 20:56:51 +0000
Message-ID: <4b38c071-ecb0-112b-f4c4-d1d68e5db63d@amd.com>
Date: Fri, 8 Nov 2024 14:56:47 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v4 7/7] target/i386: Add EPYC-Genoa model to support Zen 4
 processor series
Content-Language: en-US
To: Maksim Davydov <davydov-max@yandex-team.ru>,
 Babu Moger <babu.moger@amd.com>
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
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <e8e0bc10-07ea-4678-a319-fc8d6938d9bd@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0063.namprd11.prod.outlook.com
 (2603:10b6:806:d2::8) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|MN2PR12MB4424:EE_
X-MS-Office365-Filtering-Correlation-Id: 09914bb8-c69f-4f58-564b-08dd0037de77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TVU3RXd2UGczYzNNZkJTQzBRTTNiKy9saXJqZnBqdHUxQ2FhL3ZpN0tIK0Rk?=
 =?utf-8?B?WmZLa1NlTmNnalZFek9pNzYxRVR2UlN0dEM0NEN6L2szWDF3YzMyZGdJdjFR?=
 =?utf-8?B?anEzcEZjZE4vTFdqMnUrTVcyaGdFMlRYdjZsbWhGemNIMFJmdlg5clBuV0No?=
 =?utf-8?B?RkhNemJ6c3RhWEo4aVdLMWVTeUNnT0FONU1rekFtbG5TOU10eVJ3YU5Gekk5?=
 =?utf-8?B?K2ZlN1p3d050WmpCaVZZQU9uMHJyd3JyRWp2bEMzTjhmbTdCUmFqRXhsVmpT?=
 =?utf-8?B?MUJVdEh2NWdhckVWdkJJcm1DcVl6bzF2b1BKazhNbVZxYTcvemJOemVCcVcx?=
 =?utf-8?B?aGp5M2pWMHdOSlRoQkR0aGVoekswb21nYzFoSDduYWJhWWp1Y3dSK1JNQlhF?=
 =?utf-8?B?bkd1a1hlSHFHRnI3cXc4NFFMKyswN0djZ3grbHM0VW5GQXB0aFdOclU1VVA3?=
 =?utf-8?B?TlhhSTE0VDUrTnZGMHFmUU4zdFhudjk3dnNoVFZ2dU5kM3pjaSs1SGxhU0JH?=
 =?utf-8?B?SGpOYzlnaWovdGZIdzVoUi9POGR2ZGNIdktQclRWMlJQbjlFWnRCR2w4U1V6?=
 =?utf-8?B?aVBOaHFFRnNOV25vQmk2aldKOFg1cE5PS0d0cXE4eThjTi93TTdNL29hMnJE?=
 =?utf-8?B?dkNNVkVDakthb2tndU8vMW1UZnd0ZCtUby93YUcyaW51Wll4RDRzNTlwOUtV?=
 =?utf-8?B?cVBGeGZCWElueEdUZWJqTHFRWWtNa1A5N1c4dUhkZ0xza1FOdmI0ejhONE5V?=
 =?utf-8?B?RGJmbE5KZDRmcFR5cEx5OUFjMU11U1ZFa3FVbGIrckpEODFkNWR5TDRFZlVK?=
 =?utf-8?B?c1ZCMFJGRlN2QXFodlgzSHpGL092RHY3K0xNanJ4NktMU0NsaDFySGEzZGVm?=
 =?utf-8?B?K1l2NTNvWVYvRzhVUDV4TFA4cGp6U2owRm1BR2twdkNKTnlRN3VIa0puYnpx?=
 =?utf-8?B?c0NvcEZtakJtMWRacmxGdk1JMUV6ZlY0M2NwdmN2Q0NtRDdGejZEMHA1SmdK?=
 =?utf-8?B?ZGRvTWhXZFNVRGpCbExCT3VpdU5qYUE2QVI5SEJ3WkttMWpJNDlzTE14RU55?=
 =?utf-8?B?K25qTytlSjZyWktaUzRCN043QkVLN0hHNjVRNGF5SmNwSmlOUW9wanY5Qmgr?=
 =?utf-8?B?SzJyc3pVa1BQRm42UUM3K1owL3lhRWJQVWFacEFNcStjalptTUtsa2JIVDNl?=
 =?utf-8?B?Ly9QclltMDdyOWJRdVdMQlowMFQ2K2w2bjBKMW9TVzI3UEZnRjYrQjlqYWZj?=
 =?utf-8?B?UTFjQWF6ZGRPRU9qeWM3ek40VVR3V3NRODdXSllqTUQvMzZYamJjaFM2MGFr?=
 =?utf-8?B?dGRJd3VsVHhtUHNNQTlzLzBPZlNOVGg0TmNIOFp5Nmd5cERXcWcrWUhjQ0dW?=
 =?utf-8?B?dVp6OUlMQ3FNVm14S1plM0tHR1dTOWpXUzkxSi9QR25ZbkdGbUFRaFM1SWha?=
 =?utf-8?B?SnBGalZwV1B3djZiRUZBSmtpcktjR3JwNjhDdndrUVdLVGdmcnRIdThhdGk5?=
 =?utf-8?B?NmRpdEV6SzJmbE5FSlJMdjF2bTBOL1RoN3hMb1k1TTczeTdEQlo0bktKek4z?=
 =?utf-8?B?bCszVGZUNFFNK1VWaVBrSm0xVVlXdnArTXEyMERUN013aHRPLytxQXc4UVFJ?=
 =?utf-8?B?NncrOVROZ2dHUk1NOHVON0dKSWplTy9zQTlWdncyRkVXcEx6YlJmN043TnhG?=
 =?utf-8?B?Y01Jb0wrL2poYlZteDN3aDNJUVRnSlIxRkNvcE5MSmF0c1RRc0NMa1pyMEpo?=
 =?utf-8?Q?3+pJntOEbGdNaiRARIwR42jQSpzaCjKfZh/CFHs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UE40eW1UcGNWL1JVWGxGWVViemlnZktHZUdmWWk4MyttMEpEOTFNR2ZJd3Q5?=
 =?utf-8?B?aHdabG5MV2tEK0o1VlJpZjRJbnN6ZWh6TW9BbFl0REU4WVBmY3R6YTR4am1P?=
 =?utf-8?B?ZzYvclpDMWdlSTRzTi9hV1FMcVdIanpvNU1kbXo2dXVOMmc2VTdmb3pZNFNP?=
 =?utf-8?B?b1NJYWo1Z1FpN3hJVVpEMzlQTDNYeGJNUWxjWGJ5cWw0L2l5VWo1V0VnTHpz?=
 =?utf-8?B?WHJSSHRDZjYzMWZ6aWlWMVM2eHkyWFhHUWZVZVNVL0Nud1p6Rzh1QVRaZHRM?=
 =?utf-8?B?aS92VlVTeTlFS3pIS0RUMGZOb05rMVB1VjVGdDQ4Um9scDJ3UURjM3dnMnJD?=
 =?utf-8?B?QXpYUDVmMUxsS0E5bFhuYUd2eXdZUzVsdUpodU5BL2h0eitXTTNpS3Yycisx?=
 =?utf-8?B?b0puSnZSZTlIU213YjZQTnhmU3N4WXI4eTlyVzFmSUxTSGJuckNGT0tQbVJ2?=
 =?utf-8?B?elgvdHlybDRWMnBpa0hacUpGSDYxSjRUaXo5K0FTZm1VbGh1K2h6VGM5cGNG?=
 =?utf-8?B?c1ZQTmd6WWF5c2pGeVlDOC93SjNTdjJPZ0gxNkFUZGdKaGFsaEJ0UXpOV244?=
 =?utf-8?B?N3NLQ1NKd1U0YitQZTJuSmMrVHJaVDFpU0FlQ1piTytHSy9vUzR2Rm92anNy?=
 =?utf-8?B?SGtUTVFsbWpjRlBRVlIrQ2YyUE1Ybm9ZYWtnTUpMQTRuVXpLV2V0cDFLSU5G?=
 =?utf-8?B?N1daZVc1K1pvQUduVE1oZWhkcVFtN29WcUhoa2VJMUpjaUdiZHdXd3JPN3F3?=
 =?utf-8?B?S1hVdnMxZE1ubjJTaktyQmNmUlpzcWxCbzloUUNGU1VUU0JMdnJPZXEvME9a?=
 =?utf-8?B?aEc3NDdiN1RqM3pTK1RUVlYzWW1IcGRINmtWUks3SHhoSkpEVWcyeGZ2T2hl?=
 =?utf-8?B?Uk1KSXdDcm1hV3k0VThzOVpxMGVDdE9aai9qWVBiWC81QnlGdmIzYVdmUmcz?=
 =?utf-8?B?L2I4a0hVWEZ4bjZqdkVlTTNZM2RCWGp5TXZsM0NYVFpsZmFCZ0hYdFpFZHFm?=
 =?utf-8?B?ZTF2UFhDKzVRWFBxUkM0VXBLMXN0VTdGcXFwR3dFbUU0MEh2VUFTT09ZWXRa?=
 =?utf-8?B?UCtpS25lV2RCZGNodWt2RE5jWXh0UW0vVm9HZzU2ZnNFUU9GbnZXOC9HdllX?=
 =?utf-8?B?TGZxa1ZvNVR1dS9Fem96N0N3cEZsdHdKUy92VC92TkM1M0J0TjJ6L3JTVVFh?=
 =?utf-8?B?bXJTOFl3YzNrRU5PdXhiUDlHV1dmYmRwRCs4bVc2NFJDYjFPZmF5S3pNNnVt?=
 =?utf-8?B?UkpNdm9udDh4ZFRTS01wQzBFdFAyYkpHY2hEalNGUlY4WDZxcnB2U09EenNH?=
 =?utf-8?B?dVpiN0p4Z05ibUlXd24rQitoWWpHeTAyUzNrVWUyZ29TMFJKOVhjaWY0aTlj?=
 =?utf-8?B?dGk0V0pMNDBTMFJGaE9DdmZRbHJhWFMzVERIRTRnRjNrZVJZeGF0U09yL0hZ?=
 =?utf-8?B?d1NuOUxrb01jOTVKUkFPV2c3Q2xaMlJrK3dwc25JOUt3SXdDRVRGRlc5d0xH?=
 =?utf-8?B?b0lsdUZYTDRWeEVkRzlXMlFwS3BNUWpTQzVyNDhWRzRBemIyTnBiZXAzWHF6?=
 =?utf-8?B?TjE1c004WDl0UmJUaHFTVnpBMDRTU0JMZHNLbU9NZHc2VmlQTEQ2YllsalA0?=
 =?utf-8?B?L0NqdUtBL3hEaWFIM2V3clpXbW14YVl3WXQ2cVRab3dmNmtRYTR6YkgyaXg3?=
 =?utf-8?B?Rng2clk0M1lqVUNGQnBKU1luZVlQMS9WTlRXSGtZQW1LdnhHQnArWmhtVmhv?=
 =?utf-8?B?UzFSZWtTRnhzKy9NeWxtSnFaSW9wSXJkOFp3SXlSeEtFclFKYXZLRU0rVTJq?=
 =?utf-8?B?QnBEYVVDd0JydVBDd1BHT29rMnBPSk9meURPbjFiZXUwL1BsTCtoc3Fpd0tJ?=
 =?utf-8?B?aVpWcmNYQk5zdUxoK2haT0d1UURyaDg1WkRuamNqdTA0azh4NnJ0VDBtb2di?=
 =?utf-8?B?UzF0Nmt3NzFEQzlnTURldFN0cnpYaDNnd25NL1JoYjBvRVJVYVJWWnhuc0xr?=
 =?utf-8?B?QU1rWFJXYTR3OHE5RlZKZjQ3VCtKUlBQbjJhQzMxL29tdFNLYUIzZXhkYk8z?=
 =?utf-8?B?OGQ0YTZ3bU5SSnVRVy9Hdy9LV2ZiZEdwMkhZcE9MK0lOUVdqdlJmVUw4TjEy?=
 =?utf-8?Q?7kCU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09914bb8-c69f-4f58-564b-08dd0037de77
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 20:56:51.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uY393RPcdKM5HONCECtGV21a98lag6I1Z3TR915r7W9KAtUP6hkdTeR4PyZnmwC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4424

Hi Maxim,

Thanks for looking into this. I will fix the bits I mentioned below in 
upcoming Genoa/Turin model update.

I have few comments below.

On 11/8/2024 12:15 PM, Maksim Davydov wrote:
> Hi!
> I compared EPYC-Genoa CPU model with CPUID output from real EPYC Genoa 
> host. I found some mismatches that confused me. Could you help me to 
> understand them?
> 
> On 5/4/23 23:53, Babu Moger wrote:
>> Adds the support for AMD EPYC Genoa generation processors. The model
>> display for the new processor will be EPYC-Genoa.
>>
>> Adds the following new feature bits on top of the feature bits from
>> the previous generation EPYC models.
>>
>> avx512f         : AVX-512 Foundation instruction
>> avx512dq        : AVX-512 Doubleword & Quadword Instruction
>> avx512ifma      : AVX-512 Integer Fused Multiply Add instruction
>> avx512cd        : AVX-512 Conflict Detection instruction
>> avx512bw        : AVX-512 Byte and Word Instructions
>> avx512vl        : AVX-512 Vector Length Extension Instructions
>> avx512vbmi      : AVX-512 Vector Byte Manipulation Instruction
>> avx512_vbmi2    : AVX-512 Additional Vector Byte Manipulation Instruction
>> gfni            : AVX-512 Galois Field New Instructions
>> avx512_vnni     : AVX-512 Vector Neural Network Instructions
>> avx512_bitalg   : AVX-512 Bit Algorithms, add bit algorithms Instructions
>> avx512_vpopcntdq: AVX-512 AVX-512 Vector Population Count Doubleword and
>>                    Quadword Instructions
>> avx512_bf16    : AVX-512 BFLOAT16 instructions
>> la57            : 57-bit virtual address support (5-level Page Tables)
>> vnmi            : Virtual NMI (VNMI) allows the hypervisor to inject 
>> the NMI
>>                    into the guest without using Event Injection mechanism
>>                    meaning not required to track the guest NMI and 
>> intercepting
>>                    the IRET.
>> auto-ibrs       : The AMD Zen4 core supports a new feature called 
>> Automatic IBRS.
>>                    It is a "set-and-forget" feature that means that, 
>> unlike e.g.,
>>                    s/w-toggled SPEC_CTRL.IBRS, h/w manages its IBRS 
>> mitigation
>>                    resources automatically across CPL transitions.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>   target/i386/cpu.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 122 insertions(+)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index d50ace84bf..71fe1e02ee 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -1973,6 +1973,56 @@ static const CPUCaches epyc_milan_v2_cache_info 
>> = {
>>       },
>>   };
>> +static const CPUCaches epyc_genoa_cache_info = {
>> +    .l1d_cache = &(CPUCacheInfo) {
>> +        .type = DATA_CACHE,
>> +        .level = 1,
>> +        .size = 32 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
>> +        .no_invd_sharing = true,
>> +    },
>> +    .l1i_cache = &(CPUCacheInfo) {
>> +        .type = INSTRUCTION_CACHE,
>> +        .level = 1,
>> +        .size = 32 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
>> +        .no_invd_sharing = true,
>> +    },
>> +    .l2_cache = &(CPUCacheInfo) {
>> +        .type = UNIFIED_CACHE,
>> +        .level = 2,
>> +        .size = 1 * MiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 2048,
>> +        .lines_per_tag = 1,
> 
> 1. Why L2 cache is not shown as inclusive and self-initializing?
> 
> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
> * cache inclusive. Read-only. Reset: Fixed,1.
> * cache is self-initializing. Read-only. Reset: Fixed,1.

Yes. That is correct. This needs to be fixed. I Will fix it.
> 
>> +    },
>> +    .l3_cache = &(CPUCacheInfo) {
>> +        .type = UNIFIED_CACHE,
>> +        .level = 3,
>> +        .size = 32 * MiB,
>> +        .line_size = 64,
>> +        .associativity = 16,
>> +        .partitions = 1,
>> +        .sets = 32768,
>> +        .lines_per_tag = 1,
>> +        .self_init = true,
>> +        .inclusive = true,
>> +        .complex_indexing = false,
> 
> 2. Why L3 cache is shown as inclusive? Why is it not shown in L3 that 
> the WBINVD/INVD instruction is not guaranteed to invalidate all lower 
> level caches (0 bit)?
> 
> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
> * cache inclusive. Read-only. Reset: Fixed,0.
> * Write-Back Invalidate/Invalidate. Read-only. Reset: Fixed,1.
> 

Yes. Both of this needs to be fixed. I Will fix it.

> 
> 
> 3. Why the default stub is used for TLB, but not real values as for 
> other caches?

Can you please eloberate on this?

> 
>> +    },
>> +};
>> +
>>   /* The following VMX features are not supported by KVM and are left 
>> out in the
>>    * CPU definitions:
>>    *
>> @@ -4472,6 +4522,78 @@ static const X86CPUDefinition 
>> builtin_x86_defs[] = {
>>               { /* end of list */ }
>>           }
>>       },
>> +    {
>> +        .name = "EPYC-Genoa",
>> +        .level = 0xd,
>> +        .vendor = CPUID_VENDOR_AMD,
>> +        .family = 25,
>> +        .model = 17,
>> +        .stepping = 0,
>> +        .features[FEAT_1_EDX] =
>> +            CPUID_SSE2 | CPUID_SSE | CPUID_FXSR | CPUID_MMX | 
>> CPUID_CLFLUSH |
>> +            CPUID_PSE36 | CPUID_PAT | CPUID_CMOV | CPUID_MCA | 
>> CPUID_PGE |
>> +            CPUID_MTRR | CPUID_SEP | CPUID_APIC | CPUID_CX8 | 
>> CPUID_MCE |
>> +            CPUID_PAE | CPUID_MSR | CPUID_TSC | CPUID_PSE | CPUID_DE |
>> +            CPUID_VME | CPUID_FP87,
>> +        .features[FEAT_1_ECX] =
>> +            CPUID_EXT_RDRAND | CPUID_EXT_F16C | CPUID_EXT_AVX |
>> +            CPUID_EXT_XSAVE | CPUID_EXT_AES |  CPUID_EXT_POPCNT |
>> +            CPUID_EXT_MOVBE | CPUID_EXT_SSE42 | CPUID_EXT_SSE41 |
>> +            CPUID_EXT_PCID | CPUID_EXT_CX16 | CPUID_EXT_FMA |
>> +            CPUID_EXT_SSSE3 | CPUID_EXT_MONITOR | CPUID_EXT_PCLMULQDQ |
>> +            CPUID_EXT_SSE3,
>> +        .features[FEAT_8000_0001_EDX] =
>> +            CPUID_EXT2_LM | CPUID_EXT2_RDTSCP | CPUID_EXT2_PDPE1GB |
>> +            CPUID_EXT2_FFXSR | CPUID_EXT2_MMXEXT | CPUID_EXT2_NX |
>> +            CPUID_EXT2_SYSCALL,
>> +        .features[FEAT_8000_0001_ECX] =
>> +            CPUID_EXT3_OSVW | CPUID_EXT3_3DNOWPREFETCH |
>> +            CPUID_EXT3_MISALIGNSSE | CPUID_EXT3_SSE4A | CPUID_EXT3_ABM |
>> +            CPUID_EXT3_CR8LEG | CPUID_EXT3_SVM | CPUID_EXT3_LAHF_LM |
>> +            CPUID_EXT3_TOPOEXT | CPUID_EXT3_PERFCORE,
>> +        .features[FEAT_8000_0008_EBX] =
>> +            CPUID_8000_0008_EBX_CLZERO | 
>> CPUID_8000_0008_EBX_XSAVEERPTR |
>> +            CPUID_8000_0008_EBX_WBNOINVD | CPUID_8000_0008_EBX_IBPB |
>> +            CPUID_8000_0008_EBX_IBRS | CPUID_8000_0008_EBX_STIBP |
>> +            CPUID_8000_0008_EBX_STIBP_ALWAYS_ON |
>> +            CPUID_8000_0008_EBX_AMD_SSBD | CPUID_8000_0008_EBX_AMD_PSFD,
> 
> 4. Why 0x80000008_EBX features related to speculation vulnerabilities 
> (BTC_NO, IBPB_RET, IbrsPreferred, INT_WBINVD) are not set?

KVM does not expose these bits to the guests yet.

I normally check using the ioctl KVM_GET_SUPPORTED_CPUID.


> 
>> +        .features[FEAT_8000_0021_EAX] =
>> +            CPUID_8000_0021_EAX_No_NESTED_DATA_BP |
>> +            CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
>> +            CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
>> +            CPUID_8000_0021_EAX_AUTO_IBRS,
> 
> 5. Why some 0x80000021_EAX features are not set? 
> (FsGsKernelGsBaseNonSerializing, FSRC and FSRS)

KVM does not expose FSRC and FSRS bits to the guests yet.

The KVM reports the bit FsGsKernelGsBaseNonSerializing. I will check if 
we can add this bit to the Genoa and Turin.

> 
>> +        .features[FEAT_7_0_EBX] =
>> +            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_BMI1 | 
>> CPUID_7_0_EBX_AVX2 |
>> +            CPUID_7_0_EBX_SMEP | CPUID_7_0_EBX_BMI2 | 
>> CPUID_7_0_EBX_ERMS |
>> +            CPUID_7_0_EBX_INVPCID | CPUID_7_0_EBX_AVX512F |
>> +            CPUID_7_0_EBX_AVX512DQ | CPUID_7_0_EBX_RDSEED | 
>> CPUID_7_0_EBX_ADX |
>> +            CPUID_7_0_EBX_SMAP | CPUID_7_0_EBX_AVX512IFMA |
>> +            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
>> +            CPUID_7_0_EBX_AVX512CD | CPUID_7_0_EBX_SHA_NI |
>> +            CPUID_7_0_EBX_AVX512BW | CPUID_7_0_EBX_AVX512VL,
>> +        .features[FEAT_7_0_ECX] =
>> +            CPUID_7_0_ECX_AVX512_VBMI | CPUID_7_0_ECX_UMIP | 
>> CPUID_7_0_ECX_PKU |
>> +            CPUID_7_0_ECX_AVX512_VBMI2 | CPUID_7_0_ECX_GFNI |
>> +            CPUID_7_0_ECX_VAES | CPUID_7_0_ECX_VPCLMULQDQ |
>> +            CPUID_7_0_ECX_AVX512VNNI | CPUID_7_0_ECX_AVX512BITALG |
>> +            CPUID_7_0_ECX_AVX512_VPOPCNTDQ | CPUID_7_0_ECX_LA57 |
>> +            CPUID_7_0_ECX_RDPID,
>> +        .features[FEAT_7_0_EDX] =
>> +            CPUID_7_0_EDX_FSRM,
> 
> 6. Why L1D_FLUSH is not set? Because only vulnerable MMIO stale data 
> processors have to use it, am I right?

KVM does not expose L1D_FLUSH to the guests. Not sure why. Need to 
investigate.


> 
>> +        .features[FEAT_7_1_EAX] =
>> +            CPUID_7_1_EAX_AVX512_BF16,
>> +        .features[FEAT_XSAVE] =
>> +            CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC |
>> +            CPUID_XSAVE_XGETBV1 | CPUID_XSAVE_XSAVES,
>> +        .features[FEAT_6_EAX] =
>> +            CPUID_6_EAX_ARAT,
>> +        .features[FEAT_SVM] =
>> +            CPUID_SVM_NPT | CPUID_SVM_NRIPSAVE | CPUID_SVM_VNMI |
>> +            CPUID_SVM_SVME_ADDR_CHK,
>> +        .xlevel = 0x80000022,
>> +        .model_id = "AMD EPYC-Genoa Processor",
>> +        .cache_info = &epyc_genoa_cache_info,
>> +    },
>>   };
>>   /*
> 

-- 
- Babu Moger

