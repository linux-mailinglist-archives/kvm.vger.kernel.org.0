Return-Path: <kvm+bounces-60299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C74BE8399
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 81F73567A5A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DD032860E;
	Fri, 17 Oct 2025 11:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JZuUuZuE"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012015.outbound.protection.outlook.com [52.101.53.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2886B31DDBA;
	Fri, 17 Oct 2025 11:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760698910; cv=fail; b=pN7Sqbk3gDGSIVJiT3Ia+/b4ORF4pYbtNNF932DqF7i6W4Uw3t5cAwOQjSeZxKdmGMu19tEIIsO0z2sjyIvjF6moEPxxkUhlLjnY0r/eGiG7D28Vw6bXWUR0GAXjnNPekMplBuv4pPYzdwA/pJbsRXmTg/7iS/enoTt57h0JTyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760698910; c=relaxed/simple;
	bh=HNYfmV+JBn+e0CrgHb0nRIPfAUpJFR4ZRpRVwG5dGf8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kVHLoEmoH2nQudEsPVir0yz91oNy/QDQHcmsnWbJeDzISFQKH7dBPDRzRp87biQRO2J+DIZ7zZmHDjOYT2hoaTqLWnr4N4KPVsRwIS5iuDiGcmC2WpI3CC65lW4MQdSZXXl+DHbsvDMeWI5uWsUMr3GQzu6DIxp1Rww+MF7FgWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JZuUuZuE; arc=fail smtp.client-ip=52.101.53.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UGOgpCMFOHoXFJezWK0JOymt4NL1tdJ/srb67gy9Y/ZwSW6nzYKyPMHBeHeXXshcersbrS9QRuWJlb2SvbPjX1XUxKbnE4m/oWSFgTOKPo5v0EttWfq5yUv7JEl3yI4hGudsozGQzg2+gwpwJh4lHWILHP3rMEL5VryIbDeB3tMxbeR+YTvhJZ5ay2Fux//NavNuFSxe2R8AU5LnllaP8RTsLGXPIZg+9EEvWgwPa31BvfGJlgtlzRWzSETto3oXymCwYioNsovlS59npIq/l4JO5dScBAJ1Wpwh0oXwVJgSsfGeCK/k4Qq9VuMccTyaBSRsF5cvW4uaESHWM+qTHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tVknnIIO8ogharLsKyP8Fjo64gHdZd/wYovrg88iqc=;
 b=clp7iZ0oH1rySx7UpT1nSbBqkUUAMS+6GYCJbGkszzx2ebnnWvR82baUpeX7Onnt6I8NzRsYrnhTLYWAgN7LVdQzIfZiJJ2BQU55XNy0zRl84TiPjUVQXlkwgO9YJpkhSfL0TQfk+ANhEUn3u8LPEbVi2Cq1NZDwkQfsSXXxAbKKax7Fv+2HogbK7uiIqZWW8JJQbgDCL5285dJYWZsIefEJn2Fg6/dWjNbOoYnvRdKPg/kk9zRZzKJ4o0N3GrxWFE5n85ZCxLzxlKCzoRYX3yIzCRcwSXZXIgxkvXqt2fldhRy1ezli28Hhn4pLBGBU8bVXtom1vPVlaeaknylANA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tVknnIIO8ogharLsKyP8Fjo64gHdZd/wYovrg88iqc=;
 b=JZuUuZuEwdX5tAAUzDUvsAteqr4mEdD4MEwUiVPS0zbvZbUWLCv4+OyDqDg5dH0lUyQbd3gOYeUJJ37QzmyIAE5D7GuJt8bbA+Bx6slgDi9sUa2bFn8vbGv22KJqqXA64bFLb/SUElSxrR3Uruv7b7lDOnsWb/YZug36LD5rgpM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Fri, 17 Oct
 2025 11:01:46 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 11:01:46 +0000
