Return-Path: <kvm+bounces-16069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A1B8B3DB8
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87757B20C68
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E3E215D5B4;
	Fri, 26 Apr 2024 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fjbSFJ3z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BDC14535A;
	Fri, 26 Apr 2024 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714151827; cv=fail; b=EcNu3AZMhxKz5u8ZxjvhZaU57BxsKIG0hcCMccMVQaI/hTGI2H0iaSdXPqjTt9f9di8B+ypfaIZ7t6q+td6QkmJcvXQebuTKqR7kEsrYeAhz6dKha1nsQeyC68UPe7HWLnHR3zjEGPD2D0gcBigz5PBDLsH5wbw8dcs/doyrQuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714151827; c=relaxed/simple;
	bh=fhzmCuHNc1qGpU/obPquISsxpGMOXo4a8myq7PlkJx8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ioytuvBiEd3lD1hQD5yOmDD2VMp2T7QUlbqFq7zf3YOJwRrfC+Rowe+t8Y4XxZPu28HeMQf/ZoVQzsk/Bh1pbOIdIykvTackOsjrFwjedePG/nPky/YsE7seI1VqZUs0PHpf8Hqu8cUpEZldeHKBjQEMvzpDNPcywDhFaFffark=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fjbSFJ3z; arc=fail smtp.client-ip=40.107.244.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4W+INpINhREJiXFzBAzigNNWXYHz+WNGgms+uGM3jO88l1eeDnle3B/S9JCrYHiEaYx7+uMKeOerRkGNKekn3QqFM5o0gTojWT5UpPI05EdVAEiliDkgag72yqnPwuqzj+DD18JQK/+Cir2mRgbXG85oIPXVCJ8YMwiUh+lduVzvhB+fGn3Q8ye/uEeh0cyK9c6AWVPFmpMk1CS1xDySJznL4Q4u7UMFOetogg3TTkasC4XK6qZJ4V9xJAc4ocsKwq08CnwPjO6xG2llVoZ6yMP6sIUQXwn288nBhsQu15OYX1VCTUtnMtbl8kgkIhgrOPQW6/pSIFFbFtrsTjKug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsfPGY6OxXcJ1K+Kc4V/pQNiGolK5eR8GJrknSS+yJM=;
 b=UOkEZ4ylPooZ5NtCtGvprCR96Qzy5DFriHMcJROcC9SQc0YIV6V45+gALA0YydUyHbCo6zInc7uYcw1eSNCJIKTfKkbo1YR8aJ6/2Z/5X/ErWv8zVFJbSaskVQ0kNwPkuGrJ86KlA0tFTzpXg2cYWwKHqqRJWtPZ0nwkwU7fTK5GxUowN1fU0OaLmXBUiqT17Qdw793d74jxnjALy5zPXCcoVfksM9U0L+QOnpx6XrGBUn1S+CyK5+A4jmPvZUTZnkQ8g9Q/FZP6glmPogD77Z6Iw8akCWan2Qz54U4HEgXHrs7wU6X1dYcycumh7H4F7xGmkTxXS+oG5i0e1Qj7Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsfPGY6OxXcJ1K+Kc4V/pQNiGolK5eR8GJrknSS+yJM=;
 b=fjbSFJ3zvP2zjEfE4//13B0cKLl/aDUHgCvY8i8bWcWBvsiPsgKNrT2xpBMNmrqXA9lXZOXr8+oaHjay4DP9ZVMFK1a7Bma1tyUCbZObc47a1LRk2BW4bX+s9d73Ckgsmb8wZeY4zcrtgokTk5XIddkD5npEZqZ5DFuXyi8yK54=
