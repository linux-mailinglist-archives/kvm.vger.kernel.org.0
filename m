Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF74269867
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 23:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgINVyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 17:54:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:26619 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgINVyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 17:54:13 -0400
IronPort-SDR: U7Vwuh45twHi0HKvrjk5YU5k00tXQyqCEoZRl7UpN2m5t/mwxHt6FSm7TsZib6sozSK+SK7+pl
 YKWNl/EEIiiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160101326"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="160101326"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:54:13 -0700
IronPort-SDR: rTtZ9m78AZA1nRay+WPP5FJTGr65suXY8QAGUj8PnJIujVfkJnLbHvCbbhSfIKSupPECRw8Mxg
 Dw5LhrbUR9vA==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482508943"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 14:54:13 -0700
Date:   Mon, 14 Sep 2020 14:54:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Move IRQ invocation to assembly subroutine
Message-ID: <20200914215411.GF7192@sjchrist-ice>
References: <20200914195634.12881-1-sean.j.christopherson@intel.com>
 <20200914195634.12881-2-sean.j.christopherson@intel.com>
 <20200914204024.w3rpjon64d3fesys@treble>
 <20200914210719.GB7084@sjchrist-ice>
 <20200914213813.zfxlffphcp5czvof@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914213813.zfxlffphcp5czvof@treble>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 04:38:13PM -0500, Josh Poimboeuf wrote:
> On Mon, Sep 14, 2020 at 02:07:19PM -0700, Sean Christopherson wrote:
> > > RSP needs to be aligned to what?  How would this align the stack, other
> > > than by accident?
> > 
> > Ah, yeah, that's lacking info.
> > 
> > 16-byte aligned to correctly mimic CPU behavior when vectoring an IRQ/NMI.
> > When not changing stack, the CPU aligns RSP before pushing the frame.
> > 
> > The above shenanigans work because the x86-64 ABI also requires RSP to be
> > 16-byte aligned prior to CALL.  RSP is thus 8-byte aligned due to CALL
> > pushing the return IP, and so creating the stack frame by pushing RBP makes
> > it 16-byte aliagned again.
> 
> As Uros mentioned, the kernel doesn't do this.

Argh, apparently I just got lucky with my compiles then.  I added explicit
checks on RSP being properly aligned and thought that confirmed the kernel
played nice.  Bummer.
