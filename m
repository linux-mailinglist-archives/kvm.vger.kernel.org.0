Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4C7BBF62
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 02:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391768AbfIXAfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 20:35:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:18647 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388800AbfIXAfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 20:35:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 17:35:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,542,1559545200"; 
   d="scan'208";a="203247391"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 17:35:00 -0700
Date:   Mon, 23 Sep 2019 17:35:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190924003459.GA13147@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com>
 <20190923202349.GL18195@linux.intel.com>
 <20190923210838.GA23063@redhat.com>
 <b58d2305-284f-8652-a0f3-380b26642fe0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b58d2305-284f-8652-a0f3-380b26642fe0@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 24, 2019 at 02:16:36AM +0200, Paolo Bonzini wrote:
> On 23/09/19 23:08, Andrea Arcangeli wrote:
> > The two most attractive options to me remains what I already have
> > implemented under #ifdef CONFIG_RETPOLINE with direct calls
> > (optionally replacing the "if" with a small "switch" still under
> > CONFIG_RETPOLINE if we give up the prioritization of the checks), or
> > the replacement of kvm_vmx_exit_handlers with a switch() as suggested
> > by Vitaly which would cleanup some code.
> > 
> > The intermediate solution that makes "const" work, has the cons of
> > forcing to parse EXIT_REASON_VMCLEAR and the other vmx exit reasons
> > twice, first through a pointer to function (or another if or switch
> > statement) then with a second switch() statement.
> 
> I agree.  I think the way Andrea did it in his patch may not the nicest
> but is (a bit surprisingly) the easiest and most maintainable.

Heh, which patch?  The original patch of special casing the high
priority exits?
