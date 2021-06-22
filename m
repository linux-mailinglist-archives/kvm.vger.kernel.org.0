Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866533B0C21
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhFVSCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbhFVSCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:02:06 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38954C0611F9
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:52 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d7-20020ac811870000b02901e65f85117bso44889qtj.18
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=X7T8CU2pWlX7G1KWzznOHQSy1rZlSVK7/Z+0TYT3eEA=;
        b=FIMx6leMwUpnKir4uxGqVuHx0i8uULW07cBd9bolZKS3GyBypw8ATJpqZmn3PTGeyf
         gBClmMLiWtH6pOhmqyeYBIB4yZhhA8wHXBY0b/6vP6wCTiZ4kN5s7VNllncGCHb02znS
         kBQNBhIr9JuGK6z7CXV+dq2a/bCKt3mlJMcX52tskQ2GDss19zRvAXWwlaBj1ZTy+w0u
         16dj1y/Yyzkvx4d0o3kQvE2pIHFd0zvqe4/wEo1E7JJo8TkxZTx+ccstdJqEDtxfsEo5
         ijesBaAfhHEQ2tVwfUZQhTTPoAoi6uCnA+Nb1EQZDesc6VfjI4qISpwk4GuJbS8p188G
         cAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=X7T8CU2pWlX7G1KWzznOHQSy1rZlSVK7/Z+0TYT3eEA=;
        b=QBhpaphUII7fie5Mp2z5uTuA8MO/W7gNGIh5uaYTZWkjtMq6UKHPTxJBQ+ttFTq4sh
         bHwDlpAsD6vcEFUYJL9kntl1QYmf9wLmNmm3hbIk5JKRtjOdcm3Xl5YkQk69f06Z/dx3
         UGFBNZYfjT4440Kg5DxA9idzDpavT4R68B0UTlvaLXqGqs3qE5+IdMnSyw5/7qSmFOuA
         YwRXadpYXg8+InTF1pSzvtObk3Po+NgEUEqbMDVdSHQ0J0J2DUPegdlEN8tl19hqNecc
         J/IZK9+jqCWg5WrbsdNpDQVUnqahX7lo850VktiiGB5lCG/EsTR5GFXYtXnfieS9ZO27
         BJog==
X-Gm-Message-State: AOAM53210HLGC0cJMPUrXHSd0614j1+gWEfdMX4gZNGvsMqOc3MxgOuF
        9LxCRs0VgKNheAijXlX/rt3LQdfC5k0=
X-Google-Smtp-Source: ABdhPJzGQ3mmFGTuB7BJzPvwumzn+u7ozsRJwRC9VsNwIKZ+pHTc4fnU/06I6sSMDHUApF+OtJK/oo4hLts=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:9390:: with SMTP id a16mr6670919ybm.208.1624384731335;
 Tue, 22 Jun 2021 10:58:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:09 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-25-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 24/54] KVM: x86/mmu: Rename "nxe" role bit to "efer_nx" for
 macro shenanigans
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename "nxe" to "efer_nx" so that future macro magic can use the pattern
<reg>_<bit> for all CR0, CR4, and EFER bits that included in the role.
Using "efer_nx" also makes it clear that the role bit reflects EFER.NX,
not the NX bit in the corresponding PTE.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/mmu.rst            | 4 ++--
 arch/x86/include/asm/kvm_host.h           | 4 ++--
 arch/x86/kvm/mmu/mmu.c                    | 2 +-
 arch/x86/kvm/mmu/mmutrace.h               | 2 +-
 tools/lib/traceevent/plugins/plugin_kvm.c | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index ddbb23998742..f60f5488e121 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -180,8 +180,8 @@ Shadow pages contain the following information:
   role.gpte_is_8_bytes:
     Reflects the size of the guest PTE for which the page is valid, i.e. '1'
     if 64-bit gptes are in use, '0' if 32-bit gptes are in use.
-  role.nxe:
-    Contains the value of efer.nxe for which the page is valid.
+  role.efer_nx:
+    Contains the value of efer.nx for which the page is valid.
   role.cr0_wp:
     Contains the value of cr0.wp for which the page is valid.
   role.smep_andnot_wp:
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cdaff399ed94..8aa798c75e9a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -274,7 +274,7 @@ struct kvm_kernel_irq_routing_entry;
  * by indirect shadow page can not be more than 15 bits.
  *
  * Currently, we used 14 bits that are @level, @gpte_is_8_bytes, @quadrant, @access,
- * @nxe, @cr0_wp, @smep_andnot_wp and @smap_andnot_wp.
+ * @efer_nx, @cr0_wp, @smep_andnot_wp and @smap_andnot_wp.
  */
 union kvm_mmu_page_role {
 	u32 word;
@@ -285,7 +285,7 @@ union kvm_mmu_page_role {
 		unsigned direct:1;
 		unsigned access:3;
 		unsigned invalid:1;
-		unsigned nxe:1;
+		unsigned efer_nx:1;
 		unsigned cr0_wp:1;
 		unsigned smep_andnot_wp:1;
 		unsigned smap_andnot_wp:1;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 896e92eac28b..7bc5b1a8fca5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4567,7 +4567,7 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 	union kvm_mmu_role role = {0};
 
 	role.base.access = ACC_ALL;
-	role.base.nxe = ____is_efer_nx(regs);
+	role.base.efer_nx = ____is_efer_nx(regs);
 	role.base.cr0_wp = ____is_cr0_wp(regs);
 	role.base.smm = is_smm(vcpu);
 	role.base.guest_mode = is_guest_mode(vcpu);
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index e798489b56b5..efbad33a0645 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -40,7 +40,7 @@
 			 role.direct ? " direct" : "",			\
 			 access_str[role.access],			\
 			 role.invalid ? " invalid" : "",		\
-			 role.nxe ? "" : "!",				\
+			 role.efer_nx ? "" : "!",			\
 			 role.ad_disabled ? "!" : "",			\
 			 __entry->root_count,				\
 			 __entry->unsync ? "unsync" : "sync", 0);	\
diff --git a/tools/lib/traceevent/plugins/plugin_kvm.c b/tools/lib/traceevent/plugins/plugin_kvm.c
index 51ceeb9147eb..9ce7b4b68e3f 100644
--- a/tools/lib/traceevent/plugins/plugin_kvm.c
+++ b/tools/lib/traceevent/plugins/plugin_kvm.c
@@ -366,7 +366,7 @@ union kvm_mmu_page_role {
 		unsigned direct:1;
 		unsigned access:3;
 		unsigned invalid:1;
-		unsigned nxe:1;
+		unsigned efer_nx:1;
 		unsigned cr0_wp:1;
 		unsigned smep_and_not_wp:1;
 		unsigned smap_and_not_wp:1;
@@ -403,7 +403,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 				 access_str[role.access],
 				 role.invalid ? " invalid" : "",
 				 role.cr4_pae ? "" : "!",
-				 role.nxe ? "" : "!",
+				 role.efer_nx ? "" : "!",
 				 role.cr0_wp ? "" : "!",
 				 role.smep_and_not_wp ? " smep" : "",
 				 role.smap_and_not_wp ? " smap" : "",
-- 
2.32.0.288.g62a8d224e6-goog

