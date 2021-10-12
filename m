Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653CA42A8C5
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 17:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237386AbhJLPwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 11:52:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234892AbhJLPwN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 11:52:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634053811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OM6B3jqNboU2Hh/f2/hFxqXgrecxQ65nrQV6OMB0FCQ=;
        b=eHgnAMRRuJBOsXLmUuSsvsT96s/gslqxYHWQFvo7PXxIJqxXQCiRjMgOlR9/qAt72nQo6k
        AnoJw25oABLCYoWYOeAd5w2er+3XWLlTN/2oZSML+fGoJVPcNs9uDHfLi73SqhpMxZ0lvQ
        lBgv+UmqsovWgy/lrlqg9qqQFr6/Ssg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-UbqnepxiPXOWbjzgLEmkiQ-1; Tue, 12 Oct 2021 11:50:10 -0400
X-MC-Unique: UbqnepxiPXOWbjzgLEmkiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC82F91271;
        Tue, 12 Oct 2021 15:50:08 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCD1C5F4EA;
        Tue, 12 Oct 2021 15:50:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linux-hyperv@vger.kernel.org, Wei Liu <wei.liu@kernel.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH] x86/hyperv: Protect set_hv_tscchange_cb() against getting preempted
Date:   Tue, 12 Oct 2021 17:50:05 +0200
Message-Id: <20211012155005.1613352-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following issue is observed with CONFIG_DEBUG_PREEMPT when KVM loads:

 KVM: vmx: using Hyper-V Enlightened VMCS
 BUG: using smp_processor_id() in preemptible [00000000] code: systemd-udevd/488
 caller is set_hv_tscchange_cb+0x16/0x80
 CPU: 1 PID: 488 Comm: systemd-udevd Not tainted 5.15.0-rc5+ #396
 Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0 12/17/2019
 Call Trace:
  dump_stack_lvl+0x6a/0x9a
  check_preemption_disabled+0xde/0xe0
  ? kvm_gen_update_masterclock+0xd0/0xd0 [kvm]
  set_hv_tscchange_cb+0x16/0x80
  kvm_arch_init+0x23f/0x290 [kvm]
  kvm_init+0x30/0x310 [kvm]
  vmx_init+0xaf/0x134 [kvm_intel]
  ...

set_hv_tscchange_cb() can get preempted in between acquiring
smp_processor_id() and writing to HV_X64_MSR_REENLIGHTENMENT_CONTROL. This
is not an issue by itself: HV_X64_MSR_REENLIGHTENMENT_CONTROL is a
partition-wide MSR and it doesn't matter which particular CPU will be
used to receive reenlightenment notifications. The only real problem can
(in theory) be observed if the CPU whose id was acquired with
smp_processor_id() goes offline before we manage to write to the MSR,
the logic in hv_cpu_die() won't be able to reassign it correctly.

Reported-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/hyperv/hv_init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 708a2712a516..179fc173104d 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -139,7 +139,6 @@ void set_hv_tscchange_cb(void (*cb)(void))
 	struct hv_reenlightenment_control re_ctrl = {
 		.vector = HYPERV_REENLIGHTENMENT_VECTOR,
 		.enabled = 1,
-		.target_vp = hv_vp_index[smp_processor_id()]
 	};
 	struct hv_tsc_emulation_control emu_ctrl = {.enabled = 1};
 
@@ -153,8 +152,12 @@ void set_hv_tscchange_cb(void (*cb)(void))
 	/* Make sure callback is registered before we write to MSRs */
 	wmb();
 
+	re_ctrl.target_vp = hv_vp_index[get_cpu()];
+
 	wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
 	wrmsrl(HV_X64_MSR_TSC_EMULATION_CONTROL, *((u64 *)&emu_ctrl));
+
+	put_cpu();
 }
 EXPORT_SYMBOL_GPL(set_hv_tscchange_cb);
 
-- 
2.31.1

