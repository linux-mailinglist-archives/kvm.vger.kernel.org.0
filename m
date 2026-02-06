Return-Path: <kvm+bounces-70409-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qG03NQ1uhWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70409-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:29:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 99171FA127
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1FC9B306682A
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0232834253B;
	Fri,  6 Feb 2026 04:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RZwRk6/Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E759834214A
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351721; cv=none; b=YdxUz/phMX8tpG6v+3pTHaIyd+vGwe8dW0t5SV9IMobItMu/PQ7N1aQirBGqppBusN1PgPvF+3opfiM1OEbmSusnUeotfTemnHXgG0H7Smc9T8E67Q3gc6TInjDpjwPq3SJxoZWVZSH658Gyn4v/AGO805Df8VwVxI/zLqfdcdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351721; c=relaxed/simple;
	bh=uclzed3z8Zw2ZEjI7uHNSKEyIn1t4vQSPOBibVkQal0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SJ6aNhR7A2AtzB4A1usxxf0oyqQdNQMG5h4RFALCMeugTKzMWCFi9Deqe6n4PX0/uQSpxlFFBVaFPP0y+02bU3w4H7WgiEPMz0zFJ1Z0yPGUFu0QsHwt3f5xCREJd7S4nWfrv0h6/ySMbgYzqHNovF37Yayht3FOiNeuwXIRABU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RZwRk6/Q; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-81c72659e6bso1249753b3a.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351720; x=1770956520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GWiowObtYe31NsMaSO/9YqeYyqvmY74xvGzJVT9wiZ0=;
        b=RZwRk6/QCvjBzRpfKQwNXqC0iy1luFyHuK9+EA9JGUWZeVNwa8mbK9imWjjVIfe3Eb
         o3OyblHSEvGJa3uGSnZSdPj1LU0vo5pJK9ZbVxMw6EIjaQtECfN5CQTtXYy8Eb4AKgyq
         Wr0UgK09Rd+dTmRRUtUP+Eorrlvj14jFXflIdVsOCL1uUfAomhDbUUPSzqAej2U+EK6j
         NkXGIxSnVipQ+xskmwwjLlxaHAzdvwjrHreMUHkpA9z61cUtRV+ts0/Gwl1Z2LvjsK/f
         9JfqZQbGjyw5WyvWczhQmrXiEn165ZtzJS33xNA9mPmwdYKNtXY5ZaJarsi/AuvXEfmK
         EaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351720; x=1770956520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWiowObtYe31NsMaSO/9YqeYyqvmY74xvGzJVT9wiZ0=;
        b=xG2saMlPiqfmFQjaIgNQ45xGGCENadIJ4fWALCYBjISefSJOvUIruc/MRxC8ViO1El
         ILX0xTgeXzZH992+EIMva0PyzWz2ZhVaMH3k1ZN5G1tWE5gVNxVLYwU67HD4obKHt9HZ
         n8edGwbdpCfZGEOfcqBgjA/gcC/evb+be0ZaFkmqkScetwqKTzMAPt5/YD9PU/SA7uyB
         JAIXOzFKcS2H7OUe4taHfPjzKwRaRp2rq9jvfP0KBCwSD0BHwkcqCxQPElc1gUw2gf83
         Y2tLr2TfX7wpijLMCTq8ib5p3o4inDa9n5yRWYSHa3iYpyzPnQoCF/GBsTSz+jqSODbO
         UWsw==
X-Forwarded-Encrypted: i=1; AJvYcCUoM0poBL5vty/hC5BN/q8gj/4xxUCrsDXIG2AfhlK8+w7N5n+9ZPu9nqQ37vYAbgqN/mc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf6c7uAUUvSqzhmbL8xgybnaTCrG6JeSySM+X4QmX0ZfSDOqzs
	jHiJwEQ8IYVCHBbTNkKsf7G2izs25LaAqAFVTmoYTXWO7OnO+697xwj1Eb6CqzGSkuc=
X-Gm-Gg: AZuq6aJ8kAcDDjTFTZAmUTRbFwFN1dQ1Ldn6+vMdIkDFd6qBMjnNExtlZpj8YQjPHlw
	+M+gLK/Q6d2BUMX5jEIrJegxasqr66Uo51xTAkTWEJqX3dt45RfGnpIHbCmGy4gndoCnt9nVBzj
	jzvSBkW6H8naUd7v7JIqt0EjcWXiQ+yDnEfzXiddUE5AyZl2wVoCcG5OV74zz894udOyTt+NxQh
	6XYayHkLBQJbsyfxGiQ/4dxydpEJrTb90EwEmXCXFSeZLVlIV9twO2CdepgxeA/2hu0m2kUDWRI
	xQiQc/GJ+cJoPkSoTbwd3HCj+WXzPJf/H1GuhCK8dGc1AT2LXw3P5oiWlQnT21RkPSSfidBtD3F
	7IIvSKedmR02AWYeKdCECqeDVf5ibKhPqXWSiAhgAbh8TDHBL7zXlDL5dDiujJq1zwwoM9fBJZ8
	7qeLZB+RFdLnuml64e7J6zq95SkGKY24FtKNmXk5tJGS//2pBL+2xzVxL2d2aXMYsp
