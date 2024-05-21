Return-Path: <kvm+bounces-17840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F7E78CB16F
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 17:34:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8DB5B215E7
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 15:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D56144D02;
	Tue, 21 May 2024 15:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ijLuBhtF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B7F1442F4;
	Tue, 21 May 2024 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716305675; cv=fail; b=R6YY2FsZZKnvwnEF6SD/vgQj67IZ4VGuWY0rMf9X2s5dLthJ5LXcTQYDnmTTNtpxH8gJANthKJ0a6mS3i1vvbzEy5ozCgSyfZ66L0FkYXv+xT4Rg2b/wZQSe3aXngta/36k1kP7UAy2/HVqcVuQOqXX0XX5HxNxHdYoWhfogGY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716305675; c=relaxed/simple;
	bh=cSvJqtTJd/vbXnTt0uhtY6cct85X4SXZxoJF3LLvo1g=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2qs54eLySLcesfmmN5JTjEzlg16godkGPH1qs0l3VQ1K9iIjlyn74jji9JDqWN4OEHZkOWQTTxK15l2IKka9Tk3K3k20CXEmzlT+v1bLCryrXDzoy1HFuvUFHFvTt/AGWqCJKYUr3CuCRnhw7R0rWAsl/A5u4SUb/TUskGUits=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ijLuBhtF; arc=fail smtp.client-ip=40.107.220.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIlfRdsv8DJg+yJTU6h/cvWB5p9mcQZNz2XHtbyp4QOtBrRXFZoMLooikWSMpbyVrFe94bIyb4BFALM1nwDGgPVnc24zqhF3j2YYQmxDGewqHP/SOCjJQjL60heuK5bAApcHiQh07Wy03ex5dWxTBXHE9PAtJepijNHREvNcSnrlreBOxcNmqJE5vG3ntaCkR0uNjVHOjVk3xzz+7FTau84e4Wopj1wdUr0GA1ovemr5uXxiMVxH0S8QqnTr/obdnrgCnvilAWO6yAFPz7668g9+WDKBb91VlKJUbyVnDYB5TfMdOLssOr64LbY6qkxFfBL7OA1YMNJjQOUyEBA2Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kY6gwnd2lZ9lmZz569J+PCWRjYJvAgfqiUSqzO/d4Dg=;
 b=hZthHwVLUfuep3prSUNSmyieXVkEvBYEZMNj2AdhCx5USGGowDxSX0PYqIYevKCDhyw6Q9FFSG4bXF7QrbC/XYA16e51In3kyeZFxQKgdXyJVbKqeWMzYIXzJe1KrN9Rh6IfX8kyd9gfBtNHbKZjX3lfHy9yWl6hn1rvfGMtNoSlP5EMDJn9uHKoev/W4K4t4GAhDyPuQEApLsvUAtR6x/8m3LsmPyOifP7114PzZmbYmSwdqaNybjS6EHtTodIe0DPXooD4k2Iq4QIytTb69aU+7aj3yPV8pK47hTduWP2NUWy2jzwi4OCsv9md/t7XmW4VN7DhYn4wZjYw8Kzpmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kY6gwnd2lZ9lmZz569J+PCWRjYJvAgfqiUSqzO/d4Dg=;
 b=ijLuBhtFkszn51h7nQQbZ50nvUtoWjpppR/NvEar2AutVIYfzlhREsRfCeWTuLWUCku6KST/ugUbeIfCzNlJI3AOj7eHQFTNjDlJodmv+ur2XdJw2Bzh/B4mCv9oBAayTsVQCXNd0WA94xpbRMWlmZmzBaUWp4XHLhxSglgBNzI=
