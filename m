Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C7673D579
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 03:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjFZBKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 21:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjFZBKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 21:10:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0AA18F;
        Sun, 25 Jun 2023 18:10:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P52a6+SAMtb1aoZeZXGzw5K0TfSg4xSoWjj68sEpQmIVouueoegPMUsJf5orcSbZ1brq6JBtfrN8MCtgArKkkrLEVkFv3USdhFueJsoiU/1diABMqh1GicaG6XnOHj0j1+nnyjmSZX5v+WiKCN5KzEABntxTIpPAuPNKP2x7AKo2uq1itqZFfOlPLO7kRSLX6RQasDl19RhZYbmu4jEW3scBgXmNrlgFj9K9yaBvsEQlDgDOCCW3vVRwWW6wdmNUoZIZT9Q4gjbZ1ind65fbZg0FPzQ+wWdXpynGXVpDDXF9FUyrq3q6pAspkoRBfUoPPuJiCnoWbBe+jGR8JV8h8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjxjwiMnU79gNSi25wzZMGhJ54M3DmfS2lU4aNJ+Joo=;
 b=i39ve7FVtqueijhYte1blXHUEHFbWSl2G0Byg8UZV1B7hFC913o+eKpSiriAfmTXIeij78caDIsuqQbC1FNoAIqP/1vH9wj6A3+ToWaKOk/PRDvi6vk1CTMvVLigclyi1CHvzHul0niGtrdAw7Zd4KesimbHG8eRQmqOI2Aiz3VyPwgGB7YNKmTMSTccrSHDKqTZAJr3v+kfocc/wb9oTKKo6TpT3RNaQuPyHXKaZmsA1hBeancEx+A1q8EG+DJMRMbBGmz6lvrUIb1blhgB6/6OKKkGXRBr75+Rg71m+dTDM9Nx9TCKgi7gU4Fi0ybgzJ1YA4rDDcJz0UPYOF3GCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjxjwiMnU79gNSi25wzZMGhJ54M3DmfS2lU4aNJ+Joo=;
 b=0s9fbHfrBLicuG0tVnekQkCja5wvJsMcwMV1xVB/E7boRL0y5PrIE88LW7zWDmr6SPsjzfdOCCFRAntmLPiRzo+G2QbHtFGDd0h74ZRvjSsR9Xnl8u1YBijV6F1YL+P0g4ct0x3VvNRfUX9bEZQRoYdOX3FfOlgVf8rW4WvXpJk=
Received: from DM6PR05CA0048.namprd05.prod.outlook.com (2603:10b6:5:335::17)
 by PH7PR12MB7966.namprd12.prod.outlook.com (2603:10b6:510:274::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 01:10:13 +0000
Received: from DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::3b) by DM6PR05CA0048.outlook.office365.com
 (2603:10b6:5:335::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.15 via Frontend
 Transport; Mon, 26 Jun 2023 01:10:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT069.mail.protection.outlook.com (10.13.173.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.47 via Frontend Transport; Mon, 26 Jun 2023 01:10:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 25 Jun
 2023 20:10:11 -0500
Date:   Sun, 25 Jun 2023 20:07:53 -0500
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
Message-ID: <20230626010753.xru5ph3irmyokrgc@amd.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <a3a19de92c7ac6e607ac3e663d84a4312876084b.1687474039.git.isaku.yamahata@intel.com>
 <ZJX6s2HxbHOUMXlj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZJX6s2HxbHOUMXlj@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT069:EE_|PH7PR12MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: b5ceaa75-84a0-4c73-a463-08db75e217be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +5ePdfD1bdCTAGUYPCjDebs2U1EVvSqxCN4PNhncwLBTaKz6O3Rag1/spiwa4K7L8eL6vsvnL4OhHZz5NQwc+PZyPdv3L6EDSYsAbVsqR2zHblzKd79HWSGe1HokJIbSs3ftZXvqyde2VDuLFT8jEP3LbXUQCYNXiirm0sfAOQ6pghtq/g411WLd82A7NiblGfJPoem6BPSdv2uTj4cB1I0jzbIop1uBVZ4+LBgk+Zl9Ged/E1DkEpxGIb00XLGiui0unXR0akeBwdMAwxMgHYfUTcmOEBGqhkFFNijj64L+AjwLU1ccc/meYpUZzaw4EY59pypUaGM3TiV3G4pj1VYFLgEIe1L1jwVbdR3d1Xk1oDZYIRoha7PgSUub/6/MmlzG+D/bA8XUlx4cycr4QMwG5aKRszCP0VvdX5ymQQJXG+fP9xZTCz0NjvDxY3ao+dNrJq9c1KqKT2+r2sruMhA8cLxI8yGL4fBxniB5xvNzFs2Xi1vlYO0C92EGq6WrVKUEWxfLWbbDCEsSo11SlPrKDnyIeBtN03PdyY2C80ac6V4hU0s1raf7ev+vd+FdYt0r5KJB+W0uZk1qvRxJSLC3ckvQJ5s+ilRhFcSoQ7sB8gDAAk1gCW5Xx62vL27yoKxH/eChjY61f7m3DdidsQTXcfejciqI8l+VSuSL66mzhUTvwIAvWcjS3AaOESPJN+YYsykkLeblC1P8CohOi19u5IPh5rHbMD6z59qKS4Lq66D039fI56Gl82t27adCrCgE3bCibM/T2wPJyi2naA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(36860700001)(40460700003)(36756003)(70206006)(356005)(5660300002)(44832011)(7416002)(41300700001)(316002)(86362001)(6916009)(8936002)(8676002)(4326008)(81166007)(40480700001)(70586007)(82740400003)(966005)(47076005)(1076003)(26005)(2906002)(186003)(16526019)(478600001)(54906003)(426003)(336012)(6666004)(83380400001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 01:10:12.3704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ceaa75-84a0-4c73-a463-08db75e217be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7966
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 01:04:03PM -0700, Sean Christopherson wrote:
> On Thu, Jun 22, 2023, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 7f9ec1e5b136..0ec0b927a391 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -188,6 +188,13 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
> >  	return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
> >  }
> >  
> > +enum kvm_fault_type {
> > +	KVM_FAULT_MEM_ATTR,
> > +	KVM_FAULT_SHARED,
> > +	KVM_FAULT_SHARED_ALWAYS,
> > +	KVM_FAULT_PRIVATE,
> 
> This is silly.  Just use AMD's error code bit, i.e. PFERR_GUEST_ENC_MASK as per
> the SNP series.
> 
>   Bit 34 (ENC): Set to 1 if the guest’s effective C-bit was 1, 0 otherwise.
> 
> Just because Intel's ucode is too crusty to support error codes larger than 16
> bits doesn't mean KVM can't utilize the bits :-)  KVM already translates to AMD's
> error codes for other things, e.g.
> 
> 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
> 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> 
> For TDX, handle_ept_violation() can do something like:
> 
> 	if (is_tdx(vcpu->kvm))
> 		error_code |= (gpa & shared) ? 0 : PFERR_GUEST_ENC_MASK;
> 	else if (kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(gpa)))
> 		error_code |= PFERR_GUEST_ENC_MASK;

Maybe this is what you're getting at below, but seems awkward to have this
being handling in TDX code since that would suggest that SVM module would
also need to duplicate that logic and synthesize this PFERR_GUEST_ENC_MASK
bit for non-SNP VMs (e.g. gmem self-tests).

So maybe SNP/TDX can rely on passing this via error_code, and then some
common code, like kvm_mem_is_private(), can handle this for non-TDX/SNP
guest types. But the current gmem series does this via a new .is_private
in kvm_page_fault:

  .is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),

