Return-Path: <kvm+bounces-56442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E787B3E4E3
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:27:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 176AA16A982
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2C6322751;
	Mon,  1 Sep 2025 13:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hwfEIfwL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E7A2FFDDA
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 13:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756733192; cv=none; b=IFIfyywb3h516im6jmpiOjomqTMxT1TsrmETIsrbyo3lsVICuY8jsh03c53NPOOpLkpK/sNLYV635u+YQF9NH+E6taDwBQBo/NlT5QAXxH0jA8vHajVDyULgre3/0vgiouiW4vDy5/yXM54wleMPNPNaS0GrlNGkFJciiuy5VoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756733192; c=relaxed/simple;
	bh=4G7VCowQgnpa73GrSbdxFo/EFrOsy6Q84wFnpyATMQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=s0LN+aUK0ymVt7aVJAnRX5cY6ys9S+J4kzRS4sE8VuSSdBcyI1HgzutD4ruQP+CSek6SiDjqweBdeIdBNDSYtTLhZtR5klUU8V7DZAIjFk2jSfUHpMEPtSLc6Zg3Gqr07z2FTJ7F0luJOKpNotDxkndGNevCkBKaCXXpghAJ3K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hwfEIfwL; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3d965477dc0so1531f8f.2
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 06:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756733189; x=1757337989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vMiNyuN8vCGx4gQ6SgirNIsSrqkqFDJsdJQQNQ3ScD8=;
        b=hwfEIfwLbE9ysIlP9t9YwLZT3NcHSaZr5rJQSxHwmnoiYTIv27HhERUTa/SLr6iXv7
         odxfKLbvuKvtyFwNOCz7xAQK0seLcjTKFYGnUsMbdfumwzup0clfrCDnoFY1c4ksUoNZ
         13+5U1BkrU0w7IYX7qYo/IxMOHSjrcGYIkhYzJDbTlfIkN6Qlly/9evBe1/gq155m/4b
         0tiXbWviXF3S9d/sb9U+Ve1uvTX6DPyVNlXKhm6ILXvIPUvZDnBZ8zIDUQlXtrC3/mMU
         35lL+fgzqB11hPnxZViVglb1kEQlYhF/r67tDeTsaAlFWR2ys+6R8zP40gG3ivCaDgEn
         fWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756733189; x=1757337989;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vMiNyuN8vCGx4gQ6SgirNIsSrqkqFDJsdJQQNQ3ScD8=;
        b=dfEQFWrwe1RS5gG48An3EP8tcQkOJaUwFCv65pNnHCrYKA5hMGk/ZTJUqcl9UYrvRR
         dFcoI3phfyFF2qp/zy6A1kMfPgFQIT6z7xStA+VFMNLF70AKCk3vbeKpMzmbeRPpUA4E
         tpmARpgANno1gas3Rv7bImbf8PSLWBmbCaWwGdxQhnPmsNWK/fegRxK0QlBN2PIMx6yM
         ceQMQDh3vmtSe3FJbWX93hGQ9jd6ePZO4/ZxooDg7ITtYsCtW/56QbcQD6gFpa8bQiUh
         TIfPoEUdCbO968WE8rEDLXNhxv9OcCjM7u3OnyAJdWaW2JlQcPdPgRwzCfrILyPgPlKx
         ZY5g==
X-Forwarded-Encrypted: i=1; AJvYcCXbP5PW5sD8VS6uTdMTPkSyBJDAy09Eewd5Ym4Zij+M985T/vFpoSkYcZQ3eLF94tr2610=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmrbhe6vwd2CRXuovBgu6V9G+PlOvnYXrLj9AhgLto5s+pSDnJ
	uxJgtuJt1GiZqj3qHfIqmGTFEKC63TiIGTnNNA9a4Xkm2nv77ifU1rK84x1Oyl47rtM=
X-Gm-Gg: ASbGncttrbq4GxuNVHTFlZJCFC02fITHziReH2dVVxesJlYDtmNZmaKm59A6ZgPkSgu
	5f9KFsppMtTXPIMh0lDT45QIsL2a9SI5GXanQS2AkMRF7sWga0g82mRzm8fyF/7n1zomxLwnXig
	0YN1q6LQB0HPr9CYUXwoaYV1tOhU2yCFVnFRkOWT+JzLMC4u486E+NnrfeNjKBPo9BJqNjYrFTN
	qFcv+BN+M49afXrZGBecEGqK7gKWNUm66cNqE1TC9vf9pq4R32x5lCv+jy5SQs+IhmBWtguP4IJ
	ZjyRvFGO4t1SoAH5c4qh60t10cYQfbV/CrFYCdTaSvPwfp8KqH3ZeFnjCzBU4Aa06sH3GzIlKEF
	m0xswP4JM8o02joVOgT/6//tOj/uBLsGM1LUppTnPvonaUxJmimpLNFYeRSKNkQCtepugUKnY
X-Google-Smtp-Source: AGHT+IGvMZjAB7w3flVb9fpv8Ycj4IjlLC96zH/J1Wz7eo4dvSyKyjK/lO7Gxvgzr6WwfpI7VugvTQ==
X-Received: by 2002:a05:6000:218a:b0:3d2:aadc:296 with SMTP id ffacd0b85a97d-3d2aadc060bmr3196475f8f.16.1756733188895;
        Mon, 01 Sep 2025 06:26:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0a1f807f9sm14484129f8f.38.2025.09.01.06.26.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 01 Sep 2025 06:26:28 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	kvm@vger.kernel.org,
	Glenn Miles <milesg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 0/3] system: Forbid alloca()
Date: Mon,  1 Sep 2025 15:26:23 +0200
Message-ID: <20250901132626.28639-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Eradicate alloca() uses on system code, then enable
-Walloca to prevent new ones to creep back in.

Since v1:
- Convert KVM/PPC (Peter)
- Update doc (Alex)

Philippe Mathieu-Daudé (3):
  target/ppc/kvm: Avoid using alloca()
  buildsys: Prohibit alloca() use on system code
  docs/devel/style: Mention alloca() family API is forbidden

 docs/devel/style.rst | 4 ++--
 meson.build          | 4 ++++
 target/ppc/kvm.c     | 3 +--
 3 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.51.0


