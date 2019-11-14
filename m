Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52275FC995
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfKNPKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:10:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:50143 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbfKNPKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 10:10:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 07:10:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="379601037"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 14 Nov 2019 07:10:51 -0800
Date:   Thu, 14 Nov 2019 07:10:51 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Take slots_lock when using
 kvm_mmu_zap_all_fast()
Message-ID: <20191114151051.GB24045@linux.intel.com>
References: <20191113193032.12912-1-sean.j.christopherson@intel.com>
 <1b46d531-6423-3ccc-fc5f-df6fbaa02557@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b46d531-6423-3ccc-fc5f-df6fbaa02557@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 14, 2019 at 01:16:21PM +0100, Paolo Bonzini wrote:
> On 13/11/19 20:30, Sean Christopherson wrote:
> > Failing to take slots_lock when toggling nx_huge_pages allows multiple
> > instances of kvm_mmu_zap_all_fast() to run concurrently, as the other
> > user, KVM_SET_USER_MEMORY_REGION, does not take the global kvm_lock.
> > Concurrent fast zap instances causes obsolete shadow pages to be
> > incorrectly identified as valid due to the single bit generation number
> > wrapping, which results in stale shadow pages being left in KVM's MMU
> > and leads to all sorts of undesirable behavior.
> 
> Indeed the current code fails lockdep miserably, but isn't the whole
> body of kvm_mmu_zap_all_fast() covered by kvm->mmu_lock?  What kind of
> badness can happen if kvm->slots_lock isn't taken?

kvm_zap_obsolete_pages() temporarily drops mmu_lock and reschedules so
that it doesn't block other vCPUS from inserting shadow pages into the new
generation of the mmu.
