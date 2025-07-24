Return-Path: <kvm+bounces-53392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9282B1116E
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC8F8AC697D
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 19:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232E02ECD2B;
	Thu, 24 Jul 2025 19:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Jop5invP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DCA2E8DED
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753384257; cv=none; b=j+dXGWwPba1yZbAzhhGTpPUn+Rjl3S9ild5ZOw3Xm4lMtgwvqKpRheA4acqAJXC7Svtw/3SwoO7yXdJpRbZpD5+itXKNdJIRtuzP9vfryCHOCXqnVBf8MNPdMJRcb4GwuAiN6XQCgQmcPIDIQgqaFAqYpTcJpYEE/SKzcY/T1bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753384257; c=relaxed/simple;
	bh=pf6NOAe17j3kacmhzwEJH069n5WGjPZ2XP3sZlmlSjg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JpamOjUw6YsdPbr3SYLF9gthLwfhMvBSCvZPu4sA167SdhDretR8xpPimEvNKW7rY5QfvgPSdHMuFeEW7nvbqOWte2MTHznD7+42Ber2vgZpkLd/kU5X9EjDI1dAgHXDEW0onbgdJ2/CPYw7lCpx91TYdfug/4rKGUt/ppG8akg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Jop5invP; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a53359dea5so739306f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 12:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753384253; x=1753989053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QHWpD0i339PEcT5T5XARaFD7WcNyfAtByLV5e3Xqky4=;
        b=Jop5invPoALmbJYvGeBqwNysjU0SyrGDDTJ3DDSC8haTozHxhdmytL+QLoSMmVLLLL
         LCMVTva9ftA58Fgo2NiAUyTB2AvJqarnKsAIMoiha/LqeD+j0XspOhAbRMjmHkoy6JLR
         juxATz2okV0a73qQkhTmpsJ+IVHASqO0+Oyb08LJKXMV7tmT/LmRInRoIxhk27SUSEfO
         SbHzNbzJRGKhh+wFXQ1Fw6q1JVJ5HOm8ynzDvCzmFad9nB8/B279+v6llE9NImGfMFv4
         7fczyju+5fSVZdY3GENSSLpPLmCyb2aFqKqJ+k3cFJJnQPY0BPntRKj1dBJcRKq5fY0q
         bf5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753384253; x=1753989053;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QHWpD0i339PEcT5T5XARaFD7WcNyfAtByLV5e3Xqky4=;
        b=OIDewNQT7GkVjCcZp6sW1WJSsOPz0R5aJnjLqCHuyxwleM3cfu5c1dN6Mj5D6jhS65
         F4lGzxpaodIQAj5PQ/gvaZhOIdzBAk80TlcxO7iIVJOUOnYJ5QW8Kp8vMny0IGjkoHI7
         sHnNHqRBDOsV9VtYKR2naHXhxzWnDpKL+JVOYfC3CVB+a8VsoUR2CxgzUr3opv9s7TsX
         BDEP1UOzaUZ1ktMeI2lPU1qN21wWLB/W1XizqpOakulO7LJ3UjOezVTbhCQ0WfvXlD9g
         qwPvwFDMuipcoj2oCNge47w8xU6EHi+9NxMHxFOe9FcXRwfNXmEyallE/Hc2AALPPaCL
         9wRA==
X-Forwarded-Encrypted: i=1; AJvYcCWg77dDwR2xkPxG1TJ9hoLQuI8xMcN+/sRXo/O+3BGXMuuC/USD7oASXXyjC5CPaR5SCmI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd/8KqaKJZWESKWJFrdMnYcab/JI5FpP2Ru/RHy0w8uQcHl0c9
	skXR5HAtfHaaV3RV7rXIEC5wqHb2DpHRBV4+7H2cEijmkvMzocAGbcgXfJybkOZkN/wlYuqsnoD
	mIAZZ
X-Gm-Gg: ASbGncsZp1IPZWQ0ITNqEbKd+q/4ESho1vS0WC+wyREItDN1tOfTPdpcykO7LEC6C7S
	ebQY98tlbvxPccupRnK99Lra3crtFi0QWiLgvA+Q/vJLjlVB0bw7U3MnCh2EtspukiY0Gl07ZsR
	LkxRXmSfQXwxwVbitWFkWqr3cHNuwkUICKd/Nl4IfXVINGVMe458H3acXrAkW+1sNGiQbo6EZAV
	CzBoJV7pC60PKCjlgsIa5pR+MtdogRoB5sSws+DB5QuM6fmEs3g77GXBOOXEgMioBOuoNuJaLk+
	DQG988+9gZFvwdZP+xM1NHLXfkllVQZjlJCI/g0D9rkvkagj98mgMbJZBBHO0KqHYEzUutFqUmb
	fPRuFasfzZ3mtmPx2Wm9tlEvGygv3wHuYHDM3NGxqtZRKpHhTLqJCPOySz3aqyLIehGUxmwOWZd
	5CiFAsqkHZj9XdvWu/lxvq3E5RTBI=
X-Google-Smtp-Source: AGHT+IHSuHSpBOl1szOURAphdfh0yaIMfj7iqWnPderN6iEVaIL9mLy/9POb1HskEJTkAZKqZKaJMg==
X-Received: by 2002:a5d:5d88:0:b0:3b6:deb:1b43 with SMTP id ffacd0b85a97d-3b768f01432mr6716317f8f.41.1753384253377;
        Thu, 24 Jul 2025 12:10:53 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705378f4sm31118955e9.2.2025.07.24.12.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 12:10:53 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 0/3] x86 hypercall spring^W summer cleanup
Date: Thu, 24 Jul 2025 21:10:47 +0200
Message-Id: <20250724191050.1988675-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This little series cleans up the x86 hypercall tests by making them no
longer rely on KVM's hypercall patching to change a non-native
instruction to the native one.

There are attempts[1] to disable KVM's default behaviour regarding
hypercall patching, actually requiring executing the native hypercall
instruction.

The last patch is also a general cleanup of the x86/hypercall test.

Please apply!

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20250722204316.1186096-1-minipli@grsecurity.net/

Mathias Krause (3):
  x86: Don't rely on KVM's hypercall patching
  x86: Provide a macro for extable handling
  x86/hypercall: Simplify and increase coverage

 lib/x86/desc.h  |   9 ++--
 x86/apic.c      |   5 +-
 x86/hypercall.c | 131 +++++++++++++++++++++++-------------------------
 x86/vmexit.c    |   5 +-
 4 files changed, 77 insertions(+), 73 deletions(-)

-- 
2.30.2


