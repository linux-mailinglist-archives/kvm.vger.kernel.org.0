Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F9073FBDD
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 14:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjF0MTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 08:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjF0MTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 08:19:06 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EBB1999;
        Tue, 27 Jun 2023 05:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687868344; x=1719404344;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S/Oh83wIoz8iTjgXyFj7FBvLQ6z/1uq7Rt97/C+Sd54=;
  b=UhlkP5V77gYWSjHPKHlfFoxLhqjpTxGu3c4H7WKrpD1jaJ2Rj7OThxmC
   kogpxGeUMrU9ozH7RrmikkPX3U9hEoh/JCiiaIpj0JznH50AXczy0z8+i
   7BKfL7RrdNv5LRF0T2muSqFT6KjWZRHv4LFvwywmrNCCGpXgo73Nb1upx
   fxU2ENeRQELt92z3QBkOLsmRkm9LVvKmSjKYmluvGw/KKyYDu6l25JqhC
   eXuQi2E3dPoONTlCMzzcox850guSlqS+ON4MNuXxPtfuP/sMSWov6VITI
   FplneC5xXvV7ojDOpXK3nKzUMx1Jq0WCmcZ488aWiMtN7G61x8MGW8WCL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="364105346"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="364105346"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 05:19:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="963174691"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="963174691"
Received: from rbhaumik-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.251.217.121])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 05:18:56 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 453D0103738; Tue, 27 Jun 2023 15:18:53 +0300 (+03)
Date:   Tue, 27 Jun 2023 15:18:53 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
 <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 10:34:04AM +0000, Huang, Kai wrote:
> On Tue, 2023-06-27 at 12:50 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Tue, Jun 27, 2023 at 02:12:37AM +1200, Kai Huang wrote:
> > > +	/*
> > > +	 * The TDX module global initialization only needs to be done
> > > +	 * once on any cpu.
> > > +	 */
> > > +	raw_spin_lock_irqsave(&tdx_global_init_lock, flags);
> > 
> > I don't understand how the comment justifies using raw spin lock.
> > 
> 
> This comment is for using lock in general.  The reason to use raw_ version is
> because this function gets called in IRQ context, and for PREEMPT_RT kernel the
> normal spinlock is converted to sleeping lock.

Sorry, but this still doesn't explain anything.

Why converting to sleeping lock here is wrong? There are plenty
spin_lock_irqsave() users all over the kernel that are fine to be
converted to sleeping lock on RT kernel. Why this use-case is special
enough to justify raw_?

From the documentation:

	raw_spinlock_t is a strict spinning lock implementation in all
	kernels, including PREEMPT_RT kernels. Use raw_spinlock_t only in
	real critical core code, low-level interrupt handling and places
	where disabling preemption or interrupts is required, for example,
	to safely access hardware state. raw_spinlock_t can sometimes also
	be used when the critical section is tiny, thus avoiding RT-mutex
	overhead.

How does it apply here?

> Dave suggested to comment on the function rather than comment on the
> raw_spin_lock directly, e.g.,  no other kernel code does that:
> 
> https://lore.kernel.org/linux-mm/d2b3bc5e-1371-0c50-8ecb-64fc70917d42@intel.com/
> 
> So I commented the function in this version:
> 
> +/*
> + * Do the module global initialization if not done yet.
> + * It's always called with interrupts and preemption disabled.
> + */

If interrupts are always disabled why do you need _irqsave()?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
