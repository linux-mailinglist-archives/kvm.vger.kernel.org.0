Return-Path: <kvm+bounces-57631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6EFFB586FF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECF8D1B21862
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D528C2C0F83;
	Mon, 15 Sep 2025 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="wkgRFAWJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5B129DB9A
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 21:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973289; cv=none; b=IiuwYE8LLUgYaEBQui4eVWTxSuuONNPLlLkMjuDWSoZykROSs4TK8NoBmfqyrbSx54oaRaLr5r8Rxh6Wxg7CPMDzqNyXJCA5W43+R/6ZnR6ZI5b31bzWME01y9FUDIcJW9w99YEZs275kavnHX0TaatVkZBIEUdJWx/KqNBJkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973289; c=relaxed/simple;
	bh=BqECl176v/Gtm4B/mzO5FafL5ayJtu8vuAS8DstIHt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ackzN8S4TilD5vFekTEVuCAYvK7gbw8zOcoPtu6gHoQqVZzuTXrarp4DKReCI/WrYuG5n2HHfzVnmHRxZuk8QeDr/mVytAkkHLu6/1EzOzYunNzUopPp4Fi08oIIJOq5PusLBKne+6vinWKSKbkBYttoxAYSXP4CVrxK09xpaCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=wkgRFAWJ; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8112c7d196eso507078285a.3
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973287; x=1758578087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ombFoMObEj+Bm9MTRqLdHT2Je2br1eQyhTzkCsJmqpw=;
        b=wkgRFAWJjsJSJH24b37yWvt6LwhdJQpCJ8TDGzLgrAydW/UkLBqb2K30LglT6QnPIh
         DGOPwmj0DTVoUJgRETxdM+afz3m1h6woyOtOB+STjjfH4yELMA9H9ZXxw0OqwVn1yzla
         of2ywrj0gioFe4UP2ZhY75/CSokTzSvtniptEcq4Q25e7zONgQ5EFw/BlKTNxRr/7H/f
         YdTkrLWHbKJiOMo5PK3p+nMgkPKnEbmN02r7AI1XAoPgMZr+Vb340kfGImIL6obi7iTD
         GR0WziYOolGcOPN1jv29R+X4On5xVuNej4Be1jp35V/oTutidpIeiUS9R8IOdqhOzVif
         Nbhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973287; x=1758578087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ombFoMObEj+Bm9MTRqLdHT2Je2br1eQyhTzkCsJmqpw=;
        b=TFW+2446OfFvcWLFpoSjaV9U4060utER2fOqmSy4Z/68haKaDV8NqLtjPTUy6qwoM/
         dboxawx82Y/ktbExUBDEgiOUqcI76mYIzZZ0KZ2tw3w68hT9kJW0+kysznnMApaqie0g
         t3En6vYmkRzPZ1FHKhvkiAbpReImYLn62YGiRvYXV6EOb2wNkBjTgKNIlx0lYemrBIF1
         XNA/2PM6jgdGrr5OrTlC15txi7r1/N6xqF0hmmTynfzgWqNZwXUOitEuGNm9mwA57DMt
         ZK9AzbYjYNGfnRZaa8TfJhIU0cRBccppmXW1mK+6Xp5/2gXkN8a9dk5KIZbrV7kVZsYz
         d02w==
X-Gm-Message-State: AOJu0YzAxVLVhWMy59V1y9qCeIwmSXAumxbWktItlNRAr6D1Q8AEBuTd
	yn+Awsb2BSoyehBfBijG1lgy+qT+8Tovx7p9h2T3+f0WpIrnaYzoMu1GtevCN/DmGT/EIBIGekF
	3vwv2
X-Gm-Gg: ASbGncvGBIEUwmcoL2wJWmpdv6lZ5EBOHT+0YHftF4ObWSOWxcPc1KOrL2aMFyFSqBQ
	8/FyAqiic6E5KEjGlLGscuJDUJyt/JDSchquBkasIvilk3YaLNU/izcm3pRNvU4cE9OrHXcG1BQ
	VO918/6mcwiYx5Pi7mQPQYYoJRMH9rwyXMSL4bAFSTclJoYy3ITLY70E+Fxm0429/H6EeNiUHWB
	b4TWzB71Dab+AXHNF0F3J1PPGjx4CQuzlmdHjcPE2bQjlPjP2KOeClWbjvaZnsq4ontGP1ImC8J
	OYdVQKm3tZrBTY7/nPDPclzFzMNgiR2VgOReZF4VBPnO6f2BK9/XpPGTd4/P6cbkBbFHXEwGB+C
	IZUmljuLavM8wILoLzJ++jua2bHV+AcciJlrykAtTQ6+Kr5Jo7hvPsNZ1+b2pBpXgosHfxg94eO
	IftzT/ZAJD1cYxEC2zNA==
X-Google-Smtp-Source: AGHT+IEuqGdoGYF5m+yzcc+prlAqTqhfn1vJxl4k2UEJlpzW4xTYt2Bva1hztcSng6jqi/2eVt6xsQ==
X-Received: by 2002:a05:620a:319a:b0:7e7:fc32:f07f with SMTP id af79cd13be357-823fd4191fbmr1919575285a.22.1757973287213;
        Mon, 15 Sep 2025 14:54:47 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:46 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
Date: Mon, 15 Sep 2025 23:54:28 +0200
Message-ID: <20250915215432.362444-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of [1], trying to enhance backtraces involving leaf
functions.

This version fixes backtraces on ARM and ARM64 as well, as ARM currently
fails hard for leaf functions lacking a proper stack frame setup, making
it dereference invalid pointers. ARM64 just skips frames, much like x86
does.

v2 fixes this by introducing the concept of "late CFLAGS" that get
evaluated in the top-level Makefile once all other optional flags have
been added to $(CFLAGS), which is needed for x86's version at least.

Please apply!

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20250724181759.1974692-1-minipli@grsecurity.net/

Mathias Krause (4):
  Makefile: Provide a concept of late CFLAGS
  x86: Better backtraces for leaf functions
  arm64: Better backtraces for leaf functions
  arm: Fix backtraces involving leaf functions

 Makefile            |  4 ++++
 arm/Makefile.arm    |  8 ++++++++
 arm/Makefile.arm64  |  6 ++++++
 x86/Makefile.common | 11 +++++++++++
 lib/arm/stack.c     | 18 ++++++++++++++++--
 5 files changed, 45 insertions(+), 2 deletions(-)

-- 
2.47.3