Received: from DM6PR11CA0064.namprd11.prod.outlook.com (2603:10b6:5:14c::41)
 by BY5PR12MB4033.namprd12.prod.outlook.com (2603:10b6:a03:213::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.46; Fri, 26 Apr
 2024 17:17:02 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:14c:cafe::22) by DM6PR11CA0064.outlook.office365.com
 (2603:10b6:5:14c::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.31 via Frontend
 Transport; Fri, 26 Apr 2024 17:17:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Fri, 26 Apr 2024 17:17:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 26 Apr
 2024 12:16:59 -0500
Date: Fri, 26 Apr 2024 12:16:44 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: Re: [PATCH v14 09/22] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
Message-ID: <20240426171644.r6dvvfvduzvlrv5c@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-10-michael.roth@amd.com>
 <ZilyxFnJvaWUJOkc@google.com>
 <20240425220008.boxnurujlxbx62pg@amd.com>
 <ZirVlF-zQPNOOahU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZirVlF-zQPNOOahU@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|BY5PR12MB4033:EE_
X-MS-Office365-Filtering-Correlation-Id: 26082ca5-f951-4ef8-6193-08dc6614b076
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FgFc3P+DtRl+NLuaIWh4srTCSbCOK+LlrSO8yuQlHQhaB/3SBuh0JAk7zo8i?=
 =?us-ascii?Q?rjRYHqYgWwqPDkhPX7MXmnsuwoK3/VoV5L0WOF7LwIC2wO10DGZgES2CSMt2?=
 =?us-ascii?Q?/ZX/pHayPb/9U/sEyw3L1QC7Ki8ZMqAXPb/qiqYB7w91Z21BInxmxlryQ3G3?=
 =?us-ascii?Q?TjPv4LAzZ3lBpA7y4b5JbzTLaKwKNQI6jaIODBsjv4tVJspNWQ5hTUTDnykl?=
 =?us-ascii?Q?8LLnijjhIWd+bsu2fLx3zHQkaSESN3ZfA0PsnQZCq5xGRsOhM1phuGk+hfNV?=
 =?us-ascii?Q?cSVwLQlsODMip+Zb9UEMzmmMAK1YyLCyLSJbyFTx24u44tW/YR7Zn8xuRyB0?=
 =?us-ascii?Q?IMhK0iYWOmjn1xSzGJp5IFsoFlFPlwr04ZV+yyQ2haeB1Yvie1JbwjCpl09x?=
 =?us-ascii?Q?0s07q/0aswCrp5GZnoejsuBEbSayQvzhvGfE/8rkHRnWsegZe/5kq2V+E0pa?=
 =?us-ascii?Q?TXoycmZN5v614+hDKfyLm0jl3ApYKNq6uurpAMg/TC/eR4++k1/pL91B994z?=
 =?us-ascii?Q?izvR5Gfn30FD+MF4Y6qHP0T73rxf4sK8GcIwjy9qzzgrbI9ButBW1NNXum/K?=
 =?us-ascii?Q?P7/t6DuFrIf0E8KDeojGQFhBcyVTOWRVuati0SQkG237At9wGAQsOCvAqcJi?=
 =?us-ascii?Q?D+wQjYwwqKWT0Iq2S1NLiKJ4Q+KugSCSRP05jjKz0O4JxmEby0FOHneX+lnh?=
 =?us-ascii?Q?EG4jHa9a9+wcN3U4oITR1Q0wMTscVQV8277OptzDzrXHNdDQKDZbPODTk/I+?=
 =?us-ascii?Q?KRCZ31tllLt06bMm6jNCwTr2U1jiEx60d7c8DZBXdxQfDyUEHSzLa2eN9odl?=
 =?us-ascii?Q?EUlzRoVNaOqXMmpFOgEcQMAWbW3Nk5aTCJ/rFBMaQhkwshigtOJzycVknLjw?=
 =?us-ascii?Q?C4+5jfpaMhOg6k856SQgzNH4503Hp0GVFIHLm+APIjUdycVFZrBa6qMLVh/k?=
 =?us-ascii?Q?Ucp7PsMVesRWKduLgmgycVfZW5v8RbBVIqDviGO9cYXS1y/tnzxalbqtKT7A?=
 =?us-ascii?Q?f2DAI5Um/OUmeQuGa1dq7g8+yINejqDyUSSuEiSWHOPdDP/pKQD1brrfY/lw?=
 =?us-ascii?Q?vZOagNurexXjEFzq/Y8DA2dAm/mYdZnegNSWoflxhvGvFXNo+h3ll9I02JBP?=
 =?us-ascii?Q?s2IV+Bs3BW3St49OMdXumzICs4v65qn5nrX9zN2nVvpVIWHDEQR5xxC91nC6?=
 =?us-ascii?Q?y6tSRw7ceKnrzsUL4J4/D6fDsXc5u6fQBSOzNM+SPycL4200oIi52lDfXD6Y?=
 =?us-ascii?Q?mN2YltACrX/UFUM9+cV0RXIW4hvqxpSFKqxYpzA4dQ6v1XOydMcvM0wzU0fT?=
 =?us-ascii?Q?G/Lbqe6fe4I1iRcluGXu6A4MMjMVxC4lazPx2cn14pofq0Y3kiJR2c9vi1Tt?=
 =?us-ascii?Q?wx9u79yHQeVFyanAVDPDTpmaoCjd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 17:17:02.3507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26082ca5-f951-4ef8-6193-08dc6614b076
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4033

On Thu, Apr 25, 2024 at 03:13:40PM -0700, Sean Christopherson wrote:
> On Thu, Apr 25, 2024, Michael Roth wrote:
> > On Wed, Apr 24, 2024 at 01:59:48PM -0700, Sean Christopherson wrote:
> > > On Sun, Apr 21, 2024, Michael Roth wrote:
> > > > +static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
> > > > +{
> > > > +	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
> > > > +	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
> > > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > > +
> > > > +	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
> > > > +		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
> > > > +		return 1; /* resume guest */
> > > > +	}
> > > > +
> > > > +	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
> > > > +	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC_MSR;
> > > > +	vcpu->run->vmgexit.psc_msr.gpa = gpa;
> > > > +	vcpu->run->vmgexit.psc_msr.op = op;
> > > 
> > > Argh, no.
> > > 
> > > This is the same crud that TDX tried to push[*].  Use KVM's existing user exits,
> > > and extend as *needed*.  There is no good reason page state change requests need
> > > *two* exit reasons.  The *only* thing KVM supports right now is private<=>shared
> > > conversions, and that can be handled with either KVM_HC_MAP_GPA_RANGE or
> > > KVM_EXIT_MEMORY_FAULT.
> > > 
> > > The non-MSR flavor can batch requests, but I'm willing to bet that the overwhelming
> > > majority of requests are contiguous, i.e. can be combined into a range by KVM,
> > > and that handling any outliers by performing multiple exits to userspace will
> > > provide sufficient performance.
> > 
> > That does tend to be the case. We won't have as much granularity with
> > the per-entry error codes, but KVM_SET_MEMORY_ATTRIBUTES would be
> > expected to be for the entire range anyway, and if that fails for
> > whatever reason then we KVM_BUG_ON() anyway. We do have to have handling
> > for cases where the entries aren't contiguous however, which would
> > involve multiple KVM_EXIT_HYPERCALLs until everything is satisfied. But
> > not a huge deal since it doesn't seem to be a common case.
> 
> If it was less complex overall, I wouldn't be opposed to KVM marshalling everything
> into a buffer, but I suspect it will be simpler to just have KVM loop until the
> PSC request is complete.

Agreed. But *if* we decided to introduce a buffer, where would you
suggest adding it? The kvm_run union fields are set to 256 bytes, and
we'd need close to 4K to handle a full GHCB PSC buffer in 1 go. Would
additional storage at the end of struct kvm_run be acceptable?

> 
> > KVM_HC_MAP_GPA_RANGE seems like a nice option because we'd also have the
> > flexibility to just issue that directly within a guest rather than
> > relying on SNP/TDX specific hcalls. I don't know if that approach is
> > practical for a real guest, but it could be useful for having re-usable
> > guest code in KVM selftests that "just works" for all variants of
> > SNP/TDX/sw-protected. (though we'd still want stuff that exercises
> > SNP/TDX->KVM_HC_MAP_GPA_RANGE translation).
> > 
> > I think we'd there is some potential baggage there with the previous SEV
> > live migration use cases. There's some potential that existing guest kernels
> > will use it once it gets advertised and issue them alongside GHCB-based
> > page-state changes. It might make sense to use one of the reserved bits
> > to denote this flavor of KVM_HC_MAP_GPA_RANGE as being for
> > hardware/software-protected VMs and not interchangeable with calls that
> > were used for SEV live migration stuff.
> 
> I don't think I follow, what exactly wouldn't be interchangeable, and why?

For instance, if KVM_FEATURE_MIGRATION_CONTROL is advertised, then when
amd_enc_status_change_finish() is triggered as a result of
set_memory_encrypted(), we'd see

  1) a GHCB PSC for SNP, which will get forwarded to userspace via
     KVM_HC_MAP_GPA_RANGE
  2) KVM_HC_MAP_GPA_RANGE issued directly by the guest.

