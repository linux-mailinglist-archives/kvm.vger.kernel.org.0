Return-Path: <kvm+bounces-20855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13F889243AA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 18:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C533428271C
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 16:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A09E1BD510;
	Tue,  2 Jul 2024 16:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J7XzfRmw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94FF1BD039
	for <kvm@vger.kernel.org>; Tue,  2 Jul 2024 16:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719938121; cv=none; b=QCoNZTpNY6bFglKQrQSNn5ZhKwvKs9TWM/vrOgeOtnromQ86PPEnSGwuxW8GzDJyuhaslQ7IpfKwm9rvkLWUs0UWdxwbhEji8dXqoucIosB5oO+DTk6qdMsrgac1i/uw0MtzJhiv7CsgSW0njVsGeI5cReHnjDoKFs31VurIGGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719938121; c=relaxed/simple;
	bh=CUKWW0o9Dr0Un5n5H44DW5lIXnY/PtrZCZss2/OnwG4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=P2vaSzupf/fSSTE/1te26RBWf5/8xcpRIQFRDqLYGv22udI74CaZxihVcdc0vJSN5ykU211nnul7c6nhZyFOqr3xfWwsVFDwXBHMwRMrFR1EQGZwM7g2ElDpC4WDnVk6K+5XoC4CN/lmX+34fEp4kTezFcoh7J7MTv5sjrcom+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J7XzfRmw; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-584ee8da49aso2969627a12.0
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2024 09:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719938118; x=1720542918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xACPF8qTitC4C85q3Uzl6H9P/C7FAYrxs6IESUhBvq0=;
        b=J7XzfRmwufRX4VJjFzZIFp+kbhkU8eUW/Ij5xjRzyBzegrNPP46YtBWGJfd+nGi2AZ
         KqrdhPHv8hyJCQcijGnCwV0T9Ex6PSB3OrOEOA04xQpiK/uEXLHXai3iYh2aBYN3DB9a
         T2gXDDsmsd5x+Wo6h3f6hQPZ0hkJaPsJ1FhVQbu+zpY+vuXCOTZ3XJzDlyqVIeHvtGp8
         heFHUuq/PViWp6UCiQgrXlooU8R1O0qFMwptCS05FI3QAf6PjQ95IX7hCV4LTbZiZWvF
         H5/+ldQaxtzPfg7PUEfOni++CpTU2tklU3hScCHWGr8lpTwyt0nkRthOtzP3zDIS86dG
         xk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719938118; x=1720542918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xACPF8qTitC4C85q3Uzl6H9P/C7FAYrxs6IESUhBvq0=;
        b=oF76OsybRVkd89TAgPQOXf6iFU0g/Ii0DFrDhpmar0KGUKaSBc1dB8ypmPRUX0ooCA
         lj0OqlLJGigFuDBJkmvAh4eKpwgZbbOPyzJeUOJkZK+mPofFBkl1wognoUVzTLTDBpxH
         EAsOwwWzDl2YbVp7EPkWiPVqnj5QLgtZN5Ax+CSQA1DAveMxpbCvoc/8MWDufptM5TVe
         Z2KJVVDc7KCpc8KWHsMYuXJyMYPHTv0RO35UjyIOKPjuWfdjIfUjAcQreVz/U0HhcZpc
         4cdT+PfYcxTKBo9sdQqmVXcqskd2CEjl1RpKZgOSOJJwwqsd1AFAIGC1b8jT3YSbJyF1
         9W+A==
X-Gm-Message-State: AOJu0YwQNsrLB4s84WqoXtzCPuIlbnb5uOij+Lwo7wgC46YxXQTNxxkX
	V8bIDBsiDK4U89VgzxHpzo8X7JWozIQSxghhWVM1lIeEL64rgAUQr7BtI3ionro=
X-Google-Smtp-Source: AGHT+IFn+KAnLT7OQQYFhCtyRn1CjpvcLN6nIOZfDstHnU2Uiz2RCBWdS7oCkVfmV4i1lqUv2u3LZg==
X-Received: by 2002:a05:6402:26c8:b0:584:21eb:7688 with SMTP id 4fb4d7f45d1cf-5865d47375fmr11121050a12.14.1719938116959;
        Tue, 02 Jul 2024 09:35:16 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5861324f08esm5839957a12.27.2024.07.02.09.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 09:35:16 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 9E1C35F790;
	Tue,  2 Jul 2024 17:35:15 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com,
	drjones@redhat.com,
	thuth@redhat.com
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	christoffer.dall@arm.com,
	maz@kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v1 0/2] Some fixes for running under -cpu max on QEMU
Date: Tue,  2 Jul 2024 17:35:13 +0100
Message-Id: <20240702163515.1964784-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following fixes try and make the experience of QEMU -cpu max a bit
smoother by actually checking the PMU versions supported. You can also
set -cpu max,pmu=off to fully hide PMU functionality from the
processor.

As max includes all the features we also need to take into account the
additional TGran values you can have with 52 bit addressing.

Please review,


Alex Bennée (2):
  arm/pmu: skip the PMU introspection test if missing
  arm/mmu: widen the page size check to account for LPA2

 lib/arm64/asm/processor.h | 29 ++++++++++++++---------------
 arm/pmu.c                 |  7 ++++++-
 2 files changed, 20 insertions(+), 16 deletions(-)

-- 
2.39.2


