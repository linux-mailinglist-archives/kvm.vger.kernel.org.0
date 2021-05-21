Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CEB38C407
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhEUJ4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237267AbhEUJyy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AGjVnbpjWJoXrCLtj+5imnxZMYEvzZlDaWl+KSUGWCI=;
        b=cQvP2xePhNP7wQFcFKANebnZbtqEvDO6ipDo+XFg4ru9W2iEnvqq77euu/O51Maawa1KZp
        rp9c2zpRoiAXhGshvn+UKoYkLeYSaT5wlnI1NFRcUAybKINBhd3L3y5wcO13gclQpUSX1b
        QJJhtgGtipG7eZ8fGTRhIYZ9sLEzEa0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-Aff-W5XTOTCKGuUnjx4K0w-1; Fri, 21 May 2021 05:53:26 -0400
X-MC-Unique: Aff-W5XTOTCKGuUnjx4K0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B4B7101F7D2;
        Fri, 21 May 2021 09:53:25 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60BD3687F7;
        Fri, 21 May 2021 09:53:23 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 24/30] KVM: x86: hyper-v: Honor HV_DEBUGGING privilege bit
Date:   Fri, 21 May 2021 11:51:58 +0200
Message-Id: <20210521095204.2161214-25-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition must possess 'HV_DEBUGGING' privilege to issue
HVCALL_POST_DEBUG_DATA/HVCALL_RETRIEVE_DEBUG_DATA/
HVCALL_RESET_DEBUG_SESSION hypercalls.

Note, when SynDBG is disabled hv_check_hypercall_access() returns
'true' (like for any other unknown hypercall) so the result will
be HV_STATUS_INVALID_HYPERCALL_CODE and not HV_STATUS_ACCESS_DENIED.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 523f63287636..36ec688cda4e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2035,6 +2035,15 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
 		return hv_vcpu->cpuid_cache.features_ebx & HV_POST_MESSAGES;
 	case HVCALL_SIGNAL_EVENT:
 		return hv_vcpu->cpuid_cache.features_ebx & HV_SIGNAL_EVENTS;
+	case HVCALL_POST_DEBUG_DATA:
+	case HVCALL_RETRIEVE_DEBUG_DATA:
+	case HVCALL_RESET_DEBUG_SESSION:
+		/*
+		 * Return 'true' when SynDBG is disabled so the resulting code
+		 * will be HV_STATUS_INVALID_HYPERCALL_CODE.
+		 */
+		return !kvm_hv_is_syndbg_enabled(hv_vcpu->vcpu) ||
+			hv_vcpu->cpuid_cache.features_ebx & HV_DEBUGGING;
 	default:
 		break;
 	}
-- 
2.31.1

