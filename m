Return-Path: <kvm+bounces-22676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1104A9413D2
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 16:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C072D2862F0
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 14:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1584B1A255C;
	Tue, 30 Jul 2024 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZbiwH2Mw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ABC1A0B1E;
	Tue, 30 Jul 2024 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722347996; cv=none; b=KkBmYdpUKPQWPJ/0bI8NorkD5ZR8KLaDG/2NuQsHvH5pHw/e09sPDh+OWamuGvHGnRDc3Hag2P1hs03s70kV3J5O9Rd8eD/NjQzoiEd2UNLRM2MT29cFb+nucbPXKg417Jt/L6x3o/3iwUPNYz+SMXI1rIya+k9rFuvkUSvwq2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722347996; c=relaxed/simple;
	bh=YaM4+b6lvaZgy4LsPLegxSvo2v6TxqFJ7fyriyom+oI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gpDVgBiVDZadadoFYnYwBcQjOf/9ly6TPzbRo5BMZv4DxIt+eWqSf+A9NEpCjJueI/a3q3lD5rPFmYb2W1waJwj6fS1sir8vK5h6VZxhJ30uzNSrCMNI210JR1cuhp05fG0JV7o+8oPXiEdw+s/p7jAET7A00uc5sAfG5jGP2jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZbiwH2Mw; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a7abf92f57bso607556566b.2;
        Tue, 30 Jul 2024 06:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722347993; x=1722952793; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5jsRHt6AbZY8NHNK61Lyc5SbdHyyw8i5AOi+bgTKUYU=;
        b=ZbiwH2MwU7sbyXHHjqLRTZnOKc9DvAyFRLpGMprLlKdl8fOh35B+Xy7DhSBHbfVWOP
         VLRAV3YJzkct5hsuUzKI216X84mN+80PJHecID8zZ+GeKfjtdTYdvtlTt33RH40rmfGJ
         lCXtFKsrWNkxPBxpfh5xRSzFvwc1cj+H4Idr9/KVxoqXO1KUEqJ6KWmaFL2njitx4CzR
         5ZWXJs5/yi+u06DryvimoMSw6X8yxT9absSmLHM+ZVRFkx4Xw1mI0NWQC7X9AAu+dnr2
         KWZMRn/J2yRiAvi4ieqCpjaGR6lJipkOWM1N96DiQWzC3OE1JDq1bjlMRAZswX8U1vBX
         eszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722347993; x=1722952793;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5jsRHt6AbZY8NHNK61Lyc5SbdHyyw8i5AOi+bgTKUYU=;
        b=ITo8a8Q0wgTMyeXt6FoFWPQkN1VA6y0cPdB89h4UTxgRUi5BqUYy25OY3ImNLHi26P
         KWN9bW6XP0X/kxrxnUO8Xi6l3oFE/4NH9GSQ2VXD5g1EmiHkE9dJzXIHrhYw3E600K/3
         tvtmlPwBqyyUmOs2FiXOXBo3BlEqxpcIIomalGJcqABl7yu4FyxieJMLz/aaFZSYji7d
         /UP89zVqyTGHPUYTc4ULRVZ+qwGKwYP5kb7ppYABExLxpDq9bIWl+7p56cQEOaLi+OqI
         jhmJSj5yFymU6y4g8iHTPYDwxPXVhnbu9KUOQJaBP2aPCwYN6wzyQ8TRc/u4hWJwK+ht
         FwNg==
X-Forwarded-Encrypted: i=1; AJvYcCXXcSHSg89ucLremO1CzzalbOeJ01ihM8WXuCj3PAK3F8s91DR0kdHAyoh9UR0jbMsYnbcNHIeP1Cn+XPV8JHMoct4op5ikZZDWYk+GAZq5+pQj4lQbYtIan5mtauX2ybNk
X-Gm-Message-State: AOJu0YyAG7JfUjCxrRyW4cfGzimLLjlh25QdBU5acRQ9Au3Vgq23vxD+
	uGmxiEqTZadmf3d1QXj4N1YfiyUKNHdLKUHrSXMLtwSVSGGJuXhFpJKvGDPsu/43kRH1KHoubzQ
	FlLsPaPydoqPx2/v/r1xdva2bSfs=
X-Google-Smtp-Source: AGHT+IHpVdhGWM8xlGOpb0CaWO+/25TbVir4XUN/mf86g8YrZLSmmiFcYOvx3uozoDaV9uJ/7HgJmLa5wPvtFUkXWB8=
X-Received: by 2002:a17:906:c141:b0:a7d:30d2:28f8 with SMTP id
 a640c23a62f3a-a7d40150d76mr701927666b.68.1722347992676; Tue, 30 Jul 2024
 06:59:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Liam Ni <zhiguangni01@gmail.com>
Date: Tue, 30 Jul 2024 21:59:41 +0800
Message-ID: <CACZJ9cX2R_=qgvLdaqbB_DUJhv08c674b67Ln_Qb9yyVwgE16w@mail.gmail.com>
Subject: [PATCH V2] KVM:x86:Fix an interrupt injection logic error during PIC
 interrupt simulation
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The input parameter level to the pic_irq_request function indicates
whether there are interrupts to be injected,
a level value of 1 indicates that there are interrupts to be injected,
and a level value of 0 indicates that there are no interrupts to be injected.
And the value of level will be assigned to s->output,
so we should set s->wakeup_needed to true when s->output is true.

Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
---
 arch/x86/kvm/i8259.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 8dec646e764b..ec9d6ee7d33d 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -567,7 +567,7 @@ static void pic_irq_request(struct kvm *kvm, int level)
 {
    struct kvm_pic *s = kvm->arch.vpic;

-   if (!s->output)
+   if (!s->output && level)
        s->wakeup_needed = true;
    s->output = level;
 }
--
2.34.1

