Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E627556DDF
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 23:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbiFVVhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 17:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbiFVVhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 17:37:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E9EE3614A
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 14:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655933827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Axt2VUkACz79svdtMZMKZayRpMe+CkTeXYc5hsBMhwY=;
        b=LQRu8JyfpR4LJQuTJUqUpGt2mGMliZ88CGYv43Cc5TSMAxfHCF26A4qoP3pqs81hyzfJJz
        21ggS/zjNReIwY4HER9XaR+HHMP1igqwMm4mmhbDTNQOXVywRIx082OG6xIlsC2czWT2Qk
        WrUUpRdX5cK8dP2Y+iddjbuG4DohrZU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-p_f69ce_NxyMutphoKDDlg-1; Wed, 22 Jun 2022 17:37:05 -0400
X-MC-Unique: p_f69ce_NxyMutphoKDDlg-1
Received: by mail-io1-f70.google.com with SMTP id z137-20020a6bc98f000000b00669b0a179c7so9836479iof.6
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 14:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Axt2VUkACz79svdtMZMKZayRpMe+CkTeXYc5hsBMhwY=;
        b=kkC84lEASf+nNjXBlRwKcsBa0MQ61DQbPhFTnR9R8BplIopkseG1SGjKGuf/E0dqHZ
         hFo1z41CRl6Ych8sbndBelsmtsrb6U3ImnMxvNwuBU52SJsmTbFt0CjnFMnsec6Ey8J6
         EtUfjeTEwAyqotiMVZhGfhN04/mR1CxTMqeokUL5VVe2X7DI674CmUTNgd/Ha1W91Bug
         yN6F7GE9AveafwjaNRM6G/dj5mheW5kdqRPmkxtw7D4DHEyvDeAkY0pe+e5E3w5UJox8
         ZMW3Z94kb5jUWwE4YDT6GaMgA2qQ9RGH1+OC2emWS6nhv5re/BRPtim3OZiWdGs87sVb
         tHvQ==
X-Gm-Message-State: AJIora+sXl5nfqXQ4oNbejotWSHyWypiSnJyFp/+Tzqa+a+jZItFO3wu
        8TUQ/DVL1TZ2s9KPWkkpXRQU95h28WQ2jquCzIOIZFwHqXi1WFQKhyIueeOWoq0hUt2Pr38arMs
        qhguPnflhwXX1e0E1hisvDZiZ2N4PMT/HN/mqAGRtYOFzBNVS6CDQ06vDTjwlGQ==
X-Received: by 2002:a05:6e02:1885:b0:2d9:18c2:c5b6 with SMTP id o5-20020a056e02188500b002d918c2c5b6mr3160402ilu.201.1655933821534;
        Wed, 22 Jun 2022 14:37:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tKHnYViqxUOrsvW9fXe1CgwbG8CKvA7EufZmS7uLsZVAwWsBFk0s/qvUqeQP0pi/F5OXDiow==
X-Received: by 2002:a05:6e02:1885:b0:2d9:18c2:c5b6 with SMTP id o5-20020a056e02188500b002d918c2c5b6mr3160383ilu.201.1655933821199;
        Wed, 22 Jun 2022 14:37:01 -0700 (PDT)
Received: from localhost.localdomain (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id g7-20020a0566380c4700b00339d892cc89sm1510446jal.83.2022.06.22.14.36.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Jun 2022 14:37:00 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 0/4] kvm/mm: Allow GUP to respond to non fatal signals
Date:   Wed, 22 Jun 2022 17:36:52 -0400
Message-Id: <20220622213656.81546-1-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rfc->v1:
- Fix non-x86 build reported by syzbot
- Removing RFC tag

One issue was reported that libvirt won't be able to stop the virtual
machine using QMP command "stop" during a paused postcopy migration [1].

It won't work because "stop the VM" operation requires the hypervisor to
kick all the vcpu threads out using SIG_IPI in QEMU (which is translated to
a SIGUSR1).  However since during a paused postcopy, the vcpu threads are
hang death at handle_userfault() so there're simply not responding to the
kicks.  Further, the "stop" command will further hang the QMP channel.

The mm has facility to process generic signal (FAULT_FLAG_INTERRUPTIBLE),
however it's only used in the PF handlers only, not in GUP. Unluckily, KVM
is a heavy GUP user on guest page faults.  It means we won't be able to
interrupt a long page fault for KVM fetching guest pages with what we have
right now.

I think it's reasonable for GUP to only listen to fatal signals, as most of
the GUP users are not really ready to handle such case.  But actually KVM
is not such an user, and KVM actually has rich infrastructure to handle
even generic signals, and properly deliver the signal to the userspace.
Then the page fault can be retried in the next KVM_RUN.

This patchset added FOLL_INTERRUPTIBLE to enable FAULT_FLAG_INTERRUPTIBLE,
and let KVM be the first one to use it.

One thing to mention is that this is not allowing all KVM paths to be able
to respond to non fatal signals, but only on x86 slow page faults.  In the
future when more code is ready for handling signal interruptions, we can
explore possibility to have more gup callers using FOLL_INTERRUPTIBLE.

Tests
=====

I created a postcopy environment, pause the migration by shutting down the
network to emulate a network failure (so the handle_userfault() will stuck
for a long time), then I tried three things:

  (1) Sending QMP command "stop" to QEMU monitor,
  (2) Hitting Ctrl-C from QEMU cmdline,
  (3) GDB attach to the dest QEMU process.

Before this patchset, all three use case hang.  After the patchset, all
work just like when there's not network failure at all.

Please have a look, thanks.

[1] https://gitlab.com/qemu-project/qemu/-/issues/1052

Peter Xu (4):
  mm/gup: Add FOLL_INTERRUPTIBLE
  kvm: Merge "atomic" and "write" in __gfn_to_pfn_memslot()
  kvm: Add new pfn error KVM_PFN_ERR_INTR
  kvm/x86: Allow to respond to generic signals during slow page faults

 arch/arm64/kvm/mmu.c                   |  5 ++--
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  5 ++--
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  5 ++--
 arch/x86/kvm/mmu/mmu.c                 | 19 ++++++++----
 include/linux/kvm_host.h               | 21 ++++++++++++-
 include/linux/mm.h                     |  1 +
 mm/gup.c                               | 33 ++++++++++++++++++---
 virt/kvm/kvm_main.c                    | 41 ++++++++++++++++----------
 virt/kvm/kvm_mm.h                      |  6 ++--
 virt/kvm/pfncache.c                    |  2 +-
 10 files changed, 104 insertions(+), 34 deletions(-)

-- 
2.32.0

