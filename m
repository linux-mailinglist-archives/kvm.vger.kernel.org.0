Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6241D75D837
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 02:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjGVAfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 20:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjGVAfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 20:35:23 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623FC35AB;
        Fri, 21 Jul 2023 17:35:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFoOjhD8s8ol3ppG8zOS33RdBppuApHA8F7jYoTzBTpyNI/TXvuMlDsIajJYZKNF7CmlCTPG3FeQNazR85BbItdGQ2JQuGNvX9vMEYQsz6Z9j2tkI032hQ63irSCl9wkT20dBquqtgHaJ1a1rbxdh0xgfy3SSikKbWerCtNGwDZSgaEs/5PNwIckpsM0ZMufhPcQALdrgO8IiNKjQdiIYnhmq7ZyTL4tqis5WOraHvbTEMR6oAwseTLjTVBwlwW9nc4Jy60epzYTmW4K7h9fTl5meVFE1JPtgYifaD9xLieVUgvJEssvR/fxXxE3FSiFX51LPdICgy574HqssEC/+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77CwLwqXY9DWbNdDEG6lmLT9ZZczLBC8cVYR8UFjXOk=;
 b=hMqlKpVSDE/DdVGJRWkm/amPMupMejej//Pun2iZmm5o78UsD07kVEqfOrFlrDLHXh5IlZPxR6vLUIx/iBvK8sR2WF6c9oC9+C1YxhgmpNqfRyULPFC6xYCDZVJsADNEWWyOt/bpn523kD7oQqkFL5qLxvlMl0irkDoQKbwI+vlrGMsxjhZRzFG7E8Swr8SkPWaohFpEdCwZXax/SEWgRzQTppn74XvDw5Bfe2onVLdXlJfLOYQdaiRU+Xba/8FXoHLEbfYmE04pVeCwHwCg7vxCjU0cnBaZWsDAw3icK7bITrs6RKODXoeuVoDOCyr6+EqTUOIXz4HSLyx8f3oXIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77CwLwqXY9DWbNdDEG6lmLT9ZZczLBC8cVYR8UFjXOk=;
 b=arEIVQ77dZcwzasjPqgVT4omtrtWyWm4xgpTBHpFY0pNOJ4tB603TRFf6BmF6xQdrxXok1W67UO0BVgQtJa4OC7IABxJLvado0StJFS+WPH9y2n0QcNonxQLG2mRLXKnKG1ma/8+uFqGeMr+yQrbHonuVu9w7IN8sjunNija+xs=
