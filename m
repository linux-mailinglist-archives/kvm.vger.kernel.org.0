Return-Path: <kvm+bounces-42940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6049BA80C21
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 179E11BC45F4
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C9918A6B0;
	Tue,  8 Apr 2025 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MeoG+aFv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4826679F2
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 13:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118469; cv=none; b=jE3RABZF3s4Lv5KZ9dg1nyueZ4bHd+utO43zrNp0q12MO7sEnO+inbDEy8v4O0palrSt/Epg896RAP7JYcFaRwos57RJtgTOioC/ikOOM66+GgJ4f75N2vG5zRg339R9AzNOMRJR1kRPGTW+PAXFNW35hh8mIuSgCB+AmGTqTwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118469; c=relaxed/simple;
	bh=FAOMWgEt4ctVlbmvUA0C1egHbjcgOjxR0NjUHUtQWeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFNlCguH47Ij/7ATZtf9r1N83Y2+acS7NSJmxZlLx8PsH3RL3wLNNrtFgejwWANyw/s/NjLXGkqkVGKT70N3HFtHEhZks12RVQN8X8SkNYRKsi2qq6WO+8MeQpeq/1WL0J3au/AD6LtOIZ4cu5Bke9AcabWlDHz2TGU+UpnrWEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MeoG+aFv; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cfe63c592so52870675e9.2
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 06:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744118465; x=1744723265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwsED9xLZcHWSWQwNeYdiP1D76YEuoP7ff0R7pjjcro=;
        b=MeoG+aFv2VfbKvvE2xplXBOGS4C/QIuMiomCRrGGcsdL5hbRnuyhqbh8KeyRvVfGJN
         CFi9QRZDJmgRXwqrJDtKYGt8Rv19xhYEKBsdjZj3wq9mer9gJtJQ8uOffn2VX9KkJA7H
         PcL4IDzvS5qHId86+QhcgisZvSDaGsTieuDc7nhwFVwCRZ36eS+NfCydImYrvrlbXUSA
         nPAp+QmEckt7H9H0JMzNgfY/qNJJDca9jeG8+aRRR3c+4peB/c8yDFJfbyh7E7Y9HCUY
         WOQ94mlvqJ3QeHTVYGPjIMfdoXsI4rdAonMEppOZR2uJD+3Yid3/9gFAtlBPjytRBjTP
         II0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118465; x=1744723265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hwsED9xLZcHWSWQwNeYdiP1D76YEuoP7ff0R7pjjcro=;
        b=fta5UaDNtnx3tcgQmGAQWjcwu5cHxcyBp2vdwFeMrFOJE7lysvs+c73UIHk9cgcQTz
         RFA+0a68A6iaPl3s9+vKd/sh3fOduX0XXUsoTS/jdXJ5jM0QvMhtacK2WaGti73O2pdG
         nedbmCgwiocvYOvn0XdBzZvmBciwSB3rwEp0Wc1ckgzQRnVHEcnaQLbzMOL23BOtP0Td
         steRqTqUjeu2PemElNkY+SHcUfmGpKCxB1rK+PhX3km+4i7bxZuoRfKP4ORVNvetFWAC
         c4nnnA/AyD7ATBd1nfG12d9/o6jOragnQMExTe3/tlHwu14uU8NUv33k0UzCuYd7pX2Q
         Q+fw==
X-Forwarded-Encrypted: i=1; AJvYcCXOgSBOdd0Vq+cl+1jHYD61k7/kBTHfFvuPvE4TcvJm1oUkTYQ30pohMhA9vyYKFGrhPng=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsUbjRCMzpU5/pN/rqASdCx9LgkkYQvp7LA1wAZxmGSsSjlej5
	Ed1D2amU06lNC60Frm/DgajvIjp/ljnFwCfyIca7dkKRZT5jSAxc58TCNrm4PSc=
X-Gm-Gg: ASbGncvvPGGU/M9evxq32dsxuVH5EV8VJNMHCyM6ynt3MK84eocPKKkfhBySApkSomQ
	BTdV3Q/T2e3/z3MTXr1dfpbbKjteATrQArsFt12mlk/J3As9BAgir18aXVh0c74Q4IBdWwL3B2r
	R9F/7RJuKN/0eTOPjFJ+yewSsu5N9luC/eXZz3/tI3hczhEbVB9hBY1M46NvOF2WPCy2vP/uT2n
	CSBaeQV04AhwEeYavon8oTGwOUGwzYGalFgmxvVMbB9NqKoehDOhxPp4bcZ4tSevBJrh8VGOLy6
	Udq/cHAgovqsgxvCk3BNI4wQ7tDjNt8qu6Ox1SLqrZsJX6aI1E1C3f8q5DCyS/w=
X-Google-Smtp-Source: AGHT+IHZICYsUrjLH4YNZEOnxXpyTAQfzZP4OUy8xi2eNeiSzDjWYngsdEatS4fdZh+4tPkiN92iUw==
X-Received: by 2002:a05:600c:3d98:b0:43c:f81d:f with SMTP id 5b1f17b1804b1-43ed0bf62eemr158443455e9.8.1744118465399;
        Tue, 08 Apr 2025 06:21:05 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec36699e0sm162159705e9.35.2025.04.08.06.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 06:21:05 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v4 5/5] arm64: Use -cpu max as the default for TCG
Date: Tue,  8 Apr 2025 14:20:54 +0100
Message-ID: <20250408132053.2397018-7-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408132053.2397018-2-jean-philippe@linaro.org>
References: <20250408132053.2397018-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to test all the latest features, default to "max" as the QEMU
CPU type on arm64. Leave the default 32-bit CPU as cortex-a15, because
that allows running the 32-bit tests with both qemu-system-arm, and with
qemu-system-aarch64 whose default "max" CPU doesn't boot in 32-bit mode.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 configure | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/configure b/configure
index 63367bbc..20bf5042 100755
--- a/configure
+++ b/configure
@@ -32,10 +32,7 @@ function get_default_qemu_cpu()
     "arm")
         echo "cortex-a15"
         ;;
-    "arm64")
-        echo "cortex-a57"
-        ;;
-    "riscv32" | "riscv64")
+    "arm64" | "riscv32" | "riscv64")
         echo "max"
         ;;
     esac
-- 
2.49.0


