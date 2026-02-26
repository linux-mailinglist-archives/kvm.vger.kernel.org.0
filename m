Return-Path: <kvm+bounces-71907-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOTWCE6Pn2kicwQAu9opvQ
	(envelope-from <kvm+bounces-71907-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:09:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 09EF519F4A6
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7EBCD3033895
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7600F146A66;
	Thu, 26 Feb 2026 00:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Y9wqBRkp"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012025.outbound.protection.outlook.com [40.107.209.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694DA3F9FB;
	Thu, 26 Feb 2026 00:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772064582; cv=fail; b=jzTOQxnoaBQaAtsQH+Ke3kaA40pVRp0hLazf4OCA7i7JOMd1EF9RgsM2EiomeqIosJYEWISYlHDgRjwJEQLc1bTx/lKctiocxJfLt/Tgudl8858tjTajL/2fQ+NZLFKjXa8pwHLgxHafA7crgtTJ9po6nLHaxre5V4LkbjpWdj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772064582; c=relaxed/simple;
	bh=g8MPRqsc+Yu2M26EoixHnFh9MdBdZSiuI8ismCNQRuc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UGQM3KYKrGXa00h12Y6BAfyuD9QfIJJfjBY2TQFmJpu8Ns/uBplxokMOhjdb4id4EwGAxw7pRKjI3dyNZctX+3vdd9YtptTFeEGqmGLK2+O5WryjkCy5tlVKPdT2vjpNXDAJTgO2aoTcncq8cBiyC3shanEGTXdLGbt5pXoWSmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Y9wqBRkp; arc=fail smtp.client-ip=40.107.209.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rYClGokGUB1q/W6zjMbkOGKNCJyzAHOOp3uB0+DpQO4lVkmnmHQ6XR4h0EqSmii2rpemzXcPo9yZo+u7qFmjIF1Ei3j8OFsCHVUt2arM9n/kUfTs9LwwTB2TLMpX4Dtujy/+xooLGAFKmjF44QqjAy3NzZbMF7KUI/b4+0oVyoyK26FsehPL9JcBxoz88tA86LJw+uWg+dyJmgZ6Rjl8liacI4oFvUyqoLqxvayJB27eD7NNG/VKs0VynnGT32JcHoKCgpoLxkpyhz+DtYQ9U4l8q6GJ+U0wA5MRJePRuh9zg6QSiYgHj6IaaXxevL3HCR3cwKiH0x5iS3ps8EiJxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jes4leqCxTCiCFuzCU++gW72f0gEYBeaZWmcpoOHG/c=;
 b=Q4KKdR3Xj6UETzClKgeFtRc61l7oth4QxLuwwyQkrxvEIu43VvLY67gJ/CcQR4MMjDP0c+CSBXN4YkN1Cbatq0Qah2ZRsDcKYfJVlPpiFeNJQKvzC2A4JQcYutVtjCTaF0eeH41HbOn6DMFUbJ9fzpnU7Ar0WM4VDHowmvU9oiEOoebVtMvKFNL85mPPjI7GVxr35QZitQlJ8rugSqE95TdFoIWAEnL9kPXPe+1fleUMWLiGMkAlNxgck2EJ1K4AgV9NvH7xzYONif98pUihKozfGJrsqVzLt7gWSV1gpx9254qbDQTSYBjzHTdPRlp7HBMhLyjD78+YKbpYaMxOzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jes4leqCxTCiCFuzCU++gW72f0gEYBeaZWmcpoOHG/c=;
 b=Y9wqBRkpnwBVsClt2pCU26iPS63BWla+LSuzPzlXNJ1gRns5af2WsdVC3GFtVyFpRwL/uxKP3NmthN7ooRhMOHeA78/1Cq9SsgVd9qdegO/tPzFJVHFELjU4PUFPE3IZREzw550MExoZu9vbaLmYlPKksF6bWvXRAjCRaWFKuDk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB7222.namprd12.prod.outlook.com (2603:10b6:806:2bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 00:09:32 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 00:09:32 +0000
Message-ID: <d8fd6e0e-a814-4883-9e58-f1aa501e0d8c@amd.com>
Date: Thu, 26 Feb 2026 11:09:11 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 1/9] pci/tsm: Add TDISP report blob and helpers to
 parse it
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
 <20260225053806.3311234-2-aik@amd.com>
 <699e93db9ad47_1cc510090@dwillia2-mobl4.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <699e93db9ad47_1cc510090@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0056.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20a::18) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB7222:EE_
