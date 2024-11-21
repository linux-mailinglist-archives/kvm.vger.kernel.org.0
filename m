Return-Path: <kvm+bounces-32244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17DBF9D4870
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 09:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1B2D2828AD
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 08:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22DA1C9EAF;
	Thu, 21 Nov 2024 08:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EuJELDj5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD601C7610;
	Thu, 21 Nov 2024 08:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732176235; cv=fail; b=N5OTi0tprww5rW55sRX96W/FbFaqzE9/deKha7vT0xxUKJk3ROceMp1SzvQtCnrjqEOYC7UdjAFNKyZtf9UbyIpV5PEBtJIi3yb/RigGaP0KKtUfYrmOBkfAnDYouTJbJzS3g7C+mmBBneg11pGIalhJ62WnpKpkFfDOlapEYJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732176235; c=relaxed/simple;
	bh=6/wmXkduJl2LXLoFVezEo7DyQK8kDhJ8b6envSkwvjM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jnGrNJYU6SJh5MBUd6Av9a3q/pT4TsOom8DEJUChsAhlbZYqvTUI3pmomCf2oH2E2TupllXt7Ve2jNlHcSyrIdw2RTP4EmGglx6asVtc+PZ3g7D57Xo/lHV5hvRXKXjxcPdsBFfYqxVQaJVA2v88sggJMZgDqVBqZN7/DaikjME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EuJELDj5; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdsq3ArAyh0GQjjyqIKxP4E46ySAPCUdUcpEwdZvTukteCKYr9QCB2hgXdyM2hMnbixzvOknbkcOMy4+13UJEBe81H6CeqXJi+ly7vDWwVP4j6AXLRvpeuDMQTy/OKLZDTl5TFbvYAXAvyRx0oy1kA8QnxAOChAq5av5t8et7hC1sMPtVmxW7XrwPhzh/6mBUouCcZ8MGv57pi3mpRS8qnoqPPwyUCIKqeq8i+cSUz9mOdlRXTBysifSIcGFXMRnWOkMkj45D6QaH64fe+XytY9z6DoXaFG8OcBb4opPYt5gntk5jiieZOjzXPFJhDdLEqvecrloi7IADtX3KWh5dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qaPz+CCRZXI8TmyTSfp2KRqCK2wmdEh5JfEqpA1lX68=;
 b=zNs1si/uzPc98koQRBIy1Y1LGHFDj9kgVcbBFQkN7gSsLZDuCnO+jj1lEbT8jCgJIc7ankrX6gJnqN1jBvpwFFvRMm+Uof4106JjwVInuqBzpKdynkHhh0Zm+HVjdTRhu1FmiTF5ZknzIcqyiiccVZzu2qP7/4NHK2kIaGKb778qecJzQ+c/tcpyGd06w4TXI17Zh4hxEw+ud/Gfjtxw0NkKHKiDxl5HY/9l87AqsD02raLzSiNW8pAbmvRmhdDVYMTyWfKspyPQ0Q6gVlBnLqw/t/lXTLfUHDum051cZDF1HaRtDFC8BqRRyaSaXXydGKJIVL7oWW434gk0QgBifQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaPz+CCRZXI8TmyTSfp2KRqCK2wmdEh5JfEqpA1lX68=;
 b=EuJELDj5RjAuNbeT/EElO7rRMgUdibDjud/gCPe19lm3zrLi/KNK5GIMCIFnAdGzHcwWBjDNCDFZv0D+EJX5uP/Ii5V0fzPhIabJQfSKvE2APkG++tR96wR/8eB2QnVM7WfBSpAZUN/F0ci+68FI3OijOda3TdfjAokBqhlOfHw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DM4PR12MB6184.namprd12.prod.outlook.com (2603:10b6:8:a6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.23; Thu, 21 Nov 2024 08:03:51 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 08:03:51 +0000
Message-ID: <6b2d9a59-cfca-4d6c-915b-ca36826ce96b@amd.com>
Date: Thu, 21 Nov 2024 13:33:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <6f6c1a11-40bd-48dc-8e11-4a1f67eaa43b@amd.com>
 <4f0769a6-ef77-46f8-ba78-38d82995aa26@amd.com>
 <20241121054116.GAZz7H_Cub_ziNiBQN@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241121054116.GAZz7H_Cub_ziNiBQN@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0094.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::18) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DM4PR12MB6184:EE_
