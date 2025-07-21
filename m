Return-Path: <kvm+bounces-52996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F3EB8B0C6A4
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:41:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B9197AD4D5
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4322D0C7E;
	Mon, 21 Jul 2025 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5Zfd1mkt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595492D3EFC;
	Mon, 21 Jul 2025 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753108867; cv=fail; b=FeGHDpxmFocTNOpjZHcinV7wwrMv0uX3KsfI/YLeFXTtw9ayMQ++MW+0RIGoY0njyIfnyib6Zi0bqJbqu6bY/RVrrI6k7qewqA2zqrjZw7Sv42B1vs2MITvZf341zyx4oaCRIp4MSs8k9DE52RS6LnpoIi2iv4jbBIbnW/Ty5mM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753108867; c=relaxed/simple;
	bh=jWNd/dTTGkziuannZNzG8H8AQRtzUfm6ysRzfFUlEkE=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=Q9TJk8TDMxcI37nO5vXazWeqHe4++mXVOpOskC+C4/jdL1UX6CgsvYEsawiQmJLKxjQ+BhpYP73c0XNAmWe5TSp+heUjVu6BJbqbHl526uL+rVlIIzLcP2ur7Ks2D9fwiqRSwktQvSWd3ZvvWhtQFzxCqvbd6TQgODxwkQmzWG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5Zfd1mkt; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PENhitOFYarvMeLP31QKwzaQ7zcyuwL4tgK8Qd3QoSLBXN4Cv8sKKoMIIcyZvKqnDmO+AMKWwdtnFNTmeiXcYO7Oie9A1hNy5d4DKSiCNFDEOgwOuClKfH8Srwhs2HGT0kR26B8Zk3YeOVmqqGwbX7BQIigOr545JNwYxH9jl506SumB4HyiGRduaGbDGKdAKu04/4RXVCjLgF32XGYdFUBYj9I25gvt42fAi1P3S645+jlhBgoxjVc1z4fWNx0aN6Mr5vxJUvzXPfh6ulFCAB0b+hls1mlkQvKiTmBvD/UPwWN9OaLuuru38jiGfrfKYNy/7iQ8k+Kxp/+DnoGt8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nM6XqEemJLH0pPmFCnXTWW0q7kX7X5KlaY9XlWaxY4=;
 b=UurLcUEe4yn1y7pLe3hKhZHJYzf1YqCIpL/TREXhDwTe8hcmI3hyQeHP2kQCuKbQUl5NZm34Kee+xK+8dpWgn8el6y/cdtAkgVh7glTefVnLGoEOY/1JYWW+g8sDGAqysz+d1dODq9Fi7L6ItOYyyv+H/GqmdIphxFTuML/eSnSY4GpME3podV6U+eZStnFTNbx+xQl3RDHFbpbM+Dm8qX4LDlKR4hVlW1eFW1zhijGi6aE4IJl/7D7ILOsoyzda6ljx7R/QELiQ9fq+EsCr40nZvh18c/v8ot/3OuNLT1BGTHFxBbOsnXyH7MadVht5oI8fNfuUwCp2H+EEA6EGXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nM6XqEemJLH0pPmFCnXTWW0q7kX7X5KlaY9XlWaxY4=;
 b=5Zfd1mktFUNNvepIafIdiUJqTqAZNR+eD4h5Of0AwYpXj0CX467JjUn1VlDw8c+pzZPQ14wSnDD50I4pcOkODgGMYKJk4ELmzt+S+t7Iu2b+8rBYugdSHkJaaBboiHaQORvu1TnekjUnVxl1QtOt7hpFYaKXOIqF9Q/+m5p8z+M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB6495.namprd12.prod.outlook.com (2603:10b6:8:bc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Mon, 21 Jul
 2025 14:41:00 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 14:41:00 +0000
Message-ID: <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
Date: Mon, 21 Jul 2025 09:40:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, kas@kernel.org, rick.p.edgecombe@intel.com,
 dwmw@amazon.co.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, reinette.chatre@intel.com,
 isaku.yamahata@intel.com, dan.j.williams@intel.com, ashish.kalra@amd.com,
 nik.borisov@suse.com, chao.gao@intel.com, sagis@google.com
References: <cover.1752730040.git.kai.huang@intel.com>
 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
In-Reply-To: <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:805:66::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB6495:EE_
X-MS-Office365-Filtering-Correlation-Id: d0796f26-acdf-4261-609f-08ddc8649c12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXQ5dG12bTh3bmtlb1U1NDdoWUMyTzY1RmpBUERTVzJ6VUtWRklSSjl1Si9B?=
 =?utf-8?B?cjVrdkdiUzhldkpsVzNWZlQrQVRSblhpVkZDcTBMVnAwOWZqc05ZdUZ0RjFx?=
 =?utf-8?B?aDlYbnkwb00zclFlL3o0b093OTkwejRqMWMvdFo1Wm1wR3d0N3dHRThHVHlJ?=
 =?utf-8?B?d2NPYm5rMk9wNk1VbTZoTFNIaXlKNzdsZmxxU2hJdzNNZVpVbEZ4VGJSNXN1?=
 =?utf-8?B?UXpvR0dXaEEvVVlScHFQODFBdUJGK0c4UXlaVXJzOHR4RmhLT0ZmNUZLcW1I?=
 =?utf-8?B?REpuU0dqT3I2c1JaSThac204cUptZjUwSmFLYmhPNEU5cmc5bVBwUE9PMEpG?=
 =?utf-8?B?bXgxWlR6TUNKdGhjVEdONWRrcTFXOW1PNytFeTFCN3FMUU45SW0zcURaNVFm?=
 =?utf-8?B?WmdtZGtqaVhQbjI5d1Z2WTNJSHRWamQ5VlNHN012MDd6dDU3WDIxV0h0YzZw?=
 =?utf-8?B?UHVQQkhlcGR0c3N1TzQyZGo4K0dTUWpBVDlEeUlaVUNPTkQrNmhLTUZEVmtM?=
 =?utf-8?B?WUtZU3lBUkRNUGw4cy9kMU5WSU04YXlxZUF1TnBXay96MkxnSVBLbTJzL2w1?=
 =?utf-8?B?VWJ4M2Z6bWlDM1NiM3NaWG5HYTlJdHZVcGNtQWtRbm1tWG93TkVDL2ZOOWNv?=
 =?utf-8?B?M081eEllRWxiZG4yYkc5VnZqUXJYVlY2NmRTVFh3ZWVmbXg1d0xhU3ZRZHdx?=
 =?utf-8?B?amM4bnZmSHpWdzdLVWpoemd1dnhjcWNjMDIyNTV5ZUw0amVYMnhBZjZNc2kv?=
 =?utf-8?B?NWV3eVNXanUrQTVJRTg2WTh6SndnZU9FSCtieEI4dlV4YUM3RkxROW50ai85?=
 =?utf-8?B?WG90d1VPZTkxVnh6RzJsdSt5N2ViUDArb3VZWko5NllqVDM1SGFUcnp3bEda?=
 =?utf-8?B?WkoyYXdKOVA4MTUvQUptWE9wRyt6MWZmR3NnWkQ3VlA4ODFNUmJ2N0l2UTVw?=
 =?utf-8?B?b2l5Y3FlMDN0NXNURFlIRHNTc2NWMDVrR2RFQ3dnWnAvVi85OFNvWHVUTVZa?=
 =?utf-8?B?RmpseUpWcmE5WUJiakZEM1JYbERxcDJmT3NiRllsRjUzQWNRR1ZHU0NKc2F5?=
 =?utf-8?B?U0E3UTE4VUliZVBnRUYvaTQvWU5SZkhGK0tNOXIrS3laa2ZUWUVIQVpUUmRn?=
 =?utf-8?B?YnZwUGJHZHlOOUtLNmxhMWVESkhJQXFFZFAxSjJHMEc1bTdUaTliVm1rSUtU?=
 =?utf-8?B?QVdWRVUzdEM3SGNHRDEyVGNuSm5xNHIyOGFtMHUvM0NHN3pYR0FRbThRcGlU?=
 =?utf-8?B?TGl6UjQvMHlzZFVmekhsYm1PbElDemNGY2NBWU5hbi9KZnVRNWNSdXFTTGt5?=
 =?utf-8?B?d0xYaXNKeC9ZKzhYTHJSNGVhRENwT3VnS0JHbThXOFBaeXdTRTJOSldBb0hP?=
 =?utf-8?B?RWp4V3RSUDh1RldBRkVTZGJNdDdpZ2QvcVJRUG80MmJDMmpZUHg1dG10Wmxh?=
 =?utf-8?B?OFZNRFhtYWdhQ2FOSFlyNWxCSE43RWdXQyt3WVNMelRNeTZRekVIeWdlalQz?=
 =?utf-8?B?UnFpUEFTL3BvbFJNQW9lOGFlWnk5WWd2VHM1NUJqMVNJKzFDNjlONStGaENH?=
 =?utf-8?B?UVBSZm1ndXFzc0JGcVp3MVFHbXA5UGZEb0h1WTdQNFAzd1NsQUVxeGU4K09I?=
 =?utf-8?B?dTJ2MmhCVkRlVzgvQWkra3o5ZUdHR09qMEs2RU96ZEtoeDB1L1N3K3pheVF2?=
 =?utf-8?B?dFZ1eUg0ck55UFc4ZldNQWltNEJLanVNditzMklHM2xMdzd5NE5jM0ZQM2NR?=
 =?utf-8?B?YVBuenhpRFFldzA0aFJoTk03RVozcXNoWXhaazExY1A1aWMyTVNTRE5obXk0?=
 =?utf-8?B?OXFlRHo2a1pjTlBybkJLeU1QRmtpOEF2TjhIQjBKSlJWTDh0b1F0OCtPUGpP?=
 =?utf-8?B?ZTlvcTJZTWtZOXdKR3JJcE1HU3l5aThSNGdaSzIrTWE1TENkOCtOdUh5Zzkx?=
 =?utf-8?Q?dllHSYt597Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXZMWU95YlZrSG1QRmdBdDdTbFBoT3lqMzdRMjNQV0RxdkFoUGdxQ0czVFg5?=
 =?utf-8?B?SXJURzV4a3lLVVRsMEpONGQ2d0dkVTJzSlJ5U2d4QmhOdXZmUDhtajMvME5x?=
 =?utf-8?B?aUV5cWVCaG5vVHhZRHRFd2FZWTVLc1daeVNhcUNDU0s2NnowcUsxYU92ZnlS?=
 =?utf-8?B?dkcyb2ZNSWs5bDI5K0N0ZXVqRHZnTGJDWGtLYkNmbXYydXQvV2dMaDh5cFNi?=
 =?utf-8?B?RU5hUlZZaDZFcFZpNzZCL2dueldIU3B1S1BiQkswbWI1dHNjSTY5RTR1YitE?=
 =?utf-8?B?NGZ0KzRnYXA4ZTNpRnNlRHh3ZWcwSFQxbklxRDBEZzNraDg0d2pJT20zRzBa?=
 =?utf-8?B?ekR5Nm9JT3dNb3ozZHROWDBDYUlTT2JHUnRSazBFUVJ1a0N3d3RmaEtZdlJu?=
 =?utf-8?B?Mm9oN2dYN0VEeTBRODUvbGQ5c0MrT2dMbjVlblpMaHhZenZCYmNyS0g4djVJ?=
 =?utf-8?B?cExiMDlyUEZGY0QwQVBqVythNWg4VGlkOWttZ291RnI4MlFTV1IramtvK1A3?=
 =?utf-8?B?RGdkZEpxclYvZ3pJRnJqN0t3MXhsbUZrUU5rYUs5VVFjc0R4VU1CN3B2QTBW?=
 =?utf-8?B?enZ5OWozSUJmTWdkT3JDNVdvUnB3QkxYSURHZWczZWtGR3E1NlFKbzhYdms4?=
 =?utf-8?B?ZGhzMTNiT3d3bXhGVVdhQXlXUHlleGJzUWd0dDRHdTJHUHhacmNiWXltOHpu?=
 =?utf-8?B?cHdocGVQRjlGTE5nRVhyN3pqVlVYN21BWndoUjJPMmpzc3hBUURJTzJQNi9C?=
 =?utf-8?B?VldNZys1QWl4WC9YZnpBaW5NL3JpU3g0QnJROEJyNWhmUWY2VUs5STRvY05D?=
 =?utf-8?B?ZWRXWkJ5K1JpOU9LaFIyTUkvN04zUFVuYVhSM1BaeXRiQUt3dzBBaWRrUmRX?=
 =?utf-8?B?QmdudElJNVE2TGhybGQ3SkxKS0pHZWxaV1A5WnUzMlhPRUNyNGNEdnlIZ2h5?=
 =?utf-8?B?REd5ZmJFR0pxZTNGOXI1Z2YrYXZkZk41a0lxdnJPTi9WSE00ZFZVRk5lcWZL?=
 =?utf-8?B?akRvZkRpay9HYm1wR2E0K3hoMFMxMXY1Z3ZBQkJVRTNwcU9LMkZTWWJPeEhB?=
 =?utf-8?B?MWR1K1dBc0l5YUN3L0NmdWFSZ1RXWGVuM0VUQXY1OHEwT0Q5dzFtUlFiMjg5?=
 =?utf-8?B?ZDJQc2VrR3NOZzdiazJsT3huK2R3ekNLN2oxRTZuYXhJQ0UvckFBenY0Q0di?=
 =?utf-8?B?UUI5eEo5dk5nc0Zrc2hQSDVnd05hL2RNUklGdkR6cENxWCtHcjU0aCtSMWlm?=
 =?utf-8?B?TXNNYjE3bUN5SnJUeTgyRkFEQXNKd2tIYWt6djNla0JObU91aGhRSGUxaHhh?=
 =?utf-8?B?Tnd4dys5VDIvc1ptb24xbEpxZDV4Q0MwU0ZoZC9nc25ML01RYWN4YnFXeDRu?=
 =?utf-8?B?aEplczdJSzRLcTRIREc5Mk5IS0FmRnc5UnpMNHNUTVF5MWc4anlNS1c0ZmJZ?=
 =?utf-8?B?SnFyTDJiQzJXaXZiSnBEeFFUYWdmWFFJTDQ1MkhkR1FRWXNnSDBOTUVCSHp4?=
 =?utf-8?B?Sm82MHAvQ2hqVlhpMmlCaTBKemdjQ2VRRDZ2bG9vblk2V1RXUjNFMG95UWRF?=
 =?utf-8?B?Q0hNbjdtQy8zNDlHSy91RnBtZTlpQitkeEJMV1o3OUpmV0Q5ZWdTRjBqUDJX?=
 =?utf-8?B?dDZEQkIwT3pmRVdtcnVkZW1MYVRvN29SR1lINkdESVZBTEJLcTdwMHl3TExM?=
 =?utf-8?B?ZW5RTkFvUjFjV3Z4YmZYbTVUazExb2hMeW5tM0ZidHhsU1pQQXZUY2xSTGRJ?=
 =?utf-8?B?NlFOaC9xUDlwbFhLa1NVNWcwYzU1Z09zeWZZYlhoaFcwUHVYYXc4Vm5pRDNm?=
 =?utf-8?B?SlcrYitCcHQwbzFPNlJBcWJDSi9LTmkyRTJkRzJPUVFnaUNrMHhnUG5RUncy?=
 =?utf-8?B?VWh5WlJCTy9DSGVYRm5SVGdTVTJrMlBVeXFyTmYzZTBhOXRUN3ZTMFZQSnJM?=
 =?utf-8?B?b1g3all4NlJ6cVAxbWVuWnNXWVpFcVV0UmR1UWR1bFlxN2I3RFh3NFg3WlE2?=
 =?utf-8?B?bzFHV0prQ1pGSmUxZ1RlYUNXUWhZT3g0MStRdmJwbkpVRzAyUVpYZU5vOCtp?=
 =?utf-8?B?a3BUNW1PY1Ezb25BRzBCK2daOTdZWkoxWHh6NXd4YjVLdEdCNUJGSVk2bkRL?=
 =?utf-8?Q?aVSJB1qtE3NuV2lTFjC25AjLV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0796f26-acdf-4261-609f-08ddc8649c12
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:41:00.1725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLHR3JWWgLMsGgjlsghGigkxtD1m+IfK097GTHn5++WdD4AYLGa/nEAtCFC5hyQ8n7/Nb1PRMPym17yOoZHU+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6495

On 7/17/25 16:46, Kai Huang wrote:
> During kexec, the kernel jumps to the new kernel in relocate_kernel(),
> which is implemented in assembly and both 32-bit and 64-bit have their
> own version.
> 
> Currently, for both 32-bit and 64-bit, the last two parameters of the
> relocate_kernel() are both 'unsigned int' but actually they only convey
> a boolean, i.e., one bit information.  The 'unsigned int' has enough
> space to carry two bits information therefore there's no need to pass
> the two booleans in two separate 'unsigned int'.
> 
> Consolidate the last two function parameters of relocate_kernel() into a
> single 'unsigned int' and pass flags instead.
> 
> Only consolidate the 64-bit version albeit the similar optimization can
> be done for the 32-bit version too.  Don't bother changing the 32-bit
> version while it is working (since assembly code change is required).
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/include/asm/kexec.h         | 12 ++++++++++--
>  arch/x86/kernel/machine_kexec_64.c   | 22 +++++++++++++---------
>  arch/x86/kernel/relocate_kernel_64.S | 19 +++++++++----------
>  3 files changed, 32 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index f2ad77929d6e..5f09791dc4e9 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -13,6 +13,15 @@
>  # define KEXEC_DEBUG_EXC_HANDLER_SIZE	6 /* PUSHI, PUSHI, 2-byte JMP */
>  #endif
>  
> +#ifdef CONFIG_X86_64
> +
> +#include <linux/bits.h>
> +
> +#define RELOC_KERNEL_PRESERVE_CONTEXT	BIT(0)
> +#define RELOC_KERNEL_HOST_MEM_ACTIVE	BIT(1)

This isn't as descriptive with "ENC" removed from the name. It's almost
like you read this and think it should always be 1 because the kernel
always has host memory active.

> +
> +#endif
> +
>  # define KEXEC_CONTROL_PAGE_SIZE	4096
>  # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
>  
> @@ -121,8 +130,7 @@ typedef unsigned long
>  relocate_kernel_fn(unsigned long indirection_page,
>  		   unsigned long pa_control_page,
>  		   unsigned long start_address,
> -		   unsigned int preserve_context,
> -		   unsigned int host_mem_enc_active);
> +		   unsigned int flags);
>  #endif
>  extern relocate_kernel_fn relocate_kernel;
>  #define ARCH_HAS_KIMAGE_ARCH
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index 697fb99406e6..25cff38f5e60 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -384,16 +384,10 @@ void __nocfi machine_kexec(struct kimage *image)
>  {
>  	unsigned long reloc_start = (unsigned long)__relocate_kernel_start;
>  	relocate_kernel_fn *relocate_kernel_ptr;
> -	unsigned int host_mem_enc_active;
> +	unsigned int relocate_kernel_flags;
>  	int save_ftrace_enabled;
>  	void *control_page;
>  
> -	/*
> -	 * This must be done before load_segments() since if call depth tracking
> -	 * is used then GS must be valid to make any function calls.
> -	 */
> -	host_mem_enc_active = cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT);
> -
>  #ifdef CONFIG_KEXEC_JUMP
>  	if (image->preserve_context)
>  		save_processor_state();
> @@ -427,6 +421,17 @@ void __nocfi machine_kexec(struct kimage *image)
>  	 */
>  	relocate_kernel_ptr = control_page + (unsigned long)relocate_kernel - reloc_start;
>  
> +	relocate_kernel_flags = 0;
> +	if (image->preserve_context)
> +		relocate_kernel_flags |= RELOC_KERNEL_PRESERVE_CONTEXT;
> +
> +	/*
> +	 * This must be done before load_segments() since if call depth tracking
> +	 * is used then GS must be valid to make any function calls.
> +	 */
> +	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
> +		relocate_kernel_flags |= RELOC_KERNEL_HOST_MEM_ACTIVE;
> +
>  	/*
>  	 * The segment registers are funny things, they have both a
>  	 * visible and an invisible part.  Whenever the visible part is
> @@ -443,8 +448,7 @@ void __nocfi machine_kexec(struct kimage *image)
>  	image->start = relocate_kernel_ptr((unsigned long)image->head,
>  					   virt_to_phys(control_page),
>  					   image->start,
> -					   image->preserve_context,
> -					   host_mem_enc_active);
> +					   relocate_kernel_flags);
>  
>  #ifdef CONFIG_KEXEC_JUMP
>  	if (image->preserve_context)
> diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
> index ea604f4d0b52..1dfa323b33d5 100644
> --- a/arch/x86/kernel/relocate_kernel_64.S
> +++ b/arch/x86/kernel/relocate_kernel_64.S
> @@ -66,8 +66,7 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
>  	 * %rdi indirection_page
>  	 * %rsi pa_control_page
>  	 * %rdx start address
> -	 * %rcx preserve_context
> -	 * %r8  host_mem_enc_active
> +	 * %rcx flags: RELOC_KERNEL_*
>  	 */
>  
>  	/* Save the CPU context, used for jumping back */
> @@ -111,7 +110,7 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
>  	/* save indirection list for jumping back */
>  	movq	%rdi, pa_backup_pages_map(%rip)
>  
> -	/* Save the preserve_context to %r11 as swap_pages clobbers %rcx. */
> +	/* Save the flags to %r11 as swap_pages clobbers %rcx. */
>  	movq	%rcx, %r11
>  
>  	/* setup a new stack at the end of the physical control page */
> @@ -129,9 +128,8 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
>  	/*
>  	 * %rdi	indirection page
>  	 * %rdx start address
> -	 * %r8 host_mem_enc_active
>  	 * %r9 page table page
> -	 * %r11 preserve_context
> +	 * %r11 flags: RELOC_KERNEL_*
>  	 * %r13 original CR4 when relocate_kernel() was invoked
>  	 */
>  
> @@ -204,7 +202,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
>  	 * entries that will conflict with the now unencrypted memory
>  	 * used by kexec. Flush the caches before copying the kernel.
>  	 */
> -	testq	%r8, %r8
> +	testq	$RELOC_KERNEL_HOST_MEM_ACTIVE, %r11

