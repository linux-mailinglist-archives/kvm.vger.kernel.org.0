Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA1F3A4B7B
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 01:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhFKX7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 19:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhFKX7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 19:59:34 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8438AC0613A2
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:57:25 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id o186-20020a37bec30000b02903aa376d30fdso16971212qkf.22
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=S0iOA4oBvcUglTmYnkZepeXKKGz0OH9ri/KggjqOTpQ=;
        b=axr71vLEIIZsyDujMQU1zA/lglNnSze2n8likCqyIW2v0luAE1BhQcT51TwUE9ewxn
         Nb1GQ6eHis+rgSc/T34LmDFYSqYBzzyG4vUXZJalmTm49c/29KfqefptivTzxjWuWtP5
         HUUbEJ01xOkN8k44LWG3hEvQCDBAQm8H2kQ7ts6prVKdnoi2vBmvmLhbHhheaNFo82wS
         Sv2oiYsnja2cNDmLvdGIeaedghtuKGFe1FgFoyQFGWp7ZE2EuKdtHcm0vfTlTwitsND5
         zFXRAMT+mxanLToyIBZxKxnw/7P1eq41F/bwmzmHvQ+7pAQ9whbIVq68i1CTPPNs+ae1
         pSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S0iOA4oBvcUglTmYnkZepeXKKGz0OH9ri/KggjqOTpQ=;
        b=OFUCd9s43E0joZvmX+Q2HqnXglFfL1n1zZORimAIOHGD+tewgxJz1ln6HIsbx5JyfV
         rvxQHBpKnM/mS6m/zNt7gSfxDmXh/MsWDiTimBtyLd2L24V/R5EZQR/xPnfLy3X5CiqY
         /whxuMDy0Q69i5guXTi123u9avDXgUsxRUfoMRtIaFZmWHhr/QgKdVEJSJAnwiCyRAQt
         h+HFzBudMz+NGq5Dq3+B0z7Hyw2O524HDiwbR2NPLP2YjT0W7tbLJYKepkxaY3NXgdYb
         uGMn88VGWZAsHEct8Ol3VWAqh0BPW7aa3nPjmL0kjmwpRnDtnE3hFiBe2U2Qy990X7Av
         4LLg==
X-Gm-Message-State: AOAM531wCFKH44Y5iqa69g36whBcqQfDS6MFHJTb8Pu5V6r2Oiyiibl5
        ScVFINoExZu9aI56pqzEWRn3Oyiu4uVuwLO4RNMUuFfMoQhQp2rgMJhl9uTDvNCPtVnzNtM+1px
        NFUGNxzVTbm7gjw2pS9bj6qo+wbP/N8X9XS5xqjpbZDWRj+acBbzjZH7gc9JNuU8=
X-Google-Smtp-Source: ABdhPJxgYhVRgoNp4qwsdEe2K3L+UboPcE13qD4dFU/aKCeD6stO3e80zJafhpVrEYfu5si/RttFB90YVKF4vQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6214:240b:: with SMTP id
 fv11mr7303097qvb.23.1623455843717; Fri, 11 Jun 2021 16:57:23 -0700 (PDT)
Date:   Fri, 11 Jun 2021 23:56:56 +0000
In-Reply-To: <20210611235701.3941724-1-dmatlack@google.com>
Message-Id: <20210611235701.3941724-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 3/8] KVM: x86/mmu: Fix use of enums in trace_fast_page_fault
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enum values have to be exported to userspace since the formatting is not
done in the kernel. Without doing this perf maps RET_PF_FIXED and
RET_PF_SPURIOUS to 0, which results in incorrect output:

  $ perf record -a -e kvmmmu:fast_page_fault --filter "ret==3" -- ./access_tracking_perf_test
  $ perf script | head -1
   [...] new 610006048d25877 spurious 0 fixed 0  <------ should be 1

Fix this by exporting the enum values to userspace with TRACE_DEFINE_ENUM.

Fixes: c4371c2a682e ("KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmutrace.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index e798489b56b5..669b1405c60d 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -244,6 +244,9 @@ TRACE_EVENT(
 		  __entry->access)
 );
 
+TRACE_DEFINE_ENUM(RET_PF_FIXED);
+TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
+
 TRACE_EVENT(
 	fast_page_fault,
 	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
-- 
2.32.0.272.g935e593368-goog

