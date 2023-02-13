Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69B9695307
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 22:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjBMV3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 16:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjBMV2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 16:28:55 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE03421A19
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 13:28:49 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4cddba76f55so140679947b3.23
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 13:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eXOpCy7WQU4/t43czVVLKM4cSSkIhfZyO3oxZlTPVvA=;
        b=Dmv5QhdBYtbVdFpBp2g5PalnHfEkMeEnsfZi0JBA/N2aZdKT8NBTaOBECSTU8Vs9ka
         TGJY6oLYVCR7Gg65i4HaVIocDIp4tRgyRA9/u5Cng5xH4umpybz3WF5eZK5hDPNy7mWW
         gqvZ+Q9+D9LfAVJdyJ3n0D1QhC6gy569Iu6exXMCvTT6sT9uXvrIDQCZJ5y+0ZQ8KQd5
         0ofkEPhjL0d8sDQBUX62QKISazn4PR5i8B6Dcbo88SfYhWf67oBrO0Pd1Y36b9jVAvSv
         m5YynJG2SzutUk9UpFKc6EQT8WO5eNroeBQuIZIBLc6p7x77woupZmlLjNZZP609nb9x
         0zPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eXOpCy7WQU4/t43czVVLKM4cSSkIhfZyO3oxZlTPVvA=;
        b=qaGSdJ/S2M9PEZDHi5BAlgHhrxCqjicnta1WcnDGcEH7Haj/H0FMfZU+hwM8/qIGmF
         HdDLo5Obb+ovZnbmGpfnBPv9RZ5bOFV6G4TOBZNuraUiL93iIn9wya4nUVWPhmCFUDMB
         DpcbK2R56FeG5M6ZbToKCqoRgyaPWTLwQXoc2OqtzEnqqUJ9liauJbNMKVhT6mls5WX5
         /seVRAYbWu+3vY0CmG8wTgnU2AdajSKwURlHioO+mUMYIy0dtlb31svNGx+Yg0oGxypV
         yEUzBCt8grmpExotNVIjDe25bvZLlC/pCA7c3bGM/qtXgLM8tJvULT6ZJz+vyI8ZXJOW
         RiTg==
X-Gm-Message-State: AO0yUKVL5YC2GH0kwmRB6be/tdY7JY3J4m34lsBJKCB989Zc6QPVjAQd
        dB1mETmiZeL5HU1jLMBLh7klxKPCT7dQcg==
X-Google-Smtp-Source: AK7set9nP0u+FDyoUa3wldou5a2ZkCMcGjn+muNYb1JfzxKX048ym1Sh1brJWucN/BLMBZmcWt9nCUGF796VEQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:e9c1:0:b0:514:a90f:10ea with SMTP id
 s184-20020a0de9c1000000b00514a90f10eamr2750928ywe.316.1676323729097; Mon, 13
 Feb 2023 13:28:49 -0800 (PST)
Date:   Mon, 13 Feb 2023 13:28:44 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213212844.3062733-1-dmatlack@google.com>
Subject: [PATCH] KVM: x86/mmu: Make @tdp_mmu_allowed static
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make @tdp_mmu_allowed static since it is only ever used within
arch/x86/kvm/mmu/mmu.c.

Link: https://lore.kernel.org/kvm/202302072055.odjDVd5V-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aeb240b339f5..adb9438be3ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -100,7 +100,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  */
 bool tdp_enabled = false;
 
-bool __ro_after_init tdp_mmu_allowed;
+static bool __ro_after_init tdp_mmu_allowed;
 
 #ifdef CONFIG_X86_64
 bool __read_mostly tdp_mmu_enabled = true;

base-commit: f15a87c006901e02727bf8ac75b0251cdf8e0ecc
-- 
2.39.1.581.gbfd45094c4-goog