Received: from MW4PR04CA0237.namprd04.prod.outlook.com (2603:10b6:303:87::32)
 by PH7PR12MB5925.namprd12.prod.outlook.com (2603:10b6:510:1d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Sat, 22 Jul
 2023 00:35:19 +0000
Received: from CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::c7) by MW4PR04CA0237.outlook.office365.com
 (2603:10b6:303:87::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28 via Frontend
 Transport; Sat, 22 Jul 2023 00:35:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT113.mail.protection.outlook.com (10.13.174.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6609.28 via Frontend Transport; Sat, 22 Jul 2023 00:35:19 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 21 Jul
 2023 19:35:17 -0500
Date:   Fri, 21 Jul 2023 19:34:49 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, <erdemaktas@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, <chen.bo@intel.com>,
        <linux-coco@lists.linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: Re: [RFC PATCH v4 07/10] KVM: x86: Add gmem hook for initializing
 private memory
Message-ID: <20230722003449.664x3xcu6ydi2vrz@amd.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <21e488b6ced77c08d9e6718fcf57e100af409c64.1689893403.git.isaku.yamahata@intel.com>
 <ZLqVdvsF11Ddo7Dq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZLqVdvsF11Ddo7Dq@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT113:EE_|PH7PR12MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c62a9bd-1ee2-4db9-3ad9-08db8a4b86ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mb/Abq5qHsIUnBUwUVHZYcaw9xkVnXDwFeJ73hdnGfR3bRNhCNYRxADLO/4cVPK7JKtTa5EM9cHrJat7P3lS8wvqc5elNMGOtIkYFeh6fOzlT3TE8bsgMWqDLGa1q+CCb8IByYkqAdg0hjgBYentu6rKzhnR502RcscPRYGn3bnxIuXdWGXuEdf0npSCWf/0OmW7is+p6PY7ohnzRK0DGxu5ikqRHH7wEgpWo8rPj3g+zJJGRnHb7+yUGR3UIgRdPxQFO044VSR3oiV8dMfUcsrFUG6hju/D17hDpnVCaX7j/3qlTzwmGwEMKzG0p24cVvOhmcnIXNG4ZAt7uNUcS+2P9zLPRHmKANJ+fXnd2dxxbvnfm4f1vgdAL076vUJHL8WQAW3rSl/7hgoYza+spymr+fJ2/Mfx1KIn9ZwM6+llKnATP0y6pLDpHezta8xK2amQoL/Kya0qmIH1Q2W6MU6GlhJfwr9cwWx002FnHsagjVMYHTJb8QR4xnvxWu3XsRkzKlBgrEyih+hfWlp18crJWk/7NIhSAqJweSIMpiOl8pVE6EW0HGh+GC6QCwLZYcQPrF1d2hArdxlBVz9xlafcoyLgNr74boEgXwV57820NpSUJArPI4m2yi7JGN7mpFsQajwTIskGxgp+uBX7bOSsz+v9oQugUM8yqV7XcAb/pwpN3eCmjUdxWKO8nf7M8h28zSPaUIUaAMEd+kEdgvy5/OPE7neZWbeF4EaqfjmmjlC0toZBdlbk10wKDSVWTlAlOFxadkzSZqwjRdAkf1gTpb8shjQmKLCqvwbZPvQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(82310400008)(451199021)(36840700001)(46966006)(40470700004)(86362001)(7416002)(44832011)(36756003)(2906002)(66899021)(40460700003)(47076005)(40480700001)(186003)(426003)(336012)(83380400001)(16526019)(36860700001)(26005)(1076003)(6666004)(70206006)(81166007)(966005)(2616005)(356005)(54906003)(8936002)(4326008)(8676002)(6916009)(478600001)(41300700001)(316002)(5660300002)(70586007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2023 00:35:19.0181
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c62a9bd-1ee2-4db9-3ad9-08db8a4b86ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5925
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 07:25:58AM -0700, Sean Christopherson wrote:
> On Thu, Jul 20, 2023, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a73ddb43a2cf..35bb14363828 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4352,6 +4352,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >  				   struct kvm_page_fault *fault)
> >  {
> >  	int max_order, r;
> > +	u8 max_level;
> >  
> >  	if (!kvm_slot_can_be_private(fault->slot))
> >  		return kvm_do_memory_fault_exit(vcpu, fault);
> > @@ -4361,8 +4362,15 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >  	if (r)
> >  		return r;
> >  
> > -	fault->max_level = min(kvm_max_level_for_order(max_order),
> > -			       fault->max_level);
> > +	max_level = kvm_max_level_for_order(max_order);
> > +	r = static_call(kvm_x86_gmem_prepare)(vcpu->kvm, fault->slot, fault->pfn,
> > +					      fault->gfn, &max_level);
> 
> I think KVM should hook gmem itself, i.e. convert pages to private when they're
> allocated, and then back to shared when they're freed.  I don't like having
> asymmetric APIs (convert on fault instead of allocate, but then convert back on
> free instead of on zap), and hooking the page fault path also violates the approach
> of tying the RMP/HKID to the physical allocation.

I'd originally added an arch hook in kvm_gmem_get_pfn() to handle
RMP/HKID when the folio is allocated:

  https://github.com/mdroth/linux/commit/adf78d224126f31e9096b80be21619e1ba447304

Based on your response it seemed like there was a preference to either:

  a) do the RMP/HKID update via KVM MMU prior to mapping into the guest
  b) implement an ioctl() to let userspace pre-allocate/pre-prepare and
     do the RMP updates in advance.

  https://lore.kernel.org/lkml/20230522135036.wnvsmryhkvstwvw2@amd.com/

So this patch basically implements suggestion a), or at least my
understanding of it. Is the original patch that does it via
kvm_gmem_get_pfn() more in line with what you're suggesting here, or
were you still thinking of an ioctl? Or some other place in the code?
Keep in mind the GPA is needed to do the RMP updates so that prevents
us from hooking into the more obvious place like kvm_gmem_get_folio().

