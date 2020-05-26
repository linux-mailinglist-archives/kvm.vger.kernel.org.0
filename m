Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD271E317B
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 23:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389134AbgEZVvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 17:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgEZVvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 17:51:16 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E56C061A0F
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 14:51:14 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id v17so23791042qtp.15
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 14:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JsFe+N5Crx7S9HTSKTOSQGE2yny3voXAyrEiokfM1es=;
        b=rxbbGFmWtMHoEZjKVc6p7rFGdNaP84+QznsSghpEjm2PqUxGPsTMMLY1d8tlFu/3nO
         C5LDMn8Pe+ytAIqrRl/SIEc7ZOXFQGTtuAaybM8hiwlwRHD9A7bvDIJBU0m9EloJzDxh
         Qxu+l9a/UzvoEvHcddUZcWIG5ea3oSfKD2ikZn72T2+dSw9pToFOmD/dzk0ROHRyQ55/
         8cNgAJjElYIsqMyynpofx7BiiznwXfRTBYDlu2GP427HNFb48mKkwHP2SP2lFsU0Hth3
         3uhjjMsZU/fk02SU4YHJu5nYgBPCvWttLvCew90fCUJmlf8VOOtKaCeTmNjcQEhqO79r
         TlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JsFe+N5Crx7S9HTSKTOSQGE2yny3voXAyrEiokfM1es=;
        b=CksIy+fFI2JLkb0mPUGpZ5dN+MNTNDnBt641lw7SYooMD5KIaQZAknNAUYMb3Jd3SF
         bwMI8feONgrGW//gyWNRwgrddiywlO5C4KhoagZ/VskAeQ/j+Oz0XE+4yJ6jv+eeyv9+
         nFYnhOywxuD+n56u2RabJHovPGt24p3vuCh/t4VxZ1wVKboU1q0j4OhrBVaAZl61yzn5
         waWaiQqb+QS8usCY+KJcNrKPU5XSQ/EOzvqHgnnY0u1QzxRGuOT5UIaQO3sMKt3X2/FC
         DBH6TIJRmkCEd5L7St0goTY8n+HjaROYumBALAVeWDHV0uAwDoOk0De1e3VYQ3B0v/aP
         JYDg==
X-Gm-Message-State: AOAM531GMiRT3v/96XoWMMe+i52wo291Nk9Y/vbiMjNLbuWt0EkHDe0q
        aativkLHdkw4VapaAPfW4fbnjn1Y2XxfxXiMUs6Hfj0JZY7SsvWwzFljAO7CK1VjfWTuRn+/t98
        qhVPHBAXoGtAC/6ZjU1/qDTPSLoXiB9JOu45FtpPJw9oQoOPRSCHYyn+/ewf9oBFnqVYgIt7zja
        B9aVE=
X-Google-Smtp-Source: ABdhPJw3F8D4hE0oOF5Ut/M9pHPdbBMl7IcEA5edpRf+JFo1cn9T6X+oRXja4Ve42BOWl6cQCMpBxOmKlB9yg2qQVjUw2g==
X-Received: by 2002:a0c:8482:: with SMTP id m2mr12650359qva.65.1590529873579;
 Tue, 26 May 2020 14:51:13 -0700 (PDT)
Date:   Tue, 26 May 2020 14:51:05 -0700
Message-Id: <20200526215107.205814-1-makarandsonare@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH  0/2 v5] Fix VMX preemption timer migration
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4: Renamed flag to KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE
    and removed the KVM_CAP_NESTED_STATE_PREEMPTION_TIMER check [Paolo]

Makarand Sonare (1):
  KVM: selftests: VMX preemption timer migration test

Peter Shier (1):
  KVM: nVMX: Fix VMX preemption timer migration

 Documentation/virt/kvm/api.rst                |   4 +
 arch/x86/include/uapi/asm/kvm.h               |   4 +
 arch/x86/kvm/vmx/nested.c                     |  55 +++-
 arch/x86/kvm/vmx/vmx.h                        |   2 +
 tools/arch/x86/include/uapi/asm/kvm.h         |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  11 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
 .../kvm/x86_64/vmx_preemption_timer_test.c    | 255 ++++++++++++++++++
 11 files changed, 351 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c

--
2.27.0.rc0.183.gde8f92d652-goog

