Return-Path: <kvm+bounces-41901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C37A6E8FF
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9142B1687CC
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E6211EC00F;
	Tue, 25 Mar 2025 04:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EGMBQ0oR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0353F1A83E8
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878774; cv=none; b=qH22W65BU43uZSkq0UyylDJpDrIUzuH+fXPRpaNujkLJPTXV4rZbTA1pK2k5E28A/aUSX9jnmSlOklZhTWc7Sn4IPSbjGFskJ6bvMMphvS5sMF423HZWDLfcSqm1pX+NQngg1ouA+LRnMoqGY5XZAJw9nwurZP3DmUoslQ6cpiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878774; c=relaxed/simple;
	bh=Tx0TgPehOXoXIl2iM++dNxDUW4pxQMMurT0eHzB5EoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EOmHZxDALG3sdDBBI56oZuvZvU3iGWOCQPGLeNBfqOfsj32iQFc8mFbIRnHZpfm7VJQs6e88Bqfe+NAjPpqrWQTPEp0GYZy4lFBENs39Obb9jlxAPyNVSJs9yYVK4h/MVQ1S1t76VjOoVriCVoi0/lfdjS9pc+DodK3KpUNr618=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EGMBQ0oR; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3031354f134so5611686a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878772; x=1743483572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPsnrBhccWgusioYoG8wwAVpFwZsZiOnGsl/PTdMWhk=;
        b=EGMBQ0oRNCbSQkpmYlK99PJow/zJEqSt8Ds7tMq5lE38dK9qdl8nmvlXQFfriCpWuv
         gRdpQiU9DVOsp+grQet05Vv9qXTV37jUlnytZkju0Kx8c7YmOdRP6aL+/fuIbJ2+/Xbd
         yfFc0rBgKm447/+GQkUVh460nzo1Q1Ap/euEL93P9mft4CxJod+5e3e4CYKbufqD22yO
         riSmK5l+hI64JmRhelwpdWc6/s1tv9cjMjqPd8yLrMekRqYq8SOSmeKdJ+SW+iUHWYmi
         FAlNSubux2qonzZ0HnNW+KRUNwT/iAUQKgf9DYrezEfyYwuw2BaSATeS6u3Kpu2Wc3Qp
         pAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878772; x=1743483572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPsnrBhccWgusioYoG8wwAVpFwZsZiOnGsl/PTdMWhk=;
        b=ZHiHuutWqdykB4BuffA0R3631Jq5JDpzrBGAhYgs6Pxx8eIbe4E+k2c2kT1Ul0ZOrh
         VV4EeDUgqH/+icUqPNA2kR4mwb2eVMlbG2tbXubT8fgJLxfUei7maqY5hn0Aaii7Vkut
         pPiiSamlINcdPY9eqM8i/D4lWyYkXG28gdFW9BETwh2UDsxtO+Nvc1YikCDIeCIKUmog
         zE9Hj0jXcNqiNG7lgTGfYooLTvaR0DuudohcMNZhKtvpxaOQAEYnwZzfz5F28apt+eLU
         lLELiDJui3whxOd4RPLdILTCcnwMpdf2f1SJETs4HrG4QqykEdGkTWXG4OKzEUvacRb4
         9S+g==
X-Forwarded-Encrypted: i=1; AJvYcCWdbdMqme0R5LvfYz8q8rD9sUc9wx7eGItcFfpKeq/JK2KsRKZzXQZPEqfcqznlCawPFUg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaB8H6qSPKj0M71T16psF6k057N21kiTmpBBgah3dcDJ4a5ZlO
	VoJIjpayfnB/fAB0efWNCJrFBJJn5ttt6MHXCVjF4hZ+F6OJwkmSLfABw2Aq7qM=
X-Gm-Gg: ASbGnctUVSTDYIShoXkoK4m2bAuj92HgyCVxR8aCGNJZ1ZzrEdV+XENZ1DuU3Ws8NQt
	FpOn9PmcPLZUDPNPutF02AuHlbWVjeYwanIOEj6CdD+0ahFD0zElLRDYWfHgyxTbGkY0vyrWI5C
	4ZnxwUv9BT0yejS9E2p6zQbINLGwqa//UkXnbEZG2aEFXvKS+leK253GSBNhsTd7N2LLZMxUjEk
	dzeIk6X89J3R9TS/3NtFvSIRQqeDo8JwZhHYTRZ5NHnQvEInx9QRmy4CDJ0xCO8Y79TZ56Jg7hd
	bh01bRC5rTQck4/49LWpWzAcgUtF7WEp2zwIO/RB89RN
X-Google-Smtp-Source: AGHT+IFhBlyML92DzOsb+PMZ24kTM/lrjFJmrSBEIi05/e6tUY8Bh1kxoJuR1Fz5pHuu12ZsWx03WQ==
X-Received: by 2002:a17:90b:4d:b0:2ee:db8a:2a01 with SMTP id 98e67ed59e1d1-3030ff00e7bmr22295807a91.30.1742878772239;
        Mon, 24 Mar 2025 21:59:32 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:31 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 11/29] accel/tcg: fix missing includes for TCG_GUEST_DEFAULT_MO
Date: Mon, 24 Mar 2025 21:58:56 -0700
Message-Id: <20250325045915.994760-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We prepare to remove cpu.h from cpu-all.h, which will transitively
remove it from accel/tcg/tb-internal.h, and thus from most of tcg
compilation units.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 accel/tcg/internal-target.h | 1 +
 include/exec/poison.h       | 1 +
 accel/tcg/translate-all.c   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/accel/tcg/internal-target.h b/accel/tcg/internal-target.h
index c88f007ffb7..05abaeb8e0e 100644
--- a/accel/tcg/internal-target.h
+++ b/accel/tcg/internal-target.h
@@ -9,6 +9,7 @@
 #ifndef ACCEL_TCG_INTERNAL_TARGET_H
 #define ACCEL_TCG_INTERNAL_TARGET_H
 
+#include "cpu-param.h"
 #include "exec/exec-all.h"
 #include "exec/translation-block.h"
 #include "tb-internal.h"
diff --git a/include/exec/poison.h b/include/exec/poison.h
index 4180a5a4895..8ec02b40e84 100644
--- a/include/exec/poison.h
+++ b/include/exec/poison.h
@@ -37,6 +37,7 @@
 #pragma GCC poison TARGET_NAME
 #pragma GCC poison TARGET_SUPPORTS_MTTCG
 #pragma GCC poison TARGET_BIG_ENDIAN
+#pragma GCC poison TCG_GUEST_DEFAULT_MO
 
 #pragma GCC poison TARGET_LONG_BITS
 #pragma GCC poison TARGET_FMT_lx
diff --git a/accel/tcg/translate-all.c b/accel/tcg/translate-all.c
index bb161ae61ad..8b8d9bb9a4a 100644
--- a/accel/tcg/translate-all.c
+++ b/accel/tcg/translate-all.c
@@ -43,6 +43,7 @@
 #include "system/ram_addr.h"
 #endif
 
+#include "cpu-param.h"
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
 #include "exec/mmap-lock.h"
-- 
2.39.5


