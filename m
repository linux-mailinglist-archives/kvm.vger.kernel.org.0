Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2805EAA01C
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 12:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbfIEKoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 06:44:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35800 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfIEKog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 06:44:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so1217696pgv.2;
        Thu, 05 Sep 2019 03:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=54y2QMAiCvInXUhjF/5299Z9zWajcWTy7f1EMF8YUwY=;
        b=XULESHgX8sjFoyDdlyIWLV5v5m9Tw/PeM50SJp2525wLWiamyvwmGBlQhRfaqM5Hen
         ThdcDOIqeQa2pjdEqAaYPJrhy5YaG6dSobtLjhY4y0kbeuo3MIQCc35VFmhKZlK0SpFx
         Bt7lAi0ecdtPsa0jc6pD6XOQPf4FbngItvvYmQwD608bSqgOsxaz1AZEqd5H7AjqN3gp
         xA64PQeiICbP4OhDHlAkux4FZjU1kolLsyfakLxi01NbOtPWvDUYtzK+vEg0i4xyJiF6
         Lp9qRUyTnhqdQEBzKA16appGb6w4y6t6sHmT+fwkf5p/lnv5Nkdh1tKSh9H+16nSPoYm
         sZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=54y2QMAiCvInXUhjF/5299Z9zWajcWTy7f1EMF8YUwY=;
        b=IHK7m2scjj9wdhJ5OcOlehkRgYIjMHNcmS6BW85DRb1eMkOeGgJSKv2BlXzJVu7ubA
         GJ6MgS9X7OWAdkcYkbhsc9aWA1uz8QTbWNwFsP7OBHGk104OU8iKPMVbl3EQfA2HwYlY
         pudeOHSQfUn/+HHHnCHJ2GCkCQOe++9SrtK/liPYloOKKrDc4m7PiSm8e2fEfY21vSFx
         LK1QDZyPEDeeyNI3pCmKYc7tM9DgXS/32QYJfMdhEHujzHkE/9oNK70ZMf9Oun9mhbof
         JizjUXjSkSLymI1IPLH/bR14Y5n0ZN9hgveXc+6frYq0bpqYy64nt600QqeKoSY122HG
         v3Kg==
X-Gm-Message-State: APjAAAUPPJbPSKPXsDvDVmZZSIutIyn5MSAOJIrBUcVvBn95XYq/Zcco
        uWPES5WYmySk9pFPHw43iBR/TxI7
X-Google-Smtp-Source: APXvYqwtfT4BMVhsNb3sr+Od6dCMm4NoT3zVCcWL1nLDUGzl6n/UlJugCP6NCIDRQP8hQ35ELauoZQ==
X-Received: by 2002:a62:3887:: with SMTP id f129mr2986497pfa.245.1567680275873;
        Thu, 05 Sep 2019 03:44:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id dw14sm1070779pjb.2.2019.09.05.03.44.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 05 Sep 2019 03:44:35 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] KVM: LAPIC: Fix SynIC Timers inject timer interrupt w/o LAPIC present
Date:   Thu,  5 Sep 2019 18:44:30 +0800
Message-Id: <1567680270-14022-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reported by syzkaller:

	kasan: GPF could be caused by NULL-ptr deref or user memory access
	general protection fault: 0000 [#1] PREEMPT SMP KASAN
	RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
	Call Trace:
	kvm_apic_set_irq+0xb4/0x140 arch/x86/kvm/lapic.c:558
	stimer_notify_direct arch/x86/kvm/hyperv.c:648 [inline]
	stimer_expiration arch/x86/kvm/hyperv.c:659 [inline]
	kvm_hv_process_stimers+0x594/0x1650 arch/x86/kvm/hyperv.c:686
	vcpu_enter_guest+0x2b2a/0x54b0 arch/x86/kvm/x86.c:7896
	vcpu_run+0x393/0xd40 arch/x86/kvm/x86.c:8152
	kvm_arch_vcpu_ioctl_run+0x636/0x900 arch/x86/kvm/x86.c:8360
	kvm_vcpu_ioctl+0x6cf/0xaf0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2765

The testcase programs HV_X64_MSR_STIMERn_CONFIG/HV_X64_MSR_STIMERn_COUNT,
in addition, there is no lapic in the kernel, the counters value are small 
enough in order that kvm_hv_process_stimers() inject this already-expired 
timer interrupt into the guest through lapic in the kernel which triggers 
the NULL deferencing. This patch fixes it by checking lapic_in_kernel, 
discarding the inject if it is 0.

Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/hyperv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index c10a8b1..461fcc5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -645,7 +645,9 @@ static int stimer_notify_direct(struct kvm_vcpu_hv_stimer *stimer)
 		.vector = stimer->config.apic_vector
 	};
 
-	return !kvm_apic_set_irq(vcpu, &irq, NULL);
+	if (lapic_in_kernel(vcpu))
+		return !kvm_apic_set_irq(vcpu, &irq, NULL);
+	return 0;
 }
 
 static void stimer_expiration(struct kvm_vcpu_hv_stimer *stimer)
-- 
2.7.4

