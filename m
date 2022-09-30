Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE45A5F1218
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 21:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiI3TIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 15:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiI3TIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 15:08:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F991D7BC0
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 12:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664564914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2ho5HUk/k6PdSH+MVcpkSJ4cYO9ebBSiHEKpSKcMZVA=;
        b=CKd5MNNotUxgOwV3a6ePfzJbNNP87f61uXq1PeDqfxpJkhP+Eid9oPPJsR13S4iY5MHpKf
        ISA6fkUsL8B6stbtJpCtSD07meNNz8FO1MvdR3W/HyYHUGGwH9O0on9T2fWW+5a9z1j3xu
        ZvkXGFD0zBfVpmLmm/xcRHNQwx5CzSc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-QhyEaTq4ObSICYmSQryaqQ-1; Fri, 30 Sep 2022 15:08:33 -0400
X-MC-Unique: QhyEaTq4ObSICYmSQryaqQ-1
Received: by mail-ed1-f72.google.com with SMTP id t13-20020a056402524d00b00452c6289448so4193458edd.17
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 12:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=2ho5HUk/k6PdSH+MVcpkSJ4cYO9ebBSiHEKpSKcMZVA=;
        b=mXJ2H8lnHkJWkODEOhE/PISkkUhEjB7u4U2GlbIejoQ0MAUwNEfhBizFaPdoPW38M5
         1gJyIjfU0xQaOzo8AGkqodyfISijM7EoVZlmomn3tTO9/Jz5XjYwU0O0fVO6GS0TEDt0
         AdZJ1kdr/2bz9fMW6L0G6KXRbI0imCZuCWP2MZ+lOlJPKM5Qas1cY6TSWBi68dl2QBmT
         Qzfxnp0pRQUmvpJgxynpon0bBVBJ1yoEh4Zqz3Pyl2Ofag78pOnI+x04cZOq1/FlowpI
         t4jpTlHxfIBH06pohdI2TuVHxQKAsdUF/rE5vrxuFKGc2EK6J0LTThQivDqGu1aoJ4oi
         jgJQ==
X-Gm-Message-State: ACrzQf2B50MHZyZzTssb2MP4WkMqx3N4Vf6RCXsnCMJ+coLKofisdHau
        ux/ZNKcPI0ApFLtpBZHM6k685mHqfBWL/+S9NERQqJO73lDBDCZVUNAluUSrW++lxyPS7vsXSWn
        bx9svpPYuP2GN
X-Received: by 2002:aa7:cc86:0:b0:457:f801:2951 with SMTP id p6-20020aa7cc86000000b00457f8012951mr9018663edt.16.1664564911975;
        Fri, 30 Sep 2022 12:08:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4AneXVS/tv8vESVK+vpN3uJLhQgCqt2orY0RNpjmenzjQ8MZ56VRv+hjtCuuOTxMRHh+7ybg==
X-Received: by 2002:aa7:cc86:0:b0:457:f801:2951 with SMTP id p6-20020aa7cc86000000b00457f8012951mr9018651edt.16.1664564911735;
        Fri, 30 Sep 2022 12:08:31 -0700 (PDT)
Received: from avogadro.local ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.gmail.com with ESMTPSA id s15-20020a50ab0f000000b0044ef2ac2650sm2066367edc.90.2022.09.30.12.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 12:08:31 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final set of (mostly selftests) KVM patches for Linux 6.0
Date:   Fri, 30 Sep 2022 21:08:28 +0200
Message-Id: <20220930190828.116565-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 69604fe76e58c9d195e48b41d019b07fc27ce9d7:

  Merge tag 'kvm-s390-master-6.0-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2022-09-23 10:06:08 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-6.0

for you to fetch changes up to 07834cc4df06d48a354bb0b1eb1b07069584e581:

  KVM: selftests: Compare insn opcodes directly in fix_hypercall_test (2022-09-29 12:54:02 -0400)

----------------------------------------------------------------
A small fix to the reported set of supported CPUID bits, and selftests fixes:

* Skip tests that require EPT when it is not available

* Do not hang when a test fails with an empty stack trace

* avoid spurious failure when running access_tracking_perf_test in a KVM guest

* work around GCC's tendency to optimize loops into mem*() functions, which
  breaks because the guest code in selftests cannot call into PLTs

* fix -Warray-bounds error in fix_hypercall_test

----------------------------------------------------------------
David Matlack (2):
      KVM: selftests: Skip tests that require EPT when it is not available
      KVM: selftests: Gracefully handle empty stack traces

Emanuele Giuseppe Esposito (1):
      KVM: selftests: replace assertion with warning in access_tracking_perf_test

Jim Mattson (1):
      KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest

Sean Christopherson (2):
      KVM: selftests: Implement memcmp(), memcpy(), and memset() for guest use
      KVM: selftests: Compare insn opcodes directly in fix_hypercall_test

 arch/x86/kvm/cpuid.c                               |  2 --
 tools/testing/selftests/kvm/Makefile               | 11 +++++-
 .../selftests/kvm/access_tracking_perf_test.c      | 25 +++++++++-----
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |  1 +
 tools/testing/selftests/kvm/lib/assert.c           | 20 +++++++----
 tools/testing/selftests/kvm/lib/string_override.c  | 39 ++++++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       | 20 +++++++++++
 .../selftests/kvm/x86_64/fix_hypercall_test.c      | 34 +++++++++----------
 8 files changed, 115 insertions(+), 37 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/string_override.c

