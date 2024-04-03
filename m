Return-Path: <kvm+bounces-13457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EC2896EE4
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 14:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C41462849D3
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 12:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75EC208B6;
	Wed,  3 Apr 2024 12:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oDPkOyzE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9C417BBF
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 12:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712147585; cv=none; b=h1mjyVDmjmCQSE0Jt/EXgS0m8DPU5hSLeeUlxq2gv78fuV9o37/09f8dq7lAlFsxIRZu+o14tf6ziHQUKwYt4wZyXQGlPWzgYBDi51H8x91aLaXmnVCz1Ekii3K3SKZemJWSymrJYaxIAGIij90C0P7uKw3KGTHbIMf9eQFfhZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712147585; c=relaxed/simple;
	bh=Qfx3VcGvMtmhfosYefNZLptNn3CDdY2Ff+lsN6zW2so=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=BcH44B9Ypmud80QFD3Tzj5vWknFS2G4bM/+VenIbAU5fBDdX75pg1113erqPbC0uc9WWgyxHOrE+md7XMgRMEPsJ/w4qzDHTnbQ5z9mGFrfG4KTCfZmHLoy8enpNDu3wAx4i1a0s5cwCk+zUDqYgScn50zaXj54LEf+NpS+RBSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oDPkOyzE; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d687da75c4so62355391fa.0
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 05:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712147582; x=1712752382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jiQ+GRztMgVG86gy96aZ8sbm/90DKr+fzgR6OINghxE=;
        b=oDPkOyzExv6BTtJGOc8qYcHIce+aFvGwp2DZ3SVsmEsYzpqJHhprrdAXbyb3f0j1ba
         hSmg1L9kpf/QhIpSX/y+zEmCUxAoDrg02g1YPrXYj6dWXDU4GDnfKdETLdevTmMNzSNb
         rdewAMjudoebvdxglZMow6ooQejg202qiZOVi+hoG7KQRM43xm+eH7EMB5qvaqhWLLlU
         JzU0WsnBYuQnxzYnIfwFco3nV51GA/VgEsdxpcbNcYkoaSv9EymED8K5XMnHeA3yLkiM
         cOMLr2qOhB+Sbme2jPNm1oDmD8YtNUS65pExRylM6p1q7rNtb29v9rbC0LFEguR4m21q
         Azpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712147582; x=1712752382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jiQ+GRztMgVG86gy96aZ8sbm/90DKr+fzgR6OINghxE=;
        b=QapX2f+Xg+Mcaqoti0Ux/20n1lF0KWKlknUUzun4ytrgNsQhdbt6cR3fT5HVCGQF9g
         5AzloMZ66vOfC7mTkiQ+J2gHu8S9ycGE5RYpqlLIgHiYcNWwS7ReInRqK8QUJ99S1Ozr
         JwRKI7vas6tqqVAQpgSInIhIQIV6Jnu6gMBm51quCiXuBlZ/eDZR5XVuOQ9yqteQrrTn
         TLafuIsq8sx4grFMyXj5KGippjP5id1+0od9uGhxOAbdy3jHKiTh0vqf01VK0ZMpcTdO
         3IVKFpOdPfJGqzHLcGU0nY0AKndxAPH2k9/n4hAn4ktxzd4QFKkWckKMKW14krpYOIqo
         hvLQ==
X-Gm-Message-State: AOJu0YzTGs9MNAZWpiUub3O4gNMC7zK+lDYFwKIqOZFPYTMePeP0vZq5
	nZBwgDK0yZ0tYslTNygEv/7+HOj9yV4UvhdnRbtIkxbT8BmGR1wvt/Anya719ghYgZqmZpmvIRi
	3
X-Google-Smtp-Source: AGHT+IGs6OmQkLZlpJDSgO2FlGnt3AzAQ4lPQaghboUY5HANhQeLWU5FPRKa88O6XS8HYgGTbb+MTA==
X-Received: by 2002:a2e:9790:0:b0:2d7:2ba:525 with SMTP id y16-20020a2e9790000000b002d702ba0525mr1662911lji.18.1712147582056;
        Wed, 03 Apr 2024 05:33:02 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id jg7-20020a05600ca00700b004161e19513bsm4265139wmb.19.2024.04.03.05.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 05:33:01 -0700 (PDT)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>
Subject: [PATCH] KVM: selftests: fix supported_flags for riscv
Date: Wed,  3 Apr 2024 14:33:01 +0200
Message-ID: <20240403123300.63923-2-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

commit 849c1816436f ("KVM: selftests: fix supported_flags for aarch64")
fixed the set-memory-region test for aarch64 by declaring the read-only
flag is supported. riscv also supports the read-only flag. Fix it too.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 06b43ed23580..bd57d991e27d 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -333,7 +333,7 @@ static void test_invalid_memory_region_flags(void)
 	struct kvm_vm *vm;
 	int r, i;
 
-#if defined __aarch64__ || defined __x86_64__
+#if defined __aarch64__ || defined __riscv || defined __x86_64__
 	supported_flags |= KVM_MEM_READONLY;
 #endif
 
-- 
2.44.0


