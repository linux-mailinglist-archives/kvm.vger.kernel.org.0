Return-Path: <kvm+bounces-19084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9983900B37
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 19:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E1B81F2442D
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 17:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1435D19ADB8;
	Fri,  7 Jun 2024 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vcJDljGS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC81A19D064
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717781185; cv=none; b=DR47MkPHtJBCmYLomrz/3VKf62som8fvKxpx2kEcckZ4zPVsgo4hSWxaiBxOSjw7xeK6rPIAlRKOg0+VMAEsK2Fh+hrBIsVCnaYPjir+XdRlLSv6TlHYMCXwzL0vr51INccbtm45QRH7DjjwWE3HOh/b9JU/hJx8Ga2gu7xCO3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717781185; c=relaxed/simple;
	bh=EkyMwxgguAdShYFUA0GXN+UsQ76+bfUZ2h4ecWNIerk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cV6MUiXcQSXuHdDBKqEVab9nH6Ds/UGk6VEOh3Deg9BSsLArqypqX0Z2Gq5F/0QXs1xcFcucUoEHNJPMtZ6Ul+ctdxLmnO8zY52gj220ENcxdOCiW/pQGcIaP4/hLKr9cuak3rEdQKYVtR18TrJ7OOQvYPC+vKOqjBKZCpKFyC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vcJDljGS; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-629fe12b380so36236087b3.1
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 10:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717781180; x=1718385980; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uvcmSFh6UDPlnnaoqVbG3z1+eul2qj/DkJROW9dPPPM=;
        b=vcJDljGSZJDzjPb8utCkJ4FypfZ29PYbOLV3rfsiWDB3VlWaK/kucDGxt659/RWNmg
         Al4UKWV6aZMaNMUwLIfOssKXD3QPgT7a6FXjZDJL04wKIve3EzPnPcnJk3S6wlhSXC0r
         2oJkTzGX3o6/CZaAIHT9DpvIk2rddXXoBDST+t+trdnLR8ORMD3wBr2JJ6oTcsQJsZ2A
         +H4cQoOEzZGkBg+K+Wqy0myjDeBEfOhjmRYO1edG1kSgWh+C5V3Kf2ukHJV/0xIHGHQt
         LDkfdTbz2UxKXtvBVzzWo511jsGk2GUcB+LYDJGzyqUrYe1kdkdEmyeom/4HhKLtysg9
         LO5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717781180; x=1718385980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uvcmSFh6UDPlnnaoqVbG3z1+eul2qj/DkJROW9dPPPM=;
        b=nVz1GuEVnptGg2ax4fyMzvn1SF0lsCo+qGN/MjqYbSYnYZgr1rdhKrR2/47Iu9indS
         px49gbnK1qIfcubPVHIc2aEwN4ro6gUS/7YwFQNq9j2xSDJMZwpttz+PKXXAoWhMi+GB
         j/kfbE0nA8fhj7pM+iLXP/8C3rsACVQdh5ZIJ5vTVb24JQpsj+ln+QfLAj12wmVtx3G6
         MwZxjOBjStqPTTWeDzfK7Fvb4XTp6BpCjMn+KPNzGzrDk7Jqp7pWpPgR7DlVNCvk1g4J
         6ILO70ugAAqBkCkMQJWqfBsr25xYzJgZ12QKbu3JCxnoBmXoyqgxnlUU14Jc3uvA8Wbg
         /68A==
X-Gm-Message-State: AOJu0YxAj/xNG2VM/8NvpOocqS1n6sMixC7DuSrKYBhRHpEijgGUX+oK
	vCeUuQCHqnWYzwFGf4pOXP4Pk0tGeWfAmUXszpPzevDkccQ9zPgjtRWVJNyjC1pt49yRUPMBG/Y
	CCw==
X-Google-Smtp-Source: AGHT+IGIZ4Qb+0glovi73d9KZDhjY95rWNohcXu2h9SyflsuTB9XzgO6rUM0AtwM6BI0O8URSVqN8+IbMWY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f12:b0:627:a671:8805 with SMTP id
 00721157ae682-62cd558cf7cmr8461517b3.3.1717781179894; Fri, 07 Jun 2024
 10:26:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 10:26:07 -0700
In-Reply-To: <20240607172609.3205077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240607172609.3205077-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607172609.3205077-5-seanjc@google.com>
Subject: [PATCH 4/6] KVM: nVMX: Check for pending posted interrupts when
 looking for nested events
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Check for pending (and notified!) posted interrupts when checking if L2
has a pending wake event, as fully posted/notified virtual interrupt is a
valid wake event for HLT.

Note that KVM must check vmx->nested.pi_pending to avoid prematurely
waking L2, e.g. even if KVM sees a non-zero PID.PIR and PID.0N=1, the
virtual interrupt won't actually be recognized until a notification IRQ is
received by the vCPU or the vCPU does (nested) VM-Enter.

Fixes: 26844fee6ade ("KVM: x86: never write to memory from kvm_vcpu_check_block()")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reported-by: Jim Mattson <jmattson@google.com>
Closes: https://lore.kernel.org/all/20231207010302.2240506-1-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9099c1d0c7cb..3bac65591f20 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4034,8 +4034,40 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 
 static bool vmx_has_nested_events(struct kvm_vcpu *vcpu, bool for_injection)
 {
-	return nested_vmx_preemption_timer_pending(vcpu) ||
-	       to_vmx(vcpu)->nested.mtf_pending;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	void *vapic = vmx->nested.virtual_apic_map.hva;
+	int max_irr, vppr;
+
+	if (nested_vmx_preemption_timer_pending(vcpu) ||
+	    vmx->nested.mtf_pending)
+		return true;
+
+	/*
+	 * Virtual Interrupt Delivery doesn't require manual injection.  Either
+	 * the interrupt is already in GUEST_RVI and will be recognized by CPU
+	 * at VM-Entry, or there is a KVM_REQ_EVENT pending and KVM will move
+	 * the interrupt from the PIR to RVI prior to entering the guest.
+	 */
+	if (for_injection)
+		return false;
+
+	if (!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
+	    __vmx_interrupt_blocked(vcpu))
+		return false;
+
+	if (!vapic)
+		return false;
+
+	vppr = *((u32 *)(vapic + APIC_PROCPRI));
+
+	if (vmx->nested.pi_pending && vmx->nested.pi_desc &&
+	    pi_test_on(vmx->nested.pi_desc)) {
+		max_irr = pi_find_highest_vector(vmx->nested.pi_desc);
+		if (max_irr > 0 && (max_irr & 0xf0) > (vppr & 0xf0))
+			return true;
+	}
+
+	return false;
 }
 
 /*
-- 
2.45.2.505.gda0bf45e8d-goog


