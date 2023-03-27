Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A86CB56F
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 06:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjC1EhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 00:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjC1EhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 00:37:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1261BFE;
        Mon, 27 Mar 2023 21:37:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFgyxsssZ9z3WB+L3o/ww8rvl+2Su1UOd8ghkWJKpLnHBl20Bvcd6qK6asfZ0EaZPZ7YIfFMwKzfVkLCbx9QauZ3TdNkVy2zJb1r2rbv7eFZ22njECg5YQalSzzvUuOic19pmNnGJE9fD7bojYKXwMTzsYSp59mj+R0UpbTmkVYaLGxfMsR2Iy3FxlGNZsP/SVUdKdR5n6qzjOHXDfTpkqEWb9uCmTUymHpXmtpHqZx3nnYUYPrPFXdiVHfbFYoF2eVHq+Xk04FRddpe/HctFAd5HTJB7NafzbJZnjwb5PqfxQQAgtjb+q61G5mEXzzOhxQg7/sc3Ba8p0TsTjGNvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3J8frjIr6485c7Gf013vbZBEvA9yK2He1jMNUdniOXk=;
 b=KizAKTHX0SR8KsS7HVA9YXUQPOW6Nr+YfkbxaTBvbKqwqW/JisVRZA/3buTIdegXKp2ZeEHxp6Dp5PqQuy9Ab5VTlgna6+/Qs3K7JSOxsqPaBlM4MlhV58NZeh1WMGMWr56xeT00krcZCtNRJmZ8Jfbfnoc5EH8GLfKbB5q1dds3Hs2KrQQGbkwbZAQex4+QfQfeE7bIG0flAdty059DLTXyuRRgsglJaFSuAiix5JxqTHbD/PCUAnKIslvD5hJIEXxvolpmh/z9E6s3DAnwWdM8xGwgsIMBoOzIpV7UfDrYajOMzGZEFVMTTfIHMR0cUpcTI1x8xg3k3WfZ2yyJBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3J8frjIr6485c7Gf013vbZBEvA9yK2He1jMNUdniOXk=;
 b=FJsafA+bre9XYmUdgRLJbo+Qcps45IuPuuDvEUN63yPNjejW3MksDvNcxeBYgW2p1RiA7qKpYbe8GQbr3LPiBbnjJheAwgL62PcdpP97RufBHaOwyRS74UAYAWQJg9v2xNEhz6tEdT6z08ymLFWW9DM4yu9ZvcDHsA2eprLwcAY=
Received: from MW4PR04CA0072.namprd04.prod.outlook.com (2603:10b6:303:6b::17)
 by PH8PR12MB7028.namprd12.prod.outlook.com (2603:10b6:510:1bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 04:36:59 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::82) by MW4PR04CA0072.outlook.office365.com
 (2603:10b6:303:6b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.42 via Frontend
 Transport; Tue, 28 Mar 2023 04:36:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.21 via Frontend Transport; Tue, 28 Mar 2023 04:36:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 23:36:55 -0500
Date:   Sun, 26 Mar 2023 19:34:44 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
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
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH RFC v8 04/56] KVM: Add HVA range operator
Message-ID: <20230327003444.lqfrididd4gavomb@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-5-michael.roth@amd.com>
 <20230220233709.00006dfc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230220233709.00006dfc@gmail.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT060:EE_|PH8PR12MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fd2d84f-b972-45e5-181a-08db2f4611a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gqb6NWudd8KWmtEcTZtARy0n73fFtSBVVYpBeWRaMDP9in1uZFo4AeJTxap5Yr2Z7dwAA5Dbu0e6CpQUNtolnu82n9U9CYCBluV0+i8n9VSh/2Rl7dH30op5FJ7Tyo6QTMaMMtHNM6g00NfnumKXVMgDnworJmFK9GoRlsZuLB0x/0Ajj3+l2EMG6kMfJlmTNWBR/DmtVJqrWTPwTdJchrde8X/p0IjjjJyD9c1Q1GzZUOt+qrQPi89KXRHQRY60JsQ69oj0dk+DJnNq3tbwei4IGTHjwToyt4PXrL+a2RoUovd/vxD444oQUMtsA4FhbLnqB5wElufvfcyL89KSK2jASBpJ8hgIgmxLaJJARPjZrnN0G44fdB8/1BOf3eeeBUNzv4VluW3Be6cPPuWEHXA105NGJZr+VZN7lOKdWI+4TPbmItuDKVDJVUeKXHiEAV5r+kD19vH9uYQSpNwdlfnPbtxXZifd9usFTYrgpPs+6GH40HTiVGPYTZ5lPl5HkuOw+Gj/IIcDm43GQO1UuP3oPjmB6bn1spyZpfQBUb/YyAub9JDsyj/t7gY2ni6NCOpwRIUF6O1UEeaZAOXdcFNEUeE7Wm9ucCObXxlGXKxpP5fXvst1kcFkQDAPCFOs2mY3wY1+QUdjs6xqRfvd9QPiz3xGJABorDHuJWtxWNFegY5/izpxQD2olW5koxFuWu+g0zD+zdPVRo1guUsUaaEEkAU/eVvGmygS7faPNro=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(54906003)(44832011)(70586007)(316002)(5660300002)(7406005)(2906002)(7416002)(8936002)(81166007)(478600001)(426003)(356005)(2616005)(82740400003)(70206006)(36860700001)(6916009)(66899021)(336012)(41300700001)(8676002)(4326008)(40460700003)(47076005)(16526019)(966005)(86362001)(40480700001)(6666004)(82310400005)(83380400001)(26005)(186003)(36756003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 04:36:59.1808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd2d84f-b972-45e5-181a-08db2f4611a6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7028
X-Spam-Status: No, score=0.3 required=5.0 tests=DATE_IN_PAST_24_48,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 11:37:09PM +0200, Zhi Wang wrote:
> On Mon, 20 Feb 2023 12:37:55 -0600
> Michael Roth <michael.roth@amd.com> wrote:
> 
> > From: Vishal Annapurve <vannapurve@google.com>
> > 
> > Introduce HVA range operator so that other KVM subsystems
> > can operate on HVA range.
> > 
> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > [mdr: minor checkpatch alignment fixups]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  include/linux/kvm_host.h |  6 +++++
> >  virt/kvm/kvm_main.c      | 48 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 54 insertions(+)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 4d542060cd93..c615650ed256 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1402,6 +1402,12 @@ void kvm_mmu_invalidate_begin(struct kvm *kvm);
> >  void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
> >  void kvm_mmu_invalidate_end(struct kvm *kvm);
> >  
> > +typedef int (*kvm_hva_range_op_t)(struct kvm *kvm,
> > +				struct kvm_gfn_range *range, void *data);
> > +
> > +int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
> > +			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data);
> > +
> >  long kvm_arch_dev_ioctl(struct file *filp,
> >  			unsigned int ioctl, unsigned long arg);
> >  long kvm_arch_vcpu_ioctl(struct file *filp,
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index f7e00593cc5d..4ccd655dd5af 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -642,6 +642,54 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
> >  	return (int)ret;
> >  }
> >  
> 
> Below function seems a reduced duplicate of __kvm_handle_hva_range()
> in virt/kvm/kvm_main.c. It would be nice to factor __kvm_handle_hva_range().

