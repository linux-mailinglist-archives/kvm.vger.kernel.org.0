Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEFE453005
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 12:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhKPLQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 06:16:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234581AbhKPLQO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 06:16:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637061197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PeYaxWhimdAWkZqhdeGfXVpHiWJZ51/LaoIUZd1Whuk=;
        b=eb2zQ7EUmMSB+rLlkLKkiLMnXjT1TkhlApMyU3aybmvGJxPvzC5F+Shu2+ZwSnxS10ib0x
        vMkZzQJZLeRCBXrfSrWNJjCzk4vmowu6i3fQd/vwInOow7f84HedTJIlsFMbF+4dFYfego
        W+MoxpkRQR9Oan/PBMSh3HXOE/3GK5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-cQM6E1btN9OJrP6L0QFbGg-1; Tue, 16 Nov 2021 06:13:13 -0500
X-MC-Unique: cQM6E1btN9OJrP6L0QFbGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AFA48799EB;
        Tue, 16 Nov 2021 11:13:12 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC8FA60C13;
        Tue, 16 Nov 2021 11:12:47 +0000 (UTC)
Message-ID: <c964f098-7632-7ab2-b407-f946e988a9f2@redhat.com>
Date:   Tue, 16 Nov 2021 12:12:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 00/12] KVM: selftests: Hugepage fixes and cleanups
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
References: <20211111000310.1435032-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/21 01:02, David Matlack wrote:
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

Queued, thanks.

Paolo

> v2:
> - Add separate align up/down helpers and use the throughout the series
>    rather than openly coding the bitwise math [Ben, Paolo]
> - Do no pad HugeTLB mmaps [Yanan]
> - Drop "[PATCH 04/15] KVM: selftests: Force stronger HVA alignment (1gb)
>    for hugepages" since HugeTLB does not require manual HVA alignment
>    [David]
> - Drop "[PATCH 15/15] KVM: selftests: Get rid of gorilla math in memslots
>    modification test" since the gorilla math no longer exists [David]
> - Drop "[PATCH 14/15] KVM: selftests: Track size of per-VM memslot in
>    perf_test_args" since it was just a prep patch for [PATCH 15/15]
>    [David]
> - Update the series to kvm/next [David]
> 
> v1: https://lore.kernel.org/kvm/20210210230625.550939-1-seanjc@google.com/.
> 
> Sean Christopherson (12):
>    KVM: selftests: Explicitly state indicies for vm_guest_mode_params
>      array
>    KVM: selftests: Expose align() helpers to tests
>    KVM: selftests: Assert mmap HVA is aligned when using HugeTLB
>    KVM: selftests: Require GPA to be aligned when backed by hugepages
>    KVM: selftests: Use shorthand local var to access struct
>      perf_tests_args
>    KVM: selftests: Capture per-vCPU GPA in perf_test_vcpu_args
>    KVM: selftests: Use perf util's per-vCPU GPA/pages in demand paging
>      test
>    KVM: selftests: Move per-VM GPA into perf_test_args
>    KVM: selftests: Remove perf_test_args.host_page_size
>    KVM: selftests: Create VM with adjusted number of guest pages for perf
>      tests
>    KVM: selftests: Fill per-vCPU struct during "perf_test" VM creation
>    KVM: selftests: Sync perf_test_args to guest during VM creation
> 
>   .../selftests/kvm/access_tracking_perf_test.c |   8 +-
>   .../selftests/kvm/demand_paging_test.c        |  31 +----
>   .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
>   tools/testing/selftests/kvm/dirty_log_test.c  |   6 +-
>   .../selftests/kvm/include/perf_test_util.h    |  18 +--
>   .../testing/selftests/kvm/include/test_util.h |  26 ++++
>   .../selftests/kvm/kvm_page_table_test.c       |   2 +-
>   tools/testing/selftests/kvm/lib/elf.c         |   3 +-
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  44 +++---
>   .../selftests/kvm/lib/perf_test_util.c        | 126 ++++++++++--------
>   tools/testing/selftests/kvm/lib/test_util.c   |   5 +
>   .../kvm/memslot_modification_stress_test.c    |  13 +-
>   12 files changed, 153 insertions(+), 139 deletions(-)
> 

