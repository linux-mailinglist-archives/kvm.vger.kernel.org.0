Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F81737181
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 18:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjFTQ3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 12:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjFTQ3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 12:29:07 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2088.outbound.protection.outlook.com [40.107.96.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE0F100;
        Tue, 20 Jun 2023 09:29:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8NvELeKoEGWfiXdqlFKv9vg8B9Qadhebfrykl1TYx0OkG4ow1Z4H9FiyQb+AynivOu2JOJpvEAbHNfAdiQjW1GrGjKcqnr6S3Ts9mrmk10ChINgVOSt3sPE+4q5Wfs4RVkIsaHU6UhydegddGuLqI7V0F0dfBhstPaFj/VJhUoMX3W1q8vCc4KlmHlhZcyYMpYZQvGyN+4/TSIqlrwUFSjjLm82VvcK9M3ENNDS+pfi9TxXDCLbh/bKpYeaKvrEO/UwTDdH3Z8XKbXN+iEmM1eOclTwuY5Ov90tWPle8tTC4TNBN+udRRmZE1t6FT+MUMCUFWowpM2MnH45HxAfRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfyUV44oLKOd3bvi2Tq0qtGjCED52KwUnUdj15bJRNk=;
 b=OjtMQheXOBKwvwBiKZLHnYnJ3xMw3XCk0ALFAMUvZc2EtjfTZTIPlCF+fAwIvzfSuuZepS4Qyk0x5njMAXtJEzIc9BTgKFmoBU8h1sm7C+QW4iq4mdPfXw3fWsC2zhISA0hUwh4hQ3G5xEx/XMiXHoyG0TdqIBrnudhVQz3+32pJXlNGqOVXTK4TDVL+XrInGKDOR6MWQUNKv1d5Oh+5HmYnG6MAkBtPlcjP3ve/M6qVJbC9dX7EaNM5YXWdNbQgD74fAhNm4h4FanSaDhJtKsvYK+omvp0iJNkcYE5GbiR7sNBiYf9cRBGApnA2WKQ/dq268tPQXT5Iq8ZTMVZgsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfyUV44oLKOd3bvi2Tq0qtGjCED52KwUnUdj15bJRNk=;
 b=cPgqaTPXpx0/41VWFM80saO3w1l4cEWZlWaAkaVguKdMlzgyrnLouKeH1HT/961S3LNXyUXD6mPUf0JVym4cdN+VVlu631mxAF/u6XqShm1yCBEuvkcqlrebWlneAqdgwAVLBoCaguyd/T3dBlO23e/hXnzptPIVnMXx10gN9+M=
Received: from MW4PR03CA0004.namprd03.prod.outlook.com (2603:10b6:303:8f::9)
 by DM4PR12MB8451.namprd12.prod.outlook.com (2603:10b6:8:182::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Tue, 20 Jun
 2023 16:29:04 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::63) by MW4PR03CA0004.outlook.office365.com
 (2603:10b6:303:8f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 16:29:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 16:29:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 20 Jun
 2023 11:29:02 -0500
Date:   Tue, 20 Jun 2023 11:28:35 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <isaku.yamahata@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        <erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, <chen.bo@intel.com>,
        <linux-coco@lists.linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [RFC PATCH 5/6] KVM: Add flags to struct kvm_gfn_range
Message-ID: <20230620162835.xsmaao63brira7as@amd.com>
References: <cover.1686858861.git.isaku.yamahata@intel.com>
 <e8d3ab4a56d69a09ba74ff1c439f904075d38c16.1686858861.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e8d3ab4a56d69a09ba74ff1c439f904075d38c16.1686858861.git.isaku.yamahata@intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT060:EE_|DM4PR12MB8451:EE_
X-MS-Office365-Filtering-Correlation-Id: bd2b48ae-ab0c-48c4-ef10-08db71ab7621
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5x6BX3oR4X6ny4J63zlZmFyOG9hmVio+sEeXp96Y4tVkZpCQXyX/TQL57hiaNXgKjGiInr38qJ+kJv5FbrrKCw+ujxS8VhiWloCESiQB2YClKoGc28seHbj50AJwnEGB+VRRJwH0iTiyOuLk1VABlrZw6XCTBqiXpMAv1ALLexlyzvAOqYyRyU9fLPSsqDyqQiGbmhL1o4qprDdNJFGj5cSwrkU48Gt76iL6N/y1Lg783yT6wBgEcZT7roAXDb/TgSVRiDRACyxO/7A4vCCyiTu8Jfgc38Bi6ohcEj2r30a3eSACmRqhXuYKHd0CFLBb6kBR/+fz/Ne7aSgnzBAHNhUaCvCkEfwJH8Pw630GNBMiuzXNXPZqzxyoi7UGA7+Ca0F6KBDpouns3BALN1HKWhFG5Ft1mXYgLbu5sXswrxUxS9O8BarEGjpTT00D8GOXbT2jmyyQGkePnLZim/JKoFILb2GrUlp+fd6zoznodU3N5rFj5K3xifseF0aSvpoeb2ZPZk6Jp5tFT6Q3N/BQwn0d5csCnEhxtbySCMbYGkwMnDAYaEMPj+PDhNsbFex3yZsztfm+Uyk2inx3lz5DYBPy/A+N9dQ+54aS1KHJF8mBZLaf94d7zdx9rd7gSetNbZZO5jwZyEoWGw4+8wUMGJxlvR9pxNkBPCWLbHPZlVvuNUZI4iOuOGud/apnB+pSwYu6iWz9hOECWBmvviQfTpff9M/arjrAgnLTVTb1fX4O+zOH6/WnjTyDC3EmuuAjJew0aU+zHI16Mb3hD8Ro8lfheuPneYaMVd74qaur6Ng=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(7416002)(8936002)(8676002)(44832011)(4326008)(6916009)(70586007)(70206006)(316002)(2906002)(54906003)(41300700001)(36860700001)(40460700003)(6666004)(966005)(478600001)(82740400003)(40480700001)(26005)(1076003)(16526019)(186003)(36756003)(426003)(336012)(47076005)(83380400001)(81166007)(356005)(2616005)(82310400005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 16:29:03.6932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd2b48ae-ab0c-48c4-ef10-08db71ab7621
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8451
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

On Thu, Jun 15, 2023 at 01:12:18PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX and SEV-SNP need to know the reason for a callback by
> kvm_unmap_gfn_range().  mmu notifier, set memory attributes ioctl or KVM
> gmem callback.  The callback handler changes the behavior or does the
> additional housekeeping operation.  For mmu notifier, it's zapping shared
> PTE.  For set memory attributes, it's the conversion of memory attributes
> (private <=> shared).  For KVM gmem, it's punching a hole in the range, and
> releasing the file.

I think it's still an open topic that we need to hear more from Sean about:

  https://lore.kernel.org/lkml/20230522235838.ov3722lcusotzlvo@amd.com/

but I *think* we were leaning toward decoupling the act of invalidating
GFNs, vs. the act of invalidating/free'ing gmem pages.

One concrete example of where this seperation makes sense if with
hole-punching. SNP has unique platform-specific stuff it has to do before
free'ing that gmem page back to the host. If we try to plumb this through
kvm_unmap_gfn_range() via a special flag then it's a little awkward
because:

a) Presumably that hole-punch would have occurred after a preceeding
   KVM_SET_MEMORY_ATTRIBUTES was issued to switch the page to shared
   state in the xarray. So all it should really need to do is handle
   that platform-specific behavior, like updating RMP table in case of
   SNP. But none of the other details like GFN ranges are relevant in
   that case, RMP updates here only need the PFN, so we end up walking
   memslots to do GFN->PFN translations, when it would actually be much
   more efficient to do these translations by translating the
   hole-punched FD offset range to the corresponding folio()'s backing
   those ranges

b) It places an unecessary dependency on having an active memslot to do
   those translations. This ends up not being an issue with current
   version of gmem patchset because the release() happens *before*
   gmem_unbind(), so there is a memslot associated with the ranges at
   gmem_release() time, but in the initial version of gmem it was the
   reverse, so if things ever changed again in this regard we'd once
   again have to completely rework how to issue these platform-specific
   invalidation callbacks.

I really *really* like having a separate, simple invalidation mechanism
in place that just converts FD offsets to PFNs and then passes those on
to platform-defined handlers to clean up pages before free'ing them back
to the system. It's versatile in that it can be called pretty much
anywhere regardless of where we are in KVM lifecycle, it's robust in
that it doesn't rely on unecessary outside dependencies, and it avoids
added uneeded complexity to paths like kvm_unmap_gfn_range().

That's the approach taken with SNP hypervisor v9 series, with the
gmem hook being introduced here:

  https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#m3ad8245235a27ed0f41c359c191dcda6c77af043

and the SEV-SNP implementation of that hook being here:

  https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#m6ac04b44722dbc07839011816e94fadf5ad6794e

Would a similar approach work for TDX? At least WRT cleaning up pages
before returning them back to the host? If we could isolate that
requirement/handling from all the other aspects of invalidations it
really seems like it would cause us less headaches down the road.

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  include/linux/kvm_host.h | 11 ++++++++++-
>  virt/kvm/guest_mem.c     | 10 +++++++---
>  virt/kvm/kvm_main.c      |  4 +++-
>  3 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1a47cedae8a1..c049c0aa44d6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -256,12 +256,21 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #endif
>  
>  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
> +
> +#define KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR		BIT(0)

Can you go into more detail on why special handling is needed for
SET_MEM_ATTR?

> +#define KVM_GFN_RANGE_FLAGS_GMEM_PUNCH_HOLE		BIT(1)
> +#define KVM_GFN_RANGE_FLAGS_GMEM_RELEASE		BIT(2)

Would the need to distinguish between PUNCH_HOLE/RELEASE go away in the
TDX case if you take the above approach? For SNP, the answer is yes. If
that's also the case for TDX I think that would be another argument in
favor of decoupling these from existing KVM MMU invalidation path.

-Mike

> +
>  struct kvm_gfn_range {
>  	struct kvm_memory_slot *slot;
>  	gfn_t start;
>  	gfn_t end;
> -	pte_t pte;
> +	union {
> +		pte_t pte;
> +		u64 attrs;
> +	};
>  	bool may_block;
> +	unsigned int flags;
>  };
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> index cdf2d84683c8..30b8f66784d4 100644
> --- a/virt/kvm/guest_mem.c
> +++ b/virt/kvm/guest_mem.c
> @@ -99,7 +99,8 @@ static struct folio *kvm_gmem_get_folio(struct file *file, pgoff_t index)
>  }
>  
>  static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
> -				      pgoff_t start, pgoff_t end)
> +				      pgoff_t start, pgoff_t end,
> +				      unsigned int flags)
>  {
>  	struct kvm_memory_slot *slot;
>  	unsigned long index;
> @@ -118,6 +119,7 @@ static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
>  			.slot = slot,
>  			.pte = __pte(0),
>  			.may_block = true,
> +			.flags = flags,
>  		};
>  
>  		kvm_mmu_invalidate_range_add(kvm, gfn_range.start, gfn_range.end);
> @@ -156,7 +158,8 @@ static long kvm_gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
>  	 */
>  	filemap_invalidate_lock(file->f_mapping);
>  
> -	kvm_gmem_invalidate_begin(kvm, gmem, start, end);
> +	kvm_gmem_invalidate_begin(kvm, gmem, start, end,
> +				  KVM_GFN_RANGE_FLAGS_GMEM_PUNCH_HOLE);
>  
>  	truncate_inode_pages_range(file->f_mapping, offset, offset + len - 1);
>  
> @@ -263,7 +266,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>  	 * Free the backing memory, and more importantly, zap all SPTEs that
>  	 * pointed at this file.
>  	 */
> -	kvm_gmem_invalidate_begin(kvm, gmem, 0, -1ul);
> +	kvm_gmem_invalidate_begin(kvm, gmem, 0, -1ul,
> +				  KVM_GFN_RANGE_FLAGS_GMEM_RELEASE);
>  	truncate_inode_pages_final(file->f_mapping);
>  	kvm_gmem_invalidate_end(kvm, gmem, 0, -1ul);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 422d49634c56..9cdfa2fb675f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -613,6 +613,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
>  			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
>  			gfn_range.slot = slot;
> +			gfn_range.flags = 0;
>  
>  			if (!locked) {
>  				locked = true;
> @@ -2391,8 +2392,9 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
>  	bool flush = false;
>  	int i;
>  
> -	gfn_range.pte = __pte(0);
> +	gfn_range.attrs = attrs;
>  	gfn_range.may_block = true;
> +	gfn_range.flags = KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR;
>  
>  	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
>  		slots = __kvm_memslots(kvm, i);
> -- 
> 2.25.1
> 
