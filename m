Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13FC2B78E7
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 09:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgKRIip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 03:38:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbgKRIio (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 03:38:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605688723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZvRjCh7RiJkiCOqwcxEnpJsmtLWsYq7gbP6J2YA17L0=;
        b=czLKob4GzKb8mzi3trKmTSr3yjImEg3wBsessqwgtuBqc5wioXx4g68wxt3smAj5Gd9ec4
        OyIrZNMvY473YrjQ681tuLERwpcodjjQT4vOCnt9u4/2LZ+oCKiXHQgvJKlt3cJEjjlLoe
        dIIBDPEFAuwLobptFcSBEbrZNbFNBIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-QsZ7YhfjPq2eQJqFdg55TA-1; Wed, 18 Nov 2020 03:38:40 -0500
X-MC-Unique: QsZ7YhfjPq2eQJqFdg55TA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8871364147;
        Wed, 18 Nov 2020 08:38:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CADC2196FE;
        Wed, 18 Nov 2020 08:38:34 +0000 (UTC)
Date:   Wed, 18 Nov 2020 09:38:31 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
Message-ID: <20201118083831.jygosjdwhbk5dj66@kamzik.brq.redhat.com>
References: <20201116121942.55031-1-drjones@redhat.com>
 <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
 <20201116184011.GB19950@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116184011.GB19950@xz-x1>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16, 2020 at 01:40:11PM -0500, Peter Xu wrote:
> On Mon, Nov 16, 2020 at 07:16:50PM +0100, Paolo Bonzini wrote:
> > On 16/11/20 13:19, Andrew Jones wrote:
> > > This series attempts to clean up demand_paging_test, dirty_log_perf_test,
> > > and dirty_log_test by factoring out common code, creating some new API
> > > along the way. It also splits include/perf_test_util.h into a more
> > > conventional header and source pair.
> > > 
> > > I've tested on x86 and AArch64 (one config each), but not s390x.
> > > 
> > > v3:
> > >   - Rebased remaining four patches from v2 onto kvm/queue
> > >   - Picked up r-b's from Peter and Ben
> > > 
> > > v2: https://www.spinics.net/lists/kvm/msg228711.html
> > 
> > Unfortunately patch 2 is still broken:
> > 
> > $ ./dirty_log_test -M dirty-ring
> > Setting log mode to: 'dirty-ring'
> > Test iterations: 32, interval: 10 (ms)
> > Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> > ==== Test Assertion Failure ====
> >   lib/kvm_util.c:85: ret == 0
> >   pid=2010122 tid=2010122 - Invalid argument
> >      1	0x0000000000402ee7: vm_enable_cap at kvm_util.c:84
> >      2	0x0000000000403004: vm_enable_dirty_ring at kvm_util.c:124
> >      3	0x00000000004021a5: log_mode_create_vm_done at dirty_log_test.c:453
> >      4	 (inlined by) run_test at dirty_log_test.c:683
> >      5	0x000000000040b643: for_each_guest_mode at guest_modes.c:37
> >      6	0x00000000004019c2: main at dirty_log_test.c:864
> >      7	0x00007fe3f48207b2: ?? ??:0
> >      8	0x0000000000401aad: _start at ??:?
> >   KVM_ENABLE_CAP IOCTL failed,
> >   rc: -1 errno: 22
> > 
> > (Also fails without -M).
> 
> It should be because of the ordering of creating vcpu and enabling dirty rings,
> since currently for simplicity when enabling dirty ring we must have not
> created any vcpus:
> 
> +       if (kvm->created_vcpus) {
> +               /* We don't allow to change this value after vcpu created */
> +               r = -EINVAL;
> +       } else {
> +               kvm->dirty_ring_size = size;
> +               r = 0;
> +       }
> 
> We may need to call log_mode_create_vm_done() before creating any vcpus
> somehow.  Sorry to not have noticed that when reviewing it.
>

And sorry for having not tested with '-M dirty-ring'. I thought we were
trying to ensure each unique test type had its own test file (even if we
have to do the weird inclusion of C files). Doing that, the command line
options are then only used to change stuff like verbosity or to experiment
with tweaked configurations.

If we're not doing that, then I think we should. We don't want to try and
explain to all the CI people how each test should be run. It's much easier
to say "run all the binaries, no parameters necessary". Each binary with
no parameters should run the test(s) using a good default or by executing
all possible configurations.

Thanks,
drew

