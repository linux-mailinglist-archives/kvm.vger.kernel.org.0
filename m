Return-Path: <kvm+bounces-54009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB9AB1B554
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 744CB3AB274
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C5A274B50;
	Tue,  5 Aug 2025 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vpb76uxV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E552718E02A;
	Tue,  5 Aug 2025 13:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754402111; cv=fail; b=kdqtLqGP/9L1YdUijWIGXJXX7xgmmOXgRlOQJjAK09LuIiClZFTB6OlgV1STe1u48mNwL/J0VjcddBUM7VzOqEymj7JFiAVz9VEE669pjE7liJGJF09AkdJCHprKLv1rG2cLuutXxNYvWn+u+IxMN1NB04syegejHYzxuXSOHQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754402111; c=relaxed/simple;
	bh=tONHHXz+rh9AaGlWVimJqcqtQQi78SqhngPq9UZ+0oM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aEw8J38MSGtB1ijRA/I2adt9+fbSBiONHHs7PqfYJM2m5+6aVYEVZ0sKXz6OFfN72VAUJlxWewf0sBsaqpfKFQRrZoJN5SNhrn73zAyXB99yAYoit9t+EtNhSZXurUSCtHX+YbcBh8BeDwWrbPHAehlijv/GzEpt7R8Ttggw7hE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vpb76uxV; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hHyC89Z3uB7lZJL5RTeFZ1W2eliOz4ZA48ALONKc/HeUcP0FpqU5RQbqy7hLqBxF4G9N6avd6wOCYo7XkxzpDwAvWE1MGE2MLs/XJiVMz8S5HruWpIJlnkZf+o8hQ9ZVHeDaMtVsLycY8MmVKzglZpkVvIiMcHT1CXAbyZh5iSXgjh8plm7Ja+v2fbWq6vHSaTRSCCMDbec0+6n+aSB9J1WLmA+DFGEdmfwZttBBF4O1MtRXWyQHbu1uvDATBuzt/AXkS5Yy75rsesDALQU8yE6Lbx4zn/Jkhwn21kkZtqEsp8zW9rNAs2gUvdCvQwwyqL86UOsQ6fOLKrYRTffmxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7b9A/LlFno+Ltgt9+YoHoluYHrIe33V7BYh4Sxg2TE=;
 b=LZj3fftcOTWMG6H4opCfisEFShiqvJ2sHrt+9lR/yvtzesHLjIUAd5hBDDMLlsQbBqxHfsHLEzqjBDzBdk/abZFV59N3rLEWERBIpk90JX1SouYoBge9TleC/1RyHztNG13P1KN+HxOKZ+6fNWDZFJ7w1AgVnK7+YpOy39uJmm6zFkgsSHyQ61JJ+UJ242kTJoszQicdXDTCoP876wjpceso+Yk5j7RqK87vLYUpa3MqujdSsnYXGDBpMkfNvP9fh8QP/UZL9PGMVLY2qIbL/RxWtdyZ3g+P44r16Gri7RXQ0S02+KtQXg3+OEXeU8JYCQFssvWGnpQhauAw7ZMHUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7b9A/LlFno+Ltgt9+YoHoluYHrIe33V7BYh4Sxg2TE=;
 b=Vpb76uxVs6gTVxksifYeR9RK6N0Tni1+g9/ACmJEPyPK6/1A5XeUwcsjxkaRNB+3QKCcOtpc+qUIDnGqC3BeoNnyb/Rh6ecKBP6ZmrWFsBtm+N/ygix0pjrS9RWB1GNiBVHUV8QHtvVr1f4lo2CrotkSmMqLHbPGJVt94L0wwvFvr7EAUJXa0CHKFFqRtVkzrMmbiqfKIgeUQ4AnvMcoOc1tGPbmGn48Agv0ZzkIZw0xH3JViNg/A8233eGAZi0SgZJihKK3QJR24Xnoa0m+1gV0sT6w97/R0f3ZGja9qTZms7hkJCLN1HrpHQRclvQgIJhb3cUSh0oQn6JvJEymlA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7645.namprd12.prod.outlook.com (2603:10b6:8:107::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 13:55:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 13:55:07 +0000
Date: Tue, 5 Aug 2025 10:55:05 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
Message-ID: <20250805135505.GL184255@nvidia.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <20250805132558.GA365447@nvidia.com>
 <00999740-d762-488a-a946-0c10589df146@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00999740-d762-488a-a946-0c10589df146@redhat.com>
X-ClientProxiedBy: YT4PR01CA0498.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7645:EE_
X-MS-Office365-Filtering-Correlation-Id: b382e7fd-e11c-4bcc-6ec1-08ddd427af5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3BCqXun6zKA6yrzSYJiyHIHziO0/+sAAyGWywrhQvxoJigr5P7cGRc04A40Z?=
 =?us-ascii?Q?bXtobSuFPM2JazYHBI2TGr6V+GcIM+n5lNbKY2VTDHun7Ykkx+TwTOawNQUx?=
 =?us-ascii?Q?0pvOUi+rTywJc0kVlV3QH/LfyagMF9seHPefYS5IuHQZ21qKbkStIZq5Ik22?=
 =?us-ascii?Q?QZ6RPemwlvdGkUB1cyhOmjnY+dU8Oy4aECcJviPOBfZbHmVjcSYDplG76LQP?=
 =?us-ascii?Q?bHV5EzaDSaBw7n3XppiQLed8jFgqHtsxXmqwV86MEWygUZSsd+FUgIkotq1x?=
 =?us-ascii?Q?sbeMUMED+B5Rc3YMnI6f/PR+xRHL1BK2IrWeUPcXgCJIwnMttkU+KX4uaPbi?=
 =?us-ascii?Q?C/OBZXXBSXQJA0BYVfmbZngFT3pAdZplI604nZAg7KNc5gWyqltDh62DwBTg?=
 =?us-ascii?Q?rsyLJuDTaWbs4Kb/JRdL7/Htz4ilC5bbI63bIlD0TLrA6ctmFjDldBtnOoFf?=
 =?us-ascii?Q?21ZlLd+mQR7EqUF4IOYVYa/wr3P3dy9aaL/o/bJvzX7jlAjus7tiBOyhAn1Y?=
 =?us-ascii?Q?wSYMxbnCVesxokwr4Bgb519pYfew7YzVFoqpYWtP3LzDUa/LEdz59hh422Uu?=
 =?us-ascii?Q?1vuuDqYu89gNng1pu+ou2BGukZ/xPyS8gm2uipk5p+Nh9RP34xgKm4lUk4Bu?=
 =?us-ascii?Q?oeagZ0sGlgsOR8WdkUYHWpsqYB4Snsvf3KASDX20g8R4gsaxZrkec1mEKl7S?=
 =?us-ascii?Q?UH/FeGxJD9CRsfv6n5sUq2QhA9s9ykgHI20u4nbqXb0dQ8i7kAYQYa3je3qC?=
 =?us-ascii?Q?4a8krTp70cpYdlsYHfeP+INozUEVjIspxbGkTNErnkZ6DOE5BGsjcgRY021F?=
 =?us-ascii?Q?lsJ3Zmr8hHx68IZnCa3xwRVMBTW1wVc0c0PtMn2Wp/DTAJo03D/SHcaGn0Xn?=
 =?us-ascii?Q?cAZxd9hno3aCSn8wTPM1tVPa7rheEJgqnH8gkquo2G88BrrYe3N13CCCgLob?=
 =?us-ascii?Q?zWvspAXdM8S1j4jc90+4YaZcsoKye+g64ZlWQdVt91v3YnnDD0oxy7OhU6vs?=
 =?us-ascii?Q?DFAC6/fXhugctpCmo/vGQWIg1JCiz2UFE3QKdn0X1m5NiuhOWg06wP3jAZBQ?=
 =?us-ascii?Q?QMr/LzUQ14m/GjOh/G2InswmBWjraYeMVrl8BZOG9jAtx14vR6/S29ZyB0q6?=
 =?us-ascii?Q?sA/XGGg7/o0/wsBbpJme+wHYF9Ua+NS5KRuQgbCO0jehdz7G29pVx/cpKE5E?=
 =?us-ascii?Q?tY4IknVqz+KajDmZNrufHB6ZvYNf7TR1it7kzTOLV5ffqb5YUfDvnb5lRmoi?=
 =?us-ascii?Q?2gSA0Y8/rZdSdchlJcCTWTZ6OfBo0KzlYOLrzmu+6rx16BxvGJ3DruGZGqsk?=
 =?us-ascii?Q?0EnIg9lM4wKjaQwW/eHDe30spkP4kxzVxQO/TGRbFUhBaNoe8h7/hbXEs3+j?=
 =?us-ascii?Q?FUrjRuOfwRB1j1HGcSPru5JJI+3+IaShh/nyX7aYs2kHu5lVyG/PODf9rlP1?=
 =?us-ascii?Q?0Onih80JJmM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S0scFWYfCrjetZfobRnAUAjkGkTPINTtPkE2lPSMFE3XuFrAJf2/3HZ3dhx/?=
 =?us-ascii?Q?hNsoabo0y5L37vg/pmtpx4EYRZSNV/jsrk98rycUlqW64gqlS9svPyuJ20DM?=
 =?us-ascii?Q?B8zITANJeFurW3o9+eYcv84YGY08nB105HbvbsIdXnde+FghvR2WiGaBRa/7?=
 =?us-ascii?Q?YrWZCSfl3ORfh0k05Kdtf5juF8xRPImYh4JNDqi03iHP9Hx0zbl4w6LOATKR?=
 =?us-ascii?Q?6Kt/L4wnY156rtQn5uS3DI4AGAHCYxUqX6pvScb3EsGQexyoMAp77Y+2UKK6?=
 =?us-ascii?Q?z0kHj99bgg6Ktke056LZFS7+FkhzcHWGFt5aYh7CSnIjKGAKOdOB74EaOeq0?=
 =?us-ascii?Q?M3rpodQxSHzQ70VHCnSIsBMM72MI1VRhR0Yk/gUTa/nMJSxxCyFxkZ+gNNzg?=
 =?us-ascii?Q?jZkqTXQtcc8qjTlZ+G/kHQQYWPd5yB/cEtxIpPIPWqMPB2YbIrZQgdk8m54m?=
 =?us-ascii?Q?72pK+yzSM5ZG+PyjK00BFaSWi/A2gH9I5zsXBYi8wrUobvkrqZDw2Nahvwse?=
 =?us-ascii?Q?ExbWhwF8xwISX4emNa7ls9j+sQugN+2WKkTgtHph59gJ4u31eqW25KLiw69v?=
 =?us-ascii?Q?BLsu2iOINRynTlRTdBh4bmHdXiLUsqT+RdLHkLZ8XRolt2qWikIukewOibbQ?=
 =?us-ascii?Q?0DOoKgFWWFgk6Y4Aov4jjJRLWduVuFo5u6Jcxw1DipzLAqUfFxnj0SqM41qn?=
 =?us-ascii?Q?+0u3hkyrUattiQnxyDSUzP47OuXSSUV5jF6dTacbns3hQrY9YGnrOidjdbn6?=
 =?us-ascii?Q?7PP3yFyfw4a+7FTpZuntp1okvHUk1zCxwq/jKsFTs1EsuiAgAw+KrzeStEHP?=
 =?us-ascii?Q?ApUZSKdxgHgyTfVfHtJNzaBCyL3yHzC5DMA3U3FxrR6nVssytwI1dfO/Pjvv?=
 =?us-ascii?Q?XjwzjSdz+CJcdTGs6Nb+PiN37S8eHvTXg9+ed4nznuXPxKdc17WCoBMSQLv8?=
 =?us-ascii?Q?jCsDrf+VUz45fVMy6PnKl8dsdhUkvvcVjKGZ69gAdhqmKCGzcYY+qJoiAPdH?=
 =?us-ascii?Q?cNvbfz/ce4NJmXg3G8Z5yL4+o7oci/7SJo8NpwwXwa1Av96i5w2buiotYy5V?=
 =?us-ascii?Q?+xsaT0IxMxnIgAIFJ/rNjl9VSoj1rOW8kGqJs64Nxj4eYtLgywcCYhCyTOny?=
 =?us-ascii?Q?AIkxx59XJWPiXE/VzswzgzZfftYkcJKWZZsgMundloFu3LKHhkmp2Zy4J3Ud?=
 =?us-ascii?Q?77srYExxyFb8QXbo7bXZTPxQZVanBqxdjP8KhHRtn0eMpnd48ROlffFFIGsy?=
 =?us-ascii?Q?2cmlVP/L5SkA0U0O1N0nAiSA1+3wh/YIAiN9PXINOLj9yFH2eC+3iBYUTqSY?=
 =?us-ascii?Q?cJxMJ6IxIK9zCI+i/pv9kcXD9jlgyuaqoWZMUburjH98k32ZQ0aSMtobjmwh?=
 =?us-ascii?Q?N2ZStiKONLi1nC0Rr233oWThdtmCv2gifOK8EzRTKZRPBUmx/rhQuRB+YHBn?=
 =?us-ascii?Q?8HMx0VFI/EaLSu3i5M0EIV5fskX6nzTvEzWjE105qaKAeZXSLBEuPPeoMCWG?=
 =?us-ascii?Q?oiCSPkm0d0/NIt1gIC7EjmyPj/eY/J5cVWwchgxLHdXK9RKKTQ/3CThhfnzd?=
 =?us-ascii?Q?ij/y7LNKmf7x5el7uAw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b382e7fd-e11c-4bcc-6ec1-08ddd427af5e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 13:55:06.9871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XtcBhmoo/7zrOUqfeOwJz1eq4CaGyzLNloXm/XB9sA+8HS2eemGA7Bs940XP9dc4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7645

On Tue, Aug 05, 2025 at 03:33:49PM +0200, David Hildenbrand wrote:

> > David, there is another alternative to prevent this, simple though a
> > bit wasteful, just allocate a bit bigger to ensure the allocation
> > doesn't end on an exact PAGE_SIZE boundary?
> 
> :/ in particular doing that through the memblock in sparse_init_nid(), I am
> not so sure that's a good idea.

It would probably be some work to make larger allocations to avoid
padding :\

> I prefer Linus' proposal and avoids the one nth_page(), unless any other
> approach can help us get rid of more nth_page() usage -- and I don't think
> your proposal could, right?

If the above were solved - so the struct page allocations could be
larger than a section, arguably just the entire range being plugged,
then I think you also solve the nth_page() problem too.

Effectively the nth_page() problem is that we allocate the struct page
arrays on an arbitary section-by-section basis, and then the arch sets
MAX_ORDER so that a folio can cross sections, effectively guaranteeing
to virtually fragment the page *'s inside folios.

Doing a giant vmalloc at the start so you could also cheaply add some
padding would effectively also prevent the nth_page problem as we can
reasonably say that no folio should extend past an entire memory
region.

Maybe there is some reason we can't do a giant vmalloc on these
systems that also can't do SPARSE_VMMEMAP :\ But perhaps we could get
up to MAX_ORDER at least? Or perhaps we could have those systems
reduce MAX_ORDER?

So, I think they are lightly linked problems.

I suppose this is also a limitation with Linus's suggestion. It
doesn't give the optimal answer for for 1G pages on these older systems:

        for (size_t nr = 1; nr < nr_pages; nr++) {
                if (*pages++ != ++page)
                        break;

Since that will exit every section.

At least for scatterlist like cases the point of this function is just
to speed things up. If it returns short the calling code should still
be directly checking phys_addr contiguity anyhow. Something for the
kdoc I suppose.

Jason