X-MS-Office365-Filtering-Correlation-Id: 62eb64fa-c046-4b11-9163-08de74cb5157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	Aqz3hshTMvYw/u+Mxbk17RA4N5CtL9hEBhq407+AMiobkmPQZ96DhQ0eSJQ6alr7JXFO1A7ZZdvFnTLP06YW9/epO0+gViMxKgDEjESSMHaKzFiS3ulrmUj/cqsyjBaZfQQBaJ7cd5n1zZanY1ojXntDK2cAyZLTrsad7AJFo7hUh9ymiCW+8aw7t5hm+xweJ/BIoUNkx0mgmes9ffkUujKLLtL7IcqstV64c6oXPxdbLzkAi+AhZgbO2xQZN+onaDt2LeseXL2+LuQz6sb0Gz3WV+M/cR5BQnKYceIeaJiaizU14iuylzFON6A4gXUIi3YEA0VlepB81bBnr9oewmc1QPwUaxpjYYseaWjzwemkHL45wCmZqrBIGaS62NntE5q30qpYWE8FImDV0fRnfFdFDkAgK66wD+fGrwbMAf+LscQI7iii8hq4NnqyVAbvaNvY3u2w9f7ifvib1xmAr3IZsC8I68bjto2eu/TCz2m7aKSgDasLDe6uejrQhHbKsqViIPz1+w51VU5Tkw8F4SYhaZMryF1JoVlTQoKWLATQ2PK6ZtCpn2pzrp/L80NGFEKb3bJzfbzWP7oIuDPefkb8CqI6mjFHXkDkhpNOFXf+ewma0kBxMd85EuoSNIEhPfAiUnHUR4RLpsUCsJvJyUMrVopdOn2jpPtS9AnbUTMFB314YX0k0OiLtq9+rMgPJadxdpgUa+wMLOqGhMoRrP/q+cYabL8SYRkKCDwbwyQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0N0NE9Cd0I4R1NxMU1uWnFxdE5zRi95OGVuKzYwcEpQTkRFQmNKdlVWVjgx?=
 =?utf-8?B?eGNFTkthdmE2RVZkM040VUhONzZkRUVyS2w3di8vUmpsU2I5cSthUUU0UUdQ?=
 =?utf-8?B?M0c4elc5dFltR0RSVTRUblVsUk9QWTNWbzZqaDV5Z05JcFVsQ2oreW1OM3hr?=
 =?utf-8?B?MU5yOHhVNjlEdEp3TnN5U3o4Vk9QTGhvT3grZzZaZ0lWR1drRDByS05jU0Y0?=
 =?utf-8?B?ZFFDM05xMURpaG5zcHBTWjluMG1YTUZ5VFFoN3ExbUdtR1dYVm83MlJqVXVL?=
 =?utf-8?B?Zm5odGNJdXRxWEE4UCtGc0MyaXdmMFF5ZXZOblNsakI1TGo2czFaK0RHSFdO?=
 =?utf-8?B?Y2cyZ0k3TFU0OVlzNDJ2Zk1ndzVzQW9yc09tL2VNY3c5WTNiangwNmY0VGll?=
 =?utf-8?B?M2tXS1l0Y2lyRmlSakN5cDI2WFdXcWRFY1NBZmgzcHRwbzB5YS95NmhjTzgr?=
 =?utf-8?B?NWsxYzVUbmtYVEszbGFnSkR4SGFIQU8zdVpXN2V5ZEpaMFdUVWJNS2dTVXdE?=
 =?utf-8?B?SGx0RTVLVGhlNi9PQ1BwS1pYb3d4emt6ZGUycWtXdXFYOUVDL2xvK2tuQ2RW?=
 =?utf-8?B?MHMvRFF4eEJ6emxGdEtQb1krZ1RKaGJPbWFja1MxVzJRMlZLV1c4M1lqV3ZS?=
 =?utf-8?B?QnBCTTgxZkFodDRJazh2YnVrSnArSExhRnRiblloeUYxbTg1Tm9YdW9ndDh3?=
 =?utf-8?B?UGpkQmYxRVFDbkg1TFYvNzZlNkF5czlxZlNSK0UzeU5XaEpXNHMwYzdnR3RZ?=
 =?utf-8?B?QTdRcHNnb0FHVTlPUmJxdVN6UktTak5sMHl1L0JsR2VINHBNelJFRitGdDBl?=
 =?utf-8?B?UGQyVHEwYUo2K2JuTzNDYmRDcWltUi9wbGZUU2h2Q205SHFnV2hGM2tvZ3U5?=
 =?utf-8?B?WUs0T1oyZTVFTTUyc3J1cExyWkRnRVBKNDR6eEVDVjJ4VEkzVkREdU9tM1FG?=
 =?utf-8?B?Sk5QUDdTNmd4M2pjZEZFMlhqb1VsOWFhajAyREhQcUpRVWxQQ0I3VmtLeFBS?=
 =?utf-8?B?NDRESm1nblB2OUN0bk55anZIeFZTVWJnY25TQUlSbEFmWk9VTHRTYWg0SVpX?=
 =?utf-8?B?WFJ4VGtvVHdlZnVPdWwzMS8yMGVpbitQa1liRzg0bHRSTzczYVlxaXN5OEhi?=
 =?utf-8?B?bFFFQ1dWUXhYUjBUWkpyUE4vZUV0Y0dmKytIWnlpSFV4enl2ODlxSHdmZGpZ?=
 =?utf-8?B?REhIOGtwV3pZUHZtYW5yY3ZhNHN6NkV2R3pDRmZQWlhpYmc2czBaYm9icjhN?=
 =?utf-8?B?dWRhRGxnSmVBUWxFN0lKZktIa2gvZHgrbURwSlBrVFgvNlRPQ0dZekZtUkZX?=
 =?utf-8?B?anM5Sll4d0p3NEE1aDJMU2dnNVBzTlo1NnMySzhSREp6TUh6ZU5XQk5aYmEv?=
 =?utf-8?B?OUtrRFJqenFvbUxTZGNvWmNoL2Q2OXBZOWcxUkpTUUttT3llRXoxYjdwS0p0?=
 =?utf-8?B?N2tpVWdubHdtaVljRzVPQ2gzZVUzMXdZckFiTlUveGNZWkxjZ0NYam1hd1ha?=
 =?utf-8?B?ckY0emEzODRzNGloeHovRHBHMDBveEtCZ3Vhdk5NbFgxNGd1OCtUZVdqL0Nr?=
 =?utf-8?B?SXY2Uno1VlNtOWtia3Iza05TOGxiNHhEQmtTWWtmUnh0TjJrT1U4YVY4Q1Nr?=
 =?utf-8?B?eXphR2dTbXZxREtDNTU2amJ0UU54Z1l5ZGNLRlpmZ01UV2VyREp5eEpUaTEw?=
 =?utf-8?B?eXRPZnZMYXJiR3MwcWNZWEJGYlVYRFFjZmpiYUIwbEthdGhkdGRXbE9uL3or?=
 =?utf-8?B?ZmpFYUJEa0UvWXBpbWtuWEg3cHJLRmFnaHE5Q2pyZnhiTGl5blVQUitua1o5?=
 =?utf-8?B?aG1PcU1jOUNkZiszclA5UDhzWEhXSk8xUWwxWFBmSW1SdkJuaDBZNjdSOURj?=
 =?utf-8?B?TkZqU1pVUE1LTVZGZ0srUmdIc3RUL21ESTVPOE95UmV5cW00V3RxY1I1dzA1?=
 =?utf-8?B?am55SXpkU0JEL0M0dU5ua3NvOFNSNzYzTE44OWYxSTNQYUw5a1p1NWFQLzgx?=
 =?utf-8?B?dXE4V0FZdzFOa0R2MjV6QThSeU5rQnU5R09RaW1neHBWSC9nOGJwN2wwQ2w5?=
 =?utf-8?B?QU9BNy9MSnltQjVsb04zSWhqY0J4UU0vcGFCaUZPaStuV3M0M3psV2tybFhL?=
 =?utf-8?B?bStIRll2QW1KZE9xeHZIaElhcFdSVExWa0orQmtnRm54RkVDT2gzSFZiK1lw?=
 =?utf-8?B?NkF1TUZiM2h4YmhHbEhPNVNoTjFrd3lPUHZ1Mmt2cENXeG1Ka0JEK0F6VUN5?=
 =?utf-8?B?WXBmMDR6R3ZwaWRqc1dCYzZGOHBxTk05c3Zod0ZwYWkrNTdSL01ERXVaTnll?=
 =?utf-8?B?aDh4OENjbUhhV2FWT290Sk44aHRxVUtzemFIOHAvTC8yQ3ZlMHBZdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62eb64fa-c046-4b11-9163-08de74cb5157
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 00:09:32.7138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6CzmJZDfrhrM1SYImLTvR9B+51336lXAA4lkgxxRpe4pg/UB9kz9Cz6YcP9sRMackSuWz/igyrR96SAIgapKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7222
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71907-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[57];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,amd.com:mid,amd.com:dkim,amd.com:email]
X-Rspamd-Queue-Id: 09EF519F4A6
X-Rspamd-Action: no action



