Return-Path: <kvm+bounces-23113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB033946375
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78FF2B22793
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B002A166F3E;
	Fri,  2 Aug 2024 18:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RChvzNbP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735DA175D5D
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722624931; cv=none; b=g5kmfSaywVu64tY0cMuKj513h9S/yBPTKIrCLNg8UTQ48seYcujR+cX4hNWzchNYW4QrUVkjQx43jZM2kR2mglyEL+lw3yWGCcB8vlNG3jWoGD8Bc032xqkTL1oyvJF3fWNyEq3ieAThw/oSpYyIEBMezgN7l1UYt/se//paaes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722624931; c=relaxed/simple;
	bh=eldBfQsKlvf6Q8sBz99QXD7HgSq5xAkX0So1tJInRi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O21y7jAoy5kDtw+UHOVlZwvQZFRmQX3gWeli+CiqpCORU9TZXrh40Lck6NOf2ZuxzUr2v/mYAqHiOeDks0De9CGRGKTjx5pL1Ehzs3VGUR1xphMvbdl4+/6ggChf5zmlbff5i0HUAJWF1kuXSck8Ok+IyYRh9OUBuDViVuNBdz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RChvzNbP; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02a4de4f4eso13419992276.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722624929; x=1723229729; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ms2G/N43YcnOQEtV252HZgnjvxOb+bhJxEe42LzAOQ=;
        b=RChvzNbPxO5wqCRDS5GNGJPvsZWis9vVM7aYGxOSDDsBU2fTjUfCmHjDBwvXqpuWS7
         x5Auyd5RScbOUHu7IzdBfcHr4vtci5kBxko5zJUknTcJ/jDnVQtKVnkIkRN3KvOzrGF1
         uN5PHd3oVxG5/iwdLUWnQBJQz7Q2UsgNbFWrTdzdDXVPnFfv68hmPlSb+n7wWMO/Zq+J
         fp2jx/n3NMcHhs2SlR33FQN/XNutHAIvgcYeCYXJI9wn722MQeczlZtrceMp+ZFBrmuT
         9lmD2G2hp0dm/3Godk7gaGHhLHFw7vEvVCVC7t3VoWLIXN9rKYLLhFSTURC99Ok2rrM7
         9NXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722624929; x=1723229729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Ms2G/N43YcnOQEtV252HZgnjvxOb+bhJxEe42LzAOQ=;
        b=sMQknN9FjEz7OeYjeUFNGhqp4Vxv3aoubfyPtAfJoGxTXKjClMlHl4I6+bNhIxWfJR
         8pgl+tqCB5hGtIw7CE8VOQQmuiBySPqBa/D879EmoGxI9IGmYIar8hI4kWw7Afs333Cd
         EDuacmAsENp71XTbNqTbRc+vNmoKOLHIVZ5YEWNQTIyM10xLLrDz295P3dolwOPMBIzY
         LqVBU3M0h5xDVvLuV32+ObE0gs3BhNcXm0xMyYwW96h9fybNlJ61DOUy3HHEGqS+9hsg
         GOl2iNlhXCVA3zEqIB3zwNl9ZgccSus0wR+IoTDD/zgkd0F1WlQ1eBfi2itWzE6YS+EE
         RLeg==
X-Gm-Message-State: AOJu0YxCS9MgUEwucV7SCWdCaP0ZYbCLxZaGJac6HeKaqHu9bWNxe+0/
	4Nn4v8TElYnFoDAJvAdoXjL+e/QWfNHWhr89IrX1dzk3dCop1RGovzWffpEjwdhaKq+s4OBDFjS
	HDA==
X-Google-Smtp-Source: AGHT+IE5ZituWgyzRKqfrwI9WzmKAGDShHhzJZxZ/psL0bnmPJfQgggduhQLEwCQFk9i2qOOViKCepO0JC0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154e:b0:e0b:bcd2:b2ee with SMTP id
 3f1490d57ef6-e0bde290b7bmr7689276.6.1722624929082; Fri, 02 Aug 2024 11:55:29
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:55:09 -0700
In-Reply-To: <20240802185511.305849-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802185511.305849-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802185511.305849-8-seanjc@google.com>
Subject: [PATCH 7/9] KVM: x86: Remove ordering check b/w MSR_PLATFORM_INFO and MISC_FEATURES_ENABLES
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop KVM's odd restriction that disallows clearing CPUID_FAULT in
MSR_PLATFORM_INFO if CPL>0 CPUID faulting is enabled in
MSR_MISC_FEATURES_ENABLES.  KVM generally doesn't require specific
ordering when userspace sets MSRs, and the completely arbitrary order of
MSRs in emulated_msrs_all means that a userspace that uses KVM's list
verbatim could run afoul of the check.

Dropping the restriction obviously means that userspace could stuff a
nonsensical vCPU model, but that's the case all over KVM.  KVM typically
restricts userspace MSR writes only when it makes things easier for KVM
and/or userspace.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8bce40c649b4..32483cc16d6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4119,9 +4119,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.osvw.status = data;
 		break;
 	case MSR_PLATFORM_INFO:
-		if (!msr_info->host_initiated ||
-		    (!(data & MSR_PLATFORM_INFO_CPUID_FAULT) &&
-		     cpuid_fault_enabled(vcpu)))
+		if (!msr_info->host_initiated)
 			return 1;
 		vcpu->arch.msr_platform_info = data;
 		break;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