Hmmm... can't both bits be set at the same time? If so, then this will
fail. This should be doing bit tests now.

>  	jz .Lsme_off
>  	wbinvd
>  .Lsme_off:
> @@ -220,7 +218,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
>  	movq	%cr3, %rax
>  	movq	%rax, %cr3
>  
> -	testq	%r11, %r11	/* preserve_context */
> +	testq	$RELOC_KERNEL_PRESERVE_CONTEXT, %r11
>  	jnz .Lrelocate
>  
>  	/*
> @@ -273,7 +271,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
>  	ANNOTATE_NOENDBR
>  	andq	$PAGE_MASK, %r8
>  	lea	PAGE_SIZE(%r8), %rsp
> -	movl	$1, %r11d	/* Ensure preserve_context flag is set */
> +	movl	$RELOC_KERNEL_PRESERVE_CONTEXT, %r11d	/* Ensure preserve_context flag is set */

And this will clear any value that was in r11 vs setting a single bit.
Not sure it currently has any effect because r8 (where the memory
encryption setting was held) is modified just before this. But if any
bits are added in the future that are needed past here, this will be a
problem.

>  	call	swap_pages
>  	movq	kexec_va_control_page(%rip), %rax
>  0:	addq	$virtual_mapped - 0b, %rax
> @@ -321,7 +319,7 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
>  	UNWIND_HINT_END_OF_STACK
>  	/*
>  	 * %rdi indirection page
> -	 * %r11 preserve_context
> +	 * %r11 flags: RELOC_KERNEL_*
>  	 */
>  	movq	%rdi, %rcx	/* Put the indirection_page in %rcx */
>  	xorl	%edi, %edi
> @@ -357,7 +355,8 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
>  	movq	%rdi, %rdx    /* Save destination page to %rdx */
>  	movq	%rsi, %rax    /* Save source page to %rax */
>  
> -	testq	%r11, %r11    /* Only actually swap for ::preserve_context */
> +	/* Only actually swap for ::preserve_context */
> +	testq	$RELOC_KERNEL_PRESERVE_CONTEXT, %r11

Ditto here on the bit testing.

Thanks,
Tom

>  	jz	.Lnoswap
>  
>  	/* copy source page to swap page */

