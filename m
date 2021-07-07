Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8A93BE858
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhGGMx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 08:53:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231469AbhGGMx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 08:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625662277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A8m8l1YMhMNGREC6OerrdIRk3bJP0sjtmzeEBrv8jIk=;
        b=Jv+bsk1pBTsuq1Wdhg8E+YchuAH4zw1D2AkcaztIbgLoXGiQ119t91hUDNMiaBKuiv40Vq
        PIM9S/6RyVB0i/P0zedNVHnUFpy3gXM0gmK/aQ68HlRlyOe4bp2Fe3762SNOGXg0dotKhd
        juTCd4UAcOxfs/aneo5h7QBiAjTFho4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-UCTgX0DgMQiH11zDhpjE4g-1; Wed, 07 Jul 2021 08:51:16 -0400
X-MC-Unique: UCTgX0DgMQiH11zDhpjE4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37BD4343D2;
        Wed,  7 Jul 2021 12:51:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0958C19C45;
        Wed,  7 Jul 2021 12:51:07 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/3] KVM: SVM: #SMI interception must not skip the instruction
Date:   Wed,  7 Jul 2021 15:50:58 +0300
Message-Id: <20210707125100.677203-2-mlevitsk@redhat.com>
In-Reply-To: <20210707125100.677203-1-mlevitsk@redhat.com>
References: <20210707125100.677203-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 5ff3a351f687 ("KVM: x86: Move trivial instruction-based
exit handlers to common code"), unfortunately made a mistake of
treating nop_on_interception and nop_interception in the same way.

Former does truly nothing while the latter skips the instruction.

SMI VM exit handler should do nothing.
(SMI itself is handled by the host when we do STGI)

Fixes: 5ff3a351f687 ("KVM: x86: Move trivial instruction-based exit handlers to common code")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 616b9679ddcc..41d0a589c578 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2127,6 +2127,11 @@ static int nmi_interception(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int smi_interception(struct kvm_vcpu *vcpu)
+{
+	return 1;
+}
+
 static int intr_interception(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.irq_exits;
@@ -3101,7 +3106,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_EXCP_BASE + GP_VECTOR]	= gp_interception,
 	[SVM_EXIT_INTR]				= intr_interception,
 	[SVM_EXIT_NMI]				= nmi_interception,
-	[SVM_EXIT_SMI]				= kvm_emulate_as_nop,
+	[SVM_EXIT_SMI]				= smi_interception,
 	[SVM_EXIT_INIT]				= kvm_emulate_as_nop,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	[SVM_EXIT_RDPMC]			= kvm_emulate_rdpmc,
-- 
2.26.3

