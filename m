Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B269974F9
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 10:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfHUI0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 04:26:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37065 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfHUI0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 04:26:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id d16so1200039wme.2;
        Wed, 21 Aug 2019 01:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZVtvs8aoMj7QTvzMN1wgA3FYSaFdOhLuHmxR1kxixVM=;
        b=Ms3BJi46cOgN3pTo6ofz5yGM2VxaVWe9jdE/51BzXO80cpAlQf7wwUN796eodXSMj6
         oVYahD3zOtwBIct35oFxGkytbVTt7GNek+i0kgV4WdsI7BVEB0DXWqCT0wnCodjouP7x
         wbwWMdeyEYh54w9YydE4/+6laaIIXK40g5K2CDNDFQRbLu/kCTSAYCtRqyndAO//GYjw
         gB1sGlIHskIYMEPuyLjTtm0ynKJAYrfAU2/9bWhZRVrce2a5chO9WYfz+E7Y1YPUTkjW
         mfQ9NsitoVsak40G+qbQ3DO0vEFZ1fioNdtMnjjYR6GfctYfNKHg+ccDM7MvEGnKLStm
         5SFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ZVtvs8aoMj7QTvzMN1wgA3FYSaFdOhLuHmxR1kxixVM=;
        b=TPtaS8Esu/F04jR+uAd+fnZ5CJoBn/U51VUUTG6St/oopdh/CKYKEknxYgFmEmLWn8
         qJ/sL8CtWR3kevho39KzzeztBA9TYmB2vM3YkFWvWyvpfgsak/GWxhaf5hV8wVNJcenH
         vpzsL7PsyvMwdEZEFu1YRLTjv59TzB+smNMDV4Sq6U8+v2Z50b2e0N3KmELHBpkVAKwo
         kX8HO+BAXF7jTS8CmZqB23LW6JkNwGM4HeI83jMI1x1nm1rRrz9EXKRk+VX16z5lBWvw
         FPbvjkHpZDR/xpOQXh3Dyiq9c89OKmYHYKTlnmVQ9ACc9d+yakGz9HCyH/+ND3WrUAow
         6dbQ==
X-Gm-Message-State: APjAAAWsJZ7HWLOLzWZegLNZwOhOW3OzkHY8qqo54uRQ+peswoRfJQS4
        +RACsS1zQo5mGdKDb9r6N4rHsWxJbN8=
X-Google-Smtp-Source: APXvYqyGnNk53xFt+keZcSaEml9lLPA+oaKPBtoKKpF3Rxa4fpSbvVbnG92HflTY3dZyHk8XmfV6Ag==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr4762139wml.175.1566376006653;
        Wed, 21 Aug 2019 01:26:46 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w5sm2931892wmm.43.2019.08.21.01.26.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 01:26:46 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@redhat.com, ehabkost@redhat.com, konrad.wilk@oracle.com
Subject: [PATCH 2/3] KVM: x86: always expose VIRT_SSBD to guests
Date:   Wed, 21 Aug 2019 10:26:41 +0200
Message-Id: <1566376002-17121-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even though it is preferrable to use SPEC_CTRL (represented by
X86_FEATURE_AMD_SSBD) instead of VIRT_SPEC, VIRT_SPEC is always
supported anyway because otherwise it would be impossible to
migrate from old to new CPUs.  Make this apparent in the
result of KVM_GET_SUPPORTED_CPUID as well.

While at it, reuse X86_FEATURE_* constants for the SVM leaf too.

However, we need to hide the bit on Intel processors, so move
the setting to svm_set_supported_cpuid.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reported-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e3d3b2128f2b..c5120a9519f3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -68,10 +68,8 @@
 #define SEG_TYPE_LDT 2
 #define SEG_TYPE_BUSY_TSS16 3
 
-#define SVM_FEATURE_NPT            (1 <<  0)
 #define SVM_FEATURE_LBRV           (1 <<  1)
 #define SVM_FEATURE_SVML           (1 <<  2)
-#define SVM_FEATURE_NRIP           (1 <<  3)
 #define SVM_FEATURE_TSC_RATE       (1 <<  4)
 #define SVM_FEATURE_VMCB_CLEAN     (1 <<  5)
 #define SVM_FEATURE_FLUSH_ASID     (1 <<  6)
@@ -5933,6 +5931,8 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
 }
 
+#define F(x) bit(X86_FEATURE_##x)
+
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	switch (func) {
@@ -5944,6 +5944,11 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 		if (nested)
 			entry->ecx |= (1 << 2); /* Set SVM bit */
 		break;
+	case 0x80000008:
+		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
+		     boot_cpu_has(X86_FEATURE_AMD_SSBD))
+			entry->ebx |= F(VIRT_SSBD);
+		break;
 	case 0x8000000A:
 		entry->eax = 1; /* SVM revision 1 */
 		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
@@ -5954,11 +5959,11 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 
 		/* Support next_rip if host supports it */
 		if (boot_cpu_has(X86_FEATURE_NRIPS))
-			entry->edx |= SVM_FEATURE_NRIP;
+			entry->edx |= F(NRIPS);
 
 		/* Support NPT for the guest if enabled */
 		if (npt_enabled)
-			entry->edx |= SVM_FEATURE_NPT;
+			entry->edx |= F(NPT);
 
 		break;
 	case 0x8000001F:
-- 
1.8.3.1


