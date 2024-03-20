Return-Path: <kvm+bounces-12322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 564E888181E
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 20:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7046B21ECC
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 19:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BB28565C;
	Wed, 20 Mar 2024 19:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bz/Goxn+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5924C6A8CB
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 19:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710964096; cv=fail; b=Dg+RZF1cs6wMbZApNAw9aFOZPEEYnGxOIzdO1resgjDoUIjIMJLx7xabXDTAUkKEvhhx2uKtSAuEo4+YRxNRdHPHLyEoZtnl2DYtpZDZPAkWv1gi2lXsYbup0q1wDVxmCyjGNz0gGu2Av99frnhB4oT+MPOHQ3zvtOAF5EHhcug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710964096; c=relaxed/simple;
	bh=Q2BA2YzDfoeIookrR8bKHqUgSqUH+VyHkXMZ9x1i/xg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsdNGOndWEoBTce9cZuHppELB1RRduT2z5JSCROCFVhSoVooTUOUDDg4Cx+dDQquMGqfFVJDhL1Fju3nkb6vCDa/Dax3ugvz5tTvzIspS16w40A8LjsTU4lLNSKhVhoVbieNJTVRaKfvpGzu4y2+rLmBaY7UMgoLVFizBn1RyxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bz/Goxn+; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qy4OjRrT/QuDiysqntTf/UkHyfCUGlnh6QKNBK7OY8PGV60hZdIpbktK5U7vj1HasYQJ599SMhgDLY+gOL+/PaI6XPXCcCPBS7SdOZ8CgS8THtxSRRs4vKryMaXeeKq4Gmk43VQzd/cu6sKNDRU5eBtRxodDMgY4qnmO3sI/XDd2hbY0sOiQi3UbE0xLKReRnsd6fWAiQJqwchsgM7MciBucTh8PG8/t9F4otAeYEankIFiK5ASpTffELI4Y7zNMcs+ozl1AseAGvQTZ1/AH5NphEciGbpH1J8wUMLU3MToGsDMcAYX94kra3dfaVaeQV+7Xx5YHMRl2gqvMWahIsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drryOzZBx8YabX4Vh+BJ5HVuFkD7OTcdnL78OzNVwyQ=;
 b=ZKZ0A4zDMRCYcSf9ObxCm0txT3kRb/eNiufDOncxKriwUme2V4/78WGvN0RYiPd9bTYOZmL5Of/a8xelB9wK6IKLyh3u+kRoiBCEb6QjWjRnAr6QwwFKsi9OT183rcPhsXe4RfLPFZ/SwKToKKvX7M/YopaGsjcGyLsXc3utrxR6h2Qq99Amtmk76/a+MdxjbCtMzfnHS4DEO8JsirjDaTSlDuvyvcdgqzTtjWSTPquZalA6vwzowx0fD8ZNIS/aklvSKtPXYGBaOJ2kjzQbZ7dPEjCj/BXWonYiXiCNzPI687TLZ1TFagR/81+94zqIEoMyvFo0hOVtpAhYmZNAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drryOzZBx8YabX4Vh+BJ5HVuFkD7OTcdnL78OzNVwyQ=;
 b=bz/Goxn+he015NNkmt4dhaM2/8G+/riE+DKJcxT92qd5hwDy8aFoa3tHNE5fzqBQtMQFHjf5y7NZ/mo1zMQKTTv/JDUBVhCPx6n8CluR3d4qv3Wr8O3PepnNJBC09vJ3aLWYwAE2KuzqNrPExBANvSOGRkNJ57Lv9e/8TmcPjN0=
Received: from SJ0PR13CA0225.namprd13.prod.outlook.com (2603:10b6:a03:2c1::20)
 by SA3PR12MB7879.namprd12.prod.outlook.com (2603:10b6:806:306::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 19:48:11 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::1) by SJ0PR13CA0225.outlook.office365.com
 (2603:10b6:a03:2c1::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Wed, 20 Mar 2024 19:48:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 19:48:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 14:48:08 -0500
Date: Wed, 20 Mar 2024 12:38:02 -0500
From: Michael Roth <michael.roth@amd.com>
To: David Hildenbrand <david@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Daniel P
 =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 11/49] physmem: Introduce
 ram_block_discard_guest_memfd_range()
