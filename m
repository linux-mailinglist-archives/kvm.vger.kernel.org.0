Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDC1487C7E
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiAGSz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:55:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231373AbiAGSzX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMFcYcH2Msh4EkPVql69cwVr+T1SO7BufToboxIymYY=;
        b=Zv9Kr3/8IJe9srhR1emrNMuJ92Ek4aY1f5nufpuVA0u6PyOp4niqFVZVFCoSh5M+GQRtYw
        5NpPmrIJcQ0G/TCpzwpILXLYkqp0/gT+ePcKuFYBgV4tmjd6B6zM+iWxwuBqdZ5d2grhh+
        FWgRfloNej9W1pxSkH8Y3qpoabCZJMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-5KN4ryjoPf-DRc4fo5zpzQ-1; Fri, 07 Jan 2022 13:55:19 -0500
X-MC-Unique: 5KN4ryjoPf-DRc4fo5zpzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B087B81EE63;
        Fri,  7 Jan 2022 18:55:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 065CC838F0;
        Fri,  7 Jan 2022 18:55:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 04/21] kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID
Date:   Fri,  7 Jan 2022 13:54:55 -0500
Message-Id: <20220107185512.25321-5-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

KVM_GET_SUPPORTED_CPUID should not include any dynamic xstates in
CPUID[0xD] if they have not been requested with prctl. Otherwise
a process which directly passes KVM_GET_SUPPORTED_CPUID to
KVM_SET_CPUID2 would now fail even if it doesn't intend to use a
dynamically enabled feature. Userspace must know that prctl is
required and allocate >4K xstate buffer before setting any dynamic
bit.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-5-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 4 ++++
 arch/x86/kvm/cpuid.c           | 9 ++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6b683dfea8f2..f4ea5e41a4d0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1687,6 +1687,10 @@ userspace capabilities, and with user requirements (for example, the
 user may wish to constrain cpuid to emulate older hardware, or for
 feature consistency across a cluster).
 
+Dynamically-enabled feature bits need to be requested with
+``arch_prctl()`` before calling this ioctl. Feature bits that have not
+been requested are excluded from the result.
+
 Note that certain capabilities, such as KVM_CAP_X86_DISABLE_EXITS, may
 expose cpuid features (e.g. MONITOR) which are not supported by kvm in
 its default configuration. If userspace enables such capabilities, it
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f3e6fda6b858..eb52dde5deec 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -815,11 +815,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 		}
 		break;
-	case 0xd:
-		entry->eax &= supported_xcr0;
+	case 0xd: {
+		u64 guest_perm = xstate_get_guest_group_perm();
+
+		entry->eax &= supported_xcr0 & guest_perm;
 		entry->ebx = xstate_required_size(supported_xcr0, false);
 		entry->ecx = entry->ebx;
-		entry->edx &= supported_xcr0 >> 32;
+		entry->edx &= (supported_xcr0 & guest_perm) >> 32;
 		if (!supported_xcr0)
 			break;
 
@@ -866,6 +868,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->edx = 0;
 		}
 		break;
+	}
 	case 0x12:
 		/* Intel SGX */
 		if (!kvm_cpu_cap_has(X86_FEATURE_SGX)) {
-- 
2.31.1


