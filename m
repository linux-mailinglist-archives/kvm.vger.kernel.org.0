Return-Path: <kvm+bounces-16084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C2B8B4222
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 00:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80B671F23345
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 22:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8D738F82;
	Fri, 26 Apr 2024 22:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dv8sWoXE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FCE2C1B9;
	Fri, 26 Apr 2024 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714170318; cv=fail; b=MLeKFx/Rs3kAeNKKP08M9Coj37rNzT4ts8Y/E20Hgu9PAiE4oPG8WioMfluCqFrdJH9uh0XjRNoKV7jdufuScAcj43ksRid3sQLIHD+oH+PI+t9o1bTqYPQBd7ydYbRoTB1ZmRPCOS/Sz4qMHBxBPhvM0RFVO2jJZDeXN9XNBxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714170318; c=relaxed/simple;
	bh=gAABwnblJkv/7+4mOBba10/6l7+GNsX1u1ddSDkQHgk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m9SXglH6aGMiwPmAcvxJ3zEteaVgcrpgxi8+L1uZ31LpN8YKpUbSxBKdluJZO2DRhf89l+P9KKTbywM7i74/MoRn/EhlTu4zr7h00BfUUyp0NjVUdu2wljKPEG4AdqtjsDRZ2ik3j6w+9MF40N+MDyytb/bBeDpUXAYpQH3WTso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dv8sWoXE; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSoM1Y7w10E+YQ6zlU/WObs9GY2br1wm+/6LilJJ0dJjeQAqvN4BEZP8oHNWtcBFCmTCcOEufUtk95HI1WUwnvW06w31XRyJSEfayuG6bgUK+t/dj9DMJZFnwTUT20Zj4U6pHgs6LjmNqcUCHnkJqCBFOKFf56yafNhipI81u8D+mwiwh1vgeMxGVPrRR9jgwPagM6VRgEalEhN7x+ASJKcIXgTGENr8a9YHQRRoCuqsAlqCDkxRDEvfzcVECiz58Y94hTg6fvMcUAiK8/ldmoUY14xFrszn/2HMJpoVohGlMAvSXad41PL4H1J2xc4RMZ02rKQFR0WWKv0evkIxNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uo/rcYMiAqlLOAfMQoYK2o7sIQzc0lr+8zZ+ExATrOw=;
 b=Awr5uUucyyZ13IF/alkMos2ZOt3tolrGOAc9y/3Qk3nuKLt0/PLHdRWBVyE2NJ8Y7EGwQgUxZlTs8kIDXzHGIkABhGeEjKPqWpyFl3Md9yoW5XTOQ7kgcM0YaNn6aQQJ4yiiPOo4+xZERnCxX++bbBgggXfOtPqJAnu4zghFCsHJH/D9SwM7PnwparEOuYlkBpRxIETMfpf7V2a3csRWBAzW+q8b6QzjJgOp2ysPccIUOBlLnuaPu5ZBwHSCtty4FSUTBqh7pd1ZnBxql88jDOEGVHgBULRwASfMZJoVEQXQeX2Q5QpNjRcqQU1AfWANvykcbs4Od/GXCYT4eRTsqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uo/rcYMiAqlLOAfMQoYK2o7sIQzc0lr+8zZ+ExATrOw=;
 b=Dv8sWoXEX5QHHx6WkF+/a14IAKLYGs7QMgUaesQ8qnBxky2OQuk9grDB8yKbxeyEJvWzJP8wpmXwdLoYAEoKspn8S8XnGsKfxWwFkQXGK4HiPSsGibazHl/gj/AUcNFLoFVVPH4ni8o+Mfb6AW3ECFg2z1fCDev/QaMt9BeLKes=
