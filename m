Return-Path: <kvm+bounces-32688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 815FE9DB110
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40ED02823A0
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81CCE1C2420;
	Thu, 28 Nov 2024 01:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tNkKa1Qc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36871C1AD1
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757738; cv=none; b=LC5ruwhLCX7Opzci+AOaEqpyGUgnOXmKQ4RaCPzwSsAoUIlPT4xsEAqC12xCH56lUQNP5PtaU5/5Eh0/WZWsegoBKdyWJgoly57qd/nrDJvupa646PzHeSApQNytMGUiRvDrQzZurXcFvsOBdbfiBAXcH83hpcrWZUWgg9sAwbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757738; c=relaxed/simple;
	bh=Yzxh32zMC9cuwCoV0mcDRBR5LUTqIY74e9pZtQNtQIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aOr16h4Kpv/3Mv4ljFC/XGtpoGCwjiqPIZpJnWKRDIWRLvnutlu+/mwyEqzl0WQ5deYH45SoeRpY977PHmAa1AYtBthvnYnC84aBNz54IMvOAop470LIF6Oq5qkFciuTNF5QFJSCwj0RLQEt8tnrYZSOwTowBEwgDG3dCYyYOs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tNkKa1Qc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea396ba511so401335a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757736; x=1733362536; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+r3YaJVI8SArru6YzRyxshHYF9vDpkxkSnZ/zCtA4vg=;
        b=tNkKa1QcB36OvgQvQOGjE1vZqBes79dd/ZrAb2pBEU+9ldJwfoRpWo/yIeCGRBupoK
         VflFvpYP0BYn6nXjS2hFypq4nueuV96i1oNAbtP3Bsiavr+dwJgVsE4JKfM+vk17pQWz
         aIhSiRWUqvwqFwKiY6OPuQFwQDDitkerlbTaZ09lSFmjEJ5JfnFCgSUMV6KXZnKlkSb7
         yt/lg8nvyvrR44D+q/YdIbqxE+r3yVTiB7wR7TT+IyXQwxeUYARW/p4FxslX1GZXa9fb
         OQhCrrrito5qex4hyOfqHYSTfx/GVGkYfOoiH7QsKMaQoBjb9w7NDbdgKcw1YTQTMHJo
         UYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757736; x=1733362536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+r3YaJVI8SArru6YzRyxshHYF9vDpkxkSnZ/zCtA4vg=;
        b=aFYbvMrKh4yPFjkAzilLAMcPr0x7XKVEUsEkk8Y3TDlrpzMm6kZfgRjThB7A6C6NhP
         cUYdOPOQts+6pnzF+OicaWv1XKVkwkqDJy8PZZESfKn8HcOeXIxZVWn6UsCsOYmYdVrH
         beqF80ELChXb1Wv51F5c7m22gyXzq+cqFOEZb+0AkGnlqt8hexiABmLLA9Pbwt7Oz+H+
         jex9ewjEWz2I9k44x30+w26XO1vh1HF1A7/Y/gNzW4i0fC8e5yr5kWwEvTI+YGzW1ZJo
         2/dBZ6VZqwSF292RfbzQoZZziCy0lKSmsMengCUZPIS/fLeRqzCd69fi7koWKcOq7ttB
         xqcA==
X-Gm-Message-State: AOJu0YxynY7d8weH99DuUIYBByJ4O4xOq1+tijE2sLrF6/Kp6vE/CDFt
	u/F65pi9dkCed4MACk0jQ5aExYm42MXx4vNCkTQl8RhoV/70IlvGEMjYVO605lEQ3mEsmtiCLdJ
	97Q==
X-Google-Smtp-Source: AGHT+IHBjhGVoI3QpGx6LnIojWm/sC/X+Cwik3k+m9dhBlZ/JeQyiuq1m19KKA0Gh5+j9faOtyHPg9PbRso=
X-Received: from pjbsy13.prod.google.com ([2002:a17:90b:2d0d:b0:2e2:8611:a2cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b4f:b0:2ea:8aac:6aa9
 with SMTP id 98e67ed59e1d1-2ee08eb7cb2mr6058336a91.21.1732757736300; Wed, 27
 Nov 2024 17:35:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:04 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-38-seanjc@google.com>
Subject: [PATCH v3 37/57] KVM: x86: Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Unconditionally advertise TSC_DEADLINE_TIMER via KVM_GET_SUPPORTED_CPUID,
as KVM always emulates deadline mode, *if* the VM has an in-kernel local
APIC.  The odds of a VMM emulating the local APIC in userspace, not
emulating the TSC deadline timer, _and_ reflecting
KVM_GET_SUPPORTED_CPUID back into KVM_SET_CPUID2, i.e. the risk of
over-advertising and breaking any setups, is extremely low.

KVM has _unconditionally_ advertised X2APIC via CPUID since commit
0d1de2d901f4 ("KVM: Always report x2apic as supported feature"), and it
is completely impossible for userspace to emulate X2APIC as KVM doesn't
support forwarding the MSR accesses to userspace.  I.e. KVM has relied on
userspace VMMs to not misreport local APIC capabilities for nearly 13
years.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 9 ++++++---
 arch/x86/kvm/cpuid.c           | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bbe445e6c113..61bf1f693e2d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1825,15 +1825,18 @@ emulate them efficiently. The fields in each entry are defined as follows:
          the values returned by the cpuid instruction for
          this function/index combination
 
-The TSC deadline timer feature (CPUID leaf 1, ecx[24]) is always returned
-as false, since the feature depends on KVM_CREATE_IRQCHIP for local APIC
-support.  Instead it is reported via::
+x2APIC (CPUID leaf 1, ecx[21) and TSC deadline timer (CPUID leaf 1, ecx[24])
+may be returned as true, but they depend on KVM_CREATE_IRQCHIP for in-kernel
+emulation of the local APIC.  TSC deadline timer support is also reported via::
 
   ioctl(KVM_CHECK_EXTENSION, KVM_CAP_TSC_DEADLINE_TIMER)
 
 if that returns true and you use KVM_CREATE_IRQCHIP, or if you emulate the
 feature in userspace, then you can enable the feature for KVM_SET_CPUID2.
 
+Enabling x2APIC in KVM_SET_CPUID2 requires KVM_CREATE_IRQCHIP as KVM doesn't
+support forwarding x2APIC MSR accesses to userspace, i.e. KVM does not support
+emulating x2APIC in userspace.
 
 4.47 KVM_PPC_GET_PVINFO
 -----------------------
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 150d397345d5..51792cf48cd7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -716,7 +716,7 @@ void kvm_set_cpu_caps(void)
 		EMULATED_F(X2APIC) |
 		F(MOVBE) |
 		F(POPCNT) |
-		0 /* Reserved*/ |
+		EMULATED_F(TSC_DEADLINE_TIMER) |
 		F(AES) |
 		F(XSAVE) |
 		0 /* OSXSAVE */ |
-- 
2.47.0.338.g60cca15819-goog


