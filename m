Return-Path: <kvm+bounces-32442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5979D9D8764
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EF97287EFD
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D421AF0A8;
	Mon, 25 Nov 2024 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2i2kcsDC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A331822E5
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732543783; cv=none; b=GIp8KOYSJSMoOIzzNcKEOQfBhBM4Aw5YlcFkHsTIceE0wp1XY/G812AD72j3qfFefluuErRO2D1qB7U5VZSqoxYG7K+zDVdpf4J+I5d9hRERYDLP03uD4dBg4lMX/yzb7tk29YLNpoCUGQ2KlODQJhgqaou6MhwcgeIw3VQPaO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732543783; c=relaxed/simple;
	bh=tD0DVkxsi5N832W2IziAukLUeaMiVSG3DTJcHh9GAIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xcpm5e+8bcTmXyAvdh3e7CLhob55/VN9B8Bj3NaDZTZPJ5Z3YyFcsCYz66yL9jy2p3nVnGJJnVYiKPAobw6b5jdJOorggcKyNNjEfMfYabbhSyAt46kZG2zLdGqDWWYv8Si40L96jjnli9/1U2dh0P/KxwdrBeF2zkuws+B/jec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2i2kcsDC; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-724e1742d0dso2481175b3a.0
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 06:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732543780; x=1733148580; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q4Wdq4sGsS+u6q7KEoRzHwqO68mUS+z8jBvBEG+jFzE=;
        b=2i2kcsDCLBh/l/vu32IrqeyoMtyEOJbcQKVgjQPCorOXFkiHnlHswdlNeP8Kb0fivn
         Cd3pegueeD8/zxEt8h1oatmy2sQPww9KgrY80cW39B+soa1wYHwhNjOcjq2Yjzb+o9eU
         QSYEzd9C7hhwToWjFHRWqZ6PiMSBo09E+vuOGM1kY+x3533OwttAZ5zhasUuU6q9Qs95
         nps8CgGNaSde3DaiYbc7wSIneNH8y42RzkvOnHpWi9ouUAsmO05JKsHAy8W+tj4pqTRA
         BK1y8n/JFcNw2jdp1nT3QwYCuqKChJ9coTjOLpTS+J6bjWIQo2xeEtWhr3UsxqtdnKnm
         k81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732543780; x=1733148580;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q4Wdq4sGsS+u6q7KEoRzHwqO68mUS+z8jBvBEG+jFzE=;
        b=WfarJVzKeUvWiEbBCEeBqx1fyFgSsEt+/jrfL3D7MBDswsowMvfq15JWm4npqGYyGb
         aLvEHEnDRXj+s7UxvbkHFfqrTem49reh1FHohQGxGcQs+X7PZrc3W3EgMxXQc5yuneEW
         81uKZSSTNjdcXbIDxvbOHKEQJ1N3uVWQNt5E6Scs0dySE+AaNWqGuvewd1IB5ZiXRRgX
         HcKsBJgxlLMLEliDI68E36gdgsIQx8LfYnQ53NR9Lb4hpZNbiKblTavVoskIHdjt2BG3
         cHD6ydKv2w2iDtjO+KfaNvxo12ndlrwct1NCEO6C9n6Q3hbZG1bMrAuFRvlFHnOJof8Y
         X5Bw==
X-Gm-Message-State: AOJu0YzVh9l/ko4BSzn0O+ig2rXUY5kCnTGNTJtW+Ix3KqvWpadFuSCH
	Q91DdfCzNZrOzS8qEdoonCE8nk8ZrCMvG/kyZbC5pHEZSHJ6nHJuNWGBOzk/JQo=
X-Gm-Gg: ASbGncuDuddGhuTAVXbO0O1FZcaQhXPdZyf86pmXqqmmROxsgCI9UNCWeGivVxqwsxX
	m1dBXifwbZ+n7YZl63oLnNzyOjGerdfg9Vj/GORotJb3xJt4VbP4+Glupmawze3z1VlNPPOr6dl
	6oZVR72jdHZAbk5lnpm6LrC5/yjuKPQQC1tjk3oftoMN+o2MnVHJYJ0nR49x6J4vjpbafcs4uoO
	SOCwp/pWAdyRwUJXfWk8twBtG3URgrud+ZMNCIK4CLG9PCD/a38xobsyxc/zJa4+W70xwRnkyex
	Op98hTsCPMIuvjve+KE=
X-Google-Smtp-Source: AGHT+IEEO3vVhiUUQI3Zu0rVk+HSWvN3R5mQPlDBtZ5uYfLeultoVqH+/U35mnCLK1U8yDSxt/kOyg==
X-Received: by 2002:a17:902:db0e:b0:212:996:3550 with SMTP id d9443c01a7336-2129f232fd7mr199670075ad.15.1732543780524;
        Mon, 25 Nov 2024 06:09:40 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dc06477sm65028295ad.133.2024.11.25.06.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:09:40 -0800 (PST)
Message-ID: <54ac149d-65ac-4b2a-ad52-70bca87e8862@rivosinc.com>
Date: Mon, 25 Nov 2024 15:09:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 4/4] riscv: sbi: Add SSE extension tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20241125115452.1255745-1-cleger@rivosinc.com>
 <20241125115452.1255745-5-cleger@rivosinc.com>
 <20241125-01fae59d27bb81fff71e794e@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20241125-01fae59d27bb81fff71e794e@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 25/11/2024 14:53, Andrew Jones wrote:
> On Mon, Nov 25, 2024 at 12:54:48PM +0100, Clément Léger wrote:
>> Add SBI SSE extension tests for the following features:
>> - Test attributes errors (invalid values, RO, etc)
>> - Registration errors
>> - Simple events (register, enable, inject)
>> - Events with different priorities
>> - Global events dispatch on different harts
>> - Local events on all harts
> 
> And now also double trap and mask/unmask.

Hi drew,

It does not really tests double trap though, only the double trap SSE
event (similar to the RAS one or whatever SSE local event). I'll update
it with mask/unmask at least.

Clément

> 
> Thanks,
> drew


