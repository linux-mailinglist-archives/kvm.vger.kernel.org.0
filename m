Return-Path: <kvm+bounces-50112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D557AE1EDF
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06CB77AF45D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4422E610B;
	Fri, 20 Jun 2025 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="tdJJm49g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F85C2D323D
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433966; cv=none; b=q1x23MA1nlLP0jxYTYc233+IxcigBEJMVCfefXC2GwKovTz+Jydknrb39Iy8LwzPWpSSTuZZAdGG6RCUzW9/uvru7BqfBKsm9JyouYntupt1C5ENQmBb3EnXgGtSRc9f1V0RpPE9Y+daS1xzGz25607WqCJqbGQLKtT39MkxAWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433966; c=relaxed/simple;
	bh=1GVf6pPYxskn+oaBnxWiK8fBKw+PhSrkx5pHcSQ2Baw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loggCSUSBgOgP9QvRzn8RJ+eMK8EJ3AU9iWe9fISP4n6RL81pGxtcNPt0GNTRfvvYw0QgnJuIZhCPN4iDgbGYYmOYc+uy2BUhrL2ZvtbNA2zSmGGTLhRj4yqbNWz35XrxUcAydTIM6HD/Lpt3aUfJ5eisvbjTUNQFXNuMl2KXx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=tdJJm49g; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45363645a8eso9571415e9.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750433963; x=1751038763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mawr7WKFCGQ8tWFa19Mt3NRHVX8USqBo3jUJVELODqw=;
        b=tdJJm49gWLQUytiXOnQCBk/gwskEfghCs6QuZ2A5IGjz+R50hg6BL+ryiu6LndJNXb
         QRkloPW0aEpfLwygZoee8KtvteY7hE5Xt05MmrSRUWT4ja7Yaea5OHdYKr3mXLa3jyG3
         OWoy1DFIy3IyL0DMnAIIzRqWOQyJiK7BqaFDFFwvXurvb0+Bsj1NwVOM/OenLRGn8inA
         tzzGby47HgQE8jQMCaX6EVmCnMaU/41KTWN3pRT3S49YwpYVy0RsRDDxTWEq62FIz8k+
         /vx5pdobeq/Gh7LfO066dJb8kOLskD8zPMXckFC3tdVhNZ/rcnynN+rTIPahc+/p2JMR
         iXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750433963; x=1751038763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mawr7WKFCGQ8tWFa19Mt3NRHVX8USqBo3jUJVELODqw=;
        b=iTKPwBFXqiZeoWcUnhh+Ety62gemeFNLoL2ljgqMzLODaiUzzLPYmmi6ykAxVjk2dw
         FmVPvCLBandK7rBthqclQSudd4imiK8xJ4/vLqGCV/6qS3ESMIdKNSZvFDucThJMrB8D
         Acodhjwhrx0rpz6tX6EV7ffY3F3Vm0jbVIiq4tsc/u54XMx12esa6D3tpq0sqy11MNpx
         V/g2JW9wtpW58x/iSUgAE8ZNU8tkpFIV+xUsM3WnDRhFI/Ad+eoZ39f5p4KEMvdgt4nL
         krs4/lyufoJAb9M9mpYIhsRzOFXkRskVT0oLWUjIoiFVFzP3EeGMGz2ccISr04+WDv+K
         UhTw==
X-Forwarded-Encrypted: i=1; AJvYcCXURqP0hOzQUL9bcK0bR4kRS1TcbnINPHscMUEFJgXVZMjBBmPoSBkaJf806is5nSysDn8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwABEfx4dKNk0U8mvi7ciewXbMtZuLkiXfXkIqCmM7qVjjoUSRU
	HBdfJ7lQbj+gXsEimEuj0Ugq1L3T8RCV5koaZksYySAmhEK71tnq10mpLk9x9EhxSQ0=
X-Gm-Gg: ASbGncsjFO6g+f7Ij0f+tNWL30Zs74hu/uFJ138GqwiqdMlVBDAwTAWQ6+YsBGtMYNZ
	qAyg59sammdaPV/v7aCK9/joCDx+0UhzAuck/RFRrxngk/0DVMFNK28ZMAny6CMaHxabCUGLuPJ
	WR3d53OM6mdU79GP3WIjxQ49ORce4kod7sKSLkachQwbhQVAyLIC3kGSiYAsSfJt7hjgcEN1KJD
	uCEZDOgsnaWlc07AN+WPedQ7+KsEXRsq/d8/YZ5F42CgwmDiXtFg1ypLReOoMXf94YYOogPMPZu
	ZZOF+AeISiR6j2cmmVFcLGh+v+7XJ4UiQ3vV61RPBv/bNl1Ff6hB12SYWs38wy7y4CVK/ndAF0w
	q1wrU1qENwSUZY7VnWMUdIpwZx5QCn7N4AKz+8v05WYCUbpylMEiNOSY=
X-Google-Smtp-Source: AGHT+IHKVTrkYBc7IB7BrOKtMI3wzs1IHS19aOQAqZcphf4iGPlxDgGIvKwGYBMR4g877UlKlwfLPQ==
X-Received: by 2002:a05:600c:c4ac:b0:43c:fd27:a216 with SMTP id 5b1f17b1804b1-453659ba4d5mr29882945e9.23.1750433963308;
        Fri, 20 Jun 2025 08:39:23 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm2323815f8f.83.2025.06.20.08.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:39:22 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 8/8] x86/cet: Test far returns too
Date: Fri, 20 Jun 2025 17:39:12 +0200
Message-ID: <20250620153912.214600-9-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250620153912.214600-1-minipli@grsecurity.net>
References: <20250620153912.214600-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test for far returns which has a dedicated error code.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/x86/cet.c b/x86/cet.c
index c99458af2eab..0f7046580778 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -35,6 +35,34 @@ static uint64_t cet_shstk_func(void)
 	return 0;
 }
 
+static uint64_t cet_shstk_far_ret(void)
+{
+	struct far_pointer32 fp = {
+		.offset = (uintptr_t)&&far_func,
+		.selector = USER_CS,
+	};
+
+	if (fp.offset != (uintptr_t)&&far_func) {
+		printf("Code address too high.\n");
+		return -1;
+	}
+
+	printf("Try to temper the return-address of far-called function...\n");
+
+	/* The NOP isn't superfluous, the called function tries to skip it. */
+	asm goto ("lcall *%0; nop" : : "m" (fp) : : far_func);
+
+	printf("Uhm... how did we get here?! This should have #CP'ed!\n");
+
+	return 0;
+far_func:
+	asm volatile (/* mess with the ret addr, make it point past the NOP */
+		      "incq (%rsp)\n\t"
+		      /* 32-bit return, just as we have been called */
+		      "lret");
+	__builtin_unreachable();
+}
+
 static uint64_t cet_ibt_func(void)
 {
 	unsigned long tmp;
@@ -125,6 +153,11 @@ int main(int ac, char **av)
 	       "NEAR RET shadow-stack protection test");
 	cp_count = 0;
 
+	run_in_user(cet_shstk_far_ret, GP_VECTOR, 0, 0, 0, 0, &rvc);
+	report(cp_count == 1 && cp_err == CP_ERR_FAR_RET,
+	       "FAR RET shadow-stack protection test");
+	cp_count = 0;
+
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-- 
2.47.2


