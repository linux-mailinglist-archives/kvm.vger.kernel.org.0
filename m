Return-Path: <kvm+bounces-23432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D56CA949841
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 21:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11C341C20991
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4962813C90F;
	Tue,  6 Aug 2024 19:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WcKCt0GR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C7842AA3
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 19:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722972542; cv=none; b=OBwJHuKGWChu0Ep+VxzPi28TnS0TrkHBL3203HQP6oEHEdKnH8CjcGpMPiWh5WfhH677Zxr8V+b0YD0P9UO6nb9X9s33mrzlai4841HvoOppfkR1lszPPrLaMMrdWFWFGNWwTbQPG/S1udvKb5eZsJjXRq9gKjSfF1xKiiRZGs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722972542; c=relaxed/simple;
	bh=KE8YWGSiAyM+FCy+bwqgsm5uB25QvgVw0isBnhbk4bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n95DzzgWEv916oOF91BV7jZxY79GcqBLx1FCeqSqjemS1UCW3WRhrO31K2sbUev3d/GkcQePur7Pm/t2h7xrgOnGpmZ6Uh26Teft+GlFEtgrBbPpFpBRzSWBS+T/WMWKbf688+usAjPLJwQywxbP0r2FsHDeUuDfhF39Bbj3VAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WcKCt0GR; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3687f8fcab5so477572f8f.3
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 12:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722972539; x=1723577339; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x9ggTlFpDeO3tzm3B+faf6LESHtYJaV4u5jSKjfZQ7c=;
        b=WcKCt0GRHXejOC4HhgGZNoqZtDdNl+PB19Q5728RgE64iya26itzfMGEL+RF2G162x
         iCnruQj+C8LdLuZ76aWwIH+5HFD3mjfuKvC/dOBZ0Tdy7APzTKcRds3RZkUk6NsIkjI0
         rOI2Yq7ZlTyFTraT1A0/p3cGfOrgfsMX+iO31kD6ANEHvjInulTxQDvo/EU4ilTKuITq
         aq3p5v1sqYEaF4Whlt5nnOSv461KULDkStPZWAauPKpJNxIDDtCyM+L3B70rOXV0UYSN
         uBmNQIPsvs/2dJVcnmcOfv7oMDWDtl+8mSHXSwyt8XWGjQ2AOYlilweGPKN6QCLk2nxp
         y24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722972539; x=1723577339;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x9ggTlFpDeO3tzm3B+faf6LESHtYJaV4u5jSKjfZQ7c=;
        b=Hepd1M715Us8lOlAZ341A1BbcvEXk5rDtT36Ippmc26Fv0L8Z20LCeliI0ZqLwcqmS
         6CzifrbupBwZ7/PFfYw+AHzp2cQoEGoxzcibmP8xVvprOcjlko+rCDsa45xINpaNjk8H
         9kntiqj8SrMs8NjnzfwssedV4Kgs32RL2FyZ+XXeFnAbZDZtxKHJv9ErnGm+TPJOGBS8
         hgb6JJJ8Oz3NztNA7sjRv+/NbadqFutWr+imzUwNTLrkea6DcxgGN4KGWg0umdbfc+I4
         lUsH03nGhoNvckMK3ApyNH79Ne1t3Pn4Y9ailEn1/4qbsv3xKCK49WjTKXCGiBvNZ9Q/
         IVkg==
X-Forwarded-Encrypted: i=1; AJvYcCXIAMuZyC+lh1jPqXsFXXLkxipQRSnnslZ/jqCa7bEm5mzWCcwQTMHcKTmfOZraZ39SLLyTlDvsWtkxUlcBG7upPtB0
X-Gm-Message-State: AOJu0Yy0Iag7YrZxp7ULBWsWSa2k6P99gOeKjps19IL3Hn7vUymEHB+M
	FM1f9S3siDt4iFtG/wWklZF1hyZp4cDvnmoi2Ke1hk9aS53tF4Do4V5qf0A9ZEM=
X-Google-Smtp-Source: AGHT+IGL95hmR91RbPW7U18cwZze82jNZRU9+smHhYyTBI74N3P45y9f5389mZP9Wnej1IeYT+r52Q==
X-Received: by 2002:a05:6000:dc1:b0:367:926a:7413 with SMTP id ffacd0b85a97d-36bbc189bc0mr8767580f8f.63.1722972538773;
        Tue, 06 Aug 2024 12:28:58 -0700 (PDT)
Received: from [192.168.69.100] (vau06-h02-176-184-43-141.dsl.sta.abo.bbox.fr. [176.184.43.141])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bc5a6fa1csm13026553f8f.78.2024.08.06.12.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Aug 2024 12:28:57 -0700 (PDT)
Message-ID: <640b97b4-583c-4fa5-8ea1-be6c120aea8b@linaro.org>
Date: Tue, 6 Aug 2024 21:28:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] tests/avocado: apply proper skipUnless decorator
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
 Radoslaw Biernacki <rad@semihalf.com>, Troy Lee <leetroy@gmail.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Beraldo Leal <bleal@redhat.com>,
 kvm@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Paul Durrant
 <paul@xen.org>, Eric Auger <eric.auger@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, qemu-arm@nongnu.org,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Jamin Lin <jamin_lin@aspeedtech.com>, Steven Lee
 <steven_lee@aspeedtech.com>, Peter Maydell <peter.maydell@linaro.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Thomas Huth <thuth@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Leif Lindholm <quic_llindhol@quicinc.com>
References: <20240806173119.582857-1-crosa@redhat.com>
 <20240806173119.582857-3-crosa@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240806173119.582857-3-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/8/24 19:31, Cleber Rosa wrote:
> Commit 9b45cc993 added many cases of skipUnless for the sake of
> organizing flaky tests.  But, Python decorators *must* follow what
> they decorate, so the newlines added should *not* exist there.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/boot_linux_console.py | 1 -
>   tests/avocado/intel_iommu.py        | 1 -
>   tests/avocado/linux_initrd.py       | 1 -
>   tests/avocado/machine_aspeed.py     | 2 --
>   tests/avocado/machine_mips_malta.py | 2 --
>   tests/avocado/machine_rx_gdbsim.py  | 2 --
>   tests/avocado/reverse_debugging.py  | 4 ----
>   tests/avocado/smmu.py               | 1 -
>   8 files changed, 14 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


