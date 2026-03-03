Return-Path: <kvm+bounces-72509-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGEJCsKapmnfRgAAu9opvQ
	(envelope-from <kvm+bounces-72509-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 09:24:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D5A1EABED
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 09:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4AC8A3115337
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 08:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83445388E50;
	Tue,  3 Mar 2026 08:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vTpMeiR3"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7B93822B7;
	Tue,  3 Mar 2026 08:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772526007; cv=fail; b=p8tlJNX1p8nhqqk1VFFa1v3xNow0hpzinPwkrmC4zys7PnYoZKGlEkdmbh0PzVDvfFL2KXCiUMB1qnuFB3vtskmkzDK+jnFm772zT3XH4iB0E9YguI4dd1qgGg7cjwxJa9yB23ci7luIPilPKJb1Y4qv2/5sOkwAl7job+f5Vy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772526007; c=relaxed/simple;
	bh=QCsVLAmxo8PyJZgUTm8KUs/yIPmzMn5SG6Qw6/fqzic=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZrBxbgtjcNvejun2yeWlaNy3qOEqxLf6sLXXa/2Sq4CopQFrnXFP462Pbfyt+JmPCEigcf7EyJxOVXuxeF8kaLX6A9VOcwHDBuy8ggDkSuTn3qcVu23TcLTgkG+tjMf0oHCUsSQmvbGXfl7/5l4jsGWbXvpadEqe4ArDG3lPMGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vTpMeiR3; arc=fail smtp.client-ip=52.101.48.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EZAjJ0nPZF4oj7iNLrzaloO31oRzNpm0iWqogM0c74zLM7K4MFzTwWdI1nJ/lcP7rjuJP50gWnWs/AQsCU8r9rvBQ+oDQEspC8IrlVz2AEUDzX1qajD9LLjdK6uVUwB3DSHZyG4j1h814dwXHuuuw8ESXREVs45HBQF52hiOMSBgo1g7Ecm6FJ5JZCo9fXebJRtxc55KqxpKesgTiQrD9rQX+1V/983M0s/vF44x6Ek05/a3r5K86/IHeiJzWg7cwzevx2116LF7rJi6q9C98tAl3h6Uq6qsQxO7LSDRgiJFabTgD44jvnEEBOFrAfFCW/41pypClAmR2NxhLUSxeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gn0W9yFY5VKWPfFAC0dKmiJZrui3Vs1lu9h5koweBg=;
 b=i/FwCFHUvoqHgFokeoHq49dLLITc3/Wm2IRsmsPpJFnSjdRXEKMOvpbB+iwrdnvpINgQSSCohLC2PBAkC6Km3Xw3ce8jc6EBEEKT27bFn/1tXkLdW3JCGUaSY6tqB/ULJIwopOvqKUXLHYS6rRT57pgb1DsB0v8iY6iFCO2Svjh8Xs3VgJtiSngwlo9zVtgPixEv/OYxIcFeENDDlhZJZiGiPdCi5f0zzrYTMXyMfvdP8ZE/eOFKuzAWQau0kF3HfBbhmLxXO2jUesN4VRXMfAekdG4sspJZjf0aJKzsuTfMY9jk2ruFm/S0RyhqR5H7C3d3WDs34MWL0EoDfTM9/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gn0W9yFY5VKWPfFAC0dKmiJZrui3Vs1lu9h5koweBg=;
 b=vTpMeiR3hSs0hHkHijv0MMGxYjKSGRDVpdaP8/+e0u3Nj/dqNg3Qp/+KTvbxMPCg2FnpB/I1aPH2dYLQ+mjiSfTOktCaaXW2JRUNhhlbSl9evnsUFYloT4dX8oTPibkbpvcFp0jddeoAWjHRtlLxi7QE+KoN6iK8Pp0fbCyg46M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by IA1PR12MB6603.namprd12.prod.outlook.com (2603:10b6:208:3a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 08:19:56 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.015; Tue, 3 Mar 2026
 08:19:56 +0000
Message-ID: <9cf2e2e6-0fe2-4804-9c62-bc60c89d57c1@amd.com>
Date: Tue, 3 Mar 2026 19:19:36 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page
 state for TDISP devices
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Robin Murphy <robin.murphy@arm.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
 iommu@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-7-aik@amd.com>
 <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
 <20260228000630.GN44359@ziepe.ca>
 <2a5b2d8c-7359-42bd-9e8e-2c3efacee747@amd.com>
 <20260302003535.GU44359@ziepe.ca>
 <500e3174-9aa1-464a-b933-f0bcc2ddde68@amd.com>
 <20260302133527.GV44359@ziepe.ca>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260302133527.GV44359@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0132.ausprd01.prod.outlook.com
 (2603:10c6:10:1b9::10) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|IA1PR12MB6603:EE_
X-MS-Office365-Filtering-Correlation-Id: 19f01e5b-6c0d-4f2a-a977-08de78fda752
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	FhhEeMzTHljaBVVqCPxImMxP+iiLwfJhNhM4csJ9PepcLDAArTK+G6JDVMAZlpVwebmPfk/VkJFjxp7aYuDq9ugrtyH2jMXiSjPyS9NTtUU7VyRI+U5fY2uMe1sbO77gdWhqLYvWDoREJwX/dCJ+Zw+yWa0Mu2b9ycaD4BXuWtEDiKGFACawcELVJQTkF45lcnILQtqHpqOZA5Bi2n5iIJWiYc5AJ82j+y8qAMbs0dd8iIhXT/dbTpSbCnCrO6GdKIR3YBXISaxtkotIBzOM6PVAXlDE91SQCwNykf6nbHnEmKu46QNJwgOoT1RrAyffX2l+Ai5BNDNbSdju8jI9hwa8G6/+t8vKuAmlYlon0wgBZcG/RDiSJczzegzYKsSmFliz7avNwNOgltxJSYjX+o3P6xw4Jk1ydP/qV3OBd1YKWgdvepwLeMHlerSfYyNJifEhlJkYcsPgEsH7Rnij1cHhcxXDyzPB9CtUI3hq325yhnhDIpC9SJhgABr7pW6oXWN2otF/HFvR5q6Wm+NVr6ctL1H0tnzMJfJ5BjLm+hTEoyV+cPn7TO+iVk205KNSCQm3FipYHATZWfYt6yydF0gYBBcAtdJSaCkHi8qL3R/xAKv17Fuk/DBq7ltyajkKwtxUdHfGjreJpilgjTuZL0TI9ghfDHyq6+fbwGPQL7zEi/18yCnu8ZxhdjUjkV/9VAhupi9EZe17x3cbqn9NDtOeXGDfM9N1oJhJEHLlVZ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUtoNkx5ZStuNlJFZmF1dUw3TkJDcFN2WmlNRjhPZWVHUzBuU093ak4rN1BW?=
 =?utf-8?B?bllXdXExbnZ4d3hUdElOaWVYYTVneEJ3NzR4MENKVUFhdS80Mlk3RmdOT3ZD?=
 =?utf-8?B?UXdJZ09EZmlLdEM0NTNUeHp5T3hhS3NBLzVDQWJ2TldURm1xeHR5KzkxZjEv?=
 =?utf-8?B?Nmx4SFRDLzFKWGdtOTluRmIzd01VWllYSEtHVDVFMitYck9tN0dqTlZ6ZnFz?=
 =?utf-8?B?QTJ2c2hVWlAyM3JnSFhXUWozTTdlS3VLOWRXT1JkZVlZWlVJaTJIb01TYk9k?=
 =?utf-8?B?MlQrTFNpa2FibDB3VHlSV3BUd2ZoekxHWVRiOVh1M3lmK1VSTGFQcjJqbHpp?=
 =?utf-8?B?RTlQZDcyZjg0L2dHSEsxY2VXNTBybk4zZ3h3cjVQNWNYVUVUOE9UejdUYm9J?=
 =?utf-8?B?Nmc0VVJqTVB2SjZtT094ek5rMDl1R3lzNG9iRUkveEx2a21sbXgvVzhQVDJJ?=
 =?utf-8?B?SnpCdi9GcGZNRXdUZFUrdCtPRDgrdW9YMGRSRjMzMmFiam9vM2hHM2VRRks1?=
 =?utf-8?B?RUk3SkJuMm54eDZPU1FJRXovbGlkZi93Y3pydGlJQ0VwaEdSR2w5UXBlaE9O?=
 =?utf-8?B?bFBOcUxoSjVmNk9icFBobHdjRHIvc1pwVStoWG4yN2VJb3VGZWxvY2wwend6?=
 =?utf-8?B?NnA1MkVHUmZ4VCtmei9SQlJEcUZ1S3I2Y21DQ01YRXptWS9HcU1WcGMwbGpj?=
 =?utf-8?B?RXZJMXhSWjlxd3FpZnJweW05WDJmWklBRVVWRlNMSG5meDRPbERnTHIrMVZx?=
 =?utf-8?B?SEwrY0ZwR285bmxOYlk0c1gxNHZEMzFzU21DRTdEbGFvOXF3NkZ6L01JUXhB?=
 =?utf-8?B?SzE2S0ZsOUlPV01mSVBIOEhML2xUd3VmTFV6Zk45aDhOS08wWjk3RE9ackV6?=
 =?utf-8?B?RTFuMGRmOURvSFJiOE1EUmlSeGdjeUdUZ0Y4Q3hjWnh4ZWVjYTliZlA3WStO?=
 =?utf-8?B?MG9hNEZVMWlvRmVDU1V1VG5xaGhLNEhTb01JNDBDd2VGNHprMXk0RFF0Q0Yx?=
 =?utf-8?B?LzVOcmd4Q2Uyb1JiSjFOYU1uM20rK0lzS3IwTFBqcU41MmVZSEMzcVJOc2F1?=
 =?utf-8?B?WVROdWF5Vm41OGxrKy9BdHRJMVlVd1o1OWUvWjRJL1ZSUVNkQ002Ui9wa3JY?=
 =?utf-8?B?SDBEMDg4Wk1mSzREUWRqeGNFcmZiUTR4YVNOcTlWV2dCT1VGYVZ6SUhUeFcv?=
 =?utf-8?B?Zm1xRml0NHhGSVJkY1BFRnZCaFJKanBpUk04Mks0cGF5NTUxOCsvb3VsZmht?=
 =?utf-8?B?VE9ueW8xdWVzUXF3NmtLaURLOXhMQ2JVREY4cEhGbXU3WHFzSDdHSTRLOXJ5?=
 =?utf-8?B?Z3k2MFJyL0EyV21pbitvWUh5MExSemdCWEFxMHJuTExiNXQ5ODJJQndxU0RK?=
 =?utf-8?B?REkwcWlRbzhuenBBKzA5dWxhd2lvblREWjJscmhUSGJiNW9ncEZUU2xabkp1?=
 =?utf-8?B?WWowaGZpQWcvM0NCODdBZ092UHBHODYyZCsydmZ0eXpTcjZuclVpU3VSS3Bt?=
 =?utf-8?B?cEFxQU1KM2lId0pMbmxtRUEvZ0s2Ry9YNlpFNjJGTVVLWTR6dnNoV0xnRUVY?=
 =?utf-8?B?a0FINTFCYVZSM25hTFBaZVMzLzBzeXkreFA1cWF6aDJ0ZlBHMG9Yc3RqTW1n?=
 =?utf-8?B?Sndia2t0M3NDb2xVSHZLbzJ4OVZSUkVVdUpNYk4wbFNUN29ScS9Hek04R1c3?=
 =?utf-8?B?SWM1OXVFU1pmSmtGMXRONEE3Z1NXTGRwZ0NscXY5TVIzWnhUU2c0Wmk1OUd1?=
 =?utf-8?B?d1RmV2RZMEswdXNrbEM5WWl0aEpHQ1dMZ01xajN5bTF1MjBkZXVEdTlhYU4v?=
 =?utf-8?B?dlB6VmpKTXlVMUVQL2lWVGZGRlFkUFBaSW0veWdNSCs0VkdaWno1NnBkb2FV?=
 =?utf-8?B?OUZwNTNzajVGYlM5QWFuTE5Va1dNRnovUmtITkhtY1pObXArbFZnSFU1OUtQ?=
 =?utf-8?B?N3JudkZ2S0N3b2lnL2gybEVJS0pwZERZZjFHY29RRHUwb0xLL0p0OWF2aHBo?=
 =?utf-8?B?TUVBekdjSkJRdG9RUGxGN3FMU2tLUE5qWmxrSmM2NG1FaDkvSzNqeVlvaFFn?=
 =?utf-8?B?TVdGZHdvbXV0V0g0S2JpODZzTHhiWCtlaExRQzVSNElQdDlSZjlpa3Bvcnc0?=
 =?utf-8?B?T2ZQRmtJTHRjOU5HcFZjKzBZSGtIZUUvMWJFUXpRekZMNmtFUHNzODd6eGNz?=
 =?utf-8?B?czFva3BYRDE0UnVTcjBwTGs4SEtmN1l6OG1UMEh4eDF4akVrQWJyMHh2cXht?=
 =?utf-8?B?WFI5Mi9oeDJCNE92aG40VjZRbVE1UFM2L2xmSmJxcW9TUFNZd1VpRnROa1ZH?=
 =?utf-8?Q?qeVbGi3IjEmv9dtVgg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f01e5b-6c0d-4f2a-a977-08de78fda752
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 08:19:56.6244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4Q+gOBll+Qv6kUqpH9JyS4ZWjvJ1/XgFGw7VNyF7S3Ye+8dOPKNqwLFFKHm4d5NBuWh58MNjf58MABN0xtJ4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6603
X-Rspamd-Queue-Id: 83D5A1EABED
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72509-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	URIBL_MULTI_FAIL(0.00)[sea.lore.kernel.org:server fail,amd.com:server fail];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[58];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action



On 3/3/26 00:35, Jason Gunthorpe wrote:
> On Mon, Mar 02, 2026 at 04:26:58PM +1100, Alexey Kardashevskiy wrote:
> 
>>>> Without secure vIOMMU, no Cbit in the S2 table (==host) for any
>>>> VM. SDTE (==IOMMU) decides on shared/private for the device,
>>>> i.e. (device_cc_accepted()?private:shared).

"no Cbit" here was "there is Cbit in PTe and it is 0", rather than "Cbit is an address bit".

>>> Is this "Cbit" part of the CPU S2 page table address space or is it
>>> actually some PTE bit that says it is "encrypted" ?

afaik it is always (while SNP is enabled) a PTE bit that says "encrypted".

>>> It is confusing when you say it would start working with a vIOMMU.
>>
>> When I mention vIOMMU, I mean the S1 table which is guest owned and
>> which has Cbit in PTEs.
> 
> Yes, I understand this.
> 
> It seems from your email that the CPU S2 has the Cbit as part of the
> address and the S1 feeds it through to the S2, so it is genuinely has
> two addres spaces?

S1/S2 PTEs have Cbit. Addresses to look up those PTEs - do not.

(both are "addresses" - one in the PTE and another one - to look up the PTE)

> While the IOMMU S1 does not and instead needs a PTE bit which is
> emphatically not an address bit because it does not feed through the
> S2?

afaik IOMMU works the same.

>>> If 1<<51 is a valid IOPTE, and it is an actually address, then it
>>> should be mapped into the IOMMU S2, shouldn't it? If it is in the
>>> IOMMU S2 then shouldn't it work as a dma_addr_t?
>>
>> It should (and checked with the HW folks), I just have not tried it  as, like, whyyy.
> 
> Well, I think things work more sensibly if you don't have to mangle
> the address..
> 
>>> But in this case I would expect the vIOMMU to also use the same GPA
>>> space starting from 0 and also remove the C bit, as the S2 shouldn't
>>> have mappings starting at 1<<51.
>>
>> How would then IOMMU know if DMA targets private or shared memory?
>> The Cbit does not participate in the S2 translation as an address
>> bit but IOMMU still knows what it is.
> 
> Same way it knows if there is no S1?

If no S1 - then sDTE decides on Cbit for the entire ASID (with the help of vTOM).

> Why does the S1 change anything?

S1 will have Cbit in individual PTEs, allowing per page control.
>>>> There is vTOM in SDTE which is "every phys_addr_t above vTOM is no
>>>> Cbit, below - with Cbit" (and there is the same thing for the CPU
>>>> side in SEV) but this not it, right?
>>>
>>> That seems like the IOMMU HW is specially handling the address bits in
>>> some way?
>>
>> Yeah there is this capability. Except everything below vTOM is
>> private and every above is shared so SME mask for it would be
>> reverse than the CPU SME mask :) Not using this thing though (not
>> sure why we have it). Thanks,
> 
> Weird!!

:)

I understand I am often confusing, trying to unconfuse (including myself)... Thanks,


-- 
Alexey


