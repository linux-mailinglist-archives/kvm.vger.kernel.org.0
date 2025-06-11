Return-Path: <kvm+bounces-49135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B5BDAD618F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEACF163250
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3174C25C703;
	Wed, 11 Jun 2025 21:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K6haRCWK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCAD25B303
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677785; cv=none; b=oohUnS3l/uyDKx6rAWzCRzmVE2gJpgW3jdWWZfSkZvtjfTC8NTUqJ1T4jNl9EjB/pTj6nI/ZIJcponnXtWZ0bBszDM78TgjKrFDeutaRIiMP3sQPyvPZgMd6FKcZzto1jCh6CiIj6r1J0sCFeX2FZ2VM3galO3Ijuh6nsY/VUgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677785; c=relaxed/simple;
	bh=HU/O+hAQBRCathiCEhtneyg+3txtTnYDWui28f+iNq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NLQYj+rGp+qktHqKH2LSMenggDkEUQhmH2eAvZBLbI9RirBeOoDzyl2GDeuIg6fVFwXe7LP14wvKtkhUek2Nve9YW4ZT9hOrIOCINj96sFeD2PkiCsZ6kyrnq54ekLYfRCyFQbagKTbuHTPyxvdlCrETwdwUU6tdgPL/Z7rpWRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K6haRCWK; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b16b35ea570so202259a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677782; x=1750282582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PIqY5l9QTfLBnGxVH0bNVPmqIZNzodkqRPy8g7rI1YM=;
        b=K6haRCWKfka0gB4LnfmDsj+eWuOP+4xTGOO+EN6DLMmxhRfi37u5gbfvJ/UfmCZt3a
         qCVZ2JoauypbcvpKoHQhInucVDP21kHRLvyXy4WOZ2mTU07YnNXUdTXVWQS0udHKE6S9
         KQWvTu/kgnFVYQfcgpzUPVPfeyiHhsKTbqElF/6ll1B131fMWNO2LofaDVAn+VHi8Jq6
         1vv96eCw8InDVWr5ynLwbjsPegWAnJgbqQZLVuQS5+EyOlBg/2+uSREx0awzMfAtYKzS
         Ds95lQW4oRY79LCX6LANmQ8WyrzPD1mfWNdG9Yfppv8w8Bot9gps2jCmyowXY0HljLsw
         DU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677782; x=1750282582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PIqY5l9QTfLBnGxVH0bNVPmqIZNzodkqRPy8g7rI1YM=;
        b=ZJXbVf6A8Pu8tTBe4iI9gTiGS7GlxorEsNUy0KZMxvKlYydR9lRv0wMcVpIsWhHxPM
         rEX6KA9AHvqKJfJpaJuvQaoOkRAj7qXdXyXBtx5/gLXycV1f0gB08guYsrIQA00cB/ew
         1riRMEImiYoCpzVju2ffSU3zI2QtN3JdT9TLSh4K/E9KSGQRqOLe8oVKNn9grwg7hDGp
         UYy2SpyK5wh7y/OCIXhvIOdZMiaXMnIJLcdyastQbefW/yDI3Ef90ozSOEJ7U9PSlLr3
         sg/0uOYgEheVVx1fwRcWSFbwyEDi8DX2xHVrymxvNPqAzbTjyu/qweFDMw5AirkfKx3G
         Fe+g==
X-Gm-Message-State: AOJu0Yyt5umkM7rx2H+3qCouaq1eEB+VUi5boAtOTTUn4h1AAFpUC4Nj
	QjHJ8oKX/xdhT79nnvVP6z5vkhvapkP7q3jhWbpVSCSb2yvfHyOJzD8xwkcdWSWqlW5FrcUbvxw
	QRfP6og==
X-Google-Smtp-Source: AGHT+IE4xupnaiqX63lqW3UVbRH6cr7BEnhgz243ASqU8XEvcG4UXXe/TA4G9u/tYDjQoONdqCLDMZz1UGY=
X-Received: from pghc2.prod.google.com ([2002:a63:da02:0:b0:b2c:4fcd:fe1b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6e92:b0:215:dbb0:2a85
 with SMTP id adf61e73a8af0-21f9b52c5e6mr536039637.0.1749677782442; Wed, 11
 Jun 2025 14:36:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:51 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-13-seanjc@google.com>
Subject: [PATCH v2 12/18] KVM: x86: Explicitly check for in-kernel PIC when
 getting ExtINT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly check for an in-kernel PIC when checking for a pending ExtINT
in the PIC.  Effectively swapping the split vs. full irqchip logic will
allow guarding the in-kernel I/O APIC (and PIC) emulation with a Kconfig,
and also makes it more obvious that kvm_pic_read_irq() won't result in a
NULL pointer dereference.

Opportunistically add WARNs in the fallthrough path, mostly to document
that the userspace ExtINT logic is only relevant to split IRQ chips.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b696161ec078..fb3bad0f4965 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -42,6 +42,14 @@ static int pending_userspace_extint(struct kvm_vcpu *v)
 	return v->arch.pending_external_vector != -1;
 }
 
+static int get_userspace_extint(struct kvm_vcpu *vcpu)
+{
+	int vector = vcpu->arch.pending_external_vector;
+
+	vcpu->arch.pending_external_vector = -1;
+	return vector;
+}
+
 /*
  * check if there is pending interrupt from
  * non-APIC source without intack.
@@ -68,10 +76,11 @@ int kvm_cpu_has_extint(struct kvm_vcpu *v)
 	if (!kvm_apic_accept_pic_intr(v))
 		return 0;
 
-	if (irqchip_split(v->kvm))
-		return pending_userspace_extint(v);
-	else
+	if (pic_in_kernel(v->kvm))
 		return v->kvm->arch.vpic->output;
+
+	WARN_ON_ONCE(!irqchip_split(v->kvm));
+	return pending_userspace_extint(v);
 }
 
 /*
@@ -127,13 +136,11 @@ int kvm_cpu_get_extint(struct kvm_vcpu *v)
 		return v->kvm->arch.xen.upcall_vector;
 #endif
 
-	if (irqchip_split(v->kvm)) {
-		int vector = v->arch.pending_external_vector;
-
-		v->arch.pending_external_vector = -1;
-		return vector;
-	} else
+	if (pic_in_kernel(v->kvm))
 		return kvm_pic_read_irq(v->kvm); /* PIC */
+
+	WARN_ON_ONCE(!irqchip_split(v->kvm));
+	return get_userspace_extint(v);
 }
 EXPORT_SYMBOL_GPL(kvm_cpu_get_extint);
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog


