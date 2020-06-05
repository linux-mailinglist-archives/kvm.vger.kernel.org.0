Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F451EF6EA
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 13:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgFEL7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 07:59:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48663 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726365AbgFEL7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 07:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591358360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LKLxozwE9yOiueToAj/LCbZmtKtjyMDIjDUUZ06KkvY=;
        b=LNqTeoJV+SoQweF1G44YOemoPGzGhSqM0SyInuHt7duy2YlGhpnA1FmRwPjChORlNpKuOy
        sOHfgWSFX8xcoXpiPIRxUJ/5e5jmsAZ22gOgFw0dObBqwJq2Ubmv6QrEFsCZidOhIw4P0l
        FwNDS4+BA84QKbJ+M5w/B729xibB1wc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-MKba7rfnPkekL33pkDZqkw-1; Fri, 05 Jun 2020 07:59:13 -0400
X-MC-Unique: MKba7rfnPkekL33pkDZqkw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8693E800688;
        Fri,  5 Jun 2020 11:59:12 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A83B35D9DA;
        Fri,  5 Jun 2020 11:59:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] Revert "KVM: x86: work around leak of uninitialized stack contents"
Date:   Fri,  5 Jun 2020 13:59:06 +0200
Message-Id: <20200605115906.532682-2-vkuznets@redhat.com>
In-Reply-To: <20200605115906.532682-1-vkuznets@redhat.com>
References: <20200605115906.532682-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

handle_vmptrst()/handle_vmread() stopped injecting #PF unconditionally
and switched to nested_vmx_handle_memory_failure() which just kills the
guest with KVM_EXIT_INTERNAL_ERROR in case of MMIO access, zeroing
'exception' in kvm_write_guest_virt_system() is not needed anymore.

This reverts commit 541ab2aeb28251bf7135c7961f3a6080eebcc705.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e41b5135340..0097a97d331f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5647,13 +5647,6 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 	/* kvm_write_guest_virt_system can pull in tons of pages. */
 	vcpu->arch.l1tf_flush_l1d = true;
 
-	/*
-	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
-	 * is returned, but our callers are not ready for that and they blindly
-	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
-	 * uninitialized kernel stack memory into cr2 and error code.
-	 */
-	memset(exception, 0, sizeof(*exception));
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
 }
-- 
2.25.4

