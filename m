Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3F45A52C8
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiH2RKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiH2RKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:10:52 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC405A80F
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:10:51 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id a12-20020a65604c000000b0042a8c1cc701so4271914pgp.1
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=2fgeUau+fesji7+UbXHLLRDfif1bUVoiY8cL8+NvcF0=;
        b=m6sZUE2FI2f8PC5MXscjA57qZcILIlnX5dM8oTNtAcyr2CoRmtNGMfmI7X+WMe8xrV
         IZDsIJ6kuocRikzOL9QC5Kx+ObeOJZE8BxywPDzZ0kl98CUrAFIOkOl9r1r3MKgICRd6
         SQ7Zt4oUVrP8ln2bgpWAGe5d/rkVM+pxE7tOdtTFRK5j35NNdX6DVM1ihkYZyOeQhOPR
         MwLn3Rsk+Hjd1sDm6VHHN6ZNiRITTfvUGh2ucxiw4rqJK4JSVShK/TdzepizJyBfnCxu
         +yj3vXGfcJJ03qwV4Gm3LgQzhXyizRaMmcJWai96DJtFwTjmX6pn0dN0Vn97uMner9X9
         3EGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=2fgeUau+fesji7+UbXHLLRDfif1bUVoiY8cL8+NvcF0=;
        b=xlrEbBPkIHaNf+XC6/CRwYGZdJ3rpi1SFUtfBM6li44rt/pzVEee8kxBiq321SOz5J
         SlqbBzH12nvxYUkzoiZRsTnuhfTU/74h9AS9JuesL44o8/nDsAjNTx/YuVKSzDDapl8m
         ILD3bESe1bZPiyQG32rg6mDo9HSlfmuJAzpAw6RlX84GpnlAv7pii3wUzKTwqYE4DApQ
         jND6EZHl7UCAI6GutakIFKgGVp3k5XE09YA1BdniHqW/0rivKADyZ7xx58jyjHGegx3M
         Pz4uBhB41s7r8WjAhypMp944ewSWBfq7yW2qHjRnrh4iKfoqQcqnI7KGEQKlN6Q/+uuE
         S39w==
X-Gm-Message-State: ACgBeo3lzLwQoss3ZugJZrnWoCWXVjLCr4TpdJcH1JuG+p3JtWK1mNza
        MMXcZ60gKOPbCTyqgL4lH5Np+7trhcFCeESeeojrYIyEneMQ9TqOsRIqlWC2ObPuNDjqo1dEGjO
        FRTxkKYS4aZgpNk+8flII1fXA3eE1+720zz7hZXOUUxcB19rAgRjg8fiq+w==
X-Google-Smtp-Source: AA6agR6SCuM1d6i6LVN7Nb7qMG6UiYIsQWlP/qXOAwfNi2xwy8t0Ruc+3Ed9ygkvLJth3FmuUbpkx7EBXJI=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:cddb:77a7:c55e:a7a2])
 (user=pgonda job=sendgmr) by 2002:a63:3c7:0:b0:42b:9220:a3c8 with SMTP id
 190-20020a6303c7000000b0042b9220a3c8mr10924499pgd.366.1661793050510; Mon, 29
 Aug 2022 10:10:50 -0700 (PDT)
Date:   Mon, 29 Aug 2022 10:10:13 -0700
Message-Id: <20220829171021.701198-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Subject: [V4 0/8] KVM: selftests: Add simple SEV test
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series continues the work Michael Roth has done in supporting
SEV guests in selftests. It continues on top of the work Sean
Christopherson has sent to support ucalls from SEV guests. Along with a
very simple version of the SEV selftests Michael originally proposed.

V4
 * Rebase ontop of seanjc@'s latest Ucall Pool series:
   https://lore.kernel.org/linux-arm-kernel/20220825232522.3997340-8-seanjc@google.com/
 * Fix up review comments from seanjc
 * Switch authorship on 2 patches because of significant changes, added
 * Michael as suggested-by or originally-by.

V3
 * Addressed more of andrew.jones@ in ucall patches.
 * Fix build in non-x86 archs.

V2
 * Dropped RFC tag
 * Correctly separated Sean's ucall patches into 2 as originally
   intended.
 * Addressed andrew.jones@ in ucall patches.
 * Fixed ucall pool usage to work for other archs

V1
 * https://lore.kernel.org/all/20220715192956.1873315-1-pgonda@google.com/

Michael Roth (5):
  KVM: selftests: move vm_phy_pages_alloc() earlier in file
  KVM: selftests: sparsebit: add const where appropriate
  KVM: selftests: add hooks for managing encrypted guest memory
  KVM: selftests: handle encryption bits in page tables
  KVM: selftests: add support for encrypted vm_vaddr_* allocations

Peter Gonda (3):
  KVM: selftests: add library for creating/interacting with SEV guests
  KVM: selftests: Update ucall pool to allocate from shared memory
  KVM: selftests: Add simple sev vm testing

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/include/kvm_util_base.h     |  23 ++
 .../testing/selftests/kvm/include/sparsebit.h |  36 +--
 .../selftests/kvm/include/x86_64/sev.h        |  47 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 267 +++++++++++++-----
 tools/testing/selftests/kvm/lib/sparsebit.c   |  48 ++--
 .../testing/selftests/kvm/lib/ucall_common.c  |   2 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  15 +-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 232 +++++++++++++++
 .../selftests/kvm/x86_64/sev_all_boot_test.c  | 127 +++++++++
 11 files changed, 674 insertions(+), 126 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

-- 
2.37.2.672.g94769d06f0-goog

