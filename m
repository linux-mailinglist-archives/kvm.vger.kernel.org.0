Return-Path: <kvm+bounces-20096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E299109A7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1C2F1C210A5
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DAE51AF696;
	Thu, 20 Jun 2024 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IqltoBOW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CFA27456
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896947; cv=none; b=FhrSmegpaqwlpsNqDsjXU0Rok66ZlBMNJ5htP4aQexlyVcr5ZTznKLQB9aun20uS6vOt2N3/0/U1NrYWfhXmN+b2Zs/fPVBN6jwQGruMKlUBVgyb5D3nd6aa9SQ1i4fKPOv1xuh+GxO34Qyyu+XYHJcBUgFmq9Tvnf8Nc+jg2qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896947; c=relaxed/simple;
	bh=pUz3SnmllUrGDeG+bNxHf12f3fiSeqd2Z7ynU3lmtVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I5kJDxmW5J2ExIyTrPQSYItquUjrHymtuFvglhOztbLZdhtM2OEwNWwtO+SwoWzGFRqyf1V3E8IP4Z0uOSDNlsnIbFex/2sSC17wnneGohcFuzSHwf/YjfHv394od/YtkNDfBbzQu2Jy/p6n0dyROurbObi3fZwexbOPbvgb9RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IqltoBOW; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-57d0eca877cso1157534a12.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896944; x=1719501744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yimdE3nPFUILo7awwhHRy/OflE23PtwusH0HEIKw8g=;
        b=IqltoBOWpa/yGMCP1J/WOgTMd/xtDrmm8F1e/jQoXvvBow5dEl1xgSYWqwApjvWDJN
         TYIrL68hWrwrXNKKu2CR8fGTTWq0kaaZlUxTg+LHd6UWmjv55q93XQ6FRsQFbx6dTdJl
         g9WYg2zY/4QvSNq2E/52F2sACG2UoUhykFEZG35FI/BJ8IoY8U6otFA3tuPGlGpsEbMS
         Oj4m5fYzLAfHAjnyZUkjbcYi2HQzU1qQjtIT5CAJcueYYSHupYPH7Qpq6j0Ck+wK0ZTs
         uARwWNa8bWyBx14jRRhUKRdWFpKewuQ/gGC/XHOfMsuZ+VN5lzwhKX9XJbHOTq7RnEeT
         DhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896944; x=1719501744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2yimdE3nPFUILo7awwhHRy/OflE23PtwusH0HEIKw8g=;
        b=vM9nZ3gJiV7hTbkjYFbEQ16RfB59QeQJcseUz6iFMgc6PLaz0ia6ebVZuVp21IZlDN
         6ScinypscjcO5YvlSu6uHa7x51NN2EY5+jcc/aWwFuEeIADJsnUL/penRwd9ypXCYUNI
         QwJrIXrvNnwgzoGhaQl5OFyHmuEh59otKMwIsfhI8nBwVesRPREIqQb9Iyn48XjeTuBL
         x8y0fMD8GrI6WPU4GPx0DbOnKdZc3ay4t1bAQnW4AduKp9RLU8CR2WGAm7D94jRss8nF
         e+OM4I3vA3Uu6Mcjr1sF+N6ThULjJiexRAYLpymdeIiMpWbd9Xn+IA6ARSM+trVF0NDU
         JIag==
X-Forwarded-Encrypted: i=1; AJvYcCUawilEpL9y1y1PRa1B05aJAyi3jFDAIz7u3cp9tvAVd6Mdy4vfrMeLanuFUfP9cgZ1jT1BHOCi5uiBhAA2MYKDVVNm
X-Gm-Message-State: AOJu0YxB7MJ9FznEHCpOyyIbp4jKOWhHJLNmMDjNBlM8vv0u3Uoq+v5R
	1PdbFS2MpPUaXEpJy0RrGkj0TTD/uImvkIHOxl0efUgTvQmCdSDhvYeeQbz+nQw=
X-Google-Smtp-Source: AGHT+IF0pT64lOwvmgjrnZz5oRbIp3FmEbDr7uORUII+TZgPVQWBUAxVEabv+gd2aImTVoquazQfRQ==
X-Received: by 2002:a50:8704:0:b0:57d:3ea:3862 with SMTP id 4fb4d7f45d1cf-57d07ed410dmr4532022a12.27.1718896943048;
        Thu, 20 Jun 2024 08:22:23 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d21df986esm1006464a12.72.2024.06.20.08.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:22 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 137115F892;
	Thu, 20 Jun 2024 16:22:21 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 01/12] include/exec: add missing include guard comment
Date: Thu, 20 Jun 2024 16:22:09 +0100
Message-Id: <20240620152220.2192768-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Message-Id: <20240612153508.1532940-2-alex.bennee@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/exec/gdbstub.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
index eb14b91139..008a92198a 100644
--- a/include/exec/gdbstub.h
+++ b/include/exec/gdbstub.h
@@ -144,4 +144,4 @@ void gdb_set_stop_cpu(CPUState *cpu);
 /* in gdbstub-xml.c, generated by scripts/feature_to_c.py */
 extern const GDBFeature gdb_static_features[];
 
-#endif
+#endif /* GDBSTUB_H */
-- 
2.39.2