Message-ID: <20240320173802.bygfnr3ppltkoiq4@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-12-michael.roth@amd.com>
 <750e7d5c-cc8b-4794-a7ef-b104c28729fa@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <750e7d5c-cc8b-4794-a7ef-b104c28729fa@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|SA3PR12MB7879:EE_
X-MS-Office365-Filtering-Correlation-Id: 0170d800-207b-4fe1-da1c-08dc4916ac8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kd/dxiDsjpLt4WbqCSFSdF/gCtmPFq8XXQMb4p9d+3Q+Hur8NmVmsbGPilO/R6B59pxZByuzzlbbtPeYtSnQEgTndiMw30IfLPH+RSV27bX9w66L+7c/FhLXDhYe8jJQ5NC8a9YgpNWqOXJzufmDGtEd/Bp/w0NIMkCw93s1+fbBO81cCZ7pVqAQ31PUjInsYi3stDhlj0ksLx4OYaHzkxOHdoydBElAkut4mo1aAkhd2vja3JeCMgnecpiU67IadvEDRJbx6ES7izGi/h3x8Ax6mgoWgWQh87l8W0adzWRvW/C0sJ+H8IQAO9lo/Jo0fQt0xGkt6NkX6EX+2l6gwrXX2CkOVPA9GW+RyQxpNkK/aABabxaf2Kbee25bgGfJ3Q9Nzq+1vWzpJ07Ynb6FCRDHK+ZFGQPVdOIJZVEdR74epamYQ2HaY/CufF7xaa39/Npc34aWgQVTrCBvpiSmxcGRFkcXs40NIvjp43B2o17LBu6OghM5pJe3JHSCpUdvN63dhScQJ5ImtADRrVBJoliuBV1uNh4S0sdUDAAlQgifvfDJtE52fx3p3hE0j5b7EG7U30jqZjyQWyEWCEvUckFB86Ev1KLXW5f/qRmKe+D6nw6ARg2i6aXesCWhFKQ3pdGoDzEw+jXSOiD3jOwtY5eqzvBTJDZyo6LE5AFYfftDU0WEOWbJA6OW9/iUkYA4TgVvyrSpz2wiK8n6tsya8mwYIWhx99mC7a7s+AZ+cobNQ+x28UBlwqxQ8i2Z3JTG
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 19:48:11.1669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0170d800-207b-4fe1-da1c-08dc4916ac8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7879

On Wed, Mar 20, 2024 at 10:37:14AM +0100, David Hildenbrand wrote:
> On 20.03.24 09:39, Michael Roth wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > When memory page is converted from private to shared, the original
> > private memory is back'ed by guest_memfd. Introduce
> > ram_block_discard_guest_memfd_range() for discarding memory in
> > guest_memfd.
> > 
> > Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
> > Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> "Co-developed-by"
> 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> Your SOB should go here.
> 
> > ---
> > Changes in v5:
> > - Collect Reviewed-by from David;
> > 
> > Changes in in v4:
> > - Drop ram_block_convert_range() and open code its implementation in the
> >    next Patch.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> 
> I only received 3 patches from this series, and now I am confused: changelog
> talks about v5 and this is "PATCH v3"
> 
> Please make sure to send at least the cover letter along (I might not need
> the other 46 patches :D ).

Sorry for the confusion, you got auto-Cc'd by git, which is good, but
not sure there's a good way to make sure everyone gets a copy of the
cover letter. I could see how it would help useful to potential
reviewers though. I'll try to come up with a script for it and take that
approach in the future.

-Mike

> 
> -- 
> Cheers,
> 
> David / dhildenb
> 

