Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E9C4579D6
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbhKTACM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbhKTABk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:40 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8FCC06175F
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:34 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id q2-20020a056a00084200b004a2582fcec1so6456911pfk.15
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vNwFPHl85HCSd6FrobTYNAaEsPPYg0rnClUTDebkkfM=;
        b=tejtz/QT28zt+AH8kdTJ7B0WJpXaA0BCyraKwK0Um3p7G3n8Lh/A2VMpI9ox2PMw6Q
         rfdqYEqp4xXcV2c2T6mkQgEf95PXbgFwPzUSuumlvZwMAmhI6U+S8ZYFSmNlv2H5QeAB
         m+kDj0chR+vXRyxvaBa6Eui9q0MXt/R4Uy6brsqQkox4lNd34sE9cMvrAT51fO2a2EeC
         x+gaJ6W5lWTd+lDKa9j52Q7wlql779fOMy4cmauE90B43A6ZZhcv3TlmT4SED+SIFoow
         j+L5ikv3FtboeJ0Gtyi+jcM2MZDCbMH3gsCAiq/VwYECttUO7pp1wChHh3dIyyv47hXv
         tSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vNwFPHl85HCSd6FrobTYNAaEsPPYg0rnClUTDebkkfM=;
        b=vvzsVOSaYEY9XOSX5C1xRowwvI46Kz50teZG0yK3IRdIt0+APYDjjtaThIT9gngrBZ
         vDOLFW29f1lRZ716sksTMe4qCb9VQhbRDvWHmT96fvI/KXGC6MvUG83lQgHVHHNIZ9Az
         7zx6sUE7lW6pxqiRgGjOiWy/9v9Eq92eirB2QocZ28KD9pEIxZXWU8+ENpNDlh7QyUrF
         JwFLfU2It+6iwZ+0Lj0YrrLtkxWRDNf+PnP7QQaKa+iAyoOazqOpdIpAi2GbS4wyYu6V
         3TBVbbAztkPMlk0WEq9QZX7e+YjE5CUvD3S72sHlHi47JDVCt4AgRAbIN6h5pMbhcWMH
         qNjg==
X-Gm-Message-State: AOAM530H8rskXS/FgEmA33zZDsp+XOhqlJTWv5gyzDXWty4nY8bylbSd
        tDZEBXjbLm3B32TUELj/AQ/mH4PpI5oulg==
X-Google-Smtp-Source: ABdhPJzzcMnMves3sTRprmzo1YUtxIAkCh5AoU8KogpEHmRL1i++riG7ky88KfHlQ0BG6kLgB2cwlnkL6OMSDw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:fd8c:: with SMTP id
 cx12mr4652427pjb.11.1637366314282; Fri, 19 Nov 2021 15:58:34 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:59 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-16-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 15/15] KVM: x86/mmu: Update page stats when splitting
 large pages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When splitting large pages we need to update the pages stats to reflect
all of the new pages at the lower level. We do not need to change the
page stats for the large page that was removed as that is already
handled tdp_mmu_set_spte_atomic.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8f60d942c789..4c313613a939 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1299,7 +1299,12 @@ static bool tdp_mmu_split_large_page_atomic(struct kvm *kvm, struct tdp_iter *it
 		child_sp->spt[i] = child_spte;
 	}
 
-	return tdp_mmu_install_sp_atomic(kvm, iter, child_sp, false);
+	if (!tdp_mmu_install_sp_atomic(kvm, iter, child_sp, false))
+		return false;
+
+	kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);
+
+	return true;
 }
 
 static void tdp_mmu_split_large_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
-- 
2.34.0.rc2.393.gf8c9666880-goog