Message-ID: <45082f08-c7ec-4d45-81d8-5bce4f2fb0d8@amd.com>
Date: Fri, 17 Oct 2025 16:31:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 12/12] KVM: guest_memfd: Add gmem_inode.flags field
 instead of using i_private
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251016172853.52451-1-seanjc@google.com>
 <20251016172853.52451-13-seanjc@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251016172853.52451-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0002.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::7) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|IA0PR12MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: edb39a64-7de3-473e-3636-08de0d6c9065
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?elZsYkRkWlU1NXdsZnV6OVFMK3dJV2dtNC9YMjFDcU1iWUcxWTljNm5wK3Q3?=
 =?utf-8?B?b01Zc3B6WkZmLzJNd1o3WGNKUk5wWWVDQWRFeXBuNVVkOGxwR3lMRUFRRjBQ?=
 =?utf-8?B?OXFiZ05YcDl0TlowU1BVemJqdFo2cmNzZk05WHprUklvaklOVmJmQXdIMHQ2?=
 =?utf-8?B?Ri9LcXRYNEtWeU9weGpkZ2s1QUN1V3JSNlVBRWJuVmRNd3NTMHFCbldYYTFw?=
 =?utf-8?B?WUZhSDZlTDhtWUNWUEN2VHdLN0owWHAwMHQwU3I0TVNKTWZMOXA1bHV3c2tt?=
 =?utf-8?B?S1Z1aHVJeFRQZW9yODVBb1Y2eStzQlFXbEg0bjFYTnhVdTJvSTVHY0ltNmNP?=
 =?utf-8?B?VEtFaks4NzdhR3VKeWtSd1lBVExvUFh4bWpFUi9SUXJQWlR0QS9GeVl5M2dU?=
 =?utf-8?B?UlU3MFNadTg3RkJlYitDbXFBYzJtb1c4RnpqY0pnYzg1L3BkSGh5bW1pTTZR?=
 =?utf-8?B?bUppNUlMbm1OUGtTMUZaNVM3MXptSU16Y3JCeTJmRlczQ3BjMVorK3RWZGJz?=
 =?utf-8?B?NVNKU3MvaS9Od09zakI0NTUwYUxnd04xZFE1QzRmNEc3bGNaZW1LM0l0YURz?=
 =?utf-8?B?TnJtVTlQdnpkMGw0cHczQW1jZ0RINzZ3VE1EVzU1ZEgrNXcyQ09xZ2kwYnd4?=
 =?utf-8?B?WS9SbDZmcmErQjZkR0xuWVJ1L2VWSmJnaTcrR2xVMmdjRWl0MUM5cEY2L1M1?=
 =?utf-8?B?dzlWYi9qSE9pWU1lMjFKbjk1Q09pWk5Ra042ZVBNMFdrUUUySzhrNk9ESzZy?=
 =?utf-8?B?K2FFQVI4c2dLQnFPbFhPZnZrajJYSGxkdWU1dnJ2eTBPcmhMUUp4bkg2OVUx?=
 =?utf-8?B?YldneWEvRDJQZTIxZU9EZ0NNc214enhYSTVKcU90R3NFQ2hMU1luL1kyMVk0?=
 =?utf-8?B?NXNjMHpFL0ZEZW9KV1YxRkJrVjRrY2JTalEvQ2hkOHFwM1QxREo4ckc2ODdm?=
 =?utf-8?B?WTZNcUplWWFVSHM5SzNCa3B0cXFySzFlcjZZWFJxSnZoc1c4U21JL25kanVh?=
 =?utf-8?B?c0t6Rko4SUZzMTZWRllBaHRUKytMcjcrOFpoVFRzZVAwY1hCUWRkMXpFNm54?=
 =?utf-8?B?RERNcEcvWnl5d1ZWcml5aGlaRmJySXBWZURLWXZnR3Z6em15ZjdINmpldzlw?=
 =?utf-8?B?RHkyWmpIYjFxVkdmYlVVdTlxQjB1dUtlSHhEbUZDMFp5a0t2MDI5dkYyVTVD?=
 =?utf-8?B?Tk9uTnZkcks0ZTlURmY1Ukk5WHEvZ0wzN3VlQVFRdkdBNGQ4YkNoem54NElh?=
 =?utf-8?B?aFdBY0VOYmZxS1JHTkdlYUREcWp5NzVSSmNHV0Fway91cFYxcVJvbjVRV2ZO?=
 =?utf-8?B?Ylp2bjJlV21yaTBJeHZLejIwajlUSzF2MmwvcjNlRTBIWGYyYndKd3hsREJE?=
 =?utf-8?B?TzZ6Z3F5WWlGTWNCWWh1bXN2amZsWUxmYitOdDNhczdKZGppL25WUnhXTGxk?=
 =?utf-8?B?VXdXYi90ZEJaTkFiRTJxUTdPNDhqa1F2OGhQb01sWExWU3dCNDJFODUrVFEr?=
 =?utf-8?B?REpLWStsd1FpR21aMFFUMzRJT0xpZjltc3F5aVJmdVgrRjJRbnlPTWZ3MDZE?=
 =?utf-8?B?cW5iN2w1ck5SQnZ2K1c1NzFGUEZLVUs3d0JWYkhCQmZlME9lWGVOMU9CWEMx?=
 =?utf-8?B?OXFCaEUyOU5pcWh6eEpudVRmbks1RXJMKzAvQ3k1Wnh4L2dRbjg0SVNEK3Vh?=
 =?utf-8?B?UVZqWmtldWhQaTdEMDRHVU55eGY1VWV1bmZlNkFKbjB5TGZyTUtNZWVVMmVO?=
 =?utf-8?B?WFlLSVhTKzBLT2g3aUVFRXdoTjJvVVR0NVlCSTJ4NlZ5Nm0zNUw1bkM0YUxy?=
 =?utf-8?B?cm80SkxTUEJuQmE5Y05FS3JDejkyMGVHZG91K2ZzaXFoR2Z5UHZBQW9SRmRi?=
 =?utf-8?B?VjZtM1o5WnlJckRidzNBU1BDNHpuQmlJejNGNE9pS3g4MEJycDNhQmlWaGg2?=
 =?utf-8?Q?9ZD6Kxhy5LaTt2Gw+CUrZ5+gt4rMJM7c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnZDUmRQaW9CZncwckRDblpwZlN6eXo0d2xPUVY0THRKWTRzU0xNWjhFMC9a?=
 =?utf-8?B?VXZJZTI5S1k1VGZDVkorVXhyTzY4bDRlRW9iNGtHalg5YUtRdzJLdWhiOVhF?=
 =?utf-8?B?VURrQi94ZjBPMWM1aTBlMkZYUVBKUVpPbCtRUDRyN25ONmh1QkpVNEFBYitN?=
 =?utf-8?B?S2t0Ulk0M0YyNW04MXdYdGF3RFZwR3lwSisyMDZsb1laL0RMMXFINUFXemNY?=
 =?utf-8?B?M0VrbnlDemEyMzFla1BIRzlTNDBJU25RTjc2YXZEMDg2TkN6WlRtWVRFL1FP?=
 =?utf-8?B?OWk1UkVTQ1ZKRzlYT1AyMUFNeTB0eGZWVldSWXpwZjVkWEIwNlhoNHBCZHVY?=
 =?utf-8?B?V1FEc0l2YVMyNGdxaVprSjZLYVdwWE52NmJub2taKzRVUm53UEYxZ2swcTBM?=
 =?utf-8?B?N2RYNjl2OWdydFJ6cHpZSkNvcnIxMlZyQ3J1N1QrbkhkQlVIMUpxM2hXYXRw?=
 =?utf-8?B?RTNjVjVWVUEzd2Q5Znh3eDM1RWlSb2FTNnlCMmdEVVNSNGxYZitCdzlzS2cr?=
 =?utf-8?B?T0xuK1RQOUlrNlV3OUpzWGpHTWtTRFZ6S0ZheVp2dUg0UXlkMm5VajFsMVkw?=
 =?utf-8?B?cGF3S25SekFrQzB0d3A4UlVaUExTayt4UnFZSXJRL0VSVFBPUEZvTVpzOEQ4?=
 =?utf-8?B?ZXpGRkZidEQrSjBGaVYvTXdTV2cxSk1JYTVVc0pORjJ4czMvSHlON0hqd3lP?=
 =?utf-8?B?YVNIZGZGNlZneUtRMDQzMWZzZjNva2JQbVY4Um4yc0tPQkpNQ05VV29SejNv?=
 =?utf-8?B?cEpxQzlyaXJvWnE0NVVGNnFTOWlkR2o0TVA1SFl5MUVldlpwUFROTVRkSDFU?=
 =?utf-8?B?MDRrb0pKODRHemlvUWVQVnRzNE5JTWxHeEtFaFg4Y3huZEkveU1kb1kvK0tm?=
 =?utf-8?B?UEFQNWhUcnllWHNsWUdEWTQyMGsrdFlISGNNYnZnODh3Si9pZUlnNDFSUkly?=
 =?utf-8?B?c3VsWjdFa2s5M1BTQytxYktBUjFPOFNhTWhrb0VxNGUzdFRFWlZnMklWMXdz?=
 =?utf-8?B?QStFMTR0YWFPVHBxSytUY1lldnR5MjdDMTRLNjdkZGwxQ3VrK0J4L0pZRWh1?=
 =?utf-8?B?TVNmUytoMzVEL25SK3R3TGlFS2lzaklPSjNZS3ZId3RtUTkrblNYaUcwVis4?=
 =?utf-8?B?VERHbVRkeWlBSWNZYURVZHhMNXZ3aHBaUkU1WmRXOWgzbHFvSW5QVE4wNC93?=
 =?utf-8?B?dkdaVExmU1VMSUhDWUZyUVl3Zk81WEdiZFFpSU5qdzczcW5FN21sNEFiQWh1?=
 =?utf-8?B?a0hicHM3aEtQbWtBQmVZTklnVk9GUDFWR083djRZbDN0NUdYQUduRS9mRXJh?=
 =?utf-8?B?ODNhVHVHZzB1M1pBRXZEc2VwYzNLcHk4N0Q1dUtMeEp2NlhrNkQvNnU3R3Zu?=
 =?utf-8?B?YXRySjZrOE9wNEVLM044Nit4a2N5T0pKSW9haDFFaTlyWlRpcjFEbHYvTUxG?=
 =?utf-8?B?MDFqejM2dE9tUFpoQ1JMQy9CZ2RQRzJPQU4rSWZNRWx2S1hqNWJOckhRNDRI?=
 =?utf-8?B?Z3pPWmJUMEFpZ2Jla1p3UDNQdDU5elpBYmJ4Ulh3M0U5U3pZL0xmR25HazUx?=
 =?utf-8?B?d203dk5Ba3JzaE0rWDUzWnBNSG8xSWhnakczVGRoRnI2T1U2QjFSN0hsQU5F?=
 =?utf-8?B?bDZvcTV5RFFxK0RrNWRpY3V4WElFbmhTalJOV3NIY1B4N2tVTzNjanNnVGpK?=
 =?utf-8?B?ajZLYi9SYkxFZDFXaDVLSXNqb0YwQ1VhZFIxMG5Xa1VRU1BWSHZ5S0NYS2hh?=
 =?utf-8?B?Y0s2N0NKdEtLVDFoVGVVZ3ZzZzNvN01lZXFPNUxKL056aURzSWg1VC9Wamlr?=
 =?utf-8?B?NHM3SCt0MnRaZkdLOTNaSFBBakhkc29ZbXArcUFNNUdkVlZ2TnhSM1FEK0p6?=
 =?utf-8?B?N2dKK3JTd3pZak0xTEk5QTBtdGc0MW5aUk80b0lMZm4wMEM1Y2toaU9aREF4?=
 =?utf-8?B?WDNkaGc0R1VwbG03UHFoUkZnb1U1NEZ1dnBycjhhNlhobWlMZUZRaWFmU1lG?=
 =?utf-8?B?eUo4alJmbFdMS0hYRlV6UW5LRXJ5Mk5sTGtobGdXTVZFTGhza3hqdkxMQTd0?=
 =?utf-8?B?V2tuUHJ1ZDVnalovc0xOOFFVcXcwa0orMTZhZmo5TkRIZ0JmT2pYWHRGK0tN?=
 =?utf-8?Q?h+amwGKZEUm8zPeWtznumKBCR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edb39a64-7de3-473e-3636-08de0d6c9065
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 11:01:46.5271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51EFmnNhRXnLQ1gpZo5peErJtvY2eYg30naF4g/QHi1tT8fAh6/wedSCmKPLdd2N1ug4dd/LzjKnh5f9/ezaUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8374



