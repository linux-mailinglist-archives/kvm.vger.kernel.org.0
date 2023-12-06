Return-Path: <kvm+bounces-3728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD33807600
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:03:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1AA21C20DEE
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D83D675A4;
	Wed,  6 Dec 2023 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Dw8/G/Io"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004B9D51
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 09:02:48 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-a1db6c63028so93824766b.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 09:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882167; x=1702486967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Kp7BCmNsK0DEM7rucSiubKQj48qbRMInEEicew47CI=;
        b=Dw8/G/IofTNphnKk+kQDTAI81z5qfOSz8Vy3Z0e21U28sLE2rkyAPxBEGsPR15+AQs
         1OSiBwbXu8yV5AGm3/8DXmC5+jnQWh6Sp29vQJ9VcsWZql5qYet+REpQqmmDF5L5bkuI
         PFDvYeZqw+7xAIK/wp23jKIQpnxnpMhLCujwNOSxXwFO9QchSkMQLazsSc1tB4BHBPP3
         xa5dw1tFlCaggVD4hs4gq5zOz7GPAgmIQ0NwkkIkQeNKDmkppG41Z9y+ZPEW8xZPf/kl
         oItcz3g/KKyuCQz4pGuWSOsd3l/G/W8HV8MrW8/K0XWDvlcYPtOwBMjclzVto3P398o+
         U8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882167; x=1702486967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Kp7BCmNsK0DEM7rucSiubKQj48qbRMInEEicew47CI=;
        b=Q7l+E23+1Mc7tpEm//L6vWaVI1scDUBkBtqRrH4vJYSwsL++Xx5lC0ZQ/CwmyiUhcJ
         kMKCze7f9fb5wVC7vQdeEU1rZtmBcjc3jhYXb0tKpD2fUNSUv4yiSgnfLOV1Vpd2NJkY
         CLDFfXdn4IJ2fFzxBtSrDawnoh1r1PMLiIQmqMJArEHFYXWVyd9guqBwrdT991TQlC06
         aRaR/E/2g1oeXG8h2FQk+oPGmkcuLUOBOy4I5amqZp6+K/ETe1HfJ798MfGcmEaXjhT2
         E/1J95/0Vlz6nkdqEZ3xQOsuVEb52UtESzg6QfHWMd2VA8OxcPgXa1RTf8l8vgnM0ZlQ
         3SKA==
X-Gm-Message-State: AOJu0Yw5Kj1E0AxDRdOqbuRQN0WrJ5OcA6kwc3vlMvZIut89+GbYHslp
	ugmlsYijaATmwacjrGZObfAh7QKYJkci1ZleMjc=
X-Google-Smtp-Source: AGHT+IEKDxB7NgfA4KWg/wc6ee4tQZUdtc3hfUtVNGbPYazUN/5PYDyXVHg1rFMHNPTn6y1yyB9LLA==
X-Received: by 2002:a17:906:3f58:b0:a19:a19a:ea9e with SMTP id f24-20020a1709063f5800b00a19a19aea9emr879624ejj.87.1701882167228;
        Wed, 06 Dec 2023 09:02:47 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id sa18-20020a1709076d1200b00a1a8d03347csm180212ejc.13.2023.12.06.09.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:02:46 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	anup@brainfault.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Subject: [PATCH 3/5] KVM: selftests: riscv: Remove redundant newlines
Date: Wed,  6 Dec 2023 18:02:45 +0100
Message-ID: <20231206170241.82801-10-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

TEST_* functions append their own newline. Remove newlines from
TEST_* callsites to avoid extra newlines in output.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d146ca71e0c0..b3082da05c76 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -327,7 +327,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	int i;
 
 	TEST_ASSERT(num >= 1 && num <= 8, "Unsupported number of args,\n"
-		    "  num: %u\n", num);
+		    "  num: %u", num);
 
 	va_start(ap, num);
 
diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 6bedaea95395..4355e33c0cec 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -112,7 +112,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
 
 		/* Double check whether the desired extension was enabled */
 		__TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
-			       "%s not available, skipping tests\n", s->name);
+			       "%s not available, skipping tests", s->name);
 	}
 }
 
-- 
2.43.0


