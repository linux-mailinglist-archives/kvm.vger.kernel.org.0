Return-Path: <kvm+bounces-39994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B483A4D753
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:05:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C1203AC2FA
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5762920127C;
	Tue,  4 Mar 2025 08:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="IEIpI7Mr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C312C1FDE15
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741078700; cv=none; b=KuFHoj2tiIAbEl6tSdE5nZdwlcj+AHPAwBG4FkfA2IWO79R2r2M4F1NXRR8IBggxP2ukX8SmHHGKO3D9QM3fuRQYZAWa+8IZNHFHbj9DSMVfClqpwXeE5dBzQbR6/4fQ5lUX81M2R+1tLa4wEzs78y9uTODB1sOcPaaFFIZFCEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741078700; c=relaxed/simple;
	bh=+xt0a9MOKxcngTL6D0NlkBxMF5DrrijsvR0wGk0H/sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJOe2SLtwcmT0JMciWFFd9DIdCfCAk8/sxeHK3TW0c/+ToEDIIRsYW9N5MjJkP04z1zmFOrIQQZCLZmIsxrNpfiPTxhGkFe2knoGSXdzZYV5NGhhRSzds7bwbYMiCClb46XBCXAd4YwM6Jvns/8j1bgnRfifEb1uoPWyn3HGkbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=IEIpI7Mr; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43bbd711eedso18204095e9.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 00:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741078697; x=1741683497; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+xt0a9MOKxcngTL6D0NlkBxMF5DrrijsvR0wGk0H/sc=;
        b=IEIpI7Mrji3V5JToFgifBnmPzuPqpxdbGvSG9pgENAij336vUAkJffHrNwUihyARcL
         0v1PXvSnhe0o1yIziQIpnZKt30TE3D7RJoIgwLK2Z6RUELd6JTt2WWS54GmnIZcE1GUs
         czZ9fqN1WNmC/KP4yCHQLUuPqdOMofUI+weTDMvATao3TkqiK4XIqq0QEDW98V47lN4+
         LRNICUzQmM0r/H2cq4USqOTrLdeN5Tp0lox5l7vI5YQvnGJNd2hMw9truppO1QWOXBZ4
         kVDeb0aRqFUGAKZlMINb3D6kbPTo5b94oiBjGcrLDwJc7yWGzG+F9f7jwmD99kidVLqF
         CqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741078697; x=1741683497;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+xt0a9MOKxcngTL6D0NlkBxMF5DrrijsvR0wGk0H/sc=;
        b=bEDh4j09xWvP94uL1uTRtyFJUaW6FOGG0Ex9cQP2rGkO8D6wXMaJ7J9Ni38uMGEz00
         wT26TPLy5sPB5MK4xDvhUamBzHNNTKIfE51VIALj3LgBmNISHctY4LVvvroCN/OcjnJP
         BUg7YyaJfhTpN7xKy4Icev1jpyGusBC72pDUQQahybbFdn7HqfOQHlP5TBboQLGcUoV1
         rWefMqyMipQ13NFiRS15QfNJUq7cvyqOQTqTOWX82HcvMqOGv9uuhkmgVAfjznFrpdWc
         vhBjtyCBulEa0tI19UFG9cREVeF8wO3H0tA+AuIw9Hk8KxD0jDgaAY4pAwt+97v5DD8L
         R6dA==
X-Forwarded-Encrypted: i=1; AJvYcCUAllPuYa3KBsDtJxrtKFpABKVN1hxenHjMjA+g9Hoz8046EJObfiS5z1VZmUb9977cG/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWEzQ4LzGuCgbGONHL+NDrxI+piuB2IOsO5UQf78KYuv+H+hoo
	olL0c2FF1+9zB/upJ7RJTj+Tbqtt5nhDVsUOQjVQoHfhaG0qT9uEBEELh0VsKbs=
X-Gm-Gg: ASbGncsBpwaxAqf35dsHgfzn56le8jRbH+2KRgfM6FxKCmydDHNpU/YvIoYc2O67Chv
	OYaOWLJ5LGD4P3cUeZKTPt5WJBoh7kd3B++DXTgLW/7I0MUw8dbNQBQ6/yJYSouH87PxtyG8kDk
	2a/2BpxfTT+hgWdtbBXwPbGgBlQ2HAtDxUGDscSpbDqPhW7ULqEwoMoEHiFUluPbzvGxPQ5hMWM
	ZVV9uUPt53bISVQqloQmTTa61tTHxPNhmoBdU4rMdpZxskrs/XJpn3mTs5sgdszTJib7Cl4TYGs
	NCdBp+UGncZeWmayMwRR6+xJJUa/SJYj
X-Google-Smtp-Source: AGHT+IH6MvxZS60faFjjSE/SOwTs7ArGKMS/DI+pAYNkmL1uwIQZP3dtDN6thfBALwaicYstcm9hQg==
X-Received: by 2002:a05:600c:5111:b0:43b:ba52:bcaf with SMTP id 5b1f17b1804b1-43bba52c199mr77383595e9.5.1741078697098;
        Tue, 04 Mar 2025 00:58:17 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::688c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e485e03asm17306599f8f.95.2025.03.04.00.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 00:58:16 -0800 (PST)
Date: Tue, 4 Mar 2025 09:58:15 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: riscv: selftests: Allow number of interrupts to
 be configurable
Message-ID: <20250304-5a85b3a246f14f60f61a45e0@orel>
References: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
 <20250226-kvm_pmu_improve-v1-4-74c058c2bf6d@rivosinc.com>
 <20250227-f7b303813dab128b5060b0c3@orel>
 <CAHBxVyGGw6Ur4Kdd8Vvwp6viKWPx64w7gNvNiUzmAGeXF2PGoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHBxVyGGw6Ur4Kdd8Vvwp6viKWPx64w7gNvNiUzmAGeXF2PGoA@mail.gmail.com>

On Mon, Mar 03, 2025 at 01:27:47PM -0800, Atish Kumar Patra wrote:
> On Thu, Feb 27, 2025 at 12:16 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Wed, Feb 26, 2025 at 12:25:06PM -0800, Atish Patra wrote:
...
> I will change the default value to 0 to avoid ambiguity for now.
> Please let me know if you strongly think we should support -n 0.
> We can always support it. I just don't see the point of specifying the
> test with options to disable it anymore.
>

I don't mind not supporting '-n 0'.

Thanks,
drew

