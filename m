Return-Path: <kvm+bounces-63694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 48226C6E04C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 11:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C5FC04ECBD1
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 10:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57EA34D91D;
	Wed, 19 Nov 2025 10:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JJPU4V5X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006CC34B1A0
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 10:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763548396; cv=none; b=QJMedinHzNEbiRW3t27eE8Tgc9irKk0FhNM+X+T0GM/J4DvWryxOGk5zTIYfBdICVpKRKPICq3lEVC8vgOmbquSunEP5bE3w0dSbgf1tYaOTWqOHbl5FE5MmPy/Dd/iue1jKy/ExtAi5CodIitpnmT6nOOlAVT8oyr5q+op7Uck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763548396; c=relaxed/simple;
	bh=KYLRHghd1Ft3FmD8U8yM89qqJxbzVYC92BGjSGnyaOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k7gVPfOVVvVYy5tnwolnufdRDmSTGOd2R5DstWfGsfRoNdE5kFKcuW4cVb5JOyc+dxeYuRrFsc5ayQY5J+XFrRX0+2mGhDDZeGLya3SUGF++AYiQudOR8ue4kAIEXobUrCjbCi+glyiLtQHiQFmycPJpcNzFL8OkfV7t4B5ZL/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JJPU4V5X; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so10213292a12.1
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 02:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763548390; x=1764153190; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=B0YdXtRcS8os3PJL3hVj9G4DxbppYK6sYzqe/7yQaRo=;
        b=JJPU4V5XEN3+RlWWVAgBqFtNinERbNdCkhVBejK6tYR3v6u3y+wfYE7y/S5Uit4mSV
         swMKqz9q0jojv29X9Cx/klTlbq17vtalIkaZ1D3oGK5UW53xoBEMebhELNqGNECmTDeN
         pGCgG+ARh2EywOT5hnDH9d+ZRAUjws+Pno6gvCtjHBGyBBl9FMOPTSeQTp9P6SK2RDZb
         v+3s78062vlVoJjtbn8jQi2VWIoUeb+JUctN+FkgG3Q1kQAweEHUme+GOBTw69Eri6rY
         2Z3SwXMiveG78Bnfu60nhN+LuJbbFrJrS3QC9TMHFE2hI6Tbv47ImT6ypVzmZ3X+S/NE
         /84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763548390; x=1764153190;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0YdXtRcS8os3PJL3hVj9G4DxbppYK6sYzqe/7yQaRo=;
        b=qXw62fzfUT8hwYX9hnLA+F8wyOKuTktrLbkHOrEG0fR9JFSIzKU0V3f7HKTV7mJFyC
         tc3UnQGhNHW1Dgv+NUj2sRyImMfPpk//fOO+K8MG0b88m7JdRDKiYE/qS7y86MhbiOir
         dwg2syyvBeeT56oPNh1CjOnPcTNQFbL+CciPaRO3kFegmcwaP4WnCf2chADUkKMQb4Wu
         q0ukMVw09cKT4fiispiOcYPBdqeBEquTv1EJlNBbpoN3sJRe6SrDYXyyCKHC5ipOneAY
         LVliT+zqpnOYgSLymf6OmBJFaakhqi4cqSYf9no8rEjcl6fBZ2BnvOtKeZR5n6YhqRqj
         OhCw==
X-Forwarded-Encrypted: i=1; AJvYcCU4ISJorzwY1LO0mRbd2uuq4wp5aY4q3SV56LHk1a4YXCXi0TVg5b+o0pVozKN+f6MpBHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFaInBDSB7yVhmX+I9fj394yvL1PTIHlOEw5Y27ZAgxMCcuBW0
	VQ0E86Se84YmG7NjcD4i1m9otdlBaJAyHPu6Est4rwStcDNxE8rqyzjyVWPvZrK0Iw4=
