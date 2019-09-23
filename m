Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F4CBBF25
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 01:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503465AbfIWXw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 19:52:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:33600 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729276AbfIWXw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 19:52:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 16:52:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,542,1559545200"; 
   d="scan'208";a="213498370"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 23 Sep 2019 16:52:57 -0700
Date:   Mon, 23 Sep 2019 16:52:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190923235257.GS18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com>
 <20190923202349.GL18195@linux.intel.com>
 <20190923210838.GA23063@redhat.com>
 <20190923212435.GO18195@linux.intel.com>
 <20190923234307.GG19996@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923234307.GG19996@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 07:43:07PM -0400, Andrea Arcangeli wrote:
> On Mon, Sep 23, 2019 at 02:24:35PM -0700, Sean Christopherson wrote:
> > An extra CALL+RET isn't going to be noticeable, especially on modern
> > hardware as the high frequency VMWRITE/VMREAD fields should hit the
> > shadow VMCS.
> 
> In your last email with regard to the inlining optimizations made
> possible by the monolithic KVM model you said "That'd likely save a
> few CALL/RET/JMP instructions", that kind of directly contradicts the
> above. I think neither one if taken at face value can be possibly
> measured. However the above only is relevant for nested KVM so I'm
> fine if there's an agreement that it's better to hide the nested vmx
> handlers in nested.c at the cost of some call/ret.

For the immediate exit case, eliminating the CALL/RET/JMP instructions
is a bonus.  The real goal was to eliminate the oddity of bouncing
through vendor code to invoke a one-line x86 function.  Having a separate
__kvm_request_immediate_exit() made sense when overwriting kvm_ops_x86, but
not so much when using direct calls.
