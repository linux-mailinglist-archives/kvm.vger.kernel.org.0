Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A981B20F234
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 12:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbgF3KHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 06:07:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44045 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732220AbgF3KHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 06:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593511669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6bMazijEUH/Uu9sCncXdhJdICYXtEKD+O6jGCzyyAiQ=;
        b=bhT2YLra5NIwDrpiAkcClmLb9KhAEpcFbmJ4+jcRp314xMskjj9Ks4NGrBvxxsPwBDy0L+
        0EGwbLzMsnXl/cfJDX0utUPEiV4ZzW9Di/VMze9Akc2nlIPLqox3xKucOVJbxBuZJtBTWv
        w1HBY6Q2W2+C7Q1TfH3R33616p25fNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-hLxQllp4PQGI9P72rIm5Eg-1; Tue, 30 Jun 2020 06:07:47 -0400
X-MC-Unique: hLxQllp4PQGI9P72rIm5Eg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36AF21883629;
        Tue, 30 Jun 2020 10:07:46 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B4EC74193;
        Tue, 30 Jun 2020 10:07:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: drop erroneous mmu_check_root() from fast_pgd_switch()
Date:   Tue, 30 Jun 2020 12:07:42 +0200
Message-Id: <20200630100742.1167961-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Undesired triple fault gets injected to L1 guest on SVM when L2 is
launched with certain CR3 values. It seems the mmu_check_root()
check in fast_pgd_switch() is wrong: first of all we don't know
if 'new_pgd' is a GPA or a nested GPA and, in case it is a nested
GPA, we can't check it with kvm_is_visible_gfn().

The problematic code path is:
nested_svm_vmrun()
  ...
  nested_prepare_vmcb_save()
    kvm_set_cr3(..., nested_vmcb->save.cr3)
      kvm_mmu_new_pgd()
        ...
        mmu_check_root() -> TRIPLE FAULT

The mmu_check_root() check in fast_pgd_switch() seems to be
superfluous even for non-nested case: when GPA is outside of the
visible range cached_root_available() will fail for non-direct
roots (as we can't have a matching one on the list) and we don't
seem to care for direct ones.

Also, raising #TF immediately when a non-existent GFN is written to CR3
doesn't seem to mach architecture behavior.

Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- The patch fixes the immediate issue and doesn't seem to break any
  tests even with shadow PT but I'm not sure I properly understood
  why the check was there in the first place. Please review!
---
 arch/x86/kvm/mmu/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76817d13c86e..286c74d2ae8d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4277,8 +4277,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	 */
 	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
 	    mmu->root_level >= PT64_ROOT_4LEVEL)
-		return !mmu_check_root(vcpu, new_pgd >> PAGE_SHIFT) &&
-		       cached_root_available(vcpu, new_pgd, new_role);
+		return cached_root_available(vcpu, new_pgd, new_role);
 
 	return false;
 }
-- 
2.25.4

