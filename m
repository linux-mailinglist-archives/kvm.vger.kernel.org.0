Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C891DF249
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 00:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbgEVWrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 18:47:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:51807 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731029AbgEVWrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 18:47:12 -0400
IronPort-SDR: re6UTTsTxBHvTT2wK1cXsvHMc2QKpn0VdFfh9EB8LT7e2bTxtRw8w7SrZiuUB6NV76TwqouZfY
 D8kd8wGOs6zA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 15:47:11 -0700
IronPort-SDR: MKEeLXxdO9riXON5GuFOltoZcJ+RZyIoCIwxJs53y65xZynCbjsxwEcgg2S9vx+AwXXpT1akN8
 69Ej+LC0U4Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,423,1583222400"; 
   d="scan'208";a="374889829"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 15:47:11 -0700
Date:   Fri, 22 May 2020 15:47:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 21/24] KVM: x86: always update CR3 in VMCB
Message-ID: <20200522224711.GF25128@linux.intel.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <20200520172145.23284-22-pbonzini@redhat.com>
 <20200520182202.GB18102@linux.intel.com>
 <d85c2e1d-93b3-186d-7df4-80ae6aa03618@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d85c2e1d-93b3-186d-7df4-80ae6aa03618@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 10:14:47PM +0200, Paolo Bonzini wrote:
> On 20/05/20 20:22, Sean Christopherson wrote:
> > As an alternative fix, what about marking VCPU_EXREG_CR3 dirty in
> > __set_sregs()?  E.g.
> > 
> > 		/*
> > 		 * Loading vmcs02.GUEST_CR3 is handled by nested VM-Enter, but
> > 		 * it can be explicitly dirtied by KVM_SET_SREGS.
> > 		 */
> > 		if (is_guest_mode(vcpu) &&
> > 		    !test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_dirty))
> > 
> > There's already a dependency on __set_sregs() doing
> > kvm_register_mark_available() before kvm_mmu_reset_context(), i.e. the
> > code is already a bit kludgy.  The dirty check would make the kludge less
> > subtle and provide explicit documentation.
> 
> A comment in __set_sregs is certainly a good idea.  But checking for
> dirty seems worse since the caching of CR3 is a bit special in this
> respect (it's never marked dirty).

That's why I thought it was so clever :-)

> This patch should probably be split too, so that the Fixes tags are
> separate for Intel and AMD.

That would be nice.
