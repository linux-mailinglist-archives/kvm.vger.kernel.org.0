Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C4B3DB88C
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 14:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhG3M0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 08:26:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238828AbhG3M0r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 08:26:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627648002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBrkosEHBpunXjv6llkfAXVgsSQKtiHD9fz58o111/Q=;
        b=GBMjq9tSvcd2ewGZre3bcalJRmLK+LLvoS9i1XwxFLlydeP121PPf9QAZrvgKdbxNB2aHs
        TJpik80V6XrdxO8EJSERQkbTe8ZECnMepb33wq7DSBiFK2sjWZQTG2hEDpSn8716fqmypi
        VvppQ01KXWi4MnsXQ4q0Tm/TkNqn1WE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-yi_BwJUSOlSp_6jkkaOJew-1; Fri, 30 Jul 2021 08:26:41 -0400
X-MC-Unique: yi_BwJUSOlSp_6jkkaOJew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5793EC1A0;
        Fri, 30 Jul 2021 12:26:39 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC6B5687D5;
        Fri, 30 Jul 2021 12:26:34 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: x86: Introduce trace_kvm_hv_hypercall_done()
Date:   Fri, 30 Jul 2021 14:26:23 +0200
Message-Id: <20210730122625.112848-3-vkuznets@redhat.com>
In-Reply-To: <20210730122625.112848-1-vkuznets@redhat.com>
References: <20210730122625.112848-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hypercall failures are unusual with potentially far going consequences
so it would be useful to see their results when tracing.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c |  1 +
 arch/x86/kvm/trace.h  | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index cb7e045905a5..2945b93dbadd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2016,6 +2016,7 @@ static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
 
 static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
 {
+	trace_kvm_hv_hypercall_done(result);
 	kvm_hv_hypercall_set_result(vcpu, result);
 	++vcpu->stat.hypercalls;
 	return kvm_skip_emulated_instruction(vcpu);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b484141ea15b..03ebe368333e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -92,6 +92,21 @@ TRACE_EVENT(kvm_hv_hypercall,
 		  __entry->outgpa)
 );
 
+TRACE_EVENT(kvm_hv_hypercall_done,
+	TP_PROTO(u64 result),
+	TP_ARGS(result),
+
+	TP_STRUCT__entry(
+		__field(__u64, result)
+	),
+
+	TP_fast_assign(
+		__entry->result	= result;
+	),
+
+	TP_printk("result 0x%llx", __entry->result)
+);
+
 /*
  * Tracepoint for Xen hypercall.
  */
-- 
2.31.1

