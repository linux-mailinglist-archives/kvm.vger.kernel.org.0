Return-Path: <kvm+bounces-11830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D4D587C43E
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:25:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EC261C214D9
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 20:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C0476054;
	Thu, 14 Mar 2024 20:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lT0KS1Te"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00CE7317E
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447920; cv=none; b=c8uifNToz28XnPzT+BX96RD3hVsxOIRedzHo8AglxSAkhZDV8cr6Js8Umk95zrslFpj9uRGXC0gx9G6GU5HpymIlH6l9Jry2iR7U9C55sK2OITLxC7Tb7vtfNHvLLP7iKMjfnrAZvMgmkNVt408J0GZI0rVI+eezDX/lh8bcm/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447920; c=relaxed/simple;
	bh=cyQ2uR1WtWqFRxYPGfl+1TVBx2dUPQERmNqiM8XpAQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwq989IQAuKjy9fJ/F1gyTge2+b90alQxWZOO1e/jBEkNoKuxJQ37oakAL0fSpPM6Pe83ojnPaGcmnfmOFWxTKk1ALacerocV6AhKXXcPjr9DDfhl6xIy8kRk27rJOBPBehrRPa4Rq7tIHdk3aVbSnazm7ExUz6+J6jTOICKve8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lT0KS1Te; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a46805cd977so30141866b.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 13:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447917; x=1711052717; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pRLwYMgl/UDUGVtTi+ey3Tg5z5Sm2xHrvmETTv6ml0c=;
        b=lT0KS1Tew6aZcV0+b8RRWzM8NOTkXqfsDsqVsW1k+Yssg7RiL6ISTULPlQgAkukokJ
         u7WFWzHo4GUNHzXJNvMPK4yn46yU+yQO3dyPer6vIub+k6vBzo0lKHhhIz6BCOBzDHXk
         4bLMg9t0hFISNSCYw7q9g9jzKMaflrk0/3+Y0QV6QbLO0NozQR0auzTmsXBMgDOwlL7R
         nCXFn0BpXqfJYEPrEGQYvhWgoaLptxGqXAbuvkoxFKe1oJUcZjrCUUmSCFLvAgfu6ZVh
         sp4txkBHCGjaexB9iLBxV5UzegORcJgNLSYoS6Ng4y2LUCmiKMMdKT4S7Ir1qCsvYBUG
         CcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447917; x=1711052717;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pRLwYMgl/UDUGVtTi+ey3Tg5z5Sm2xHrvmETTv6ml0c=;
        b=UuYB9gn4O02FhAxixD1YC6iWdMt8hAeIFvMzeiM4z9gjKzcdghS/w1EczmoBHlgbjU
         ps+wu0TTJUFt2ZY3bnvOHj1KJNkRtAkep9KWTQqtxvzKxxgSHKbk9P2vxdDD8oDjlRaI
         Ny3I793vZjra2Pg1Vi4YO3z3DcsQMxW2wiGeBsFMokIou/nSQ2evBvGV3XbM/Ash58Ex
         2gBFCtwp7URx9Uq2f6zvfIVoU00HLfA8mxj6HUDKHrivG92KQ/yPu1zxbeT6UxvQFNfw
         7a5P9mPormMYq3HWQddW3OxyGySaqbHR6BtmjcQat7oh6N+QfWp4GsD7c54KbBnuAR0w
         zs/w==
X-Forwarded-Encrypted: i=1; AJvYcCX1rJYXG0eUvVhvDyYgzxA7XbmGe7Mmu9uWLmd1njrCzBehw/fTwv4pRYiTH1aDrfIawTqL+VD6xiydewYKw8xVci5x
X-Gm-Message-State: AOJu0YxEefVI+6HzDJIUq6GVPGpHMJd8QU2gP1asrjuXXjwRW4vPy0H5
	RfsYn1lCoLRGDoIh6x6XKvc/B1fz/vTgK+xjOQYSpRF8hkDg0cSn83gewxJfJA==
X-Google-Smtp-Source: AGHT+IHiMpX8oq69CsmwoWeCDboIKyc9/3ET5RDJwETpARBSad/uPBpvw4EMATrK/2Ae9kiiUviJAw==
X-Received: by 2002:a17:906:260e:b0:a46:13a9:b7af with SMTP id h14-20020a170906260e00b00a4613a9b7afmr83924ejc.47.1710447917073;
        Thu, 14 Mar 2024 13:25:17 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id l5-20020a1709066b8500b00a4320e22b31sm1025367ejr.19.2024.03.14.13.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:25:16 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:25:12 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 07/10] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
Message-ID: <b5c4f8953cfe7073c0adfe83499b56ecaa314741.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Given that the sole purpose of __hyp_call_panic() is to call panic(), a
__noreturn function, give it the __noreturn attribute, removing the need
for its caller to use unreachable().

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1581df6aec87..9db04a286398 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -301,7 +301,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -326,7 +326,6 @@ void __noreturn hyp_panic(void)
 	u64 par = read_sysreg_par();
 
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
 
 asmlinkage void kvm_unexpected_el2_exception(void)

-- 
Pierre

