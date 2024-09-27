Return-Path: <kvm+bounces-27630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D93FC988843
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 17:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90F36283C02
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 15:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5EF1C1739;
	Fri, 27 Sep 2024 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jDW0Zb0t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C524142621
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 15:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727450851; cv=fail; b=CN7e14NpFqbf4lrmnzZzsKzcRmYPEd4wPsqPGMEXhDB7wbHemQQMccQl8bajaCgRHkXt8+HrbM/E7Yuyi8cixL5wpl+OhOb9QyZZFlJu/Vo9B2uOCJ+wg8R4dfxhDF7Y5vxscBYTW9UtLFgcuCUAyjMzytnTD7vQE9docdtzV+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727450851; c=relaxed/simple;
	bh=0YyRinfc+w4VhJZR1NjSNlQD+M/J5M2yyzASzU+wUcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cnAd3OHyFDv57VBncXhSN4SPqhmH5HI4Bd0Z5q2X1n/5EaBD7f3DfQ9TO3frkjRC+PI9nFFhap2djtM2lxS825hDwArfC03LcBHa+xTXSAdfprsty1mnjqeH9IFmUExEFrMOz5rAtOjEQr+MOsixLcTnjqwrr2eDEHBCVs5D1V4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jDW0Zb0t; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QSJBhxZRtEjERq11AG+h3fWzXkEfMNBmInvKdUeOhIb40ft/GWmSzkYCd4ahSxHt5ClbgbieVYxa09ZpXbU9imTfoARtk8rFxPb7WjJXEaWSeipFMk6aC6KS21hOcIwS1tQh4JcW7R34yOy8r7OrRQzRh6cD4tS/mB3AWEognYpcojinGFfE5UL/Nn5e5p3PY6RrsN3bRLX/snnJwJ6fNLBg+HRoRWxQJxKUHf2+L+CdrGhnohFHfB5BzEiVYtovY4gNWMHZHsqpddzy9bfS7S5Ri80eV5biOCHBbPaUYR16KBQ8AcSTYgtKutMw752H9jv0eyyY+6AYylYfyCiu+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pTdnrBYGUYHeR177lcdcDy1mE3mLolYvUp+szHMqF8=;
 b=x9BHPxDmIx2Zb1tkrfsuZDMev6+rhPfmh/lvvWecEl1Q0BIMR1/ZLKOZOHar+lXNbGftof/XFzKEmO8KaK+xnOuGwkGpc8tRmO1rsuOXxIPPioSpY4KpPxjwiGHMLwXOyDwPEaJTdtlCMIQ7fc2h2QR/zjRgCbJ/G0BRUTK9qISZ9QqiJ2lfHBB62xFiIiqcfTmwZb8+4gwytN0yIQMING/CSaT+jmKdVC5rkSIztU1mXjSLNdUtP5+64sfHpWzRc9w5id/V+6Qo22/Y2b27FpV+N5fATLMah6w77gOHahV8kJ0piTgklF9ydR3FwMkPyOTG9rsbQRxX4ChFFx9Z9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pTdnrBYGUYHeR177lcdcDy1mE3mLolYvUp+szHMqF8=;
 b=jDW0Zb0tYSfECfbg19NysjEBnjrdG5zUPbWsKV1/S8HUi9yTSkzmWv7PAQVIkUVonXOqp3xTjlOHKbjU1DhHNdSQOGWUhg3dJdRb7M5SMnY/tuub/QGyQkdIpfmklyDBq4gyAGClrnyOwehC3T/UOs01Z1l/jFk9ysYW6eGaTXVzAeFTlbJOCnxYMNi4/ezsy62DloKVC+QgKFysNooDbbEbJaGQ6lImZYfsWip++T4ClYeBrotv1qyQ5R8YKXqr6+QxK49Jcmi2OFD36X4agbeMn4Pm+aqhgDUj6vk7fHRsbhLGJX209M9z1krju5Y2yeE+4qVCFroTaiBUZe3oyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB5901.namprd12.prod.outlook.com (2603:10b6:510:1d5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.28; Fri, 27 Sep
 2024 15:27:25 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Fri, 27 Sep 2024
 15:27:25 +0000
Date: Fri, 27 Sep 2024 12:27:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240927152724.GC4568@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <2024092614-fossil-bagful-1d59@gregkh>
 <20240926124239.GX9417@nvidia.com>
 <2024092619-unglazed-actress-0a0f@gregkh>
 <20240926144057.GZ9417@nvidia.com>
 <ZvXjcPOCVUSlALZZ@pollux.localdomain>
 <20240927125115.GZ9417@nvidia.com>
 <Zva_qP2B4rndSiCw@pollux>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zva_qP2B4rndSiCw@pollux>
X-ClientProxiedBy: MN2PR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:208:fc::40) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB5901:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f0576e9-f661-4c28-85ce-08dcdf08e3b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zwHOrhwV3gjz2lXNXYsniVHjgZkkyVYzydCHtXwOdIrxeUk9CI/El41l6Afe?=
 =?us-ascii?Q?E+7lGToJKZ5TFFxyymc03ujvDDCnk132Oj8N7nw1v9VngOlwhC29WU61VBg/?=
 =?us-ascii?Q?Hcsh2t9T1xMWwZJadwQtLarJwFM1c1u09C/mMkumUsYBSi1F3OVtrrzou/VB?=
 =?us-ascii?Q?uv/POcchqgta3AhnNG1yv98Sj4iKyz9/K7q2BBTLp217BkL1AdyodDLiL9Wg?=
 =?us-ascii?Q?k4+v0MAaVY1PMcfAus9RuzvcjJsZl5xyEkZ7LEw5OF6xBCmzaSRv2CPgysPx?=
 =?us-ascii?Q?ZVX5fCIo16g7phhqWn8HcY5bcgOjI4zyzLb8eD5xULkQt2cmM9HejgiOmzqr?=
 =?us-ascii?Q?WXcXppIsfBGrjud2EjYHSu4IbefiD8Epjo6WVoUJjer3FwossjQoGFDPsu4O?=
 =?us-ascii?Q?h/yeC4bY9oy7o6jNwOw9lzxeW+CHjgKIgyx0xLEMJO28wf23nLLMvw8cOB5q?=
 =?us-ascii?Q?gaFXRHGpdGqS0nHc3s6m9AB6/fbLQ/gerandsRb1nVqSiT1UFvA1evKfm9mX?=
 =?us-ascii?Q?c9sOWf8xxw2ByXE9D1eWEb1xp4fSB/IG0tsIJq1eX6tmjt/nvwmOST+kIgWr?=
 =?us-ascii?Q?xu4qbwTbsSfnC4kMlzuV5bySkPzvhLIC66EvRfHNgPocAthliAr1SkgRaCVm?=
 =?us-ascii?Q?K1Qndg9oazziE8+2Q3U8AVm+WZaHOIlFwCdp24FV8j28tLR0UIWl/tD1NLHQ?=
 =?us-ascii?Q?NXJpWW2OFp12KSlJ3aNe8rSmGp8ZNg1/X5GqpuOuFFivHqYVA0Gz156LsNY1?=
 =?us-ascii?Q?VJ5ruNAGaw1hMurJ5mgOqJ2r1ywYCTVobb/EJtIhQjrDzAU96CimdfPFnXRp?=
 =?us-ascii?Q?cfIwnlgXVcyrPzG1IWnuNvJvdqEGLPxQcVenwJoT0TO+O9SkS8IDTQb5gP7t?=
 =?us-ascii?Q?yfqNaMty7ik8eS+rPc4Jg2o6VG/tgPElx4DU/UTzTCVlABKCgIUvXOpd/WAB?=
 =?us-ascii?Q?dhvqWjmmPg8qL6s20Cw0XxXeFW7vGbBvNJmlHQYj+QySUdrFPI79pSWtcISk?=
 =?us-ascii?Q?LfB+IZOl9H4aOr0lR05FgMnSuywPgICWlEaW9885SIbbUy4808uD6bOoP4hW?=
 =?us-ascii?Q?mcWQM0JBfuyxyDMkwCzMdU16DKHmbRkx0s0hjc/QvzjDB3KioP5MffuCxhPy?=
 =?us-ascii?Q?4mlajpjJ705xqlP1ifOWK3EpAkjhIbcRvbJkvrA6Vm6Z2qtbt/pwew9vOjAw?=
 =?us-ascii?Q?bLztxpjZGFYs/BiTkSXo5N7OqwUOd+Su8ZxkfkDB9SEJzpenbzkirCtuofKP?=
 =?us-ascii?Q?iy46d5leYzr+5TJnmVbP+Acwdr/vlDL3lfHaOUvABA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nt+XWEhapZxEY7u/f4AxumGxWMZMa/P7RFWQnzs5J5bx5Q1PELBCv6zQaDUH?=
 =?us-ascii?Q?TN8M+uJGNKHE3MkW0e4K87JScZefwPPB4y4vtKI3r/w7sRcms3/W5ywxX/rO?=
 =?us-ascii?Q?GfzfsxLObdYMVq1rLb6ICe6DS4XanYPQAth1TpGcaTC6ENwBg4j9RJzzlkC3?=
 =?us-ascii?Q?g1ow3YTshiaIGt5UrnKlxs8QaWy8dtcojtuGlDDFliYFG6iF3wh9z6sl66hs?=
 =?us-ascii?Q?nOPjUNcL5pn4VQrUmjhQp5B42y8iDlo3aytHGBbZul96C4IK0MbAnikRcdAc?=
 =?us-ascii?Q?Q178KWMwbXyJq5FnTxopO/JYzUvn9IVwPiSN/9GzlYlE2plpxFloBEXm8yJ0?=
 =?us-ascii?Q?hHd3cnWpfYMkKzSsnqtCSqM5iN2A1hoKqzdcpeeOyKQbLghv0nresc/DvBnx?=
 =?us-ascii?Q?BbByEvb+en6wdA9YWBb9K2ykCBbJrm5M+pMHG/CIb3BSitcvUr3/Ll5hfwBC?=
 =?us-ascii?Q?0N8OstFewm1hwrWZ3B+kj9hhJJlnzD+OOARPhd2XPjBX2RTD5fb2brQn2C4F?=
 =?us-ascii?Q?egJImW/ECxwOCBCLXoI5jpkL+3JgE9gLsXc9yvTtAfAOY9L3vsLuomjmT2ea?=
 =?us-ascii?Q?4eQrZnYJRSGOyupX73Kiii2FiqSJUITsgS+9zJbkSvrpGVAM7aBgSoeghJc5?=
 =?us-ascii?Q?Rr8m+9xe7Y77xW0JuJVkvcIoPScIxBgWh2C/jGFKeL0PFAfUSMd9jOvAzTxs?=
 =?us-ascii?Q?FT7WFhOXmnGf9wPkpJapPwJ+oNTfpBiLNQ9SNXM95Tis/kc7I9yEzo2fnvvF?=
 =?us-ascii?Q?gnrzoit97UbJv42SEon4LxvIOii8iCBNMPN7/NtpvFOmHt3xs6mfJ3u6ZGje?=
 =?us-ascii?Q?Tm61bW8NdjBm6ZUZDdAAv4Fhbhv8AwGN084l2x9dMyHuFqZmiFfIrPXgpLR3?=
 =?us-ascii?Q?U5ocQ9U5gyJoH99l8VXs+Zcp6pvwbqg++bZP7Lbu7dNKfhF2ERbMZWCEaQ9Y?=
 =?us-ascii?Q?nAP78OfOpjD9/mnP2r7rVXi7YXLevd9ELtlPLH207cu6IaC1UrrVdXjC1u70?=
 =?us-ascii?Q?wx7sJ+NaiTAzM1cdMh/X0GA2Lhl5URdCOHdQXGmHPZ4zy3bYBMDvhBvtfLCY?=
 =?us-ascii?Q?j3aN6AkNsQ7yfTOcTfuKcHhFom7vgeQDGtRqy9FsjBKgLSPB51qXzm03ANvh?=
 =?us-ascii?Q?CVvcJ8hXgjFdtrVo+iAJknR0A3P4NHjwA4rvvKn8a2KjOiyWS1Xt8ugktjNs?=
 =?us-ascii?Q?oKTtS7bcII+ayORAHD7E4iOBbEBpzaTHZF1P6IQiyL8sNqLggxQlyZ6qcTd0?=
 =?us-ascii?Q?IRNRJ0OOPs/eB41N0NYnB/7milzn+SKuubZkPfYAEEdRYosppeqNWtMtZpPW?=
 =?us-ascii?Q?uqsru2zu5rMEUl261TGY4kPuIIbZN2LLRPkcH9sNi0WCH9fGq1vTlM/RwQGu?=
 =?us-ascii?Q?+FuuLaijPTE47pUKsFKpDcYbG4/D92E2v/+Gs8LzT1GQzpY3t1N8Piwx6Qub?=
 =?us-ascii?Q?IfTBhbNj0vym/7YoQf3Ihd46h2KIKqkkO5Oq/+2uXMKjdar/8qcWyJYEv6tJ?=
 =?us-ascii?Q?31jexfhVCx/PpxUUMy6syNh3IxX+pttZ/NmLGRgGKBhLYc0BBG/CXiK8YHNV?=
 =?us-ascii?Q?DE9MbqQL663nSM/qFJs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0576e9-f661-4c28-85ce-08dcdf08e3b6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 15:27:25.4890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ym6H9LI9hr8wLq4M7pxCNLkiGnuG78xf36Pjn/X6uywS/bIZgyXqH4FftBqxr1wD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5901

