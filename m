Return-Path: <kvm+bounces-38240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1EBCA36ABC
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 569241896C0E
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0B7188CA9;
	Sat, 15 Feb 2025 01:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rwzn+S4h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E9915D5C4
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739582088; cv=none; b=dCcOZm8stTG7WLbui1kE+P+fHwJ5OcximFplFs9gnLjcivGLeVE7+1S+m/E0iy+7M2ywQhBqO0MyD+RtFkG7y2lbDgOaR76uLD5ePS6ZF1bOdOLHz6r/UY5BLYawXHBuRUgK9L89HyeVJdyZNh+c08/Ir6xwq6pEfCEthyhSgUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739582088; c=relaxed/simple;
	bh=V20/5Zcwsh3LkusvwxipaeAPlQmSrKGd8beRUUCMKWc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q1eNZ1W7NEfn/RcCh0a4iYCeFozGYrlV1HeftxsKe1//iVeyOZWM4MqwTXMNsRO1VTlUIqc2ys4Ds3879GU6LYqW6FnpvYPU/ZcPYQ/EGeN7qcorP3OlRD/BZuNbzWdkFjiw/NbOK83Vqsb99hiwdIFDYb2NgUeWtu7LMn3+Ibg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rwzn+S4h; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220d6018858so42223405ad.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739582086; x=1740186886; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j7vKBoevqSd0YmMKIcf2UgJa+X4zyjdi3hzZRBAtboE=;
        b=Rwzn+S4hIGg4lO+DfRTiSY4efs3/Y/cAxBcBhKr9SwwN1IJ4OS4hNcxNLrJkkLTJJn
         h0Pw3yE5+U31JfWy4pqYUivC/JYuAnWowf/fHtZeFgB2jbPJQW8le9TLU1MXxOWyRDBz
         2NtUvHAXmXllWtXHYWM21FkVpO2ZRJEJsfOHv8NAQGsGNnl1hOVrCBuzn+PHqf0wqryY
         /DHO4z0b6E74WWN4bvUgshv6r4UdeKKthM7TzNLYG0HX15xlNHXMf+s6o8u/knZizIdY
         JyLzF17t18bsC7ykkLFm+zjVqeOv2YgOTGBCTyihitMLmGvXBOhQ0qTgGK+Ny6CvYGcZ
         e2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739582086; x=1740186886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7vKBoevqSd0YmMKIcf2UgJa+X4zyjdi3hzZRBAtboE=;
        b=BuAF5JbpCrDTQHwDzqSZRS0lkFbHl5C/FtRC+XhxpBAlkrvZyX4586JkiPkLM0r27t
         q3QkiR8pCYm0Hx9pbiRvg/Gkb6Ohg93VTDuGvL9GqzSO6BiUJVoEMDetU63vUhvdpDKM
         QmpSaEq41S06/pfbiUKADDBWnuVXH43DhaVXsZZHyv1KK8CyL8dgJRqGPXImx5F+5XDC
         ha7QjccML+BhWKjG/y0FzIZPQdTY1ymqK21wb9eKQrMxdheBuMjMOGQrJ5WbLmR1rjET
         6Vzc4NsgqjRahVFqdAuT/V0ZT784KgIJJanhOZ9SqA4gvT809Ih8JwcnhVD0V6QMH0oA
         q2lw==
X-Gm-Message-State: AOJu0Yxvp0cks/V7O3jzFB7j/uRx53WPf/UumjAbqlB2GhqkNvK6m1Rk
	2wILaOqIGQPG9rBxnr/AWyXcrSOznDB8x50/ji4/DWduapKtrtoeHdlWnq2REzwD87r7Q8FF+Q/
	PSQ==
X-Google-Smtp-Source: AGHT+IGtO3LhcclmaxlBOzDhlZWiTA4X0kQhu9BMoJyJBJrBPP1akoMVuWrkGmqqeaspC7bpVglvyuzDJl4=
X-Received: from pgfp3.prod.google.com ([2002:a63:ab03:0:b0:add:f880:2c5b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e8c:b0:1eb:48e2:2c2f
 with SMTP id adf61e73a8af0-1ee8cbc1ea9mr3069398637.30.1739582086175; Fri, 14
 Feb 2025 17:14:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:14:36 -0800
In-Reply-To: <20250215011437.1203084-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215011437.1203084-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215011437.1203084-5-seanjc@google.com>
Subject: [PATCH v2 4/5] KVM: x86/xen: Bury xen_hvm_config behind CONFIG_KVM_XEN=y
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Now that all references to kvm_vcpu_arch.xen_hvm_config are wrapped with
CONFIG_KVM_XEN #ifdefs, bury the field itself behind CONFIG_KVM_XEN=y.

No functional change intended.

Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b15cde0a9b5c..f31fca4c4968 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1410,8 +1410,6 @@ struct kvm_arch {
 	struct delayed_work kvmclock_update_work;
 	struct delayed_work kvmclock_sync_work;
 
-	struct kvm_xen_hvm_config xen_hvm_config;
-
 	/* reads protected by irq_srcu, writes by irq_lock */
 	struct hlist_head mask_notifier_list;
 
@@ -1421,6 +1419,7 @@ struct kvm_arch {
 
 #ifdef CONFIG_KVM_XEN
 	struct kvm_xen xen;
+	struct kvm_xen_hvm_config xen_hvm_config;
 #endif
 
 	bool backwards_tsc_observed;
-- 
2.48.1.601.g30ceb7b040-goog


