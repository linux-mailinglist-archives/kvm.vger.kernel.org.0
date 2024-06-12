Return-Path: <kvm+bounces-19468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 852879056FC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FB5E1C20E00
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F840180A6C;
	Wed, 12 Jun 2024 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="plXVGwHM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED60F1802CA
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206512; cv=none; b=qG+SrgBZ9v4/4nHWP/fVTpuBfch+TAFnQBITl3PkNnXXgrMLZb5myIYIGSxAkf3l9tPTSBCPzgoFl7qQo10zbIDSPJgDva4SdVDZx3QPPu1O4gSePMh56Y99xlVtnEMawIWoCZ/reFQJWPxftXFm242MvqojE+uFuYsxpRa4cf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206512; c=relaxed/simple;
	bh=hhjtL1KZNh7s4H+vCr+InjMK7eqyjYHSrl0IyEe67G8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gdM1thvDKIoDEsrI55vHoIpI7I/21T8Lc28VOUYnybN1eqYPTrN2CCDZgRmWKdtInPlmBoqjqwB2SF0sw6LHLVTCONy5G6tT8RVWmh8wMcJlunvma0E3veabowUaanWzE2yT2AA7azPb0KL/giy1nBgY6ZmXjz/X4KcPrBimhpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=plXVGwHM; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a6f11a2d18aso471466b.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718206509; x=1718811309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJAQlF/zpzEh6ZUd/TIoqAhEJRcTvj1Vbf876k6aGf8=;
        b=plXVGwHM9vPlfNB4kCoBEhZkdoruX2eiBWdqn56i2XQAW/CMUZlGn7KR6g6j5IQQ4I
         6sP38KM4vEUQYYW0OPWo2RIJjw47LfymM+ghgUraSvd2G4bZO3VTSzYUX4cyZPNV3a9q
         VXaDQnNN4srjZ+hfqLL/i/eG4F3VC4HuQmJlKJ3e6kUk1utA1PCJz354pKjY5uLh728M
         aS4gg6594udjomGzRwiw6EOPX5qPhoVupljCv+YnPrU1/CAFE+1LCc1z9NIIRGJ1+g9t
         Vf4VG5Ca2eBAdUAm1yzAXaUyZgy5Yhin+922tTdIQFXonjePj+E/glL/Q569obzOiuFK
         K/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718206509; x=1718811309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJAQlF/zpzEh6ZUd/TIoqAhEJRcTvj1Vbf876k6aGf8=;
        b=Yq+wjlSVgkEoFGEXisAuHtabfJowBT9cTkg3zmg8GnqQaiq0cKC+wByhdSrmnR8A1c
         83SD5CW8prMD/Das3uR8FMV0R28SfN5nUcYiXlphY/rPH3YjJYni+/wFT4h0LX0vzOUy
         K3rF6RQjJUUKTDMSjqARkszNmEmisId1lpfl1X/6/9V+AOfNuQ68ZP0hzU4Z1Iu7nuX9
         Wv+tBYDvC/e3Zz4viHLM18BerRQGJNFkJjH9ymKLcFMtnDBLJznoWq1MLBgUvyTUvy0h
         x6kvgqv0pxM2w2fe0odAFNyERdxvitdY0yjDSMugDEAgM2RrhfvsXDwJKPRTR+B8lF3h
         MPVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzpwj5mN8jX9+/n/eDMcOVAvf6qa3R0RTtneJhY+XC+P6W5wADGFZ9PXKwPygICD9Nfg9xAtAFxBCc/QBWimrUIUFk
X-Gm-Message-State: AOJu0YxwRGzPoSlVQluNbwfE2ybo0NrK+YSGuXS/ytzbQWPE97cFnsIw
	rT8UUYzOR3P9cNDzEsf078n2/bmBZaJoLZ2CesK0Jrbsq8JrUzDEo/gkeF1zBW0=
X-Google-Smtp-Source: AGHT+IEUiek7G0JZYXLhDU7k/lAdd2/r6kUwG039veuUiD6xxCOyuZljXlDyYhWaBzPy7woxoD/XUw==
X-Received: by 2002:a17:906:898:b0:a6f:23b9:4e5f with SMTP id a640c23a62f3a-a6f4800a19emr122891766b.70.1718206509163;
        Wed, 12 Jun 2024 08:35:09 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6c805f9f3dsm910164966b.95.2024.06.12.08.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 08:35:08 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 3A48F5F939;
	Wed, 12 Jun 2024 16:35:08 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	qemu-s390x@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	Alexander Graf <agraf@csgraf.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	qemu-ppc@nongnu.org,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 1/9] include/exec: add missing include guard comment
Date: Wed, 12 Jun 2024 16:35:00 +0100
Message-Id: <20240612153508.1532940-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240612153508.1532940-1-alex.bennee@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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


