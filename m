Return-Path: <kvm+bounces-41811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBEAA6DF06
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 16:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D42C188C1A6
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 15:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5EA26138D;
	Mon, 24 Mar 2025 15:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C/rsSC7U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7461E531
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 15:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742831530; cv=none; b=WW9RwGsWDKhEhBXwxT4Gxs7/RSsGHVWEarZ+PR1017Z2zd0mDWBcarGn5wF+VgGev10mbDEKXHmXpg0T90uRkXIauFy3rgHKhGh8kEE7kNe9WbyOCBEYHT+byyx341j2GSx7LGyBQ4fGtCU0q/jP88wqXpSvA5LsX1Th5lSIGF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742831530; c=relaxed/simple;
	bh=jrF5OhvPJSXyXb6LX2+y3oBS6QjtjU88e7ADlwpSXaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D2IEBLI4sD1KjC6AjawFUh7glcuTydj9Cfl02+mYTPMsePNbn4zRwq9yCRk2VCmHHm3U7EFg6IOJD/jeRb3H93kqVR5zBEa2nXnGzQToGK88vmhwidpcigytMBkb9f8N98Q40u4D8WR3o1yMZpXWYayHXiBYAgh2+CIejLc3U3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C/rsSC7U; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cfe574976so26269215e9.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 08:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742831527; x=1743436327; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfspRdXGlgq6NyzVTJZAgVrhAb+j3MeBFls5zV5sjbk=;
        b=C/rsSC7UK1ZNZNVe7Ds1mHOdLs9sN2cRgQdMnaoLBF1jKk2SCRZdVimcBJnlwFI+Vp
         Hbwc7LQY2JxojD1UhM1WhUDtKxuK70AmIX2eT306uP4zwtPa0L8PAsZhSXlCiJHqvF+Q
         ZwXxd+5T5t2xHBjkyu2AEXxHBRTIjZ5DTqOtRHmEJfxFxDGz59IHsFpPrr9DNiuxke8N
         O9R7O/PsLF7AmZCTa6E/QajTGYCk0RiBtqzWgZuu/iZ5Wt1Be/wANGKSvUPxjNz3uHuq
         46nA0KeYZbILddCnsAJ4wnA+ZIHEfqUnYHHW4kXZwslPj/m6cCrD9Gn0EHTUMZGJx/PD
         v03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742831527; x=1743436327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfspRdXGlgq6NyzVTJZAgVrhAb+j3MeBFls5zV5sjbk=;
        b=TifHfbSw8Zt6ij+XyjDgQQEClZemBl3FPg1nhhlEUjhKot4aSk64zpaV4DsJpZY3qD
         aLCNSDyGa7gPXy4w5paTE6JUrZdG9dEG9CxEUFsYUYzMrBBb9JscYPLFm5UJkmWV/OCJ
         Zr8XwGP437HqJ8pGcoM7daRGA4ptRT0hnARo2tMTkMUglBf/Zr6PyH2pzVAF0RTM3LBK
         zltpgFhomr9y9c7GTbMYNxKJdVspMBh46lKqPYl9UAWG7/dwi5KAYat9vWWoWpKeLiSb
         AuqeNN7nBWTnbgHWIqRMqs9YerYiMY+nye3rEHTPWKIiM5/Y7OFZPnT5zXoVWoAHGlvQ
         hnHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPStG71tp02WYGFMObT7YaFRRqA8OxqLfmVUvj0rOZYEIV4goV6c1G4PVEF7Wb3PdoxVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJoj8ERsHyXDlAvxI/AE12TRN1XpV5j/T3XZKP/9ShZuY87f1e
	vdnw1aZRhkpKmf2JzBoL7Qdj00Fig2Su1Yh+kgo67vaPgQ+xvrCnNMnLUvMtJPo=
