Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C95C74FB9B
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 01:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjGKXBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 19:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjGKXBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 19:01:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB71E60
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8ad356f6fso64574975ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689116495; x=1691708495;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ArFj1o9NSdPQxx1m9ygKjSQno20NdD8JCdPYTouZybg=;
        b=x3HRX0SKKbx4+NkpXEbDDUTRypVaGi5VgoGmKzAPfyHkaq+gWEOmJea0l+ewoaRCoI
         MO0KeNEAbjAVDfwPZsGrevdQcfi1D23vyyqcKUfZ9uuB1Mp1DpNJFiM+rupUsres0QDw
         U4GVVXSxS1rEzthJHabrf1jVkEVc4hMyLnCLHC/qrZZly88AWh0Fn5bPdfV14ch1ap1q
         M0LOUGuRRtXHH0IHWpipEXuSwvQDCv9+aMUrqtrbEc9ijPXBDT4lPCc8NzGyjtxQIFrZ
         M2q4eqVEWBtxTQBkSW96Zv56mj0cnwERzxiQ/8KWp0+vM9060eSDFwE2f7jzcQj9c8xl
         oj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689116495; x=1691708495;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ArFj1o9NSdPQxx1m9ygKjSQno20NdD8JCdPYTouZybg=;
        b=CNVRITVWGhlnxkQTTQgZjkh9dhDMVS3R5Q/06ddNApuLaUzijU/5noBuP3EmM7dtSC
         Q4ElnK4IipUid4OfSrf1OIhfOPIQwiD0UK+oXnChjfxgJLZ6GP+47keARQ6nlZjOhViN
         jTVU1rb0vLK6im/AFP6B0gSUeCh1vjO5Y57Yaa8LhCEWaaeu8fvyefp0NHz261tNBrJR
         Nsxm1Jha55njwHn0KwIOEl6nVRVRWOS5TMECuK2FoijFLnk4Ll647E/YPVVsdPi8HmMA
         6sH9QlZXtOVqfXWA+b4E8WGGPvRuIYqH6PJjksAZvqBj5iIBtEXY8YVgX/vFvl5KkH5f
         ZRKw==
X-Gm-Message-State: ABy/qLbfhu1EQzIbKBWZ0L8idKw3WEaZZHVnIG7ZQQme46JzFCtlL/4m
        fvaW1SNrnmofEhsAOZiuwuTraZwbJUY=
X-Google-Smtp-Source: APBJJlEnsGjdY86SpJV8AfP5O0Y+w0eDh5v2W1Ha3ueE6ESzD8l1xlfCwxQzysRlxUoU47FTo8Gi3Z0O4EQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa09:b0:1b8:95fc:d0f with SMTP id
 be9-20020a170902aa0900b001b895fc0d0fmr12256129plb.7.1689116494750; Tue, 11
 Jul 2023 16:01:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Jul 2023 16:01:24 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711230131.648752-1-seanjc@google.com>
Subject: [PATCH 0/7] KVM: Grab KVM references for stats fds
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Zhang <zheng.zhang@email.ucr.edu>,
        Kees Cook <keescook@chromium.org>,
        Sean Christopherson <seanjc@google.com>
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

Grab a reference to the VM when handing a userspace stats fds for VMs and
vCPUs to ensure the stats files don't outlive the VM and its vCPUs, and add
a regression testcase in selftests.

Sean Christopherson (7):
  KVM: Grab a reference to KVM for VM and vCPU stats file descriptors
  KVM: selftests: Use pread() to read binary stats header
  KVM: selftests: Clean up stats fd in common stats_test() helper
  KVM: selftests: Explicitly free vcpus array in binary stats test
  KVM: selftests: Verify userspace can create "redundant" binary stats
    files
  KVM: selftests: Verify stats fd can be dup()'d and read
  KVM: selftests: Verify stats fd is usable after VM fd has been closed

 .../selftests/kvm/include/kvm_util_base.h     |  6 +-
 .../selftests/kvm/kvm_binary_stats_test.c     | 72 ++++++++++++-------
 virt/kvm/kvm_main.c                           | 24 +++++++
 3 files changed, 75 insertions(+), 27 deletions(-)


base-commit: 255006adb3da71bb75c334453786df781b415f54
-- 
2.41.0.255.g8b1d071c50-goog

