Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A141775EC1
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 08:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfGZGKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 02:10:25 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45674 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfGZGKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 02:10:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so24219772pgp.12;
        Thu, 25 Jul 2019 23:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dsM74ng/+OcAlXBDq3JGUl8fa3U6dOaT9r2XMZw1hC4=;
        b=atboVViFYZD+wIpeQVXz92sQVk1Nm/NYZtyb6YL/YVmJOYV94UfvjZpYbm2TQ1cja6
         TOdLvh2i9mQdnaaTHy3xQzw9L7eC4dcRLlWhp1ofwHkcxN25HIxTvqYxFS3un342a14D
         y/F3r/ljq0yKTXGI/17G1Ms8cxCC9K6E5uHt6x04ujs1RmLqrR95kNTa+PXKBRkv2eix
         9FewEza5ivvSqYPFXi9hh1E0OQnbwzTubcH/pWcRj/N5bkV9gMHEOMxj3NUSHW6mWwY/
         nj33m3l8L1E5jqUcLmNTi8s6CIeU/2kSG5lwezvWVyOEjFgYvm3wlOzKkEbQTMZ0B2iy
         UbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dsM74ng/+OcAlXBDq3JGUl8fa3U6dOaT9r2XMZw1hC4=;
        b=bSIkwFE+HLbhr4dFZDbEAZTB/PVN+itUTq0iWsYvTSJ0K4pzg6MzVDrRGJqC6Jc+4V
         B4NsetpHy5ANPA8MEMIeLmjhZLvVbJQPygjQ5CsQ744rgft9dLHu2qzgO5U5YqGtNlNq
         8c/XsRrXnu90RNw0ZQNFGogrJHlcfJd4VwrS5B5gqDXGH/1yu7j+5sWXVq8tOQ+as2BP
         fCsZU7Rosj50O016Ypl03uKtp0vow5TvZimfCuP41Wt39vA7JdjWxQNY/bBtlyffmslE
         98n/S+KUwh1EI4jY9SSHUzRbDrg31tGsCU9jogAkbGLzVEociexxsZ4rqev1mcIyh0fK
         b8ng==
X-Gm-Message-State: APjAAAVlrPBMYQmez6Vc5nKbgVOOgFOO7yA+BVvMd6/lGm6fEPISniLx
        CPxQzQSqp2r9sB6L4HGugZ6nlU38FQU=
X-Google-Smtp-Source: APXvYqzL9cfwoAS5aI4ajw1kg/Hf86nRIzKb35U8xlsN5bjX1APCIUWsGogaMEYHNrsFo2BdpcVj7Q==
X-Received: by 2002:a63:5920:: with SMTP id n32mr86699340pgb.352.1564121424041;
        Thu, 25 Jul 2019 23:10:24 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id m31sm58352070pjb.6.2019.07.25.23.10.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 25 Jul 2019 23:10:23 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Nadav Amit <namit@vmware.com>
Subject: [PATCH] KVM: X86: Use IPI shorthands in kvm guest when support
Date:   Fri, 26 Jul 2019 14:10:17 +0800
Message-Id: <1564121417-29375-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

IPI shorthand is supported now by linux apic/x2apic driver, switch to 
IPI shorthand for all excluding self and all including self destination 
shorthand in kvm guest, to avoid splitting the target mask into serveral 
PV IPI hypercalls.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Nadav Amit <namit@vmware.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
Note: rebase against tip tree's x86/apic branch

 arch/x86/kernel/kvm.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b7f34fe..87b73b8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -34,7 +34,9 @@
 #include <asm/hypervisor.h>
 #include <asm/tlb.h>
 
+static struct apic orig_apic;
 static int kvmapf = 1;
+DECLARE_STATIC_KEY_FALSE(apic_use_ipi_shorthand);
 
 static int __init parse_no_kvmapf(char *arg)
 {
@@ -507,12 +509,18 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 
 static void kvm_send_ipi_allbutself(int vector)
 {
-	kvm_send_ipi_mask_allbutself(cpu_online_mask, vector);
+	if (static_branch_likely(&apic_use_ipi_shorthand))
+		orig_apic.send_IPI_allbutself(vector);
+	else
+		kvm_send_ipi_mask_allbutself(cpu_online_mask, vector);
 }
 
 static void kvm_send_ipi_all(int vector)
 {
-	__send_ipi_mask(cpu_online_mask, vector);
+	if (static_branch_likely(&apic_use_ipi_shorthand))
+		orig_apic.send_IPI_allbutself(vector);
+	else
+		__send_ipi_mask(cpu_online_mask, vector);
 }
 
 /*
@@ -520,6 +528,8 @@ static void kvm_send_ipi_all(int vector)
  */
 static void kvm_setup_pv_ipi(void)
 {
+	orig_apic = *apic;
+
 	apic->send_IPI_mask = kvm_send_ipi_mask;
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
 	apic->send_IPI_allbutself = kvm_send_ipi_allbutself;
-- 
2.7.4

