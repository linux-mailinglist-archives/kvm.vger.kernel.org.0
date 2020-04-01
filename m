Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BC819A687
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 09:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgDAHss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 03:48:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43127 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731870AbgDAHsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 03:48:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585727326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ypssZ6zwvTHoDEme2IBh4Wgg7TJtOHNAKmXZ7+9lnoU=;
        b=ixDEoymZFrUiLu1s8lIpomh/Gr9veM/5/xXQP5cRtiuuiR3riAiNC8X/PWK7KLOWPIUAvk
        XGpOaYpB/IgzuHYJd3T0eA4bVAXHLpUgIii24/YEydFRV7IavHcg+OP7edFuGxnvaZUsHv
        5rWIGiWD/6J6tQvhzwawa9GE5APohvg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-NxTG9kOAMS-4iwAdtPooaA-1; Wed, 01 Apr 2020 03:48:45 -0400
X-MC-Unique: NxTG9kOAMS-4iwAdtPooaA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D59E18C35A0;
        Wed,  1 Apr 2020 07:48:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E16319C6A;
        Wed,  1 Apr 2020 07:48:29 +0000 (UTC)
Date:   Wed, 1 Apr 2020 09:48:21 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v8 13/14] KVM: selftests: Let dirty_log_test async for
 dirty ring test
Message-ID: <20200401074821.2tii2x2pzungea44@kamzik.brq.redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
 <20200331190000.659614-14-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331190000.659614-14-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 02:59:59PM -0400, Peter Xu wrote:
> Previously the dirty ring test was working in synchronous way, because
> only with a vmexit (with that it was the ring full event) we'll know
> the hardware dirty bits will be flushed to the dirty ring.
> 
> With this patch we first introduced the vcpu kick mechanism by using
> SIGUSR1, meanwhile we can have a guarantee of vmexit and also the
> flushing of hardware dirty bits.  With all these, we can keep the vcpu
> dirty work asynchronous of the whole collection procedure now.  Still,
> we need to be very careful that we can only do it async if the vcpu is
> not reaching soft limit (no KVM_EXIT_DIRTY_RING_FULL).  Otherwise we
> must collect the dirty bits before continuing the vcpu.
> 
> Further increase the dirty ring size to current maximum to make sure
> we torture more on the no-ring-full case, which should be the major
> scenario when the hypervisors like QEMU would like to use this feature.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c  | 126 +++++++++++++-----
>  .../testing/selftests/kvm/include/kvm_util.h  |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   9 ++
>  3 files changed, 106 insertions(+), 30 deletions(-)
>

For the vcpu_kick and sem_wait stuff

Reviewed-by: Andrew Jones <drjones@redhat.com>

