Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83FCB98FC
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 23:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393915AbfITV0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 17:26:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393779AbfITVZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 17:25:14 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 10B208980EA;
        Fri, 20 Sep 2019 21:25:14 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E76295D6B2;
        Fri, 20 Sep 2019 21:25:13 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/17] x86: retpolines: eliminate retpoline from msr event handlers
Date:   Fri, 20 Sep 2019 17:25:09 -0400
Message-Id: <20190920212509.2578-18-aarcange@redhat.com>
In-Reply-To: <20190920212509.2578-1-aarcange@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Fri, 20 Sep 2019 21:25:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's enough to check the value and issue the direct call.

After this commit is applied, here the most common retpolines executed
under a high resolution timer workload in the guest on a VMX host:

[..]
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 267
@[]: 2256
@[
    trace_retpoline+1
    __trace_retpoline+30
    __x86_indirect_thunk_rax+33
    __kvm_wait_lapic_expire+284
    vmx_vcpu_run.part.97+1091
    vcpu_enter_guest+377
    kvm_arch_vcpu_ioctl_run+261
    kvm_vcpu_ioctl+559
    do_vfs_ioctl+164
    ksys_ioctl+96
    __x64_sys_ioctl+22
    do_syscall_64+89
    entry_SYSCALL_64_after_hwframe+68
]: 2390
@[]: 33410

@total: 315707

Note the highest hit above is __delay so probably not worth optimizing
even if it would be more frequent than 2k hits per sec.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/events/intel/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 27ee47a7be66..65b383d5e062 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3323,8 +3323,19 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
+#ifdef CONFIG_RETPOLINE
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr);
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr);
+#endif
+
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
+#ifdef CONFIG_RETPOLINE
+	if (x86_pmu.guest_get_msrs == intel_guest_get_msrs)
+		return intel_guest_get_msrs(nr);
+	else if (x86_pmu.guest_get_msrs == core_guest_get_msrs)
+		return core_guest_get_msrs(nr);
+#endif
 	if (x86_pmu.guest_get_msrs)
 		return x86_pmu.guest_get_msrs(nr);
 	*nr = 0;
