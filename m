Return-Path: <kvm+bounces-17208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 837898C2A57
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7343B25022
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 19:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BEB487B3;
	Fri, 10 May 2024 19:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="165O5gkM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C7E481D5;
	Fri, 10 May 2024 19:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715368148; cv=fail; b=ZBUeA8COgARPpNQB6jkvY64gsh/5oiCQPGrJX603epJHzT1xvZDy6lUoNL4g7IdsRzsWrliMpzn1VhzdJY9ccN5VAYIEiNkWVbjO+wHFhdjyYE9OqnM36HjBaLVFCCayu7X6eSsqpfkcourbdrOfg6ukeFv/YA04mH/REOvHilQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715368148; c=relaxed/simple;
	bh=0ByqADji/+c2K66VLruGUyOTov8ON3fZ71VCLEC6eFk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvSFn1AUH5FT8nIA3UaXx+aR6v3VhRXnfgyjeLt9ZS5U00b27/Wl++e0ztkwknxHUfAVEaosN4F9S1XTmBvSVBbJbu7F3EJqMtBNhp6OwkPsgXNG7Za4DUY6P9/Hz4k8AvQoX89TVmP84m/RiXiVN1z3W/l7hrfyiPBm9km5f+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=165O5gkM; arc=fail smtp.client-ip=40.107.96.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2IB6QYsQAqla6mRFKJJBQzjQNh5AJBrmSjB2wHiG/0hQ0XRTXycKwmmMB1rwTxn8hZg7RXqZR+QUiOeLRGlZkJrY3ayyYJ1pnsS6tue0KBsDagel/CW7Y31WxGRreIzBMkeRSOWPnL41sEam9bK7dmrN7t0eKJJ/60Imx2hzRHQtJyB+ZGbuhHDN3oKqfa5s0+/8XG18rP4FWfypJEcRxzO0UVQk4nQMBPdOC5Eeq9E0VoFGrxbo6/VM5yCLdFWj94CF6t1yV+VUkRwlc3aNQf88ni/zXEL152wVZEHHlzE/CMrUv/GFbnqriHLbFbb7xrL9UArXhY1I9TgKbaomg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xrx6loo7EdKYmH9u5AM9rsavyb7lhvWfgqE+eRctvDs=;
 b=FnFgI4Ns2kQIACdnQdxe4FMwyW5FIsBJnWH6UlfuUnD0cC5zg3w3E6rJlvpoPz+b3H+PEwLA6dvMu0MmYds9nszLhMGikEI/1fzYDruXPD9/7CHOpqQKJcRYN9DKQjr8KTxpwZQ8sSFgHZcIWE/SRgdwzE1zL4ActAtdi0MOBBMCZg/dd279TYvVlb+oMNil7uvQBpB+ydyIsOzEgx4pF1F6FMYWNsROCopmTzbCI6BW3fZ3wlyB9X4nP07dIfayfzzGkY5qR1cmcQOqz7aBpSHctlqoO+MISI1g7cogXFG3FeudHsPBlKeMEmzfukwkC7fYEkRofz5n9sPYDnM5pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xrx6loo7EdKYmH9u5AM9rsavyb7lhvWfgqE+eRctvDs=;
 b=165O5gkM5c3qTp6+v4g3zeKaSLZgQ/8cYne+KbC+A4eLkPrEbjSMOlJM0X7u7viGL7KYnKzdhjmn8uSVtWKx1Gu+H38Ycmto7fDCb6mK6UxUV+dFesnC4Ss0VfxI7J6QVQ9LSiDbL6kn2BZdEvCkF827hvMV8T75e+gspyEQ570=
