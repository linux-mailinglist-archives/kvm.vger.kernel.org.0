Return-Path: <kvm+bounces-71908-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kORoO5WPn2kicwQAu9opvQ
	(envelope-from <kvm+bounces-71908-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:11:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B52919F4DB
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:11:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BC102305CD08
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840D5381C4;
	Thu, 26 Feb 2026 00:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="A4yQybbi"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011025.outbound.protection.outlook.com [40.93.194.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601D61482E8;
	Thu, 26 Feb 2026 00:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772064623; cv=fail; b=L/X14w7/JnczFJUdr7xvhTRf0JQtK630xLmiEBulCONkZAc4LvSML/yWQD7EjGJnboCsa3XIGn4m2YjgTVGAilLC9bAEJmTqHjwUoHWFqt5OEYSVL88PuThXR5+3cceaBS/ojZjbyuntxIl73ux9/Cl5O7074/WG69o/RRwEJf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772064623; c=relaxed/simple;
	bh=9/JY+ufAXY7q6Jpcsp5pP8rTg1ukRlKS2PKAO3DGjuE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eyRKq90Rpo3mXe92eU5HAw8ZYUWjIrX9u6maefNI1g/jAg+XlNNnLkooza+YfvqB9163+LUk6Hztv3N9BSCK6dz0JdN/Mlz08EDyToQ+Z40sUBexzgr50txXx5WOdjNXQOZ0bJD/9ncpjojCWFxZivKvsGiVu2FvVMLg+UOZxc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=A4yQybbi; arc=fail smtp.client-ip=40.93.194.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yN1WhBs0o1TULuF57ACM5cFFnGZ4sLiFoXcW5b+tMiPH9pM2TJU0EJG9hgIsUkQh4JIVPMv+XbW3eXMxzCxn/acCBa/FEYL7IUwzO6GMixi2CEJphG9KqI+xxW8nnWdEp1eSNCIuj34z7l3kcrHgnRBiIlEnZy2LqCL0+0B3QTpJ6JUoo6xYjUpUVmdYkXpjymhNUF7xUka/oVzLEZ1T3v/2btNKLmsZR8BMSlhId7op3IfCofQ70dBt+cKtdGN0JR9M4TurbJfHwgZaBhMkeTDygsu/UcxZUQYESvKJCE+WAjM/+emEoHN4LEX30yK/wX1YTa4G716gCgykurd9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RVlCDBk77SrqpW/47Tvb55hx4PjnsBA1j9BtWo77zM=;
 b=WJgHdx84A2DiWAejJHBBRLzMKOKxI8JCjRLD4ziJyW4ALxBQ6DDGRrOq4prwUkv4RB7hcnN9XcJTiNgoSL2Df8xgxwDRrvIwVOYRLf8tuYbQ6EqOa0GOnZ5JLPhIQRdIXpqPFWclKZ4M1QlM7OiUzo3lI64IcDsrQHD2fZyKI8n/ZFW+M3NwcW4I3DEiqmnPqkXNnhC4lK9783cmluasiJcrt4WQwYG7DsfRZa1Md51GoTr5CanozG9AnclYn4V+WYBnd8hcoPzn41sGDaHzaMiH984ZRnEETyfkbOg/hcG6gnkIb3//8UNRQExuFymODyUkfAZkWs4wdCvtKX6t/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RVlCDBk77SrqpW/47Tvb55hx4PjnsBA1j9BtWo77zM=;
 b=A4yQybbiBBLm4w1Rdoa9QBG8fk7giw4xecV0JBUZHfJpbXDxvH1oaYJRQKL5JxoSAZQH/Ncssy7vF/EKyNN08dsQZm4DnStkl3etMIqFiRomxs9mx7GudL6IUylkG0Jv8y7Xa2xdb2T7sPw3c+JDdrJEuo5Z9XLu/qL7BgeqXKQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB7222.namprd12.prod.outlook.com (2603:10b6:806:2bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 00:10:16 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 00:10:16 +0000
Message-ID: <921baa41-6e0e-466b-a0d5-7b5953ef3612@amd.com>
Date: Thu, 26 Feb 2026 11:09:46 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
To: Robin Murphy <robin.murphy@arm.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
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
 <20260225053806.3311234-5-aik@amd.com>
 <5c7397b5-0368-4bd7-af5a-e513f289c775@arm.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <5c7397b5-0368-4bd7-af5a-e513f289c775@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5P282CA0057.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20a::9) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB7222:EE_
X-MS-Office365-Filtering-Correlation-Id: 4767ae4c-1f23-442a-e783-08de74cb6b22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	YLvm4gPcONtQq8dGtGjvZD38FgyTc61jGn+3PzgU/ATB9j/kqrowVdvJzJWozRF67avQR84oa36nPmqDmJEaQg3TQ1dP3q1khSnnSgFDKOX1k1/OzTu+cXLEoYrapk1WFJXzyuginja0H0BBHWSqm4kwiyn548YtQt8lBROv+ufYsok0PsTT5gUXuUYn8y2XDpCifETitiUJamSxu7D2Ei8RDRMN3U8Aslu+BdyUips2iLzMkZ9ks6ZRwVdBriChfj5FvmOoMsn3IewqSh/UkJRHEaR9J20AGlRB87nup/30N9lwogFND++dIltEgXZ7OSaJYcVTNB7tvxFn9prQ90NRnkKnQJNWlZ/tkNLaQ0Wgj2lt+/xk8m0zaOJsqtg9Yvdt3nWUzny2jVkDXporkfUhzH3zaB54Jsz0j74slSdOP6VG1dYB8nW0lIaAp3eFH7m+l7L6HKt9l4e2HQToW0kB6Rzsvt4HmURGr47eGImbSG85UfXwzxg9r+/0CBsusvpAJNxp3TCg+pVdIk0T7ExzQEa6aojpiYOMsoLUov7m1T5utOVdnhiU/dmi59E8GTcIl8mm0klH2darg4thJVIVKv4BY8DWLZ1uRCWCzG/WJ3NgMLI2yDVqQwiSLZugWNwb/MbWlPPO5ybLq0TqE5YqJisd/0Tgf09YbGYegfzbQiC5FhFaPPM+QRbwoEhbYe+t0mX5HHNtp2s7FAPcPQiMJQ4dzRxzzPF4ejjOq0A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2YxTG44Z2dHRksvOVVUV0tPYTIrcU9mMHBka25JZmhhazM5Z1BFbitCaWIy?=
 =?utf-8?B?U2dlWnhLNUowSjVnY2dXRHFMZVpTNmtHaGRiVEZsQzZHb1NHZWxvOXhhWDVG?=
 =?utf-8?B?SjV2Y0xFWEkxU3pGcDMra21OWlM5U3pFMVZKcDVEejVNcy85Qnh0dllxdXNn?=
 =?utf-8?B?bEVWaFh5NjFGeVVyT3QwalpyRGlTL1FsN0F3WnpwSVRzbXQ0aEdYVGplWUZ5?=
 =?utf-8?B?eERYR2JJNXFEMWlaU0lkbUN3Tzhkbm9IN1lpajExZTN4UkhPbmNTUTBLUmxU?=
 =?utf-8?B?SDNuR0pRYXo2MXgyaldqckNCZEx4Y1I4a3JNa1NyaUFKUXJtMFpPdXhXbjc1?=
 =?utf-8?B?NUcwdXRBWlMzR2NmTlZkSDJyWEFGclQ1aDNVS2JQMTRrQmhubGlWZTZaQXNC?=
 =?utf-8?B?aUZOVW1JM0JNZytvTzNnNVMwc1J0VHFSN2FGVnpSTS9CY3Y2a082aUdKR1Fw?=
 =?utf-8?B?RVFzSUZLa1hLMjlKR2xtSU50US9zUmg2NTZ5aDJBREJab09xVk5QSnBha0ky?=
 =?utf-8?B?K0xuVDZNaU0zYVBnNTJ2NjZLSjRCRnVSa3l0K0dxRW5HSDM1L1ZxUmROR2NV?=
 =?utf-8?B?K2tmaFdxcWFaaHpIWWZVMFFNbkw1R2UwODFmd0Fta3B0UUZwdTBJa3dlUGhx?=
 =?utf-8?B?Ump6VzV4WUN0eEMxdTlpRnN1SFlVcWZISE5rMU5iTzgvSnNhUXNvOWVMbVQ3?=
 =?utf-8?B?SkY4WmFhb0JHd2dOOGw1M2ZJV0tvK2xvYkE2SzZZSnJKMXpWV2RyQlNwdmx2?=
 =?utf-8?B?K0JpL3JOUlY2NHB2dWY5cTl4QmZMdzZGakxrTyszdnFSM1QrSmdKMVdhN2hD?=
 =?utf-8?B?YlJFNktxKzRLclhHSnh3am5UUnNSREdSR2Q1ZDNKeFJXNEg3SlJvN3pLNGRN?=
 =?utf-8?B?SEptVEkrcjBoU20wNWVPVS9rYURZdmxQbnFzdFNHazBTZlZncVl5eHVVdS9q?=
 =?utf-8?B?VEl4cG5mUXZaU2FlZE5HamtUNUpEUnJrZ21JcjgyWFJDTVVxWHJvSzJEOHVG?=
 =?utf-8?B?TURNNWlzVHNKaVlkTlAxRllJTFJQK3dxRXB1MVRUcU1semhSNkdQYTdhOHg3?=
 =?utf-8?B?amJod3Npd0hQUUwrTzNZS0cyakRJZ0lINkovMTlNbjlLUnNNeXByNGdKT1Jw?=
 =?utf-8?B?bzgrRGh2ZW9jd3AxOUNES0Y5ZHpoRUdtUUNWa0VFMS9CcnlRZVVrWG1DL1BK?=
 =?utf-8?B?UHVrMGJCc3U4OVluQmo3QTNHQU9qMFJHeE9FZTNpNGc0d3ZmMzB3UWJiU0FR?=
 =?utf-8?B?NEl6SXlOWlUwaXY1c2xicWZscjgrZW1JMDNmQUE3TkMvMFlnOERTc0VvTmlM?=
 =?utf-8?B?TExKZ0FTd3l6NUdma0J1KzZGY2FlWWpSaDZZZWJGcmRIdXRKZW9ySkM1N3Ji?=
 =?utf-8?B?S1g4OElmd091cFlLVVV3NzNxejBiRm9vdTF4OVpqcDAraFFXb3ptdUxXZVRh?=
 =?utf-8?B?YW45WW9qTGxKU1JNWkY2M2VYRGpLNUh6aklRZHFZMml6d3djaGR2TTBMOUFi?=
 =?utf-8?B?T1hYeHVFRklSUjRDYmQwNVk2OXU0enlNa2c0UmJ0OFN1VzI0S0VEYkhrNDhZ?=
 =?utf-8?B?Qys4U1BCRkVIVzMwN2xBSElQWGdJVCtocERzYWxoYWczMlMzZ1ZHSUg1ZXp3?=
 =?utf-8?B?d2hFdlQzazc0eGhrc0p0dUJIcnJFTW4yZTNLNWRmb3JQaXU0aCtNaWFnQ2RP?=
 =?utf-8?B?YjE3SGlaS3JqZjJ3eWFja1VEZ01aekJ0OElmNXJlKzVybjBLU3J6Z1IvSjA3?=
 =?utf-8?B?MTNRZmp3Rzh4SG5xRmF2TmdtVWxibFQ0T0gvd0tMRC9lVnRQb1pnWWNZc0pw?=
 =?utf-8?B?azBrNkJpWC8xb3c4Rm9aU0Q3NlJxSDIzNzBpYk9wdngrYm1ZS291UDBNUkdy?=
 =?utf-8?B?NW8zblRTR2ZPeVY3TWplU29MblNJWFhYaklJNGVVZGIxUUJUQ0xMbkc1di9w?=
 =?utf-8?B?TVltMVV3VTVhZ2FVaExYM0lFVEVORkora1hnUE9TamFuOHFRa1hyQ2RiTjNM?=
 =?utf-8?B?aUNrV0ZsWmtPNmdWYjlEcUFpQ2VhanRBV2d3Qllyb0VLM1RxcnUzeWVqRGRR?=
 =?utf-8?B?c1FvM2txNjJkRE5ObDFyY2dkN0tTcGE0aHd5aTJNdjZlN21xREczL1czays1?=
 =?utf-8?B?b3N3VHI1ZXBIQkVGZkFOZmw5TngvYlNMdlJLZjU3Q1F6NWNsVU9SOFR6WHE1?=
 =?utf-8?B?Mlc0R1dSVGRRcS9xYUp6UEdtSzhHeFMwWlBWM1VwNk12SGpkWDh6eVFHVjE1?=
 =?utf-8?B?bU9sOGZhcEFsZElXMk9YeTVOSkZwb0pmMjZmZDdtVXVaNXFpbkR1R251cGdk?=
 =?utf-8?B?MmU3alVLTVpDbm81c1I0ODVSNjNZeXAzdXZuV0dFWERvNzlYTXhkUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4767ae4c-1f23-442a-e783-08de74cb6b22
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 00:10:16.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCQpCyw353wSiZ0ZShX7f/CYizzaRVUgtk5pBlBvpICPnQG/czzVF84y3wHOPMrC3tSCSzV4Cb8XeQrxmzSscQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7222
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71908-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_GT_50(0.00)[57];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email]
X-Rspamd-Queue-Id: 6B52919F4DB
X-Rspamd-Action: no action



On 26/2/26 03:48, Robin Murphy wrote:
> On 2026-02-25 5:37 am, Alexey Kardashevskiy wrote:
>> SWIOTLB is enforced when encrypted guest memory is detected
>> in pci_swiotlb_detect() which is required for legacy devices.
>>
>> Skip SWIOTLB for TDISP devices.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   include/linux/swiotlb.h | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
>> index 3dae0f592063..119c25d639a7 100644
>> --- a/include/linux/swiotlb.h
>> +++ b/include/linux/swiotlb.h
>> @@ -173,6 +173,15 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
>>   {
>>       struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
>> +    /*
>> +     * CC_ATTR_GUEST_MEM_ENCRYPT enforces SWIOTLB_FORCE in
>> +     * swiotlb_init_remap() to allow legacy devices access arbitrary
>> +     * VM encrypted memory.
>> +     * Skip it for TDISP devices capable of DMA-ing the encrypted memory.
>> +     */
>> +    if (device_cc_accepted(dev))
>> +        return false;
> 
> This seems backwards - how does it make sense for arch code to force SWIOTLB globally on the grounds that all DMA must be to shared memory, but then generic code override that because it claims to know better?

True. I have the itch to remove SWIOTLB_FORCE from pci_swiotlb_detect(), this may be the other way to go.

> I'd expect to see something more like:
> 
>      if (is_cc_platform && !device_cc_accepted)

device_cc_accepted() implies is_cc_platform.

>          return true;
> 
> here, and then get rid of the rest of the (ab)use of SWIOTLB_FORCE for this purpose entirely.
> 
> However there is the fiddly aspect that it's not necessarily strictly enough to just un-force SWIOTLB; we really want to actively ensure that no private memory can *ever* end up getting bounced through a shared SWIOTLB buffer. The private/shared state is really a property of the individual DMA mappings, though, rather than an overall property of the device itself
At the moment it is a property of the device though, for AMD, at least.

> (since a device that's trusted to access private memory isn't necessarily prohibited from still also accessing shared memory as well), hmmm...

True. With vTOM ("everything above TopOfMemory is shared", not using it now) or secure vIOMMU all sorts of accesses is possible. Thanks,

> 
> Thanks,
> Robin.
> 
>> +
>>       return mem && mem->force_bounce;
>>   }
> 

-- 
Alexey


