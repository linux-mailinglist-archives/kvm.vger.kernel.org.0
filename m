Return-Path: <kvm+bounces-12430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE8DE88619B
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 21:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 751C8284F6C
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 20:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD76C134CCC;
	Thu, 21 Mar 2024 20:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GsJ3XSax"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2057.outbound.protection.outlook.com [40.107.96.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1072613442F
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 20:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711052805; cv=fail; b=e8r8SfZisDPdxjE5os9nGytNQZDEET43pYIE9xZHLKlJx6nlYkufskAiNojhclcKqlVOSLWFrVzNtlx5AjGvtZCfZcuzRiruUf5/lw+y8VBYGJ5n1BJX/yupPogOKx4oDR9lo6ibemGL6NQgEZ2fXFE4bwuplXW6Ufzq/qIrojA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711052805; c=relaxed/simple;
	bh=jqXAXG5fntzNLWHixrCvQ9wCld5uxq0O+t6wWg1FjiE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjm2HGrF9PmsmQ5teuyDwWiLsZmdgQkeRV97g+v79IvtbBFNF4A6RLjCRRiq+4IJ4u5pQSdsNnJJlj+M4DjRItd70pg6chCPRWAkdHly2zhCVsPl++W2QYMEBvhJNjCPnhsTeaEJKO00RDI0zfZMf1ez4y7fLxJtvRgk6m/6urg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GsJ3XSax; arc=fail smtp.client-ip=40.107.96.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSEc60a2wSEZjPgoQMZzo5It8u5+gX96PI5a1BrmqTi9zbAG9zfAt5BA+aR4LolrwgnAWbk2KwQjmGvyqyvf2W50n2+mB/d/TLvCU0S38KJzYLMjwPhjD3hWhx7CILCznzsZnuo8AOo+5srfnTZSZKfRq4+kjjilZz31rO5/E49Rflgt5CFNT1pofg7+KqwYt25NSpHAYbV6EpcIQ+1T53fzWMY2xyNgCYcqShqq+ylpWr19jkVlVSwUT/vJPa1p8OqOJXdfJLPngg6CYU1EebapDghS+4+vKaMBVFvUZBNOIJcNpSth+/TfBCwzS+IP/lWBFHklUP/HACuPgsDSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/Rqk07KNoqw0cqixffWZBlIRt0nRcrCu0I3UuzlLo8=;
 b=FIc5Qyd7mTtGuvslZTAG2XDxhW783IKznW/IV5NokKaJ6ELKQQ3lsV4eRyUdIb2erA6rqKQ71BrsFXBBdi2mXoEnv4EKaWlxPa8VOb2VftcvmmCqibz7StIdgGxbbij7d0mF/991z85PTsd7Qm/63Z2i6JHuQJqwDkdiwAy1Cy0NAGMJy+2MDi5ID/UAsSFinLAFxzM84PWtfnB8EtLnGlsO+GDH08/c9ajLocLtoRSVnrthfRiZWyLGJxH17MGpF3Go223EglCrRNixvsvDD53RGa6feRWNjg1LXD0WeMosBFEA5TMcGbTU/Zjju3vKJOc2CMWJDLVSw8u24eBcAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/Rqk07KNoqw0cqixffWZBlIRt0nRcrCu0I3UuzlLo8=;
 b=GsJ3XSaxAQm5/TtZ5YT68GFoQmRw/nDuOFwaA3uNEYASZvwNEc4J5hIPqAhEAOwvIt+Y8Z3gNQSyoYlBBMc1riZbk4uJYTustPRbf3nwxKKq9fSTdMKUCXm30jp1UpwcumKkw52btHHijR0cg/PW7Z78df1Dp/CYmPyMCuBkKbk=
Received: from DM6PR10CA0013.namprd10.prod.outlook.com (2603:10b6:5:60::26) by
 CY8PR12MB7339.namprd12.prod.outlook.com (2603:10b6:930:51::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.27; Thu, 21 Mar 2024 20:26:40 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:60:cafe::1e) by DM6PR10CA0013.outlook.office365.com
 (2603:10b6:5:60::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Thu, 21 Mar 2024 20:26:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Thu, 21 Mar 2024 20:26:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 21 Mar
 2024 15:26:38 -0500
Date: Thu, 21 Mar 2024 15:24:03 -0500
From: Michael Roth <michael.roth@amd.com>
To: David Hildenbrand <david@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Daniel
 =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 11/49] physmem: Introduce
 ram_block_discard_guest_memfd_range()