X-MS-Office365-Filtering-Correlation-Id: e0738f18-096a-465a-4bcc-08dd0a030942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFpIU1lIMi95UEpwRXkwa0lidWpkVmFZRFlLM1dQVUpma1UveXhpVHNUYWdI?=
 =?utf-8?B?T1dxbWRYblpDK3Jwc3EwYkhGUmd1YWJSZHl5SXlCd2hnZGpJdWRReDdFT2pG?=
 =?utf-8?B?M1VDUUNpZEF6QjFhMTlheTZwL0xKTjRaNzFENG9LbWRMUzJGL1ZnMU02V3k3?=
 =?utf-8?B?a081TVdKTFpNQ3Z1NmtqNVhMemFYYlU1a2FrQm41RER5REtpalFxVnVHYmVo?=
 =?utf-8?B?ZkZUY3hOVkJsMlFjRWplUmhWS252YjhvS2tBTTBrYWN1QXZEeCtPOGZNUUdu?=
 =?utf-8?B?STJJbHNwbDZBU2x4dWtzZ3BuVHQvVWhnME5IeUpPbzBScHZoRkpQT2g1NHpL?=
 =?utf-8?B?eFlJRlhyenZqVnBHUlBVUUptcGNsQmtlSkNvK2lMSlluMGZrUjdnMTdTVVhM?=
 =?utf-8?B?QjFZUUN5WDAxY2MrcXBXb0w5TFErNitUUXFiSzljMEFTc2NIR1BCZlZnTHVr?=
 =?utf-8?B?ZHpVbGx1UjZIekNKUmFYdEdPL2Vic3ZXQ0JGS1pXZHE1L3VZK3dqUXdKSjB0?=
 =?utf-8?B?QTJvNFZZd3Q1Z3ZMczIrS3ozY2tUT2poRHRaOGFRM2NsV2xhdkZ1dGZiY2Jr?=
 =?utf-8?B?d0liWWlXK0w5a29IbGVReDdMaTl0b2hyeEFZZVp2WktrNjF4SFpFV2NnYkNm?=
 =?utf-8?B?NlFPcXpDb3cyRjROQ1Y0a1VoczM5MFZ2RUZnZ25MZkJZbGpudjBPRm9EU09x?=
 =?utf-8?B?Znp6SzM3ZzBCa3JoSGY0R2FhbzlIVlRXUmJaS0Z3RmN4VnN0RmxTS2FXekw1?=
 =?utf-8?B?cHdJenpMaUxwN3VBZy9RejRPWmtPQ0lVL2tOcHVOallNSjg1NTVJZWMzNUZK?=
 =?utf-8?B?R0NYeWxGejduR1pvMFViWVF6ZHlPMC9NN3Y0NzNtL04wazQ5N0VLcTcxUk95?=
 =?utf-8?B?V1JUR0VQWlhYeUFXZ2gzQmcxNjJlN2RFbDljaWIwenozOGtXTkJSQVRiSlla?=
 =?utf-8?B?WUNOeExHdlZpWDdPUXY2bHYxQi9zR3d1cTNiMWp2Z0JqRXE0aThlZlcxWTBY?=
 =?utf-8?B?N0F5SDRJNjRXSjhkb0dLNWpHMGQzWVBCaGIxS0I2V2pHcGNHa1JxMUZBTjlj?=
 =?utf-8?B?Zkx6NjZ5MHBsS3ovaU1hT1dZQm5BcGtES0NVclVqckttQWFwcHhmZkVEZjhF?=
 =?utf-8?B?MktpTlJhOEEvSUVuVmFQYjVuVElCckxITTNUbVcyWXhlcWlkWTJ3NG5BblZ5?=
 =?utf-8?B?YXlpQ1ZjQWZhR3lnQkIwZ3RXWWhEZXBabE1KS1lxemZxbnRFM0FmeEVDdWdp?=
 =?utf-8?B?UE5scWZsUjZqUHRNS2wyT3RreHlKWVRPYmp1QzFjZEtCSCt5a1J1NUh4d1dM?=
 =?utf-8?B?Qk9WUGdVbXo4bXBOMU1uTWppMFU1OHR6dTBTQnVwR0JpQXpUTElhVVA5OWFE?=
 =?utf-8?B?QzF4Kzlmdk55WHlDeHR5UlRzV2JDNDNocjZkTDRlRnZUMHNNRzVqRGUrNUlT?=
 =?utf-8?B?N0QyUEV1eUNYUFNZQTAzT1g4Y3FJSXZVV3N6RGN0Ujd6dEFVL0E1QjRSS1Fa?=
 =?utf-8?B?TXRINS9ub1UzMlozM1FlSjlEUjFNd1NsVFQ3RDZCU2Jqb2ZBaEJYL1E3azc1?=
 =?utf-8?B?dm1SMHVuTjYzYUdSTVBnL1NobDdteGVYdzhzZGJBcW9YYzVOZVBxU0FEZGtq?=
 =?utf-8?B?ak1DMnZEOXpFelV0dGtQMVRoS0E0cXRGSlZCdnh5cVR4bjFQRVFBODFSSm9P?=
 =?utf-8?B?VlppMHllNEhWMS9aSHRCOXZnRnVRMDY2c21WWjJSd3c3NExBZjlKZC9zYWtT?=
 =?utf-8?Q?qRW0IswetKvNx5VMLhGrZoXZOgWkwaUfUjPepI0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2UyelFBNXRjcXNQRFhoeHdnUlNzV0RMWnNza1lFNHIyWTZtdzlYQ0ZwUHgr?=
 =?utf-8?B?WTBaMkFKUjdOYVpxc2cyMFkxUkRUaHRqeTZXVjhmbGFsSzNKeTdUbmZRVHBB?=
 =?utf-8?B?b0k4cmw3SlA0cExIajdMNlBtRnErWkhiTzZYN210OUExVXliekVXWHVpbkRT?=
 =?utf-8?B?WXI0OEI3US9US2xNeGVKQ2pzYitQcXc4T25Pc3FqL28zK21yMzJ3ZVlTdHFu?=
 =?utf-8?B?N3l3SjBRcFVxRkJmMDZBUTgrM0FFMWx3UW8veGdnQStkNi9GamFHZVpWUFRm?=
 =?utf-8?B?a09CSUNhbnAxV29YNEhkdHgvMVh5NmFQVGZ2NEV3Qmxhd3REWWVzbGZ3eGJl?=
 =?utf-8?B?RFZHOUd6anpsOWQ0enl4bUdwQnhXQzJOS3YwQXVkVHNsaVRDMnE5cHR5TFcw?=
 =?utf-8?B?TDUxd09oSlBCWG5kcUdYRTlqcElCRFlKbDkwWk0zN3RqTlVwd0FIUHNsZEhy?=
 =?utf-8?B?cWdZa0xkMFVRbU9pMzlURnZHRW8xYTFiMmdnTW05dUVDcHV4OHo5Wm42d1Bl?=
 =?utf-8?B?NGRhU21WeS91WUVudDI2bmt6UTFDMUxodkJXSkxuOFJFS3F4SGxCUFhRV1ls?=
 =?utf-8?B?d1Y2RklJcFA4MzAwdUNuMFQwa0VPcnVad0JKdHlqc1JJYnRGdzdNblVZY1pI?=
 =?utf-8?B?a1BXWkdvNEtad25Pb3FnR0t3SmxSM2FSYjFtRVN0ME5MenVuR1I0OVd1akV4?=
 =?utf-8?B?TGR1cEVNMGM5MnVWMmFCbkVQZnlrM2x1M1RBdFhTRGRCWVVkTUUvZE4zNk9I?=
 =?utf-8?B?Y3ZId3B2cW4rTllrNTJlQkVKOUpRZVZ1cUgwc3FIc1RZMUkrclYyRlJYMlZN?=
 =?utf-8?B?c0kzUHorWU1ETFp0NUFGajJ5N1hlQ0d0cmY0a0tmTW5XaTJtSEpHR2V2Tkps?=
 =?utf-8?B?TTNJNEpkLzBwV2FtcXMzZ054M0Z4VUFDbTl0SGNqOHpRdkZjVjQ3S3BVWFhn?=
 =?utf-8?B?WmF5OGJGODVMNDFmT0toVTN2cHM2ZWkwbUpRR2dic0ZRSmFQbk96Qi9RNmE1?=
 =?utf-8?B?dXBFc3B5cXlSTkdyNmVNaGNRa2k4ZGtuWFF4SFZxRUJhTVk2N2J6Sm1HcG85?=
 =?utf-8?B?dXVkWGdmZkNjU2M4NkdxMDNyTkZYdVJMNW40TDdFUDlSUGJjbFAxTitKUFVj?=
 =?utf-8?B?OGIwN0dpQThQSUhxVVovdzl5eFJ4bFBXeEFBY0hTcUsxYXg0cW9BZkdNWXpP?=
 =?utf-8?B?ZG42Yi92aDRod3lNTHBRV3JzQkZPNGZIL0dVUVdyNEhpSXkzbHUxRWdyQmFM?=
 =?utf-8?B?SlpaRGNVTkg3QlNpVVQvZklxQjlCL3F3K2hkVCtJbXU2UU8rOGpnMllaNW5s?=
 =?utf-8?B?UEprNzVvbGxta1RsZnJLbDRjaVEzcWQ3cVNGeWpwZlFTN2Y4TUdJKys1NzZW?=
 =?utf-8?B?WUtVRFVhSE02T2xWclYyaW9zZ3VSaktRQ3BJM1RlNUpJbWRFNG1SWDZjRmdB?=
 =?utf-8?B?Ym5sQXNKa0pQNk5jV3g2YVYzVjJZQjJDRU0rSjRQM09XSTVIbnV2RFIyQm5a?=
 =?utf-8?B?cExqa2hSUDNUaWZnLzBxQVdYUE1rNmsySG5PWnl1T0owSmNlMHZtbkRlSzR2?=
 =?utf-8?B?THZESnZDWjV4TldpcFVDSGs0R1RqZWo5R1ZOT281anA3NzBYbDVqbnp2Vkgz?=
 =?utf-8?B?RXd6QkYvTTZTQ0NzRURQQjdqQ3k1WEt3T2g5TU9HbjRjZW1qR2dYbmZFbUdn?=
 =?utf-8?B?WFRzbDRPd3oxOU1vaWtNSDFOZ0puQzlEd0JTNy9nVUpsNndERnlXVzZrY2Ex?=
 =?utf-8?B?R1dybGNNaDhUTW5scnE0amJrTUJ0WS9hT2lqM1hhcCtvUWljWUxkbXRnWU8x?=
 =?utf-8?B?ZUYvUGMvd1ZNcXIzaXRyV215THNtTG84TjRQdXlpZTZVUWxTWm9BSllFNWdt?=
 =?utf-8?B?cTRZYVdEMG5PVDBZeFFYSjJsQ2FxcVNGMzRsQzY5RmNLTVdVc2VHM2M5NFhu?=
 =?utf-8?B?RU8vUjFSVnJHdk8zK29WU0FGUTZrU1dNQ04rOVNDd0FIcmV1TnpNeG9BdFVC?=
 =?utf-8?B?YWZSTHorZXZwRkpidWZkMDgvanBNSmxpZ1ZyQ2g0emJBcVJQODdFREsvZlM2?=
 =?utf-8?B?Y0hGN3k4RDR5SmdUNmdURk5aWHlDYnlncUs3d25YNGRTOTQyVGxCbFJTMm9O?=
 =?utf-8?Q?XtJGTj816cmJ2cfoRIf2GGOZE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0738f18-096a-465a-4bcc-08dd0a030942
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 08:03:51.6668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBYDxauSVhuQgJXedjUeaVQzXVLM69lCu99n9PMOa2sK5NqaxKeoEEs4ABb+6V18FUNsiiiBspdwljvo4HwdAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6184



