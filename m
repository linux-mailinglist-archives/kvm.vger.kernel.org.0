Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621247406FE
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 01:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjF0X7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 19:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjF0X7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 19:59:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494781FC3;
        Tue, 27 Jun 2023 16:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gADdqXbql3od1RsgL8hI5jQkMIZp8zGXywdziFaVBw3x4BG+xd8q26ncaGgX7nYwx6/7aW2OunDCit2xMKRjt1H/JieEt0tt1xT3U6zPJP5XmTi0vQ7xj8S33EXtgPqn73PUpNHfo5p/N0bFPsZYDZHBkt1kGU9rCZ1zaBufawNnpUwH+j8XrVctMDesc8TohuzQPsJFCzKTfvYE8WK+7bdl7kiHvNXw3/a5aTVriewfq24gYMppbslq5XvaB3F7WTKNT2wejDQkSHXlOfnX514XO+CAiU6n9cCD2ToXqNzOLlnuwep/1OoEbl7IzkPyRvaqclhm9QWH2/UoaWpjGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xK+UQIZocNImMdTK8FGtWxKw6RpPfkGjG4LIbMcYzw=;
 b=g5ArYXxXiDxnJUNt2AU8XdZ5JqdJAY8ywPz08qETLgIEtJ8JqasEIClLrjRLuaieBQtt7z9ESkcJcKPheQenK0OSkqlH6dwp84YpH+7NYIvoh2wpfoUZrZvHxKd4C1mqJc+c3pCl6F9SnxajnhIbCViuj4s6iPUjhN1bhJdhZBpUPYszFZ5OHEgDtOIKbHJrb9SIG3jAq83S9FBce9GKr7P5pi+4kq93Eo218sLHfgHPU3drmELQWWgm/M/VXQNDUyXZOZ/IL4KSq6JG5jrH9WHIM/iTy5mKRAnfmjbwbsFWgBce8+ejeXpsjh0qLf/CkwQPscdOyGVTCOFvb2P5/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xK+UQIZocNImMdTK8FGtWxKw6RpPfkGjG4LIbMcYzw=;
 b=UpV5OtrtRFgRDZD9DgixKnhJOGFF6mlPv0JxfUvM+c7tBmLRV7SF/9grIhHrzm69y0dYQWhPlSzyysWKcFW7ghKZpb43C8MCBi5k6V73aHtpx2qnFlY7jdMptkS3h5C8JAbvb7NjomkI7pHSXZM0QkBZbsX0GzxwwJiuxi4mVhM=
Received: from BN9PR03CA0119.namprd03.prod.outlook.com (2603:10b6:408:fd::34)
 by CY8PR12MB7634.namprd12.prod.outlook.com (2603:10b6:930:9d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Tue, 27 Jun
 2023 23:59:04 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::96) by BN9PR03CA0119.outlook.office365.com
 (2603:10b6:408:fd::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.34 via Frontend
 Transport; Tue, 27 Jun 2023 23:59:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.48 via Frontend Transport; Tue, 27 Jun 2023 23:59:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 27 Jun
 2023 18:59:03 -0500
Date:   Tue, 27 Jun 2023 18:58:45 -0500
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
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: x86: Introduce fault type to indicate
 kvm page fault is private
Message-ID: <20230627235845.qixtneay2tiv6xuu@amd.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <a3a19de92c7ac6e607ac3e663d84a4312876084b.1687474039.git.isaku.yamahata@intel.com>
 <ZJX6s2HxbHOUMXlj@google.com>
 <20230626010753.xru5ph3irmyokrgc@amd.com>
 <ZJnXObRHhn5Q1dX2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZJnXObRHhn5Q1dX2@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|CY8PR12MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 89ae2d90-7cd1-4716-f2eb-08db776a7c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X2uqVytGTxlcwYTvBrPcgrSPIN7fdv8Hr6BK++zMpGx57lshwm0/Who0szJELnwHn1ZH8JtEx1NpSS2yW+zb5P/1rjuTznXU1aeuq7EjhT6eadRG7khMljE1jRn9gN2qyFAFlt/SoLwFeGqDvI8ITruVXtF29acGTz66blb6DYCSjs9K61QluY7IhoCVjhjsQa+YaC3xB41KEpSDBb10rc8y4WmZlX/JzNnIl2GHRXDucn/W0buYMVw9SiZfJvw6qeFkRirc1qeUXp46M9Kmo3vpS8sngPK/wcDf9dOK6UMK3iwPT+vCRsaVUcRuuLPAHKTknzmukGT9e1eMF0/V2Yhy9IHHHl2qRD3Ri01c8++vrShPdAWP1xJgoS0F/cPzv85dvbOrrR9SSqPQubD18XGJeJRSyAfLVivj1+68NTz04CtnGFEtV8Xw/OXskmMWYNtTsVgHativ+CrTOUPSHzywGu+YKf7ptS6zHm8wlBjtoxo36OPFWu/X00w9oj0bflhAroVmJSkG/jubGDfLLc1y4JXz94JgfNkoqL77d/YmdfdmcMbqQikmxiFgOB1oA9B5oeWXXKJp3JHQDQxITDO7SfOVdbD0s2Q7zkDGwbqkpEGOMY3w3IKDSTVBHbx57PaahBWyW15JMX0FADeYL8ZOCOMxEb0Ll/FXwdojIdIQT0BBTf9V5Lagka7xGj4biVYjRjQGe5G9CvZ0F2AiA+eLYrtiNeX1CY9af1vuEn56vKJhr6c5x4KY6KG1gwMPubPfK+bqTUb9iQkcvgxvWw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199021)(36840700001)(40470700004)(46966006)(83380400001)(54906003)(478600001)(6666004)(1076003)(81166007)(2906002)(26005)(186003)(30864003)(82310400005)(16526019)(70586007)(316002)(7416002)(44832011)(356005)(41300700001)(70206006)(5660300002)(8676002)(36756003)(4326008)(6916009)(8936002)(426003)(86362001)(82740400003)(36860700001)(336012)(47076005)(2616005)(40480700001)(40460700003)(66899021)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 23:59:03.8179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ae2d90-7cd1-4716-f2eb-08db776a7c4b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7634
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

