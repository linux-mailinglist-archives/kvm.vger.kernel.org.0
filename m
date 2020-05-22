Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724971DDEEE
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 06:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgEVEgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 00:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgEVEgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 00:36:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE7FC061A0E
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 21:36:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r18so7853171ybg.10
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 21:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QS458jr+jrBF4ZfrX+FLmz0fQcR7FoBz8JDXCnUvz5Y=;
        b=q/qo6JwLEXfPjmuxeElHOzftGXFyQAYKpnloCymb3E/rBkxuZzb1oYOQxI2kQmqy7n
         0nvd6SccJ9RR9goh+XheBYzhYe87dCUgPWbTH45SXdw0whyAkeDH/yi2QjE4wIEXxAnS
         nWiYCs+VbhUVykPRm946R88Ny1wqBJwkunZxAcldTKzF72vFO7DiTDxiHflmqTaf0PPW
         gbFWl8Dg+p/wLqePn/d5NyDtU8YvHoBRGTbEBFjjHYGR7GJNLYNWU3EaKWhvoubLDYn8
         K2pDIWe4y8X1WLPN76p2xW4/VduztYX3K/KIpSLjaX9N7jbtNauelXXMYZsGLXxRHebb
         QKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QS458jr+jrBF4ZfrX+FLmz0fQcR7FoBz8JDXCnUvz5Y=;
        b=fWMRlHmQVcMiAo68hpsHco5Eshhsd95NZcAm09B4OQGgYn6HqJPEOMm9vycfEz7jcj
         P2IY077/9DEUDx/pG60neqQDHKj/hOKhGGT4JxmQ80Y1VcnsMFowko9lzKOmcEiERKb7
         IAxmUkRa3EYkRi5YmCepagQA3t4n4V+bIpj+GX9ru1fvzfbZtcqBdMC7ZJvpQkaFOaJr
         hP26HVEg2N9w1iDdhzB4bxDpoqR89shj8Y+hgiI7v3dBcRRk4USdEJMujgU61socBV82
         rXLVV4YdgI6sPJduJcwfqVxQ52vFxNHgZTzA7CQCPboB8TOKWSKdff+fPHdzL0jEHKta
         br6w==
X-Gm-Message-State: AOAM532HHM2k1OnPqzhQNV2Yrlip1E6et5XnNcYOrYz7I5N+KfZwNmmy
        g2g5+gkxqE+lagYUIqgBR7hfZiWMuFNPAvKv80lnGMFfP/79k2I1iAQFd8Dj5Ol92j6wqK4Nsiv
        oZswDnqxqawhiZkYcjox0Hm9w4bFE8hFNZFqdZ3UelB5AfzD3bWdAKtK7BNN6o9CZYpgEPuHmaC
        XT77E=
X-Google-Smtp-Source: ABdhPJwM75oQ01CEnjrgIJbj/klTIFWT7khTjG8eKzU0yWqgLg8eCiyR41SZSSSRIeFzC9oaRypGApTjB/ad/IyOd6nh2Q==
X-Received: by 2002:a25:7e03:: with SMTP id z3mr20226600ybc.285.1590122202595;
 Thu, 21 May 2020 21:36:42 -0700 (PDT)
Date:   Thu, 21 May 2020 21:36:32 -0700
Message-Id: <20200522043634.79779-1-makarandsonare@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH  0/2 v4] Fix VMX preemption timer migration
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2: Added an u32 flags to the kvm_vmx_nested_state_hdr to check the validity of
the preemption timer deadline. [Paolo]
v3: Moved the code to calculate timer value to a separate helper [Sean]
v3: Rename l1_scaled_tsc_value as l1_scaled_tsc. [Sean]
v3: Removed unncessary parenthesis and moved the >> operator to previous line [Sean]
v3: Changed >= to > for comparision between l1_scaled_tsc and
    vmx->nested.preemption_timer_deadline [Sean]
v3: Removed the extra if check in sync_vmcs02_to_vmcs12 [Sean]

Makarand Sonare (1):
  KVM: selftests: VMX preemption timer migration test

Peter Shier (1):
  KVM: nVMX: Fix VMX preemption timer migration

 Documentation/virt/kvm/api.rst                |   5 +
 arch/x86/include/uapi/asm/kvm.h               |   4 +
 arch/x86/kvm/vmx/nested.c                     |  58 +++-
 arch/x86/kvm/vmx/vmx.h                        |   2 +
 arch/x86/kvm/x86.c                            |   1 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/arch/x86/include/uapi/asm/kvm.h         |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  11 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
 .../kvm/x86_64/vmx_preemption_timer_test.c    | 255 ++++++++++++++++++
 13 files changed, 356 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c

--
2.27.0.rc0.183.gde8f92d652-goog

