Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3307822E38
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 10:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfETISb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 04:18:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36224 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731227AbfETISb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 04:18:31 -0400
Received: by mail-pf1-f194.google.com with SMTP id v80so6846983pfa.3;
        Mon, 20 May 2019 01:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mdt4XlZC2pbZEPI5nicfnEPh8hasPLijQObiVuuVk5U=;
        b=F4ADy1WJ9aMW0Az7Dcb+0CcgLU5O44XY/14U+Gs4tGxmIBm8szxfx4j6S1DkxBcrlR
         n3PQ5hf9p+QsKDZZ17LuTCPhVJ0SJy9BRgMi86tDC4R5JfaH8jBBLLbg19iojD470F0M
         BNuPG3VUxmoyGnsgdQHheUr+YWFBQzFWf6Jaa2KKt/aUIvxKGRyyPCe1hoN990YW7av3
         U0pSVnYD46UujRL35g1wN6nnQ+5QCYfX68CyQ3nNcAUcziw35h4puVYMvmbeJV1vjX5g
         El1D+tXjs56vmcaX2HrWEIBNhrR3jPfqbO12VFmG3Jt/zKLMJ6Gc7/qLSGPDZXIeU6y7
         pHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mdt4XlZC2pbZEPI5nicfnEPh8hasPLijQObiVuuVk5U=;
        b=t1N6mE4bovCAkdm4sxSkr2V3MQutda9jbzqJt/w7bbROibnLFVEUOTZ7XVbSt5KYYf
         EvbZcP/XweJCD6qVHWAcg7MK/mZZbgLv7VYETjHbRh5RTKcSvl/q0TPbtA9jWyz895xM
         BzolPAIVCtdesZESqKvm4zlpEoG3MUZ+ZrvMzCQ/s4mT9v/I//QWfARnm1gkFNBifpbG
         Gi2R7d564jpa9N5BZX1yyP7z3/jG7fO23sndtkMzFTf0ayzmy3/0CC6kDlv73j5dZgZS
         S68fZbA+jgqZi2VU6U4U5t/bGmmQ3lUEn7jh/j7Uly26Ht6bgXK02HFjEE/dD8hTXgQl
         9f/w==
X-Gm-Message-State: APjAAAU9V3tJOXzxiQafzrDkT0WhaRhhfE4hOItXOZChKb47FCiC9Xbf
        rvYntgY2DfkancSJKS9Ot7DXbaMC
X-Google-Smtp-Source: APXvYqyPyLbyrCRfNQefD9XIPpkMB7dSe/X8dKxXE/5/RV60f4apoPUFT3zr2mZ2wfTsTB2UZp3TBQ==
X-Received: by 2002:a63:fc08:: with SMTP id j8mr73659889pgi.432.1558340310502;
        Mon, 20 May 2019 01:18:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z9sm18522110pgc.82.2019.05.20.01.18.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 01:18:30 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v4 3/5] KVM: LAPIC: Expose per-vCPU timer_advance_ns to userspace
Date:   Mon, 20 May 2019 16:18:07 +0800
Message-Id: <1558340289-6857-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Expose per-vCPU timer_advance_ns to userspace, so it is able to 
query the auto-adjusted value.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/debugfs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index c19c7ed..a2f3432 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -9,12 +9,22 @@
  */
 #include <linux/kvm_host.h>
 #include <linux/debugfs.h>
+#include "lapic.h"
 
 bool kvm_arch_has_vcpu_debugfs(void)
 {
 	return true;
 }
 
+static int vcpu_get_timer_advance_ns(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+	*val = vcpu->arch.apic->lapic_timer.timer_advance_ns;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
+
 static int vcpu_get_tsc_offset(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
@@ -51,6 +61,14 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	if (!ret)
 		return -ENOMEM;
 
+	if (lapic_in_kernel(vcpu)) {
+		ret = debugfs_create_file("lapic_timer_advance_ns", 0444,
+								vcpu->debugfs_dentry,
+								vcpu, &vcpu_timer_advance_ns_fops);
+		if (!ret)
+			return -ENOMEM;
+	}
+
 	if (kvm_has_tsc_control) {
 		ret = debugfs_create_file("tsc-scaling-ratio", 0444,
 							vcpu->debugfs_dentry,
-- 
2.7.4

