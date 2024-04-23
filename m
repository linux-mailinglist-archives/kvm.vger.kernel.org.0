Return-Path: <kvm+bounces-15635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 530DA8AE32E
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B1A9B236E5
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 10:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992507580A;
	Tue, 23 Apr 2024 10:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GWjWXBv7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642B760B9C
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713869794; cv=none; b=Be1+JIDu1JjoK2lIsWvu/uN6fZqBNEB6nFEGHljDMz8ZlD4FejQ03CKk87yeF8YZ9xcF50Qcl3lr5JZsHapAPPKZO1N/SIe4H3xTg3o4Wg8cVhz852mCxQRNT9iLUlMnZOlLSPocuxHbk36dE7KXuC8sPhBB7MlcNbRKLli3iZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713869794; c=relaxed/simple;
	bh=o3+E/pVcXMqGN2IqmycMoE4DCLdrwAivCv4tvzqB9Rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jssnuYZkj15TwMT/vrISiW4uc26Eb7Pa90ZkkdNrJ3ADVcUiX0wrGXi63ZG3kemwojF6oNeDarKDVl2uIqIiCjYzrNzvjKDHegfpdeNlzHtlJBgpHJOKZhFTW0J0BznsLM269O+Iud5kU2z4He7QEIXRQcONtcnCZJSSbb7bo4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GWjWXBv7; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a524ecaf215so558174266b.2
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 03:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1713869792; x=1714474592; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f7A3dJbrWY/9z1NTPLr/SP8VA+syiS13CnbQZQzTmh4=;
        b=GWjWXBv7Cn/wPbJp28rCO/HzDYzjI29GOdYQTrarblqKOgDeYn3CMGmc/GwGIkH4It
         iB3UMMD6o4gBTSzyTAEtPmdUsIT2n0REd682t2ojxM4ti9Dm/fCioytcnGeCadF8Qcjn
         BpIBgOr0VFARD/PwKTh7SXuBs8aHgvSqqdh0f42hJm7nDib5NCjiC60yYWVYaaH4MUys
         D+SXlayKn1e3Do3FKERf/5Gpxhj/xYw+NqF2h6vvfqEx9ZO+s0abjW2tbqyjiCAWdSVl
         BrPOEbTJ3p9kwUvePL8lXjN2ZBgRJNamoLAcGjwbn8i8Ynaw8PSDXBTbMCdblEqWu7F4
         7wCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713869792; x=1714474592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7A3dJbrWY/9z1NTPLr/SP8VA+syiS13CnbQZQzTmh4=;
        b=vwekSCsxJIKQRtk/ecy96CMQjUOKwWukmj8piTw0G/jrJTbBvy7aSsgGTGRY2yoQZS
         Lvb9t8rnw00e5lfFOGC3ZmBMzRzst9dFK+rtMcb32Mssk3LgaReCKjoH7zblfxffJskl
         UPu2sp6uvboO7AqusrbH/UI8ta48+cLkFbh24JDelYFqVwA1MDuOv1hk6wlRmDyPq/Ag
         2RpxZaKn8Sy0EMO8d/xXvQgHMDjkee1wQen9ZWjvuCTOMxG5vUoXkKQcsoMICFNhCl3h
         JFDIYdu68YUBbBLpqk5RHeoikVhGnkQMj4nImYiynwg4+M7Oq2Jtbc5QYbPARnP40Ad/
         sKwg==
X-Forwarded-Encrypted: i=1; AJvYcCUVKDvIG4rOMCvdGA+b7pM+y660v2BLSm3rdjjd79AO2/7n+EE778iJ/OKSUaqI0ilVCA8RxWRFWWNK3L+Tg4guY7tI
X-Gm-Message-State: AOJu0YxIT6yxoOJhii5LFcZTcvVItSUHDwX/MXCp2GEpkz8IqIBLsDft
	D3sSKmrb5X7AQUrSnM/vdTJBM90Hz7WgE0Jn3yvI9b710vEgVWnMfWUTAhLnZXg=
X-Google-Smtp-Source: AGHT+IGuxCj+bPVMezQTiiqaIkHubBLsXlhj+D610GPwkEGBc0PyN8R4nZYOrEBNLFuAizVxpXXs2w==
X-Received: by 2002:a17:906:3502:b0:a52:22c4:8158 with SMTP id r2-20020a170906350200b00a5222c48158mr8092139eja.56.1713869791624;
        Tue, 23 Apr 2024 03:56:31 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id c27-20020a170906d19b00b00a5557bc8920sm6916846ejz.54.2024.04.23.03.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 03:56:31 -0700 (PDT)
Date: Tue, 23 Apr 2024 12:56:30 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Anup Patel <anup@brainfault.org>, samuel.holland@sifive.com, 
	Conor Dooley <conor.dooley@microchip.com>, Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	x86@kernel.org
Subject: Re: [PATCH v8 24/24] KVM: riscv: selftests: Add commandline option
 for SBI PMU test
Message-ID: <20240423-b25d0b1540d2092f5370afa5@orel>
References: <20240420151741.962500-1-atishp@rivosinc.com>
 <20240420151741.962500-25-atishp@rivosinc.com>
 <724a4797-18dc-4011-ba48-445c1cb6a976@collabora.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <724a4797-18dc-4011-ba48-445c1cb6a976@collabora.com>

On Tue, Apr 23, 2024 at 02:03:29PM +0500, Muhammad Usama Anjum wrote:
...
> > +	pr_info("Usage: %s [-h] [-d <test name>]\n", name);
> A little weird that we have pr_info named helper to print logs when it is a
> userspace application, not kernel code. I'll check it in the source who
> added it to the KVM tests.
>

It was me, as git-blame will easily show you. Why is it "weird"?
Applications have needs for pr_info-like functions too, and the pr_info
name isn't reserved for the kernel. The only thing weird I see is that
I didn't differentiate pr_debug and pr_info messages. I probably should
have at least given pr_debug output a 'debug:' prefix.

Thanks,
drew

