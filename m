Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3723559665D
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 02:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238028AbiHQAgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 20:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiHQAgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 20:36:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5280C8D3D3
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660696578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MKdnvMx5HcsCQZcyhQgGaAskxmfq1ngWlPQ1j5mYASQ=;
        b=WhtoS3BhskiSSftZzZLi+shfqdhdGxlpx3qLMAqTFPTdYlvl+q+rb2ni/xQWP6Auuyw6AN
        7FUu72DvgTFTu5hPyeyPmpuhNAw7pzSuqb0GmtPuuxXW+bZTW2uoFguEP36GtZAIqyyPW5
        gWDbxGPc0UCReC9Kn7wDdCXHR6UF/jU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-341-A_BcdFzdPnKzrTfjLIPuUw-1; Tue, 16 Aug 2022 20:36:17 -0400
X-MC-Unique: A_BcdFzdPnKzrTfjLIPuUw-1
Received: by mail-qk1-f198.google.com with SMTP id bl27-20020a05620a1a9b00b0069994eeb30cso10461181qkb.11
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=MKdnvMx5HcsCQZcyhQgGaAskxmfq1ngWlPQ1j5mYASQ=;
        b=3PLo0j5lxiWmD3PFfF2a7PU0PhaDF81OTiHQH/hr0sFECfp1HtGppILAW9cpUDzJT/
         YBEuBokBnMLpo2IsKDrXus2WIHoNgTu+/YjRtap0LNqir1YAXRgg0u1fJzV4mX6yLdhy
         czTTO3eXigseqYGMe6f2edRJlT+1bfHIhBybqtqnqz2lxizPhaLG3dm69ukgfHdjHR2r
         lng7Qy8YL1JHjsmEdtMPveUqXTVDIN8/GxbNCWYGmuQZIN59xSQJlI40mxRnOEVUZJwX
         LqKW47UAhVPKy9jx5zXwaWqK4pwLihwUzQetMq9yxgbj0TQZsgkhkIo7OesNVwJsiVER
         zCkg==
X-Gm-Message-State: ACgBeo3ULlBnsgZdHiQtAoLq/L++eMC1xlU+0n76TAYKchUeYRSkIMrv
        QZ5QKJVAdyy60LukFHGS9KdPEw7aefRRNpnoUO6QjOFtYeHLb4PeSt/UdtU4ePBll44zybrcavE
        /Aee0vQmzpMCJ
X-Received: by 2002:a05:620a:f96:b0:6ba:e280:3adc with SMTP id b22-20020a05620a0f9600b006bae2803adcmr14702785qkn.435.1660696576693;
        Tue, 16 Aug 2022 17:36:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6f7bSIzqEEt4Tk3rqBqKencREqt2JkgzbgDmzwuRWN/rUerQ++83tyZbG75fBXqzW5bbXSTQ==
X-Received: by 2002:a05:620a:f96:b0:6ba:e280:3adc with SMTP id b22-20020a05620a0f9600b006bae2803adcmr14702770qkn.435.1660696576472;
        Tue, 16 Aug 2022 17:36:16 -0700 (PDT)
Received: from localhost.localdomain (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id c13-20020ac87dcd000000b0034358bfc3c8sm12007175qte.67.2022.08.16.17.36.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Aug 2022 17:36:16 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v3 0/3] kvm/mm: Allow GUP to respond to non fatal signals
Date:   Tue, 16 Aug 2022 20:36:11 -0400
Message-Id: <20220817003614.58900-1-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3:
- Patch 1
  - Added r-b for DavidH
  - Added support for hugetlbfs
- Patch 2 & 3
  - Comment fixes [Sean]
  - Move introduction of "interruptible" parameter into patch 2 [Sean]
  - Move sigpending handling into kvm_handle_bad_page [Sean]
  - Renamed kvm_handle_bad_page() to kvm_handle_error_pfn() [Sean, DavidM]
  - Use kvm_handle_signal_exit() [Sean]

rfc: https://lore.kernel.org/kvm/20220617014147.7299-1-peterx@redhat.com
v1:  https://lore.kernel.org/kvm/20220622213656.81546-1-peterx@redhat.com
v2:  https://lore.kernel.org/kvm/20220721000318.93522-1-peterx@redhat.com

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
and let KVM be the first one to use it.  KVM and mm/gup can always be able
to respond to fatal signals, but not non-fatal ones until this patchset.

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

Peter Xu (3):
  mm/gup: Add FOLL_INTERRUPTIBLE
  kvm: Add new pfn error KVM_PFN_ERR_SIGPENDING
  kvm/x86: Allow to respond to generic signals during slow page faults

 arch/arm64/kvm/mmu.c                   |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 18 ++++++++++----
 include/linux/kvm_host.h               | 14 +++++++++--
 include/linux/mm.h                     |  1 +
 mm/gup.c                               | 33 ++++++++++++++++++++++----
 mm/hugetlb.c                           |  5 +++-
 virt/kvm/kvm_main.c                    | 30 ++++++++++++++---------
 virt/kvm/kvm_mm.h                      |  4 ++--
 virt/kvm/pfncache.c                    |  2 +-
 11 files changed, 85 insertions(+), 28 deletions(-)

-- 
2.32.0

