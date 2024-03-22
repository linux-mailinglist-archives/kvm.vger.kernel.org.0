Return-Path: <kvm+bounces-12485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D09F886B6C
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 12:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5A351C20924
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 11:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E293F9DA;
	Fri, 22 Mar 2024 11:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XkM9cqo/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061723EA9C;
	Fri, 22 Mar 2024 11:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711107707; cv=none; b=QlbhVbr7Zc0q4w+T3PTxWSv3Nn76gMK1nIKiipM5dIE3jSXm8XlBlFL4n8kDiWafd5mEdd9K+rBpkAxGuplmqk6b2GweoMm2JOOYYzOYQshAKSZ9pqVf8D8MnD/ggSK2VO8XXZV9DNGVNyt0T3kWMSNhyEdy5rhhFzDADt0QSr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711107707; c=relaxed/simple;
	bh=DnLFfeW1AMMJ/5y4K8wzGOftS7A6Z+PTU6bFKYYbMD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aGP6N9L+6GU1yDSNCf3v2WpY00CUd2jUJ5ShsAX/EO7w5Kz8LRDHOGt52Uy79jYLFFfpD3sDmjyS/ZtEpZXx1GlaKkpFIW0PwyTX6qU0o0oaIDZEBszp3ps+HJ4y4T5sQSoCor2zg1S7DA9ytbXTZ/7cvV9zPX8Jh6pFXF+5vW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XkM9cqo/; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-789e83637e0so126389485a.2;
        Fri, 22 Mar 2024 04:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711107705; x=1711712505; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8evdBv9wfzyxMz+KpHh32wSrhwaXKbA+tqAPHK3l3vc=;
        b=XkM9cqo/Ojd3gW26ZFoCUJ4nmQywIpC5VR9LrN0RE6HI7BrgsaT4NIOAEfZPch/tmd
         hSSBa3GpdIz2c7DbdkpA3EluYsebNoEdst3N+WUQgVV1edsHZMUgpGt1zGqPtPggNuS+
         tSbABDFrhPfNo0qUBAfCa7y7G7oHTIYJgIrcNsGDp5tR6c+nLJLcEj+NyfMd6vEYfQAr
         DFwPvxtBcg2SbVB3kjhx7jYJGdfo4RZjxgHUU1z3xl2V+KEwfttDyaCvIVoIsSiS4EGK
         tP0zKzFG0F0lNuOUeC5cp8F5aGdZSehaVnxyVTaVSkLUuessaB67dgbjouxlC4FJEafT
         Scmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711107705; x=1711712505;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8evdBv9wfzyxMz+KpHh32wSrhwaXKbA+tqAPHK3l3vc=;
        b=c2lkvi1dLx8WqA/AksRL0dnIsa6hleMBmuh9HaGyE7xxbGjuqWPJh6owd4bJyiktGw
         EQwPf/TDFRgBurLOHVyvoBQdkntcWZH9NWe7LLxyzHgFX8R53tu5faQTQ4vHplgBkNk3
         2Z/+iLiBB6Gxqow7mu47qZPz/6fBWjDuMD7usOVSJshOw6EUE1AjB2OurJp6cieLPNFj
         Kg/akYNYMwYe6bGHSTZvM9myuKPMA9IQJPmz597onKJg1upGXOBWpvj+IY6jK2MfsVvQ
         czvL8f785avotqDjtt41C96X4PbcAX5k3e49tBTKPiRV+7NQpI9InOeb3rMJ9j5lF7FX
         ZsTw==
X-Forwarded-Encrypted: i=1; AJvYcCWBkjR+Ht769FX2LauhQIJm+I59xM01IYmdYFByjHcCbpH0nBA4dZciNmwrFmjcTSK9yiTcv/lEYDUTbL4RYq+YRQiYAcGMoCsnLk0UYQ82beIfGBbJC/3l3aKEEJcfghZN
X-Gm-Message-State: AOJu0YyK5h7VyDmRgnurFiLGLF+T6yvjFuxOLSugAsuUz1VAMNhfBfC9
	+mxrQLlO9bIeJ4JWKwFqX7jnUZxOc8eBXLH33dm0Mqi2aymZngo4j0tAIwNsRkPOjA==
X-Google-Smtp-Source: AGHT+IHYXA++eriMaFp3DVL8xL47iq28Kzs2KTpZk5Dga3q6r6IomxL2a7u8Kbi2GZjdsrCkllcNxQ==
X-Received: by 2002:a05:6358:4894:b0:17e:edfd:89bb with SMTP id pe20-20020a056358489400b0017eedfd89bbmr1963530rwc.15.1711107354301;
        Fri, 22 Mar 2024 04:35:54 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.27])
        by smtp.gmail.com with ESMTPSA id h190-20020a6383c7000000b005dc4fc80b21sm1382661pge.70.2024.03.22.04.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 04:35:53 -0700 (PDT)
Message-ID: <f44de7d9-e03d-483d-96d3-76c63158061d@gmail.com>
Date: Fri, 22 Mar 2024 19:35:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM RISC-V APLIC fixes
To: Anup Patel <apatel@ventanamicro.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20240321085041.1955293-1-apatel@ventanamicro.com>
From: Bing Fan <hptsfb@gmail.com>
In-Reply-To: <20240321085041.1955293-1-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Hi,


As you mentioned as below, riscv's aia patch in 
https://github.com/avpatel/linux.git

Why is this series of patches not merged into upstream?


在 2024/3/21 16:50, Anup Patel 写道:
> Few fixes for KVM RISC-V in-kernel APLIC emulation which were discovered
> during Linux AIA driver patch reviews.
>
> These patches can also be found in the riscv_kvm_aplic_fixes_v1
> branch at: https://github.com/avpatel/linux.git
>
> Anup Patel (2):
>    RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
>    RISC-V: KVM: Fix APLIC in_clrip[x] read emulation
>
>   arch/riscv/kvm/aia_aplic.c | 37 +++++++++++++++++++++++++++++++------
>   1 file changed, 31 insertions(+), 6 deletions(-)
>

