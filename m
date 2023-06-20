Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E033473760B
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 22:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjFTU3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 16:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjFTU3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 16:29:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D0D1B0;
        Tue, 20 Jun 2023 13:29:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpM8nqcqfwVtJCd9WZYlY/6L1Umffjd0Wh3s6hQPuHs9QfpyBIBOwXx6XRsOacLocf/dBmYn7arVU3lwIXxQ2hXSgCBQ3WaUTCGaNbb7PliceIvRuwDKcspVDmjzTftDi05pF2z5d0y8HrerVHJD6ni4hqtbCuOa10kQ+bIMUG64BZmOANWDDLBc/Z+nWS2C+kyqpvEcndYca9bFmNDb0zE6VyOc7vWrPENZJ91e9U0D8dF7UKmAp6jiqG3rwOsBRiU7Sllg55RxdXCb/D0tqp/Qyxq6zan8vtIuf+D34SjBQ3AQB4f4DS+rZQCJZ3fXmYWAsgdzFWBgOBD3XUd9AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QErKuHqjgYzYEUcQ0+FIUtGQ0dLNShWA0OaDms28deg=;
 b=M+mWEu+PLeNEo1s1qiXgcwAivp/XndbfQOHSq2rw5/7eES/8/plNuwHWMBn55TE1ldP+ZIfHZzOcsU66k0PrjYIZRgLkWp9GmdKqDkfvutm/5SoixtQJEsQvO+PdQbcD6hngH4hZc4p9Rzj2mp/yPdpypB0sJ5IkG86qpEYc9gdIwvmYPIYt4Nfr0MHCOM14DYsWxCYA1jh16PfWYKgphu0kl2/30K5fBEkv/zhbATXyDceoRjxQOUIi/LUL+h0iLIyuzJD+DMdzskdgR76di1OkWnqXUpi41TSA85MV5Q9s1B1Fo0ndi0szfousJ58FCmjA77hyfvSSvEMm6f+MEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QErKuHqjgYzYEUcQ0+FIUtGQ0dLNShWA0OaDms28deg=;
 b=lhnIFIEFKsDiQoWiCEOcylzQHt6+0W2mNghgywW/2cR2xLkyyauQnn58S7gDm7HdWUIxGfo9ElF36vw28WeyzJ5PUOp7NSt+yzy+5D8FamfxPkeq0AasSvdh5FD+sE/giFCDXr/aMfT0JdcHkyUXrZdlizCGd8tSlgXC88gqsaI=
Received: from CY5P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::26) by
 LV3PR12MB9236.namprd12.prod.outlook.com (2603:10b6:408:1a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 20:28:57 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:930:b:cafe::43) by CY5P221CA0012.outlook.office365.com
 (2603:10b6:930:b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 20:28:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.19 via Frontend Transport; Tue, 20 Jun 2023 20:28:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 20 Jun
 2023 15:28:56 -0500
Date:   Tue, 20 Jun 2023 15:28:41 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: Re: [PATCH RFC v9 04/51] KVM: x86: Determine shared/private faults
 using a configurable mask
Message-ID: <20230620202841.7qizls3u3kcck45g@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-5-michael.roth@amd.com>
 <20230614164709.GT2244082@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230614164709.GT2244082@ls.amr.corp.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|LV3PR12MB9236:EE_
X-MS-Office365-Filtering-Correlation-Id: aedad9f2-a347-405d-2276-08db71ccf973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mnnsttvQKwGxc20EtSwFdaufJZ9+x2zqkkdlZDSDR5ZhOWLQxb9l8lQi8jR+TYxSKWRvnYWk5KjI6qNx4cN185y/9GJpYfZxsrwtqSH1/ORX0ZLRV33PiZpGfivDo1U4awBKssZFNbMjpr7jkDiYJbmOuznRU5a3Ax61sAbnlSO/k0lF8lE+Vggyadl50287YfXNghQYMqHkUa3lXCPgfpdE56JSIZnQTjj2CZSyO5rCw/N8EjyiUBt73i9Ol63lDya9Ij/KRJN5q0igS2/PkVmyjlh7xoe/8mWq5C+9G/5eZltMILQ4FOCDg+ICLfqbitTw8qCwLKGIF7Vb9y2YUioTTWMojZjdg1V1Cam6APDzSpAi1LotKbFGyxL/hMGH3At1AS2dD+Tf4OObt8ShO7tLuOa0KX6J8D3tfj2OOdU5coj+VNp6VMe+6VSoItddjAAO8FjHuMtgD4XqUB2+d1GpK2zU3vAC1uNZGL/UdFoMapNTOQPeP9BJyiP3WHXg03fxbxiZ6gDMLqcrxujr8RQibFuomE2RvwPnnP6tkF0D/NDOHvSdLwfJ1lNQqkJAcY0Refl0ODNBfFFwoKdC+CrUYoDcfFQVubesD+RW31s+ar9oxTFBoXMJg+pPP1hjXhAfAAjjUYdyMlreX4pOb7WlLL19xL9OsLwWRBG7WIl1oswAZTC5Bs2BQcEjl0vkbtJXsNvKptwNsc7VaaK/YA0GMV6bbbXrJObCHFzrGTvnGXcluAZPUMhGKvZDbXwlvaE3Ml451g3vF2Nu/twOhQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199021)(46966006)(40470700004)(36840700001)(478600001)(4326008)(54906003)(26005)(16526019)(36756003)(186003)(1076003)(40460700003)(6666004)(40480700001)(2906002)(8676002)(41300700001)(8936002)(70206006)(70586007)(6916009)(316002)(5660300002)(44832011)(7406005)(7416002)(82310400005)(86362001)(47076005)(356005)(36860700001)(426003)(83380400001)(336012)(82740400003)(81166007)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 20:28:57.4458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aedad9f2-a347-405d-2276-08db71ccf973
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9236
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

