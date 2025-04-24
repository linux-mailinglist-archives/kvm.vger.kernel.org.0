Return-Path: <kvm+bounces-44135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C27A9AE28
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:00:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E45471B65F94
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 13:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DDBA27C844;
	Thu, 24 Apr 2025 12:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Ubxf29LP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9CF27B4F5
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745499591; cv=none; b=qz/xIMY1IGZMEy03e3vJ3vDjI6NN1geRnp+9odeVSWTZF6QgKAJ2AprLpY4k9cX3TCRfTgTnF2CF/JKwkf3+DHFWQxUAoFYIQaVOKFoD1r76SgtNX/hOL1C91dzhvVKb/CDm1XJ1trnjqSsEyZGoJVxEmv/NBypNPaIwHYV9Hrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745499591; c=relaxed/simple;
	bh=LgOj32ZR2p1Cbcje8X1KxFsR/LzGtQoiCDWTf+/EkPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7KqVQjhJigk354xIrZobGlCXY34nBplHcylZwBGB9CsvUr08VD8clZr42MwCNbmurK01Sl2rpmfeF+wWllTAO5+/Rp2pLbAWVsZcx/7oKiUePxqw6rn+rOjKK/QvsWrDWBKSJijzUgmxgIq0Oe1HUGkRbudi80h6tIp+1DUylo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Ubxf29LP; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso11042585e9.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 05:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745499588; x=1746104388; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pq4MolfPNd+K5bSXscDIAMqQ5BwEg88636RxK2hmqJg=;
        b=Ubxf29LPg56+SuNDmTNIM7CqasNp8TvS65zZ5/oqSkKEi35gNq8tdC8VCq2glypxmd
         anJIMVX0qkj8JNXxVOtvv9DoJFOFObWDkfIklQ1XLmtCzWAOGzY4n+sNH3J0/IbSOf8B
         rccyIqlQTOssIsqDWR36Xw41P/AFw8DtFqmIiG8kk74Z0mzZkTIdIxwH1O/uysHgnSiv
         YNi1WWiMuVX4FE5oJWQePbO8+XHxwik9hn6SvPudtN1ih+RaKmLDttL9TPoEs8mRNqXW
         GOghE80joL3RPi5dKD6vYi49SxZC/hmF6tcAcFNjhR+3HxbefyC6PI28yFesIPXMKmhc
         2bYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745499588; x=1746104388;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pq4MolfPNd+K5bSXscDIAMqQ5BwEg88636RxK2hmqJg=;
        b=TfnadomHwj2/+FWYv1L7R/lYeQSX9CquJ9jP/4f+YRmvvtO0ZgAIApXCqLDseeT+wa
         CqUhdYkGuBOi7X3zf1GLykZMILZBWnbT9v/HP+Et5WRfQWBKt2MSjQs6kyFcUDJRVmt7
         m6KOeKIuE14kN4gunzEflRpP8Nb7bskvRlZwhiw2hggWTsERj8n/TCZBBJNoh5DiQjeB
         ZVV5NpKGeJzAIuuKMp/8yvQ/6vmeRN65t7iGnNMAroD2HgkqKtXKesCUmH1L+WIqIZtX
         RohXLlmDNF3sdacWL9BRwbAhSxiBxRZBNDpev+yPWNJq6//TSCKGZLUOppEV3fwajBWq
         PWaQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5n46KOCJ2/HhN6bBAplPh2tQPjU6Xkg6N2cPWoCylAZ0v6++GWiH86punm8lFKz+o+O8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBiw0YOXBXgGFABTykU/UmPNlFnrDcABInys+vYVvAPcDBm1ox
	Q1BN3w2WZV2fuPszZl6pF9BoPcejnnU6Fl8Eey6/RR+PWhT1ye8HT8qFff6JoAE=
X-Gm-Gg: ASbGncvZgZ4fKkVwcDxSj7XqL3cRBc/znyJkrV4EQrN+XBLbttpkv8QDhURFpTAVlqy
	DF6NMhPb91pHt9edmQMHLzg6cOzj/mi6nRyBCKURFwQR6CFzo5UVfdLge5AUpIn0F3clS5p6w3M
	zqJkyg/93ClBdqu3/X52chpH7rEw2JfrhYn8DDFp7PSdRbNEBgfy/nZIVPdY6WmOEYI7z5Zy3D5
	6K3XH+sxnIVDVUveOTjVWj5tKwW7bnGNfceVE3TtJj543zGqEGpWQBXe8VDEprXo4kRXo6A/GfB
	aQyf3WoPchPv7UCx3bmjKN2AuGNC
X-Google-Smtp-Source: AGHT+IFsbpbMlf/oHa4o+M5HvcWy8tOY+l/DnXhzIG3RxZPMjwPTQ6efidUI/BlzMjp/KIlBUhnJsw==
X-Received: by 2002:a05:600c:3b9b:b0:43d:db5:7b21 with SMTP id 5b1f17b1804b1-4409bdaf8fcmr14760305e9.28.1745499587910;
        Thu, 24 Apr 2025 05:59:47 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2ac26dsm20167525e9.21.2025.04.24.05.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 05:59:47 -0700 (PDT)
Date: Thu, 24 Apr 2025 14:59:46 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v5 04/13] riscv: sbi: add SBI FWFT extension calls
Message-ID: <20250424-27a672c1da15353051b52c59@orel>
References: <20250417122337.547969-1-cleger@rivosinc.com>
 <20250417122337.547969-5-cleger@rivosinc.com>
 <20250424-c0700f89bcd29438d6d8d65c@orel>
 <f6c5c92d-73aa-41a7-99bb-f95e388ea294@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6c5c92d-73aa-41a7-99bb-f95e388ea294@rivosinc.com>

On Thu, Apr 24, 2025 at 02:35:02PM +0200, Clément Léger wrote:
> 
> 
> On 24/04/2025 13:06, Andrew Jones wrote:
> > On Thu, Apr 17, 2025 at 02:19:51PM +0200, Clément Léger wrote:
> >> Add FWFT extension calls. This will be ratified in SBI V3.0 hence, it is
> >> provided as a separate commit that can be left out if needed.
> >>
> >> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> >> ---
> >>  arch/riscv/kernel/sbi.c | 20 +++++++++++++++++++-
> >>  1 file changed, 19 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
> >> index 379981c2bb21..7b062189b184 100644
> >> --- a/arch/riscv/kernel/sbi.c
> >> +++ b/arch/riscv/kernel/sbi.c
> >> @@ -299,6 +299,8 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
> >>  	return 0;
> >>  }
> >>  
> >> +static bool sbi_fwft_supported;
> > 
> > At some point we may want an SBI extension bitmap, but this is only the
> > second SBI extension supported boolean that I'm aware of, so I guess we're
> > still OK for now.
> 
> That seems reasonable to have a bitmap rather than duplicating
> *ext*_supported. If that's something that bothers you, I can take care
> of it and use a bitmap. SSE will also have a sse_supported boolean but
> in it's own driver file though.

Up to you. We can always do it later.

Thanks,
drew

