Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1DB30A369
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 09:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhBAIhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 03:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhBAIhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 03:37:36 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2707AC061573;
        Mon,  1 Feb 2021 00:36:56 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id j2so9937944pgl.0;
        Mon, 01 Feb 2021 00:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eVINvg/Fw9V8hooodk2Ygvx8KN7ol+WUF2ilOSjWNrQ=;
        b=Nj1jwMQ3BLyOEU9G7jUae9Ir45WM27dbdJkb5RAkU+3teGa59eOJkXNV6ESVQJ+X34
         3qkKryIAX8hQRWgKeattWPAmBEZCqUtvTwv0yLyX/NO1ubjnqNy0/M4ewa+QCrWUKWDl
         5z8UEjYEv3PuWLfyKldEPTIYbquhRCLFOksH9ugAJZAQxWJgOAjg53hoqXg8XMPx6lBU
         9nZhy6Yy75LHuXII1dIYDRzPfGQpMGXagoOZ04pVXVNWEiDby3c3dD6vfwRaEMH9FEAI
         XLtZRxO4PlQ+WUYzHqlGeuuHPUOVk3ncXq3GX/8zLRNwMY4iZh0MzDYpNgUHKvrs7I8D
         A+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eVINvg/Fw9V8hooodk2Ygvx8KN7ol+WUF2ilOSjWNrQ=;
        b=UiG0Tslyv6NmqV6PogbhPX0vn8BVWPF5g4PZp3jeGkQ/COilCfeCtVhhORxg/hzyUd
         +xw6JpqDMhJRJRpJiDo57VUsIywH2SzjnjBWs5Wf9UZ+Ok7Wy37uuMzrqfgw8BL4qm9y
         7cANAlGYC8t8vNeob5weJgGhJj19+kZfftpQsG8V3Hek0IBNpFU1eDuY51MRlUTpe60o
         QeDJ71ntdni2BYQSFALHNE4j+XbigXW4RiwwfbiuavekSt/4SHGZO9O2eXUxmCRejfWN
         AvowDiq3aqy5hu4N+Ilz/7GXB7EpXp0mO7Yi1xff+qsLIHLoWcb1lYBa2dGF2gf0fAgF
         uUWQ==
X-Gm-Message-State: AOAM531lNspjhlurC8rRgvlps4HJ4dt5mplNx25UEsktmaFwCQHSY4BG
        NuE0nlIi1N2rS0fJa6hYhjd7SNTwAsPpng==
X-Google-Smtp-Source: ABdhPJzJjlaC3zpkzKamcZUZW5v4s6e6oNTOtMTymP4gZzLu8JTAVNzp83KtRgZ3oKOKid3mcFZQrw==
X-Received: by 2002:a63:5526:: with SMTP id j38mr16180273pgb.177.1612168615250;
        Mon, 01 Feb 2021 00:36:55 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id t25sm17234032pgv.30.2021.02.01.00.36.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Feb 2021 00:36:54 -0800 (PST)
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
Subject: [PATCH v3] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
Date:   Mon,  1 Feb 2021 16:36:27 +0800
Message-Id: <1612168596-3782-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

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
Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: stable@vger.kernel.org#v4.19-rc5+
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * allocate dynamically memory unconditionally
v1 -> v2:
 * add code comments

 arch/x86/kernel/kvmclock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa59374..a72b16e 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -268,6 +268,8 @@ static void __init kvmclock_init_mem(void)
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
 {
+	kvmclock_init_mem();
+
 #ifdef CONFIG_X86_64
 	u8 flags;
 
@@ -281,8 +283,6 @@ static int __init kvm_setup_vsyscall_timeinfo(void)
 	kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
 #endif
 
-	kvmclock_init_mem();
-
 	return 0;
 }
 early_initcall(kvm_setup_vsyscall_timeinfo);
-- 
2.7.4

