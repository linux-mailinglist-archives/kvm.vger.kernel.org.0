Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F58617F0CD
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 08:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgCJHB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 03:01:26 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44678 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgCJHB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 03:01:26 -0400
Received: by mail-pl1-f196.google.com with SMTP id d9so5059926plo.11;
        Tue, 10 Mar 2020 00:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YVCc+DwPWWPXpUGQIKeRYvwB/hOaYmc0ZXRCQL5h/QI=;
        b=Ch9tuHA5mP7aZFRWp0dUFohQRYj+RTodiPvpCIpy4uvOXMytCkwdiMZ8Fwni/PV1Nj
         gUjFzAIGWPoFoGnUY4THtMnyY/X+jN3DJJ/BxpHSt3HVYYq22nZ59dxdQqW/co+r7VYN
         Q0ZQvxNXcEsmMocQ6TZGyvzuK7zrhPG75zitXlYJzcwYg0B/QADaBME/215jJcAe6t3e
         0ZBrSTlKoZRb6o4kiw3ItxxWf44Bea+Mz142XjKc/nR0uuGB5RGH6nheTo2d5g+va3Vw
         2yweAWeEhHJ2kF1UhpbB2jCnYSF2UsHsaxTqwXnK/dIzivkulWBYkDHbrA0Tq3TRASph
         CuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YVCc+DwPWWPXpUGQIKeRYvwB/hOaYmc0ZXRCQL5h/QI=;
        b=twlSLYhPvXzTu9HmseqhisVOvU8lSxXW9Xnc3fktx6cMBgXrVZcG11SoCvhuxePCIA
         SHw/OYjp3z+sSirf164pj3kzAlDzFHV4CWBpzJ5ZjMxXopN2J40cZJB+RU0x+rxorrcr
         PD2ave4wm7J+3HwR1fuQ+xEZeavAsQjl7njhbx3j9OgfulFxGvdb76iTOZr5xBFovaDD
         8S5uKfZ02yYj6oea2eQVX8FdxU9/2sDOB0qJH1n5HhCTEDv3jQX9Z3oUT53DOvjOUnnh
         079PwwcnPwI2oce2/VDzYSDkQ78NmxRCfNp8TsIE8QTtQ/QxFVlOjYOum4qzusMzYAVg
         fCng==
X-Gm-Message-State: ANhLgQ1Um/tRwTfz9tjiWBqRxC6Xelc9cpJT4hh4EqA8VEN8Hk+aFjtb
        AE5obU77nr/66it+KBhdBtP2lww9
X-Google-Smtp-Source: ADFU+vtWyb9wxDCHh+eWg5cFe/KSNXdnPSQSZLGp23dJF5fr7mZVeuzE2lhp5gRqVxgsx9KRANH4EA==
X-Received: by 2002:a17:90a:a409:: with SMTP id y9mr261468pjp.103.1583823685319;
        Tue, 10 Mar 2020 00:01:25 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id k14sm1645934pje.3.2020.03.10.00.01.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 00:01:24 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: X86: Don't load/put guest FPU context for sleeping AP
Date:   Tue, 10 Mar 2020 15:01:19 +0800
Message-Id: <1583823679-17648-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

kvm_load_guest_fpu() and kvm_put_guest_fpu() each consume more than 14us 
observed by ftrace, the qemu userspace FPU is swapped out for the guest 
FPU context for the duration of the KVM_RUN ioctl even if sleeping AP, 
we shouldn't load/put guest FPU context for this case especially for 
serverless scenario which sensitives to boot time.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5de2006..080ffa4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8680,7 +8680,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
-	kvm_load_guest_fpu(vcpu);
 
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		if (kvm_run->immediate_exit) {
@@ -8718,12 +8717,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		}
 	}
 
+	kvm_load_guest_fpu(vcpu);
+
 	if (unlikely(vcpu->arch.complete_userspace_io)) {
 		int (*cui)(struct kvm_vcpu *) = vcpu->arch.complete_userspace_io;
 		vcpu->arch.complete_userspace_io = NULL;
 		r = cui(vcpu);
 		if (r <= 0)
-			goto out;
+			goto out_fpu;
 	} else
 		WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed);
 
@@ -8732,8 +8733,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	else
 		r = vcpu_run(vcpu);
 
-out:
+out_fpu:
 	kvm_put_guest_fpu(vcpu);
+out:
 	if (vcpu->run->kvm_valid_regs)
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
-- 
2.7.4

