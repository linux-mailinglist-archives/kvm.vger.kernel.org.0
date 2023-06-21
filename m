Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF697392C1
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjFUXA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjFUXA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:00:56 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6848B19AC;
        Wed, 21 Jun 2023 16:00:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+HKC9u5uzowVE8qzdkK09Wk5jnWZkiTfZ0wIzYAojIUpEm517vUQ64tTsyrifWNq/c9SHsltSthrd1Vyli90SpKOI3T5zIaMyNb0fAV8Kyu3D6LNjE03t1gTf0ZJEclnBiAEUQYWENDxj68IIoj6IVdC05P5FIikUTn1mKe7h/pbTDEL6ms1aCLOrYyiVjja7fL2Nih4PG2P9NRR9aG5400W58GNaMtxA9YOQn2Q0VB9zVdREM2PbYs4DCevL6mkrAaF24heHs3D4WlOmP2UOKBFfe61rjWeqoT3gx/cBcEeVqOegx0ME239gHzhH05fnto1v4ZBLK998Q7n+Ey4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPLngqNlgh8qSF2ge0kMqCLy6y+oKEC2AAVkGPr07ek=;
 b=nRUd601Y3KKLRjc+sCIEN5vIq6PU0z6JiQJOoh1o+tXt5Zvk6hhM6daavvzP/gGjvk8fcKEGqK+/wDRYaBcljQ1mzyXXga1+5oVd1tWEa5Eq2yYf7jOb2Gt9QUdy/LL+IKac8dgy9vMonKR1c/jNuJ2rzQlikteal0nJ8vsDMaxU6SafZ6XsRuDUCnOQU+VRbRQjwS15xKSTBGhcEPHbSik+xUEYUagGuQ36PhuzYVESut9ETknnifEjrIjCoK7oFrZAcrPDPlbQioqxuJGFMScngfmX13q17YXahfHniWn7jxA454CjdyPOBLYzYqzf6VVdD3VFmSf22L4jadSKZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPLngqNlgh8qSF2ge0kMqCLy6y+oKEC2AAVkGPr07ek=;
 b=YfQj9Ck6Mj5PNjznYunp97ptPaDSL1OeqTiXyU27IEoqiQn+QL6D6+0zXuphFAO8Q4zsc02XBOHPLhWicTAOqzB/Pin6LmGfUbPPc/km2kR9igAUxx7HVgNqDswMQ381cavrudtSQRXUniubpSfW6/oWMmepjLLBnWiVf2u8YU4=
