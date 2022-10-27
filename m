Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7179A61024F
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 22:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbiJ0UD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 16:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbiJ0UDY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 16:03:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152D0564E1
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:03:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e8-20020a5b0cc8000000b006bca0fa3ab6so2532734ybr.0
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n9RxM3OVpi/ByTNxMLI8qeKFt7yoTDR7gL0eNW24Xok=;
        b=kdhbUK3XhnLPxM3H9UoNDZMbWYtP0l8gDIdQBIZHiE0u22m9pi6QAWInnjrSr2sY4D
         KbfxwdEi990AI10mlyCb/g0OuqnSkfV1k46wH1lUp9TS2SeqWmDDvbNfBRGnLSkehyF8
         jR5IaKLc3QBLSqCPdy9oQStVGczC/S4qVrU976Jz8cjwFT1yRtY+2D92lO9TbSVZ25By
         zqSyirZDUcX1iqxPL0xqxzeW26OFVipsqdShdjEKgwpAXwDJyxc6voIjSbQLf2ajacst
         TSnAX1/AASrR9qKc0QoyN/YgMZHH4ur4kAbPpTPdEyxc9qQbOYWVAoFvOpM8uJiy9miJ
         tjgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n9RxM3OVpi/ByTNxMLI8qeKFt7yoTDR7gL0eNW24Xok=;
        b=iPhch4sH/AvU4s5BTZvJ14ia3czCVx1pJJ4z2g1HqXevkluIaPk7e6xpkd1RDsdtl8
         DFtN1WRxvLsp6HU42+l9COU7aUGL9OCP4AXNhnY4osI00TF2WLJMCel/1Oasx+B9Mb5A
         F+4atf7PfNaUSy6M4Je9c/JpQGzxgLVKYYMkL/oydSBn2qJ9E6dTs17MDCwt+/3VctRF
         KslwJOsVdanQm/vDYNinD0LfZ5NwMPCJ7Cc3GjfJAq4ADLNjp1hM7VknYlM+rYDq8Ma1
         IRp56GRgnOPU54RCKKYOQf1D/YZc3++xJxdj06cjRM4FnJL1I81/UuzvLISWm3Xfy6Af
         s4FA==
X-Gm-Message-State: ACrzQf1C0br1e6+3i/8xtpq69WvuFwa7b6G/AfXje8zsup3SWlB7ct3j
        sgeBYkWu3SzhMUfFlGwN4xNrGnPYad/pvA==
X-Google-Smtp-Source: AMsMyM4yr8gYnjoQbZGzdT7J6TrlD9ZWLogWS+ibDuh5NT2ys9uVryrpNFQZ++p8yUx0bHqY7aayIwfu0qr9Xg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:319:b0:329:88ec:ba20 with SMTP
 id bg25-20020a05690c031900b0032988ecba20mr3ywb.492.1666901001132; Thu, 27 Oct
 2022 13:03:21 -0700 (PDT)
Date:   Thu, 27 Oct 2022 13:03:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221027200316.2221027-1-dmatlack@google.com>
Subject: [PATCH 0/2] KVM: x86/mmu: Do not recover NX Huge Pages when dirty
 logging is enabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series turns off the NX Huge Page recovery worker when any memslot
has dirty logging enabled. This avoids theoretical performance problems
and reduces the CPU usage of NX Huge Pages when a VM is in the pre-copy
phase of a Live Migration.

Tested manually and ran all selftests.

David Matlack (2):
  KVM: Keep track of the number of memslots with dirty logging enabled
  KVM: x86/mmu: Do not recover NX Huge Pages when dirty logging is
    enabled

 arch/x86/kvm/mmu/mmu.c   |  8 ++++++++
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 10 ++++++++++
 3 files changed, 20 insertions(+)


base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 
2.38.1.273.g43a17bfeac-goog

