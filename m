Return-Path: <kvm+bounces-27566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E549875D0
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 16:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72DB11C24BF8
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 14:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB6413B5B3;
	Thu, 26 Sep 2024 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AZ2NZWXc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CD34595B
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727361663; cv=fail; b=Jm9iXJ1ftYA1+a+xVQ68XxfoKBPy24lsUb7D8po3Wt0TUbyEPADP2R0XziQGzKJK9XuOpjUigRYnWzg0nfJoRLLa7CDOn7D/NEA6nVUbYcv8zzCNu30DsHtkzwUTDij5ejUeGvz6u6ZwqlouOqehPpPko1g8Er/hNwqpSe80iXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727361663; c=relaxed/simple;
	bh=aIj/7BH3Wzpx9vCysfhhI6DaN7tEfZqA31lMjZHxZiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pfrgLYLHqXGUm6/VGvkQR7FXCTxSrRXGUJzsluy9F1L8knjyUPrh6YTiOoO3IOE6iLusfHve+S5cFpPlHE4n0dK1RDjnYYG9qieSz9S1taCg1TbGVkkz9TXMLuffEjQ3ScsU5yf2632K0y0FPznBcVdY7EIrE7m79a3V3ezVJvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AZ2NZWXc; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w9zozWMoOnoJxNhjtufORyNyhhWgXAJMncpUv99HPW9PatfWml75XuRC6SkfR4Kbp6MHUI4vi72C4lkkFvaXaDGaUTfshOHBkLNDEb68Dv4cKmhs1pAF9vrmOTZuVKzAwCvF6qCluCYqDF/VKmX5bcEZA+UYpHdyqhKWXvr5VEYE0an98u6NCmIU3tLAJqd+dkFfmPK2J+q+zB+X3XGhDYPzqx02k6UyDtfuIMiy2ljLJnr80eZbsLVLHzmA16aZY4Udq01XD1y/RZKu5KnhY8WsUbvbTflPtZkmIjrgGLyd37HzLvl98KbSvKIwiqcjvtcApW18sglJXz0ZCigcyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ld+kbfLUCty8AX8jYxBKBC+hlqHoBZ2ceJtZPB6D4LU=;
 b=Fjko1b7k6FZeMCc0sFXrUo6+NouNN5UvGaj1E8xskOUa5pFfshwGm2Yqci68rLz9lQ4uE3+ehUmtdI2IXGOd0z6bm1cUO1Wss2P+eobjq/MBHCQNIay4mqkbJbUfIrt6/2Q4N1vIV1VvVvgkYI6rJYTA4fzaA9hYGH/ExObkzziiPL4rcFI0rxF+dArNsrfdZTdGz1ojbq2unt4e8F85h91e0V0PUkh2ZgfO9GDgydHkom1K43rHMJPTYhu85mRxE5F/NxYuDmZ4PNiXW/eUg9neHuwAjQt5lmubxJpD2ztOuwZL1wpthgXIQLt6PXMCY2Vt8wBGZTf8xVriAJu7HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ld+kbfLUCty8AX8jYxBKBC+hlqHoBZ2ceJtZPB6D4LU=;
 b=AZ2NZWXcNZFLbPgN8cIDHWgci94+bpAm4bBAcMcme5T4YdH97SVBf54zlohjIejFfkePz1m0A2Nq3hlmQnO/YLXSkFxx8pUo6oIYk7n7buPMso1/65JS4ppvrA7UZx+0hEnzPjYx03l7QAAslUc//XNqg3mYIaTZuKtifUhvBeR/XAHFQ9vh+KKRrdf8AedERsuOWKwCo1gT/DIpqVnO7nGLQJVJTyzphb3f5kOaC11qdPDuXl4v5UPJV3JdjOHwuKl9r2QZmZRXnwHVEu75h42+TEgP0PUI87tjWVKi5uBzcIc0qSYUg8JtHeiNQ+JeUl0b0GoGQ+1rNZ/NV8l9hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.21; Thu, 26 Sep
 2024 14:40:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 14:40:59 +0000
