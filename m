Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24592453008
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 12:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhKPLQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 06:16:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234727AbhKPLQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 06:16:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637061237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mtoNUUPQtOcmGJ1fXa5aSQpzCiJ+yZmcVPTyDaFeIFs=;
        b=XGodoP8Fj5jzQw8veeNGmCI4+eKgillb69Th/oWhkiJKEuGxAO+qUAqV03iq1FK2XwzOuI
        OmoFp+pCoglxONMhXp8hHfPsWT5zKkR47IezTJvPPezcHlpLmoRX4tAuhW6bPKe6Ji+6al
        QvO1tSO+q9nojX6kmlUS9CqSGojqdy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-KQTdo3skPeC9YkOox4_wWw-1; Tue, 16 Nov 2021 06:13:54 -0500
X-MC-Unique: KQTdo3skPeC9YkOox4_wWw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED4CB10144E8;
        Tue, 16 Nov 2021 11:13:52 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEFC219723;
        Tue, 16 Nov 2021 11:13:45 +0000 (UTC)
Message-ID: <eb6fff8c-9548-6f51-bf80-88d4f164f4d6@redhat.com>
Date:   Tue, 16 Nov 2021 12:13:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/4] KVM: selftests: Avoid mmap_sem contention during
 memory population
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
References: <20211111001257.1446428-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211111001257.1446428-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/21 01:12, David Matlack wrote:
> This series fixes a performance issue in the KVM selftests, specifically
> those that use perf_test_util. These tests create vCPU threads which
> immediately enter guest mode and start faulting in memory. Creating
> vCPU threads while faulting in memory is a recipe for generating a lot
> of contention on the mmap_sem, as thread creation requires acquiring the
> mmap_sem in write mode.
> 
> This series fixes this issue by ensuring that all vCPUs threads are
> created before entering guest mode. As part of fixing this issue I
> consolidated the code to create and join vCPU threads across all users
> of perf_test_util.
> 
> The last commit is an unrelated perf_test_util cleanup.
> 
> Note: This series applies on top of
> https://lore.kernel.org/kvm/20211111000310.1435032-1-dmatlack@google.com/,
> although the dependency on the series is just cosmetic.
> 
> David Matlack (4):
>    KVM: selftests: Start at iteration 0 instead of -1
>    KVM: selftests: Move vCPU thread creation and joining to common
>      helpers
>    KVM: selftests: Wait for all vCPU to be created before entering guest
>      mode
>    KVM: selftests: Use perf_test_destroy_vm in
>      memslot_modification_stress_test
> 
>   .../selftests/kvm/access_tracking_perf_test.c | 46 +++---------
>   .../selftests/kvm/demand_paging_test.c        | 25 +------
>   .../selftests/kvm/dirty_log_perf_test.c       | 19 ++---
>   .../selftests/kvm/include/perf_test_util.h    |  5 ++
>   .../selftests/kvm/lib/perf_test_util.c        | 72 +++++++++++++++++++
>   .../kvm/memslot_modification_stress_test.c    | 25 ++-----
>   6 files changed, 96 insertions(+), 96 deletions(-)
> 

Queued, thanks.

Paolo

