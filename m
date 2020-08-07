Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C9323E94D
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgHGIkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:40:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57764 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgHGIkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596789605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CVgCrbHD7hvXuVLRDbSdOjrd+IO61nl5HNmtIuB5AoI=;
        b=gE0S/fFmqIERmmGfyu5OZfjc+VJL3mxZIKTrvLXOY8uv+7gHvEs9C9QwBFhOq+7USlbJkn
        5yJEPwF2htCARgT+/ffrx0W9iE0VMQ0iTNQJydNEGXLBgE7nXpY0xmOTYie6Q09o5Y9NYU
        sAb454weCXWj3HSdQxMMvtgnZjBoM8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-Zv7pK4TIPCeh9NAEza6syg-1; Fri, 07 Aug 2020 04:40:03 -0400
X-MC-Unique: Zv7pK4TIPCeh9NAEza6syg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 419381009622;
        Fri,  7 Aug 2020 08:40:02 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12BFB5C1D2;
        Fri,  7 Aug 2020 08:39:54 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] KVM: x86: hyper-v: disallow configuring SynIC timers with no SynIC
Date:   Fri,  7 Aug 2020 10:39:41 +0200
Message-Id: <20200807083946.377654-3-vkuznets@redhat.com>
In-Reply-To: <20200807083946.377654-1-vkuznets@redhat.com>
References: <20200807083946.377654-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
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
index af9cdb426dd2..4291943d1028 100644
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