Date: Thu, 26 Sep 2024 11:40:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240926144057.GZ9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <2024092614-fossil-bagful-1d59@gregkh>
 <20240926124239.GX9417@nvidia.com>
 <2024092619-unglazed-actress-0a0f@gregkh>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024092619-unglazed-actress-0a0f@gregkh>
X-ClientProxiedBy: BN9P221CA0028.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: daea140c-a711-4f2c-fe5a-08dcde393c96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hBWYtwankgFYxnFiqYrS14KmjEkqEqmUD8RqOoPpVbsOaPrh6lTCIBynDOW1?=
 =?us-ascii?Q?Smi0XByi1xPGyczWnh6Nq8Pk3n2GTCMzWQxYTdPbp8K88vL+lS9/KjBcsfkV?=
 =?us-ascii?Q?xpDkUQxWagY6tvEmwHGDvY1I7uHozfgF9kpVOc2ox+aFE0kYkuyGawapY1ke?=
 =?us-ascii?Q?d91f0CEdkFl96JWLsRTVOzeVzRwtO7cNGo++IB5bpK7ZFczNJYHzHkwheib2?=
 =?us-ascii?Q?LOk/ZBFtTgusfaOwMBGm0vy2LAGCB70Zk5Gcnf5P+0KHF/I3nzN7+07OcUkW?=
 =?us-ascii?Q?Q4QhwlMTxmDZLdxOTfRP/dNgzB8iJfitcuzk4rXiRiERdNIboqpcR3V5CQH5?=
 =?us-ascii?Q?gf+Gqb4vCV+o+FsPTPAnzZyWvrxcQDSPrT7Ne5+m2/Ax50fj67+IMKo0OL8x?=
 =?us-ascii?Q?D41kLKMMulSO7SICfhQoFAlKjiuKpIm8kgW3xQd6eNli6AqhV0CaoiLtnhFF?=
 =?us-ascii?Q?yzqss2qi/6qSB6CUtEw6N/BbYsy04faOiyY/iDDenlLOa9f17EMfpRIAe2Xn?=
 =?us-ascii?Q?V1nfm/B07m4uWf2UAT3aClus9V5TtmKaUIp/OdeilyvWmDHYVnfiNw2B6fJ0?=
 =?us-ascii?Q?IGqcygkEjbfpRyrlE9D4tlxIdfz//oawXLUBFjQVIMsYpyqhOtNNS+psj5DS?=
 =?us-ascii?Q?lykkcz4e+l1Jdr8Wg7vjXfxANkGlZFE3ZY5sKRL+rAwhudUu7KEzGB1/oMrh?=
 =?us-ascii?Q?rIxXUU5tn7TBUSjQx0N6QuPzAnfkvtLmhyGHIuFN8XH/9+1iijPVgRJypomb?=
 =?us-ascii?Q?kSMqnW+97ORpZAe2+7RIRQ2x+dyTIqhMzFHH+t4r8PnoEHu6wqdLP1eX/gYl?=
 =?us-ascii?Q?4VnNGwnFVNU4KXoXEMZaJpizyvqnki6SE35xfWjWVRTo4cc9nwwT+9SjnKVj?=
 =?us-ascii?Q?7+zyZECtIXofRsa/hqvqwj4r0LA/ya+mWn+cx5sXDGgm9JTsG7T28DPL+c7/?=
 =?us-ascii?Q?rQSGD0b/F9/h98ETpbw5uWksStKaolgnylhqBy1TmV1YWIGDervU0ijruBbN?=
 =?us-ascii?Q?lp0r3t/WFhjZMBkJ9croMUMrt9vIJFr5ubyOHETxZz8pt20KmH8QsbtgxJnn?=
 =?us-ascii?Q?ZWH8zrxMSPEhXCOpXQwfXlLRpuCS8mn42Fs2R6KZd3DYBh4tBaDPxxvR3jdL?=
 =?us-ascii?Q?z9qMBiM7cAiLqa381ST6qUd/Tfo6TZYD0z9Csd0MQbPA750VQLVs2aJSyAV5?=
 =?us-ascii?Q?Kb8mxyg4pUNVancm6/EfAVIG8LkaAsmxi3aj0CgQ0XYgfQWupxbw98YpUfod?=
 =?us-ascii?Q?Svw2g+QvnRD/Sk0/nslZCTD3yAK6JDk53bk1QeSHxg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wuBeoi9taRv4/gFxW5KcJtKhlJbud01STXdqudJ9on6kxu/yoSfU4UIZ2XXM?=
 =?us-ascii?Q?78Gnq8hhDC8OVcP4+Eh0Mpahbk6uW/JC5PAGVYOf2yApXk5qzbACuszDy4z4?=
 =?us-ascii?Q?GAgt0NfvRKY4YyjUjKBk+t897fGz2Ib5RSZ+mJN9SPD4qbgcH2dxqUTNhXO8?=
 =?us-ascii?Q?wZgwAA1V9M855OP7tQRcNgmQJWZZ9oJLIFBcGOBo65JhGOHbrqIA2p0jNe55?=
 =?us-ascii?Q?KaYGgKhtqRC+Zoo/ZJqgcknR03m76ch/tC4cBYEiI2BP0vO1G6Rt7pxOg+t/?=
 =?us-ascii?Q?ifJCTUO6WSH7sSY+kh9iZWejZXU+amdowdZNybuKFdEYH4AMpGzmri0wRAgc?=
 =?us-ascii?Q?3StUa3ylwegM7Co9G6eXXiNuQ2j+L5iM4eRqu/cJ9MUKDAqYKXPo0xkq3Lbc?=
 =?us-ascii?Q?gfdXkSI3AEw2KRZf3ErWw71kHKF7DFM8vf/s6ivbviHsLXxLxNp7LJ/kTrxD?=
 =?us-ascii?Q?U5JpTT/nt6m1khlefk4OZ+K7+UX4Cc/spaWVYaNY3vBYh2224aEzUt7AdszA?=
 =?us-ascii?Q?q32ztZtZ7X/Pag+K9G/6CwdP56XxPQMQcs0BQ0l7j9txBj/v9fiIxjmQIgPG?=
 =?us-ascii?Q?Jhmi/VBF8YYETJgdOfhAbz2hZVpkzZ3vmJZ9kvYZa5wysL2H/zv1RjysVNS5?=
 =?us-ascii?Q?XGJf0s4AP3CB+yxu+nITfNIBHjabZAWZWdceRd3IXfaf3Y3AMIOgPBRWTHaK?=
 =?us-ascii?Q?iDMiQLIWWZ3VkH14ebLTiiKpgnm4gQU9z9ntG2Oon5nrd4HItK+8sAL4a4WK?=
 =?us-ascii?Q?eSVmBcEbYzYETb6VjcbcROXOGpnc2Qz86HV8A1bNTgQRFevts5M+JNx4EFEn?=
 =?us-ascii?Q?/W3mNzwKtHu+wLYcRO596Lsq+BChnYJwveG8zg+tAxZWPzzBuAWBwy0Srb3U?=
 =?us-ascii?Q?Nrr6/GBFRGryeTiMLR6E96AVbPk7c3x6q2uZ7TKbq1leWkdKMA3hLR25gFES?=
 =?us-ascii?Q?/jGfk07QPyHKynAL+Gfw6c5u+c/bBwSH9MLMOBbp9ubYi9uVRQjz5BEv5aUf?=
 =?us-ascii?Q?w3d/v9yDLdAO0Nj9hQ0goNUhobb/h5K/TsxzyNzyo/WtRCn5ytnTg2DrF/KN?=
 =?us-ascii?Q?VJaCkUVEJ2iu+4KA6bOEwMmd1XF2g4ijXFM7UOMT5bfSaJ9ppssH2ZcnWkzZ?=
 =?us-ascii?Q?HkFK75GLlSMhN6c2CLV3xV3Eg0dUxTvr7eitg5oCr6NBKHWDDOj0K85Aw+Ti?=
 =?us-ascii?Q?YCAKYtU0A7+bdNtS0kfsxaUyYVMg03G27V8v+3VbI8+96YC+aie0VZja2z+T?=
 =?us-ascii?Q?avs2GxQX7KdSW2Qf1UZTwYkzQMyFroUS1H9PT1gXFo6xZOKd2Q3YJ/kDbLWA?=
 =?us-ascii?Q?VWchUYHlnmKdfuygnK11NNddNo5cuAJXSyMJE4/hoKCkciXLq8E6SaTGSbYX?=
 =?us-ascii?Q?fhhDfKEEtbyuaLFd4M0xyNeOlb9ZjKPMp7ufkEFe053MgFPXa9f0iW0E30FM?=
 =?us-ascii?Q?14+pVKPe30hDqP197d7ivsnnRkzJTwRImrgoNEI4W0NU6PVQU4Hz9wrCwzR+?=
 =?us-ascii?Q?Q2vHQPnMEyajJsjKXUDi7H3X0eKFiKCZtUA9/7pxKHUPYbLFo+UuR+xtYxXX?=
 =?us-ascii?Q?JHRf0v8kKlB5zpswPB8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daea140c-a711-4f2c-fe5a-08dcde393c96
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 14:40:59.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6XpLE5KqI+3z/P3nME3b1nTWZ76+ivHi8D+1u5clZC0m1MQEmkqRZO+Hn47VgWH2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392

