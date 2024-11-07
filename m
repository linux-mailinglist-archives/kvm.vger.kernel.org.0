Return-Path: <kvm+bounces-31055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCD249BFD00
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 04:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 175CEB224C8
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 03:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3F615B0F2;
	Thu,  7 Nov 2024 03:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f+UfV4xQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3472F38382;
	Thu,  7 Nov 2024 03:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730950419; cv=fail; b=JY8L5epnWVVUMWZ0wMxifeLLa3aQmM4zvKwwHFA9rU1eqp1mWcTgEpowd+IiaegDmYHIh+u46d++H73KUn8f16LURpmW/s5pYF8wGr1ut9xTTd//RXOg3upQWi0nYzdR0H19FrmG7JN96MVK9AbYS8kevk9FHlAZ9yIL53RNDj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730950419; c=relaxed/simple;
	bh=M1ZJ7WNEchAtaOgPdAbfdFkAD3tW+A/2QMFZsJS8MrM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Sy0wApmA0fIA54FnEbKESMzmpPODcAl6iYnWmRdHGrgedJVvYcE8T+5oE65eym/d5SNKdZdkggtdXtfe0kU+HJH3ZD7I56HH6SdEEFdIzKjWFiW8RCeV363/BawTP0+ECWb61iPpwg1lLPxH3cX5p7t8YJybwsK5NSk/dEIG5wM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f+UfV4xQ; arc=fail smtp.client-ip=40.107.94.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VLeffN9ZumJTv0KyQDwvi3UIXVlb+d2y6+19UbhSz3umVaxLuZ0ETrFAPN/5LFegglQn0XfzWNRVsHXCNmP3r/HybjqDJ1y1KKcyM6pEE67XonYj1H9H06fD7SPt9EycW1LE4iqqkHv/MkXWlFcyucELEI077q08JT4hVyvWEGux5zsOg9P0cnaEEMjMFjgQwYD68q0VGev2xVploCYtinDK4M/c0OEr1Kz8cI0ly/UwOuh3sNAj4IMY4+5QE+bf3wvfgkub5beqkx5eB+JwMHHy8/3Bgv5E8rQxY8PPrH1jrVofmI5INciAHQBCyazBPuAbETqNVAwxJQM6Xa+IHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rEXk3v8dQJpxBLEH3VX5fhsBcfg0Euttu4swoeK3Nt8=;
 b=XX0zgi55VErJtQIQXgFEdYPcUt454++KUpsxBuH1XwMKoOfA89QEOxiGS0ROf8vG+j9LUqpTQlNbyLGApdNBxBYZOY3bkI7t7qoIX4OqmwczPs/fgfvcnqpyjjmnItgiaT1IuSHyF96A5Ch3gvYIs8u8kKeOPcSEnZsuSlr+5+D5GAjb9MK5Wt4+JL+uAvb/ckNCNn3Weh/AefBCaXrF1u8OmTPPVASzmN+Holabtljwz3jIUGhXpstWB66amgoitrxuK3r7yfat/qb1P/zEkkMNN3+h0QmK8Jln9mIr8SI5fUoHXMD1CXMDY2OYmO61j+rBYnIRV5tj0YvWkp28ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rEXk3v8dQJpxBLEH3VX5fhsBcfg0Euttu4swoeK3Nt8=;
 b=f+UfV4xQwcKg4We/YjoTScnibyUVHV5JVxt+O8lvs+3GeXgqB0tZFq5RdpMDdfTL58zDM3mcgeSjkcL4yt3xFn5LclFagiH7qfwYCcY0e5WCOh/CMQWlm+9M51jKgc50y+ds9B3zoOmUpEHnvWxZUvgye1s8ap6aWt5mAkzfi6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 LV3PR12MB9117.namprd12.prod.outlook.com (2603:10b6:408:195::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Thu, 7 Nov
 2024 03:33:35 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8114.028; Thu, 7 Nov 2024
 03:33:35 +0000
Message-ID: <599c8b26-0a9c-4ed2-9e35-be51db27a6f4@amd.com>
Date: Thu, 7 Nov 2024 09:03:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 03/14] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
To: "Melody (Huibo) Wang" <huibo.wang@amd.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
 <de5905fe-214d-4740-8b6d-45386efa50ca@amd.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <de5905fe-214d-4740-8b6d-45386efa50ca@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::20) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|LV3PR12MB9117:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d8a557a-c63c-4701-e7a4-08dcfedcf63b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEJFTlBkNy9xR1B3cVFCd0M5Y2dMa01qOFBwVXJwRlg4eGhnN1lFSjJzTms5?=
 =?utf-8?B?NmxGK1FiWXZBb3EvODJPL0RHcmlJbVd3Um9iaVRRem1qUXU4dEI3bytHUHYw?=
 =?utf-8?B?TnNCa3ZqMGNYNmV5RzErc29QT0g0T2VSSlVjWkNoNEt6NzV2T0pRM0FxM1RK?=
 =?utf-8?B?cEJCM2E5RUVCdnRHM0lOOEI1NUVJVzd2K056TEVoWDZObkhBellJeHB2ai9C?=
 =?utf-8?B?YVlvR1R1cjBob3UyNW80a0w2UWt0b3VPaGtBRFMwdXFLbFhya3A2QlU3SWVa?=
 =?utf-8?B?dTd5dTVJVXU2YVVmdzdUYnhCRmZTcWFrSGlObzMyWUJoT3lVRXIrbzd5THFI?=
 =?utf-8?B?RFVIdzVUbnVTUGtWZjI2UTJ2cTN4Y24vSU1USXljWDFZV1NKV1VsQTk5dmdQ?=
 =?utf-8?B?cWZkNzN2b2t3aXZHZFVuK3creU9WWnZNVEJjZUVqVi9wd3JDNk5KNW9JQWhQ?=
 =?utf-8?B?QVZPV1FoYTV6YitFRTNQSWtWTGZmak02VnllYzEwNytmRzU0bTZDaUFHRVNJ?=
 =?utf-8?B?MTQxamd2UGRLVTEzMHFHcjJuNUVxWmcwcHFya3NSUnN5RVJib2VIMCtDSkZZ?=
 =?utf-8?B?Zm0wSjhqQU50WjRCUUtYR0locTFtc01CZHR1eEs0K1dKWDBHeHBDV2diUjhq?=
 =?utf-8?B?VmJkcnZZL044WHpHTXpzTWdNOEt3KzhNdmc0d21RMWVsV3BUK2xwTEkyYzVt?=
 =?utf-8?B?aHE2d0gyeTlsWjFYMFJHb0p3V1F5eTRyYkN1Qldad2dhRUZ1ejV3SzhOVjVY?=
 =?utf-8?B?THRWRk5mM0M1REpFSVIrNkozaGZod21nZnlFcmY1N3NCN3VRa0p2STAyRzQz?=
 =?utf-8?B?QXNBNVZjT0F3eDFIU3d1UXlMSzFvOFMyaEVTblpIcUcvYWFVUmFIbldiS1ha?=
 =?utf-8?B?QlFuN3RyekcweVNJWE9IVW1UMnpYYjJNL1lJeW92QXV2a1NHM0ZKWlgrcHJS?=
 =?utf-8?B?dDRaaStqU0FDY1pBbnhtTWVIUjNoUitrVXlOclJtRVc5WDhDRnVMa2dseEEx?=
 =?utf-8?B?cDlpdExhN01Na2JHVnNGK1dFeGRLQ0RsU1RFVzg2Y2trQXQrTlBqL1ZTQ3N6?=
 =?utf-8?B?a2YyUWR4NWNWYnJWUHZ0UitWa1c1OGpTaWpMUnZwcFMvWXlRTDdYTEorbWh6?=
 =?utf-8?B?Q1p0S3BEZHRyUWRmeHNwWmZDT1FPcnVRbktWbi84dnBFZmlaKzRpcXJ5Qzdl?=
 =?utf-8?B?aG03cEdRQ1kvNGhIcFh1dm9SMlRmbFJDZkVLc3lKN3dzYjRWdjFUUE5zbTNF?=
 =?utf-8?B?UjJEQkhwTElVQmtxSWc1Z3U4UWVTbkZSVzFSZmJoZXZRTmFVUm1iekxWRUVT?=
 =?utf-8?B?aUVnbXNjMTB2bW1NVkVvODVyT1ljYjhBdGxDeGdhOUJRVlJZNGVNWk5KQ2VN?=
 =?utf-8?B?S1F0VWtMQUtZM3VTUU1vT3FtbUhTQmdQYzl4YmR1bFZGUnhwODBGWmdhTGQz?=
 =?utf-8?B?MFlwcTJmOTJaUXdCa0NmaUZpdVhhRmthVVQwbUJJNURBa2M5RkEzMFd2ZWJH?=
 =?utf-8?B?enRpRnVEM0FzVmo2czhjVENFdE1YY3d4U09pSm9ZYUo4Z2VNWU8rdFk4NWxB?=
 =?utf-8?B?ckY4cDZiMXV6bXNpN2NjS1plLy9NUldRVmVWcGxnaGVxWnovNzRqMmwvT0l0?=
 =?utf-8?B?YVRaanorYzE4SWlQNWtGc1pWSEhxVjF5L0Z5dUdVTnErTHBFVUExbytqcFFq?=
 =?utf-8?B?Y1FqM2s3Q25zZUZwWUhmeWRCVkNhTnoyMzJNcStTb2lEV2VBbFFabUF6ZTNx?=
 =?utf-8?Q?5an/vH/EqOmoYT97e0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHpDeVNtQ3VVNVM2Yk9XaUh6SEZ6UmYwYWRMSkxJMGttNnpvelhPWktTdWZD?=
 =?utf-8?B?UGkrR3VyWHJyQ2dXQkJjSjRKUFEzcVZWRnJlSDNPdHh1U0g4TXcyTmk5SHZN?=
 =?utf-8?B?ZXcyYU9rbm83Q1ROajJLMXUvK0hYbDltSFkrSFBvTk1mTDhOUnJQdXBwUExS?=
 =?utf-8?B?Q2NjUERJSkR0b3luM0ZUNU5keVhWbENyZExzeDIxR2tuKzUwNlF1SjhIcFAz?=
 =?utf-8?B?MC9rM3JrQmxJQzlEa3UzU0Q2RTNUTlVxZ1FrVk01SHh0NUFkZ3VSQlpSdUtz?=
 =?utf-8?B?eHBGYnRWeFpBRGtYOHRBRSs1QVpHeTFmSHlXVDZIalVwVysvdU9mZ3FCNklV?=
 =?utf-8?B?TjltN1NNdkNvN2Nxbm1ORFh2eURLR0l6eDBFSFRTa0JYL3pTeUFHWC9OYVZa?=
 =?utf-8?B?VmNXaUVaKzRqVU56d0pzQndOSld2QTZoT0lybEQ1UG4wcFNndUJ0LzVvM0xr?=
 =?utf-8?B?dk94R3N2a29tNXhIeWhaS2xkdGc4K2hsYkZzOHNZcVl2eW5kS0wrYTkyS2V5?=
 =?utf-8?B?d01uOFc1UVhPdlFzQWpLMzZIbjk0S2k4OExCdTlKSGVDK2QxaDRRdUx0OEU4?=
 =?utf-8?B?VE81UGhMSzQ3K2VBUlF0bmFMczEyeFlzR2xjWXhsY0p1ZERIcG9nQTUwNDdE?=
 =?utf-8?B?dzdkb05HS2tLTkZEQy84VHl5YlVRWngwWFIzVHFUaWhTd3JHQWRjZlhDTGMy?=
 =?utf-8?B?Zm1KaDdXMjU2Q0EwcjkzVEhYSXlDNnFwZlFPcVdpd1J4N3NVbk40bTJRbnlh?=
 =?utf-8?B?SEh4eFBDMlJCQ1B5UlBuOHROak02bWl5SzUydWYzZ0M4Q01JclU5RTVWN3NP?=
 =?utf-8?B?ZTM4RkNPL2J1UzVXWGtzY1lMUWZGZWpveWMrVHVscGp5YjlCUmxySk1VcUhu?=
 =?utf-8?B?NHpLUTZFdTNNUkdUczZrajU3ZmMyRGpaTDJvYjVLREdDRzJTc2Yzbk1DTTZL?=
 =?utf-8?B?dzBVRUE5SWhlMGhtT2ZPZjE4amMwcVpiYUpMUzZLaXZ1M2ZSK091K3Z1SmU1?=
 =?utf-8?B?dGFGZ3FWb3NDWkZ4a1g3dFFGdFFoczV1QXoxbVVKNURDRGVYVzJ0TG5tU0Ur?=
 =?utf-8?B?QXJRbm9tOUdsZmtRTnBnbkIwdzRvbmFtalRTQVpnU0pJL2p0NWpKeGxHYXlM?=
 =?utf-8?B?MFMxWkJvc0FyN01CZTU2amJQblpNcE9MU1FmZ3E2S1E1UklHRFNLdUtBTzMx?=
 =?utf-8?B?TFl2eVNOTndLQVVZRlQxS21Sb1V2RjB1aHZBWmk5bThkOW55dXVwWWhxdFdY?=
 =?utf-8?B?T3pBeUFFU1VjOSs0WDBNdGhGZ3lNZlh6cnd0b1pOODlJYTlWUDByQXdpYUs3?=
 =?utf-8?B?NjBxK0tvU2FkMTF4R2NwMFloMkVJOC80cTkzODZldTVYNlYyU0UvakVuNGNI?=
 =?utf-8?B?VkM1SHM4a2Q2dlNRV0JZSnYwNk8xVjI0cWhxc2hpMVRSbWNnZkRWV2F5bnNS?=
 =?utf-8?B?Mk9iSWNlVGdHTkd3UktkcXBZZmI3SEdrZlR3QU5XUHV4NVk5K1RrNXhaV0ND?=
 =?utf-8?B?aGlQTmM2aS94L1ZHMTN0L2RzRWhkb053NCtrL3YzaHFJdW1kSHdLdmZKRVBX?=
 =?utf-8?B?Zld3OUxEUFlyR3FPcmplZ2lRU3Bsb2htYlpicUhuQWpLKzl4OWw1VDFVSUhx?=
 =?utf-8?B?RmVpRXJWNDU0WXpQelpiSWVpRlJZaXFoN1ljbHZrVXl3OHNaa2VnWWd4RzFB?=
 =?utf-8?B?aVF1V0NKdGNlMXhSUUNKU3V5VGlNdnVXVlFRQ2VORDg1MXI5eHQvZ1huNWNY?=
 =?utf-8?B?RktYMGxCbGJGR0JiaXNFZGo0WlVwSVZ0ZDI3RnlmV2JydVIrRjdGaitKUFlS?=
 =?utf-8?B?Q2NSSG5idUk1clN1bktlYjZucnVRaUdlZ3pIYWNXb09KZ1N0QWpYQXFuQ1lZ?=
 =?utf-8?B?b0x6RkxMZ09GaFQ2SThaUjBDNkVEdmFsakppbjFoTm13UTlDeWVKaU14WExF?=
 =?utf-8?B?RkFJVHBVMklzZTlzRlNiUytjbXJuc204c29WSXQ5WHc5NUp3ZVJzdHN5RUpo?=
 =?utf-8?B?MEgxck9VNXd0SWdXNzlzdVBHRnZSWXhFbFBzSStTcFRPNXhLVjVyVUpaY1Zp?=
 =?utf-8?B?NlBsSVdaQkxveC9VWU9SUERpTVNyTWxVYTFJTU1vSy9hamQ2YkQ2NlIvMm9u?=
 =?utf-8?Q?/JnGiY7QZbkHeJ8Q3p72DXyw6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d8a557a-c63c-4701-e7a4-08dcfedcf63b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 03:33:35.8345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWyNsbMlReF9KBRfPsD9BQgDwz4WboPhfMyAZDAG2Z1rptyau84N//rHNbJIhsC5mR3LNW9IDQ+weoMnpNXaOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9117



