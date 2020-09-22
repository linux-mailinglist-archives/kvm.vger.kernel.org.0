Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0512274581
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 17:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgIVPjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 11:39:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50478 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726810AbgIVPjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 11:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600789184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lmWuOZWC5vEFLn9TZNSK2MRdB7KP5iT7n5gHz6qa7g0=;
        b=hUGkDRZ5fRx7+8cw41fs8qSWqrOU7e9miMAeGVvhBfgRlf640TCUwX0KDFI1n3mfxEo34S
        b1c9SYpGiGxJgf74Beo1vsXN4iTNzzBUKnoQ01jv4LITYOh6nNTTZ4DwKNxsHJqTTBk0q0
        KTGbFK/sxRUgty7B06GYftZl4rEAnA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-073ccWMMNsyOZ4DBoXHx2g-1; Tue, 22 Sep 2020 11:39:42 -0400
X-MC-Unique: 073ccWMMNsyOZ4DBoXHx2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 782188C3360;
        Tue, 22 Sep 2020 15:39:40 +0000 (UTC)
Received: from starship (unknown [10.35.206.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E026710013D7;
        Tue, 22 Sep 2020 15:39:35 +0000 (UTC)
Message-ID: <5d19bbf5bcc4975e4ac6c4aef8b92b4a1ed4bc16.camel@redhat.com>
Subject: Re: [PATCH v2 1/1] KVM: x86: fix MSR_IA32_TSC read for nested
 migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Tue, 22 Sep 2020 18:39:34 +0300
In-Reply-To: <7db1383cc9d40f76a02076c3b86cf832fd7463cc.camel@redhat.com>
References: <20200921103805.9102-1-mlevitsk@redhat.com>
         <20200921103805.9102-2-mlevitsk@redhat.com>
         <20200921162326.GB23989@linux.intel.com>
         <de9411ce-aa83-77c8-b2ae-a3873250a0b1@redhat.com>
         <7db1383cc9d40f76a02076c3b86cf832fd7463cc.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-09-22 at 17:50 +0300, Maxim Levitsky wrote:
> On Tue, 2020-09-22 at 14:50 +0200, Paolo Bonzini wrote:
> > On 21/09/20 18:23, Sean Christopherson wrote:
> > > Avoid "should" in code comments and describe what the code is doing, not what
> > > it should be doing.  The only exception for this is when the code has a known
> > > flaw/gap, e.g. "KVM should do X, but because of Y, KVM actually does Z".
> > > 
> > > > +		 * return it's real L1 value so that its restore will be correct.
> > > s/it's/its
> > > 
> > > Perhaps add "unconditionally" somewhere, since arch.tsc_offset can also contain
> > > the L1 value.  E.g. 
> > > 
> > > 		 * Unconditionally return L1's TSC offset on userspace reads
> > > 		 * so that userspace reads and writes always operate on L1's
> > > 		 * offset, e.g. to ensure deterministic behavior for migration.
> > > 		 */
> > > 
> > 
> > Technically the host need not restore MSR_IA32_TSC at all.  This follows
> > the idea of the discussion with Oliver Upton about transmitting the
> > state of the kvmclock heuristics to userspace, which include a (TSC,
> > CLOCK_MONOTONIC) pair to transmit the offset to the destination.  All
> > that needs to be an L1 value is then the TSC value in that pair.
> > 
> > I'm a bit torn over this patch.  On one hand it's an easy solution, on
> > the other hand it's... just wrong if KVM_GET_MSR is used for e.g.
> > debugging the guest.
> 
> Could you explain why though? After my patch, the KVM_GET_MSR will consistently
> read the L1 TSC, just like all other MSRs as I explained. I guess for debugging,
> this should work?
> 
> The fact that TSC reads with the guest offset is a nice exception made for the guests,
> that insist on reading this msr without inteception and not using rdtsc.
> 
> Best regards,
> 	Maxim Levitsky
> 
> > I'll talk to Maxim and see if he can work on the kvmclock migration stuff.

We talked about this on IRC and now I am also convinced that we should implement
proper TSC migration instead, so I guess I'll drop this patch and I will implement it.

Last few weeks I was digging through all the timing code, and I mostly understand it
so it shouldn't take me much time to implement it.

There is hope that this will make nested migration fully stable since, with this patch,
it still sometimes hangs. While on my AMD machine it takes about half a day of migration
cycles to reproduce this, on my Intel's laptop even with this patch I can hang the nested
guest after 10-20 cycles. The symptoms look very similar to the issue that this patch
tried to fix.
 
Maybe we should keep the *comment* I added to document this funny TSC read behavior. 
When I implement the whole thing, maybe I add a comment only version of this patch
for that.

Best regards,
	Maxim Levitsky 

> > 
> > Paolo
> > 


