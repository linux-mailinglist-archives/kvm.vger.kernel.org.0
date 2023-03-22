Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39806C4F63
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 16:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjCVPZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 11:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjCVPZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 11:25:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EA36132A;
        Wed, 22 Mar 2023 08:25:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ToTKwqHfOKP3jPTeIjURCM10nxCi85dMMbKqP4N5ulPSCfxug3xH3WlejGogpOBls0+fQ/z8EV91kSIYkbzDBnYyIbc+3Qf2iR/Fn6Sj1NOQYltb9u+8tNNWTZrawyf1SYNl4Q8HOAaF9KA116rR+s15Z/vmE2j3GimIIexQHSRgvuVpCwkUFnstwCUxw3TcjR38ta604OOXGSqHu9htuYclyyBEkUKi9yWd9kbwNkpND/zPaaa943sEGyORKb5/HoBnoasSiNCCoa2moCrfaxhc4OalhPIBsm+ZnphkNjLJYQX/OzmaPsuLM9X0CUksflIqD7TEMtV4SJdNRWkZqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YESdAaGdd5j53aGAigayAsgwMBCzvwpoiTljfws4SmU=;
 b=dfnAuEHYFFIjUJYXV3kxvRlb6k70HqH5uTBTb/dhB9cIfk8cZivEyS2W9MpEiZJtCWcTkUD0DEzyqt/z9Nh4siQWKcywqUq8UxdpVZ2u81RbX/91oR5itJxW24iS4NZuB2sBorOmGppsSes9Xyu1oKilQBxvzhJwIeCwgxp9EyDi1pKcS8uk/522kQ6omA9LBPipNDsXdaZH2pTu+jfqYuMEEsSlO8+IxOYwcQIK7o4vmXLUL4eLy4CPLfH3lf8QUm8Hf8PszEmcO9GocVoRbklft7IKOrIOzW075Qw29L2r45TucwaC0G99HQKMUZ0Vp/OrMYT1aql2VZ7DJ8kM0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YESdAaGdd5j53aGAigayAsgwMBCzvwpoiTljfws4SmU=;
 b=aWDHMN1XuelB9R0oPtEeRh7kpQwxRnCQwnnBlK9EAq2uX8Qr7rwMYBeh3SuqxNcEYvkr/xEixAIg+mOI614fEPsfEPFv3xnNTVfQ2jJxWa8GHXFgll58AEen6wINLKa8ZH18emyLPIVs7YFeqi0QKxBSIG/MrDWG6Rll2jYIllw=
