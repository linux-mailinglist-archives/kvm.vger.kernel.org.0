Return-Path: <kvm+bounces-60475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAD0BBEF4C3
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:32:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FB6218965F4
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 04:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E922D63E5;
	Mon, 20 Oct 2025 04:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NSs58go0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8784A2D5932
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760934559; cv=none; b=uKcC7ZQj4rnt8ASOnuEtljeXIwshjFt4XJ95y4mKLtYzBlH1CoKsZC5mQlnMmKeKyobkaVHtPa5lq+kR+tmyx8Bsz+DkXcWvfFFyiVmaOrEqylNF6RqrExd5aT1E0qAc04DiZUB/hKYMx1pBoFEiI4rBhFOxbFDB6uozUuj2pVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760934559; c=relaxed/simple;
	bh=c191XMGekjwyT0k1fIaZ95ZvPfNZBLAH+N5NWD52kwE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R3LlrsXZiVUy+9x9yqoGQOLpVYKK+YhfLFfSutkMF/TWX5C6rFseN2TcLBuJlROol5zt7G6Nt9wrvPZU7vEjw1Ux0NNdWuqXVtY+7YBaNBpAIZdajsvrBXNt3oUYLM9jEY0Ol8BtnZoQAsn9i3HOBwXH3ZM1tdqXPoxe72Wxdm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NSs58go0; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-290deb0e643so25032375ad.2
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760934557; x=1761539357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K/wZtJxRjsPgsFT1TZQP06vJqUDEl57iCFv88CuZkP4=;
        b=NSs58go0HdBRQ83pu6c38OEJRSDMhRpsd+KZ2YVjUlboshhfT/vxGd/2WLOMHiKz0v
         0AogOMMMB4f0CDGLoVD4P9emzk6WlUT9U1UtCMKz8FAEVcPifE4x5uPWzdE4WqaPYa5G
         CleVhyKg/Cna92SjsvQezDjAyGaLRsjr5nxdzmc1nT6nYom6JJZvNRtnBu+nfRtcVGHX
         Y52Rmcaqt0eEE9bfrivHoDfP2C4US5v0vUq3THvEBYWZiOaVBGLVdP+vLIXjtHa2lj1K
         6U75MmoNuW5JzafRxxBVACIFaAlWuUMIZSJkdilwdiUFGWQpD3XPYc9EFjQwUy6M8EAE
         kyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760934557; x=1761539357;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K/wZtJxRjsPgsFT1TZQP06vJqUDEl57iCFv88CuZkP4=;
        b=jtV2ZCHRTZKB0t+4dCDOihFqXaq9I8MPVXnTcQr9LuQRo8ck/Ry69NJF5fN56a+Y/+
         10O3YHXl0B/2+yDMz10D8fgxzNYLS5hGlcI+QLE0KkjmxouLyHE5QmZB0JOfR2TYWzkp
         neZoX8qQHrcnr4hksrbYzyRRWNM1+w75UdwtZ9A0D3f5Vq9ZkbEhlHBZU0nowODD0asC
         Az7BPtKPacNyH8JCrlip6ieMqYWUDMCcJdPfw06wHd0jHNzBz6GeUgV4qmBzGRvbauJH
         l6q0Z7KywIzaZYpuKJ9qKMA26235o7b/f59b5nf2yZOXXsMUcYPdPS9mTSiAOI+Bytjk
         McNQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0JraOnVD4aRRe1ihixOFD/gD3D5xLqykWOr1drsleLxoLO16qYuhSYKXA6LGCbx0Cr3A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZWzRCyk3lMZQgdQkD65e0wQSjRQqWz3n896gS7As8N8fEYr7f
	Q0wscU2f0Ik8mhQfMZWFx01kJ5JpDTpaD34/D/NLVyOTckwWEpd02ak9PUPlkPiwHPg=
X-Gm-Gg: ASbGnctYsnDhlaNzT8mGsM/oFbIR6O86SZKjOJ532vPB1gM25iZp3VRRxt0ucavpYtz
	Kt6ZdMNRCx7xU4b5G9+qxb1HBq44MFzl5J+r98hKSAJNOHkWdHzg/mVmCwthDgJ5JHAtcCLeFPz
	ydy3TMu8egh/xPA7gHcUEUGjkyQJE2BEghfh1FP+cQHqNGkssy4FN+rrG5oNwWmNxFYgCWEuRc5
	e9dz/8629otJqLkZ47GIHy71/w6jf3lbpwskTwbMjrEaK+sF14vPRE2mZRuDu5C1UK1rLAK56ma
	zB0kVlUJ19EZlZ17LV+NkW5IHR1B7qLGHYCY+MV9cxkdU3DNZaT3ax+8azoB7cgxvIgQgYa/6I6
	Qoxb5dQf9JoaHc/Rv3OEV583MnYhgqKXIqJyASvoN6FgOVgY15gWb1ug1E8jZzUUNL0xJ+2TgFp
	3WJWYWzSiUErQ/zPeRWHsf5I50hA8JtiQrsuY1VFCT8fCVVEF06bDFVaE1UTuT1Is=
X-Google-Smtp-Source: AGHT+IFpyzb2lc+FEvYmYTlRzjGRaKAbU2/1KopbwUla+EaFbZIWmZ4VSEnrtlloLabkn4dzpBObsg==
X-Received: by 2002:a17:902:e5cf:b0:290:9576:d6ef with SMTP id d9443c01a7336-290cba423b1mr160239305ad.54.1760934556712;
        Sun, 19 Oct 2025 21:29:16 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b35dadsm6932872a12.26.2025.10.19.21.29.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 21:29:16 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	guoren@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	lukas.bulwahn@gmail.com,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v4 10/10] RISC-V: KVM: selftests: Add Zalasr extensions to get-reg-list test
Date: Mon, 20 Oct 2025 12:29:04 +0800
Message-ID: <20251020042904.32096-1-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM RISC-V allows Zalasr extensions for Guest/VM so add these
extensions to get-reg-list test.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index a0b7dabb50406..3020e37f621ba 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -65,6 +65,7 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZAAMO:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZABHA:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZACAS:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZALASR:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZALRSC:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZAWRS:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_ZBA:
@@ -517,6 +518,7 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(ZAAMO),
 		KVM_ISA_EXT_ARR(ZABHA),
 		KVM_ISA_EXT_ARR(ZACAS),
+		KVM_ISA_EXT_ARR(ZALASR),
 		KVM_ISA_EXT_ARR(ZALRSC),
 		KVM_ISA_EXT_ARR(ZAWRS),
 		KVM_ISA_EXT_ARR(ZBA),
@@ -1112,6 +1114,7 @@ KVM_ISA_EXT_SIMPLE_CONFIG(svvptc, SVVPTC);
 KVM_ISA_EXT_SIMPLE_CONFIG(zaamo, ZAAMO);
 KVM_ISA_EXT_SIMPLE_CONFIG(zabha, ZABHA);
 KVM_ISA_EXT_SIMPLE_CONFIG(zacas, ZACAS);
+KVM_ISA_EXT_SIMPLE_CONFIG(zalasr, ZALASR);
 KVM_ISA_EXT_SIMPLE_CONFIG(zalrsc, ZALRSC);
 KVM_ISA_EXT_SIMPLE_CONFIG(zawrs, ZAWRS);
 KVM_ISA_EXT_SIMPLE_CONFIG(zba, ZBA);
@@ -1187,6 +1190,7 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_zabha,
 	&config_zacas,
 	&config_zalrsc,
+	&config_zalasr,
 	&config_zawrs,
 	&config_zba,
 	&config_zbb,
-- 
2.20.1


