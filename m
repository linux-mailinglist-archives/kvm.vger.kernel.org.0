Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE86321DB9A
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 18:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgGMQWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 12:22:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53067 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729027AbgGMQWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 12:22:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594657332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nIrIhkWx/fstyu+UDLNFnGFufkVWvbrIsXpWnjTB3C8=;
        b=gYqjtefWOpavVbsvDHbnk4jsfHIIlM8Ae9DAQMlfYKrPVwmyborprJk4JRbkDmPjhufhsl
        vo/nafL+tDwqwrDp+PzIWzz2aiAuCGC23ZEiLKUy0yyaJjpQMZrt8LSkB25okyFbEvh3LG
        kgMbVIn++lF8XGuzwriWmpMP5xzu0lM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-ah7gXTzCPP63Gib3iujv3g-1; Mon, 13 Jul 2020 12:22:11 -0400
X-MC-Unique: ah7gXTzCPP63Gib3iujv3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC843800FED;
        Mon, 13 Jul 2020 16:22:09 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C706D74F47;
        Mon, 13 Jul 2020 16:22:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: nVMX: fix the layout of struct kvm_vmx_nested_state_hdr
Date:   Mon, 13 Jul 2020 18:22:06 +0200
Message-Id: <20200713162206.1930767-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before commit 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer
migration") struct kvm_vmx_nested_state_hdr looked like:

struct kvm_vmx_nested_state_hdr {
        __u64 vmxon_pa;
        __u64 vmcs12_pa;
        struct {
                __u16 flags;
        } smm;
}

The ABI got broken by the above mentioned commit and an attempt
to fix that was made in commit 83d31e5271ac ("KVM: nVMX: fixes for
preemption timer migration") which made the structure look like:

struct kvm_vmx_nested_state_hdr {
        __u64 vmxon_pa;
        __u64 vmcs12_pa;
        struct {
                __u16 flags;
        } smm;
        __u32 flags;
        __u64 preemption_timer_deadline;
};

The problem with this layout is that before both changes compilers were
allocating 24 bytes for this and although smm.flags is padded to 8 bytes,
it is initialized as a 2 byte value. Chances are that legacy userspaces
using old layout will be passing uninitialized bytes which will slip into
what is now known as 'flags'.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Fixes: 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration")
Fixes: 83d31e5271ac ("KVM: nVMX: fixes for preemption timer migration")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- The patch breaks ABI so it needs to go into 5.8.

- This is a successor of "[PATCH] KVM: nVMX: properly pad struct
 kvm_vmx_nested_state_hdr"
---
 Documentation/virt/kvm/api.rst  | 5 +++--
 arch/x86/include/uapi/asm/kvm.h | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 320788f81a05..e75992ad856a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4345,8 +4345,9 @@ Errors:
 	struct {
 		__u16 flags;
 	} smm;
-
-	__u32 flags;
+	__u16 pad16;
+	__u32 pad32;
+	__u64 flags;
 	__u64 preemption_timer_deadline;
   };
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0780f97c1850..4ecc6bd49818 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -414,8 +414,9 @@ struct kvm_vmx_nested_state_hdr {
 	struct {
 		__u16 flags;
 	} smm;
-
-	__u32 flags;
+	__u16 pad16;
+	__u32 pad32;
+	__u64 flags;
 	__u64 preemption_timer_deadline;
 };
 
-- 
2.25.4

