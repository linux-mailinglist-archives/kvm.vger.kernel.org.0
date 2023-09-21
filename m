Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0A77AA0F9
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjIUU4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbjIUU4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:56:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AD38F489
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:34 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5789f2f13fcso1074969a12.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328414; x=1695933214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVkSv5USYfxh1iDKrRIotw/ScBvVaPg/YoEhVNrkyyk=;
        b=j64uyZccEnShlAdgH+z/yCrEhNjhDPvwwhYoXxMvkQGQdf6M+ByvuT15KHoe3NDF5A
         EfQgD11auZHJRt3TUKYuF+9SN7tewsr8s3lKv2SIHThBChosMQEQf3kLeT2AI8sQuq2F
         C2W8NaYsomfUsEobNW/762TT3jgw1SW9bV5UO3NIO8W+aTOHgw+pY3DaoVfEGT1todQi
         fyJLultWhqhG13EnC5c/eFwCSTbmgmvZVYgnIX8/qCadHg/QHLl6zMgyB5gEUzg+FY13
         LQY15dn3MXrwtxpKrhUgOulX4zaLZoETz/HMlk9cKgOR6qSCsFSmVM1AbSJ//qBJgg32
         TJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328414; x=1695933214;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVkSv5USYfxh1iDKrRIotw/ScBvVaPg/YoEhVNrkyyk=;
        b=EWHnxBiWFvfOSlLT4f0CGceM57Zr12GYAYnEWpUtT9n7JrQJYsM7yKsYShtptTEob0
         txjvIoRccCjXCKZ7VHNwMJOYZR0opfxKRIOK6kHyk6Zk2mY314FjkrhsnUTY9lrXm6h2
         fH+kS67WdJ05AgS2Th/WipQ2NfHA+X6FzF+hlpCvmXzUemh8ugfwFUBRflOJMw6SKOF7
         coK29eYiH4KsxF8FhvQqvdFm7DJe/jRnyF8lzWWVD6xeafBHlO/9xQslW4BCO2HLjIe+
         H0CeGMx6o2KnPEnn6aH2DFgvKMThoWPuSZ7ojBHSDB9OkzaTxDDkej1NBLh8MNE+rMcn
         gz5g==
X-Gm-Message-State: AOJu0Yz2FDgLg8JQGWxgCP4X2ZWnSbe6ndC47l9el/vKU0myX+qGKev2
        BJeJdenAfIF2es8aiXPAQHzls3DdpNM=
X-Google-Smtp-Source: AGHT+IHYFIuc9zqyHxB81MZBEcRhKGKtq8Fpu2bgHAXxJfzHlFxcNfobP06GPEJ6dPoFhdY2/yLVWW0ytIo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88b:b0:1b8:80c9:a98e with SMTP id
 w11-20020a170902e88b00b001b880c9a98emr81106plg.13.1695328414013; Thu, 21 Sep
 2023 13:33:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:17 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-1-seanjc@google.com>
Subject: [PATCH 00/13] KVM: guest_memfd fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a variety of bugs in the guest_memfd series, almost all of which are
my fault, and add assertions and testcases to detect future regressions.

The last patch, renaming guest_mem.c to guest_memfd.c, is obviously not a
bug fix, I included it here so that if we want to go with guest_memfd.c,
squashing everything will be straightforward.

Note, the truncate fix and test conflicts with Isaku's series[*].  My
fix is more correct (knock wood), and my test is slightly more comprehensive
(though arguably not really all that more interesting).

Note #2, this is based on kvm-x86/guest_memfd, to which I force-pushed v12.

Note #3, the patches are organized so that they can be squashed with their
Fixes, i.e. the splits are more than a bit odd in some places.

[*] https://lore.kernel.org/all/cover.1695327124.git.isaku.yamahata@intel.com

Sean Christopherson (13):
  KVM: Assert that mmu_invalidate_in_progress *never* goes negative
  KVM: Actually truncate the inode when doing PUNCH_HOLE for guest_memfd
  KVM: WARN if *any* MMU invalidation sequence doesn't add a range
  KVM: WARN if there are danging MMU invalidations at VM destruction
  KVM: Fix MMU invalidation bookkeeping in guest_memfd
  KVM: Disallow hugepages for incompatible gmem bindings, but let 'em
    succeed
  KVM: x86/mmu: Track PRIVATE impact on hugepage mappings for all
    memslots
  KVM: x86/mmu: Zap shared-only memslots when private attribute changes
  KVM: Always add relevant ranges to invalidation set when changing
    attributes
  KVM: x86/mmu: Drop repeated add() of to-be-invalidated range
  KVM: selftests: Refactor private mem conversions to prep for
    punch_hole test
  KVM: selftests: Add a "pure" PUNCH_HOLE on guest_memfd testcase
  KVM: Rename guest_mem.c to guest_memfd.c

 arch/x86/kvm/mmu/mmu.c                        |  25 ++--
 .../kvm/x86_64/private_mem_conversions_test.c | 112 ++++++++++++++----
 virt/kvm/Makefile.kvm                         |   2 +-
 virt/kvm/{guest_mem.c => guest_memfd.c}       |  84 +++++++------
 virt/kvm/kvm_main.c                           |  40 +++++--
 5 files changed, 184 insertions(+), 79 deletions(-)
 rename virt/kvm/{guest_mem.c => guest_memfd.c} (92%)


base-commit: 7af66fbd6d89b159acc359895449b5940b6e4fdb
-- 
2.42.0.515.g380fc7ccd1-goog

