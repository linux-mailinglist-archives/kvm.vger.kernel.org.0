Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0124679E84
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 04:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbfG3CQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 22:16:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40115 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730514AbfG3CQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 22:16:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so29202615pgj.7;
        Mon, 29 Jul 2019 19:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MHeqW4XGwRZCSnKm2FHh/NR+ei+oiNfLETPiRLzlp1c=;
        b=V/KPPgBlV0awF1PGIW53YT1rmjWx6JGJT49TDhUesas9BTCDfXAFGbaByyw1eysAg9
         bvgRA4v6ypGKIo0529BdCFOokDNe44HsdOzhKZbKpI1loiaO+OXZ2FGzboLDqiLHAqaP
         htyfb9lXsNO6yKRTRS0fla9Xcw4fUe2bLnnJZ4bRgUG/kK67TrAwzDO4ugjZcjo6djxf
         w652shW/X8lqhpDMynPlJn3HwKYBbNqU4+4syN56g/z3EHwHEdjJsOnp9F3nmiAQgIlZ
         6paOdBwGnmmusP/mQ0KVKrahVkMrGtvYpZE9EdrnrWUAbOPb/ViHuDXwidFLt5tnA4xf
         stFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MHeqW4XGwRZCSnKm2FHh/NR+ei+oiNfLETPiRLzlp1c=;
        b=rCTmb24iNyH8jIx6CIWXGt0HjUJmCwbrEZxLTEKH/jtLQMvHZyrarRC2VJYFfz/VGd
         g0BYbdrzZasLbLkiYuEv87gdZKvgBzEtviUFRznf+6B9JhYyIKn/h/D9/wUdECbyRu1k
         pC2WX7jFM+fWQreb0WvflHrKsxyUR770mJOynsYgvxNmbu2rFC54KEvv4dg4CKzwkhpE
         FoNnXaY4lvcVuF433Frut6e2tFhNrGw/6eAoddt+APRG/6vJYmKt54t/fERzGiHAr/px
         B9YPH+mShQVmXr6n6Xappx0rgZJU5BMoHGg8de63EFMWekeSxL2YG2ThNMPjmNadk9vO
         BqoA==
X-Gm-Message-State: APjAAAVqQOy9JbEycHElNPctxMaui0rrtm9zP+Haa9Z1I/qvtaaBFbFP
        KQSaS8FU7kJXH/ARWZFXS1hB0unkBbM=
X-Google-Smtp-Source: APXvYqx1bBxZ/jXNVCAOPkCVavGQjQT13ZBFslgUVFldlrj6KG2cOOROfNX0tY3q4U6uIISjMgrhgw==
X-Received: by 2002:a63:31cc:: with SMTP id x195mr95473353pgx.147.1564452962012;
        Mon, 29 Jul 2019 19:16:02 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id i7sm49836240pjk.24.2019.07.29.19.15.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Jul 2019 19:16:01 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Nadav Amit <namit@vmware.com>
Subject: [PATCH v2] KVM: X86: Use IPI shorthands in kvm guest when support
Date:   Tue, 30 Jul 2019 10:15:45 +0800
Message-Id: <1564452945-18425-1-git-send-email-wanpengli@tencent.com>
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
shorthand in kvm guest, to avoid splitting the target mask into several 
PV IPI hypercalls. This patch removes the kvm_send_ipi_all() and 
kvm_send_ipi_allbutself() since the callers in APIC codes have already 
taken care of apic_use_ipi_shorthand and fallback to ->send_IPI_mask
and ->send_IPI_mask_allbutself if it is false.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Nadav Amit <namit@vmware.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
Note: rebase against tip tree's x86/apic branch
v1 -> v2:
 * remove kvm_send_ipi_all() and kvm_send_ipi_allbutself()

 arch/x86/kernel/kvm.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b7f34fe..96626d8 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -505,16 +505,6 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 	__send_ipi_mask(local_mask, vector);
 }
 
-static void kvm_send_ipi_allbutself(int vector)
-{
-	kvm_send_ipi_mask_allbutself(cpu_online_mask, vector);
-}
-
-static void kvm_send_ipi_all(int vector)
-{
-	__send_ipi_mask(cpu_online_mask, vector);
-}
-
 /*
  * Set the IPI entry points
  */
@@ -522,8 +512,6 @@ static void kvm_setup_pv_ipi(void)
 {
 	apic->send_IPI_mask = kvm_send_ipi_mask;
 	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
-	apic->send_IPI_allbutself = kvm_send_ipi_allbutself;
-	apic->send_IPI_all = kvm_send_ipi_all;
 	pr_info("KVM setup pv IPIs\n");
 }
 
-- 
2.7.4

