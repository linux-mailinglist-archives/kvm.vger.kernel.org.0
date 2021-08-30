Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C003FB68D
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhH3M4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:56:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236776AbhH3M4s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 08:56:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630328154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KdEurXJXxggl2GUsYn4W6z6BKwUnQbHPXhjhk7gUsMA=;
        b=V261J8ATAefnTse92cB2KF2KtzDOoZLFM+mCnqppZjp8UMUjJqvPGXT46yLvZZKtqmWEF8
        N3jQiwKk+bm+/IXRB4qrlqvRl3+Tq9l3E5g9LU27gc0PWWvQKHo6shuyoHWcvTvXy9sxCZ
        oFItNvuGzyMZpH4YT8DZGPRqTK1UMOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-jK8EpjRmPIKdGj6ngAQHww-1; Mon, 30 Aug 2021 08:55:53 -0400
X-MC-Unique: jK8EpjRmPIKdGj6ngAQHww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3DB1100A91F;
        Mon, 30 Aug 2021 12:55:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CCD760854;
        Mon, 30 Aug 2021 12:55:48 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 2/6] KVM: x86: force PDPTR reload on SMM exit
Date:   Mon, 30 Aug 2021 15:55:35 +0300
Message-Id: <20210830125539.1768833-3-mlevitsk@redhat.com>
In-Reply-To: <20210830125539.1768833-1-mlevitsk@redhat.com>
References: <20210830125539.1768833-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_REQ_GET_NESTED_STATE_PAGES is also used on VM entries
that happen on exit from SMM mode, and in this case PDPTRS
must be always reloaded

Fixes: 0f85722341b0 ("KVM: nVMX: delay loading of PDPTRs to KVM_REQ_GET_NESTED_STATE_PAGES")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..4194fbf5e5d6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7504,6 +7504,13 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	}
 
 	if (vmx->nested.smm.guest_mode) {
+
+		/* Exit from the SMM to the non root mode also uses
+		 * the KVM_REQ_GET_NESTED_STATE_PAGES request,
+		 * but in this case the pdptrs must be always reloaded
+		 */
+		vcpu->arch.pdptrs_from_userspace = false;
+
 		ret = nested_vmx_enter_non_root_mode(vcpu, false);
 		if (ret)
 			return ret;
-- 
2.26.3

