Return-Path: <kvm+bounces-42297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A774CA778C6
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 12:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFCB9188E04E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 10:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4811F09B1;
	Tue,  1 Apr 2025 10:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nOiFfozz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAECC1EDA35;
	Tue,  1 Apr 2025 10:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743503166; cv=fail; b=aheZYtcbtvgyxAvT5UFDZX/UwzCUlaF6Mff+io1I6+sFe3cBQnzHuyVMkduMPAIYekTUo48wqlS0po9mAV7B9FK3AecFaGcT9VWv2rjMs82LQnxlx+glIyD0JJVdlwxyjiNDDcU/BUS8C605TJsXmwM6pobTb67UsCqKaeFUkdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743503166; c=relaxed/simple;
	bh=BMbXTByKVD3Q2+dFcaYRgXI91xFaojhVJX1r9AwzxPs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VEirmVBc8mmw9qVGfnExRzoyBfoiTmIGez112rFJZCyUuMSTnHvmqwL9FnBMRgJEcUEyambQ40MWsjo79JJ/b5Y0SHJxgolZrRxatvc5y6s1YBxzhTdzgnCYM/pJ98SYtqBmXzP0zAfvZDyP0m7waaP51uZ6IVI1/9AQAeVaSOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nOiFfozz; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vSWKA2qM2fccQek4rpIQ3JoalQQXleJbT1sskhVOcB28VA58muYcPN6jjcZ6vmeqnWzMJKNyQcsSuhpru+muEj3EjU6e+55mbFyzfUlBkYTuP9DtY4HX0VCUq0fb0DLL8yciE+c9FgSvBCadc34PP1PEM0OsdwunojrMYdQgi63D0orEZjPZUX/OJ00BcuFD6aBg23XQ2bgZbSkdL6z0WJOZoo4wm+TF3kv/O+RJNGDJiElsLcRbSdSmHLgfON/+sl1xRtXvxEE59h3Xpu6D/nrYPcLjReoCMqh8o2bdnDp62VPZF6Ct2ReHduD5hQtuqyiZKBvYTOXY4tBBU9gk+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Poi6xRnKf5a7yz6Fgi2pAp5fpIgQTob8sUN2ZyBU1uA=;
 b=Iihp6sU9s2Uy4/HKHI+sGfwFLccFP3cR5QCLYMuWCOoXnYmt4eY/6NEum7vDtfTK37DOSb6pg6S6v/D33/S3TuLs+ce1VReUDTWySJV2X6gVp2a7nzBNlZKGLZtq/33EOiRYzNzdByP1Ar3sZn/VPk2GMGAebZbWg//qhlD89dr5P6vDunK7U3YY4ZI67PJBXD5Hk4IvksTKRLJKfHmiKRYuDnTKgOnevW4ufFIV8oEoXjqCfjm3DPArM4xV6yvtBrzv6yaR2EoxLDCBXZDuarAwrhXb+jzFuvf90RNlfVk8lIphSB1v0j/BMoDAwG6KnrZ/lIX2/SXZrsw8rFO/Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Poi6xRnKf5a7yz6Fgi2pAp5fpIgQTob8sUN2ZyBU1uA=;
 b=nOiFfozzbY9IY6DOuJds8qlRNNyD3k5hPo6z6l8JvsvBj+VY2AzmC3JvLq6YNAEI388iX1UdKg/O2ua3WGDVbkONHitC5laJ+qC8vEbuK0C5jigM5/CmLDgXk/6++U8jjtYEg+Gj6AXsAumcTjhDMcMHZx5559BSsI1jLmdRPQ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SJ2PR12MB8943.namprd12.prod.outlook.com (2603:10b6:a03:547::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.49; Tue, 1 Apr
 2025 10:26:00 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 10:26:00 +0000
Message-ID: <0cd2aa35-a12c-464d-85db-afa8d477d993@amd.com>
Date: Tue, 1 Apr 2025 15:55:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 06/17] x86/apic: Add support to send IPI for Secure AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-7-Neeraj.Upadhyay@amd.com> <87h63m2zku.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87h63m2zku.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::27) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SJ2PR12MB8943:EE_
X-MS-Office365-Filtering-Correlation-Id: 64542b27-ecdf-4568-608e-08dd710798d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?elVlbmdiUUtoK0loMXA0WEhiTzFldFpxdFY4eDVNcU14Nk9pSlU1UHVkNnZZ?=
 =?utf-8?B?RWgzWGhsSmNCWUREbExPaDlmWXhWMUF3d0ppK1paUnZyc001QmFldm9RSmtG?=
 =?utf-8?B?bm9ZVGZ1STU3L1hYOFpCa2gwcEE0ZlhnNlhxZkVseTI1MG55dk1MQUxkRE1B?=
 =?utf-8?B?bFBsRHBHR1J0TUdxaXVCRWkydTNnaEFnRG9LZC9GcWFrMmJVcVlqTkV1SUU2?=
 =?utf-8?B?dHplSDhxc2dXMmdNQzZVYkkrcUJ0anFhbFpLRUoya2c1R29nQlhMb1A2VWl4?=
 =?utf-8?B?a3k3R1BtcmZ5U1NLeTB3aWZKcVp3ak10WlA4OE55ajk5THVpYzlSN2FJNGdI?=
 =?utf-8?B?d1NKRVJHS0d0OEhrVkJlcW9GSlcrWm1kNUZCaU1vQzFwcVdFaXRubldJWVRW?=
 =?utf-8?B?akV2bHJrbnNncGpHMUlOaXNkdWVYeldiUTROVUdJbWY2ZkxFWldTUUhTWVM4?=
 =?utf-8?B?RURUUExhV2Noa1pBb2hwd0JQdG5qVEpVSHozVFk0ZUQ2b3V5bXZXbDdFa3I0?=
 =?utf-8?B?d0pPdG1XdndjYkxWVWt2cFp1N0YwS0xQd0dpQWpXalYyV0VrM0FGdEMzTHRY?=
 =?utf-8?B?ek9zb203WmllTTlNcEVlc2ZWWjZxY1dESW1YK0RpUVB6SXZCS0crb0lwcnpj?=
 =?utf-8?B?YUIxV1VMbm5DYUR2MmhRN09KbWVSc3VNTUg2SGZCb1RXRXIrVjhKNXgzL3ow?=
 =?utf-8?B?Q2lrWVQrVGlFdnBvYkc4QXIzRThZdzM5cThsUm9DcHVCSVo3dkFmeCtJU1FV?=
 =?utf-8?B?WUtnUDdxVDIrTlFyRmpvcGJXdnRmN2pEem5BK3BtSXlQYWMrM1puTFAyRzF0?=
 =?utf-8?B?ZXpKSU1VWU1ib1V1RStUSDRiV0tlOU5LNXB6Y2pHNG9ubmg5NjRWb3hCeTVv?=
 =?utf-8?B?elJWbUtSSlc5a21NZklRZWNvUlhjaVB3SjZDd25GeDlIdXcwb05zR1l5MTB0?=
 =?utf-8?B?YXFVbEV4UzFZMmxRZW9iRGZwOVhRdkE3S2ljSW5ieXN2M1hybFQ5VXhFYzRp?=
 =?utf-8?B?WHYzY0VyL2kyRzRaVkx1YjFubFdRNVpvSUFwajdRY2p0bFQ2dC9iN2Nzalpk?=
 =?utf-8?B?TVBhVjNORk94OHEzeUJiTmxWR2FqMEZacmt4eFpCT3pUbXVWWTFuS09wbUEx?=
 =?utf-8?B?NW1qWmcvTC9PdXFtTUVobitpeU5UR0tISmdIVmxYOVg1OFZRenZGcUtSSVV4?=
 =?utf-8?B?UU1WWTVJNGsxdDIyQUduTHhtQklORkM1cnJoUEJleDdwNXpDWnRBTWhiY294?=
 =?utf-8?B?b1FRQmZ5QXR6SW9NS1MzVFVFcVY5L1hBNjFEOGRMek1LZ3VQR24xYmZEY3Zw?=
 =?utf-8?B?ZVdvOG5ZekF4Q2VkbDI5N1A0aS9rd2xBN09CRHAwSU5WVkxwSnRITCtXUjlV?=
 =?utf-8?B?ZW0vTk1abG5ZRHhTNWxzRWtGcTF5L0t3Z3RHakNrdzllQm5qOUtTajMrWndJ?=
 =?utf-8?B?cEhLVnpqc01DNHRYb2FueEV5YXZFejhQaTZhQXZyekNoMVAxNS9oVHlkNndN?=
 =?utf-8?B?bjRzUlNpK2dKZGM4T0N5MUFnbTRtQ2pOdVJ5bEtwZVozaGdoaG44cEpZWjlD?=
 =?utf-8?B?TXEvc0gzOHErRVlFZTdWbXVkdUJWME4vTGVsc2hERHZvT0l1SjFFb2JkVmc4?=
 =?utf-8?B?OE9zL0NpZ2xEWkFVOGlwSU1tYm9tclV5T3duZy9keHMrTmttZ3RrekF6VHJu?=
 =?utf-8?B?VFVDU3AvMFk5WVovb3RBamZvSDJGVUVmT2dHa0FKRW41LzJzRUh4bjdWTWdN?=
 =?utf-8?B?V2FjbW1GaittWjFESGh6aHU4ajZMNU9iNzlTYTB4clhqSkptVzhhK090dFpn?=
 =?utf-8?B?Y1VxZXFScUZlWEZZaUI2UWxOYlpFMy9nUlQ4dHhycm9ySkFqT0h0TlNIVU5w?=
 =?utf-8?Q?5wXeETyvZ7zzE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTlTRVRzWHhqWU1NZTBWdTFxVkRyc2tyazkwUGV2Y3VqZGNsSldFa0pOK2Ra?=
 =?utf-8?B?bHlLVnRRV0N6L2tYSUpYRUZSY2NGSGUxbkNwOUtVYXVMdm9rd2dUajVzSm8z?=
 =?utf-8?B?MkVuRmFvUld6TElwZm1Xb0l1bThSOXVLMVlpSjNKMXMvWFdIcjBVT0JGaGdv?=
 =?utf-8?B?VWNhS25EblpPeU5Vb2NWZDh1Z2FHaGVBNmVHUjFwa1ZXcmFsR1lsM20zeVJt?=
 =?utf-8?B?RzlVWWk1aXh1Sm9rUytMM2UrMWdyOVlic1lVUzBHcVNlVWdQQ0JxcFhlZU5D?=
 =?utf-8?B?MUo4L1RoVkxjc1o1bWpjRjdYNDdzUWtuaHJLcUFhbm5nd2ZOakxJMFRhaE9T?=
 =?utf-8?B?TXNrOGM3YjVBN1hIcnFwTEc1Z2x5R3R4SXpDUldzczZWNmVXblB4SDBSTitN?=
 =?utf-8?B?emxKQ095WktmUDNvaGdaQlUrUnBMNkVtMW9VSDJuTDJRSFVINnRWRjBqMzhF?=
 =?utf-8?B?SSs0bHFCejJYcW12OEpNMmJWc3hDNjRYQ21PWE16L242TmR2ck9nVDVMaHlU?=
 =?utf-8?B?RjJvT25PV0FjeXVVY244SFMrWGFlMmY2NHUwK3RRQ2pRODQ2YWp5MXJTaWNL?=
 =?utf-8?B?QXhucGpnUXBnSnlFSjJTYzVUVmZtSGhlYmkwbE5SYWxyNEZaMlliSlFYZXZI?=
 =?utf-8?B?STZpc3RYeFBWMWtPTWNFRU5nTGxQdUtTcVBSNzhYOFZCQVNUcnlmaXdWTTlJ?=
 =?utf-8?B?cjBTQk1WakJZRHQ0RzA5bEloMjhNTGxVN21wZzROWUFGSFJmYmRkT2UweWxo?=
 =?utf-8?B?WngrcUU0NkM5NjFNRU9nS1ArMU1TRGlXNzdTeWpJZ05Rb3Vid1pocG9ZZ2VV?=
 =?utf-8?B?Uk9FWGNxdml2eWNpN3JtU2Z2ZmlvZE5pVlkxSUQvb0FrbDNBWUJXTGtjd01n?=
 =?utf-8?B?RUpaU3p6bXcyZmhCVFg4NnRWWmdLaTFINmhXc21QNWFZS21FK2pNNUJ4TG1G?=
 =?utf-8?B?MzdVU3lOVkJ5RmdDMmJsYlA5Ym55V0o3VktWYUdPZmhDVk5xZE9yVExodEE1?=
 =?utf-8?B?ZG4wdkFRV3hOSERZZUx1WjR0REt3VXhrY0x3UVh6ZHBNbElYOGJQSXROYnVm?=
 =?utf-8?B?VnhaOEdmMTAybHlGSkZQb2JGODk3K1VLeEpjbE82bHR1bFdTTHcyM1pjQWNB?=
 =?utf-8?B?RG9VSm5pL3pDTzhLNW5EVFhQUjNPQVVZU2pSVXRLdzc4LzgyQlNVUzZrTjVU?=
 =?utf-8?B?bzNpa0cyWnRhbi9EVWhqemI4NFFTclVFeStkOTZrN01yRm9Bdk5JK1hiaXk5?=
 =?utf-8?B?ZFIrMG05VFo1KzlEM3NaNTNKTFhOdDg4Z1pBTFRBc0QxNVp5eVE2eEE1Tkdu?=
 =?utf-8?B?R01oc1dqS0lodGlxVDdnOTNIaHVjK0ZlOTA3TlZJWDVlTGowa1UzRW1kWUl1?=
 =?utf-8?B?eFlGN3F1cUU1WUFudHdjM1FPRUtaeXA2b0liUFdxd0puVitJLzgwRnY0MUFn?=
 =?utf-8?B?YUtYYWdGOUxvNGxDOFpNSjZrVDJzRno1WHRiYTZWQ1B4KzNydUVpa3JDdmRN?=
 =?utf-8?B?ajRxeWQramZFQmI2dUlaRGdFeFgxdnNtTUlMcFc3cDNRM3IzWXBrUUs1d1JT?=
 =?utf-8?B?OWRkeS9DcktMZ0dpSXppUXZEU3RRSXk1NGtTdW0xc2VSaXFYdTIrNFJsQ1FM?=
 =?utf-8?B?VGplV1FPUkNwUjhHbjlFR0hHaldvS0krdk81UXF0S1krZ1NRSTQ3ZUZSNk1Q?=
 =?utf-8?B?MVFxVkpuWkJjR0pyc2xQN2xoVFJmUmdQNXFFZzBUYXFzN0dHbzNSVVg1eGRG?=
 =?utf-8?B?V2o2c3d2eWxZbVZnTFp2QlhOenJaRDloQkVMeDlvUElXRmRuajNEaEJWenpR?=
 =?utf-8?B?RUV2Qm8veWJ2ZlFPcWk4YTZscGV5bmdKQWhyb01DdXArd0VuSU1zUm15UlpJ?=
 =?utf-8?B?Ym9JcUEwK0hnb21td2NyMTUra0I4anV2TUdjSlhjNkhwZCtsOWt0eTZMTVph?=
 =?utf-8?B?c3NoaWcxOG1aMUlwUEZaVSt3T1hXRnJhaGdCVDdQSmQ5NDNjeVN1RFBlcXhx?=
 =?utf-8?B?Z09hRnJWR1BCZEtnNmp1VTV2WVY3aVBSTUw0NEgxUkZna0RubWluZ1IrODF4?=
 =?utf-8?B?cmU1V3RhRG1oZ2tEMFdiQkZFTFJVa3BSZUpZbUtpV1RqS3IvMzFPZlptTjZP?=
 =?utf-8?Q?zKTtGTjoRwYxloiG49oae+mVk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64542b27-ecdf-4568-608e-08dd710798d4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 10:26:00.3801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BEIYATP53ElhiH+E0qwh27Bi5gSvDLfqy4IaeIpeLbgbef29XlR2KHfcM72o9/rKqaUHaW9tgASbHLr8CG+Qog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8943