On Wed, Jun 14, 2023 at 09:47:09AM -0700, Isaku Yamahata wrote:
> On Sun, Jun 11, 2023 at 11:25:12PM -0500,
> Michael Roth <michael.roth@amd.com> wrote:
> 
> > This will be used to determine whether or not an #NPF should be serviced
> > using a normal page vs. a guarded/gmem one.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  7 +++++++
> >  arch/x86/kvm/mmu/mmu_internal.h | 35 ++++++++++++++++++++++++++++++++-
> >  2 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index b3bd24f2a390..c26f76641121 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1445,6 +1445,13 @@ struct kvm_arch {
> >  	 */
> >  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> >  	struct kvm_mmu_memory_cache split_desc_cache;
> > +
> > +	/*
> > +	 * When set, used to determine whether a fault should be treated as
> > +	 * private in the context of protected VMs which use a separate gmem
> > +	 * pool to back private guest pages.
> > +	 */
> > +	u64 mmu_private_fault_mask;
> >  };
> >  
> >  struct kvm_vm_stat {
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 780b91e1da9f..9b9e75aa43f4 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -252,6 +252,39 @@ struct kvm_page_fault {
> >  
> >  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
> >  
> > +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
> > +{
> > +	struct kvm_memory_slot *slot;
> > +	bool private_fault = false;
> > +	gfn_t gfn = gpa_to_gfn(gpa);
> > +
> > +	slot = gfn_to_memslot(kvm, gfn);
> > +	if (!slot) {
> > +		pr_debug("%s: no slot, GFN: 0x%llx\n", __func__, gfn);
> > +		goto out;
> > +	}
> > +
> > +	if (!kvm_slot_can_be_private(slot)) {
> > +		pr_debug("%s: slot is not private, GFN: 0x%llx\n", __func__, gfn);
> > +		goto out;
> > +	}
> > +
> > +	if (kvm->arch.mmu_private_fault_mask) {
> > +		private_fault = !!(err & kvm->arch.mmu_private_fault_mask);
> > +		goto out;
> > +	}
> 
> What's the convention of err? Can we abstract it by introducing a new bit
> PFERR_PRIVATE_MASK? The caller sets it based on arch specific value.
> the logic will be
>         .is_private = err & PFERR_PRIVATE_MASK;

I'm not sure I understand the question. 'err' is just the page fault flags,
and arch.mmu_private_fault_mask is something that can be set on a
per-platform basis when running in a mode where shared/private access
is recorded in the page fault flags during a #NPF.

I'm not sure how we'd keep the handling cross-platform by moving to a macro,
since TDX uses a different bit, and we'd want to be able to build a
SNP+TDX kernel that could run on either type of hardware.

Are you suggesting to reverse that and have err be set in a platform-specific
way and then use a common PFERR_PRIVATE_MASK that's software-defined and
consistent across platforms? That could work, but existing handling seems
to use page fault flags as-is, keeping the hardware-set values, rather than
modifying them to pass additional metadata, so it seems like it might
make things more confusing to make an exception to that here. Or are
there other cases where it's done that way?

> 
> 
> > +
> > +	/*
> > +	 * Handling below is for UPM self-tests and guests that treat userspace
> > +	 * as the authority on whether a fault should be private or not.
> > +	 */
> > +	private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> 
> This code path is sad. One extra slot lookup and xarray look up.
> Without mmu lock, the result can change by other vcpu.
> Let's find a better way.

The intention was to rely on fault->mmu_seq to determine if a
KVM_SET_MEMORY_ATTRIBUTES update came in after .private_fault was set so
that fault handling could be retried, but that doesn't happen until
kvm_faultin_pfn() which is *after* this is logged. So yes, I think there
is a race here, and the approach you took in your Misc. series of
keeping the kvm_mem_is_private() check inside kvm_faultin_pfn() is more
efficient/correct.

If we can figure out a way to handle checking the fault flags in a way
that works for both TDX/SNP (and KVM self-test use-case) we can
consolidate around that.

-Mike

> 
> > +
> > +out:
> > +	pr_debug("%s: GFN: 0x%llx, private: %d\n", __func__, gfn, private_fault);
> > +	return private_fault;
> > +}
> > +
> >  /*
> >   * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
> >   * and of course kvm_mmu_do_page_fault().
> > @@ -301,7 +334,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> >  		.req_level = PG_LEVEL_4K,
> >  		.goal_level = PG_LEVEL_4K,
> > -		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
> > +		.is_private = kvm_mmu_fault_is_private(vcpu->kvm, cr2_or_gpa, err),
> >  	};
> >  	int r;
> >  
> > -- 
> > 2.25.1
> > 
> 
> -- 
> Isaku Yamahata <isaku.yamahata@gmail.com>
