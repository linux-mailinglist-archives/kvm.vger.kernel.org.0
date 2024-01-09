Return-Path: <kvm+bounces-5931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB1F829081
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07CB01C24C35
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C7447F4B;
	Tue,  9 Jan 2024 23:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yNNaX1GP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E824777C
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6da380cc0d6so4179249b3a.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841396; x=1705446196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zpfa/x9yEuVfUmpeFfAFqOYrAZ+6Wf628MHaj6l1xFg=;
        b=yNNaX1GP1q4m5xr/3s6qd/MKn0c99a00cxzOVGk5Y0wZ2u3uW1IW3ucZr1gWsFvF4Q
         srtqQOMTEknuMO/m4YBzB2ywUlGjMXdLJ3f2VsITEStN5jC1ilnrpdHDFunJfXlT8tng
         EkFkiGTiMF6ktrlBoeGDDWnkskVew+HsfHDZOIY9uw5kysNnd22HwosInh6QX+zGrXDf
         5YMalFKd7fPXBuYoX8R9HRg22c5fSvw9PxV9jxLOkVGkhCah/CSpG/C8kkXAMADj3QKK
         Z1tRtH50hK8td3Qp0s3OGkdfm6upaczkPL5lXspNtg3lMG5CbEsmAny4/9QyyjNFD1x1
         Oy5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841396; x=1705446196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zpfa/x9yEuVfUmpeFfAFqOYrAZ+6Wf628MHaj6l1xFg=;
        b=oKsMSkEci1Y3l/frlDKQqGyZ0pAvpt72Viu05BCZ4WrW/qrBOwm28aoMLlGExFvNFQ
         8MgE1Vej7V0NlM55QVCcmhyP0p2LF5/2yYWyK1VSketA21JD2h62zSxlffG8RyR4Zo8N
         DgNCcDfLYzf7/J3mPE0Ua9p9yo3UUlGqVSDcRIBvUYa8uigFYuA9robDo0zEBNqfY9Is
         tqKkSKDmFvRXdpInbC+rek2cHhvr6Lc/gOuH2kWkIinLTmYbaRT8xeZHhQGXtUl2Epns
         1BUUFvGTR3oV+L5fPuxvxJwGdTUioR/WHgced4pw+INgvhIadFf2jsT+38N4ftGDWQHV
         fBDQ==
X-Gm-Message-State: AOJu0YzR7WhjzgsAe+NfwluEhd+IRbrFtPjymfnaWlwKSsHhzsHs4Xhb
	OE4Hkj632yY9JxoM5TnIuOYOEdFJgmBKPntOlQ==
X-Google-Smtp-Source: AGHT+IHExjDUtGswL0uDHzkSiN8N6SZ1wWSxlh71TMBv4bC0yv6BmT37iVMl+ZN2gHx7zh0d4bUgmT+9pYg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e90:b0:6d9:cb95:d738 with SMTP id
 fd16-20020a056a002e9000b006d9cb95d738mr42128pfb.2.1704841396543; Tue, 09 Jan
 2024 15:03:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:32 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-13-seanjc@google.com>
Subject: [PATCH v10 12/29] KVM: selftests: Add vcpu_set_cpuid_property() to
 set properties
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
index a84863503fcb..932944c4ea01 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -995,7 +995,9 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
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
2.43.0.472.g3155946c3a-goog


