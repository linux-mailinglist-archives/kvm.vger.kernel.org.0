Return-Path: <kvm+bounces-15981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C5948B2CB5
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E923C2873B0
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA75216C84C;
	Thu, 25 Apr 2024 22:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AFNp6kcT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C63156258;
	Thu, 25 Apr 2024 22:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714082430; cv=fail; b=tHYUG6n5TJp2XPLwCRxAUuREfHsysBOp1EAHVrLK+CLhJ4TTsbhrOIlbffArJP/ZbQEC4561RCo2sfYttoNfXQ1kHGsiieAYXPklIO6HrS5rRWOtuEwPEUOzHFusDhy94fP54BVfpDppKsohZ4piErsv9gkpHEqXc5jEfE02ZXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714082430; c=relaxed/simple;
	bh=QuyZmuymJ+rIOG5zR/AK02ai7iCUZkpknT5q/oNNwLY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jF28YcNFlbV/AxcgUcmtpz7sXiOJABLQ2uEbawxJwtzR2FrvfIMokR5vuW5C1u8+9rs0WSRRgVFLWgA3VWbIchmBkipwODdtEH/Zzd7lHIj97T4nXsxe+uDyqFusv2zGVSwlgwRBXDUjVAPW4pEOgQWJMik8BH0XynQkY+Phs08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AFNp6kcT; arc=fail smtp.client-ip=40.107.243.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxr23ZJNThA0xCdEa4t92x1RiSv4kZrTzVnx8TaGiacnpR0S4X3QBovvDPj1L1xFSBps6AVFrOxPG6opIXkaSgTHT6xmZErVmtk0Igmf+49IQMjTFI1nvcrGn0lyVYmcih4ZfiPgW/iRc8YpdqDfAS5hyEwppgBTZ93bbSuaDFHDjn13dYvC3oOQ6uIFj3iDMeY5BbULAHLf6LCqD7DW6gINPAa2+fR2/9lILnLXogYdMCVHzzLFdR5yY2H3YdZzLkliI+jYSmW9/cFttG99LIjRpO0ss4YB0W4ygs5I+8j9QEkeaAaOi330kYAFP5v8TK8zStxSWUrN7n7Q/CfQaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQvxiengEpccv4Mkkia81lqqiMWkS6re/A6vdEXtbUM=;
 b=EMEQE8ZLYMsFX9OCuwfXcG6krdH4iEnTx/ET7DXWWfSUCG204uOKGvbOF46SwOYWV70V8UWPB9AyoHj9wnNfleSkhec3y9KmGZbjN4NWT28HjXlzSpdc2HotaUW2fBVpfuEHP5tyM6H2bSf8fM+BCaBSq1dKor98BMlYUWQjQ6dBToURDO+dy217NEr1hTDKQSS1+ElXvBT9gpy4Vr80OQryZXebafjpT5+uqSjsMw1srRdLWr39TZSWWEm8eWSypE+zdzbYXJCPl7ZxVX/aaxiRNrYsiuABYFpGwQp2wFUaumtAmdVWlxU0leqV51/38vje1OVmHHf3Wtitv9LDWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQvxiengEpccv4Mkkia81lqqiMWkS6re/A6vdEXtbUM=;
 b=AFNp6kcTtPPBXGohyw6mRD0D1Fhm5SQe47zArAq1Pa+Q5CEFufitvztQczniDdKtCLZBWfOJX44Fwi6VG4ZPZN+foLuc2XxmSkSVXnomWOSDcgWKAplagWCfTOBRY2dRKjpAK3MDVCeAQyX3SrrmDiv2ASEgWrxsVGBSBcrjt/g=
