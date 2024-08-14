Return-Path: <kvm+bounces-24209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD6C9525E2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:41:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C9EBB23334
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3798814B943;
	Wed, 14 Aug 2024 22:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L0KrXUCG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3D9143888
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 22:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723675298; cv=none; b=Vjo9B/m6X9ZibEUReQomE69NRACMxDC77seCuwqsxUZgP5+kGrKgYE87rz0NHe39qBo0+6za+M1BsiDiIVGYu7HBTK0SELd1mEgXOdvtCfCDqJFKK5vUuS0vrd0G1gTVo9+qUKg219mekrDDjHuPilQTtmS4sKL6WduQdE3SmnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723675298; c=relaxed/simple;
	bh=oB+G2UEAbc1t795N4yrQsp1YwdgDPfSLGPbedzTOb9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=IZZ/JRsr06qTcWXRyQU4gPVERzXv2MOP9RHLjmNv6mDpblIW8avENwi4AZzqoqBrUTInd7ma1q1FupG9G6KPQV82KA4PcZam7ml85UC0hkmi6ZEDERyy5JtRztmzduWxc4QBGS9DLAF2Lx/qoflGqHsC+Pyd4yiBDbTRMf83G6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L0KrXUCG; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fd69e44596so2492215ad.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723675296; x=1724280096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+CPT1Wcm5Loouzy0QjXsIcxjBTGx2lwMSs6X8Aj1VVY=;
        b=L0KrXUCGup0m/hsL2187stoOoqYeDYOl3HbOx4i9AS2jT2dRheQGa8PFTJhTAq8t2Y
         1DyOHOHWSqbESacx5sUTsSvU6XDb1e7/iw0P5g7VaiWsQnyTjnZ3UTyVEBAHY9v/qHEQ
         YOTu8bIJf0ltSevCsNLV04KF8MpKU4Zc3Fm9Un/5OXlLedt83vEM9oLG+vO/N2MxE4E9
         my4qe0e/KKUn95VfA+FJJLcSfEQVkqe0mcz52tpr4/rtu5Nx5hY1h4ca2vhXwiPTlubX
         XCVVGZgb2lvJfFqDfRkwlBXHm1bhmBS/ob+8tp5KqxytcwBlSKpPP+vbta8HlYeyejDE
         Ry2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723675296; x=1724280096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+CPT1Wcm5Loouzy0QjXsIcxjBTGx2lwMSs6X8Aj1VVY=;
        b=kRiwl/LMLNOsBBp42jlIG0iNpbkTFRU9886x4wpIddPBuMAVzdU6fQ5tuU1nl4Lrgc
         FqsYTX2k/W7v1ROsp8yV3xJcsiBvUXEB3E5dBz8WTMJQUAADT6ek+edBwtCfobF1CAFR
         IQuYpsCrmnnWxwQqVlXddWhf8ZonxNhBktIrbedc0xV0yY7RYiUoFitEoaRc0warDYMd
         ddOymA+EacO7ObfXlBT0vTtMBKFb3ZtIL2vfobT+ggiWzCjYBPuMuZdQUX5ApAIuwBzd
         VT9/fnGx9gx2y2uoAbLE5tWFh18xZKROiwTHy/e3/UfSjJXQcJ3lfOQOtlss/+U/4X+q
         ujLw==
X-Forwarded-Encrypted: i=1; AJvYcCUxv+FySX0QkhZDEZ1FgvpTqrS46gIIi7Y+DRpwKhxQt5rgiFH5sNpMraiUz7Je4fp8yFq4RzMeTnhBqUN8luKlBn/B
X-Gm-Message-State: AOJu0YzcagcKwiC2sW/gJkEBqQirEVYAK7SgqZkSzMPFeJfsewoY8TDH
	7VI1di1eJ6o8VmtvQsdjKVWBtMDO7SoKqWYXFwEge18fYyf4a6eZczjjGEyFbcA=
X-Google-Smtp-Source: AGHT+IG7gxkJQzoz85Nl6gIYhEFIhQRnI1kEpARmF/7Y+15rka8ekLMz3X97T1LAnWwofpIENpZv6g==
X-Received: by 2002:a17:902:f64d:b0:1fb:8e29:621f with SMTP id d9443c01a7336-201ee4bc33cmr19854555ad.16.1723675295973;
        Wed, 14 Aug 2024 15:41:35 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00:5b09:8db7:b002:cf61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03b2874sm1225595ad.308.2024.08.14.15.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 15:41:35 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 0/4] build qemu with gcc and tsan
Date: Wed, 14 Aug 2024 15:41:28 -0700
Message-Id: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

While working on a concurrency bug, I gave a try to tsan builds for QEMU. I
noticed it didn't build out of the box with recent gcc, so I fixed compilation.
In more, updated documentation to explain how to build a sanitized glib to avoid
false positives related to glib synchronisation primitives.

v2
--

- forgot to signoff commits

Pierrick Bouvier (4):
  meson: hide tsan related warnings
  target/i386: fix build warning (gcc-12 -fsanitize=thread)
  target/s390x: fix build warning (gcc-12 -fsanitize=thread)
  docs/devel: update tsan build documentation

 docs/devel/testing.rst       | 26 ++++++++++++++++++++++----
 meson.build                  | 10 +++++++++-
 target/i386/kvm/kvm.c        |  4 ++--
 target/s390x/tcg/translate.c |  1 -
 4 files changed, 33 insertions(+), 8 deletions(-)

-- 
2.39.2


