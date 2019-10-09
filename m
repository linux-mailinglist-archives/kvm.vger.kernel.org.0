Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4884D04D9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 02:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfJIAmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 20:42:07 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:48408 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbfJIAmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 20:42:06 -0400
Received: by mail-vk1-f202.google.com with SMTP id h145so176458vke.15
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 17:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aPzuEK87aDrWGqWoXHQrkCZLPZrRn8GynSzDsCpPFJA=;
        b=obNd30LtFrVVMUNKHicXP5ZEi0UcdyxV/0Ol7Z8ApkmTeEvaIzM4o12f/zhZalDzlg
         taZ3Aj2KLlfbHPRV++RjpJc9GU3gO+OHO6uYXrYVeeqEwgHoRoBAyRBpXNcwAdWqDuM4
         U85gI9BKxzEigcOMDhZCHNNUPDXM2PCRJ5DwzbDzoP2aecsSVdqRd83K0EO9NB24tvVH
         iG+myYYyor75x2NCczrbPhFa5VZ+JvZlNY2wl5SpiABE6BK8qfookuhKK8TGvJaM89Tb
         YbmBy8BoLn/eSQ9UjM+pjWk6KoSzazvgy62KCO8p1h48SOozfdjmRJQ/8aY5A4IjwgKw
         34xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aPzuEK87aDrWGqWoXHQrkCZLPZrRn8GynSzDsCpPFJA=;
        b=hbUPGy1oMAv3ighYCITCOr/ZiG612ziyL+jkWfygvrKWKUgFEQZZr8aHFgBY1/mx1r
         Y/iqX+ALyAJkSAr9L04E01EjVFgCWpCX2ubUc/2itVXKG23lzZdUYLXKpnOG5DEJMHxx
         8oXCVOGzgoAhF9S9N0/KkHf5wMPnIOattcMjkWoWjLQlkEZOq1PdkQRD0PcL9v43reeq
         q2YBh+fmGkqIM7ka+b53YXaSYH7+kcqsUZDg8DvAviinUbwTaT5Ln5/dRqt/ERxNkrDT
         cN2+ZGl97i6pQbkPvAkUsT/6HQWvB2rrwKpt6GXxUCA3LFuKNblBwuIuMMdGM8d0aURs
         wqyg==
X-Gm-Message-State: APjAAAWv6bKXwKmDq2lAsOvmjOeOKtIfslh0qsFJAytai8NHpIXnY8zJ
        I/AijRWRvERMsnM2ru/ILxEyU7Cp2dPWPq6R
X-Google-Smtp-Source: APXvYqxtFBb3LJKjxCedYKIF5Jk5uNC1BnGIbTsYvfgyh5egAWmDXO3lxu0yqUWaKb0l/RmAiIgyDCLiGyJbQVnA
X-Received: by 2002:ac5:cb62:: with SMTP id l2mr697137vkn.32.1570581725690;
 Tue, 08 Oct 2019 17:42:05 -0700 (PDT)
Date:   Tue,  8 Oct 2019 17:41:40 -0700
In-Reply-To: <20191009004142.225377-1-aaronlewis@google.com>
Message-Id: <20191009004142.225377-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [Patch 4/6] kvm: svm: Enumerate XSAVES in guest CPUID when it is
 available to the guest
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the function guest_cpuid_set() to allow a bit in the guest cpuid to
be set.  This is complementary to the guest_cpuid_clear() function.

Also, set the XSAVES bit in the guest cpuid if the host has the same bit
set and guest has XSAVE bit set.  This is to ensure that XSAVES will be
enumerated in the guest CPUID if XSAVES can be used in the guest.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.h | 9 +++++++++
 arch/x86/kvm/svm.c   | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d78a61408243..420ceea02fd1 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -113,6 +113,15 @@ static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x8
 		*reg &= ~bit(x86_feature);
 }
 
+static __always_inline void guest_cpuid_set(struct kvm_vcpu *vcpu, unsigned x86_feature)
+{
+	int *reg;
+
+	reg = guest_cpuid_get_register(vcpu, x86_feature);
+	if (reg)
+		*reg |= ~bit(x86_feature);
+}
+
 static inline bool guest_cpuid_is_amd(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 65223827c675..2522a467bbc0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5887,6 +5887,10 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+	    boot_cpu_has(X86_FEATURE_XSAVES))
+		guest_cpuid_set(vcpu, X86_FEATURE_XSAVES);
+
 	/* Update nrips enabled cache */
 	svm->nrips_enabled = !!guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
 
-- 
2.23.0.581.g78d2f28ef7-goog

