Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705D927F67D
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 02:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbgJAAID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 20:08:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:60234 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbgJAAID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 20:08:03 -0400
IronPort-SDR: QOrSecTYfy1wNKpIgdRhPk/jXOqYdpaxwx/VhQnzsYMVjdkoRZq4fc0juNcSAy9qgu2ADjYlyC
 9zx6nZZEQc9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="226709898"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="226709898"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 17:07:54 -0700
IronPort-SDR: 1UJ+S4sgmJXexOZ5NPN/D3AT2O/fyuck9i4WqjCgWy/HEdJYwpfSfAqOPkDrBS0lCVlHuCz25h
 HJYdcPBr3few==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="341382868"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 17:07:54 -0700
Date:   Wed, 30 Sep 2020 17:07:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric van Tassell <evantass@amd.com>,
        Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
Message-ID: <20201001000752.GB2988@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-3-bgardon@google.com>
 <4a74aafe-9613-4bf2-47a1-cad0aad34323@amd.com>
 <2d43d29f-d29c-3dd7-1709-4414f34d27da@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2d43d29f-d29c-3dd7-1709-4414f34d27da@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 01, 2020 at 01:34:53AM +0200, Paolo Bonzini wrote:
> On 01/10/20 01:20, Eric van Tassell wrote:
> >>
> >> +int is_shadow_present_pte(u64 pte)
> >>   {
> >>       return (pte != 0) && !is_mmio_spte(pte);
> > From <Figure 28-1: Formats of EPTP and EPT Paging-Structure Entries" of
> > the manual I don't have at my fingertips right now, I believe you should
> > only check the low 3 bits(mask = 0x7). Since the upper bits are ignored,
> > might that not mean they're not guaranteed to be 0?
> 
> No, this a property of the KVM MMU (and how it builds its PTEs) rather
> than the hardware present check.

Ya, I found out the hard way that "present" in is_shadow_present_pte() really
means "valid", or "may be present".  The most notable case is EPT without A/D
bits (I think this is the only case where a valid SPTE can be fully not-present
in hardware).  Accessed tracking will clear all RWX bits to make the EPT entry
not-present, but from KVM's perspective it's treated as valid/present because
it can be made present in hardware without taking the MMU lock.
