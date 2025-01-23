Return-Path: <kvm+bounces-36406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35455A1A82F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:54:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77CB1160F30
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2224146D76;
	Thu, 23 Jan 2025 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="A2M2m72X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7427B13FD86
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 16:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737651257; cv=none; b=HtJTYztY6G1OsTqjm5jbjlDkhqrZJof6DWJe2tx4D2LcP/z7cMhGRk6WnnL3N5SSTP9EHVhwIeqHW34qaApOdA9FcU2NGlWFex3O5npqLxtKTtoVzE/JDTmM8jxE0duyZFNDxW4GbHd9V5/JGarftB486PGW4B1Q687+DZq6tCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737651257; c=relaxed/simple;
	bh=QbD/cWDozB8ERAq2C1OP91Kk8aaQpn/iFz7lmkacQfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LhqA75ylLCY+0rM9IuIfbhwcsVzKR/qrNS8IG3Tvfcah0G2iQ3hp6TetfC1goLc8MSUbPjtv4325gJk7YjOAQvHOSdy/yshh3gdcrcRhifv5PngN0npSrr5zHHOMtBlL2M/Uzop2yrbeKEADHxokmB9mMWDxGgdHkMgRlTHXy2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=A2M2m72X; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-38637614567so574333f8f.3
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 08:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737651252; x=1738256052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JXuUoPlSKwj4vRfcS596K9iAUYTTPfvaMQ+EuE7oBlI=;
        b=A2M2m72XY5kPKmOhffMJyWobzY8mbOaKT1MH4z5el+kM6RAv7vAgvN5aZNrAvS0y8Q
         qDTgmABr/BDancIgHLxuo5akanDEy6d7iCjg64jNhYBV+7MVL5Zw8tXMIKGu+cPZ4h4Z
         nAWwu2dvlucvNuOIOdE7z9oyV0iRqKuHdG/tH3P+2GhlQhvZsl71LZqiqgAf7YrVt6CN
         gl7fCEn17Tr/aP3jvx64mfjHZyCo+HGs3HS2Q45YOpm0Ao1eLY9TZ9WFp2re82VKsHly
         YJY/+AfoSyLNElDIwAY+Cuu7liEZKFbY+pOVMrfZF/9nFt/qjuA6PPCnkIaMykzPLs5W
         Z5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737651252; x=1738256052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JXuUoPlSKwj4vRfcS596K9iAUYTTPfvaMQ+EuE7oBlI=;
        b=hfC57q+4mDKoS6djHa+cAm4Eos1bfPf620GZ/2K3wUuwNsYIrMz0RPa0N9turNSjh4
         9HDMKG+TGvATnxEfQPBlho6+1y/Obj6ipJp237G5iUJg1p4vauhNM2n73LQt0MSgA3sv
         bjhlbRB6WKT5MKWNvxMN9XTAvKgXyyAqyAfwSzWUiNDgmzQPbWSSAerttnxx+6sZojrz
         w1cJOnou+3XPtqeU+NXzDum/SKglWd/UKat5DG1HyZfqN78leuYPfGAyU9fJdXWGSUWK
         iiQ3BQcWzqCxKN/xKcGq9vnLrzqJ3feR7t9i7r1+l1Y1mV0Ra+3cMsK65pKm7zvBtoOd
         sBBQ==
X-Gm-Message-State: AOJu0YxqWb2YigIhkJQew8sp/jL7xqBqssKT+0TUuwRrbvf3VxyjAdka
	RZ1ZFH/mL+yUIDHXQynIQLRBrYx2MzkuB2AmmtI8TYPOmze92V5dtsRxFRXSw3zRZwtWWC7HWZD
	t
X-Gm-Gg: ASbGncvWhfzPACrYlnHHAiCSRFe61PLbmlpOQugfJdjk/QaNsR3mDvl3RMkYafdSbQ/
	qpVReYQPHerr/OwQyoJ7JJG4bO5UX+WYwcCozyQeGM6xvnzh1UNFzyKC6ICOqkGRmOjHZuHzxm0
	a7TqIpA1ScSmyyhjXe+3QIUEaTLppYJ/GgiSKz/RGeURLBispYAFFiicBfQzjWvPF3knrmb3VLX
	RMv74nMufDNetophw2PMUA2MOJ/GDqNSypfRzdriUc/18BTEmW0Qpuw4if57MuAsY6Egr49MPcp
	/f/9RQ==
X-Google-Smtp-Source: AGHT+IHfTK2dRn/lHoUSyZlpKK7dtzi3zFTmTAjS6WsgKZ2Vs9gZrPu3tgke91iDNBBpCfjqf99L0Q==
X-Received: by 2002:a05:6000:1a8b:b0:385:fc00:f5f3 with SMTP id ffacd0b85a97d-38bf565720bmr22236619f8f.4.1737651252025;
        Thu, 23 Jan 2025 08:54:12 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bbc8dsm165695f8f.72.2025.01.23.08.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 08:54:11 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v2 0/2] Add support for SBI FWFT extension testing
Date: Thu, 23 Jan 2025 17:54:02 +0100
Message-ID: <20250123165405.3524478-1-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds a minimal set of tests for the FWFT extension. Reserved
range as well as misaligned exception delegation. A commit coming from
the SSE tests series is also included in this series to add -deps
makefile notation.

---

V2:
 - Added fwft_{get/set}_raw() to test invalid > 32 bits ids
 - Added test for invalid flags/value > 32 bits
 - Added test for lock feature
 - Use and enum for FWFT functions
 - Replace hardcoded 1 << with BIT()
 - Fix fwft_get/set return value
 - Split set/get tests for reserved ranges
 - Added push/pop to arch -c option
 - Remove leftover of manual probing code

Clément Léger (2):
  riscv: Add "-deps" handling for tests
  riscv: Add tests for SBI FWFT extension

 riscv/Makefile      |   8 +-
 lib/riscv/asm/sbi.h |  34 ++++++++
 riscv/sbi-fwft.c    | 189 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c         |   3 +
 4 files changed, 231 insertions(+), 3 deletions(-)
 create mode 100644 riscv/sbi-fwft.c

-- 
2.47.1


