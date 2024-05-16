Return-Path: <kvm+bounces-17512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C198C708B
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 05:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A610B22A7B
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897454A3D;
	Thu, 16 May 2024 03:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aXonmDoY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04514436;
	Thu, 16 May 2024 03:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715829137; cv=fail; b=PWG2lw6bhoczqgVUp0g5WVR3x5aWzUMx0r58CYLHLb6OTPQJ489u7JHKRQMnuDVnnnCY0tDS36pQvM7GdyWJU3P2rIyMuFLt4Q8uI8oazmAhDEsK+D79OgBunJXuMqLfsCwVHpog+mVxiVPQky3p2WAEMmW8C2wJOSZtIpRnG90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715829137; c=relaxed/simple;
	bh=jx5I7qyoVpqtVDh5lsmYekGySPjsv54gJ/vn2Gqx+JQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfJPlD+Oo3yFu5PiftTuRUJtj+XGG9CFtLeZzhyZhBSxLnQPEW0KQ+Gk6x34rZSadSuvhO0sdxUV60ns3R6n6Wr2g/GBzsbKMDCXKEzUZzTRinjWeHmX9QQY/XrgHtQzsySE0vOP6iYTG68+JV7Bzc4I8BlqeJStbc1iTFTzdPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aXonmDoY; arc=fail smtp.client-ip=40.107.223.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ct0MIDcQq/i4roPvjSRyvKG+b7fdol0lVOQycKRZQsJYlqYDfqu+Nd1zB1tWAWA63TCth9wsd1t8aAS3XODbUL2d8o5YNYl9NZoKeLQRwGvxj/F0HZeaKSMBZCgM470SdaNUBPwIKP0LA6Ec63vJL99txwxi7bbGwB6BA38u+d62ygU24vHpX215rk9CIArSbOA5w/agdMftLW2M1b0XvlgEg+/eY1ZoyoBHZG9w0ws7ZfKKndNhpQ+B+gKrJLHS+4b9EcEA7UiBbQdLoilLAhlOb7LLPKFROJRfZIemi1KIoSrMkFT8NfCaett+ROdtdLWfzBvdKO+jt+eYs4IcpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QMaYxMr01Yvv6VyEmOAe10kXBHIqaQYI5l0CNSypGc=;
 b=IE4Xij/lb+1q9JOjd+LoEigUZkU61ROdSGl9NWRZ4NgIASr85d98YZ80CU57dZdPRa9kTMXbcZkE/nOOpCg4mWiTKVJUBRTLIke6ZPy+29Qzz+nqXjuhZCaJxQbwD4mh1MYDQTWq3DR+GK2bvMN3zUyV6fwILEZs+oUZpPQaCKeNA9wF00l0lrMiXZLN3j2FzmM6QVYQ2yxSg8GEWdt24XyRpFFJ+OZlLwZQ+2KAnB+r3gm4E7n+DO6INZCT9iKqef1VGl33RmYGJOTflWajg6bhIxSzjmSY6x1mvSZSYLH8JRbNXe+vzbCP2DASiYCFNEU99Uk8d/EP+VWrgfgkQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QMaYxMr01Yvv6VyEmOAe10kXBHIqaQYI5l0CNSypGc=;
 b=aXonmDoYNue+4dhNcBpZoGKdWdhDwpksMWh85+i0QoCv5b/fgV5U6eT6P/BqAhSM8uMqxCOZl5C3nLE87MVu3lVnGY8CqBnXYBM2SXr6PbqVHu2m5xTCEeUWibppF4qE6/0XfrlJr0SsEtqLK6X5HH/MRxImAH3RyZpSNcKUQA4=
