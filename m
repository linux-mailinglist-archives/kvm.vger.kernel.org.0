Return-Path: <kvm+bounces-9130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC31D85B3E8
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C1C528438C
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 07:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C465A780;
	Tue, 20 Feb 2024 07:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IEfMKogW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB775A4CE;
	Tue, 20 Feb 2024 07:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708413897; cv=fail; b=YTNNkBxCQGBB+r1NZXF0k77/ifdxp2USnt2i1GCZqCZstFpc7Fi/Kc3TsBlCY2PXMT9CtvOx9iVmzf59uBzM0wOcdKHNppO/f57XKH/+Yjh+jIjkK2X3EqangWiMlhpFiKx3glpkXKlbvm5TRU6WE4M+f9HKd0CirPrsTnLpZ/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708413897; c=relaxed/simple;
	bh=THmRekXrtk7g/fvWMys3KRpvDLKG/1FnERdWmgHpmQg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e+sV/oGrO07+wX52ccifAMeHZLMjFWnOt8/yX1PxrUQKhr1tUg/FasSHZx4Yqg4LO4wMOjVI7mwO0Fwi8VHHd4nlhpUXUwYPdvMusgKJeh/4Flrz47o7Sdi2Q5p5rM1GG3/Dji/yvm+orhDq6TsAmoUwRvzLpG2hIjz8cYHBE0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IEfMKogW; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708413895; x=1739949895;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=THmRekXrtk7g/fvWMys3KRpvDLKG/1FnERdWmgHpmQg=;
  b=IEfMKogWG5lpLNrtua4Le4PsjGY9oeF31KJUJ0VEnf2u69tiWayJfeQ8
   HF34yirknso1uvKXH3EjRQf3Oh7lnrdm3zOPAjdgVNWPeuBVWd1XHYvRA
   +/0D1aOdSpOcLo4/Qnp1k2CTs/gjvZCk+kvjgwPwCC7VDx2gIdH/au1PC
   kpNZVFFN8m0HUgTH3Zh9nwIS9Vhm5x34n8GgOIS4anvVufDNJQJ0u1dbn
   ysfYxxdrGrDWYX4I4DqnW2BcZmfPSME/mbzljM4+WFqsOsC+4H+7+qSqV
   xN0ccpDENGs9hFdRtCSnYgO4HOOVQ+cJDhbgeRmyUsfK8YdA0aquWI3Uq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2381335"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="2381335"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 23:24:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="9348845"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Feb 2024 23:24:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 19 Feb 2024 23:24:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 19 Feb 2024 23:24:51 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 19 Feb 2024 23:24:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pv85lnt9B7yHN3hbiBR3NsjT7JRdgWpquy4lC4aAOAIq/bZ8T1BkJDhkcYphp2vBQq7/bKTfEFilEPkg7fDyfftNTLVdR4HMJVlFgDVgkRQnl9fS+kMLO1Kfp7quGVxal8A6Zcm+jgIuawuHcnWfKzdTRo3jcCr6+lhNv4UZcZzk8MekW4RuACXcbNRnl6WWFsMaApHY3FCmVVY580VQ/OKzs40/+EPj8ssm14VWwVHBCM5ZQt6S2cMi9w76JMN6aOvHL8q5qlfjhuxR7LTSiCt9QPsE18T6+GFeMfkBDGuiz4zdqh7iRu5TYb6vgEDdgA598CNJXnaFsOqhHSg0qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edW5q47J7XaDUuFHFEV4WnF/y/tcjPqRAtm87+XBJn8=;
 b=QjSS0zsK9k5k67nQIL2QTbLo3p3vYIXNWm5U5PGnNZTn+W64wgdPl1dxU5TKdHHVJgE0E9ZoPPP5pnQoDK32wp4fYF+X6uwqqdjZfrK6i4OaW2n9Q/f2+AvenAsQsE9aH7vBDJmMXryV7Oi6PTUMcAsLCeTdegmJPmxbpQWOLDt3Vv8fL6EsO9zfpPefPxf7TByKYOfdfqTpYPD0XG937VAg4sHh/WZ4n/MS8QNmgurFhOas0V+au2fEXpvNM5xT9jtTQnc6ZIK/6zPRLyRBm1uG0+qMP6NDbJqG6EAz6jqeoMjoWU9ivxpEhkm7awfDBItnLbIUpqgLM38ZBiGWrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB7645.namprd11.prod.outlook.com (2603:10b6:a03:4c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Tue, 20 Feb
 2024 07:24:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::81e3:37ec:f363:689e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::81e3:37ec:f363:689e%6]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 07:24:42 +0000
