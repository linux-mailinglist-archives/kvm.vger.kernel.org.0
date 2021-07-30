Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6193DB88A
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 14:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238808AbhG3M0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 08:26:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238777AbhG3M0m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 08:26:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627647997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFC4Cp31Aq3gIHr9OgBqUPlhgsOuhhr5HdfYZjmNAWM=;
        b=bhugqfLgesaBraUtqiYvwdh2VW8jEmUUBZSf/impTq/lqNMyAYouWm7jZsPYSjzpBXhfQ7
        X/j9qVQ/zggAb5KpGWXO8DDycAM9OTLvUMirtqpc8K49eHNxeSJwWgzUYuitDj2Cj1AHzi
        hOs6iDBlDHKLNLlM2vJINgBLoVQ6ESY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-F3JZjcybPLuJ0c_62KezVQ-1; Fri, 30 Jul 2021 08:26:35 -0400
X-MC-Unique: F3JZjcybPLuJ0c_62KezVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F0E6107466D;
        Fri, 30 Jul 2021 12:26:34 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CBF218C7A;
        Fri, 30 Jul 2021 12:26:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: x86: hyper-v: Check access to hypercall before reading XMM registers
Date:   Fri, 30 Jul 2021 14:26:22 +0200
Message-Id: <20210730122625.112848-2-vkuznets@redhat.com>
In-Reply-To: <20210730122625.112848-1-vkuznets@redhat.com>
References: <20210730122625.112848-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case guest doesn't have access to the particular hypercall we can avoid
reading XMM registers.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b07592ca92f0..cb7e045905a5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2173,9 +2173,6 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	hc.rep_idx = (hc.param >> HV_HYPERCALL_REP_START_OFFSET) & 0xfff;
 	hc.rep = !!(hc.rep_cnt || hc.rep_idx);
 
-	if (hc.fast && is_xmm_fast_hypercall(&hc))
-		kvm_hv_hypercall_read_xmm(&hc);
-
 	trace_kvm_hv_hypercall(hc.code, hc.fast, hc.rep_cnt, hc.rep_idx,
 			       hc.ingpa, hc.outgpa);
 
@@ -2184,6 +2181,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		goto hypercall_complete;
 	}
 
+	if (hc.fast && is_xmm_fast_hypercall(&hc))
+		kvm_hv_hypercall_read_xmm(&hc);
+
 	switch (hc.code) {
 	case HVCALL_NOTIFY_LONG_SPIN_WAIT:
 		if (unlikely(hc.rep)) {
-- 
2.31.1