Received: from PH1PEPF0001330E.namprd07.prod.outlook.com (2603:10b6:518:1::9)
 by PH8PR12MB8432.namprd12.prod.outlook.com (2603:10b6:510:25b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 22:00:26 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2a01:111:f403:f910::) by PH1PEPF0001330E.outlook.office365.com
 (2603:1036:903:47::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.34 via Frontend
 Transport; Thu, 25 Apr 2024 22:00:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Thu, 25 Apr 2024 22:00:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 25 Apr
 2024 17:00:25 -0500
Date: Thu, 25 Apr 2024 17:00:08 -0500
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
Message-ID: <20240425220008.boxnurujlxbx62pg@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-10-michael.roth@amd.com>
 <ZilyxFnJvaWUJOkc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZilyxFnJvaWUJOkc@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|PH8PR12MB8432:EE_
X-MS-Office365-Filtering-Correlation-Id: fb010b4c-9e0a-4e3d-f3d3-08dc65731ce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6AWk+Yq7FwxtB4UzdgJ4YsPTFQaYrH9lmiaLNYwPib5e+aAR4+ONp7uXLWNT?=
 =?us-ascii?Q?s2S+MCFttYH2aXCyKnl70pSjss29jBtsGMWGfypWEWqlWJ2rDH1gB9eZ4gQw?=
 =?us-ascii?Q?PmadbzRPajtF/OPLEQs/fbJ8IifFKdSiGWsXphoSvUFNgVLFv5J744j46LGF?=
 =?us-ascii?Q?uRrKb8LwFPk7k6GCTjv2o65UtRNt/wK8N7vSFZHtmfG7aLXb3ivvsoS8OlDd?=
 =?us-ascii?Q?tXo0Z6Z6gfWS+C/9GTB6tKLByvMChtl+PRORUfJdSIxobmRwfpLcG1feq9wY?=
 =?us-ascii?Q?VbZ3rbjHd1CXBNgrpeTJfJXhzFIDtb2VsHePZEHDLuGu9ctJazd4HsH2q0e+?=
 =?us-ascii?Q?kl0f2tlqZYmhSrEYidRWolg813y6AftXeuWINl9vg+DBsR1V+BtdlEE4YnAT?=
 =?us-ascii?Q?hwzLgFBMhRlYBzpRaVrzQHElVx+q8zuwtUuKtFlIm8k7ZRg+i3BFH3GXPBqv?=
 =?us-ascii?Q?xaw16k77sZG4zsZy/cCqBnujWEv6ZPML/hh+5n0v6U1/a+6HMreLAkg8zaeq?=
 =?us-ascii?Q?o2LfN7s+O9vKD4KC9OLS9CnOhc0oBISG27rTdNiaosqBrkSyWx4WP1ZNaHgY?=
 =?us-ascii?Q?ytLkdogpVunjlsPmz5+RV7Het2qvf1TkTdDW73eaal5Lkv3OTYSqC3rGfjYo?=
 =?us-ascii?Q?u9F7ZLbnuShXRnvkBIhtmyNuJ3C583OzPR0LuTiZ7KLyu8w9uWakwNBHsweT?=
 =?us-ascii?Q?9VuRHBvj55PSP9Pmg9EcSYUpkx+G+V0GjJMrK2Gnuk/O1oXdL2rjmJ0fZ7W/?=
 =?us-ascii?Q?XD1Tm+eP2rG2q11U/ZccmskPEELk35WOmnc2f5kQQUq+Nov7lsWMQAGczCke?=
 =?us-ascii?Q?+bhd/8NNQdSIwPEas6RsyzcGK5F3T4y9zBhO1u/1LbPBvBf69GL/093SYpwe?=
 =?us-ascii?Q?6uKCpIjC+Y1tGoUYzTYBF4sZX+0ehTnA2vO4ztYfMgjOkUkujZMy03SmDURn?=
 =?us-ascii?Q?jpbEFuqXhn8ADq1xngUvzfm5fsYM8SgdIfSTdjw4vmZoTSNZo7k5SAPjIDpv?=
 =?us-ascii?Q?k0Plt/xYwgMgkvT3Qnz+mH60nfzDAPHlY4E0ALI/eEdUM9Jb5wM1ubYgF5Wz?=
 =?us-ascii?Q?PS9REi5v1eeRsHcbhvw8LRnwZgCVWNHW69iOJSK93CORGsdFSMkcWDFIf88A?=
 =?us-ascii?Q?2J8jGDuEePEwwJLbzKQ5SfvUE70AoYhbVWm8QyJaGLwZVggZr+TWutHNojjQ?=
 =?us-ascii?Q?EXdpw+zUZO602cdJzkX87dy8gJNkXfNBKSI6bSKdORauSthnHi/d5TNoJacm?=
 =?us-ascii?Q?vJ8pqS7e/9+puQJ7GaGEYo3aYxsdbNV+kKCMY5TaKmmae7C9yTruV0GmA+3u?=
 =?us-ascii?Q?lbgOhqeo614e/jeNFx0j2JrTct6H468c3jtghs1CmShETD+QTgX7Qiiu71w7?=
 =?us-ascii?Q?dJ/wlDPJ2naiD1TBXFl1gc7K40UD?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(82310400014)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 22:00:25.9241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb010b4c-9e0a-4e3d-f3d3-08dc65731ce4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8432

On Wed, Apr 24, 2024 at 01:59:48PM -0700, Sean Christopherson wrote:
> On Sun, Apr 21, 2024, Michael Roth wrote:
> > +static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
> > +{
> > +	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
> > +	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +
> > +	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
> > +		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
> > +		return 1; /* resume guest */
> > +	}
> > +
> > +	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
> > +	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC_MSR;
> > +	vcpu->run->vmgexit.psc_msr.gpa = gpa;
> > +	vcpu->run->vmgexit.psc_msr.op = op;
> 
> Argh, no.
> 
> This is the same crud that TDX tried to push[*].  Use KVM's existing user exits,
> and extend as *needed*.  There is no good reason page state change requests need
> *two* exit reasons.  The *only* thing KVM supports right now is private<=>shared
> conversions, and that can be handled with either KVM_HC_MAP_GPA_RANGE or
> KVM_EXIT_MEMORY_FAULT.
> 
> The non-MSR flavor can batch requests, but I'm willing to bet that the overwhelming
> majority of requests are contiguous, i.e. can be combined into a range by KVM,
> and that handling any outliers by performing multiple exits to userspace will
> provide sufficient performance.

That does tend to be the case. We won't have as much granularity with
the per-entry error codes, but KVM_SET_MEMORY_ATTRIBUTES would be
expected to be for the entire range anyway, and if that fails for
whatever reason then we KVM_BUG_ON() anyway. We do have to have handling
for cases where the entries aren't contiguous however, which would
involve multiple KVM_EXIT_HYPERCALLs until everything is satisfied. But
not a huge deal since it doesn't seem to be a common case.

KVM_HC_MAP_GPA_RANGE seems like a nice option because we'd also have the
flexibility to just issue that directly within a guest rather than
relying on SNP/TDX specific hcalls. I don't know if that approach is
practical for a real guest, but it could be useful for having re-usable
guest code in KVM selftests that "just works" for all variants of
SNP/TDX/sw-protected. (though we'd still want stuff that exercises
SNP/TDX->KVM_HC_MAP_GPA_RANGE translation).

I think we'd there is some potential baggage there with the previous SEV
live migration use cases. There's some potential that existing guest kernels
will use it once it gets advertised and issue them alongside GHCB-based
page-state changes. It might make sense to use one of the reserved bits
to denote this flavor of KVM_HC_MAP_GPA_RANGE as being for
hardware/software-protected VMs and not interchangeable with calls that
were used for SEV live migration stuff.

If this seems reasonable I'll give it a go and see what it looks like.

> 
> And the non-MSR version that comes in later patch is a complete mess.  It kicks
> the PSC out to userspace without *any* validation.  As I complained in the TDX
> thread, that will create an unmaintable ABI for KVM.
> 
> KVM needs to have its own, well-defined ABI.  Splitting functionality between
> KVM and userspace at seemingly random points is not maintainable.
> 
> E.g. if/when KVM supports UNSMASH, upgrading to the KVM would arguably break
> userspace as PSC requests that previously exited would suddenly be handled by
> KVM.  Maybe.  It's impossible to review this because there's no KVM ABI, KVM is
> little more than a dumb pipe parroting information to userspace.

It leans on the GHCB spec to avoid re-inventing structs/documentation
for things like Page State Change buffers, but do have some control
as we want over how much we farm out versus lock into the KVM ABI. For
instance the accompanying Documentation/ update mentions we only send a
subset of GHCB requests that need to be handled by userspace, so we
could handle SMASH/UNSMASH in KVM without breaking expectations (or if
SMASH/UNSMASH were intermixed with PSCs, documentation that only PSC
opcodes could be updated by userspace).

But I'm certainly not arguing it wouldn't be better to have a
guest-agnostic alternative if we can reach an agreement on that, and
KVM_HC_MAP_GPA_RANGE seems like it could work.

-Mike

> 
> I truly do not understand why we would even consider allowing this.  We push back
> on people wanting new hypercalls for some specific use case, because we already
> have generic ways to achieve things, but then CoCo comes along and we apparently
> throw out any thought of maintainability.  I don't get it.
> 
> [*] https://lore.kernel.org/all/Zg18ul8Q4PGQMWam@google.com

