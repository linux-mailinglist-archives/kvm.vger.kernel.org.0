Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E79660A9F
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbjAGANY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjAGANS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:13:18 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08977669A2
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:13:16 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpn-0047fx-AX; Sat, 07 Jan 2023 01:13:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=BppU/G60jve0VgO5NLLNJspxy/FQSkjGWbiTqWtccbQ=; b=CrXLltJXxTwQi
        eCv1qXbuoOYhHvKID5JdjX766BB21R1dADOc7qco5HRd/YsCF9Dq0PP/0vCwEzFsSd/1B6SVvg1Mu
        roWW8yIQLPKfzr6Y3xXydPWDn6JMF+3w1RSyA0Fzy1oDTN+24r9iEbrZP9F26IqXHp02iBfUKziRd
        c/30KR6yX4mjBXayv6aZ4q8yr6NdFWiMCGK/kTtoxQXsvVkjIPUkAsuynNvzsvqZvDbyvoVOhZt/X
        oCsGGV2fm18HdZj0Uwy9HP6UzfE1gQfTLAeb4G95fA7yUNdFN12sXjKEJBXJoBSPir/Q6YdWp4Srx
        xqdTRVybuPfJ8J7eFH7UA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pDwpm-0003w1-TQ; Sat, 07 Jan 2023 01:13:15 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pDwpi-0002mN-7R; Sat, 07 Jan 2023 01:13:10 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 0/6] kvm->lock vs. SRCU sync optimizations
Date:   Sat,  7 Jan 2023 01:12:50 +0100
Message-Id: <20230107001256.2365304-1-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is mostly about unlocking kvm->lock before synchronizing SRCU.
Discussed at https://lore.kernel.org/kvm/Y7dN0Negds7XUbvI@google.com/ .

I'm mentioning the fact it's an optimization (not a bugfix; at least under
the assumption that Xen does not break the lock order anymore) meant to
reduce the time spent under the mutex. Sean, would that suffice?

Along the way simplification and cleanups are smuggled.

And, by the way, what about other sync-under-lock cases such as

kvm_arch_vm_ioctl KVM_CREATE_PIT
  mutex_lock(&kvm->lock)
  kvm_create_pit()
    kvm_io_bus_register_dev()
      synchronize_srcu_expedited(&kvm->srcu)

Does this qualify for some form of refactoring?

Michal Luczaj (6):
  KVM: x86: Optimize kvm->lock and SRCU interaction
    (KVM_SET_PMU_EVENT_FILTER)
  KVM: x86: Optimize kvm->lock and SRCU interaction
    (KVM_X86_SET_MSR_FILTER)
  KVM: x86: Simplify msr_filter update
  KVM: x86: Explicitly state lockdep condition of msr_filter update
  KVM: x86: Remove unnecessary initialization in
    kvm_vm_ioctl_set_msr_filter()
  KVM: x86: Simplify msr_io()

 arch/x86/kvm/pmu.c |  3 +--
 arch/x86/kvm/x86.c | 22 +++++++---------------
 2 files changed, 8 insertions(+), 17 deletions(-)

-- 
2.39.0

