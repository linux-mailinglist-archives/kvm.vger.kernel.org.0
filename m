Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFF3368EC9
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 10:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241361AbhDWIYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 04:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhDWIYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 04:24:05 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B51C061574;
        Fri, 23 Apr 2021 01:23:28 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id p16so20915719plf.12;
        Fri, 23 Apr 2021 01:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rJls36wmWapo3qvKYvXIZESml4N0oAcI82yv0aWi8Zo=;
        b=tlZ3+VmVJgvoiB7BlALO1QgnB7apv1jxZ/roqgKjhDd8v7w+3XCuX3KKsTzURoauX7
         jcQOilCZb2wZmF9Kn4z3TdKGuo1Nntklx637Jfs3xlwtOSwcVDeUZys26OwMTTd03m8b
         Dp2YHfS3jsPZ4hxP2jZXU9tU0GiyDUV/qMnxmSC9n58KDFuhs2iY10k0SQD3diX+OTXb
         eBzR8fN8n3y9/OATUcHUEjMccCrhI3PNw59hkpbs2m5OLUDBOl1wIwzNkp/EXV5MoKLK
         kQbg048W5rTj1D2kXivCMd7m6iLmzjg5l5NiTZ0YpOpStshQNaGNrxem0NAyGQnll77G
         UD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rJls36wmWapo3qvKYvXIZESml4N0oAcI82yv0aWi8Zo=;
        b=mUiwmWA2JmuKk/+V8zq7sLGvVOGb7Wh6VqFbrO+/udhZG6KLHAIOC+oSNlXqeWGqjD
         j5dvaL03yX5xWxvqQ0jtwLAWVRjuPK9pMSaqRGSJYGYKIGLpriAM81vqdz/v/DrxyzMD
         Vhy/qd1AJOTivpbTqh+AyeX9vsTftCYBupOfCd83Rb/Y+fh3duNEOc5XJdOBt3POaDi4
         0FgnF0Nzfd+CIVRIASvH2GNIxbSaSSz7qIZ6aCyYLlEZI71lOq+i04emFKOvzAcvhYQq
         rjppzyDddeJ4kneqMyIcxxGTEfIAN2m3IQVDJJdpyqu6xD+MnDCo4VSdqmoCcYdqKAbZ
         zsfA==
X-Gm-Message-State: AOAM531mBLtRm9FX8EKEZ+bjGq1zb/QZtkc1/2HTpdnGoPCxjGeWQx6/
        blT7HXdT2WOAsoahkvwXIqOFfiFVTco=
X-Google-Smtp-Source: ABdhPJx8rlLvieJFLdb68pZVfQ4X0tABu9WIsS0hK2O5SMgBs+3DDHEfjafsPSyVFR5V1Pj7YCUj2w==
X-Received: by 2002:a17:90a:a895:: with SMTP id h21mr3191124pjq.13.1619166207837;
        Fri, 23 Apr 2021 01:23:27 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id b7sm4096181pfi.42.2021.04.23.01.23.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 01:23:27 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] KVM: x86/xen: Take srcu lock when accessing kvm_memslots()
Date:   Fri, 23 Apr 2021 16:23:20 +0800
Message-Id: <1619166200-9215-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

kvm_memslots() will be called by kvm_write_guest_offset_cached() so we should 
take the srcu lock. Let's pull the srcu lock operation from kvm_steal_time_set_preempted() 
again to fix xen part.

Fixes: 30b5c851af7 (KVM: x86/xen: Add support for vCPU runstate information)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bf52ba..c775d24 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4097,7 +4097,6 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
-	int idx;
 
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
@@ -4105,15 +4104,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.st.preempted)
 		return;
 
-	/*
-	 * Take the srcu lock as memslots will be accessed to check the gfn
-	 * cache generation against the memslots generation.
-	 */
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-
 	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
 			&vcpu->arch.st.cache, true))
-		goto out;
+		return;
 
 	st = map.hva +
 		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
@@ -4121,20 +4114,25 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
 	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
-
-out:
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	int idx;
+
 	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
 		vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
 
+	/*
+	 * Take the srcu lock as memslots will be accessed to check the gfn
+	 * cache generation against the memslots generation.
+	 */
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (kvm_xen_msr_enabled(vcpu->kvm))
 		kvm_xen_runstate_set_preempted(vcpu);
 	else
 		kvm_steal_time_set_preempted(vcpu);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
-- 
2.7.4