Received: from BN9PR03CA0797.namprd03.prod.outlook.com (2603:10b6:408:13f::22)
 by SJ1PR12MB6241.namprd12.prod.outlook.com (2603:10b6:a03:458::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48; Fri, 10 May
 2024 19:09:01 +0000
Received: from BN3PEPF0000B075.namprd04.prod.outlook.com
 (2603:10b6:408:13f:cafe::fc) by BN9PR03CA0797.outlook.office365.com
 (2603:10b6:408:13f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48 via Frontend
 Transport; Fri, 10 May 2024 19:09:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B075.mail.protection.outlook.com (10.167.243.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 19:09:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 14:09:00 -0500
Date: Fri, 10 May 2024 14:08:43 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: Re: [PATCH v15 23/23] KVM: SEV: Fix PSC handling for SMASH/UNSMASH
 and partial update ops
Message-ID: <20240510190843.yivmiwaj5isvqyph@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
 <20240510015822.503071-3-michael.roth@amd.com>
 <fe5cc86b-43e0-4685-99e7-998e61db333f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fe5cc86b-43e0-4685-99e7-998e61db333f@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B075:EE_|SJ1PR12MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: ef6650de-1de2-486c-902b-08dc7124a714
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?g9NllTG9StPr6fyX6Rffgjd0j+LMafgEO7V2agCTYwvABitcTXeS4nG/G1MW?=
 =?us-ascii?Q?6OdogbZleJGOFvJ6xJ4roRNpAWqhWQswjxqzQnP1GiMMeZA5hr2hjq83P2uj?=
 =?us-ascii?Q?jqeEkVlmULiuqtkdlxuFXIoZL7Gc7JhFL44T+4ud0mszLSl13Ks33hp/wc6U?=
 =?us-ascii?Q?EabgOX02DDvJHioGNUCf9nJEO4QFuBrkm6RzUnB0JzSApGAkYZFV46vIxbRt?=
 =?us-ascii?Q?yuMexiqRPRzoByWveJP3TXOH9i7pruiSWJL0hXdc0aJdQutOYEsGBLtebO8Z?=
 =?us-ascii?Q?8A9JFDQPZgrI9QnrNinKVRrYOazqCSnC2U0+JEVp8BzRODcRm1kXspDRDwbL?=
 =?us-ascii?Q?AwOBdQCrgUGUHgXVWYHtGfsgED4/gHCWiINm8p8c3aAA9S63bPZCGniQGMgY?=
 =?us-ascii?Q?/IiWmtnWQWQQezoQHpfrYR5ZuyiEz3OeV10riuAwAiXoRajUyMK2EreQNuiN?=
 =?us-ascii?Q?a5SnLx0OGbIEEtykZOLvgP08PXERlBlytlI9GB8N+e6lpxzMRkF1H6Ex3gMK?=
 =?us-ascii?Q?3OBirA2DgxSEeL421qPnCva9DlBJCNzjfje0p3dptp8cAhzJAeiRaOnf1uPR?=
 =?us-ascii?Q?iSwYQGdTXTpZsbxpuxUzWVH2OOQXArH+qNk0HtZgzVrAOB1C3x1gmuH2yJXF?=
 =?us-ascii?Q?3XlaBSXBIY8u/RXdLoMhu1OqcxgTfr5FGwWB7ogCbmfoJKVT3iCHx2LAB/8T?=
 =?us-ascii?Q?V/APYljWFc8fq2p3iyleTDFWqQCcZTnyh05pM5pJrW11MlUsZY+ZLoXSlxXf?=
 =?us-ascii?Q?s8ME+TyukqEhd7C0wndlwpLiha5dAFdJTKGXf/zpqDLwilE5AC9V+h3HMASW?=
 =?us-ascii?Q?vhjfnGIDkqoaY9JbJsfBJ3YAOTk1nD0gWU7Cn8SRXqCYJKYDa9JsRS1yFyxF?=
 =?us-ascii?Q?dvrs3zbLezPoggXktN0I0kmUebl30opBFKQK7FPNMzr7EqOTsvyo8BvDaJEK?=
 =?us-ascii?Q?xvzzvllYEhRTyz3ilYubM50OOOlLrZ1ufemM7452DvoXOh0f1sDorshXwvVu?=
 =?us-ascii?Q?kL+/zcDatBD+3sPMLJFGDWBhXXhJ1y7/EMzFx/lV3WrFId2LJx7jC/773zLV?=
 =?us-ascii?Q?Twut7pcTtVIK2uM97UDpIEcjfC6AeWMjgSlzwObNdednh/nsqHKLFpx3zw4Q?=
 =?us-ascii?Q?nFFf8wLLg7FWMuxyf+OZREwY7XZemQp3QYbiNLlhAOCybKhVK/4lgRtDqa5S?=
 =?us-ascii?Q?lUzhNieflMkJjZ60ukR9q6CIbZmtKsXBV+xXREegmTxBSzgbRdtUUfmQdgmh?=
 =?us-ascii?Q?q5WYOeNyzxtdQhr9hQf8rhmXQhuKCqUYihmk1lpAfvr7AmoH3xYq+Xx0Pp+n?=
 =?us-ascii?Q?pgl5w5VXFdk0VRH+PoFJtnqf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 19:09:01.4890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef6650de-1de2-486c-902b-08dc7124a714
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6241

On Fri, May 10, 2024 at 07:09:07PM +0200, Paolo Bonzini wrote:
> On 5/10/24 03:58, Michael Roth wrote:
> > There are a few edge-cases that the current processing for GHCB PSC
> > requests doesn't handle properly:
> > 
> >   - KVM properly ignores SMASH/UNSMASH ops when they are embedded in a
> >     PSC request buffer which contains other PSC operations, but
> >     inadvertantly forwards them to userspace as private->shared PSC
> >     requests if they appear at the end of the buffer. Make sure these are
> >     ignored instead, just like cases where they are not at the end of the
> >     request buffer.
> > 
> >   - Current code handles non-zero 'cur_page' fields when they are at the
> >     beginning of a new GPA range, but it is not handling properly when
> >     iterating through subsequent entries which are otherwise part of a
> >     contiguous range. Fix up the handling so that these entries are not
> >     combined into a larger contiguous range that include unintended GPA
> >     ranges and are instead processed later as the start of a new
> >     contiguous range.
> > 
> >   - The page size variable used to track 2M entries in KVM for inflight PSCs
> >     might be artifically set to a different value, which can lead to
> >     unexpected values in the entry's final 'cur_page' update. Use the
> >     entry's 'pagesize' field instead to determine what the value of
> >     'cur_page' should be upon completion of processing.
> > 
> > While here, also add a small helper for clearing in-flight PSCs
> > variables and fix up comments for better readability.
> > 
> > Fixes: 266205d810d2 ("KVM: SEV: Add support to handle Page State Change VMGEXIT")
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> 
> There are some more improvements that can be made to the readability of
> the code... this one is already better than the patch is fixing up, but I
> don't like the code that is in the loop even though it is unconditionally
> followed by "break".
> 
> Here's my attempt at replacing this patch, which is really more of a
> rewrite of the whole function...  Untested beyond compilation.

Thanks for the suggested rework. I tested with/without 2MB pages and
everything worked as-written. This is the full/squashed patch I plan to
include in the pull request:

  https://github.com/mdroth/linux/commit/91f6d31c4dfc88dd1ac378e2db6117b0c982e63c

-Mike

> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 35f0bd91f92e..6e612789c35f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3555,23 +3555,25 @@ struct psc_buffer {
>  static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc);
> -static int snp_complete_psc(struct kvm_vcpu *vcpu)
> +static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
> +{
> +	svm->sev_es.psc_inflight = 0;
> +	svm->sev_es.psc_idx = 0;
> +	svm->sev_es.psc_2m = 0;
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
> +}
> +
> +static void __snp_complete_one_psc(struct vcpu_svm *svm)
>  {
> -	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
>  	struct psc_entry *entries = psc->entries;
>  	struct psc_hdr *hdr = &psc->hdr;
> -	__u64 psc_ret;
>  	__u16 idx;
> -	if (vcpu->run->hypercall.ret) {
> -		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
> -		goto out_resume;
> -	}
> -
>  	/*
>  	 * Everything in-flight has been processed successfully. Update the
> -	 * corresponding entries in the guest's PSC buffer.
> +	 * corresponding entries in the guest's PSC buffer and zero out the
> +	 * count of in-flight PSC entries.
>  	 */
>  	for (idx = svm->sev_es.psc_idx; svm->sev_es.psc_inflight;
>  	     svm->sev_es.psc_inflight--, idx++) {
> @@ -3581,17 +3583,22 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
>  	}
>  	hdr->cur_entry = idx;
> +}
> +
> +static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
> +
> +	if (vcpu->run->hypercall.ret) {
> +		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
> +		return 1; /* resume guest */
> +	}
> +
> +	__snp_complete_one_psc(svm);
>  	/* Handle the next range (if any). */
>  	return snp_begin_psc(svm, psc);
> -
> -out_resume:
> -	svm->sev_es.psc_idx = 0;
> -	svm->sev_es.psc_inflight = 0;
> -	svm->sev_es.psc_2m = false;
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
> -
> -	return 1; /* resume guest */
>  }
>  static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
> @@ -3601,18 +3608,20 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
>  	struct psc_hdr *hdr = &psc->hdr;
>  	struct psc_entry entry_start;
>  	u16 idx, idx_start, idx_end;
> -	__u64 psc_ret, gpa;
> +	u64 gfn;
>  	int npages;
> -
> -	/* There should be no other PSCs in-flight at this point. */
> -	if (WARN_ON_ONCE(svm->sev_es.psc_inflight)) {
> -		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
> -		goto out_resume;
> -	}
> +	bool huge;
>  	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
> -		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
> -		goto out_resume;
> +		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
> +		return 1;
> +	}
> +
> +next_range:
> +	/* There should be no other PSCs in-flight at this point. */
> +	if (WARN_ON_ONCE(svm->sev_es.psc_inflight)) {
> +		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
> +		return 1;
>  	}
>  	/*
> @@ -3624,97 +3633,99 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
>  	idx_end = hdr->end_entry;
>  	if (idx_end >= VMGEXIT_PSC_MAX_COUNT) {
> -		psc_ret = VMGEXIT_PSC_ERROR_INVALID_HDR;
> -		goto out_resume;
> -	}
> -
> -	/* Nothing more to process. */
> -	if (idx_start > idx_end) {
> -		psc_ret = 0;
> -		goto out_resume;
> +		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_HDR);
> +		return 1;
>  	}
>  	/* Find the start of the next range which needs processing. */
>  	for (idx = idx_start; idx <= idx_end; idx++, hdr->cur_entry++) {
> -		__u16 cur_page;
> -		gfn_t gfn;
> -		bool huge;
> -
>  		entry_start = entries[idx];
> -
> -		/* Only private/shared conversions are currently supported. */
> -		if (entry_start.operation != VMGEXIT_PSC_OP_PRIVATE &&
> -		    entry_start.operation != VMGEXIT_PSC_OP_SHARED)
> -			continue;
> -
>  		gfn = entry_start.gfn;
> -		cur_page = entry_start.cur_page;
>  		huge = entry_start.pagesize;
> +		npages = huge ? 512 : 1;
> -		if ((huge && (cur_page > 512 || !IS_ALIGNED(gfn, 512))) ||
> -		    (!huge && cur_page > 1)) {
> -			psc_ret = VMGEXIT_PSC_ERROR_INVALID_ENTRY;
> -			goto out_resume;
> +		if (entry_start.cur_page > npages || !IS_ALIGNED(gfn, npages)) {
> +			snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_ENTRY);
> +			return 1;
>  		}
> +		if (entry_start.cur_page) {
> +			/*
> +			 * If this is a partially-completed 2M range, force 4K
> +			 * handling for the remaining pages since they're effectively
> +			 * split at this point. Subsequent code should ensure this
> +			 * doesn't get combined with adjacent PSC entries where 2M
> +			 * handling is still possible.
> +			 */
> +			npages -= entry_start.cur_page;
> +			gfn += entry_start.cur_page;
> +			huge = false;
> +		}
> +		if (npages)
> +			break;
> +
>  		/* All sub-pages already processed. */
> -		if ((huge && cur_page == 512) || (!huge && cur_page == 1))
> -			continue;
> -
> -		/*
> -		 * If this is a partially-completed 2M range, force 4K handling
> -		 * for the remaining pages since they're effectively split at
> -		 * this point. Subsequent code should ensure this doesn't get
> -		 * combined with adjacent PSC entries where 2M handling is still
> -		 * possible.
> -		 */
> -		svm->sev_es.psc_2m = cur_page ? false : huge;
> -		svm->sev_es.psc_idx = idx;
> -		svm->sev_es.psc_inflight = 1;
> -
> -		gpa = gfn_to_gpa(gfn + cur_page);
> -		npages = huge ? 512 - cur_page : 1;
> -		break;
>  	}
> +	if (idx > idx_end) {
> +		/* Nothing more to process. */
> +		snp_complete_psc(svm, 0);
> +		return 1;
> +	}
> +
> +	svm->sev_es.psc_2m = huge;
> +	svm->sev_es.psc_idx = idx;
> +	svm->sev_es.psc_inflight = 1;
> +
>  	/*
>  	 * Find all subsequent PSC entries that contain adjacent GPA
>  	 * ranges/operations and can be combined into a single
>  	 * KVM_HC_MAP_GPA_RANGE exit.
>  	 */
> -	for (idx = svm->sev_es.psc_idx + 1; idx <= idx_end; idx++) {
> +	while (++idx <= idx_end) {
>  		struct psc_entry entry = entries[idx];
>  		if (entry.operation != entry_start.operation ||
> -		    entry.gfn != entry_start.gfn + npages ||
> -		    !!entry.pagesize != svm->sev_es.psc_2m)
> +		    entry.gfn != gfn + npages ||
> +		    entry.cur_page ||
> +		    !!entry.pagesize != huge)
>  			break;
>  		svm->sev_es.psc_inflight++;
> -		npages += entry_start.pagesize ? 512 : 1;
> +		npages += huge ? 512 : 1;
>  	}
> -	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
> -	vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
> -	vcpu->run->hypercall.args[0] = gpa;
> -	vcpu->run->hypercall.args[1] = npages;
> -	vcpu->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
> -				       ? KVM_MAP_GPA_RANGE_ENCRYPTED
> -				       : KVM_MAP_GPA_RANGE_DECRYPTED;
> -	vcpu->run->hypercall.args[2] |= entry_start.pagesize
> -					? KVM_MAP_GPA_RANGE_PAGE_SZ_2M
> -					: KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
> -	vcpu->arch.complete_userspace_io = snp_complete_psc;
> +	switch (entry_start.operation) {
> +	case VMGEXIT_PSC_OP_PRIVATE:
> +	case VMGEXIT_PSC_OP_SHARED:
> +		vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
> +		vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
> +		vcpu->run->hypercall.args[0] = gfn_to_gpa(gfn);
> +		vcpu->run->hypercall.args[1] = npages;
> +		vcpu->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
> +			? KVM_MAP_GPA_RANGE_ENCRYPTED
> +			: KVM_MAP_GPA_RANGE_DECRYPTED;
> +		vcpu->run->hypercall.args[2] |= huge
> +			? KVM_MAP_GPA_RANGE_PAGE_SZ_2M
> +			: KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
> +		vcpu->arch.complete_userspace_io = snp_complete_one_psc;
> -	return 0; /* forward request to userspace */
> +		return 0; /* forward request to userspace */
> -out_resume:
> -	svm->sev_es.psc_idx = 0;
> -	svm->sev_es.psc_inflight = 0;
> -	svm->sev_es.psc_2m = false;
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
> +	default:
> +		/*
> +		 * Only shared/private PSC operations are currently supported, so if the
> +		 * entire range consists of unsupported operations (e.g. SMASH/UNSMASH),
> +		 * then consider the entire range completed and avoid exiting to
> +		 * userspace. In theory snp_complete_psc() can be called directly
> +		 * at this point to complete the current range and start the next one,
> +		 * but that could lead to unexpected levels of recursion.
> +		 */
> +		__snp_complete_one_psc(svm);
> +		goto next_range;
> +	}
> -	return 1; /* resume guest */
> +	unreachable();
>  }
>  static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
> 
> 

