Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F048E787D89
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240719AbjHYCIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 22:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240846AbjHYCHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 22:07:40 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422ABE66
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:07:39 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c091a563ecso6132795ad.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692929258; x=1693534058;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ij7IJ9LeENVlJByi4z/6QrJLTj5aVJhs6LLV7CfHy1E=;
        b=nZY/HsLnBnVzySI5bwR83jGtbGyAfr52IW7zOyBFfiKpVXDzCz66LOicUFzYv7+pjp
         npFN6/fXfHEsdYPRvxhmAcBXuKa8iMXGOKHemw0KdIlsqkkXiLnSXXDcDnZYdVuZBLGS
         VI9bK5XLqVYp/wn87KYxY8dZhSkVnavD8mDxyzgLdYXe9GpF4ZoD3Lzx/8GjB9V/sZ1W
         6+l3YikZuyH3kyvhGw7m6g/eEjc/Lnb8+7T85xgUkVWlGeps+Q24Rl77dCIiUQkElMJF
         RlxuicGUGppQCuBWcsHPVz/467/laIGeNy3RpNIa4jqIQ4JH5NK4hyDm31oi/CweNAvt
         ZAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692929258; x=1693534058;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ij7IJ9LeENVlJByi4z/6QrJLTj5aVJhs6LLV7CfHy1E=;
        b=IHhqZCAR/LGDDz8bGkCQe8YroF2FbfLNYmrJnlZo0p5RdbZU2RMVWb+a+6CCsR+TwO
         s/lZThUKPxHw75uY3kf2mM1HIdjBATCPp0dUf+LLg+2BTK2komVNSJAB6ifURrSWqgeO
         8NpiNvkmyNiLta2Yn5vVJmp+TdfC1FqBxwYsbybj49YxRb5fPt4yQvehzEBdDfTT4SEr
         sPnZ4Wpw6C9EJ0jSIApuBpJG7QvFcDOJWhI8nAzwQK0b3IK/gf5BZt/93+yjP9S+a1li
         WwtYz6wW2GQ+wtwGxjt4Ml8ixendDmgxhc6Smk/MMT1YcQ37nKlztJN8YsPXz0vmC+qU
         Z4aQ==
X-Gm-Message-State: AOJu0Yx+TjLi6RM4wwhxh1NN9hUzlkDw/FEhH68b1ZwjKPDC446dstj0
        +Zb7fAdPG53oftm3HVfWrr98vBQBtr0=
X-Google-Smtp-Source: AGHT+IF7loOUbycshuEEvy226/Q/37wCJDPtRBqLjjJlP1CdSVcxR8XOuDqm3RnPk2MjhQ3dFwEeCkRrGno=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f203:b0:1bc:e6a:205e with SMTP id
 m3-20020a170902f20300b001bc0e6a205emr6177096plc.5.1692929258615; Thu, 24 Aug
 2023 19:07:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Aug 2023 19:07:33 -0700
In-Reply-To: <20230825020733.2849862-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825020733.2849862-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230825020733.2849862-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
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

Retry page faults without acquiring mmu_lock if the resolved hva is covered
by an active invalidation.  Contending for mmu_lock is especially
problematic on preemptible kernels as the mmu_notifier invalidation task
will yield mmu_lock (see rwlock_needbreak()), delay the in-progress
invalidation, and ultimately increase the latency of resolving the page
fault.  And in the worst case scenario, yielding will be accompanied by a
remote TLB flush, e.g. if the invalidation covers a large range of memory
and vCPUs are accessing addresses that were already zapped.

Alternatively, the yielding issue could be mitigated by teaching KVM's MMU
iterators to perform more work before yielding, but that wouldn't solve
the lock contention and would negatively affect scenarios where a vCPU is
trying to fault in an address that is NOT covered by the in-progress
invalidation.

Reported-by: Yan Zhao <yan.y.zhao@intel.com>
Closes: https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1a5a1e7d1eb7..8e2e07ed1a1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4334,6 +4334,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (unlikely(!fault->slot))
 		return kvm_handle_noslot_fault(vcpu, fault, access);
 
+	if (mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva))
+		return RET_PF_RETRY;
+
 	return RET_PF_CONTINUE;
 }
 
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

