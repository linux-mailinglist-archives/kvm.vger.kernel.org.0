Return-Path: <kvm+bounces-42350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B30EDA78003
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F8A93AFB1A
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8157F21D5B3;
	Tue,  1 Apr 2025 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a5ziWGK0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092D820E026
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523918; cv=none; b=cNKtJbN13o9EcbqwrMkwJB95Hg8UeYwpGG7cfJRrMU4M8mtlgg95uRCTTFw1XrAirUCpQEaHjzXNhdydEKaJ6THIKjdD+FcOOwWUX4H61NyUQ3JOi2Tmz1W7MJNVIJEtmPHLXLuFxojVQXOQa1divjiHYKfMhfhRhwkNR2fIp+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523918; c=relaxed/simple;
	bh=4+ShkaclNBVkSqlXTUWslO5wly515CBbMa70/QPy/14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMjDAqKzjax7RkyIwHROoFZ3TSUXcUKZNUUyZIz98zYYkUJtYseAEzeeEsBodVBPxbqlZrGa5LVUpyNTk2yuOkq0L04WSUQeSN4GAtR7ZWdQK1hinBW32xWsM/qzLGLFw/SYGye4sSBt/jH2vpiJ9OtTiRkRtYosLSxc6oWPAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a5ziWGK0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UaINNrC6inNW3Mym/pTKp2ET1N4DSwNzn/ffTCwZc4A=;
	b=a5ziWGK0oKoIHNuJiQnGEyZq+DPHg7XmLjZcn5tlBwoJUbdMHwT0ayn/ErPo3Bf3xIvA/7
	5qXhc5Lo0TQ+dZDYi8+RjHPVO9FWf26rMuHiaIUyQGS2GEBS4PDu68Tg42LXkYu5U0oTif
	VC1VRMZoqL22QsTLmjy8nnsN4yipIU4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-7ccnJkkLNaiumHLPY130Eg-1; Tue, 01 Apr 2025 12:11:55 -0400
X-MC-Unique: 7ccnJkkLNaiumHLPY130Eg-1
X-Mimecast-MFC-AGG-ID: 7ccnJkkLNaiumHLPY130Eg_1743523914
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3912d5f6689so3444512f8f.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523913; x=1744128713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UaINNrC6inNW3Mym/pTKp2ET1N4DSwNzn/ffTCwZc4A=;
        b=siN0CsUWCkNJJ1vRwMT+X0pZT6Ajva3ehfkHDrFLSagUNsFPj8P9aA7U99KWgQOUaC
         H3RO1gZNP2upZyB5uClqn5z+Xh77cIPMLtmGllEmhwmy9Corh8gQ0t0iU+2iNP6CIYYO
         ZpAXVQ/Nb5LsiGw3SYGrTEWgrqZQdxq86fqo3qsBnAnMOX4Ow8/aQuZVaTl5qkmnIvjQ
         Q+QEwIyaxNDxPzpF1graBpSjEW1G9nXuScGbQiVd6cG5R6HCCvKyXylt054fyuLdDwit
         HHzg0DrZZLRZMWTnZV/5ua0+i6k+Oi7GwJ8PImYoudeseJUNisnXvoGlvF5mD/dHBVVY
         dT6A==
X-Forwarded-Encrypted: i=1; AJvYcCX/9w6z2Y8K8FffYZcePB5DWKor1gZVAH3sovJuKy3P5dbnGdiHYCi2ILgMDfRpfIGUjh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyStOvTvzQB1SieUaVCwV+0yhVMhczJJt2vGKFevnEkJPrYGocG
	pV8XKiX8CPwirhHEtz1DbNgLCabFa1HA6VWkAh2/MQqzdHxkhozQKnurt2xmXVl1IDXezyEY73V
	cY7qHPqDgXq/fXQeVf4K9Vbk0gXDpughU4vHu0oUjVeqe1JtEaEs2LKmmIw==
X-Gm-Gg: ASbGncs167WX/ZW6cj3XU+n0lw6ZSafM/+XA28fVu9FPzT1YV5Hh0IPjCwZbzhTDcdn
	OCCn7KChLzmMvowTgmRFfHEdY1YrH/sJXVkdzcIBU0+y5qwIeU0455UXGi5x/p8m0P4h9Gt7qsN
	uGYQsz0rShOxCRmBtI7uULsEfFHMmWtsIfyjKNq/I+Onl2Xe7b2wYAUkv3G32l3oS+r02/HbyXo
	qu0ZylycRoWJrkm5Wvj8k68Zdzv1ckYKg/hqgkW44wyaoJ+O6tGtTjDK7a409h7vGfM6Y6Eue/N
	Etf8qcy56cj/QdKHki15Qw==
X-Received: by 2002:a05:6000:430e:b0:39c:268e:ae04 with SMTP id ffacd0b85a97d-39c268eae24mr2570930f8f.0.1743523913170;
        Tue, 01 Apr 2025 09:11:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHP7UEfcGfLr0vO0H9IZqm3DR9p/GuTN1cmhrTGdbGPRl5CO1PoNYMm3svPGs26HA+6q4WUQ==
X-Received: by 2002:a05:6000:430e:b0:39c:268e:ae04 with SMTP id ffacd0b85a97d-39c268eae24mr2570871f8f.0.1743523912597;
        Tue, 01 Apr 2025 09:11:52 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b7a41b4sm14291601f8f.85.2025.04.01.09.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:51 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 16/29] KVM: x86: split "if" in __kvm_set_or_clear_apicv_inhibit
Date: Tue,  1 Apr 2025 18:10:53 +0200
Message-ID: <20250401161106.790710-17-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a527a425c55d..f70d9a572455 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10637,6 +10637,7 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 				      enum kvm_apicv_inhibit reason, bool set)
 {
 	unsigned long old, new;
+	bool changed;
 
 	lockdep_assert_held_write(&kvm->arch.apicv_update_lock);
 
@@ -10644,10 +10645,10 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 		return;
 
 	old = new = kvm->arch.apicv_inhibit_reasons;
-
 	set_or_clear_apicv_inhibit(&new, reason, set);
+	changed = (!!old != !!new);
 
-	if (!!old != !!new) {
+	if (changed) {
 		/*
 		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
 		 * false positives in the sanity check WARN in vcpu_enter_guest().
@@ -10661,16 +10662,16 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 		 * servicing the request with a stale apicv_inhibit_reasons.
 		 */
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
-		kvm->arch.apicv_inhibit_reasons = new;
-		if (new) {
-			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
-			int idx = srcu_read_lock(&kvm->srcu);
+	}
 
-			kvm_zap_gfn_range(kvm, gfn, gfn+1);
-			srcu_read_unlock(&kvm->srcu, idx);
-		}
-	} else {
-		kvm->arch.apicv_inhibit_reasons = new;
+	kvm->arch.apicv_inhibit_reasons = new;
+
+	if (changed && set) {
+		unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
+		int idx = srcu_read_lock(&kvm->srcu);
+
+		kvm_zap_gfn_range(kvm, gfn, gfn+1);
+		srcu_read_unlock(&kvm->srcu, idx);
 	}
 }
 
-- 
2.49.0


