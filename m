Return-Path: <kvm+bounces-6854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD8E83B0C9
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 19:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 850E4B36E90
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 18:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2695A129A98;
	Wed, 24 Jan 2024 18:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wnytdPGk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC357A73E;
	Wed, 24 Jan 2024 18:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706119335; cv=fail; b=WOt7LcwPjmmB2fr8u46MXGG4FDrzff1IR2STNZNG0WuUVPE5QnjmUX1+oY5kKp9tfPzUSPGMuOYVfRlFL3vJg1frYXwCrKUOXG8bb0IhZoE8BWnorR6cCOESHWwqNLHpRWSv2OpQwsMIHrIIzw+RbfAv4hBzKq7E5z5OGChqZE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706119335; c=relaxed/simple;
	bh=Jb0m4Eovt0lCtDOnJUmbTVQ95GM1fhfaI4A/7B0DcnM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DoptPy9Uk5U/7b9CS3fMOgDhw+q9h4HJNW//EXE7OrS2t9W9IrldyQdJ5tGELNLIBy3cuLWNr4dYsGdOFtBd705fy871JKuGm47DaVrXWHip02g1DkSXRqQc3Y4cv+mkJ3dJf8t8D/ZJrjSjndKyViChGHS1Nhiz1o+e9qfZIA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wnytdPGk; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWcGLzHpmMVDYtRCHd1N5ctX+dYaa2SrnC9PsSQd9btK7M0CPbmYOdxgGwoGeV0w9VXI0LuTz8kw6R17o//gCWnAQsqyfDe/DSy/CSb8pmYphl+Ne4zzVkas1VmEL6cd08/fI3yexfHRAcF5BNISm1QyKXpv0YT0Uj3sLIrvYaYYS9hq/6L9G/LKOf1ogclrQeiqOCisRHc+WbtAuu0sHzrTIPPAjQB49yqk5G1+7E1y3NVlHHkcLkslicHit45wjwHpli41uRRLq5t66cz+uVPFVd0atelIeNFa4CS4kuUX2BbgYUDD8kgc7SCgiTIomThoLoFuE6ls9SVRYuR9+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5olHOcLBAPEOg21Cz46OrlKpmKwzO/UrMKkeTSSSQ8=;
 b=SKEFvTWuSvLmJnqnrHEfWVudjhk+cmX0isL10wMJdVLXHPByZFPZBDrylZRpQQcC2jfLXWEjNu0zLhtH7KQD11fGY6haFMxPJNe7b5ND13qaYG+RvNSBTiCmMWqIrrbdW7AEzPUfsMiSZNv2GVH/FaYpsX/DLqHee298znmDWXyq2UvAJUMcq/Rrf+kJ7D8DQSMdzFPnNYqBPzb80/wDzyq1mewKlO/922EmzGRzumdEWIy+olMZuRlaqwtgTkeNzJK/4HUNIL7juFHFBjE9TIDAB88NsWPy9BmpHgiLyUBPng/HkjKPUfVcbihKvWhv1KNpz5ASbOFzmCZWLkvB/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5olHOcLBAPEOg21Cz46OrlKpmKwzO/UrMKkeTSSSQ8=;
 b=wnytdPGkMC1UD3j3MrtQKmRGKv9t5eoI6gx9ndap6KQ4Q1TAASCUPf8fL892DF0+Kbzf9n4gNeXmezEQ2O0br2bLw1tW/xO1WY23RWchfS5R+mcoH9qFm5TqDZ9XyjEgLKaySVofmzrLneWs5/vx8LaeSRVjujyoBI6JakNs5TE=
