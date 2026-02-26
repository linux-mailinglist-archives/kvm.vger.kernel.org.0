Return-Path: <kvm+bounces-71922-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2DolEyPhn2lLegQAu9opvQ
	(envelope-from <kvm+bounces-71922-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 06:58:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB1F21A12C5
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 06:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3873E303D11B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 05:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70D238B7A0;
	Thu, 26 Feb 2026 05:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OplA2AC8"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C44371065;
	Thu, 26 Feb 2026 05:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772085536; cv=fail; b=Y3Cx0/nbtvaIQEae3yTVmxlz/7Ma+N4ex+HapEZff8FTFnn47niOou/SrX6iJP+NsOzuVyPE1g8cqqk+HtWrE222YbRlP8eXlJVBXdDHMFc/MuiIoMLw7azybN+O/22PSmaTwRPKNsiGk0M/xlCM2gLACnR3VTo01Wo2rsmvblQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772085536; c=relaxed/simple;
	bh=gzyCNiRE5jJ5xgEBF46m/fQdtiEHZ/ypS/YPOsAK+Vc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I1Gkbe+L43aDlpbV98znIJWFdVISJbPyUK5xIBR0FfL/psmoIrj1KU8g/eFEJ2kTozTo+ycIhidABM1/YozknJpwTd24vthwNzQCMlsAzvupstTtTF3reedXtFLqM1IpKKIZJLuga+nHRLAvGg/Y/Ljwm/yTaaio7VI813hMMcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OplA2AC8; arc=fail smtp.client-ip=40.93.195.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LJNc1LSzS5dafRZ7wYimI4wm6+4qN6zHgyIPSo4dLVsaTR4fdGXJJP5MmZnE5q7Hk6s0sRn3SId4PvT99tIC6gfeKoRHWL38CigYBYTPmFvJ2UQ7iI0gSMETQj+iFlAuUfctk2WGg856Z8/B4+lh7RKP0yWWS0xbh5BIiRtDqlT27fENxu+HHxymz7sbuyhcVlHIcZw3FjAR+xvXr8mZIayzCo27K8nSj1AKDSwtQdoEk4Px8b4k/2MHvLN2WUb5CQLokm7CW2WesovnddOOWMJE5Mp1wNTt5uyf6tGX/RVJJtB/rto64qCZsrj9sXoGfrRgAS0yvMcsytz/XXcf5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sp1/fHL+MfhWcNCa7pCfXbS8qlmJwoG+hAb5US15Uy8=;
 b=xfUlVcacgu3qo96t9hiZ2fQVts46MqfFu4rhI5ATmnu5GYOTfska04AYlcrs9C/z49RaU4ijiDFm+o9BBJCVKWQVm2gZcpAhInFWky7rhQa0RU+cibBJKyZ4i5w3jZZHkZ0hn95354MHBdorhQ45/58P3ZiYB9bkZaG5cqUKsDfXiwaTxqjEen3L8QrAKVawzCxQ1DeO9Zg0ISbqEQg2unopwp4Yj3luz98MitgleV8mZvDVFNhHtQMoVVD1IqPuVKHi58vXQQzqM1ay8+ue+FWccJQFD+jVP8VDIKQxPmGq5wmBOpXJSZ4dWal8qZgByuadjgzZb3WeJ/U/7d2nXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sp1/fHL+MfhWcNCa7pCfXbS8qlmJwoG+hAb5US15Uy8=;
 b=OplA2AC8bXjZQQQ3Q1iKIrmVfi0Ho+f2M78aII2I/z0pBRKADMb1UNEUzMiYiKnDRD32mXZHbe/SWQJRE4HnxKOBrQtu7NmZlLti93oXA/vZzX3tjE3s/lWEUVnJK8fka1GAwQE9Ybm1DuymTVkoZeJABFQb/6H7+/vBluL7M5U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB8161.namprd12.prod.outlook.com (2603:10b6:806:330::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Thu, 26 Feb
 2026 05:58:51 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 05:58:51 +0000
Message-ID: <224dec48-ef23-4873-ade6-8aad98a6c2fe@amd.com>
Date: Thu, 26 Feb 2026 16:58:29 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 8/9] RFC: PCI: Avoid needless touching of Command
 register
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Dan Williams <dan.j.williams@intel.com>,
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
References: <20260226002459.GA3795172@bhelgaas>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260226002459.GA3795172@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0148.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB8161:EE_
X-MS-Office365-Filtering-Correlation-Id: f11d58c2-f62b-49fc-e643-08de74fc1d91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	0OBmXamGzUo27EoDi2VS8P/K8f1e77ziVA5PTslV5FCSJIgyqKuWEEWe1Si3OIdp1pgczxHyXbZvZgffn7XcPWmrt5xFwg0gO3zBbU2JrcOh/I7ZO8uvJZDMxZO/vAGC2ccZbjw+GC1Y/xx2Gt+fbW/b8uoE9z4b5uJVwPNT/MyOHTlf4hx4tMcbYOz/smLW8c9OCrw8oV6Zw9hctrIvXE+rGTocL8YMpBrvNkB/R9lh91wCYpWsVQAHEJgAVycrEMbQMdceXEpaIvMoU7qYSiSkjag/knMg+vf91R4kJ+YX2UB8ELnWq3pYkFLIdCFOlWQ0LYxX39k72M+N3NbeFU6XqOPXnPvjVJA1Gcz2zXt2CryxFNLYn5tM1IotBmh/5E46Qa2BEkx5PrrT8qf9arO89vrCm6sbduy5Ioj216r4ZMf3MXWmzR4yXX7lLP471WSLPiV4UprHFyozIHFTr++SyDLAK7Ia0kzl+W1InMX8t5ERC2zw7Kcl24TLCzgUn8SXX11LVVkO9bPkp5wT8PiXsP0X3NZoapt0Xfj8Is4kHQrwHQawltOsq1nvyejrmFfT/31YPV925KW3/qABPybUNqXF0/mj0t3nkLAk3CVjzgIvaT1GINT06ecrfcB7KhTOZ8ZM+8X06ACZP9LXl7dfWNLlfi5JNSpbo95tltwCBR5yA5LhkrtLfw5gcnCC++7q2E7ztarlVNxrqHA7bN6b9mLIBqHBG33BGcdI7Cs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NENSNnU2VEUybGJycUJJb05kT2twNW11UU5idGxZb1pMRjdMVlFaZGw2ZmpG?=
 =?utf-8?B?OXMzeWk1MFQ1SnhFdkdHYnJpMmpBSFR6VGpVNFdjbGdDMWxwNEM5aUN0TVV3?=
 =?utf-8?B?V1QwajAzMGJ5L1ZkSEJoNnVOQ1hXRkNGRHlMcS9TR0I0a1ZhZ00rbGdQSi90?=
 =?utf-8?B?KzlrWEZvYTVjckQ3bGh0blRkc1luRU83N2JjT2NSVElXbVVoVTBUQUl4L2Zr?=
 =?utf-8?B?VE5qejVlYXZ2NDB2aE9udVJmZzlLcnBBUzhhSWhhUDYrK3cxZ2dVbWVIZk5M?=
 =?utf-8?B?MXdoSEpmM3pRZzdDUmZJTGJ0L1AxajZJV09kWXAwVHEwQWdTRUhYQmJvQ011?=
 =?utf-8?B?bTNzcUNpY0k1dXVHRW9RK2pQZ0lWVE0vVzRqOXFtMlVJYWkvb1Vmc2hLUmdS?=
 =?utf-8?B?dEdHYS9QRkJlOTdTTUREcDFTbXVUYkwwK2RWaUVMK2VMbzFhV0UxaXM5Uldi?=
 =?utf-8?B?YjMzblNZYW0weDlRdG1WZk0wdjhUTE1yaHp1cTZqcFEwRll1VkNmWHFUTkZw?=
 =?utf-8?B?N1hOazJSdXNScEdUSzIwSEc4ZnA5QkxqNVcyVUNQV1EzcVJTZ2tuSHNDR0U1?=
 =?utf-8?B?c0FlOGptUVdMQkcyQzdFWG4zcFBoNlV0cUFnbnRwYlpTT2RlRmRDWE0rMkFp?=
 =?utf-8?B?WDNlTm9rQzhmdklHZnk2UzNGQStIc09LNEFEOEVoK0s2Y3I4Y1FQa1pnYzh2?=
 =?utf-8?B?YmJUTXByM2o3R0tVNWViV1lZNDZneS8wV3dqVm1MRWloaFc5a3hkNXZDWFpC?=
 =?utf-8?B?SXdBQTBYOUlzMlJVWHBRK1R4TW9sWnVIVUt5RGtjQmxPdFIzbVlqTHlVc2ha?=
 =?utf-8?B?L0k0Yy9ZaXhNTjlkYklMb0t2SW1nQmhhZmFmdTd2dE5IaEFoblBjd3RvT3lK?=
 =?utf-8?B?ekh2S3Q1RkU4T280ZEZvNkhQWFdKUVFPbklLUVN2ZE5JUEVXR0k0d3JRdXFD?=
 =?utf-8?B?S3ZBRWx5V0Q1UCt6enNjZ2pjYlFWcUZKN0tCSVE5UHNraTVzUUJNL2Z3Ti9k?=
 =?utf-8?B?Mk4yTTJ0bU9oMW41VzRoNTBSVENUckJQRmQrczVFaGtGaWtVcjc4andnTEZl?=
 =?utf-8?B?K0djdHlIR29HMGZHbXBrQzczWVNKNUhqNG56c2tycGtpWFBPQnBmQXJZekZT?=
 =?utf-8?B?VGNGQWh5ZHE2aU1FcUppNDF3bFRkNWd1OG5ydEFjVnkrcExrNFlSVjJwMVlD?=
 =?utf-8?B?ZSt0TkVQU0lMZXFrcnNVL3IwWGpoOTJIQVFtOWVkMFhpV2p4SWkyWmtpOGhr?=
 =?utf-8?B?REVKTFIvdk1QM1A4Vlo3VzNRYVVSV0V6cUt4c28vbnB5UzljbENkbEkvMDRO?=
 =?utf-8?B?SVluU3VxN0lVbm9oWDNIc2VpTkpvR21rQ29ZbVpSKzNISFYwMWxjeHpVK3gy?=
 =?utf-8?B?UGVBZkdMa2FLWmUvVzBUR2xGTkhLRmxuNWV1UzR0dURrOVdpZW9SSDRna2xo?=
 =?utf-8?B?dDdWcHR3QWdqUkFaRVZaOUFoRHJocFErKzhWTHJKVWFrUCt6VE5QNDhpRkZZ?=
 =?utf-8?B?b3Z0VDBqbyt5elRxUjMwUHhVQ3pNM1FMRndYUU41NmJSeitYRlFMNy9NZXl2?=
 =?utf-8?B?WFNKWVU1a1NMRGNJSDNRdjc5Yk44V3orYjdUUWlJQThVODlSdFlOdlh4dDhK?=
 =?utf-8?B?elVhSjhzbEsvMnFEMFVBQ0l4bjRyblA1L0FkTVdmaUdRSzdiUUlGeGVvQ0k1?=
 =?utf-8?B?TWtpVHl6VVhpNzZZYlVSRGdzcHNHeHU4VEEyYXRITEdaN3Z0dG1YYlF4VEVV?=
 =?utf-8?B?SnpzRkxXZW5DV3Fxei9NdEp2MzRvb1JsaWVITFV6bHVkY1lyVHRmTlhQR1Vj?=
 =?utf-8?B?WVV3Q1VHeUhIOUVSWEhxeWxKUTRsWHJ0bFozOTNmS08xZTJBUGhJaTZYMUF1?=
 =?utf-8?B?ZURSNkErYm45RUc0OFZKNFlaRWpnVVZoMllkV0FLZXFPMVN3Z2l6RVg2UG4y?=
 =?utf-8?B?RSszWldEU0tIdmdVYTh2TE1BelR2VHdVZnlvb1VHbVJNTzIyS3ozMTFONjZr?=
 =?utf-8?B?K21ycE9KUlZRR1NpcGxXaDJOaENoK2JCbFczRkdNR1M0MUx6WUJvYVFPWklM?=
 =?utf-8?B?RFcwOUZlZWRMNVRYN3puK0VaaEFYdG00MXVGYW4yWmNaankzMU45V0JKclJq?=
 =?utf-8?B?K04ybjlCOU5GTllVQUJzaTVSN0FvaFR6SzZxVlZQVG84MzV1Qy82VDlUa08x?=
 =?utf-8?B?WUhkcENGcWdnODR3SEhldGdycTltbkxnY2pXMzBRMWNFZHhqdzhGTDNoNG1W?=
 =?utf-8?B?MUlDODErd2Nqc2hSQmZSbmxjbFA1Ynh1ejJXWm1UZXBmVEFaT09LMi9ZUGdm?=
 =?utf-8?B?cEN0VW0yQjZ0MkNQdjBzNlBsZFc5cGh1T2VYUkhUK3JxeTVYNkZPZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11d58c2-f62b-49fc-e643-08de74fc1d91
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 05:58:51.1874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FUHlNb3vUM66BqsSWxx7Sx5BKZ+1CiXaTMchFYqKuYuwjgZjNAwn/OfYvuAzEfU+sa0PhYAdpB56PvDrrAsdnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8161
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71922-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_GT_50(0.00)[58];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DB1F21A12C5
X-Rspamd-Action: no action



On 26/2/26 11:24, Bjorn Helgaas wrote:
> On Wed, Feb 25, 2026 at 04:37:51PM +1100, Alexey Kardashevskiy wrote:
>> Once locked, a TDI's MSE and BME are not allowed to be cleared.
> 
> Disallowed by hardware, by spec, by convention?  Spec reference would
> be helpful.

By the PCIe spec, the TDISP part. Once the device in CONFIG_LOCKED or RUN, clearing MSE or BME will destroy this state == will go to the ERROR state. PCIe r7, "Figure 11-5 TDISP State Machine".

Then, if it was CONFIG_LOCKED - the device won't be able to go to the RUN state which allows DMA to/from encrypted memory and encrypted MMIO. If it was RUN - the device will lose those encrypted DMA/MMIO abilities.

>> Skip INTx test as TEE-capable PCI functions are most likely IOV VFs
>> anyway and those do not support INTx at all.
> 
> "Most likely" doesn't sound like a convincing argument for skipping
> something.
> 
>> Add a quirk preventing the probing code from disabling MSE when
>> updating 64bit BAR (which cannot be done atomically).
> 
> Say more about this please.  If there's something special about this
> device, I'd like to know exactly what that is.
> 
>> Note that normally this happens too early and likely not really
>> needed for the device attestation happening long after PCI probing.
> 
> I don't follow this either.  Please make it meaningful for
> non-TEE/TDI/whatever experts.  And mention that context in the subject
> line.

Well, frankly, I have this patch for ages and originally QEMU did not intercept zeroing of BME/MSE and just by having this patch, I could get my prototype working without that QEMU hack.

Then, even though the QEMU hack works, it is kind of muddy as when a device driver wants to clear BME to, say, stop DMA - and in reality it won't stop. So I suspect the QEMU hack won't always be enough and we will have to teach the PCI subsystem to not clear BME/MSE in some cases.

Hence the patch, to highlight rather unexpected writes to the PCI command register which are not that harmless anymore.

I'll drop it if it is no use to anyone even with the above.

>> @@ -1930,6 +1930,11 @@ static int pci_intx_mask_broken(struct pci_dev *dev)
>>   {
>>   	u16 orig, toggle, new;
>>   
>> +	if (dev->devcap & PCI_EXP_DEVCAP_TEE) {
>> +		pci_warn_once(dev, "(TIO) Disable check for broken INTX");
>> +		return 1;
> 
> s/INTX/INTx/
> 
> Why do users need to know this?  Why as a warning?  What can they do
> about it?  "TIO"?

ah, sorry, a leftover. Thanks,


-- 
Alexey


