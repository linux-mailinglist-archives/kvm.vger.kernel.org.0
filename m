Return-Path: <kvm+bounces-40734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5799FA5B7DC
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A17A173ADD
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5ADB2206AB;
	Tue, 11 Mar 2025 04:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZR1OvrxP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB0C1EB1BE
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666153; cv=none; b=iOMDQThipFfGxKcbRYkscZGmobWickDpRNNFLCCGkZVZfd7hqXnZx6eqtoiJ7/E5Mio5TnGkci609IRBLpV84+xRKwIalvhi80bUipit5bCXpyBrDCTPfNf/6pTa1VNGO7ChrE0fwMYBTJkyt8nHpRPLwW2XDJELMER/5vbuGkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666153; c=relaxed/simple;
	bh=CPSslnXnrG3PuOzhFaRqUdFyOZWqbvTYRwMrQTpy6Y8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lWL1YjiP/x4un0439SrV3cJ5ddvV2nwvLktP7AKQe+gRrASf2FiKMw0HLbu2yY6oA5tPLoKhHuBFddZ0r/o/mmttQG80hYpIhwrtGsm5tapwoyxCszKF/Li17iopRHZd0ckRvWCqTvQAWn5iCEAED6B6K3NIw7R1eknmVrvUhFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZR1OvrxP; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-223fd89d036so97389255ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666152; x=1742270952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q89mBu4b5JYOE58WB93/V2zR/jXmfpOvKMtRO3aXK0o=;
        b=ZR1OvrxPu/Nzx7DuWgzuDibJNsxP6egr9a7PNmcf3KPa5nhxBFn4xCeVU8ieWaDC6D
         15ZgY+iaz++bcuxSxTRyBYzDrbGtM4fTZCTNZRrOYk/G54UiavyAjc1ytmjBzxKJOUcK
         JyBYLDknzlJXSM+Y5jfcqpNKAo67zWtNcEoCSiL5yhqmY2wXq6cwg/o4EY+R7Cagm20P
         jdK2BW9/LwLkCB6EFVlXa3Ke/Vh+OEG1/OYyXti4hnyX7pyMyg87ISbhUtt/qQtJMYls
         ktk6W1rXAKEXBNR1ySP2kJlBrvCXc0OEzqhimVuH5eTrjwKzQN941guufzxNZ0AE4xWX
         hEhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666152; x=1742270952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q89mBu4b5JYOE58WB93/V2zR/jXmfpOvKMtRO3aXK0o=;
        b=CoCr6OxI6wKqOVPNUY4AfTe8bHzXXfFNIawsRf74AfyqtbLqbW1fP2cLnMLnW8ZFms
         dV4+Uv3xM9K8LXLxwO2O93X92j/bml3wwFwF7YuanZIyGPjaIE3yqnGBTFljcYW4vquy
         qXJpaQQq6uX8g7+Rt+tiIRtMI/+v93fpA8FrjTZCHTLo7+XTythRV0njMH+vRpM6ozSR
         btqLgjacUqFKIr+UVrwOxtWDxE6uzkJ/oag7Dsy7rtEVLYwGmLkZFaqNCGVy9VYn1YIN
         CNTdsOT/BYr/5+LtRGz+yYEkQYzoSnnWRFCWqXwtSna48WlKBqQKSOlnEHClEAoFJqev
         IX0w==
X-Forwarded-Encrypted: i=1; AJvYcCUuAoD3/DIBcf9VepH71liXzeKml8il84FJfubw8ge4hZlFdGUapbwSD4TUa7xRHLbQ0rk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4ceoSqu3L3RffgDM5SA6cEqSOM1J6+I7ImopzYU+25tlXTIA0
	xPUH6gkY/LYRgMFr18cizkrYB2+wgYXwFIHd3ISN29SH4hSLSJhPDSLk6o65wFs=
X-Gm-Gg: ASbGncsi02pVL7+xPU99XEefls/BvCdQRvKZLSe0WcsJqaC0yx8a82VwKdx16IeEky0
	PSsk4D2WU6tV3HCWIDdzwZ1S3QKM6Mg0yJiS3Osxbh27wdAR8/VU7RVe4L7uicKSbD/BR7Yi38p
	mLD8Zz6YDxZ5hJaP8IAJdF6Fq4PbvHgD7lNhI4dBG8GRk55SV00apk8PG0+UDWlNb+r48IGGgsN
	uo8w0Syxx0D3IMNYkKvZbBbKzbtTXAMgFWqA1GvVeoiiOXqtA+xKsuSKlQaQe4ex9x41tpRzZS0
	p/e0vt5JSDgiJEuI1ynlE0H8wSZDvq3hUiI8y6hSM66Y
X-Google-Smtp-Source: AGHT+IE7G7QimFDknOZtg96uV2bamM0fTFqFZY88Y5t1E8IfrTFu2U6cjPQap3/Vq7WYgH3pY/scbA==
X-Received: by 2002:a05:6a21:3944:b0:1f3:321b:4f8b with SMTP id adf61e73a8af0-1f544b190edmr25270834637.19.1741666151748;
        Mon, 10 Mar 2025 21:09:11 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:11 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 13/16] system/physmem: compilation unit is now common to all targets
Date: Mon, 10 Mar 2025 21:08:35 -0700
Message-Id: <20250311040838.3937136-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 system/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/meson.build b/system/meson.build
index c83d80fa248..9d0b0122e54 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -2,7 +2,6 @@ specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
   'ioport.c',
   'memory.c',
-  'physmem.c',
 )])
 
 system_ss.add(files(
@@ -15,6 +14,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'memory_mapping.c',
+  'physmem.c',
   'qdev-monitor.c',
   'qtest.c',
   'rtc.c',
-- 
2.39.5


