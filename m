Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05A863F86E
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 20:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiLATh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 14:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiLAThy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 14:37:54 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B7D21A4
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 11:37:52 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id n184so3168570yba.6
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 11:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nQrJ41/5H+ZnwY7xKFRy6HK29kZHfa5uFdQaYIp7nS0=;
        b=PsCBdkDDYbJ4nobaCzBFv4c2ce5i6jFZM8riMnz49MsyrC8UwZJwctPESXoDR8DxOK
         jJ8sPG60cUu84DRL54N1bj6gyJn+qRrhI0RSnMyQL0pyWB+pKBqIcAuAjm2Ebt8uWFul
         fFHWpp3Tay0MlAe9m7hxYKW3G0UudE9cx0MXVoJvL0wGiKMl+JatYIw+ATDri3Mjl+fN
         MlEOK3qbh2a0dYJBui4up9qCMx82TnwzpA+Y303mJbMhyfhBhwdne9oOyPHADLEGwaj8
         aBHA6Kbg1vmNU5pcpA4pTmYAj2oP73kpRhkvT+0/xqrjf85frizC4zApoHbPlKUKSM5U
         /eyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nQrJ41/5H+ZnwY7xKFRy6HK29kZHfa5uFdQaYIp7nS0=;
        b=mpE98PSEiCgKI2IslbWZPhhtIWbofbWRJUC6Yfe5f/MApPum/HG352Xf/KO2Myjv7+
         VCIdanjKKF9GwU9EX4dGYoAypZzFSrN8t6Angb3U6tlHZuYsY0/VkHOGoTk645pZdamc
         i520yV5Yt0fc4pdGD18LiJdft18ouyUInHjeN31LM7BTarxaAGygyqZRCdIi/9UizJjC
         1W4xDRqMLZGqRRqbGHx/6hhmxgwFwuYAeHw8aD6kiuVDMnJj+Uxec38giiNC0OIIceYY
         f6pxifJrLH+MHcBja1yfqvqItzlL6Id/fRRYpBTOho108tWWZ781KraxthbadlA9xCF2
         BU6Q==
X-Gm-Message-State: ANoB5plisq/l5YMRwGISVL/4pHFuMpTZbufENTfuzp72CMy0OL3mctUo
        0QW0PvT9tYt3Bw+5jbOOYYQipA6N/VDoqGdDZgCWYOIqEa/sksOM
X-Google-Smtp-Source: AA0mqf5w/PMpSCxvHYSLM7SGdw/f4JGOdn60YVkkeaznPSqAc9aAFrj3LgJcS1SoOlz+SorOJs+9AxsHNk48OaKQPI8=
X-Received: by 2002:a25:add1:0:b0:6f6:366c:f47c with SMTP id
 d17-20020a25add1000000b006f6366cf47cmr22098086ybe.19.1669923471925; Thu, 01
 Dec 2022 11:37:51 -0800 (PST)
MIME-Version: 1.0
From:   James Houghton <jthoughton@google.com>
Date:   Thu, 1 Dec 2022 14:37:41 -0500
Message-ID: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
Subject: [RFC] Improving userfaultfd scalability for live migration
To:     Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One of the main challenges of using userfaultfd is its performance. I
have some ideas for how userfaultfd could be made scalable for
post-copy live migration. I'm not sending a series for now; I want to
make sure the general approach here is something upstream would be
interested in.

== Background ==
The main scalability bottleneck comes from queueing faults with
userfaultfd (i.e., interacting with fault_wqh/fault_pending_wqh).
Doing so requires us to take those wait_queues' locks exclusively. I
think we have these options to deal with this:

