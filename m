Return-Path: <kvm+bounces-28303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75BA49974BD
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3847928ABD9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C951E1328;
	Wed,  9 Oct 2024 18:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bRjp8Pvg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8499C1E04BF
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728497868; cv=none; b=silKG/hP4mEes4V9c8MF3EzZLNw2wjmC1WM6GsGhttdPNFQ6VKTR1oB1xb7YElRV7gXE0K32kJ1pzAvVdIGHQMR4AEIsTfomOovFnyF+kXuVFDj78KW06JgSFQ9j/JnvejlkjBfnX4Q4P0aqTEDXhpV9HJPxy1kitP+jz3KikOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728497868; c=relaxed/simple;
	bh=0zM527JK/paLZTNDe5QFY0koUa6j7yB2QFiZGlD4Z4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qvzshdHWSToZQAb9SGa9XGa5p2BAAXfU+BXXX/wFxhZ/MayMYItvXnEDf4NIAjMN8QxRmvLhjtNv8zJ4wFn99Umak7N666Y0c6SLsdB7HVvqzbJywgOErqkXVdkihAHox4otH3LNnOzcBlwM++gINKyC90s9EdtT0L40IDq0l20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bRjp8Pvg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-70ac9630e3aso106330a12.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 11:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728497866; x=1729102666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=be89kprlJKC4G7WLZof2cKHiOhtzCos3l78DyaXkfv4=;
        b=bRjp8PvgU5Jvw764HVrDE2TtO2Rp3hWQ2w3nm23XPKqLkGlC33NhSP2dporg4Jd1Ct
         Pd9gyEQOfoXip1zs2sulKzyE1U0kTnXx7tR5LV++5c/3Cr9RFafKrIGV/dmlWt4MgL6r
         Wumsvodcurys29Cb3Y+FnY1BOyD9idx4bxaLOfUDFwXEs1G9JjS/jitPPOKOQuJmEpSH
         5y6bIyPAwZkVmKKwiA+ulID7L/EmZVOw3HXomNdm+8bhDm5mLqyHs3CGgKvPsdpT+IR4
         galN9O1y7pYiArwdwGpuhQAsf9RenL1t0wo3ffUuQpzP6KUjgOU/NrpRVp2xO2h/mhfK
         9fFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728497866; x=1729102666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=be89kprlJKC4G7WLZof2cKHiOhtzCos3l78DyaXkfv4=;
        b=Sjy395JQy27JyEiLOqyYn9Uj86CDqopXKan4IH9kKxc5TezOwd+DfN85LCJDJgApmk
         6nDHjxa8w8PBRcABXM7jxNaOKmrYK62UA2Pspgoqcd32/4Zf+i4ijAqGfimedraHpQvK
         uZi4F2VtbFLf+UAksr6p+oJSylX1pEK4dD/F9A8bT+2w/TybPmakx7wJ4K9FHqXPoS4r
         l4zd+HvCWbz2fOgo8U83/kWcPc9gy8Vu3Y0Oar739IUhz2N79wyvpSajNK9HXhOEUhwD
         2zjv638wj9pyQWgjxQcLh4/3rmWWq65VjbN3F8QU06HcJcfwP3jKxyjqQIjQtZ3DjsW9
         c4Lw==
X-Gm-Message-State: AOJu0YwTI+GRCOZNs054rPTKAKtQRm0Efzai/rLzczL6Cu0U+9ESySTP
	dAScijP9P9n5D/8+3oQs7+q/KtyONHM/vi3ocspI4kQ3DgTkyleiACg33EurgFXGDeUf0mLj6e5
	ISQ==
X-Google-Smtp-Source: AGHT+IH++ydkI6iIiLg5mDcR+PNffx9cTT1AyjXQiz1ktdHe1ZEbIL4uc7d0r3nPPztS+TWADPeejHpXgr0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:5a46:0:b0:7db:539:893c with SMTP id
 41be03b00d2f7-7ea320ea266mr3285a12.9.1728497865541; Wed, 09 Oct 2024 11:17:45
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 11:17:35 -0700
In-Reply-To: <20241009181742.1128779-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009181742.1128779-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009181742.1128779-2-seanjc@google.com>
Subject: [PATCH 1/7] KVM: x86: Short-circuit all kvm_lapic_set_base() if MSR
 value isn't changing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Do nothing in kvm_lapic_set_base() if the APIC base MSR value is the same
as the current value.  All flows except the handling of the base address
explicitly take effect if and only if relevant bits are changing.

For the base address, invoking kvm_lapic_set_base() before KVM initializes
the base to APIC_DEFAULT_PHYS_BASE during vCPU RESET would be a KVM bug,
i.e. KVM _must_ initialize apic->base_address before exposing the vCPU (to
userspace or KVM at-large).

Note, the inhibit is intended to be set if the base address is _changed_
from the default, i.e. is also covered by the RESET behavior.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2098dc689088..ffccd6e7e5c1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2582,6 +2582,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	u64 old_value = vcpu->arch.apic_base;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
+	if (old_value == value)
+		return;
+
 	vcpu->arch.apic_base = value;
 
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
-- 
2.47.0.rc1.288.g06298d1525-goog


