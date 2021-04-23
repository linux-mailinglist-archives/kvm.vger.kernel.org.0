Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83FA368BC6
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 06:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhDWEEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 00:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDWEEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 00:04:34 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B3DC061574
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 21:03:59 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d130-20020a621d880000b02901fb88abc171so14311426pfd.11
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 21:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=X+DkTW1449q6fKkD8wwhLKFk8s0Ll4r+obcvc3w7AoY=;
        b=OEV2E0v7G6MTuZNr6BG8lG5sW3RKvFodkb/XgGwjBktiRnkXbRKMRqYz/lzohVAI/E
         r0/P7Urx2zN0iq9Jdq1FmN1WGG1A5vrWPFfQUPwM4XG2URDsvLGMfF7S28OSkRSjzps3
         04lQmvsAPgbiSzxoWjwXj140V2pmVwFbjk+ghVUQKxCl08oYu6FnI7a1a5DZCRi+mQIY
         O5I4ztfWmfkqO6XXsiGqHZYAxikvGeNU+p0DymtFax1b+HaddNSHuf+bdzBbPPSaDLp2
         ii0FukZCzTcycFtCxy8Fx5BYQtUh1pfkcX/t6pmuyfORPa3PyGh+9eN6IuKUc4jojNNb
         XqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=X+DkTW1449q6fKkD8wwhLKFk8s0Ll4r+obcvc3w7AoY=;
        b=Y1qvzJEVos76C+dMQyvrlUZaIrQ4NBZ4YcuaAc/2Zq4Q3q6NLFdbss9pMxuNpzuOWN
         z+5Gt2k8CvCaSgIxR6aZieSE0x95uqNuVY36eAEEuu6mZpW6kbwEyuQLJqN+8KuJBZvn
         05MPVoryys7+YLIg1mh+OXAzhGNwDvVrPI9jZxqHju7deA5vSMa9sEovXPFh+0Ob0y84
         HK5UDrJmB9mta9Gr+BwcsMPuiDOdIMp73IbvcSS3Ic96Ue0rE67JNrEL/qLo5hOmfb2F
         75LToug5h1qeWIb8d8iFu2boSbPP3bkKYGBFB8//785IUXzcopyKtRLIoyh4abj6tE/U
         Bbeg==
X-Gm-Message-State: AOAM5304KSbuMnRdK66hwRRa/HtxsQOliEa460Ohm/TXvFJ/5wY0xsIJ
        a5Q4sircMZV8oXMQKsmc0OGJKDJvcgY2zrTtD7H82KxS6B3VVfaA3lvxRVW4t3t4qzdzIKjgLoe
        kQxA626fHbV9ltwH+efqV9DPHE4anQQwZF5uAmUMFldmYHex/3mweIcwyi+P+Mlw=
X-Google-Smtp-Source: ABdhPJzAqfVay/TiQ2no35LKS+c6fnp/vF6u7i0f38OpLvhcyqzJZ1aTWQmi2aj2SkJiYTFhn+EdPXPQ/sludw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:19d1:: with SMTP id
 nm17mr3454828pjb.218.1619150637213; Thu, 22 Apr 2021 21:03:57 -0700 (PDT)
Date:   Thu, 22 Apr 2021 21:03:48 -0700
Message-Id: <20210423040351.1132218-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 0/3] KVM: selftests: arm64 exception handling and debug test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

These patches add a debug exception test in aarch64 KVM selftests while
also adding basic exception handling support.

The structure of the exception handling is based on its x86 counterpart.
Tests use the same calls to initialize exception handling.  And both
architectures use vm_handle_exception() to override the handler for a
particular vector, or (vector, ec) in the arm64 case.

The debug test is similar to x86_64/debug_regs, except that the x86 one
controls the debugging from outside the VM. This proposed arm64 test
controls and handles debug exceptions from the inside.

The final patch adapts the x86 unhandled-vector reporting to use the
same mechanism as the one introduced for arm64 (UCALL_UNHANDLED instead
of direct x86 port IO).

Thanks,
Ricardo

Ricardo Koller (3):
  KVM: selftests: Add exception handling support for aarch64
  KVM: selftests: Add aarch64/debug-exceptions test
  KVM: selftests: Use a ucall for x86 unhandled vector reporting

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  86 ++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   2 -
 .../selftests/kvm/lib/aarch64/handlers.S      | 104 ++++++++
 .../selftests/kvm/lib/aarch64/processor.c     |  56 ++++
 .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
 9 files changed, 506 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

-- 
2.31.1.498.g6c1eba8ee3d-goog

