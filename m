Return-Path: <kvm+bounces-43723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBB9A95613
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 20:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B62291895C5F
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 18:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FE51E9B3C;
	Mon, 21 Apr 2025 18:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oa+HW9Vj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B890C2ED;
	Mon, 21 Apr 2025 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745260999; cv=fail; b=aGC2wRs+KC5PQ/h6cCwfVu1WGP6e+rrHcazhmlEKIgRJWje43f0Gndt0/vXH6CtVG96QH8som5857/LY5DegIDlXR6F2E00nb5hBeoES9lrX6BW+miUCKU1er8VRs1MIDmtTfNnVt2Ye1s7KEer30xf6hTPTJD6n55Ksh9IYCjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745260999; c=relaxed/simple;
	bh=6emR7pHHc9CKgMye4MY5yuRCW3/ha9VqXx3IFeNB028=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=PlXkJY5XsFVyaxCjTJeuuvKMkl9EphHxwJRyXKaAiTujZrXZ9lAcWtpqbNisITnRpggbWshntkgKR/tU20KWu5YCp82c8bOKd5ZafpEJgndOSy0VC305Q5IKlD+ZtRYNMmCGBrwnj+z0dlCrMohCzowScSXvNDztDg0fZ0haWgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oa+HW9Vj; arc=fail smtp.client-ip=40.107.93.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twh3iuow+UyJYWg5ehYrhhxaVfSQsGA6C9PmsootvtdB4TC8t9z7pTNLqUvQwSYfttj7o+UY9IZCEY3yZqXnm6ttJJ1h+6HM24bxoWEHvcYFzpoCF+Z4IcLPeqOEZd1X4PxaQjKbY/iE4zAx37qKFe350QMWdNRpyAijZelrm1SxYf3z1fkX7yAuSlzK/T36VpBcaBQSJnO5f8XeO/VbTFWGGAhyrU5WXmnre8c9yd+v7ydN42irY4TngyLaK5Rm6jtOrdBicHZ4LI0BIYIB723b3f0++bDs/hdWig0dAoGS3Xpr7XFgBRwas9hMbyBEy0ast+Pugd6/yuDZKPx3hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SryOG2yrUjnlmgFA8YV1AL4jCBUcBJg3To/5s3pCJZg=;
 b=NhSfpBbSxe6PncQM9E7zmcruu9AaT3BCs3i7fjqmumCrRTyDLGQ5HKY6yLwyd1LjjKyyrxloJSB+jioL+PU1dXPn8aQ9SCPZH4yVdCrr47fA8FPofzbNTxF7E/ZQz8tVciXM4As2yPc/pnHR8lzu2fOah+1Iu6EdrjgragqkrqBXKQHvDjc1T9qkhsnjvU8fInWQU+/HcBr5ZCXyyJeLgTixktMS7/+mqcIFaXyuZFIPuA9LQji+iuYsNCCbozY6chAoEWu55ufoUGvqcCLYw6Fho5ZNZCoPhE2Eucm7y6l5oGnI/sopdHSKpkLhzSZ8xs91RrF1zGV1/Rz5qDYHng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SryOG2yrUjnlmgFA8YV1AL4jCBUcBJg3To/5s3pCJZg=;
 b=oa+HW9Vj25I2wdBke36+h5XbeCQVadlPlH90hqGKwhp5wsH8hGsHKmI4kWa3ZmHxxqy15QAL+5R4RVu53SOCCyYMsnijjkaSTfEj+uA5p6JftPs2//35LU7XPf60bPzk59S7gkTEFCFk4aWH/uQl6f1WKrJnnDxjSozsgxA3bmc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB5721.namprd12.prod.outlook.com (2603:10b6:8:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Mon, 21 Apr
 2025 18:43:13 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8655.033; Mon, 21 Apr 2025
 18:43:13 +0000
