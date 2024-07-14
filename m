Return-Path: <kvm+bounces-21608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F4E930897
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2024 07:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96E59281B3C
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2024 05:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72121172C;
	Sun, 14 Jul 2024 05:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5uvYd/Ck"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F981F51B;
	Sun, 14 Jul 2024 05:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720935192; cv=fail; b=jfkuHoO4frkFxLYJl9Bbamgn/vudAd2S/bfLvC7JZ5JhZ4jL/m37ZVtnd3iOJZnRJPYj7OMX2NCaGTQaTdHIKDYJYlKbFFNrPogUb1AmYyBFMc+gUPo+xipIcunf8sJKIyFAaPVfzL7Hzy5BUkYH2A3fxCRAQ4IVhDBMPARynkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720935192; c=relaxed/simple;
	bh=OSG7zC0aWpNI7S/BUhF8htxi3uhoJb0a1PS2niMbSGQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlLe+JClTNW16iaOEwpLOZi3US/ilLyISfa2sIWSIOTylts2T1qlfdpsCKiLsOMoASclmPAJDmoDYX2bcHtSAMjCxZhHlbI/MGXqlRGQ8V2iiRbMoEsksFg9Y2JQ1um77fiPeMIJ+H8NbsA5FvH4F8FN8MAqZRl2aqqCs/0SVuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5uvYd/Ck; arc=fail smtp.client-ip=40.107.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KtyadiD4RmdX9Lpe1CASDPKIq/D+Cm5R1piqrdmKJvHt6QiwlalLdwb7F0eBV69N4pgpAg+FnHjshnxjn3bMBr5VC33X+LHK47wfkmL45Y/NacT2M27Va5SuRlQsChzPTwKBj/gtNkMpYuxrTW5rgX2lxtT9/zhXwMaE8BZHyMnN0a8ck7S+/S1ugghAz9fRFpwklcvPWE3VA7ikV8mPp0qiYBDH2FxU93DTStyl66wC9tQY73wFawxH4mxHyYpdXA2De6eLVasg5ICgwUVve7T4ND+4qVDAKLExwncaCK0yWrbD7SCJRaWJ91TnORZ5pnzxES5DQlhyriIWwRhUWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfoRZMQFyqKFwCsYXTwrY6QAA+r2ecA2RWu6azHrScc=;
 b=p7NanIuctjoxu0pIjJfOX2yywIWeAYj2PpFgkqcB7KUHAPRelLXAUADJKxOMaIgeSSfHvncr5MyZe9hCYMzVlfloCJiBSpw42Ulbu9UOutjLoWwbpQVzj4HmOAgcbzHGYwJlaXtd54GO0/Cmc2t3lGZkc+dETPcit4OrLnZZq887Z6wJrQ3zMXOVvynW//bTyacT4XyXZhpQ/lcwD9UXos1/ghegeiziLm8YgkrKPo8NTc8iI7lyMdmNxM5RJ9wkypiX6mTQEFYyrb+Si07DyM1Yf7fgPljAUX67aPGhT/Y8ZoUOKdxVCndwwlf0uTAvtU7DLOsRUtKwqFjnmpTqPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfoRZMQFyqKFwCsYXTwrY6QAA+r2ecA2RWu6azHrScc=;
 b=5uvYd/CkcAJDOOI9Umimzj3ZgCaFFAX2sDGcL4pqe0ISkbWd7EKIWWJTljsEwRu+b0ui+8KPuj++fj9GBLuLI2Owxt0Vdoq4w1roAcNHd9/xh+xvZPYEZCPSNzzXPjFcDSEJCn2LapGEI6h+Z+yCTurrPUI3UgkPi+25wdeRuQs=
