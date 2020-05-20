Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FF71DC2D3
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 01:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgETXWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 19:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbgETXWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 19:22:44 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38358C061A0E
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 16:22:44 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id i6so5317400qvq.17
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 16:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/lEDirUhwHyfOWS2dNRkbkWfMcrJD0a50ucbyJwdVOw=;
        b=XZuB3rMe1s5DxcAuFxC3aXX8cHnvI8oAMLWVGhwcgwkjThZcLMbk3xdurV4XYsT9Kr
         zQQa0lV+toN+rSP9JntYeWS9vnqpeOUZjWbpIw/uIW9FnM4zVhvA13Ln9KFFGBXRwlu1
         lqq4QzfmGkdCcVGFM2687Pfx9fcC95+1ykuVCt5IhprSpyrpV5k8m4VVH2J6TR6Hx03B
         NXMtXaFsASr8C+FWIFdIUSE+A9SkOzmHVwT8Le87VOHm+ow9ahTpGVHHw8I0CVdTITNu
         fUYi8qm0t/yo2j3R+exqhkRlvYcfwrO0kFXwwcuw3mxxU66b8rT9AhrJl6imvh+qkbir
         I7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/lEDirUhwHyfOWS2dNRkbkWfMcrJD0a50ucbyJwdVOw=;
        b=TzA0fbn1i7knKWiMGLmJwNrS7OACek2TqILBR1CnuGay8hllymbAUdXroTwGRK//9k
         OMhGJExFw3BKkhdSwkCFpVkt1xCf2k9CEhdUTCzHvGaTEcD9kTLv8okl3pRnv8mQ7AjF
         mLs9oLxzz8dxRPbNCL+oLsC0H2RAgluoSB/6ZbRWl4cOzzdr1/h17u7/AOcSB/NkJG9l
         vkJLLiXwYK53C79kL+X1a8nZkFh61DZKlVX5vmJ4koyYhj8N8l6jhTk3dG7oZhvyloLF
         qtjr5U0asAv6bsqaPYux+htB4iZEgW/NqV7e+TJrJypnzHUqp8eue4XOUyuL/9nknFb2
         upkQ==
X-Gm-Message-State: AOAM533O9S1pfjJnIUyzWbyZ1yW3OK+wo9jgO1Vyv++ZRQ8LPA04AqCQ
        TNvulrp2CHpsYhX0D9CY24r9MAwpiB3hx/osPRKPl5URU7jHVfBty+Ju2I3F5QGsaZlhx2ObQv7
        alkeJSn+7R7LuQ24UFhAxtGYCA3cvRl6+Lo95r+mAVUDaHZBiy/y3wYCmieBrI1OXubFqcT1qDr
        bSkFQ=
X-Google-Smtp-Source: ABdhPJwPxeGt9Iss99GIF8/ugNxOAQVvai2hJGX7zVzAp8/qJ5jXEBrTGO5i4iUvzz0+u10LDt1vc/3j2Z858AijFZXAuQ==
X-Received: by 2002:a0c:db83:: with SMTP id m3mr7324371qvk.40.1590016963114;
 Wed, 20 May 2020 16:22:43 -0700 (PDT)
Date:   Wed, 20 May 2020 16:22:26 -0700
Message-Id: <20200520232228.55084-1-makarandsonare@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH  0/2 v3] Fix VMX preemption timer migration
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix VMX preemption timer migration. Add a selftest to ensure post migration
both L1 and L2 VM observe the VMX preemption timer exit close to the original
expiration deadline.

Makarand Sonare (1):
  KVM: selftests: VMX preemption timer migration test

Peter Shier (1):
  KVM: nVMX: Fix VMX preemption timer migration

 Documentation/virt/kvm/api.rst                |   4 +
 arch/x86/include/uapi/asm/kvm.h               |   3 +
 arch/x86/kvm/vmx/nested.c                     |  45 +++-
 arch/x86/kvm/vmx/vmx.h                        |   2 +
 arch/x86/kvm/x86.c                            |   3 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/arch/x86/include/uapi/asm/kvm.h         |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  11 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
 .../kvm/x86_64/vmx_preemption_timer_test.c    | 255 ++++++++++++++++++
 13 files changed, 344 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c

--
2.26.2.761.g0e0b3e54be-goog

