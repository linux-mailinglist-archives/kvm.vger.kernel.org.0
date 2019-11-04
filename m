Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A3EEF0E6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbfKDXAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:00:16 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28451 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730121AbfKDXAQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 18:00:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572908415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+tPxnHSoO16n5+Sy5wmIEDxZvcTP3JroTMdKGRpMAx0=;
        b=HuQCO9OG2jd8lPrUKZiQt6y9dX7rXoVTbrJO8f+JFWS5rXQ4eB49/WpumAma+tinMBD5Bn
        P/l5hJe2eQrpy20NtCDmHARQAAp2S7GnmToGiqFWa1hMK3H2Conia+MWftc+o3lDCG2tlm
        4fcYFnRKQHGcjb5P5uBwe4+JCiXaEGE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-6X7J1Ko-PnGdXzYrSSTdYA-1; Mon, 04 Nov 2019 18:00:10 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CD52800C73;
        Mon,  4 Nov 2019 23:00:09 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 606AF5D6D0;
        Mon,  4 Nov 2019 23:00:09 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 13/13] x86: retpolines: eliminate retpoline from msr event handlers
Date:   Mon,  4 Nov 2019 18:00:01 -0500
Message-Id: <20191104230001.27774-14-aarcange@redhat.com>
In-Reply-To: <20191104230001.27774-1-aarcange@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 6X7J1Ko-PnGdXzYrSSTdYA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
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
index fcef678c3423..937363b803c1 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3323,8 +3323,19 @@ static int intel_pmu_hw_config(struct perf_event *ev=
ent)
 =09return 0;
 }
=20
+#ifdef CONFIG_RETPOLINE
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr);
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr);
+#endif
+
 struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
+#ifdef CONFIG_RETPOLINE
+=09if (x86_pmu.guest_get_msrs =3D=3D intel_guest_get_msrs)
+=09=09return intel_guest_get_msrs(nr);
+=09else if (x86_pmu.guest_get_msrs =3D=3D core_guest_get_msrs)
+=09=09return core_guest_get_msrs(nr);
+#endif
 =09if (x86_pmu.guest_get_msrs)
 =09=09return x86_pmu.guest_get_msrs(nr);
 =09*nr =3D 0;

