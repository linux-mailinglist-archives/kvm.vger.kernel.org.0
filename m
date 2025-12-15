Return-Path: <kvm+bounces-65983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 457C4CBEC7F
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:56:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A16543002509
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE7D30BB8D;
	Mon, 15 Dec 2025 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y02Vn52d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F277430CDBD
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814151; cv=none; b=RcNcdKKMoQdOqeg00kK0kYQ9JqLPwzL1c9lmH+SlG7Jk244By9bR41WbZtTuI91rVdSVUHXZsHtZL0uOpz4bHu0hhBhoVXSFDdEp16ERugii+X9Ov60eP4n3KT6QX7wN4ULnY8nYDeudlVRFCZ+IsmUVFFqlstK+GHCgiA1/U+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814151; c=relaxed/simple;
	bh=RV/SRDs2NYKR4bNyg9iD41K74i8IniewHpHDgBIC6Q4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=urxdABnYTEASGMcoAuVfDFy+8lpy6Wnu26LobNcirQrRZvoai6jtPzLvV4TvKmX5aqBxg9AmPNEaJik0af+JZ+sGmMcLE00umB8kLociALNEL0v4elPcaspSTsPUgFcvPn3dhexB8Kmj49aYfNV/EPsyG5e+WEKnJBTOr4m5Rmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y02Vn52d; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430f433419aso1338259f8f.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 07:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765814147; x=1766418947; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ozb3WNjr0r/hE1f6GMZd7Idc+wYYTjRgIGjeMMU1tjI=;
        b=Y02Vn52drrA3LCaJu+35xdXnyFtYN0eWTRTHW8q8RbVY3DOU+wlk2UjHh6E8w7bKjd
         ZLvHBuBRHiAVzRzJ8UF5bU9RGPdmbhxsZUCul6B3zOMYfEXv/+gyhyWIalkWDyk8DUCG
         Z+6mvQFhHOSXfZhMT3pfG8Bvv6iCYG1rURkFSMtZZHz0Wc+h6ZzL2ZLwppwXrCKNtamR
         CIbomJXz1aq839sZscD7XwSgyoA3VhknPogQeZPEsLtpIAqFJAqpykfsHNXHsu4AyCnM
         2S7qqfjwfFTODThCtnOyG8xigYL7Y/gCtMVo5fUF5IajK6TlOM4KcNqqpEW6/HjsnS0I
         QXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765814147; x=1766418947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozb3WNjr0r/hE1f6GMZd7Idc+wYYTjRgIGjeMMU1tjI=;
        b=xU16Bbh/ftHlR5mUlBgvJoSQc8QxVC7IazPETVRkHggYCll6AZswa1Tt3H9/faMXx4
         I8KEVMZUnEgRyzgTB+fNDCik78Z67XUBGpyuLyQgPyyn0XMQSgAX0r8fZOFUf8pTIU/R
         N1Vq1nbiUL/h4EIIUzbHn5A3/UcguLwvD/Us3hz4e3cGtJkAOaLI0oXGWoy3Cn1uln2Y
         LArYRlIQDbcWDlcyNc/oltP1f3eNNphFfrFvf8fMxsrRoZeXa6Izka2ecziM9NF+Qpa5
         J2u7CGkhyQhcmk+lehnCWhNOUDRXmqBL9ppuNBqcdB9qAEtRHQ+0yprzkrWKtgZ9CaOf
         JH0A==
X-Gm-Message-State: AOJu0YxD3TfpjrEHj5YVhyZwfcL7eREbqlqHXnTFnUQmWezEriDJ5nUw
	njIBnwsodjpnyqCnL6jVHqNzraBU+TS5hDhaCe5gCRFh7I3UqEuvRMYYQO45Pm+QyEvLrbUlwji
	GaJFfIc5oKI1CVp/D7rnfAK9Cj5MdQpicGN1shvpTptm2w0oX2Kusis2bp1MJ902orernTKX8aT
	Ta5IhvK2HC8mRipVw4vPKakKCNXyU=
X-Google-Smtp-Source: AGHT+IEA3qzwHHfgsxMrJtwJjrbKjzJPwpmzlnx20u2uHp1w/Y/C+4dLQqaNvlIkM5w1MLH3+iZmaCYi9Q==
X-Received: from wmpy17.prod.google.com ([2002:a05:600c:3411:b0:477:4a46:9980])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f09:b0:477:fad:acd9
 with SMTP id 5b1f17b1804b1-47a8f916685mr100374585e9.34.1765814147228; Mon, 15
 Dec 2025 07:55:47 -0800 (PST)
Date: Mon, 15 Dec 2025 15:55:40 +0000
In-Reply-To: <20251215155542.3195173-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215155542.3195173-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215155542.3195173-4-tabba@google.com>
Subject: [PATCH v1 3/5] KVM: riscv: selftests: Fix incorrect rounding in page_align()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The implementation of `page_align()` in `processor.c` calculates
alignment incorrectly for values that are already aligned. Specifically,
`(v + vm->page_size) & ~(vm->page_size - 1)` aligns to the *next* page
boundary even if `v` is already page-aligned, potentially wasting a page
of memory.

Fix the calculation to use standard alignment logic: `(v + vm->page_size
- 1) & ~(vm->page_size - 1)`.

Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V 64-bit")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 2eac7d4b59e9..d5e8747b5e69 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -28,7 +28,7 @@ bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
 
 static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 {
-	return (v + vm->page_size) & ~(vm->page_size - 1);
+	return (v + vm->page_size - 1) & ~(vm->page_size - 1);
 }
 
 static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
-- 
2.52.0.239.gd5f0c6e74e-goog


