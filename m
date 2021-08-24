Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A043F6885
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 19:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241017AbhHXSAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 14:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240935AbhHXR76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 13:59:58 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38607C08ED8B;
        Tue, 24 Aug 2021 10:40:30 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w68so19006166pfd.0;
        Tue, 24 Aug 2021 10:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w/ArGHeLEE7U3heuTr2jTkUenyA8yIadcyI1Uv6vrXA=;
        b=IL0wSuVJdS4m3gMpdTktRGE8yE7NOEXL6sMpQtgAC0zn/7pyD4eav1ieFD+pbj/K9J
         DPBZHLsUKeBd2p3ttM0AwmnOUQk5f3QUm+Yzg2Gg3cii4J21LN0Ofj/0kqnK+y3nTzHU
         dhCI5KOtxkADpuV9AIn73KvPzPlsauztocDJ0pw9W+E2ZN5zl9wYjhHFjZZ3tUaBOnlU
         Cg/AOvRthPx5NaqF6cq+iZoqK0FY0ElulnLj4WX96Z9tuVXzgkX2RNjsGU1lQ2kL9wzS
         BCKizsZbS3uPnqTpy21rrnhJmdhrBh+AD+hatnRxW4UQyl0ZJqq3rxTSzNh9yVvBE4gz
         bcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w/ArGHeLEE7U3heuTr2jTkUenyA8yIadcyI1Uv6vrXA=;
        b=VnsdOvEMnPyxeD2iFvn/H8jdk2caFvBHLdh9QLOR0Nr97MDLZ2hbgQvUEMjd0vq75L
         9JIVLogpY7q6wBhItiAfO8p34NuGTUfBCzZv4kXalBr10LqyccDwgo07p0AuXEsauMOi
         jzwEplpjnkeZ7ABwAYd+ahZ0hlWM5q6RDg0EtTvmpfSsxVZsFuCzPp64Be02CWuX8l/N
         5E0AXo61Z13giAnI2e7oQlFUEHlI3wUEyUbXhzbCG1AdtZwkuMc8cLZXQpfZGrQixQYs
         5gyI4uqKrGGlZbj922DuteUHIdfvyt1aKKYhrSK8bIMUZ2ye+Mu9eeJaDo198gvZRwdZ
         oCEQ==
X-Gm-Message-State: AOAM533uu8N59xdGWTGYtnBJvFBbJnSSb/SRP3j6ARH2lJg0NrmjCflR
        DaBgKYt/hRIkmDHyUjgxqrlYMYVIU/M=
X-Google-Smtp-Source: ABdhPJy/knetC2Ufm9M17OLqgJBugppJkqoDyRCF6EJ5OjqEDNRUuroDGFW2tyx1RppN9xt6W8dJGA==
X-Received: by 2002:a05:6a00:9a6:b0:3e1:656c:da81 with SMTP id u38-20020a056a0009a600b003e1656cda81mr39726847pfg.26.1629826829647;
        Tue, 24 Aug 2021 10:40:29 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id d22sm3183619pjw.38.2021.08.24.10.40.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 10:40:29 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 1/7] KVM: X86: Fix missed remote tlb flush in rmap_write_protect()
Date:   Tue, 24 Aug 2021 15:55:17 +0800
Message-Id: <20210824075524.3354-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210824075524.3354-1-jiangshanlai@gmail.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When kvm->tlbs_dirty > 0, some rmaps might have been deleted
without flushing tlb remotely after kvm_sync_page().  If @gfn
was writable before and it's rmaps was deleted in kvm_sync_page(),
we need to flush tlb too even if __rmap_write_protect() doesn't
request it.

Fixes: 4731d4c7a077 ("KVM: MMU: out of sync shadow core")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4853c033e6ce..313918df1a10 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1420,6 +1420,14 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 			rmap_head = gfn_to_rmap(gfn, i, slot);
 			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 		}
+		/*
+		 * When kvm->tlbs_dirty > 0, some rmaps might have been deleted
+		 * without flushing tlb remotely after kvm_sync_page().  If @gfn
+		 * was writable before and it's rmaps was deleted in kvm_sync_page(),
+		 * we need to flush tlb too.
+		 */
+		if (min_level == PG_LEVEL_4K && kvm->tlbs_dirty)
+			write_protected = true;
 	}
 
 	if (is_tdp_mmu_enabled(kvm))
@@ -5733,6 +5741,14 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 					  start_level, KVM_MAX_HUGEPAGE_LEVEL,
 					  false);
+		/*
+		 * When kvm->tlbs_dirty > 0, some rmaps might have been deleted
+		 * without flushing tlb remotely after kvm_sync_page().  If @gfn
+		 * was writable before and it's rmaps was deleted in kvm_sync_page(),
+		 * we need to flush tlb too.
+		 */
+		if (start_level == PG_LEVEL_4K && kvm->tlbs_dirty)
+			flush = true;
 		write_unlock(&kvm->mmu_lock);
 	}
 
-- 
2.19.1.6.gb485710b

