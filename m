Return-Path: <kvm+bounces-16085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 594098B425A
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 00:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D90F21F22340
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 22:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDDC3A8E4;
	Fri, 26 Apr 2024 22:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K3F41UGP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B673BBC1;
	Fri, 26 Apr 2024 22:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714171740; cv=fail; b=bYkOkdNKQ4VtULQn4Nnc1kbWBUTg8Ke4ggLE6e097++OW+zq6N2J3Iz/Qm4VjLzgKguy8AN9dnSoUgjxM4nklqR4VprdH6kyP2+w2BIPDyZ6n+HT2MokIpddU5TcTnsWJZFEEu0bGYEZRB9gflt93deqQ/On/8ydX27h1M2D/P4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714171740; c=relaxed/simple;
	bh=wA8pBnm8GqboOGhP27o4koppyYQKsrIBzrWzYaI0CJA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts69Hshy78DlKh9/d2ZHLaZaCNvuRLh9i1wxpkqdJ8P6LKMYk6kU8FVslSbylKd7Dm+S1O+oOix9AyUSpjzTi4t3zqHPco6Pf0sDK/Fx/+wMXN1P6xD9HceZaZI19Uu+7YLf7E46MGpgXuXSxzHMRDA4AjifDdHHNyUgCxUxXKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K3F41UGP; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6/kOjsUN89l60kngPEamqdv4XmGZOKsRl0SHf6hnaG1Tkkn2zH+5ZGH4JSKty595KnH0/WbKSzJClHGABuRO2xp7VDl+NOcGKLfDNeDOwzPXWTEYEzLVprg9kXwLKVQymkkpwtJrFaYI6pnFoea2mAi06orIyR6xEI0slK+4DH9i4BegfTPZ+TnuH8uP3UrIjqZAamKVicPUVuOpkXlu7Z0WMJHHKaVhPk9bnd6yVeTbWfRjoXsbC83F0KGiGEQCcKy8y8rm7NgBneIhqyABjvzQr4LaFmaE5oPJTFaiWJx9875K6GpZhC4r03gJ5vzJeAuGcbdzw8pYMWldcWiTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PyXRteb8TGejSxCcD9pkBa6lgrH1J4l6vEFfBSlZ8no=;
 b=frZwboUcCX5scYK24tdAcL3oYyQ+m9Bs8fMRxpLrIo+EEphwc4W1rXHpoWktWXdX6mXp1KU42EyT3kYdo9gp3gPQdj12ICJYI8S7b9cUG3tQ2yAuI/vXWn5Gi6jEIvwdz/YuqMgB4klpnKtjsQzuYrbz/NIfQ91vokEhNorEh/cZEDdYl5SPB5CXRU77CMeZoNATW9AC1NygbmiIfySejfXSBv39gyqiui/zKvE1Tg7jP9LCZoOlPTZH8dsbMFrM6Sn2HNW9y2UbTUqROOk4HBeLrDAvXIfXIhgT7niP2DqEtnQgY2/mqcaJRlIGng5V/g1g30YqQXXab+anS2uMuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PyXRteb8TGejSxCcD9pkBa6lgrH1J4l6vEFfBSlZ8no=;
 b=K3F41UGPbRIdQdxfY3pHWg1MpJdnfUjc8L1gw+c6HsdLCZgKQfbSUsSYeHkgbt7N8jU+uZBaf46nqNnr9MkzJMSd3B0YIsROApH1Xpqtd1B0XomCqYVRplDt4iBhxA/zdPAfm1m5soLIFr9tWA59+/4+16HMP+0TjXaLYlc95eY=
