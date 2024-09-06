Return-Path: <kvm+bounces-25981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9769296E8A6
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B50771C23679
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D27A54648;
	Fri,  6 Sep 2024 04:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AFwiOMd2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC0783A18
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 04:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725597260; cv=none; b=SrLKtcsNaWjc3tCKx5smwhF9iVhafaCz4JP2j9d5BtQoXvnwZo/7XdtE6Uksc0OwwiyLlglpGsEHDdHBFTa5T9uw/EJRfKACfs5WlEWGV+/AN1q+YJSKPM81IQA4l8Q4i4ltYJ1QW1WQZnW2lUdLJ/DwXISdZR/pSaZ5SITUpuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725597260; c=relaxed/simple;
	bh=RT1aI6hMXnwPobjxMnyWJW+WtLEHVfvy+uS/LP8jAcU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jwSfbUKWVpyltkfmntQop6HGx8BmsZRrKhrdqsMvRojV7ZKT7+VESYkOpvOiSJ2qu7Pww1b2IVhShzsQwcTjHDv3gL9SdK0+af+qeY6HjuT9jAKN+QrNtggKM8XpNVMmFF4PITCYJmOUej0ptZfdMKx5+0wbPWRL3O6e8deqn+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AFwiOMd2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d8b3af9e61so2042357a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 21:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725597257; x=1726202057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6f4XFGl9ES5RFIpxWgOae+ryWTVpyIEIUyDw0NY4Vg=;
        b=AFwiOMd2mQ3+tCzVimogfIYIAqSGkYNOYeh2dmbGpKtNpQNKCN1oIEKCfC+lIkyxNk
         3AgIzr3vpd5We+Zi+Pi0GBuNbDFFiZIYxU9DLOISB9dJIkfFkBbPWwimIzbWXyTSpgh1
         UK3E684nu5LCzMi6TjtbK7Wq0MmNCZDoKLsXKB1qTkyJbS32/m+D/bXnHrljeCGxWksP
         sY8HNIuVAryTIQQ1qfKKpWRiHk4G2Js6ZYNhqqFW6F2kc9K4eMltIXPgbr19gIYhBXci
         nNISyckXiSF0z/C8GUtEPjcUfSUI/NANB4uBy4bdDJwg4pBoZpz2I7inY56YEM4MAC0m
         NWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725597257; x=1726202057;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6f4XFGl9ES5RFIpxWgOae+ryWTVpyIEIUyDw0NY4Vg=;
        b=NryjxoE94koLigHzm3jKV/5AKFTIKXv7oMifK44Ni2CaRejoUmWWLFEMhZNr/55V02
         ROaF05UCz24HERMJS/vYr9b4ZoT2+ESlTOtySd4s6WK9sSKQbfuFsp2g8BNRJEyhoBpG
         MbLuuOnTKowYmry7BMIn4hM1bFog6pu9OG/msun9PkdkAlJxtCUhmaAr05c4BwZ665hv
         a6Y/tlzJ3Xatcf5Aumhn8f/k1QGaYxfNxSlaOwfXpM9iWCjbkAzqVSMM/SHbwuq3jb4V
         N0hUTvnLW0MjBUY8GVMDdJanWfuprQEpHqdCJolY4ap0nkByYK62nbUCEZN9eZx2k70P
         FOcQ==
X-Gm-Message-State: AOJu0YwJHnMKT9MStNOLT6bUEp8LsKwsxYZQ2/gwnmZ9lcDI5cTtWwg8
	Q8mWmQ7NVkmEfYtZAtxZwKuQNHnBPnKNNZfGeza2Mzyu8fiHhIXVQG1jcji08OtGOteiuGgVf0t
	g8A==
X-Google-Smtp-Source: AGHT+IGFOYWmrB5M6QLnKYNdASjWqveqc4FvIbep8yb+3D99F8n/A6lA+zOOTF0vtx08MfD8jk9Qimnri/Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4c84:b0:2d8:b475:ec2b with SMTP id
 98e67ed59e1d1-2dad50ea941mr3373a91.5.1725597255343; Thu, 05 Sep 2024 21:34:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Sep 2024 21:34:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906043413.1049633-1-seanjc@google.com>
Subject: [PATCH v2 0/7] KVM: nVMX: Fix IPIv vs. nested posted interrupts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Chao Gao <chao.gao@intel.com>, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fix a bug where KVM injects L2's nested posted interrupt into L1 as a
nested VM-Exit instead of triggering PI processing.  The actual bug is
technically a generic nested posted interrupts problem, but due to the
way that KVM handles interrupt delivery, the issue is mostly limited to
to IPI virtualization being enabled.

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

v2:
 - Split kvm_get_apic_interrupt() into has+ack to avoid marking the IRQ as
   in-service in vmcs02 instead of vmcs01. [Nathan]
 - Gather reviews, but only for the patches that didn't meaningful change (all
   two of them). [Chao]
 - Drop Cc: stable@ from all patches.  For real world hypervisors, this is
   unlikely to cause functional issues, only loss of IPI virtualization
   performance due to the unnecessary VM-Exit.  Whereas evidenced by my screwup
   in v1, this code is plenty subtle enough to introduce bugs.
 - Drop the patch to store nested.posted_intr_nv as an int, as there is no need
   to explicitly match -1 (as a signed int) in this approach.
 - Add a patch to assert vcpu->mutex is held when getting vmcs12, as I was
   "this" close to yanking out nested.posted_intr_nv, until I realized that
   accessing a different vCPU's vmcs12 in the IPI path is unsafe.

v1: https://lore.kernel.org/all/20240720000138.3027780-1-seanjc@google.com

Sean Christopherson (7):
  KVM: x86: Move "ack" phase of local APIC IRQ delivery to separate API
  KVM: nVMX: Get to-be-acknowledge IRQ for nested VM-Exit at injection
    site
  KVM: nVMX: Suppress external interrupt VM-Exit injection if there's no
    IRQ
  KVM: nVMX: Detect nested posted interrupt NV at nested VM-Exit
    injection
  KVM: x86: Fold kvm_get_apic_interrupt() into kvm_cpu_get_interrupt()
  KVM: nVMX: Explicitly invalidate posted_intr_nv if PI is disabled at
    VM-Enter
  KVM: nVMX: Assert that vcpu->mutex is held when accessing secondary
    VMCSes

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/irq.c              | 10 ++++--
 arch/x86/kvm/lapic.c            |  9 +++---
 arch/x86/kvm/lapic.h            |  2 +-
 arch/x86/kvm/vmx/nested.c       | 57 ++++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/nested.h       |  6 ++++
 arch/x86/kvm/vmx/vmx.c          |  7 ++++
 7 files changed, 72 insertions(+), 20 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.469.g59c65b2a67-goog


