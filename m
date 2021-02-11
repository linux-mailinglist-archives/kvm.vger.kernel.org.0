Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F83318A04
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 13:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhBKMCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 07:02:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230028AbhBKMA3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 07:00:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613044733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PBbv8Ik3MJk5Ifs8Y2ot0HB2Ai76el9x4Ro3xXxLdLQ=;
        b=WCDVGEkl4ey/djGFjCxPqYe8uvfbQf9CPA3HcVXVlOR/SqceC00VlAy+4bzlwwZReJkC0z
        Pfg5ehARAzTyCg67vx7jBYC6J8n9WVBweXL+z6BIDKj4nPTgqZjnXZH0N9Y+/Kr1mya74d
        xTDm4NjdlHbuNwDBCdYSVbQ2EPfSsXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-gBhHTZsqOq6Dw3-MLmTWMA-1; Thu, 11 Feb 2021 06:58:52 -0500
X-MC-Unique: gBhHTZsqOq6Dw3-MLmTWMA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CAB080196C;
        Thu, 11 Feb 2021 11:58:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9DEA5D74A;
        Thu, 11 Feb 2021 11:58:43 +0000 (UTC)
Date:   Thu, 11 Feb 2021 12:58:41 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 00/15] VM: selftests: Hugepage fixes and cleanups
Message-ID: <20210211115841.sbs2a3p7xx4womrc@kamzik.brq.redhat.com>
References: <20210210230625.550939-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 03:06:10PM -0800, Sean Christopherson wrote:
> Fix hugepage bugs in the KVM selftests that specifically affect dirty
> logging and demand paging tests.  Found while attempting to verify KVM
> changes/fixes related to hugepages and dirty logging (patches incoming in
> a separate series).
> 
> Clean up the perf_test_args util on top of the hugepage fixes to clarify
> what "page size" means, and to improve confidence in the code doing what
> it thinks it's doing.  In a few cases, users of perf_test_args were
> duplicating (approximating?) calculations made by perf_test_args, and it
> wasn't obvious that both pieces of code were guaranteed to end up with the
> same result.
> 
> Sean Christopherson (15):
>   KVM: selftests: Explicitly state indicies for vm_guest_mode_params
>     array
>   KVM: selftests: Expose align() helpers to tests
>   KVM: selftests: Align HVA for HugeTLB-backed memslots
>   KVM: selftests: Force stronger HVA alignment (1gb) for hugepages
>   KVM: selftests: Require GPA to be aligned when backed by hugepages
>   KVM: selftests: Use shorthand local var to access struct
>     perf_tests_args
>   KVM: selftests: Capture per-vCPU GPA in perf_test_vcpu_args
>   KVM: selftests: Use perf util's per-vCPU GPA/pages in demand paging
>     test
>   KVM: selftests: Move per-VM GPA into perf_test_args
>   KVM: selftests: Remove perf_test_args.host_page_size
>   KVM: selftests: Create VM with adjusted number of guest pages for perf
>     tests
>   KVM: selftests: Fill per-vCPU struct during "perf_test" VM creation
>   KVM: selftests: Sync perf_test_args to guest during VM creation
>   KVM: selftests: Track size of per-VM memslot in perf_test_args
>   KVM: selftests: Get rid of gorilla math in memslots modification test
> 
>  .../selftests/kvm/demand_paging_test.c        |  39 ++---
>  .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |  28 ++++
>  .../selftests/kvm/include/perf_test_util.h    |  18 +--
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  36 ++---
>  .../selftests/kvm/lib/perf_test_util.c        | 139 ++++++++++--------
>  .../kvm/memslot_modification_stress_test.c    |  16 +-
>  7 files changed, 145 insertions(+), 141 deletions(-)
> 
> -- 
> 2.30.0.478.g8a0d178c01-goog
>

For the series

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

