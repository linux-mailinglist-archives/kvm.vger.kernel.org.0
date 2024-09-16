Return-Path: <kvm+bounces-26998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5CB97A274
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 14:41:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 618E31F21714
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 12:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3D815574C;
	Mon, 16 Sep 2024 12:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="D4F2pKtm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BE4156CF
	for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 12:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726490492; cv=none; b=SQzZqHOAOrv+JWNEnX1m3LflgFHkpXOwjGuMY1oncJHsUnCSaI1lHGbJFs2cXA0JZeqqdrCz8m1aoNWhpseVlIsmH8e0U7E+CuT9iNiJwvqgN+O46LqSTHMZuJ0Z33k0+jSlm9IKp3eqDDgGZhjzYxlAD7Ip/KWvTaMxrA+p9C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726490492; c=relaxed/simple;
	bh=S/ftoAScjgiV360t76a5mqODWdMIpi91lRWa69OOHFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XclFSD4cixkVieoWFJCcinesni37LCVvmXXGM4nTj+s2hIxVlAr3iGtnXMyzSrrVj+QiY+DvoplLp71z9R9FDeJ/M8DWRo7bYsxyGYg/oKbOj0l0BNPFAH6T6uCZjGkJF2FgiU1qyYK5V0U6OVObd285nEMrFMYcEx1Vy+FU8u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=D4F2pKtm; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a8d6ac24a3bso803008866b.1
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2024 05:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726490489; x=1727095289; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GV6Qavvmkl6w+Qrw4EyS70WlfiOWC0YssBlS9J9YVb0=;
        b=D4F2pKtmRr0OBn+bsJZ7NyDP4FvrCqK/FsMHHghFLR+54wWshzwU717T73dywf2tO4
         satPc/TsujT9YG8iV30ImCAVQikRB+x0ozX/mNrqEjhOeNzeENXuMJyjRxDyPNbuSxJ5
         Xdd3ynGLYRRulXpuhxAS7zd8yNBx1u+ZEoDf9l3mbwT+1fmxrs3N+zgW0N5tYWR0cUfr
         xpdIkE39XiOKt4rMQGRQxX0XJRpnrwVUnRCp2XHy0G4GUahD8zvYD9agCjs8hCZM6/SB
         tTZ4bZ2kQPvlYLQcSFf2zUQJ9ou9BfCFAybA4BUs6vbSTJB7MWVojwAvbDCXNR4aEHqX
         Oafg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726490489; x=1727095289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GV6Qavvmkl6w+Qrw4EyS70WlfiOWC0YssBlS9J9YVb0=;
        b=HVVGP8IKx5EgV0TnRbIw1IWRdtum9Njgj1OFAL5ycw4/+wXDWtCFkcLf91pCmiwv1E
         4qTV2Aj2CNP4Rhfbv93+pN+6L7JUtoaZONUe4LjbQOZbmzk7LuRKxepCBtb2N3Zm8hmi
         UFikJCl6A7tXHeE+QBFlVOiSJ81gn4C0v4cEvANk5HQXNRU0EEsmpD2KlRrKsS5V7KK3
         JZZPdHcKyY95+GGX9K9cWCamEuyTikjVjFEWQiJmDQlE18tpPhCM8SvQCKW/KAY7M7Dh
         u3Z92bVy33+mSllevEi3a+BfetvZGdhxYSbSNU0H+uIMrSEoRwI0oARMlSAWW2REnIOT
         D5oA==
X-Forwarded-Encrypted: i=1; AJvYcCX+vNds7nqTmDbMJKhbg6GQNnsAPkxmn9dOtC7HaqafNJ/xDk6aWTnBZW1rVLAigPRF7Cc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsGSc3cGaCXQ8mRY7+2srz1ZwIVksMNcmK9CJ1CYYjdQY+wxVU
	xDigkbbkiZKhg776IPV3mz3HB5Re5vLi3cX0lELZW0dIBiAlnKEE0ABjWhBnlEI=
X-Google-Smtp-Source: AGHT+IFnPigrzANCemZ9VtsGTqNDvB1a9yTdTADsvcOLtZZYeHwglJ1hZd6gPRX2GFqfyECMP2QLKQ==
X-Received: by 2002:a17:907:944b:b0:a8a:87d5:2f49 with SMTP id a640c23a62f3a-a8ffae3a20cmr2140430366b.28.1726490488745;
        Mon, 16 Sep 2024 05:41:28 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610966ccsm308905866b.45.2024.09.16.05.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 05:41:28 -0700 (PDT)
Date: Mon, 16 Sep 2024 14:41:27 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 2/2] riscv: KVM: add basic support for host vs guest
 profiling
Message-ID: <20240916-1d1835e5f16d58c674fdef5b@orel>
References: <cover.1726126795.git.zhouquan@iscas.ac.cn>
 <86e8f4eeb30dfc8700089cd88616e6cfb5a142ff.1726126795.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86e8f4eeb30dfc8700089cd88616e6cfb5a142ff.1726126795.git.zhouquan@iscas.ac.cn>

On Thu, Sep 12, 2024 at 04:00:38PM GMT, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> For the information collected on the host side, we need to
> identify which data originates from the guest and record
> these events separately, this can be achieved by having
> KVM register perf callbacks.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/include/asm/kvm_host.h | 10 ++++++++++
>  arch/riscv/kvm/Kconfig            |  1 +
>  arch/riscv/kvm/main.c             | 12 ++++++++++--
>  arch/riscv/kvm/vcpu.c             |  7 +++++++
>  4 files changed, 28 insertions(+), 2 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

