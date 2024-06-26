Return-Path: <kvm+bounces-20564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 069A5918708
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 18:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 090BF1C22DF6
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 16:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6839218F2D1;
	Wed, 26 Jun 2024 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o9mZYRiB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DB718FC65
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719418283; cv=none; b=QXOvjhKE9qLt2m4jwkqW9fr9kfmfR6M4VczPkr9Pz9q4WZBFdsuc7/DRA8iV1KNY4PdOCdFYA/PLAP0jrMngF4XIrD/PjPqwNah6ROJ+ibUsjWvhSOA9cLuuaNX6kFeRldd8deAijQZ8UoAhrnJezKfnVzMZfG7FGLyiLz0D6o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719418283; c=relaxed/simple;
	bh=6hPh2jNpnxRa+iRt/wOd9PFb9G5Q4pISzFnEJuLmEMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGzv2C034ZP/0Qh2cKckyvJcjrWmmpJ+3c05Wlt/LzT84ZAqdYCVgFhcR60sJwbFqjqccwwhwmtRBiA5qXYCnTafmQtlG/qm0Gt1SrQCJD5Kg8BIH2lx3IUAoRZSFyRuCnRqRFAn333Xiv3m69z7dzENo/QjOO4p5ydBKJC9ttI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o9mZYRiB; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-709423bc2e5so5340532a12.0
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 09:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719418281; x=1720023081; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6hPh2jNpnxRa+iRt/wOd9PFb9G5Q4pISzFnEJuLmEMc=;
        b=o9mZYRiBTDmvF1xQOvyURFP2Hg0NDIG9F8NdiGVgbPunfQXgTvcVGYlJUiP/7C/Z/D
         Rwbo5Y3jm8QGrmtxOF65wTHwhd4waHkJMIdXd04/VUtW5JSGEL/CIqUkq/wjrPL4LuJ5
         z3ebYqTJ3AgHjaNr7+2hynmVrYjpt+08UMQbDEuK1Ned5vSp/pmkmMW67FkQy5+02J7R
         iLdzup2f3BbwSudIT2JAz1KR+hvjvs/Ja9Ur1kmu+6KK6qcf0UIAf80+Tu+NVnE2CeS6
         JL+OCXoxrbcjpFLD1vsKebzvzVBJnj+OZZk550BJY8BwNRP2VibW1XSqdXihoPkauR0P
         2juw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719418281; x=1720023081;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6hPh2jNpnxRa+iRt/wOd9PFb9G5Q4pISzFnEJuLmEMc=;
        b=RjXX967MuwLWGxUVKPRZ4hLgYXN1WRy0J3WSFTjaDX8BT94jD9lSLZkIMMT4BXCs+Y
         eQeCP77YnYjs9iGKLAjIn4tItXfbeFNgJBo1gUkvxhHO0Fd4IJIQEj6gn1UNy3GEA6P8
         rhOz2VwUd0rC47iW63+ZdajWUrYk459OIet2Phl1IqNPufB4v4MtINBZjjUtrd5ZwG5s
         bGIXoxyWqiBtu8xWWKF0kDIIYThSm3QQpy0O+GSsGglGMy0dtdezCkc/26hn46uXd69S
         gMqAFmdnmDq5AJ6ScAENTcrL8firUWRqqpnBm3/d4VodTAHKACwLxwx0Nsd4tmDvjr2k
         xhBw==
X-Forwarded-Encrypted: i=1; AJvYcCVlpfcvVU8oyUeKIN45NpfCRWo0rgCiHUndjvaG+zqyPqxyw/mX4v+koVfG4C43hGYgjaJ51YgbxB+VM0g7ASiKNXCF
X-Gm-Message-State: AOJu0YxkKcb6aeQ0r1fbAHNEI0Htm5C7CkFn1OvBre2W30GruSvBV8Ed
	aj3M/xC3NFzIx8zzsL6Ti/vpPeZNTQGh1n4sc0IdmGfInJYOgD3CepvW2umxIzA=
X-Google-Smtp-Source: AGHT+IHC47SL3YL58+TOsXVm5csg84mkvIQSRf8ZA9YqVU1DF5X2zyje9Qa6k3HZFU0AH++1GHXfSw==
X-Received: by 2002:a05:6a20:da90:b0:1b4:da55:e1be with SMTP id adf61e73a8af0-1bcf7e75050mr14143102637.14.1719418281472;
        Wed, 26 Jun 2024 09:11:21 -0700 (PDT)
Received: from [192.168.0.4] (174-21-76-141.tukw.qwest.net. [174.21.76.141])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7069b36b540sm3308925b3a.66.2024.06.26.09.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 09:11:21 -0700 (PDT)
Message-ID: <730a96e7-4e8b-4d67-b7f2-1362d7473be7@linaro.org>
Date: Wed, 26 Jun 2024 09:11:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] target/i386: restrict SEV to 64 bit host builds
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
References: <20240626140307.1026816-1-alex.bennee@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20240626140307.1026816-1-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/26/24 07:03, Alex Bennée wrote:
> While the format
> strings could use more portable types there isn't much we can do about
> casting uint64_t into a pointer.

Use uintptr_t, obviously.


r~

