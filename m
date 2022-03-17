Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BEB4DBE68
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 06:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiCQFey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 01:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiCQFex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 01:34:53 -0400
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84DA2335EF
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 22:02:35 -0700 (PDT)
Received: by mail-ot1-f74.google.com with SMTP id n7-20020a9d4d07000000b005b2389a99cfso2231624otf.17
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 22:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gsRfKzq4vGn1YNn7YUeVAb6qtw1e/e04FOs1fz7BrH8=;
        b=JQG63yoRkgZtQa+AY5jQ61gQ21UrAkBQTDwjcqE2wayF+Aw4AE7+soI3KijdVqUYth
         PA+hEiVlLfeDxUnpYSSfvZYqpWIzC/cD7KxxMRRaidxbHfUUpjfNO++vp23aI8SxFNXQ
         VNz91cyBoLSLN/u8cEo327J4nZPFO4XQN6SUi8pt//hAX8OFAQtYftmQtWHYqMfE+Oh/
         3To00VP/WmW2h9NWj9TJ3SI4+LNL3gUxfXG60r9DWvtkrVBmfYJqVcS27uYuDIbO/qES
         XixXnDXWQ751hX8ejbeNt6RayBdIbk+kZshHHKYU/RrxBMcLdnI2MmN96lBOjX7ldQpI
         +YSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gsRfKzq4vGn1YNn7YUeVAb6qtw1e/e04FOs1fz7BrH8=;
        b=6sRzdPed504qQeggfWRA8Ntuo8poWigG4i6KWCm7mJK9MOd7cjaO6Q0ZuOsvF0OQAY
         M/+c5EJJLhxEsdWHMT72uHH0Nkzoa1mpZDudQ2cM1NywzbAA28LbcZpD9eLtDPpZXSOf
         +UygTC2MqA8PWesis4NU4dRAEW9mtMDFSeR2G1NrkmWWSMlW4MRCOR8XnrVUWskP6QBX
         EJywvlSoiM5cOf2K42rbvIQ5biXJcBIz3foZ1SxPDi7NtybDgxQUKeJhPdmZVYmhuY2W
         NVlzrWxNevnt5RMOlksXrlQBOMcZYP2Ln6uhWHx3NehvwVqNFp89sn/0N2lss+AACKp9
         tCmQ==
X-Gm-Message-State: AOAM532tLF8PJqIb/cPYu9IhADVvtDTcafV11p1xojDp0rbfhOZTlBTd
        zrc+bZh5vtEQn8aBCqyUW8Rz+czgJr5Q2GKEM18GO+M5ptTnznO4Cc2zBjosIjHP+xVhDSnJ5xf
        wnZRYRjPa6cwAtiQakAlJccLVrIW71A7mdR8KdkeKUS92hwJXD/+tojPtQRFSKcY=
X-Google-Smtp-Source: ABdhPJzy+EnjPuXkGb+ndtKs1lIVtKRwKk8qD6YEJzvqK1mx3sZTRli0/Bkp7MZ6poB8q45nifTmZHT0ufFTpQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:e541:b0:1c6:55e5:ae4b with SMTP
 id ei1-20020a17090ae54100b001c655e5ae4bmr9070079pjb.62.1647492690738; Wed, 16
 Mar 2022 21:51:30 -0700 (PDT)
Date:   Wed, 16 Mar 2022 21:51:24 -0700
Message-Id: <20220317045127.124602-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 0/3] KVM: arm64: selftests: Add edge cases tests for the
 arch timer
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new selftests that validates some edge cases related to the virtual
arch-timer, for example:
- timers across counter roll-overs.
- moving counters ahead and behind pending timers.
- having the same timer condition firing multiple times.

The tests run while checking the state of the IRQs (e.g., pending when they
are supposed to be) and stressing things a bit by waiting for interrupts
while: re-scheduling the vcpu (with sched_yield()), by migrating the vcpu
between cores, or by sleeping in userspace (with usleep()).

The first commit adds a timer utility function.  The second commit adds
some sanity checks and basic tests for the timer. The third commit adds
the actual edge case tests (like forcing rollovers).

v1 -> v2:
- Remove the checks for timers firing within some margin; only leave the
  checks for timers not firing ahead of time. Also remove the tests that
  depend on timers firing within some margin. [Oliver, Marc]
- Collect R-b tag from Oliver (first commit). [Oliver]
- Multiple nits: replace wfi_ functions with wait_, reduce use of macros,
  drop typedefs, use IAR_SPURIOUS from header, move some comments functions
  to top. [Oliver]
- Don't fail if the test has a single cpu available. [Oliver]
- Don't fail if there's no GICv3 available. [Oliver]

v1: https://lore.kernel.org/kvmarm/20220302172144.2734258-1-ricarkol@google.com/

There is a slight complication with where this series applies.  The test added
here fails without commit cc94d47ce16d ("kvm: selftests: aarch64: fix assert in
gicv3_access_reg") which lives in kvmarm/next.  However, it can't be built on
top of kvmarm/next as it depends on commit 456f89e0928a ("KVM: selftests:
aarch64: Skip tests if we can't create a vgic-v3") which is not in kvmarm/next.

Ricardo Koller (3):
  KVM: arm64: selftests: add timer_get_tval() lib function
  KVM: arm64: selftests: add arch_timer_edge_cases
  KVM: arm64: selftests: add edge cases tests into arch_timer_edge_cases

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 891 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |  18 +-
 4 files changed, 910 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

-- 
2.35.1.723.g4982287a31-goog