On 11/21/2024 11:11 AM, Borislav Petkov wrote:
> On Thu, Nov 21, 2024 at 10:35:35AM +0530, Neeraj Upadhyay wrote:
>> APIC common code (arch/x86/kernel/apic/apic.c) and other parts of the
>> x86 code use X86_X2APIC config to enable x2apic related initialization
>> and functionality. So, dependency on X2APIC need to be there.
> 
> Have you actually tried to remove the dependency and see how it looks?
> 

No, I didn't try it previously, as based on checking the code below
is what I understand how the code is layered:

- Common x2APIC code in arch/x86/... initializes the x2APIC
  architecture sequence and other parts of common x2apic initialization:

  * Disable and enable x2apic (...kernel/apic/apic.c).
  * max_apicid setting in (...kernel/apic/init.c)
  * acpi_parse_x2apic() registration of APIC ID in early
    topo maps (kernel/acpi/boot.c)
  * Enable x2apic in startup code (...kernel/head_64.S).
  

- Each x2apic driver in arch/x86/kernel/apic provides callbacks for implementation
  specific (x2apic_uv_x.c, apic_numachip.c) or a particular mode
  specific (x2apic_phys.c, x2apic_cluster.c) functionality.

As SAVIC's guest APIC register accesses match x2avic (which uses x2APIC MSR
interface in guest), the x2apic common flow need to be executed in the
guest.


- Neeraj

> Thx.
> 