Received: from CYZPR17CA0021.namprd17.prod.outlook.com (2603:10b6:930:8c::26)
 by DM4PR12MB6159.namprd12.prod.outlook.com (2603:10b6:8:a8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Wed, 22 Mar 2023 15:25:26 +0000
Received: from CY4PEPF0000C97D.namprd02.prod.outlook.com
 (2603:10b6:930:8c:cafe::d7) by CYZPR17CA0021.outlook.office365.com
 (2603:10b6:930:8c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 15:25:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C97D.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Wed, 22 Mar 2023 15:25:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 10:25:24 -0500
Date:   Tue, 21 Mar 2023 20:58:38 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
CC:     Isaku Yamahata <isaku.yamahata@gmail.com>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 02/56] KVM: x86: Add 'update_mem_attr' x86 op
Message-ID: <20230322015838.z3bwcrvi4gqag3q6@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-3-michael.roth@amd.com>
 <20230318045611.GE408922@ls.amr.corp.intel.com>
 <20230320180543.ly4jgu54hyamy2gl@amd.com>
 <20230321132136.00005234@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230321132136.00005234@gmail.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97D:EE_|DM4PR12MB6159:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b82080a-98ce-4222-77d8-08db2ae9a97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGf/JpG90I2NwX67sA/Ivrhhxzfhz3I7SYSNEO7JCltZPZAieqFsoIxldnxFWz7ySOoRVoQtVq1YaJZEU+pPId7yrtUAyvernbazxLyUzmvzWBSl7VhbiL2dnJMvidvLmQ7dOMwcqfUMdr9ndlj8MRiaBz6XhmVTyVUaJJ2GskYS667xeE/YKgDMCIf34yIXLoEhOeApOMmQQzLrtyqoamvWwET+bS4qdR0ODTHiyDlDPw2o09T1sk/Be3TklyxXM+/QPcjqfC/GU4QOmfF8lLptxBt+MLoNgUM3NlSWRrsLZ95YdtGz/f174HrleRK2Jhb/TwhmGlEOjltR6onRhDVr6dEAjPXosOz1arRIC+dYq5epfaAN/K9DUnyekzbaUQiJBAFo0Vv9HcvszkVSjXDyLHtTyw3z2bk9WYiyI/x4+wqQbtKTezda/rkfXHSgJPamhI+IRLvdjsJ5+yDzxXX1kefkOwdcsdckjrQ9qj7g0+cQkOoIHZRhHgZy9Yz4oV5qC+OwAOkf/5vU6D0JAspReurEanwJ4kX9Gzp2dRTyNQu4NkkvpSQBVvZdU/WKxMx6Z4hirFz0rpRWq2o/sHL8/K9QA3pdOVDYATGXo3bi8MzukQtDiZ6AUHHhpo4U4OfWLIRGNdbU6uNPV+uwSCBUwkJ4qYMBHN6BjI672J5LFbKfvt3dLbFCYx+KKEXSEOTty6kt3sxfteDrPDh9eAd2d4zeHBj0F979+78WEcp/lVjp0qGA+SBz2Jt4R5tx6YuYxvT/XK3amAwifP0UNQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(30864003)(44832011)(36756003)(8936002)(7416002)(2616005)(5660300002)(7406005)(40460700003)(47076005)(426003)(83380400001)(36860700001)(15650500001)(336012)(2906002)(40480700001)(82310400005)(966005)(478600001)(316002)(86362001)(54906003)(82740400003)(41300700001)(1076003)(53546011)(26005)(81166007)(6916009)(8676002)(356005)(70206006)(6666004)(4326008)(70586007)(16526019)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 15:25:26.0838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b82080a-98ce-4222-77d8-08db2ae9a97b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6159
X-Spam-Status: No, score=0.6 required=5.0 tests=DATE_IN_PAST_12_24,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 01:21:36PM +0200, Zhi Wang wrote:
> On Mon, 20 Mar 2023 13:05:43 -0500
> Michael Roth <michael.roth@amd.com> wrote:
> 
> > On Fri, Mar 17, 2023 at 09:56:11PM -0700, Isaku Yamahata wrote:
> > > On Mon, Feb 20, 2023 at 12:37:53PM -0600,
> > > Michael Roth <michael.roth@amd.com> wrote:
> > >   
> > > > This callback will do any platform-specific handling needed for
> > > > converting pages between shared/private.
> > > > 
> > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > ---
> > > >  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> > > >  arch/x86/include/asm/kvm_host.h    |  2 ++
> > > >  arch/x86/kvm/mmu/mmu.c             | 13 +++++++++++++
> > > >  include/linux/kvm_host.h           |  4 ++++
> > > >  virt/kvm/kvm_main.c                | 29 +++++++++++++++++++++++++++++
> > > >  5 files changed, 49 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > > index 72183da010b8..a8aaf532c2ab 100644
> > > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > > @@ -132,6 +132,7 @@ KVM_X86_OP(complete_emulated_msr)
> > > >  KVM_X86_OP(vcpu_deliver_sipi_vector)
> > > >  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> > > >  KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
> > > > +KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
> > > >  
> > > >  #undef KVM_X86_OP
> > > >  #undef KVM_X86_OP_OPTIONAL
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index f856d689dda0..2da3fb2d5d1b 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1644,6 +1644,8 @@ struct kvm_x86_ops {
> > > >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > > >  			     int root_level);
> > > >  	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *private_fault);
> > > > +	int (*update_mem_attr)(struct kvm_memory_slot *slot, unsigned int attr,
> > > > +			       gfn_t start, gfn_t end);
> > > >  
> > > >  	bool (*has_wbinvd_exit)(void);
> > > >  
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index fb3f34b7391c..053bd77bbf52 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -7251,4 +7251,17 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> > > >  		linfo_update_mixed(gfn, slot, level, mixed);
> > > >  	}
> > > >  }
> > > > +
> > > > +void kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> > > > +					 struct kvm_memory_slot *slot,
> > > > +					 unsigned long attrs,
> > > > +					 gfn_t start, gfn_t end)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	ret = static_call(kvm_x86_update_mem_attr)(slot, attrs, start, end);
> > > > +	if (ret)
> > > > +		pr_warn_ratelimited("Failed to update GFN range 0x%llx-0x%llx with attributes 0x%lx. Ret: %d\n",
> > > > +				    start, end, attrs, ret);
> > > > +}
> > > >  #endif
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index fdc59479b3e2..d200b8f45583 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -2330,6 +2330,10 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> > > >  				    struct kvm_memory_slot *slot,
> > > >  				    unsigned long attrs,
> > > >  				    gfn_t start, gfn_t end);
> > > > +void kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> > > > +					 struct kvm_memory_slot *slot,
> > > > +					 unsigned long attrs,
> > > > +					 gfn_t start, gfn_t end);
> > > >  
> > > >  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> > > >  {
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index b68574ff6c30..8ec985f1c57d 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -2561,6 +2561,32 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
> > > >  		kvm_flush_remote_tlbs(kvm);
> > > >  }
> > > >  
> > > > +static void kvm_post_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
> > > > +				       gfn_t start_orig, gfn_t end_orig)
> > > > +{
> > > > +	struct kvm_memory_slot *slot;
> > > > +	struct kvm_memslots *slots;
> > > > +	struct kvm_memslot_iter iter;
> > > > +	int i;
> > > > +
> > > > +	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
> > > > +		slots = __kvm_memslots(kvm, i);
> > > > +
> > > > +		kvm_for_each_memslot_in_gfn_range(&iter, slots, start_orig, end_orig) {
> > > > +			gfn_t start, end;
> > > > +
> > > > +			slot = iter.slot;
> > > > +			start = max(start_orig, slot->base_gfn);
> > > > +			end = min(end_orig, slot->base_gfn + slot->npages);
> > > > +
> > > > +			if (start >= end)
> > > > +				continue;
> > > > +
> > > > +			kvm_arch_post_set_memory_attributes(kvm, slot, attrs, start, end);
> > > > +		}
> > > > +	}
> > > > +}
> > > > +
> > > >  static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > > >  					   struct kvm_memory_attributes *attrs)
> > > >  {
> > > > @@ -2602,6 +2628,9 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > > >  	kvm_mmu_invalidate_end(kvm);
> > > >  	KVM_MMU_UNLOCK(kvm);
> > > >  
> > > > +	if (i > start)
> > > > +		kvm_post_mem_attrs_changed(kvm, attrs->attributes, start, i);
> > > > +  
> > > 
> > > Doesn't kvm_arch_set_memory_attributes() work for you? i.e the following patch.
> > > The error check and pr_warn_ratelimited() can be pushed down into the callback.  
> > 
> > This is originally how I had but when CONFIG_PREEMPT_COUNT is set this
> > will generate warnings for this callback as well as the invalidation
> > callback as reported in v7 here:
> > 
> >   https://lore.kernel.org/lkml/Y80vhKwQyw8hS%2F22@notebook/
> > 
> > The main issue is that kvm_mem_attrs_changed() is called while holding
> > the KVM MMU lock, which disables preemption. But when updating
> > attributes for SNP, we also need to remove private pages from kernel
> > directmap, which involves acquiring a mutex which results in
> > "BUG: scheduling while atomic" warnings.
> > 
> > So that's why we ended up somewhat duplicating some of the logic and
> > using a separate callback chain that happens out of KVM MMU lock.
> 
> Let's split the things of changing memory attributes:
> 
> 1) Update the memory attributes in the xa array (Both TDX and SNP)
> 2) Zapping the EPT/NPT mappings (Required by TDX)
> 3) Update RMP table (Required by SNP)
> 4) Update the directmap of kernel (SNP, but I guess TDX needs it as well)

