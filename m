Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212E53B23C0
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFWXIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhFWXIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:08:21 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DD7C061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:03 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id b125-20020a3799830000b02903ad1e638ccaso4321712qke.4
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jbfGWs931zA+JGWuuEGa9C1XdcBcxFB7u/E81/FmgGU=;
        b=q4witublxlQfQh9byhgfZ2JZsN+6vdXlBZi0aMSrSAjmRmYvx9rFDvbS8yFOPcM4LB
         /1NxO5D6/eZNco8/BabNsUhn0brbIh92TLER1gzpd13/O2Zy76WZxJCtulEKzpBuvW8I
         988XdjGpKD6Bcr9HncDuGdCXh2LXROdtzD4VOqCu/2y55QLPQE7xBUTZweL+nFzXB24g
         pq1yIkl8TKm2Ia2OD8LDhSuqUA7TXbKcCoFPsTwJNu7HxvV/RRB8Ow0uEVbf5L8Hy2UQ
         IUMWRxhgRXtwlrhbbhWzCi+yckSL81UJn5vCW0JR7fdCZtUtz5KZSghBUQ4rW47zwXQm
         s2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jbfGWs931zA+JGWuuEGa9C1XdcBcxFB7u/E81/FmgGU=;
        b=L4KXO+W8g4DFymNrw6So8tk3INe5LFTUW1DA8tvoUwffNR2R45NLvxWsOG2wm7obG4
         wyu7Fo5+grPpRHaIUQ5ZRJqmcyrX4IvvDPPUI0Ces0SzD+y4oV7DjxWiRBXY+i8jTTqA
         h2upxBbfMKdKNzaxrNwgakaPZubG0dmudTln5noxvXH3NbcDayX1E+8d8gTKoGYicvNX
         BTBg6IggVhriHlXAqOhVPEiQLVKgZzrvSEaMss6MjzRG+3Y5+p4nLiSubtKNAY5jgswO
         Bt1T6mOsNt0liEGxY7409KaKGTDkbYX+pGhDohpkvmC+XS4n4Wr5GbOEzdb2cUjzFHtC
         gBtg==
X-Gm-Message-State: AOAM530/rWFdwVIq9CFX1RsxLCmfxrZmhQ8zFeNO0QzltqcawKGjsp4Q
        nYpF1Jdx02Sx2GSlXaDYqkfN2NA6WnA=
X-Google-Smtp-Source: ABdhPJyWxbjbqPIzyPvxjQ1GE7fMSRSGs/DNU7B9f28W8AIL1w65sp4XTKNcI58saYVi4VCH5f0kO2HHF60=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e9e:5b86:b4f2:e3c9])
 (user=seanjc job=sendgmr) by 2002:ad4:5a07:: with SMTP id ei7mr2045985qvb.46.1624489562735;
 Wed, 23 Jun 2021 16:06:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 23 Jun 2021 16:05:47 -0700
In-Reply-To: <20210623230552.4027702-1-seanjc@google.com>
Message-Id: <20210623230552.4027702-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210623230552.4027702-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 2/7] KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use boot_cpu_data.x86_phys_bits instead of the raw CPUID information to
enumerate the MAXPHYADDR for KVM guests when TDP is disabled (the guest
version is only relevant to NPT/TDP).

When using shadow paging, any reductions to the host's MAXPHYADDR apply
to KVM and its guests as well, i.e. using the raw CPUID info will cause
KVM to misreport the number of PA bits available to the guest.

Unconditionally zero out the "Physical Address bit reduction" entry.
For !TDP, the adjustment is already done, and for TDP enumerating the
host's reduction is wrong as the reduction does not apply to GPAs.

Fixes: 9af9b94068fb ("x86/cpu/AMD: Handle SME reduction in physical address size")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4b2f8c6b41e8..28878671d648 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -941,11 +941,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		unsigned phys_as = entry->eax & 0xff;
 
 		/*
-		 * Use bare metal's MAXPHADDR if the CPU doesn't report guest
-		 * MAXPHYADDR separately, or if TDP (NPT) is disabled, as the
-		 * guest version "applies only to guests using nested paging".
+		 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
+		 * the guest operates in the same PA space as the host, i.e.
+		 * reductions in MAXPHYADDR for memory encryption affect shadow
+		 * paging, too.
+		 *
+		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
+		 * provided, use the raw bare metal MAXPHYADDR as reductions to
+		 * the HPAs do not affect GPAs.
 		 */
-		if (!g_phys_as || !tdp_enabled)
+		if (!tdp_enabled)
+			g_phys_as = boot_cpu_data.x86_phys_bits;
+		else if (!g_phys_as)
 			g_phys_as = phys_as;
 
 		entry->eax = g_phys_as | (virt_as << 8);
@@ -970,12 +977,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 0x8000001a:
 	case 0x8000001e:
 		break;
-	/* Support memory encryption cpuid if host supports it */
 	case 0x8000001F:
-		if (!kvm_cpu_cap_has(X86_FEATURE_SEV))
+		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
-		else
+		} else {
 			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
+
+			/*
+			 * Enumerate '0' for "PA bits reduction", the adjusted
+			 * MAXPHYADDR is enumerated directly (see 0x80000008).
+			 */
+			entry->ebx &= ~GENMASK(11, 6);
+		}
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
-- 
2.32.0.288.g62a8d224e6-goog