On 11/7/2024 12:50 AM, Melody (Huibo) Wang wrote:
> Hi Neeraj,
> 
> On 9/13/2024 4:36 AM, Neeraj Upadhyay wrote:
>> The x2APIC registers are mapped at an offset within the guest APIC
>> backing page which is same as their x2APIC MMIO offset. Secure AVIC
>> adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
>> within the IRR register offset range) and NMI_REQ to the APIC register
>> space. In addition, the APIC_ID register is writable and configured by
>> guest.
>>
>> Add read() and write() APIC callback functions to read and write x2APIC
>> registers directly from the guest APIC backing page.
>>
>> The default .read()/.write() callbacks of x2APIC drivers perform
>> a rdmsr/wrmsr of the x2APIC registers. When Secure AVIC is enabled,
>> these would result in #VC exception (for non-accelerated register
>> accesses). The #VC exception handler reads/write the x2APIC register
>> in the guest APIC backing page. Since this would increase the latency
>> of accessing x2APIC registers, the read() and write() callbacks of
>> Secure AVIC driver directly reads/writes to the guest APIC backing page.
>>
> I think this is important non-obvious information which should be in a comment in the code
> itself, not just in the commit message. 
> 

Sure, I will add some of this information in the comments. Thanks for the review!


- Neeraj

> Thanks,
> Melody

