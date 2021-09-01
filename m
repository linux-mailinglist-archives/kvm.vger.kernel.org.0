Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E2D3FE550
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 00:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344957AbhIAWLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344720AbhIAWL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:11:29 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4248C061764
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 15:10:31 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h10-20020a05620a284a00b003d30e8c8cb5so989796qkp.11
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 15:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ijYiSiDDUHb3AX8DewnNIKO+XanSVwO3pukxO/BIptQ=;
        b=PIaib/UOcr8eqZtZtxH8TsMegPAAIPuTuFSHWDsKDNgXUi7HFb111cDWFixwg+vn1J
         yH74Vi9zPrwcpnOM43NTlCWphRUYs+X/VVstAxnZiwKv4NsgZfd9xfyjSJC3BVWcNh/U
         noBXYMev1g/hIMm/41n9iutstqp5C2xv5Wghy3hlSw4LTKbPGzKVcc9BZFoa0m/SHIoc
         12G6Qcgpj3u+u98e9mxUxsv+OROUxDU66XjMab7LzGXJTM8BjftTDUTVC8G1PjwQu9MO
         oSAGWoQG7lJ6bdQai/CvUlZ4DeUvaSmXE4XBWesj8P8Pq94P0rJcROPOyrFQDKFhqvXC
         zEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ijYiSiDDUHb3AX8DewnNIKO+XanSVwO3pukxO/BIptQ=;
        b=eqKpFJZP2wPA1okylXc3LueXYwceDxr0KHFvmnQZqSLllb+PrBvLC6Y80yMEapwDv7
         HGy5Vml2otG7qPyc2Y23WQuUw+ePr99taUrbowO5O2xFU9naElSEm4qxtxgg9heRze/8
         9mIDOXEx3KEoph8TzUEOY0hPnFCgL/g9jpVkh6YgwpynIbVAC0aUd9oYi+0JsyNao0zP
         rAPu5gId0GB2v/bnjvguqETD/8JWAWHcQDVvs81rhkgQjDcfTj8kjLZlvfmYSDDEGnoD
         uY55SAsBeYEE8at4zlxOOlJhvl/W6m42oXhGUaNxGyKGBUyJziajnNy1g2V29u7iDnkN
         L4lw==
X-Gm-Message-State: AOAM533ynljKsKL7l/rs+5jYBHr102oT+wISxIgoSV39M9s34CL8tKuF
        /qZUaEyt31Rva83/5Q87DIv+TnctDkU=
X-Google-Smtp-Source: ABdhPJwhT9bVSOgLzaDSDP/gOkZ1+NUgU5lq9FeD0s0kVgkw4RiNzBPbJEp0bal8001VwUfDiAQcmnRMmgM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:9935:5a5e:c7b6:e649])
 (user=seanjc job=sendgmr) by 2002:a0c:e910:: with SMTP id a16mr1602642qvo.37.1630534230980;
 Wed, 01 Sep 2021 15:10:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  1 Sep 2021 15:10:22 -0700
In-Reply-To: <20210901221023.1303578-1-seanjc@google.com>
Message-Id: <20210901221023.1303578-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210901221023.1303578-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 2/3] KVM: x86/mmu: Relocate kvm_mmu_page.tdp_mmu_page for
 better cache locality
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia He <justin.he@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move "tdp_mmu_page" into the 1-byte void left by the recently removed
"mmio_cached" so that it resides in the first 64 bytes of kvm_mmu_page,
i.e. in the same cache line as the most commonly accessed fields.

Don't bother wrapping tdp_mmu_page in CONFIG_X86_64, including the field in
32-bit builds doesn't affect the size of kvm_mmu_page, and a future patch
can always wrap the field in the unlikely event KVM gains a 1-byte flag
that is 32-bit specific.

Note, the size of kvm_mmu_page is also unchanged on CONFIG_X86_64=y due
to it previously sharing an 8-byte chunk with write_flooding_count.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9bfa46b35201..4b06e6040e90 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -35,6 +35,7 @@ struct kvm_mmu_page {
 	struct hlist_node hash_link;
 	struct list_head lpage_disallowed_link;
 
+	bool tdp_mmu_page;
 	bool unsync;
 	u8 mmu_valid_gen;
 	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
@@ -70,8 +71,6 @@ struct kvm_mmu_page {
 	atomic_t write_flooding_count;
 
 #ifdef CONFIG_X86_64
-	bool tdp_mmu_page;
-
 	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
 	struct rcu_head rcu_head;
 #endif
-- 
2.33.0.153.gba50c8fa24-goog