Received: from BN0PR07CA0026.namprd07.prod.outlook.com (2603:10b6:408:141::26)
 by MW6PR12MB8951.namprd12.prod.outlook.com (2603:10b6:303:244::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.25; Thu, 16 May
 2024 03:12:13 +0000
Received: from BN3PEPF0000B373.namprd21.prod.outlook.com
 (2603:10b6:408:141:cafe::be) by BN0PR07CA0026.outlook.office365.com
 (2603:10b6:408:141::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28 via Frontend
 Transport; Thu, 16 May 2024 03:12:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B373.mail.protection.outlook.com (10.167.243.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7587.0 via Frontend Transport; Thu, 16 May 2024 03:12:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 15 May
 2024 22:12:12 -0500
Date: Wed, 15 May 2024 22:11:55 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PULL 13/19] KVM: SEV: Implement gmem hook for invalidating
 private pages
Message-ID: <20240516031155.meola5hmlk24qv52@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
 <20240510211024.556136-14-michael.roth@amd.com>
 <ZkU3_y0UoPk5yAeK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkU3_y0UoPk5yAeK@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B373:EE_|MW6PR12MB8951:EE_
X-MS-Office365-Filtering-Correlation-Id: 938260ef-8461-4a8f-e5b3-08dc7555fb26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lH3kHORD0LG1gMA8m4skBNE3fG7Xjc3gu6jnYZ5T4YDMJoNr9fY2oFtvY+df?=
 =?us-ascii?Q?3i5bU/bMcgorVr8TR/1Q+e1XfwYDBCRpXu7AP1muuTeQcRqO00zmOzsSsKRA?=
 =?us-ascii?Q?AMVwyiSR5aYneRxI8G3sBwBd86X3XP09vThlRvzWYofR/DFSesW0iZKiEOPk?=
 =?us-ascii?Q?c0cR+xxfhqZQRCzICRIvv3zRACSr8yCazx2kHO4FAcLMBbW6AZPVi5z7yvqF?=
 =?us-ascii?Q?E9J4SRKhJ1OVMuwfJECxMBtpEnokGRBRDdvFyT1ohus6U6waJyCga8og/UpY?=
 =?us-ascii?Q?Ii6z7elqfhQJJwwRFIoHLddMNpVrp+ewQ83Zh5yd6sEP19/QPUfZQdfFaUwY?=
 =?us-ascii?Q?gYXLOpDVazhnceuBjfTp0VUjGwwXbIWxyEGznMK4E6hWRKwyfvJKKOj3CIc+?=
 =?us-ascii?Q?lBlnAz3EfNaQquauOc3LSp8bCqSTtTN464PAUS+3agVyRa6SQLMpuG4OlEYp?=
 =?us-ascii?Q?dmjF/XvbfOUgnxzxDJ03EPnjN3E+M1QUqxI5CkBE8AxJK59upfifcmGU6kps?=
 =?us-ascii?Q?lPO1iosZ0Rcd52U0GzJPsrzSeq4Tz2vrPLg61R3XhnMSkmtHOXDA2m7X/H4u?=
 =?us-ascii?Q?hzxKiZUfD1TH0gX95hgPA7wP8W9agVg4emy27KUx5T9yQcCbck20nKNvA2OL?=
 =?us-ascii?Q?UhYudCdB5oZRvRPcsLGqUASfe4nzN7Q+w2/LiBGhWwcUknQcgMbCfKgKqdV5?=
 =?us-ascii?Q?h5WvgHhBQFcZdgCeZaQrPn2HmYPWuzmLNtKT+1uk4TuN3x7mSNHzSjxLsuyn?=
 =?us-ascii?Q?eVX8K6wQPSSb33GAAld5PaybrZB0B/2gpA/FenWpk7FJauFWi4DnF8VYxzMh?=
 =?us-ascii?Q?oyvzMG+nmDXgxwTWoujSp9IkFZQZmQ2Mwd6HqOC8YXXNQkqxPHzDRjUcDQ1D?=
 =?us-ascii?Q?eDINiPxFIl6WiD0IAL0Ro2ZhJSGS2Z9w07T9eAGSNMPz4PSb9ycX+HIQeX2Q?=
 =?us-ascii?Q?9Vim4RhcnMKeLk2tHo0jFjF2sqPqtzBHNNYqmyd9DbM78OCf0JmUlA8ywakk?=
 =?us-ascii?Q?Ee5wtWesHlKDtbWRXHHqL4SjYMAaZWqEYyJevw8pQH364OLsxHlr2alOnky7?=
 =?us-ascii?Q?wGcomJ8i1jYASN2ZGJnBfR/WquZ72yLmtZs0ymKohA3CpM82PhUgJfb/O2MN?=
 =?us-ascii?Q?utDRhY8bMu2gHXM6swSRP6N1QovGXkwCxARPRvJHOme/ROyVY6mNmcHqWyKP?=
 =?us-ascii?Q?alvs51bdvCqsbr7TNFkHYXGZP5/WN0t6K6e2brIuO4PatjJev8LnH0WX291c?=
 =?us-ascii?Q?yscQ6ATyvj17b29n0IgmcYDlvfwcsPuTHmbtNbx3tggCVOpsDZANkAu3d8az?=
 =?us-ascii?Q?unIxjF41aYa7EZNX35v5NHpRUez2+Fpevg6tEa4LNw3fj5IEFVpw+rqlIpwb?=
 =?us-ascii?Q?4ZkfflwHiqDeUkWh0o22ZXikgW0N?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 03:12:12.5599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 938260ef-8461-4a8f-e5b3-08dc7555fb26
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B373.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8951

On Wed, May 15, 2024 at 03:32:31PM -0700, Sean Christopherson wrote:
> On Fri, May 10, 2024, Michael Roth wrote:
> > Implement a platform hook to do the work of restoring the direct map
> > entries of gmem-managed pages and transitioning the corresponding RMP
> > table entries back to the default shared/hypervisor-owned state.
> 
> ...
> 
> > +void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
> > +{
> > +	kvm_pfn_t pfn;
> > +
> > +	pr_debug("%s: PFN start 0x%llx PFN end 0x%llx\n", __func__, start, end);
> > +
> > +	for (pfn = start; pfn < end;) {
> > +		bool use_2m_update = false;
> > +		int rc, rmp_level;
> > +		bool assigned;
> > +
> > +		rc = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> > +		if (WARN_ONCE(rc, "SEV: Failed to retrieve RMP entry for PFN 0x%llx error %d\n",
> > +			      pfn, rc))
> > +			goto next_pfn;
> 
> This is comically trivial to hit, as it fires when running guest_memfd_test on a
> !SNP host.  Presumably the correct fix is to simply do nothing for !sev_snp_guest(),
> but that's easier said than done due to the lack of a @kvm in .gmem_invalidate().

Yah, the code assumes that SNP is the only SVM user that would use gmem
pages. Unfortunately KVM_X86_SW_PROTECTED_VM is the one other situation
where this can be the case. The minimal fix would be to squash the below
into this patch:

  diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
  index 176ba117413a..56b0b59b8263 100644
  --- a/arch/x86/kvm/svm/sev.c
  +++ b/arch/x86/kvm/svm/sev.c
  @@ -4675,6 +4675,9 @@ void sev_gmem_invalidate(kvm_pfn_t start,
  kvm_pfn_t end)
   {
           kvm_pfn_t pfn;
  
           +       if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
           +               return;
           +
                   pr_debug("%s: PFN start 0x%llx PFN end 0x%llx\n",
                   __func__, start, end);
  
                           for (pfn = start; pfn < end;) {

It's not perfect because the callback will still run for
KVM_X86_SW_PROTECTED_VM if SNP is enabled, but in the context of
KVM_X86_SW_PROTECTED_VM being a stand-in for testing SNP/TDX, that
might not be such a bad thing.

Longer term if we need something more robust would be to modify the
.free_folio callback path to pass along folio->mapping, or switch to
something else that provides similar functionality. Another approach
might be to set .free_folio dynamically based on the vm_type of the
gmem user when creating the gmem instance.

> 
> That too is not a big fix, but that's beside the point.  IMO, the fact that I'm
> the first person to (completely inadvertantly) hit this rather basic bug is a
> good hint that we should wait until 6.11 to merge SNP support.

We do regular testing of normal guests with/without SNP enabled, but
unfortunately we've only been doing KST runs on SNP-enabled hosts.
I've retested with the above fix and everything looks good with
SVM/SEV/SEV-ES/SNP/selftests with and without SNP enabled, but I
understand if we still have reservations after this.

-Mike