Date: Tue, 20 Feb 2024 14:54:57 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Friedrich Weber <f.weber@proxmox.com>, "Kai
 Huang" <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, Chao Peng
	<chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, Michael Roth
	<michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "David
 Matlack" <dmatlack@google.com>
Subject: Re: [PATCH v4 3/4] KVM: x86/mmu: Move slot checks from
 __kvm_faultin_pfn() to kvm_faultin_pfn()
Message-ID: <ZdRMwdkz1enYIgBM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240209222858.396696-1-seanjc@google.com>
 <20240209222858.396696-4-seanjc@google.com>
 <ZdLOjuCP2pDjhsJl@yzhao56-desk.sh.intel.com>
 <ZdOvttFKP1VVgrsA@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZdOvttFKP1VVgrsA@google.com>
X-ClientProxiedBy: SI2P153CA0022.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::8)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB7645:EE_
X-MS-Office365-Filtering-Correlation-Id: ba432bbc-6c75-4912-19f1-08dc31e501b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GM2BBeMJXz6AHnTUCT/DlBzZWvQSle/aX7nIkiiT8t82bJgMFmLDQ95d/5Fpp89EUdvb5G+c1DFxJ/yOw8Y8EThq2oLafSN/rb7V9qj93It2WmoL2QjgDe5Q7sgiw+VrqX7JOyIZSVhPZTTuzCM7zfUUJFQRrF6Pn+RzRo12U/bXeiPrtqVwXVf7NMnPVUa/HDJ0iLHuvjLOzFahFUud5RCOzE4U2pMDcat4g8r0veNd4t5BOjDOHgkQkBuHjWoxvXJaix0uzT7F0/7eZlIEnidwYNrOQdHxWbldSOu1O/KEAv9jgTi12nC1KKO2pYvjMr2MHIBaBbeaAgwKXll7aF6MVyJsNlioByddJzhIyzQQSM3BAnZeG8Y65n9YKkz4vmyzBcDyqwM17VrKYJ60XRhMG6reaQRei38JjNZ5r1GTYSHhB6Zj70LjGmBCUApm5dwea5ezMfnJC73wa784KX0DqEVaz5hyZ0iav/vLuhbvSzZRc/QkZ2Q1aZAY+ziPlXZhiln0jOaeFddAy2ChQ84M43wpOrRNBJgaoiAXjbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N+/nBs9CDHzPw1QhFxAbxo4W4I/o0t2jxAwQf7NnzgHR/VfBe7y8WY3/zVW9?=
 =?us-ascii?Q?djy6l8kXRGD7fkG2gWAxZM1l/LZPajYTpw5tKsz3DJkYj7rh/VBpdq3+nPbS?=
 =?us-ascii?Q?Q6tuO5N7dBX6m24QUUZFXc8oDru0KqrP1VhijdXVjsW6UPQA8sNwjA4pQNN0?=
 =?us-ascii?Q?NiqE54Wg7vWOOASuSNi5p+jZAXS72Tq91YPgasNulqX8+JW5GLm8IR3y628t?=
 =?us-ascii?Q?43fEvMgXhYeoPmANmapdtTKJTT2hpedx0Q2px2KIuJH73YRJeOiqd1uv3+J/?=
 =?us-ascii?Q?1fumALLXIrYx/EHUXm1BmUHxC9oEyzQKRR1ASHyJgrcJ2XXXjweeqGZ3glHt?=
 =?us-ascii?Q?vzqFE99lkuIkS1wumMt/m8o3DJ2BjIUpHVvs4VvJY9b9AnCm0y8XwJv9tipE?=
 =?us-ascii?Q?7LbZ4L6glMvyKmOJjhG1UBmPLknYhxfvp7em0G7cnb8zZ3rB6oKg6OQVg0qq?=
 =?us-ascii?Q?I2poex+eQEYW0eEjrdWNhjR7mEZXfX4HpQEa1cu9GjPaDfNW8OuRqP6HcnKt?=
 =?us-ascii?Q?T2OMRaVtAtL5yHEhJZRHNUQGUZbG0iSDSatohkMk18Gk/EGA9A8su5o9Cn/I?=
 =?us-ascii?Q?1N73onNaUC62y0KhdG46ssqcFPbFb104RTObRyw56J4oTOxfU9xdF6LGmaDg?=
 =?us-ascii?Q?XtB6qx2nVq1eNxChJ6pqmY+99ECgYjj4IoKWgw/jrQSWJ/GvTI+LALbqqYaF?=
 =?us-ascii?Q?37HCEapD/aP2WotiRaCx0uff/7Ue+C00pXqYeHhjbcCHtcWDLcSFrW83Bjkq?=
 =?us-ascii?Q?jWdyomHz9tPnJreIlOm9DwwEx9fgjZGOlmP/0MwWs0LwsPCB9SSSdqJ5i8fR?=
 =?us-ascii?Q?yNuHxG42F2iSSqS6YEnCBIn72ouZ5ADWMFL9pXGFjIz2JXAKwfzAtHB2Ds2Q?=
 =?us-ascii?Q?8DybK/yS83RP5KGp2E6WyMtp1Rf5FwpvQmV/vyyyqm/K22LUcUBr9zXnHd27?=
 =?us-ascii?Q?fxq45E4QnhPPvNNq1CDo+Vim1uyQjedRqP3Uz9Np2n11a5x5EofEgpGAUEOH?=
 =?us-ascii?Q?BB7b84HtWAjZfag+MQ3yW/H3qIwxeUjUbhUWFlnvWGYoS5BLfwjYR1vwmPAL?=
 =?us-ascii?Q?BXC9Rto1amkIzpaDOqgXr7qZ6gG11BmjHs6wDYim5wLB4FEISfeS8fnMWHh8?=
 =?us-ascii?Q?3LMZoxSoVcKJi/1TUcqdqEVPyJIdNPUTgeggncZnBXoFcqEGWmKIGFG9Fz8M?=
 =?us-ascii?Q?Vy4LKlUQIOE7Z5QzieOfk4ddbQ3MlUkxyqDgEjxvpPByEP3XrdOU/abvf61l?=
 =?us-ascii?Q?HI23GBYnc5moCQbBIfAOOKs6MNeB/AyBS0gsk0L0aFv+yEV0FT4rIPgygn87?=
 =?us-ascii?Q?pG/5V+Zt1MNtMVbxKmPFXwIGzeKYMPA0XUzwV6T+kXKBVNZ0aVnVOmLD0MSJ?=
 =?us-ascii?Q?XlgB6Zvr9FRkCdvHwHia2VbCnBf8YTf038bRplqHRZhbvvdUATYzdW14oU1k?=
 =?us-ascii?Q?cnYNOkC+9nWLOzc2cdHD5PWJlbARTT0eqG8fSa/9T/FqXWPUn6m7v8/tVU+e?=
 =?us-ascii?Q?chZ7RtwAqmpqBjgMnXaqDHGt1o+kJD/23p75cBsofQ/qCP8kiw00gjSGAdc9?=
 =?us-ascii?Q?Ew2lQ1Q83CR9873DzbxEdhktlVwGbrdaR5gU1oD5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba432bbc-6c75-4912-19f1-08dc31e501b0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 07:24:42.6411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBajMhTqsN2IwmnfyNRF8bvwfEzWulC+sHd0GGqwVZbfdOoDslQMIKIFWZgtyC27JMY0vYsM5Dru7VMbvOGVrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7645
