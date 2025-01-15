Return-Path: <kvm+bounces-35552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60C20A1260D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 15:32:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E5DA188CB81
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 14:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC3781728;
	Wed, 15 Jan 2025 14:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X+qNOf+U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE527080B;
	Wed, 15 Jan 2025 14:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736951545; cv=fail; b=caFAR+0Ryw+gC8G3I2+TZFKTje4fBwi8eC/PPZNOQf/W8nRoG2i22HI/O2RcHBhHfOq1LA95c6kHAA9ryqgWl5EJQdd8cyJfDCtBAzUz2K22UX3iCxNGOPdJPjjMSF19vQZvzfPW+w/sdFIi92wJbRoerKVzKmku2+ZIXttvPD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736951545; c=relaxed/simple;
	bh=w9F7TCUTUqNtDqXxK+bqdhD8YqmLSWcdzEfF41lB234=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TR+yrOJDt/5TifPMsdIdFqloWjOEKBU8xCCateor8apdyMHSsDIgcsVknLW5ZysX7BtSV/4QjVb+WNYfiKEBuKxokaZSQH77ZMx6YMkLXp4TYHMQi4ik431yyuVbdSrVVzZoB5s5hXMYhfVtSldHylLxnGj9Cwy2jUs+gMxomZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X+qNOf+U; arc=fail smtp.client-ip=40.107.96.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJeHYq7ws21JU5Muo5jMC2diHH66qS9ovdSc0fuRlaDPHHfhX9HKmJXFToVXO23uqAn5I316lhDX7ZR9bcWKrsMMutvtPagFPlHGGfdL7TDyvX4MMgMgHfvqnW/roFpyFcme5ZgUHW0hUKyRM2E4zYERikN5A7LIvqGQ2aSwiPbX9zvdSHB/GFHKyh5cSFJDcg9/LwL59kvzW217sMZ2pgl/DsJ68Zg+HGdEjMVERWIN1CfRaww2C5PMwmr4/87mozsOoKwWzlLRGxCKOdqVZpnly1oYuAFP5X2c/HE3ZjuQy2nIMPNfw8w+v/RF+ewO331FV2Fp2BpHYtDe9iD7yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTZWUHEg7kapikEV3OD4+6pUyKOPZAmqKx63gxMawb8=;
 b=g+7I/MFClr+rZa9NTnAr4dE4XfJ2tsExGVmgBy36xJ/ODrnHk5Zx6eZXZwKI8jvRcd+hYij67qrMjedsTm60t4ZjDppU0rX42cNWogsBdH5CHRHi1j3cQeMo9gzs5sOCZoZZqnMEERchDEpZbR8UStAdKImpdVWIL3L+ROLkVWCW8KX7qkyS+GiOu1PrX1P93DyovoWn7ih5koSmUJaeqUoBVaO0sk7gswzRVGBdz8m02bXuj+QBUYitemiSbDTeAhlHQEjNMaTclv/9q0JoJ70aynYMmWE7S2TRc91FF/9bMydSokejdjf1VI/X2ZoS4/GEA8yKbHEQAsL2oFLZwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTZWUHEg7kapikEV3OD4+6pUyKOPZAmqKx63gxMawb8=;
 b=X+qNOf+UmQa+WvLyLS4313dnEMZuzLnJePcLmuJLOrEztQByrbLPC8cZU24OV1ua+3lhvIPcbF5E5GgothHAjLSh37bA+qywBzL+U/1TbBKGzKiZx3y1u4u4gjFwJ6nXHix69N6FUj+vQ9BaY6bNGvhzzMrdrhc9pU5WlBFbkx8e7dd4vDNxvYSI3X/0ZgdiNwPrcA47p1Whl0IUI2voK7DViTy+Bh4EJD03zkX5nb7nkdIlcf23k6wMQGTwvyuz8gv/Rl4Kzo2hm6p+M27Mt/ejTSKqk7B5Cnsl65jg4lIn7O5DQeSC3NKnAJFciyrGA3RVu8LNj2aRw9iSHGMsDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6550.namprd12.prod.outlook.com (2603:10b6:930:42::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.19; Wed, 15 Jan
 2025 14:32:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 14:32:15 +0000
Date: Wed, 15 Jan 2025 10:32:13 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250115143213.GQ5556@nvidia.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
 <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250113162749.GN5556@nvidia.com>
 <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
 <20250114133145.GA5556@nvidia.com>
 <SA1PR12MB71998E1E70F3A03D5E30DE40B0182@SA1PR12MB7199.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR12MB71998E1E70F3A03D5E30DE40B0182@SA1PR12MB7199.namprd12.prod.outlook.com>
X-ClientProxiedBy: MN2PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:208:d4::42) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6550:EE_
X-MS-Office365-Filtering-Correlation-Id: 955a662e-121a-4d25-4dae-08dd357167f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?91tyu0ZZQXLDhVOyrR+6ehjApfyOtdxAA6okSacZg5VJqTJED7xQZA7qv1N8?=
 =?us-ascii?Q?bYBSoLsse1dj7jC6Pzlggk+hwS0bX6D9AendI0J+mzUq6MkJON4+siamn07W?=
 =?us-ascii?Q?PENW9u2AUYRVDTKe+QoW+rYDJ4bRzqwlN/DfXOG8dSWWs9zjnta3v32+bJAS?=
 =?us-ascii?Q?rBdQrsYKeADe6VHaAFWTVirsCFIwVMlMLQjkBz5tuXNFDQDGiFOv44S8T9ZF?=
 =?us-ascii?Q?js3WL4hKriFRwypdQil5XjqTwzkMv0Mkc0IgwF2GBtnrUvOmCBFROo62hhsG?=
 =?us-ascii?Q?imKBRmD9gTXqWtUVqvUMEwqSASAzN6ZEYzY9wmGmcQ7kNEePQ306Stax1Ut6?=
 =?us-ascii?Q?5u+DazpsoyBc3clFm4SKxvENyU/BuHGhCHwd92xKP1MNAN9KP0WTWzYSSJs9?=
 =?us-ascii?Q?omwjx6z8Rcon823wJZr+c50Ws+Ty6eWO5WNQOlncwVlLZPNBOa4/pVmXhJCg?=
 =?us-ascii?Q?2TWzgOLu7F9B4//2Lg+LFQfHqvCG5G4/jIjSPxtvAMSjMndb9iSZajzmM7FS?=
 =?us-ascii?Q?zYptBUv9hwvrYqeq9bKNFEM8ThdWdA7AzNBkJfUCY65BkXXsoGBwkFJ6BsEH?=
 =?us-ascii?Q?35iEErNUcL3sKK83qG2WV5OX0/TW2fxdPJGtlfaphpGUHmiHlat7uB2UcEOs?=
 =?us-ascii?Q?qTKPYfi+6BvJoVxP/zNy4F/yOAUpSp/Dl+1vF5LK1lPX/AEmm3NAbfHYoI58?=
 =?us-ascii?Q?Uv5qQhVKSzCF25mFIkSkeuROa2IOCrpOWeDGS1Q0r65hvQd9BLOFrnu0FLGQ?=
 =?us-ascii?Q?97EL7/sFTi8wTg8hZ7lFd1JwDlVVFZuB3rGZVLig1Oz9GmjSOZfQC2Pg45DQ?=
 =?us-ascii?Q?tx5M8XTT44W7dtlfVAHaXjfKP4p2TW68RAJE4QxS3CyI5kttgNeMeeXJ9F7n?=
 =?us-ascii?Q?quHkOEIkEGvLRtDll5hRARCy28Mmj0NMiworQGy7DptP4Xlj3VJQkD+ayQ1E?=
 =?us-ascii?Q?YrIAslWt8JxTA5ldpWzzvelQqM1a6WzcNcTcBggmpzn2HaopqloG9J3Wi9ZM?=
 =?us-ascii?Q?UtpOm/MehG+9mVgdnJsaxL7ciI+oQd6kiQR+o7zLwIMICrVXleVnAL4BiaOK?=
 =?us-ascii?Q?YoYqZHdE+19+WDng/F1N7TU36nTBnbWEfIzlNP9m0XqjV2l5cJEK+kSPZGhe?=
 =?us-ascii?Q?nL2/JyRzYKGXXtRFk+1/2WpcTuqNXI4dpgNeLrNRUy/zydCY1N6TLiJA1mk/?=
 =?us-ascii?Q?QOk4NmfTFhBoTQDBGgill3W9cMME6uKHJyX8zaFeftEohWlKKE135wHDYzM6?=
 =?us-ascii?Q?nO0d6ds3HiKYQnU0cFVGgf9ivguxzSn4QqMk3BMWBHT/REcMziYHb1L8E6dm?=
 =?us-ascii?Q?5qDPBmeh1cUvV5CcFMV4/CamJaTctjT3SraSGv6gZNTM3x8uIqsOXH4vvic5?=
 =?us-ascii?Q?8H0zdAMb33qsSLc1jXCgAner/LU4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LhrYivRhPhSt+g3hmtLUdngY126atKc3bY4+IqQm1VtuYoM3DCTIdB6RiVJn?=
 =?us-ascii?Q?wIxFkWNsBurcdSG2GyXUQWppUeUbYH0ygT9Ei9ME9DMA6HY29Ps5i3E3BeQm?=
 =?us-ascii?Q?70G35pq4k/V7rZSQE4X0R/nTB93lDEKgVsG0hTNGjhnqHdZvLYRWI/X5H5ip?=
 =?us-ascii?Q?JvwnrOuYu5ZZPBc/VZjYii2Ub4a7j0aGJvYokNOtgzT+NE1tLgEyNe3i5zwt?=
 =?us-ascii?Q?qJFrF+JAHzdEcMIjHeW0LYVX6MEgVfyzU6aTw/oTYXEnnMj8IWXKTat8Y5eG?=
 =?us-ascii?Q?z1MDhlFwsYhTGw93bNlncopQJfA1BJ6GGAuq3TTMtzqlA83ug7LfcgSTDJnM?=
 =?us-ascii?Q?2O6jaFtmQCos/9vu0e6TGJTxBS6/ApVVKg9LHKJB54gSipj+D4axHP434eW4?=
 =?us-ascii?Q?g4CwQc7Rzws+9B5aUOmQIPLFqaPlKD4kHtmBrEvXD/B23fT39o+TlpGyCobJ?=
 =?us-ascii?Q?dJLDP6JpE2hwnMomC7u0qvB92cKicwbtNzAXZrCFdXnp9WOZ/wIgRNzYkBYw?=
 =?us-ascii?Q?lzgPipG+y53lzPgWdJcp6+2DkvvVa3V+URUh1gDVlkimQM4GMVH9YLXDajtF?=
 =?us-ascii?Q?zzS88P8RopmLyxTEX2JuVMABHjNYy4jfExJSRiHEDMTZFt7eM9f66d/g4k9B?=
 =?us-ascii?Q?U8MQCUWDq14ZcRpFV1TKWLA6GkAZnYVOwF+KheDwH6ibRVKVxK4VOpBNSf58?=
 =?us-ascii?Q?urxo807v4CMGh0ESQMJ+C3C4W+tkbG8aJXGfT0GnUp98v1ElLIrFqnfB1Fsh?=
 =?us-ascii?Q?8Mg5REeyeYcvTmpnKaLAfMJpEzz7Td/GMOon4MKPfjaSlYzY7NYNI4aomueh?=
 =?us-ascii?Q?6jqCQSO8sbJL51hLz26p9pRV4iwEtEC1jrPS+w39is33kvCDUcnvfFB33Ggb?=
 =?us-ascii?Q?loPZEHFxTGuENCY651fHqaBZGSxx3u3OwKLMKqsiyqt1oDepYHT+FhHToAkL?=
 =?us-ascii?Q?oApFgtiDIut9/A6gT24eQGPEGQF/XkugSOTPZ1KLhAwcZbrx0IU7rvFrW7Up?=
 =?us-ascii?Q?FYpgYBbhtG3VMGyzM0/5WHxMr+ulatX2cTOU0YJi3m7vwQBsSaMgznuX+4a/?=
 =?us-ascii?Q?LmGtQS1nO0nP5SWxoR3sLslw9WrjMYH7MWkQdqXdgBjOeUfEdDzObFxlsRdE?=
 =?us-ascii?Q?d1z1nOkxSopUmDEWoEWMn04d5lR1l1TskpLcSu3od47bs+cvcCMPjEOvA8Zh?=
 =?us-ascii?Q?/JiI276kbE76Usl2cbbs06Zzstay6EZOaAx5qGeX8qm8retmtX4lJk5E2yFG?=
 =?us-ascii?Q?bTmcDMYRfxXRXJHPLegKmwQ6aF5ZdPWE8gAfOJWjphas0dpoNNwksHzh9jq4?=
 =?us-ascii?Q?WO+Y6+JbxfaBD3s6sK+ITgpEsN4OvjsqgXNg5y9OP/28BAa8Jzpdh8X8YXks?=
 =?us-ascii?Q?Pi5NiQ22kkejHocTJUixv+uRkOcrYyg3oUJog737Tj/nsVMJw80ablnUNBHQ?=
 =?us-ascii?Q?8W5On33MTshmdQRWrbwLuzRWuiOHaF9ukJs6dglACug0dM/vHA2MrUCX46EJ?=
 =?us-ascii?Q?ZlwJYChkufLsf1jVUfuqJAH2KB7WTEHLz2wYuZbX5mClY3fOZSjSqjYbUqE6?=
 =?us-ascii?Q?zu7jtrl4wSthumDqiuCH/J0q6ZfAzSwnaq3DhPHx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 955a662e-121a-4d25-4dae-08dd357167f1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 14:32:15.0265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3C4E4o8GfCu71HvYyG+vZJeriqwLidcxyqc0x5zwyFfRPzYE2r1TObKYPMAGrtDk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6550

