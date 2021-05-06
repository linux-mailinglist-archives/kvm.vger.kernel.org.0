Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6C337526E
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhEFKfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbhEFKfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 06:35:34 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE80C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 03:34:35 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4FbVLy14KVzQjmt;
        Thu,  6 May 2021 12:34:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        references:in-reply-to:message-id:date:date:subject:subject:from
        :from:received; s=mail20150812; t=1620297271; bh=z2UpZaQTir0vzq1
        Z9CPYLwmm/209nXDFaIL1cvFjUjc=; b=ddmopuzJub9dKUYuFUli1UKs/T57kz9
        mP0pVop6wAFmGqwzZjcAx9Q+aPI4jxmu9H4wiVnEN95yHSjrKQuLHNUX2r/ZoOQH
        W1RcqRkC5xyay6sALgpByY5dvZXGxLwFgHHAx5r9680ulptTQvafYIG5WrvXvwI5
        s440841GQe08uEBZv0GEbx0mDy8evYsFh9iHHGx+acBXvcqFPpXvyovbwXZu4GRb
        1JptDIsy3qD83r/dinalGgdhXRQntRWxXiIVu6uDb+k31Tvhwc5JccdN0A3ITKrN
        4LTN0dM0aIhNWvZIWfnBGXj0gdA54TeNC7tA0Akf3JnDeSmO1ugxvNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1620297272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=AOQezRw/Qhq58C1S76C53S8WJukWtlamNupqTIoEHE4=;
        b=ODrYpKC4rsdmapxAsH5bm2hOh89vr9M2RvOm8BsqGrGWVBQhg27cQp2E7ofK8An4ouSrDv
        En9QyDrxvg2hizxN1VUyKKKU0+2EnW4h6wk12R76lcOStpqF0Lk+JGVtPC+Np8WWbVUge6
        G4K9HUcSLYaC1OzN9orRG0Czgg37/GgRxpeuo8OLFSTiv1ATO55T0TmNX1Ki0dfL7Hd1iE
        wSZPXxZvbZBtl8BSN1dXpnfPfsZyX7OG6JEWc9HliSZDaLwDPr1+BZbFswGcSKtMRh8UiH
        0wfEON6yB50tcdrhMWvekMxc4hS7IL9Jt5uB6y8av0Rjv+KYe+WLZclurdtBmw==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id JqI6ufEz10e9; Thu,  6 May 2021 12:34:31 +0200 (CEST)
From:   ilstam@mailbox.org
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Subject: [PATCH 2/8] KVM: X86: Store L1's TSC scaling ratio in 'struct kvm_vcpu_arch'
Date:   Thu,  6 May 2021 10:32:22 +0000
Message-Id: <20210506103228.67864-3-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-1-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: 140031891
X-Rspamd-UID: d471ff
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilias Stamatis <ilstam@amazon.com>

Store L1's scaling ratio in that struct like we already do for L1's TSC
offset. This allows for easy save/restore when we enter and then exit
the nested guest.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++--
 arch/x86/kvm/x86.c              | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cbbcee0a84f9..132e820525fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -705,7 +705,7 @@ struct kvm_vcpu_arch {
 	} st;
 
 	u64 l1_tsc_offset;
-	u64 tsc_offset;
+	u64 tsc_offset; /* current tsc offset */
 	u64 last_guest_tsc;
 	u64 last_host_tsc;
 	u64 tsc_offset_adjustment;
@@ -719,7 +719,8 @@ struct kvm_vcpu_arch {
 	u32 virtual_tsc_khz;
 	s64 ia32_tsc_adjust_msr;
 	u64 msr_ia32_power_ctl;
-	u64 tsc_scaling_ratio;
+	u64 l1_tsc_scaling_ratio;
+	u64 tsc_scaling_ratio; /* current scaling ratio */
 
 	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
 	unsigned nmi_pending; /* NMI queued after currently running handler */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cebdaa1e3cf5..7bc5155ac6fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2119,6 +2119,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 
 	/* Guest TSC same frequency as host TSC? */
 	if (!scale) {
+		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
 		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
 		return 0;
 	}
@@ -2145,7 +2146,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 		return -1;
 	}
 
-	vcpu->arch.tsc_scaling_ratio = ratio;
+	vcpu->arch.l1_tsc_scaling_ratio = vcpu->arch.tsc_scaling_ratio = ratio;
 	return 0;
 }
 
@@ -2157,6 +2158,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 	/* tsc_khz can be zero if TSC calibration fails */
 	if (user_tsc_khz == 0) {
 		/* set tsc_scaling_ratio to a safe value */
+		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
 		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
 		return -1;
 	}
-- 
2.17.1

