Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC225153DA
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380084AbiD2SnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380079AbiD2SnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:43:10 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BABCD64D3
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:52 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id mm2-20020a17090b358200b001bf529127dfso4423758pjb.6
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vX0LiIlEVdgzV2l+bjk1F0pjD+Z7yYfTJycwcaaWHm0=;
        b=J5pA4KS9iUHgNTgxm1NA4hWaWB+XUrv/1vLWiWpfDmJfXjQEzIE+NYB1ED9reknwB/
         WaMrDqPjUt7w5vUvOi+UMxi+httAOBrEakCKV/nVRJj6CVluz7Us4Fx+d7KlTrzOsOAV
         6bcOZlcMuinmqE/++n6MNXVqDEkNUNhZjvIcHvR0HxH2HLzJorBzDvALO9YtISVG7Hhu
         0dVZYPZuBfsaXHVmj+9WUX3M7Iz6N986+2vjXbOfTmDU8ltTULaRYwXXef5X2HnbfQZ8
         1B5TJr7XnyDq1nstjE6sj0BcbX6vDtD4tfZvBWf+Roae5TihoKB0blrSvHj29oTbhKBD
         eLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vX0LiIlEVdgzV2l+bjk1F0pjD+Z7yYfTJycwcaaWHm0=;
        b=MZXaH+qzVriDEaeVaoLEnsnEm+ewq/iiA3auFseMWbrZBdd7uTzlhNJrfLOyx93Vdu
         eg0+qP57dkBdldasakNLnv7DKPp1ZUy+LTkQvflXEKk1ujBlSdfKJcG3fIPgMAFU/U1y
         rCAsXMadEyDNRdauZGdHVa3by+BHdzohNyZc+NiQtNYqGsyhKEUe81GEUeTaYXkJYY+B
         wGuR0AFxkcAmF/4qp0oHv8ewpviyrDcLq2Gs3Kh7D19yT/1MO2UcLNbeQIh5Eel1IIT1
         umm/7TQhRSzy3+ZMKfanDoV37+kko1zhlo9atx0HIQR7wGGir+/0c2k+Xv085CtQ/4dn
         zVzw==
X-Gm-Message-State: AOAM532tO9a4IoY485ernS7s9hfxK9p47eUcRwoOz9St4bATUcadT4/K
        BcdEvWpMgblAEDT6h+ORxTSxeOp0sVJLog==
X-Google-Smtp-Source: ABdhPJyzmzd8Apv913MJngKeZqQgg7C9oVD1UkwShw8U2wjNitFwL/lMJnITRL7YWkM7ZxlgC9ItF+0ZZLCqWA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:8f45:0:b0:398:d78:142f with SMTP id
 r5-20020a638f45000000b003980d78142fmr584412pgn.162.1651257591510; Fri, 29 Apr
 2022 11:39:51 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:39:31 +0000
In-Reply-To: <20220429183935.1094599-1-dmatlack@google.com>
Message-Id: <20220429183935.1094599-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 5/9] KVM: selftests: Move VMX_EPT_VPID_CAP_AD_BITS to vmx.h
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

This is a VMX-related macro so move it to vmx.h. While here, open code
the mask like the rest of the VMX bitmask macros.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 3 ---
 tools/testing/selftests/kvm/include/x86_64/vmx.h       | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index b512f9f508ae..5a8854e85b8f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -488,9 +488,6 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 #define X86_CR0_CD          (1UL<<30) /* Cache Disable */
 #define X86_CR0_PG          (1UL<<31) /* Paging */
 
-/* VMX_EPT_VPID_CAP bits */
-#define VMX_EPT_VPID_CAP_AD_BITS       (1ULL << 21)
-
 #define XSTATE_XTILE_CFG_BIT		17
 #define XSTATE_XTILE_DATA_BIT		18
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 583ceb0d1457..3b1794baa97c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -96,6 +96,8 @@
 #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
 #define VMX_MISC_SAVE_EFER_LMA			0x00000020
 
+#define VMX_EPT_VPID_CAP_AD_BITS		0x00200000
+
 #define EXIT_REASON_FAILED_VMENTRY	0x80000000
 #define EXIT_REASON_EXCEPTION_NMI	0
 #define EXIT_REASON_EXTERNAL_INTERRUPT	1
-- 
2.36.0.464.gb9c8b46e94-goog