1. Avoid queueing faults (if possible)
2. Reduce contention (have lots of VMAs, 1 userfaultfd per VMA)
3. Allow multiple userfaultfds on a VMA.
4. Remove contention in the wait_queues (i.e., implement a "lockless
wait_queue", whatever that might be).

#2 can help a little bit, but we have two problems: we don't want TONS
of VMAs, and it doesn't help the case where we have lots of faults on
the same VMA. #3 could be possible, but it would be complicated and
wouldn't completely fix the problem. #4, which I doubt is even
feasible, would introduce a lot of complexity.

#1, however, is quite doable. The main codepath for post-copy, the
path that is taken when a vCPU attempts to access unmapped memory, is
(for x86, but similar for other architectures): handle_ept_violation
-> hva_to_pfn -> GUP -> handle_userfault. I'll call this the "EPT
violation path" or "mem fault path." Other post-copy paths include at
least: (i) KVM attempts to access guest memory via.
copy_{to,from}_user -> #pf -> handle_mm_fault -> handle_userfault, and
(ii) other callers of gfn_to_pfn* or hva_to_pfn* outside of the EPT
violation path (e.g., instruction emulation).

We want the EPT violation path to be fast, as it is taken the vast
majority of the time. Note that this case is run by the vCPU thread
itself / the thread that called KVM_RUN, and, if GUP "fails", in most
cases KVM_RUN will exit with -EFAULT. We can use this to our
advantage.

If we can get KVM_RUN to exit with information about which page we
need to fetch, we can do post-copy, and we never have to queue a page
fault with userfaultfd!

== Getting the faulting GPA to userspace ==
KVM_EXIT_MEMORY_FAULT was introduced recently [1] (not yet merged),
and it provides the main functionality we need. We can extend it
easily to support our use case here, and I think we have at least two
options:
- Introduce something like KVM_CAP_MEM_FAULT_REPORTING, which causes
KVM_RUN to exit with exit reason KVM_EXIT_MEMORY_FAULT when it would
otherwise just return -EFAULT (i.e., when kvm_handle_bad_page returns
-EFAULT).
- We're already introducing a new CAP, so just tie the above behavior
to whether or not one of the CAPs (below) is being used.

== Potential Solutions ==
We need the solution to handle both the EPT violation case and other
cases properly. Today, we can easily handle the EPT violation case if
we just use UFFD_FEATURE_SIGBUS, but that doesn't fix the other cases
(e.g. instruction emulation might fail, and we won't know what to do
to resolve it).

In both of the following solutions, hva_to_pfn needs to know if the
caller is the EPT violation/mem fault path. To do that, we'll probably
need to add a parameter to __gfn_to_pfn_memslot, gfn_to_pfn_prot, and
maybe some other functions. I'm not sure what the cleanest way to do
this is. It's possible that the new parameter here could be more
general than "if we came from a mem fault": whether the caller wants
GUP to fail quickly or not.

Now that hva_to_pfn knows if it is being called from memfault, we can
talk about how we can make it fail quickly in the userfaultfd case.

-- Introduce KVM_CAP_USERFAULT_NOWAIT
In hva_to_pfn_slow, if we came from a mem_fault, we can include a new
flag in our call to GUP: FOLL_USERFAULT_NOWAIT. Then, in GUP, it can
pass a new fault flag if it must call into a page fault routine:
FAULT_USERFAULT_NOWAIT. That will make its way to handle_userfault(),
and we can exit quickly (say, with VM_FAULT_SIGBUS, but any
VM_FAULT_ERROR would do).

Userspace can then take appropriate action: if they registered for
MISSING faults, we can UFFDIO_COPY and, if they registered for MINOR
faults, we can UFFDIO_CONTINUE. However, userspace no longer knows
which kind of fault it was if they registered for both kinds. I don't
see this as a problem.

-- Introduce KVM_CAP_MEM_FAULT_NOWAIT
In KVM, if this CAP is specified, never call hva_to_pfn_slow from the
mem fault path, and always return KVM_PFN_ERR_FAULT if fast GUP fails.
Fast GUP can fail for all sorts of reasons, so the actions userspace
can take to resolve these are more complicated:
1) If userspace knows that we never UFFDIO_COPY'd or UFFDIO_CONTINUE'd
the page, we can do that now and restart the vCPU.
2) If userspace has previously UFFDIO_COPY/CONTINUE'd, we need to get
the kernel to make the page ready again. We could read from the
faulting address, but that might set up a read-only mapping, so
instead, we can use MADV_POPULATE_WRITE to set up a RW mapping, and
fast GUP should succeed.

If MADV_POPULATE_WRITE races with a different thread that is
UFFDIO_COPY/CONTINUEing the same page and happens to win, it will drop
into handle_userfault and be woken up with a UFFDIO_WAKE later via the
same path that handles the non-mem-fault case.

This solution might seem bizarre, but it makes it so that the mem
fault path never needs to grab the mmap lock for reading. (We still
have to grab it for reading in UFFDIO_COPY/CONTINUE.)

== Problems ==
The major problem here is that this only solves the scalability
problem for the KVM demand paging case. Other userfaultfd users, if
they have scalability problems, will need to find another approach.

- James Houghton

[1]: https://lore.kernel.org/all/20221025151344.3784230-4-chao.p.peng@linux.intel.com/
