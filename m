Return-Path: <kvm+bounces-41295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B723A65CC2
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4B0919A10C0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E2F1EB5C0;
	Mon, 17 Mar 2025 18:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H3Eyq5vP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CAD1E833A
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236476; cv=none; b=e9kRMfGKTHMgYa2yd9Rz1f+gA9CLUVFOjSUvy0bRjoJqOR6jdL79eI9BovuvpvKUbWX0VRP1uzYj+nrpoxIJ97VTLxaUIy+flSAujAaDdfACDT1n3BfuuCW2eFON3QsqMc/mjUPtq6cAmI9m8QsPLg3hvrG4CyptUzMdk4Iua4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236476; c=relaxed/simple;
	bh=072rJgb1v8WTOR3ndNWM1YDjHaA2UGkZkEMRddxYphA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TmlmxRrHhkt0omBc8I2yhT+RrG+vfBKomUVMlswCLW2soSafYb9/GLpevFrIutl9dRH2K4nKcJVvNvfAVN7ALXcReafLd0tfdSq/RacTGyTiVjIZ6051FJCLSchOZgWwaU+ewYNz99KMv+ljCWe4I+yPVwq9c+I4Of2lA8byFes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H3Eyq5vP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-223594b3c6dso98913805ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236474; x=1742841274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rp8GQC6vA5rTxSSazblnkjuLZPjrJAYUOFg9uGM493s=;
        b=H3Eyq5vP2hRLGSY3hkwVPk0vXSziMAxE1SL4RI5DJljGWECpWWml193s6mh6cnxFW/
         3h4jESg7aGlyLM+GZfHOEUOh+73hiXIhFQy5VzREAggVbnN/Yde9ClT5QplnQsUxdoZg
         Nnt5YKWaFw5RB8LPqU8BNILCE9xNnM/hWOkJxmlTrROD7xFsfgPRtHkv9pwTopw/Yqbe
         mE6SDLF439cYnXCTOctMse3ApYQw6c+LIgnInihQRFu1hBeEZp0oIP8py3iFhqP1ViB0
         OOTK9XvVZs+fGXmGjhfOjC9gdBjVqcW75+MsTg9wVaqkyN2UgxlGv9VtN9/GChj4fsE1
         R6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236474; x=1742841274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rp8GQC6vA5rTxSSazblnkjuLZPjrJAYUOFg9uGM493s=;
        b=hEIiR9T7Oftz5rMgUV3wPLlCHqceTsY2BOwsTjDnMpgb59JVAASDc0rHJCHfEj3CBk
         qC2eNOKSv/TuJUm+EyZKuT7x1SzCAM9X1ER1u0m0Iq9dOoWGjiA58Aomtd7vU8ZGCEbH
         YX51kHAqu2gNW71JtaipxtY37NQFKNqr2XUhAKNGpazA959XLx0D3Za7cjqTnkGac8S3
         Cnovu89D2BdJSH9WPqzaQNosDF5L6MW5Qcyja8EtjiFRac9SO5omOyKOcpQniLdvztHC
         ePZY9nPg0Tro6Rd63pgoZKD1L9gGP2JI2M8UKUlDH54BNZ/1Gjj2VcqB/oKGZhiA1c0Z
         xCNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrTZ7RmPx4lG4XS00bUqo119GLsw8FVXQxnGb8x3tpPpQ619T2vSAMOYpDs47ErmQ+dGk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0DjgXWWDM30wSaULCyDmbtNyyySjranSIxjlKA0LKFbF9Bqr2
	fknRvtZYoe1jKHp9JAsxCWw3nfcG0EGrjTYqYGWe4FKvhzJsDjOeubKbI+pjM40=
X-Gm-Gg: ASbGncvkbmK1+lmNEvrZOrVGNTzg/Bq5Gic5ISIYyQXnefOG0L5uwEVlewrx3xkXCpv
	Du9zzynZ9c4YwwtbgUsdhyhvvSp8mLxLt8wOkuFzmlvt1FjeAxiCacpqGI2WBZM3s8XLavfc0k0
	cPNo2BInuYQx2uKRs6oUJN+bqeE++Yf9vhqBlJxBXBtA2kERuQqdVw0BGMsQ/PD2oD5QonR496W
	UyIy6Bb1fyCaXl3Q6QDolHsiDvc4TSfoDvLWTtNvJAv/51fnIJhSvewM5Mw+Rk8wSMQrd2+ggF+
	xOniDkwv3/IuEbWA1svyd7vRNLNJ3whq/l5AjujO//P/
X-Google-Smtp-Source: AGHT+IHGRjUHfsZhtfemIo+dlcyT/9a20csro4vrsnSjWHRpRL87+9vnxPcq6naL2TxBdu+3gDVtPg==
X-Received: by 2002:a05:6a00:9a7:b0:736:6ac4:d204 with SMTP id d2e1a72fcca58-73722375218mr14371340b3a.11.1742236473962;
        Mon, 17 Mar 2025 11:34:33 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:33 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 08/18] exec/memory-internal: remove dependency on cpu.h
Date: Mon, 17 Mar 2025 11:34:07 -0700
Message-Id: <20250317183417.285700-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed so compilation units including it can be common.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory-internal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/exec/memory-internal.h b/include/exec/memory-internal.h
index 100c1237ac2..b729f3b25ad 100644
--- a/include/exec/memory-internal.h
+++ b/include/exec/memory-internal.h
@@ -20,8 +20,6 @@
 #ifndef MEMORY_INTERNAL_H
 #define MEMORY_INTERNAL_H
 
-#include "cpu.h"
-
 #ifndef CONFIG_USER_ONLY
 static inline AddressSpaceDispatch *flatview_to_dispatch(FlatView *fv)
 {
-- 
2.39.5


