Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38EA350090
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 14:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbhCaMmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 08:42:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235613AbhCaMll (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 08:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617194500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CJ7CAhfyI891QLLS7moyInEYvvulvtUZ6HJ9gvElXsM=;
        b=bwburUgPmMENYMuplvzqS4fjGg+Wt/ylsj7E84waA6iyBgk83tz5moy6nvmOJkesT3/GFF
        6FZ81rCB+4/MCXPbXDnfD60hTUVFRy+ri75oHB/ujHkK7yLGmzKCkmz/RkYMOp8994pkPg
        gJiixwGYW2Z6t8yeH8sA32KFwWpcwP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-oLRSX5A8OnyGFcPonUWJWg-1; Wed, 31 Mar 2021 08:41:39 -0400
X-MC-Unique: oLRSX5A8OnyGFcPonUWJWg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97D178143FE;
        Wed, 31 Mar 2021 12:41:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64BC360861;
        Wed, 31 Mar 2021 12:41:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] KVM: x86: Prevent 'hv_clock->system_time' from going negative in kvm_guest_time_update()
Date:   Wed, 31 Mar 2021 14:41:29 +0200
Message-Id: <20210331124130.337992-2-vkuznets@redhat.com>
In-Reply-To: <20210331124130.337992-1-vkuznets@redhat.com>
References: <20210331124130.337992-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When guest time is reset with KVM_SET_CLOCK(0), it is possible for
'hv_clock->system_time' to become a small negative number. This happens
because in KVM_SET_CLOCK handling we set 'kvm->arch.kvmclock_offset' based
on get_kvmclock_ns(kvm) but when KVM_REQ_CLOCK_UPDATE is handled,
kvm_guest_time_update() does (masterclock in use case):

hv_clock.system_time = ka->master_kernel_ns + v->kvm->arch.kvmclock_offset;

And 'master_kernel_ns' represents the last time when masterclock
got updated, it can precede KVM_SET_CLOCK() call. Normally, this is not a
problem, the difference is very small, e.g. I'm observing
hv_clock.system_time = -70 ns. The issue comes from the fact that
'hv_clock.system_time' is stored as unsigned and 'system_time / 100' in
compute_tsc_page_parameters() becomes a very big number.

Use 'master_kernel_ns' instead of get_kvmclock_ns() when masterclock is in
use and get_kvmclock_base_ns() when it's not to prevent 'system_time' from
going negative.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2bfd00da465f..2f54beed0105 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5728,6 +5728,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 #endif
 	case KVM_SET_CLOCK: {
+		struct kvm_arch *ka = &kvm->arch;
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
 
@@ -5746,8 +5747,22 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		 * pvclock_update_vm_gtod_copy().
 		 */
 		kvm_gen_update_masterclock(kvm);
-		now_ns = get_kvmclock_ns(kvm);
-		kvm->arch.kvmclock_offset += user_ns.clock - now_ns;
+
+		/*
+		 * This pairs with kvm_guest_time_update(): when masterclock is
+		 * in use, we use master_kernel_ns + kvmclock_offset to set
+		 * unsigned 'system_time' so if we use get_kvmclock_ns() (which
+		 * is slightly ahead) here we risk going negative on unsigned
+		 * 'system_time' when 'user_ns.clock' is very small.
+		 */
+		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+		if (kvm->arch.use_master_clock)
+			now_ns = ka->master_kernel_ns;
+		else
+			now_ns = get_kvmclock_base_ns();
+		ka->kvmclock_offset = user_ns.clock - now_ns;
+		spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
+
 		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
 		break;
 	}
-- 
2.30.2

