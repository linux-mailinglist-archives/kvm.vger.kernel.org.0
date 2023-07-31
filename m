Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA7776A1DD
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 22:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjGaUac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 16:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjGaUaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 16:30:30 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD43184
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:30:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56438e966baso1410840a12.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690835429; x=1691440229;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6HESCPn2yqkRQlomTDEJ9KEelTSIJogLeTLwuEF5EyM=;
        b=bIOTcPBKQpMsQ2T038vAoGELSwehmJJHLXxm0vf7EKuC0vlU7oM5xb+0JHY8DMrTa6
         vjiCtfDi4kTL5EtobGmC5eLwYHbbPwoALsuGqqELp5A7ErCquVX5RBodMXTmxdcTgoIT
         8kq/f6qU3bnUXYaTjESLcAXCoJvZQITEk4SpczPfkH8r3ILgy3m6n3RJ/v2yt6dXQ5Tq
         yN8F33WdnVS7aXG/I3E80Chr/bnZInSl3kaP12QzmDAm0HT/ApcbtFahnvurMVvg3cfr
         DwCh3X+vO2C96IswGqZFhexHyjKLpwTvqH5fXuFj7Xr5L+1/Z2YMfjRHJ0BN3KDE8yVp
         APBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690835429; x=1691440229;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6HESCPn2yqkRQlomTDEJ9KEelTSIJogLeTLwuEF5EyM=;
        b=CWi0nsAYjylXy/MD+TmgbKLfCPBYPDJYfLi6C2b0SXvsUzVcdAycdqKhkE4Lcx0eU2
         275dhnrFwXuY9Z4ToOSq+QZVpJkxmuPXUygAK7g0+roFvxt7fajSJEASZRfZH5jZ+A86
         RrqTJPp3ieW7x/yP1qZSM9Xlg0aXEUsVLHres3kuDd105NL6YZjoZkrAn6Il+cF6gsuA
         Pc8OAT5HxZcCoQ8F8v0BjQGflKiAVBk21gvJ8aHwPpQZaW4mDo1JJyxK3Jj5hkcSFydk
         Iu9vIyqgHxNfFi4sP2+z1FJBjPsIHG1t0GrIcdSfBb6+1Cjbl9XrMco5mFjgEV4YiZLJ
         8d8g==
X-Gm-Message-State: ABy/qLbsLOusnvoeVVVgzFVlP+lYPQFqZWEFmt/nA/nGsV/mENb4dC1u
        g/DiOl3xdhlKxoSlU6zZSwPcWHrr5ks=
X-Google-Smtp-Source: APBJJlHgxXlg8+gvx8zA8kKWT9TTiDRE1TpIeTm8T+Air3m+lXVJ5gOGOil9KVUs5jELG98CZaMGEync9vo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c8:b0:1ba:ff36:e0d7 with SMTP id
 o8-20020a170902d4c800b001baff36e0d7mr46611plg.12.1690835429354; Mon, 31 Jul
 2023 13:30:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 31 Jul 2023 13:30:23 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230731203026.1192091-1-seanjc@google.com>
Subject: [PATCH v4.1 0/3] KVM: selftests: Guest printf extra prep patches
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delta patches for v4 of the guest printf series to enable guest_printf_test
for all architectures.  Sending all 36 patches seemed counter-productive,
and I want to get input on adding ucall.h asap.

v4.1:
 - Add ucall.h and have each arch UCALL_EXIT_REASON so that generic code
   can query whether or not a ucall exit actually occurred. [Drew]
 - Use UCALL_EXIT_REASON in guest_printf_test.c and enable the test for
   all architectures. [Drew]

v4: https://lore.kernel.org/all/20230729003643.1053367-1-seanjc@google.com

Aaron Lewis (1):
  KVM: selftests: Add a selftest for guest prints and formatted asserts

Sean Christopherson (2):
  KVM: selftests: Add arch ucall.h and inline simple arch hooks
  KVM: selftests: Add #define of expected KVM exit reason for ucall

 tools/testing/selftests/kvm/Makefile          |   4 +
 .../testing/selftests/kvm/guest_print_test.c  | 221 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/ucall.h     |  20 ++
 .../selftests/kvm/include/riscv/ucall.h       |  20 ++
 .../selftests/kvm/include/s390x/ucall.h       |  19 ++
 .../selftests/kvm/include/ucall_common.h      |   1 +
 .../selftests/kvm/include/x86_64/ucall.h      |  13 ++
 .../testing/selftests/kvm/lib/aarch64/ucall.c |  11 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  11 -
 tools/testing/selftests/kvm/lib/s390x/ucall.c |  10 -
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   4 -
 11 files changed, 299 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/guest_print_test.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/ucall.h


base-commit: 12dcd9e1fe9264d306837622952b8f79d1181fab
-- 
2.41.0.585.gd2178a4bd4-goog

