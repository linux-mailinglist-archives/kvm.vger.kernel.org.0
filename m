Return-Path: <kvm+bounces-45753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95842AAE7D0
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 19:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FD7C7BFFCD
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5913928C843;
	Wed,  7 May 2025 17:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="f4RVo24t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC1828C845
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746638920; cv=none; b=eTnz+238h13sBzoRhCUA4fACZI/SXh0CdZMOBtRKrZdWc1bxncSplFTqHCJlmNoGpRU+DvJZaifGDCQgr9hEkKHuHrJT1huEqsMcVSCL6M63374a6wSg342WNQuoJH4RoOulhe6mjh+D7QBhQgje/DkPHyj1bIEMr0KS1p2RXq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746638920; c=relaxed/simple;
	bh=VEQsZlKiPlg8JG29HLY8kuFIcRJCMVZ5ZBC0vAQca9I=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=MoK5m23xgsRdFEXP4qvSRFBNe4LyM4i0Z+xXwD40cY5Fp2jnWQyT88GfnioJVe5gQhYMnedfnhCI6rAjF8ysku3NESe3umy2c7N6f9Xo5rlMKDzOdLEc7dFrT+PbAx1IpxEH5YdqkPlqf1KA1qUe6UEkVa9RQl50vZmkeekOInw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=f4RVo24t; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43d16a01deaso80255e9.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 10:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746638917; x=1747243717; darn=vger.kernel.org;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1k0mMQcs727Jg3GUuCAHgbefpxoeFAFqTEHafwowpE=;
        b=f4RVo24tqQrRj+RtDkDwSGKQvnLAOIiFUyOy/lepU07kCA0xqZZFYTNvB4Gw9AS/wv
         TIqRNd6EiK5t5f+AtMas4FCPENMa5yarpPP0vz904i3OH6p50LiAYfPx2P16/S8CWdn2
         40bSRGfPsoR6sNQxKQvY0Xe5q5FPtMKofbuX13xDoSCQdldCbJRx05CZU9nWAF0+mC18
         IiDuz7Woa23akTkZjkc2vubEsPvoYqGevt9EXhmEoWLq/H0AeYOBP853gtzwwDLIf5kV
         19pu7CboQHkqo0B44oo3Y9lS/ni39Fpxif0LbBiYYEh2sEwY6d3NyTI3+LNyxwLYibrt
         VrLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746638917; x=1747243717;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n1k0mMQcs727Jg3GUuCAHgbefpxoeFAFqTEHafwowpE=;
        b=HthZyJjIreiTMeyybW4TVBhMOBKHXJS8yce1zqpXIBN95BtlKjwaAJx+96zfjgO/hQ
         94iAYRETHlhGVJkbyKaZZSjuy9TgE//ZJAmeD63+jiunwvFdrf/IFDU7ilV1pvejorXb
         pegg79m+clcM9TS3wUHBkTahPHDrWO6F1IVt2CtEYDE05+EcrSZ4Nof5wVyI7DPPOU7B
         OrrCaIGGuYEZ1ea41Iv5xNwRVxFkm+hwiRJcwL6Am/i9EfXj0/pU2st81MKRC29Wh+4H
         De8Eqdj2NzZquKtsU36DvbqBCJM9iXl5PRNzJ8CuJJRyCpTp/s9zwTTSeV47SUg3I8Ta
         uKgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvrxt1q8/pduHj+kRGe+nJ0nruG5WtxqFqbxHrM4KJ8M7+q8ZAMzv5swQznbpHF7/yAVI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMq5SdGciIasdd34bI0pPDISlg4V2PEWnrTcQ69RWfwPS0n/f1
	i/tUXeC7U7/3sySufFT5Lx9P55r28sqq5sdZom0uOEvR14qc5X/YCKBMLCAB3EY=
X-Gm-Gg: ASbGncuURtfBCWyvBtHElE7ZIzz6V54qm85eo05AYMeA63ttnVH8D6lFsyWI+pebFti
	fCDKGXcub0NiAjdd8vORflxt6h0u8ZT+eMLFVkp2RrH8kOyp3JIUHlpuK7Z6RwBk+j/j94wRgbw
	lJaf6PGOvyQ9Lq/AbBZ+DDKfuLAwdJsNFU3QPzmcNpeyEB4532wacjoR/1uzxQq9PlNEimpKAs+
	St0JGlpaPu01eaFmXMLqGEUDvw20nMVCbV+bJMGLn9cGDFtXIKTX9wVmvZMuziVAoa9hN9pnKUG
	5xcYGqGcJ1bv6rhqeL8D5zW+j4K2M2ugIld6fkAGMBEUuaiI
X-Google-Smtp-Source: AGHT+IHU+1d2rnAPUioAKK829WKkuchI8dVVAYZLNapz3Ruq/guJ3Nrk018+5LxP/Vpdt+N6B5rWQw==
X-Received: by 2002:a05:600c:8711:b0:439:9a40:aa27 with SMTP id 5b1f17b1804b1-441d44dd3b3mr14261685e9.5.1746638916681;
        Wed, 07 May 2025 10:28:36 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:f39f:9517:bfc5:cd5e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd3b7f18sm7953815e9.40.2025.05.07.10.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 10:28:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 May 2025 19:28:35 +0200
Message-Id: <D9Q3TKPXTPMO.39LSPFEO587XO@ventanamicro.com>
To: "Anup Patel" <anup@brainfault.org>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH 2/5] KVM: RISC-V: refactor sbi reset request
Cc: <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Atish
 Patra" <atishp@atishpatra.org>, "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Andrew Jones"
 <ajones@ventanamicro.com>, "Mayuresh Chitale" <mchitale@ventanamicro.com>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-5-rkrcmar@ventanamicro.com>
 <CAAhSdy0v7Cw+aGF8DDWh1gjTBXA23=H01KRK8R2LTQHLRHo5Kw@mail.gmail.com>
In-Reply-To: <CAAhSdy0v7Cw+aGF8DDWh1gjTBXA23=H01KRK8R2LTQHLRHo5Kw@mail.gmail.com>

2025-05-07T17:31:33+05:30, Anup Patel <anup@brainfault.org>:
> On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcm=
ar@ventanamicro.com> wrote:
>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/=
asm/kvm_vcpu_sbi.h
>> @@ -55,6 +55,8 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,=
 struct kvm_run *run);
>>  void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
>>                                      struct kvm_run *run,
>>                                      u32 type, u64 flags);
>> +void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
>> +                                      unsigned long pc, unsigned long a=
1);
>
> Use tabs for alignment instead of spaces.

Oops, I totally forgot that linux uses tabs even for alignment.

> Otherwise, it looks good to me.
> I have taken care of the above comment at the time
> of merging this patch.

Thanks, I'll post v2 without the three patches.

