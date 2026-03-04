Return-Path: <kvm+bounces-72681-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BBpC/8oqGkdpAAAu9opvQ
	(envelope-from <kvm+bounces-72681-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 13:43:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A541FFC4D
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 13:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A5F48303075B
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 12:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47DD71C84A6;
	Wed,  4 Mar 2026 12:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="djQmuktu"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597C71509AB;
	Wed,  4 Mar 2026 12:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772628208; cv=fail; b=Ls5b+Jr/8of8PVjFqQoWUQlp+418Dfve5Jqudgj6kKnYR3ZZsM41fL1eVq8xvofHmxKZ6BWxpGr4VRO4Im9Y/svVySIHhKyWBWwmgdyni1GnSND9fUnhVu5ytT/kUXI37QS8hIAcKj60lu23FzyiLW9dzsXZ2bjaQgpz01gU+F4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772628208; c=relaxed/simple;
	bh=fjx+7iS7zvciK7ycQfbJwNKwNMKJlPUi6DVmLh17tBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kzNcokS8TfWGtbPcO5l5u9Lf930rtZozNijTnnVD6P1J/rMv0dibqb9WciBuZKY+0mILkCC60SmlFtEC49GLyImwBL2LOjKMN6zfADbTb+G5UqKzIF/IfrUGIb217heB4qvWz3z9MHqcsH/OJOJwiiX9YUH2/fqu8TwHWWM/S64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=djQmuktu; arc=fail smtp.client-ip=52.101.193.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HrlBWIbBWhBGel8RsQCYcbQLhBVYCB30xuuR2zYn9mpfU8dkQXotAIoyymUXReXroquKT59E8nfomkWiuGe9QKKTLr0G3ok9Hq0TSSMcXEaDo9/8WxTTCdqwwwEC+HEurJelzMz2uSpGH1Ps3H6Cp714mW9aWotcaPXUDYtpEBwl6Vpm2+YbBYyfDpq8AZN8f5vyN9AXTQTl6ZYeEah7CxDpY4srLlYMBBX4dWOZeXycBqIa/W7M7U9e0eP74vbnAXYFF8uZX4L6L2Rijula4JdRoMZMPSd+PoUcSS7o8m2z0VRStxPOgx6Z367hEIz1FoXgxYn1g1Eb3FQUDj6rYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjx+7iS7zvciK7ycQfbJwNKwNMKJlPUi6DVmLh17tBI=;
 b=dEdKo+ZRAsWN9RvrkFjBtzanniBUC2YhlO0/M09j8jGI0OzDXOrxhyxLteWwCO+FYZ2QkBK8x+y8wvPWJFW4KEPI6ECEvVs/W6AktXkaU9eVT75iEDNM9cnHr1WuQtWfDShv7mEAaU/15Cqpldc0ln1kJ3Nc22NnQi67uwXyxgOV00uFh8atROyF5a4b6CIuJ8wn8093anNJZJ9a3OwDDpNhFFI86N/yaQJqREkiAvBZ96uUjEciRlFNmSljlJBEypCcRW01CyIcU6xTfNXY4DarfPkGsSsPChLYUiwiTMImZXN16gdTqcj+k+nx46brzWhDuLRDZWuyTMKctAaYSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fjx+7iS7zvciK7ycQfbJwNKwNMKJlPUi6DVmLh17tBI=;
 b=djQmuktuXJ+DCCVIiz2kr8TyHvHREM5hUTUncSQyM2oBCMZMCtBZACVy5vpgkLKSFJ9X6aSBiBN/S/IYlofDXnWEbMZMWFnepzDaHiy5bk1bzfguezvxIYScPswH8nHaal9knmbPKGhQVFNfgHyc7U/SdSooAn2djRwgkHt4s5csmhuXt0k14evlM6gqgvj4b8YOc+zup+eO5Lzcs/2YWpj370zcc/7QoOB7cNsFY04og/hIp/Y7R3B2928pIZwSETpoK3DQy4y4HvIrtiFUClBLBzDwst7wzRpI6DitCLcOWqC6/egoiZgg6DmJtSrC+dyZVbk4o6J5eduGIShrAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6222.namprd12.prod.outlook.com (2603:10b6:208:3c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 12:43:18 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 12:43:18 +0000
Date: Wed, 4 Mar 2026 08:43:16 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: dan.j.williams@intel.com, Robin Murphy <robin.murphy@arm.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Melody Wang <huibo.wang@amd.com>,
	Seongman Lee <augustus92@kaist.ac.kr>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Denis Efremov <efremov@linux.com>,
	Geliang Tang <geliang@kernel.org>,
	Piotr Gregor <piotrgregor@rsyncme.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kim Phillips <kim.phillips@amd.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
Message-ID: <20260304124316.GL972761@nvidia.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-5-aik@amd.com>
 <699f238873ae7_1cc5100b6@dwillia2-mobl4.notmuch>
 <04b06a53-769c-44f1-a157-34591b9f8439@arm.com>
 <699f621daab02_2f4a1008f@dwillia2-mobl4.notmuch>
 <20260228002808.GO44359@ziepe.ca>
 <69a622e92cccf_6423c10092@dwillia2-mobl4.notmuch>
 <20260303001911.GA964116@ziepe.ca>
 <20260303124306.GA1002356@nvidia.com>
 <5d669086-a5c8-4e55-8108-a9fff41cf094@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d669086-a5c8-4e55-8108-a9fff41cf094@amd.com>
X-ClientProxiedBy: BL1PR13CA0348.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 69756e54-921a-4523-2c7b-08de79eb9c2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	DNaoNkkE5qm6r05ZF9rG+/KqKa90eS1YOjer6N99tIqSZs2jowVI0M5kQjm/pGWist9X9VnHM0ZIo3CnbA25lKmoKP5v6yRDgWLeJJl0kCuyGYRnX6MFVf0Yo0l6oXJrLaAcSDRCkKoTm5AtO+lsOC1mSDEK+ubinPjqc4KEKOaKRSTTe9jNWd71f4Ye8N24/bFXDDfJLo5ndPAKmGy3C1iS1Fc97bNKaT5WEC4MezliwiGBiwYyidKnwxx4q/XoqQVekIUSeavpWhp1YuMRTXJ6Dm3a7Ncuv32eu3ievzJUBVKLPJWLNrlR1u+E6Rborq/Jd9RoW5BHeOfdMQCqr+jKuyCsij1UI2Qj8J6qTcYJ70YTGtzOf5Z+TS77xabnoHTZ9cUtcLSSSW1dr44b2Mst9VyBcBq8iX9/vWU1Rwr4LfYbVr7JLDTDhwUPiQi5hWFTHQVhlqSaGoWAZwNyoP0GsMnWXtnf96wpvveUS05w1FgWTOLdDBgVrpDGjV0HDfW8cH8RU33lm7tCFlK3LSuoJZonfeLxoVqFZYAlYZJYQYXZFiK0KJf2jgytn/L2exWVl0fPGOR9taBeURr/G+4WTPM5u0sKftfGvCsJon3oxpJPENuBKMyCp5pffLDLD6aS7NvI2Hhp+Qs9UWPwdzqyN9OjOVONbg0gYcYpiNmIgzxsHwgFk/pEuOEkP6hFS2C0VOmpDKKxYWEjWFhnM/mVFe72j5L1j/ixCzqB+ew=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gcftIQnGC1Qk7HSfMuJaPdpl/vPhK110unKsXA6fxh1/Nn6nL2drXEl05Zfi?=
 =?us-ascii?Q?v+TdSGSUgZOXkcxG4As5oPHpCrxrXnqh6Xyb93xhNLf1N//oiAXx0kYxXoUZ?=
 =?us-ascii?Q?Ch4bvijvSJniXyj2o3XR4j4X55IaY09ZnabrowGWphlW7VYP51wE0zp6DH0G?=
 =?us-ascii?Q?BqOh8k1tMP3eWr5VYzXU5RS4Y91l+7OtIpOJfwdVFyixLusamsdLYMm/0qGm?=
 =?us-ascii?Q?4RRlilxUIaSyeTSQ3t+syMP/Ow23iLM+D5E6MsdLUoFLAD4veJO+BIXtec3T?=
 =?us-ascii?Q?NZ23YGkr0eyyXE37S3OM4RuQQ94vB7tYPu9ALtnM/4x7K2rTF6Brak6ihOap?=
 =?us-ascii?Q?QOJATM/Zh1GYyqwSedBp1xwdB85OmeGwtxqLTKniZIi8A/pC5qsdwCSSq4JW?=
 =?us-ascii?Q?FkoDDAs00C75rMWGmZNbhGC/Y2fLRFdtUxYcOGQg3U4rn9erfarh4EnjgNZc?=
 =?us-ascii?Q?xRIgzCmQnE6DbcPuAKB9RNlNHu6n1rts98yktjKBc1AcKHn0YkeknbQe0t+n?=
 =?us-ascii?Q?vgngXoCBEo6unyHHOcn2VqbbCWBRkWkjGPfNiGP4+hs5zFL61dDIYdNin431?=
 =?us-ascii?Q?0bdokx6t8pFaP0dsmoT1BcFYTMkjQATzvab2nOlzRkq/OVrX59SyJHsY8KRW?=
 =?us-ascii?Q?V4/qjLhf5kSpK8XSlPaYsvJPeseFFGqSUrLznRqa8j/7GCkmscJ6t2ETwtod?=
 =?us-ascii?Q?9iSTqG1zssjXTOwp3iZ7bXsIj5UQeu6wtHh5tJ9oIDUiZ6AXlLU/GPsCOrMX?=
 =?us-ascii?Q?5U+kPrjUWhgNsOLBSzQS+FETkAPCXvxHS4ZEqe4rFKd3vBBk3B0kSoWllFXr?=
 =?us-ascii?Q?vp4MJhoGHfd3dkmbvbuRka9rPq652to731rkshxUP+c3hostTlWIMIhOAPp6?=
 =?us-ascii?Q?Bl/jTg2sSDh6hgeg1DOhBc7vKYNUXVLzMIs3m3utpn9X7RRJk8GCkdLNCovO?=
 =?us-ascii?Q?FztKIcGXVgHrtaaKoR2cw82Wr8BgLgmvtvKyjOffFbotuFtU9W8aRZk1TO0X?=
 =?us-ascii?Q?eZ4LATBFjqy/2yRL6Uj5MBpLWzDDtV1rRfbrQdnxPUYxUPWLVPu8HTyW5inj?=
 =?us-ascii?Q?wVMuT3ANEKY9RtPKGlHXZmB4Dn//tV2+G2uMbJG1FpV34dL0fqdLqV+gNmRR?=
 =?us-ascii?Q?+CehZ4iaQJKgfzQrROLoI6RI/gf/hekrIYfmEf/hPUULwzp9S6i/N1lYEXmN?=
 =?us-ascii?Q?WDwYiVpHeBRbAJUWUKS0avhJpdOEw+g18gziYczdys/pnc/HfL69CFQnYYs0?=
 =?us-ascii?Q?rI3U/RvTv0rhpiEunGbHtnlmcCOfHfanz0HOQ6YUmeddKb2PgFhNZiQTQxom?=
 =?us-ascii?Q?ZefbEHNIy6ZqvH035WlHrI8S8zMZJ7CGxhVhInKBmUFuvcyDXUkRYxjurYTU?=
 =?us-ascii?Q?vA1+byQqD7+GyEFL2dMXjoJW8OaKF43uHDGAaIzekbNMtgPFWX0DQwPXEh3o?=
 =?us-ascii?Q?HQOPe3fBzvNDoG4c4mVIhwwtF/IzJko+IbLFNKOlZDdcVjXliwm4ySJW/T7a?=
 =?us-ascii?Q?aLlJDVNno3eHJ2Y0RMxi0KOnFxfEkH7gJKL5oaC0AiM6Oksju66twuG0aRHy?=
 =?us-ascii?Q?uWOtQQMhhgzzJHvTFLlq01/uWv05LPuaAqDB2rfpd1JJKCPg1AxeKrwDXB/G?=
 =?us-ascii?Q?Wo6Zm44b53/Spnh00YXPKgWYXfQL6xxSF6lebH0E0fzqRd8DDEtMR7MzmLFk?=
 =?us-ascii?Q?CpysKHO+tn1BvIcKJfSJ93UhL8I5A7smBNQL/Gvw1yDSOPB102mbu3Nwldqa?=
 =?us-ascii?Q?jRl7QJ5OGA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69756e54-921a-4523-2c7b-08de79eb9c2f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 12:43:18.0796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EloZd/bHkCes+B0M546kdDs1Hrzk83EaIsudh2vrXR10lSBADR25ADOjQ+ct4WJy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6222
X-Rspamd-Queue-Id: 24A541FFC4D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72681-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[58];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,Nvidia.com:dkim,nvidia.com:mid]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 05:45:31PM +1100, Alexey Kardashevskiy wrote:

> > I suspect AMD needs to use their vTOM feature to allow shared memory
> > to remain available to TDISP RUN with a high/low address split.
>
> I could probably do something about it bit I wonder what is the real
> live use case which requires leaking SME mask, have a live example
> which I could try recreating?

We need shared memory allocated through a DMABUF heap:

https://lore.kernel.org/all/20260223095136.225277-1-jiri@resnulli.us/

To work with all PCI devices in the system, TDISP or not.

Without this the ability for a TDISP device to ingest (encrypted) data
requires all kinds of memcpy..

So the DMA API should see the DMA_ATTR_CC_DECRYPTED and setup the
correct dma_dddr_t either by choosing the shared alias for the TDISP
device's vTOM, or setting the C bit in a vIOMMU S1.

Jason