Received: from PH1PEPF000132ED.NAMP220.PROD.OUTLOOK.COM (2603:10b6:518:1::32)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.24; Sun, 14 Jul
 2024 05:33:06 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2a01:111:f403:c91d::) by PH1PEPF000132ED.outlook.office365.com
 (2603:1036:903:47::3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Sun, 14 Jul 2024 05:33:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.17 via Frontend Transport; Sun, 14 Jul 2024 05:33:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 14 Jul
 2024 00:33:04 -0500
Date: Sun, 14 Jul 2024 00:32:49 -0500
From: Michael Roth <michael.roth@amd.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Message-ID: <n2nmszmuok75wzylgcqy2dz4lbrvfavewuxas56angjrkp3sl3@k4pj5k7uosfe>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-10-pbonzini@redhat.com>
 <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
 <CABgObfbhTYDcVWwB5G=aYpFhAW1FZ5i665VFbbGC0UC=4GgEqQ@mail.gmail.com>
 <97796c0b86db5d98e03c119032f5b173f0f5de14.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <97796c0b86db5d98e03c119032f5b173f0f5de14.camel@intel.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|DM6PR12MB4235:EE_
X-MS-Office365-Filtering-Correlation-Id: e139beab-3d2f-48ec-19d4-08dca3c67007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L/BQ63vs93U+R6m+U/y4gEJNv9V3QxuZi7ruAASuUqV9UakvT22b8v+IQldn?=
 =?us-ascii?Q?H9VubsU97CCdGyhqxL/aLlzyX++1TDcYWh9IKPTIeegS20kp/u3egizAHBz3?=
 =?us-ascii?Q?HTW/Nx1Y/rr1pNDaHPbN1jqrgELI1X8sIj14XDDjneaM2FW98J0GX+SJNQEo?=
 =?us-ascii?Q?5A2ywFg3YOTG0pTtJy7SGrR5LzvTk/iPuW+cMQJRkvS7P5cx0jSSBywED2h7?=
 =?us-ascii?Q?PAKDJIQzg6GmZDNbkwe5BewENETGcyDwxKILKpuzpLYMUrUfLiG4ivJaqmie?=
 =?us-ascii?Q?pjzQXcU75F7LrvFYYAaoS67zaUYb2hFT7nZQOZUE6CMmJ3txdctftsFsGXby?=
 =?us-ascii?Q?6I77tizPeAXyxCXCL3vKFT1HZesy0Lt1sf2otKv70UMxfyPjzElFb02vg7oI?=
 =?us-ascii?Q?3TIyAxH2b1fqhnxs5gP/c9OtjicXraYtfR7Ck61DF0dwF/pGMcx48xvwWrMz?=
 =?us-ascii?Q?6R1zSSIbA7SkLuwcx6ervtZ9+karVEZWlfeMx8mme0wRBpQHaIKsbWP/0Mrh?=
 =?us-ascii?Q?bngGiZ9zLBhRBJY4ZiDKfn4CBgwN+VuKjysA4Q3h1302CseB3sLvj5VtOIen?=
 =?us-ascii?Q?XJErvY9P3BV4OCaY61hYLDEqZo9X4CxS2y9DcpVwTEp5TB979f70NO17Ay7L?=
 =?us-ascii?Q?r0bXXu+b+VMpj5jf2Q4tod3eLUpEvGrLa5JAoKahJkAZpJ+s1JDslYTFzKjt?=
 =?us-ascii?Q?CxiA8UpwWth8g7uRRwbNABf6blVGbq+4bRxwSQ39y2K3Y7MQVTEx0e1rHDkJ?=
 =?us-ascii?Q?sJmbRIzMxJRzi7qSoYsBRXGP9u62btmjUKOSsfZhw+HXXpTUz/orFcAiNOEA?=
 =?us-ascii?Q?4hkzdWUt8W8tjwI/K93Td+OBpiongU/TG5nn2Bi0bNSmQ6JXp1ZYwUp744g9?=
 =?us-ascii?Q?gs0EzReNeCrPTuM+vx2zeG15QSPiGZmDtmVUhMhyz8JkZ1KGaYhJWBmlWJhI?=
 =?us-ascii?Q?WO2mFZ8l2boGfgW2ugXjZsfn98TwMz82TRc1tZM7IFVzJY2apWkcMvPs51nv?=
 =?us-ascii?Q?jiREzVw585+ZFwucE2lFEDYCQZo7ox9pPfJaSh8HapgRA+VcytY6SUhvttKv?=
 =?us-ascii?Q?3el7ZE/OP2eDOmqid9UhKRpx09Dt/nQNkEP1d/2teKpdWJU6FW4d9HJVhC9X?=
 =?us-ascii?Q?GMDSt+BJ5mwvUQz+H/2ZykJW7ZSlRlb3puZnuhuyCskzniDFWSA0ACJ/F4p4?=
 =?us-ascii?Q?w73x9zJYO/MZBHfMsbPRpapqX7xxASaiRNCEGI7ITWAWgrJnkI0WWfL6+FJO?=
 =?us-ascii?Q?WHybrtJ+1+/+XEzkuVo+BvQDoemrBEiS/Ke9wAqNL5O2Q/FD7lYVhButNfKH?=
 =?us-ascii?Q?hpSZLjJ22CpoSvfqmrDQjiEnKIAm6VRQUqx0LQ4TzzhPt70s0KbpmuHPJgqR?=
 =?us-ascii?Q?bMD8RFrH1GVAZwtCSrqELq3u3/KpPAWOfd36Ft6fmsz3GwnXpw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2024 05:33:05.6258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e139beab-3d2f-48ec-19d4-08dca3c67007
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235

On Sat, Jul 13, 2024 at 08:25:42PM +0000, Edgecombe, Rick P wrote:
> On Sat, 2024-07-13 at 12:10 +0200, Paolo Bonzini wrote:
> > > 
> > > This patch breaks our rebased TDX development tree. First
> > > kvm_gmem_prepare_folio() is called during the KVM_PRE_FAULT_MEMORY
> > > operation,
> > > then next kvm_gmem_populate() is called during the KVM_TDX_INIT_MEM_REGION
> > > ioctl
> > > to actually populate the memory, which hits the new -EEXIST error path.
> > 
> > It's not a problem to only keep patches 1-8 for 6.11, and move the
> > rest to 6.12 (except for the bit that returns -EEXIST in sev.c).
> > 
> > Could you push a branch for me to take a look?
> 
> Sure, here it is.
> 
> KVM:
> https://github.com/rpedgeco/linux/tree/tdx_kvm_dev-2024-07-12-mark_uptodate_issue
> Matching QEMU:
> https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu-wip-2024.06.19-v9.0.0
> 
> It is not fully based on kvm-coco-queue because it has the latest v2 of the
> zapping quirk swapped in.
> 
> >  I've never liked that
> > you have to do the explicit prefault before the VM setup is finished;
> > it's a TDX-specific detail that is transpiring into the API.
> 
> Well, it's not too late to change direction again. I remember you and Sean were
> not fully of one mind on the tradeoffs.
> 
> I guess this series is trying to help userspace not mess up the order of things
> for SEV, where as TDX's design was to let userspace hold the pieces from the
> beginning. As in, needing to match up the KVM_PRE_FAULT_MEMORY and
> KVM_TDX_INIT_MEM_REGION calls, mysteriously return errors in later IOCTLs if
> something was missed, etc.

If SNP were to try to call KVM_PRE_FAULT_MEMORY before SNP_LAUNCH_UPDATE
(rough equivalent to KVM_TDX_INIT_MEM_REGION), I think the same issue
would arise, and in that case the uptodate flag you prototyped would
wouldn't be enough to address it because SNP_LAUNCH_UPDATE would end up
failing because the gmem_prepare hook previously triggered by
KVM_PRE_FAULT_MEMORY would have put the corresponding RMP entries into
an unexpected state (guest-owned/private).

So for SNP, KVM_PRE_FAULT_MEMORY/SNP_LAUNCH_UPDATE are mutually
exclusive on what GPA ranges they can prep before finalizing launch state.

*After* finalizing launch state however, KVM_PRE_FAULT_MEMORY can be
called for whatever range it likes. If gmem_prepare/gmem_populate was
already called for a GPA, the uptodate flag will be set and KVM only
needs to deal with the mapping.

So I wonder if it would be possible to enforce that KVM_PRE_FAULT_MEMORY
only be used after finalizing the VM in the CoCo case?

I realize that is awkward for TDX, where the KVM_PRE_FAULT_MEMORY is
required to create the sEPT mapping before encrypting, but maybe it
would be possible for TDX to just do that implicitly within
KVM_TDX_INIT_MEM_REGION?

That would free up KVM_PRE_FAULT_MEMORY to be called on any range
post-finalization, and all the edge cases prior to finalization could be
avoided if we have some way to enforce that finalization has already
been done.

One thing I'm not sure of is if KVM_TDX_INIT_MEM_REGION for a 4K page could
maybe lead to a 2M sEPT mapping that overlaps with a GPA range passed to
KVM_PRE_FAULT_MEMORY, which I think could lead to unexpected 'left' return
values unless we can make sure to only map exactly the GPA ranges populated
by KVM_TDX_INIT_MEM_REGION and nothing more.

-Mike

> 
> Still, I might lean towards staying the course just because we have gone down
> this path for a while and we don't currently have any fundamental issues.
> Probably we *really* need to get the next TDX MMU stuff posted so we can start
> to add a bit more certainty to that statement.
> 
> > 
> > > Given we are not actually populating during KVM_PRE_FAULT_MEMORY and try to
> > > avoid booting a TD until we've done so, maybe setting folio_mark_uptodate()
> > > in
> > > kvm_gmem_prepare_folio() is not appropriate in that case? But it may not be
> > > easy
> > > to separate.
> > 
> > It would be easy (just return a boolean value from
> > kvm_arch_gmem_prepare() to skip folio_mark_uptodate() before the VM is
> > ready, and implement it for TDX) but it's ugly. You're also clearing
> > the memory unnecessarily before overwriting it.
> 
> Hmm, right. Since kvm_gmem_populate() does folio_mark_uptodate() again despite
> testing for it earlier, we can skip folio_mark_uptodate() in
> kvm_gmem_prepare_folio() for TDX during the pre-finalization stage and it will
> get marked there.
> 
> I put a little POC of this suggestion at the end of the branch. Just revert it
> to reproduce the issue.
> 
> I think in the context of the work to launch a TD, extra clearing of pages is
> not too bad. I'm more bothered by how it highlights the general pitfalls of
> TDX's special clever behavior for KVM_PRE_FAULT_MEMORY before TD initialization.
> 
> If/when we want to skip it, I wonder if we could move the clearing into the
> gmem_prepare callbacks.