On Mon, Jun 26, 2023 at 11:21:45AM -0700, Sean Christopherson wrote:
> On Sun, Jun 25, 2023, Michael Roth wrote:
> > On Fri, Jun 23, 2023 at 01:04:03PM -0700, Sean Christopherson wrote:
> > > On Thu, Jun 22, 2023, isaku.yamahata@intel.com wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > > > index 7f9ec1e5b136..0ec0b927a391 100644
> > > > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > > > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > > > @@ -188,6 +188,13 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
> > > >  	return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
> > > >  }
> > > >  
> > > > +enum kvm_fault_type {
> > > > +	KVM_FAULT_MEM_ATTR,
> > > > +	KVM_FAULT_SHARED,
> > > > +	KVM_FAULT_SHARED_ALWAYS,
> > > > +	KVM_FAULT_PRIVATE,
> > > 
> > > This is silly.  Just use AMD's error code bit, i.e. PFERR_GUEST_ENC_MASK as per
> > > the SNP series.
> > > 
> > >   Bit 34 (ENC): Set to 1 if the guest’s effective C-bit was 1, 0 otherwise.
> > > 
> > > Just because Intel's ucode is too crusty to support error codes larger than 16
> > > bits doesn't mean KVM can't utilize the bits :-)  KVM already translates to AMD's
> > > error codes for other things, e.g.
> > > 
> > > 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
> > > 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> > > 
> > > For TDX, handle_ept_violation() can do something like:
> > > 
> > > 	if (is_tdx(vcpu->kvm))
> > > 		error_code |= (gpa & shared) ? 0 : PFERR_GUEST_ENC_MASK;
> > > 	else if (kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(gpa)))
> > > 		error_code |= PFERR_GUEST_ENC_MASK;
> > 
> > Maybe this is what you're getting at below, but seems awkward to have this
> > being handling in TDX code since that would suggest that SVM module would
> > also need to duplicate that logic and synthesize this PFERR_GUEST_ENC_MASK
> > bit for non-SNP VMs (e.g. gmem self-tests).
> 
> Ah, right, forgot about that angle.  The non-TDX synthesizing can be done in
> kvm_mmu_page_fault(), e.g.
> 
> 	if (vcpu->kvm->vm_type == KVM_X86_PROTECTED_VM &&
> 	    kvm_mem_is_private(...))
> 		error_code |= PFERR_GUEST_ENC_MASK;
> 
> > So maybe SNP/TDX can rely on passing this via error_code, and then some
> > common code, like kvm_mem_is_private(), can handle this for non-TDX/SNP
> > guest types. But the current gmem series does this via a new .is_private
> > in kvm_page_fault:
> > 
> >   .is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
> > 
> > This seems at odds with the idea of storing this 'fault->is_private'
> > logic into the error_code. Isaku and I were discussing[1] that we
> > should do one or the other:
> > 
> >   a) store everything in error_code
> >   b) use the .is_private field that seems to have been introduced to
> >      track exactly this information
> > 
> > So I think this series is attempting to do b). If you're suggesting we
> > should do a), then what purpose is fault->is_private field meant to
> > serve? Are you planning to get rid of it? Otherwise it seems redundant.
> > 
> > But I think approach b) is useful for another reason:
> 
> "is_private" would serve the same purpose as all the other bits that are derived
> from the error code, e.g. improve readability, reduce line lengths, etc.  Though
> looking at the name, just "private" is probably the right name.
> 
> 	/* Derived from error_code.  */
> 	const bool exec;
> 	const bool write;
> 	const bool present;
> 	const bool rsvd;
> 	const bool user;