Received: from CH0PR03CA0406.namprd03.prod.outlook.com (2603:10b6:610:11b::14)
 by DS7PR12MB6336.namprd12.prod.outlook.com (2603:10b6:8:93::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.46; Fri, 26 Apr 2024 22:25:12 +0000
Received: from CH1PEPF0000A347.namprd04.prod.outlook.com
 (2603:10b6:610:11b:cafe::77) by CH0PR03CA0406.outlook.office365.com
 (2603:10b6:610:11b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.29 via Frontend
 Transport; Fri, 26 Apr 2024 22:25:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A347.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Fri, 26 Apr 2024 22:25:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 26 Apr
 2024 17:25:10 -0500
Date: Fri, 26 Apr 2024 17:24:57 -0500
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
Message-ID: <20240426222457.7yn66athor2jxsrj@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-10-michael.roth@amd.com>
 <ZilyxFnJvaWUJOkc@google.com>
 <20240425220008.boxnurujlxbx62pg@amd.com>
 <ZirVlF-zQPNOOahU@google.com>
 <20240426171644.r6dvvfvduzvlrv5c@amd.com>
 <ZiwLKI_xtZk3BG_B@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZiwLKI_xtZk3BG_B@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A347:EE_|DS7PR12MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c88abb9-92f5-4003-f830-08dc663fbcfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ug+GTrgVwoFcfEQ+S1njCsuZcJp7w4aTjim5krz+1yHO8cI5lw0oAv82VIY/?=
 =?us-ascii?Q?VYMkd/wjo2fXCQej61bCJVkRJ7feMPdiJzuoxR+y4XBilo9WhEBUK9EBdVSM?=
 =?us-ascii?Q?h4nXQGr3RF1Okffcc36yfpV71gbmVmr8WEPk3SvlNgWlHK+SVCuwSOoxzPVK?=
 =?us-ascii?Q?ShggUQr6ZxjcumyVxdZRwQMFPoCl1TsbqLJHcJ+XoEqJTPF1l1/ZlNH/WxBb?=
 =?us-ascii?Q?YYZ6YXMSFeDeFCmk+8u0e8+X1dQDZN7V6DTKAuJCLuPZ1Oyvz6HXg9gUamPM?=
 =?us-ascii?Q?2xDiWZAPhlnDXqLUovtbm4dgGEt3IxswovofS/MkiTEfNuHHbqIVgyfamcYw?=
 =?us-ascii?Q?u7kS5CFDbfWc0ZZ+qoGuX0ZJtgCTN7shubLXgCictbqWbgIwUrcdNcLc59n6?=
 =?us-ascii?Q?yp6Q9quyQncTWTWMWHiWQO29u8kofBrCVAahgQ4vZXEs76h+cltIZq8U8sXI?=
 =?us-ascii?Q?0w02CW7SIf6YfxzcNxAqytWS41LGsOrc3V+tmdY4Hhv2hxglk2hWizh132g5?=
 =?us-ascii?Q?W5n3tgpCWIZz1eDzyPqBph6sxxJ/ZJmnXkER7ExDgdukivpz4/kWZjWA/Sbc?=
 =?us-ascii?Q?xSRBb7CGZui4/G7rhexF0UfoekM2jAkh38Hbo0kaB9XA0Vx5gNb/Gt8P24Ps?=
 =?us-ascii?Q?r2lGCZJbIO86pTwLd8aEBcSirI/O/GooPheB8CNZu1o687Ykxsh2he+R3Yjv?=
 =?us-ascii?Q?p9ABli+E+CTm2LqnYEzbLDL5xHwCycrT4w+QrgsmhA0h28TbKXYLzESXidGE?=
 =?us-ascii?Q?KcXgjBSuWy+eOexAyy26smol8+jX4bYj55lckrDmpYbaXzp2zl3VdmRr+EHr?=
 =?us-ascii?Q?tmd5Pws7k9mau5nOKhum5BqSdgNQxwvqoWZOEP7AwC/KmmxR9VOgzlO3+pGu?=
 =?us-ascii?Q?thyroQGXGzPiXMr7aS7y8Z4DDzeApHgFA/9ZiMoJwLlCqPa9FKNnrdbkHbiq?=
 =?us-ascii?Q?zdPYj22GLH0wHd2i1JMIY3y0aeiKgzbCCI7oxP4N9i7+Z67N4y6nGNGRmD78?=
 =?us-ascii?Q?BTDPuUXVsnpRFCx+4KjhliqY0ChJSMtZc55Ddy5hAKFsO/k6zLYR99YG8yDh?=
 =?us-ascii?Q?4yIdzYu1cqFRCX2lbLO6GElt3fQ7BehrjBKGK3OCZb8j7pEKN7/ktgmuilAr?=
 =?us-ascii?Q?JVCYV9Bt0sycAaeFCkaaAWn8RQRh5C6zRIivJGsLqoIRMa2aYypiTQiY/B7q?=
 =?us-ascii?Q?kqwOtOkpKQ1aCXhvKBhENpPqOXyv7WLRGDY0vBYGPqsdy6+xUFs3rSJSnMQJ?=
 =?us-ascii?Q?/o7V+O1pVbUtmsbUiDBpqq/cXaYsVGvZoqSkF9oXzTfJlvs5v7iwvYyScO1W?=
 =?us-ascii?Q?eSQAeyM7GsU0evoQ4xj06x87HTnJs0uapfwBHXXg3X/szVp88fKvzKDHO0Gf?=
 =?us-ascii?Q?KOrhKIKTEpHk2Qcyo9vcUf9NlZEv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 22:25:11.8745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c88abb9-92f5-4003-f830-08dc663fbcfb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A347.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6336

On Fri, Apr 26, 2024 at 01:14:32PM -0700, Sean Christopherson wrote:
> On Fri, Apr 26, 2024, Michael Roth wrote:
> > On Thu, Apr 25, 2024 at 03:13:40PM -0700, Sean Christopherson wrote:
> > > On Thu, Apr 25, 2024, Michael Roth wrote:
> > > > On Wed, Apr 24, 2024 at 01:59:48PM -0700, Sean Christopherson wrote:
> > > > > On Sun, Apr 21, 2024, Michael Roth wrote:
> > > > > > +static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
> > > > > > +{
> > > > > > +	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
> > > > > > +	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
> > > > > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > > > > +
> > > > > > +	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
> > > > > > +		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
> > > > > > +		return 1; /* resume guest */
> > > > > > +	}
> > > > > > +
> > > > > > +	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
> > > > > > +	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC_MSR;
> > > > > > +	vcpu->run->vmgexit.psc_msr.gpa = gpa;
> > > > > > +	vcpu->run->vmgexit.psc_msr.op = op;
> > > > > 
> > > > > Argh, no.
> > > > > 
> > > > > This is the same crud that TDX tried to push[*].  Use KVM's existing user exits,
> > > > > and extend as *needed*.  There is no good reason page state change requests need
> > > > > *two* exit reasons.  The *only* thing KVM supports right now is private<=>shared
> > > > > conversions, and that can be handled with either KVM_HC_MAP_GPA_RANGE or
> > > > > KVM_EXIT_MEMORY_FAULT.
> > > > > 
> > > > > The non-MSR flavor can batch requests, but I'm willing to bet that the overwhelming
> > > > > majority of requests are contiguous, i.e. can be combined into a range by KVM,
> > > > > and that handling any outliers by performing multiple exits to userspace will
> > > > > provide sufficient performance.
> > > > 
> > > > That does tend to be the case. We won't have as much granularity with
> > > > the per-entry error codes, but KVM_SET_MEMORY_ATTRIBUTES would be
> > > > expected to be for the entire range anyway, and if that fails for
> > > > whatever reason then we KVM_BUG_ON() anyway. We do have to have handling
> > > > for cases where the entries aren't contiguous however, which would
> > > > involve multiple KVM_EXIT_HYPERCALLs until everything is satisfied. But
> > > > not a huge deal since it doesn't seem to be a common case.
> > > 
> > > If it was less complex overall, I wouldn't be opposed to KVM marshalling everything
> > > into a buffer, but I suspect it will be simpler to just have KVM loop until the
> > > PSC request is complete.
> > 
> > Agreed. But *if* we decided to introduce a buffer, where would you
> > suggest adding it? The kvm_run union fields are set to 256 bytes, and
> > we'd need close to 4K to handle a full GHCB PSC buffer in 1 go. Would
> > additional storage at the end of struct kvm_run be acceptable?
> 
> Don't even need more memory, just use vcpu->arch.pio_data, which is always
> allocated and is mmap()able by userspace via KVM_PIO_PAGE_OFFSET.

Nice, that seems like a good option if needed.

> 
> > > > KVM_HC_MAP_GPA_RANGE seems like a nice option because we'd also have the
> > > > flexibility to just issue that directly within a guest rather than
> > > > relying on SNP/TDX specific hcalls. I don't know if that approach is
> > > > practical for a real guest, but it could be useful for having re-usable
> > > > guest code in KVM selftests that "just works" for all variants of
> > > > SNP/TDX/sw-protected. (though we'd still want stuff that exercises
> > > > SNP/TDX->KVM_HC_MAP_GPA_RANGE translation).
> > > > 
> > > > I think we'd there is some potential baggage there with the previous SEV
> > > > live migration use cases. There's some potential that existing guest kernels
> > > > will use it once it gets advertised and issue them alongside GHCB-based
> > > > page-state changes. It might make sense to use one of the reserved bits
> > > > to denote this flavor of KVM_HC_MAP_GPA_RANGE as being for
> > > > hardware/software-protected VMs and not interchangeable with calls that
> > > > were used for SEV live migration stuff.
> > > 
> > > I don't think I follow, what exactly wouldn't be interchangeable, and why?
> > 
> > For instance, if KVM_FEATURE_MIGRATION_CONTROL is advertised, then when
> > amd_enc_status_change_finish() is triggered as a result of
> > set_memory_encrypted(), we'd see
> > 
> >   1) a GHCB PSC for SNP, which will get forwarded to userspace via
> >      KVM_HC_MAP_GPA_RANGE
> >   2) KVM_HC_MAP_GPA_RANGE issued directly by the guest.
> > 
> > In that case, we'd be duplicating PSCs but it wouldn't necessarily hurt
> > anything. But ideally we'd be able to distinguish the 2 cases so we
> > could rightly treat 1) as only being expected for SNP, and 2) as only
> > being expected for SEV/SEV-ES.
> 
> Why would the guest issue both?  That's a guest bug.  Or if supressing the second
> hypercall is an issue, simply don't enumerate MIGRATION_CONTROL for SNP guests.

