Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3698A20058B
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 11:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgFSJmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 05:42:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54226 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732121AbgFSJmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 05:42:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592559722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zPadoQCK/Zr9dBTIUqiEQCreoi9mBoOI8SaL3yX0d6k=;
        b=ESGagB1D/3k7fc6ZFBIVwjKWWqdft1VkmlO8D62YMQAj3aKYt2NZPZoxPFLF92zDnoKdJl
        pOn9LsvRuPm2dLGExbcuvijphCBAnpEjHcf059qaTzptU0rB5WxQEHtTXoFIDPRi4z8cK7
        ipRR8jh2llRSBUi223vJOYCNMo0uyAA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-Sjz3vM05PgSz-fHbhIqSIQ-1; Fri, 19 Jun 2020 05:40:57 -0400
X-MC-Unique: Sjz3vM05PgSz-fHbhIqSIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 272688035D7;
        Fri, 19 Jun 2020 09:40:56 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 726A971688;
        Fri, 19 Jun 2020 09:40:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC] Revert "KVM: VMX: Micro-optimize vmexit time when not exposing PMU"
Date:   Fri, 19 Jun 2020 11:40:46 +0200
Message-Id: <20200619094046.654019-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest crashes are observed on a Cascade Lake system when 'perf top' is
launched on the host, e.g.

 BUG: unable to handle kernel paging request at fffffe0000073038
 PGD 7ffa7067 P4D 7ffa7067 PUD 7ffa6067 PMD 7ffa5067 PTE ffffffffff120
 Oops: 0000 [#1] SMP PTI
 CPU: 1 PID: 1 Comm: systemd Not tainted 4.18.0+ #380
...
 Call Trace:
  serial8250_console_write+0xfe/0x1f0
  call_console_drivers.constprop.0+0x9d/0x120
  console_unlock+0x1ea/0x460

Call traces are different but the crash is imminent. The problem was
blindly bisected to the commit 041bc42ce2d0 ("KVM: VMX: Micro-optimize
vmexit time when not exposing PMU"). It was also confirmed that the
issue goes away if PMU is exposed to the guest.

With some instrumentation of the guest we can see what is being switched
(when we do atomic_switch_perf_msrs()):

 vmx_vcpu_run: switching 2 msrs
 vmx_vcpu_run: switching MSR38f guest: 70000000d host: 70000000f
 vmx_vcpu_run: switching MSR3f1 guest: 0 host: 2

The current guess is that PEBS (MSR_IA32_PEBS_ENABLE, 0x3f1) is to blame.
Regardless of whether PMU is exposed to the guest or not, PEBS needs to
be disabled upon switch.

This reverts commit 041bc42ce2d0efac3b85bbb81dea8c74b81f4ef9.

Reported-by: Maxime Coquelin <maxime.coquelin@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- Perf/KVM interractions are a mystery to me, thus RFC.
---
 arch/x86/kvm/vmx/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 36c771728c8c..b1a23ad986ff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6728,8 +6728,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_enter(vmx);
 
-	if (vcpu_to_pmu(vcpu)->version)
-		atomic_switch_perf_msrs(vmx);
+	atomic_switch_perf_msrs(vmx);
 	atomic_switch_umwait_control_msr(vmx);
 
 	if (enable_preemption_timer)
-- 
2.25.4

