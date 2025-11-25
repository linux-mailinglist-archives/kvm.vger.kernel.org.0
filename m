Return-Path: <kvm+bounces-64488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A902CC8480A
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:33:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D59614E351F
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B3A130DD12;
	Tue, 25 Nov 2025 10:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OIgXMlOt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCB0211706
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 10:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764066828; cv=none; b=cqlEi5XEmH7SLuD9KIRGserfAW2q0CrIuPNwfZkEhGnfKbneXqUhSa6tgMapCLzHFeQpoedg2WLKndlGC14itJg7TcxldOmaNV9f5mEym2LWCilFoeGDmFtuL13mEHOaxUaXGeOtpl9EFBE2HhIeRoARbdrs6IJaiwElpLJaU0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764066828; c=relaxed/simple;
	bh=OZVr2bVw4SkRkSwlFuytcqDdtqhW2Rzbq/iiKxXR4/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/6X/5nX+LNBDWV8cPqeDMJ6CLX0giVZUDgy3Bo6GN5xw9Q78yHLCu8wvkPA3fZ43h5rq4EdrfODDAUGn1y8gKZ1LE+XciEJjHniGt+AkCDv7RyHNV3aoWUAxrFm07WovIkoNJ+P6/nck+99ngVRkkXu0BsD2I2PqXhdf+rD7Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OIgXMlOt; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so44142265e9.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 02:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764066824; x=1764671624; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qVEkuuFCR7NbtFW0OlDkWq+pV/uCWFvNJVFGsL6m1PQ=;
        b=OIgXMlOtJkYVrMIrbHohvRaaX446qBul1aBNxKWOYIldBJT1W2iaEacLzDtXWC4EQ0
         MVJ/dSmCa01UThhwuAkuO+p0wbvUkbVQuTCQBgypJ+PxjuglwFSnSKxDeVd5wuS2u9Ig
         nPeAAUVmipZ2iKd54HOKo01DIhyUWjUcMDLwAgg4NsaHscNqMr3H4dACvI6A45X4/KKh
         o+VPiWiXd9Y7OItRqFTnfhjdilzJY3dRTmpspPbmJHh8445R0Ue2yr3PlVdCCTqh+QKu
         /z540N9lMJIieoJbsQ2/ODUd2YFQYRq8LzuaolHd/yrO41Fp8B9bKi2qIZPoIz13znrW
         7z2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764066824; x=1764671624;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qVEkuuFCR7NbtFW0OlDkWq+pV/uCWFvNJVFGsL6m1PQ=;
        b=jwe8RA2hUiAPKiDNz7T6UwtJXO3HTbcHNVQ8vmSWXGbltaphnH/sc2O7JdxFqSWzH0
         KgOxAtdJypvACeV2BIrXzj8c9r2Ed89UDvBhUtsxS1lNXDq/5PnHtLvZK+UB+W1nOVhn
         w63iPevTLLve8MwZoejY0gc5crIEs6kyvp6id3saYLSixjh1PNBdatp+i9ssbDBP8VUr
         hWie0TBAPqLgvJ7faDeN/p4NsaJuiMZdY2KhR+UFIP2de5F8NAD86RJIJ6/MK+g8E7qv
         bdOGHtvsxx2lgTofq/VdXJQzG5PUML0NUnd8bgS2ZifVbMn3U31z0K8Z+Xlx1QUb+Fay
         JZyA==
X-Forwarded-Encrypted: i=1; AJvYcCVeUVVqv1KKZ/wHq+ybCG0uJZBsyG/lABrM2hnwoKsNSGAOQXkwXkKHcJ1czHxgl9zdt84=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbtuQINZmBVxBUvSbM02WNjpqUrUKqnMj0vUhC0aFQv60aBlkJ
	5RwSbhmSGqhwo8jTb0CpmPdfh4Vgqd1QIpBD3Nt2c2jlUMBzRhDMOwd8kwvq8r3o7VM=
X-Gm-Gg: ASbGncvnB9B5CBV1BGlM/REdLf+kLrLwPcYQRedt5yUXg7j9VLDR3ECubvq5sHMwPvn
	0VVx4/F3c6lknzPU2rlNlcmOpdP7BSc/X1iuBXgURiVAO55TfWNuueIrWZlyDPpv/X+newVMXgv
	sO/dkrFAoe6MxnxOkg3MfhkVv3DEi2C1ugNJtifgzCSKVvUIpEpq2jvKuL6ewkoW44HB+cZIfnN
	Fu0rY+Xur3asc2Brg6vrEATABlXQUcIVfQtZSsdFbEWq7UlHsLfj8aBFxyr7a57FL0AeUctXQOF
	/kV/W9piUMg0mTQ3PFlWXd2b1t+AjNVXHdbfjhYHH7JTqLNH1eQbY+/yOTXVzco9sZ6uzYnWfL/
	WlQ6xvB/DpzVgQ2WggFWjE70vU6OBDwEjrC7qziRp08VrvyFzGp2gUnl4stdheOVLkHLGb0h6Zf
	BAN/neHWTRE+lQt8b9OzkcnHuEe+TW3enu0lTrXNHTp3qEmjEoTU4Xlg==
X-Google-Smtp-Source: AGHT+IFApPn6Dh96fqRXcjIGHqRxteYfW2Ih6XJVhmqOm0vC/WSJ4vAgpMhfjPAF9VAusNd5lbB+qA==
X-Received: by 2002:a05:600c:1c92:b0:477:7f4a:44b0 with SMTP id 5b1f17b1804b1-47904b2c2c5mr22072355e9.33.1764066824607;
        Tue, 25 Nov 2025 02:33:44 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf355af6sm245789815e9.3.2025.11.25.02.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 02:33:44 -0800 (PST)
Message-ID: <bdbb568d-0432-4d59-bd1f-cf2eb20bc2a1@linaro.org>
Date: Tue, 25 Nov 2025 11:33:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm: Don't assume accel_ioctl_end() preserves @errno
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, eesposit@redhat.com
References: <20251125090146.2370735-1-armbru@redhat.com>
 <875xay4h6y.fsf@pond.sub.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <875xay4h6y.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/11/25 10:03, Markus Armbruster wrote:
> Markus Armbruster <armbru@redhat.com> writes:
> 
>> Retrieve the @errno set by ioctl() before we call accel_ioctl_end()
>> instead of afterwards, so it works whether accel_ioctl_end() preserves
>> @errno or not.
>>
>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> 
> I did not check whether the assumption holds or not.

Indeed, on Linux the futex syscall is called via qemu_event_set.

>  If it doesn't,
> then this needs
> 
>    Fixes: a27dd2de68f3 (KVM: keep track of running ioctls)

LGTM.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