This seems at odds with the idea of storing this 'fault->is_private'
logic into the error_code. Isaku and I were discussing[1] that we
should do one or the other:

  a) store everything in error_code
  b) use the .is_private field that seems to have been introduced to
     track exactly this information

So I think this series is attempting to do b). If you're suggesting we
should do a), then what purpose is fault->is_private field meant to
serve? Are you planning to get rid of it? Otherwise it seems redundant.

But I think approach b) is useful for another reason:

> 
> And that's not even taking into account that TDX might have a separate entry point,
> i.e. the "is_tdx()" check can probably be avoided.
> 
> As for optimizing kvm_mem_is_private() to avoid unnecessary xarray lookups, that
> can and should be done separately, e.g.
> 
>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {
> 	return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
> 	       kvm_guest_has_private_mem(kvm) &&
> 	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>   }
> 
> where x86's implementation of kvm_guest_has_private_mem() can be
> 
>   #define kvm_guest_has_private_mem(kvm) (!!(kvm)->vm_type)

It's just about not checking xarray for non-protected case. The
optimization here is that neither TDX nor SNP care about the xarray as
far as determining whether the *fault* was a private or not. We only
care later, in part of the KVM MMU code that determines whether the
fault type is at odds with the xarray state and whether to generate a
KVM_EXIT_MEMORY_FAULT as a result.

In that code, both TDX/SNP, as well as gmem self-tests, will all end up
calling kvm_mem_is_private().

In the gmem self-test case, in current gmem base series, and I think with
what you've proposed here, we'd check the xarray via kvm_mem_is_privae(),
both in kvm_mmu_do_page_fault(), as well as later kvm_faultin_pfn() where
KVM_EXIT_MEMORY_FAULT case is handled. That seems off because:

  1) Checking in kvm_mem_is_private() via kvm_mmu_do_page_fault() means
     that we will grab the value prior to when the KVM MMU records the
     mmu_invalidate_seq, which means there's a window between
     kvm_mmu_do_page_fault() and kvm_faultin_pfn() where an updated
     xarray won't be noticed, and the #NPF retry logic will not get
     triggered.

  2) For gmem self-test, kvm_mem_is_private() is the authority on
     whether the fault is private or not. There's no need to distinguish
     between what was set via KVM_SET_MEMORY_ATTRIBUTES, vs. what was
     indicated via fault flags/GPA like TDX/SNP do.

So it makes sense, in the gmem case (and TDX/SNP), to defer the
kvm_mem_is_private() till later in kvm_faultin_pfn(). It avoid a
duplicate lookup, and a race. But .is_private only conveys
encrypted/unencrypted fault in TDX/SNP case, it doesn't have a way to
cleanly convey this case "just use whatever kvm_mem_is_private() reports
later, because it will always be what the VMM set, and it's too early
to check kvm_mem_is_private() right now".

So that's where this enum type came from. Although in the discussion I
linked to above I suggested just:

  enum kvm_fault_type {
    KVM_FAULT_VMM_DEFINED,
    KVM_FAULT_SHARED,
    KVM_FAULT_PRIVATE,

Which I think would work just as well, since VMM_DEFINED is basically what
MEM_ATTR case handles in this patch, and if you also add the
kvm_guest_has_private_mem() check into kvm_mem_is_private() as you suggested,
it would naturally cover the SHARED_ALWAYS case as well.

I'm fine with other approaches, but think there are a couple good reasons
(#1 and #2 above) for what Isaku is proposing, and any alternative
approach should account for them as well.

[1] https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#mdb24fe4998aa3ff3e568e8a0cba4d12b159087c7

-Mike
