Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E83387B87
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 16:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbhEROpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 10:45:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236984AbhEROpP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 10:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621349036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ABAYVVieK0QVGJuud5j42mYNkh2sIpAQCYqff+fRew8=;
        b=GBW/CPaSZmGR+iXGBCrl0PIBrrLfTR5sCJyRqfWHgpf+79doJAVNQc8HSKRGMpwfawt6ZB
        yMsXKXViawu+1ePg/42bivOCb+pPvq49alUnD9Fu0IAa5lH9f9ITCN1RICpuMwUgKwFLG6
        QbSYcc1D3PAs8dVMeyA8L0i3JpnLLYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-Hb189BR1M_SZITYHULtApQ-1; Tue, 18 May 2021 10:43:53 -0400
X-MC-Unique: Hb189BR1M_SZITYHULtApQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 938A4107ACE4;
        Tue, 18 May 2021 14:43:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37E8663B8C;
        Tue, 18 May 2021 14:43:49 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] KVM: VMX: Drop unneeded CONFIG_X86_LOCAL_APIC check from cpu_has_vmx_posted_intr()
Date:   Tue, 18 May 2021 16:43:36 +0200
Message-Id: <20210518144339.1987982-3-vkuznets@redhat.com>
In-Reply-To: <20210518144339.1987982-1-vkuznets@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CONFIG_X86_LOCAL_APIC is always on when CONFIG_KVM (on x86) since
commit e42eef4ba388 ("KVM: add X86_LOCAL_APIC dependency").

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/capabilities.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 8dee8a5fbc17..aa0e7872fcc9 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -90,8 +90,7 @@ static inline bool cpu_has_vmx_preemption_timer(void)
 
 static inline bool cpu_has_vmx_posted_intr(void)
 {
-	return IS_ENABLED(CONFIG_X86_LOCAL_APIC) &&
-		vmcs_config.pin_based_exec_ctrl & PIN_BASED_POSTED_INTR;
+	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_POSTED_INTR;
 }
 
 static inline bool cpu_has_load_ia32_efer(void)
-- 
2.31.1

