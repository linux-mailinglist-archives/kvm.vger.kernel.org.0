Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EA745B3B0
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 05:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhKXE51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 23:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhKXE5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 23:57:25 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD28C061574;
        Tue, 23 Nov 2021 20:54:16 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1499022pjb.1;
        Tue, 23 Nov 2021 20:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:organization:mime-version
         :content-transfer-encoding;
        bh=C1fBHSHLNb8R9PJCao5SfEesx1PpysiDmw49Wb+sS3c=;
        b=SlmKGIL/HxOnEkagH9jIYQ9gMI0y+9uymTHZYXmLB+hblFw5etRRdXe8f7W7PnXKuS
         Fdel4W17wOBzDHQlj5WF5JmLxfRCTCFepj64mNfxVAs6E5WtKPKb9aXQdajhsPdEAdWt
         iQpQGEXAQon6XAlBrXB8EiYDp5Z2vdlnf8fxKjEidz2x5O1Ju04mXY2OEgEB76CfZP+m
         wa+9Qi4GrVC2434J5RksyuBoT/QVcsqe+UtIWckJneUofkwAAeZ+wMlEXt/eE9AkbYzE
         PHao3dY/K2yfqnfhhVum/6D7ayKpk+R1CLe9RVqW+NGbG9tv7+GpBv8asfMiGQ0XaSos
         jSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-transfer-encoding;
        bh=C1fBHSHLNb8R9PJCao5SfEesx1PpysiDmw49Wb+sS3c=;
        b=esKwpgJeMkTlO0VKtRJfugv2EOAkQlJO9ilFsf9wlGsul/pUTKgoOCvaF+lnspVu02
         gRW9LZxAxagbhjNpKGizHwX7aIYrMPCQ0KsZftND7iJWe5s1yg4u/t2LTNME6YE7Qyz2
         rh3VTz/ASIa9hiPBLaix8KgmYuZwtANhfxKQKf8WQfjmQB/2/dA8kSsYz/r4N3NqkIQ/
         jJsYQJ4UO3BswDzhIgOPcM1aNaAEa/IK0awsNgDbrhFiJrH+186rKTKmIpeJvMMEIM9V
         OLyCYp8VglmzDTeyKJoAH+S2xc78kRZHBOKP8bHB3b0+N2h34JpOW2Y4VbIJNOBbOGPS
         zQHg==
X-Gm-Message-State: AOAM531op10VSU7Wo5i86Ai4RZ3SF2ryYnB08dB8U1Hohg2EzLred7kC
        j/6qBmb4gugqRkk6ww7gc9g=
X-Google-Smtp-Source: ABdhPJx/Dw2AGL/bPMC8Fv2k2ALxwIIquoxif4oI9+zrczcqJISJP+6HemzjI28C9wvSIeKoiPDNWg==
X-Received: by 2002:a17:90a:be10:: with SMTP id a16mr4592535pjs.133.1637729656160;
        Tue, 23 Nov 2021 20:54:16 -0800 (PST)
Received: from localhost.localdomain ([43.128.78.144])
        by smtp.gmail.com with ESMTPSA id p20sm14992984pfw.96.2021.11.23.20.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 20:54:15 -0800 (PST)
Date:   Wed, 24 Nov 2021 12:54:09 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: [PATCH v2] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211124125409.6eec3938@gmail.com>
Organization: ksyun
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aili Yao <yaoaili@kingsoft.com>

When we isolate some pyhiscal cores, We may not use them for kvm guests,
We may use them for other purposes like DPDK, or we can make some kvm
guests isolated and some not, the global judgement pi_inject_timer is
not enough; We may make wrong decisions:

In such a scenario, the guests without isolated cores will not be
permitted to use vmx preemption timer, and tscdeadline fastpath also be
disabled, both will lead to performance penalty.

So check whether the vcpu->cpu is isolated, if not, don't post timer
interrupt.

And when qemu enable -cpu-pm feature for guests, all the available
disable_exit will be set, including mwait,halt,pause,cstate, when
this operation succeed, hlt_in_guest,pause_in_guest,cstate_in_guest
will all be definitly set true with one special case, mwait_in_guest,
this feature's enablement is depended on the HOST cpu feature support;

When cpu-pm is successfully enabled, and hlt_in_guest is true and
mwait_in_guest is false, the guest cant't use Monitor/Mwait instruction
for idle operation, instead, the guest may use halt for that purpose, as
we have enable the cpu-pm feature and hlt_in_guest is true, we will also
minimize the guest exit; For such a scenario, Monitor/Mwait instruction
support is totally disabled, the guest has no way to use Mwait to exit from
non-root mode;

For cpu-pm feature, hlt_in_guest and others except mwait_in_guest will
be a good hint for it. So replace it with hlt_in_guest.

Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
---
 arch/x86/kvm/lapic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 759952dd1222..42aef1accd6b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -34,6 +34,7 @@
 #include <asm/delay.h>
 #include <linux/atomic.h>
 #include <linux/jump_label.h>
+#include <linux/sched/isolation.h>
 #include "kvm_cache_regs.h"
 #include "irq.h"
 #include "ioapic.h"
@@ -113,13 +114,14 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+		!housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);
 }
 
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 {
 	return kvm_x86_ops.set_hv_timer
-	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
+	       && !(kvm_hlt_in_guest(vcpu->kvm) ||
 		    kvm_can_post_timer_interrupt(vcpu));
 }
 EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
-- 
2.25.1