On 10/16/2025 10:58 PM, Sean Christopherson wrote:
> Track a guest_memfd instance's flags in gmem_inode instead of burying them
> in i_private.  Burning an extra 8 bytes per inode is well worth the added
> clarity provided by explicit tracking.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 4463643bd0a2..20f6e7fab58d 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -30,6 +30,8 @@ struct gmem_file {
>  struct gmem_inode {
>  	struct shared_policy policy;
>  	struct inode vfs_inode;
> +
> +	u64 flags;
>  };
>  
>  static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
> @@ -154,7 +156,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  
>  static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
>  {
> -	if ((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED)
> +	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
>  		return KVM_FILTER_SHARED;
>  
>  	return KVM_FILTER_PRIVATE;
> @@ -385,9 +387,7 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
>  
>  static bool kvm_gmem_supports_mmap(struct inode *inode)
>  {
> -	const u64 flags = (u64)inode->i_private;
> -
> -	return flags & GUEST_MEMFD_FLAG_MMAP;
> +	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
>  }
>  
>  static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> @@ -399,7 +399,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>  		return VM_FAULT_SIGBUS;
>  
> -	if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
> +	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
>  		return VM_FAULT_SIGBUS;
>  
>  	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> @@ -588,7 +588,6 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  		goto err_fops;
>  	}
>  
> -	inode->i_private = (void *)(unsigned long)flags;
>  	inode->i_op = &kvm_gmem_iops;
>  	inode->i_mapping->a_ops = &kvm_gmem_aops;
>  	inode->i_mode |= S_IFREG;
> @@ -598,6 +597,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>  
> +	GMEM_I(inode)->flags = flags;
> +
>  	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
>  	if (IS_ERR(file)) {
>  		err = PTR_ERR(file);
> @@ -917,6 +918,8 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
>  		return NULL;
>  
>  	mpol_shared_policy_init(&gi->policy, NULL);
> +
> +	gi->flags = 0;

I initially wondered why these are initialized in kvm_gmem_alloc_inode() 
instead of kvm_gmem_init_inode_once().

Your comment in kvm_gmem_init_inode_once() made clear to me.. The ctor runs
once per slab object, so  gi->flags wouldn't reset on inode realloction.
Initializing in the alloc_inode() ensures proper reset on every allocation,
Makes sense!

Thanks for the detailed comment!

Reviewed-by: Shivank Garg <shivankg@amd.com>
Tested-by: Shivank Garg <shivankg@amd.com>

>  	return &gi->vfs_inode;
>  }
>  


