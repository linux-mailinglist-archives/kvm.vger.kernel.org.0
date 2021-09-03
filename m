Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D06D3FFC56
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 10:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348446AbhICIwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 04:52:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:14856 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348429AbhICIwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 04:52:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="280384714"
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="280384714"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 01:51:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="429550353"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 03 Sep 2021 01:51:02 -0700
Message-ID: <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Date:   Fri, 03 Sep 2021 16:51:01 +0800
In-Reply-To: <YS/lxNEKXLazkhc4@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
         <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
         <YRvbvqhz6sknDEWe@google.com>
         <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
         <YR2Tf9WPNEzrE7Xg@google.com>
         <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
         <YS/lxNEKXLazkhc4@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-09-01 at 20:42 +0000, Sean Christopherson wrote:
> On Thu, Aug 19, 2021, Robert Hoo wrote:
> > On Wed, 2021-08-18 at 23:10 +0000, Sean Christopherson wrote:
> > > > My this implementation: once VMX MSR's updated, the update
> > > > needs to be
> > > > passed to bitmap, this is 1 extra step comparing to
> > > > aforementioned above.
> > > > But, later, when query field existence, especially the those
> > > > consulting
> > > > vm{entry,exit}_ctrl, they usually would have to consult both
> > > > MSRs if
> > > > otherwise no bitmap, and we cannot guarantee if in the future
> > > > there's no
> > > > more complicated dependencies. If using bitmap, this consult is
> > > > just
> > > > 1-bit reading. If no bitmap, several MSR's read and compare
> > > > happen.
> > > 
> > > Yes, but the bitmap is per-VM and likely may or may not be cache-
> > > hot for
> > > back-to-back VMREAD/VMWRITE to different fields, whereas the
> > > shadow
> > > controls are much more likely to reside somewhere in the caches.
> > 
> > Sorry I don't quite understand the "shadow controls" here. Do you
> > mean
> > shadow VMCS? what does field existence to do with shadow VMCS?
> 
> vmcs->controls_shadow.*

OK, I see now. But I still don't understand why is these shadow
controls related to field existence. They not in
handle_vm{read,write}() path. Would you shed more light? Thanks.
> 
> > emm, here you indeed remind me a questions: what if L1
> > VMREAD/VMWRITE a
> > shadow field that doesn't exist?
> 
> Doesn't exist in hardware?  
I mean doesn't exist in VMCS12, per the bitmap. In this case, when L1
read/write the field, it is shadowed, won't be trapped by vmx. 

> KVM will intercept the access by leaving the
> corresponding bit set in the VMREAD/VMWRITE bitmaps.  This is handled
> by
> init_vmcs_shadow_fields().  Note, KVM will still incorrectly emulate
> the access,
> but on the plus side that means L2 will see consistent behavior
> regardless of
> underlying hardware.

