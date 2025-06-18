Return-Path: <kvm+bounces-49881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 088EEADEFD7
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 16:39:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F1A7188DF01
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563502ECD3F;
	Wed, 18 Jun 2025 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lNQgWHoM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2044.outbound.protection.outlook.com [40.107.101.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAB72EBDD6;
	Wed, 18 Jun 2025 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750257407; cv=fail; b=LkYO9X40fWEwPpsZvk+F5ZLqRtSU2zothzbshLBI2yQofKgs9DtQuAIFEEf0z/gt6e1Bt/dYkXPvTsMicr6fMPjkO1FnXCF2i/Wl7EVopyQC1ir0+OfhfDl/EQfCybfzfSXzwTnTtGC6LFNcqzt2lirgN/Ye05FMG8SLRLWIEPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750257407; c=relaxed/simple;
	bh=iUX+YHzNJf84YuV5gRWErQy5YSjbuCM7n1kB5sc8i1E=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRH/iD67SgDW1vVt7GSzCHecEPAgZNzmcZtXHTa6cc6V6FoVc1Zk6ptFhx8H7PBFBcoirl2et6QuWUr6B2f1bUxcQy4Gl7kOep7D+glM7TiwZOoP9c8Z31YqQVi8HeF8I+P9LJdxMK4RYu7ib2iQbWPKdeqzo3NdagriENNeHMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lNQgWHoM; arc=fail smtp.client-ip=40.107.101.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3X9V3J9b8PvsXis+dkRfcRkHbdbG3kEVf9deFcxZnHJZrYbgHCRPefagt01lYlqq/wNbUKV9KA3aS9oZgbmqvEE/eted+W5GTETA9bQh33HEk+vUAACOyRLIBEssMAaPbwMPVuAIraYEtyR9Dc22XRNNDtgUtekoe5IrrAMNRXagDNrJCw9PjITSjSQ1A/EaCJvbm9HXljc+OBnDh0lavsZRkJcjy+LT1Hr99GwR4GSfmYjEr1vzH6kJO0hmPmcj9+KRI6qsUssYLtGownxoHfwmgWbG83qGbUppMyeC7U19AavVscbEtYoBcq7rnsyoF9zOyOgO0JTeUGQNXVMVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ctc3CuZVxujYQqNxXyDKo81mHpmi/2LH6sI9W/Z+e68=;
 b=gGy8fTslpbLT/6lvW8P9D7OdLDg/Dn5A+EOk0NK2lJnyrYsWbNkiBYUwEwbqYhoohA+tsJHKHhwPKtJlgz8tYRJLbsDvd0pPHMeXpjsBQcIYlO0dYRoellBYpQGXElF4Ca/j7yHHgbcy1CSB71ZJQ5vliCLsCfgqvxYqSJKeo8BGz9o4TBYSrs8OPSqvxrOh3U0KN89YeHTRjOMBHkJ/A1M9cBRodA8bnhb5/32cSY3xpFsWc8YeCqj+5BrlIBELgDXMW7bD10zqhNDlpuND9V/VHldhlMWsEM2g6a8e4o6GtogIfIJtqiuyqL1jEttMjXuFgGIuC6x4f6Qmk/QftQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ctc3CuZVxujYQqNxXyDKo81mHpmi/2LH6sI9W/Z+e68=;
 b=lNQgWHoMIloA1vBZLiBK/SuA/BIqcjLrym1bxLlPlOuGp82l4mxXrT2FtQ9IlpCj9k1eXhcLCYRBA/AWwUvvNePA3P4eoyomgDjSSX1jw0qTBvRO4+IjAxcs2Tv8YZnZ6UYMDY31ESwRVMvXrftbUVwe2BPTR9rucSYs8m/NPSU=
Received: from CH0P221CA0046.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::19)
 by IA1PR12MB8192.namprd12.prod.outlook.com (2603:10b6:208:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 14:36:42 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:11d:cafe::ce) by CH0P221CA0046.outlook.office365.com
 (2603:10b6:610:11d::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.33 via Frontend Transport; Wed,
 18 Jun 2025 14:36:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8857.21 via Frontend Transport; Wed, 18 Jun 2025 14:36:42 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 18 Jun
 2025 09:36:42 -0500
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 18 Jun 2025 09:35:11 -0500
Date: Wed, 18 Jun 2025 20:03:06 +0530
From: Naveen N Rao <naveen.rao@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, "David
 Woodhouse" <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Sairaj Kodilkar <sarunkod@amd.com>, "Vasant
 Hegde" <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, Francesco Lavra
	<francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 12/62] KVM: SVM: Inhibit AVIC if ID is too big instead
 of rejecting vCPU creation
