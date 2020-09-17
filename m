Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7739F26D889
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 12:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgIQKLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 06:11:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726598AbgIQKLD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 06:11:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600337461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sYHG4V6fy3u/g4UVdawRvlE3KZPiniHhZvdOnhelAps=;
        b=fxtebcD0wcUeBa/m8l1S3NCyfsy9sqBL1SzJ4QNIvEEKPNYdmherbpYXZhTkWFIG/pcr4h
        O/vt4rl5+pjTXevR4JXPlHIvVmpeJE8AsEfaLcf1R83v3yyC4J8waf0b3Py7oyo4BjPJh6
        n2i3rRTF/MQOJiv0VJacEbeNPX6RAzo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-yqSV6GPdOoWRQpRVufXO1Q-1; Thu, 17 Sep 2020 06:10:59 -0400
X-MC-Unique: yqSV6GPdOoWRQpRVufXO1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4937F801AAB;
        Thu, 17 Sep 2020 10:10:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4218101416F;
        Thu, 17 Sep 2020 10:10:54 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 1/2] KVM: add request KVM_REQ_OUT_OF_MEMORY
Date:   Thu, 17 Sep 2020 13:10:47 +0300
Message-Id: <20200917101048.739691-2-mlevitsk@redhat.com>
In-Reply-To: <20200917101048.739691-1-mlevitsk@redhat.com>
References: <20200917101048.739691-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This request will be used in rare cases when emulation can't continue
due to being out of memory, to kill the current VM.

Currently only implemented for x86.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c       | 7 +++++++
 include/linux/kvm_host.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17f4995e80a7e..ea1834dd807f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8471,6 +8471,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_update_apicv(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
+
+		if (kvm_check_request(KVM_REQ_OUT_OF_MEMORY, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+			r = 0;
+			goto out;
+		}
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 05e3c2fb3ef78..487c8ed2e3f88 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -146,6 +146,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_PENDING_TIMER     2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_OUT_OF_MEMORY     4
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
-- 
2.26.2

