Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C861E2012A7
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392907AbgFSPyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:54:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392500AbgFSPyI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592582047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ONVIMPFVgNlQCWartogeNcXUxw3XoJkJEtWznEeVhjk=;
        b=cwVR6aAS83hOC250xFLAk6Ur1omjydrJLzAGSKkQwnmJDgC5uYEjfubVJ7RuJUmJ2qiStM
        m30VuD+JnNKXTxhJleNTsclSnz0SVY7a0aslzWTA7rWratdvB952DvXhT6Dh+tIEvXm5lg
        Ndi4ETgvVY8o0GmAq7B8YICYUZyTFyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-an-RjqUnOU2a1z51WD2Ghw-1; Fri, 19 Jun 2020 11:54:03 -0400
X-MC-Unique: an-RjqUnOU2a1z51WD2Ghw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79C6C18C6EEA;
        Fri, 19 Jun 2020 15:53:54 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1DD95BAD3;
        Fri, 19 Jun 2020 15:53:52 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com
Cc:     ehabkost@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        kvm@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH 1/2] kvm: Add support for KVM_CAP_HAS_SMALLER_MAXPHYADDR
Date:   Fri, 19 Jun 2020 17:53:43 +0200
Message-Id: <20200619155344.79579-2-mgamal@redhat.com>
In-Reply-To: <20200619155344.79579-1-mgamal@redhat.com>
References: <20200619155344.79579-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds the KVM_CAP_HAS_SMALLER_MAXPHYADDR capability
and a helper function to check for this capability.
This will allow QEMU to decide to what to do if the host
CPU can't handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR properly.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 linux-headers/linux/kvm.h | 1 +
 target/i386/kvm.c         | 5 +++++
 target/i386/kvm_i386.h    | 1 +
 3 files changed, 7 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 9804495a46..9eb61a303f 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_SMALLER_MAXPHYADDR 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index b3c13cb898..01100dbf20 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -136,6 +136,11 @@ bool kvm_has_smm(void)
     return kvm_check_extension(kvm_state, KVM_CAP_X86_SMM);
 }
 
+bool kvm_has_smaller_maxphyaddr(void)
+{
+    return kvm_check_extension(kvm_state, KVM_CAP_SMALLER_MAXPHYADDR);
+}
+
 bool kvm_has_adjust_clock_stable(void)
 {
     int ret = kvm_check_extension(kvm_state, KVM_CAP_ADJUST_CLOCK);
diff --git a/target/i386/kvm_i386.h b/target/i386/kvm_i386.h
index 00bde7acaf..513f8eebbb 100644
--- a/target/i386/kvm_i386.h
+++ b/target/i386/kvm_i386.h
@@ -34,6 +34,7 @@
 
 bool kvm_allows_irq0_override(void);
 bool kvm_has_smm(void);
+bool kvm_has_smaller_maxphyaddr(void);
 bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
 void kvm_synchronize_all_tsc(void);
-- 
2.26.2

