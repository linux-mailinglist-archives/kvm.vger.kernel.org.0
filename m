Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F5401B24
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 14:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbhIFM0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 08:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237245AbhIFM0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 08:26:42 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F7BC061575;
        Mon,  6 Sep 2021 05:25:38 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id j16so5531410pfc.2;
        Mon, 06 Sep 2021 05:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UmBZm6nsLJ37H9eh10vOWK3FkWVJCo2NauoZ+XB4cd0=;
        b=gWLNTCcRISfyVGlu17uPjXxYADtSl8OE5nVWpruGPxrrJ/BVt6g4rq/EtLQcEF+yij
         XnuzPXgQLVfbYWH0sP99ff552bnFy3DDA9T4w4oFdCo+9IKhmuHjrlcHiLeYbTakOkl3
         DKhQdsU2QtuK/2QNQWQZJTG4ULIrBom0wUh1mbfBhLBr7JCj/0De90yIr9t8twQvnoBH
         uD0MwNg9Dyoh+QuqXMUgnYO6RuraC3mGHL3KT8NTDLVjCNvnD364P3I0ecH6DjgryiaX
         ug5q0159eMvb0Fy9aK1Vw5qH3x8GiQUdOlVKzM+iJmN/xvCsmXD3kVrDrOHGUm774/0q
         0sYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UmBZm6nsLJ37H9eh10vOWK3FkWVJCo2NauoZ+XB4cd0=;
        b=e9bQmGCEiLc0NoT6emlscFgVqpjYl8OqQkIWPO9YgeoUTITSMIaqOvVzVNcBldQkgQ
         Jb4Ox3Y5lQTboP+6tvDoe816VZNKPQeFHAXGaFTY+gMKxndWo1szLailhEpi6kxXU7n/
         hllkB7y1wnPEmC6ftPrZ5dvwK32xmGeMkn060wmSoCY5xnaEpRoOjtCTmtpJz0HBm9V3
         e8TeDsB6PpJIowkZUwhciFVSvPGKccmhTxjo3uB7ic/tgGrDTz6mg+XirSRFsNYv6Z81
         6F6/eo9Ppt0Jdu5g4vER2yAcalwtYmxTD2OwTiAQ0d01GAAq4efauNPukLKENUEyuaId
         F35g==
X-Gm-Message-State: AOAM532aYUUkZrpHvzdYGnCngDa+uyS/cmwsAencEJJo6oCTEJLHItVg
        s1oK9OykUs24SHQHn67NntNJRFXxv4o=
X-Google-Smtp-Source: ABdhPJwTb86ZckUvhutjrCJCv6YO6apn5oh4IL7MbeHd6BfMWZGI80bPyThgf2Nd9wen/D+mPCb7Hg==
X-Received: by 2002:a63:4303:: with SMTP id q3mr12030866pga.375.1630931137543;
        Mon, 06 Sep 2021 05:25:37 -0700 (PDT)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id e19sm7370242pfi.139.2021.09.06.05.25.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Sep 2021 05:25:37 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V3 1/2] KVM: x86/mmu: Verify shadow walk doesn't terminate early in  page faults
Date:   Mon,  6 Sep 2021 20:25:46 +0800
Message-Id: <20210906122547.263316-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <YTE3bRcZv2BiVxzH@google.com>
References: <YTE3bRcZv2BiVxzH@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

WARN and bail if the shadow walk for faulting in a SPTE terminates early,
i.e. doesn't reach the expected level because the walk encountered a
terminal SPTE.  The shadow walks for page faults are subtle in that they
install non-leaf SPTEs (zapping leaf SPTEs if necessary!) in the loop
body, and consume the newly created non-leaf SPTE in the loop control,
e.g. __shadow_walk_next().  In other words, the walks guarantee that the
walk will stop if and only if the target level is reached by installing
non-leaf SPTEs to guarantee the walk remains valid.

Opportunistically use fault->goal-level instead of it.level in
FNAME(fetch) to further clarify that KVM always installs the leaf SPTE at
the target level.

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c         | 3 +++
 arch/x86/kvm/mmu/paging_tmpl.h | 7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4853c033e6ce..538be037549d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3006,6 +3006,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			account_huge_nx_page(vcpu->kvm, sp);
 	}
 
+	if (WARN_ON_ONCE(it.level != fault->goal_level))
+		return -EFAULT;
+
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
 			   fault->write, fault->goal_level, base_gfn, fault->pfn,
 			   fault->prefault, fault->map_writable);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50ade6450ace..4d559d2d4d66 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -749,9 +749,12 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		}
 	}
 
+	if (WARN_ON_ONCE(it.level != fault->goal_level))
+		return -EFAULT;
+
 	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, fault->write,
-			   it.level, base_gfn, fault->pfn, fault->prefault,
-			   fault->map_writable);
+			   fault->goal_level, base_gfn, fault->pfn,
+			   fault->prefault, fault->map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
-- 
2.19.1.6.gb485710b

