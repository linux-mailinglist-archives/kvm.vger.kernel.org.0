Return-Path: <kvm+bounces-20562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E04D918733
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 18:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C73CEB27E83
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 16:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98E119069E;
	Wed, 26 Jun 2024 16:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jPxUpbne"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2073.outbound.protection.outlook.com [40.107.101.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034C618EFCC;
	Wed, 26 Jun 2024 16:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719417951; cv=fail; b=HzepSE/bqAUYWgPrXcoVCkVPvMrOgQagDF8ZL8qySY1Sd2UjZb+m40gV3zXIqvQBILIe4OQyn3pGqQWNYoWo+pWunu4ujGmR1LMpmYUZAr/lF4aquJtsX4usvgxjhL+FcVzornX6VCvUU0UZRoOmCYnpma9Rylw7DmC9ZttH18U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719417951; c=relaxed/simple;
	bh=AXu54D/7jELgZgHjOi61LLDAgmkQxRAZClCSabRf2Qk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pyWy0IC90zfyXpF9HotclA11Bu7kxsQ+jmfC35wbik9WALBNPcFjXZIMFlY5neacotADY16rA3Co+FHcflX/QnC867+gT35bjfUp1f2jnlrnw4wPiMA+ARjdnjoCYX7G0zZCI6oM0EAFFWDqpDCqD7Uv16rozCl4VhEB2NPKRBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jPxUpbne; arc=fail smtp.client-ip=40.107.101.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1Gmdm2y1TnJYH0Bf+KOn/l0bAPtMkvjuBc9WCHXNcNJHhFuB7Qn+4MeLnRFWS1+7uBuUpuIOxeOTO1138kOOCqFHZLuQZkuN4arwGtpa8q5aunuPF1U3V6N+wUJ4yNY3r4LyyTKNO/TMwe6ESw+9kk6vgljIuqteS6D3U5iSYsyFP+H2oWsfek8I4rZTaZ/G92TLuYv/XL/DFZIkaERHb7KLLkhAvQxLri/I94cYPOMI81nnfkchpVaIEukRfI1ws4EfCk28befsahwtzoLeBSthtukWTJ721oq8TwhTqJNHuDCkmiQRSoI7RxmWdwxuQB1zkarv6OIaQJiTrn58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9P0ypJwcNpn/YgqlAdOGUPPzj65wPYbQ+XAKrvOGT0=;
 b=l8/Pg4AgmBG6ZGgu8qV/FKXtrY7/8T9nTGLwEguBrg5szzA0eGp75RxEU95yFFw1PJPLZPGZtfEAL8SNWsmcY+f7FgsKQsSTBa9SEAhFgfUriG+1vVLD/Qdf8xK9TXIk8emYATjCKHj0IpH30wkp40MrVuwBYgaHQmKNmCGshq6z0yB2LzNa7HPekd5g3vPjf+oaH6SLFk9XJoRFFEWp9qLea23+o2eFxKcYoMgMO26ESANZQFuH+g3I1Z5aLmq3p69cwAyzfO+v0y4rgRXu1Fu0qEU+gwq0lb8ol4sSlYZGm+qw1GznsWiYCYHg4fUVGG4prwjDB2h08RwiL14f3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9P0ypJwcNpn/YgqlAdOGUPPzj65wPYbQ+XAKrvOGT0=;
 b=jPxUpbnej7mGduuUUmjHiM8KYMdAT04g5HOw4RfuvscleItpiLA8agsm7C442AlNH000UQnQ3GeqbwBhs2/oZda+UhX0YMG2kAjQe91B93zEvS5lmAlCdu9F6T5nudXOOumxdY5LWyXOCFC1mrPkFC9tyQ5sZzUZfdAKlCfPDyI=
