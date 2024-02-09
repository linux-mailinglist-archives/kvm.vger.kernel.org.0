Return-Path: <kvm+bounces-8385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0267984EEA9
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 02:52:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68503B25B48
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 01:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345E217F8;
	Fri,  9 Feb 2024 01:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vc2ZM0uO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C7B139B;
	Fri,  9 Feb 2024 01:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707443557; cv=fail; b=Z1iAM0Hx/F1GzoAZIKXREU5oXRqFwb0JVopvKxDqaVCU0AN27aUa0QN7PpHlSlTbWKzw1a8JAf9RIDBH71rwr4yqEJBOpgeIfN9Eu7Rno+hQHkqM8qkEYdTcBItv1I+OPqKs8PxAt17cK9hw2bxc/Z5xlbZ5kRNxf/U8heCnhUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707443557; c=relaxed/simple;
	bh=rr7ch+BB5rbmLRxe2vw8svA9wa6jHBJegCOaz9teuxY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYcU6sj6Puu2+ULUHD7B28QSEgKZ5mShnnsOzuNUJqaQwIOWPowyi1Z5GZjJ0SSD5RQbQeTRtMpYDoM1n58jDu21XTT47Jhxo2ZlPghhBARaHGV50AhYk2MAlwrY6mhQfxEy4sNgU/IHpbZTStCouY4nwROkpGiaTct1F+4Nyi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vc2ZM0uO; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSfRpxSib2XslGPPtpqUwtzvDRlIM17eRLW1pr/60HQwdcFaNADaMy+Om4KxMyN/GVsj1oLnr1g5itudAKFS5z87VaKDWJ/Gg0qWwolq5gQSuZHh7IZTjjmEy0AHbObqWytqM7rpTnH+IwMvbhuofS8eU65KNDBXGvjrpoT8MjvK6gDgKkoN0nu88Nsv+7Ta72NjU1oK9HIHfzElxca4wXQw7r8RFbJhF42ljpH4XUiENGUYi2vFkOSPVfvZUQUyk0pf/C7vhaQPNnSc6lML1/BcZPF2GDvrXg4RAz16ZiBDlPFKoS4YscmDcoyMl1sBogAPqspSIKcLTO3KwO0afw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UxuYHw6h45Qj/UCXjWNQNek+lV/wpatv3BONnJE2QpA=;
 b=lxABmzCcwSN58TldKCeeWGXMfSLIfi3Hg9RhCACxQ6Z6/+GoH7GBLhelPjpM/ARfrjweGahJGYh2DSb9gya/DkvmJNNaRQlOiV4/AZKqkqBS7HVnQ1eUP3FAcBSwyUEA8JWKTh9RsUiYcy6fb7Eky2OUWzUMOBoPPlU3HzaUD/R20u0lmRDV3p10jxfl8sPW6s2TmeOs21qLT2okkITbEYDRsWpYtyhaDv/A+bMhx8cdi18LXG2noQhDe8gb4EHc0O7M04D/vqE248TCKCVvSFd3sVbnbZrr8MB80lgzuS0PpbS1+1mqKginvRynM0rvuvzhaF4Vc+Jk0o9wzAhbsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxuYHw6h45Qj/UCXjWNQNek+lV/wpatv3BONnJE2QpA=;
 b=vc2ZM0uOXKRf0IUgJkuA4lxG7+JxTPkIY3lSL6/POxyRSw+dl0O+4Y/sYiknXjRHU5QY6Qgc9ZFCoXFnunjVMphCRy2YxIfPUq773L/5zVYUnroUAYZ0C7EnDaHZfVZnSm/HTKZwgg+wA26i6KAYxj7JVK4QGs4toiyquRqWuJc=
Received: from MN2PR04CA0011.namprd04.prod.outlook.com (2603:10b6:208:d4::24)
 by CY8PR12MB7266.namprd12.prod.outlook.com (2603:10b6:930:56::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Fri, 9 Feb
 2024 01:52:31 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:d4:cafe::65) by MN2PR04CA0011.outlook.office365.com
 (2603:10b6:208:d4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36 via Frontend
 Transport; Fri, 9 Feb 2024 01:52:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7181.14 via Frontend Transport; Fri, 9 Feb 2024 01:52:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 8 Feb
 2024 19:52:30 -0600
Date: Thu, 8 Feb 2024 19:52:05 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <vkuznets@redhat.com>, <jmattson@google.com>,
	<luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
	<pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v11 18/35] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Message-ID: <20240209015205.xv66udh6hqz7a6t7@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
 <20231230172351.574091-19-michael.roth@amd.com>
 <ZZ67oJwzAsSvui5U@google.com>
 <20240116041457.wver7acnwthjaflr@amd.com>
 <Zb1yv67h6gkYqqv9@google.com>
 <CABgObfa_PbxXdj9v7=2ZXfqQ_tJgdQTrO9NHKOQ691TSKQDY2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfa_PbxXdj9v7=2ZXfqQ_tJgdQTrO9NHKOQ691TSKQDY2A@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|CY8PR12MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bc132a9-4cf1-4242-be94-08dc2911c720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Rp4KlCA6h9GSEFM4xw3CHc36Ockr2TWiLUpM6af5/38SK97bGJwtGNqAoZALe0x341TrKAOcBb1u6jCN6ioWufngeVoQBMlfUbhSIyWMT8vqllrTcu2sf21j6J8wZLJtbXfVAwEDZP+2XkXz/nz7N5f/cM1CcHdJUqKXL8f6tvM/wY2eojtp3UcFunjJYlFR1csxA1wla1uBetex583xlfRsS2194VoL5R6m32EFXPavzWRiv2hpj0UEngTlucpa2VavepWhWL3JFMNgpAtV3RpIn49VckeoPo980OsvUtHbc41fiDxZrDRauTh3hexDTT1H31DC59sDMWGd5+pW1luLJQyNQ1ZHCj7ny0IWGpT6rdivMO3hh4XeqdaXAwIboUdFExgAKrxyOoDiQRI10xqursc8jhsiZJyRnzXlBYGXm8tklfHYrmG7P4ZodKkB/JflzygJVBFgR2iNakxXZ/tgVAuqgCn+VtYbTmMJibNShzHEp8IhAKS+/WFAk882clBD+SqoWQsVvcWc41W9sQNbXGPxPpzNP+0b4vo5BGwfhzP7xvFfzUVFm4qfX5TRZRlngl8+Pw0kt56E5W+8DXWwW+oA+ez+1qEDCVZZ9HY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(376002)(39860400002)(136003)(230922051799003)(82310400011)(64100799003)(186009)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(2616005)(26005)(426003)(336012)(16526019)(83380400001)(1076003)(478600001)(53546011)(86362001)(70586007)(316002)(6916009)(8676002)(54906003)(4326008)(70206006)(8936002)(81166007)(6666004)(356005)(82740400003)(44832011)(36756003)(41300700001)(2906002)(7406005)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2024 01:52:31.0981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc132a9-4cf1-4242-be94-08dc2911c720
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7266

