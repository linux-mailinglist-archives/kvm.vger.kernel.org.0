Return-Path: <kvm+bounces-30359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C9C9B983B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1197B21215
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A321CEEAD;
	Fri,  1 Nov 2024 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AK22g6er"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06E61CF5D9
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730488497; cv=none; b=bkjfirq9MILyXjlNNh3jSGGYNdUHN3BZhkbKI16fLS7VTjQE1ES0SSWG+uJRBYZSb9SwU6xa+YNe5XziO+SEPRcQh7j99Ns0uk5A23/khPG/4AEwTKnFUqpbwPwSAR0E0hUhNz/VhGUkw/PVEsGSysbe5RRCDP3L+W/jQxNptMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730488497; c=relaxed/simple;
	bh=AW20RPSqHiDv3fdCFx5HqXZFyAEwbL8305AAGXtmtFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FBzE4U/Ac1LZZh/DaBHwA6fe3IJ6/WwhKEp6zkJn2c9n9fCd8zryq3Nk2QFfHOECUyfM7guL2nnGLdJKYUvH+U7HcdlQJDG3QHdF/Faa3y8BIjgeRyJ2J7eRgojMm/3z6cdlS8d29YPV8tUbFZEvD9apJRUHrgsdnCcmZdvyhmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AK22g6er; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e33152c8225so724824276.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730488495; x=1731093295; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eKpbimIHH00sjHL9LmhMqa7Xx8rmdKzGFtZAWYFdii8=;
        b=AK22g6er8cxh5A75erKAuaBUdWuN2b/rKANfBJi36YWc9723cQ9QGkVWckkNKOzvan
         PaQ+Zi0jOMDAVdB4S8wzPOb6kzp0jWRWDD8U0+GjtbpHPEcFQWvcCaL5oDAeyp7Bmdbm
         SN/TXzSAlE6kOrVZ6BMtc9tlscvEMpijaNiBOl1J5+a9OcBXqScs2jYPO8B6t1SZmrXL
         KUtRrb6nnc9IiuRvncAwAiAUfRfHGdmEwj/05UGN2swVfJlJh2C7T6qmqKSpyQaNQ3Op
         mJVhqubIryAw0/O33WBZzaI9r+V/cbIljBc9s4DFqKHYcohhq6sE9KReGjqZPjeFC/gf
         euRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730488495; x=1731093295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eKpbimIHH00sjHL9LmhMqa7Xx8rmdKzGFtZAWYFdii8=;
        b=ejsxKJTyq2cgPCnYlneXltbJ94y7dEUo3oQo7dgDmZwwwgKwVuH2uF8GQeoohfxocT
         ZW/tvUf/+1CQwo7+FQenNgZ8Ho3HI1fbJsbYe3iN1XugkE4jti00K9OFg8+MZ+CUETR/
         5uIOclmsJjavuOr1Q/8rQc0MuL2ajpMroVqvSQjGB1Iz3aAhCTG1n1sw0d7OiPrqGR4O
         hSAC867smzNYEEOz4PC0Vc56UwkjVsZfrOycYmO2SwhVs54dhh8eDk8nGqi1FBzqlU97
         8aovqwzH7OzE5T2sIGU209L/mMjNyVOlLDDO+15DTetvASbgLULTgaC9VLpvzOj0StFv
         b/jw==
X-Gm-Message-State: AOJu0YzY0axMiFCBNfZL5J6KfVfSark8QKYroO3SFrNZ24PxxHBnkBTZ
	aNrco8q6C/VQoGSCy9mVpBTGKsT8eNzn9Giwhm0I2B6tRxWb2UP1K0sbWJGXaSs0DkbYIJwZorQ
	i8g==
X-Google-Smtp-Source: AGHT+IEg0O0AegMc5HJlVs59TSZ96+d/qrSdvFRy5uOr2T1xkt+bIsh/JxfUJG2zkmVqY/VivVCoVROYj0o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:aa89:0:b0:e2b:e955:d58a with SMTP id
 3f1490d57ef6-e330268d946mr2445276.7.1730488495007; Fri, 01 Nov 2024 12:14:55
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 12:14:44 -0700
In-Reply-To: <20241101191447.1807602-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101191447.1807602-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101191447.1807602-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: nVMX: Check for pending INIT/SIPI after entering
 non-root mode
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly check for a pending INIT or SIPI after entering non-root mode
during nested VM-Enter emulation, as no VMCS information is quered as part
of the check, i.e. there is no need to check for INIT/SIPI while vmcs01 is
still loaded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 84386329474b..781da9fe979f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3517,8 +3517,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		(CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITING);
 	if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
 		evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
-	if (!evaluate_pending_interrupts)
-		evaluate_pending_interrupts |= kvm_apic_has_pending_init_or_sipi(vcpu);
 
 	if (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
@@ -3605,6 +3603,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	 * unconditionally.
 	 */
 	if (unlikely(evaluate_pending_interrupts) ||
+	    kvm_apic_has_pending_init_or_sipi(vcpu) ||
 	    kvm_apic_has_interrupt(vcpu))
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
-- 
2.47.0.163.g1226f6d8fa-goog


