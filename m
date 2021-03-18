Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA3D340C47
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 18:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhCRR4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 13:56:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232319AbhCRR4G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 13:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616090165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yJwKGGb6xUVv2uEIdalH0fpIFBKMebltv5Li4eKnJWw=;
        b=AYk/2jd10wBDcsPrbMUA7kUB8Ap+V8QIn3j/mxDusEzMIyindXdHYSgpWkBLufVPHjAR25
        RwBKyFolV0k7HxvwGbiD4DIbAcBfcJpB7OwnTalPBacmIOVhMPirDi6S7s61WL9iTj+UGv
        m9WiFNDyLrqqQov7caNrx6sQEF2zxGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-VM2tPDYXM5CJIXqD_HAj8w-1; Thu, 18 Mar 2021 13:56:02 -0400
X-MC-Unique: VM2tPDYXM5CJIXqD_HAj8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A1378189D7;
        Thu, 18 Mar 2021 17:56:00 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B3126064B;
        Thu, 18 Mar 2021 17:56:00 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id DEE0A4188684; Thu, 18 Mar 2021 14:55:15 -0300 (-03)
Date:   Thu, 18 Mar 2021 14:55:15 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources
 tests
Message-ID: <20210318175515.GA40821@fuller.cnet>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210318140949.1065740-1-vkuznets@redhat.com>
 <20210318165756.GA36190@fuller.cnet>
 <4882dc8f-30bf-f049-f770-24811bb96b54@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4882dc8f-30bf-f049-f770-24811bb96b54@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 06:50:35PM +0100, Paolo Bonzini wrote:
> On 18/03/21 17:57, Marcelo Tosatti wrote:
> > I think this should be monotonically increasing:
> > 
> > 1.	r1 = rdtsc();
> > 2.	t1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
> > 3.	nop_loop();
> > 4.	r2 = rdtsc();
> > 5.	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);	
> > 
> > > 
> > > +	/* 1% tolerance */
> > > +	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
> > > +}
> > 
> > Doesnt an unbounded schedule-out/schedule-in (which resembles
> > overloaded host) of the qemu-kvm vcpu in any of the points 1,2,3,4,5
> > break the assertion above?
> 
> 
> Yes, there's a window of a handful of instructions (at least on
> non-preemptible kernels).  If anyone ever hits it, we can run the test 100
> times and check that it passes at least 95 or 99 of them.
> 
> Paolo

Yep, sounds like a good solution.

However this makes me wonder on the validity of the test: what its
trying to verify, again? (i would check the monotonicity that 
is r1 <= t1 <= r2 <= t2 as well, without the nop_loop in between).