Received: from SA1PR04CA0007.namprd04.prod.outlook.com (2603:10b6:806:2ce::12)
 by DS0PR12MB8270.namprd12.prod.outlook.com (2603:10b6:8:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Wed, 24 Jan
 2024 18:02:11 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:2ce:cafe::d) by SA1PR04CA0007.outlook.office365.com
 (2603:10b6:806:2ce::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22 via Frontend
 Transport; Wed, 24 Jan 2024 18:02:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7202.16 via Frontend Transport; Wed, 24 Jan 2024 18:02:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 24 Jan
 2024 12:02:10 -0600
Date: Wed, 24 Jan 2024 12:01:50 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Jason Gunthorpe
	<jgg@nvidia.com>, Yan Zhao <yan.y.zhao@intel.com>, David Matlack
	<dmatlack@google.com>, <pbonzini@redhat.com>, <isaku.yamahata@intel.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.01.17 - TDP MMU for IOMMU
Message-ID: <20240124180150.blms3z7fqseioult@amd.com>
References: <20240117010644.1534332-1-seanjc@google.com>
 <20240122193605.7riyd7q5rs2i4xez@amd.com>
 <ZbFJOyGb21UX6qXn@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZbFJOyGb21UX6qXn@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|DS0PR12MB8270:EE_
X-MS-Office365-Filtering-Correlation-Id: d3ae71ae-a188-41c9-bf2f-08dc1d0696b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d20HQg9LAUpVwUfrty8RU0DMXR+C1pLbN05QqJ+1flCAl9dy/0pWxy5B5mHNewwa4p9XA6cFMLmrsxNeVomCtz8MlOEqBVOkmGVy/7Vx4MPUohokv0KULdNYnI/wxB3CWIQkbKczwFRN5hroPWol5aDj+FTpIADh3+Z/dnxpB+h9lgLTl2w8adyjW3zdr0uSpoQ9ASx3RyQA3VOcvJNLxzh5mg61EElTrAZyvCiijiCfkPqcxn5iBj2JEXlcykfHlnBfg2IQIra1kOB6bh9jsqLS8dPE/dZaK0SMykoVpn5pl2wqB5YweLZLfthYNNjQJbvkM5R1jz0S3c7Sm2dspoYJlCrv1fRPNk+y4MZkJMZ347jYN8K+8aUJMlyHaxwmA5qbhOBP6p+mRHZKBbDP6ZXLJHrTG907DZ57f67vSo6ULb4SisINj2d4id2rRGh/w26yp65hM4pyJGKk8e04QvC7jgNlW1M6kY8YeOpS0q3FFpqEMslz7AaxwgGTVjHbuCKNF4wcsBhIu6h/6x12cEqJT8ijw668lKkvYdkKc20ZOUho2HXXFwRPy3jb2MKak97Fha56X+bR3yg58W1DSr8J29BwGyviBmSrtt2A4ladPMHZN/PrSCHsrAe3t3Tb4mXnkzEzRTXVBk40iNf/4Ll9rD1OOQAqBEn+9uylBDBNUJ28okul+T1IUzH5Bk6JM7cHOOmKSaQPxzI8RufnjGDAJPBM9mXrz9JxAHp6c9sBSvTvMWvelpQq+qVaqnFC0IwkOckMx1TBT7KD64dfYU0duvun+22C6/PG0qpbleSDJZ1xlCpVJ74aLT6d4YVuxxTHHoA+z7JEi8wadVYzTw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(376002)(136003)(39860400002)(230922051799003)(82310400011)(186009)(64100799003)(1800799012)(451199024)(36840700001)(46966006)(40470700004)(86362001)(316002)(36860700001)(70586007)(54906003)(966005)(70206006)(6916009)(478600001)(82740400003)(81166007)(356005)(2616005)(6666004)(16526019)(1076003)(26005)(4326008)(8676002)(44832011)(83380400001)(426003)(336012)(8936002)(66574015)(40460700003)(40480700001)(36756003)(5660300002)(2906002)(47076005)(41300700001)(5930299018)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2024 18:02:11.4620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ae71ae-a188-41c9-bf2f-08dc1d0696b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8270

On Wed, Jan 24, 2024 at 09:30:35AM -0800, Sean Christopherson wrote:
> On Mon, Jan 22, 2024, Michael Roth wrote:
> > On Tue, Jan 16, 2024 at 05:06:44PM -0800, Sean Christopherson wrote:
> > > Tomorrow's PUCK topic is utilizing KVM's TDP MMU for IOMMU page tables.
> > > 
> > > FYI, I am currently without my normal internet (hooray tethering), and we're
> > > supposed to get a healthy dose of freezing rain tonight, i.e. I might lose power
> > > too.  I expect to be able to join even if that happens, but I apologize in
> > > advance if I end up being a no-show.
> > > 
> > > https://lore.kernel.org/all/20231202091211.13376-1-yan.y.zhao@intel.com
> > > 
> > > Time:     6am PDT
> > > Video:    https://meet.google.com/vdb-aeqo-knk
> > > Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656
> > > 
> > > Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
> > > Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link
> > > 
> > > Future Schedule:
> > > January 24th - Memtypes for non-coherent DMA
> > > January 31st - Available!
> > 
> > Hi Sean,
> > 
> > I'd like to propose the following topic for the next available slot:
> > 
> >   "Finalizing internal guest_memfd APIs needed for SNP (TDX?) upstreaming"
> > 
> > There's 2 existing interfaces, gmem_prepare, gmem_invalidate, that are
> > needed by the current SNP patches, and there's some additional background
> > about the design decisions here:
> > 
> >   https://lore.kernel.org/kvm/20231016115028.996656-1-michael.roth@amd.com/
> > 
> > There's also another gmem interface that you recently proposed for handling
> > setting up the initial launch image of SNP guests here that seems like it
> > would have a lot of potential overlap with how gmem_prepare is implemented:
> > 
> >   https://lore.kernel.org/lkml/ZZ67oJwzAsSvui5U@google.com/
> > 
> > I'd like to try to get some clarity on what these should look like in order
> > to be considered acceptable for upstreaming of SNP, and potentially any
> > considerations that need to be taken into account for other users like
> > TDX/pKVM/etc.
> 
> I penciled this in for the 31st, let me know if that works for you.

That would be perfect. Thanks!

-Mike

