Return-Path: <kvm+bounces-71904-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PHzDUaJn2nMcgQAu9opvQ
	(envelope-from <kvm+bounces-71904-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:44:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F33019EF4B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:44:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C796309606B
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5C03859C2;
	Wed, 25 Feb 2026 23:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JsIbYTEg"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012049.outbound.protection.outlook.com [40.107.200.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05533803F3;
	Wed, 25 Feb 2026 23:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772062985; cv=fail; b=mUMoLT1l5Uw665BVcSzoi9QTVmzFZqQoz6CTD1Cosad+UZ73icuSibAhUQpbpCEPpKy0NDlaZ+gfqO3pRYO23r3fqVo7tS4Hd10Aa+BRnnE4hiyL8zxQSVlhagQURTjEXCaUrBr7xdZgVm4JGHoBZYe9N75Ez5tlwA6qRmmjVAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772062985; c=relaxed/simple;
	bh=1kxKxf5negGjsP/kZRwSTytQhXDD+XeNBnLFAuMhYh8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZYAB81TnlZEwDSq3YH73l8svFLDsNgSktQ/hJYd5TLwvbym0PQd6fpvxErKnC6LBiWw0QUoe73WQWeM3ERjvxnT8iw2WtapkhAeCMGjljEcEvpt1v+//XIvugp33zy9uLkI3E0Z/ekUDmc+LVyhoRaXV3UsXcwZKqcBek0QbJZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JsIbYTEg; arc=fail smtp.client-ip=40.107.200.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=blPKEq2IJb+bg3Lx408ExKOnG+I8au4lUXAyCmx/DK9OQteO48wRDg8mBBufvr2h8g2icUUVhYHpPXUSffD7U9CbkKR4CnhhUGOwVUU+njONBaZtJKBtSE3AJgIVssoOIdUBrnHJGDRKTuvIC0SVfVcpIPhktc1ek3slns2AFfLcVk3XjtujfdsjoXeLWJBC5zIf3gSrQSApUnZCcmY/Ts1HSSRq3FVsRNg81zE1bsvVHss7iSZe6yws99X/r0nirh6GnS/1pbQP9MIpr27WMbXIx6lR/T8qwW+dB6dvtYP4gfYJRV8RigI/kPANQrmt2+3eu0jlkdw4vNnbmhCVWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i421onDldOFho69s1WRwV1o6OldqUDI25mpKGMr2+IQ=;
 b=esqbwyppJxsp2iujwNgzYmPDqPmO8dIFFSgZV35M5/bvzJFvtZ+AZ8Nfb8ic7oyO+gm5BPEYFj/8OIiice4ghfP2CLMqJeogCmy3cITg8qf8k+eEA6GMwg9lRrcoWqtySkvSHPEizVtJxNxMvj25ZLXHJMSMR2D2NDR3IdIN/EzTIP7XR8KTSssbmK9wQxfxCd4ncVcJ6CYa07MLk6tKxqXX1NAkpecMD1ITmciNVOcIFX2PLwIqKH7hLKwg1efgXoWxBOR4mtcv9GZySzyyv92gBMYpWlr6t2+XRaYd962b9Hy+ds3HV2JZYgLYvsU/L5z+FyHgnLYjT15I5SuNKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i421onDldOFho69s1WRwV1o6OldqUDI25mpKGMr2+IQ=;
 b=JsIbYTEg6ubO0WrvC9r2c6htm8hZiqlXzHu8vqc8TJAawFtQiLdDuicOc6A1anobttWIaYdICvunOqNy16BgsJS6atT8K0TjNsfuEVwoX0d+DwwhqG9hlTfSWBrvza1JFhJWJ/qjXqzDkopZ783D0/KvCRWVZ+nzMhJF2CdINE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ2PR12MB8649.namprd12.prod.outlook.com (2603:10b6:a03:53c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 23:42:59 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.007; Wed, 25 Feb 2026
 23:42:58 +0000
Message-ID: <4ce3cd1b-dede-434e-b55e-feca647f1e0a@amd.com>
Date: Thu, 26 Feb 2026 10:42:40 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 2/9] pci/tsm: Add tsm_tdi_status
To: dan.j.williams@intel.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Mike Rapoport <rppt@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Stefano Garzarella
 <sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>,
 Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Tony Luck <tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Denis Efremov <efremov@linux.com>, Geliang Tang <geliang@kernel.org>,
 Piotr Gregor <piotrgregor@rsyncme.org>, "Michael S. Tsirkin"
 <mst@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-3-aik@amd.com>
 <699e97d6e8be7_1cc51003c@dwillia2-mobl4.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <699e97d6e8be7_1cc51003c@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0121.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::10) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ2PR12MB8649:EE_