X-Gm-Gg: ASbGnctgPC/rXvV4iy42vC0cO7woFIRRzpXxrzqXR5mrkUgOtTHjwdroOStt4dKOqPD
	MSEv38u4ir8mH01eKwB9Moa5weqOkk8GmZ7ltk/FFKtGy35ZJBwqQOcwOHfOJy9rz0mxPJW2FFI
	Nnezdnw86Qq2ufdVrZyvUROYL2u5uU5em05/UfDWiSzLiIUbtIDgOWD4u8n5GKPQ6Jq65TqYhti
	CmgpNviRqUpbadSnlomM/vKaJpM35+G4uJEhZQlqQRRkN+ewBQpblvdM3ywPA8efIcnX4ml0wNr
	3ac2O0smpPNabf8bjODZmlLLTiIpP+kGobt35xRsbcV8xpUYBzJiPtno826O6SI3TUPMKR6Gpsq
	WELByVsCJTYHZVrMVVgX2tKs9tBqkLIYwn9OITEKjlNT9p/iyc8oWUrCUIXrIPt7FY4apxqARLh
	gfTuk9imDABxu8q6ChOk1zAiHwxjXFIJaYQgRwp+fUe2Ven8s=
X-Google-Smtp-Source: AGHT+IHZOSQ73VV5I/Rb482rwGQgTOMYTFla03maKxSXUiAVVdb6oiAo9BjkAhQbR7/07nMvHenlUg==
X-Received: by 2002:a17:906:b357:b0:b73:780d:2bcf with SMTP id a640c23a62f3a-b73780d2d63mr1326634266b.16.1763548389512;
        Wed, 19 Nov 2025 02:33:09 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fedb2eesm1577294066b.68.2025.11.19.02.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 02:33:08 -0800 (PST)
Message-ID: <6a7ad323-657d-4cda-83e2-58492394f44c@suse.com>
Date: Wed, 19 Nov 2025 12:33:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] x86/vmscape: Replace IBPB with branch history
 clear on exit to userspace
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>,
 Tao Zhang <tao1.zhang@intel.com>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <20251027-vmscape-bhb-v3-2-5793c2534e93@linux.intel.com>
 <b808c532-44aa-47a0-8fb8-2bdf5b27c3e4@intel.com>
 <20251106234055.ftahbvqxrfzjwr6t@desk>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251106234055.ftahbvqxrfzjwr6t@desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/25 01:40, Pawan Gupta wrote:
> [ I drafted the reply this this email earlier, but forgot to send it, sorry. ]
> 
> On Mon, Nov 03, 2025 at 12:31:09PM -0800, Dave Hansen wrote:
>> On 10/27/25 16:43, Pawan Gupta wrote:
>>> IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affected
>>> by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
>>> indirect branch isolation between guest and host userspace. But, a guest
>>> could still poison the branch history.
>>
>> This is missing a wee bit of background about how branch history and
>> indirect branch prediction are involved in VMSCAPE.
> 
> Adding more background to this.
> 
>>> To mitigate that, use the recently added clear_bhb_long_loop() to isolate
>>> the branch history between guest and userspace. Add cmdline option
>>> 'vmscape=on' that automatically selects the appropriate mitigation based
>>> on the CPU.
>>
>> Is "=on" the right thing here as opposed to "=auto"?
> 
> v1 had it as =auto, David Kaplan made a point that for attack vector controls
> "auto" means "defer to attack vector controls":
> 
>    https://lore.kernel.org/all/LV3PR12MB9265B1C6D9D36408539B68B9941EA@LV3PR12MB9265.namprd12.prod.outlook.com/
> 
>    "Maybe a better solution instead is to add a new option 'vmscape=on'.
> 
>    If we look at the other most recently added bugs like TSA and ITS, neither
>    have an explicit 'auto' cmdline option.  But they do have 'on' cmdline
>    options.
> 
>    The difference between 'auto' and 'on' is that 'auto' defers to the attack
>    vector controls while 'on' means 'enable this mitigation if the CPU is
>    vulnerable' (as opposed to 'force' which will enable it even if not
>    vulnerable).
> 
>    An explicit 'vmscape=on' could give users an option to ensure the
>    mitigation is used (regardless of attack vectors) and could choose the best
>    mitigation (BHB clear if available, otherwise IBPB).

I thought the whole idea of attack vectors was because the gazillion 
options for gazillion mitigation became untenable over time. Now, what 
you are saying is - on top of the simplification, let's add yet more 
options to override the attack vectors o_O. IMO, having 'force' is 
sufficient to cover scenarios where people really want this mitigation - 
either because they know better, or because they want to test something.

Force also covers the "on" case, so let's leave it at "on" for attack 
vector support, and 'force' for everything else

<snip>

