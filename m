Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C4F4CAB6D
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbiCBRWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiCBRWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:22:31 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A176CC336D
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:21:48 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id v4-20020a63f844000000b003745fd0919aso1358821pgj.20
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9YqbKPgK/tnln+kDR4MCwrkXjLgcuv/9ke+y8jolErQ=;
        b=JJIwR4S1BUgY5vhRkYWvlg1aX6GMvEvVhU92JbsX52jBVdFceU5p6y3G/IgKMkPVcD
         oZ/VPIxu+kdHAtekC/PA5anN/lxyeBlkTP2n37/4izCp/waT7J4XKhWrJrvQM2QEbLTZ
         Zv757zxYDSuctL1b4yiGQNBIWuGtoAgiUJxj7XQH6bvQxXd0psfVfBMaYjVgV+7DkivL
         5rdbbFwAF50Rdt43ND3bqdLmKrRjEgmBGR9MapnLlr/HAMfo/4G0fYtWByHJfMOgxrGB
         JKx+sB9L48WdnwGw9JdIPJhEyuumgp0iba5DPWAUeNGYp2hY9sdAN5s06B0KKVsvSVzc
         +gcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9YqbKPgK/tnln+kDR4MCwrkXjLgcuv/9ke+y8jolErQ=;
        b=UpBd8XfgewCpi0o82v/wm6gkjv5I24tLlzlr4tMSkIvPcSetrRBIZB2OPAXXR7d+JY
         yjET+j9DhBzBNrT27o7F/wf/j/DWEiJZtPXZTcDBf5+jQeGpdutbMWR1ppWI2WFrMgwx
         YskVeNoEDA7YJgMRd0YXisozCel150QiZ7i5JUhWmdABANMb5QoP5srBy/sHOJBYCcvS
         17J4I1rJKfkOb9nLPjw1QNvUWjyYTjczzgonRnUTpGVdiPuwxtFp8aiAUNOeYJxB864d
         G+WtsXmbxgwJPP0U5OKMN0bN6V+ADjVEA55dXZ62Xh4aU/URpr5dDlAYsOuKySWoX/vX
         kdTQ==
X-Gm-Message-State: AOAM530Gfc2ZoDidK19rGG8XWYhfwqBhH75XTlrH19OnOi1KxpX2XvjR
        OPqFfVbvWpxxfYwYnCpIT+Dc0GtXBycv0STlcv0erUQA3oTT7AMMmJHjaQDOUcfndk/G4+hDRk3
        mBQIlB0zy9zAJuUIhytuVcBABgQMMi8V6rbfgNw2sV3dts802MWew6n90JeQ6Jg8=
X-Google-Smtp-Source: ABdhPJzcVPPRUt45oQWrGlnE/6fSfAxoeOuL9L8e2CajgCORaLLzh7dZ8SvY7ZHhnxk0ohWDJdzH/VHb/XZaDA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:192:b0:14f:ff7c:33db with SMTP id
 z18-20020a170903019200b0014fff7c33dbmr31987796plg.75.1646241707938; Wed, 02
 Mar 2022 09:21:47 -0800 (PST)
Date:   Wed,  2 Mar 2022 09:21:41 -0800
Message-Id: <20220302172144.2734258-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 0/3] KVM: arm64: selftests: Add edge cases tests for the arch timer
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new selftests that validates some edge cases related to the virtual
arch-timer, for example:
- timers above the max TVAL value.
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

Ricardo Koller (3):
  KVM: arm64: selftests: add timer_get_tval() lib function
  KVM: arm64: selftests: add arch_timer_edge_cases
  KVM: arm64: selftests: add edge cases tests into arch_timer_edge_cases

 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1179 +++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 4 files changed, 1198 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

-- 
2.35.1.574.g5d30c73bfb-goog

