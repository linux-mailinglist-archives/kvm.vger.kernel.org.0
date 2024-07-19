Return-Path: <kvm+bounces-21979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39D9B937E19
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EACC5281777
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCCA314AD02;
	Fri, 19 Jul 2024 23:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0r3601bv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057CC14A4DB
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721432643; cv=none; b=WIi2HNFRi05GWRwlfDLarV7DR8EgQbzQL3FWKbKIGP4qhvbR5WLufkNshQwxXRO/buoVqtVhwAR6EiT3Xle0PGmZ/U2x8sIkhZC3WHWe4Oar5v1A6QoKSWcZvLCt7To28RB+fGh86vlxOEn95eohd3NA1RgpyALASKzESK2nhC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721432643; c=relaxed/simple;
	bh=avuIVrOvbdJuGswu1VBc5QXgq1mmaRUWopHFZ+/wLdQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sBsQB467z//q1oXK2l8GyhAfHZ3olmo/2DO4L5/wzkc3v3RosiHW3sUPlAyHPh1V1Xunz3/xMKUuRFnKV9462qE+EO8yjJcFVi3JXrAPh3ff/oruaOeXx63j+hgDBIXfc0osCR5d9p2639Kc/7BZ5hF6sS+VfT4/vIft4xprJZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0r3601bv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb7364bac9so1833523a91.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721432640; x=1722037440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vV3aMaVHf7C/0akufsxFVZJRmuCa+4Ea2SM/3XMiVaU=;
        b=0r3601bvHPZl17MhLs39ASHfYqDDVZLF/ZdoHoubWqtS08h5jfdX3wo6h4JvqIGu0J
         tYIe8VuuYIr8sgplw+OSabkUbgzNxEIIwY6LXA3uzUyBgnTPL29CoKfMHewytkSl9/Fx
         OBCJvXZNXggsMqp/Z0+cfUiQ592ek+H0v5pNnAdkFOER2YjnNTOpnZ+bMyl4KVCH8oak
         qJ2RcM5VLMOInvxks/wg/2rvKU1dUyJyxbkdBl8mHESEbjtI3qvjMpnyR6QePVGywUCX
         1tcWhBlbps4P26N9sqTtmwr0V785nb8yqDaIWRCuicYB3DSkR3148sZNdT0+u/T/8A6e
         gEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721432640; x=1722037440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vV3aMaVHf7C/0akufsxFVZJRmuCa+4Ea2SM/3XMiVaU=;
        b=eCtl9wv2s6iia5YqHr3ivSG58Sw3HLKTI6L4iHdWByFDLhr8uFbNaKCYIC2GmUpkSE
         wsR9saFfs3PPO5OxQyS2s5YRoud8T97uOyueBBvdpetwXLIgYFJLExKiV/SW3kk/pksS
         Kdl4LDkcpw6Q6BAGLUzA0LOXlgo0aZ2NExHPsqQCiLeOSvcr0+170L8gfIa6U/EnYv4a
         uqbyFrWQ/QXZsVddV53V5WngHiCyxpKrxekqY/Hve/7drJJ9RM8u2fCQ38i0pH1MNTs1
         1BIMYmnGyTe0bbgfgsfcHM22SuZVJQhwt8XImy5las3svX1eFpzwxQ59odbMEr/9Uw4r
         G8aA==
X-Gm-Message-State: AOJu0YylbWl0bAQCllySW4MXwEhA0erPgJ7ROLRflfaE1YcVs4QoMF6q
	wGo2gDJ4JRqUWRCccvBYA3yMSvDSCRCqNx+fEXxCmLDbRZWlKYxdGsy+IpiLk6MfAtFfAwqmR4H
	z8Q==
X-Google-Smtp-Source: AGHT+IGPvuABTRGzUn95rBWDL/2eBHyGq/tmVyD1jWvRffYkunDVRYZslMTOmS1p0lIemoM5bFBHW+JX+M4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7081:b0:2c8:632:7efe with SMTP id
 98e67ed59e1d1-2cb7761c6bbmr21715a91.4.1721432640200; Fri, 19 Jul 2024
 16:44:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:43:43 -0700
In-Reply-To: <20240719234346.3020464-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719234346.3020464-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719234346.3020464-7-seanjc@google.com>
Subject: [PATCH 6/8] KVM: selftests: Add x86 helpers to play nice with x2APIC
 MSR #GPs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Add helpers to allow and expect #GP on x2APIC MSRs, and opportunistically
have the existing helper spit out a more useful error message if an
unexpected exception occurs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/apic.h       | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
index 0f268b55fa06..51990094effd 100644
--- a/tools/testing/selftests/kvm/include/x86_64/apic.h
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -11,6 +11,7 @@
 #include <stdint.h>
 
 #include "processor.h"
+#include "ucall_common.h"
 
 #define APIC_DEFAULT_GPA		0xfee00000ULL
 
@@ -93,9 +94,27 @@ static inline uint64_t x2apic_read_reg(unsigned int reg)
 	return rdmsr(APIC_BASE_MSR + (reg >> 4));
 }
 
+static inline uint8_t x2apic_write_reg_safe(unsigned int reg, uint64_t value)
+{
+	return wrmsr_safe(APIC_BASE_MSR + (reg >> 4), value);
+}
+
 static inline void x2apic_write_reg(unsigned int reg, uint64_t value)
 {
-	wrmsr(APIC_BASE_MSR + (reg >> 4), value);
+	uint8_t fault = x2apic_write_reg_safe(reg, value);
+
+	__GUEST_ASSERT(!fault, "Unexpected fault 0x%x on WRMSR(%x) = %lx\n",
+		       fault, APIC_BASE_MSR + (reg >> 4), value);
 }
 
+static inline void x2apic_write_reg_fault(unsigned int reg, uint64_t value)
+{
+	uint8_t fault = x2apic_write_reg_safe(reg, value);
+
+	__GUEST_ASSERT(fault == GP_VECTOR,
+		       "Wanted #GP on WRMSR(%x) = %lx, got 0x%x\n",
+		       APIC_BASE_MSR + (reg >> 4), value, fault);
+}
+
+
 #endif /* SELFTEST_KVM_APIC_H */
-- 
2.45.2.1089.g2a221341d9-goog


