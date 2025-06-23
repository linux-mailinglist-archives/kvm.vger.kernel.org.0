Return-Path: <kvm+bounces-50326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B42F3AE4005
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:27:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CD853BD765
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3855248F5A;
	Mon, 23 Jun 2025 12:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="STsvWzdX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6FB1957FF
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681207; cv=none; b=Q9hJA0mNz/qYzt3pek755n/fMGl3BBH+D5x75/RxEdSVhSr4dNZeadbJG/Fgtewn7KWJ216/dSpMNp8DtZRhDGhE4MNtSwpcRZdJ9MUb8UMRYs5+PEat7f77gADtIgv4/4vNIR2ATgthobCeO7z5XsGSalhWizP+3nF9PNmuuW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681207; c=relaxed/simple;
	bh=OQk9QRusfHQEt++YC0RplGJPmlYhjJLC4+HrPr+sP0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qcCMDqvewQKQWZuZJ+Mr/lSjxxqfj5CKbDcERf1fUad/O83yGoKXYHv1scvZIAaQJVpeSQ2MhoXFjgXf3QWNa6tnF1JtaMj9/uJxofChqM8kQgTHzTAJ01hZzsvX3XwzY2+7ax6FdTqeoS0e4c4G3ovNzlljcXpiy0B8NY8oy3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=STsvWzdX; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-450d668c2a1so31401055e9.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681204; x=1751286004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/J3/dM6yL9EpwD8nNu/ZbysHMLeoDjMiAJQk/DeNw0=;
        b=STsvWzdXi0grqnaqa5xneo2SYo6Zz49zftnBVciQUCGrp06LFAS7Ko4aguAMZxsK4X
         sHCC0RcsPyx+KV6fklbMLVbYQiIK1FnX7mz1ibNZv1BUAXPCAaANiZG6CWOWuyt3FYv4
         Y+hD7nQsMFpMU8GjX/sDYiRapoYWMRsIDV6SIHM5v6P5cwvdVBCT8dIzJQ4mpeHU6Ic7
         k6R8uZjSLlkN1EA7e8XU4wwhPfqrh62Opoy5sXGAKkreHES1EQYlsEf09AbxogRr/qil
         LrwA28VxkOgdw0Mj7BsowFG2IlFueB4FamdkLej04B0AjOpYxJmpyH6JoZY9D+nWS9ns
         nTsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681204; x=1751286004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y/J3/dM6yL9EpwD8nNu/ZbysHMLeoDjMiAJQk/DeNw0=;
        b=PEPiDaWtpOobUCALGTtXJ9qddItbeF/q/0ghKlnTzq8+AJf9V0Uf1yXKxAXYiYHE4N
         rxzIpuieBYY+0Cnj9mRZ4c+65jQlw5m0LkhnfMBs81QD/Gf2ldz/h/1YiZ+soBtbtQax
         +Do4roaTJdfVlvqcaZpNm3BwarxhTweXcamgXszJdlp864jJ1kJ1lmI126eeVuH27Ufj
         birox/dSnebYUFdlBe1vkm65o8HpvEim05uKasbQ/5c7bBIFqmx0NNu5Miukteh0rygP
         9JwMJsKf3HJ2y0hD4JoKe8vfA/iG0rBQhQ2E/rqPtjDlcX3HV530d4oyPziMU2gqFLxi
         hpBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVX4Z4kRhavAqqcbLdHITbT//bgQIHIxHTI5PADlHB62M505UMMX88J/LKA3Z9Gnzubxp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDly35E4ntUGvoRALiqa8MFfcheV1R21lynbPq69a9Tnp6Pk5B
	hE4SPIDAyRlY7Jzq5M54GbvajrOeRwtlI3PzSGoP+VlbgzqAhfdXbBeFS1RNgBIAGro=
X-Gm-Gg: ASbGncu78WKd1pSyUnMX1Pmd96Q2kBQb2Z9tSYPUGmio1j1c+dt+9ekVb3yhE55TD9f
	YU5IweBpjht9UQSySqsChKul46+tbaiWnSM47ErXtrtt5U3A7nvtkLkftwXii0wQq53KLBW4Kf9
	LSgtB4mcDruYv15qCfg642MHf6oXAA17Ydoz957MEx3LUguxa3d1xMo3G2e6JWWY3jEoIWkPfw3
	5hryr8cyggOdwooOPGNWZddI7jERvv8wHbnXaWuDGatMfgDOOZ/peCYFLNgk865xZQbmJG7OJNs
	ST61L+eYHSFEFDCJ6/nSSkPNm95rhH64zmcbYNl7kqhzvrKMhx6kPyAsCXLr+E1i/x2peOHGmgS
	0qLeywowwJWw4j4Jug2LXVmWvEPwtxJj771HT
X-Google-Smtp-Source: AGHT+IEDBLzyvotQDHdgeUadRfrLThtjSEX8cwJuz2mnLVjDK+hMLUAuzhTdSt0x3jQyPiQhQl7KNg==
X-Received: by 2002:a05:600c:1d27:b0:453:10c1:cb21 with SMTP id 5b1f17b1804b1-45365e3dffamr107598715e9.8.1750681204506;
        Mon, 23 Jun 2025 05:20:04 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646cb5a8sm111194065e9.7.2025.06.23.05.20.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:04 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 15/26] accel: Introduce AccelOpsClass::cpu_target_realize() hook
Date: Mon, 23 Jun 2025 14:18:34 +0200
Message-ID: <20250623121845.7214-16-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allow accelerators to set vCPU properties before its realization.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/accel-ops.h | 1 +
 accel/accel-common.c       | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 44b37592d02..a863fe59388 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -35,6 +35,7 @@ struct AccelOpsClass {
     void (*ops_init)(AccelClass *ac);
 
     bool (*cpus_are_resettable)(void);
+    bool (*cpu_target_realize)(CPUState *cpu, Error **errp);
     void (*cpu_reset_hold)(CPUState *cpu);
 
     void (*create_vcpu_thread)(CPUState *cpu); /* MANDATORY NON-NULL */
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 56d88940f92..55d21b63a48 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -105,6 +105,9 @@ bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
     if (acc->cpu_common_realize && !acc->cpu_common_realize(cpu, errp)) {
         return false;
     }
+    if (acc->ops->cpu_target_realize && !acc->ops->cpu_target_realize(cpu, errp)) {
+        return false;
+    }
 
     return true;
 }
-- 
2.49.0