> 
> Practically speaking, hooking the fault path will result in undesirable behavior.
> Just because KVM *maps* at 4KiB granularity doesn't mean the RMP must be assigned
> at 4KiB granularity, e.g. if userspace chooses to *not* PUNCH_HOLE when the guest
> shares a single 4KiB page in a 2MiB chunk.   Dirty logging is another case where
> the RMP can stay at 2MiB.  Or as a very silly example, imagine userspace pulls a
> stupid and covers a single 2MiB chunk of gmem with 512 memslots.

Unfortunately I don't think things aren't quite that flexible with SNP. If
RMP entry is 2MB, and you map a sub-page as 4K in the NPT, you'll immediately
get a PFERR_GUEST_SIZEM on the first access (presumably when the guest tries
to PVALIDATE it before use). The RMP fault handler will then subsequently
need to PSMASH the 2MB entry into 4K before that guest can access it. So you
get an extra page fault for every 2MB page that's mapped this way.
(APM Volume 2, Section 15.36.10).

That might not be a big deal for guests that are at least somewhat optimized
to make use of 2MB pages, but another situation is:

  - gmem allocates 2MB page
  - guest issues PVALIDATE on 2MB page
  - guest later converts a subpage to shared but doesn't holepunch
  - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
  - KVM MMU splits NPT mapping to 4K
  - guest converts that shared page back to private

At this point there are no mixed attributes, and KVM would normally
allow for 2MB NPT mappings again, but this is actually not allowed
because the RMP table mappings are validated/4K and cannot be promoted on
the hypervisor, so the NPT mappings must still be limited to 4K to
match this, otherwise we hit the reverse of the PFERR_GUEST_SIZEM
scenario above, where the NPT mapping level is *larger* than the RMP
entry level. Unfortunately that does not result in a PFERR_GUEST_SIZEM
where we can fix things up in response, but instead it's a general
RMP fault that would be tricky to distinguish from an RMP fault
resulting from an implicit page conversion or some other guest weirdness
without doing RMP table checks every time we get a general RMP fault.

So for all intents and purposes it does sort of end up being the case
that the mapping size and RMP entry size are sort of intertwined and
can't totally be decoupled, and if you don't take that into account
when updating the RMP entry, you'll have to do some extra PSMASH's
in response to PFERR_GUEST_SIZEM RMP faults later.

> 
> That likely means KVM will need an additional hook to clamp the max_level at the
> RMP, but that shouldn't be a big deal, e.g. if we convert on allocation, then KVM
> should be able to blindly do the conversion because it would be a kernel bug if
> the page is already assigned to an ASID in the RMP, i.e. the additional hook
> shouldn't incur an extra RMP lookup.

Yah we'd still need a hook in roughly this same place for clamping
max_level. Previous versions of SNP hypervisor patches all had a separate
hook for handling these cases, but since the work of updating the RMP table
prior to mapping isn't too dissimilar from the work of determining max
mapping size, I combined both of them into the kvm_x86_gmem_prepare()
hook/implementation.

But I don't see any major issue with moving RMPUPDATE handling to an
allocation-time hook. As mentioned above we'd get additional
PFERR_GUEST_SIZEM faults by not taking MMU mapping level into account, but
I previously had it implemented similarly via a hook in kvm_gmem_get_pfn()
(because we need the GPA) and didn't notice anything major. But I'm not
sure exactly where you're suggesting we do it now, so could use some
clarify on that if kvm_gmem_get_pfn() isn't what you had in mind.

WRT avoiding the RMP lookup, I'd tried __filemap_get_folio() without
FGP_CREAT flag as a way to check whether the folio was already allocated
or not, but it seemed to result in a lockup, and didn't look like it
would be any better performance-wise than just doing the RMP lookup
anyway (which is just a normal memory read), so that's the route I ended
up going.

-Mike
