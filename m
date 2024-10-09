Return-Path: <kvm+bounces-28264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8565C9970BD
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:12:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4316B24440
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF039202F6F;
	Wed,  9 Oct 2024 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1jQMqcI4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88412201253
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489008; cv=none; b=rbFaKgQYpj7aSdpeLjhc+PYHmJxcAATCWI7wH7tqtuuUp7ZcLN8Mdg09T6X7eFuUeaFEjccLG0IYkmiUw7G0vP3LqQ3n57xfwpwQjaQFC/NI8Qn/D2cHf2tXlfxJG5vOgrrRnz+tVlyO3zfQubk/PiqxiG4PiiiqsqQL39pSc2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489008; c=relaxed/simple;
	bh=wpp1BhgAAr1F0pJrXcm4U6/ifagqLD98EYbry7T//bg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o1A+CxoZ7SbbPjZtxzvtb591GcwlwYvB3w9kXKtoGSHkXK5/XTiI87v2DkDfMVuwCLmQ6hCbM/G9cUZ3Cn0z5SrfwW36RBazET7vLQT1EQC0UVkZfMTB5MLiUphOstI+E2NbXLfQeAYvDalKiUr7b+qhIosVlJ8dMqVHDHctLIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1jQMqcI4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e0082c1dd0so146324377b3.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489005; x=1729093805; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dEQn+W1SexZcTNgUxAN0PCwUsSeaftCY9kaEGEXOiDc=;
        b=1jQMqcI4ubJqBBaBjtssAPl+91NX0ubjwFKhAxkC2iYTvoOgNiTTAZ79cE8kWudMDz
         CLOhv3Lp2kuDlvHCIqyQ66mqCSCCqReDoJm5wGrSaCmhbXoIoTbjiF9yndR7xIKEqd95
         SvkfXWvjN0oeh1UbHH1xY0eiXy1v4c7/FFdSZJhHteOsAgFeRyynjgoOL/4HwedvSNkl
         ebjonR3SgVBCz4CRY6FcuMNo/lwg02P8N1WTXR/cfw+qvkKfw2zU5bF8IoC8WQTv+pUN
         w3Yb0fsKno2oL/PAo+Zi8nKcWH97sog569/hxnZgp8VNUICJjEhysP6vEMF2aeY1MEpw
         LLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489005; x=1729093805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dEQn+W1SexZcTNgUxAN0PCwUsSeaftCY9kaEGEXOiDc=;
        b=OYi/MtCDZD4JA+yeR9hgpNUf4Dow4m43bUR9rwMQNpfWjFjgzHfd2DpaVrYZ2AfG/2
         9jtQsr8ESq6x5XtukF5Rvml0hgnA21dksLYgFx0Yr6GZRcxVe/MzMyPGFeds1sxU1UV4
         Tsn0EJkN9wSqS0H02HMPVFnYxL4PaiyRk4psWFo8QQVQzrziQRjNfUa9OimIySxMNj22
         +R+IJ+8vHA1UpEwDBweDcAQ2tyulbIBUOakc0M0xNhup7G2oy9gylwHzHi5eAO2lvrpf
         b4hrPJBdPcld3zGsDJaJ0M4UtmCWS6ihSz/jyb//LBY+rgT7vVWuxLw9tTGgPV7Hrafp
         Ckmg==
X-Forwarded-Encrypted: i=1; AJvYcCVh18Nxowwab1pZKC9Mi3E09ol+gaylXEb8gqHwYBCPgV6xje/PPnlDutb2RIhuC+IEmjw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCZRQM1/MmmFxe1Q3fe4dXGuILimVYqKozeI8NUEjJ/8s1yH1U
	f1ETdgTDCLMO4xsn86x7A/1DR3spx77OAzcSoWvREuI99wGMDS9ih0kdRIjtMnl0xp4/slo/iYh
	R3Q==
X-Google-Smtp-Source: AGHT+IFrWalNmEyn72/5CXUVKhi80GHo8XaYDR+iQ/XjxOT9S8VfevqUwXplC0nvvzPPLclQ9b5vmaVf6gI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a0d:cd84:0:b0:6e3:b08:92cb with SMTP id
 00721157ae682-6e321d4062cmr303877b3.0.1728489005619; Wed, 09 Oct 2024
 08:50:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:44 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-6-seanjc@google.com>
Subject: [PATCH v3 05/14] KVM: selftests: Check for a potential unhandled
 exception iff KVM_RUN succeeded
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't check for an unhandled exception if KVM_RUN failed, e.g. if it
returned errno=EFAULT, as reporting unhandled exceptions is done via a
ucall, i.e. requires KVM_RUN to exit cleanly.  Theoretically, checking
for a ucall on a failed KVM_RUN could get a false positive, e.g. if there
were stale data in vcpu->run from a previous exit.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a2b7df5f1d39..6b3161a0990f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1646,7 +1646,8 @@ int _vcpu_run(struct kvm_vcpu *vcpu)
 		rc = __vcpu_run(vcpu);
 	} while (rc == -1 && errno == EINTR);
 
-	assert_on_unhandled_exception(vcpu);
+	if (!rc)
+		assert_on_unhandled_exception(vcpu);
 
 	return rc;
 }
-- 
2.47.0.rc0.187.ge670bccf7e-goog


