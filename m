Return-Path: <kvm+bounces-29975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A159B52BB
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 20:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACBCFB229D0
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 19:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07AE12076B2;
	Tue, 29 Oct 2024 19:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="mhEFYSCr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4396120720B
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 19:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730230192; cv=none; b=hZdS/lnDHbCwAkVN7zcYTtISDVNGRF+8qE462FXa0zDLJC8Bet+rUVDgFpUGCuvhdm4MQgLWcYlECfCOzBq3GtPXMBdBkBNb6s/tq8gY0rC0BYF03v9QsSHsGViIf9N+vInbjtdOQxVb5EbPCpjS+YWseRy4WVENDG1q9ujFWwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730230192; c=relaxed/simple;
	bh=LN7V5BQeKRXCPiL+YCrWG2j4TvAtcAaEOUEhSygUgns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIz6SL/6edOCMQaIiWnmDMKbU/GucE7CLHXnrxcTuqHU/LBuXfZzJSc4wWzzQXe3R08ievT+xnxQS/mNFKdw6CdL6PQNRt+aCFjgduXYTWQp7e8lTFmvGkCna0adDAPRsOVhNBBuM31Mg7l/lKhhalXtO2AFWWiXAbLg9c3yWUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=mhEFYSCr; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7ede6803585so147313a12.0
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 12:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1730230189; x=1730834989; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p453f5qLRHQrUMFO6yBtyDQCP3AS0fkH5n591K5O5UY=;
        b=mhEFYSCr82QFdTX9kitkI0S3dUZZv1eiE6GPRHfDwgu+S/Sc5dqqiRHjnI4k2R3oDI
         uqQ4xK3YRctbX6QxSITaSwgyp0qWokDZ/mpLxt6dTFB+RLDEBtqZdRLBXDJqOKGQmpxT
         LB5jYQI6c6E6VUQWhQ0g8HVTz+j04gkgjXthjebkWIkQZbYihntkC6ikzqZU1RiTHdgl
         ZiMEiNIkIHS2llQMxsxJGGj8XcMY+lQ9tYL1+UeaU17dDvNiyG8+SzIz7LT5cdxGwClP
         dB9CnBSv82/0xIg5+u/T4gEMLYRyugkzYNLvNDQdgUG85N8QvjIig/d/4hoHppyiZT22
         ZHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730230189; x=1730834989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p453f5qLRHQrUMFO6yBtyDQCP3AS0fkH5n591K5O5UY=;
        b=hdKHsPD1Yg2vXIrSvtc+b9cOLed8fMuECzQGNCDlrCXAdXdc11/+24jfaisphC7mrG
         LUbGTDrnLnKxwDfacpTy9PkXfX5J3eHEYhOOqHPW9uqNQU77meb9jIOYrZDVgm6Iek81
         qEFauicxp/dTwI3ROZq4PQNOmNDlxtgcImKaWJeoA7Hyq+P560Fed6/RNj8wSi7alqF1
         UgV1m7MTZPUoFW89iAaQN0nBcjyChdGGQCUOkgHGoiz7LYf9Tu9QKzmeB/nKMWu+blF3
         GW/SgZz30hw0XVJs3yuIiMBJOiZt4rKHWnKJZh1el8Vw1iV0s/rGlSN4fws/2y4dunLc
         SbUw==
X-Forwarded-Encrypted: i=1; AJvYcCX4aBJ1G/mWBrxjYIxFXzlud8J2X5maM3Fj27KN6ZzbWOizIfSsl3pOjuIEWd09tBylWPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNmE05UUvIyk8vT2VMJrseiS90h1nxeSPCWLw/zxKk6B8ntpOx
	JbPtAuXKe7viADzT2nARjAdGAcVjS4S6oAYp+xta2/FyDSZlGAC4ffiprE77uPM=
X-Google-Smtp-Source: AGHT+IFhFlcCcvQjHhliRyZXirlOj5VprFQBCQ8QKlxSPQtXsUC/wqBDa3PY5cBoAFjEcgQ0R7Ad7Q==
X-Received: by 2002:a05:6a21:181a:b0:1d9:15b2:83e with SMTP id adf61e73a8af0-1d9e1f0b721mr5535203637.7.1730230189067;
        Tue, 29 Oct 2024 12:29:49 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a3fdf2sm7909099b3a.214.2024.10.29.12.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 12:29:48 -0700 (PDT)
Date: Tue, 29 Oct 2024 12:29:46 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Max Hsu <max.hsu@sifive.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH RFC 2/3] riscv: Add Svukte extension support
Message-ID: <ZyE3qjpOXJYPRVlX@debug.ba.rivosinc.com>
References: <20240920-dev-maxh-svukte-rebase-v1-0-7864a88a62bd@sifive.com>
 <20240920-dev-maxh-svukte-rebase-v1-2-7864a88a62bd@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240920-dev-maxh-svukte-rebase-v1-2-7864a88a62bd@sifive.com>

On Fri, Sep 20, 2024 at 03:39:04PM +0800, Max Hsu wrote:
>Svukte extension introduce senvcfg.UKTE, hstatus.HUKTE.
>
>This patch add CSR bit definition, and detects if Svukte ISA extension
>is available, cpufeature will set the correspond bit field so the
>svukte-qualified memory accesses are protected in a manner that is
>timing-independent of the faulting virtual address.
>
>Since hstatus.HU is not enabled by linux, enabling hstatus.HUKTE will
>not be affective.
>
>This patch depends on patch "riscv: Per-thread envcfg CSR support" [1]
>
>Link: https://lore.kernel.org/linux-riscv/20240814081126.956287-1-samuel.holland@sifive.com/ [1]
>
>Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
>Signed-off-by: Max Hsu <max.hsu@sifive.com>
>---
> arch/riscv/include/asm/csr.h   | 2 ++
> arch/riscv/include/asm/hwcap.h | 1 +
> arch/riscv/kernel/cpufeature.c | 4 ++++
> 3 files changed, 7 insertions(+)

Reviewed-by: Deepak Gupta <debug@rivosinc.com>


