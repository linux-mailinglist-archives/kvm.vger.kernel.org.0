Return-Path: <kvm+bounces-20600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C20091A49E
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 13:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C63B31F235AB
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2157B146D7F;
	Thu, 27 Jun 2024 11:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ec0BCH7F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C916C13EFF3
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 11:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719486518; cv=none; b=UJ+4yZOoI3LBuN/8rD2hgExE7QXaa5qK7KCV/flnGR6i4VSBCAH/qcLqSMCl0g36Yh5/w6ne1nImbhjMmdRgz9zFXtUGQ7+e0DvfsJz39uFyl1Mab8xE78NHkhUNoKZufLzQCQjT9vTzGEop5a7Kgj4UNR+YMBk8aSey3MUG44Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719486518; c=relaxed/simple;
	bh=ud5eb5rdqtjJmcbNqo/LrGRxP/q+QNr6BrzIbEdW5+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eIiKF8doX3I42XuF/eNm2ABsckG9R6Vsq2rHUrBxVE25SwrJMpUvdfyg1iPSwYTSABNp3GtrztiwHiMHWS6Fdf1FtOL+ffO77vdDCVHz+unwY8CWbcAfZcOi/pynAyHoNeqKu6J3YIcOqbLFNBW2elgKzSFEhqla7DCkN0adaUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ec0BCH7F; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ec595d0acbso59467741fa.1
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 04:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719486515; x=1720091315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o2XCYxT40DbL9y2Narcb3mT+cwq7XXW09HIX9xIHGkM=;
        b=ec0BCH7F+VSA0sGwZQnziZQA5FrQHHqRp9ICR8/yFDYVP+T3s6JZdUoMP6iIKq3tIq
         BIjfikIrOwAnmJ8ywUm8mCvRNy8uTXfqFQkTQvFGnFIQBrvtPJN1GMr4wbZgOr9Oesa0
         soE+JUk07PWG8/WXMJuXRQ5PK0geWUOxPppyBGFIicHHWv0GBO5rpmUuxfc7oj6ZbYLx
         kXUxvRIF9iFqILoEyRkiaSHAtOQFIPRKSLh57TcevD6TOapjFdqxIGZTN6HI6+Sdklpa
         F4/fU2UhHuZKSjKalBPB8Ay/I2wdXs3IRRvNyXGk66edAxP7VQYcCCL7BsZoQDPzdplZ
         6ANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719486515; x=1720091315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o2XCYxT40DbL9y2Narcb3mT+cwq7XXW09HIX9xIHGkM=;
        b=Lx52sgrOa9GrkSLF63qIcYu6AxVn4SKaeBjZnAmoGlB9p1J/heI+gfMa4lfw5+683a
         5BA1HtwNP6ATJKSQWxzouOzVWDyAFsvwlazbZNAZTCIOxMJBDNyPtlfUYB2TN/Z3zkQh
         /AubZvq641GeCNs95Kg737cyOMzZutyudjGY24GSeNHLLVFwGtTQ9NnGP4A5jV69aADX
         wir+f7wXUc15jdtly1++dD+e2InEIZzXpsL+vD7mTFz3wZZHYYjfT6EOujfMBIOUAl25
         qPeiRZA0ZvX+q6OgkaldbbssCX5YK6W3iKyPwXMqaFDW4d1i1UUw678DcYVV8gkAYjRg
         xzSg==
X-Forwarded-Encrypted: i=1; AJvYcCUGO54lhtXZ4yyE6/A7cS7k70kCSAJ3bOYfi0b+dqXG5zllM1reNhTnPedlkaCLUwH/LOAekQyWybBteBWu1KtMY2GI
X-Gm-Message-State: AOJu0Yx42/DC0Zaa4R2dq+CtRXGiObnfwID+yjANH3iooCGws+H/OAyV
	FtRUSBZgXXyKpAxKpTmfyRqNpGkjqjqiihRUnKxGBEHxfn9EJcI269L2A5TpDI8=
X-Google-Smtp-Source: AGHT+IFcbK8snw1UpZCkkK/fbYRXItddDuleNKKncMy49sWuS783EwY8WSMh1pgnqOSBF3yKu88L8A==
X-Received: by 2002:a2e:a442:0:b0:2ec:5019:8fa4 with SMTP id 38308e7fff4ca-2ec7278a341mr44327031fa.49.1719486514989;
        Thu, 27 Jun 2024 04:08:34 -0700 (PDT)
Received: from [192.168.236.175] (72.red-95-127-32.staticip.rima-tde.net. [95.127.32.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-424c8245da9sm61189205e9.1.2024.06.27.04.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 04:08:34 -0700 (PDT)
Message-ID: <43547a69-1caa-474b-96b9-e76b65100f9b@linaro.org>
Date: Thu, 27 Jun 2024 13:08:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] sysemu: generalise qtest_warp_clock as
 qemu_clock_advance_virtual_time
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jamie Iles <quic_jiles@quicinc.com>,
 David Hildenbrand <david@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mark Burton <mburton@qti.qualcomm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-arm@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Halil Pasic <pasic@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Nicholas Piggin <npiggin@gmail.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
 <20240620152220.2192768-7-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240620152220.2192768-7-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/6/24 17:22, Alex Bennée wrote:
> Move the key functionality of moving time forward into the clock
> sub-system itself. This will allow us to plumb in time control into
> plugins.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20240530220610.1245424-4-pierrick.bouvier@linaro.org>
> 
> --

@Pierrick:

Use 3 '-' if you want the changelog to be stripped:

---

> v2
>    - use target_ns in docs and signature
> ---
>   include/qemu/timer.h | 15 +++++++++++++++
>   system/qtest.c       | 25 +++----------------------
>   util/qemu-timer.c    | 26 ++++++++++++++++++++++++++
>   3 files changed, 44 insertions(+), 22 deletions(-)


