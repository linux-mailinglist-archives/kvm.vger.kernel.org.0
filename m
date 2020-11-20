Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF42BA449
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 09:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgKTIGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 03:06:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbgKTIGN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 03:06:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605859572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Sc3/DoTPvTLhE+UbBZa2r71W9UwlwEzVG8I2Gq48DA=;
        b=OggcpzvwzZ7tS2da95l+uqD1U3w7EwHcgY0Cyav8Yfy+Zs5HYwsozDebj2UnqrUZ0U5Mjx
        Oh9ta6VM/JSQu/9Vb8sasHS4vDS4Aj4muOdxagIFGqD23EFcV4XmsM1oI+VtWbMqZUIZJq
        r/GbgvYwgd1seQeSIPoEBZonSwhTPjU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-dGq18GHCMrC3pjvZ4Ewgjg-1; Fri, 20 Nov 2020 03:06:09 -0500
X-MC-Unique: dGq18GHCMrC3pjvZ4Ewgjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC958107ACE3;
        Fri, 20 Nov 2020 08:06:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0CC65D9D5;
        Fri, 20 Nov 2020 08:05:59 +0000 (UTC)
Date:   Fri, 20 Nov 2020 09:05:56 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
Message-ID: <20201120080556.2enu4ygvlnslmqiz@kamzik.brq.redhat.com>
References: <20201116121942.55031-1-drjones@redhat.com>
 <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16, 2020 at 07:16:50PM +0100, Paolo Bonzini wrote:
> On 16/11/20 13:19, Andrew Jones wrote:
> > This series attempts to clean up demand_paging_test, dirty_log_perf_test,
> > and dirty_log_test by factoring out common code, creating some new API
> > along the way. It also splits include/perf_test_util.h into a more
> > conventional header and source pair.
> > 
> > I've tested on x86 and AArch64 (one config each), but not s390x.
> > 
> > v3:
> >   - Rebased remaining four patches from v2 onto kvm/queue
> >   - Picked up r-b's from Peter and Ben
> > 
> > v2: https://www.spinics.net/lists/kvm/msg228711.html
> 
> Unfortunately patch 2 is still broken:
> 
> $ ./dirty_log_test -M dirty-ring
> Setting log mode to: 'dirty-ring'
> Test iterations: 32, interval: 10 (ms)
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> ==== Test Assertion Failure ====
>   lib/kvm_util.c:85: ret == 0
>   pid=2010122 tid=2010122 - Invalid argument
>      1	0x0000000000402ee7: vm_enable_cap at kvm_util.c:84
>      2	0x0000000000403004: vm_enable_dirty_ring at kvm_util.c:124
>      3	0x00000000004021a5: log_mode_create_vm_done at dirty_log_test.c:453
>      4	 (inlined by) run_test at dirty_log_test.c:683
>      5	0x000000000040b643: for_each_guest_mode at guest_modes.c:37
>      6	0x00000000004019c2: main at dirty_log_test.c:864
>      7	0x00007fe3f48207b2: ?? ??:0
>      8	0x0000000000401aad: _start at ??:?
>   KVM_ENABLE_CAP IOCTL failed,
>   rc: -1 errno: 22
> 

So I finally looked closely enough at the dirty-ring stuff to see that
patch 2 was always a dumb idea. dirty_ring_create_vm_done() has a comment
that says "Switch to dirty ring mode after VM creation but before any of
the vcpu creation". I'd argue that that comment would be better served at
the log_mode_create_vm_done() call, but that doesn't excuse my sloppiness
here. Maybe someday we can add a patch that adds that comment and also
tries to use common code for the number of pages calculation for the VM,
but not today.

Regarding this series, if the other three patches look good, then we
can just drop 2/4. 3/4 and 4/4 should still apply cleanly and work.

Thanks,
drew

