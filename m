Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9982F9C80
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388236AbhARJjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 04:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388359AbhARJIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 04:08:54 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0658C061573;
        Mon, 18 Jan 2021 01:08:13 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id l23so9371226pjg.1;
        Mon, 18 Jan 2021 01:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oQRRXCmQGQuZCQYLuXtxMPDteVSg+sjt+B2CXlJY5uY=;
        b=mFLSEyB+WhWxpHiQ5SDX8AgkmO6t61ZxQLrGeseRTFKcpVG2KYbZOvC1IcKSb9UB8n
         FbsEINhEJ6SYW4NHfcFQdk2qC3jwlv9imhbzy+v2yhCaaN8k9lqJ+oxu4M8Y1Xrl9+Nd
         LAfYKUDdeeqRQ8u9/FIaMuHJBqXBGE79t56lFKYtluKT5RweAdMZHTUxYQedhejjDBnK
         vk9I8Bie++azRpZ9WBspDKbAcjLmhrabBfJ18dBpsOdmKzRgqdrwlbtoC7wZiWli79rL
         eC5Y4LuRFjsWKdlE+lTeeREMjoz58xz/D2EP8vc+nqY6Pm9gq5g6Wh8PXC7w8IWmPv5E
         oNMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oQRRXCmQGQuZCQYLuXtxMPDteVSg+sjt+B2CXlJY5uY=;
        b=FasCIC4z8+SXxWpaVb4otPe4+DHTIFXtcocfV2q+C71j26iped/0cODaVeUAgddU+e
         gooz/kDnkE6v8xH0Fz4Z4WcYA7nR1Wb2F6RK6r7411JPlasUcTUFwlsZITLgLauRM5rr
         8mOVVd/MBTxJjHpVfAkLLAyjgsO5/hLkgsFzXq7kqXndo00huLsu7WnKszESsr/Gb7dl
         PKTgFdXBygIlHVhX+tmobxjdYild0HMlayDEogQrs0F9+WwqxS8tRgabSag+CzRAkWyM
         +Y7mB+/3wC88J5e1ZhCGfIB4n5hjM9cxP3FMlLa+cnuvj/9V+l/F5rJ69FmRPtEE1+z1
         Lmcg==
X-Gm-Message-State: AOAM531erOsz0yc5RRvdRWUOhicGGA1Kjp8xRSJyu0h12u6rbZy5kLoa
        l3MQNf5HZ5BnMzICPIrH3pNlmQHUMHk=
X-Google-Smtp-Source: ABdhPJxJBsHPSINp5FR+JCVHGdC/tIYhE5D4jiNCxl3I8JYQyucDZzbeiNFS3GArZSdv6WjL08yZfA==
X-Received: by 2002:a17:902:8a8a:b029:db:e003:4044 with SMTP id p10-20020a1709028a8ab02900dbe0034044mr25859233plo.19.1610960892926;
        Mon, 18 Jan 2021 01:08:12 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id s23sm15186928pgj.29.2021.01.18.01.08.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jan 2021 01:08:12 -0800 (PST)
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
Subject: [PATCH v2] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
Date:   Mon, 18 Jan 2021 17:07:53 +0800
Message-Id: <1610960877-3110-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The per-cpu vsyscall pvclock data pointer assigns either an element of the 
static array hv_clock_boot (#vCPU <= 64) or dynamically allocated memory 
hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if 
kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in 
kvmclock_setup_percpu() which returns -ENOMEM. This patch fixes it by not 
assigning vsyscall pvclock data pointer if kvmclock vdso_clock_mode is not 
VDSO_CLOCKMODE_PVCLOCK.

Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared variables")
Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: stable@vger.kernel.org#v4.19-rc5+
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * add code comments

 arch/x86/kernel/kvmclock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa59374..01d4e55c 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -294,9 +294,11 @@ static int kvmclock_setup_percpu(unsigned int cpu)
 	/*
 	 * The per cpu area setup replicates CPU0 data to all cpu
 	 * pointers. So carefully check. CPU0 has been set up in init
-	 * already.
+	 * already. Assign vsyscall pvclock data pointer iff kvmclock
+	 * vsyscall is enabled.
 	 */
-	if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)))
+	if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)) ||
+	    (kvm_clock.vdso_clock_mode != VDSO_CLOCKMODE_PVCLOCK))
 		return 0;
 
 	/* Use the static page for the first CPUs, allocate otherwise */
-- 
2.7.4

