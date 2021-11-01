Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F27442072
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 20:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhKATGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 15:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhKATGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 15:06:05 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AA8C061766
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 12:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HwiPKnZL4j3tPps0I6gs9w+5zHq9re6+4gY1NvEU4Y8=; b=HL0h9+PseDm211RRRQ/oJ0dI4V
        wyrQZ9PuX9kXf/I956ton6kTRq9yjw+l+9QT6zjozGT/eVc1QRWUKoZAxBXm+IAm8vQrwkzKQn/XL
        IlZqnX015LXhvjPhRRSNIUPqmJjrap30fVXaPRPR1RoKqXSEQJCoh8G0BitUbfpqYOCr6KS3qEr8x
        X5zaEJYPs7mwhAUj/5mQye33PPtYHyjc5YzCpfsHRR1byYhDfG176HV+Ne7KeuNF79rul0NNBTF8W
        +8y9v02PR3vcZ35i8IF/2wLoVn+IXKGLCZomzxN6jYOZCQ7GNqDM/clKFhdriPGxE+lFc5kr6VplS
        NEX4fxcQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-00DcY2-La; Mon, 01 Nov 2021 19:03:16 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-0004hV-C6; Mon, 01 Nov 2021 19:03:16 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        KarimAllah Raslan <karahmed@amazon.com>
Subject: [PATCH v2 3/6] KVM: x86/xen: Use sizeof_field() instead of open-coding it
Date:   Mon,  1 Nov 2021 19:03:11 +0000
Message-Id: <20211101190314.17954-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101190314.17954-1-dwmw2@infradead.org>
References: <20211101190314.17954-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 6dd3d687cf04..565da9c3853b 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -127,9 +127,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	state_entry_time = vx->runstate_entry_time;
 	state_entry_time |= XEN_RUNSTATE_UPDATE;
 
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state_entry_time) !=
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
 		     sizeof(state_entry_time));
-	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state_entry_time) !=
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
 		     sizeof(state_entry_time));
 
 	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
@@ -144,9 +144,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	 */
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
 		     offsetof(struct compat_vcpu_runstate_info, state));
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
-	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state) !=
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
 
 	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
@@ -163,9 +163,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
 	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time) !=
 		     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=
-		     sizeof(((struct compat_vcpu_runstate_info *)0)->time));
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
+		     sizeof_field(struct compat_vcpu_runstate_info, time));
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
 		     sizeof(vx->runstate_times));
 
 	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
@@ -205,9 +205,9 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	BUILD_BUG_ON(offsetof(struct vcpu_info, evtchn_upcall_pending) !=
 		     offsetof(struct compat_vcpu_info, evtchn_upcall_pending));
 	BUILD_BUG_ON(sizeof(rc) !=
-		     sizeof(((struct vcpu_info *)0)->evtchn_upcall_pending));
+		     sizeof_field(struct vcpu_info, evtchn_upcall_pending));
 	BUILD_BUG_ON(sizeof(rc) !=
-		     sizeof(((struct compat_vcpu_info *)0)->evtchn_upcall_pending));
+		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	/*
 	 * For efficiency, this mirrors the checks for using the valid
-- 
2.31.1

