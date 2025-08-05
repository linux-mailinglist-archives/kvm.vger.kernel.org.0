Return-Path: <kvm+bounces-53999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDED0B1B4DD
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:26:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68216189909F
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DA9274B31;
	Tue,  5 Aug 2025 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pTpgJ1Tx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECC422F74D;
	Tue,  5 Aug 2025 13:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754400364; cv=fail; b=XcST2Gq+ldms4bjMM6nm6RxCMssIqeN4C/WeoS3j2UA18yyBY0+qMWx2Vxj7ZGzZBXbq1tLuw1YU4D/xPUYFniyNgf15YKtVVysK/YPG4F03Hv7qBweWj/B+4LECfEbk6beqX/mSBKdIMrDqEcjlinuoDbYwZFQjr3mujR3BkYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754400364; c=relaxed/simple;
	bh=AkwEFvU+r4aRcogUXEwN0Z4f/ys3hT36ug9c1nSUL5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M24hsrC+GG3UGJ1ZUK6W77sgP7S2xEzMhX1aElkE9s5iDmgANS1c6DXEox676/PQTwVNkhqoaa7nn+95GsYuOYAOeLhtBsifqM55F9I/QvO7JzBxbfmEbgeB1fcRuOUsOrliRK6AvborVs2Kbpe8kEV+jTcS4gsqx7DWz2QB0Yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pTpgJ1Tx; arc=fail smtp.client-ip=40.107.236.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jt0Kh9AU4RaOwFuoEigDrIwV+ORLBMbsK9ay4W7jPqDsiBvteZn4Vjz5/aOT7oDXpJ2JjvrzxQ8uA0RlFQ+aiueTzDA5ujCFDERiOVdX6gulojlt8POcO9LrVpAWRKSEwTGkTkYzGJFYCMCIz8ID9beNmzkHIOWNSHWXelEwHBDLWeDfSGk5bHcXqfIiHJXwvKScsH4TMYpH4ta3CRs49fZrQRexaW4MIEdAX6SDKf77gh4S1vMu8B8ZkEC/G315i/ffeBhj2sHDtoUiljQyNv0gf4t5oZtJqJ2sgq/l5swUAL6EY3uMrtdHZMQF/DegUst3eRVW5B5k2V0xiSjOZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCCCt4FOAA7RVq0F0+oFD68PqcroeQqz0HqlYaOvaV8=;
 b=hnf6Bg0t4VMwG7Jq8KNbv/CLDc8hIIZ4zXkis1QCnsQHjp+dVpCU+Qql/A2ErE1Ux++1sptufX48WQ9OLai5bPIQcWm0C1fuGcK0n+Hm16NUznf2Hax/eNUSx7brikkJgIeOUxUuD2kIenzK7VAOJNXfnwqzHMiAZZnTQwoISGVTlpx08V6Sqe74Ye+52lRxXEGoybcamq/2ZizeYm24+m7W+tS4XjWC/hcMK1/ivGEozj8XWwxyjcxPHjM4YEMNPBQ5GbLpYe/jjoMH6Dc7ZLAWhYT2ocXWSiNnENGPVkfJf1HVh3O2/Ty50Y4JjyXRF8EkKlGGUvVrPE887w7wYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCCCt4FOAA7RVq0F0+oFD68PqcroeQqz0HqlYaOvaV8=;
 b=pTpgJ1TxF+dt1Z5a+mU0EnvXtSvQfGVWDuSY49s4sWDoBEgCTFfiqVqtQc8dIEoWoxOdOToDhc9QKaG6hNP43phfyucpkBozSJELZ/0Gv41Bev5txcDr4yUei70JzpdFbk+jvu9RfTrdcSpcdJvFJQaHe3VxTGOXta0j0EtC2Upj4HZ/qvvd2AE+SB46QSHFhN6qIjStzILSnvz9CX1qlxPO6NSrzy/jl7WAMC++578WaY6XQIov9c15LmnJHqkxnBWgxyCUJq8gaOJcdp1oWofGojvFmjGNiNGuHHt6MMKrTCuwtZVLTHul9ANHqPfYQYDccEctQ3OXpp3CQD4pLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB5835.namprd12.prod.outlook.com (2603:10b6:208:37a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Tue, 5 Aug
 2025 13:26:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 13:25:59 +0000
Date: Tue, 5 Aug 2025 10:25:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
Message-ID: <20250805132558.GA365447@nvidia.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
X-ClientProxiedBy: YT4PR01CA0395.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB5835:EE_
X-MS-Office365-Filtering-Correlation-Id: e7cecf60-989f-4b68-4e58-08ddd4239da4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XCJejzPPN7X7FcaafVG0Ff865IJNu2ljOvw4UKvwkBmXmHw9qnNQ1Hg6SPJi?=
 =?us-ascii?Q?nlUma+i7JjmI5ZeJEX4chFZ29OgfM2OwXiqVKjAcIc4hITWOrt9djyIgLmPR?=
 =?us-ascii?Q?GyY0YTo2OMnBmHSDzl4e6UzW8VIpLVoADv3nKDMjG6kOwBw73FbqLyp1VaZX?=
 =?us-ascii?Q?FHVuaKXCqKB3tcqH45uoix6/HS/Jt3QILxvh9jvKPw3X4wfIxsdz4TNevd9D?=
 =?us-ascii?Q?bnBRfuUuppO/GYzGN1wGkHddG+ghm/+4sgMVheuXlq1Oe4Z27ytJD0MTm1O4?=
 =?us-ascii?Q?yqHNmv4Jqt4UhE55MY7xg7CzpY84tvm6dlXBoj0TFG2fgcbRUUfJW2RJG4Vw?=
 =?us-ascii?Q?C2DPEerN5kfLyM4X2h4DUfqxypyNlUDE6MA/dF1s38IotiazQC1NWVRaF88E?=
 =?us-ascii?Q?dvK4TM1xOu+mVwYmLwdnPQKAWo/im/0GxMdvKiupH4ZsmnQaRYGP/uXeqgxY?=
 =?us-ascii?Q?OJTNm1AtB8hfFeKjpYe6KQ1/wGEmqnywuufbRsgpO1HZH5Vtw6XTuasVUtuW?=
 =?us-ascii?Q?XT/QawduS47q7YnOFirvWq18Rp3chng7fzXEawfZYGXoirxCUgaPZmK7o3vC?=
 =?us-ascii?Q?Zv+B8DyZdLdvCXdu+Jb4bws06YHpvJWLbpYYtWyi8vihyvgpeMVLcXOtCs6S?=
 =?us-ascii?Q?8/AjNg74HLcZRqwzOkkbVQpgi6iEH0KOarEIXBRQJwx0lKWBlR3IdTd9pfy4?=
 =?us-ascii?Q?BFoiAK/f6+ksnWiJcBpcgtMnVIVzTaA/2YCiKlyJWaJsz5k0PjngQEzKzpE1?=
 =?us-ascii?Q?2bcK03NIcE3hVvPYrROKeOJXLm5y9/z6jliNLeR2MjLvHhV4QTPoJ904+CK6?=
 =?us-ascii?Q?U74cBLzRnZyB5OWbsizlqM2kqwxbPRQN8g5mQd3gHIirgBtPzQONTf69sQHN?=
 =?us-ascii?Q?Y5vJqaEfVJMfle1jDzXTPAtffSGvdGSlcdEJOO2XsjlPT82oxVGZ/nAPjAaI?=
 =?us-ascii?Q?veNYcGagd73m9N7sv63zwaN7R7TpD7zLGDhcHzU+XXHW/MVWabz69hxZSFUI?=
 =?us-ascii?Q?m9kmRdVuf6Hqq/hYu115F16qHT1i2Y0lGDgYoqV49UJdWUfoLpA6ETJ1ukL/?=
 =?us-ascii?Q?Qnp9zq1QumsafugSPypyaHVplwYEfyRV1sha1f4dgyv7rOZdicCKvhqAlY7d?=
 =?us-ascii?Q?KXJdVlr3pzP/826lZcnOj+OhkA/ZZQj+32POR18wCRS79CO8kvBLHJWajagx?=
 =?us-ascii?Q?a5mJH78UQt0gK2uO9yhn2TWXm7+yfmlkbP2KpLJ1tRn60MroRJ6O25h5mkM1?=
 =?us-ascii?Q?KFqTmFtplYKZ56HcOs4SoB8vLCwxedD6FvrwJJH+9DvmxiBSd+4nw5o67TbT?=
 =?us-ascii?Q?WclQqjOgWeun2uz6lfaqiSMZezdavXoEA5BkHmd2S2NHcWX8T7Nz0GbhurhD?=
 =?us-ascii?Q?MvU6XABp4jPV8KyKAMtfN6+RQLspiSKyPPxyjCnaTVS8jh/CoCnMK9WxyvT4?=
 =?us-ascii?Q?GDuEGtIO6Ck=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OrKOQ9xqwHYRl8y+ERZWvnb2OZTgOJSSZv2hHCuPs3NFEtpP6+c+9kLdKjfr?=
 =?us-ascii?Q?hxyjuvhTuDf9+9+tu1KfL5KLaPf35mZpjiheZVmpeXxeZ+hxspjyxQVPROjk?=
 =?us-ascii?Q?UnHxdpo0nEYDyfXMpLXC+Q6ck9QCQUHdCH+jDo2dA4S6L7RJild8cVcCRXNA?=
 =?us-ascii?Q?rEnANSLqzrtY1AnfB6NPYF9ITovL0wLDp2SI8DEq3EEDh5BsVJur7gajBSv9?=
 =?us-ascii?Q?uMfbPNMYhXheMgE1GdEYtROUpyY2mYiLIhqe5X1t/0ss6t5QyiGwgHCsGyOT?=
 =?us-ascii?Q?zsEWEACxb+l6boh2n0JfCjvE9XOHVUqDzpqaeDdRXxHIIC2UyBqqIX0Aq1uq?=
 =?us-ascii?Q?PAQ175SYYRMB3Uplc9UwWZZL+OVwPylPlQunlutq5/dP65cVOjNFlKfukm7w?=
 =?us-ascii?Q?vTfqvUSYXGrw1E3mzYA/u9a5E9eZdOgrPykGAPD39zE95aSDgHn9F0SHMn96?=
 =?us-ascii?Q?jo36YwFUYeTBYnEuvqUvuB0fA74mrnZ3vFjaENK2OP1frYVbB+x5sWk4cPMT?=
 =?us-ascii?Q?R1ziM15uBKqJuaymjOa2477JX1HL4p+m2s9+ucxA2Udu3shoH35pYkvXzz1q?=
 =?us-ascii?Q?gEtI+SplvBKzTcmNb9upZlQD1/Lv8sF2rUxUgjdDByHPSYo6L5A0VaSIwMdF?=
 =?us-ascii?Q?T1r4h6P9iPNeRt/y9/nVsUk2XZutHY9fKDMuWzxRlKftOkU3G1Mr67jWnuEB?=
 =?us-ascii?Q?uhcknudnPV9ripyOxkMBYnVD87c6A1WivU+kGMiVozuvXZg3StVxUznWRVYc?=
 =?us-ascii?Q?Ujq1StdNuXO3FCtf2yyZaV8ZKMMdtUm+H9lGsmGqJZYnrM3UqtbesljXyUQF?=
 =?us-ascii?Q?xI/jJh3sMfMRGyDcyTnBgPgPs3o8e0CX4D0DApI6AfQ8XBnlowPwb33WLbC3?=
 =?us-ascii?Q?MBr9x+0Dj0k3wc/7kgsDPGk/awIv86tPz28EK58zKUiNbkjPnzjBs6ERZJsp?=
 =?us-ascii?Q?7GbFAklbfB83NpJOQXqEOV8GRf4/VIjEuHHQRUw8WljPFKfA/814rxgHnC6A?=
 =?us-ascii?Q?KAil9n1i8GvA1eaWIjsMIzqWfF5jWNHK+UaBci+z2YeNwJt0FQ4yLoiycdYu?=
 =?us-ascii?Q?ndjTfyOJ8+uZzPI9Bs4kD4KSCUDkMTTdePfrTAEl4SARFo9TnsIVutJXlMSI?=
 =?us-ascii?Q?xB2fIhpu8DqQx87+mTKjsERcsWJwaNcLrDgQDMFQGO17ufpQA29JxomsamOC?=
 =?us-ascii?Q?c7HmmY+sIErddKSw9MgMR2Bpw8hYnSGk6vThYr+WMi5W37eYO39KSvJygCBu?=
 =?us-ascii?Q?Ytjrfxm3O28ThAl/BBT6SHTkZtTM2A43U+vOU0RWGnPSTSv+D0Y/QyDY0/Cl?=
 =?us-ascii?Q?NGUUadhw+UJ23g4NqLC6fwUPLZ2sENB+PsaK5csZ3b1B2OLLcZ38is8e4qvk?=
 =?us-ascii?Q?5MyvwkOsaZNmOmEQ8ep8FOeh1eXRFZhdQGYek4GGSULkncY0UJ8IUk2VPIY5?=
 =?us-ascii?Q?D+k3Znq3ONga9u3+ZJg5T7lDDiVJ09FhZx5AhnFigJ3duPGEkjTAsBEh/ZLJ?=
 =?us-ascii?Q?kxecIrD/9qUpiMJw2WmGnL3twYpobLGelV8WFJd30m+mFhKKQEitp1ZEXqL8?=
 =?us-ascii?Q?OSWlYz4IzWHvgNVtIB0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7cecf60-989f-4b68-4e58-08ddd4239da4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 13:25:59.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VkDW3YIV9jLIJPx4p8WSFgUaX2ErtsLSdS6iFB2K0pqSpnyCP/263MNomS7Hh/m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5835

On Tue, Aug 05, 2025 at 04:00:53PM +0300, Linus Torvalds wrote:
> On Tue, 5 Aug 2025 at 10:47, David Hildenbrand <david@redhat.com> wrote:
> >
> > The concern is rather false positives, meaning, you want consecutive
> > PFNs (just like within a folio), but -- because the stars aligned --
> > you get consecutive "struct page" that do not translate to consecutive PFNs.
> 
> So I don't think that can happen with a valid 'struct page', because
> if the 'struct page's are in different sections, they will have been
> allocated separately too.

This is certainly true for the CONFIG_SPARSEMEM_VMEMMAP case, but in
the other cases I thought we end up with normal allocations for struct
page? This is what David was talking about.

So then we are afraid of this:

  a = kvmalloc_array(nelms_a);
  b = kvmalloc_array(nelms_b);

  assert(a + nelms_a != b)

I thought this was possible with our allocator, especially vmemmap?

David, there is another alternative to prevent this, simple though a
bit wasteful, just allocate a bit bigger to ensure the allocation
doesn't end on an exact PAGE_SIZE boundary?

Jason

