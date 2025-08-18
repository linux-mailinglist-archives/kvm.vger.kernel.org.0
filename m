Return-Path: <kvm+bounces-54878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DC3DB29F29
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 12:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4D412008DF
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 10:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329AB258EED;
	Mon, 18 Aug 2025 10:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="H8UUTFuj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFA0258EDC
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 10:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755512954; cv=none; b=cuE1yAIS/UIjudlHa4D6eqhA6DcZVkRJ2mnOXyJ56Q5Yg2YYpP9PhonaG66LByGJZu23+7xloKuzukZRCM92i4cAWjo3P74oBuqP9nPBu0UlzFEixl1W2T273uwiFFCjygGZ94k0oLyT4h/Ya9YuI8Pifa+3bI5tUAAIygKSF4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755512954; c=relaxed/simple;
	bh=BhbysUcbAKjEA8/11kFRzX2E12IzlBavWPgZPsKEmYQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=haEAuIVLcjs0+EqX19Ps+zNRc7Hjm0oJ4eI78UXUF3dHz+igkG/13jM6BxT2Z2MXAin+N7bcIPNYRuZbFImcvKzPgeLCMcldngNmOQ4CI1zPflmF8CGRk4FCcOXtGd2v4NEYf36hjbZnNJez4XFwevrTEoB87IxiuALlGAh+Fm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=H8UUTFuj; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a1b0b4d13so4694765e9.2
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 03:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755512951; x=1756117751; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhbysUcbAKjEA8/11kFRzX2E12IzlBavWPgZPsKEmYQ=;
        b=H8UUTFujZ5bOLN6tfCzFgID6wonxXrPF9cK8Z+ZS9fyfn7aGURLVqHXgqUfi0r1/vT
         Sn5ORcibCb9aNtRsE/3btDwWwqXJZGMUURJjuWMjBC4l7T9zXMjCDo1M57XWLJlakU+l
         i2xjswyTWWLeLqPI7PT19ZhfG/PayiG1TGLWAI9BpBnIVjtqe8FmsjaE4txXpr5y6qRM
         kBWo98qzE6NncAWo39DOGtkOl77CnZymx9LV6pX2e0hE0mXXBX6HaP2BTNIo18pCZ6r3
         bWRWDQzCLZj6P8Nz4Dyj/0QiMOQ0SPrY+hnQXZVGLZR3tXU6mpsrcrBxprzPFe2GmO2b
         aSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755512951; x=1756117751;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BhbysUcbAKjEA8/11kFRzX2E12IzlBavWPgZPsKEmYQ=;
        b=jJ1Z0R9+H03cVCH3Z7yy1uRpS4SnJqqdTRulLniLgZZvmUxWqd5jiRjEd6NlPpTR48
         4TxD/NvJ7HKjhpvGo0TslZiEY0rXgEHmq0dL6tNXHu+4RBwVnVPSyqQH6xFoQGYLUwLc
         DcxRJdp+0fzC6/CpSUwiHesxB7oGKF8v9PQ1upvryyxRVDz/do/J1e+5nUqE5G+txbfu
         0Yys/CdfHXb3l7bWOzw/2zjCyJ/K0uHTLdLp+/DJysjK7F6adJiuY1fN7h+VFZuN+n4j
         yL6J9PTIMdGykGSkcH0g29GlymHAhAV4zg9HSTbYf1GhADxTg4KzC8ld6CyGCU3SAY9G
         lPOg==
X-Forwarded-Encrypted: i=1; AJvYcCWEw1l/049CMdTw20TOvUjQ5pwrSDS1PAgd1QCz3aZGS/mxmuZWDw1P/fviMMrdp3g7pJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjctKzGp/O0maJW1LKsEyhhWz2ws8IkGIn4WDWm+V8Jygk0EuX
	UNUR1rTfo6YbdbfRGu+3ryxJ7otXVKsunYlOgMCpm6Nwyp7tedG5iMZDQtVvQWgYxRc=
X-Gm-Gg: ASbGncuOYjdfwc2/CvQwdXzx3VWeoiUwM+Mkk6UrGMoyq7dkURf1ADAdjtOpKLzCxBr
	qyIcihPE1692uPfP5ZWNVqjN/o2bbwCoz3i41Hq10bw1f9DWWkmPc3wbf60MRpSperHZ8/6YxfK
	RcDvzjTifXE7RXe2DaCaLxKf2lyBvpqREpbdKRg/FyCJh+i3YVAfc8+wOd6Ns9NcAcQfEHPlXZm
	nEded2RixChU6ITUfA4b6MbTBLS6TA//dmEscqSu/hyW4JuwxxzOPeCscZqAyAoZpp3Lf/WpexS
	8Oak6+T1Q9Slfae/C8ISVC9YsC60NxH/z9U0PL/PhFZd4Byh2652GXbzzKPpBZqZBcAZFBv40/p
	3VjYjU5JZb5JQ9o5+G0NaUBGjqie28Q==
X-Google-Smtp-Source: AGHT+IFey14ol9S6TtNaCL77HGtEmBhLvnjzcHSJ5a+JMC7yNb3b8k4bUmeKUn0yZJ7mbxDU1Gpejg==
X-Received: by 2002:a05:600c:46cf:b0:459:ddd6:1cbf with SMTP id 5b1f17b1804b1-45a21781fb3mr36116495e9.0.1755512950889;
        Mon, 18 Aug 2025 03:29:10 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:faeb:f88c:9e29:5aa1])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45a2232de40sm125126805e9.26.2025.08.18.03.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 03:29:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 18 Aug 2025 12:29:10 +0200
Message-Id: <DC5HEJRMZ84K.34OPU922A7XBE@ventanamicro.com>
Subject: Re: [PATCH 0/6] ONE_REG interface for SBI FWFT extension
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, "Paul Walmsley"
 <paul.walmsley@sifive.com>, "Alexandre Ghiti" <alex@ghiti.fr>, "Andrew
 Jones" <ajones@ventanamicro.com>, "Anup Patel" <anup@brainfault.org>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Shuah Khan" <shuah@kernel.org>,
 <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: "Anup Patel" <apatel@ventanamicro.com>, "Atish Patra"
 <atish.patra@linux.dev>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250814155548.457172-1-apatel@ventanamicro.com>
In-Reply-To: <20250814155548.457172-1-apatel@ventanamicro.com>

2025-08-14T21:25:42+05:30, Anup Patel <apatel@ventanamicro.com>:
> This series adds ONE_REG interface for SBI FWFT extension implemented
> by KVM RISC-V.

I think it would be better to ONE_REG the CSRs (medeleg/menvcfg), or at
least expose their CSR fields (each sensible medeleg bit, PMM, ...)
through kvm_riscv_config, than to couple this with SBI/FWFT.

The controlled behavior is defined by the ISA, and userspace might want
to configure the S-mode execution environment even when SBI/FWFT is not
present, which is not possible with the current design.

Is there a benefit in expressing the ISA model through SBI/FWFT?

Thanks.