X-Gm-Gg: ASbGncv9BjXgxPXadA3stz99NTPdnfQOcdYvx+43OahWkRCwLYPC+uXDsSNhUOXZIor
	0+vVdWVOtFjhg58ZzIxtWe8U9BTixT5q3M2e+Ojc1ZgjuJgLWVmacfg22mMDxYT5r2MNFSHGAgL
	biFACrjEFcBo8qY1ZPWxe67Vq4FCWCr0CtrmfrJmpMS1QKefvfrIYYphetqUo5NVgDPo2+YD/qe
	oeLVKW9Al6yVCkcfv/oGMOgeBms0g87YjkrRh1J+ZFu1X4D7S00sXgta7uFN0Edu+nxTHSsBJEm
	A+7GiMovjew0C4J0MRP5lk56w78qjB0iolfbn9YftVM=
X-Google-Smtp-Source: AGHT+IFl7nFmYn4ImJin0UE8VO9TEBa7A4QjUDf+jR+LnIW0MqNGIXU4E97G8J6fG8YpTpqXzsYFRg==
X-Received: by 2002:a05:600c:574b:b0:43c:fe90:1282 with SMTP id 5b1f17b1804b1-43d5703e686mr82814625e9.7.1742831527103;
        Mon, 24 Mar 2025 08:52:07 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f556basm173837045e9.17.2025.03.24.08.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:52:06 -0700 (PDT)
Date: Mon, 24 Mar 2025 15:52:05 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger@redhat.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <20250324155205.GC1844993@myrica>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <20250322-91a8125ad8651b24246e5799@orel>
 <Z9_tg6WhKvIJtBai@raptor>
 <20250324-5d22d8ad79a9db37b1cf6961@orel>
 <Z-E2v1sKiPG_pt9x@raptor>
 <20250324-37628351a72ca339819b528d@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324-37628351a72ca339819b528d@orel>

On Mon, Mar 24, 2025 at 02:13:13PM +0100, Andrew Jones wrote:
> On Mon, Mar 24, 2025 at 10:41:03AM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Mon, Mar 24, 2025 at 09:19:27AM +0100, Andrew Jones wrote:
> > > On Sun, Mar 23, 2025 at 11:16:19AM +0000, Alexandru Elisei wrote:
> > > ...
> > > > > > +if [ -z "$qemu_cpu" ]; then
> > > > > > +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> > > > > > +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> > > > > > +		qemu_cpu="host"
> > > > > >  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> > > > > > -			processor+=",aarch64=off"
> > > > > > +			qemu_cpu+=",aarch64=off"
> > > > > >  		fi
> > > > > > +	elif [ "$ARCH" = "arm64" ]; then
> > > > > > +		qemu_cpu="cortex-a57"
> > > > > > +	else
> > > > > > +		qemu_cpu="cortex-a15"
> > > > > 
> > > > > configure could set this in config.mak as DEFAULT_PROCESSOR, avoiding the
> > > > > need to duplicate it here.
> > > > 
> > > > That was my first instinct too, having the default value in config.mak seemed
> > > > like the correct solution.
> > > > 
> > > > But the problem with this is that the default -cpu type depends on -accel (set
> > > > via unittests.cfg or as an environment variable), host and test architecture
> > > > combination. All of these variables are known only at runtime.
> > > > 
> > > > Let's say we have DEFAULT_QEMU_CPU=cortex-a57 in config.mak. If we keep the
> > > > above heuristic, arm/run will override it with host,aarch64=off. IMO, having it
> > > > in config.mak, but arm/run using it only under certain conditions is worse than
> > > > not having it at all. arm/run choosing the default value **all the time** is at
> > > > least consistent.
> > > 
> > > I think having 'DEFAULT' in the name implies that it will only be used if
> > > there's nothing better, and we don't require everything in config.mak to
> > > be used (there's even some s390x-specific stuff in there for all
> > > architectures...)
> > 
> > I'm still leaning towards having the default value and the heuristics for
> > when to pick it in one place ($ARCH/run) as being more convenient, but I
> > can certainly see your point of view.
> 
> I wouldn't mind it only being in $ARCH/run, but this series adds the same
> logic to $ARCH/run and to ./configure. I think an additional, potentially
> unused, variable in config.mak is better than code duplication.

I agree with this. However the next version ends up replacing both
cortex-* types here with "max", so we won't need to pass these values in
the end. The "processor" selection in configure will only be used by the
Makefile for the compiler flag.

Thanks,
Jean

