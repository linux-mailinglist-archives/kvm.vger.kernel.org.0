Return-Path: <kvm+bounces-40672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8064A59998
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:17:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0041A3AB5C9
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A4E231A24;
	Mon, 10 Mar 2025 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Nvg/ZGFq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC6822DF8A
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619670; cv=none; b=AOJuufRCauhepS6grzFPFAHgDXURWw05VF8ghr5cB95AURh+uePIDm9ms/TEAPW/0B8fdlK8NgrOpV6QGdtsMwBLZc1qe2Ag0t4dFq1m8Rs1rro/qRoPOfkOWSn/Qj8oGrrvHrzbg50VG41aiIPIWyf0hDdlO1KMjNrK1fWZrnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619670; c=relaxed/simple;
	bh=4ctq2Y9j6Ai2zXepSDGwSaGD5sKanUbwQl6UjhiXbqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgJbkZdKHGnBtFG/DeNWb5WlrUsO7lM8sBUY0MXFTzWiP1XAxVdBz9SYASkEqcEpaLBCp8oMpR4/A+XggiWOerNQfw3X02ipo5s1lI6/yMhM1ZoNmbA8idhTFGFF/HhIY9lRAfhqDDSu9mEagmMeMCe0oPdmGSTqvh9il+s+C+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Nvg/ZGFq; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22403cbb47fso82381295ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741619668; x=1742224468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZ6ZtCFLM2HDQCXfIF+4ZGwXAoERFl4mcxOr8+ok9D4=;
        b=Nvg/ZGFqrNZtscVsbTYfAORJvCoMPMZJNwv92/JsMTCYz+mOxmmnQzUHnWJyUE/D08
         WvTXFpKackj8JbpaDjjdHXcXBAPEw0Krm81RTLUSvpESA7PURwp/oOqooMrcj7g2nJNO
         I5Yo+ATYJUBXbDeKfsxB+jdXwADm60moLf2ySHWDU3mIWK7tj3lznTKEvV5yAlXa2CPn
         fI7rZswSfoFmBmDwsIc/rt8ei3COabFx0FwCoVD6V3Y78Y7XyL1KJNsg00lG26NsL3Bq
         uzKJgZl5TzJMDD3cut2mPIcFLW9HBPsdffI6M/vm/m85BW5NlxwKJ3cyQSQTLr4tHtKD
         0U/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619668; x=1742224468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZ6ZtCFLM2HDQCXfIF+4ZGwXAoERFl4mcxOr8+ok9D4=;
        b=PIEZGbnzrdpTX+liaGgypNvA8RtXrZgisT3WG9wSJXEVeBSKKsSgzz+GwltGZE7Y37
         +4PhEbbiJTRAQRZNaFzjYKt3F1jsN2TX9FvZxhMqCty1zuRhgZFROsUte35+IjOQJxnR
         cgWtKVethvPRC76shB6/Ee85DiNXoWm+iuRtVQyAaiv00pOQo/aaOfSjIYZl29Pf87AJ
         AVxLQUh/hBzkA8T8XqEdEVUFH3cqnN8Oz4Ppr8K0cGHzPFw0s+bKsXIfH7Ek8hfcD+Nw
         QBF8SlLK+aWPbSH1jPrKBFNGsrvl6l8DdwzHQ9kLNOuNJtHd8hCxZT2p1nAG4/aM5O2Z
         WDwg==
X-Forwarded-Encrypted: i=1; AJvYcCWoE/KSeFgq+G03ySneRLLYwmB+NyAqfpzCGMdioEYZy2N/2129lC8jKC9sShGhnZGChOs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMhQj+9dvUuujBU9Vo6MhM8LlgIJlTst3jNPk7iA/De882/bAi
	y4aBECDTTpZOyBI+wP4C+5Ezny2cJrKaog7j2ceK7ygQwRN4IlcuNsv1tgq4ql0=
X-Gm-Gg: ASbGncv8z+PhEqprB+BcGhN58+cwUNAYp+Ku0UIxURM2LzXA1mgwoz++rT8AN3eEZXh
	SfaG3HO7S/j1nPHvKLZKEUg4RmB62iqycfPHZQovBkP22T8rPVzhOfPj9RPrbFacQZpCGdzYAlg
	hWsvk0eIyUZIvTZw1fW7uzy8XlMmslJrRnHIm6gjDLD1lFyY72d6c/4Seu/xjPaG6z01lD6cjTF
	+lLdg75R5Kw26eKnuw/PdSvRJ6y9zc1b+sY0wCVtQxo1zRSfoMPCqmsRtoA5iscyXFwepeDFutr
	SJcACyH+WZluMLXJIt0Um37bTmWG1bCeD/0J0Dr9bEYXmQ==
X-Google-Smtp-Source: AGHT+IFtA7ejSY4XIE1Y8FAoh6UcQJS/Qm4jl+kbYc+4FdTVNJHdwGd9aRrsWNeD8S620FnvoI8t0w==
X-Received: by 2002:a17:902:eb81:b0:223:5ca1:3b0b with SMTP id d9443c01a7336-22428bd592amr282068535ad.40.1741619667997;
        Mon, 10 Mar 2025 08:14:27 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e99dfsm79230515ad.91.2025.03.10.08.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:14:27 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 12/17] Documentation/sysctl: add riscv to unaligned-trap supported archs
Date: Mon, 10 Mar 2025 16:12:19 +0100
Message-ID: <20250310151229.2365992-13-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250310151229.2365992-1-cleger@rivosinc.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

riscv supports the "unaligned-trap" sysctl variable, add it to the list
of supported architectures.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index a43b78b4b646..ce3f0dd3666e 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1584,8 +1584,8 @@ unaligned-trap
 
 On architectures where unaligned accesses cause traps, and where this
 feature is supported (``CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW``; currently,
-``arc``, ``parisc`` and ``loongarch``), controls whether unaligned traps
-are caught and emulated (instead of failing).
+``arc``, ``parisc``, ``loongarch`` and ``riscv``), controls whether unaligned
+traps are caught and emulated (instead of failing).
 
 = ========================================================
 0 Do not emulate unaligned accesses.
-- 
2.47.2


