Return-Path: <kvm+bounces-19159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8FF6901B4D
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 08:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDE821C21752
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 06:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A5A22EE5;
	Mon, 10 Jun 2024 06:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zBpxHVlR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0176C1A716
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 06:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001195; cv=none; b=Ww09fVkMcloKshbTrTQvnZiOMrhyxt93Gfaco2PhPOQGuRzSU5wtHqJ4zT6fhnG0L0z0dGrI4zi9z/+TGimMo9EvhYlTYr0HXlcEwdLRWs+dBKEWgRfHD+6Z/nvkXKsj0/A+rlVCXb8FWJf73wOwm+J8Z8EpTNfDg1WxHqUizsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001195; c=relaxed/simple;
	bh=EI4/EM811Evgaxt17ukV0tKGIs7v8E3XxqrfQ4eYqoY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tx8cQSG1iA5pGpOCnph4Lrj/zri9Aw/CoSrh7DeG0XGEEZ0zoQTzbIKWGUiaYJ8zTDxR9+m5r6RUV9dQkx2l6kGbuBAtVvZx4KnEzzFBBK6Oi+2Sr+O0silgIE7KVlWf87JBtv2DL7V7J1he64MdtFu0uOLhQ9Fcq+xsYfCfE7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zBpxHVlR; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a080977a5so75954987b3.0
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2024 23:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001193; x=1718605993; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=erSEe/z/lyxgtHPTmqJJzIqKibPHcDLT3stY+lpOvXc=;
        b=zBpxHVlRTpSgVrH8z0mGR2DGmrPt7uC4z6v8NkwGL+B61CpnPlxDcLFvnu42q+JfFI
         r3EbHZRTgFM0HIuwLubyz7Lq53OBUs1SyB85Qb0AVEFmy7nddAKtlzbW0QRfRn1cqfoZ
         C2qn5zgrj6nLVLr6r+J7hfNQ+oDp4hgeUQQz6a4VRerHNs82R/iH6HjRDOK9Li+kUYOe
         s2bOtwaAseSGu70qSFNnsMntot4kJZm2MiZLwEGjGqJ8f1egkYvPyDP3JPc4Wo5zkKKD
         PfL54Qj9yGkl6nfnYPKoj+8cidlwl0/BJgmP5Gu2s0PKmjHO+F7zJEgYmUu3QUaPy4XZ
         E04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001193; x=1718605993;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=erSEe/z/lyxgtHPTmqJJzIqKibPHcDLT3stY+lpOvXc=;
        b=mT8SpaZ/oeGSxR4KusGbSjiIq35wj2jnmvzzXDFh9HgqEW9+LmktBVt4oPwWGUdGi7
         fJxngJTr+OFk3R/sVV1y2DHtz24/xuBigvtuy4q2fK7mk4qy/7CjUMjlPWMVC6aEPT8g
         DnC8aQVAs/fDVrn49iHSmc1lP08093egQlTERevE2ETx8UVpfGhabmusj5Z/xzadWVMD
         sQTowAtSLch4cqlE65C5csjBjD5Sfi78e9JBhXvH4ZYCQhXyA+G8iukBgkMwi+7/CjHV
         SeSFcrsqgz1D+hKQkjgBXT6zmRocYWhBrU3raEghXR2g6jKA9HhykgHqBdtabZwZfHdG
         BU5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX89VyNt9lTEm/j5Llea44GG1vHtdnObuvRBhcf8tcGj/v8j8elOpBaWhlogH/oSnp20f00Rh++qGw3Dcn7mQNfNwNe
X-Gm-Message-State: AOJu0Yx200MOPWsqTik8IWP2G9kZyLTDgaVTJSa2Z0rZiYxgYo+3CjZ/
	sQJtfLQKnpcbAfXcATVABwfEmghraBPW6D+5vM6emPrVRIVIP5guL6okNJvVxz3WPF5BYvcVrQ=
	=
X-Google-Smtp-Source: AGHT+IHneFcZIljJu58TGDzZRXW2Dq5HHh3VsxwTxsRfeFhyr4nvcrpdZeErzPsMk+6Ni5nqm5R0Pmo18g==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:690c:640d:b0:62c:f7e2:fc4e with SMTP id
 00721157ae682-62cf7e3002dmr13313527b3.2.1718001193144; Sun, 09 Jun 2024
 23:33:13 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:34 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-6-ptosi@google.com>
Subject: [PATCH v5 5/8] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Given that the sole purpose of __hyp_call_panic() is to call panic(), a
__noreturn function, give it the __noreturn attribute, removing the need
for its caller to use unreachable().

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switc=
h.c
index d7af5f46f22a..0550b9f6317f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -384,7 +384,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -409,7 +409,6 @@ void __noreturn hyp_panic(void)
 	u64 par =3D read_sysreg_par();
=20
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
=20
 asmlinkage void kvm_unexpected_el2_exception(void)
--=20
2.45.2.505.gda0bf45e8d-goog