Received: from DS7PR03CA0321.namprd03.prod.outlook.com (2603:10b6:8:2b::6) by
 SA3PR12MB7782.namprd12.prod.outlook.com (2603:10b6:806:31c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 23:00:51 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::d1) by DS7PR03CA0321.outlook.office365.com
 (2603:10b6:8:2b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:00:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.37 via Frontend Transport; Wed, 21 Jun 2023 23:00:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:00:50 -0500
Date:   Wed, 21 Jun 2023 18:00:31 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Message-ID: <20230621230031.37hdnymbjzwjgbo2@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-5-michael.roth@amd.com>
 <20230614164709.GT2244082@ls.amr.corp.intel.com>
 <20230620202841.7qizls3u3kcck45g@amd.com>
 <20230620211845.GV2244082@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230620211845.GV2244082@ls.amr.corp.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT046:EE_|SA3PR12MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: f5075f13-e7e1-46f1-7e51-08db72ab5c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sma25HMm6hodeWkb1Ta0H+ippelY1ho1iEzVy/8i9Ho46YdqWgmQ2zJpX0RHp/2xNovgiCIgzo5DlQLkOXZ8zVM9Isgd+M9bIYhi739cTwV6IVaX/I0ALzoLwE2QvVmujcUprODern5y5mAg0WlfBg2GfcZNjakU2freoKLJehMYOGB//hcgUk596Ak8qwA2kfSFbgJ0+pqVcsSbNAjxOi3JqIYrL5La2Xkp2vUxZq2SMXDHGqjdQG+Hw//WjWImxcr8lH2fYCkAJOOW/RvPfvcpBnXp487lGgfbRmauvhAongVQXZj23CinOf9XdRc0BfmAHRkv8J6hzJDfeEFiw4Yp8dhsaKci139WPGzeDLoRWo6KVUGMPXJIy2qjqjxE8pQtbHNV3igw+76xZxqaPgFKEv/BwhS2MibLf6KdE9lDKgshiiVfW0qu36xj0V8T4ePS89gl/dlunkm9DDGyJr6tGpA8E5GeTDeNKgyjyQgdtYrfZhvqRHNTAlCTJ2/HavgIfiiO/caGiKdwOmgyhwt3FTLoWp6chB03BwlYpIGC7ZEGUrzEbUXuBUV/+Zh/dHeRT0ua1Bf6ql0W9OEbmOBkRxpUHlIehA+z/s/dyP4MNxlgvcIVmcL73LIvoQD7A2NXrcTurDl5cE+VG8Q1p29fOq3BxWOqWmvbLlnH7GXPWhdOspBuMD2vWm2PGCFdSCf3UaCqY9XsiPrgUExRd8Etd/PMw2AtSaKjtMlA0JumSm07/i/P91Hkky19hYkXH4JxiK7vR+REgT9hbFWjYw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(5660300002)(44832011)(7416002)(7406005)(2906002)(40480700001)(82310400005)(70206006)(8676002)(356005)(81166007)(47076005)(83380400001)(426003)(36860700001)(36756003)(86362001)(82740400003)(6666004)(6916009)(4326008)(8936002)(478600001)(70586007)(54906003)(41300700001)(186003)(16526019)(26005)(336012)(2616005)(316002)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:00:51.2243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5075f13-e7e1-46f1-7e51-08db72ab5c1b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7782
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 02:18:45PM -0700, Isaku Yamahata wrote:
> On Tue, Jun 20, 2023 at 03:28:41PM -0500,
> Michael Roth <michael.roth@amd.com> wrote:
> 
> > On Wed, Jun 14, 2023 at 09:47:09AM -0700, Isaku Yamahata wrote:
> > > On Sun, Jun 11, 2023 at 11:25:12PM -0500,
> > > Michael Roth <michael.roth@amd.com> wrote:
> > > 
> > > > This will be used to determine whether or not an #NPF should be serviced
> > > > using a normal page vs. a guarded/gmem one.
> > > > 
> > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > ---
> > > >  arch/x86/include/asm/kvm_host.h |  7 +++++++
> > > >  arch/x86/kvm/mmu/mmu_internal.h | 35 ++++++++++++++++++++++++++++++++-
> > > >  2 files changed, 41 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index b3bd24f2a390..c26f76641121 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1445,6 +1445,13 @@ struct kvm_arch {
> > > >  	 */
> > > >  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> > > >  	struct kvm_mmu_memory_cache split_desc_cache;
> > > > +
> > > > +	/*
> > > > +	 * When set, used to determine whether a fault should be treated as
> > > > +	 * private in the context of protected VMs which use a separate gmem
> > > > +	 * pool to back private guest pages.
> > > > +	 */
> > > > +	u64 mmu_private_fault_mask;
> > > >  };
> > > >  
> > > >  struct kvm_vm_stat {
> > > > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > > > index 780b91e1da9f..9b9e75aa43f4 100644
> > > > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > > > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > > > @@ -252,6 +252,39 @@ struct kvm_page_fault {
> > > >  
> > > >  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
> > > >  
> > > > +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
> > > > +{
> > > > +	struct kvm_memory_slot *slot;
> > > > +	bool private_fault = false;
> > > > +	gfn_t gfn = gpa_to_gfn(gpa);
> > > > +
> > > > +	slot = gfn_to_memslot(kvm, gfn);
> > > > +	if (!slot) {
> > > > +		pr_debug("%s: no slot, GFN: 0x%llx\n", __func__, gfn);
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	if (!kvm_slot_can_be_private(slot)) {
> > > > +		pr_debug("%s: slot is not private, GFN: 0x%llx\n", __func__, gfn);
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	if (kvm->arch.mmu_private_fault_mask) {
> > > > +		private_fault = !!(err & kvm->arch.mmu_private_fault_mask);
> > > > +		goto out;
> > > > +	}
> > > 
> > > What's the convention of err? Can we abstract it by introducing a new bit
> > > PFERR_PRIVATE_MASK? The caller sets it based on arch specific value.
> > > the logic will be
> > >         .is_private = err & PFERR_PRIVATE_MASK;
> > 
> > I'm not sure I understand the question. 'err' is just the page fault flags,
> > and arch.mmu_private_fault_mask is something that can be set on a
> > per-platform basis when running in a mode where shared/private access
> > is recorded in the page fault flags during a #NPF.
> > 
> > I'm not sure how we'd keep the handling cross-platform by moving to a macro,
> > since TDX uses a different bit, and we'd want to be able to build a
> > SNP+TDX kernel that could run on either type of hardware.
> > 
> > Are you suggesting to reverse that and have err be set in a platform-specific
> > way and then use a common PFERR_PRIVATE_MASK that's software-defined and
> > consistent across platforms? That could work, but existing handling seems
> > to use page fault flags as-is, keeping the hardware-set values, rather than
> > modifying them to pass additional metadata, so it seems like it might
> > make things more confusing to make an exception to that here. Or are
> > there other cases where it's done that way?
> 
> I meant the latter, making PFERR_PRIVATE_MASK common software-defined.
> 
> I think the SVM fault handler can use hardware value directly by carefully
> defining those PFERR values.
> 
> TDX doesn't have architectural bit in error code to indicate the private fault.
> It's coded in faulted address as shared bit. GPA bit 51 or 47.
> PFERR_{USER, WRITE, FETCH, PRESENT} are already software-defined value for VMX
> (and TDX).  The fault handler for VMX, handle_ept_violation(), converts
> encoding.  For TDX, PFERR_PRIVATE_MASK is just one more software defined bit.
> 
> I'm fine with either way, variable or macro. Which do you prefer?
> 
> - Define variable mmu_private_fault_mask (global or per struct kvm)
>   The module initialization code, hardware_setup(), sets mmu_private_fault_mask.
> - Define the software defined value, PFERR_PRIVATE_MASK.
>   The caller of kvm_mmu_page_fault() parses the hardware value and construct
>   software defined error_code.
> - any other?
>   
> 
> > > > +
> > > > +	/*
> > > > +	 * Handling below is for UPM self-tests and guests that treat userspace
> > > > +	 * as the authority on whether a fault should be private or not.
> > > > +	 */
> > > > +	private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> > > 
> > > This code path is sad. One extra slot lookup and xarray look up.
> > > Without mmu lock, the result can change by other vcpu.
> > > Let's find a better way.
> > 
> > The intention was to rely on fault->mmu_seq to determine if a
> > KVM_SET_MEMORY_ATTRIBUTES update came in after .private_fault was set so
> > that fault handling could be retried, but that doesn't happen until
> > kvm_faultin_pfn() which is *after* this is logged. So yes, I think there
> > is a race here, and the approach you took in your Misc. series of
> > keeping the kvm_mem_is_private() check inside kvm_faultin_pfn() is more
> > efficient/correct.
> > 
> > If we can figure out a way to handle checking the fault flags in a way
> > that works for both TDX/SNP (and KVM self-test use-case) we can
> > consolidate around that.
> 
> I can think of the following ways. I think the second option is better because
> we don't need exit bit for error code.
> 
> - Introduce software defined error code
> - Add a flags to struct kvm_arch for self-test use-case VM_TYPE_PROTECTED_VM.
>   Set it to true for VM_TYPE_PROTECTED_VM case.
> - any other?

Vishal: hoping to get your thoughts here as well from the perspective of
the KVM self-test use-case.

I was thinking that once we set fault->is_private, that sort of
becomes our "software-defined" bit, and what KVM would use from that
point forward to determine whether or not the access should be treated
as a private one or not, and that whatever handler sets
fault->is_private would encapsulate away all the platform-specific
bit-checking needed to do that.

So if we were to straight-forwardly implement that based on how TDX
currently handles checking for the shared bit in GPA, paired with how
SEV-SNP handles checking for private bit in fault flags, it would look
something like:

  bool kvm_fault_is_private(kvm, gpa, err)
  {
    /* SEV-SNP handling */
    if (kvm->arch.mmu_private_fault_mask)
      return !!(err & arch.mmu_private_fault_mask);

    /* TDX handling */
    if (kvm->arch.gfn_shared_mask)
      return !!(gpa & arch.gfn_shared_mask);

    return false;
  }

  kvm_mmu_do_page_fault(vcpu, gpa, err, ...)
  {
    struct kvm_page_fault fault = {
      ...
      .is_private = kvm_fault_is_private(vcpu->kvm, gpa, err)
    };

    ...
  }

And then arch.mmu_private_fault_mask and arch.gfn_shared_mask would be
set per-KVM-instance, just like they are now with current SNP and TDX
patchsets, since stuff like KVM self-test wouldn't be setting those
masks, so it makes sense to do it per-instance in that regard.

But that still gets a little awkward for the KVM self-test use-case where
.is_private should sort of be ignored in favor of whatever the xarray
reports via kvm_mem_is_private(). In your Misc. series I believe you
handled this by introducing a PFERR_HASATTR_MASK bit so we can determine
whether existing value of fault->is_private should be
ignored/overwritten or not.

So maybe kvm_fault_is_private() needs to return an integer value
instead, like:

  enum {
    KVM_FAULT_VMM_DEFINED,
    KVM_FAULT_SHARED,
    KVM_FAULT_PRIVATE,
  }

  bool kvm_fault_is_private(kvm, gpa, err)
  {
    /* SEV-SNP handling */
    if (kvm->arch.mmu_private_fault_mask)
      (err & arch.mmu_private_fault_mask) ? KVM_FAULT_PRIVATE : KVM_FAULT_SHARED

    /* TDX handling */
    if (kvm->arch.gfn_shared_mask)
      (gpa & arch.gfn_shared_mask) ? KVM_FAULT_SHARED : KVM_FAULT_PRIVATE

    return KVM_FAULT_VMM_DEFINED;
  }

And then down in __kvm_faultin_pfn() we do:

  if (fault->is_private == KVM_FAULT_VMM_DEFINED)
    fault->is_private = kvm_mem_is_private(vcpu->kvm, fault->gfn);
  else if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
    return kvm_do_memory_fault_exit(vcpu, fault);

  if (fault->is_private)
    return kvm_faultin_pfn_private(vcpu, fault);

Maybe kvm_fault_is_private() can be simplified based on what direction
we end up taking WRT ongoing discussions like whether we decide to define
KVM_X86_{SNP,TDX}_VM vm_types in addition to the KVM_X86_PROTECTED_VM
type that the selftests uses, but hoping that for this path, any changes
along that line can be encapsulated away in kvm_fault_is_private() without
any/much further churn at the various call-sites like __kvm_faultin_pfn().

We could even push all the above logic down into the KVM self-tests, but
have:

  bool kvm_fault_is_private(kvm, gpa, err) {
    return KVM_FAULT_VMM_DEFINED;
  }

And that would be enough to run self-tests as standalone series, with
TDX/SNP should filling in kvm_fault_is_private() with their
platform-specific handling.

Does that seem reasonable to you? At least as a starting point. 

-Mike

> 
> Thanks,
> -- 
> Isaku Yamahata <isaku.yamahata@gmail.com>
