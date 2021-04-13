Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B899435DEDD
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344091AbhDMM23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:28:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345596AbhDMM1z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yR7IlAhx/B5XJ+0ixhU/p5f+3s/SmBKSwi/7KCJ61qI=;
        b=iKJ5gHcnRnxXKASEa/bGWAITd6vVkX5ZdVGRA3rGUn8I8abGOoGcijw7nmwdgvPN5Q+FXq
        J+TDA+S5Dt4AfM4P9bJCAKIMdWYnpHG3+91Pnb027p+ZZ3fJL7oS5Tgm6ABXx4dCKp12cC
        KZzlaG+mHr74w0iueXwNuYn9t/ukhd8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-BxZjuDmGPJSvNGBvCHYR4w-1; Tue, 13 Apr 2021 08:27:33 -0400
X-MC-Unique: BxZjuDmGPJSvNGBvCHYR4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5473A19611A9;
        Tue, 13 Apr 2021 12:27:32 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6EA760C04;
        Tue, 13 Apr 2021 12:27:24 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 16/22] KVM: x86: hyper-v: Honor HV_STIMER_DIRECT_MODE_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:24 +0200
Message-Id: <20210413122630.975617-17-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Synthetic timers can only be configured in 'direct' mode when
HV_STIMER_DIRECT_MODE_AVAILABLE bit was exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1299847c89ba..0df18187d908 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -646,6 +646,11 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 				 HV_MSR_SYNTIMER_AVAILABLE))))
 		return 1;
 
+	if (unlikely(!host && new_config.direct_mode &&
+		     !(to_hv_vcpu(vcpu)->cpuid_cache.features_edx &
+		       HV_STIMER_DIRECT_MODE_AVAILABLE)))
+		return 1;
+
 	trace_kvm_hv_stimer_set_config(hv_stimer_to_vcpu(stimer)->vcpu_id,
 				       stimer->index, config, host);
 
-- 
2.30.2