A few differences make it difficult to refactor this clearly:

  - This handler is mainly used for loading initial contents into guest
    image before booting and doesn't rely on the MMU lock being held. It
    also *can't* be called with MMU lock held because it suffers from the
    same issue with mem_attr_update() hook where it needs to take a
    mutex as part of unmapping from directmap when transitioning page to
    private state in RMP table
  - This handler wants to return an error code, as opposed to existing
    handlers which return a true/false values which are passed along to
    MMU notifier call-site and handled differently.
  - This handler wants to terminate iterating through memslots as soon
    as it encounters the first failure, whereas the existing handlers
    expect to be called for each slot regardless of return value.

So it's a pretty different use-case that adds enough complexity to
__kvm_handle_hva_range() that it might need be worth refactoring it,
since it complicates some bits that are closely tied to dealing with
invalidations where the extra complexity probably needs to be
well-warranted.

I took a stab at it here for reference, but even with what seems to be
the minimal set of changes it doesn't save on any code and ultimately I
think it makes it harder to make sense of what going on:

  https://github.com/mdroth/linux/commit/976c5fb708f7babe899fd80e27e19f8ba3f6818d

Is there a better approach?

Thanks,

-Mike

> 
> > +int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
> > +			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data)
> > +{
> > +	int ret = 0;
> > +	struct kvm_gfn_range gfn_range;
> > +	struct kvm_memory_slot *slot;
> > +	struct kvm_memslots *slots;
> > +	int i, idx;
> > +
> > +	if (WARN_ON_ONCE(hva_end <= hva_start))
> > +		return -EINVAL;
> > +
> > +	idx = srcu_read_lock(&kvm->srcu);
> > +
> > +	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
> > +		struct interval_tree_node *node;
> > +
> > +		slots = __kvm_memslots(kvm, i);
> > +		kvm_for_each_memslot_in_hva_range(node, slots,
> > +						  hva_start, hva_end - 1) {
> > +			unsigned long start, end;
> > +
> > +			slot = container_of(node, struct kvm_memory_slot,
> > +					    hva_node[slots->node_idx]);
> > +			start = max(hva_start, slot->userspace_addr);
> > +			end = min(hva_end, slot->userspace_addr +
> > +						  (slot->npages << PAGE_SHIFT));
> > +
> > +			/*
> > +			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
> > +			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
> > +			 */
> > +			gfn_range.start = hva_to_gfn_memslot(start, slot);
> > +			gfn_range.end = hva_to_gfn_memslot(end + PAGE_SIZE - 1, slot);
> > +			gfn_range.slot = slot;
> > +
> > +			ret = handler(kvm, &gfn_range, data);
> > +			if (ret)
> > +				goto e_ret;
> > +		}
> > +	}
> > +
> > +e_ret:
> > +	srcu_read_unlock(&kvm->srcu, idx);
> > +
> > +	return ret;
> > +}
> > +
> >  static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
> >  						unsigned long start,
> >  						unsigned long end,
> 