X-MS-Office365-Filtering-Correlation-Id: 8750517e-8c79-4a7b-a895-08de74c79b3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	TXCeBTfmHneuPoXzuT1+/5Om67FbtOigOQaiSecW/ucxQbiE4bT6uYrHkvQZI/Ks3C/D+vP3dphi5UHeGDCHpTH31qD3H8wixydbIxk9vLMpB2Pd/7D6IaZKgiJIY3lwvXihwcUHovZHQ4FUxrdhRCUPycaiEqdEVQAERv4jj5jxDJLwQ3WnMQ6ntjFQFDNVttp1wnNG7aP2M1rbZs+yiw9E+CRYb3mwjF86NfyR6bqpH++gN4UZCu9d0lOMYQ6FIZuNjm1SLsiQ8Gr0R42eSIs4Tea/Jmzu1TkCRQZ/UEvMjfGS9JLfWdWoKSgTlJ+crZeGCTbXx6cxXPw68KKK9bMnVbgCsDBDaP0Dn7sljopa8wRpSJoSdHvo11rdHEo7PGUtoc0Y0/C2OQe3Ydh+7swxtMzysGTrfvZSqBcM+QX2Plk6R4SYsenG7Ne8PtQg4db0iDrADN2sXnKo02n3cDM9NBNvyXU5KDHmWTj1HvZn9fic6XZR2D37vEsaORSQrm+yNoJyTdiIBOWG2kQBb1NCOq+MKWH5VoOxRTjgziTKZR9eWBQveCYqjdpETm5m6IJIzjW4aVbSCvI7jTJCU13ZlD8GGWqLAfKnBwvRHYyfj3bKwcU3B4Kd01F9wkBmG/q/2gklAQUriHwUk7pajJtLbKl3OS/G/Mb7XFP0MQZQZ6WaUO7xTzlvDmxmfymlScSV+M0VXfuH8wPD83RIffCePrgQ2hY47AcEotvNUh4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUkwd25FQXp4LzMxdzhwakdqVFh6di9MMTR0dFpnbXBIcnl2UjRzZ3ZYc3RT?=
 =?utf-8?B?dGJ6Q01mOGVjQkc1dmp3bkY2M3ZuSmRyOExqNW9xMlF0MkIvUUlLRFBsZW92?=
 =?utf-8?B?OEQrYnUwdS9HeXAvTXZVbGJaSm9jRFJBcmlDWE4wQTZTNmU0THdna3QzQ1Jp?=
 =?utf-8?B?SzBjZmtDbXZvSFNRZWlhQjZZN1hJRnJtY2dMNjVXSGthY2pxdG5mNERPOE9o?=
 =?utf-8?B?Q3BMeS83YzVkc0ppN1J5a0k3VTJ3WDQ0S3RrK0hTdE00dlpIL05sVVFGQjBL?=
 =?utf-8?B?aWFKUG9LMFdCenh5czFiOU9GaVpyUEpHY3hiOHdldk9JWno0NEpDeHk3cXBh?=
 =?utf-8?B?b09tV2J6am9CeUhIM08yUEFXQzE1RmtJRktUMXhFUCtZTWErMHBPcS9RZ1M3?=
 =?utf-8?B?K09IZzJ0cVZYL1VOWk5aNGkvYnV2WEM3WVJnZmwvdHB0Tk9zUXM5ZU5YOFZG?=
 =?utf-8?B?cHZzcDhLcXdwNnlpT2Q2WnpEeE9IKytML3VmalNjeldmZzdGK0JIMWprT3pX?=
 =?utf-8?B?ZG9OOFR4VjJOWGVNS2htQkxqZzVKUnIyancyTVIvWmFsV0R3bHFRbUh4MU1B?=
 =?utf-8?B?dzVXRlpVc0Zwd3AzRHdDMzdXYWpuVDJycExJemhldXhaYS80TlBaSXJ5THM2?=
 =?utf-8?B?aTVlSmZPeDZDNFlJUm9VR0J2aHFiUDQ4czJlTCtyM0hSNE9RWlJmMER4MU81?=
 =?utf-8?B?WlZJOStEMGtQT1MvVVBMcEY4Q2ljWC9POVhHN3ZaSjBEaDJtODNIWUYrcDJD?=
 =?utf-8?B?MjBmbTQ1QUpaNThITzRHKy9qVmdsbm4wVmdBUWUxVTIzQThrdXhjc1R5ZUdL?=
 =?utf-8?B?NmZkbUQzeGVCOGk0ZGdBcWgxQ0QyNjBXU3hPdGtLRHQ1akVadFZLd2lWNG5y?=
 =?utf-8?B?cEdhN2lOVHd2NWpiNzB0eW9CeUJpOEJwcjdaVVVVbVhaQVI4S3l5MjZ6cXl0?=
 =?utf-8?B?Q2dzaHQ1a1lKWUdiUVJHN1k0WWlvK200aXRoN05UZ2xHaXZ2eDFOR0RiMmpO?=
 =?utf-8?B?ZVZpbVRtaytSODJVdkk5MG9xWlR0NDNNVXFieG1jejFtMnBXbnNSd2kwMFRJ?=
 =?utf-8?B?bTFNS2FGVFlQcmJQaDVUOWZpd2d4RFhURHdESTFTcWowMWZGR0RhS21zU00x?=
 =?utf-8?B?ZGZ3aXZCK3dYODQ5QWZDY0ttVzkycllvR1lkUFpacVNENyt1RWtSZGRiRlhq?=
 =?utf-8?B?eTVySFIzTGdPMnpXOTVCQ2I2SXRERzRubnQxUlFVRDF6OHpBQU1nMllaSUNX?=
 =?utf-8?B?b05MTWk2SEtXanc3RlNKREtOZENlNmxmYTVnUDM3Z0VGRE45QkxJTlN5ckp1?=
 =?utf-8?B?SnFlODVCeEJ1cEpiYnNYY2dGbVNMZ3pldU5SVkk3ZzcrMEROYU5aNWVmZXV3?=
 =?utf-8?B?RDRYejM2RUUzZ0tOcXF0WXNDSzV6c1E0RHNFNlJxU1I5YnJwY01GUWdqKzJa?=
 =?utf-8?B?UFJPOG1FdWNjRWYvYkprTkQ0UnhRWVFPV01nL09xdGRRTmUyMDdxOElzQzIy?=
 =?utf-8?B?amNaeEZIdVJTaUl1czVXUFNENkNabVlBbFpoNkdFYkxlZkdhOXFIRUQ4S0No?=
 =?utf-8?B?ZEpiaFZpVGNFWnNLRlVFclp2cTRyM0VvSXpRV1JGNGpwai81RGdlMHRZRDI5?=
 =?utf-8?B?Qm1yUzRDN1Z6NXE5Zk5DWUlYQkdWcnBQQkZDZG9uSmQ4bmFSK3NZc3R6L2Yw?=
 =?utf-8?B?a2tBTUx6QVJlOHFGNlRBckNKU3AzTDMra0czOHdTL1BtaWNDUHpTQi9uSWFH?=
 =?utf-8?B?cythemdQQ2FzcVNDVDBDdDFlQnE2L3F0bjRuUXA5ZDVROUlGb3VJSDFkeWRR?=
 =?utf-8?B?UnhQc3dMUDJ5czBETXlCTmplRVorb3h6UFJKOUNCR1RTSDhoenhHQUFzQTNq?=
 =?utf-8?B?YkFIQjJOZUR6SDJtN29FNHdMTzEwamJVeitEaE5ZM0k3ME5ISnhWaUdLQnNP?=
 =?utf-8?B?N09FRVlreXoxbVlydDBjQlJEMzd2dGV4bksrREU4T1JENGFuTFVIZUtzRWM0?=
 =?utf-8?B?dk5YbU5QMWdWMXM4c1RjZFUwYkZ6dTg1ZEdoTCtVeGQxNVlQdEFzOHNub1RU?=
 =?utf-8?B?MWVQQkRJeXIraXcxRzh2S3VCY1lrdHM5TisvR1o2SE1ESE9WQjZmeFJMZ09V?=
 =?utf-8?B?a1RTRnNwVnhuSHJ1TjUzM3BGWTV2dDJHQjdVSUIrU0tBc0I5ZjhDNFMvQmtD?=
 =?utf-8?B?anZQeldubVVvbk1SS3pNMDNITmliY1hya2pDMmg3YWNHNGtpdTVYV1Q1RjMr?=
 =?utf-8?B?bGtYU2JWL0hUUzJUTHBlelBQcUVkWGd4NVpoN2c1R3FmRUVpTzVScGRRYWpR?=
 =?utf-8?B?NkJwdTZKQ1FpM0ozN0wwbisvTlR5Qk0xTEFJOTNBeWY2OXBvbUNRQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8750517e-8c79-4a7b-a895-08de74c79b3e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 23:42:58.7717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7saH6Cg1aBB7MP4IKO6tB/+e/XZUOd1OxVOjbzFtN8EggaUy2LRKX1lkqtPplmwtgn+XJTjR50YGgl+fKf1qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8649
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71904-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[57];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8F33019EF4B
X-Rspamd-Action: no action



