Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9028F1B840F
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgDYHCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:02:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41024 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726396AbgDYHCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 03:02:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587798143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=HZm6DwXTwnx3KiIUACMsSmVOaGpBtskQUoUJSCSU4Rk=;
        b=UwkN3maF7BJQptgnM1/4776MctmZ9m2sCLWi2DzvI8mFD/5Zc1pFC7g1wKI379J1xmtasX
        QtQ3O8mwz+8xQpj4f4WTtd5ri1GOOMK8Kh4q9awk7rpRhmxerWwVkLzDCBG8ABKlCjE4HN
        tVoa2XDDR1Z0QnN2EUZ6b4d2NpCIhnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-4ZB6agrCM12kT8-FC1h6-w-1; Sat, 25 Apr 2020 03:02:18 -0400
X-MC-Unique: 4ZB6agrCM12kT8-FC1h6-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 888271895950;
        Sat, 25 Apr 2020 07:02:17 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB2DB600E8;
        Sat, 25 Apr 2020 07:02:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 21/22] KVM: VMX: Use vmx_get_rflags() to query RFLAGS in vmx_interrupt_blocked()
Date:   Sat, 25 Apr 2020 03:02:14 -0400
Message-Id: <20200425070215.251397-2-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Use vmx_get_rflags() instead of manually reading vmcs.GUEST_RFLAGS when
querying RFLAGS.IF so that multiple checks against interrupt blocking in
a single run loop only require a single VMREAD.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200423022550.15113-14-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0e5eacd6f911..9e2ba1f96cd1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4537,7 +4537,7 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
 		return false;
 
-	return !(vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) ||
+	return !(vmx_get_rflags(vcpu) & X86_EFLAGS_IF) ||
 	       (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
 		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
-- 
2.18.2


