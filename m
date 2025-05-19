Return-Path: <kvm+bounces-47037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 990FEABCB63
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95BBC189F527
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054C0221267;
	Mon, 19 May 2025 23:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K4RFK20g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B2B220F28
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697300; cv=none; b=Wv8nOjP6180aeXTFaJBfmEpHtI767SIv9CfUsWh0oNkyWsZxt2az/QvADLF0/ZZ6ztc1rWKV2fNDXCJWEaCv6/dDk2eBpC48oMN7/rK/+Aij+ghLb8YcJrfIlJDjBPyPCl1npepeyLzJpKXRi43cdxSgwYnIKAMGL+xIyOnMewo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697300; c=relaxed/simple;
	bh=UwuKTXN4OqCCMe+jM9zYYbs3thcrz+jQJPX8ot07JVQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oSxI2oP28JSWXxJoHVb+Guol8Y+1G2pJvF0O/5AcAQhbVo87QwxL7euFponN7WQJGxxFxoGieCTHstXX4+u7Hua8nVEr2zCraQcyJwHYNCbIH5L3cYT3cCNFfIi2MRaaYjNp+gxK0FYE+JFvZKI+cjLgaIgi+mGLAtPUIQJCL54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K4RFK20g; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e6ccd17d6so5889626a91.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697298; x=1748302098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=13NzYr+pbxTvviNR9IPlo9XaLmrxzIsUh0zJ2XTyH2o=;
        b=K4RFK20gIkQkluTweAlC2hqkCOswmV0WOeSL3ISowcfFw3tbgSbqT2M78ACrzQFi3P
         B4uMfRLfZAn0VrwVMqp4Oi8Z6YlszHcWgx2M4gHVSICjIRoVjVVXaNGcgFK3ZQelxhd4
         ZFv3d2ZtLMEE9UhFpzb9MUO+FgvFsNwWe4j9cS1YixdaeMHAcVpIdJ5QE3DLzjonHfzM
         eRk+2Q9o60iWR/0kbE145g3rMDP3Pt5JVq331fkdK5UpNyBZs+HXsiiQJTAUKJbAErhV
         KiOvJOWVsZmroz4VyRJtbURTAQvt0+VhrILKySHOE9zumEGCAG09eh4deXNPtUqfVmTo
         /zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697298; x=1748302098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=13NzYr+pbxTvviNR9IPlo9XaLmrxzIsUh0zJ2XTyH2o=;
        b=cNLpg7xIAvMmpLSdzmDL6Hbrivzzf78d+i1pMCs9J0mY3rCi2EufpOaan31tIDvWPu
         Y8b+XtHm53cxrglPKkyeiXOJv+zErMgG9/5SlDqUGJUkV7jRr2Cu1ocJ+9C7foTnE6Tr
         Qfr5WR0MAY1TaDKrlvtJDU1NbCzQsF+ck/cuYnQNf5pAn6x39uLhnX4/ZO9ptfVST0ar
         XAMK46ig26HzjlwU45eXU6VF5zPgoS3afZgqQIFCHntqueSvuToMHQe0JrReS8miSG4u
         TWzX7e15Yzu9ebDzxa0OlbK9IHT1SqCC9HE371mekd1kmnZ9CNgOlcWGhBzBrw0wgOMP
         a4PQ==
X-Gm-Message-State: AOJu0Yzy468BFJxlk2pRox+U9LNbfeoEKToqRaG9xNloJ9uBM1Ngl1dc
	Iu5yMbzdX7rPDPQffKKG7ko3abEBAmgKbvRfcnhoy3iKJriB9r5CZgVzZ1QTd5FoPf56f7ojMwu
	zNy36YQ==
X-Google-Smtp-Source: AGHT+IG/CQnReWfNW7O8BXVLAYxKyDMuWKbAMXQaxaCMWzgNBG2DV/wpi6fbS1bYnayYJECsAoA+YL5xfrc=
X-Received: from pjbpb8.prod.google.com ([2002:a17:90b:3c08:b0:2ff:852c:ceb8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1343:b0:30e:9349:2d93
 with SMTP id 98e67ed59e1d1-30e93493283mr21837747a91.28.1747697298154; Mon, 19
 May 2025 16:28:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:27:55 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-3-seanjc@google.com>
Subject: [PATCH 02/15] KVM: x86: Drop superfluous kvm_set_pic_irq() =>
 kvm_pic_set_irq() wrapper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop the superfluous and confusing kvm_set_pic_irq() => kvm_pic_set_irq()
wrapper, and instead wire up ->set() directly to its final destination.

Opportunistically move the declaration kvm_pic_set_irq() to irq.h to
start gathering more of the in-kernel APIC/IO-APIC logic in irq.{c,h}.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/i8259.c            |  5 ++++-
 arch/x86/kvm/irq.h              |  2 ++
 arch/x86/kvm/irq_comm.c         | 10 +---------
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 330cdcbed1a6..f25ec3ec5ce4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2208,7 +2208,6 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 	return !!(*irq_state);
 }
 
-int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index a8fb19940975..0150aec4f523 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -185,8 +185,11 @@ void kvm_pic_update_irq(struct kvm_pic *s)
 	pic_unlock(s);
 }
 
-int kvm_pic_set_irq(struct kvm_pic *s, int irq, int irq_source_id, int level)
+int kvm_pic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		    int irq_source_id, int level, bool line_status)
 {
+	struct kvm_pic *s = kvm->arch.vpic;
+	int irq = e->irqchip.pin;
 	int ret, irq_level;
 
 	BUG_ON(irq < 0 || irq >= PIC_NUM_PINS);
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 76d46b2f41dd..33dd5666b656 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -63,6 +63,8 @@ int kvm_pic_init(struct kvm *kvm);
 void kvm_pic_destroy(struct kvm *kvm);
 int kvm_pic_read_irq(struct kvm *kvm);
 void kvm_pic_update_irq(struct kvm_pic *s);
+int kvm_pic_set_irq(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+		    int irq_source_id, int level, bool line_status);
 
 static inline int irqchip_split(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index e2ae62ff9cc2..64f352e7bcb0 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -27,14 +27,6 @@
 #include "x86.h"
 #include "xen.h"
 
-static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
-			   struct kvm *kvm, int irq_source_id, int level,
-			   bool line_status)
-{
-	struct kvm_pic *pic = kvm->arch.vpic;
-	return kvm_pic_set_irq(pic, e->irqchip.pin, irq_source_id, level);
-}
-
 static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 			      struct kvm *kvm, int irq_source_id, int level,
 			      bool line_status)
@@ -296,7 +288,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		case KVM_IRQCHIP_PIC_MASTER:
 			if (ue->u.irqchip.pin >= PIC_NUM_PINS / 2)
 				return -EINVAL;
-			e->set = kvm_set_pic_irq;
+			e->set = kvm_pic_set_irq;
 			break;
 		case KVM_IRQCHIP_IOAPIC:
 			if (ue->u.irqchip.pin >= KVM_IOAPIC_NUM_PINS)
-- 
2.49.0.1101.gccaa498523-goog


