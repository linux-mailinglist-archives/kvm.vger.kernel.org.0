Return-Path: <kvm+bounces-15103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA878A9D0B
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C5801C20978
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D70916C682;
	Thu, 18 Apr 2024 14:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="LrG7d/vu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E568E6A8CA
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450435; cv=none; b=AMassSS1GlPJB3nAEBhj5+0Az/qkZCED7ktDialatvKK1+TqJGVPdlBlimUumU7vlDXvxFC1nu3RSCjwHwrHbeaBjBrTiq/P5WxlY8+ayyL3lnO6Gsf2zQhilUZJivboXXQJyATPdIHVJ/otMSmI22Wt+YHbr5HRdDR/HP2fqEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450435; c=relaxed/simple;
	bh=/TrgVYKlVLS8nP1dLN0vviFu0a5Y9pRo5dVAWIYX6Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FlA7lLclCVg3BYW4gu/4WHMVtj0VFkCUdWfcWcn+Pel6sISc3M6gaxbCwe+yyoCb8N1c42WmWlsQ8sIO1vJZ6487aUE00y+LnmSz/0dd9NlhS25LAHtHUjYcncXJcoYHSstV3SadOHHnrCbhq+TJ3RZ98ZubK6n1BQ+MuAxjzLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=LrG7d/vu; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-349a31b2babso113834f8f.2
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 07:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713450432; x=1714055232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdC41mYpitxeoerTPG3yyRH/m087Cg7WhfTha8ba/eQ=;
        b=LrG7d/vu7DJfKfLLY6FDtrOScYMCSWDlCC8u5mZn4QdKSgyaqr227VZr6N86J3yFhW
         DGGTF8HC1fRlOLETlVsHkfsWFgeGG/E5Ajp7KXItNyQOqUEGtHDiN5tFnPWfwP1r3U2T
         dBHqN9foxuxg9k5bwyYmuA4c3mBcytXS2q93QWCpmnFQls/M9+wN3drND+qN7Ab6NsvJ
         2WaHbRbf9s60OrYEzwo57nb0+8xhEYaMHj2qtOnwlTeCJmJObD03oHywZhjhmCfbjdip
         nYCtySWbB8MsvpHYrqGGYgp/h506EMzEArTeHOkhoUQihnGNquSVi9EVTl98/IncbhtD
         j8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713450432; x=1714055232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdC41mYpitxeoerTPG3yyRH/m087Cg7WhfTha8ba/eQ=;
        b=ahsBx29JqePmMNpm0fq88ug4+6Q+/1nToSVWJ+pM58ly52wcMVHI7PgujH48+gZxzp
         Pty4AQ1zQ0F052rRZ2eOWOMC8rZnvIQOo/qZKQjeNPkN7ArKL/eS/UYnE2rr1MC70c9g
         zunvOARTyQjd6qq12YR3H9o591XKjxHxhcKxy1sIBUxlsa9Ti5CJpO6EpXKoVhl/th7p
         8ZoOithvp2dleqj0hiGWpvKMTWyDnnuEiddxEDxpRGCQKzPs0+pvAKk85DPAyU1JK28H
         8418pziSfDs7Y02vM7JeybdzMzEaBh58KSoyBKh1Am/A6SYtzf33lR2fobmc5frFKH0x
         K1/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+0mfJnaIoBgreAvbnhbNNi9DhxaLaqa54B8oSPN6RtL9vHf4Awce8WSRpVuObG1YMH7OoslDXGalguIJ85voBVt5N
X-Gm-Message-State: AOJu0YzDpkC2vSg1SDQWRgvfTPMnNLZzD9j0oXQHP0dNQXoaqXyGXfSf
	tu4wn65UR5kU2uPwQu1txdRSMcRaZFdm9IzudbZhJHc6+zwbkqRFLuw6sH/fGVA=
X-Google-Smtp-Source: AGHT+IG+7UAmdiY0BoZwG9iLOw0KtSyypeYXnsCe7CYjI2xbi4A4G8xboXK1Q/fcCptfkBlEV51ecg==
X-Received: by 2002:a05:600c:4f51:b0:418:73d1:94e9 with SMTP id m17-20020a05600c4f5100b0041873d194e9mr2017672wmq.4.1713450432345;
        Thu, 18 Apr 2024 07:27:12 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b00418a386c059sm2873645wmo.42.2024.04.18.07.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 07:27:11 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [RFC PATCH 2/7] dt-bindings: riscv: add Ssdbltrp ISA extension description
Date: Thu, 18 Apr 2024 16:26:41 +0200
Message-ID: <20240418142701.1493091-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240418142701.1493091-1-cleger@rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add description for the Ssdbltrp ISA extension which is not yet
ratified.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 63d81dc895e5..ce7021dbb556 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -147,6 +147,12 @@ properties:
             and mode-based filtering as ratified at commit 01d1df0 ("Add ability
             to manually trigger workflow. (#2)") of riscv-count-overflow.
 
+        - const: ssdbltrp
+          description: |
+            The standard Ssdbltrp supervisor-level extension for double trap
+            handling as currently defined by commit e85847b ("Merge pull request
+            #32 from ved-rivos/0415_1 ") of riscv-double-trap.
+
         - const: sstc
           description: |
             The standard Sstc supervisor-level extension for time compare as
-- 
2.43.0


