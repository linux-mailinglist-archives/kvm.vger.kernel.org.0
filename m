Return-Path: <kvm+bounces-28882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C4A99E99E
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 14:21:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD14C1F220E1
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248731EBFEA;
	Tue, 15 Oct 2024 12:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iix/AxI5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385D16EC0E
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 12:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994863; cv=fail; b=CwFgJM8lS5q9GekUmRzYyAIY5F5ZpKw2eNlke6LtHvps9GZkvndRvE6BLIMLRdd0bqfYn1jp7P5Vzosi9S+pK4LZldUFkksDSsLseIwr/Ldj/L5V29WZxqcbnHoRZzLQ+yqogDunq82oFvRHgVu/Q1ceNM6YCBZS8T/zHtRVOpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994863; c=relaxed/simple;
	bh=0+j2jGj/tovxxXqh4/cjWTVo6ATkbes8T98pmZ2JMtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qxnd+khdB26jEX69IzfXFh1jfqLtkXlwiYaYEuSCF+NnFnY7RV3Rrw0+Ez3gvg9gqnYs4fVgXjgRW75+rprxCP7OQSeyzPtlqxormBm4kXJGC6ZhnZfA/LPC13iphnBzNXorq4CSL+QAMvqmAKxcArD3KpPSlGcVZesTAltFJh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iix/AxI5; arc=fail smtp.client-ip=40.107.244.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQdYZeVpzSHwBkNAaU2O/acW3pVSN2ERjplS2cuIASxP4TkuPzdZL2LX05YV1b1YUQmoDKBOLUFkFHFDlJNUrVD7zqGS6cIlVEqLgxQ3vWYH2pGMKFFAxPId9lb0teFhAK9GLCQd2qO+jnNNB27NA7Lbk8blVpNmWZXPfCShMdQlMWqPMr82IR0rB19VCLaRwS7Opsi2Zsy5VVy1Jz4a3glHJZRpIMe0rLPLgMdoM1zgXKdhV3cL6xBaF24tZDTKA+ibeK+rDAn/QejhDc/rBXdwjbhCiJVTHLcrvyGglc+4RplV5KpsCY5u1jJh8RqJUMeRrh90Guzk+rCxhE9jtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roC9BrCOQWlr4Sy5KqK1VfbIg664aEbhIpH4L0yvVj4=;
 b=n7b8kdlkDJyux0HVrCQkrx67zGOo9tXkrHbqrDvpgoGml0Psnw+ZfPjLsKz12yjhSg1gLlI2T2RFJquk/UhnbysZNW78RqyheP2DR5ss6bqlzLaczTwhrQMp0+ubbY8Bcy8HGlUKV23r0EUnU8jc8RcxEF52ZfGxbiJDjeGSEpj3OK6JPA51fxE2Bc6KDZa3oszvNYxIsfcQKq95YuCFwiQ1Bl6PH6/mrDJfX91pftMRgRzrvmOWEQmpDzdpihwmFt+x8r6Cb4WJyQLBaiwK+01dE1WRwpaq2BDi6vwZ+J9cEGstFuONnQM8Vtyg0ZABaesdkNYT+dSRNmdmkW5Z2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roC9BrCOQWlr4Sy5KqK1VfbIg664aEbhIpH4L0yvVj4=;
 b=iix/AxI5NtJavloWLhAp1q+RytJRn/OW+QGclNvH1bGFy4ehiFWvXbX9egTxnx4kKbkyZMOp66CbdhzsoDXT/VM6nNS0iC3EylUjvkZaUpa/UoTYmZiaGxbf2FvW+8y78sPmtloygN7ZCh19CjmWwh3S3p3V1HQ0pU6C41xr3L1MUQ25y1EcRMmNU8HCQsq2ienIlaWS+WyDBbQCC2XO/ZvVUWUUHY6s9pkRjawLXs8kw4Mk1Hc/WYPPUMrEayp87kjdyvqUdg1a+BnOllwHqbM+JWN43eW7pn4BXsofozCuIkXp6Fs/Y1Lh3YkK/db4R2hOgI45BESjGFtqacYhMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7285.namprd12.prod.outlook.com (2603:10b6:303:22e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Tue, 15 Oct
 2024 12:20:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 12:20:58 +0000
Date: Tue, 15 Oct 2024 09:20:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	Andy Currid <ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Surath Mitra <smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
	Aniket Agashe <aniketa@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 04/29] nvkm/vgpu: set the VF partition count when NVIDIA
 vGPU is enabled
