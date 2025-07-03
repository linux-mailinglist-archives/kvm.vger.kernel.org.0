Return-Path: <kvm+bounces-51434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCE0AF7130
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23D27527388
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89BC22E3AF1;
	Thu,  3 Jul 2025 10:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Cx3+Bs1h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F0A2E2F01
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540309; cv=none; b=htVwSTwKoQDbHpQig0hPpNJnvANeXGwzayYmIgtFhhrRPCAMdaGStG+cJOptVDhCellupMa1cL4H3610gMRQ1FxcmIh0SG+FvKOPbCsLi5KYNivcpouBTgNbOhLjcIltOjIS8DkJ29qR/G7OAGyn147vT5fUUBaYBM3qObgC5Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540309; c=relaxed/simple;
	bh=gxYn6Vq9EJ0ah0atcxmZdNORkrT6whm+K+E8EY7r2xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RzbIfXfWwZUv+lzG56281mRLWAFok7bLOs4rZISYFZGOZ5A7vxQiOUSVXQNzizoglja1VCMCa/wxvWVhlAmWPXgW+nFOQw4gZIRXtAW3Y5RGKdm2RD81cgUd3evr01eBtXSTSvjl8mZuG1iays6t3Scw0NiQEOHj1/NyV2xUHNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Cx3+Bs1h; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4530921461aso52363115e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540306; x=1752145106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9oDPnMiXj0W5tjbWJ4QNzpnf7Jjks18+DwO7DMnaVk=;
        b=Cx3+Bs1hb11k6rBa3Ho1fGnRQWkSqoBy2wkS1R3dXTg+mxjSF0FnaxUqcKMyFtwWSp
         +693aftN6a55pG68G42/WLfSo7QhE1LjWPD3y1cGqmhus/2WRkSLtD5T+HUMIT9wvPUz
         EXnr46x2+xioRuCTCvJImJ2EhfMB/E4+01+rd0GVN7egXFaafatlZP+R29HtQUNCZljJ
         dFxGHWX9/Cgenv3E//GytVHS49Z3P/nfHNN1RiIPc+cDkBFGdeMPrfv0zaLmKih7Zeh2
         vhGh3yXYM230JQdlcK05nrhgQg/dJ/k8S2BC+ZjL4jawIm5j0ZLnupWqiQ8eDTy56S1D
         3xFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540306; x=1752145106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z9oDPnMiXj0W5tjbWJ4QNzpnf7Jjks18+DwO7DMnaVk=;
        b=mRbP0+w1/9V+Y+x4I7zyzeObWzGWzQv8abVGR7G1kw8Sm/gunI/F5NVsC+CWqlZLYf
         D6HGnJLBIUf/FoTT0ciWQrq5yJEk8xMlbtihJi9VdOuDWJWZ/dCUY76zC2wcs+P+g8y4
         WswBxC8leZyzYRkVxWNx8MKURyqDkJGII8ZWgnwY44k1as5kvXvu7p5GAeoz8UHQjKT8
         rXsoW6xJN2GZSy00VgN8jcgi66Z8cT9Ddts9uh3E5LEuDgPAfeSigmteu4F4TsUyi8iA
         xn6mbu6d3kvZ9Rc0l0go+cDI2T6882w/TibgBSCfdbrYj64k16Yn9aHHhW9IUtQaLlTs
         Oasg==
X-Forwarded-Encrypted: i=1; AJvYcCVxkBMPmHw4cMhek71jHp0pON3cKL+em3eYsaO3sJSUNvpQ0tG+5gts9ZsZ+XQDBEuWhjY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0+nBa537C7uRJIubHNDzoSgctiWLqGIzrLHDpRKa3LHr8Q0m+
	XNbQLaoBEmBti5S4pJQPDPff/mEhYuy8/3L8AvYLiygtsIsK1Gh9pLybtHmarv46cJ0=
X-Gm-Gg: ASbGncvNuMda4I+mx838CKBnGDyeoV6tWFuH2nlYh3tZRhBpb5tD3ZEE+TYNotlzLey
	5jSmJhRsFPP9+M+aJKTK9Uq9REUwAAZRk0uO+xTzIxZyKp2hGAQG2pJgP1hbwd5Fhm0WJJcNi2A
	ue86NSdlP9FhIojlOk/cAs71WZrn5eSA/CdGt43fwsQWYfLrUMglstlmEfA1pfziBJAFTkQZ/uN
	f4yUvpRHzQn+K+qgQPohTejTMFw5hs9t+v+D2mpkzRmbs53PUpRKyQ7CWWFcNGaYP4suGYNZqdW
	nQoS76dbM0FE+ZpiFNTXYXIen3C9DbZVrs54FwKrwRunnP7sH7hZN5elQ+In7sYV5fETU1CPLr4
	hkX9NZrj81Ww=
X-Google-Smtp-Source: AGHT+IEFReRAJH2FYWXivnT7yhvwImOKEpLg7WkwUoTmJ6AuJ6pGN7l7U7CUpirT0Nc9mpI2CZnvOw==
X-Received: by 2002:a05:600c:3111:b0:453:b44:eb71 with SMTP id 5b1f17b1804b1-454ab3a8f15mr22671775e9.19.1751540306331;
        Thu, 03 Jul 2025 03:58:26 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a99b1a5dsm23326275e9.29.2025.07.03.03.58.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:58:25 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 31/69] accel/tcg: Implement get_[vcpu]_stats()
Date: Thu,  3 Jul 2025 12:54:57 +0200
Message-ID: <20250703105540.67664-32-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-all.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index ae83ca0bd10..490596dbbd6 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -239,11 +239,17 @@ static int tcg_gdbstub_supported_sstep_flags(AccelState *as)
     }
 }
 
+static void tcg_get_stats(AccelState *as, GString *buf)
+{
+    tcg_dump_stats(buf);
+}
+
 static void tcg_accel_class_init(ObjectClass *oc, const void *data)
 {
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "tcg";
     ac->init_machine = tcg_init_machine;
+    ac->get_stats = tcg_get_stats;
     ac->allowed = &tcg_allowed;
     ac->supports_guest_debug = tcg_supports_guest_debug;
     ac->gdbstub_supported_sstep_flags = tcg_gdbstub_supported_sstep_flags;
-- 
2.49.0