I'm not so sure TDX requires this. I was under that impression, but
Kirill raised some doubts about this and I'm not sure it's been
confirmed. If it's purely an SNP thing then there may not be much value
in creating a separate callback for it:

  https://lore.kernel.org/linux-mm/20221031141426.GA3994099@chaop.bj.intel.com/T/#meba4ce80709cd3afd3818b61e6419fd800287b9e

And for SNP, the current code does the unmapping/RMP update in the same
function:

  [PATCH RFC v8 15/56] x86/sev: Invalidate pages from the direct map when adding them to the RMP table

I'm not against splitting RMP/directmap handling, but just want to
understand what the requirements are around that a bit better.

Does handling the #3 / RMP update / kvm_arch_post_set_memory_attributes
stuff outside of MMU lock cause issues on TDX side? What sort of
handling is needed in these callbacks for TDX (if anything)?

> 
> Does SNP really need to zap the NPT mappings when changing the memory
> attributes? (The new mappings will be created later in the fault). I don't
> find this requirement from APM.

I don't think we've added anything specifically for SNP. Do you mean the
generic kvm_unmap_gfn_range/kvm_flush_remote_tlbs sequence below?

  kvm_vm_ioctl_set_mem_attributes():
    KVM_MMU_LOCK(kvm)
    kvm_mmu_invalidate_begin()
    ...
    KVM_MMU_UNLOCK(kvm)

    kvm_vm_set_region_attr()  // xarray/attribute update

    ...
    KVM_MMU_LOCK(kvm)
    kvm_mem_attrs_changed():
      flush |= kvm_unmap_gfn_range()
      if (flush)
        kvm_flush_remote_tlbs()
    KVM_MMU_UNLOCK(kvm)