Received: from PH8PR20CA0024.namprd20.prod.outlook.com (2603:10b6:510:23c::19)
 by MN0PR12MB5835.namprd12.prod.outlook.com (2603:10b6:208:37a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Wed, 26 Jun
 2024 16:05:42 +0000
Received: from SJ1PEPF0000231B.namprd03.prod.outlook.com
 (2603:10b6:510:23c:cafe::91) by PH8PR20CA0024.outlook.office365.com
 (2603:10b6:510:23c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.24 via Frontend
 Transport; Wed, 26 Jun 2024 16:05:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231B.mail.protection.outlook.com (10.167.242.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Wed, 26 Jun 2024 16:05:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Jun
 2024 11:05:38 -0500
Date: Wed, 26 Jun 2024 10:45:31 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <pbonzini@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, Brijesh Singh <brijesh.singh@amd.com>, "Alexey
 Kardashevskiy" <aik@amd.com>
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Message-ID: <6sczq2nmoefcociyffssdtoav2zjtuenzmhybgdtqyyvk5zps6@nnkw2u74j7pu>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-2-michael.roth@amd.com>
 <ZnwecZ5SZ8MrTRRT@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZnwecZ5SZ8MrTRRT@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231B:EE_|MN0PR12MB5835:EE_
X-MS-Office365-Filtering-Correlation-Id: 724cb405-bf59-401c-2b42-08dc95f9d31f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230038|36860700011|376012|7416012|1800799022|82310400024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8kZJsQddM7zs1YUEj8UMMOlPqfmoXxAux1xsRdW7Y8RBGH0454UxcMEeA+Wp?=
 =?us-ascii?Q?mSwLxgljwNIU+Dqbraqer6PXqyM7JuOJp/xJrEhQ1gJ550N80fSAEiiaEJU2?=
 =?us-ascii?Q?7Qt2kTGOpZMWuFiGTLuFD0iivjj+YwQF5RkcSeIbF9nHGeH4BI9i/j/5VhnT?=
 =?us-ascii?Q?IMSUFBDAg6Gas6F3mLxr4bFnjSixrwSV7teFgkEu55MbLH8OlnkYi/+W/2FO?=
 =?us-ascii?Q?fipAel1/l1yxhskOJj/MjbS0KLlmo1NtYm1C1OXOdakSF1O4ZukopqziRmH/?=
 =?us-ascii?Q?xBQ1dcOYHsU8kiHUfUXc49JnI7b8ZnQOMsJuSzP91Ht7BjVAX2A9uUTPj7O1?=
 =?us-ascii?Q?0Z8rZ79Rv+v8LV17PQzRw7cDuOrEzjKcSIaloQ6VF/sO2Y2snJAHIq9eLyIo?=
 =?us-ascii?Q?ZKCzbspXimcdTHpOsTqZKrd9F33utbKCPdy3HC0A5PQEcc4IZW4zd44Q05K6?=
 =?us-ascii?Q?cj1mWAsFIPqMVE7RYf4dEKB5PwC8wDALsPiPN5LCP4U9rL3217Fi6wkw0Bzu?=
 =?us-ascii?Q?eAyNZbJMVa1foeHlfBzxVbrkdWSRbQ6X/3HfseOO+EvuK4+Dv59iWYm6lWVI?=
 =?us-ascii?Q?HLDM8MZaI8AGx9jwdV7eHI4SdxwIbFhHTHid91QniulM5l+HD6C9WHF0qqtd?=
 =?us-ascii?Q?Rvu+ix2s8AiWUApoKqKI2ip1uvfpOP9G1XK3AnxaGGf5KlVgu+RLS4dlNS5W?=
 =?us-ascii?Q?sJUaFrTb3+f/yg/OxXCmzOmBppUE3X6lAgs7Vh8kcbtYyludysBtEWaigdMx?=
 =?us-ascii?Q?K8TfM8E7lgvr68EgXRgrL7lzRmRSyOi7SUtouUSJ7C+4iB1N/N1qMTHQ6El2?=
 =?us-ascii?Q?y7m6nQusRo7vVDVXdoWa8YOBb3VSTKgegcMiU+T6vzX3wHKtBeLopJc8u32I?=
 =?us-ascii?Q?1elbHQJy2T3q34t2cUgXb1MCkuGvOffFoN335F7z2qnxu1Vm0CgH4JpyeaYK?=
 =?us-ascii?Q?N9RlL7BWKH55oWvwhiyQyjCGf2VhsFYW62sA51uI/SWCc+XGCbIlMukhECQz?=
 =?us-ascii?Q?eAugdY3nNlrNdonh1O8Q5ULJSjqO6vybbVWBfOs8quzV36sMpVgQgZ5Tc61U?=
 =?us-ascii?Q?9KVNBJXpmO6l924paLpfCT6XBM/j+jsH7lSoAwW8EimUaLsGwbjc+0z/2I4n?=
 =?us-ascii?Q?Oa5WFKtsdpFAzsrDg5vJmeXRGIKQF7q12+AP9bcfNZoxzF80N/VItFjPJLX4?=
 =?us-ascii?Q?QCe7WIbxO/Ch3psaLJvZJyBbe/yBS4D9P9uqAPxVZWodeSZThgXGtrpzcora?=
 =?us-ascii?Q?/MABli52L10SWPsesvSeuEqFKmOQcxOXEG6V0xFN6Kdq5auWHYuQxkLnf54l?=
 =?us-ascii?Q?jUPGiuw6kxnDydTXtpnBzdTvSqqxw1kY8eVPS8X5SRc9JPtOlJbEDM3Lm/qy?=
 =?us-ascii?Q?+NqnY4g=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230038)(36860700011)(376012)(7416012)(1800799022)(82310400024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 16:05:39.9792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 724cb405-bf59-401c-2b42-08dc95f9d31f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5835

On Wed, Jun 26, 2024 at 06:58:09AM -0700, Sean Christopherson wrote:
> On Fri, Jun 21, 2024, Michael Roth wrote:
> > @@ -3939,6 +3944,67 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
> >  	return ret;
> >  }
> >  
> > +static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> > +{
> > +	struct sev_data_snp_guest_request data = {0};
> > +	struct kvm *kvm = svm->vcpu.kvm;
> > +	kvm_pfn_t req_pfn, resp_pfn;
> > +	sev_ret_code fw_err = 0;
> > +	int ret;
> > +
> > +	if (!sev_snp_guest(kvm) || !PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
> > +		return -EINVAL;
> > +
> > +	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
> 
> This is going to sound odd, but I think we should use gfn_to_page(), i.e. require
> that the page be a refcounted page so that it can be pinned.  Long story short,
> one of my learnings from the whole non-refcounted pages saga is that doing DMA
> to unpinned pages outside of mmu_lock is wildly unsafe, and for all intents and
> purposes the ASP is a device doing DMA.  I'm also pretty sure KVM should actually
> *pin* pages, as in FOLL_PIN, but I'm ok tackling that later.
> 
> For now, using gfn_to_pages() would avoid creating ABI (DMA to VM_PFNMAP and/or
> VM_MIXEDMAP memory) that KVM probably doesn't want to support in the long term.

That seems reasonable. Will switch this to gfn_to_page().

> 
> [*] https://lore.kernel.org/all/20240229025759.1187910-1-stevensd@google.com
> 
> > +	if (is_error_noslot_pfn(req_pfn))
> > +		return -EINVAL;
> > +
> > +	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> > +	if (is_error_noslot_pfn(resp_pfn)) {
> > +		ret = EINVAL;
> > +		goto release_req;
> > +	}
> > +
> > +	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
> > +		ret = -EINVAL;
> > +		kvm_release_pfn_clean(resp_pfn);
> > +		goto release_req;
> > +	}
> 
> I don't see how this is safe.  KVM holds no locks, i.e. can't guarantee that the
> resp_pfn stays private for the duration of the operation.  And on the opposite

When the page is set to private with asid=0,immutable=true arguments,
this puts the page in a special 'firmware-owned' state that specifically
to avoid any changes to the page state happening from under the ASPs feet.
The only way to switch the page to any other state at this point is to
issue the SEV_CMD_SNP_PAGE_RECLAIM request to the ASP via
snp_page_reclaim().

I could see the guest shooting itself in the foot by issuing 2 guest
requests with the same req_pfn/resp_pfn, but on the KVM side whichever
request issues rmp_make_private() first would succeed, and then the
2nd request would generate an EINVAL to userspace.

In that sense, rmp_make_private()/snp_page_reclaim() sort of pair to
lock/unlock a page that's being handed to the ASP. But this should be
better documented either way.

> resp_pfn stays private for the duration of the operation.  And on the opposite
> side, KVM can't guarantee that resp_pfn isn't being actively used by something
> in the kernel, e.g. KVM might induce an unexpected #PF(RMP).
> 
> Why can't KVM require that the response/destination page already be private?  I'm

Hmm. This is a bit tricky. The GHCB spec states:

  The Guest Request NAE event requires two unique pages, one page for the
  request and one page for the response. Both pages must be assigned to the
  hypervisor (shared). The guest must supply the guest physical address of
  the pages (i.e., page aligned) as input.

  The hypervisor must translate the guest physical address (GPA) of each
  page into a system physical address (SPA). The SPA is used to verify that
  the request and response pages are assigned to the hypervisor.

At least for req_pfn, this makes sense because the header of the message
is actually plain text, and KVM does need to parse it to read the message
type from the header. It's just the req/resp payload that are encrypted
by the guest/firmware, i.e. it's not relying on hardware-based memory
encryption in this case.

Because of that though, I think we could potential address this by
allocating the req/resp page as separate pages outside of guest memory,
and simply copy the contents to/from the GPAs provided by the guest.
I'll look more into this approach.

If we go that route I think some of the concerns above go away as well,
but we might still need to a lock or something to serialize access to
these separate/intermediate pages to avoid needed to allocate them every
time or per-request.

> also somewhat confused by the reclaim below.  If KVM converts the response page
> back to shared, doesn't that clobber the data?  If so, how does the guest actually
> get the response?  I feel like I'm missing something.

In this case we're just setting it immutable/firmware-owned, which just
happens to be equivalent (in terms of the RMP table) to a guest-owned page,
but with rmp_entry.ASID=0/rmp_entry.immutable=true instead of
rmp_entry.ASID=<guest asid>/rmp_entry.immutable=false. So the contents remain
intact/readable after the reclaim.

> 
> Regardless of whether or not I'm missing something, this needs comments, and the
> changelog needs to be rewritten with --verbose to explain what's going on.  

Sure, will add more comments and details in the commit msg for v2.

> 
> > +	data.gctx_paddr = __psp_pa(to_kvm_sev_info(kvm)->snp_context);
> > +	data.req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
> > +	data.res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
> > +
> > +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
> > +	if (ret)
> > +		return ret;
> 
> This leaks both req_pfn and resp_pfn.

Yes, this one should be fixed up by the v1-revised version of the patch.

Thanks!

-Mike

> 
> > +
> > +	/*
> > +	 * If reclaim fails then there's a good chance the guest will no longer
> > +	 * be runnable so just let userspace terminate the guest.
> > +	 */
> > +	if (snp_page_reclaim(kvm, resp_pfn)) {
> > +		return -EIO;
> > +		goto release_req;
> > +	}
> > +
> > +	/*
> > +	 * As per GHCB spec, firmware failures should be communicated back to
> > +	 * the guest via SW_EXITINFO2 rather than be treated as immediately
> > +	 * fatal.
> > +	 */
> > +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > +				SNP_GUEST_ERR(ret ? SNP_GUEST_VMM_ERR_GENERIC : 0,
> > +					      fw_err));
> > +
> > +	ret = 1; /* resume guest */
> > +	kvm_release_pfn_dirty(resp_pfn);
> > +
> > +release_req:
> > +	kvm_release_pfn_clean(req_pfn);
> > +	return ret;
> > +}

