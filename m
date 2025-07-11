Return-Path: <kvm+bounces-52091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80746B01363
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD78E7A6F8E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 06:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77931D7E54;
	Fri, 11 Jul 2025 06:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WHwDLMg/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B0635950
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 06:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752214588; cv=none; b=uEjgLbvzLFUS7UNYsRsEqzn397RMlxUkubD9lf3VR+tHaVgdTyGoOJTw/PM04nR9yvSxDnuYlWo4GYBfxr6Dm0xV0NVXDS6Sn5QyHsteDtsv9vR7a+hBve94GRg01T6FzHGSoB4C4o/EPoSFjpTAHN4RVnsNg4pr6D0LyzBEcos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752214588; c=relaxed/simple;
	bh=47YogP8wO1/1CZX6L6M640j7zCn7xq2x3uPbrcgBo+4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Qsv9eJFjraj+noTWisaBXjOHn/Kwl3ByfkLynnV7UAX92VrNQr+7l784wCgXTGUNYqWij4EJOAQEALk6AvEr6dnNr7CZO/J3PQ9s+64ND7gsoQrke/QwHlvl5jBVKbY96vHdkPCUwJ8viPjdCGX1+IdBkdRZLVCgfGNz4d2kk+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WHwDLMg/; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b20fcbaf3aso241831f8f.0
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 23:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1752214584; x=1752819384; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=47YogP8wO1/1CZX6L6M640j7zCn7xq2x3uPbrcgBo+4=;
        b=WHwDLMg/+iU6QZfKQIEcGDEQiv438gNFddZ6rtFqKBSjjXaIHd0cHYB0wCm1N7elMd
         UHICSDilAOvRSRDWCO19PePPKY05GghUj4aigmctoM40Hpq2mwwecwsEZ62De7zbxfcC
         sCkTqMJLARKYRZrSpbs7WpAwblc80Cp1v2qW/bYFjIqRPayv9lx0ureZaG9Q84FtvsCN
         KNL5oVGWcSh39ENisOTveBVoW72UGGXJXPbGT/GhAZJxkyRdD/0QmkBel7CwfEPr8s+4
         VjakQfr0g+DTvaO1jn3n9v0+RvswGUDldOrCluFz59J1I9OwrgU+nt/psy7N0ZAGpOsE
         vEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752214584; x=1752819384;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=47YogP8wO1/1CZX6L6M640j7zCn7xq2x3uPbrcgBo+4=;
        b=qISqrBG2FRIG+H4XVYMT0NCRF2vtLUNMNOjZELNCyRZ4CcqyVmqVqymF7u9xTLGwmJ
         bjhfstPuVNcVxHsYt/OpEkgq60iCaiQoTVMaIOimYWbxJEZnMDvafnwPZfPOtGIZHPKA
         OS0Glvf9YDtwfXWZvbiTO5HFsM2DqQsybqAaKx2HQAGOR3nXIJvHDNKn/a2mNnuF5hcC
         zyNXwmRa+GGrvd+qT5kgz16TngTBtxCIXlB5t2Hib4O2hSbP7s/Ndq6F6FFofAJQdunc
         S1eNSKWqgZcUvNsfryu18SFFsb+Y5pOtru0cpaYuf+bOmC0WoZFHQhNUTo+ugtZdg4bk
         4Wmw==
X-Gm-Message-State: AOJu0Yx8n0MOm7ZXn5UsjsIA/WwKj1uD4Axnh7jBvHl2Vr+atnC1k/dE
	oXk0fYM9m3uJCmvqUISbPTODQySwLQIhMVAdtpVU5fD58CjWilDIgEGj8pdNvxsw8qk=
X-Gm-Gg: ASbGnctuJ3l3lL7NVK1fhW4AlMsaB/612tYLhsSz4WjTAZhsAfif6Mmgy5oV9Fx8yte
	Tt6ckGabFX2sZ9yOIw3Yu6B+RSkbeVVaIajf0Bc1fKnk1dzYwwinY6Sw/5KxOKBOw0ZWhkzooec
	URRmkf7Wo2oyAYhTdbkcJXaji0bMKO0Aw/ZkXCIgtzIE+YASkhkdSbJD2MUinbJ6QAPh6d/SWaC
	Bt/9G6vZ1T/56Qv7cH+x10kyXCCDCvZtGevGctAIXHh3wnTyAJGkG0OhaxquxQRqvWo0Q8GykZ3
	LfwxUGKsi0RG0Y62pxsuPqstSr9R0nkQTZHGKXmab4tifW62ey90yGiuHVFnQcgcNijR7tH0lwo
	FxA3k+byzx4j0HT1HLkp39QPaHibFRkMReMHs5CPUyCcBvvwwoT0X5x1h/w==
X-Google-Smtp-Source: AGHT+IFmrp2wvx6BT0KyJb8OkHRj5zkFsyk74vrJoJEn0B8TRag/YIYDZNX5MR7sI4EZ9patSQYdRQ==
X-Received: by 2002:a05:600c:4714:b0:43b:c825:6cde with SMTP id 5b1f17b1804b1-454f4254765mr5662365e9.3.1752214584185;
        Thu, 10 Jul 2025 23:16:24 -0700 (PDT)
Received: from localhost (ip-89-103-73-235.bb.vodafone.cz. [89.103.73.235])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454dd466154sm37076735e9.12.2025.07.10.23.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 23:16:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 11 Jul 2025 08:16:22 +0200
Message-Id: <DB908AUW6N76.3SYAGIFGCDJ27@ventanamicro.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Delegate kvm unhandled faults to VS
 mode
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
To: "Xu Lu" <luxu.kernel@bytedance.com>, <cleger@rivosinc.com>,
 <anup@brainfault.org>, <atish.patra@linux.dev>, <paul.walmsley@sifive.com>,
 <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250710133030.88940-1-luxu.kernel@bytedance.com>
In-Reply-To: <20250710133030.88940-1-luxu.kernel@bytedance.com>

2025-07-10T21:30:30+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> Delegate faults which are not handled by kvm to VS mode to avoid
> unnecessary traps to HS mode. These faults include illegal instruction
> fault, instruction access fault, load access fault and store access
> fault.
>
> The delegation of illegal instruction fault is particularly important
> to guest applications that use vector instructions frequently. In such
> cases, an illegal instruction fault will be raised when guest user thread
> uses vector instruction the first time and then guest kernel will enable
> user thread to execute following vector instructions.

(This optimization will be even more significant when nesting, where it
 would currently go -> HS0 -> HS1 -> HS0 -> VS1, instead of -> VS1.)

> The fw pmu event counters remain undeleted so that guest can still get
> these events via sbi call. Guest will only see zero count on these
> events and know 'firmware' has delegated these faults.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> ---

Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

