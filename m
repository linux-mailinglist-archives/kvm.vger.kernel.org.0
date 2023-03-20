Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75246C1E9C
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 18:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCTRwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 13:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjCTRw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 13:52:28 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2086.outbound.protection.outlook.com [40.107.96.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DBC19C44;
        Mon, 20 Mar 2023 10:46:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyRDgrybEDdQAKP+W2OtuAeZHGw+HvuboZHc6B2fOhR76SEUoCrceX+sGj+8MkiUmEYKkRlmj9RPf015APzZPE0jRi/5vpCnRnvlpzOTwdpz4y3SiVj2bDsM7CQR2xJ3MjEHxTVP26/hwf/Zr1RKTK3ZRWdTkASdzAoSocQUdADlmWq9Urjzb9O8fvg+ju/4fhYkqRzKs9wCvEOj9vSBg6IM6UpDsQghNSieZLzk0AHCjitKF6r1zqG3N0kHuFgaBdr4BVPO7YYyr8ea/EqT3iPSRN8JZmraDhahTOcI+r1FXuEC23ct1Tx9CtfQab9txJWFqYkYrryCAO7eahKMkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X02qzMpYFA4NEHKkhsMnLGO7c1MFWRAc3dA113JU9RA=;
 b=MFoAcxTzHBtAWV+Rel2ItzZLf4TzzUILtrOKGFgfNLfsCTPeqrLpRQWDhnf0mGYUYUgGi9uk7HU7KplOTPGZutZhUn5Yum8VMy8HX/JDuFnQUNp/nh2WfDCDZ2Bb9v7Pk2yokrbmnlk0+DC/B1rAhdB6RC7ZgASUcMKhSGKWH/ipX6g0a2vMwHhQcVx5H/sGsBtapAW1UqHLqSsSFbyhqfqc/fSYEP7C+ZK3iYR0RPlpuFdT5J2kBF4rOI25zAyKzwIpCh3Y3FJm+UI0GXxAGOh2Nxab4Cz+zhWmk2lOufUUyrGosiyGPojDZqDpFUb//LJpBWCqrgcsHSxPlwl82w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X02qzMpYFA4NEHKkhsMnLGO7c1MFWRAc3dA113JU9RA=;
 b=odLleDVTr3AXRtVWrDMWdk7dP2KVWkBF3ZL86iDaNanLJOGBUsM/0S9EgCkoSgGPaiaV90IcHMdvSPNiiWyOgU9NqcbyEWgX2R1s2JsgU37IUv+d/lquN3KFv09/UMxZeCYga9RGE2j0ChpIaf9wMOzAFd2XPKhj2bEjvPC7Kt4=
Received: from DM6PR18CA0025.namprd18.prod.outlook.com (2603:10b6:5:15b::38)
 by CY8PR12MB7539.namprd12.prod.outlook.com (2603:10b6:930:96::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:46:17 +0000
Received: from DS1PEPF0000E648.namprd02.prod.outlook.com
 (2603:10b6:5:15b:cafe::1c) by DM6PR18CA0025.outlook.office365.com
 (2603:10b6:5:15b::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Mon, 20 Mar 2023 17:46:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E648.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Mon, 20 Mar 2023 17:46:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Mar
 2023 12:46:16 -0500
Date:   Mon, 20 Mar 2023 12:46:01 -0500
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 01/56] KVM: x86: Add 'fault_is_private' x86 op
Message-ID: <20230320174601.4ccz7mmf4h6agpxt@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-2-michael.roth@amd.com>
 <20230318045137.GC408922@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230318045137.GC408922@ls.amr.corp.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E648:EE_|CY8PR12MB7539:EE_
X-MS-Office365-Filtering-Correlation-Id: 4964f04c-59d7-4795-e551-08db296b01bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sX1j3KG1gTOPEVqbUyXCwyVI0uxu7sIYdlW4S5k4CSUlMQG+ksCjbkfNenVf9QchpimKHHOhTuO6m1L7oGyo48zckc38jOROuwToMARAWfWGwvLqy0qQDq3DKIAAHrkEYoZNVbXnFZktNBvfG+5TJ4MZlq9Njj5N3P9rL2QrEhjZoxGvSzZEMiWRfxnGqBP3z3ABo98F3TvyYKHqNPAee19z/WGl8pEd5Xg9RqxHwetXA738iEJ2gf8PryVf2V1Zp8E7aTOykqXRVERrX1oUV690tsIkJDDLdVQh4ormuyyjpf0w3tzfxcXTx7wzE7UqGYno42KsQPLcpSb6CXwzVgVdn9CavJHMP3RIQy8ZKF8m4+I9jZmBuiYexwQLitKG8OE4T4ED1yE1l/KJojCmcm2Fe5v0H2GG7PXLtVwXkVPWfojYwaUGf1tORLWZsfyaU4iYxLWIXjo5uRTwF6h6nqznvTDdF9b8/hkfgrXT1wM/n+BHALlVjIaNNsX1OlWadJEvRkznX7dfasQood6rnVBJX+9HQsgEwL+DiO/tL++25zGX2ZknZhgzhQIK0wCwem3JtFVoO4NJsmULoEE2+2T9NWhnsXEa+9K54+m6z6zWKd6g+w0Le5rOwHmWIjRKpPzddZVOaH22NBAKvYamfzcE74ews7CLKbFzbb6giMOm6EJwez6x7L9uearOlilMa7ZoVV72WGiMFgnoPBamy3n2AB7jhPQmYXbwV9PRyJs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(83380400001)(2616005)(426003)(47076005)(336012)(40460700003)(86362001)(44832011)(356005)(81166007)(36860700001)(40480700001)(8676002)(36756003)(82740400003)(41300700001)(70206006)(70586007)(8936002)(2906002)(5660300002)(6916009)(4326008)(186003)(7416002)(26005)(1076003)(16526019)(478600001)(53546011)(6666004)(7406005)(966005)(316002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 17:46:16.9712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4964f04c-59d7-4795-e551-08db296b01bf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E648.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7539
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 09:51:37PM -0700, Isaku Yamahata wrote:
> On Mon, Feb 20, 2023 at 12:37:52PM -0600,
> Michael Roth <michael.roth@amd.com> wrote:
> 
> > This callback is used by the KVM MMU to check whether a #NPF was for a
> > private GPA or not.
> > 
> > In some cases the full 64-bit error code for the #NPF will be needed to
> > make this determination, so also update kvm_mmu_do_page_fault() to
> > accept the full 64-bit value so it can be plumbed through to the
> > callback.

Hi Isaku, Zhi,

Thanks for your efforts trying to get us in sync on these shared
interfaces. Would be great to have a common base we can build on for the
SNP/TDX series. You mentioned a couple patches here that I couldn't find
on the list, are you planning to submit these as a separate series?

> 
> We can split 64-bit part into the independent patch.

Agreed that makes sense.

> 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---

<snip>

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
> > +	if (static_call(kvm_x86_fault_is_private)(kvm, gpa, err, &private_fault))
> > +		goto out;
> > +
> > +	/*
> > +	 * Handling below is for UPM self-tests and guests that treat userspace
> > +	 * as the authority on whether a fault should be private or not.
> > +	 */
> > +	private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> > +
> > +out:
> > +	pr_debug("%s: GFN: 0x%llx, private: %d\n", __func__, gfn, private_fault);
> > +	return private_fault;
> > +}
> > +
> >  /*
> >   * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
> >   * and of course kvm_mmu_do_page_fault().
> > @@ -262,11 +293,11 @@ enum {
> >  };
> >  
> >  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > -					u32 err, bool prefetch)
> > +					u64 err, bool prefetch)
> >  {
> >  	struct kvm_page_fault fault = {
> >  		.addr = cr2_or_gpa,
> > -		.error_code = err,
> > +		.error_code = lower_32_bits(err),
> >  		.exec = err & PFERR_FETCH_MASK,
> >  		.write = err & PFERR_WRITE_MASK,
> >  		.present = err & PFERR_PRESENT_MASK,
> > @@ -280,7 +311,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> >  		.req_level = PG_LEVEL_4K,
> >  		.goal_level = PG_LEVEL_4K,
> > -		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
> > +		.is_private = kvm_mmu_fault_is_private(vcpu->kvm, cr2_or_gpa, err),
> 
> I don't think kvm_mmu_fault_is_private(). It's too heavy. We can make it
> it's own. I.e. the following.

Is it causing performance issues? If most of that is mainly due to
gfn_to_memslot()/kvm_slot_can_be_private() check, then maybe that part
can be dropped. In the past Sean has mentioned that we shouldn't have to
do kvm_slot_can_be_private() checks prior to kvm_mem_is_private(), but I
haven't tried removing those yet to see if things still work as expected.

> 
> From b0f914a1a4d154f076c0294831ce9ef0df7eb3d3 Mon Sep 17 00:00:00 2001
> Message-Id: <b0f914a1a4d154f076c0294831ce9ef0df7eb3d3.1679114841.git.isaku.yamahata@intel.com>
> In-Reply-To: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> References: <428a676face7a06a90e59dca1c32941c9b6ee001.1679114841.git.isaku.yamahata@intel.com>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> Date: Fri, 17 Mar 2023 11:18:13 -0700
> Subject: [PATCH 2/4] KVM: x86: Add 'fault_is_private' x86 op
> 
> This callback is used by the KVM MMU to check whether a KVM page fault was
> for a private GPA or not.
> 
> Originally-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/mmu.h                 | 19 +++++++++++++++++++
>  arch/x86/kvm/mmu/mmu_internal.h    |  2 +-
>  arch/x86/kvm/x86.c                 |  8 ++++++++
>  5 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index e1f57905c8fe..dc5f18ac0bd5 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -99,6 +99,7 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>  KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
> +KVM_X86_OP(fault_is_private)
>  KVM_X86_OP_OPTIONAL(link_private_spt)
>  KVM_X86_OP_OPTIONAL(free_private_spt)
>  KVM_X86_OP_OPTIONAL(split_private_spt)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 59196a80c3c8..0382d236fbf4 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1730,6 +1730,7 @@ struct kvm_x86_ops {
>  
>  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level);
> +	bool (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code);
>  
>  	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>  				void *private_spt);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 4aaef2132b97..1f21680b9b97 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -289,6 +289,25 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
>  	return translate_nested_gpa(vcpu, gpa, access, exception);
>  }
>  
> +static inline bool kvm_mmu_fault_is_private_default(struct kvm *kvm, gpa_t gpa, u64 err)
> +{
> +	struct kvm_memory_slot *slot;
> +	gfn_t gfn = gpa_to_gfn(gpa);
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot)
> +		return false;
> +
> +	if (!kvm_slot_can_be_private(slot))
> +		return false;
> +
> +	/*
> +	 * Handling below is for UPM self-tests and guests that treat userspace
> +	 * as the authority on whether a fault should be private or not.
> +	 */
> +	return kvm_mem_is_private(kvm, gfn);
> +}
> +
>  static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
>  {
>  #ifdef CONFIG_KVM_MMU_PRIVATE
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index bb5709f1cb57..6b54b069d1ed 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -445,7 +445,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.max_level = vcpu->kvm->arch.tdp_max_page_level,
>  		.req_level = PG_LEVEL_4K,
>  		.goal_level = PG_LEVEL_4K,
> -		.is_private = kvm_is_private_gpa(vcpu->kvm, cr2_or_gpa),
> +		.is_private = static_call(kvm_x86_fault_is_private)(vcpu->kvm, cr2_or_gpa, err),
>  	};
>  	int r;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fd14368c6bc8..0311ab450330 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9419,6 +9419,14 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>  #undef __KVM_X86_OP
>  
>  	kvm_pmu_ops_update(ops->pmu_ops);
> +
> +	/*
> +	 * TODO: Once all backend fills this option, remove this and the default
> +	 * function.
> +	 */
> +	if (!ops->runtime_ops->fault_is_private)
> +		static_call_update(kvm_x86_fault_is_private,
> +				   kvm_mmu_fault_is_private_default);

I'm not sure about this approach, since the self-tests (and possibly SEV
(which doesn't use a separate #NPF error bit like SNP/TDX)) currently
rely on that kvm_mem_is_private() call to determine whether to handle as
a private fault or not. But to run either of those, we would need to
load the kvm_amd module, which will have already introduced it's own
kvm_x86_fault_is_private implementation via svm_init(), so the handling
provided by kvm_mmu_fault_is_private_default would never be available and
so we wouldn't be able to run the UPM self-tests.

To me it seems like that handling always needs to be in place as a
fallback when not running SNP/TDX. It doesn't necessarily need to be in the
kvm_x86_fault_is_private handler though, maybe some generic handling for
UPM selftests can be pushed down into KVM MMU. Doing so could also
address a race that Sean mentioned between the time kvm_mem_is_private()
is called here (which happens before mmu_invalidate_seq is recorded for
the #NPF) vs. when it actually gets used in __kvm_faultin_pfn().

If we take that approach, then the requirements for specific TDX/SNP
handling are reduced as well, since we only need to check the
encryption/shared bit, and that could maybe be done as a simple setting
that where you tell KVM MMU the position of the bit, whether it
indicates shared vs. private, then both TDX/SNP could re-use a simple
helper to check the #NPF error code and set .is_private based on that.

Then KVM MMU could, if no bit is indicated, just fall back to using the
value of kvm_mem_is_private() somewhere in __kvm_fault_pfn() or
something.

I mentioned this to Sean a while back, which I think is compatible with
what he was looking for:

  https://lore.kernel.org/lkml/20230220162210.42rjdgbdwbjiextz@amd.com/

Would be good to get his input before spending too much time adding new
state/configuration stuff in KVM MMU though.

As an interim solution, would my original patch work if we could
confirm that the gfn_to_memslot()/kvm_slot_can_be_private() sequence is
no longer needed?

Thanks!

-Mike

>  }
>  
>  static int kvm_x86_check_processor_compatibility(void)
> -- 
> 2.25.1
> 
> 
> 
> 
> -- 
> Isaku Yamahata <isaku.yamahata@gmail.com>