If we go out of our way to pull bits out of error_code so they can be
accessed more consistently/sensibly, why introduce additional bits into
error_code in the first place? It just seems like an unecessary
intermediate step, and introduces error_code bits that TDX/selftests
don't actually ever need, which raises the specter of "what if hardware
starts using this synthetic bit for something else?"

Is it mainly to avoid introducing additional parameters to
kvm_mmu_page_fault() and instead piggy-backing off of error_code param?
Or does recording the values into error_code have a use outside of that?

> 
> > > And that's not even taking into account that TDX might have a separate entry point,
> > > i.e. the "is_tdx()" check can probably be avoided.
> > > 
> > > As for optimizing kvm_mem_is_private() to avoid unnecessary xarray lookups, that
> > > can and should be done separately, e.g.
> > > 
> > >   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> > >   {
> > > 	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
> > > 	       kvm_guest_has_private_mem(kvm) &&
> > > 	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> > >   }
> > > 
> > > where x86's implementation of kvm_guest_has_private_mem() can be
> > > 
> > >   #define kvm_guest_has_private_mem(kvm) (!!(kvm)->vm_type)
> > 
> > It's just about not checking xarray for non-protected case. The
> > optimization here is that neither TDX nor SNP care about the xarray as
> > far as determining whether the *fault* was a private or not.
> 
> Yes, and what I am suggesting doesn't use kvm_mem_is_private() to synthesize that
> flag for TDX (or SNP).
> 
> > We only care later, in part of the KVM MMU code that determines whether the
> > fault type is at odds with the xarray state and whether to generate a
> > KVM_EXIT_MEMORY_FAULT as a result.
> > 
> > In that code, both TDX/SNP, as well as gmem self-tests, will all end up
> > calling kvm_mem_is_private().
> > 
> > In the gmem self-test case, in current gmem base series, and I think with
> > what you've proposed here, we'd check the xarray via kvm_mem_is_privae(),
> > both in kvm_mmu_do_page_fault(), as well as later kvm_faultin_pfn() where
> > KVM_EXIT_MEMORY_FAULT case is handled. That seems off because:
> > 
> >   1) Checking in kvm_mem_is_private() via kvm_mmu_do_page_fault() means
> >      that we will grab the value prior to when the KVM MMU records the
> >      mmu_invalidate_seq, which means there's a window between
> >      kvm_mmu_do_page_fault() and kvm_faultin_pfn() where an updated
> >      xarray won't be noticed, and the #NPF retry logic will not get
> >      triggered.
> 
> That's ok-ish, for some definitions of ok.  There's no fatal bug, but userspace
> will see a spurious, arguably nonsensical exit.  If the race occurs before mmu_seq
> is snapshot, this code will detect the change and exit to userspace.
> 
> 	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
> 		return kvm_do_memory_fault_exit(vcpu, fault);

Yah, that's not so bad, but it does make it more tricky to write tighter
tests since you always have to allow/handle spurious KVM_EXIT_MEMORY
faults instead of being able to individually flag those non-sensical
cases. Not a huge deal I guess.

> 
> >   2) For gmem self-test, kvm_mem_is_private() is the authority on
> >      whether the fault is private or not. There's no need to distinguish
> >      between what was set via KVM_SET_MEMORY_ATTRIBUTES, vs. what was
> >      indicated via fault flags/GPA like TDX/SNP do.
> > 
> > So it makes sense, in the gmem case (and TDX/SNP), to defer the
> > kvm_mem_is_private() till later in kvm_faultin_pfn(). It avoid a
> > duplicate lookup, and a race. But .is_private only conveys
> > encrypted/unencrypted fault in TDX/SNP case, it doesn't have a way to
> > cleanly convey this case "just use whatever kvm_mem_is_private() reports
> > later, because it will always be what the VMM set, and it's too early
> > to check kvm_mem_is_private() right now".
> 
> Yeah, the duplicate lookup is unfortunate :-/  But I'd really like to be able to
> make kvm_page_fault.private const, just like all the other booleans that are
> derived from the error code.  My concern with making it *not* const is that
> there will be a discrepancy between "private" and "error_code", and we'll have
> to be very careful to never touch "private" before kvm_faultin_pfn().

