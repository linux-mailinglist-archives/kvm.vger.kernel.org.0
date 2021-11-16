Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCF7452F33
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 11:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhKPKho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 05:37:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234267AbhKPKhm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 05:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637058884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3MiB1D6R8uEZ4fYPIm6H41sSxei2ZXjA1gaGxUhCl+E=;
        b=He02gcD6eIswwT4DtTEDFCC2IGzAJYLKJ1TzeKm0mpAD8xzm1QnnhT3b0EDxDVJnodxnwZ
        xXJQS19r9EWaVZzhRE8S0/1pWPdRG0Vek2vMRjIep9NG9+7zJ6nBembjh3Zz7Mri+QmasT
        M2kuUBGUHQyCn0tDQsxVahLz37y3tG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-c4Z3Mk0ZOyu7jQcMqzSCqg-1; Tue, 16 Nov 2021 05:34:43 -0500
X-MC-Unique: c4Z3Mk0ZOyu7jQcMqzSCqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 857F8100C66C
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 10:34:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (unknown [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 455E060C13;
        Tue, 16 Nov 2021 10:34:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com
Subject: [PATCH kvm-unit-tests] x86: mark KVM-only tests
Date:   Tue, 16 Nov 2021 05:34:38 -0500
Message-Id: <20211116103438.674714-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TCG does not emulate the PMU nor the intricacies of the VMware
backdoor I/O port.  Disable those tests unless running on KVM.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/unittests.cfg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 6585df4..efdc89a 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -178,12 +178,14 @@ extra_params = -cpu max,vendor=GenuineIntel
 file = pmu.flat
 extra_params = -cpu max
 check = /proc/sys/kernel/nmi_watchdog=0
+accel = kvm
 
 [pmu_lbr]
 file = pmu_lbr.flat
 extra_params = -cpu host,migratable=no
 check = /sys/module/kvm/parameters/ignore_msrs=N
 check = /proc/sys/kernel/nmi_watchdog=0
+accel = kvm
 
 [pmu_emulation]
 file = pmu.flat
@@ -191,12 +193,14 @@ arch = x86_64
 extra_params = -cpu max -append emulation
 check = /sys/module/kvm_intel/parameters/force_emulation_prefix=Y
 check = /proc/sys/kernel/nmi_watchdog=0
+accel = kvm
 
 [vmware_backdoors]
 file = vmware_backdoors.flat
 extra_params = -machine vmport=on -cpu max
 check = /sys/module/kvm/parameters/enable_vmware_backdoor=Y
 arch = x86_64
+accel = kvm
 
 [realmode]
 file = realmode.flat
-- 
2.27.0