On Thu, Sep 26, 2024 at 02:54:38PM +0200, Greg KH wrote:

> That's fine, but again, do NOT make design decisions based on what you
> can, and can not, feel you can slide by one of these companies to get it
> into their old kernels.  That's what I take objection to here.

It is not slide by. It is a recognition that participating in the
community gives everyone value. If you excessively deny value from one
side they will have no reason to participate.

In this case the value is that, with enough light work, the
kernel-fork community can deploy this code to their users. This has
been the accepted bargin for a long time now.

There is a great big question mark over Rust regarding what impact it
actually has on this dynamic. It is definitely not just backport a few
hundred upstream patches. There is clearly new upstream development
work needed still - arch support being a very obvious one.

> Also always remember please, that the % of overall Linux kernel
> installs, even counting out Android and embedded, is VERY tiny for these
> companies.  The huge % overall is doing the "right thing" by using
> upstream kernels.  And with the laws in place now that % is only going
> to grow and those older kernels will rightfully fall away into even
> smaller %.

Who is "doing the right thing"? That is not what I see, we sell
server HW to *everyone*. There are a couple sites that are "near"
upstream, but that is not too common. Everyone is running some kind of
kernel fork.

I dislike this generalization you do with % of users. Almost 100% of
NVIDIA server HW are running forks. I would estimate around 10% is
above a 6.0 baseline. It is not tiny either, NVIDIA sold like $60B of
server HW running Linux last year with this kind of demographic. So
did Intel, AMD, etc.

I would not describe this as "VERY tiny". Maybe you mean RHEL-alike
specifically, and yes, they are a diminishing install share. However,
the hyperscale companies more than make up for that with their
internal secret proprietary forks :(

> > Otherwise, let's slow down here. Nova is still years away from being
> > finished. Nouveau is the in-tree driver for this HW. This series
> > improves on Nouveau. We are definitely not at the point of refusing
> > new code because it is not writte in Rust, RIGHT?
> 
> No, I do object to "we are ignoring the driver being proposed by the
> developers involved for this hardware by adding to the old one instead"
> which it seems like is happening here.

That is too harsh. We've consistently taken a community position that
OOT stuff doesn't matter, and yes that includes OOT stuff that people
we trust and respect are working on. Until it is ready for submission,
and ideally merged, it is an unknown quantity. Good well meaning
people routinely drop their projects, good projects run into
unexpected roadblocks, and life happens.

Nova is not being ignored, there is dialog, and yes some disagreement.

Again, nobody here is talking about disrupting Nova. We just want to
keep going as-is until we can all agree together it is ready to make a
change.

Jason

