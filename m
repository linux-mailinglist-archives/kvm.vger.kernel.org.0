Return-Path: <kvm+bounces-54966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9D1B2BCA8
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FED81784FA
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A577E315781;
	Tue, 19 Aug 2025 09:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fYXNToH9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EDF315765
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594545; cv=none; b=Ob2g8Jsp4eMPiaf7+oeqW8yzshC0TgEMCKhVfLIzbpO4840Zfq4jngQnHTBOGwhuMwhCiY9D4ewSbcjCyIBZ93F2CLih93Zv7HVDi2o9MyEgC0SaxKOk4EpkzYyO6awdDoAwLOB/o1HixCiXkebW5YY+zR7If8cP0DDar72B3VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594545; c=relaxed/simple;
	bh=H2tOAJiT9+UKslPsSm2DpbqQjItGsMTWZFtsWcCliJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NNneBp7ZFZsMqklF562b+7PJ+skc4K1Bo+1Eg7GDuxvmwok0bV0Dhtj7R7UyaAktahs57vFCFc5G0UrYgejTk4iBBmpEEAr2llo8p4EafS8/Ty2aLFcfo1kPP0ndeD54CzCX305k/NAb9vWuFFj1XjgE9tqqJ/zBAuQq4156yQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fYXNToH9; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b9dc5c2c7dso2779052f8f.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 02:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755594542; x=1756199342; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dryunec7C15FT43WsTYqyK8BC2tH9vRzD5ncvT1VTyI=;
        b=fYXNToH9tEqgbEMXVOP5e5crtcIxIxr+Uk7zs27IWvQhA5rlV9cw2n5Gr4i1RSqO9u
         OSUsTNsfQw40GtiIQ8viYHgfpbsyxzt+Y4Z4OeLH4CqfSZBu6iT85sZ3N+lIfq0nJsmt
         OSHbojn6RtuhFGZrgsgTRoP5qrfN4Yu0TTnvhF+DHThf/qKRMmgbo/CmNIGlfYXGfjb5
         h7baHupfizv+ggwN787/wgd9mvqjLHrFrLc530OfPDPrg/iseoFcii4f2xX4/PyBk8+I
         q18KOIViTOhkj61WHgqWOgyt3cxVfK/lqmXeQlZaGUNbpunOpwzodlVsbG/detztO2GL
         gObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755594542; x=1756199342;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dryunec7C15FT43WsTYqyK8BC2tH9vRzD5ncvT1VTyI=;
        b=A+BqWjHbwOEeXcJubBkRrEavMERF04x0rgjlDM5wyJAk/cDn51dkvSne9pUxfgLMYd
         yMSObgY973tRvl7RsgEdVyBpRycYy4jiyJm7/22oAkuOMF5gFzwoi3mZp5Ae1poJgJZV
         kDaqK782zYdKLHt135OBOWYApou3o6++ygyQiPsLA4qMvmQJs3vXcufk8QrN9iztlFiy
         xU0XGQqk4eSHEzIVAFvphEB0USplQaQofaQ4A1rKiaD4ld+6YV+isvu6UfGKTNFk2VmA
         Pdku60Ve5Co1kPqo1bN04Hbnaod3crCZ9JEIpBdFCnU2SGbuh56Mg6OmvyU7P/5wx3gW
         YvCg==
X-Forwarded-Encrypted: i=1; AJvYcCXJX1w/BFu4Qz3X2lBY/PZ5uo1uyoq+S//Vd1YRVD7OVnCT3jv7EF3BPDHV8Gz3JpeAfEo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFa0nqGW3LtRtyCfHo8KV6g/xlLsT5BaQITWdsB8QxuFXJSQkG
	YskXz7Aq0QfKebXCm8mfP8A/rm+jdFJIvj4CmRiIPGLt2KLpTcE0dWbifYn8/MYNKJ07/Sg0YNi
	Zwg==
X-Google-Smtp-Source: AGHT+IEWZK/S3bmfcTBpMD/OWSO9i/fgVmwIt0LtH8csguKl7P4ZrXGSAdstuEmNYdGpRILLFl16F7mudg==
X-Received: from wrqx7.prod.google.com ([2002:a5d:4907:0:b0:3b7:8342:dc50])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64ef:0:b0:3b7:9c28:f846
 with SMTP id ffacd0b85a97d-3c0ed1f3372mr1452415f8f.44.1755594542204; Tue, 19
 Aug 2025 02:09:02 -0700 (PDT)
Date: Tue, 19 Aug 2025 09:08:53 +0000
In-Reply-To: <20250819090853.3988626-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819090853.3988626-1-keirf@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250819090853.3988626-5-keirf@google.com>
Subject: [PATCH v3 4/4] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

Device MMIO registration may happen quite frequently during VM boot,
and the SRCU synchronization each time has a measurable effect
on VM startup time. In our experiments it can account for around 25%
of a VM's startup time.

Replace the synchronization with a deferred free of the old kvm_io_bus
structure.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7d6111cf254..103be35caf0d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -206,6 +206,7 @@ struct kvm_io_range {
 struct kvm_io_bus {
 	int dev_count;
 	int ioeventfd_count;
+	struct rcu_head rcu;
 	struct kvm_io_range range[];
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4f35ae23ee5a..9144a0b4a268 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5953,6 +5953,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_read);
 
+static void __free_bus(struct rcu_head *rcu)
+{
+	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
+
+	kfree(bus);
+}
+
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
 {
@@ -5991,8 +5998,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	memcpy(new_bus->range + i + 1, bus->range + i,
 		(bus->dev_count - i) * sizeof(struct kvm_io_range));
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	synchronize_srcu_expedited(&kvm->srcu);
-	kfree(bus);
+	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
 
 	return 0;
 }
-- 
2.51.0.rc1.193.gad69d77794-goog


