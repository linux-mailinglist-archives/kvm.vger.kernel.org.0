Return-Path: <kvm+bounces-72350-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gIpQNqJRpWkc8wUAu9opvQ
	(envelope-from <kvm+bounces-72350-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 10:00:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF681D5252
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 10:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AD311300D0E8
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 08:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF83738CFFE;
	Mon,  2 Mar 2026 08:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ljUrtZEh"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010035.outbound.protection.outlook.com [40.93.198.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F0F38A73E;
	Mon,  2 Mar 2026 08:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772441976; cv=fail; b=u82yQHdRWREn4T3qImb8PnIxJxOoyx+WdhlkBSXnNlPStLE3IdV7JEXzV1qJpbYucF8V/9acpwGrRE2vqhcjlLCvvDD7IwIaFh9uvjtR2A5M4HESaVP2qMrIxSTy0Vn6Vhcrb85wcHMHFERbZl3bRZyu1FFf1pgU5Iu0OUT9Xqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772441976; c=relaxed/simple;
	bh=o1Cj2x68Rzom0GXEjUbFdu2Lhpr9CR0buqu2DM4Bfb8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LAcOVaPtNR6CMrApuokS5G6SAVvY7uY7t1qM6h3u9LRCJT++qaW0mrbCBFgAwDft2NoWRHRhMo4jY3AGu4+H6SYgBh3ZEZNhnacV0Oh7ajbKrBQ1jjbL2OEh5dYcXTKwhcp2pT7YZd8sYdqtM23126opoiOhFklD4+vkkBLdgmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ljUrtZEh; arc=fail smtp.client-ip=40.93.198.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tX79oMhNdxWw/XQ3+GyAYqGq4XQtkrT/4TbYVdMTKfiETtFJl3cTFSwZYd/fZhsniEp5rkeuSASvmltHBVm3rs5Sh5c7S7Xz0zS93E6KYwc14kPcZZv+3rrrOBERsbrn74aXGYA+EnOh3qBIWS+MQU47lXkkISjK3PAVVFBGSQSHZU0MyU3j+hvipa/YqWsLuvajh4/+Y60x0wmFsPelUtURv6oQgbzmaJtUVdmTrEBMR8i8TzhEv11UCRtqzN+n4g+SVw3cOEIhE2c7fWby4F5H3CG8X2xpJ1AMVC62JhNVe+L98WzNAF05guY5DAggm4rRSTT5LmhuJEITnJhl4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kWy2F+oJWFmugvu5A1ciHx5tFgGvAM8g1dtdaqb+Xck=;
 b=fxLMx0FZkYJQ+aAh8H8GkdeZzkwXOQ11Xrv8bqLfzPKJLAjPZMOZmx/oolPsb+lK8EeixhezGUJMNG14QOuPHpijQwwcMLIbvl3koZv+z5Of2atzB6dcRGA5nOJb46z1XYAs+C5txLrI/4v5rodLHTvu4ritNXElpCHY/8vZ8EoxLdg2sbGaYahVH8KygVnqaODo58sfoWwPzqzmbAIjeWj5B46+0lFkY5u8fLwHOAfnrQhxEy/nsW3huq+AOOzXUsE1riHVuqYMCHil/f3OILA/aUZGCjDsA3M/rCxxryI+QFJ1Ued3kI7wpb3yVrQd15MEwxEBlVoj5fEuJdOnEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWy2F+oJWFmugvu5A1ciHx5tFgGvAM8g1dtdaqb+Xck=;
 b=ljUrtZEhdvzNydsGnlzjXpK7Zb9VWkzo8JWzGel4/yYiLsxGrahVK6hXE4mTbY+KMUyMrxUXizGbCR4j9yCIBcWtO/E8Vn0ig++YsBN2Y8Ue3E/08+FNTovSm/gbr7yRwft2itY9f1EqU2IppAfMXychtBAlDjggHZudEw/b4Gg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by IA0PR12MB7773.namprd12.prod.outlook.com (2603:10b6:208:431::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 08:59:31 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.015; Mon, 2 Mar 2026
 08:59:31 +0000
Message-ID: <77471a2e-2820-45e4-a862-ff0c47868cad@amd.com>
Date: Mon, 2 Mar 2026 19:59:02 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 9/9] pci: Allow encrypted MMIO mapping via sysfs
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
 Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-10-aik@amd.com> <yq5aa4wqtzfz.fsf@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <yq5aa4wqtzfz.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYCPR01CA0022.ausprd01.prod.outlook.com
 (2603:10c6:10:31::34) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|IA0PR12MB7773:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a1fd34f-8074-47c9-e78b-08de783a0477
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	rBEB2w8V5F9hFeo4YPI4zCQJXSWbCNwiT1ljKeW9xqvcKxSHupFnZIPDWmnOy2lMeP/Db8wZQ1FEmao3+9SuMZKq/UhnnNgNHfFlrP+G11M5jECOxSBSwpRkhBsmkwEbZZLlP2OspFElAC/e7xZhx98ozHKjxqarP1cay1zHcnoKszTh6zN5VFS5/WrRAN5M9S+FXTDCSZCjtrUL5PBp1SvI8O/SCrwlgoH36cGA/oaS1neKVjA3sdG8v4qScuwfkn2JswlVWmXYUVqFzDJ6Vn4Oh34mmVOof7CIniLmqeOF+6Jxp8ULqoXrT6VbolnWGDLL38r8xuMwjRJaNNwf20qU+IThpP+yX3JQzYF+4d4BsubQzTqk07ELXNqa24++WdMwYDSvqQojJ3uCdlfjQzS7keqCTbBSoFb2VYXq8AviRGbotpo/3LZmjdvg+ZyhFgHgKbqtu67C18+o5CFhsm6BmlGcmEVAqJsXzHpPQcaw1Bk3M/SukA0XlwX6oQU5Fy5R3rgCKJIx6CJFBhkvqiocmCCaSawWkQVmjVKoCHoWYXDpgL9i8igqmTpudbDHSd6e7o8rZRu5DGTKSiUotIYkqWJg64MJoPRuAoSc8sO1QV/hcRF6dztyuDUdB4fWATlIuCStBkU9Ou538JZ1Jui8mjD24EbZDnk0BzIlQFS4+6Md1xwVh4OHfhvqiv8cQPfzmcDRu7PD/qLG5rIUfOUpDmeR5yEgpe82mrMsC0c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0c3Y1pLT25USVZ5Nlhwd1JDNzNhTUZlYWFDaHhiKy83ZFpRWUJDSHhlcjRO?=
 =?utf-8?B?Umd5VzRyNjFOeFMzamFwOE1MN25DLzJ5WlRLbm14S283eW96NU9VanR6blU5?=
 =?utf-8?B?U3JSOUxwMnd4SmJxVjNZWWtQY2FSZFg3UzZMNzVDY1J2Y3pNdzBSWVptUVVC?=
 =?utf-8?B?Sm1ucCt4ZkJwaG51dkV2TU11ZnRKSVdwS3NXanc2akxtZXFTUU5MenBCMEU0?=
 =?utf-8?B?d042VjFHazhXYWwvQjdqazJOZCs2Nzl6ZG9uZVljWHN1bXVydXUvWkFHSElr?=
 =?utf-8?B?aTN5ZTE1S0dYQ2tqWm9Ec2VSWlZDTmI3MHlSSzdWQWdYbklGVm51TmdUbXRp?=
 =?utf-8?B?dHJSMnhsS0x4WTMxVVFuVXlCZTlPRDJlUDNlbTBJd2szVEIrc3A3R1V5eEl4?=
 =?utf-8?B?Wm5pUVJvZjRPbmJEUzcrZ3VZODd4ZGpvMFpzRXNQTzlXeU9zSlVmcGZhbE1Z?=
 =?utf-8?B?cnRoUkYvM0VpNXFycm1reUF6SHhxd3RsaXU2THUvWFRucEs2RFNOcE0yY0Vs?=
 =?utf-8?B?bis0V2NBRStBd3B1MlBsanA4cSs0c3RZbE1iWTI3TmdvUHlBQ2lYNkN4Rnk2?=
 =?utf-8?B?aGlCdytZTStmaTBJYzdwelVDSTYreTZQeHBPWlJkQktLbnJkRWVrVFl4ald4?=
 =?utf-8?B?a0NFamhPTmpvQXFEdzRrN0xmNVgrY00rRk1wR2s5bU94N1RtOE1PRXVLbUxu?=
 =?utf-8?B?R1d6cllOL0tTOWtOZ0pyTjdyb2FaL0RheDhtbXpkS29RVHRQbi9xUXIvZzV4?=
 =?utf-8?B?dStaTEU4MjQ2RDlZSStTV0taMjlKN2hTd3pUV2xWMExLM1U5bGxuTEJ2eGtp?=
 =?utf-8?B?aFJ4WSt2eHpwcGlrUjFDMTMyWnU3bEZ1RHR3V1l5WkR6UW9BUzVQb1JoY2FD?=
 =?utf-8?B?VjZqYnl3TDl3eDFIdzhCVDdCeEExbm43OFNpMDN6czdLNFVoMHlGRFB5c0VQ?=
 =?utf-8?B?T0g5NDhKdElHZVhsSlNXVUwvYURrdHlKdGNIbGpOYWJ1WkFRckdhY3lMT0lT?=
 =?utf-8?B?V2w4cEN2VnFzOVlEc1FtL1JkRWlDeUxkK0hNODBVdnlhYXZQY3YrRE1iaTZY?=
 =?utf-8?B?WDBpajRxelVBV0FRRldmM2xaZ1VkaldRNDFNeHVhbjlrK3grYWU0aVJ2SzEz?=
 =?utf-8?B?Y0hwMXd3a3RLdU1nZmYrbUNUYlJ6d1ROOXhiL0pZeFY4OWRMVnlqRXdFZXZZ?=
 =?utf-8?B?K0d4ZXNhUXp1eWNMNmN0U1Q4S3NVcE95VTZHUDNZdE9MK0JVTUtpSE1XdWlT?=
 =?utf-8?B?OGpONmE5SkU4YnI1azhJK20rWnd1NitZMVQ4VXVXNnIwa2d5TGJmMEhuS01X?=
 =?utf-8?B?S04xUUNmWFlIK3k5bnd3TUJ4dmgzb3IyWHVhYysySG1oeHd5NXRaN0Q2YnVL?=
 =?utf-8?B?WU5QNlBONWh5d2k1L1ZJdVlkQkFIMVZCQjlkWFJzYllkaVlaRDh0d3c4ekg1?=
 =?utf-8?B?RUVCeHJBV0haZDlEVU4rWXNaQ21oYnVIYnZzNC9sZWxMNWVtcGJYV0tlU05J?=
 =?utf-8?B?YXp5bkFoSy9JZW11eXJDQVNEd2YvOGN0UXV6YXk0VHJNZHNMVTY1aEVBeWgy?=
 =?utf-8?B?UlloOGg0UlZYWXZLemMyMWVTOGFyeXQ0eWxMKzBlWGgrYTdCQUtqR0xvYzA4?=
 =?utf-8?B?dnQzUDQ0MGVsbTJRM0FYTTlIQ25xVVRwN3U0NjNVQ3hVNmFubFNCbGVoOGwr?=
 =?utf-8?B?WE0zaFNxNHJDcFpnRjNPand6NWRuS3BKQzNPL3hFaFNvdGJCajc5UEY1L2NV?=
 =?utf-8?B?Y1BLblpMUnUwZHp0UEdmVU5wMHhSeEQ5LzgzS2dXamQxekZsU0x1bWl1SC9R?=
 =?utf-8?B?ejdmdFdyMlBMTmhFcTNaUHMwVTBtT3Vtb0pjbVJLMUFyWE5LZGFDM2pQR0FQ?=
 =?utf-8?B?ZE9VdHFMTXBtT3RIRlc4UzZuSDdqZ2wwZVNJYXluZU5ySEhibkxKNk85QVRN?=
 =?utf-8?B?OThOVVEwbWkyRXd3U2R0MXRpb29Xc1FsUERLY0p2UlVoOWZoT1RjMERFR3V3?=
 =?utf-8?B?UWd0aFJwU0NiU0pZUHdPQkNaY2gra2dkS09JNWY2YjZzcStDN0hJRisyb1ZE?=
 =?utf-8?B?bW9GK3VOTDE2SmUyMTNSZGtsbnNsL3lHQ2hpRlJ2WVZHM0JTUStUcDA3a1lH?=
 =?utf-8?B?Z1V1NWJLZEtRS0JxVGtLRFliVEFKcmRUdWY0Vkc5SEh1SHlHYmF3VVBwajhY?=
 =?utf-8?B?N3E5QVpDMUdyaXJGRGw0VnFHL2gzOGt6eC92cGdBdVdveTlFRlZRc1R1SnpK?=
 =?utf-8?B?OXJzQUtCOVlWajFpTkxBSTZrUU14RnBFOVZlQXpDOHVuZm5QNmNNSUpzQ3Y1?=
 =?utf-8?Q?Q7VK8dXf9ybSzWi0Tc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1fd34f-8074-47c9-e78b-08de783a0477
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 08:59:31.4399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3Hwm42o9iM1wwl/MVxTnhwN8WIzrtPrbw8O8SICuBelxYWhBAsejdShSrnwg0PZ9iQJyY7MHYZt7IFzdT4CuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7773
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72350-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[57];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email]
X-Rspamd-Queue-Id: EFF681D5252
X-Rspamd-Action: no action



On 2/3/26 19:20, Aneesh Kumar K.V wrote:
> Alexey Kardashevskiy <aik@amd.com> writes:
> 
>> Add another resource#d_enc to allow mapping MMIO as
>> an encrypted/private region.
>>
>> Unlike resourceN_wc, the node is added always as ability to
>> map MMIO as private depends on negotiation with the TSM which
>> happens quite late.
> 
> Why is this needed? Is this for a specific tool?


It is not _needed_ but (as the cover letter says) since one of my test devices does not use private MMIO for the main function, here it is to allow https://github.com/billfarrow/pcimem.git to map MMIO as private and do simple reads/writes. Useful for validation, can stop in gdb and inspect tables and whatever. Thanks,


> 
> -aneesh

-- 
Alexey