Message-ID: <2db90a8a-0cd7-be70-06d2-3475ba391cc7@amd.com>
Date: Mon, 21 Apr 2025 13:43:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: roy.hopkins@suse.com, seanjc@google.com, ashish.kalra@amd.com,
 michael.roth@amd.com, jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de,
 James.Bottomley@HansenPartnership.com
References: <20250401161106.790710-1-pbonzini@redhat.com>
 <20250401161106.790710-2-pbonzini@redhat.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 01/29] Documentation: kvm: introduce "VM plane" concept
In-Reply-To: <20250401161106.790710-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0111.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB5721:EE_
X-MS-Office365-Filtering-Correlation-Id: 510de740-ae85-457c-45e4-08dd81045f41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a3dRVFc0VmR0ZEpETVMvTmV4WmtGNlE2TTg1bE1HbXFvRDkvTC9hNEhCVHAv?=
 =?utf-8?B?M1Q1NnBGSmlmZk8zc1RYREp5YlVRY1FLQ0QxYkVSdXdnWGh6T0FITFdBZFk0?=
 =?utf-8?B?TXFSUzJWYzR2TmQ4cm9SbTBwRVpvem55MlZyT2pHUklXNmx4ZlNQU3Ura2xU?=
 =?utf-8?B?YTdxcTdXcHV2V3FHVHBQVXAya1YyWmZiMWxMd3dEQVJnSnoxZ2lBV0hmeTRG?=
 =?utf-8?B?QWFQVWpkMEt1eEpWci9YL1crRnlweHBvTitsZnh6ZkcrTk95WmRjTWU5NGxx?=
 =?utf-8?B?UXo4NW5WVWJnd1V3V1I3K3BEaDlmcXZyUjZRcjdkSkhxbi85NmRoOURaV3p3?=
 =?utf-8?B?YXBTbFFoRUxkR3lmbi9paDEwMFJxbGp5Wi9VbXVtNUpqNWRCVkFVWFkzY2N4?=
 =?utf-8?B?djJIeWwvbHlFUXJ6OUR2d2tMTHBUdnl4L0tPakF2eDRyYitRaFpZeGhjVlZZ?=
 =?utf-8?B?MEFCVlZPakl0bGRnRXptamFVSVFyM1NTZXE4bXNQZk1wRDZXMWdXanBBcjN3?=
 =?utf-8?B?UkdsZCtKdmtCSXdrczB3SW1tWmlrL2hsZG9DcmlMdkpLbDhPUHc1a0JKNXFB?=
 =?utf-8?B?em1keDhQZ2lwKzBPOUlHTVdoeEYyR3NZaEtBTUo3ejZOaGExaGNuMHVTeXdH?=
 =?utf-8?B?cEUyVHpGNllpUzU3RnFybEE5eFNWOGVKWnlMMnZRdlY2aGhDcE9FMXRVS2ly?=
 =?utf-8?B?SGh5TGk1NkxzSEJ6UW4wNGgvZCtCYzJ2eXlUMndPUmVJY2liVDRzQmY0MGhL?=
 =?utf-8?B?WnV6ZU5sYitMaXEvM2tkYXJ6eUxVbm5PZEx5TzlWQ3ZWOGxWTElOVkNVejM0?=
 =?utf-8?B?VTNSUG5UZVBYMmtGNmszaElxd2JJamVyT1ZyLy9aNmJoQUVMa3ljTXZZdDhi?=
 =?utf-8?B?aGJRdE5TMjBBVkRTY2VMaVhFUWk3T240V2VmNzRRL0tSd3NsSVlnQklmcWF5?=
 =?utf-8?B?NVJTbUp5S1ppQUFpRGI3bkc5ODFOUWhtSkpWT2dTVzRnQkNBUm9NY1pzUnhN?=
 =?utf-8?B?cEg0L3BIUG44Q0ZmcExBNm5jYlU3VWZGTERCVC9sYTEvRWlzUTJyd2pBL3ZQ?=
 =?utf-8?B?bnNNeHEyaTkySlpDVXRWb1NUb1gwVXRyclhNR2x5b1JXMVNvVExHODlsMDI5?=
 =?utf-8?B?aWZ6czd4S2JGYWlRVy9aV1NYRFBWUEw3bFcxM3JDRXBRRDJUM283VnI4MkNK?=
 =?utf-8?B?R01IYVBmVExGNUNyN2gycXRXQy9QZ2xHcWtmTDJJRHErM0R3bndEcW13ME9Z?=
 =?utf-8?B?ZDRyS3cvZnZQbnB1c3Y5ZVFEU1lkM0VRVGJBN2Yzbk1TcmJRYlZwRkkvdklt?=
 =?utf-8?B?UEtsR3JBMTkrdUVnVEtaeGNORjVrcHJNUHZ4V2Y1amxUbXFSM3hsQjVJOWZE?=
 =?utf-8?B?cno5RWhSUmpCbUxaMnkrSzhtRThwL0VEdTZuNlBLbGl3K2tSMmRzSUN2RDdP?=
 =?utf-8?B?alZwa2dPYlYrVFF0M1hsS2tOM3FwMTJjbS9KR01PMmU1ZGw0ZnhONEt3ZkVZ?=
 =?utf-8?B?Z0lscXdSWURTSERHclA4VWsycUhGQU9wSnNwK0xRaEJINXU1K2NMK1J6WGlu?=
 =?utf-8?B?ZnZ5WFBYWDBBQys2REhQUHZRYitUaDEvaDVkc3JobzR5WGtJakRaeTUraUFa?=
 =?utf-8?B?TU83RWQ2Qmd2WTRFZlhpRml4NzYvZzNFTWg1eEhhdkgvUkpncVFxMTh2U2xB?=
 =?utf-8?B?bW1DNTlydWFmNnR4QmJWbVpCZVI5emc4MFRxVng0amV4WGVGeDVSdit3cHNI?=
 =?utf-8?B?QkVrUnBoQlYvZ25rWnZzMGQ0WjBzcktWMW1HRE1reTBNK092Mys4K3l0eVBQ?=
 =?utf-8?B?cSthL3VFYW1uNHYxOGRQaWM0MXE3S2dzN3BFd0JkZmE3UHp1anMveGxCUGNR?=
 =?utf-8?B?a0x0clhsVDJUa2xud0VlMHE1QkNzWVdYdU5QQ2pCUXpPL1NGMGhtMjNHelNV?=
 =?utf-8?Q?rpXemjAZah4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3h6SS84UENzVS9FOGZQSi91eWY0V1FVdlV1VzRjV013bVBaY1pNSzhiU0F1?=
 =?utf-8?B?VEY1RkNNcnhwS2pmc21FL0lldDk4eHNTKzhORXMwcUNFLzkzcVUyeS9pcDV4?=
 =?utf-8?B?eDViMmhleWsrR1QwQnUwWEllQlpVU0NTNWZHVUZnN2huMW1BKzN4SGJUODU5?=
 =?utf-8?B?RWtESG5VYzFBRUtRQkhZRFAwdWdCVXo3aUxNUVdCbjNGUE5YYnVkTVBKLzdZ?=
 =?utf-8?B?Smw2T0JVV1NXeUNaN3VER0VOTkNkNkRiTGRnZnYxa2puUWpvL2tCaE5UYnJy?=
 =?utf-8?B?bm8xN0p1UUhuRE5yNWNWOTV6OWc3dU81U3dmUDlvSXRaZnZLcENCaHJndFdJ?=
 =?utf-8?B?YU1vS1J1T2ZuQys3RnlLRHcyYlVGbUd1enpzdlpkQU9BTXVrS0ZnQVhaTjhT?=
 =?utf-8?B?c0NMZExYS2IwK0xLNldvNkhoSkVTd0RLRlBBSmFZWXg3VFArSFZsYjh6ZWtj?=
 =?utf-8?B?dzlEY3FBaFF0MjNqZUtiWVNVWkJIVmFzSy9vYmVrNkZYdW5jWWUzQXhZUFM5?=
 =?utf-8?B?ak5wZ3VnUElwVWhiWlRlZmhQMmR3N3RLTWtMM1U3STlhQ25qaWwwYjdwd3hW?=
 =?utf-8?B?WHFuMnZYSUxnMTMwbGtFd3ZyaVd4cWpHTnkvQlUyaGZBUUd5L2tEcmRISTRY?=
 =?utf-8?B?SFZpRVZDdWYrSzBwNTJTU1ZpRkxVeVlFcUlMOWRHS01RSkdvZ05WQ2dWd2pz?=
 =?utf-8?B?RG1OYkU4NXFxUmFXdk1PTWlOak1tZ25tcWp5UTBNdGpGM0NpRmFZTm1CWFRX?=
 =?utf-8?B?SlRNcXhxZE1mNmJWUm55aWx1dGxHZ2x3bHNtM3pKS05ILzRZdmh2a05qMjUr?=
 =?utf-8?B?N3RKZnJvVldlN2puU1lwVHk5SmV4VUQ5NllnWGZNcG5QYmg5QjBQVW54TkhM?=
 =?utf-8?B?VStHQjY2V1poV2xhbzlWZ3gyWGEyN1ZtaXJxRmwvbS8ySUZBMzgrbjJNOGdK?=
 =?utf-8?B?QlNuVDFJd3lhc0hLcmlna3VOWllVdklaYTJraDdjdi93Z1FURHVSb3Q4eXlK?=
 =?utf-8?B?ci9naUxrdHdndEVGMVFPektKWmFiTGxPVVVwNnhkc3FSb29DcDRKRjJuOTNZ?=
 =?utf-8?B?bWkrTE1KR2JONUtFeEl4eUlBZld2NnBUdG9rN2I2aXBuQ252WDc1TlcvaWUv?=
 =?utf-8?B?ejI0TFBIbEJXcVFreFFlVzBIVS9QcUFYcUVuKzUrRkxUaVl4MDBnOWt4UEFO?=
 =?utf-8?B?cVRRcDdlYlpUUnBPbDJ5R0dTamt4ZnJFU1RoZ2VrWnFqOXBvbHBEOFFLSFFW?=
 =?utf-8?B?bEI2VmptQ0RKV3k1TVVQR1NWc3pYRlNab0NCVDNxUGwvUHUwN2J2VlFMRjYw?=
 =?utf-8?B?Z2lPc0VtNm5kVTBzL2ZRZEhqcHV4czNhVFI4Uk5jZ1BhY0d5RlQ5ZlAzN3U0?=
 =?utf-8?B?dEIzU3gyWnN4Rmx2SXVvZ3FIREhrVE1SVWlIV016bzBjMmJJdUR4ditrdU5L?=
 =?utf-8?B?NjlUVnNUQnd1MGVNWWZCVWF0QTRha1ZseHBGNEpmKzloY1RROVpYTzJ2amxq?=
 =?utf-8?B?UzNkUFlnRU9oY21kMXlNTnRjRGFQeC9FK053V2JGdzMrVnRieVQ5TDF5aFBJ?=
 =?utf-8?B?ZUVHc3JvZDZHeU1UY2ZXSTNwdFU3QVlaeTZoRFdwTUFtNVRyaVQrb1BpdGdF?=
 =?utf-8?B?WDZDdW94S3dMMUx0R0pSZGJzSFc3VTYvWGNQM3FsdUc2SUVDT2M0RUx1U1ZF?=
 =?utf-8?B?em5IUm1QR2wxcE5kdUNyRlRCclJKeG5aQ1Z5R1FPL2tacVA0T1ljd04vQ2xk?=
 =?utf-8?B?eU9HQUJQQzIwTS9QV3lxL05BRlZSQURzdkZ5enVDSFBBTHdOc2NmVktzTHFl?=
 =?utf-8?B?Q1V1M3VWQ0RFN1dHT2Z5ODNsU3ZwR3RFbml2cFVFRVpZcmZ4cUVsT01CdjNU?=
 =?utf-8?B?aFFqV2RXRHVxQndKb0M2ZTNRV1dNSjhXcXZhRkVZV3k0WUJsTnB4MlIxdmpi?=
 =?utf-8?B?OE4yK1phNW53bFRZb3QwT3h5WWNOVHRjSGYwdGNvQktXamZpMU5EQVM5T3lL?=
 =?utf-8?B?SlQwVDJGaFM0ekJzTGF1dGIrNFNoWFNzY1E5N3FSSXcxWGRsZHlPaWx5Y0J4?=
 =?utf-8?B?b0Q1S0d6V1ZTdUdnTmxmZ0lobGxGb0tDWnUyVlFCU2pCemVPSXc3WDBkK0E3?=
 =?utf-8?Q?LHJhjEp4tvsx+YYUbZ3RBcPSk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 510de740-ae85-457c-45e4-08dd81045f41
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 18:43:13.7155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CH7oEWxE6/JkGsBJqeObGMjtJPsELi8cbxRvLxA18dD+IoZaj/Lo/Jit8wUUm3A+JybQY8f9rK15LX6h3sxLeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5721

