Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FC633BDC9
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 15:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhCOOik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 10:38:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240219AbhCOOhX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 10:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yF/DRECI57j8pYNPafUBHiPKLqMI/OZXnNRjB907b1Q=;
        b=cbhfZf4VJiBP6xqGaE2RQj6Fyg9g73ik4lR/nxJMOqHg2he8KVQEJ9MGmv8/gDzjviSwIm
        hkP6XazuiUn4/RL+l1MCIwFiwju/r81YzIbyM7woCsW8fxqLeaF7EjLSPuuAR9XrfQy8Ae
        iePVLih0NurRShBgChkg5gxiOQ05Cp4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-m1gV5_plM6-b04MT6-c8vg-1; Mon, 15 Mar 2021 10:37:20 -0400
X-MC-Unique: m1gV5_plM6-b04MT6-c8vg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48551107ACCD;
        Mon, 15 Mar 2021 14:37:19 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FFFB5C8B3;
        Mon, 15 Mar 2021 14:37:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 4/4] KVM: x86: hyper-v: Don't touch TSC page values when guest opted for re-enlightenment
Date:   Mon, 15 Mar 2021 15:37:06 +0100
Message-Id: <20210315143706.859293-5-vkuznets@redhat.com>
In-Reply-To: <20210315143706.859293-1-vkuznets@redhat.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When guest opts for re-enlightenment notifications upon migration, it is
in its right to assume that TSC page values never change (as they're only
supposed to change upon migration and the host has to keep things as they
are before it receives confirmation from the guest). This is mostly true
until the guest is migrated somewhere. KVM userspace (e.g. QEMU) will
trigger masterclock update by writing to HV_X64_MSR_REFERENCE_TSC, by
calling KVM_SET_CLOCK,... and as TSC value and kvmclock reading drift
apart (even slightly), the update causes TSC page values to change.

The issue at hand is that when Hyper-V is migrated, it uses stale (cached)
TSC page values to compute the difference between its own clocksource
(provided by KVM) and its guests' TSC pages to program synthetic timers
and in some cases, when TSC page is updated, this puts all stimer
expirations in the past. This, in its turn, causes an interrupt storm
and L2 guests not making much forward progress.

Note, KVM doesn't fully implement re-enlightenment notification. Basically,
the support for reenlightenment MSRs is just a stub and userspace is only
expected to expose the feature when TSC scaling on the expected destination
hosts is available. With TSC scaling, no real re-enlightenment is needed
as TSC frequency doesn't change. With TSC scaling becoming ubiquitous, it
likely makes little sense to fully implement re-enlightenment in KVM.

Prevent TSC page from being updated after migration. In case it's not the
guest who's initiating the change and when TSC page is already enabled,
just keep it as it is: TSC value is supposed to be preserved across
migration and TSC frequency can't change with re-enlightenment enabled.
The guest is doomed anyway if any of this is not true.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2a8d078b16cb..5889de580e37 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1103,6 +1103,24 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 				    &tsc_seq, sizeof(tsc_seq))))
 		goto out_err;
 
+	/*
+	 * Don't touch TSC page values if the guest has opted for TSC emulation
+	 * after migration. KVM doesn't fully support reenlightenment
+	 * notifications and TSC access emulation and Hyper-V is known to expect
+	 * the values in TSC page to stay constant before TSC access emulation
+	 * is disabled from guest side (HV_X64_MSR_TSC_EMULATION_STATUS).
+	 * Userspace is expected to preserve TSC frequency and guest visible TSC
+	 * value across migration (and prevent it when TSC scaling is
+	 * unsupported).
+	 */
+	if ((hv->hv_tsc_page_status != HV_TSC_PAGE_GUEST_CHANGED) &&
+	    hv->hv_tsc_emulation_control && tsc_seq) {
+		if (kvm_read_guest(kvm, gfn_to_gpa(gfn), &hv->tsc_ref, sizeof(hv->tsc_ref)))
+			goto out_err;
+
+		goto out_unlock;
+	}
+
 	/*
 	 * While we're computing and writing the parameters, force the
 	 * guest to use the time reference count MSR.
-- 
2.30.2

