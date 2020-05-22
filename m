Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684C41DE73D
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgEVMw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729946AbgEVMw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:27 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E6EC02A198
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:26 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id c12so6437754lfc.10
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+GYG0qSSXXWNbW6SjclZipkt2clARhTBGL72G1TzR+g=;
        b=i0Xow3WAyL0kpKfuXIdY3nsoVq7W+EV6oRNEhiS9/GqxAvqsfGsFEey4lDq1sbsAgR
         c2wOtAadryEu9FVsEyb1ufe/OZRu6HsI0zAsPfnJX9Cza8D1+FE0u0l9tdERa4Ih4Qn7
         fRUKi+BP4n4l/2k0Hne8Q33RiCfF5XEv1W2P9dxFOKQTZJRUJ0/vO6IRlqN1zBseWmfP
         8B17qjaBI3U81aZuJDuNQwNREoT4KhZYstsVtwwjfCtaska2sJP88wjLooXeBtpWQPjW
         0N9lRb6YrjPKdWl3ZP52L/8qV5vUTrMVgo4oObShrgOoEz+q8mEDmzi+0iTqjyjvzrfw
         41/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+GYG0qSSXXWNbW6SjclZipkt2clARhTBGL72G1TzR+g=;
        b=hDsmNsSrakdBhvm31mwNAhyHImOLvZScNecb577owB6e0Au39NOjZfi7DlqM6a4XjA
         aETPbGDDHBzSKouhx4a8fNFQKoz75k1FMMPtVptVS+iIRWJCO0/s6B3/OrvEZrCopY9M
         bjuXyT+F09aNkam6WaRtvvNytiL4FFx42aVSVnefh1lJqxueh/in61T+lgjv0jmecuZb
         MTd/AM9I7lcDIyd8ABw9H/kdf3wLH0TjZgl/jpnScnYu/UFfNSrY+TstIXTk/4xvRWKY
         8Alk+K9h3HmAmlenp6USfV7t5wyTGOExxVXQ60v1bGpfqMvya+kSqvOLOE4yYSHVuhbD
         wOgA==
X-Gm-Message-State: AOAM530TpaW/pXXtytEyhJs57IWinDEET+OAQkSCvwXUjCxcoh3FoXde
        7U2PabAg51Gh5V5Y/o+XRthMmw==
X-Google-Smtp-Source: ABdhPJycCB0b0poeoDUYOr547M1WglFr8iGoptYLIwiwPw+BjbaimdNLYbqeeMIrOC3lCpI+0PYUJQ==
X-Received: by 2002:a19:6b14:: with SMTP id d20mr1776578lfa.202.1590151945216;
        Fri, 22 May 2020 05:52:25 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id v28sm2405723lfd.35.2020.05.22.05.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 02FC710205A; Fri, 22 May 2020 15:52:20 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 12/16] x86/kvm: Share steal time page with host
Date:   Fri, 22 May 2020 15:52:10 +0300
Message-Id: <20200522125214.31348-13-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct kvm_steal_time is shared between guest and host. Mark it as
shared.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kernel/kvm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index f50d65df4412..b0f445796ed1 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -286,11 +286,15 @@ static void kvm_register_steal_time(void)
 {
 	int cpu = smp_processor_id();
 	struct kvm_steal_time *st = &per_cpu(steal_time, cpu);
+	unsigned long phys;
 
 	if (!has_steal_clock)
 		return;
 
-	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
+	phys = slow_virt_to_phys(st);
+	if (kvm_mem_protected())
+		kvm_hypercall2(KVM_HC_MEM_SHARE, phys >> PAGE_SHIFT, 1);
+	wrmsrl(MSR_KVM_STEAL_TIME, (phys | KVM_MSR_ENABLED));
 	pr_info("kvm-stealtime: cpu %d, msr %llx\n",
 		cpu, (unsigned long long) slow_virt_to_phys(st));
 }
-- 
2.26.2