Message-ID: <7timm7vdq4vjwn6jo5bwgtbn3f7pdtdch7l5dws76pjg7syqwb@al5mifdmboog>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-14-seanjc@google.com>
 <bmx43lru6mwdyun3ktcmoeezqw6baih7vgtykolsrmu5q2x7vu@xp5jrbbqwzej>
 <aFGTYoxlLhZsiMUC@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aFGTYoxlLhZsiMUC@google.com>
Received-SPF: None (SATLEXMB03.amd.com: naveen.rao@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|IA1PR12MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: a508df61-5dc8-4570-bfd9-08ddae758b2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3SEQh2xhl04eJfVMCJOaGZaYiPrvDn7Z2obWfsy2Xpdf/0PHwpF1As7ZoU+6?=
 =?us-ascii?Q?14VTdYa/1gL++ticU/7UcHcUZDFXez9898CYVyd6g5fBkxsUxuIx8RF1dR2p?=
 =?us-ascii?Q?sv8F5zu/QF16bRMdfdtvCmfDSY/vCf+/2v66PMe+kudOPcD+diW0ofhtp0pg?=
 =?us-ascii?Q?iuS9XJgYdXNTh1VAg/P5fswVEGUNwRcHmVerxmsUKfwUWb3VYMQE1qJqJ+Ph?=
 =?us-ascii?Q?w0PpZ4TR9BPmOmfH4+R2lZxFwaQsIQAuxNsjzjqK78EoCSvwbeKe5Ar1b82Q?=
 =?us-ascii?Q?/8PeCNicT3Du30fXB0UD59KQmS/uGUeKwtUZ0E7rn/otK4JQ9x+Bm7siMKkB?=
 =?us-ascii?Q?Qt5YwSN/ofpzngHFYPLtrczJtkURap7zaFaYG6JSdq5Oy+3eHkHT2GhFL+gH?=
 =?us-ascii?Q?oLmbfXjFWK5dprUYDx2zp6CKw/ygPKMUvuSqQUrTLNx5qvXcv0Bx2dHotwVD?=
 =?us-ascii?Q?XtGCwqKcyn37RIfrsPG9wRjYkimeULpcWX538SqTbxxBPA+dYqtsdYE2naFS?=
 =?us-ascii?Q?FxsWuUuVa5RmHZQpbdKEUp3vPwqwUs8j7fFnkJ+Ju456SnulygICSgWst7Il?=
 =?us-ascii?Q?VE7GvYHEQgp3BvRxc+j5F9EoCqF46DyFGr9yfyT/xl50h5m7J3QNRzbjQMl+?=
 =?us-ascii?Q?iGeN2xSb5+0UH30FhLiBn45lNzMAaWYAHiSTVADF4s9E0mKqsJhfV76uZzIk?=
 =?us-ascii?Q?lzNWoKCx0VAxl9Ekvx0SOlbdmApBuroYXjK4vb4/JGqSmPRcn9O9+r9v9Rx8?=
 =?us-ascii?Q?dLhxXoqcuIF6EHtkE1ObpbOg7vRm3gbUJ6sJ6dqswSFc7ZW4vX0yt2WzNbCf?=
 =?us-ascii?Q?L+NbhAVw3sUiw4SAR4hjtw5Q4EJb53g2Tu21R01Dfxc4O6PoswCBv00l4GZf?=
 =?us-ascii?Q?IfGuvFMLuhx7kEvjXZahscsLZUkCWtJaIg/eHpC4fckGx4O3wVamQIf+upqS?=
 =?us-ascii?Q?+pbAbnoM4Zcr9y+8ip7iP0iHbstc5gvXT1xcE7e1AhVjK6w0Cg7rGPh+UNRb?=
 =?us-ascii?Q?736ie/Ia+Ol5Xk9+FtiTLNC51oSkyGGjhzIIYVbiwY/8Cns18pporZ5OGxZ/?=
 =?us-ascii?Q?zAHCvcNdxoHPfTueahM1u9kaqonDzNjVDprhEdEeyoQxL7/Qj7xIgfG3RycN?=
 =?us-ascii?Q?ad8vFMsps5RMhcPVnqZsEQTBMJCU4Zuv+x9o8BtDGgTiAGMtkpixG/2UQFEO?=
 =?us-ascii?Q?Z5l7QZNsNEtO37AWDKM+9/beqT8KW6Ft5vJbZYyvNE4YzxYp2qeYpqmkxeS2?=
 =?us-ascii?Q?//BBDiXo1UgCUV/qsInWHvlroDE3i4O+oBIsKOQVUjjh5tDyCTpwbfFB39ZA?=
 =?us-ascii?Q?t9Wqaw8lb0aLhkgdHDTH6L3y2FqO6xd7RlF1IGr19hfirLGhsnXc4/6CHINE?=
 =?us-ascii?Q?E+A61UYMzUIDw6sxpu+Wo1H4XmHoC9Gb62Yyv5VfCecpnAw84ZBclvLkWnr3?=
 =?us-ascii?Q?NfZOCSGDQjNn4BoxqkSgMi/mZPNEpdCioNaSfwMwA4fIqRuCv3OeICfwZ4eR?=
 =?us-ascii?Q?8YA2raVF8LzyKd6PuKIfdGL6urGaFjbNwUgw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 14:36:42.5298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a508df61-5dc8-4570-bfd9-08ddae758b2c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8192

On Tue, Jun 17, 2025 at 09:10:10AM -0700, Sean Christopherson wrote:
> On Tue, Jun 17, 2025, Naveen N Rao wrote:
> > On Wed, Jun 11, 2025 at 03:45:15PM -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index ab228872a19b..f0a74b102c57 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -277,9 +277,19 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
> > >  	int id = vcpu->vcpu_id;
> > >  	struct vcpu_svm *svm = to_svm(vcpu);
> > >  
> > > +	/*
> > > +	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
> > > +	 * hardware.  Immediately clear apicv_active, i.e. don't wait until the
> > > +	 * KVM_REQ_APICV_UPDATE request is processed on the first KVM_RUN, as
> > > +	 * avic_vcpu_load() expects to be called if and only if the vCPU has
> > > +	 * fully initialized AVIC.
> > > +	 */
> > >  	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
> > > -	    (id > X2AVIC_MAX_PHYSICAL_ID))
> > > -		return -EINVAL;
> > > +	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
> > > +		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG);
> > > +		vcpu->arch.apic->apicv_active = false;
> > 
> > This bothers me a bit. kvm_create_lapic() does this:
> >           if (enable_apicv) {
> >                   apic->apicv_active = true;
> >                   kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> > 	  }
> > 
> > But, setting apic->apicv_active to false here means KVM_REQ_APICV_UPDATE 
> > is going to be a no-op.
> 
> That's fine, KVM_REQ_APICV_UPDATE is a nop in other scenarios, too.  I agree it's
> not ideal, but this is a rather extreme edge case and a one-time slow path, so I
> don't think it's worth doing anything special just to avoid KVM_REQ_APICV_UPDATE.
> 
> > This does not look to be a big deal given that kvm_create_lapic() 
> > is called just a bit before svm_vcpu_create() (which calls the above 
> > function through avic_init_vcpu()) in kvm_arch_vcpu_create(), so there 
> > isn't that much done before apicv_active is toggled.
> > 
> > But, this made me wonder if introducing a kvm_x86_op to check and 
> > enable/disable apic->apicv_active in kvm_create_lapic() might be cleaner 
> > overall
> 
> Hmm, yes and no.  I completely agree that clearing apicv_active in avic.c is all
> kinds of gross, but clearing apic->apicv_active in lapic.c to handle this particular
> scenario is just as problematic, because then avic_init_backing_page() would need
> to check kvm_vcpu_apicv_active() to determine whether or not to allocate the backing
> page.  In a way, that's even worse, because setting apic->apicv_active by default
> is purely an optimization, i.e. leaving it %false _should_ work as well, it would
> just be suboptimal.  But if AVIC were to key off apic->apicv_active, 
> that could
> lead to KVM incorrectly skipping allocation of the AVIC backing page.

