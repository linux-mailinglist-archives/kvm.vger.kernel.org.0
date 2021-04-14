Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF8F35F0A2
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 11:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350275AbhDNJT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 05:19:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348456AbhDNJTR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 05:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618391936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lVRYkG8HT2RetKDpCte03mc/XAEz6khB2uVafY2YZ7o=;
        b=eez5QzTgsBy/FhIPq7/2dIp5g4piYmQei+XYReS9/d3fyBzcrwRwVSMTUEQ6pW+wM6riea
        UUlP5Vyo22w0n4LEPO5aaNH0tmH2ta1i3VEHQx683oh2NbtXrstmoegsKqswsCHo2Gsj9v
        O8I6p/pjNpx8ahKZprFeJou8enbN/og=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-KPBEfEORNDKyhqgqUT8AOA-1; Wed, 14 Apr 2021 05:18:48 -0400
X-MC-Unique: KPBEfEORNDKyhqgqUT8AOA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 771E781744F;
        Wed, 14 Apr 2021 09:18:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A73EF62A22;
        Wed, 14 Apr 2021 09:18:42 +0000 (UTC)
Date:   Wed, 14 Apr 2021 11:18:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] kvm/selftests: Fix race condition with dirty_log_test
Message-ID: <20210414091839.mvm6ffmfdoy44e3l@kamzik.brq.redhat.com>
References: <20210413213641.23742-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413213641.23742-1-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 05:36:41PM -0400, Peter Xu wrote:
> This fixes a bug that can trigger with e.g. "taskset -c 0 ./dirty_log_test" or
> when the testing host is very busy.
> 
> The issue is when the vcpu thread got the dirty bit set but got preempted by
> other threads _before_ the data is written, we won't be able to see the latest
> data only until the vcpu threads do VMENTER. IOW, the guest write operation and
> dirty bit set cannot guarantee atomicity. The race could look like:
> 
>     main thread                            vcpu thread
>     ===========                            ===========
>     iteration=X
>                                            *addr = X
>                                            (so latest data is X)
>     iteration=X+1
>     ...
>     iteration=X+N
>                                            guest executes "*addr = X+N"
>                                              reg=READ_ONCE(iteration)=X+N
>                                              host page fault
>                                                set dirty bit for page "addr"
>                                              (_before_ VMENTER happens...
>                                               so *addr is still X!)
>                                            vcpu thread got preempted
>     get dirty log
>     verify data
>       detected dirty bit set, data is X
>       not X+N nor X+N-1, data too old!
> 
> This patch closes this race by allowing the main thread to give the vcpu thread
> chance to do a VMENTER to complete that write operation.  It's done by adding a
> vcpu loop counter (must be defined as volatile as main thread will do read
> loop), then the main thread can guarantee the vcpu got at least another VMENTER
> by making sure the guest_vcpu_loops increases by 2.
> 
> Dirty ring does not need this since dirty_ring_last_page would already help
> avoid this specific race condition.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
> v2:
> - drop one unnecessary check on "!matched"
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c | 53 +++++++++++++++++++-
>  1 file changed, 52 insertions(+), 1 deletion(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

