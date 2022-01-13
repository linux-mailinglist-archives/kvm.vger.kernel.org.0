Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C6F48D243
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 07:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiAMGM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 01:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiAMGMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 01:12:25 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB233C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 22:12:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso17362084pje.0
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 22:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ts8RgrIvYlUyMkKlBFR0Ft0sqT+vD7UXNC3L+87myZY=;
        b=P0K9rW4/Aw3etpwJ5+F/WEEAIoXaJIDCfzGGfnJ1emVyNRH1I6qqhVk0D285sTW6bJ
         8U5BFJAT9ycdC/wEKdQQMCC7QXIyrTpjp3XQOWm3Xvg9z/1SXef0QNuY6XQofKfatOCG
         TZRFaGIdF+tUjuLT7Q0I/lUoZPKomQYojo7+kHObvp9r5tma4p4kB8wNYqJXrrYYvEMb
         2K6lTTYk7PJumcLrEzdWBVTj0vWYKvIQtYkcOdb+AI3yjwvpJKmy8dgbU98YoLjvFmTl
         h4rD1aO9eaCxKyKnZmz+866E66RpKyzvtTPghNt5rm1K+T4oRp3+p3ux0g8hdD8RdXut
         TUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ts8RgrIvYlUyMkKlBFR0Ft0sqT+vD7UXNC3L+87myZY=;
        b=WmojrWVUXroE0udh02FD4/btJYv/VqAQheuGBIKQrGToYQlm/GatW7h5Vl3hb63LKU
         VJ7NEaqATYz4sze8I/n4UYwlA/jke5m+/Lj8SjAcm/28TANL5CjeTF5iDY1FphLqhLLM
         Ug9gJtVR3RjbHUZf0O+uT4WYtqerukvxv5qnljUqH36SCH+ELLnwxNdKS5prUEMkao5l
         srC72k1dIZGuBvORpCblc0WVkmB7frX0ibH1TPNvNKopjYtbocqaLBeCPmxhX7uf+QX4
         drZHeO3Y/zLHHOO0x1ZFprkgygihpErqLZufAXb5/Q7tETV7jQR/W2+rF2zekYwYACl3
         1OSg==
X-Gm-Message-State: AOAM531EGJwdBxABxo8hANSL33xy3hA8aYK76MmfecfkcpRbbnGIF7pb
        0iyMUgxT3iJxN6r9Z9ZoFyXonQ==
X-Google-Smtp-Source: ABdhPJwBmxVJaaKyVTUhtBy2c9tOZg+9WMPmADe4DCEKJmhoY/VUIGr5zDc+0NurF6gPP8ev8vWtgQ==
X-Received: by 2002:a17:90b:33cd:: with SMTP id lk13mr12790344pjb.35.1642054344988;
        Wed, 12 Jan 2022 22:12:24 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id c19sm1448592pfo.91.2022.01.12.22.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 22:12:24 -0800 (PST)
Date:   Wed, 12 Jan 2022 22:12:20 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH 0/3] ARM64: Guest performance improvement during dirty
Message-ID: <Yd/CxKuA04I9k5W1@google.com>
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <Yd+TV4Bkhzpnpx8N@google.com>
 <CAAdAUtgk7y6WA4YO96ZTX6ZUPPzfLtJWnToBVPHtLG89vJ-y2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdAUtgk7y6WA4YO96ZTX6ZUPPzfLtJWnToBVPHtLG89vJ-y2g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 07:50:48PM -0800, Jing Zhang wrote:
