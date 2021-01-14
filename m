Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B122F5FEB
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbhANL2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbhANL2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 06:28:01 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70348C061574;
        Thu, 14 Jan 2021 03:27:15 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b8so2769059plx.0;
        Thu, 14 Jan 2021 03:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+ahAs1amo347RNXkYJWCZ9woGbW2UnM8CDWcOU1vF2o=;
        b=D/jG69CXI0DgiRLmOMiDexv151tVKOYLHzy7fqOI/Ojwr89bsBjpxk1jyjQbg6IyON
         HXKaOUzJOkB+WrW7inSnTeyzK4I4zZlI7MSXAXjCHer2yprVG4fAJ2n8KX6aB6JgNMD8
         FvMepAHoM44bmfY42U9MsZd6u1Huavhd5T/bjetdnBBJ/qYp5A+qR3jTwq7FCPhRNMvG
         mQs//5KPzdbOU0WOKlrfXT+cRvS8dqix5NM/E1cIiLyFX6TQYqQuui7aoIsr12iDExJD
         VpFRwNfoO1AfZ/QuG06nag5QEAI3ttJm6jYRGj3GVapfbgVVUUb7SOqq+/uA1qqnZs+M
         q7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+ahAs1amo347RNXkYJWCZ9woGbW2UnM8CDWcOU1vF2o=;
        b=GqPp7FU2XN50oEXw6BeyvD9+bUxhBtJDzfAnoXH+GtYOdDLUGIaujCTQTSZ1ZW87cc
         MbAmtgtJEDgoOMLIL//9idGUevXz1wCXGYmcABClbDPS/t3o+SwLHGFfVOOl9q70GAza
         er2c7nHA2mUti8G9aPCoE4U6B5ZE1hk/D9B+Gm5idpx0jalcQPRta1wwOYJyIpSHNEfX
         aOIg8vnheGDllLPVAOBbkr0h8oHjDGicvytIlLhLPoThUu07ctzG02PpFUauS8LtnFxd
         Qs/xwbRdjHF2ztd3Mi1DkmELHhAeTn1/MxuzO/MHxEReoalDxGwKo+mLmGhD/kXaqaxd
         Znsg==
X-Gm-Message-State: AOAM532ubTHHKoyzxc+33G00zV2N478/C4n4PGqGSB7RuopZLlLqsKjv
        re/fyatuWgPMs8IrA/9RGvc+61R9bsI=
X-Google-Smtp-Source: ABdhPJy7Da3wPrakUrDmoeu8jQQd+au8pjcn3oxJWf4szYLgljbRKTt+QfxsIyf++DNDfvEhYM0h2w==
X-Received: by 2002:a17:90a:d3cc:: with SMTP id d12mr4426882pjw.202.1610623634764;
        Thu, 14 Jan 2021 03:27:14 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id c24sm563629pjs.3.2021.01.14.03.27.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jan 2021 03:27:14 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
Date:   Thu, 14 Jan 2021 19:27:03 +0800
Message-Id: <1610623624-18697-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kernel/kvmclock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa59374..0624290 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -296,7 +296,8 @@ static int kvmclock_setup_percpu(unsigned int cpu)
 	 * pointers. So carefully check. CPU0 has been set up in init
 	 * already.
 	 */
-	if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)))
+	if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)) ||
+	    (kvm_clock.vdso_clock_mode != VDSO_CLOCKMODE_PVCLOCK))
 		return 0;
 
 	/* Use the static page for the first CPUs, allocate otherwise */
-- 
2.7.4