On 4/1/25 11:10, Paolo Bonzini wrote:
> There have been multiple occurrences of processors introducing a virtual
> privilege level concept for guests, where the hypervisor hosts multiple
> copies of a vCPU's register state (or at least of most of it) and provides
> hypercalls or instructions to switch between them.  These include AMD
> VMPLs, Intel TDX partitions, Microsoft Hyper-V VTLs, and ARM CCA planes.
> Include documentation on how the feature will be exposed to userspace,
> based on a draft made between Plumbers and KVM Forum.
> 

> @@ -7162,6 +7262,44 @@ The valid value for 'flags' is:
>    - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
>      in VMCS. It would run into unknown result if resume the target VM.
>  
> +::
> +
> +    /* KVM_EXIT_PLANE_EVENT */
> +    struct {
> +  #define KVM_PLANE_EVENT_INTERRUPT	1
> +      __u16 cause;
> +      __u16 pending_event_planes;
> +      __u16 target;
> +      __u16 padding;
> +      __u32 flags;
> +      __u64 extra;
> +    } plane_event;
> +
> +Inform userspace of an event that affects a different plane than the
> +currently executing one.
> +
> +On a ``KVM_EXIT_PLANE_EVENT`` exit, ``pending_event_planes`` is always
> +set to the set of planes that have a pending interrupt.
> +
> +``cause`` provides the event that caused the exit, and the meaning of
> +``target`` depends on the cause of the exit too.
> +
> +Right now the only defined cause is ``KVM_PLANE_EVENT_INTERRUPT``, i.e.

