Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227297AA101
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjIUU4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjIUU4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:56:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AED4220
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:52 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81c39acfd9so1818961276.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328432; x=1695933232; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e5f7fcNoXL+epp7GM6J6bVKjQgaoLneVTY2X9JXuWRg=;
        b=GmDzyG/T9FWlGLQM/yDebSC/pppt1SFf7DlQnd4YxYIs07qbm4BTIZ639qV8gbbs7m
         lvzy1Im+3ZCMr0BYirajSwh0nz1LQsDB+qBczOshuKJJTrW8v+m5dqWH6ydd6J4IsUBy
         op4+RPEpviqCWD7wI8xCeErcmwwXFqsXWw82wRucspQNalR9y6bXfZtfOqKq0He2I9W9
         tkM3wU02+d859sXtpBPWNCQL8tMAPwoebZsdiepkA3c2K+5RptmQ01vQZ/7AJblzIs2G
         BgCUMbOSvDmNMUaSExgE1x/nVOG5u7IhPgaDLCy7Ha7iVDEfv+9eeIB0VRps/qwAnfmQ
         Pf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328432; x=1695933232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e5f7fcNoXL+epp7GM6J6bVKjQgaoLneVTY2X9JXuWRg=;
        b=JtXn2A2ELj7w/1/89f2abRDqzk8GOfNRBl5zj+SGfAwcLeclwnjz+jmhnKF4hZ1aFZ
         eGXbqfBQlJGnrrooAejkv6zz+mSIorlCOy/tN2Y5JEF5NWjdfRn33mgbXOuBvZbN+YUu
         /GiCkycSCIkOiatUqFD8U12fja59y4DfVY0JUorX/u+xQB7/wmpspPGuRUfjVYH2HCZN
         fX+nKhaeaZ/mnHK5Wiwq/iI6ybuqqQCABm3stNJD4jNedvmQQxAbiohhO82kwzYRmYB0
         +pzBq5NsewWPRKPx7JqdgjiiFroCEf7soY4LogPXls7SYdu9XClDFTS4HtQE0HgE0kKp
         J70A==
X-Gm-Message-State: AOJu0YysNbFixrRdzV8NXjME256JQ+HLHGMhuYXkhNNj0dTvXrHSTXDI
        5L0cvbTrFI+OslBME/oWQqVj2stqy6k=
X-Google-Smtp-Source: AGHT+IE3ligRVXMNx7Ai6SVYOMLzKH9iL3vgDfzERbbEOnY3rAREZhYCuKUZj1rP+ggkOD4exEVe8RniJ6M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce8b:0:b0:d81:503e:2824 with SMTP id
 x133-20020a25ce8b000000b00d81503e2824mr82196ybe.10.1695328432076; Thu, 21 Sep
 2023 13:33:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:27 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-11-seanjc@google.com>
Subject: [PATCH 10/13] KVM: x86/mmu: Drop repeated add() of to-be-invalidated range
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_unmap_gfn_range() instead of kvm_mmu_unmap_gfn_range() when
handling memory attribute ranges now that common KVM adds the target range
to the invalidation set, i.e. calls kvm_mmu_invalidate_range_add() before
invoking the arch callback.

Fixes: dcde045383f3 ("KVM: x86/mmu: Handle page fault for private memory")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aa67d9d6fcf8..bcb812a7f563 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7272,7 +7272,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
-	return kvm_mmu_unmap_gfn_range(kvm, range);
+	return kvm_unmap_gfn_range(kvm, range);
 }
 
 static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-- 
2.42.0.515.g380fc7ccd1-goog