On Fri, Sep 27, 2024 at 04:22:32PM +0200, Danilo Krummrich wrote:
> > When you say things like this it comes across as though you are
> > implying there are two tiers to the community. Ie those that set the
> > strategy and those that don't.
> 
> This isn't true, I just ask you to consider the goals that have been set
> already, because we have been working on this already.

Why do keep saying I haven't?

I have no intention of becoming involved in your project or
nouveau. My only interest here is to get an agreement that we can get
a VFIO driver (to improve the VFIO subsystem and community!) in the
near term on top of in-tree nouveau.

> > > But, we have to agree on a long term strategy and work towards the corresponding
> > > goals *together*.
> > 
> > I think we went over all the options already. IMHO the right one is
> > for nova and vfio to share some kind of core driver. The choice of
> > Rust for nova complicates planning this, but it doesn't mean anyone is
> > saying no to it.
> 
> This is the problem, you're many steps ahead.
> 
> You should start with understanding why we want the core driver to be in Rust.
> You then can raise your concerns about it and then we can discuss them and see
> if we can find solutions / consensus.

I don't want to debate with you about Nova. It is too far in the
future, and it doesn't intersect with anything I am doing.

> But you're not even considering it, and instead start with a counter proposal.
> This isn't acceptable to me.

I'm even agreeing to a transition into a core driver in Rust, someday,
when the full community can agree it is the right time.

What more do you want from me?

Jason