X-Received: by 2002:a05:6a00:3997:b0:7e8:4433:8fb9 with SMTP id d2e1a72fcca58-82441773041mr1246675b3a.65.1770351720150;
        Thu, 05 Feb 2026 20:22:00 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:21:59 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Richard Henderson <richard.henderson@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 00/12] target/arm: single-binary
Date: Thu,  5 Feb 2026 20:21:38 -0800
Message-ID: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70409-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 99171FA127
X-Rspamd-Action: no action

This series continues cleaning target/arm, especially tcg folder.

For now, it contains some cleanups in headers, and it splits helpers per
category, thus removing several usage of TARGET_AARCH64.
First version was simply splitting 32 vs 64-bit helpers, and Richard asked
to split per sub category.

v2
--

- add missing kvm_enabled() in arm-qmp-cmds.c
- didn't extract arm_wfi for tcg/psci.c. If that's a hard requirement, I can do
  it in next version.
- restricted scope of series to helper headers, so we can validate things one
  step at a time. Series will keep on growing once all patches are reviewed.
- translate.h: use vaddr where appropriate, as asked by Richard.

Pierrick Bouvier (12):
  target/arm/arm-qmp-cmds.c: make compilation unit common
  target/arm: extract helper-mve.h from helper.h
  target/arm: extract helper-a64.h from helper.h
  target/arm: extract helper-sve.h from helper.h
  target/arm: extract helper-sme.h from helper.h
  target/arm/tcg: duplicate tcg/arith_helper.c and tcg/crypto_helper.c
    between user/system
  target/arm: move exec/helper-* plumbery to helper.h
  target/arm/tcg/psci.c: make compilation unit common
  target/arm/tcg/cpu-v7m.c: make compilation unit common
  target/arm/tcg/vec_helper.c: make compilation unit common
  target/arm/tcg/translate.h: replace target_ulong with vaddr
  target/arm/tcg/translate.h: replace target_long with int64_t

 target/arm/helper-a64.h                       |  14 ++
 target/arm/helper-mve.h                       |  14 ++
 target/arm/helper-sme.h                       |  14 ++
 target/arm/helper-sve.h                       |  14 ++
 target/arm/helper.h                           |  17 +-
 target/arm/kvm_arm.h                          |   3 +
 .../tcg/{helper-a64.h => helper-a64-defs.h}   |   0
 target/arm/tcg/{helper.h => helper-defs.h}    |   0
 .../tcg/{helper-mve.h => helper-mve-defs.h}   |   0
 .../tcg/{helper-sme.h => helper-sme-defs.h}   |   0
 .../tcg/{helper-sve.h => helper-sve-defs.h}   |   0
 target/arm/tcg/translate-a32.h                |   2 +-
 target/arm/tcg/translate.h                    |  22 +-
 target/arm/tcg/vec_internal.h                 |  49 ++++
 target/arm/arm-qmp-cmds.c                     |  27 +--
 target/arm/debug_helper.c                     |   4 +-
 target/arm/helper.c                           |   5 +-
 target/arm/kvm-stub.c                         |   5 +
 target/arm/kvm.c                              |  21 ++
 target/arm/tcg/arith_helper.c                 |   4 +-
 target/arm/tcg/crypto_helper.c                |   4 +-
 target/arm/tcg/gengvec64.c                    |   3 +-
 target/arm/tcg/helper-a64.c                   |   6 +-
 target/arm/tcg/hflags.c                       |   4 +-
 target/arm/tcg/m_helper.c                     |   2 +-
 target/arm/tcg/mte_helper.c                   |   3 +-
 target/arm/tcg/mve_helper.c                   |   6 +-
 target/arm/tcg/neon_helper.c                  |   4 +-
 target/arm/tcg/op_helper.c                    |   2 +-
 target/arm/tcg/pauth_helper.c                 |   3 +-
 target/arm/tcg/psci.c                         |   4 +-
 target/arm/tcg/sme_helper.c                   |   5 +-
 target/arm/tcg/sve_helper.c                   |   6 +-
 target/arm/tcg/tlb_helper.c                   |   4 +-
 target/arm/tcg/translate-a64.c                |   3 +
 target/arm/tcg/translate-mve.c                |   1 +
 target/arm/tcg/translate-sme.c                |   3 +
 target/arm/tcg/translate-sve.c                |   3 +
 target/arm/tcg/translate.c                    |  25 +-
 target/arm/tcg/vec_helper.c                   | 224 ++----------------
 target/arm/tcg/vec_helper64.c                 | 142 +++++++++++
 target/arm/tcg/vfp_helper.c                   |   4 +-
 target/arm/meson.build                        |   2 +-
 target/arm/tcg/meson.build                    |  21 +-
 44 files changed, 391 insertions(+), 308 deletions(-)
 create mode 100644 target/arm/helper-a64.h
 create mode 100644 target/arm/helper-mve.h
 create mode 100644 target/arm/helper-sme.h
 create mode 100644 target/arm/helper-sve.h
 rename target/arm/tcg/{helper-a64.h => helper-a64-defs.h} (100%)
 rename target/arm/tcg/{helper.h => helper-defs.h} (100%)
 rename target/arm/tcg/{helper-mve.h => helper-mve-defs.h} (100%)
 rename target/arm/tcg/{helper-sme.h => helper-sme-defs.h} (100%)
 rename target/arm/tcg/{helper-sve.h => helper-sve-defs.h} (100%)
 create mode 100644 target/arm/tcg/vec_helper64.c

-- 
2.47.3