On Tue, Jan 14, 2025 at 11:13:48PM +0000, Ankit Agrawal wrote:
> > Do we really want another weirdly defined VMA flag? I'd really like to
> > avoid this.. 
> 
> I'd let Catalin chime in on this. My take of the reason for his suggestion is
> that we want to reduce the affected configs to only the NVIDIA grace based
> systems. The nvgrace-gpu module would be setting the flag and the
> new codepath will only be applicable there. Or am I missing something here?

We cannot add VMA flags that are not clearly defined. The rules for
when the VMA creater should set the flag need to be extermely clear
and well defined.

> > Can't we do a "this is a weird VM_PFNMAP thing, let's consult the VMA
> > prot + whatever PFN information to find out if it is weird-device and
> > how we could safely map it?"
> 
> My understanding was that the new suggested flag VM_FORCE_CACHED
> was essentially to represent "whatever PFN information to find out if it is
> weird-device". Is there an alternate reliable check to figure this out?

For instance FORCE_CACHED makes no sense, how will the VMA creator
know it should set this flag?

> Currently in the patch we check the following. So Jason, is the suggestion that
> we simply return error to forbid such condition if VM_PFNMAP is set?
> +	else if (!mte_allowed && kvm_has_mte(kvm))

I really don't know enought about mte, but I would take the position
that VM_PFNMAP does not support MTE, and maybe it is even any VMA
without VM_MTE/_ALLOWED does not support MTE?

At least it makes alost more sense for the VMA creator to indicate
positively that the underlying HW supports MTE.

Jason

