Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475B93A18AB
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhFIPLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:11:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235881AbhFIPL2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623251369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uFiUxCbDMzJzQxw+j4Pyt7pNQH1auf0tMVF0/40YtGo=;
        b=IY8EkmfHn4+DnTjFS3DTvxoncDQpgqHoA+a8F2BstDD/VkvtWsFnI2RTzNWJazxDlkywCo
        LEeOv1U7gcJIZq6YZlRZESW7UhpihGzhUi4ZY2eVsTX+Vsi+HzNRVwo26GB3yVn9Qfflm1
        oJ68ANniF+iFoGksJ+yBzEfxVQ9rveA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-VlMXQDfgPhmwu_9GS0CfHw-1; Wed, 09 Jun 2021 11:09:26 -0400
X-MC-Unique: VlMXQDfgPhmwu_9GS0CfHw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C97BC101C8A9;
        Wed,  9 Jun 2021 15:09:24 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B159060BD8;
        Wed,  9 Jun 2021 15:09:21 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: x86: Check for pending interrupts when APICv is getting disabled
Date:   Wed,  9 Jun 2021 17:09:10 +0200
Message-Id: <20210609150911.1471882-4-vkuznets@redhat.com>
In-Reply-To: <20210609150911.1471882-1-vkuznets@redhat.com>
References: <20210609150911.1471882-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When APICv is active, interrupt injection doesn't raise KVM_REQ_EVENT
request (see __apic_accept_irq()) as the required work is done by hardware.
In case KVM_REQ_APICV_UPDATE collides with such injection, the interrupt
may never get delivered.

Currently, the described situation is hardly possible: all
kvm_request_apicv_update() calls normally happen upon VM creation when
no interrupts are pending. We are, however, going to move unconditional
kvm_request_apicv_update() call from kvm_hv_activate_synic() to
synic_update_vector() and without this fix 'hyperv_connections' test from
kvm-unit-tests gets stuck on IPI delivery attempt right after configuring
a SynIC route which triggers APICv disablement.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0f461f111a0b..605dda19642b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8979,6 +8979,15 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
 	kvm_apic_update_apicv(vcpu);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
+
+	/*
+	 * When APICv gets disabled, we may still have injected interrupts
+	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
+	 * still active when the interrupt got accepted. Make sure
+	 * inject_pending_event() is called to check for that.
+	 */
+	if (!vcpu->arch.apicv_active)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
-- 
2.31.1