Received: from MW4PR04CA0282.namprd04.prod.outlook.com (2603:10b6:303:89::17)
 by PH7PR12MB7966.namprd12.prod.outlook.com (2603:10b6:510:274::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.31; Fri, 26 Apr
 2024 22:48:42 +0000
Received: from CO1PEPF000044FA.namprd21.prod.outlook.com
 (2603:10b6:303:89:cafe::dc) by MW4PR04CA0282.outlook.office365.com
 (2603:10b6:303:89::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.26 via Frontend
 Transport; Fri, 26 Apr 2024 22:48:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.0 via Frontend Transport; Fri, 26 Apr 2024 22:48:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 26 Apr
 2024 17:48:41 -0500
Date: Fri, 26 Apr 2024 17:48:26 -0500
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
Message-ID: <20240426224826.q53obbzjzhp6lrme@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-10-michael.roth@amd.com>
 <ZilyxFnJvaWUJOkc@google.com>
 <20240425220008.boxnurujlxbx62pg@amd.com>
 <ZirVlF-zQPNOOahU@google.com>
 <20240426171644.r6dvvfvduzvlrv5c@amd.com>
 <ZiwLKI_xtZk3BG_B@google.com>
 <20240426222457.7yn66athor2jxsrj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240426222457.7yn66athor2jxsrj@amd.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FA:EE_|PH7PR12MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b1e6cd7-4ba7-4087-2438-08dc664305c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400014|36860700004|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TkBdWpqlRuHzI9qp+E63HTk/SqMQxuFw03oif1fAKbkiovD8Gw6q2uW25H3v?=
 =?us-ascii?Q?uUkv6SAVh1ht5C9CtAj2fP4nSd9Ge1QmejPnT41Aq1yroXtiq61XNvxYr5eJ?=
 =?us-ascii?Q?C694O3N0ndzGJLODDSyqIY8KT95YZ3X9LPu3Wy3RELmHhC8aGzfqTtVw/d2e?=
 =?us-ascii?Q?bP0iSsi+TAXQYbC218c9ZJd/msbO+aPgbAuAoCIUhWMKvQGzVvJ5qnolBzPi?=
 =?us-ascii?Q?FcXsTl0aYTpozdHXTM9hxpnOcbmSDQOiTrcLhJtgEHOn+RDpwNSQz93ztY/m?=
 =?us-ascii?Q?Zwn5vo9Dg5i1E+iae4ConI+dwBlltt3T+gDSDFM+4UxozlzMPgr5Rsfc+Dt1?=
 =?us-ascii?Q?WmsRG5DO4TrlSxHG4BrAnP210oj7CIAny6juTlk/EwU8xl2d/u/y5/khm1La?=
 =?us-ascii?Q?Szx9AX16J9VN+/07W6ZaOE1SEUowKswvRdFN/F4Np4B3FV/RDhzT5ganNyKk?=
 =?us-ascii?Q?8z4cmBvcVNaFEDWvr4iTuDWV6O22vs8cCQXIOf3Y5gbmVV8kOVDH6e1L37+F?=
 =?us-ascii?Q?y7lSXnQOVwLh2PbJz8rgQzhaQwUJGAbHmbmU5o1j7IxxLZHCVlJ2gXx0lYaQ?=
 =?us-ascii?Q?LhC9IlODJS6mlkhObk+mHSkcOqmdsdeoT6SWASdFdHUm43YZsRPieRSsDduK?=
 =?us-ascii?Q?sn4JbjkiBXei1YdyaYLn+hcTD8IAcTY9D7cK9AAjrKzk8PL2tmkHcREK+4kL?=
 =?us-ascii?Q?m6MwA35+sL5M6hTadx+DP2Zj25hNuIzOWETI4xzxTLqzxjYfjbPIpvxmnUGj?=
 =?us-ascii?Q?WX/eW2AGGjz+P4+MF2cIeeS1hoUK/5V7Qz0tv0m535ldWGy1BQbPmjO2Z+3r?=
 =?us-ascii?Q?AXYRA2CwWNbQqni0zYPmoUH1IkAdWQbiVF0HJpBSgzaybKclo4+HyCM2qoLU?=
 =?us-ascii?Q?f2EEJpZ/gDB16JynxiR7zcO767r1B3EVH6gO7CAZ4uVSVycrY4eTtOnCEpIf?=
 =?us-ascii?Q?9urYI3CbbE5i33IrcTxJcyhmX5VHAdL0Ihnfqs88miar0Si4p1qdDF3apbSP?=
 =?us-ascii?Q?cwdcXXeUz0Q6Liz2jl7YwBJHVP8wUigXFEbyqUJoKWWadK8BQU1hXcOp6uhR?=
 =?us-ascii?Q?7nS4IGxyyEhXuANAIE4LLKNC6dBW1fAoJpwd5t76J8V/LbPXAW0BO9IdInTD?=
 =?us-ascii?Q?xpmURQlPIuQcMEyE7/pq0e88K3wJ0ZgTb5pQkoqS6Fzvyn0XhwrxWXEz1u5u?=
 =?us-ascii?Q?FeY1G6i7urRrf9jDlXG+VE43Asy3dMy+cv9ZmbfAwc187Tfs2YLimAXdmYW9?=
 =?us-ascii?Q?WNNhT3cjVwgPoVV5/Dxosbrnn3oyacBfstKFuiQPz3CdUGfusdtp/TJ9ZbvS?=
 =?us-ascii?Q?g0D+pMOT15qf7tJBhOvSaVxJaoVjIIhTHzIh2x+7bYIWPkj7kuXMOUKTpwZy?=
 =?us-ascii?Q?IJqHi4lH9ayXuZH7usUYwak7CL4x?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 22:48:42.2588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b1e6cd7-4ba7-4087-2438-08dc664305c0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7966

On Fri, Apr 26, 2024 at 05:24:57PM -0500, Michael Roth wrote:
> On Fri, Apr 26, 2024 at 01:14:32PM -0700, Sean Christopherson wrote:
> > On Fri, Apr 26, 2024, Michael Roth wrote:
> > > On Thu, Apr 25, 2024 at 03:13:40PM -0700, Sean Christopherson wrote:
> > > > On Thu, Apr 25, 2024, Michael Roth wrote:
> > > > > On Wed, Apr 24, 2024 at 01:59:48PM -0700, Sean Christopherson wrote:
> > > > > > On Sun, Apr 21, 2024, Michael Roth wrote:
> > > > > > > +static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
> > > > > > > +{
> > > > > > > +	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
> > > > > > > +	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
> > > > > > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > > > > > +
> > > > > > > +	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
> > > > > > > +		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
> > > > > > > +		return 1; /* resume guest */
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
> > > > > > > +	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC_MSR;
> > > > > > > +	vcpu->run->vmgexit.psc_msr.gpa = gpa;
> > > > > > > +	vcpu->run->vmgexit.psc_msr.op = op;
> > > > > > 
> > > > > > Argh, no.
> > > > > > 
> > > > > > This is the same crud that TDX tried to push[*].  Use KVM's existing user exits,
> > > > > > and extend as *needed*.  There is no good reason page state change requests need
> > > > > > *two* exit reasons.  The *only* thing KVM supports right now is private<=>shared
> > > > > > conversions, and that can be handled with either KVM_HC_MAP_GPA_RANGE or
> > > > > > KVM_EXIT_MEMORY_FAULT.
> > > > > > 
> > > > > > The non-MSR flavor can batch requests, but I'm willing to bet that the overwhelming
> > > > > > majority of requests are contiguous, i.e. can be combined into a range by KVM,
> > > > > > and that handling any outliers by performing multiple exits to userspace will
> > > > > > provide sufficient performance.
> > > > > 
> > > > > That does tend to be the case. We won't have as much granularity with
> > > > > the per-entry error codes, but KVM_SET_MEMORY_ATTRIBUTES would be
> > > > > expected to be for the entire range anyway, and if that fails for
> > > > > whatever reason then we KVM_BUG_ON() anyway. We do have to have handling
> > > > > for cases where the entries aren't contiguous however, which would
> > > > > involve multiple KVM_EXIT_HYPERCALLs until everything is satisfied. But
> > > > > not a huge deal since it doesn't seem to be a common case.
> > > > 
> > > > If it was less complex overall, I wouldn't be opposed to KVM marshalling everything
> > > > into a buffer, but I suspect it will be simpler to just have KVM loop until the
> > > > PSC request is complete.
> > > 
> > > Agreed. But *if* we decided to introduce a buffer, where would you
> > > suggest adding it? The kvm_run union fields are set to 256 bytes, and
> > > we'd need close to 4K to handle a full GHCB PSC buffer in 1 go. Would
> > > additional storage at the end of struct kvm_run be acceptable?
> > 
> > Don't even need more memory, just use vcpu->arch.pio_data, which is always
> > allocated and is mmap()able by userspace via KVM_PIO_PAGE_OFFSET.
> 
> Nice, that seems like a good option if needed.
> 
> > 
> > > > > KVM_HC_MAP_GPA_RANGE seems like a nice option because we'd also have the
> > > > > flexibility to just issue that directly within a guest rather than
> > > > > relying on SNP/TDX specific hcalls. I don't know if that approach is
> > > > > practical for a real guest, but it could be useful for having re-usable
> > > > > guest code in KVM selftests that "just works" for all variants of
> > > > > SNP/TDX/sw-protected. (though we'd still want stuff that exercises
> > > > > SNP/TDX->KVM_HC_MAP_GPA_RANGE translation).
> > > > > 
> > > > > I think we'd there is some potential baggage there with the previous SEV
> > > > > live migration use cases. There's some potential that existing guest kernels
> > > > > will use it once it gets advertised and issue them alongside GHCB-based
> > > > > page-state changes. It might make sense to use one of the reserved bits
> > > > > to denote this flavor of KVM_HC_MAP_GPA_RANGE as being for
> > > > > hardware/software-protected VMs and not interchangeable with calls that
> > > > > were used for SEV live migration stuff.
> > > > 
> > > > I don't think I follow, what exactly wouldn't be interchangeable, and why?
> > > 
> > > For instance, if KVM_FEATURE_MIGRATION_CONTROL is advertised, then when
> > > amd_enc_status_change_finish() is triggered as a result of
> > > set_memory_encrypted(), we'd see
> > > 
> > >   1) a GHCB PSC for SNP, which will get forwarded to userspace via
> > >      KVM_HC_MAP_GPA_RANGE
> > >   2) KVM_HC_MAP_GPA_RANGE issued directly by the guest.
> > > 
> > > In that case, we'd be duplicating PSCs but it wouldn't necessarily hurt
> > > anything. But ideally we'd be able to distinguish the 2 cases so we
> > > could rightly treat 1) as only being expected for SNP, and 2) as only
> > > being expected for SEV/SEV-ES.
> > 
> > Why would the guest issue both?  That's a guest bug.  Or if supressing the second
> > hypercall is an issue, simply don't enumerate MIGRATION_CONTROL for SNP guests.
> 
> At the time of its inception, KVM_HC_MAP_GPA_RANGE was simply
> KVM_HC_PAGE_ENC_STATUS and got a more generic name over the course of
> development. But its purpose never changed: to inform the hypervisor of
> the current encryption status of a GPA range so VMMs could build up a
> list of shared guest regions that don't need to go through firmware for
> migration.. And it was and still is asynchronous to a degree, since the
> the migration control MSRs signals when that list of shared pages is
> usable.
> 
> These are very different semantics the proposal to use KVM_HC_MAP_GPA_RANGE
> as a means to set memory attributes via KVM_SET_MEMORY_ATTRIBUTES, and
> the 2 purposes aren't necessarily mutually exclusive to one another. It
> only really becomes a bug if we begin to interpret the original use-case
> as something other than it's initial intent in the case of SNP.
> 
> But at the same time, it's hard to imagine this older SEV live migration
> use-case being useful for SNP, since userspace will necessarily have all
> the information it needs to determine what is/isn't shared with relying
> on an additional hypercall.
> 
> So treating the older use case as specific to non-SNP and disallowing the
> use of MIGRATION_CONTROL does seems reasonable. But it's really the CPUID
> bit that advertises it, SEV just happens to only use it for when
> MIGRATION_CONTROL is also advertised. So we could disable that as well,
> but I did like the idea of being able to handle guest-issued
> KVM_HC_MAP_GPA_RANGE calls even with SNP/TDX enabled, which is less of an
> option if we can't advertised KVM_HC_MAP_GPA_RANGE via cpuid. But I
> suppose we could do that with KVM selftests which is probably where
> that's more likely to be useful.

Hmm, well...assuming SNP/TDX guest agree to make those vCPU registers
available via VMSA/etc in those cases... So i suppose we'd need some
additional handling to support advertising KVM_HC_MAP_GPA_RANGE via cpuid
either way and it is best to disallow guest-issued KVM_HC_MAP_GPA_RANGE
from being advertised to guests until there's support and a solid use-case
for it.

-Mike

> 
> -Mike
> 

