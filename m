Return-Path: <kvm+bounces-27063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E33097B797
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 08:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE8BC28745E
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 06:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4032C155307;
	Wed, 18 Sep 2024 06:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KmAC/2c4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACED4139CF2
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 06:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726639520; cv=none; b=IO0TDt756DI8c3w0/lmqn/Yi+CCQE947qnBXJPH9FIUIODIdIuBhmUJ0dqVNWWyFH1vFfk+5Uzgn4IFQe1X11ZG8PprXdhI3GQenrzadCjgDG6RYQszVxUEVIND3JNPZqHgBxINRJR/K057v0mEfTFM6k/yxV23E4EBWInAX5b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726639520; c=relaxed/simple;
	bh=t5mGxf+CZ3zZYnX4JbiIfh5pZ7tAjdTRZMOnJjviD4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REtdKzocuIqVaBi0xDIbeLzNt0ttXHcckV9e3BB9GILhydEIMEJf4QmYdFfolvJGv5Sc3E9n6f/evzxhGETPGdlZdSkDmZyEaSqGGmvN/ANyzl7k+YGmkNo2vFD+riI3cIzA1oqrQktHPA1Cr8DewxV11u0SVkK+uSv+alKqQmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KmAC/2c4; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a8d6ac24a3bso81973966b.1
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 23:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726639517; x=1727244317; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t5mGxf+CZ3zZYnX4JbiIfh5pZ7tAjdTRZMOnJjviD4c=;
        b=KmAC/2c4GNy7hXjZS60NBIlvm4P6FIIdBmWQPhjiiZvS150jjz0Epc1Dxu/C9p5Qfm
         zWf/sBxOrIfu9pRjOof+pDiMm9MbSqT9BKoknXlrZfcgIE49SA0+y1otAymsp7yzv3wF
         JFuZooqg4BWLLycTuyXP622Pg6C4Wft8ZfoaxImmdYKPwTG4UWdxAjAs8+pxjEKdUVVU
         6+TE8iVnZtyrTAB74zDIiF/4By7+TpCPuggUHnMP+Sf7fLsq41lIalnE7D70tO0pyiEN
         9K9Y08EpNUpt2+wDD2Vh0wZIoIywjmqGJStAGDZjpY0yE1kD/RZNH9kc5qL0iSAuPXVD
         mIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726639517; x=1727244317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5mGxf+CZ3zZYnX4JbiIfh5pZ7tAjdTRZMOnJjviD4c=;
        b=A1+f7m8mUQbLxR6SJMNL+wHCVY1Dx7w+hqtUChGPPgNatVWM6jWyglGa2gz0Bq4Gdg
         l6GqDqdv0ot9mNytArZv2bSVOGmbVKaZLPP4vNupAOalQPhZKaw4zPGaJ+0FPa/U+cS4
         /K73VZjs4W5w8ttjqHqJ2Ebsg/ggmJSVD35b2Az3kkzLEnV3n4x6mzKA6ElmIULp1L17
         c+QYBrcPf/VjSMAgduBOcXyibfAef++l/xDulVNb8UltdZgtfRk0KXnOZwQca/A38yHf
         B56AP+RneEvBRoBhJrAu/q41n38svNkC4xSAZz/C8tw23r937xdibmNqMi79FdjKjz+Z
         iIAw==
X-Forwarded-Encrypted: i=1; AJvYcCWYsVW4B2oOOFQmJ2GT6uZW27o+5PtTzaWKZXFYTDPRsgsJHWfZCkcWmIoY988MXzvG/mo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy7X/blB10tyaj8+G4uGiDj6OYHsrwXeByEpaRI4yaIQ2bwpno
	baNkVANcaP/AwkMkTxUQiDEG1FVeSkqgGFQcw/nbc0Fwn0glgPpgosxQIAOkWDw=
X-Google-Smtp-Source: AGHT+IGHKR0qqgSX96tsaPbrMvlFd8LcDl6wWuDi67U5uzQHtG4PPaURsQoSA0G1nXDghe6Ahz69jQ==
X-Received: by 2002:a17:907:7ea7:b0:a8a:cc5a:7f30 with SMTP id a640c23a62f3a-a902a8c26ffmr2252797466b.25.1726639516625;
        Tue, 17 Sep 2024 23:05:16 -0700 (PDT)
Received: from localhost ([213.235.133.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9061096aa2sm536689566b.35.2024.09.17.23.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2024 23:05:15 -0700 (PDT)
Date: Wed, 18 Sep 2024 08:05:13 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, 
	Alistair Francis <alistair.francis@wdc.com>, Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, qemu-riscv@nongnu.org, 
	qemu-devel@nongnu.org, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] target/riscv: enable floating point unit
Message-ID: <20240918-039d1e3bebf2231bd452a5ad@orel>
References: <20240916181633.366449-1-heinrich.schuchardt@canonical.com>
 <20240917-f45624310204491aede04703@orel>
 <15c359a4-b3c1-4cb0-be2e-d5ca5537bc5b@canonical.com>
 <20240917-b13c51d41030029c70aab785@orel>
 <8b24728f-8b6e-4c79-91f6-7cbb79494550@canonical.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b24728f-8b6e-4c79-91f6-7cbb79494550@canonical.com>

On Tue, Sep 17, 2024 at 06:45:21PM GMT, Heinrich Schuchardt wrote:
...
> When thinking about the migration of virtual machines shouldn't QEMU be in
> control of the initial state of vcpus instead of KVM?
>

Thinking about this more, I'm inclined to agree. Initial state and reset
state should be traits of the VMM (potentially influenced by the user)
rather than KVM.

Thanks,
drew

