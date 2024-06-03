Return-Path: <kvm+bounces-18641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D1D8D81B3
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6A25B235E1
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED88D86ADE;
	Mon,  3 Jun 2024 11:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A+uQHyXv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81DB84A49
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717415774; cv=none; b=T3ePdWZ6PkG0XSJiPw3eb9APkUP2yx82/cIl+H5909zsN7PoHXuwgK5w21Ht6B2NW38sN36zilTP3Sm2Av9i8aZDo/MEH8samqJvUqemaIBR+3XkqzfkKGZQAiyoBiz1ntysOcazT5+jNhR3mrKJXYON0sRYuZ1Hnnyq5s75j4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717415774; c=relaxed/simple;
	bh=XJEC/B4uhAgLk6EAxMOUwh3tuLIakX/Zi7ywfYEhcVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TINfdOmMQIcHU+S4qZzywJRceSiYfPB7FnzAjvOvM5oq7Fagx24UMVvb3ZO5wNSad8tUGHUiaN+aRx/EDrc9LoU0b+Fxt5/OHCn/rTc8YXkKZq5vOh2HuPY1M+6fmP4/b5xE0pfQxlDFiEonxcM6HC8AMDg3XkOrbtRBZq7EBA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A+uQHyXv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717415769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=O8e5+PKQhh8KirLRZQvLEvNDQfhGdSve44+Cczu7Yxk=;
	b=A+uQHyXvDtC+knMGYoG4/EQRxEUtyPNCLJ2x8WTbqw8fsfhISVHt+SU8742VKUgmfDVG20
	L/lCWPGGwf/bseR1HhP6flpT6wVqXMMAsqXjcloEd52EjB4kaa0M49mS0aUxcoWn+NJiKb
	QjlPhbEotp1Kd0CAf7Tlessf9oEdpIg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-Z-delFAOMLOilNEQ-Waxgw-1; Mon, 03 Jun 2024 07:56:08 -0400
X-MC-Unique: Z-delFAOMLOilNEQ-Waxgw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-35dc02b991eso2289875f8f.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 04:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717415765; x=1718020565;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8e5+PKQhh8KirLRZQvLEvNDQfhGdSve44+Cczu7Yxk=;
        b=NY0DcouCu4iTznFIsTVkDw3iNyLQZ83YwUZ/liWfOfJhmKawlzvyeD9n5fkvg/BVi2
         hP6Y9IbLNz7TCeywvHWDiCGRadSxSUDsgPU3y9L2Cj9iA4K7yVb/6QdxOlVe7coBpm1N
         jw+/B1p1ys83a+EJgtA0h2DuSJH/VUJmGhTD2LDTVc48282bArqNptTL3P/3dbqAGFfK
         aAfAON5vQvjeOT2SdJo4OWkWhf6++h515XjVhkwQV0Uq+J63G6NigIATOAw/fhj04xqD
         hT5jgNERyTRC8KIHPKjojzqTd/y6iFOuXvazv8dBIYDoRWNDoDgYqPNdA9nl7PwoFEyo
         BHiA==
X-Forwarded-Encrypted: i=1; AJvYcCWtAenD/zB6AXLk+PJyFuGaiaXJrzWEY9+0x59KfaFp/6R/hKwBElJktNVeMJiodXPxnQN7a7cjmCl6Yxa3bmRxYB8Y
X-Gm-Message-State: AOJu0Ywggc28oO6ArSxpcuGM2J7aWO3VCeJQgvbPjnp99FJFuOP9OBuv
	2nPkIvBoIOadNMvAj9x7wdBLQ/uTSxda6rodOYamGN8itiZYWLMZutEgtVnfKHRVT+apqDeU3/e
	CKQBVThGwCuLdn5H7MALHsWp7p8hQ3CdowJ1+FfOiW77dXktuVQ==
X-Received: by 2002:adf:a189:0:b0:346:92d2:a496 with SMTP id ffacd0b85a97d-35e0f2852f6mr6150352f8f.29.1717415764859;
        Mon, 03 Jun 2024 04:56:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuWqIirAQ+VHnp40beRP4/AfgO/I/Awh5FXaoVZpoFOgAsvmH14g2EzP1NeRHPVksYNF9cGw==
X-Received: by 2002:adf:a189:0:b0:346:92d2:a496 with SMTP id ffacd0b85a97d-35e0f2852f6mr6150336f8f.29.1717415764470;
        Mon, 03 Jun 2024 04:56:04 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-229.web.vodafone.de. [109.43.176.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04c4388sm8692285f8f.14.2024.06.03.04.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 04:56:04 -0700 (PDT)
Message-ID: <cebdd4e9-4754-47a6-86c8-283eddd797f8@redhat.com>
Date: Mon, 3 Jun 2024 13:56:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] scripts/s390x: Fix the execution of the PV
 tests
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Marc Hartmayer <mhartmay@linux.ibm.com>
References: <20240603075944.150445-1-thuth@redhat.com>
 <b3444016-91b5-40cc-a4f2-9cb0f5c0cc28@linux.ibm.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <b3444016-91b5-40cc-a4f2-9cb0f5c0cc28@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/06/2024 13.05, Janosch Frank wrote:
> On 6/3/24 09:59, Thomas Huth wrote:
>> Commit ccb37496 ("scripts: allow machine option to be specified in
>> unittests.cfg") added an additonal parameter (the "machine"), but
>> we forgot to add it to the spot that runs the PV test cases, so
>> those are currently broken without this fix.
>>
>> Fixes: ccb37496 ("scripts: allow machine option to be specified in 
>> unittests.cfg")
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
> 
> LGTM
> Has this issue come up in the Gitlab CI or in your internal CI?

Gitlab CI does not run the PV tests yet - I just noticed it while running 
the tests on the s390x machine that I've got access to.

  Thomas