Received: from BL1PR13CA0252.namprd13.prod.outlook.com (2603:10b6:208:2ba::17)
 by PH7PR12MB6666.namprd12.prod.outlook.com (2603:10b6:510:1a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Tue, 21 May
 2024 15:34:30 +0000
Received: from BL6PEPF0001AB4C.namprd04.prod.outlook.com
 (2603:10b6:208:2ba:cafe::3a) by BL1PR13CA0252.outlook.office365.com
 (2603:10b6:208:2ba::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.17 via Frontend
 Transport; Tue, 21 May 2024 15:34:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4C.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Tue, 21 May 2024 15:34:30 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 21 May
 2024 10:34:29 -0500
Date: Tue, 21 May 2024 10:34:13 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Michael Roth <mdroth@utexas.edu>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: SEV: Fix guest memory leak when handling guest
 requests
Message-ID: <qgzgdh7fqynpvu6gh6kox5rnixswtu2ewl3hiutohpndmbdo6x@kfwegt625uqh>
References: <58492a1a-63bb-47d2-afef-164557d15261@redhat.com>
 <20240518150457.1033295-1-michael.roth@amd.com>
 <ZktbBRLXeOp9X6aH@google.com>
 <iqzde53xfkcpqpjvrpyetklutgqpepy3pzykwpdwyjdo7rth3m@taolptudb62c>
 <ZkvddEe3lnAlYQbQ@google.com>
 <20240521020049.tm3pa2jdi2pg4agh@amd.com>
 <ZkyrAETobNEjI4Tr@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkyrAETobNEjI4Tr@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4C:EE_|PH7PR12MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: 48a7f89d-ee2f-4d0d-57b3-08dc79ab81da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|1800799015|82310400017|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2nadsuVj+oLkDMzeF9OSlB1+c5kFqj6tNqr9M1gCJn0c3gPixWvZY5OFupEQ?=
 =?us-ascii?Q?vIMRlfK6nN6FZpstZTsKdAjRFH2OmB4R9f7QqZDo3SUDeJ27qzNXIoHlwpVZ?=
 =?us-ascii?Q?LJueJa9BJ4pmDIx8eRXhNYfUNzh+biQq9bU+ZowpKH92BnA1nuYXFZaIjQ64?=
 =?us-ascii?Q?6MNjXnG9NihukD1UvIU1XduUhfbFyhJjeaid4KrtQI4Ub/kcnin89tXG1V7P?=
 =?us-ascii?Q?VM9b1tJZi4fTqPvgZOJ2vM8lyKCnCIRldBqP/1IA/FhGPAWCfg2ABJ0lqGzr?=
 =?us-ascii?Q?1n8uVMQ+uRhCvPfAZxxWk9jZjqsGazv3QkNbEH7mJZ9Wv4HE8Wj1KoeZHxWI?=
 =?us-ascii?Q?8MZtUvGkhXYeHCVzCKhpmWTAEBqlXGKXvXK44EZnsOSnerk4Rzds42sHW4iL?=
 =?us-ascii?Q?IMRy0gMLc1KScJ9s+aDi5iT55zCmJndZZyP32khIQsGimI70jsXhP1YhABqn?=
 =?us-ascii?Q?B73P13sUGbVU1S7KOr8dkWmwYt39XyCc69KN+qd9oo1LdA8uE/405o3BsVFp?=
 =?us-ascii?Q?0VVCSdA20To5Zz/5ZpxsDnvS4cYVv1aMTsVYemQMYn9e5PSVjRFCFkT5mBwT?=
 =?us-ascii?Q?MQpmxCOVYOfZwFHH+uW8MWCNdxko8MQZVLOyA26WXoK06q2+wDgcn7Ab9452?=
 =?us-ascii?Q?VK5RI63w3Si4HYmYcjkrBUMVeNljVR6swi/y4a5gk0E1/8XMgG/IywnLzIpc?=
 =?us-ascii?Q?RrBSqXJCX4E7glb5O0UbdQ4wXbBCA/RR0Z+5ESQZSxTHxj095d9gMa6wGdmZ?=
 =?us-ascii?Q?ij+7G5EKOG0rPJgJCbN6InLLpffq3RbDIcQYGPXtI3ViP+RN2M1tPW+cLdSF?=
 =?us-ascii?Q?X+umavKsDEBnWjH4sn/SGXr/4+e3AM54QQL7JWlnKONndRQfhp8pID0Kis7a?=
 =?us-ascii?Q?J34n7q/wTKPQAQrUtU7E5vBRG8e9MJN7SuEuSAiK0kkuNUCTu1Hj9+8KSy8o?=
 =?us-ascii?Q?vJmlyIosSr6eahfzR9CdMqNrY+RtiElpHxh/iEXcnU4to/nA8UGByRubEVRZ?=
 =?us-ascii?Q?09qt3Rns8rF65kaoB7Tq3Nz6E1QmT7d4SyYEhTSHNHK1/4HO0Q6UuVAori5Z?=
 =?us-ascii?Q?ug9uJi3kFtlh5EucC3rVNJA04ZRL7+LkzTXi5EME55pvAUyCObCaNFQ1WkQZ?=
 =?us-ascii?Q?Cp7asYTF2kxsUGhREIwkILHfwDyP6D1RAIxbJyze/Zyl3bSiQJQflhpf6Srx?=
 =?us-ascii?Q?MHs2UG0I1eJgOyA+NaWoZH4gW6U8DQViWgPTlQsBdsOFoe+ELMtSI7UFCuM2?=
 =?us-ascii?Q?JlaboGnZE7Q5NuG0Sm2QjdsROOmjNsPHDBQ25sJqqjN+c+0SHIQc6AhG6ao1?=
 =?us-ascii?Q?osGTj8MI1dAwrjcq+oIamoxBF2UO0qqfBDhuzU5J+FWX/Swg19ugOZItfup7?=
 =?us-ascii?Q?QDYBxjJRnP75LnPTmwdmf3Vf4LZn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(82310400017)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 15:34:30.4394
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a7f89d-ee2f-4d0d-57b3-08dc79ab81da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6666

On Tue, May 21, 2024 at 07:09:04AM -0700, Sean Christopherson wrote:
> On Mon, May 20, 2024, Michael Roth wrote:
> > On Mon, May 20, 2024 at 04:32:04PM -0700, Sean Christopherson wrote:
> > > On Mon, May 20, 2024, Michael Roth wrote:
> > > > But there is a possibility that the guest will attempt access the response
> > > > PFN before/during that reporting and spin on an #NPF instead though. So
> > > > maybe the safer more repeatable approach is to handle the error directly
> > > > from KVM and propagate it to userspace.
> > > 
> > > I was thinking more along the lines of KVM marking the VM as dead/bugged.  
> > 
> > In practice userspace will get an unhandled exit and kill the vcpu/guest,
> > but we could additionally flag the guest as dead.
> 
> Honest question, does it make sense from KVM to make the VM unusable?  E.g. is
> it feasible for userspace to keep running the VM?  Does the page that's in a bad
> state present any danger to the host?

If the reclaim fails (which it shouldn't), then KVM has a unique situation
where a non-gmem guest page is in a state. In theory, if the guest/userspace
could somehow induce a reclaim failure, then can they potentially trick the
host into trying to access that same page as a shared page and induce a
host RMP #PF.

So it does seem like a good idea to force the guest to stop executing. Then
once the guest is fully destroyed the bad page will stay leaked so it
won't affect subsequent activities.

> 
> > Is there a existing mechanism for this?
> 
> kvm_vm_dead()

Nice, that would do the trick. I'll modify the logic to also call that
after a reclaim failure.

Thanks,

Mike

