Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6673057C145
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 02:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiGUAD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 20:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiGUADY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 20:03:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A4A9743FB
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658361802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0HOOHkAh3MZpUMeUIVAREqDy3wbpVTpA7LvIV0AcxA0=;
        b=BIoRVQsjx3OYlE/wF7hBGVvUbC8XnhTzPQ3LDtP/yqreRVnzoQiqVkoYRDArJBlGmDtq9M
        D29ESBGVzprwJe1Ep1uIC/e7LxtnLryY/jSVcZHV2WMrTafNmwI/6/1DDuCdMcIg37k3F5
        SV1vUmLM+7zEfh7mRgD4ACma+Jiqjfg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-09DWnR83MIi5ZMbumEO0qQ-1; Wed, 20 Jul 2022 20:03:21 -0400
X-MC-Unique: 09DWnR83MIi5ZMbumEO0qQ-1
Received: by mail-qk1-f200.google.com with SMTP id i15-20020a05620a404f00b006b55998179bso237041qko.4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0HOOHkAh3MZpUMeUIVAREqDy3wbpVTpA7LvIV0AcxA0=;
        b=HdwIDXrtFbn5TyLk/VeSZYNLPue+RaE9R6EfmVoS7AsiA23uDeFvV0sKuivhqC11PT
         R4l9fBxmiD9VZDSL75Lu59TiYyLv9/w2z/crY6bzusY986eSJ6uY6P//MUZzuKrW+G0I
         PJeacfvtkJQcvnBLsVMCuAmJ2G3p55GBRFkIaRr/rFIe4ENq92LaJzl5GJ73mMbipU4t
         dq/Cy6eICE94ZpS1QF+uVxzYcQRdlai5FV0vA21cIvCdo+HoO3kKQDCxb8WKZ1iASOj/
         O0k/6TwrvzfEHjFkVemalwqnBOAxELCpp/i1IJrDhfDQEjl94TOrAytRHee92/6RjNuz
         5/mQ==
X-Gm-Message-State: AJIora810K/w4NtjdY6qhHg/4ucSJlzv5OMc/dZwCZOB767XdPiYkgay
        ZlomdM0aCZm3vOa+R0l59V9FepEnUPYRPk3gGJyteB0nCjFVe6M47ECHS6kATlmYQYjhNbzoy7C
        8vsq6JIAPh7wj
X-Received: by 2002:a05:6214:194b:b0:474:69c:c21a with SMTP id q11-20020a056214194b00b00474069cc21amr3792542qvk.25.1658361800668;
        Wed, 20 Jul 2022 17:03:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1td9GAJoudrL5DhtFUEXZ0vWM5eEgh/b3Z8hNa2qWsTt+tRvoCnZ7VlRAHlZ06k2CHi33a+3g==
X-Received: by 2002:a05:6214:194b:b0:474:69c:c21a with SMTP id q11-20020a056214194b00b00474069cc21amr3792502qvk.25.1658361800353;
        Wed, 20 Jul 2022 17:03:20 -0700 (PDT)
Received: from localhost.localdomain (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id g4-20020ac87f44000000b0031eb3af3ffesm418640qtk.52.2022.07.20.17.03.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 20 Jul 2022 17:03:19 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        John Hubbard <jhubbard@nvidia.com>,
        Sean Christopherson <seanjc@google.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v2 0/3] kvm/mm: Allow GUP to respond to non fatal signals
Date:   Wed, 20 Jul 2022 20:03:15 -0400
Message-Id: <20220721000318.93522-1-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- Added r-b
- Rewrite the comment in faultin_page() for FOLL_INTERRUPTIBLE [John]
- Dropped the controversial patch to introduce a flag for
  __gfn_to_pfn_memslot(), instead used a boolean for now [Sean]
- Rename s/is_sigpending_pfn/KVM_PFN_ERR_SIGPENDING/ [Sean]
- Change comment in kvm_faultin_pfn() mentioning fatal signals [Sean]

rfc: https://lore.kernel.org/kvm/20220617014147.7299-1-peterx@redhat.com
v1:  https://lore.kernel.org/kvm/20220622213656.81546-1-peterx@redhat.com

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
 arch/x86/kvm/mmu/mmu.c                 | 16 +++++++++++--
 include/linux/kvm_host.h               | 15 ++++++++++--
 include/linux/mm.h                     |  1 +
 mm/gup.c                               | 33 ++++++++++++++++++++++----
 virt/kvm/kvm_main.c                    | 30 ++++++++++++++---------
 virt/kvm/kvm_mm.h                      |  4 ++--
 virt/kvm/pfncache.c                    |  2 +-
 10 files changed, 82 insertions(+), 25 deletions(-)

-- 
2.32.0

