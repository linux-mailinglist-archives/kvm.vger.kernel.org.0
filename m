Return-Path: <kvm+bounces-25736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 968FF969ED0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:15:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 393D51F23D6C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 13:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218B51A42C5;
	Tue,  3 Sep 2024 13:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AFlp+OGL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A0C1878
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725369342; cv=none; b=oQfuPDzATAjdjgS6IWp9N0mk9KMrWicR5Ej/w7LQYO3/zD+JbXZC3ioNzqr9ROrVBGh/Ap2HCBf/PneIahu3AuypHziQm9/9VE0y6Zj3RnfS6/vRZVkcj4j8HMHugagixjO35gfm49GfFU00txtFPdvmqGnJHHnpKogALreobvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725369342; c=relaxed/simple;
	bh=ZUpmcNC+Ah7wMmQtuIot59Zbqb3NzhBzCZuS4tF/w4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BAnxWhxyVu0LpjuZZGAkmBZcjikd0jQZU4bDsSCRENb0mur1Rohr1Lw3cmmBqndMWsO5uS/BvQdNNDdOgGgy7YyBxG4VQtonL6/hIToqS+7ltuKqtA7A5u3cWBhAQPRc0FkuLBLjcqjxzURTZEmRZjBT5SaUPMlK5XE1qh63Tgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AFlp+OGL; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-428e0d18666so45383765e9.3
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 06:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725369339; x=1725974139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N2LD41fBqc4MjqU6fbyBgu4Sh5uUK5vzOa4pB56KxVk=;
        b=AFlp+OGLcFJw3DZ0+a/S/0fPc0COubMWx115/FX+33rBJap6SXHaT1xSSg8ZeNe3lN
         IbfpcC3GLvTRyYtih1S1/6MFaiz0ZZamoh8GrJeKQwpIj/pAcs8l1S9BbKK62iUJVNzo
         kZNyDqXpwEKSqe0Egem9p5UPfzlcw+A0D8XuYHIFXpbFaIcxFcj7Xt1u2UZBHBlpFa6y
         mTjdJh/PF08Em/sOggOUXsMXCOcm/krLxcq0CGLfJvY90MYaafkLtvr4ed2oW1eaiiM/
         QmKqDQ57ebxspU5cBzKjG1lEj3HXU936nQpXcv1szsrwNtgMT9KOwrzgErV+j85qYlo4
         gKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725369339; x=1725974139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N2LD41fBqc4MjqU6fbyBgu4Sh5uUK5vzOa4pB56KxVk=;
        b=WF7Jc165dcSLHyutu/0aky0t64SxSLy/PyYtbFvCvYIDr7ehlALFOVse81LSfjwY9F
         ZyPKn5jkyFoW5uFYhzQE70MTjZ1ZTquLhU645DUnRgiHcZOGR/U3eT1IcJkmVxhuqRbO
         oeSzfDSGI3Eib53N7hG8XygaEF78IlnSnPw5P9OHzgLgpfdTqaRJhNhH7QqvT9ZVI0CO
         ZlyDxHTPjLu8Ali5CkXx/UOzqHPEtN5MDt8VdQcOJm8Yyvfvnamn5wPf4Vy1JTcXIJMe
         gC7QEmezDBW5pQCXzqXKzYE8or2WULykWaoOrrnekDWYp/uNyB7o2HFULBB264YwZMDG
         masQ==
X-Gm-Message-State: AOJu0YysvZMOLooDwL1yK+RZ4LxDiH1FFydMvpXFrhrD7GshpMq6yZLH
	qq75kgTZ/8BI9NX6jE8iVPWfzK2Ah5ChqRm0VTUVmIbqyrRHO0c3SRgaKbSiCoC2vsAgZqW3MEx
	6/n0=
X-Google-Smtp-Source: AGHT+IGJA9jOm8dKh0eYPl6ERpSkZ+8uzbyXP7VqnnhhWI9sureiIzSzpSdlvzmXPs1VAP4TemaKGw==
X-Received: by 2002:a05:6000:1143:b0:374:d25f:101 with SMTP id ffacd0b85a97d-374d25f0282mr2569257f8f.18.1725369338542;
        Tue, 03 Sep 2024 06:15:38 -0700 (PDT)
Received: from [192.168.1.67] ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6df954asm169945835e9.26.2024.09.03.06.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2024 06:15:38 -0700 (PDT)
Message-ID: <0388418e-ad94-43fa-a375-73cbff27a2e4@linaro.org>
Date: Tue, 3 Sep 2024 15:15:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm/i386: refactor kvm_arch_init and split it into
 smaller functions
To: Ani Sinha <anisinha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20240903113418.38475-1-anisinha@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240903113418.38475-1-anisinha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/24 13:34, Ani Sinha wrote:
> kvm_arch_init() enables a lot of vm capabilities. Refactor them into separate
> smaller functions. Energy MSR related operations also moved to its own
> function. There should be no functional impact.
> 
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>   target/i386/kvm/kvm.c | 337 ++++++++++++++++++++++++++----------------
>   1 file changed, 211 insertions(+), 126 deletions(-)

Nice cleanup, however it would be easier to review as a series
of dumb "extract FOO function" patches instead of a single one.
Up to the maintainer.

