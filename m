Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B14630C6BC
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbhBBQ5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:57:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236851AbhBBQxL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:53:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612284705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcL4iP7hBp43qywJjKYyk0ZVEk2naCJmHXvEkF498tQ=;
        b=fs53r/KRWAm4OyFV4xBxWF/ackzENi0ohf7onVla16i7KfRVkcuWC5vuLz4cIsiAiJ110p
        zyvO/tb+w5p5zELOJhMvUbz7ig+zorvkUV3I7Ms2t/l1GR3zWcpOYd1XlRwMU981lh6E6n
        KLSwFRSSa6bG2OWlnht1YLEpfAHS4do=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-t03N4MQ0NRCoqtyRnto8nw-1; Tue, 02 Feb 2021 11:51:43 -0500
X-MC-Unique: t03N4MQ0NRCoqtyRnto8nw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5902195D56B;
        Tue,  2 Feb 2021 16:51:42 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52E6C60862;
        Tue,  2 Feb 2021 16:51:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 1/3] KVM: x86: move kvm_inject_gp up from kvm_set_xcr to callers
Date:   Tue,  2 Feb 2021 11:51:39 -0500
Message-Id: <20210202165141.88275-2-pbonzini@redhat.com>
In-Reply-To: <20210202165141.88275-1-pbonzini@redhat.com>
References: <20210202165141.88275-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Push the injection of #GP up to the callers, so that they can just use
kvm_complete_insn_gp.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c |  7 ++-----
 arch/x86/kvm/vmx/vmx.c |  5 ++---
 arch/x86/kvm/x86.c     | 10 ++++------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 687876211ebe..65d70b9691b4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2337,11 +2337,8 @@ static int xsetbv_interception(struct vcpu_svm *svm)
 	u64 new_bv = kvm_read_edx_eax(&svm->vcpu);
 	u32 index = kvm_rcx_read(&svm->vcpu);
 
-	if (kvm_set_xcr(&svm->vcpu, index, new_bv) == 0) {
-		return kvm_skip_emulated_instruction(&svm->vcpu);
-	}
-
-	return 1;
+	int err = kvm_set_xcr(&svm->vcpu, index, new_bv);
+	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
 
 static int rdpru_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9986a59f71a4..28daceb4f70d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5227,9 +5227,8 @@ static int handle_xsetbv(struct kvm_vcpu *vcpu)
 	u64 new_bv = kvm_read_edx_eax(vcpu);
 	u32 index = kvm_rcx_read(vcpu);
 
-	if (kvm_set_xcr(vcpu, index, new_bv) == 0)
-		return kvm_skip_emulated_instruction(vcpu);
-	return 1;
+	int err = kvm_set_xcr(vcpu, index, new_bv);
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
 static int handle_apic_access(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d14230dd38d8..08568c47337c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -986,12 +986,10 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 ||
-	    __kvm_set_xcr(vcpu, index, xcr)) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-	return 0;
+	if (static_call(kvm_x86_get_cpl)(vcpu) == 0)
+		return __kvm_set_xcr(vcpu, index, xcr);
+
+	return 1;
 }
 EXPORT_SYMBOL_GPL(kvm_set_xcr);
 
-- 
2.26.2


