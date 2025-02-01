Return-Path: <kvm+bounces-37032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A995A24651
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:41:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A90777A1E7D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B634D35957;
	Sat,  1 Feb 2025 01:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t0ej3dpj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F809156F2B
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373929; cv=none; b=sNwuRMXreD6w2E+ur10TtbMm8t1M+6N1j4d2Wji6QnTZGXPHDoQPxGLD07Sx7xx4Gai9p+Tbufqk9npM5ac8+/3EfrOEzH5IlFf+s4/62xTMo/3zDtfz0qd/BT9+cXcSU8uZ6zN9h1jMq+hqKk4IGZi985RoT3iJRrX1klPyNU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373929; c=relaxed/simple;
	bh=v9H+2tMmNqFAeOpfbgGt/nZWndkG/fhbAY6d0wjp8N4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YrcKVD1Wd1ujsQo+qfA7mC+HxMNClUtn9oQEsg2ZpO3gWgjVdMPBCO3FmYQmMu3B3IH5qlpPK4aWD0nHJ3xqMbBsY/M1d7weYYmQ2EdFgDk0YhHLR82lB2A4xd579rkXxe7OWdeSjNGxaX4X5ctIlmPdDWsko5llaoZ+SajJXlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t0ej3dpj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166a1a5cc4so52476855ad.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373928; x=1738978728; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IMAYQckruDa+SPrRiOqDGSNb0t/dgyYc3adSwMI6g+M=;
        b=t0ej3dpjti584ksrWRkhAetjp9cq+Y2yxlydSPG9jPuYcmYYI1E9R1yUAdMelTNhsc
         sX3lNxs6JeFoG/8hZaU0/tm7HyFIIk6boWx12JDB2U5bAFAjZWf28RFF+di035R/LR6v
         /QtdgXUj/S114EmPUmAEqTmIBnjNzZPp7CGqLSE9VHso2tJidBso3XNTyuVOZ9saKXWk
         NF/zYkqRpBlsez8tAOOS9VTL0gfErKPrGXNtmzr4jT8MwjTnC0sJvs1lygxIaQfvajhh
         v1hK4qaVZ7FU3yDczElr6xJ5rR+L4p7Up9cCEtlr8MARjsjK36audKkRzNBbKgvdY21q
         sL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373928; x=1738978728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IMAYQckruDa+SPrRiOqDGSNb0t/dgyYc3adSwMI6g+M=;
        b=kOxGxNP0myl2AuRE0qmRm6Jh4VYtwq4t9ZtsRxIXAnqZ9/E3Ia+rzj6jcquQyirNTW
         HhVTLFXSGLMHWjD3fPGQCrm6attI2UplqDlLHwNClqzu6LGVg3ePy1WUgjEt6FTs7kbi
         I/+V//w1XHfAkrISV3a3/d9lvArVziFRl1PTsaI30bpTXDyPiuSBlPrgeVCyP0rDmP0l
         8EOd4gN6e94a3Gou20++Bza/Iy/PMQoHM7HR83d5W9IUu6juLgGuC8R/yRxN2nVH92nO
         +vOYaFfnPKdjtQzSYQ81YP9hIlud5ONq/9lOegeyCvJiSRxLRjRIzG23bW2qG7dS4v8u
         wUOA==
X-Gm-Message-State: AOJu0YzKUFPH9DUQs0tSnJKmhJaC3Gg6pcInjGGii1ndhfs8RogXYPPY
	oxj+fOFTxkcUaFY9KNOVq22A+5sxW5y76FAH5kFdJecPY6CKnVbbMCRw7TcqOzHh0vNvJw2MHWB
	Cpw==
X-Google-Smtp-Source: AGHT+IGH8xQcFoI+aZS/paLcJ3lHOSsoPD/bioCvxQShclhq3Gc+aulVvgApxgkYoQcRJY3B5N26fOk0g0I=
X-Received: from pjvf15.prod.google.com ([2002:a17:90a:da8f:b0:2ea:5fc2:b503])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dacd:b0:216:50fb:5dfc
 with SMTP id d9443c01a7336-21dd7c3cddemr179335675ad.9.1738373927642; Fri, 31
 Jan 2025 17:38:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:26 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-11-seanjc@google.com>
Subject: [PATCH v2 10/11] KVM: x86: Setup Hyper-V TSC page before Xen PV
 clocks (during clock update)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When updating paravirtual clocks, setup the Hyper-V TSC page before
Xen PV clocks.  This will allow dropping xen_pvclock_tsc_unstable in favor
of simply clearing PVCLOCK_TSC_STABLE_BIT in the reference flags.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9eabd70891dd..c68e7f7ba69d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3280,6 +3280,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		hv_clock.flags &= ~PVCLOCK_GUEST_STOPPED;
 	}
 
+	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
+
 #ifdef CONFIG_KVM_XEN
 	if (vcpu->xen.vcpu_info_cache.active)
 		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_info_cache,
@@ -3289,7 +3291,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		kvm_setup_guest_pvclock(&hv_clock, v, &vcpu->xen.vcpu_time_info_cache, 0,
 					xen_pvclock_tsc_unstable);
 #endif
-	kvm_hv_setup_tsc_page(v->kvm, &hv_clock);
 	return 0;
 }
 
-- 
2.48.1.362.g079036d154-goog


