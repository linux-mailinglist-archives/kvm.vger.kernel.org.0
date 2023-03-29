Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929D26CF7BA
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 01:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjC2XvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 19:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjC2XvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 19:51:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276755FDB;
        Wed, 29 Mar 2023 16:50:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciNfCalUOZ/xXA64nanXdZhIApe3uKO5D/uctkmoPtsBeVde9boPZzhSGO1Rh/jKhmTvwhz3hutl0TjjMHyyNaxazwTxexbeJlj/N97N19tB+IJHQTA3x8CG7FNCev0+egPponYOnT1hBlNmmXKC81Fb2xGS8pd+AB1upGWuTAjw70HhFTyV+E7WMgjMlvYwBA3H6HJjN9PlIUHeq7SAUkVRqBfQ9/zDsAymbu084VQfBC0O3ZzaJDwmrcpAagz5pX0PDjsp2oxYoyltwsFLdvBrlxay9ewoTQuPmQESLCW3SX3JahEx9vcX9Vjx5+iw6DN6NvjJ+PH0Jfldty81Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRQS+QK3N3mxrNhDTh9kRz6Ku42rDt89DrAXv1CiaSI=;
 b=haDw2Sp1w5qn8Fk++TWyjuSYF/jKRojA7oB6MtnEWFEeXu30SR1AQIKTbBvOZXXNnTtRAI4USJKmfFky661tAFC+NgiXAkI328i32hYyxwqMujWKt5dVj+wpwdmXZymCUvpHWAHprNbkaKYPSLkjc+FgPNET77/PeklWH4wjDs7q47NBvltsmKj9x9qa5d8he0ZePpdqnGT7+pMJxn+aUdBXtNzgQEvKhxtWyow1gNIseukMNT9Syj0F7MWJaNsJl7/z3u+vtwzFgCXbx6XCDNBwN0bKiVGI3SZxxuxwFSclxG5Z+5OS+wY4onQu3UFXaGPgp6ewoyYs6gH0v4wbRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRQS+QK3N3mxrNhDTh9kRz6Ku42rDt89DrAXv1CiaSI=;
 b=mHk8tF94fNb31LuzoKoKu1t05lEeOis5fLocRZC68lc5Pdh5chq4JxrAsN1afULjcRrbvHDvswc++OkTarSW7CvmTQcxxK8+u47PrInwrDB3wEpDtuo8z7XT0dk/fT7jUH2PvMYqX7Fkz85M6WuMjSdQce6Q8zHOZhMRQX0nZUY=
