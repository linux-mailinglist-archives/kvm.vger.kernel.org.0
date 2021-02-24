Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA50232355F
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 02:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhBXBjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 20:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhBXBiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 20:38:55 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B917EC061574;
        Tue, 23 Feb 2021 17:38:14 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id j12so215055pfj.12;
        Tue, 23 Feb 2021 17:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PCXVBw+FVq9Qv7Zgo9oRjK2xe7y4k5Oj/v44tVkJbo0=;
        b=BzANR0kJ0Fql1BVqLO7DnIkZ3agBiRBMZ6/U31p70gakfCYgStJ2M0NxYbDiAv3wkO
         LTDQUJ4IMBxPgO6kNi637XPnIHwEaXrzNIDl353nkG5ilyHai6E1AB8V4DUATcjiqaN7
         nNVuSbD1a4znNNpqlVh37CG9HBQ/mw5ggtCeQC2ntjUjQYNrVXsikK9GPNRdqGt+bgF+
         nx8wPq/dFdkPwIokb1paqGOvAWznX7lkiDwMFUPQi4O0nXHr7mDDaa/JD5RDRExDt3xk
         K3jxbe9Lq3FxryDETbMhX/evp7ZGqAvtFeCOzNtUy5WI21u5Q7c8RfQSQRcQhRM8DScQ
         nilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PCXVBw+FVq9Qv7Zgo9oRjK2xe7y4k5Oj/v44tVkJbo0=;
        b=FJCh2tXVGbUwcXCxlBn39H1/1ilfvXxAcGEBDogfIo1gGl0Pjaop8tmvXrX3QCNp2I
         kuSSnnRjigNLwPyWlb3hWcKKBjHkLGA+tFS36Uk6lyGy9DTSsHJFLEbBf9TqyS4Nb0Fj
         O7kC/PWRdA3gGETRqftlg7EcM0hxfiOnqkp/qae1vcyQTQpIlfOyujqm4rm0fXxwxD2R
         8IM3clPZSQkmhwWYhxW7DVC6VWg1BIIy8IlvX14Um+RQq/cAsBXfKrcY+YdS6zrj1+1f
         WXkqQ+6V1Msi6rGAGHVXmVwpcEo23+IGfJCtGrfyWPuv+bylIFDJaX8/Mk0i+n4oNKGe
         pEGg==
X-Gm-Message-State: AOAM532OWHcB6f5p5oDPcHEdaCQqBCbSRcbhhnuOKCT9/y0uc+WfVg77
        V19/qma9T0fQXxc9eMUr1FCVeAVau+Y=
X-Google-Smtp-Source: ABdhPJzJshRJmbbt1UgbHujf4RlK2kPBVuv+u8LI9fmqOatvvdvhrMXceRut6hmhsPt2Imd1dKNXiQ==
X-Received: by 2002:a63:da03:: with SMTP id c3mr25765435pgh.176.1614130693933;
        Tue, 23 Feb 2021 17:38:13 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id g141sm422496pfb.67.2021.02.23.17.38.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Feb 2021 17:38:13 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v4] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
Date:   Wed, 24 Feb 2021 09:37:29 +0800
Message-Id: <1614130683-24137-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                88
On-line CPU(s) list:   0-63
Off-line CPU(s) list:  64-87

# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-5.10.0-rc3-tlinux2-0050+ root=/dev/mapper/cl-root ro 
rd.lvm.lv=cl/root rhgb quiet console=ttyS0 LANG=en_US .UTF-8 no-kvmclock-vsyscall

# echo 1 > /sys/devices/system/cpu/cpu76/online
-bash: echo: write error: Cannot allocate memory

The per-cpu vsyscall pvclock data pointer assigns either an element of the 
static array hv_clock_boot (#vCPU <= 64) or dynamically allocated memory 
hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if 
kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in 
kvmclock_setup_percpu() which returns -ENOMEM. It's broken for no-vsyscall
and sometimes you end up with vsyscall disabled if the host does something 
strange. This patch fixes it by allocating this dynamically memory 
unconditionally even if vsyscall is disabled.

Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared variables")
Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: stable@vger.kernel.org#v4.19-rc5+
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v3 -> v4:
 * fix kernel test robot report WARNING
v2 -> v3:
 * allocate dynamically memory unconditionally
v1 -> v2:
 * add code comments

 arch/x86/kernel/kvmclock.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa59374..1fc0962 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -268,21 +268,20 @@ static void __init kvmclock_init_mem(void)
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
 {
-#ifdef CONFIG_X86_64
-	u8 flags;
+	kvmclock_init_mem();
 
-	if (!per_cpu(hv_clock_per_cpu, 0) || !kvmclock_vsyscall)
-		return 0;
+#ifdef CONFIG_X86_64
+	if (per_cpu(hv_clock_per_cpu, 0) && kvmclock_vsyscall) {
+		u8 flags;
 
-	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-	if (!(flags & PVCLOCK_TSC_STABLE_BIT))
-		return 0;
+		flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
+		if (!(flags & PVCLOCK_TSC_STABLE_BIT))
+			return 0;
 
-	kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
+		kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
+	}
 #endif
 
-	kvmclock_init_mem();
-
 	return 0;
 }
 early_initcall(kvm_setup_vsyscall_timeinfo);
-- 
2.7.4