On 25/2/26 17:33, dan.j.williams@intel.com wrote:
> Alexey Kardashevskiy wrote:
>> Define a structure with all info about a TDI such as TDISP status,
>> bind state, used START_INTERFACE options and the report digest.
>>
>> This will be extended and shared to the userspace.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>
>> Make it uapi? We might want a sysfs node per a field so probably not.
>> For now its only user is AMD SEV TIO with a plan to expose this struct
>> as a whole via sysfs.
> 
> Say more about what this uapi when sysfs already has lock+accept
> indications?
> 
> Or are you just talking about exporting the TDISP report as a binary
> blob?

I mean that between lock and accept the guest userspace wants to read certs/measurements/report to do the attestation. And it will want to know these blobs digests. And probably the TDI state. Although successful write to lock() is an indication of CONFIG_LOCKED, and accept == RUN.

We do not do real attestation in phase2 but the report is required anyway to enable private MMIO so I started shuffling with this structure.

> I think the kernel probably wants a generic abstraction for asserting
> that the tsm layer believes the report remains valid between fetch and
> run. In other words I am not sure arch features like intf_report_counter
> ever show up anywhere in uapi outside of debugfs.

True, this is a shorter (not shorter enough :) ) version of SEV-TIO's TDI_INFO. Thanks,


-- 
Alexey


