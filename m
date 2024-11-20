Return-Path: <kvm+bounces-32155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0EDC9D3CF9
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 759601F2356B
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E07C51A7265;
	Wed, 20 Nov 2024 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OCwOXAVJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAC0AD27;
	Wed, 20 Nov 2024 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732111427; cv=fail; b=uvcv+BTd7/9/1ya4OgnLBoQGKqENJOEeDc+NFvFDMZTQfupZDASAjUfH5GAHPAWIRoco/oRYUD5m1/VCFkhCDR7XJAx4/xlS40u1kv+idhDF2/dBcEp2NoWnrQt9hlhlIfVfq2rjKq0yvW7iU0VJGR3kh5sOdfiHYZyCWvthVD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732111427; c=relaxed/simple;
	bh=XYkEKYKu8mZU01Ovdpm5cg003XwIb7M5x9ZwcEXzy4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YeyPPQMMZEV9nqyxBctFm7kyJMYrZN0TMOIZEaDAg9FnGfDv3LS+n6OetDRKWWVNzKenPfNr3ZoEK/zOIJOoX/Du3IT1rlQqGTFsFsQeuB0wVqlzihLry0jQuIQut4a8aIkmXkV/9ZQrBhlQnTb+mr6Ny3/2xVEOg56cMyY1G2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OCwOXAVJ; arc=fail smtp.client-ip=40.107.100.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PSbHuYeKPW1050oC8T/PM6LG7CgdKcwjPV6hLZN8i4nYZb4RvmMMeRHUtYFNo67LalDYQjCrSJE2qjGIsebISBVS2SsCnLOF9C1PCtCE+fRSg50bDlBeYeh6geWjAWvbYVoOjMMfbJfNAOczoDE8NvExfPKC5K6x3vhnB2LkHaNt3/tR5DbO3GEnM3SeMPbqBlBXutLI8c/gjFoRZjtfjMwbFPXqFqqSHQCvfGhq6H76Ph6AvFZoegZ371Q9d5CUlgqc/y/fArHvHAUtRVsXp9Ny0mQZiF2AbvBeIIM1XzHcHK0tximm0Orl027Px/klrv2TcpR/4+KxcIL8Gt6FdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vabg5oqHXpEI6VZNY6D2sJLldk0DehvIfS/E4IwKRBM=;
 b=gLJiDamGNSaqEKQOxMaOeLQph1/yEDmv3Xc2m9YSP28jPhOFfyv4aoKo1UbpPe1JtUL4xG6F5/QHsK+co1L5JzJAR1noRYNXEoj3LQKdUUZJxrO0Fv0x8NadU9hRTmJPeXDnabdCcJoalVZqUpxXRXVZtg3Kq2DZj7m7s3+H/RKK1dqImMZp+yjlPE/SWKNHa+LL1ymHtq8Ped2HjDozBqM51zZAScAKB66FFChEA0EG841fH8QOeZkeKOi02tugZ2grsUPZG8dNexSwB5SbmjB5Gtg8GvHuiNj1mJvAL3ukB9nPv5PwSZiiICTH01idZbV8oiqMjZ0JjDaMwsQNfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vabg5oqHXpEI6VZNY6D2sJLldk0DehvIfS/E4IwKRBM=;
 b=OCwOXAVJMVf4RhT+YmcXIvaS7SLV4bh/ugdPbYoS0aldzREsvb+8jRu1r6gXCxGm7VwIHjqlOGHMydr0GxCXhpN0l/vIQFZExfjTEu/2wm6Ng5NyMLQtXbmLKCYpRZ5aw/AyH0HDcOtZjrz5sC6SLhnDCZhkifCDHbNX7G+5QGFWLE168Xo9QawLPHKfHs5sGWRM/jo5jNvbOIElnKragUqfLdV8c9aBdVNKZHQjDOF4PQ0bd/2egcQuMvLlyB9MSkfOpSKXaV6NbIQuaOgIVu93/U1xA2GXvbB0RjLnu6smKkgLjBmYVxUohg8wMJ6zljjdP0qt5h8u4m6RuAPg9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6278.namprd12.prod.outlook.com (2603:10b6:8:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.14; Wed, 20 Nov
 2024 14:03:39 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8158.019; Wed, 20 Nov 2024
 14:03:38 +0000
Date: Wed, 20 Nov 2024 10:03:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nicolin Chen <nicolinc@nvidia.com>, tglx@linutronix.de,
	maz@kernel.org, bhelgaas@google.com, leonro@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, dlemoal@kernel.org,
	kevin.tian@intel.com, smostafa@google.com,
	andriy.shevchenko@linux.intel.com, reinette.chatre@intel.com,
	ddutile@redhat.com, yebin10@huawei.com, brauner@kernel.org,
	apatel@ventanamicro.com, shivamurthy.shastri@linutronix.de,
	anna-maria@linutronix.de, nipun.gupta@amd.com,
	marek.vasut+renesas@mailbox.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFCv1 0/7] vfio: Allow userspace to specify the address
 for each MSI vector
