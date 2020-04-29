Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE691BD866
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 11:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgD2JhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 05:37:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40893 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726790AbgD2JhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 05:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588153020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=62PaSZcXI2KQgVFHOqv6n3wyyzQ9POA7+NN5mWgacs8=;
        b=UZ1SECicnPHh9qU6HJM5+UKxh+j0guzxFmW3ojW2ni1py2clyFUeYlJFgBtOsA3Pe60YST
        SdpbJ2nlT0kFN3QShYqQtS0T2UTD4vdl3uI4tbCl3cvYxRllYkbOvZIfaHpgG6tI9wJIOq
        O2cIji9t0d6oq5v3DyLvtQWeW64aXZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-cmJqbOcjPOCvCOOEaFvaCA-1; Wed, 29 Apr 2020 05:36:58 -0400
X-MC-Unique: cmJqbOcjPOCvCOOEaFvaCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6477800C78;
        Wed, 29 Apr 2020 09:36:56 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABDE45D9C9;
        Wed, 29 Apr 2020 09:36:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 5/6] KVM: x86: announce KVM_FEATURE_ASYNC_PF_INT
Date:   Wed, 29 Apr 2020 11:36:33 +0200
Message-Id: <20200429093634.1514902-6-vkuznets@redhat.com>
In-Reply-To: <20200429093634.1514902-1-vkuznets@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new capability to indicate that KVM supports interrupt based
delivery of type 2 APF events (page ready notifications). This includes
support for both MSR_KVM_ASYNC_PF2 and MSR_KVM_ASYNC_PF_ACK.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/cpuid.rst     | 6 ++++++
 arch/x86/include/uapi/asm/kvm_para.h | 1 +
 arch/x86/kvm/cpuid.c                 | 3 ++-
 arch/x86/kvm/x86.c                   | 1 +
 include/uapi/linux/kvm.h             | 1 +
 5 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cp=
uid.rst
index 01b081f6e7ea..5383d68e3217 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -86,6 +86,12 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest ch=
ecks this feature bit
                                               before using paravirtualiz=
ed
                                               sched yield.
=20
+KVM_FEATURE_PV_SCHED_YIELD        14          guest checks this feature =
bit
+                                              before using the second as=
ync
+                                              pf control msr 0x4b564d06 =
and
+                                              async pf acknowledgment ms=
r
+                                              0x4b564d07.
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest=
-side
                                               per-cpu warps are expeced =
in
                                               kvmclock
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi=
/asm/kvm_para.h
index 5c7449980619..b4560f60fb05 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -31,6 +31,7 @@
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_ASYNC_PF_INT	14
=20
 #define KVM_HINTS_REALTIME      0
=20
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..790fe4988001 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -712,7 +712,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_ar=
ray *array, u32 function)
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
-			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
+			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_ASYNC_PF_INT);
=20
 		if (sched_info_on())
 			entry->eax |=3D (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3b91ac33bfd..b1ee01fdf671 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3413,6 +3413,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
+	case KVM_CAP_ASYNC_PF_INT:
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_KVMCLOCK_CTRL:
 	case KVM_CAP_READONLY_MEM:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b..15012f78a691 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_ASYNC_PF_INT 182
=20
 #ifdef KVM_CAP_IRQ_ROUTING
=20
--=20
2.25.3