X-OriginatorOrg: intel.com

On Mon, Feb 19, 2024 at 11:44:54AM -0800, Sean Christopherson wrote:
> +Jim
> 
> On Mon, Feb 19, 2024, Yan Zhao wrote:
> > On Fri, Feb 09, 2024 at 02:28:57PM -0800, Sean Christopherson wrote:
> > > @@ -4406,6 +4379,37 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > >  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> > >  	smp_rmb();
> > >  
> > > +	if (!slot)
> > > +		goto faultin_pfn;
> > > +
> > > +	/*
> > > +	 * Retry the page fault if the gfn hit a memslot that is being deleted
> > > +	 * or moved.  This ensures any existing SPTEs for the old memslot will
> > > +	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
> > > +	 */
> > > +	if (slot->flags & KVM_MEMSLOT_INVALID)
> > > +		return RET_PF_RETRY;
> > > +
> > > +	if (!kvm_is_visible_memslot(slot)) {
> > > +		/* Don't expose KVM's internal memslots to L2. */
> > > +		if (is_guest_mode(vcpu)) {
> > > +			fault->slot = NULL;
> > > +			fault->pfn = KVM_PFN_NOSLOT;
> > > +			fault->map_writable = false;
> > > +			return RET_PF_CONTINUE;
> > Call kvm_handle_noslot_fault() to replace returning RET_PF_CONTINUE?
> 
> Oof.  Yes.  But there is a pre-existing bug here too, though it's very theoretical
> and unlikely to ever cause problems.
> 
> If KVM is using TDP, but L1 is using shadow paging for L2, then routing through
> kvm_handle_noslot_fault() will incorrectly cache the gfn as MMIO, and create an
> MMIO SPTE.  Creating an MMIO SPTE is ok, but only because kvm_mmu_page_role.guest_mode
> ensure KVM uses different roots for L1 vs. L2.  But mmio_gfn will remain valid,
> and could (quite theoretically) cause KVM to incorrectly treat an L1 access to
> the private TSS or identity mapped page tables as MMIO.
Why would KVM treat L1 access to the private TSS and identity mapped page
tables as MMIO even though mmio_gfn is valid?
It looks that (for Intel platform) EPT for L1 will only install normal SPTEs
(non-MMIO SPTEs) for the two private slots, so there would not have EPT
misconfiguration and would not go to emulation path incorrectly.
Am I missing something?

> Furthermore, this check doesn't actually prevent exposing KVM's internal memslots
> to L2, it simply forces KVM to emulate the access.  In most cases, that will trigger
> MMIO, amusingly due to filling arch.mmio_gfn.  And vcpu_is_mmio_gpa() always
> treats APIC accesses as MMIO, so those are fine.  But the private TSS and identity
> mapped page tables could go either way (MMIO or access the private memslot's backing
> memory).
Yes, this is also my question when reading that part of code.
mmio_gen mismatching may lead to accessing the backing memory directly.

> We could "fix" the issue by forcing MMIO emulation for L2 access to all internal
> memslots, not just to the APIC.  But I think that's actually less correct than
> letting L2 access the private TSS and indentity mapped page tables (not to mention
> that I can't imagine anyone cares what KVM does in this case).  From L1's perspective,
> there is R/W memory at those memslot, the memory just happens to be initialized
> with non-zero data, and I don't see a good argument for hiding that memory from L2.
> Making the memory disappear is far more magical than the memory existing in the
> first place.
> 
> The APIC access page is special because KVM _must_ emulate the access to do the
> right thing.  And despite what commit 3a2936dedd20 ("kvm: mmu: Don't expose private
> memslots to L2") said, it's not just when L1 is accelerating L2's virtual APIC,
> it's just as important (likely *more* imporant* for correctness when L1 is passing
> through its own APIC to L2.
>
> Unless I'm missing someting, I think it makes sense to throw in the below before
> moving code around.
> 
> Ouch, and looking at this further, patch 1 introduced a bug (technically) by caching
> fault->slot; in this case KVM will unnecessarily check mmu_notifiers.  That's
> obviously a very benign bug, as a false positive just means an unnecessary retry,
> but yikes.
>
Patch 3 & 4 removed the bug immediately :)

> --
> Subject: [PATCH] KVM: x86/mmu: Don't force emulation of L2 accesses to
>  non-APIC internal slots
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 488f522f09c6..4ce824cec5b9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4341,8 +4341,18 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
>  		return RET_PF_RETRY;
>  
> -	if (!kvm_is_visible_memslot(slot)) {
> -		/* Don't expose private memslots to L2. */
> +	if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT) {
> +		/*
> +		 * Don't map L1's APIC access page into L2, KVM doesn't support
> +		 * using APICv/AVIC to accelerate L2 accesses to L1's APIC,
> +		 * i.e. the access needs to be emulated.  Emulating access to
> +		 * L1's APIC is also correct if L1 is accelerating L2's own
> +		 * virtual APIC, but for some reason L1 also maps _L1's_ APIC
> +		 * into L2.  Note, vcpu_is_mmio_gpa() always treats access to
> +		 * the APIC as MMIO.  Allow an MMIO SPTE to be created, as KVM
> +		 * uses different roots for L1 vs. L2, i.e. there is no danger
> +		 * of breaking APICv/AVIC for L1.
> +		 */
>  		if (is_guest_mode(vcpu)) {
>  			fault->slot = NULL;
>  			fault->pfn = KVM_PFN_NOSLOT;
Checking fault->is_private before calling kvm_handle_noslot_fault()?
And do we need a centralized check of fault->is_private in kvm_mmu_do_page_fault()
before returning RET_PF_EMULATE?

> @@ -4355,8 +4365,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  		 * MMIO SPTE.  That way the cache doesn't need to be purged
>  		 * when the AVIC is re-enabled.
>  		 */
> -		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> -		    !kvm_apicv_activated(vcpu->kvm))
> +		if (!kvm_apicv_activated(vcpu->kvm))
>  			return RET_PF_EMULATE;
Otherwise, here also needs a checking of fault->is_private?
Maybe also for where RET_PF_EMULATE is returned when page_fault_handle_page_track()
is true (though I know it's always false for TDX).

>  	}
>  
> 
> base-commit: ec98c2c1a07fb341ba2230eab9a31065d12d9de6
> -- 