On 25/2/26 17:16, dan.j.williams@intel.com wrote:
> Alexey Kardashevskiy wrote:
>> The TDI interface report is defined in PCIe r7.0,
>> chapter "11.3.11 DEVICE_INTERFACE_REPORT". The report enumerates
>> MMIO resources and their properties which will take effect upon
>> transitioning to the RUN state.
>>
>> Store the report in pci_tsm.
>>
>> Define macros and helpers to parse the binary blob.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>
>> Probably pci_tsm::report could be struct tdi_report_header*?
> [..]
>> +struct tdi_report_header {
>> +	__u16 interface_info; /* TSM_TDI_REPORT_xxx */
>> +	__u16 reserved2;
>> +	__u16 msi_x_message_control;
>> +	__u16 lnr_control;
>> +	__u32 tph_control;
>> +	__u32 mmio_range_count;
>> +} __packed;
>> +
>> +/*
>> + * Each MMIO Range of the TDI is reported with the MMIO reporting offset added.
>> + * Base and size in units of 4K pages
>> + */
>> +#define TSM_TDI_REPORT_MMIO_MSIX_TABLE		BIT(0)
>> +#define TSM_TDI_REPORT_MMIO_PBA			BIT(1)
>> +#define TSM_TDI_REPORT_MMIO_IS_NON_TEE		BIT(2)
>> +#define TSM_TDI_REPORT_MMIO_IS_UPDATABLE	BIT(3)
>> +#define TSM_TDI_REPORT_MMIO_RESERVED		GENMASK(15, 4)
>> +#define TSM_TDI_REPORT_MMIO_RANGE_ID		GENMASK(31, 16)
>> +
>> +struct tdi_report_mmio_range {
>> +	__u64 first_page;		/* First 4K page with offset added */
>> +	__u32 num;			/* Number of 4K pages in this range */
>> +	__u32 range_attributes;		/* TSM_TDI_REPORT_MMIO_xxx */
> 
> Those should be __le64 and le32, right? 

Oh yes.

> But see below for another
> option...
> 
>> +} __packed;
>> +
>> +struct tdi_report_footer {
>> +	__u32 device_specific_info_len;
>> +	__u8 device_specific_info[];
>> +} __packed;
>> +
>> +#define TDI_REPORT_HDR(rep)		((struct tdi_report_header *) ((rep)->data))
>> +#define TDI_REPORT_MR_NUM(rep)		(TDI_REPORT_HDR(rep)->mmio_range_count)
>> +#define TDI_REPORT_MR_OFF(rep)		((struct tdi_report_mmio_range *) (TDI_REPORT_HDR(rep) + 1))
>> +#define TDI_REPORT_MR(rep, rangeid)	TDI_REPORT_MR_OFF(rep)[rangeid]
>> +#define TDI_REPORT_FTR(rep)		((struct tdi_report_footer *) &TDI_REPORT_MR((rep), \
>> +					TDI_REPORT_MR_NUM(rep)))
>> +
> 
> So we all have a version of a patch like this and the general style
> suggestion I have is to just parse this layout with typical
> offsets+bitfield definitions.
> 
> This follows the precedent, admittedly tiny, of the DOE definitions in
> pci_regs.h. See:
> 
> 	/* DOE Data Object - note not actually registers */
> 
> I have a patch that parses the TDISP report with these defines:
> 
> /*
>   * PCIe ECN TEE Device Interface Security Protocol (TDISP)
>   *
>   * Device Interface Report data object layout as defined by PCIe r7.0 section
>   * 11.3.11
>   */
> #define PCI_TSM_DEVIF_REPORT_INFO 0
> #define PCI_TSM_DEVIF_REPORT_MSIX 4
> #define PCI_TSM_DEVIF_REPORT_LNR 6
> #define PCI_TSM_DEVIF_REPORT_TPH 8
> #define PCI_TSM_DEVIF_REPORT_MMIO_COUNT 12
> #define  PCI_TSM_DEVIF_REPORT_MMIO_PFN 0 /* An interface report 'pfn' is 4K in size */
> #define  PCI_TSM_DEVIF_REPORT_MMIO_NR_PFNS 8
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR 12


I cannot easily see from these what the sizes are. And how many of each.

> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_TABLE BIT(0)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_PBA BIT(1)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_NON_TEE BIT(2)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
> #define  PCI_TSM_DEVIF_REPORT_MMIO_SIZE (16)
> #define PCI_TSM_DEVIF_REPORT_BASE_SIZE(nr_mmio) (16 + nr_mmio * PCI_TSM_DEVIF_REPORT_MMIO_SIZE)
> 
> Any strong feelings one way or the other? I have a mild preference for
> this offset+bitfields approach.


My variant is just like this (may be need to put it in the comment):

tdi_report_header
tdi_report_mmio_range[]
tdi_report_footer

imho easier on eyes. I can live with either if the majority votes for it. Thanks.

-- 
Alexey


