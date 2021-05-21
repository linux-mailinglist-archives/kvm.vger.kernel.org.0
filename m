Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6491C38C3FC
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237430AbhEUJzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:55:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237091AbhEUJyc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=plNdtHpYe9BYUnQEFdjY6cVVnjE9JhcUf7d08afGey0=;
        b=EVDzecZ6pSiYllbVU011jLI6VBUyoOup8yzozAYXLjkD8S6vFaCnR+mhDzLB3ICDH5Gpar
        bhAveNsyl7QjoBOdz/Kp7WIJj6rYGkjWNFe/pnFG6dFG8qBbjsaekkQA5Rr9ueo4Ba4rsR
        oJt9VYHDX7nN8N+YKRf8mc1eO7qXBsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-2G8qKeFjOHm_RasvbowolQ-1; Fri, 21 May 2021 05:53:07 -0400
X-MC-Unique: 2G8qKeFjOHm_RasvbowolQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CF271922961;
        Fri, 21 May 2021 09:53:06 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB3B7687F7;
        Fri, 21 May 2021 09:53:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 19/30] KVM: x86: hyper-v: Honor HV_STIMER_DIRECT_MODE_AVAILABLE privilege bit
Date:   Fri, 21 May 2021 11:51:53 +0200
Message-Id: <20210521095204.2161214-20-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Synthetic timers can only be configured in 'direct' mode when
HV_STIMER_DIRECT_MODE_AVAILABLE bit was exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ec065177531b..12b6803de1b7 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -630,11 +630,17 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 	union hv_stimer_config new_config = {.as_uint64 = config},
 		old_config = {.as_uint64 = stimer->config.as_uint64};
 	struct kvm_vcpu *vcpu = hv_stimer_to_vcpu(stimer);
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
 	if (!synic->active && !host)
 		return 1;
 
+	if (unlikely(!host && hv_vcpu->enforce_cpuid && new_config.direct_mode &&
+		     !(hv_vcpu->cpuid_cache.features_edx &
+		       HV_STIMER_DIRECT_MODE_AVAILABLE)))
+		return 1;
+
 	trace_kvm_hv_stimer_set_config(hv_stimer_to_vcpu(stimer)->vcpu_id,
 				       stimer->index, config, host);
 
-- 
2.31.1