On 3/21/2025 8:36 PM, Thomas Gleixner wrote:
> On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
>> +	/* Self IPIs are accelerated by hardware, use wrmsr */
>> +	case APIC_SELF_IPI:
>> +		cfg = __prepare_ICR(APIC_DEST_SELF, data, 0);
>> +		native_x2apic_icr_write(cfg, 0);
>> +		break;
> 
> Please move this into a proper inline helper with a understandable
> comment and do not hide it in the maze of this write() wrapper.
> 

Ok.

>>  	/* ALLOWED_IRR offsets are writable */
>>  	case SAVIC_ALLOWED_IRR_OFFSET ... SAVIC_ALLOWED_IRR_OFFSET + 0x70:
>>  		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)) {
>> @@ -154,13 +159,100 @@ static void x2apic_savic_write(u32 reg, u32 data)
>>  	}
>>  }
>>  
>> +static void send_ipi(int cpu, int vector)
> 
> Both are unsigned
> 

Will update this.

>> +{
>> +	void *backing_page;
>> +	int reg_off;
>> +
>> +	backing_page = per_cpu(apic_backing_page, cpu);
>> +	reg_off = APIC_IRR + REG_POS(vector);
>> +	/*
>> +	 * Use test_and_set_bit() to ensure that IRR updates are atomic w.r.t. other
>> +	 * IRR updates such as during VMRUN and during CPU interrupt handling flow.
>> +	 */
>> +	test_and_set_bit(VEC_POS(vector), (unsigned long *)((char *)backing_page + reg_off));
> 
> See previous mail.
> 
>> +}
>> +
>> +static void send_ipi_dest(u64 icr_data)
>> +{
>> +	int vector, cpu;
>> +
>> +	vector = icr_data & APIC_VECTOR_MASK;
>> +	cpu = icr_data >> 32;
> 
> Yes, converting from u64 to int is the proper conversion (NOT)
> 

Do I need to use unsigned int? I will update this.

>> +
>> +	send_ipi(cpu, vector);
>> +}
>> +
>> +static void send_ipi_target(u64 icr_data)
>> +{
>> +	if (icr_data & APIC_DEST_LOGICAL) {
>> +		pr_err("IPI target should be of PHYSICAL type\n");
>> +		return;
>> +	}
>> +
>> +	send_ipi_dest(icr_data);
>> +}
>> +
>> +static void send_ipi_allbut(u64 icr_data)
>> +{
>> +	const struct cpumask *self_cpu_mask = get_cpu_mask(smp_processor_id());
>> +	unsigned long flags;
>> +	int vector, cpu;
>> +
>> +	vector = icr_data & APIC_VECTOR_MASK;
>> +	local_irq_save(flags);
>> +	for_each_cpu_andnot(cpu, cpu_present_mask, self_cpu_mask)
>> +		send_ipi(cpu, vector);
>> +	savic_ghcb_msr_write(APIC_ICR, icr_data);
>> +	local_irq_restore(flags);
>> +}
>> +
>> +static void send_ipi_allinc(u64 icr_data)
>> +{
>> +	int vector;
>> +
>> +	send_ipi_allbut(icr_data);
>> +	vector = icr_data & APIC_VECTOR_MASK;
>> +	native_x2apic_icr_write(APIC_DEST_SELF | vector, 0);
>> +}
>> +
>> +static void x2apic_savic_icr_write(u32 icr_low, u32 icr_high)
>> +{
>> +	int dsh, vector;
>> +	u64 icr_data;
>> +
>> +	icr_data = ((u64)icr_high) << 32 | icr_low;
>> +	dsh = icr_low & APIC_DEST_ALLBUT;
>> +
>> +	switch (dsh) {
>> +	case APIC_DEST_SELF:
>> +		vector = icr_data & APIC_VECTOR_MASK;
> 
> So you construct icr_data first and then extract the vector from it,
> which is encoded in the low bits of icr_low.
> 
>> +		x2apic_savic_write(APIC_SELF_IPI, vector);
>> +		break;
>> +	case APIC_DEST_ALLINC:
>> +		send_ipi_allinc(icr_data);
> 
> And you do the same nonsense in all other functions. Oh well...
> 

I will clean this up in the next version.

- Neeraj

> Thanks,
> 
>         tglx


