Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E675022A39F
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 02:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733231AbgGWA3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 20:29:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:28662 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729486AbgGWA3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 20:29:41 -0400
IronPort-SDR: mQzAGlKCCuvKcm4vAyXPHgq61e5tIOzTfGMyNmsPqwwgsRMmSGoFu7ZpuarhEF5VrPewKV7ZgA
 TM5uLyLhpiRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="149620646"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="149620646"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 17:29:41 -0700
IronPort-SDR: dnI/EJGSOOebbW4BpM3U1cRyeFIY8G0LSZwYJ1J3OzLS4f724Ci4kCG0joZmj1jMOMpTa0xWBh
 8p9rhiNwK9Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="288464413"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 22 Jul 2020 17:29:40 -0700
Date:   Wed, 22 Jul 2020 17:29:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v11 02/13] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200723002940.GO9114@linux.intel.com>
References: <20200708193408.242909-1-peterx@redhat.com>
 <20200708193408.242909-3-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708193408.242909-3-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 08, 2020 at 03:33:57PM -0400, Peter Xu wrote:
> Originally, we have three code paths that can dirty a page without
> vcpu context for X86:
> 
>   - init_rmode_identity_map
>   - init_rmode_tss
>   - kvmgt_rw_gpa
> 
> init_rmode_identity_map and init_rmode_tss will be setup on
> destination VM no matter what (and the guest cannot even see them), so
> it does not make sense to track them at all.
> 
> To do this, allow __x86_set_memory_region() to return the userspace
> address that just allocated to the caller.  Then in both of the
> functions we directly write to the userspace address instead of
> calling kvm_write_*() APIs.
> 
> Another trivial change is that we don't need to explicitly clear the
> identity page table root in init_rmode_identity_map() because no
> matter what we'll write to the whole page with 4M huge page entries.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
