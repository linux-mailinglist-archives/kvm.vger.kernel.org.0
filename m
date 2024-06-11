Return-Path: <kvm+bounces-19366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A008A9046BC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 00:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 463F11F25EE7
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 22:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9748915444B;
	Tue, 11 Jun 2024 22:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wHIQK/kg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69468155350
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143528; cv=none; b=VVqd5eyGdr/qA+bmzYsTzHwSVl8POZy1UK35E9zuyh6ngj2FxHFAXb7UM5UP6mcbGVkt4Y8V7zgpBj+KYjS161d9KKwPja7TPPBc/lYqukLt9MBQbE6tVvEydvqJLAJJ68dXHC9zic0LKzMu9r89sXcS0EsP1VcOA+SsG0zOSUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143528; c=relaxed/simple;
	bh=gFu+Sw6FfHFhBGeL0KWbFRGu8jwMbi8iDkm+qP8tqvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P5sfgk7ab3dxPvDyhpf+acMpWJqZogJSBem4QyiEMU143QdQSUZBSSM4ivqT4n5IjZTfEi5HteQh/MMphYfHb0QXoASfn98HPjtUo4+I/k24ceOSLA75baM7Ubu/xecqfjguXhgYgAoZrMG0z4wmHvV045jV8cX6z2rwI1X41Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wHIQK/kg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfa84f6a603so10276434276.3
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718143526; x=1718748326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y0tWpVro+PTLkdjwwJJw7gcPsAniIuq8D/3VEiAryJ0=;
        b=wHIQK/kgPlsyRRR/7P8YlB6Ze8xbmHB2YSWs9Vo/a3maivGci0fyga7Mi81rz8B/ib
         tyGPGBz5O02JwDh7pPkmDHXcnccfQp7ptqZE16hpvFM9aAcRnHQHCBDd4uSyfmBPsjD+
         xGE5vMVNDJPpreZdVRqIe/my0utL1oNlGKhZ5/77wJ9L7PKqQE3xsZgRjeXVf8Wue0G2
         37MnQ8/iFQNlyeE8FOevRxsxW/EQlciLNO0f1zVDA6wiB3bLPRp27isCCRjX6zy9Km4q
         0BnneHB4f3pXYcG1jS4CE1+MgroZ30tUEqJpIyrq2wm8Jz6C0V9Rv6Z5nwluBqJbVk3+
         /tDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718143526; x=1718748326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y0tWpVro+PTLkdjwwJJw7gcPsAniIuq8D/3VEiAryJ0=;
        b=vRFRPcFvMysi7EFrKTZQnaAB5PR/h81MNZWYpBUUHk4GqVNaMQ1xgGOwduEVq4S5KL
         WE94AU8b8ynXey975hNewCcf1nII3eUwnaSRArmikFC7ReAhOiXiMa35iuoKFn5fqpu2
         e0BIN7UxmAoVAUndAl9ltjMCpGdEOfQmNUY0jMU3kCfijVVTxQCNegkMlon3b2ESk9+8
         t4Imr4MFfzu0gj8pwWrdrXPAjXC6tjlecTlYxEhK/Um3LNGoS3BqHpWs0DiJPiYlb31V
         VrK6d56OBGyHT2dREUs0cHxhfitent74y6JB7IE4hDfjnITKqXGu2/eFH6am0VRX3rA6
         J5xQ==
X-Gm-Message-State: AOJu0Yy7FxTf/qwS+ESZT9aNlKPVtWk0jsu6jYCIuT40qXLXrABf9UER
	B0bMYnukiKlR7awWre2LjAWbWZ1cD36d28laF/KK98Vp4TK5TyoH24FXIq/poeYEJz5fPZOmYtU
	J3tCWRnDNUQ==
X-Google-Smtp-Source: AGHT+IFf99FyBHSmkELQndmLkR1qklKV6sa+0sTgV1cL8/trlo9d4ArkqHnv66FB/zN34RJqqxrF0EDgBsUzqw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:709:b0:dfa:ff27:db1 with SMTP id
 3f1490d57ef6-dfe66559ef6mr332276.4.1718143526381; Tue, 11 Jun 2024 15:05:26
 -0700 (PDT)
Date: Tue, 11 Jun 2024 15:05:12 -0700
In-Reply-To: <20240611220512.2426439-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611220512.2426439-1-dmatlack@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611220512.2426439-5-dmatlack@google.com>
Subject: [PATCH v4 4/4] KVM: x86/mmu: Avoid reacquiring RCU if TDP MMU fails
 to allocate an SP
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Bibo Mao <maobibo@loongson.cn>
Content-Type: text/plain; charset="UTF-8"

Avoid needlessly reacquiring the RCU read lock if the TDP MMU fails to
allocate a shadow page during eager page splitting. Opportunistically
drop the local variable ret as well now that it's no longer necessary.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7e89a0dc7df7..142a36d91e05 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1402,7 +1402,6 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct tdp_iter iter;
-	int ret = 0;
 
 	rcu_read_lock();
 
@@ -1440,16 +1439,15 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			else
 				write_lock(&kvm->mmu_lock);
 
-			rcu_read_lock();
-
 			if (!sp) {
-				ret = -ENOMEM;
 				trace_kvm_mmu_split_huge_page(iter.gfn,
 							      iter.old_spte,
-							      iter.level, ret);
-				break;
+							      iter.level, -ENOMEM);
+				return -ENOMEM;
 			}
 
+			rcu_read_lock();
+
 			iter.yielded = true;
 			continue;
 		}
@@ -1472,7 +1470,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	if (sp)
 		tdp_mmu_free_sp(sp);
 
-	return ret;
+	return 0;
 }
 
 
-- 
2.45.2.505.gda0bf45e8d-goog