In that case, we'd be duplicating PSCs but it wouldn't necessarily hurt
anything. But ideally we'd be able to distinguish the 2 cases so we
could rightly treat 1) as only being expected for SNP, and 2) as only
being expected for SEV/SEV-ES.

I'm also concerned there's potential for more serious issues, for instance
kvm_init_platform() has a loop that resets all E820_TYPE_RAM ranges to
encrypted, which may step on PSCs that SNP had to do earlier on for
setting up shared pages for things like GHCB buffers. For SEV live
migration use case, it's not a huge deal if a shared page gets processed
as private, it's just slower because it would need to go through the SEV
firmware APIs. There's also more leeway in that updates can happen at
opportunistic times since there's as KVM_MIGRATION_READY state that can
be set via MSR_KVM_MIGRATION_CONTROL once everything is ready is set
up.

For SNP, all those associates KVM_HC_MAP_GPA_RANGE calls would have
immediate effect if they are not in lock-step with the actual state of
each page before access, and there is no leeway for stuff like leaving
a shared page as private.

I also a lot of that was before lazy acceptance support which happens
out-of-band versus these pv_ops.mmu.notify_page_* hooks, and kexec
support for SNP guests has some notion of tracking state across kexec
boundaries that might get clobbered too.

I haven't looked too closely though, but it seems like a good idea to at
least set a bit for kvm->arch.has_private_mem use cases. If it's not
needed then worst case we have a bit that userspace doesn't necessarily
need to care about, but for SNP just filtering out the duplicate
requests seems like enough to justify having it.

-Mike

