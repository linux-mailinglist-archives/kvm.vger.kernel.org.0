Return-Path: <kvm+bounces-59620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE17DBC3448
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 06:07:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6DAF189A2D5
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 04:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4992BE653;
	Wed,  8 Oct 2025 04:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w81Vt7g8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB07D14A60C
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 04:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759896446; cv=none; b=TEMglB4ncFMvzNujfriZHIZjvyrDxrKScYDMqBA0sj6gw+z7iQd9jTm5RujIII3ACYXBBwg9cpUDZbc8SoPuEI77iV9kkAHcEjtEBFh8SbCVEJygH7H1PpUNHa3TB9M/M8fBBQnbrXTlsr0Q4oiV642mI5wKeDqSuZoXJqapSe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759896446; c=relaxed/simple;
	bh=qBxZwo3D6gTTAm/Ldxa0q18h19IV6+6m3CTIuFxcQhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwczmrayM6+JIdZNI3DbE0W7SCw6wiNcxW8FZVB+txsoumzDzYamvJan/+hIJ7RVMRyDsoh722quOZ3NyvG06XfCH3+L1lUsljUL7DBcMEjL2Vs727F/Z6D7LvWQrj5XIOozpmh4GuGbItzJbhUiFb6LTXniDr8KACokOKp5dJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w81Vt7g8; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e2c3b6d4cso55849685e9.3
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 21:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759896443; x=1760501243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxAtWtmejX8FeMeLelhLJTDbTvi6ib8BE8g2ZB3OGV0=;
        b=w81Vt7g8ssiWpqCTA2PAcFnjzsos/ktIqKTkNJx0z+zRE7VwZGbhKRr9SiCc3MN0+b
         gmIUEAZpTBFbspEd4C1RN120Z+PdLKme5k6wGl/xy/8zymqpkmFS+9mcRNHxGX79zgNZ
         4jupNeSHi6oXp94EVEGuKnnL4nb9XY5nDEp1ALIaGJFxWnuvZyjZGos2Ze7rek+CmzP7
         vwis+hbCpaMa06vW62eMUayuZwpr+fq0K/mZU8M/NgqKikEZPHcX7grHyiLPwN2jfSKM
         Sz175G3n7Kkh0vSiwkyvNASwBZ3YeJ0yHb9K/MTvG/bgPh+InCC90wijIHjw3Pkk2Jpp
         5QiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759896443; x=1760501243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FxAtWtmejX8FeMeLelhLJTDbTvi6ib8BE8g2ZB3OGV0=;
        b=OzzvLmbJA02FjnNuXPqgrDmNdhlDVNI1Sr1bjAR80SwxoAGZqX3L/jDstkPHWYUWvY
         gPsTmpyResWg9LNej217F2XIT/pixnNF734s5qyB/EOJXUjfpsLLuZdVlsUGsu6XZZ6v
         QEYInOlPnVwUUF+fE2tuVZxT0/fWQ2p9LuPSCjRp0lTU32B4WL9DihDOBug1lptsxl6t
         XMFVOkLWBUTEhOgn5G7K2k0AkLVYf/QBYz/mPhccsbnOAvy2kBBrJ6LS+3+1fOmgcFeP
         kidSGfSNvLJ/TFzH81PJyc10CU6AMyuVMrQNxvZ4WILqswUoPcwh1/h9/0qrgm3Cq/Kl
         h5RQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnGHkid7n2cMtudEvJQWHFdbg9Jpq4MLymnpu4rxcD7B6RLR1Qf6HnLyD2swstvEjZz3w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeJJ0+NYfITFmg21N1VjP4EjulVxDPW1n1SC0M5DKMlMmL5KNk
	yyqZjgA/EZOUZifgeHk1mfaxd0SHuluS7GfYV5CjpP8kn3uTaLQdavu5vKhhiG9Rn5Q=
X-Gm-Gg: ASbGncsyG+kz0uvtymGb9H1QrKLd+9wprmgzkrC3M3xcUJ/R5XjlduPyUa5rdphmFo8
	2BPmA9zyOnC0C0B57EPdxo9jwZ2m/VpOqENzosylhXGOGdqiTx0vqEmBaSdE2ZIMOko7LinpR4m
	0N5c1+jcGxZ64AF0kCxAnHitz666ltiXg0g/6sihBk9YzLdydeynf9kH5FslTTXxv6cjBVdLNvI
	D6IOgww6rrnLxeA7MSg1XYHJiSrtQNSnuXsqpr2HlHsAugor594ZzCWaO57nMog1/i+9KLgGgFr
	/SZF0zDts0Dkl7SaVhMxTzcIPCo6aJIP4bTWfZAH2GBT/Y01ablO4A1O6/tT1wiNNvd5GHlUmPo
	NcYqEXRXQla2RZdMnv0BZk1ikqxIxiQxJDbANhtFk5IebBxjRKb+Z+uOi482ykb5SRWca4rrBHl
	fKOewh6OSh3diSpJNUUMiQWlYr
X-Google-Smtp-Source: AGHT+IExiobNOfGSPWTb7L2l3odsWU/Eo27joKAv0sBZvTrPNsL9nZk7Rb2MQW0Mia20pwxgoKA8RQ==
X-Received: by 2002:a05:600c:3b1f:b0:46e:42cb:d93f with SMTP id 5b1f17b1804b1-46fa9a98ef7mr11946895e9.15.1759896442997;
        Tue, 07 Oct 2025 21:07:22 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d7f91esm18486965e9.20.2025.10.07.21.07.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 21:07:22 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	kvm@vger.kernel.org,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Song Gao <gaosong@loongson.cn>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 1/3] accel/kvm: Do not expect more then KVM_PUT_FULL_STATE
Date: Wed,  8 Oct 2025 06:07:12 +0200
Message-ID: <20251008040715.81513-2-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008040715.81513-1-philmd@linaro.org>
References: <20251008040715.81513-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

KVM_PUT_FULL_STATE is the highest level defined so far in
"system/kvm.h"; do not check for more.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
---
 target/loongarch/kvm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index e5ea2dba9da..45292edcb1c 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -397,7 +397,7 @@ static int kvm_loongarch_put_csr(CPUState *cs, int level)
                            &env->CSR_RVACFG);
 
     /* CPUID is constant after poweron, it should be set only once */
-    if (level >= KVM_PUT_FULL_STATE) {
+    if (level == KVM_PUT_FULL_STATE) {
         ret |= kvm_set_one_reg(cs, KVM_IOC_CSRID(LOONGARCH_CSR_CPUID),
                            &env->CSR_CPUID);
     }
@@ -801,7 +801,7 @@ int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
         once = 1;
     }
 
-    if (level >= KVM_PUT_FULL_STATE) {
+    if (level == KVM_PUT_FULL_STATE) {
         /*
          * only KVM_PUT_FULL_STATE is required, kvm kernel will clear
          * guest_addr for KVM_PUT_RESET_STATE
-- 
2.51.0


