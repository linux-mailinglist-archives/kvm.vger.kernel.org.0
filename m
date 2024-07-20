Return-Path: <kvm+bounces-21995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66758937E50
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 02:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C7841F22120
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 00:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53F48830;
	Sat, 20 Jul 2024 00:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ejRIov5z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF1820E3
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 00:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433702; cv=none; b=GuHiX58JK88v9Gv2NYKP4ioFi88CEfKem0Xfuw+0mcLwE9M/aUSpMg+t1KfgToVeFk5a/+1e5AROa/UjjQAiINonwjHGFaXS2nS/hpHtwvJ1VW2PGNFvkbUcRhbZcI/twci/6taV/CaWWBLkyKF8+7G5NI4E1PIIPD3+Ey3zovI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433702; c=relaxed/simple;
	bh=zKOcZ/17Qu7v6XtfeopuihxsA/xqagkCC7r/VB/xMg8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Rac2BZvHrWKXYHJqKSC5OGOnTTmla1NnPZhZYC/cHLV2dMk7kiARyj8kHP+W46tZmn9D++jIE+vy9jNMgRtGCIsDSApPVY8VBsNYOc9qfVOgbog0+eRMOK9c+q2QDZlN9P6/KX/suEM2G/mrUEdeD4Scw5TUpdqPiwe96CxfLtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ejRIov5z; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc05c4f9c4so24824395ad.3
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 17:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433701; x=1722038501; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kwRE/lB6XnWzRpn4tZdnpiLwQkxee6V131gQ6RaCx10=;
        b=ejRIov5zk2wRNQIDwtwwJepCEI1NWNxorvJb5SKiGL7LoAgoN2xar41qtTpkKLMCe0
         iPQTiSxZg1xo32+QigB+mWiy37Z2y9WIsSMDkYcAjlcZ4UaZeruKA/Epusl0h/PUtMVu
         s0OzI67/mYje5OgdgGq+cMDfHiXkxQrTsP4LogLQBzgMbdSxcOQvMcxDca1bjWkMDuXr
         y6HSmVhR9p1DeCa5OjiN2zVzxFo4QPJglw+r1bc8zlaVQmC9kpZmVMXZ4GIj/cJQ6Bxp
         JiuzF7gQ9gHxLgK/fjJbDx3JUBGXH9Bew7KnkpjQtpLtLPihztmqjFuChCNCyro38AsF
         hEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433701; x=1722038501;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kwRE/lB6XnWzRpn4tZdnpiLwQkxee6V131gQ6RaCx10=;
        b=mlBxoDMQtvT6QZGoNI81fpYuPQUJnQX6AmP4pWzivL1Oyay9tEooImRrzeNyJ8w1AQ
         j2MfC+8sn9mOZGJ93y+SUtrXYbhhulIyj0LrOUh6L4e7VFYnPIRvexI3CU5nN/INDTG6
         ENIZTUwZUTs7Jr35X9FjPqYJ+vGnPslUDCO9bbQetMftPfcBDw3hM6SlS7o3MakaI9Q1
         y1fwkNyHLxobl19xDZxef/k+phEIwV7e0yGzFivxsq54b/O735544Qzgi6iBKVdmma5S
         Tad6N0EyXFME8u1yOjTO4UboooyG2ko70eMRss981EGZr8nujTDAq0qPqk9/b25tJ6tK
         ZLNA==
X-Gm-Message-State: AOJu0YwOzti+7BToLs1Qi0YY0oKvsHy8tCWJfLx6kpPnT/74vZkhqCua
	TyqiPCE71rHCJaLBWtZiepIoGSYymrmsdcoe7f0AU/pOJb7XMG2CQaa9WM6Q7aMG8suuzOzFV7i
	Zhg==
X-Google-Smtp-Source: AGHT+IGJdd/lIh6kgApMAgbImNa+p0bD7o/hCkswy/T2NLWgYTvuwwbI+Fq9TlVBuF/yYHgNrZpAxtNcJTA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2341:b0:1fd:6ca4:f988 with SMTP id
 d9443c01a7336-1fd7462db45mr28085ad.11.1721433700595; Fri, 19 Jul 2024
 17:01:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 17:01:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240720000138.3027780-1-seanjc@google.com>
Subject: [PATCH 0/6] KVM: nVMX: Fix IPIv vs. nested posted interrupts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fix a bug where KVM injects L2's nested posted interrupt into L1 as a
nested VM-Exit instead of triggering PI processing.  The actual bug is
technically a generic nested posted interrupts problem, but due to the
way that KVM handles interrupt delivery, I'm 99.9% certain the issue is
limited to IPI virtualization being enabled.

Found by the nested posted interrupt KUT test on SPR.

If it weren't for an annoying TOCTOU bug waiting to happen, the fix would
be quite simple, e.g. it's really just:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f7dde74ff565..b07805daedf5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4288,6 +4288,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
                        return -EBUSY;
                if (!nested_exit_on_intr(vcpu))
                        goto no_vmexit;
+
+               if (nested_cpu_has_posted_intr(get_vmcs12(vcpu)) &&
+                   kvm_apic_has_interrupt(vcpu) == vmx->nested.posted_intr_nv) {
+                       vmx->nested.pi_pending = true;
+                       kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
+                       goto no_vmexit;
+               }
+
                nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
                return 0;
        }

Gory details in the last patch.

Sean Christopherson (6):
  KVM: nVMX: Get to-be-acknowledge IRQ for nested VM-Exit at injection
    site
  KVM: nVMX: Suppress external interrupt VM-Exit injection if there's no
    IRQ
  KVM: x86: Don't move VMX's nested PI notification vector from IRR to
    ISR
  KVM: nVMX: Track nested_vmx.posted_intr_nv as a signed int
  KVM: nVMX: Explicitly invalidate posted_intr_nv if PI is disabled at
    VM-Enter
  KVM: nVMX: Detect nested posted interrupt NV at nested VM-Exit
    injection

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/irq.c              |  6 ++---
 arch/x86/kvm/lapic.c            | 12 +++++++--
 arch/x86/kvm/lapic.h            |  2 +-
 arch/x86/kvm/vmx/nested.c       | 43 ++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.h          |  2 +-
 arch/x86/kvm/x86.c              |  2 +-
 7 files changed, 49 insertions(+), 20 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.45.2.1089.g2a221341d9-goog