Received: from DM6PR13CA0006.namprd13.prod.outlook.com (2603:10b6:5:bc::19) by
 MW4PR12MB7311.namprd12.prod.outlook.com (2603:10b6:303:227::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.29; Wed, 29 Mar
 2023 23:50:52 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::da) by DM6PR13CA0006.outlook.office365.com
 (2603:10b6:5:bc::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Wed, 29 Mar 2023 23:50:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Wed, 29 Mar 2023 23:50:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 29 Mar
 2023 18:50:51 -0500
Date:   Wed, 29 Mar 2023 18:50:34 -0500
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
Message-ID: <20230329235034.rqgqe32lwq3m3nth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-3-michael.roth@amd.com>
 <20230318045611.GE408922@ls.amr.corp.intel.com>
 <20230320180543.ly4jgu54hyamy2gl@amd.com>
 <20230321132136.00005234@gmail.com>
 <20230322015838.z3bwcrvi4gqag3q6@amd.com>
 <20230323201716.00007662.zhi.wang.linux@gmail.com>
 <20230328043635.bpepzqxaqjla426q@amd.com>
 <20230329020011.0000018a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230329020011.0000018a@gmail.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT072:EE_|MW4PR12MB7311:EE_
X-MS-Office365-Filtering-Correlation-Id: e95f50fc-a688-4e2c-7b13-08db30b06df0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50CXIcOD6f8JiMiUa5q4xFaTEMVYXHkmPOlH0Jze/g8+YF1OqVOD7wAlgsC+l9Oepq37W2s7chMGN2ER2LnXNpCES+LKtXhvwQYobSbKcDviY97HsLrZjBDRUDs8CDt2TRFSSGYFnIEsjANDBDKAt2dCAJFVJqvONAl+F1CFL7mrp7g7I38erFCAi3pnhDYk7BEdDqNTezaM0IRic12fB5ctQmPClIe39V0ITRzKXAsz0js2YluQhGDU02zHjMb1GPkg4XRxsAQcU+UDZWPD79MDnV9jhLWkPoDl+cm7nwxoh4CrcUk2ayN6W7iET2pVL6cRneOH+pyKMMzMdrpwhS/6RFIidzBrKQaAYHSgGUb/mebQlNUnf45axFeJS/f3BeMWHjK/gXpk/PanI0fs0lFvlIj1IhsLzvTJz2w8Q8+LmhSige16jP3mx2D/NWuCaMq0To4IyRjSawRQYjgxu+0vrl8yioXoalmIJi9s581wNdiCm83KtKQSClxs/2EGcbjuEknw6dURBQMqHUKLD/M1WFeo8AfezKnsvBy4SjYyNyjNNcpF/zdFouE1gl5mVn4ZzgDjUyuiP2MY15aswj7//hY48mZ3rpu1qNdNVJjHVe5WPCMMGpZ0eemwptYOFtsHfU3GhCAsiJib9isDZQ83tdMdDaKnzTFlSuWp6d4/fpS0s1OZ+xHOTQJpwRZg6MElsRD1bUAi2Dhtn1tust7h1oTcnULNCbNsBOOf9Wcgsp4ajAOfkHePtFwKepdJCkDDRI294c7Dz3rkmXpZyy19yVDOQ6hqcmDx71HapesUHZALsrjBaWBHTnZc/IVV
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(36840700001)(40470700004)(46966006)(8936002)(66899021)(47076005)(2906002)(83380400001)(426003)(336012)(2616005)(36860700001)(86362001)(36756003)(82740400003)(40460700003)(41300700001)(5660300002)(81166007)(356005)(40480700001)(966005)(478600001)(54906003)(8676002)(6916009)(70206006)(70586007)(4326008)(7416002)(16526019)(15650500001)(82310400005)(30864003)(6666004)(44832011)(186003)(7406005)(1076003)(26005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 23:50:51.9129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e95f50fc-a688-4e2c-7b13-08db30b06df0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7311
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 02:00:11AM +0300, Zhi Wang wrote:
> On Mon, 27 Mar 2023 23:36:35 -0500
> Michael Roth <michael.roth@amd.com> wrote:
> 
> > On Thu, Mar 23, 2023 at 08:17:16PM +0200, Zhi Wang wrote:
> > > On Tue, 21 Mar 2023 20:58:38 -0500
> > > Michael Roth <michael.roth@amd.com> wrote:
> > > 
> > > > On Tue, Mar 21, 2023 at 01:21:36PM +0200, Zhi Wang wrote:
> > > > > On Mon, 20 Mar 2023 13:05:43 -0500
> > > > > Michael Roth <michael.roth@amd.com> wrote:
> > > > > 
> > > > > > On Fri, Mar 17, 2023 at 09:56:11PM -0700, Isaku Yamahata wrote:
> > > > > > > On Mon, Feb 20, 2023 at 12:37:53PM -0600,
> > > > > > > Michael Roth <michael.roth@amd.com> wrote:
> > > > > > >   
> > > > > > > > This callback will do any platform-specific handling needed for
> > > > > > > > converting pages between shared/private.
> > > > > > > > 
> > > > > > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > > > > > ---
> > 
> > <snip>
> > 
> > > > > > > >  static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > > > > > > >  					   struct kvm_memory_attributes *attrs)
> > > > > > > >  {
> > > > > > > > @@ -2602,6 +2628,9 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > > > > > > >  	kvm_mmu_invalidate_end(kvm);
> > > > > > > >  	KVM_MMU_UNLOCK(kvm);
> > > > > > > >  
> > > > > > > > +	if (i > start)
> > > > > > > > +		kvm_post_mem_attrs_changed(kvm, attrs->attributes, start, i);
> > > > > > > > +  
> > > > > > > 
> > > > > > > Doesn't kvm_arch_set_memory_attributes() work for you? i.e the following patch.
> > > > > > > The error check and pr_warn_ratelimited() can be pushed down into the callback.  
> > > > > > 
> > > > > > This is originally how I had but when CONFIG_PREEMPT_COUNT is set this
> > > > > > will generate warnings for this callback as well as the invalidation
> > > > > > callback as reported in v7 here:
> > > > > > 
> > > > > >   https://lore.kernel.org/lkml/Y80vhKwQyw8hS%2F22@notebook/
> > > > > > 
> > > > > > The main issue is that kvm_mem_attrs_changed() is called while holding
> > > > > > the KVM MMU lock, which disables preemption. But when updating
> > > > > > attributes for SNP, we also need to remove private pages from kernel
> > > > > > directmap, which involves acquiring a mutex which results in
> > > > > > "BUG: scheduling while atomic" warnings.
> > > > > > 
> > > > > > So that's why we ended up somewhat duplicating some of the logic and
> > > > > > using a separate callback chain that happens out of KVM MMU lock.
> > > > > 
> > > > > Let's split the things of changing memory attributes:
> > > > > 
> > > > > 1) Update the memory attributes in the xa array (Both TDX and SNP)
> > > > > 2) Zapping the EPT/NPT mappings (Required by TDX)
> > > > > 3) Update RMP table (Required by SNP)
> > > > > 4) Update the directmap of kernel (SNP, but I guess TDX needs it as well)
> > > > 
> > > 
> > > Thanks for the effort of detailed reply. It is very informative.
> > > 
> > > > I'm not so sure TDX requires this. I was under that impression, but
> > > > Kirill raised some doubts about this and I'm not sure it's been
> > > > confirmed. If it's purely an SNP thing then there may not be much value
> > > > in creating a separate callback for it:
> > > > 
> > > >   https://lore.kernel.org/linux-mm/20221031141426.GA3994099@chaop.bj.intel.com/T/#meba4ce80709cd3afd3818b61e6419fd800287b9e
> > > > 
> > > 
> > > Hmm, Krill and Isaku, can you confirm that TDX doesn't need this?
> > > 
> > > I think it is a generic requirement that TDX/SNP are not expecting the
> > > host to touch a private page either from the kernel or the userspace. 
> > 
> > This main issue is that in the case of the RMP table, a write to a 2M
> > mapping is interpreted as a write to a private page even if the write
> > didn't actually touch any private pages within the range. It may be
> > possible in firmware/hardware to distinguish between these 2 cases, but I'm
> > not sure whether that's the case for TDX or not.
> > 
> 
> I was thinking this today. SNP uses this trick to cope with the existing
> HW design. It is mandatory for SNP. What was the benefit of
> removing/restoring the directmap for the purpose of restricting the access
> from the kernel for TDX? Probably catching a wrong touch to a private
> kernel page from the kernel space instead of triggering MCE.

