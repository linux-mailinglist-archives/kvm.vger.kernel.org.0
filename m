Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646173ABF4A
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 01:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhFQXWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 19:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFQXWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 19:22:07 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14358C061574
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:19:58 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v1-20020a372f010000b02903aa9be319adso3521512qkh.11
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=x6kZay8QFcZCwXeqKzx9gBeO5XUJEU0U/bkJm47MKuE=;
        b=H6EUqqmHh9XZchhM9KBTYb6IjPova9sdoOF9S4YMX9GoX3gF3kMRVSu68u3jpkYezj
         DVgiTUa9RvYh5uqZk1UXOOUQgIFFTPqydPTaL8qc4lciufVCTigD8am16oXXk2ZkYRf6
         dyMHvAL2AP/ac4Z+qZFXtyNYCb8LeVoPeU0iE56lGS7jFgbYc3MsEL40Mmn3lRcfo3jj
         DjCJLJUkwgquJQyoSD3tzO57myXP2OeFwXhUs2UJPqohlDtLlEaPqsZbzwCr/MSSe0fL
         6W5vecyaksRpLw8WAoH7ksJ0rg7jDw1lriN2ovMZiDE2A8PvNnOfqDtDqt/grNpm0dBp
         XV0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=x6kZay8QFcZCwXeqKzx9gBeO5XUJEU0U/bkJm47MKuE=;
        b=NR2I5kzq7umqyWvF338dDhpBapEsQPp1lrdFlBQXBqHBZZw66B8nXH9BPyZmj7nRmv
         +gyRob5R98KG+raUrwUJySQtks8RODdJIWwHjnIrj8jCzgImcnV0AP17VUeRkEoecOEj
         sgTRCJJNK7oQa3Tt8sMha1FQILjeTFZw5nP5OPmfSl/Bz8PriONPr5Z9+tGNnLbzE6Zw
         WdYQ8F/czNVRYgc/Y76BvBzUIeaFpHnuGXtQlTho5avRgSnWxh7B0MGAclJxNZOIjHSz
         XACHXyEKy6aOhS5bVangiiQz8razJbj97zA/VHE6aQpp6zofOId4TUrDCIT4YLNdyXCX
         6Wrg==
X-Gm-Message-State: AOAM530vluCAMSxjnllw6SZncrNHtICQP82TMknRhsX1+OI+HpCcVPXY
        6xR7UTOKioHTcz+PtE7XpF3sdbi4YmpsVSGbO/lWq4K/oHXM3aNPSZfaQ+6F7fiMSh0CWmNcxrm
        G3KNQdYzOq0xfXB3J2BH0TuxNS9Fye3fZHcC9iFp+iqAYELgJpOtN8bOEmhZ6dr8=
X-Google-Smtp-Source: ABdhPJyU07nfV9swuZBO8xidyk7pO/mLeBScBOyR08mfHT9v03SAGvxkodm6EnM35TsbjWAPf43HWyTNNdm+hg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6214:268e:: with SMTP id
 gm14mr2452398qvb.25.1623971997147; Thu, 17 Jun 2021 16:19:57 -0700 (PDT)
Date:   Thu, 17 Jun 2021 23:19:45 +0000
In-Reply-To: <20210617231948.2591431-1-dmatlack@google.com>
Message-Id: <20210617231948.2591431-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20210617231948.2591431-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 1/4] KVM: x86/mmu: Remove redundant is_tdp_mmu_root check
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The check for is_tdp_mmu_root in kvm_tdp_mmu_map is redundant because
kvm_tdp_mmu_map's only caller (direct_page_fault) already checks
is_tdp_mmu_root.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 95eeb5ac6a8a..5888f2ba417c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -979,8 +979,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
-	if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
-		return RET_PF_RETRY;
 
 	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
 					huge_page_disallowed, &req_level);
-- 
2.32.0.288.g62a8d224e6-goog

