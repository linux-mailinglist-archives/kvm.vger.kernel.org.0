Return-Path: <kvm+bounces-50598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FFA2AE7435
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 03:18:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 378633A4769
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126BE1494C3;
	Wed, 25 Jun 2025 01:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EcxYw18+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2514501A;
	Wed, 25 Jun 2025 01:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750814300; cv=fail; b=PCYQjCc3IwGgNOdemzLfGvGbCV4p4XkIW2lOSqtShjWw+dPjIACXEvWwRHZ3F5aZCFQDHr4zKsP7IxeYO7DQ2WZGzpi0P312ZoAMNhgxKb9GXfPD8q/mblsUIwhObiVJWmqdaaHIHO99AkrDdQY+MT+RGVNUY3gmUunBGXnWunA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750814300; c=relaxed/simple;
	bh=w4RoVxBXxSc5irQkz3lNvNTbxLAW2xxvRhDqkdBZ0Jg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OSS3VGiGUS327qQ5V7Iu+aVn6iaf9REOADB49ks3Xg54M/QCIVng1LpZNDpCvc78D5SEFKXkV2JYYtWkvxFb+qIPhAP7FM0XXdQvBLYd/DT4tFaPine7DP5BNL6khdxBkXOi9fwJ4yYTG1pEPDRkP9KPQTsT7QFbF57BeerBB3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EcxYw18+; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NSyr1m3wJZflrurGitwyeoM+xyfr/zP1lP9mwxGtzc6FXF258dS63JulDfl/KWe6xafr126gHpruG68gh8RekSQI3yePnlUgRYjbnBPW9thsSAqoKnqIgBrBvZCRSzGedJuhwq4MsGJy+UY8GdS7xStPlNpI/ItrwSjA5ePC1xNYVaQFadxWg4mX8bP/eh3p9DHwvoLITWq4U/qE9jL9TvA4aC2W0L5nRHW0nuIKKA3bwCTrh088mNxo5/ExyhHXZZGOREqT6JQkqhEtsnPp92uSAEFBjharptdqFOHLrSP8mI9rNQLlxqFUbIU60qzz5gAU9uACe0tS75ayNtUuHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRLlFZYq0yoRgvd+La6b6tf8qCrUSuQaA1vDX/O5q24=;
 b=RKyeDvMe8hT+Fi/D/TJE/iAef4q6ZNScOWk3491SKwzjumIGQTyYBpKFMSEwpDWwsybt1Y/AOLBlU1zfNNKdCbGhaxIS6CCOViiFj0ja9a8WIfkN7hz5Lc39JDK/3aiAsZP9VrKl/Ghu3unjNLWg0D1tSqns5LWYqCnvhqPIgfUWtEmgSuWtlS+U8wyGRfc/NNz6xCFks3h0BXojE4wf9A1/oBLhVjz261hPWSVMQGxOEkfh/T73J538oyACe4VB5Rp/fe1/gOLltNZHqFJ0KytmxkY70ukIdbVxscXBwQE+nTkGVy5IZVdDIMoI8/5ky80S91FCaFvuDobQsBL6CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRLlFZYq0yoRgvd+La6b6tf8qCrUSuQaA1vDX/O5q24=;
 b=EcxYw18+IArnkYBVoYBxsM/gF/fYnPnhsC9H3/SEMPCRCRlUw3PpxxlUDUQLw14vgHTMMcuvvie/UWQOtvYrjZ5F4s1UGtQoBAsRAWzk88g14K1ED8a0GfYfZSnCCEF10Lc6LuLW4ZzFu3xsiwcn1UQbmaxof9pfeiLpMzwFezU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 MW4PR12MB7287.namprd12.prod.outlook.com (2603:10b6:303:22c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.28; Wed, 25 Jun 2025 01:18:15 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8857.022; Wed, 25 Jun 2025
 01:18:15 +0000
Message-ID: <6dfdfc71-435d-42c3-a46d-84aca776a47e@amd.com>
Date: Wed, 25 Jun 2025 06:48:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 18/37] x86/apic: Simplify bitwise operations on
 apic bitmap
