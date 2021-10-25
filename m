Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD60439B77
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 18:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbhJYQ1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 12:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233443AbhJYQ1q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 12:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635179123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9YLgAyXs3K5Wk/mUtAnrMI4Vyi1II+Ednpwsx4xkjsg=;
        b=SDRT3MxjxG07l+8aAMGxGHbCCvpdZ1MDJ2m7cstVQmjYcGd4H4YN3HRD4pLvtV74gaGTPf
        blWx6ezKFlf1PC2KC5lDiLxWr247jM/q+xrLKBU5mYdB7b0jAkxJdRdAnRMcfO3nlgK0tA
        dPe7uUFIa+04q4/+8TPvk9KJHWR/9fo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-XUWSV9jrNmSCROQHdAeHxw-1; Mon, 25 Oct 2021 12:25:20 -0400
X-MC-Unique: XUWSV9jrNmSCROQHdAeHxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DFB2802682;
        Mon, 25 Oct 2021 16:25:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC97E1037F3B;
        Mon, 25 Oct 2021 16:25:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Marc Orr <marcorr@google.com>
Subject: [PATCH] KVM: SEV-ES: fix another issue with string I/O VMGEXITs
Date:   Mon, 25 Oct 2021 12:25:17 -0400
Message-Id: <20211025162517.2152628-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the guest requests string I/O from the hypervisor via VMGEXIT,
SW_EXITINFO2 will contain the REP count.  However, sev_es_string_io
was incorrectly treating it as the size of the GHCB buffer in
bytes.

This fixes the "outsw" test in the experimental SEV tests of
kvm-unit-tests.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Reported-by: Marc Orr <marcorr@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e672493b5d8d..12d29d669cbc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2579,11 +2579,16 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 {
-	if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
+	u32 bytes;
+
+	if (unlikely(check_mul_overflow(svm->vmcb->control.exit_info_2, size, &bytes)))
+		return -EINVAL;
+
+	if (!setup_vmgexit_scratch(svm, in, bytes))
 		return -EINVAL;
 
-	return kvm_sev_es_string_io(&svm->vcpu, size, port,
-				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
+	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->ghcb_sa,
+				    svm->vmcb->control.exit_info_2, in);
 }
 
 void sev_es_init_vmcb(struct vcpu_svm *svm)
-- 
2.27.0

