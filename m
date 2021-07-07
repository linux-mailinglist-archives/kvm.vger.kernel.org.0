Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECCD3BE85B
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhGGMyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 08:54:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231800AbhGGMyC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 08:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625662281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wW8WDkxvAoGkbHm52MpQ2Ci/IJt/l/ylZkv+vEZTLXY=;
        b=LkNd7X/lnwxnk575yt3iHr39hxBUPGmrjRRz4y3golVDjw0P6hu2MyT0NSxjE8LzDMmfWd
        BmrQ+ZyeYLS5ryw4AZOi1tq6uPKr/01owFq4dyCszloLgjGjxYx0r7s3HDSabS+vGuXN24
        UWXCDDFm+Tywpni/W7/X4j/hFp14OUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-EEWS1rxfOqmTR5ku8A83-w-1; Wed, 07 Jul 2021 08:51:20 -0400
X-MC-Unique: EEWS1rxfOqmTR5ku8A83-w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92EC9343CF;
        Wed,  7 Jul 2021 12:51:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A94C219C45;
        Wed,  7 Jul 2021 12:51:14 +0000 (UTC)
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
Subject: [PATCH 2/3] KVM: SVM: remove INIT intercept handler
Date:   Wed,  7 Jul 2021 15:50:59 +0300
Message-Id: <20210707125100.677203-3-mlevitsk@redhat.com>
In-Reply-To: <20210707125100.677203-1-mlevitsk@redhat.com>
References: <20210707125100.677203-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kernel never sends real INIT even to CPUs, other than on boot.

Thus INIT interception is an error which should be caught
by a check for an unknown VMexit reason.

On top of that, the current INIT VM exit handler skips
the current instruction which is wrong.
That was added in commit 5ff3a351f687 ("KVM: x86: Move trivial
instruction-based exit handlers to common code").

Fixes: 5ff3a351f687 ("KVM: x86: Move trivial instruction-based exit handlers to common code")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 41d0a589c578..a3aad97fa427 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3107,7 +3107,6 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_INTR]				= intr_interception,
 	[SVM_EXIT_NMI]				= nmi_interception,
 	[SVM_EXIT_SMI]				= smi_interception,
-	[SVM_EXIT_INIT]				= kvm_emulate_as_nop,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	[SVM_EXIT_RDPMC]			= kvm_emulate_rdpmc,
 	[SVM_EXIT_CPUID]			= kvm_emulate_cpuid,
-- 
2.26.3