Message-ID: <20241015122057.GH3394334@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-5-zhiw@nvidia.com>
 <20240926225100.GT9417@nvidia.com>
 <e76bf5fe-4ac7-44e3-a032-35f04249355f@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e76bf5fe-4ac7-44e3-a032-35f04249355f@nvidia.com>
X-ClientProxiedBy: MN2PR20CA0042.namprd20.prod.outlook.com
 (2603:10b6:208:235::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: e7d3c883-f44e-4e77-232d-08dced13d336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tVp6gkE1J9saxwJTF0bS4sB0FDf56Yqvj1981DOHTidEUB8YbfixbMob32CC?=
 =?us-ascii?Q?AS6zrl4RJSk9TK4Jspb6SpSDm/bVOdqqbmZzA+JOTdm7s1bcxoAVU4pvxbVN?=
 =?us-ascii?Q?/ZrgHbkmqWzwQKBFPoXiRB2rl2vaARB+FKrA1AIdxdVnNBdmhExgCw2kGVJg?=
 =?us-ascii?Q?6eLQiLXOyNgUIeAgmNTGXBOn4CH4ZY9WdXjEgeAt6jxP4dtvRd/SJFfJBw9w?=
 =?us-ascii?Q?Aw4X59snxJ5MMiATRBM9fo73BR57/newKES44cK1YltV5siwy8Mn7tuBZNkJ?=
 =?us-ascii?Q?WYZlKLLW82KKJvPtMjuT9UOn4CbecWsoWEMU3qWoq3rV3Vi8IQTr7iYftBVU?=
 =?us-ascii?Q?qelVO88mqssMFCx69eGgsuPE9sqrcRTwMHNsLEFfbd/iq/2Vs9CqZTvJ7CKK?=
 =?us-ascii?Q?qd6uVNbu9YRRuVzaQG+1wCmqOVycEjGnybFYMFl82XNShvpn80Ly9xbAg6WB?=
 =?us-ascii?Q?dKqAtCKxJ/mOVmyN0pmQDUKXp1DpSNvaTJReAoaNc2RLD4KMA4Ac7t2OYk8Z?=
 =?us-ascii?Q?xZh8Gj7X09v2AhJFG3vyL53jfscTkP9bPm//yPR2C7uPEcx0thA15WRpPu2a?=
 =?us-ascii?Q?N0VktF1+6qULWQ+4mFb/m/lnKDUqGgu/H7y/IJ6E4/6dbpW4Fc43Ad2J7APa?=
 =?us-ascii?Q?NCTvC8o3Vz+JeGbCueubMOaO2Y+l33+/AW0xXLc+4w1pi8gakZGVURlfNuXC?=
 =?us-ascii?Q?iRS817ILAf1pgVfRQON+BQdHPtYXRwK+2ZZ9h60FMQOk9ngwh6aCJD7onWqH?=
 =?us-ascii?Q?+y/kWYslCjgO4m6E75GI8vo4swu/QOPpqbZmUWdgsbBpfQl03GBdUYVgmUsZ?=
 =?us-ascii?Q?ODCZmUkycx18u8l/Zzn3iO4I8LvPy90Oir7dxp6srqkbLbSU3kPGMjXFriFI?=
 =?us-ascii?Q?1MthwR/sBZLU3ohQ1sJGiXUTgtkWMm1v9j6a7WyD5/XYkElo2RqOofZUvpJw?=
 =?us-ascii?Q?150hXn1Yjfx/5c1qs1XwClX7z0xlksETsO7qAqF3fLzsoytF7scnN5fpNCaG?=
 =?us-ascii?Q?WcMvnwoPFc/w8+Snm7RukPVYYR6jZ2ahWpZ80SKJMT71c9vdpqKf4GyEwTwz?=
 =?us-ascii?Q?FTH0l2Ux2IvNxf7ObzB/4MYDTo/5cWcekvU3NUqpQk87pldzg4+xxPibnjOy?=
 =?us-ascii?Q?LMIcZ1Z/3+YqG2p7cDPSqsIMKizflvfbmQ2xD4A3rrunzjlmuU8VIAuym+xa?=
 =?us-ascii?Q?JkV6kNHZo4nlKALqZxJH1UePLqqK4zdnB7lLuF3f3xkkt6v0BhsXlrCHObKg?=
 =?us-ascii?Q?dvFMMKNBS/JsmfMudTq2EdGm03zYlQdp1aIu6WO5/w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HusjCXT+c8SNK5H1bd5p2VkXvbCsXvj3VnxpDGKctnHTKrAQcILz8Qi/ThnI?=
 =?us-ascii?Q?99zJKz2pxlmgj8vR133P5sHB3ibchSR20NbPMY/A//zeKljnKykyzEiysYNs?=
 =?us-ascii?Q?6vtEvorABc9FMU+Tka6mt5OY4U4UYG9z0N2N852/oJ8BC5COxnIBM0/zxtdy?=
 =?us-ascii?Q?9P0mdQRrobLlfVa6K5D76u2zyaywu26JdtY/bCdvsJaFALV4aFY6Lz0h0M3O?=
 =?us-ascii?Q?jk7ZHBHLBySGuC5IgNcGgI2nv8TkEEVSo1ulSM+WVn5/1/lbuwq8ne1zSwFn?=
 =?us-ascii?Q?TOyASKT0kd9fOXgh5on+aAZ4t9vTxiGawaPrNR5QWxweYlP02x/pJeMz3YzN?=
 =?us-ascii?Q?9wqXT1I8lwLku9dQkDFHKl3CWYOD42n14FpPma9ThSZOVeL+48fvSMLF9i2l?=
 =?us-ascii?Q?y7rXNuAGcIiSVHaeDNk+axGCKKXdq3rqZ8J+DznfR2eFhbgMqjvEwHT1tBRl?=
 =?us-ascii?Q?ucKpkkb7wBkj9yd/hS3LAEZKdrN8EGbxBCBarNho5+qPyUnwMJrX2A88AgCq?=
 =?us-ascii?Q?ZJIZ1KmnW8fEWt+mGhUPJUI+h4rfx5T8Is2L/GxV4nRQwHdEBItDDt+yTAbJ?=
 =?us-ascii?Q?Z3hMKdMVtbExxPpuY8eHprk8SeVmCOVwgnunJcJ5qHzXA3T3Uip5p/X0p1gc?=
 =?us-ascii?Q?cmQ6p5XIGrcbBpQuo4Zk5jGC90znZ2pgFOLRPUD2vUcK3/tsRlwHoLlpRA+b?=
 =?us-ascii?Q?yxbisbjI38TkjACY94KVb+NwbZQ/AFkwnGdLM6F18jLwd+0SNU+3Dhkxdg+L?=
 =?us-ascii?Q?PlTX6EGnhnau7408xN2UBmDsqCvhokbqcvkSVrE1K+1qm03D36CcdIJruebw?=
 =?us-ascii?Q?FzU1IXiJE6hmE2yg6IV/8SSKVA/mJ+dhrefTtA9Q5J3sWu+Qu92epup7Qpp6?=
 =?us-ascii?Q?Eij33czAf0GtiQMibjQE56SEagoGg8va7HGCE87rB1aosLlabMHpDBhH+8Az?=
 =?us-ascii?Q?rDupHmlirFkGVpwuCnd+8g34rvfQQQwYBD2/3yuiLMxJdDhx4entEyiO5ou8?=
 =?us-ascii?Q?mZpJWbFKg5nKBp1lRPkTY/+AhHpVmHfc+MnVaqaypLLjppXgIweKxKB/iwLI?=
 =?us-ascii?Q?+wvdXOSPpC4dcB0BuJrlHirr0IsSc1Seh+p59yP/HT3gvrpLIgsBcdzxKGDU?=
 =?us-ascii?Q?HSUT3vzxzjNEwptKvUxA1y4ELlDpFF9Chh8OEDgiVXusmtA7KLVjz3kgkMiL?=
 =?us-ascii?Q?NFV9AMAT5/sXYT7IrpnS9OhfUnAxMQX0QWL3Fa4PZKXoj3tjfc9DRLDeNEb7?=
 =?us-ascii?Q?QspMVNB9r+s/pRRsl6Y/QTGHt1+dI2NvecLU7PQD5Zr2dmj9ThFBjfjvS2DS?=
 =?us-ascii?Q?0/VN3zSWeYn2rHLfY3MEJwWVVMMEiAy3Vn4T2GzlXV/2Tp+zsrxf1XsVJ2EA?=
 =?us-ascii?Q?Gk5f5VxiXRiNp00WyjFeZiYKjy4GRQERMD4Qelnh4nvra4YQ8MngsocJl5rr?=
 =?us-ascii?Q?W/+oAjtE3qsw+0erEkW7PB2uOhJym9V1Tm4OQu3m8yd3ruvL3mrzbqA3tdxU?=
 =?us-ascii?Q?m6YSHnPDjhbLkTmzfwbnPZ7QC4COwCxoz4TDGM0D3ukbQvGmiyoJ/LU7ukiN?=
 =?us-ascii?Q?hIXuIV1UY6FL+/6SJ2s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d3c883-f44e-4e77-232d-08dced13d336
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 12:20:58.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxrSH/mViHZ6sjm3iaq/gR7NI6Wyw8/k9segt4h8/HpvJ19QumbDF1X975x3at4y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7285

On Sun, Oct 13, 2024 at 06:54:32PM +0000, Zhi Wang wrote:
> On 27/09/2024 1.51, Jason Gunthorpe wrote:
> > On Sun, Sep 22, 2024 at 05:49:26AM -0700, Zhi Wang wrote:
> >> GSP firmware needs to know the number of max-supported vGPUs when
> >> initialization.
> >>
> >> The field of VF partition count in the GSP WPR2 is required to be set
> >> according to the number of max-supported vGPUs.
> >>
> >> Set the VF partition count in the GSP WPR2 when NVKM is loading the GSP
> >> firmware and initializes the GSP WPR2, if vGPU is enabled.
> > 
> > How/why is this different from the SRIOV num_vfs concept?
> > 
> 
> 1) The VF is considered as an HW interface of vGPU exposed to the VMM/VM.
> 
> 2) Number of VF is not always equal to number of max vGPU supported, 
> which depends on a) the size of metadata of video memory space allocated 
> for FW to manage the vGPUs. b) how user divide the resources. E.g. if a 
> card has 48GB video memory, and user creates two vGPUs each has 24GB 
> video memory. Only two VFs are usable even SRIOV num_vfs can be large 
> than that.

But that can't be determine at driver load time, the profiling of the
VFs must happen at run time when the orchestation determins what kind
of VM instance type to run.

Which again gets back to the question of why do you need to specify
the number of VFs at FW boot time? Why isn't it just fully dynamic and
driven on the SRIOV enable?

Jason