Not sure, but yah might've been something like that.

> 
> My point goes to let them stay in SNP for now as they seems closely coupled
> with RMUPDATE so far and the timing of doing RMUPDATE is still under
> discussion. Maybe we invent some new pre/post, but they turn not necessary
> later if the timing of RMUPDATE is changed.

Makes sense.

> 
> > > 
> > > > And for SNP, the current code does the unmapping/RMP update in the same
> > > > function:
> > > > 
> > > >   [PATCH RFC v8 15/56] x86/sev: Invalidate pages from the direct map when adding them to the RMP table
> > > > 
> > > > I'm not against splitting RMP/directmap handling, but just want to
> > > > understand what the requirements are around that a bit better.
> > > > 
> > > > Does handling the #3 / RMP update / kvm_arch_post_set_memory_attributes
> > > > stuff outside of MMU lock cause issues on TDX side? What sort of
> > > > handling is needed in these callbacks for TDX (if anything)?
> > > > 
> > > 
> > > No, it doesn't cause problem for TDX as TDX doesn't need such callback.
> > > 
> > > Unlike SNP, which has (1 NPT + 1 RMP) and the enforced HW check is done by RMP, TDX has
> > > two EPT(smiliar with NPT)s (1 shared + 1 private). Converting the memory attr is achieved
> > > by zapping the mapping from one EPT and creating the mapping in the other one in the fault
> > > when guest access the memory. The fault GPA will carry the "SHARED" bit (!C-BIT), so
> > > KVM knows which EPT should be chosen for populating the mapping.
> > > 
> > > I was trying to figure out what should be the proper callback and at which layer it should
> > > sit for achieving changing memory attr for both TDX/SNP. The current callback looks a little
> > > bit hacky. Duplicate code pieces because of locks implies the SW structure might need to be
> > > re-considered.
> > > 
> > > > > 
> > > > > Does SNP really need to zap the NPT mappings when changing the memory
> > > > > attributes? (The new mappings will be created later in the fault). I don't
> > > > > find this requirement from APM.
> > > > 
> > > > I don't think we've added anything specifically for SNP. Do you mean the
> > > > generic kvm_unmap_gfn_range/kvm_flush_remote_tlbs sequence below?
> > > > 
> > > >   kvm_vm_ioctl_set_mem_attributes():
> > > >     KVM_MMU_LOCK(kvm)
> > > >     kvm_mmu_invalidate_begin()
> > > >     ...
> > > >     KVM_MMU_UNLOCK(kvm)
> > > > 
> > > >     kvm_vm_set_region_attr()  // xarray/attribute update
> > > > 
> > > >     ...
> > > >     KVM_MMU_LOCK(kvm)
> > > >     kvm_mem_attrs_changed():
> > > >       flush |= kvm_unmap_gfn_range()
> > > >       if (flush)
> > > >         kvm_flush_remote_tlbs()
> > > >     KVM_MMU_UNLOCK(kvm)
> > > >
> > > 
> > > Yes, I was talking about the sequence above. I was confused of why changing
> > > RMP requires a zapping-recreating flow of NPT in SNP.
> > 
> > Hmm, so you're suggesting doing something like moving the
> > kvm_unmap_gfn_range()/kvm_flush_remote_tlbs() into .update_mem_attr()
> > callback so the platform can decide if it needs the zap/flush rather
> > than handling it in generic code?
> > 
> > If SNP really did't need the handling it's an interesting thought, but
> > I think it is needed there after all...
> 
> Yes. I was thinking so. When I was reading the APM, I thought one of the
> advantages of SNP architecture was splitting the HW-enforced check from NPT
> mapping management. Thus when updating the RMP, the NPT can stay as it is. I
> guess that's why I was so fancying of eliminating the extra zapping.

