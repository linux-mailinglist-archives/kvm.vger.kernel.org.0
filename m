Return-Path: <kvm+bounces-45383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83178AA8ADF
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAA4F165854
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C924A1F4C8A;
	Mon,  5 May 2025 01:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sJRaDudl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763AB1F09B0
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409983; cv=none; b=Om+dZq03hiA7bTq7mlUC9PrY9pg6WbxhbqdSXu7ZPDqEIT/wZvj/qmn/sJdUxVAoFmzIq/OCDvvfO9QMIQDHori2R/ptNnqf69W0U0o00cHw13DZ7ZeXx2MK77Y96cXKaoY2wF8OLxUnLgzW7FGA5s1rXwt7OCcEFMZbFEbekZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409983; c=relaxed/simple;
	bh=jmUdrboFzyga4mrTnDHClA3zNyFy9mK8dkNEdQa4KPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPogaxFA937O8FLe39Zihd3kyslbAvenD1mlYZkOkLH65Bk7b5n/oy1csnoZyluWZrXahnt45lZ8iRZ5AYAPxR8gW0kkX1uPnuyiS5InzAp9Mg1iHcxfVU/sLkecv8MQLG5FhuUXyZ5iVFQHIj1s+CEOe23XJfr5zxIoz9Cj/os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sJRaDudl; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7396f13b750so4722910b3a.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409982; x=1747014782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oONThx//EO5WSiuREF023HuwIIuJ5yNwT7cwhGAiXZE=;
        b=sJRaDudlw1qppr8m4bY5kMcPL5OsKse5HqCQfZ7gY9O8RqhKcBDCRij/GRUWzikxDL
         UbHmcGUw6nQORJiyLtkWhQg444QK02Yktv3fP6mW2bsQW805sAqO1SXdAsoLS4XoxjqZ
         Y/hg6Kn5em8p2Z+8cyXNafLQk1+vbQDSZ8nvtGK/7K/B/drxP28lpzgHHaEZe4Mvui7U
         sCqp6GaNfmYttDPNy6QjzWolEYrH8O6LvQ5ls9LdiwrtiBKn1Ej6UlwmU7uv4iKE1D3N
         9oe4uGEMu44Ul6fZct1KEyzRqK3NFGZ/a4fGhOpjsWnYD8UjND3dJD9JG7xi+Vb7bXnj
         xbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409982; x=1747014782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oONThx//EO5WSiuREF023HuwIIuJ5yNwT7cwhGAiXZE=;
        b=nGhnlsEGAWtRCvhZAic30tvcUHExtFCpdzxHSNcEUpmnmoYNCNZgINxnk0pC+Pm6e+
         WDQoOlh+xwLYbNuhre9+3li8z4WmlKLhjGTIjEKWzVY0awhoMrekNjpfWnK/ixCGbA3R
         IZzc/0wyDrmyFzMyXIXf9jiZtlou/lVThLORu/c22HzLgkJGqSjzdaB8vNmYnlUWexUm
         96JdUTDRzI2rJRcYMuVjboY+jDAl/dFySBvkaspXk8NzBO0OjdJNZCICnt0sjaiYs7At
         +DaG1H2gXi8GYRd+l3z6Ci9aAgx5QSNjqENtONFGECep9Xi42Hu53+Z8mGQCEkXtkbK9
         mOOw==
X-Forwarded-Encrypted: i=1; AJvYcCWV+A/AeCqDHPs9TtKYP/Y3q4/GMNJ/JvgGjgylT+GYyPTljt3x8HyDHEaBf+1fSXel6ZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+9rr5xf4hSPp61S2bPoB3LyopFXEt1QdvOkHNn4Fq3gcVJgTJ
	4NORcVqKW0QHNyqCvnTpqF7ppSnZ60NclDxCAbusU7nC7gaVOLO8xB51sRRGSBw=
X-Gm-Gg: ASbGnctP9AbJdNsFG3wnHk/yIDZf5CNNYSomDU3dasq4rd2MzFKVvjln5pCIj6/4pik
	WaMDiD30XFgJq2xwD8Uoq7YEy4Gc5JOJVQDz4ulDX/5a9YPnGHnSLXaxXQgB7FozjEfkk7My6t1
	9x4SysLFauk5oS07Sr48ZjOGhK8tU6unF6WQp5zQNGpKyGrFFsNR5Rqy8yiy3MVxh43Z6GbsvKT
	I/ziWNf/Vsb6Gt0+qG5IX2O3s2NE1gboyun7FKZLAn7Nzxr/v+/U44FwXAVNgOq3WuEs1525/vf
	sZMojrMwHsuETSBrepB9rEcZ2+zlrO7BrNcXuD9f
X-Google-Smtp-Source: AGHT+IHr0qzcLKdRFzKhMCewLOWMtdB62i1QsUpnVafjImETUYvckCkVS/LSQ7CJAssIR78evsGItQ==
X-Received: by 2002:a05:6a20:3950:b0:1f5:8b9b:ab54 with SMTP id adf61e73a8af0-20e06823c71mr10780816637.23.1746409981839;
        Sun, 04 May 2025 18:53:01 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:53:01 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 36/48] target/arm/machine: reduce migration include to avoid target specific definitions
Date: Sun,  4 May 2025 18:52:11 -0700
Message-ID: <20250505015223.3895275-37-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
 target/arm/machine.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/machine.c b/target/arm/machine.c
index 978249fb71b..f7956898fa1 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -6,7 +6,8 @@
 #include "kvm_arm.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "migration/cpu.h"
+#include "migration/qemu-file-types.h"
+#include "migration/vmstate.h"
 #include "target/arm/gtimer.h"
 
 static bool vfp_needed(void *opaque)
-- 
2.47.2


