Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB11A550134
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 02:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383221AbiFRAQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 20:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbiFRAQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 20:16:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6594E20BFA
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 17:16:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id lw3-20020a17090b180300b001e31fad7d5aso3592257pjb.6
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 17:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=4HlwtKsrcUiP4ezxQu89E9aBkat4STQcCRUlQRJmlM4=;
        b=cqH7RwM35eUa9gSH23Vyp0IXD8rbHQ6iHBYjzqYB4r/ApR3GiB5irQq91CvaOTU2a/
         JbiD+lO3mhGF7Q9VF8Z+RL2N3kcJKkwfgbC11BxFaQhlTH5WcSxRdyy/VhMTgegBEuWE
         m0ICZIKBakq6kG4UrIJM1l7DZgPfrlXNTJzqVOW/b/BDjaQn7NZ1PZDqtivgtVVTA1vf
         J3LNa6ebna+9KeWC2sraxN7xZP7PZA5oz+Ft9ZxR6ro5zNG2FCSpgajvCr+Yw7sr0lRJ
         GloAY8IFUzs+m+0goppunIS/0Ln/zHmwSHJByc2TnvMQ/Qh39U6cvZifZQqRqYSCI5Ep
         Y1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=4HlwtKsrcUiP4ezxQu89E9aBkat4STQcCRUlQRJmlM4=;
        b=hs89Bzkg8//FyW5ST4jdLKeDOQ932L/LkTP5IN/PRWW8LDZSf5/q6XeOAXTUEvYuBD
         KPprNE7X8dmYjyhzr0vBvWvC6CuduXkzC3TyxWO2qEkxTGF6PzlN6CQ1xU1Bmyq5fCqM
         4OxXcW98Ihj118i/gaqIwPMb0qsye8b1PuxpSFHUOYKpZzFSzPOYUjI3vVY0kg3YK8w8
         jWvBzOkE7NZ5Ul6JLzYQeXTqwp8gdK6myM2j3rNzxRPs+iYVMhN3Y/Ba02ftrKKOJ2Y4
         LY3TSgpvGuD5Iz1ChwbdV4ilHMitwIYfsKXKUKt3Z4/KWEAPpOuz8l1MJYR92stXsaAe
         YRSQ==
X-Gm-Message-State: AJIora+zVVU9921YZJGUKCmdvBa4pkN5v/QAC3qag73nMwACJww0Ur3E
        cZd/YVZ9qbx3oEZlYhRTgaCsvy3TFbE=
X-Google-Smtp-Source: AGRyM1u0GdVPlx+Hq/yK0Jw2vZzxWWQDidlftHCsuvnSZKrmnfBPw9OaOWYf8QzYovkEUkJdLG9nTYZRGxE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:16d2:b0:522:81c0:a635 with SMTP id
 l18-20020a056a0016d200b0052281c0a635mr12877654pfc.0.1655511381838; Fri, 17
 Jun 2022 17:16:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 18 Jun 2022 00:16:15 +0000
Message-Id: <20220618001618.1840806-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 0/3] KVM: selftests: Consolidate ucall code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate the code for making and getting ucalls.  All architectures pass
the ucall struct via memory, so filling and copying the struct is 100%
generic.  The only per-arch code is sending and receiving the address of
said struct.

Tested on x86 and arm, compile tested on s390 and RISC-V.

Sean Christopherson (3):
  KVM: selftests: Consolidate common code for popuplating ucall struct
  KVM: selftests: Consolidate boilerplate code in get_ucall()
  KVM: selftest: Add __weak stubs for ucall_arch_(un)init()

 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/ucall_common.h      | 17 ++++++-
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 36 +++-----------
 tools/testing/selftests/kvm/lib/riscv/ucall.c | 44 ++---------------
 tools/testing/selftests/kvm/lib/s390x/ucall.c | 41 ++--------------
 .../testing/selftests/kvm/lib/ucall_common.c  | 49 +++++++++++++++++++
 .../testing/selftests/kvm/lib/x86_64/ucall.c  | 41 ++--------------
 7 files changed, 87 insertions(+), 142 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c


base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
-- 
2.37.0.rc0.104.g0611611a94-goog

