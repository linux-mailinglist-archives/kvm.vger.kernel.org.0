Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501CF1DBCC4
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 20:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgETSYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 14:24:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:48214 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbgETSYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 14:24:40 -0400
IronPort-SDR: kA9uCOfTHe/oxYHbNSjaXhst4gFYypz6Mprf7aRR+DELzHIgYO/MJsM58L3pF1oNpZk0zUNC+j
 mCWBkvmRl8Zw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 11:24:40 -0700
IronPort-SDR: Ypm2z3nWDUG7ZmbZjO9jywFjZeA+GSi0EFdtJ0UuVCGZ3MgXju9knWwr+ZM3x71Gu15lssgik/
 GE7M1iRmlNXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,414,1583222400"; 
   d="scan'208";a="289446544"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 20 May 2020 11:24:39 -0700
Date:   Wed, 20 May 2020 11:24:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 21/24] KVM: x86: always update CR3 in VMCB
Message-ID: <20200520182439.GC18102@linux.intel.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <20200520172145.23284-22-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520172145.23284-22-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oh, and it'd be nice to do s/VMCB/VMCB\/VMCS in the subject, I almost
glossed over this patch because it explicitly said VMCB :-)

On Wed, May 20, 2020 at 01:21:42PM -0400, Paolo Bonzini wrote:
> vmx_load_mmu_pgd is delaying the write of GUEST_CR3 to prepare_vmcs02 as
> an optimization, but this is only correct before the nested vmentry.
> If userspace is modifying CR3 with KVM_SET_SREGS after the VM has
> already been put in guest mode, the value of CR3 will not be updated.
> Remove the optimization, which almost never triggers anyway.
> 
> This also applies to SVM, where the code was added in commit 689f3bf21628
> ("KVM: x86: unify callbacks to load paging root", 2020-03-16) just to keep the
> two vendor-specific modules closer.
> 
> Fixes: 04f11ef45810 ("KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter")
> Fixes: 689f3bf21628 ("KVM: x86: unify callbacks to load paging root")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
