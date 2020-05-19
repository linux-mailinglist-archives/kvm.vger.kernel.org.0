Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0261D8FB4
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 08:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgESGCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 02:02:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:19593 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbgESGCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 02:02:03 -0400
IronPort-SDR: +VQHXw3MQxxcOekyxDvTrVMh8bQypkW80gqq53SYLrdaoGDTjk2YEWSTblI3HFLbSMX3Kp2s85
 dK1HO0rF+vIg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 23:02:03 -0700
IronPort-SDR: y4lsW/PNAfbuy5Fag+JzJnFc/DGtPA/KTrEOkwzocyHtEIyk9G9qprvgxX/KjZ0ltkijiWVnzV
 aFzBlgw6nUlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,409,1583222400"; 
   d="scan'208";a="282220610"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 18 May 2020 23:02:02 -0700
Date:   Mon, 18 May 2020 23:02:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: emulate reserved nops from 0f/18 to 0f/1f
Message-ID: <20200519060156.GB4387@linux.intel.com>
References: <20200515161919.29249-1-pbonzini@redhat.com>
 <20200518160720.GB3632@linux.intel.com>
 <57d9da9b-00ec-3fe0-c69a-f7f00c68a90d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57d9da9b-00ec-3fe0-c69a-f7f00c68a90d@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 18, 2020 at 07:37:08PM +0200, Paolo Bonzini wrote:
> On 18/05/20 18:07, Sean Christopherson wrote:
> > On Fri, May 15, 2020 at 12:19:19PM -0400, Paolo Bonzini wrote:
> >> Instructions starting with 0f18 up to 0f1f are reserved nops, except those
> >> that were assigned to MPX.
> > Well, they're probably reserved NOPs again :-D.
> 
> So are you suggesting adding them back to the list as well?

Doesn't KVM still support MPX?

> >> These include the endbr markers used by CET.
> > And RDSPP.  Wouldn't it make sense to treat RDSPP as a #UD even though it's
> > a NOP if CET is disabled?  The logic being that a sane guest will execute
> > RDSSP iff CET is enabled, and in that case it'd be better to inject a #UD
> > than to silently break the guest.
> 
> We cannot assume that guests will bother checking CPUID before invoking
> RDSPP.  This is especially true userspace, which needs to check if CET
> is enable for itself and can only use RDSPP to do so.

Ugh, yeah, just read through the CET enabling thread that showed code snippets
that do exactly this.

I assume it would be best to make SHSTK dependent on unrestricted guest?
Emulating RDSPP by reading vmcs.GUEST_SSP seems pointless as it will become
statle apart on the first emulated CALL/RET.
