Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE05636B238
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 13:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhDZLPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 07:15:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34201 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233257AbhDZLPI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 07:15:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619435666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dQ0s9uXClzFJ0WAK8gw/NS3T718yMbcP67JO4aP5f/0=;
        b=Fn+QUxM5WY2WeoSW2eFz+Q9sGUJwv0aJnNWXErc79lJEeRLhfWdaHsgs1GZDvGcL55M4KJ
        lyLVKi0MASKEmJkWYAMYh8gFs2YPjm4nsC2Z03Nu7yr+OUd2w0CB/6s8rOx1oOU+5YHZOj
        rDR8sMyl8+sN3inzlgOj5VWiY4lStoc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-cLVr7eI6PwmgWBNyn62N_g-1; Mon, 26 Apr 2021 07:14:24 -0400
X-MC-Unique: cLVr7eI6PwmgWBNyn62N_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3D4DA0CAB;
        Mon, 26 Apr 2021 11:14:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FE175D9D0;
        Mon, 26 Apr 2021 11:14:06 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 6/6] KVM: nVMX: avoid loading PDPTRs after migration when possible
Date:   Mon, 26 Apr 2021 14:13:33 +0300
Message-Id: <20210426111333.967729-7-mlevitsk@redhat.com>
In-Reply-To: <20210426111333.967729-1-mlevitsk@redhat.com>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

if new KVM_*_SREGS2 ioctls are used, the PDPTRs are
a part of the migration state and are correctly
restored by those ioctls.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 764781ab805b..743a832d6caf 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3122,7 +3122,8 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	struct page *page;
 	u64 hpa;
 
-	if (!nested_cpu_has_ept(vmcs12) && is_pae_paging(vcpu)) {
+	if (vcpu->arch.pdptr_reload_on_nesting_needed &&
+	    !nested_cpu_has_ept(vmcs12) && is_pae_paging(vcpu)) {
 		/*
 		 * Reload the guest's PDPTRs since after a migration
 		 * the guest CR3 might be restored prior to setting the nested
-- 
2.26.2

