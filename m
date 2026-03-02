Return-Path: <kvm+bounces-72335-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDqZBQMgpWnd3wUAu9opvQ
	(envelope-from <kvm+bounces-72335-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 06:28:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B9F1D3160
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 06:28:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BBBA03017BC2
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 05:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D759A313531;
	Mon,  2 Mar 2026 05:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E6v/dwhR"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012006.outbound.protection.outlook.com [52.101.53.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABE61C4A20;
	Mon,  2 Mar 2026 05:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772429310; cv=fail; b=HRK7XxHIfBOVLX46lVg1wznFaIZWskFc27aaweiNyY1QZkV/1R1bRf7ThWB20eSu1zs1Xxn4teYn/3FlD8BnY7lIJKhqqd9lf9+faJiNXuX6QwESg0s2Sf+sm3xEkjkZybcyUZyeqd8js+nq0TPiTiZZmhK7ic7N0rIDEOY4ZPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772429310; c=relaxed/simple;
	bh=rBlunu+hyABda5G8SrVBUq1+BXb2Pyvqu3y0wt/pZbE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kIy4cF5DoldO5rPNM1BFmsJKnYqY8D7/KKqrSqNxUw5jQ2tNM5Q3m7+7EE6zq2J7K8zTTt9ukuotUnFddRGJAPLYtdjumXd9pRJbYmVVDnSEhBDaxe4ZkDtW3PWpohgDs0iJeujMF8ud1dQGLHsBxIoLMUkxOE3ikVvWq7uNY1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E6v/dwhR; arc=fail smtp.client-ip=52.101.53.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bHHnjEwyBtB7hCLNK0xvOUi94KKj9iDnDsX9UvM0aoYcvrPhXtHQ8Z93MLRZvF74F6dtCbGNS/Y07mJv7h2kIvA/OUSmbIKy23ytIFML3nHsNDkiLwk7GGN8FaPXQzbIbhfjlq+pro+JR/JcSlb2U/dtcjYSw1GkpaBbEaCEKH9k6Yg4IvAsa1iRNYa3MPyys4LtOT7WzKLBgijGDEygAt4Ckaa5kOPYHT17Q1Oh3DGn0o17xmmqNC6c+ib4A3SM+UzrVxL3BIU0/GLRjSAtch4gs1sQ3DCk1nCxoSoVInPMWheotwQViyYEgxTGBEMH/CYmmLSB9lVhPBSmpltoeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qn6LVGNIjQtQww+i7er7MfxnPo2pnw3TgDUDF2UINtk=;
 b=m2oDR/BXt31fQ7zXBHWVepQ+7NE3Xtc8PaL4QQaq4Yd6nFSxpS/SWd04Remwg41ZfrzlMngypitxnahme4qyWz/SEzCrqd0cFtyy9auO4wcbdZv5xWTZO9cxUsxBTMSLFSac1W7VRE7ApptRr5IIz8vfjW61a7b0D5UfM5tzPN04lkX6yU63p0WkzSoBF0jC2wBp9HiDPbrgwFvDcIvPESyR+CuupntfIw1QJ9xeqoWepQSRCN6uCSmu1mtni0H3LGe3VKMi9j7PWnpsN3zenDtQ+2f83yM5bnxi864QV2CEMRiRdpbnwblkM6Ke5rMSyM40gPcRTKuEVHirfvq1Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qn6LVGNIjQtQww+i7er7MfxnPo2pnw3TgDUDF2UINtk=;
 b=E6v/dwhRcCl5murh57w2CHD7vhpMVC/tDUBNvp7KJeIcsIpZwAijnJ1t2WSC5fMpHkLC6vVwoFTAzKofLCgnHToOSMi2dH43GcCIVNfKfcva7hubHv5Y//r+66IfQ+Ztq3Lbz/ykYWt2vn/BRyV6ugKBHIBUaB++alpiedJxwuQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by LV8PR12MB9450.namprd12.prod.outlook.com (2603:10b6:408:202::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 05:28:25 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.015; Mon, 2 Mar 2026
 05:28:25 +0000
Message-ID: <500e3174-9aa1-464a-b933-f0bcc2ddde68@amd.com>
Date: Mon, 2 Mar 2026 16:26:58 +1100
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
 iommu@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-7-aik@amd.com>
 <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
 <20260228000630.GN44359@ziepe.ca>
 <2a5b2d8c-7359-42bd-9e8e-2c3efacee747@amd.com>
 <20260302003535.GU44359@ziepe.ca>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260302003535.GU44359@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0125.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::9) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|LV8PR12MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c8924e3-bcc2-4741-d90c-08de781c86b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	7GKafOEmDcKTmEbMTZRGs/jBaqJ17m2wOilzR0d7P1CqLXAV8VK6CGYWShiQLKLWPKK9EYXCNYviFs+oOtwQEWEnih8kUrkwSjC06bmXlgMPpO1q65jGXelvXAK1sk4Nt8mzapclB/GICFJvpZZshCpl3CDOq9XeMccAGTzwJ5kt0E9ogD3/jpDwgHOWU6vcMAJyCES7tV5gankOwYnJJgzWbbgwXBqXGEhx5hQV86eH6JGP+xmOcm9mpnwtGF7u4jhQ6W2Mt5YLYhui8b6zSMTtXDRYuIwoyQffwwm4DrR9YtGBpBW81rJ7al9oIhOidtGrpI2r2nXuAsMPgm+nqu+XkIarucqDfQUBhT2L1rasx6Xdfbm1HZodsT2KBKtZj2sc9n8CvIn3CRKety21jaZGWYA7zQ4ibqlSfN697Mbu9qGIG1DfCvrXyKpd+W8kxtLU4lIOrFrUJwakPLRrXmEC23iuh0nzimOgqC/DqEi5M6ox18y0eIyLRIlRXJiRTTSxd2Xf/ztdH5DIBOBwbRBx/3Vgy2Ry7Dm2Vc0BI4ixJTSFB8fDO1wDoW9NLRLyg9Z1+D1sEMh9TCvfZ2srsL5rE2eXoBIGwsG8ZxCssDtvu3gZTGeo8prvqNVfKZOoOx6X96mtMcenvGxhgO8Vlo9htEt8yHnO0CF+3J4aA2GnP4cx1hGmKl99E/YGyLlaJnTm/rfqIAxxeI7XmR1TO+qiUWwkW/8VcJDcXnnadHc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWdyd0ZhNkZyU3ljYWpNTWxFZEoxZG9jRytHV2hObnVxbVZ0RGh0T2dZYWpV?=
 =?utf-8?B?VjZ4azZuK0dOSWxxRkJESmdjdTFOL3pwcXNUSC9MdjM3Sk1GN01qMEdtdVZC?=
 =?utf-8?B?d1VFS0wxeVBMYlJLVXpXMm5tdE5jNXFtUGpidzQzSUJaMUg5SFJJS3R3WWVZ?=
 =?utf-8?B?YVc1RUhrUkxLU2ZBSHQ5aDlPMDEwWi84ejQ2WVVzQTh2NjBjR1FJaFpQUnRS?=
 =?utf-8?B?N292ZTZMTnNRV2tUVjh6SHplOTRWS20wVUxzbWJ4QVUxbklqcitWdDlQSVpE?=
 =?utf-8?B?RFNmYTU5WEt5RnpiWTRWSi91YzMxZkwwM3JOQkl6aVZwSi9xa2dGZUFGUSs3?=
 =?utf-8?B?RWlwQis4bjZsVWhjcHZLV0hmaVFLRzdOcVhmL2ppNlR3WGo2bm9QeUt2cmR4?=
 =?utf-8?B?Q3RFYk9Ed2trdzRUeU9kRjVOMTFhaGU3WE9Na05mZi9pZ0l0aXk4N3NMUVg2?=
 =?utf-8?B?endlRUNTUjJta0daZ2l1RmVpYS80S1d3WmUwVHJSTTl0c1ZZTTFBenVqMlgv?=
 =?utf-8?B?ZEd1dGNVbVVxQmZmaG5sNmgrRjJTRHpmeVdzOWJ1cFJSK2hqemZQNXZBVkZZ?=
 =?utf-8?B?UFdEdU84RHBGZVZobFVvMW9CQW9RdEI4OFpqYjM5SjZubkprU0JvMUMvL2xI?=
 =?utf-8?B?SGdrTDJPL1ZCYUpWUWVtVi9tVWF5bGxiSFVwQ1l3eFV1WklyM2tqU3Q4Y0NJ?=
 =?utf-8?B?K0t1U1g1eitTNDZmZlQ1L0FKajMweHFCWGhjM1NHdnVmSXlKbFFhZUw2NU54?=
 =?utf-8?B?bDFydjEybmlRUEdHUGgrVGp5U1U0N0VrOVMwNXJoK1hrbzcrVjJLUHR3YnQ5?=
 =?utf-8?B?cDY4bVBDOE9WQzNhOFN6MUQxSWRHbUR1ZzhKcmY5M044NElsUy84SWZBaHFu?=
 =?utf-8?B?d1NKRmhyZ2xYaWtTRFF1d1FHcmRRWDBaMUp3TVJ2dnF4T2s2ekx0WHZFdzZo?=
 =?utf-8?B?RHJFNTc3WWFYMStTNE1kVzNOZU1PV3pYS3NnOGs5Uytsazhobjhta01KaUFJ?=
 =?utf-8?B?RjNsNlh6bmNHV094Unk0Zm5FRWdWcTh2MGNSd3RzWkE2MHBPZTRnbFpqV0wr?=
 =?utf-8?B?VXgxZ3lCUEhpZkRWcGJrUTloOHFxcEd2ZEJGV0hJbXQ4WjJ2MDdqT21GbWsz?=
 =?utf-8?B?VDFBdXBRT3RWYk1KYUJHaXpSSUZYaG5STTVwbUpGM2xFNEVydjJqWHZIR2g0?=
 =?utf-8?B?YUhmcW5wQXNBUnkrbnZYTzBaUVpLMTlFcHhzR0Z4OWx2M0p6TUlkRFJtMHgw?=
 =?utf-8?B?dnQ5MUI3ek53bTNRR0JoU1FBVVpjQklVeFg1WHdXeGRINGExeThybDdSYWxC?=
 =?utf-8?B?N0lRRVpPOUw5V21XQVFldFl4TDBFV1I0cVVPRFgxZXN5Tzd1MktWeGVYbGdZ?=
 =?utf-8?B?cEk3M1I2aXFBNFlmNkFnMmpmQUI2ZmFuWG5jdzJhYUt3NzlvQkxWSGxnNTVR?=
 =?utf-8?B?UmxvUjZCZk9ZeE1UakJlZjN0MnorUjc5a1AxS0VraytJMTdLK2dxQmppVWww?=
 =?utf-8?B?UmFMRGUyTVZSUzRidEtCRlpJUTZwUElPMFFwcm9lTkZOZGFSNVlMRGhWaWpo?=
 =?utf-8?B?Z1pMTlNuLzNmWHJoN25ucmR3K1FvWmQ0MnVSN1VvSDl1djRjb2ZqQWw3a29q?=
 =?utf-8?B?NWk5cDduZTlIUTdyOXlSSDhWb3VSbzV3SGJKVytRaHFYTUxkVFgwRmpXTldq?=
 =?utf-8?B?Mll2WENtVi9MMk5wdk12MC9TNmJscHFsM2N5aXhmMzJHdHV5eTFvamFRYWdu?=
 =?utf-8?B?bFRYaUs4TUlHM0xPc3dVVmdCTHByWVFrWmN0N0EyT3N2bnRmbm9NMEoyTmpC?=
 =?utf-8?B?UWlEeS9ENlo0L2VVeU9HSTVNNmlaVEJOb0NRTHAwaCswdDBLczVtWEVzT2xO?=
 =?utf-8?B?VmJkc2YxZk1MWEhEYnZkTHpQZ2NRUWhXTzlISzkwOEtHWks5Sit3UklQZXo2?=
 =?utf-8?B?YjFhSGw3OEE0Q3NNejRXZFMvUFJKaU85TDVPdHBOZkxTUEdXVmFVSHBPd1ZM?=
 =?utf-8?B?L29UUytvSGEreHlLMkZUVXZ3cUx1UHZBQSt5UW02SnB1M0VOMmlORFBJdktS?=
 =?utf-8?B?UDFoRTc4V3V5TG9sU2ZzanBVZlhwRGtCZUNiOEwwcjJqZXFhM251enVnLzE5?=
 =?utf-8?B?dWVnaGNpaDdwVXVZMk9OVUFYL1A2QU8vOCsrQWlaNjFrVHZtWkNteEFobzRN?=
 =?utf-8?B?UFFvU2ZWOHpzT0UwSVM2QnlBYVBzNjRZVnpCTUxSQ2ExM0M1Vm9MdklpSzZW?=
 =?utf-8?B?bUNuVlozcUdDTUlvOWd1MThsTEJSVzlQRkUyRkhzQktoRnBYYmp4OVRzRjdw?=
 =?utf-8?Q?Pj7lh0dyjz7et0aH4i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8924e3-bcc2-4741-d90c-08de781c86b2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 05:28:24.9816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7SYmYauJO9+Ght/72nEmXpojQZmQSrEMs6YjCsgYwq6/b7CFL2xJfGAv4zZsSsx/mdAVSRXhFWAoXcYEO14n/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9450
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
	TAGGED_FROM(0.00)[bounces-72335-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_GT_50(0.00)[59];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C7B9F1D3160
X-Rspamd-Action: no action



On 2/3/26 11:35, Jason Gunthorpe wrote:
> On Mon, Mar 02, 2026 at 11:01:24AM +1100, Alexey Kardashevskiy wrote:
>>
>>
>> On 28/2/26 11:06, Jason Gunthorpe wrote:
>>> On Wed, Feb 25, 2026 at 05:08:37PM +0000, Robin Murphy wrote:
>>>
>>>> I guess this comes back to the point I just raised on the previous patch -
>>>> the current assumption is that devices cannot access private memory at all,
>>>> and thus phys_to_dma() is implicitly only dealing with the mechanics of how
>>>> the given device accesses shared memory. Once that no longer holds, I don't
>>>> see how we can find the right answer without also consulting the relevant
>>>> state of paddr itself, and that really *should* be able to be commonly
>>>> abstracted across CoCo environments.
>>>
>>> Definately, I think building on this is a good place to start
>>>
>>> https://lore.kernel.org/all/20260223095136.225277-2-jiri@resnulli.us/
>>
>> cool, thanks for the pointer.
>>
>>> Probably this series needs to take DMA_ATTR_CC_DECRYPTED and push it
>>> down into the phys_to_dma() and make the swiotlb shared allocation
>>> code force set it.
>>>
>>> But what value is stored in the phys_addr_t for shared pages on the
>>> three arches? Does ARM and Intel set the high GPA/IPA bit in the
>>> phys_addr or do they set it through the pgprot? What does AMD do?
>>> ie can we test a bit in the phys_addr_t to reliably determine if it is
>>> shared or private?
>>
>> Without secure vIOMMU, no Cbit in the S2 table (==host) for any
>> VM. SDTE (==IOMMU) decides on shared/private for the device,
>> i.e. (device_cc_accepted()?private:shared).
> 
> Is this "Cbit" part of the CPU S2 page table address space or is it
> actually some PTE bit that says it is "encrypted" ?
> 
> It is confusing when you say it would start working with a vIOMMU.

When I mention vIOMMU, I mean the S1 table which is guest owned and which has Cbit in PTEs.

> If 1<<51 is a valid IOPTE, and it is an actually address, then it
> should be mapped into the IOMMU S2, shouldn't it? If it is in the
> IOMMU S2 then shouldn't it work as a dma_addr_t?

It should (and checked with the HW folks), I just have not tried it  as, like, whyyy.

> If the HW is treating 1<<51 special in some way and not reflecting it
> into a S2 lookup then it isn't an address bit but an IOPTE flag.
> IMHO is really dangerous to intermix PTE flags into phys_addr_t, I
> hope that is not what is happening.
Sounds like what you hope for is how it works now.

>>> Does AMD have the shared/private GPA split like ARM and Intel do? Ie
>>> shared is always at a high GPA? What is the SME mask?
>>
>> sorry but I do not follow this entirely.
>>
>> In general, GPA != DMA handle. Cbit (bit51) is not an address bit in a GPA but it is a DMA handle so I mask it there.
>>
>> With one exception - 1) host 2) mem_encrypt=on 3) iommu=pt, but we default to IOMMU in the case of host+mem_encrypt=on and don't have Cbit in host's DMA handles.
>>
>> For CoCoVM, I could map everything again at the 1<<51 offset in the same S2 table to leak Cbit to the bus (useless though).
> 
> Double map is what ARM does at least. I don't know it is a good
> choice, but it means that phys_addr_t can have a shared/private bit
> (eg your Cbit at 51) and both the CPU and IOMMU S2 have legitimate
> mappings. ie it is a *true* address bit.
> 
> Given AMD has only a single IOMMO for T=0 and 1 it would make sense to
> me if AMD always remove the C bit and there is always a uniform IOVA
> mapping from 0 -> vTOM.
> 
> But in this case I would expect the vIOMMU to also use the same GPA
> space starting from 0 and also remove the C bit, as the S2 shouldn't
> have mappings starting at 1<<51.

How would then IOMMU know if DMA targets private or shared memory? The Cbit does not participate in the S2 translation as an address bit but IOMMU still knows what it is.

>> There is vTOM in SDTE which is "every phys_addr_t above vTOM is no
>> Cbit, below - with Cbit" (and there is the same thing for the CPU
>> side in SEV) but this not it, right?
> 
> That seems like the IOMMU HW is specially handling the address bits in
> some way?

Yeah there is this capability. Except everything below vTOM is private and every above is shared so SME mask for it would be reverse than the CPU SME mask :) Not using this thing though (not sure why we have it). Thanks,

> At least ARM doesn't have anything like that, address bits
> are address bits, they don't get overloaded with secondary mechanisms.
>>> AMD's SME mask for shared is 0, for private - 1<<51.
> 
> ARM is the inverse of this (private is at 0), but the same idea.
> 
> Jason

-- 
Alexey