Yah it was an interesting thought. Maybe before the switch to UPM it might've
been possible to avoid the zapping, but seems like it's a fairly general
requirement now.

> 
> After reading the code of the UPM, I think we did need the zapping here for
> SNP as pages for private memory and shared memory seem from different
> sources. shared <->private memory conversion needs to wipe the mapping of
> pages from one source and go through a fault-mapping flow on the pages
> from the other source. Still wondering if there is any good idea to improve
> it based on the current approaches.

It may still be possible to avoiding zapping for shared->private
conversions since the subsequent access with C-bit set would cause an
#NPF with RMP bit set, but yah, it won't work for private->shared and
doesn't seem worth it to complicate the logic for anything SNP-specific
unless it would make a significant performance impact, but I think it
would be lost in the noise vs. RMPUPDATE/initial faulting of private
pages/directmap handling/guest exits for page-state change/etc.

> 
> > 
> > > 
> > > > In general, when the RMPUPDATE instruction happens, the TLB entries for
> > > > the GPAs being modified will be flushed, so subsequent nested page fault
> > > > should be able to obtain the updated mapping based on xarray/#NPF at that
> > > > point. In that respect *maybe* we don't need to zap the entries there.
> > > > 
> > > > But if the nested page fault occurs before the RMPUPDATE, I think we would
> > > > have a race if the above sequence isn't in place to handle the unmap/flush,
> > > > since in that case we might get a stale mapping because nothing would've
> > > > forced a tlbflush.
> > > > 
> > > > There's also stuff like the UPM selftests and SEV lazy-pinning where I
> > > > think that kvm_unmap_gfn_range() sequence is also needed. But I might be
> > > > misunderstanding the question here.
> > > > 
> > > 
> > > In this case, an extra tlbflush would solve? Still, the unnecessary
> > > zapping/recreating of mapping is not promising. I understand that the way
> > > how this patch goes is probably to minimize the changes, but it would be
> > > nice to focus more on what is really needed in a common path and abstract
> > > and re-factor from there.
> > 
> > I tested this and just doing the tlbflush is insufficient. If the
> > entries are still present in nested page table HV doesn't necessarily
> > get an #NPF so the guest can still end up with a stale mapping. After a
> > shared->private conversion the guest would cause #NPF with RMP/ENC bits
> > set once it tries to access it as a private page, but for a
> > private->shared conversion the guest can subsequently access the page
> > with ENC-bit=0 without causing an #NPF, but in this case GFN can still
> > be mapped to the PFN restrictedmem was using to back it when it was in
> > private state, instead of normal non-restricted memory.
> > 
> > So it seems like SNP needs the zapping behavior as well, and that it
> > isn't very different from the TDX/SEV-lazy/selftest users. So having
> > common handling seems worthwhile.
> > 
> > > 
> > > Can you elaborate more about how the lazy-pinning unpin path is connected
> > > with the zapping here? So that I can dig more about it.
> > 
> > Just to be clear this is with regard to SEV lazy-pinning, which makes
> > used of restrictedmem mainly for lazy-pinning of private pages, rather
> > than SNP (which also inherits lazy-pinning from restrictedmem).
> > 
> > The main thing with SEV is that the private/shared status of a page is
> > completely up to how the guest decides to map it in its page tables,
> > unlike with SNP where a mismatch between guest-expected status and
> > actual status in the RMP table will generate a #NPF. So SEV would be
> > even more reliant on current zapping behavior to ensure the NPT will
> > be updated.
> > 
> > > 
> > > Selftest is a minor case, guess we deal with them via enabling a switch.
> > > E.g. a prop in debugfs.
> > 
> > Wouldn't want to break things if a guest was running while selftest was
> > running, or something along that line. Especially since it seems to be a
> > common requirement given the above.
> > 
> > > 
> > > > > If yes, can we postpone the update of the RMP table in the later fault,
> > > > > like TDX? So that we can save this update_mem_attr x86 ops as things
> > > > > will be solved in the SNP-specific fault handler.
> > > > 
> > > > Hmm, I think this would be possible. But it's nice to be able to handle
> > > > the RMPUPDATE as part of KVM_SET_MEMORY_ATTRIBUTES, since it allows
> > > > KVM MMU code to rely solely on xarray state and not have to query RMP
> > > > table to check if a particular PFN needs an RMPUPDATE before mapping it
> > > > into RMP table.
> > > > 
> > > > At least... it would *in theory*, if the RMPUPDATE happened under
> > > > protection of mmu_invalidate_seq (in which case it could inherit all the
> > > > same protections KVM MMU has around mmu_invalidate_seq/fault->mmu_seq,
> > > > e.g. letting the guest retry the #PF if fault->mmu_seq is stale).
> > > > 
> > > > But currently, RMPUPDATE (via kvm_arch_post_set_memory_attributes) happens
> > > > *after* the invalidation sequence above, so in theory a guest could fault
> > > > on a page just after xarray state is updated, but before the RMPUPDATE has
> > > > been done, in which case the KVM MMU code would properly map the page
> > > > accordingly to xarray, but since RMPUPDATE wouldn't have happened yet, the
> > > > state of the corresponding PFN in RMP table won't match the shared/private
> > > > access type expected by the guest, so when it tries to access it it will
> > > > get another #NPF with RMP bit set in the error code, which will get
> > > > handled as a no-op in handle_rmp_page_fault() (patch #44) and loop like
> > > > this until the RMPUPDATE is finally done. So it still works out, but
> > > > maybe not keeping as much in sync with xarray state and could be.
> > > > 
> > > 
> > > I see. rmp fault handler only deals with page size mismatch for now.
> > 
> > That's correct.
> > 
> > > 
> > > > But deferring RMPUPDATE to fault time goes in the other direction of
> > > > that. Are there benefits/requirements for doing things this way for TDX?
> > > > I could see it being beneficial in terms of reducing overhead for
> > > > uneeded page-state transitions, since they are only done on-demand but
> > > > doesn't seem like it would be that much overhead compared to some of the
> > > > other operations being done.
> > > > 
> > > 
> > > Besides the HW design, I guess one major purpose is to optimize the
> > > booting time of VMs with large memory. Also, post migration can be another case.
> > 
> > It seems like without lazy-acceptance support in the guest there isn't
> > too much reason to optimize here, since the guest will necessarily fault
> > in every page as part of pre-accepting the memory in OVMF.
> > 
> 
> Do you mean pre-accepting the whole system memory? or only the initial
> allocated memory for OVMF?

I mean "pre-accepting" in the sense of "guests that don't have
lazy-acceptance enabled", so yes the whole of system memory.

> 
> TDX has already been working in a lazy-acceptance style. I believe the
> lazy-acceptance will be the furture direction. But I understand that part
> can be in stage 2 with the lazy-acceptance for SNP.

For SNP the OVMF bits are there:
  https://www.mail-archive.com/devel@edk2.groups.io/msg53857.html

but guest-side kernel support still requires these patches getting upstream:

  Kirill's base+TDX lazy-acceptance support:
    https://lore.kernel.org/linux-mm/Y7QzI0GqNeG9OHy1@zn.tnic/T/

  Tom's follow-on SNP support:
    https://lore.kernel.org/lkml/cover.1670513353.git.thomas.lendacky@amd.com/

  Dionna's patch to instruct OVMF to not pre-accept remaining memory
  after EFI_EXIT_BOOT_SERVICES:
    https://lore.kernel.org/lkml/def9b0b5-b880-be99-fa95-b05d76a91824@intel.com/T/

But yes, I agree lazy-acceptance will probably be the common default for
TDX/SNP guests, where we'd only be zapping entries that we know the
guest is going to be using anyway, as well as avoiding all the other
related overhead.

> 
> > And if we're making use of lazy-acceptance, for SNP at least, we wouldn't
> > end up getting .update_mem_attr() callbacks in the first place since
> > those are ultimately the result of the guest issuing a shared->private
> > conversion request, which would generally happen until just before the
> > guest decides to accept/pvalidate that GFN. So with lazy-acceptance the
> > guest optimizes most of this potential overhead away already.
> I understand there can be 
> > 
> > > 
> > > Out of curiosity, What is the avg cost of RMUPDATE? Suppose it is an x86
> > > instruction and not going through PSP firmware.
> > 
> > Yes, it's an x86 instruction, no firmware calls there. Average seems to
> > be about 1us per instruction. It's not insignificant, up to 5s for a
> > 16GB guest in a worst case scenario where the guest does not optimize
> > for 2MB shared->private conversions and has no lazy-acceptance support,
> > but it doesn't seem like it would be common to try to boot large guests
> > in such a configuration.
> > 
> I see.
> > > 
> > > > > 
> > > > > If no, guess we need a x86 ops to tell if a zapping is required.
> > > > 
> > > > Sorry don't think I quite understand the suggestion. What would this
> > > > zapping be covering vs. the invalidation sequence that currently happens
> > > > in kvm_vm_ioctl_set_mem_attributes()?
> > > 
> > > I was thinking that zapping of the mapping in EPT/NPT was required by TDX
> > > while SNP might only need an RMP update + TLB flush. Thus, the abstraction
> > > of the kvm_x86_ops.update_mem_attr should sit at this level. But let's
> > > scratch this for now as I need to dig more about the lazy pinning stuff.
> > > 
> > > > 
> > > > > 
> > > > > Back to the lock, updating RMP table doesn't require a mutex. Taking
> > > > > the lock is required when updating the directmap. both TDX/SNP requires
> > > > > this update the directmap when changing memory attributes.
> > > > 
> > > > Is that confirmed? If so, do you have a pointer to the associated
> > > > documentation? I'm a bit unclear on this due to above-mentioned
> > > > discussion.
> > > > 
> > > > > 
> > > > > Wouldn't it better to factor the touching directmap of kernel part out?
> > > > 
> > > > It actually needs to happen before the RMPUPDATE. As soon as there is a
> > > > shared->private conversion in the RMP table for a particular PFN, then
> > > > any access via directmap by any particular kernel thread to any PFN that
> > > > happens to be in the same physical 2M range can cause an RMP fault on
> > > > the host, which would be fatal. So the rmpupdate() helper in this series
> > > > will unmap directmap entry corresponding the PFN before a shared->private
> > > > RMPUPDATE, and restore mappings after private->shared RMPUPDATE
> > > > 
> > > > So we could still factor it out, but it would be something like:
> > > > 
> > > >   if (attr == private)
> > > >     kvm_unmap_directmap(start, end)
> > > >   kvm_mem_attrs_changed()
> > > >   if (attr == shared)
> > > >     kvm_map_directmap(start, end)
> > > > 
> > > > > 
> > > > > Then you can call the x86 ops.update_mem_attr() in kvm_mem_attrs_changed().
> > > > > And update the direct kernel mapping for both TDX/SNP in the
> > > > > kvm_post_mem_attrs_changed().
> > > > 
> > > > Or, adjusting for the above logic, move the unmapping/mapping to a new
> > > > kvm_pre_mem_attrs_changed() and kvm_post_mem_attrs_changed(), respectively.
> > > > 
> > > > Which seems pretty reasonable to me. Then we can:
> > > >  - drop duplicating the kvm_for_each_memslot_in_gfn_range() walk stuff because
> > > >    we'd just need to know what PFNs to map/unmap from directmap
> > > >    (although we'd still need a loop around kvm_restrictedmem_get_pfn()
> > > >    for the GFN range so not necessarily prettier)
> > > >  - call the RMPUPDATE / corresponding TDX handling via kvm_mem_attrs_changed()
> > > >    which brings it both under KVM MMU lock and also let's it piggyback
> > > >    off the fault->mmu_seq handling so it doesn't get out of sync with
> > > >    xarray during fault time.
> > > > 
> > > 
> > > That sounds better. I am just little bit worried that update_mem_attr() will
> > > end up as an SNP-only callback.
> > 
> > If it really ends up looking like an SNP-only thing, I don't see any
> > immediate issue with deferring this handling until fault time. But the
> > previous constraints remain:
> > 
> >  - directmap unmap needs to happen before shared->private RMPUPDATE,
> >    can't be called while holding KVM MMU lock or other spinlock
> >  - RMPUPDATE, and that needs to happen outside 
> >  - directmap restore needs to happen after private->shared RMPUPDATE,
> >    can't be called while holding KVM MMU lock or other spinlock
> > 
> > I saw the TDX patches added some x86 ops / hooks in KVM MMU to handle
> > mapping secure pages. Is there anything there you think is worth
> > re-using/re-purposing for SNP use-case?
> >
> 
> They are mainly for the TDP MMU to manipulate the TDX secure EPT through
> firmware call. Due to the TDX architecture (1 shared + 1 secure EPT) and
> mirror secure EPT design, TDP MMU is aware there is a "secure EPT but with
> reduced-features", when  a #PF happens which EPT should be operated, and
> when memory attr is changed which EPT should be zapped. Those callbacks
> in TDP MMU are used for maintaining the mirror secure EPT.
> 
> SNP designs in a different way. It doesn't need the TDP MMU to be aware of
> "there is another kind of NPT" as the enforced check is done in RMP, SNP can
> easily, keep all the RMP routines out of the TDP MMU. Also, SNP doesn't need
>  a mirror NPT. Thus, SNP doesn't need those callbacks.
> 
> In *theory*, it is possible to re-purpose some of the callbacks and merge
> RMP update into TDP MMU, like omitting the manipulating mirror secure EPT part
> for SNP, but updating the RMP in the callback of setting SPTE. But I have to
> think about what would be the benefit as it doesn't fit the SNP HW nature.

Yah, can't think of any benefit currently. With both pre-acceptance and
lazy-acceptance those pages will get touched shorty after
KVM_SET_MEMORY_ATTRIBUTES, so the more obvious benefit of avoiding
unecessary RMPUPDATEs doesn't end up working here. And in terms of re-using
callbacks it seems like the TDX and SNP hooks are both where it makes the
most sense to have them. Would be nice to have a shared callback for
this but might not be the right approach here.

-Mike

> 
> 
> > Thanks,
> > 
> > -Mike
> > 
> > > 
> > > > But would be good to hear others' opinions on this. And also confirm
> > > > whether TDX needs that pre/post directmap handle or not.
> > > 
> > > Yes.
> > > 
> > > > 
> > > > Thanks!
> > > > 
> > > > -Mike
> > > > 
> > > > > 
> > > > > > 
> > > > > > -Mike
> > > > > > 
> > > > > > > 
> > > > > > > From 7c618c1f3c236c382e64680efcbe7d8a672aa870 Mon Sep 17 00:00:00 2001
> > > > > > > Message-Id: <7c618c1f3c236c382e64680efcbe7d8a672aa870.1679114841.git.isaku.yamahata@intel.com>
> > > > > > > In-Reply-To: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> > > > > > > References: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> > > > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > > > Date: Fri, 17 Mar 2023 12:00:09 -0700
> > > > > > > Subject: [PATCH 4/4] KVM: x86: Add 'set_mem_attr' x86 op
> > > > > > > 
> > > > > > > This callback will do any platform-specific handling needed for
> > > > > > > converting pages between shared/private.
> > > > > > > 
> > > > > > > Originally-by: Michael Roth <michael.roth@amd.com>
> > > > > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > > > ---
> > > > > > >  arch/x86/include/asm/kvm-x86-ops.h | 1 +
> > > > > > >  arch/x86/include/asm/kvm_host.h    | 2 ++
> > > > > > >  arch/x86/kvm/mmu/mmu.c             | 1 +
> > > > > > >  3 files changed, 4 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > > > > > index dc5f18ac0bd5..956db2ee25a5 100644
> > > > > > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > > > > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > > > > > @@ -100,6 +100,7 @@ KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> > > > > > >  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> > > > > > >  KVM_X86_OP(load_mmu_pgd)
> > > > > > >  KVM_X86_OP(fault_is_private)
> > > > > > > +KVM_X86_OP_OPTIONAL(set_mem_attr)
> > > > > > >  KVM_X86_OP_OPTIONAL(link_private_spt)
> > > > > > >  KVM_X86_OP_OPTIONAL(free_private_spt)
> > > > > > >  KVM_X86_OP_OPTIONAL(split_private_spt)
> > > > > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > > > > index 0382d236fbf4..88e11dd3afde 100644
> > > > > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > > > > @@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
> > > > > > >  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > > > > > >  			     int root_level);
> > > > > > >  	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code);
> > > > > > > +	void (*set_mem_attr)(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > > > > +			     unsigned int attr, gfn_t start, gfn_t end);
> > > > > > >  
> > > > > > >  	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > > > > > >  				void *private_spt);
> > > > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > > > index 0ec94c72895c..329333486e64 100644
> > > > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > > > > @@ -7908,6 +7908,7 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> > > > > > >  				    gfn_t start, gfn_t end)
> > > > > > >  {
> > > > > > >  	kvm_update_lpage_mixed_flag(kvm, slot, true, attrs, start, end);
> > > > > > > +	static_call(kvm_x86_set_mem_attr)(kvm, slot, attrs, start, end);
> > > > > > >  }
> > > > > > >  
> > > > > > >  void kvm_memory_attributes_create_memslot(struct kvm *kvm,
> > > > > > > -- 
> > > > > > > 2.25.1
> > > > > > > 
> > > > > > > -- 
> > > > > > > Isaku Yamahata <isaku.yamahata@gmail.com>  
> > > > > 
> > > > > 
> > > 
> 
