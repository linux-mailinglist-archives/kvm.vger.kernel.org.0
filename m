Return-Path: <kvm+bounces-50106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F214AE1EDE
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B24B1691CF
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A152D8DC6;
	Fri, 20 Jun 2025 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Mmk4OpK3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952CA2C0313
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433961; cv=none; b=vF+dY7jxcbIJ35A3Xy0rGUSuwt/V+yi8FdmYr95ErSjkV6O/Bgx72Khca8PMRI4hw8pHUzk0GLj4eGcdIBKCBRcKqI/XbxQvbywHm4caYThhCy9aAAvgoUkmPppaeP97DQrDAMam+5ws4C1dBlgrB/v74Lzj8c2htV6FBfTB03k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433961; c=relaxed/simple;
	bh=cw6gEAPuSVg6baKTid+qSNGJEuj6J71x8pwOImucu9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B0rrXv8cs2jTQA3IZqxAwmQynE+PZtxcQ8Ts7z8vQh7A+JnksndFmPOWC9GQqfBivg0Kr4xtVmTihjZACVoG371zNnG7hdqJ53YbbfxRNePhoZLPzWxVXFoXeNKe9eA3r1OTm+pzl6riiKa03xCrLYufogtQ+mrZrmnVahbJeiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Mmk4OpK3; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-442e9c00bf4so16454735e9.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750433958; x=1751038758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RubJ0ulvX/GwDr9pCBWV06f2zWZN9L5yy2ll68AmBzQ=;
        b=Mmk4OpK3AT4HywXyjeDwZPOkBfVgnAGS9cA/v+XqUJ/NKvfN4fyVQLqGC4EYI5b8zm
         tXbl64NqmvZZyP5WFR9oIsEtH83+WsY0Lve3q6JZzjN10/MDu6x6quybDcL7uDLpCVlp
         aOAx9do9qMeM21IeFlKVkx8N6LGcv71xpSH4hPTY/qImyWkFpndvYYFLj00A04L+rm9F
         h3oWj1AlYDh4lXLHYrQD0Nf1V+R6yjSS7OPvo5PVJVfW+cp+UgVSjySuIxDBkO20boOU
         qgSmm9Q5joCg7WvjStGqf4b+4WV2+jcBfNTy1AVUtavcX/uglUF/pcSjz+35Gr57w+N6
         Uveg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750433958; x=1751038758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RubJ0ulvX/GwDr9pCBWV06f2zWZN9L5yy2ll68AmBzQ=;
        b=Vk9r9KFavx+0tV2/Ghr7Pj/t9HV9aL2gBOOhnzUa48DotHmjGBPbDvw3kwL8Fw76UT
         r+YWD7njSgGDukHQPAthwzgPu6y8RMLEPDu32QsmlWs6z6ZWGoAiNiQwR6tgO2h1HQHb
         zmbC60X/Bw+usfL4zRBtGDmOPWkywunsSr8IShqeN9laAPcBSLjCmrpmEqOZNPj1rmdx
         zTDZBh57muJWZT6ELirRltdHb+HCi/FNT+iRxCFzUrKWTZgv/w4wE00u/ml9k72xyP9/
         KwKPveCQUBNYzRpwgzF8QfoiDQDFdCDLOLbkqF8o8R8fQMq4WHFiXVE3mske8MV2DwcV
         8P2w==
X-Forwarded-Encrypted: i=1; AJvYcCW5xuDEuAJg2spMvg3semDqrW3/os19W0lekOjVqNNNy14Vsse4N+xyVUuRwqS/3cQPefQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJWNW+OJxaS+dpNEiSV929dCo/nyBzPb0qmtYO/EjuTF1/Z1+W
	nfR+iqVyu/J50XHlyMSDciMQ0GTAVZhoJrP3YNKJy9JTO9s1fWz6KosOozahx2v7IidMqTZYRHs
	rZjuD
X-Gm-Gg: ASbGncvcMUfhF0LN6Ev0wCg40HFeGOyr4Uc89i+naqpqIFhm2ANpeYQEkFzpWUiXor8
	tMAC/jypc8szZtkunKoifiNk48VV+tPIeO4XO0UYgn1voMnhPTXhmNK3FzSl0vQOQFO8X0jZV5g
	xYaPNDVTfiQiJ+/kItMgm7Fpig7ZkxdRDKAtpfJk7rLYDSxqO6RBsiO/kaPmbTWgkqGHJwVBMzh
	+nSso8YdgfZYbW3jT1Z2cIXTpu/S2MS4F2XXq1LUPcrSFasApMRE7eOSwt3c5arXrpg00a1ywMo
	I/y7jlUUPx8py844+y+8wKDA2a1UignMJ3KGcCksNDJD9BPeilOWBu4y7qrgtMeYtGv7vSSVbnr
	Gm3aeb8R7zIoQ+II59kbHldcDUZ6cZyXUh/sPEhxqovjscb8ktlPIMzw=
X-Google-Smtp-Source: AGHT+IG0oK7sYgO+5FJI0O1ER9m3uCWc84IAN6z1tiWABUhYAgsUogWTXoqODt81l8UHbOKydoMxHw==
X-Received: by 2002:a05:600c:4754:b0:441:b3f0:e5f6 with SMTP id 5b1f17b1804b1-453659bae18mr26158155e9.25.1750433956302;
        Fri, 20 Jun 2025 08:39:16 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm2323815f8f.83.2025.06.20.08.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:39:15 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 0/8] x86: CET fixes and enhancements
Date: Fri, 20 Jun 2025 17:39:04 +0200
Message-ID: <20250620153912.214600-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I'm playing with the CET virtualization patch set[1] and was looking at
the CET tests and noticed a few obvious issues with it (flushing the
wrong address) as well as some missing parts (testing far rets).

[1] https://lore.kernel.org/kvm/20240219074733.122080-1-weijiang.yang@intel.com/

Below is a small series with fixes and cleanups.

Please apply!

Thanks,
Mathias


Mathias Krause (8):
  x86: Avoid top-most page for vmalloc on x86-64
  x86/cet: Fix flushing shadow stack mapping
  x86/cet: Use NONCANONICAL for non-canonical address
  x86/cet: Make shadow stack less fragile
  x86/cet: Avoid unnecessary function pointer casts
  x86/cet: Simplify IBT test
  x86/cet: Track and verify #CP error code
  x86/cet: Test far returns too

 lib/x86/vm.c |  2 ++
 x86/cet.c    | 81 ++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 64 insertions(+), 19 deletions(-)

-- 
2.47.2


