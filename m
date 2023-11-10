Return-Path: <kvm+bounces-1418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C6287E7729
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B52DC2813F3
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CB5567F;
	Fri, 10 Nov 2023 02:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n6s2P59W"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5672D5231
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:31 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAAB47B4
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:30 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6b3e4c22dabso1494928b3a.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582410; x=1700187210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bz+cFjmGJykZammOdDVwa1MNebY51dfMTOWn2QBuCm4=;
        b=n6s2P59WuqBwH5zqjT5/UyGf/jPYWzlQAs4dYBd52sZf4mMdptZihnVvL9DFjNyvbg
         zEiiCMSX4ZCfJBQcsQmDnh7AXL5GNMgqFRsAm0rE5WpJugC/dqeifBaFX8Lip/5Xl54l
         PEXqVcroRlZHw/4SxNEcZxeo99iGp1GYyfFHQbFRfr/RRJTzQlaSo9tsbP9e6G5sk1wI
         2sw5cV1ZOa7bYkpoi6vSiJlwnaY3BdLNDVZVIX17feXbKfSu/EoAG+Tz4WPbmlyT5L5y
         xo7OSG375P2ndInIu52GzSlV412HLF6izIMqwzimAaaVjZOe6WBZuOULGnC1+UBdFIKi
         GTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582410; x=1700187210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bz+cFjmGJykZammOdDVwa1MNebY51dfMTOWn2QBuCm4=;
        b=Z7f89uZ3O4q7HczAJmgQd9S88km2GLdtGynu2LeJxPQGZwklRIaPGaq213Y0BpdR8E
         UU0UZkedhBIAH5IcEdUyF356tv0tPJfvbmaEE3r8xWQXovQyrE6jv+Hhkk4sVbIv9/oG
         NhaFlPogpQ64ruw7nt4PK52exi2JxYQi9l+vZDF/B07hbahTrpWoPzQXMZPQDRqRWld+
         kdyN2hT+DXBgw79eWlveInWDN6UK2eYQyu9r/VJvZdsOWbTVOkoyGoslJCAKY99lVNHO
         +wqtLEFjdJkFE53/dhy6tyKr1ocxwphdFvsjAVCm5rZy/YCDr2OOItALP9MdJfvNjyGX
         MAAA==
X-Gm-Message-State: AOJu0YzFNCYQYCe56dj5udtwhhccZZXZ6Eq2JziKPqwCkQKezb9e608d
	CDZw4BtDGBmJ8pxST/Ow9zXWuLUInko=
X-Google-Smtp-Source: AGHT+IFrUaQlXe1zq/FgSYHz0vm+SUwiTd20fARy8yP7dca37b6JphU5TOkonG80Qlu/5pn/jlo5StSE4yI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b20:b0:6be:aed:7ad0 with SMTP id
 f32-20020a056a000b2000b006be0aed7ad0mr901504pfu.2.1699582410463; Thu, 09 Nov
 2023 18:13:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:49 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-10-seanjc@google.com>
Subject: [PATCH v8 09/26] KVM: selftests: Add vcpu_set_cpuid_property() to set properties
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Add vcpu_set_cpuid_property() helper function for setting properties, and
use it instead of open coding an equivalent for MAX_PHY_ADDR.  Future vPMU
testcases will also need to stuff various CPUID properties.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h      |  4 +++-
 .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++++++++---
 .../x86_64/smaller_maxphyaddr_emulation_test.c    |  2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 25bc61dac5fb..a01931f7d954 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -994,7 +994,9 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
 }
 
-void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr);
+void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
+			     struct kvm_x86_cpu_property property,
+			     uint32_t value);
 
 void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function);
 void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e..67eb82a6c754 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -752,12 +752,21 @@ void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid)
 	vcpu_set_cpuid(vcpu);
 }
 
-void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr)
+void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
+			     struct kvm_x86_cpu_property property,
+			     uint32_t value)
 {
-	struct kvm_cpuid_entry2 *entry = vcpu_get_cpuid_entry(vcpu, 0x80000008);
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = __vcpu_get_cpuid_entry(vcpu, property.function, property.index);
+
+	(&entry->eax)[property.reg] &= ~GENMASK(property.hi_bit, property.lo_bit);
+	(&entry->eax)[property.reg] |= value << property.lo_bit;
 
-	entry->eax = (entry->eax & ~0xff) | maxphyaddr;
 	vcpu_set_cpuid(vcpu);
+
+	/* Sanity check that @value doesn't exceed the bounds in any way. */
+	TEST_ASSERT_EQ(kvm_cpuid_property(vcpu->cpuid, property), value);
 }
 
 void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function)
diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index 06edf00a97d6..9b89440dff19 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -63,7 +63,7 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	vcpu_set_cpuid_maxphyaddr(vcpu, MAXPHYADDR);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_MAX_PHY_ADDR, MAXPHYADDR);
 
 	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
 	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
-- 
2.42.0.869.gea05f2083d-goog