It can actually be const using the KVM_FAULT_{VMM_DEFINED,SHARED,PRIVATE} 
abstraction. fault->is_private doesn't really need to be overwritten for
VMM_DEFINED case later, it can just be treated as "use whatever
kvm_mem_is_private() reports". But I guess that's what you mean by
"special casing" below.

> 
> And I don't want to special case "VMM defined", because the primary reason the
> "VMM defined" case exists at this time is to allow testing KVM's implementation
> without TDX or SNP.  E.g. I don't want to end up with code in fast_page_fault()

Are you suggesting VMM_DEFINED would eventually go away once SNP/TDX
have bigger uptake, or maybe in favor of tests built around some new VM type
(e.g. software-protected VMs) that use guest hypercalls to set
guest-expected memory state rather than always relying on what the VMM sets
up?

I guess in that case VMM_DEFINED handling could just be dropped at
that point, and KVM_FAULT_{SHARED,PRIVATE} would still be relevant (or they
could get switched back to bool at that point), and software-protected VMs
would set that value based on whatever state tracks the hypercalls.

But if that's the end-game maybe it's a good reason for keeping
fault->is_private bool and avoiding enums. But still don't really see the
worth in also setting the bit in error_code.

> without TDX or SNP.  E.g. I don't want to end up with code in fast_page_fault()
> or so that does X for KVM_FAULT_VMM_DEFINED, but Y for KVM_FAULT_PRIVATE.

Hadn't really considered fast_page_fault() for SNP... it seems like
for explicit page-state changes, the vCPU issuing the conversions
would just block until the GHCB request it issued was completed. So by
the time it accesses the GPA, KVM_SET_MEMORY_ATTRIBUTES would have
already zapped the old entry, so the fast path would get bypassed at
that point.

For implicit page-state changes, I guess there's a risk you can
get stuck looping on fast_page_fault() since it's up to KVM MMU
to generate the KVM_EXIT_MEMORY_FAULT so KVM_SET_MEMORY_ATTRIBUTES
gets called eventually. Sort of surprised I haven't encountered
that case though... but anyway...

If you rely on similar checks to what slow path does:

 	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
 		return kvm_do_memory_fault_exit(vcpu, fault);

kvm_mem_is_private() could be stale due to unnoticed invalidation,
but eventually it would reach steady-state and the
KVM_EXIT_MEMORY_FAULT would fire. Is that sort of what you have in
mind there?

For SNP it seems more efficient to check for RMP bit and then head
straight to the slow-path, but this isn't a hot path so probably
doesn't matter much.

> 
> So I'm leaning toward the above be
> 
> 	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> 		if (vcpu->kvm->vm_type == KVM_X86_PROTECTED_VM)
> 			return RET_PF_RETRY;
> 		else
> 			return kvm_do_memory_fault_exit(vcpu, fault);
> 	}
> 
> even though software-protected VMs would perform a technically-unnecessary
> attributes lookup.  *If* software-protected VMs ever get to the point where folks
> care about the performance overhead of the extra lookup, then I'm all for
> revisiting the implementation, but that is a ginormous "if" at this point.  Though
> even then I'd still prefer to figure out a way to make the flag const, but that's
> a future problem.
> 
> > So that's where this enum type came from. Although in the discussion I
> > linked to above I suggested just:
> > 
> >   enum kvm_fault_type {
> >     KVM_FAULT_VMM_DEFINED,
> >     KVM_FAULT_SHARED,
> >     KVM_FAULT_PRIVATE,
> > 
> > Which I think would work just as well,
> 
> I want to use vm_type for tracking "VMM_DEFINED".  KVM's ABI easily allows for 64
> VM types, I see no reason to reuse KVM_X86_PROTECTED_VM for TDX and/or SNP, though
> the type probably should be KVM_X86_SW_PROTECTED_VM.  With that out of the way,
> there's no need for an enum to track shared vs. private.
> 

Introducing TDX/SNP vm types seems to buy us some flexibility so it
sounds useful.

Rather than synthesizing bits in error_code, maybe we could also use it
to help out there as well? (assuming parameter-passing was the main
use-case there)

  static bool kvm_fault_is_private(kvm, gpa, error_code)
  {
    if (kvm->vm_type == KVM_X86_TDX_VM)
      return gpa & TDX_SHARED_GPA_MASK;

    if (kvm->vm_type == KVM_X86_SNP_VM)
      return error_code & PFERR_GUEST_ENC_MASK;

    return kvm_mem_is_private(kvm, gpa);
  }

  static inline int kvm_mmu_do_page_fault(vcpu, gpa, err, ...)
  {
    struct kvm_page_fault = {
      ...
      .is_private = kvm_fault_is_private(kvm, gpa, err)
    };

    ...
  }

-Mike
