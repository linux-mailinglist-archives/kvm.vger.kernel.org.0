Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCE6277476
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgIXO6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:58:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728192AbgIXO6M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 10:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b3u+hCNp/UZwSX5InWLParTOjW8Nw8QIqmJE9xvS92M=;
        b=VD9InTYWT7DBoZlHz2v/DOO5DRN8M/YLqSlRzFGB2t5OVwHh8tw67rmVzEHSsgFvY0kFWd
        9hXeO+/54jFEuUZhBxh//J/yLk/utjDhjW1/QTBez6AY78ldAwqPoxclfxdnHUnfOC71dM
        T2MfW7o9BOZCIeAy/xpoH9/UEXI0KPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-aNjx-uPHPYya3CrZk48eiQ-1; Thu, 24 Sep 2020 10:58:08 -0400
X-MC-Unique: aNjx-uPHPYya3CrZk48eiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDBC71008548;
        Thu, 24 Sep 2020 14:58:06 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A6795578D;
        Thu, 24 Sep 2020 14:58:04 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] KVM: x86: hyper-v: disallow configuring SynIC timers with no SynIC
Date:   Thu, 24 Sep 2020 16:57:52 +0200
Message-Id: <20200924145757.1035782-3-vkuznets@redhat.com>
In-Reply-To: <20200924145757.1035782-1-vkuznets@redhat.com>
References: <20200924145757.1035782-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V Synthetic timers require SynIC but we don't seem to check that
upon HV_X64_MSR_STIMER[X]_CONFIG/HV_X64_MSR_STIMER0_COUNT writes. Make
the behavior match synic_set_msr().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 814d3aee5cef..9527fa9685ad 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -633,6 +633,11 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 {
 	union hv_stimer_config new_config = {.as_uint64 = config},
 		old_config = {.as_uint64 = stimer->config.as_uint64};
+	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+
+	if (!synic->active && !host)
+		return 1;
 
 	trace_kvm_hv_stimer_set_config(stimer_to_vcpu(stimer)->vcpu_id,
 				       stimer->index, config, host);
@@ -652,6 +657,12 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 			    bool host)
 {
+	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+
+	if (!synic->active && !host)
+		return 1;
+
 	trace_kvm_hv_stimer_set_count(stimer_to_vcpu(stimer)->vcpu_id,
 				      stimer->index, count, host);
 
-- 
2.25.4

