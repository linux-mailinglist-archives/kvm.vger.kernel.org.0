Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BD833BDDA
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 15:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhCOOjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 10:39:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240198AbhCOOhV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 10:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f4OpybUJz5iJaVvVR75EyFkJKEepA9rPE6zzgFFhznU=;
        b=GNLfjXPyyOlQg2fK+tHhJUN3bKP0zxcRkshmgXZyewR7XzrdMB56h/D9PHlXnA01VfSZa/
        HnOqfIzF2MsAw1/B6Y9wFPEh5T3sX9fiI/h5HytD5N73Kw28JORJ3Qodge8mqG4pQ2ooBv
        NMIufZq9S4yVfhd3+nJXltMp7NgyuWQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-ZOjlbchJPKSb5ZP1a_7fpg-1; Mon, 15 Mar 2021 10:37:16 -0400
X-MC-Unique: ZOjlbchJPKSb5ZP1a_7fpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99F8218460E6;
        Mon, 15 Mar 2021 14:37:14 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B008E5C3E6;
        Mon, 15 Mar 2021 14:37:12 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated TSC page by secondary CPUs
Date:   Mon, 15 Mar 2021 15:37:04 +0100
Message-Id: <20210315143706.859293-3-vkuznets@redhat.com>
In-Reply-To: <20210315143706.859293-1-vkuznets@redhat.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM_REQ_MASTERCLOCK_UPDATE request is issued (e.g. after migration)
we need to make sure no vCPU sees stale values in PV clock structures and
thus all vCPUs are kicked with KVM_REQ_CLOCK_UPDATE. Hyper-V TSC page
clocksource is global and kvm_guest_time_update() only updates in on vCPU0
but this is not entirely correct: nothing blocks some other vCPU from
entering the guest before we finish the update on CPU0 and it can read
stale values from the page.

Call kvm_hv_setup_tsc_page() on all vCPUs. Normally, KVM_REQ_CLOCK_UPDATE
should be very rare so we may not care much about being wasteful.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47e021bdcc94..882c509bfc86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2748,8 +2748,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				       offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
-	if (v == kvm_get_vcpu(v->kvm, 0))
-		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
+
+	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
+
 	return 0;
 }
 
-- 
2.30.2