To: "Huang, Kai" <kai.huang@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "tiala@microsoft.com" <tiala@microsoft.com>,
 "Vasant.Hegde@amd.com" <Vasant.Hegde@amd.com>,
 "Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "huibo.wang@amd.com" <huibo.wang@amd.com>,
 "Santosh.Shukla@amd.com" <Santosh.Shukla@amd.com>,
 "nikunj@amd.com" <nikunj@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de"
 <bp@alien8.de>, "francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>,
 "naveen.rao@amd.com" <naveen.rao@amd.com>,
 "David.Kaplan@amd.com" <David.Kaplan@amd.com>,
 "x86@kernel.org" <x86@kernel.org>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-19-Neeraj.Upadhyay@amd.com>
 <2f4603f4c74ba21776ad6beff5f5b98025c99973.camel@intel.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <2f4603f4c74ba21776ad6beff5f5b98025c99973.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|MW4PR12MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: dc7e2bae-5c0e-47bc-c263-08ddb386291e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bHZPVjJzenhRSllMa3BnMlBRVDZUQ25yWmR0YnBITTRnUjRzejRSaWxjQlF1?=
 =?utf-8?B?RnpYZkxVa3UrWUZtMmFTMiszZ3craG5DRDVpTS9rT29ST1V5TWUyTFIyc1Rw?=
 =?utf-8?B?QzZseEZIKzlOTUdzeXcyV1ZwaUNoeU9hckFabXBLWkhoYllLN2FNc3hJUzVk?=
 =?utf-8?B?dE1uNzQ1MFlCbHVYNEl0MVVMWVd2cW9xYVpTL0JHNmU2bWJidU9obHltU3hH?=
 =?utf-8?B?K2hhajdNdzVTVjZmc1I2Rnh0R0ozd3I2MDQ3V25zT1dVR1N4T244WmxhdUpn?=
 =?utf-8?B?M0hYeWs3di9CQ1ZFc3RaRWR6ZEtKR0RyTDh3V051ZXgrRTdsZEErV2h4R2lT?=
 =?utf-8?B?QSt6VzV2bUhTMWZJRlVUNXU1NUZOZnhqTCttS3RiUTFOb3FyTUdJSno0NHZL?=
 =?utf-8?B?Z0ZzUnhKWUV6UmNRd3dvalV6V1RXaWd5bTNEMlc2TTUxWXQxRmsramlFKzZO?=
 =?utf-8?B?bXlrMVBQUGJSbDZwVjZCSHNBblpMSGU2Y0E4d2dUK0lPR0RtTEk3SUhqZnpN?=
 =?utf-8?B?elNUS3h3RnQvektFTkMzanZENkNkZmRFSDdxK1drbk1iZ0pZNjdkYjA3TGxE?=
 =?utf-8?B?bEVsVlV4aks2L0VDOGNoK2F1YWVoR2RWZGlUT1ViQUd5bG5KMDM1QVBLMFhM?=
 =?utf-8?B?ZWpGZTc2R2ZYWEJZK3JxSXJuUTN0OFBBZk9BTm1tRVh0K0JOclpMRnF1ME5U?=
 =?utf-8?B?RENvd2lpanA1TG03OVVyRWNPVzFJZWFkLzZHaVl1Ym9VMEd3VnlZaEVUbk4z?=
 =?utf-8?B?cXNnZll3UWM1eVVrZjBFVnFtWjJ4Tjg3ZFV2T1JONkExQjl0aTIyRHk5VCtU?=
 =?utf-8?B?S3p3VlhVZC9ZNWhtRHNWMHdWL011Q0lDbWk0SE9qcmp5MGtqL0lZSnhzWjZ6?=
 =?utf-8?B?d0s4QXdDbHVBWjJ4TEJqQUVUbzRDZWxpYlRXeU9hc0RjVFhiZCtzdXpSbjRj?=
 =?utf-8?B?aDg2ekJ6MUp6b0ZLR212cHg3VTlyUjY4U0ZOSTJuUUpUcWlEUDI1L1d0WmZn?=
 =?utf-8?B?VEpTbk5zVW5xYUFOYVZpRlNvSHRYcWRkcWoveWdVeW8ydjBSUUZNSjZJMFNt?=
 =?utf-8?B?TXFGNkFlQjhSbmMyaVJ3MTYyZzMvcWluY0dYdXRiUG9rSHlXK0VZTzZnaFgy?=
 =?utf-8?B?T3d2U0pPY3NKMnFKS3hXR2pYR1VkRk5CS0NOczFWNUdYV3B6blNMSGgrakRM?=
 =?utf-8?B?WkJNb0xBMWtuMnpMWkdnR2d2SHNGWC9CSnVkcEovaE0xdVVPK3EzN0lQY1Zh?=
 =?utf-8?B?ZHVZVjRhZFNUa2IrYXI3THhLQUluK0kvMzlZMVlrL28vdkVKaHo5MC9mdk8r?=
 =?utf-8?B?ZENyc2NrclYxVFMrWTgrMDQ5WVhuTktVdm5TZjVaOEFyZWlxQjhnMDV5Sm5D?=
 =?utf-8?B?TmxqN080VzRKaGJsNUhDRzhBVzZDMTgxY1B3UVU3R0dmS0h6Z1JnVjNUQ0Nj?=
 =?utf-8?B?c244cTlqbFNqRjZSRVd3SWtRWmJpd1pFY0VwemhpVzJrUi9ZQzlWUnNFejJJ?=
 =?utf-8?B?UUwwQkwxVmQwTEFkajQ4cVJBM2Jvc2o0bmpOdkpHb211M2ZZNzczVVlPUXhu?=
 =?utf-8?B?cENmZ3hJYk0wZW1rMW4xQnU4RzZFc0hWNWhnam16cG1oYjhEc2xKdlBoSDFM?=
 =?utf-8?B?dHNVMDFRc0IvTWZtOFRGbmVIUU9JZlE2K1ZGSXFnMVJlQWZaMStHeE5pbmg2?=
 =?utf-8?B?QUtkQzRZSllza0tGRUprcXAwejFMYjVGbk5SUnBrWWd5Tm9EM2FxWUxETG5v?=
 =?utf-8?B?K3pqQ0FRV05nUGluNENSdFF1NVRsU1hUSm13cEtyRkFhd1N4QmVHVUc5R3VE?=
 =?utf-8?B?RmwyZ2FaVnZ2aFQrNWxkWmdXOG1iWm9VOXFGOEVHdElYNEU1dy8xMVJNNHhD?=
 =?utf-8?B?QzRaUE82L1NMSEp4RGNqb0Y3d3V3TUwrS0xHaTlIcmM4QnI4RWhERjlxODhz?=
 =?utf-8?Q?SvRrlz/zLK8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2JkZWZoVzJIcmtOYkVrN2pYQkdLdEhCckYrOG51cWdOb3k5WmJCN2RJd3FC?=
 =?utf-8?B?aVVaM1MrU2c0Z0J6UmxBUHRMQURpWXI0YllyUDVBbVFUSXJMcHJRZGJ0dmtk?=
 =?utf-8?B?VG5RdE9iVFcvMmY0Zld3dWRrNjNDMG8yRzBybjJpck9CS0ZETFBlNm42UzJO?=
 =?utf-8?B?RFMyZzMzUmRxdTRDQlkyRC9USFVKamtVSVZzQzcrMDdWcnJURnpzUGxOVGNM?=
 =?utf-8?B?MUFObkhBTXMvK0Z5RUljVFQ2Ly94NGk5eVFyRWFOL1VpR1NwZWJYU2RSaEl5?=
 =?utf-8?B?TkNKM0dqdjJsRjZ4VzBmWWpST1dNSW1zL1M4bjY4NFdDRysxZndQMDg5eEd6?=
 =?utf-8?B?dEJONC9kUy9GYzNsRmgrdm1WalVUZTlSbzl1SzRES1cyTU9ZM1RhT1BnSytM?=
 =?utf-8?B?dUQ0Nk45WUdmVW5LdUI2d3ExZ2IrU0dWVWtsdG9zWTRmWGdXNVZpMUtVUHRF?=
 =?utf-8?B?eGhOZWlJSFBxNVE2aGd4Q29LdkFOQ1FwZTVrTlEzK3VvVWtER2pZYUtja0FR?=
 =?utf-8?B?RG5vUlJ0T2dERWV5NEJJTXk5WHpTSFVGWHBISUorYmp6K1pWNWhjcEg5V2VH?=
 =?utf-8?B?cEFDNS9xdS85SlZobDZRK0liUXE3Znp0THQ2U0NpRWZTbi9wdXlpREsxWHF5?=
 =?utf-8?B?Mk1BbDRCVm9mZWhRWmx3TGYrbWhzUElLMGluUHd3ODlLbGFBZ3NKOHFsa0My?=
 =?utf-8?B?ZXVqUkk4dUZKQi9MYlZiMmIwdzVXQVF5RmhKRmY3aXhRWWpHN1NGekUzZWFN?=
 =?utf-8?B?Rkx5dDNYL2djUk50VjJuVlNseit5ZVdWaEZjZ0lhSExpUW9nYkpYRHJ5a1hs?=
 =?utf-8?B?RlVvOE5JNzM0NVQySmVjKzhybkVscFhETXRiZnZGYThNNE51WU0zaTc2SlpK?=
 =?utf-8?B?Nm1XTXhUd2FkS0xMWkNMdCszempPOGU4NkVjZ1BRTUZ0K3VoQ2xhaHZXekpx?=
 =?utf-8?B?Q0dOY085K1V6WGRJL0lLZlRZc3JoWUtDcFNkRFQxWEF2VE1yUE1vQWRQK0lu?=
 =?utf-8?B?UlhVcnVvbkNiVHFCb09nMnp3K2ZPNXpubjhDSUtvRml2dzhHRk8xSElZdWpu?=
 =?utf-8?B?Ymt4bUZGYjVyaFlxM2sreWp6VWFIYkV3N1JXUXByWWw1ZWlBSjdma2E0T2g0?=
 =?utf-8?B?NS91RDVwZzkraDExWWlGQU1kcm9tNHNnbHlkaUlTS3VLcW80MUhsZlRONEVE?=
 =?utf-8?B?dDBmTnJOcXJaYjlyRTlxT3paYnBydTM4WjZFS2hFSXFjYjJ1c0NtQUppYVNj?=
 =?utf-8?B?bWRCSHUyVGhSZnBVQ0FML3BDaWZXLzJJVFhzTG9qUmlRR3FzcXZBdEZjVnA5?=
 =?utf-8?B?Vmxla29Hb2xrbUlvVjlEbVNyY1YzVm9uNVY2eVhVTGJVSnh4YjBwQWJ2cFpk?=
 =?utf-8?B?SC9pc1Jjc2Nod0h4VloxaTdEM3hYaGdlVUVINXk3SkpjR1EvdFBkMzhacjBT?=
 =?utf-8?B?ZElsNzVTVG1zZVgvVUFLWWV5eVI4S0U0Nmo2d3A0MTRBN0hlakYzSGg3VVR5?=
 =?utf-8?B?WXQzUFB2TzFiTHZ4YTQrZDJTR2s0N3ZJVWtvR3h3R0taWHpBZzN5UEJTc2k5?=
 =?utf-8?B?Y2RzZ3ZieWVsencyUU4vUncyaFA2U2JnbFFRNHhIczJIc0JJZmdENCtLaEFL?=
 =?utf-8?B?NjdtblVkZDNuVVJSVWtWNDhrMU5pM0FIcUoxRVcyaytrQzlYbzlkeXU4WlZz?=
 =?utf-8?B?aTBQUHVHMzV5RU0rNkttOWduMzNzVTJEZFN4SktibWxpeXNVOXhmKzNPNU5y?=
 =?utf-8?B?bnFaczZMMHBaV0gvUFVOWU1KM0JlZUwzTGdmZU5keWg2R3Zka0thV1MzbXR1?=
 =?utf-8?B?bEJjaGcvdTZBRGxhUGM5ZWNBZThkTEY5ZmQ0YjZ0QU9taWlBOWx4alprS1dI?=
 =?utf-8?B?T1hhSFQ5dS9WS2lWSWFwd2tWTlJzTTVxanRjd0Uzc1hsN3BEd0t5U04yVlRx?=
 =?utf-8?B?cVdFUUtoSjIyK1ZXQ2tjNEd5Rzc3TThIbG05UVlJTnN6Tm1ndTlYZm5QMVFq?=
 =?utf-8?B?bG5nUU02cndmQVVCanREa1pmeU5abGZWQW92bXlRT1pUTGNsdVd5WThhSDhE?=
 =?utf-8?B?NHBJMHVmQXZrckRtN3g2dHp0bHRjckVlV2JOcFJtd3NyQUs0S3VjeFRVWlZt?=
 =?utf-8?Q?2NWIhCSQc4nhhNKzpo5sUNtDI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc7e2bae-5c0e-47bc-c263-08ddb386291e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 01:18:15.7355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6UwkTgZNGrLH+jVbz6wCHOQtLbVQis/Dh21HxTW0PW6HPjhQeB8HFOCA85raGf+h7w3SsVZTTCi9ZQ0gbL5eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7287



On 6/24/2025 4:07 PM, Huang, Kai wrote:
> On Tue, 2025-06-10 at 23:24 +0530, Neeraj Upadhyay wrote:
>> Use 'regs' as a contiguous linear bitmap in  apic_{set|
> 					      ^
> 					      double whitespace here
> 

Will fix.

>> clear|test}_vector() while doing bitwise operations.
>> This makes the code simpler by eliminating the need to
>> determine the offset of the 32-bit register and the vector
>> bit location within that register prior to performing
>> bitwise operations.
>>
>> This change results in slight increase in generated code
>> size for gcc-14.2.
> 
> Seems the text wrap here is different from other patches, i.e., the
> 'textwidth' seems much smaller.
> 

Will fix it.

>>
>> - Without change
>>
>> apic_set_vector:
> 
> Perhaps add a blank line here to make it easier to read (also consistent
> with below).
> 

Ack


Thanks for the review!


- Neeraj