With the SVSM and VMPL levels, the guest OS will request to run VMPL0 to
run the SVSM and process an SVSM call. When complete, the SVSM will
return to the guest OS by requesting to run the guest VMPL. Do we need
an event for this plane switch that doesn't involve interrupts?

> +an interrupt was received by a plane whose id is set in the
> +``req_exit_planes`` bitmap.  In this case, ``target`` is the AND of
> +``req_exit_planes`` and ``pending_event_planes``.
> +
> +``flags`` and ``extra`` are currently always 0.
> +
> +If userspace wants to switch to the target plane, it should move any
> +shared state from the current plane to ``target``, and then invoke
> +``KVM_RUN`` with ``kvm_run->plane`` set to ``target`` (and
> +``req_exit_planes`` initialized accordingly).  Note that it's also
> +valid to switch planes in response to other userspace exit codes, for
> +example ``KVM_EXIT_X86_WRMSR`` or ``KVM_EXIT_HYPERCALL``.  Immediately
> +after ``KVM_RUN`` is entered, KVM will check ``req_exit_planes`` and
> +trigger a ``KVM_EXIT_PLANE_EVENT`` userspace exit if needed.

I'm not sure I follow this. Won't req_exit_planes have a value no matter
what when running a less privileged plane. How would KVM know to
immediately exit?

Thanks,
Tom

> +

