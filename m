Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E730B1011A
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 22:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfD3Uol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 16:44:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:11912 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfD3Uol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 16:44:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 13:44:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="342231339"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga005.fm.intel.com with ESMTP; 30 Apr 2019 13:44:40 -0700
Date:   Tue, 30 Apr 2019 13:44:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86: Prevent use of kvm_register_{read,write}()
 with known GPRs
Message-ID: <20190430204439.GC4523@linux.intel.com>
References: <20190430173619.15774-1-sean.j.christopherson@intel.com>
 <20190430173619.15774-3-sean.j.christopherson@intel.com>
 <a1dc6d40-feba-4b14-bc23-b25e23bb3c2d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1dc6d40-feba-4b14-bc23-b25e23bb3c2d@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 30, 2019 at 10:34:52PM +0200, Paolo Bonzini wrote:
> On 30/04/19 19:36, Sean Christopherson wrote:
> > ... to prevent future code from using the unoptimized generic accessors
> > when hardcoding access to always-available GPRs.
> 
> This cannot be done in general, because builtin_constant_p could be used
> through layers of inlining.  For example you could have a function that
> takes an enum kvm_reg argument and _its_ caller passes a constant in
> there.  Of course we may just say that we don't have such a case now (do
> we?) and so it's unlikely to happen in the future as well.

Another potential hiccup, and probably more likely, is that
the register save loops in enter_smm_save_state_{32,64} get unrolled by
the compiler.

My thought was (is?) that the only time KVM should ever use the
generic accessors is when the register is truly unknown, i.e. comes
from emulating an instruction with ModRM (or equivalent).

I thought about manually unrolling enter_smm_save_state_{32,64} so as
to avoid the caching logic, but that seemed like overkill at the time.
I didn't consider the compiler unrolling the loop and exploding.  I'll
see if I can come up with anything clever for the SMM flow and expand
the changelog if I end up with a version that is "guaranteed" to not
run afould of compiler tricks.

P.S. Do you want me to send a patch with the cleanup parts that I unwisely
smushed into this patch?  Or have you already taken care of that?
