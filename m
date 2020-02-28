Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13D173363
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 09:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgB1I7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 03:59:22 -0500
Received: from mail-yw1-f74.google.com ([209.85.161.74]:52004 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgB1I7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 03:59:21 -0500
Received: by mail-yw1-f74.google.com with SMTP id a16so3725122ywa.18
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 00:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=o3P8/n3NO+y1mFt3LRRLUFHUv02ncTruiTBoZVHd2vw=;
        b=Z0t18VO20mFKl+fhMEs/z9vvkN/3Aq7WvXT/M2GN2DxBtZW3HkmUlAQLkV3ViReM4+
         umoGHntd1Xq6NLIfe2J+xoho3TQp6fa7ihrvcALCX9jZWTgBiG6/QrKe4aj9pHxKkIl0
         2O4Og+Cbhg56SilJ5hHz6JoNOA3xx8vJIhDvTYcXmN5LlFbxUZ3j2dBg7kf7TUUD4Ejw
         lO6hc8yNg8xLSRAsrKvBhcFn5zrF+cruA0U0qU2UuUTUO/P+FR9iR+azXGleuM9bLyag
         w0MW/h7X8QfKbF0tQktyT6gBUNP7QLjl6SyXBIeBnE7p0lzntqiyBvHlzZOJit7+IITr
         P4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=o3P8/n3NO+y1mFt3LRRLUFHUv02ncTruiTBoZVHd2vw=;
        b=PZta6+6x4rpee5RekVS1AAqySIsDb4OxJSlxXxxTrF0nStc2SRxcS3Crq7BpFSQMHc
         dfJ9uB5ArKHFBifAcWrX42oGzmheZMkF+W0qVzvQfEYLKg6fRQa25fT55ye3sLTVJrrF
         OhTvbCYxGo+EX7UvsHZepTvC7ErpvhlwbHt72lipMnHprvQ/Ft9OJkFsWnrkSXOeEF/W
         8z1D0J0hkl3q5kFS9kMoCIBRG7tuIgRUWNtWm4Ysd5HXdBIkG/rqFxGJHAB0HgqsPyxt
         bfRQT4VoJ+iJ9GJy3JAD8SFHSVSC4fzCEt8jaJaBZ0GvrLSYj/dCRFN+RWJeEPOMo2iF
         fOyg==
X-Gm-Message-State: APjAAAXq0y0Klxc9VL90w+SOLWPFfEJot1fBQEDMchCG14ZlAlwPQOCE
        GB+a2b1mS6xZ5CUwaMJwV26mA/j6V+V4rACYskUXEDbpcXgGF0ZG8lLEis5d+pTajRlwcuppmI9
        1Nbxfq2Xa33nqSw0sgJvrIdqYxBE4J0UFBK0/KxdgEEbyz64mJkM3ZmPByQ==
X-Google-Smtp-Source: APXvYqzP3RUnZIVjaQfNcil/MS/vuswAhJ2e1PJwwii/DjJffySzTP6e5msxU1Gn2LHXCVfh0j7NJfpTSdE=
X-Received: by 2002:a81:2e52:: with SMTP id u79mr3698169ywu.70.1582880359137;
 Fri, 28 Feb 2020 00:59:19 -0800 (PST)
Date:   Fri, 28 Feb 2020 00:59:04 -0800
Message-Id: <20200228085905.22495-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v2 1/2] KVM: SVM: Inhibit APIC virtualization for X2APIC guest
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AVIC does not support guest use of the x2APIC interface. Currently,
KVM simply chooses to squash the x2APIC feature in the guest's CPUID
If the AVIC is enabled. Doing so prevents KVM from running a guest
with greater than 255 vCPUs, as such a guest necessitates the use
of the x2APIC interface.

Instead, inhibit AVIC enablement on a per-VM basis whenever the x2APIC
feature is set in the guest's CPUID.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---

 Parent commit: a93236fcbe1d ("KVM: s390: rstify new ioctls in api.rst")

 v1 => v2:
  - Adopt Paolo's suggestion to inhibit the AVIC by default rather than
    requiring opt-in
  - Drop now unnecessary module parameter

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 98959e8cd448..9d40132a3ae2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -890,6 +890,7 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_NESTED     2
 #define APICV_INHIBIT_REASON_IRQWIN     3
 #define APICV_INHIBIT_REASON_PIT_REINJ  4
+#define APICV_INHIBIT_REASON_X2APIC	5
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ad3f5b178a03..b82a500bccb7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6027,7 +6027,13 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
-	guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
+	/*
+	 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
+	 * is exposed to the guest, disable AVIC.
+	 */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
+		kvm_request_apicv_update(vcpu->kvm, false,
+					 APICV_INHIBIT_REASON_X2APIC);
 
 	/*
 	 * Currently, AVIC does not work with nested virtualization.
@@ -6043,10 +6049,6 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	switch (func) {
-	case 0x1:
-		if (avic)
-			entry->ecx &= ~F(X2APIC);
-		break;
 	case 0x80000001:
 		if (nested)
 			entry->ecx |= (1 << 2); /* Set SVM bit */
@@ -7370,7 +7372,8 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
-			  BIT(APICV_INHIBIT_REASON_PIT_REINJ);
+			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
+			  BIT(APICV_INHIBIT_REASON_X2APIC);
 
 	return supported & BIT(bit);
 }
-- 
2.25.1.481.gfbce0eb801-goog

