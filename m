Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F2C81024
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 04:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfHECDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Aug 2019 22:03:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36553 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfHECDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Aug 2019 22:03:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so38836418pgm.3;
        Sun, 04 Aug 2019 19:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jGqqJdoFPgJRfsp1veHs6du8u1sFJO+Ydm26xk5LIKY=;
        b=Xk3DeOF+Q2VofPljRLhC6CCEq1+BN2Mk/wjSANITZuaSY20WOH+WPYkQJWFOObpmrO
         bpsnSXk5JcWYIMKSZC2plULWQtsCTYiGvkD/4az2GR4uOhj0wd+LstHF/ClEosGMCQPw
         lb1kb55OEJFNG7Eh9E644AfDvu3Lto1ZK89D2tyjouFjQguZnjRVFxaBrn4tnKUJyiNx
         Sr16EnS0eruQ0YO6gVBpfXjKsr/7r+/AemBkoYTu1EOHOJsFnCWSlOF9ccss3HE3Ak0b
         M/G5jQ3JvY9h9Xvc+Vmv0dd0UutHogKn/F7x5BHeHE0+hlLlUyh7+Qx2NVfiUnXByZz6
         r06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jGqqJdoFPgJRfsp1veHs6du8u1sFJO+Ydm26xk5LIKY=;
        b=JQrOjVgR8lKghFumUgt4rYXMU9FkypsIIZyYPMB0rfMNXh/0QLoMmQ5ccRUdTc0Zgv
         jybZvCeDtqT1hCtsaTv6vIgevVPe8V6HyUv535eE80Skav+VMVYMjgSzXtVMk+kh2Kik
         hgcgC40UBIbBOdv7igcukcn+oZWpX8bdz/C/f/Be+6jm+Sv6pMwJragSZm4y5c3VeMFf
         ve7upF2w6w8ZPWP0eSVA5yd32E+llzNuPgz4NIIP/A7NM+abMtytqsjsE+VpC5sApnxw
         F7TrWFb3pTLqit4QcYc+Cb4qk4/qTSu3ZqPVFSMVLc6tlb/AAQElIhuPFlvJRp9Wrw4i
         SHkw==
X-Gm-Message-State: APjAAAXfX6o3Z1maRTzjnGUIjBh2kMH/GOAIm3Fcszdz/2laKVlSTDjU
        gMWMJ+rXcpL4/tatoxyfrL+8Pp2L
X-Google-Smtp-Source: APXvYqz+Q9PM/X7k6L6D+IfKYndmCPEBeDNfA4xoBsr4C1ljccCsECgjdtNKyzuq869gnzWJhdzYzw==
X-Received: by 2002:a63:2a08:: with SMTP id q8mr102013732pgq.415.1564970618660;
        Sun, 04 Aug 2019 19:03:38 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id o32sm14739365pje.9.2019.08.04.19.03.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 19:03:38 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Nadav Amit <namit@vmware.com>
Subject: [PATCH v4 4/6] KVM: X86: Use IPI shorthands in kvm guest when support
Date:   Mon,  5 Aug 2019 10:03:22 +0800
Message-Id: <1564970604-10044-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
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
Note: rebase against tip tree's x86/apic branch, but just modify kvm codes
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

