Return-Path: <kvm+bounces-18956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35DC78FD994
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 00:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4726283807
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 22:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C8E15FA96;
	Wed,  5 Jun 2024 22:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="jbDQNcSI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928673B1AB
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 22:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625126; cv=none; b=Iu0KTnoesDD3BGlrkEBB8CKG10B/pM8DV3oMGsZShO8Np0FaX9ehvyHOZq/18WH5WY7k7RcL4QQdcFyVObFWXQmR5x5ITjPUmy2g4NlzPJ6J0WhvgSrQeQ2BhjmfI25cBKXoSyAAJbJdasVf/wpJYkTP8ztI+GSW2mNeDh3Xs2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625126; c=relaxed/simple;
	bh=QJjnj0ss24plSTNwTQeT5jX+/7TkIkcPqBKh3DM9100=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J/0/rRLWbtts9UvTS/U8v9IJrC9WovN45VKrhr6tyOBBROiblPtTtTdrP7Ue8ifsAmxstCH6js8fxp39FyJx/5QgHEROXCNeoYX5TdTpwBpQpjmJ7uKJM7iun6uDm2/I8tUz53H2QuiTsuSjWeVgVhggJhFwhBSWuSQtTkp/4OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=jbDQNcSI; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a63359aaacaso41605966b.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 15:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1717625123; x=1718229923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4/tUZqMJ9fVTqi7O5TJG840u6xF9S+kTH++Xf66rKI=;
        b=jbDQNcSIx6C7T44c6Z3ISZOe+4WgasE4/KUrL2Qagfu0OoFxrqFMV2zSfkMv/nC7wA
         2CepTzJ9GdQeMw0WwgJjtyztxSBe5FxozzsYHq4HZPL106QYBj9glne1bQ7g+C/mP5p1
         /LmGqvPQRYnT6ymQPYLrtEJQsgild0QwkluPPrEUVHQz7WJtCthbQsFs1xBdwm1Rvm4A
         ocDTeMSYQ2w0cwit1YQolAylLLKmdNsk7v2Iu1MH9CHI/exHRRZfu6KercnE/ONOVZ9K
         auPAP7dr9Lfwu983Wozz+Xla6tQJRCadO3DDXcbQyDjW8q2OWeQUag+wiUrBwyFBf9Ru
         p1kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717625123; x=1718229923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4/tUZqMJ9fVTqi7O5TJG840u6xF9S+kTH++Xf66rKI=;
        b=kz7SW1U1kVdjmAdeuxMK6XLKMgbXTRX3DP3E+Q8lty/WsTLeox5/MLH3zU6lHwe+RJ
         wt8J38FUPCHoCc8Hw/w8CRDYy29ztKR+X5xzWpOsrSGxRDBJ/b+9xTwaWy2uUNclDtKA
         DX8wvvjH/dEnHb+AWjn+lcxp/aqcJiPB+ZId/6lJ2DJBn4k290RVWLhI+rk28/AB3cgi
         bBll9aK8HlIW+fTDjAMt7ppGJTxFWTAKrpAUAssRGY2/3c//ZLf/H9V+7VK2DLH3kiDj
         uq3zSPWWrTtBp/77bK7EkpNYoezc2rRDQgKqKdj3AjFlN06m8+1fftPPuEvN0E6+KMfZ
         wV2w==
X-Gm-Message-State: AOJu0YwLi0vEoGf9/o7JeKFDHh5fQMOxWWyHjj1+p7wEuNb2gEIh52fA
	4VP5qNxwsVoftWN4SDm8O1mRYPqoHj7rBkA7D8OwKt6dJK2e7Moapm5K3JjDAWE=
X-Google-Smtp-Source: AGHT+IFYtL9999L+qVZxkiU7xp60uw3FS6PYPNhCQJ3zIbReDM6+/5bPb4JGdNO9mTbWIMldgcyjiw==
X-Received: by 2002:a17:906:c198:b0:a63:582b:8ac1 with SMTP id a640c23a62f3a-a699face692mr255463366b.20.1717625122583;
        Wed, 05 Jun 2024 15:05:22 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af09bc00454dac98c3a8ddbc.dip0.t-ipconnect.de. [2003:f6:af09:bc00:454d:ac98:c3a8:ddbc])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68f56506dcsm574559866b.57.2024.06.05.15.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 15:05:22 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>,
	Emese Revfy <re.emese@gmail.com>,
	PaX Team <pageexec@freemail.hu>
Subject: [PATCH 1/2] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
Date: Thu,  6 Jun 2024 00:05:03 +0200
Message-Id: <20240605220504.2941958-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240605220504.2941958-1-minipli@grsecurity.net>
References: <20240605220504.2941958-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If, on a 64 bit system, a vCPU ID is provided that has the upper 32 bits
set to a non-zero value, it may get accepted if the truncated to 32 bits
integer value is below KVM_MAX_VCPU_IDS and 'max_vcpus'. This feels very
wrong and triggered the reporting logic of PaX's SIZE_OVERFLOW plugin.

Instead of silently truncating and accepting such values, pass the full
value to kvm_vm_ioctl_create_vcpu() and make the existing limit checks
return an error.

Even if this is a userland ABI breaking change, no sane userland could
have ever relied on that behaviour.

Reported-by: PaX's SIZE_OVERFLOW plugin running on grsecurity's syzkaller
Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Cc: Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..9f18fc42f018 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4200,7 +4200,7 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
-- 
2.30.2