In general, when the RMPUPDATE instruction happens, the TLB entries for
the GPAs being modified will be flushed, so subsequent nested page fault
should be able to obtain the updated mapping based on xarray/#NPF at that
point. In that respect *maybe* we don't need to zap the entries there.

But if the nested page fault occurs before the RMPUPDATE, I think we would
have a race if the above sequence isn't in place to handle the unmap/flush,
since in that case we might get a stale mapping because nothing would've
forced a tlbflush.

There's also stuff like the UPM selftests and SEV lazy-pinning where I
think that kvm_unmap_gfn_range() sequence is also needed. But I might be
misunderstanding the question here.

> If yes, can we postpone the update of the RMP table in the later fault,
> like TDX? So that we can save this update_mem_attr x86 ops as things
> will be solved in the SNP-specific fault handler.

Hmm, I think this would be possible. But it's nice to be able to handle
the RMPUPDATE as part of KVM_SET_MEMORY_ATTRIBUTES, since it allows
KVM MMU code to rely solely on xarray state and not have to query RMP
table to check if a particular PFN needs an RMPUPDATE before mapping it
into RMP table.

At least... it would *in theory*, if the RMPUPDATE happened under
protection of mmu_invalidate_seq (in which case it could inherit all the
same protections KVM MMU has around mmu_invalidate_seq/fault->mmu_seq,
e.g. letting the guest retry the #PF if fault->mmu_seq is stale).

But currently, RMPUPDATE (via kvm_arch_post_set_memory_attributes) happens
*after* the invalidation sequence above, so in theory a guest could fault
on a page just after xarray state is updated, but before the RMPUPDATE has
been done, in which case the KVM MMU code would properly map the page
accordingly to xarray, but since RMPUPDATE wouldn't have happened yet, the
state of the corresponding PFN in RMP table won't match the shared/private
access type expected by the guest, so when it tries to access it it will
get another #NPF with RMP bit set in the error code, which will get
handled as a no-op in handle_rmp_page_fault() (patch #44) and loop like
this until the RMPUPDATE is finally done. So it still works out, but
maybe not keeping as much in sync with xarray state and could be.

But deferring RMPUPDATE to fault time goes in the other direction of
that. Are there benefits/requirements for doing things this way for TDX?
I could see it being beneficial in terms of reducing overhead for
uneeded page-state transitions, since they are only done on-demand but
doesn't seem like it would be that much overhead compared to some of the
other operations being done.

> 
> If no, guess we need a x86 ops to tell if a zapping is required.

Sorry don't think I quite understand the suggestion. What would this
zapping be covering vs. the invalidation sequence that currently happens
in kvm_vm_ioctl_set_mem_attributes()?

> 
> Back to the lock, updating RMP table doesn't require a mutex. Taking
> the lock is required when updating the directmap. both TDX/SNP requires
> this update the directmap when changing memory attributes.

Is that confirmed? If so, do you have a pointer to the associated
documentation? I'm a bit unclear on this due to above-mentioned
discussion.

> 
> Wouldn't it better to factor the touching directmap of kernel part out?

It actually needs to happen before the RMPUPDATE. As soon as there is a
shared->private conversion in the RMP table for a particular PFN, then
any access via directmap by any particular kernel thread to any PFN that
happens to be in the same physical 2M range can cause an RMP fault on
the host, which would be fatal. So the rmpupdate() helper in this series
will unmap directmap entry corresponding the PFN before a shared->private
RMPUPDATE, and restore mappings after private->shared RMPUPDATE

So we could still factor it out, but it would be something like:

  if (attr == private)
    kvm_unmap_directmap(start, end)
  kvm_mem_attrs_changed()
  if (attr == shared)
    kvm_map_directmap(start, end)

> 
> Then you can call the x86 ops.update_mem_attr() in kvm_mem_attrs_changed().
> And update the direct kernel mapping for both TDX/SNP in the
> kvm_post_mem_attrs_changed().

Or, adjusting for the above logic, move the unmapping/mapping to a new
kvm_pre_mem_attrs_changed() and kvm_post_mem_attrs_changed(), respectively.

Which seems pretty reasonable to me. Then we can:
 - drop duplicating the kvm_for_each_memslot_in_gfn_range() walk stuff because
   we'd just need to know what PFNs to map/unmap from directmap
   (although we'd still need a loop around kvm_restrictedmem_get_pfn()
   for the GFN range so not necessarily prettier)
 - call the RMPUPDATE / corresponding TDX handling via kvm_mem_attrs_changed()
   which brings it both under KVM MMU lock and also let's it piggyback
   off the fault->mmu_seq handling so it doesn't get out of sync with
   xarray during fault time.

But would be good to hear others' opinions on this. And also confirm
whether TDX needs that pre/post directmap handle or not.

Thanks!

-Mike

> 
> > 
> > -Mike
> > 
> > > 
> > > From 7c618c1f3c236c382e64680efcbe7d8a672aa870 Mon Sep 17 00:00:00 2001
> > > Message-Id: <7c618c1f3c236c382e64680efcbe7d8a672aa870.1679114841.git.isaku.yamahata@intel.com>
> > > In-Reply-To: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> > > References: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Date: Fri, 17 Mar 2023 12:00:09 -0700
> > > Subject: [PATCH 4/4] KVM: x86: Add 'set_mem_attr' x86 op
> > > 
> > > This callback will do any platform-specific handling needed for
> > > converting pages between shared/private.
> > > 
> > > Originally-by: Michael Roth <michael.roth@amd.com>
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/include/asm/kvm-x86-ops.h | 1 +
> > >  arch/x86/include/asm/kvm_host.h    | 2 ++
> > >  arch/x86/kvm/mmu/mmu.c             | 1 +
> > >  3 files changed, 4 insertions(+)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > index dc5f18ac0bd5..956db2ee25a5 100644
> > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > @@ -100,6 +100,7 @@ KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> > >  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> > >  KVM_X86_OP(load_mmu_pgd)
> > >  KVM_X86_OP(fault_is_private)
> > > +KVM_X86_OP_OPTIONAL(set_mem_attr)
> > >  KVM_X86_OP_OPTIONAL(link_private_spt)
> > >  KVM_X86_OP_OPTIONAL(free_private_spt)
> > >  KVM_X86_OP_OPTIONAL(split_private_spt)
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 0382d236fbf4..88e11dd3afde 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
> > >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > >  			     int root_level);
> > >  	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code);
> > > +	void (*set_mem_attr)(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > +			     unsigned int attr, gfn_t start, gfn_t end);
> > >  
> > >  	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > >  				void *private_spt);
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 0ec94c72895c..329333486e64 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -7908,6 +7908,7 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> > >  				    gfn_t start, gfn_t end)
> > >  {
> > >  	kvm_update_lpage_mixed_flag(kvm, slot, true, attrs, start, end);
> > > +	static_call(kvm_x86_set_mem_attr)(kvm, slot, attrs, start, end);
> > >  }
> > >  
> > >  void kvm_memory_attributes_create_memslot(struct kvm *kvm,
> > > -- 
> > > 2.25.1
> > > 
> > > -- 
> > > Isaku Yamahata <isaku.yamahata@gmail.com>  
> 
> 
