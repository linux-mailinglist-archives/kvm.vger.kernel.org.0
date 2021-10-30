Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E3F440B86
	for <lists+kvm@lfdr.de>; Sat, 30 Oct 2021 21:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhJ3TrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Oct 2021 15:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhJ3TrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Oct 2021 15:47:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13734C061714
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 12:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hhPo34I8NULxaODFxrGTl8Dl9pubMGQ160a6gnqKEPo=; b=koo83rfecXZowu6Sh6uwWm/yAX
        1X+P2aFt+InrWD1X21DV5bpTeMRdHQcO+tP3fmt7H/U+alvfD6Rtjwo7mA9OyXtTw7LCwAxnIhmf4
        jHjkq9L+PpIgVRwuzO0ZNkUN1vyWJ16NPey46IiFNBaE56+RHOOBSBkUHMTT2/zvMJ+WR4QBPWQFD
        zGDxiRQnZJ6ZWXMgS82pdUZI15K18g0+LOjB6/qzGNyQyfwPacLbDNM875hyoZ8hn2zHqBALzVfdp
        Bh/TTv1ago8+noNLOyMXr7v/blKy51WuUIZzVD8rufi3HuDx+cw4pkQjoBv2NVDkPiZsDSkmkIsmu
        rgTjwmqw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mguHF-00DHbL-29; Sat, 30 Oct 2021 19:44:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mguHE-00066A-Od; Sat, 30 Oct 2021 20:44:28 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Cc:     "jmattson @ google . com" <jmattson@google.com>,
        "pbonzini @ redhat . com" <pbonzini@redhat.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>, karahmed@amazon.com
Subject: [PATCH 2/5] KVM: x86/xen: Use sizeof_field() instead of open-coding it
Date:   Sat, 30 Oct 2021 20:44:25 +0100
Message-Id: <20211030194428.23395-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030194428.23395-1-dwmw2@infradead.org>
References: <20211030194428.23395-1-dwmw2@infradead.org>
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
index a0bd0014ec66..c4bca001a7c9 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -152,9 +152,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	state_entry_time = vx->runstate_entry_time;
 	state_entry_time |= XEN_RUNSTATE_UPDATE;
 
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state_entry_time) !=
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
 		     sizeof(state_entry_time));
-	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state_entry_time) !=
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
 		     sizeof(state_entry_time));
 
 	if (__put_user(state_entry_time, user_times))
@@ -165,9 +165,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	 * Next, write the new runstate. This is in the *same* place
 	 * for 32-bit and 64-bit guests, asserted here for paranoia.
 	 */
-	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
-	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state) !=
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
 
 	if (__put_user(vx->current_runstate, user_state))
@@ -181,9 +181,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
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
 
 	if (__copy_to_user(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times)))
@@ -222,9 +222,9 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
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

