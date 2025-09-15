Return-Path: <kvm+bounces-57632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 909E0B58701
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 790AA1B25120
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16062C08CC;
	Mon, 15 Sep 2025 21:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="HUgd21rO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D732C0F87
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973293; cv=none; b=E4ZG+aE8JMQtk27rm336+DVoNaJdppqHtvgiVDWgqsa6/5FVnTSOAgllaxJJ0fgrdEub3lb9Pyes9T/gJ5Vyb88opvRCHzyO78bZVIG7hNLhXsVetk7lFZhuubYYUWBS98KMidVLE8heXBblMdBw/pH+6u1tK1L5rkI2yZuj49o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973293; c=relaxed/simple;
	bh=Bk5KjA4JdS/NCumF4B+M4o8ki0+1/OPy8Zsgtq0+E5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCF1FvzIR5sY3g/zfaXbS/sCIGz07Q/jSP7zP6Z4sMfxzyJm9vlbNRPqnLMl6yKq/RgYHeqOfwAh27kECoWtfiwLyo7MafMqOsxavdldHhVFtDsp33kT2Ca7CBNjcjR8icaMgYV8QlmelzwrlAsRTe813HaqI8lq2XkyU945zwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=HUgd21rO; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-787d9eab745so9457556d6.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973290; x=1758578090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1Wf1YB0SsfvRNrXE8RjpeDW1RLS6E9uJSM4diZKivw=;
        b=HUgd21rO9/2x4IGM7sH3g5PwxQmTSs3VdF1w5+J8L5/8ScpHlgM2CRxgXXvklyd+fv
         Z3nMAmktz2qNSCeplNTK2XDdq5qnvReol5aoikAIqIP8no/E4+hNtPDN3T0YD4kgVkr/
         lrM+On7Q7ErXvgSgmcnYNVXaE38wEwkxYI0x+repbFWYU8cZncMt3gLmGyaJhneSKdwt
         4rlaMo3YTl5soJ5znBoGjZeHBrzGn4lTwFPaoS7f3Ga6xzPY+qpFSACG5KZSOcZSUrK6
         OkldR0xWrcBvzfhdpzFWyPv16ovTWf6RrI+eNAkVBbmvpFyxI7dngCEP4LwIIkgilBGR
         tgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973290; x=1758578090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1Wf1YB0SsfvRNrXE8RjpeDW1RLS6E9uJSM4diZKivw=;
        b=lXJbus1YRkOViP51pPy3mrNfyQr0y1zC3Ca1pj1I7moiqEW77GORFlcIulf2J1K2x6
         V9C9x5+nsogBde9bFjVQvD+ec5RZMlvnMwHVLlU+JgExOQ4eDi51GCc0HEgkRnMj8d8L
         nw6bFZ4HSg/RxFJG0zQvRwrONgILiJghjJGRGsaMYtvQvnZs3VwBFNc7h1X/sLb2fsjn
         2mDHsbTRFc3UDN1hKGBmgqpL06IP/ZvUV+yDm0FAvfOv6laJ6wYTcAmm/iyonI4HHeFx
         6iIFBft+VCnHEmZ+LEZsfE5AdQCvt9MGw7U00ZKMyrbrKaEu2fLfFFAHCOynOr+VGKH6
         BP5Q==
X-Gm-Message-State: AOJu0YzNWW/FNhaFAFD0Y4UiJAxdJc1KgFyLjdIwTggTFWbKb+8vShoK
	z71soL1vfBBmLQjLnf10NnjZowtJCJoE0cXqOuY62ps4DUhUPxzL8z/ZGhVtiG9cwWc=
X-Gm-Gg: ASbGncu95yxpTX8xGqvB7yVnIcN4x2+SZYcKTrRk+d9t0aqEt2NlpwmMrNLvZ3UjNoi
	ivHYvKhsnOmY7XpAIpBoAWKgICPZjdpZWMvWMJTkwFyO9hIFCs843rBYzebbsyuvtG/wuezi1gG
	eRbY6aYd2RvQf+qVnHUtrMs4LJJtuvwt1hnY4Q+No/bFuXUtH8gvGiiL5zEOtBLLuCOUkc2a/Sd
	lyS7SbcVYmNxiNcTtI5alcDFgJscQhhvgejSS64rPBjnRIDMLH3UtpJ5XHng0etPVJgJMjCBNZC
	QvJSf8l3gKO5SgAtayp4+Xda0wyi04/O5BDMCg1pmvAcM6gK1Qx8bVE4y18zvCQIjABZCZyzhwW
	39fwnLTmvDVzAXRCPzxuK75rnFR46PAcvGnGfLNOAj464CpFb1OAjVFH6ylerPGFI4ikBLJm522
	4D1TmvOjrAk0A6E7KKzqicV1Kir5EO
X-Google-Smtp-Source: AGHT+IEJAtu0zt8kOgDGhE3gvqekHDqO6GH/t48ORW60nfsydMY5t/sT9Xnm7A1gzaPfgepEiGjW1g==
X-Received: by 2002:a05:6214:21e2:b0:740:fffe:c0e5 with SMTP id 6a1803df08f44-767c3a5483amr201042416d6.50.1757973289714;
        Mon, 15 Sep 2025 14:54:49 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:49 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 1/4] Makefile: Provide a concept of late CFLAGS
Date: Mon, 15 Sep 2025 23:54:29 +0200
Message-ID: <20250915215432.362444-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
References: <20250915215432.362444-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow architectures to provide CFLAGS that should be added only after
all other optional CFLAGS have been evaluated.

This will be useful for flags that depend on other, generic ones.

To allow 'LATE_CFLAGS' to make use of the $(cc-option ...) helper,
assume it'll be a lazily evaluated variable. To further ensure the
$(cc-option ...) compiler invocation overhead won't be per-use of
$(CFLAGS), enforce its evaluation prior to extending CFLAGS.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index 9dc5d2234e2a..0ce0813bf124 100644
--- a/Makefile
+++ b/Makefile
@@ -95,6 +95,10 @@ CFLAGS += $(wmissing_parameter_type)
 CFLAGS += $(wold_style_declaration)
 CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 
+# Evaluate and add late cflags last -- they may depend on previous flags
+LATE_CFLAGS := $(LATE_CFLAGS)
+CFLAGS += $(LATE_CFLAGS)
+
 autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
 
 LDFLAGS += -nostdlib $(no_pie) -z noexecstack
-- 
2.47.3