I understand your concern about key'ing off apic->apicv_active - that 
would definitely require a thorough audit and does add complexity to 
this.

However, as far as I can see, after your current series, we no longer 
maintain a pointer to the AVIC backing page, but instead rely on the 
lapic-allocated page.

Were you referring to the APIC access page though? That is behind 
kvm_apicv_activated() today, which looks to be problematic if there are 
inhibits set during vcpu_create() and if those can be unset later?  
Shouldn't we be allocating the apic access page unconditionally here?

> 
> > Maybe even have it be the initialization point for APICv: 
> > apicv_init(), so we can invoke avic_init_vcpu() right away?
> 
> I mostly like this idea (actually, I take that back; see below), but VMX throws
> a big wrench in things.  Unlike SVM, VMX doesn't have a singular "enable APICv"
> flag.  Rather, KVM considers "APICv" to be the combination of APIC-register
> virtualization, virtual interrupt delivery, and posted interrupts.
> 
> Which is totally fine.  The big wrench is that the are other features that interact
> with "APICv" and require allocations.  E.g.  the APIC access page isn't actually
> tied to enable_apicv, it's tied to yet another VMX feature, "virtualize APIC
> accesses" (not to be confused with APIC-register virtualization; don't blame me,
> I didn't create the control knobs/names).
> 
> As a result, KVM may need to allocate the APIC access page (not to be confused
> with the APIC *backing* page; again, don't blame me :-D) when enable_apicv=false,
> and even more confusingly, NOT allocate the APIC access page when enable_apicv=true.
> 
> 	if (cpu_need_virtualize_apic_accesses(vcpu)) {  <=== not an enable_apic check, *sigh*
> 		err = kvm_alloc_apic_access_page(vcpu->kvm);
> 		if (err)
> 			goto free_vmcs;
> 	}

Thanks for the background and the details there -- I am going to need 
some time to go unpack all of that :)

> 
> And for both SVM and VMX, IPI virtualization adds another wrinkle, in that the
> per-vCPU setup needs to fill an entry in a per-VM table.  And filling that entry
> needs to happen at the very end of vCPU creation, e.g. so that the vCPU can't be
> targeted until KVM is ready to run the vCPU.
> 
> Ouch.  And I'm pretty sure there's a use-after-free in the AVIC code.  If
> svm_vcpu_alloc_msrpm() fails, the avic_physical_id_table[] will still have a pointer
> to freed vAPIC page.

Oops.

> 
> Thus, invoking avic_init_vcpu() "right away" is unfortunately flat out unsafe
> (took me a while to realize that).
> 
> So while I 100% agree with your dislike of this patch, I think it's the least
> awful band-aid, at least in the short term.
> 
> Longer term, I'd definitely be in favor of cleaning up the related flows, but I
> think that's best done on top of this series, because I suspect it'll be somewhat
> invasive.

Sure, that makes sense. For this patch:
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>


Thanks,
Naveen

