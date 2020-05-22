Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B61A1DE750
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgEVMx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729406AbgEVMwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:23 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD313C08C5C6
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:22 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q2so12439916ljm.10
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CZiTRxJYlwT1JI2O16YcOTpTGTvsIt3/iftpkk7xc8A=;
        b=BCBMwrmxMDVQ8OtO/KzaGXdCQjeM5F3cHHB0vfwb+cvf3Z9A3LDLjE7FRdVA24erc1
         AwGxByPjg3hQAFjypKvSVkWdRRBvKLHfBx29kditdFzk85rwJq1bXca7C6+N6UmBzHt2
         OXnkj1PjOYNeHoVV4Ifh9uH4tgA161gjedRNrQL0TngxOBh8LfMvjqFNZWSE5EVvQVjf
         /MPNmP2sqqH6b4eEbAFXnNVzihJ3KDwwxVKCXR3tgnkR35deNmWrXA6h1mMyzS88L//S
         C5oUjasf0WZz8yTkaFbxXPLdszje883xE+ngP1PTwL+ClRS5mxxgTFJiVccDWlLid61Z
         YBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CZiTRxJYlwT1JI2O16YcOTpTGTvsIt3/iftpkk7xc8A=;
        b=l23nFlrQV78PmvnLs9BuoKf7iAIe1CE2eNsc19LALbKHFCgZbV6v0jOqSPaWQagCxi
         ftKRqCVHy/eyrsX9rKqqJSMk88pyzkv/sFKsiAwh/B05G1CWb8slAcKKJ8l2HaXBiGTo
         eNwEMCK0Q6DAdAAqlB6WVU2crFdHb2FKvrj/nU2hS+EM40GHPUyWXiv/t0yIFLVZiPTL
         4vuvspaMUOZ6pMY2oBDMrb0ZJkTfMLz0Vczln3G1tM699U4BLScPjN8gwG1eM4Ydnr8j
         f8rft5ItUtXKFVDVJUW86eKrJ6hfqXn2+DXEJ02s7j6Tlui3jZ4u7FzXeO8WF//WZ6Hi
         47lg==
X-Gm-Message-State: AOAM533YWcNr4WEmkUwp5AVaaeqcLmsGC0iO96rrE0rbXsmso0IbKdon
        xqupI68uE8aXqpP2hIalZIVU0g==
X-Google-Smtp-Source: ABdhPJxTEKdBkbnDP1WqaMmPg43HON2muTRB5YapI1uWS4rRjwdDOETM87HycrYnjbyjjuXd8HuRsw==
X-Received: by 2002:a2e:6e17:: with SMTP id j23mr7349735ljc.106.1590151941240;
        Fri, 22 May 2020 05:52:21 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id e18sm343155lja.55.2020.05.22.05.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:20 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id D8584102056; Fri, 22 May 2020 15:52:19 +0300 (+03)
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
Subject: [RFC 08/16] KVM: x86: Use GUP for page walk instead of __get_user()
Date:   Fri, 22 May 2020 15:52:06 +0300
Message-Id: <20200522125214.31348-9-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The user mapping doesn't have the page mapping for protected memory.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 9bdf9b7d9a96..ef0c5bc8ad7e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -400,8 +400,14 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			goto error;
 
 		ptep_user = (pt_element_t __user *)((void *)host_addr + offset);
-		if (unlikely(__get_user(pte, ptep_user)))
-			goto error;
+		if (vcpu->kvm->mem_protected) {
+			if (copy_from_guest(&pte, host_addr + offset,
+					    sizeof(pte)))
+				goto error;
+		} else {
+			if (unlikely(__get_user(pte, ptep_user)))
+				goto error;
+		}
 		walker->ptep_user[walker->level - 1] = ptep_user;
 
 		trace_kvm_mmu_paging_element(pte, walker->level);
-- 
2.26.2

