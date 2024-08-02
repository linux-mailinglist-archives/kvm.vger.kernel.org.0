Return-Path: <kvm+bounces-23147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 787A29464A0
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AF981F22B20
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9DB7BB14;
	Fri,  2 Aug 2024 20:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q2vQpciJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8282461FE9
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631809; cv=none; b=OmUhEfQrcq89RJCL5bOe+6K9LWg7l2TFjtuISB/j8JvODyKCpmGMZDF0a1SekKD43AT1mv+cdl3Rb8Qy9q29sTZ06gw8Iqev9T+FMcUookrz1gijqsiC30QjEcCnPMxIEmlUPHxNtB6xnkZnjE4oQaZeGOxE3iugeYWz+/F9hUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631809; c=relaxed/simple;
	bh=sBOo69kX0YSryhxxIcP7p5qc/h2v/Z1JZ3udeP11lhk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YZCUMRmBXy486sqZbCX3Ot8lnFK3tpGX+VaaHxm4/QWGXWhtiZv+MVtGCxets07AeRvAYtfxl7eh6CQQV9x4sn1cJEBC78hnGWK/Mx+ll3TVDf+IQrdDHtZy8NSDG3oMTaMa+vVvpMWAQ9fxHs7JV6QcmcOIlfs1nH2rwOuVXbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q2vQpciJ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-721d20a0807so8648546a12.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631808; x=1723236608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=O9gMVDnHqOtk8HQWACGShA2WLrj6CrVEJQ1Rnn6+n04=;
        b=Q2vQpciJXWKeda903RP1ApRBHHnwXCeZMC0TnkqRpsPVO7XOGehAlGOYqEXCO+ReaJ
         5/ofGa0ihuARQPbJoRNYAVdr9HDaJSq6Od5jkNayPu1sRqOGtIMZSFcEMai+Qt2uRnJb
         9n7usvWB5NXdavwFQBAh84iBQBS8UQY3351a2oyK9SKB4Wft6Hp+7CRjAKDs5klHYUn1
         zceg95trXDojyAZf7L3DY8qmBFzpMJxYng9FHe5ZEnrypbP2Z8BmE4XA/UVyaqJd3OpI
         imTRGj1Q2sDf20jLYvhGpec82BAieRXjq5/TnzqBnQJG8G2g6AvaXmoq9BHtW4MBNw0F
         Uh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631808; x=1723236608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O9gMVDnHqOtk8HQWACGShA2WLrj6CrVEJQ1Rnn6+n04=;
        b=ehV4wD5zuUkpxJ0UgeeqPU0YP9hJjVjI8EAhSducxxlC0JegKdvWSKE3fCAwAsSN+i
         boEwwaLcCAhSxXMw4PasS35zh1+/2hzVF0tJC11KxIrP5xlAHdD8fu+PHEGBoToVtUFR
         757G5zF9/B9lWvWmfDHxp+OQNGLUl/q/o96UfF609kSZoNsW4mbgz6O6cvi3nK+qFE67
         AfSEVhKgMrTSJOLCuGFYW4RJXykA8kahHq3EeQWfYuFHy1zJQFXLC52/ozxUXHK+Yrss
         t4ORzDla5KhLx4PJ8dLS2PIWOeIcrvCxEL/iIIGIWtN7cPJCWbIn/LuVE7ieP1ogOttP
         QJ6g==
X-Gm-Message-State: AOJu0Yz0BBFFEgNDBdGCIUYiibv6xTgZa81C0P7ngYjpQKglLqmbkXw0
	pQKrxaim4Ud4Mcg6bblian/j7klWh/2KheO8ytTTOMRMXq+vWpdIvFP1gQkvAd5ExbUh3vXTJVT
	PVA==
X-Google-Smtp-Source: AGHT+IFIO4UD2Q8xM+v/fcdA/e1KXIqTtO1/9sFBl4VhJt9M8ln8Nh08MMSytma4Tf1IuwJIQtRi3c99cHA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:798f:0:b0:7a1:4462:412e with SMTP id
 41be03b00d2f7-7b749235e63mr8632a12.9.1722631807730; Fri, 02 Aug 2024 13:50:07
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:49:58 -0700
In-Reply-To: <20240802205003.353672-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802205003.353672-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802205003.353672-2-seanjc@google.com>
Subject: [PATCH 1/6] KVM: Open code kvm_set_memory_region() into its sole
 caller (ioctl() API)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Open code kvm_set_memory_region() into its sole caller in preparation for
adding a dedicated API for setting internal memslots.

Oppurtunistically use the fancy new guard(mutex) to avoid a local 'r'
variable.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  2 --
 virt/kvm/kvm_main.c      | 15 ++-------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 689e8be873a7..b341d00aae37 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1179,8 +1179,6 @@ enum kvm_mr_change {
 	KVM_MR_FLAGS_ONLY,
 };
 
-int kvm_set_memory_region(struct kvm *kvm,
-			  const struct kvm_userspace_memory_region2 *mem);
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region2 *mem);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..0557d663b69b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2105,25 +2105,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
 
-int kvm_set_memory_region(struct kvm *kvm,
-			  const struct kvm_userspace_memory_region2 *mem)
-{
-	int r;
-
-	mutex_lock(&kvm->slots_lock);
-	r = __kvm_set_memory_region(kvm, mem);
-	mutex_unlock(&kvm->slots_lock);
-	return r;
-}
-EXPORT_SYMBOL_GPL(kvm_set_memory_region);
-
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 					  struct kvm_userspace_memory_region2 *mem)
 {
 	if ((u16)mem->slot >= KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 
-	return kvm_set_memory_region(kvm, mem);
+	guard(mutex)(&kvm->slots_lock);
+	return  __kvm_set_memory_region(kvm, mem);
 }
 
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-- 
2.46.0.rc2.264.g509ed76dc8-goog