> On Wed, Jan 12, 2022 at 6:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Hi Jing,
> >
> > On Mon, Jan 10, 2022 at 09:04:38PM +0000, Jing Zhang wrote:
> > > This patch is to reduce the performance degradation of guest workload during
> > > dirty logging on ARM64. A fast path is added to handle permission relaxation
> > > during dirty logging. The MMU lock is replaced with rwlock, by which all
> > > permision relaxations on leaf pte can be performed under the read lock. This
> > > greatly reduces the MMU lock contention during dirty logging. With this
> > > solution, the source guest workload performance degradation can be improved
> > > by more than 60%.
> > >
> > > Problem:
> > >   * A Google internal live migration test shows that the source guest workload
> > >   performance has >99% degradation for about 105 seconds, >50% degradation
> > >   for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
> > >   This shows that most of the time, the guest workload degradtion is above
> > >   99%, which obviously needs some improvement compared to the test result
> > >   on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
> > >   * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB
> > >   * VM spec: #vCPU: 48, #Mem/vCPU: 4GB
> > >
> > > Analysis:
> > >   * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
> > >     the number of contentions of MMU lock and the "dirty memory time" on
> > >     various VM spec.
> > >     By using test command
> > >     ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
> > >     Below are the results:
> > >     +-------+------------------------+-----------------------+
> > >     | #vCPU | dirty memory time (ms) | number of contentions |
> > >     +-------+------------------------+-----------------------+
> > >     | 1     | 926                    | 0                     |
> > >     +-------+------------------------+-----------------------+
> > >     | 2     | 1189                   | 4732558               |
> > >     +-------+------------------------+-----------------------+
> > >     | 4     | 2503                   | 11527185              |
> > >     +-------+------------------------+-----------------------+
> > >     | 8     | 5069                   | 24881677              |
> > >     +-------+------------------------+-----------------------+
> > >     | 16    | 10340                  | 50347956              |
> > >     +-------+------------------------+-----------------------+
> > >     | 32    | 20351                  | 100605720             |
> > >     +-------+------------------------+-----------------------+
> > >     | 64    | 40994                  | 201442478             |
> > >     +-------+------------------------+-----------------------+
> > >
> > >   * From the test results above, the "dirty memory time" and the number of
> > >     MMU lock contention scale with the number of vCPUs. That means all the
> > >     dirty memory operations from all vCPU threads have been serialized by
> > >     the MMU lock. Further analysis also shows that the permission relaxation
> > >     during dirty logging is where vCPU threads get serialized.
> > >
> > > Solution:
> > >   * On ARM64, there is no mechanism as PML (Page Modification Logging) and
> > >     the dirty-bit solution for dirty logging is much complicated compared to
> > >     the write-protection solution. The straight way to reduce the guest
> > >     performance degradation is to enhance the concurrency for the permission
> > >     fault path during dirty logging.
> > >   * In this patch, we only put leaf PTE permission relaxation for dirty
> > >     logging under read lock, all others would go under write lock.
> > >     Below are the results based on the solution:
> > >     +-------+------------------------+
> > >     | #vCPU | dirty memory time (ms) |
> > >     +-------+------------------------+
> > >     | 1     | 803                    |
> > >     +-------+------------------------+
> > >     | 2     | 843                    |
> > >     +-------+------------------------+
> > >     | 4     | 942                    |
> > >     +-------+------------------------+
> > >     | 8     | 1458                   |
> > >     +-------+------------------------+
> > >     | 16    | 2853                   |
> > >     +-------+------------------------+
> > >     | 32    | 5886                   |
> > >     +-------+------------------------+
> > >     | 64    | 12190                  |
> > >     +-------+------------------------+
> >
> > Just curious, do yo know why is time still doubling (roughly) with the
> > number of cpus? maybe you performed another experiment or have some
> > guess(es).
> Yes. it is from the serialization caused by TLB flush whenever the
> permission is relaxed. I tried test by removing the TLB flushes (of
> course it shouldn't be removed), the time would be close to a constant
> no matter the number of vCPUs.

Got it, thanks for the info.

Ricardo

> >
> > Thanks,
> > Ricardo
> >
> > >     All "dirty memory time" have been reduced by more than 60% when the
> > >     number of vCPU grows.
> > >
> > > ---
> > >
> > > Jing Zhang (3):
> > >   KVM: arm64: Use read/write spin lock for MMU protection
> > >   KVM: arm64: Add fast path to handle permission relaxation during dirty
> > >     logging
> > >   KVM: selftests: Add vgic initialization for dirty log perf test for
> > >     ARM
> > >
> > >  arch/arm64/include/asm/kvm_host.h             |  2 +
> > >  arch/arm64/kvm/mmu.c                          | 86 +++++++++++++++----
> > >  .../selftests/kvm/dirty_log_perf_test.c       | 10 +++
> > >  3 files changed, 80 insertions(+), 18 deletions(-)
> > >
> > >
> > > base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
> > > --
> > > 2.34.1.575.g55b058a8bb-goog
> > >
> > > _______________________________________________
> > > kvmarm mailing list
> > > kvmarm@lists.cs.columbia.edu
> > > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> Thanks,
> Jing
