Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EBF735A06
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 16:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbjFSOrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 10:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjFSOrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 10:47:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368DC1B0;
        Mon, 19 Jun 2023 07:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687186020; x=1718722020;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vSIDsXoHgFk3LG2nLDWLfukEJ6ybqcavLSChFuxh5cU=;
  b=htQZFjwnWRVUTweamLhQNPdG8GdroNoQPne0kTUGvQRbAIg4JJhF/2K4
   dovIOVM6eR1QlsCZYTaSuAz/oAIS/tbe0THzmAyYKKhT8YxARcZpxmH9A
   9FFe9YuhETjAY8aEyZgrmX0EudmO08DpUcaSS+N95uFs3F3jhL1vCdIDy
   6UIsgTWZdRrMIeBcIbRHxaIFZyDxaPTtiRM5Qz2pTVaJQF0pcnd2kOve/
   EQ/9WZBG0Xh0yLJ1pmqwCPbzVIi/c9b0ch9x+5NFwpOww1bDcsDIeGuNQ
   yx1BkxBMXinL1sWSBxrSyLqYmP/DJG08EOmlDtHtW1YpVej4Jav8Y/zuT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="362185572"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="362185572"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 07:46:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="779065687"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="779065687"
Received: from leitchrx-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.45.32])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 07:46:54 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 905A810DD6D; Mon, 19 Jun 2023 17:46:51 +0300 (+03)
Date:   Mon, 19 Jun 2023 17:46:51 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Message-ID: <20230619144651.kvmscndienyfr3my@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
 <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
 <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
 <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
 <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
 <5782c8c2bb3e76a802e4a81c553a21edbaee7c47.camel@intel.com>
 <be258af9-a329-6f03-fcf9-9dafad42c97f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be258af9-a329-6f03-fcf9-9dafad42c97f@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 19, 2023 at 07:31:21AM -0700, Dave Hansen wrote:
> On 6/19/23 04:43, Huang, Kai wrote:
> > On Mon, 2023-06-12 at 06:47 -0700, Dave Hansen wrote:
> >> On 6/12/23 03:27, Huang, Kai wrote:
> >>> So I think a __mb() after setting tdmr->pamt_4k_base should be good enough, as
> >>> it guarantees when setting to any pamt_*_size happens, the valid pamt_4k_base
> >>> will be seen by other cpus.
> >>>
> >>> Does it make sense?
> >> Just use a normal old atomic_t or set_bit()/test_bit().  They have
> >> built-in memory barriers are are less likely to get botched.
> > Hi Dave,
> > 
> > Using atomic_set() requires changing tdmr->pamt_4k_base to atomic_t, which is a
> > little bit silly or overkill IMHO.  Looking at the code, it seems
> > arch_atomic_set() simply uses __WRITE_ONCE():
> 
> How about _adding_ a variable that protects tdmr->pamt_4k_base?
> Wouldn't that be more straightforward than mucking around with existing
> types?

What's wrong with simple global spinlock that protects all tdmr->pamt_*?
It is much easier to follow than a custom serialization scheme.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
