Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B65848C8FC
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 18:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355411AbiALRBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 12:01:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355423AbiALRBs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jan 2022 12:01:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642006907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6IXJlDqizWeo54+8z6zzciDQhLWhFcuUSJKVg6qjks=;
        b=XNkBYwa2XuZ2UgW6l0qKQT1diXl3QjKl7TTP5KNf8y2b/tW5evgu7ah7sMx+ogjGwG6/6y
        Iw956a53kCFr5Jyf0DJXdekGd2pJuPSdx2juYtrlL9ueHNO3uTAOiwkPZ5FaGueHkMvXkD
        iGEN9tsgvHdaxLz6vJooJefqwwqjS4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-RsM4B_BgN0ORPwpYBmt-XQ-1; Wed, 12 Jan 2022 12:01:44 -0500
X-MC-Unique: RsM4B_BgN0ORPwpYBmt-XQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1845880573B;
        Wed, 12 Jan 2022 17:01:43 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E15E326DE0;
        Wed, 12 Jan 2022 17:01:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
Date:   Wed, 12 Jan 2022 18:01:31 +0100
Message-Id: <20220112170134.1904308-3-vkuznets@redhat.com>
In-Reply-To: <20220112170134.1904308-1-vkuznets@redhat.com>
References: <20220112170134.1904308-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened VMCS v1 doesn't have VMX_PREEMPTION_TIMER_VALUE field,
PIN_BASED_VMX_PREEMPTION_TIMER is also filtered out already so it makes
sense to filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER too.

Note, none of the currently existing Windows/Hyper-V versions are known
to enable 'save VMX-preemption timer value' when eVMCS is in use, the
change is aimed at making the filtering future proof.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 16731d2cf231..3a461a32128b 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -59,7 +59,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
 	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
-#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
+#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
+	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
+	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
 #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
-- 
2.34.1

