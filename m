Return-Path: <kvm+bounces-50798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D23AE96DF
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B2C11885DA5
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B61B233727;
	Thu, 26 Jun 2025 07:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="KQmcnKUv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F7E24E4AF
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923310; cv=none; b=CPJAPcMGsTnd/tED4ZLDlNC0chKrEZuJ1uNygd9KhmoGEUoYu6ygBwalcoDz6yUrV9sFO/Rdox1DXscw6/goDjC8BP7NW73xTy4NeTy0QJvKcmgaJ9NHeQLQC/SsWYt9nh3bq1RsJ2AOwT7jDsiOvgx5r0SBpkV9a46hsGnw9oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923310; c=relaxed/simple;
	bh=9nDAXaKHg7FyzkWhZLXIJ5TfAZov6WC+79xPXEY+UOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQCrMemtTAXrdhbXSomw6ezbPr2CVVVlK6RMWwLcjcpHsGSvSV9dd5shlyDkcvTekBKG1xk1jA3F4/35NHD8VjZzKcBMt9gFXocu2LT36vVXO3HibfVzDYc1bzdr86TKMO6ylak8JKIqCeLu2S/Un0SrgO5BYrwJSStPPcVC8WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=KQmcnKUv; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a54700a46eso324347f8f.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923307; x=1751528107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kbCt1+qV0Bh+iNsTQzd35NDe0jsI5/O94RxZfbNod3w=;
        b=KQmcnKUvTiRWcZ2DGzEdm1W0rAhcaQPKkgMxWHrAnbyLr9Pl8mI8FGJKlaR1Znh0A8
         U0bszRw0evywbJTvleaROBxcIOQp5V7uHnkt9PK1UeZT3zfUK0UKBjcrEiZZtrzEW7F+
         WQXB3QYarEtN+gpp2DaYb//PnanaQ6t/EX9ZmAX8qUojGb4YM7T6ceRa07+ui5WRHWol
         F2EUz+R/yaWY9nBBHcGKxU06HY9d8S0A/8n1077Xp/2neU7uV29Wk/Fw4DuvlLvZag6m
         L0VVa46i8hUpRrmp9+EEc+gAwhcZ3qDWfIVrLC5O6PAStPAHvRhgtcT/FrlnU0/iNbII
         mxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923307; x=1751528107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kbCt1+qV0Bh+iNsTQzd35NDe0jsI5/O94RxZfbNod3w=;
        b=n/OKd/K65Dm/g9ijTndRHD622k+8rapfcLlToZCh+JMFXyfEOOVPqLgdR3r4UDoizK
         QWZhe4IxCJiaYk9bQoJms7b54XS1QP6EHQzpd+B0WK38ysR42OQWhthXxGPnVZsYGJPj
         zn46pUEqJ9NmFgZWRH0IqjgG28htqoxBD4CH7JPv71yeC2EL/2Rwc7C0ieDCGF1jPWeW
         kbtwupUao3tghH+na3fcTXdiDgCs2xbOXQeU1dxmsR8IxSx+oMKAhTiOH76O+tNkuS85
         Xbjcmg8gAfvgRW92nNO5ptX8XaGOos3Pu4YRw/9gLZ/KnShPpeMYNRv/iSRNb44dv1gB
         YCwg==
X-Forwarded-Encrypted: i=1; AJvYcCX6Ly8Grp0fIoqd6d26vdvaYi1aNHFWfBYuUSmshltRZxLoqgstwYCwNrvTwHKqWLTf9BE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc5r5PaAhk+83sF4hf+xJRunhmt50emYliOjEoARHMUQYnbNGP
	GSrm6xmOhAE1MbtSvX3KBc+WxiPu5G9hwx8tn1X3ZGTGYkCcEa05GatxviobDtB6DQw=
X-Gm-Gg: ASbGncsBtvCRg0+ahRVqRJZ2MCmQW2XTgwAdC4yqpkASPnYlXdLDvdRUJd8aIfNTqev
	3QYPtCWr0B3Y7LWki0AejruHl53+/3GGENdCNtprFExxzkealc946JSIEvg/hM+0AyxB8DdUzqV
	FIc0G00ZNyo/FaygTeG98QgdYKeuKWdaP3adsbZSwxCuuTpRPnm9C25VqQLbaSY7HySgLbFNrAl
	Su8uRKtUVC5vKcWRP1ZcA7PKRtn+GVT4oKBGDpaxo3n9NOqK2n2OhgNGXCigMpt5EdB+GsiIYmb
	RQpijZCeQIp0opqikRK7AX7wZNQWRxYKrCuiJXiH63bXqwYPdhW+C50JWnv5R3gJWFxhVZLvtRh
	RQrFmPvvprKjm7MMj+XYVtl+SLjpd55B2gHd+VLc7HA1oPfc3m1gV16I=
X-Google-Smtp-Source: AGHT+IHkCSTkiKZdnVynGrOGZUHnKnEASlddGrss4eedsj8L2CxUHbkS6+6RTlgoR/yvinx26ZiomQ==
X-Received: by 2002:a05:6000:230f:b0:3a4:d6ed:8df8 with SMTP id ffacd0b85a97d-3a6ed66a302mr5225776f8f.39.1750923307273;
        Thu, 26 Jun 2025 00:35:07 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:06 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 05/13] x86: cet: Use report_skip()
Date: Thu, 26 Jun 2025 09:34:51 +0200
Message-ID: <20250626073459.12990-6-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

report_skip() function is preferred for skipping inapplicable tests when
the necessary hardware features are unavailable. For example, with this
patch applied, the test output is as follows if IBT is not supported:

SKIP: IBT not enabled
SUMMARY: 1 tests, 1 skipped

Previously, it printed:

IBT not enabled
SUMMARY: 0 tests

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index b9699b0de787..1459c3dd3d67 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -59,12 +59,12 @@ int main(int ac, char **av)
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
-		printf("SHSTK not enabled\n");
+		report_skip("SHSTK not enabled");
 		return report_summary();
 	}
 
 	if (!this_cpu_has(X86_FEATURE_IBT)) {
-		printf("IBT not enabled\n");
+		report_skip("IBT not enabled");
 		return report_summary();
 	}
 
-- 
2.47.2