Message-ID: <20240321202403.doucffgy33qywjox@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-12-michael.roth@amd.com>
 <750e7d5c-cc8b-4794-a7ef-b104c28729fa@redhat.com>
 <20240320173802.bygfnr3ppltkoiq4@amd.com>
 <48cafaf1-83df-40f3-905a-472cb5f9256e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48cafaf1-83df-40f3-905a-472cb5f9256e@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|CY8PR12MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: f27b2d94-6442-4b2c-3c39-08dc49e5373a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9R4k6dt/YmbTL4plZfQ4Yozyyj6uVs2TTMo5Ncqn67yXpGzY62eujykTLxRqFwwF/BAs72YRT4FrioC7tRkXV/7v9iOXOeMeURMW7ckYBPNAdJkJ+lneqXAZ7paVnsbV1twTxK/FH8SvVvIUN4KlzSjtPawoexXOzJfUxbArtKwgjTObMfIa5Yt52M1/JoCucK4A/CArJOm3b4DXn/Xd0UL9UdpkzMbaM59iVD+7UCmoJM0QWdY+ewHRhzzUxLr8mPUMwBsCVJBiUL1pHvPbjUEXakZ23O+/abn61xExt2nsPydClbcPRnNMnqME+HF3AjC1DQhlhR+QkT8FXBZmxjnC5AQjgDymiv93MjtTjfn72sj2gSXLByfsXOoeiURLTyc7YEzNd3tAlSK/Dd8Ecfiana8h92/dPe0QjjKFgXSfJ8vpXdNcbvJ913Q4LO+elQjVjuF26yhOqcZRRpfAiYhGV1QA1MaqqoRHCgbx7mOz03P/Ilw3MSfv2hgVzH96WKEkDB/qy8ARdp34Ou38Dwb/7ksH8w+EJ2TQapH/9FbXxbxqWh/8sP2YrAXGzC/oFDFhsmxD9rUplj2FhlvOGuQVavPNP4b4xWsr5e0eLwwscGExy5GSWpW9jXgFTZVjU/AEwcFToSOLi4ny6FyVOL+rKYrgk3Ai4hRPPLJrXcsrSDxnrOddclaxQg3Og/Mi0beYpJYHPjg0SW1JsceGgm4HFhs0M4UrDOY1II/qMcQVfkEZIQ9+Hosizc13ovpO
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 20:26:39.9857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f27b2d94-6442-4b2c-3c39-08dc49e5373a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7339

On Wed, Mar 20, 2024 at 09:04:52PM +0100, David Hildenbrand wrote:
> On 20.03.24 18:38, Michael Roth wrote:
> > On Wed, Mar 20, 2024 at 10:37:14AM +0100, David Hildenbrand wrote:
> > > On 20.03.24 09:39, Michael Roth wrote:
> > > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > 
> > > > When memory page is converted from private to shared, the original
> > > > private memory is back'ed by guest_memfd. Introduce
> > > > ram_block_discard_guest_memfd_range() for discarding memory in
> > > > guest_memfd.
> > > > 
> > > > Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > 
> > > "Co-developed-by"
> > > 
> > > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > 
> > > Your SOB should go here.
> > > 
> > > > ---
> > > > Changes in v5:
> > > > - Collect Reviewed-by from David;
> > > > 
> > > > Changes in in v4:
> > > > - Drop ram_block_convert_range() and open code its implementation in the
> > > >     next Patch.
> > > > 
> > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > 
> > > I only received 3 patches from this series, and now I am confused: changelog
> > > talks about v5 and this is "PATCH v3"
> > > 
> > > Please make sure to send at least the cover letter along (I might not need
> > > the other 46 patches :D ).
> > 
> > Sorry for the confusion, you got auto-Cc'd by git, which is good, but
> > not sure there's a good way to make sure everyone gets a copy of the
> > cover letter. I could see how it would help useful to potential
> > reviewers though. I'll try to come up with a script for it and take that
> > approach in the future.
> 
> A script shared with me in the past to achieve that in most cases:
> 
> $ cat cc-cmd.sh
> #!/bin/bash
> 
> if [[ $1 == *gitsendemail.msg* || $1 == *cover-letter* ]]; then
>         grep ': .* <.*@.*>' -h *.patch | sed 's/^.*: //' | sort | uniq
> fi
> 
> 
> And attach to "git send-email ... *.patch": --cc-cmd=./cc-cmd.sh

That should do the trick nicely. Thanks!

-Mike

> 
> -- 
> Cheers,
> 
> David / dhildenb
> 

