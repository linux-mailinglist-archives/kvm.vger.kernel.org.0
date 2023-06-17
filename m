Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB434733DDA
	for <lists+kvm@lfdr.de>; Sat, 17 Jun 2023 05:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbjFQDpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 23:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjFQDpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 23:45:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED5730F8;
        Fri, 16 Jun 2023 20:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686973507; x=1718509507;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XwjZf4OZ6eYrcFkxkPDYjloZyHMyc8e9inqGFlKDqN8=;
  b=jMVQe3B2PVUh4QwxC7xGJw4RW8xMazNpyMyqOI47XV5ceOg9ZqT8745b
   QggThgQXei22q+zyupEqzzHJciZWIq+3W+1bVmhKF8ZB1B2OtR+sQpFGi
   huddxpenz1Z59vVBYQgM+tBSk5Ly7WUlPDZCKg7+6HiQazKadnlqEPUSA
   9Vsdwc8r89tBBlKanKMKNeloLzvgzCijN7BJre4PHnYSeYvfqkjOzyoST
   EVO/pVmDk0obN2hkr33DmYEm+cyX8gJLpfgo3VIbBNgDz5bSAwGwg+sL8
   sGUtpshWwH4+wFfkrT6bdy/OONCfutIZ0IE13maptyRSA+3mcB3vSM8Db
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="445738601"
X-IronPort-AV: E=Sophos;i="6.00,249,1681196400"; 
   d="scan'208";a="445738601"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 20:45:06 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="746596944"
X-IronPort-AV: E=Sophos;i="6.00,249,1681196400"; 
   d="scan'208";a="746596944"
Received: from jye19-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.28.32])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 20:45:02 -0700
Date:   Sat, 17 Jun 2023 11:45:00 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
Message-ID: <20230617034500.djk5nhmpxony3ngp@linux.intel.com>
References: <20230602011518.787006-1-seanjc@google.com>
 <20230602011518.787006-2-seanjc@google.com>
 <20230607073728.vggwcoylibj3cp6s@linux.intel.com>
 <ZICUbIF2+Cvbb9GM@google.com>
 <20230607172243.c2bkw43hcet4sfnb@linux.intel.com>
 <ZIDENf2vzwUjzcl2@google.com>
 <20230608070016.f3dz6dhvdkxsomdb@linux.intel.com>
 <ZIi+jWxYg/UhKpr1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIi+jWxYg/UhKpr1@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> > and the backing page is being reclaimed in L0? I saw
> > nested_get_vmcs12_pages() will check vmcs12 and set the APIC access address
> > in VMCS02, but not sure if this routine will be triggered by the mmu
> > notifier...
> 
> Pages from vmcs12 that are referenced by physical address in the VMCS are pinned
> (where "pinned" means KVM holds a reference to the page) by kvm_vcpu_map().  I.e.
> the page will not be migrated, and if userspace unmaps the page, userspace might
> break its VM, but that's true for any guest memory that userspace unexpectedly
> unmaps, and there won't be any no use-after-free issues.
> 
Thanks, Sean. 

About the kvm_vcpu_map(), is it necessary for APIC access address? L0 only
needs to get its pfn, and does not care about the hva or struct page. Could
we just use gfn_to_pfn() to retrieve the pfn, and kvm_release_pfn_clean() to
unpin it later? 

B.R.
Yu