Message-ID: <20241120140337.GA772273@nvidia.com>
References: <cover.1731130093.git.nicolinc@nvidia.com>
 <a63e7c3b-ce96-47a5-b462-d5de3a2edb56@arm.com>
 <ZzPOsrbkmztWZ4U/@Asurada-Nvidia>
 <20241113013430.GC35230@nvidia.com>
 <20241113141122.2518c55a.alex.williamson@redhat.com>
 <2621385c-6fcf-4035-a5a0-5427a08045c8@arm.com>
 <66977090-d707-4585-b0c5-8b48f663827e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66977090-d707-4585-b0c5-8b48f663827e@redhat.com>
X-ClientProxiedBy: MN2PR18CA0013.namprd18.prod.outlook.com
 (2603:10b6:208:23c::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB6278:EE_
X-MS-Office365-Filtering-Correlation-Id: 9929d772-3c64-46ea-0470-08dd096c21dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emdUUGM1c09KeWQySlRwS3BDczVIeDdHUzM1TmU4N1NueFI1czN5L1VYMndJ?=
 =?utf-8?B?TFZLUTVzZWthQlQwemY3MFNTVEowR0NiNmx5R1BSeDlWWlFwWG8rUGkxN2c1?=
 =?utf-8?B?bWgrcVAxbWZqci82TXNENUdSRDRYTG9Qa29ON2EyZ2d1Qi9zMFNvMGt6SXhK?=
 =?utf-8?B?bGpBZHo4c1dXOVFDRW5qbmRmWXU3OG81RzNqaDNDdGZWY1hYdXZLQ2JVTXMw?=
 =?utf-8?B?N2NIK2ZJUG1lZ1BRdWhESkpka2d6N21TZUVxcWdiK1pyVzRJZlNzT2tiZEg0?=
 =?utf-8?B?ZEdzd1NTQ3BlZVlON0JDcUc0MUhUcDVkKzI2ZHk4aDVXRTVScE80RXVGOFRV?=
 =?utf-8?B?NmpxUmJrM1JicUdFOW1makkzMTNGMHpjeHVER3JBSk5IWWFKeURyemRNbHlh?=
 =?utf-8?B?M0cwL2xLakpXT0tSWXVoL0Z5bmI3U0JtalhqbHZHYkxVYm5TOGlqaGQ0by9I?=
 =?utf-8?B?RzZ5SEtPVm5ET05EdnZKWWRGcTdIUUlRVTRoMXFTVmhnK3VVZUxqUW5tS2Vz?=
 =?utf-8?B?bnVubnJwTWowRXh4T2N5Zm9OUmllKzRYVjZjRUg3alNRMW1KZUxldEk1ZlR4?=
 =?utf-8?B?RFhoSm1mc0dvK3E3NDlqMFdsSTBhbHh2REs3bWdxczB4Q3kzdklaaG5wMm5U?=
 =?utf-8?B?VFdVaFhZU0p3TXI3aFFDYmZrdUM0UkFMM2hUOGcrcHVLczBlbDEzU2xKc0ZP?=
 =?utf-8?B?eUVqWmxQNTRZdDBZN3ZBWkk2azZGUWJ0S2N2UytYOHpLd0pkS1pNMHFUSjNq?=
 =?utf-8?B?RC9VZHZta1lMVFo0OFZyaG5DaEdZN0FVZHE0NEVuZDNFSUhWVnl1N1VHZHhv?=
 =?utf-8?B?M0IwTDNDb1RiRlRYM3ZZOG4zUFZ3bVJweEViNENldmpESnNMUlJnNEJySWNB?=
 =?utf-8?B?UUUxOHVmQUVLWTRDeStpbS9xb1FqalJHRTZFNTAvVmhaSFdjU1NsTlppWW1o?=
 =?utf-8?B?RUV1dHI4cUU2d1d5bytBSzhpZmRGUWJ4UlZNNU45RGl4OGNmQkFFZnk3MjZP?=
 =?utf-8?B?ckkzODN2aFNIWFhUVk5PcXRJYk9EeHRIVDZFL0pUbkcyaGNOVG5tNzZ6QTFV?=
 =?utf-8?B?cjBVQmJab0tibXZEbWJuUklTU0t1S3A2bE1kd1lOQ254dVFGNWtvNVlKWEho?=
 =?utf-8?B?eGpWZlg3SU9oVjhtaEp2M3VMV0hRQzVKeHQweTZMNjVudFJGVVFQdW5CbGZH?=
 =?utf-8?B?TTZqQXdGbUVJUnFlZU5GWERHd1QxdjZGbkZJSTU2dFlpeFc3Z3l6YnlBa0dC?=
 =?utf-8?B?ejhiRTRlem1RWHhPQ2t3U0RGemtEbm1jcDVLaXJBTGIrdzJUUjErQXRhdGM1?=
 =?utf-8?B?Rk9XL1dYWDdqOTJjcFZWL0llTG1HZWZESHVhU1dOTWtyTDlnNUg0YzRPbWY3?=
 =?utf-8?B?Y1Bja0kvMmttVEJydEp0ZG1ONEowY1FJRlVLamMrQ05sREpIdGdwcjZyNWho?=
 =?utf-8?B?dUdock54QXdNVWVPc2RqYVRBb1pvMmtiNndQSWRZNTVnVERkSTFBYU91bk9M?=
 =?utf-8?B?ZmZWMVkxczFvaGNqQVQ0OW5CY2xEUlNCbWNkYzl2QmlqNTMrcUd1TVN5eG1z?=
 =?utf-8?B?Rnd3K0s4bEFvNWIraGM1MGZJWGorc09rWVdnblNoSkFVelVhdzhJaGNmN0U3?=
 =?utf-8?B?dHFNaGtxZzNYT05zSVNFV0Y3UWh6Y2lYY0RSa2RSa245dmlBNFNGSFIwWmpu?=
 =?utf-8?B?dWJ4T2paU1NlRmQ1bS9ERG1xa2lRS0kvMDZiYXJ5M1ZuYkRuVTdreFVTTGdt?=
 =?utf-8?Q?tpX9bh6IzEpP0sHcbgAAGlMMM1CiVIQS2ztLAER?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFpxcDVVKzROdHRtZEx4WStVRC9EZkpVdXJZck84eWtkMU5KRDV6NWpVd3hO?=
 =?utf-8?B?eCt4MHNnWlAzL011aGxmWG5FQ2FZMStTZXprc0lzK1Z4UE1ja0dycW9rTkto?=
 =?utf-8?B?WWlmNWcvYi9tRTV6YTBBaWdWTysrcEdYb3FTT3cwL1licWtvL2gvTDJkSUlN?=
 =?utf-8?B?eVpWQUI1ak42OG82Ym9aM0hFcThnU09UVDgySkFFb1pvelo1ZjZUSnI3ajRZ?=
 =?utf-8?B?RGdVbzhydDdlSytta3JwNGVSTzZzUjNlMHVVRXM3R1RKbW9MV3R4Y2RwMkZD?=
 =?utf-8?B?a1hUMXNxSW9NZHZyRlZGcmpkSFM4cm1qVHZWWWE5S0s0VzF3ME5PWEQycW81?=
 =?utf-8?B?cDh0clFGeGMxQUFTRXBNQjFDWUZEUFlXTnVPUC9MWTlqcml1Y0xweVdQZkha?=
 =?utf-8?B?RFJaSGd4VkVQTFNPZi9IOFltM2xkRFJvcTVCNElwTTMyT3RjZlM4dTBDdkRH?=
 =?utf-8?B?eG8vMmlsWDc2Mk9kbzgvWUZTTlU2VWhUaGhFWXJRQ3dOU1RHcjczOXVQWmwx?=
 =?utf-8?B?MVFvVThoL0RGbytzTDlEUEV6RUJwRWJRR0JMRnZ6TzFQSlk4TmJiQ2VVVXJQ?=
 =?utf-8?B?dFI4dU1qaUJNZXlWakVGa3U2WjdJMzNDdjZLL0pLY3k4RjRCVlFXb0hiUmVl?=
 =?utf-8?B?L2JNZ3RlRXNpV0Q1US9BK3ZJd2NnK0FSTU9UQURMVWlOaEhRVTh6UFMvWEpX?=
 =?utf-8?B?ZTBQREUwTWdDaUh3a3QzTW52Vk5NaGdtNkx6QXAyVFlTYjFSUFlBZCtWTmRs?=
 =?utf-8?B?L0dhempOTTlDM21MM0dCZ0E2bFNPS2JRTDBwR2NEVmpWQ3czd3JHVXpRcWJC?=
 =?utf-8?B?TlZnWlZCcjd6eE5FNnpGeU5kdVJKdUlmUS9XYTVlR0tYL1FZQjkwc2lMbGpJ?=
 =?utf-8?B?U1ZmT1pJeGpaQllsOFA5eVVQanBVbXRtZmtoZ0xpb0krVmU0Y0JwcHluV05Z?=
 =?utf-8?B?N2RxdWIyR2l0a2FrQVc2czc4Y0I2eEZOTVNERzRSdGVJbXF2SWxwbzQ5OE1R?=
 =?utf-8?B?ejM3Y2VUck9ZeFZMZFV5UXZOc1NSRjllemQrVDRXVUNRd01XZFBlKzN1L0p1?=
 =?utf-8?B?V05jZnVhQWtVckt4M0p1bmx5UzVOdmNMZlNCTGEyVmM2YmN0K0h1VFdrS1pK?=
 =?utf-8?B?SXRmR3ZiTzU2bElEM1FmNmx6M2JGRG91ZmZXOWRaZDhIa1p0eHhhYi8yUHVX?=
 =?utf-8?B?VVNqbzVFL2l5eWZmZEZ4MElwRTV6M29lUFdJMldNbGpCSVA5RzY5TkI1MUNU?=
 =?utf-8?B?WWVCcFN3eFNBMXRGaSt0UUJtb1BWUmZLVmZ4c1J4ZjlGWXFZckNnWm91UWV1?=
 =?utf-8?B?Y0crWldzRk5UVDF5V0NETjBtL0FLVnJTc1JpSkd1WCs0OWNLMjJGY1ZkNlEz?=
 =?utf-8?B?WS9KdXVMVERBTVJ2NXB1OGVSdDN0OWtTNm9TbXVuSnpzVmMremp0MTNURTJP?=
 =?utf-8?B?ZWZxNEh1a2ZmZjNYdFlwanVzdzRwbi90M201d0Y5RnhwVzQ5cW96cXJyYjd2?=
 =?utf-8?B?MGV5d3drQWE0OEZZaDBGdUc4aTc4d0MrUnhXcTg3bmlWU0RWdzMzbjJISlov?=
 =?utf-8?B?MXA4c1pjOTdYMGd6Q0pCWE5vbHhnRDdnM1dPRnVKOVB4RCsvV3dYSWtNNGdQ?=
 =?utf-8?B?NmZuR2Y3WEY4a2lGUGNWcUo2Nk1xNm5yS2twRUUzNHczOWVFU0hiTVdZcGZL?=
 =?utf-8?B?MldiTkZEWkZtMHo5bFNZUnBFaEUzOVpWbEVpaE9tM2ZkeWxMbjljbGNrOTgr?=
 =?utf-8?B?Z2pBMUJXVzNUZndJUm53aDBHZVdKdTVVQTk5cnBnQjV0ays0MnBhTGI1SEtH?=
 =?utf-8?B?S2J3bFB1bSsvMHdJQTY3aEUrc2RXcDNRTDlyTkFMaGJBMWZmMEhjSmt4czRD?=
 =?utf-8?B?NC9xYit6Rm9UZmpBUTlMeUMwQW5tYXlVSFhzU25Yai9QVUJWb3dBa2tySGtR?=
 =?utf-8?B?WFFvSExhZlJYWnNFczBsZTFJNVFuKytNUW5CRkV5Y3hMSThrM1BCaElSNGJo?=
 =?utf-8?B?NExlSUVIcEtLTnFDc25xTzdoWUVHbEFUN1hqSXBaSnJ6QlpUVFZHQ21EcGRj?=
 =?utf-8?B?UmZJdjVTVWEzRkI5Q0F5UHJBeGFvTnpJUlVGeUtVZGxPbUx2ZDBsQlNWaXZ6?=
 =?utf-8?Q?FBlU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9929d772-3c64-46ea-0470-08dd096c21dc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 14:03:38.8100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LIwgDG2NQEZ1LpyzHC5m3Mjbk5MlxeFgD3xZhZu39Q0ItjlesuUR28ID1q7wrCe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6278

On Wed, Nov 20, 2024 at 02:17:46PM +0100, Eric Auger wrote:
> > Yeah, I wasn't really suggesting to literally hook into this exact
> > case; it was more just a general observation that if VFIO already has
> > one justification for tinkering with pci_write_msi_msg() directly
> > without going through the msi_domain layer, then adding another
> > (wherever it fits best) can't be *entirely* unreasonable.

I'm not sure that we can assume VFIO is the only thing touching the
interrupt programming.

I think there is a KVM path, and also the /proc/ path that will change
the MSI affinity on the fly for a VFIO created IRQ. If the platform
requires a MSI update to do this (ie encoding affinity in the
add/data, not using IRQ remapping HW) then we still need to ensure the
correct MSI address is hooked in.

> >> Is it possible to do this with the existing write_msi_msg callback on
> >> the msi descriptor?  For instance we could simply translate the msg
> >> address and call pci_write_msi_msg() (while avoiding an infinite
> >> recursion).  Or maybe there should be an xlate_msi_msg callback we can
> >> register.  Or I suppose there might be a way to insert an irqchip that
> >> does the translation on write.  Thanks,
> >
> > I'm far from keen on the idea, but if there really is an appetite for
> > more indirection, then I guess the least-worst option would be yet
> > another type of iommu_dma_cookie to work via the existing
> > iommu_dma_compose_msi_msg() flow, 

For this direction I think I would turn iommu_dma_compose_msi_msg()
into a function pointer stored in the iommu_domain and have
vfio/iommufd provide its own implementation. The thing that is in
control of the domain's translation should be providing the msi_msg.

> > update per-device addresses direcitly. But then it's still going to
> > need some kind of "layering violation" for VFIO to poke the IRQ layer
> > into re-composing and re-writing a message whenever userspace feels
> > like changing an address

I think we'd need to get into the affinity update path and force a MSI
write as well, even if the platform isn't changing the MSI for
affinity. Processing a vMSI entry update would be two steps where we
update the MSI addr in VFIO and then set the affinity.

> for the record, the first integration was based on such distinct
> iommu_dma_cookie
> 
> [PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part) <https://lore.kernel.org/all/20210411111228.14386-1-eric.auger@redhat.com/#r>, patches 8 - 11

There are some significant differences from that series with this idea:

 - We want to maintain a per-MSI-index/per-device lookup table. It
   is not just a simple cookie, the msi_desc->dev &&
   msi_desc->msi_index have to be matched against what userspace
   provides in the per-vMSI IOCTL

 - There would be no implicit progamming of the stage 2, this will be
   done directly in userspace by creating an IOAS area for the ITS page

 - It shouldn't have any sort of dynamic allocation behavior. It is an
   error for the kernel to ask for an msi_desc that userspace hasn't
   provided a mapping for
 
 - It should work well with nested and non-nested domains

Jason

