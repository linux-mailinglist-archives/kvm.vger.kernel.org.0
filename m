Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E271D3B0C06
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhFVSBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbhFVSAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:53 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A717BC0617AD
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:24 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id e13-20020a37e50d0000b02903ad5730c883so1723796qkg.22
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SXPUg9mNmqVN5rRtGZsktXnV3IRtDTAZpIQMiVU+baY=;
        b=m1bpxHKWRMXd6AP9P/rxCP1SVrJwcVZ+LBLaU6bVsOae/XAOt9w7AyOgX1LluKqP+C
         cdGh27lYDruC6CulMsAYjvLoAGMAy3JFOJqNWfgtWYlbpZRyWuZcTD5xtbrFO9e3+SxE
         Xnt/QfpgKtpG4UrtYtVNI1pjErGJFV6+5IaNjq1+zpzgGtBeGqW5Uq1dut0AuKfmiuOA
         XtJPkxtmycqkDXwohCE8n7xPT1SdrluCrjzn2XrvOLEp7UD/LJJHYjmPoXkkrMtwFzzq
         yGWFOEmvgcPYVBs8VxHhHH9Rid40Fz95cHSd9TgVh+JUiWqd/P3p0dooVe9z7dEm5KWl
         BuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SXPUg9mNmqVN5rRtGZsktXnV3IRtDTAZpIQMiVU+baY=;
        b=Q28S7csThfbkSXvADkiMTruvWDs0kgd1KyQbXgDnFekZcELaaMvTo1B4fX0mZs7qb3
         4Wlsgzh4aeCFWb+dvPOj74SKD7vmb2rQm/jmpDZEYn1qXZVhu4HrPQUcYYy1XHmvonMV
         6lpBxb6G3VpTEx0jKa9CYH7HPZh06EW+UTTgX2RrjdwM8BShVSYTZ1iudt81tMCFbmms
         7OjF3V7oURh2tddTRGp0ByA+VNuPXUIauXnIly3cVQFfsbqylJFVfG9UnBdEqo59gpEy
         RXSlTfjHFNGS1pOKLeJjZxiQkmHhRYkiVW/ehJ8xlsS2MWJHyFV0NIVQpHuBGpO659JH
         Elpg==
X-Gm-Message-State: AOAM533c2waYBeq9qPNepy0eix8/9IOUCGjKeGJ0zgILrjW6uAKbXNhj
        RXPe9sC9j2qYLo7mSG5nYfqK8Xm4Pe8=
X-Google-Smtp-Source: ABdhPJxbENL+2wIAUfosytd1ZbrgFCTF9+OpHIVawKBqVJIDy4pnomFUqtWns578BZpguezHdmPPkQtpHXM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:d44f:: with SMTP id m76mr6300374ybf.198.1624384703815;
 Tue, 22 Jun 2021 10:58:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:57 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 12/54] KVM: x86/mmu: Drop the intermediate "transient" __kvm_sync_page()
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

Nove the kvm_unlink_unsync_page() call out of kvm_sync_page() and into
it's sole caller, and fold __kvm_sync_page() into kvm_sync_page() since
the latter becomes a pure pass-through.  There really should be no reason
for code to do a complete sync of a shadow page outside of the full
kvm_mmu_sync_roots(), e.g. the one use case that creeped in turned out to
be flawed and counter-productive.

Update the comment in kvm_mmu_get_page() regarding its sync_page() usage,
which is anything but obvious.

Drop the stale comment about @sp->gfn needing to be write-protected, as
it directly contradicts the kvm_mmu_get_page() usage.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2e2d66319325..77296ce6215f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1780,18 +1780,6 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
 
-/* @sp->gfn should be write-protected at the call site */
-static bool __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			    struct list_head *invalid_list)
-{
-	if (vcpu->arch.mmu->sync_page(vcpu, sp) == 0) {
-		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
-		return false;
-	}
-
-	return true;
-}
-
 static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
 					struct list_head *invalid_list,
 					bool remote_flush)
@@ -1833,8 +1821,12 @@ static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
-	kvm_unlink_unsync_page(vcpu->kvm, sp);
-	return __kvm_sync_page(vcpu, sp, invalid_list);
+	if (vcpu->arch.mmu->sync_page(vcpu, sp) == 0) {
+		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
+		return false;
+	}
+
+	return true;
 }
 
 struct mmu_page_path {
@@ -1931,6 +1923,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 		}
 
 		for_each_sp(pages, sp, parents, i) {
+			kvm_unlink_unsync_page(vcpu->kvm, sp);
 			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
 			mmu_pages_clear_parents(&parents);
 		}
@@ -2008,10 +2001,19 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			goto trace_get_page;
 
 		if (sp->unsync) {
-			/* The page is good, but __kvm_sync_page might still end
-			 * up zapping it.  If so, break in order to rebuild it.
+			/*
+			 * The page is good, but is stale.  "Sync" the page to
+			 * get the latest guest state, but don't write-protect
+			 * the page and don't mark it synchronized!  KVM needs
+			 * to ensure the mapping is valid, but doesn't need to
+			 * fully sync (write-protect) the page until the guest
+			 * invalidates the TLB mapping.  This allows multiple
+			 * SPs for a single gfn to be unsync.
+			 *
+			 * If the sync fails, the page is zapped.  If so, break
+			 * If so, break in order to rebuild it.
 			 */
-			if (!__kvm_sync_page(vcpu, sp, &invalid_list))
+			if (!kvm_sync_page(vcpu, sp, &invalid_list))
 				break;
 
 			WARN_ON(!list_empty(&invalid_list));
-- 
2.32.0.288.g62a8d224e6-goog

