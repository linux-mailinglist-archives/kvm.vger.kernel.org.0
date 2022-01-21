Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEE04967E1
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 23:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiAUW3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 17:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiAUW3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 17:29:39 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7552C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:29:38 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id n2-20020a255902000000b0060f9d75eafeso21923376ybb.1
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=A/ow/CQlY0zqHstt4Zs3QK0O11/NS0VBhiM4HuVhI3w=;
        b=G3WdVzUOMS4N1LRl1GLTVoZjpIunTtpuw/WxbEjTqUP22tOgVocLRzJZft0Zvc9nZv
         Vv4L768PbhMH7NbV9xloqnk0ORiWk6qDCOE3AXpekgdaPgTh/Vo5OX6uM4n4mNdzbxDD
         tqJ6RI0GP6uf3pnF07Xkkw0w6ONcY0loF91SkHBzkgyaghoWQrhd/PTDoaU12tH8W1ES
         V3foe9IR8oruSpgAlSu6vMh9Fe5MFw7SVF1QZtLGcESYNjvmFS9FGSwwpQSwRl372m/a
         x+jQkDSysHXXeiftRnHojcNoET2+TNtcOZlHSug3XxtYpM/P0mP4omc/NCNxyODDC+O2
         w7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=A/ow/CQlY0zqHstt4Zs3QK0O11/NS0VBhiM4HuVhI3w=;
        b=jI9uRQ+hvkdjSb98JREgyKMs9BJ1LCpxpP8buc/iCgnH9U7jpmGvnBkFTiAFWCUR/t
         gctNPgUpmMFGYP/ROrkBO+YKT1sA7C1aFBbqaLMqbrRy3Yggjk6azJogzlORQbn/Qc/Y
         74T7dbZt/WfA5g/1ZExhyNLO+iZROkmAeenyF+vGbGJ3ibtSGGVbn3AorhlP3KY4qIHx
         slC8UEsmWf8d+f945qEJY70I+chZrLoUwKTG1AzDnn9rCfW4ImXNXmasbej0R+NH+E8n
         pnlfDzpQ1Djo2VKwd3S4wDUtPaetnYB5XXYffEaqPbtq+Nm/Jxpkvk0CgVmzUTfxcrhr
         lReA==
X-Gm-Message-State: AOAM531tY98WCAFbT2S/RYZhJOSaQ3pH6SE/kxWItVGUHR/JqXN0/HbT
        bxWrgS09DeXVxfFz7bDFnTVa/fSSj/ey3TlK09loGnI8XHgHNqZqoH6trMhEDFnXL8FpCgEo/YV
        dccx1abq+4fjJVSbavjzVcpObRVSDr/I4hEQr1tMBX0gbk6fgLXb+rAeSMfqr3uW3fw==
X-Google-Smtp-Source: ABdhPJz/ghZ44E4Z1HvceJDJxDuhVMB828pIroKJCfWynj+sXyzXT+WjNnXyUcG2hSlje5w+inH3SvTsFCt4e4Y=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a05:6902:51:: with SMTP id
 m17mr8740206ybh.464.1642804177919; Fri, 21 Jan 2022 14:29:37 -0800 (PST)
Date:   Fri, 21 Jan 2022 22:29:30 +0000
Message-Id: <20220121222933.696067-1-daviddunn@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v4 0/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com, seanjc@google.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set allows usermode to disable PMU virtualization on
individual x86 VMs.  When disabled, the PMU is not advertised to
or accessible from the guest.

Corrected changes that I missed committing into v3 patch set.  This
incorporates Like's suggestions from reviewing v2.

David Dunn (3):
  KVM: x86: Provide per VM capability for disabling PMU virtualization
  KVM: selftests: Allow creation of selftest VM without vcpus
  KVM: selftests: Verify disabling PMU virtualization via
    KVM_CAP_CONFIG_PMU

 Documentation/virt/kvm/api.rst                | 21 ++++++++
 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/cpuid.c                          |  8 ++++
 arch/x86/kvm/svm/pmu.c                        |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |  2 +-
 arch/x86/kvm/x86.c                            | 12 +++++
 include/uapi/linux/kvm.h                      |  4 ++
 tools/include/uapi/linux/kvm.h                |  4 ++
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 48 ++++++++++++++-----
 .../kvm/x86_64/pmu_event_filter_test.c        | 45 +++++++++++++++++
 11 files changed, 135 insertions(+), 15 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