At the time of its inception, KVM_HC_MAP_GPA_RANGE was simply
KVM_HC_PAGE_ENC_STATUS and got a more generic name over the course of
development. But its purpose never changed: to inform the hypervisor of
the current encryption status of a GPA range so VMMs could build up a
list of shared guest regions that don't need to go through firmware for
migration.. And it was and still is asynchronous to a degree, since the
the migration control MSRs signals when that list of shared pages is
usable.

These are very different semantics the proposal to use KVM_HC_MAP_GPA_RANGE
as a means to set memory attributes via KVM_SET_MEMORY_ATTRIBUTES, and
the 2 purposes aren't necessarily mutually exclusive to one another. It
only really becomes a bug if we begin to interpret the original use-case
as something other than it's initial intent in the case of SNP.

But at the same time, it's hard to imagine this older SEV live migration
use-case being useful for SNP, since userspace will necessarily have all
the information it needs to determine what is/isn't shared with relying
on an additional hypercall.

So treating the older use case as specific to non-SNP and disallowing the
use of MIGRATION_CONTROL does seems reasonable. But it's really the CPUID
bit that advertises it, SEV just happens to only use it for when
MIGRATION_CONTROL is also advertised. So we could disable that as well,
but I did like the idea of being able to handle guest-issued
KVM_HC_MAP_GPA_RANGE calls even with SNP/TDX enabled, which is less of an
option if we can't advertised KVM_HC_MAP_GPA_RANGE via cpuid. But I
suppose we could do that with KVM selftests which is probably where
that's more likely to be useful.

-Mike

