Return-Path: <kvm+bounces-28306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9969F9974C5
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93383B2760B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 665B11E25F8;
	Wed,  9 Oct 2024 18:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="imfZ9yF3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D3B1E22E2
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728497873; cv=none; b=oqvACkOd+CgyZ6HXCt40jHGhXQ7HcZRUPrIslTWi1mODU3dJDkmgPQfimZDO6zarkIdMBwdv1nu9TRfY1uOhkBVuS7UjW02hLCdtSK8UaO8t9EhX3NSkaYwT6UeY7IDGM+cwEIvEpVCqexZNHX0MSVstpvzbIhSv6IACvoPKLJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728497873; c=relaxed/simple;
	bh=dr1ocippoTiMHINFoEKeoOJdkH3TJbfSreMvnI8POao=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IilrEsufyzO2mVzhssHTBQNODPRIiUJ+/vJwM1E6KzSY4Z/2nRQo6HQ0srWBpQqI5in24ncS7D0KOWmhNYqPTfEuMCydYaPuavwwRaEaG7c4fOAwy+Y26bk88k0iE64fkNfTIz8sd48BCJI0gefGyDcLxzXesyoztnmIpt3/TvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=imfZ9yF3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-206b912491eso12480045ad.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 11:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728497872; x=1729102672; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uFbHUh5HFyC0uY+uQnqYlSoSZ23sTgNwEXGQiV0ebm0=;
        b=imfZ9yF3F+EdM9ILJdDLnqX6xTls+cXhKaJb210JUWqIx6YrclGDxuyVRWGjuraXpU
         pUCz23QO17XNGOT9FPLBf+Hlg3mmvx1bRjlMIkMdBXdq0QZWbGquIeZgZJo2OMwBbaGS
         CVQC+VXdKm0TpE1hOGAwR7Cwcak2Wc6v7ouNXDt6lYdzis8S5SN221as6zYGTcOjJApM
         W8DMlWHNkwpASSelXror3xobdXWVz/OvqiXBvO2zSCH/HaahMnfACPN3VdCamhW5z/Fo
         RBIZYwWIWaufqsU7ELvS8YzDJJCxYYXAGXTddiOngyrq9z1GExhVGZinKHwWv8HET4k3
         BLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728497872; x=1729102672;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uFbHUh5HFyC0uY+uQnqYlSoSZ23sTgNwEXGQiV0ebm0=;
        b=knRdos+shgXa1k8g4IbIm926yQlkmc73nqLSOFNsk3vhlnwbQ1D0LeT/6mmom3ht9g
         geKSLtbiwWEP//1aH6WWuqIxfAPQ4PqYMuh218hBH6F+Ua29QZzoFOk+SYgo6BgQe1Hk
         REDLPcE4Ab0jLx55NDXlj2HztvNIPJjNZKl+25tEfWlOBRQlI5VBCIMa5i7JHUUsjAb6
         ZzQkxWKl/WbJCPajHHgWfs56Q1nCzdSFukNnNhgqnQhP+Eq7ii/V0x1W6lF559vF7Tli
         eyLwNX61lkLVCWtyi6RuC/MJY8xGy3cn5cuEW+gA+2C3XFoTxxVkku6CLm+R/RxEHLNr
         kuTg==
X-Gm-Message-State: AOJu0YyonuBrvRBjLONM5GFLZylhDWMXD5h6MQxYt5qSqzoJWq76BeL7
	vgFIaTQqVQhG3KJLOtc5ojY96uIRy7YZJWA6RcIWaXxCzsnzuLikV4WT+VIIzrQHOUecOlHc/Je
	DCA==
X-Google-Smtp-Source: AGHT+IFxgGjwSMcuXgjNkJ5HhITFq3whkXYGmzmgq9KCSPfSEZArwXJp8THUlfo6pQ76SR1lEIlfpReep/U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cf07:b0:2d8:8c74:7088 with SMTP id
 98e67ed59e1d1-2e2c7f4f80bmr1263a91.0.1728497871555; Wed, 09 Oct 2024 11:17:51
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 11:17:38 -0700
In-Reply-To: <20241009181742.1128779-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009181742.1128779-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241009181742.1128779-5-seanjc@google.com>
Subject: [PATCH 4/7] KVM: x86: Inline kvm_get_apic_mode() in lapic.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Inline kvm_get_apic_mode() in lapic.h to avoid a CALL+RET as well as an
export.  The underlying kvm_apic_mode() helper is public information, i.e.
there is no state/information that needs to be hidden from vendor modules.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.h | 6 +++++-
 arch/x86/kvm/x86.c   | 6 ------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 441abc4f4afd..fc4bd36d44cf 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -120,7 +120,6 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
-enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
@@ -270,6 +269,11 @@ static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
 }
 
+static inline enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
+{
+	return kvm_apic_mode(vcpu->arch.apic_base);
+}
+
 static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 {
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 046cb7513436..c70ee3b33b93 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -667,12 +667,6 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
-{
-	return kvm_apic_mode(vcpu->arch.apic_base);
-}
-EXPORT_SYMBOL_GPL(kvm_get_apic_mode);
-
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
-- 
2.47.0.rc1.288.g06298d1525-goog


