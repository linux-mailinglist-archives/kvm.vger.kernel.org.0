Return-Path: <kvm+bounces-30352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 484E29B97BE
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A06F0B21D0E
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067321D90CC;
	Fri,  1 Nov 2024 18:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MDHk3TRy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2BB1D2F5D
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486180; cv=none; b=GcmT+Z0CoyT1yE0BhiG0ECscDemx7O/jHiPoUS/w8JA/JjM6L2eCl68wbSsXfrOWaIf622m2siEw1Bv6HJh7K775+w//nn06Ez6hjv8FvPRLwbVxVYlJ4DZpbPzzxyd3y8rPUje+tgSLjds8Uo0iClfKyAZ6WJSF3oNNNPIX7KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486180; c=relaxed/simple;
	bh=wETa+dLcXchkDF6niCLZKhIJhZbg0XK3Wfx1WgkxMCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TiSgTxCnOJGmvOxQBUUTpaOVX4erJs310BQOFnv7DC3GLpiZODtPSMwOzp96yrF5wryKCpmhpQGuhNniOrYN0TYj8lm0A0TChBjdKOmKKZMTr9hO60PzKsmXvNCLj+rIrX9jQRoLV2ncgSPlChS8T0KoTgYJgZZwPzYTJzI1uRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MDHk3TRy; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7cd9ac1fa89so2555843a12.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730486178; x=1731090978; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=t6n3TCROGALKBhF87tS4HVc6hSldgq3keX1Nmca5GdQ=;
        b=MDHk3TRyDF0J5zovlyekZcJk15Cg90yrmpNGQnIykNg4UT/vWmf2MFi8otvSWkgtDD
         0ShRvpELKEW7cj+rT0B8yo9L8pAs0R1+iJAcuSNODEj1SIzSZ6rg08GMp2aB4t7EnPDU
         HNw0NBkH8reDlTtAFQ0m5k0dHbMJsv8GVy7gMtPdu0UozJf+fcKg6R28H/J5nOSCAxEn
         mOdWVRcMdcmtHt0xahGe6B+0M5cDxlq76L8ExAw6KpA8mgp0yIon3EZ4L/tf15iR9CKV
         NXDsVJt3ICxYv92h9zIhc0eSM+/3OeTy07vRX/YMauqzqMbPIEGHVbn+KofzrIoX7wit
         Hqrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486178; x=1731090978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t6n3TCROGALKBhF87tS4HVc6hSldgq3keX1Nmca5GdQ=;
        b=dvexJYbrCKeeTVglOdrHAFh/wi/l/4h9+gVhBCnTNdGqU140VhZelnuypls8bO0vH3
         GokdvFxUcfjCCuXVmvr8KfiRVUe4pelxpiGdismpYKHFuOFbtVexCzGiRsGe7drYDLrn
         2eRyMYOlpjalZ2XO4AxW46V7HDBDNmhJGaw7MC1jxDjYaiZhIpXpqj63N/ahFsBbvHMy
         8vP9oRUpHfNI1ynTiBzRviuVBUh9sP/gM/ymsoDgdY+AX7zOrfuFu9y3/rBc2pgqCPVu
         trxem18zMxQ/e6jdzXzF1AWx/42acCpNkWsOK9bvTbAb1+J7GYozgkRdzJhK2T1SrmwA
         lgJw==
X-Gm-Message-State: AOJu0YxFH9lQ1gHQpRcViR3xIBue3ZBizQFpWOdwCjD9k4R+CSQ42fID
	IM1glJSA/TJUCTqLBJPdvEayjd88X1KM+4hcGG0H7n7xIQykne2jTHfTHMbEASo8vxN8/Rz3Yy4
	ujg==
X-Google-Smtp-Source: AGHT+IH9li/61FEUW1xJGw5b33eDgRmdCZyYAPvyxxo44gUVaRYqdHjdk4v5TgKyy+vIqOwzof42J6bDicI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:e54b:b0:20b:7be8:8ecc with SMTP id
 d9443c01a7336-210c68803d5mr2548335ad.1.1730486178136; Fri, 01 Nov 2024
 11:36:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 11:35:55 -0700
In-Reply-To: <20241101183555.1794700-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101183555.1794700-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101183555.1794700-10-seanjc@google.com>
Subject: [PATCH v2 9/9] KVM: x86: Short-circuit all of kvm_apic_set_base() if
 MSR value is unchanged
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Do nothing in from kvm_apic_set_base() if the incoming MSR value is the
same as the current value, as validating the mode transitions is obviously
unnecessary, and rejecting the write is pointless if the vCPU already has
an invalid value, e.g. if userspace is doing weird things and modified
guest CPUID after setting MSR_IA32_APICBASE.

Bailing early avoids kvm_recalculate_apic_map()'s slow path in the rare
scenario where the map is DIRTY due to some other vCPU dirtying the map,
in which case it's the other vCPU/task's responsibility to recalculate the
map.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7b2342e40e4e..59a64b703aad 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2582,9 +2582,6 @@ static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	u64 old_value = vcpu->arch.apic_base;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (old_value == value)
-		return;
-
 	vcpu->arch.apic_base = value;
 
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
@@ -2632,6 +2629,10 @@ int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
 	enum lapic_mode new_mode = kvm_apic_mode(value);
+
+	if (vcpu->arch.apic_base == value)
+		return 0;
+
 	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
 		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
 
-- 
2.47.0.163.g1226f6d8fa-goog