On Wed, Feb 07, 2024 at 12:43:02AM +0100, Paolo Bonzini wrote:
> On Fri, Feb 2, 2024 at 11:55 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > > +        struct kvm_sev_snp_launch_update {
> > > > > +                __u64 start_gfn;        /* Guest page number to start from. */
> > > > > +                __u64 uaddr;            /* userspace address need to be encrypted */
> > > >
> > > > Huh?  Why is KVM taking a userspace address?  IIUC, the address unconditionally
> > > > gets translated into a gfn, so why not pass a gfn?
> > > >
> > > > And speaking of gfns, AFAICT start_gfn is never used.
> > >
> > > I think having both the uaddr and start_gfn parameters makes sense. I
> > > think it's only awkward because how I'm using the memslot to translate
> > > the uaddr to a GFN in the current implementation,
> >
> > Yes.
> >
> > > > Oof, reading more of the code, this *requires* an effective in-place copy-and-convert
> > > > of guest memory.
> > >
> > > So that's how it's done here, KVM_SNP_LAUNCH_UPDATE copies the pages into
> > > gmem, then passes those pages on to firmware for encryption. Then the
> > > VMM is expected to mark the GFN range as private via
> > > KVM_SET_MEMORY_ATTRIBUTES, since the VMM understands what constitutes
> > > initial private/encrypted payload. I should document that better in
> > > KVM_SNP_LAUNCH_UPDATE docs however.
> >
> > That's fine.  As above, my complaints are that the unencrypted source *must* be
> > covered by a memslot.  That's beyond ugly.
> 
> Yes, if there's one field that has to go it's uaddr, and then you'll
> have a non-in-place encrypt (any copy performed by KVM it is hidden).
> 
> > > > > +         kvaddr = pfn_to_kaddr(pfns[i]);
> > > > > +         if (!virt_addr_valid(kvaddr)) {
> > > >
> > > > I really, really don't like that this assume guest_memfd is backed by struct page.
> > >
> > > There are similar enforcements in the SEV/SEV-ES code. There was some
> > > initial discussion about relaxing this for SNP so we could support
> > > things like /dev/mem-mapped guest memory, but then guest_memfd came
> > > along and made that to be an unlikely use-case in the near-term given
> > > that it relies on alloc_pages() currently and explicitly guards against
> > > mmap()'ing pages in userspace.
> > >
> > > I think it makes to keep the current tightened restrictions in-place
> > > until such a use-case comes along, since otherwise we are relaxing a
> > > bunch of currently-useful sanity checks that span all throughout the code
> 
> What sanity is being checked for, in other words why are they useful?
> If all you get for breaking the promise is a KVM_BUG_ON, for example,
> that's par for the course. If instead you get an oops, then we have a
> problem.
> 
> I may be a bit less draconian than Sean, but the assumptions need to
> be documented and explained because they _are_ going to go away.

Maybe in this case sanity-check isn't the right word, but for instance
the occurance Sean objected to:

  kvaddr = pfn_to_kaddr(pfns[i]);
  if (!virt_addr_valid(kvaddr)) {
    ...
    ret = -EINVAL;

where there are pfn_valid() checks underneath the covers that provide
some assurance this is normal struct-page-backed/kernel-tracked memory
that has a mapping in the directmap we can use here. Dropping that
assumption means we need to create temporary mappings to access the PFN,
which complicates the code for a potential use-case that doesn't yet
exist. But if the maintainers are telling me this will change then I
have no objection to making those changes :) That was just my thinking
at the time.

And yes, if we move more of this sort of functionality closer to gmem
then those assumptions become reality and we can keep the code more
closely in sync will how memory is actually allocated.

I'll rework this to something closer to what Sean mentioned during the
PUCK call: a gmem interface that can be called to handle populating
initial gmem pages, and drop remaining any assumptions about
struct-backed/directmapped in PFNs in the code that remains afterward.

I'm hoping if we do move to a unified KVM API that a similar approach
will work in that case too. It may be a bit tricky with how TDX does
a lot of this through KVM MMU / SecureEPT hooks, this may complicate
locking expectations and not necessarily fit nicely into the same flow
as SNP, but we'll see how it goes.

-Mike

