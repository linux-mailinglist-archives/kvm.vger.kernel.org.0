Return-Path: <kvm+bounces-8120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42AFC84BC8B
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67EEB1C22ED0
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 17:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E88BDF67;
	Tue,  6 Feb 2024 17:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="qJs4kVvo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72C1DF42
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 17:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707241953; cv=none; b=SJXc1glbdQ1sDI4Lv0fELLMHq4YdMwSigDFp5cvp6HlbxQvMghlO+4o+FJD2U0JwNuom2ZgiwDAsUZk8kzzWKMbEq8+NkFfpBF15SyNHyvhPonKhtK1no80owADJz9Bp7MsEEh89oNekyUn7YbTOgraH6/lRWhn5KDC3q1HuYJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707241953; c=relaxed/simple;
	bh=UEE6ppXa6AKzYlVRQa3E9/E8quiqomtGZVkTgFtROrs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J84DTmbWK1Vsrg7JzDYkQSxQo2SRmeQHUgdbbQCC5Bg6zC0D71BEzTPgwC87O3ziFp0A8KlmaOsYHqbn0KtGHRsTIw1kyPpKzFsJPW7kr2Bm+ZdIvI4NJxiRD2xsFgoN9XM9Cnm+Zqc90umqSWuHSojuNsweylsXUX7q4qgvBC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=qJs4kVvo; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a380a1fa56fso162142966b.0
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 09:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707241950; x=1707846750; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Hxcqa7giXhTiEbDsalnJIyrGG1Ev/Xk5CDBOOwyBCU=;
        b=qJs4kVvoVAHOJB5GcQNPHMOxvbM5prdwjezzapuoegRpa6HCahzODS+8v0+o2BI8b3
         /qQETx80WTvlSPPwT8R/OgWrOrHWM+CHIMGL/3kgRqwH41KsRDLB+q8q28zi++BbVbAs
         xeXDeiFoaE8H4clhEIW/BEqlR3InyDiiIwQBhfW6D0bOvLIOZRX1XSfsLiPSCEfMzngR
         BHISmtfnASJGMB7qhDowdwd+17B6B9WViNZ/CSLiarcpEXLHKhd1ANHgRgVebnpEdor8
         NZTyzwth4yTbbf9k6fIS77A11BNgeB7+ntDkRXJ34fat6fUlWRKVeQVuG95L1UdYJeum
         F6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707241950; x=1707846750;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Hxcqa7giXhTiEbDsalnJIyrGG1Ev/Xk5CDBOOwyBCU=;
        b=pexoOp5XPkzRoq/DLgTO7gDYRVKH7vcy6TRnrbT9EfJtVWXbHJmtQJxetGwd9ywKnW
         tasJ+6+H4N26FM0TUgrzULRHauZlP9dY96L3MyVmrYmTNoNUVtiTs8cj0fYKoaeqlrCI
         myvNyi9KWJmFE7PX1OHuM+NKTiPwmuatCLr0CyM0C7fvX4rPxmqiMfX4a9x5haCOI1xO
         HvYxfFTGjXh+XFgzC4zi7J9FymbFb52QaS1qWAJ8LHogV0VqRiEHysr90gY0CoUdZpwC
         Onyy6TWiZCqD0EkHAjY4LSQ+W5ODvp4OmKFMw3wjSixnE+Nl3yZVe2NUCfhYxaTvoU2W
         uznA==
X-Gm-Message-State: AOJu0YxHa9dzasiHy0E6mF60zQUljLu24BmmCTKW/sDgjIdHRf1WwaQL
	QywyJ+ZoZmUIQKtITg/3PoQqBI1D/nwpzFFLi4ZGS9/YpT99tKfQSSK6uy3SjqM=
X-Google-Smtp-Source: AGHT+IFOsb6Ogx2qctY34Q3leadhu1OoLolBKboU0xx384zzPPaT2chxX+Mn7VAgLavST/7oGzjoZA==
X-Received: by 2002:a17:906:6d04:b0:a38:5443:f4e0 with SMTP id m4-20020a1709066d0400b00a385443f4e0mr704052ejr.19.1707241949708;
        Tue, 06 Feb 2024 09:52:29 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXSF4K7LxVyebHcyyWx7gXuzn/amlWHU3eUplO0wx/L0abHnVMk4zBvRKPmaxzoG2z3yg0eaIhTX8QqzxGwfpOdsBb8
Received: from ?IPV6:2003:f6:af18:9900:571f:d8fb:277e:99a5? (p200300f6af189900571fd8fb277e99a5.dip0.t-ipconnect.de. [2003:f6:af18:9900:571f:d8fb:277e:99a5])
        by smtp.gmail.com with ESMTPSA id h25-20020a170906261900b00a3701b05115sm1403452ejc.29.2024.02.06.09.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 09:52:29 -0800 (PST)
Message-ID: <a8889e67-29d7-4133-81ce-6f6adb7a478a@grsecurity.net>
Date: Tue, 6 Feb 2024 18:52:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] KVM: x86: Fix KVM_GET_MSRS stack info leak
Content-Language: en-US, de-DE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240203124522.592778-1-minipli@grsecurity.net>
 <20240203124522.592778-2-minipli@grsecurity.net>
 <ZcEsG8ohXfgcYvB0@google.com>
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZcEsG8ohXfgcYvB0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05.02.24 19:42, Sean Christopherson wrote:
> On Sat, Feb 03, 2024, Mathias Krause wrote:
>> Commit 6abe9c1386e5 ("KVM: X86: Move ignore_msrs handling upper the
>> stack") changed the 'ignore_msrs' handling, including sanitizing return
>> values to the caller. This was fine until commit 12bc2132b15e ("KVM:
>> X86: Do the same ignore_msrs check for feature msrs") which allowed
>> non-existing feature MSRs to be ignored, i.e. to not generate an error
>> on the ioctl() level. It even tried to preserve the sanitization of the
>> return value. However, the logic is flawed, as '*data' will be
>> overwritten again with the uninitialized stack value of msr.data.
> 
> Ugh, what a terrible commit.  This makes no sense:
> 
>     Logically the ignore_msrs and report_ignored_msrs should also apply to feature
>     MSRs.  Add them in.
> 
> The whole point of ignore_msrs was so that KVM could run _guest_ code that isn't
> aware it's running in a VM, and so attempts to access MSRs that the _guest_ thinks
> are always available.

Yeah, I was wondering that myself too. But I thought, maybe there's
buggy QEMU versions out there and it's because of that?

> 
> The feature MSRs API is used only by userspace which obviously should know that
> it's dealing with KVM.  Ignoring bad access from the host is just asinine.

From a quick google search I found, enabling kvm.ignore_msrs is a common
suggestion to work around Windows bluescreens. I'm not a Windows user,
less so in VMs, so dunno if that's just snake oil or sometimes works by
chance because of returning "random" MSR values.

> 
> At this point, it's not worth trying to revert that commit, but oof.
> 
>> Fix this by simplifying the logic and always initializing msr.data,
>> vanishing the need for an additional error exit path.
> 
> Out of curiosity, was this found by inspection, or by some other means?  I'm quite
> surprised none of the sanitizers stumbled across this.

Manual inspection, yes. I was looking how MSRs are handled in general to
answer a different question for myself (related to FSGSBASE handling
resp. the lack thereof, but completely unrelated to this change) and
found this code just a little bit too ugly and looked a little closer.

> 
>> Fixes: 12bc2132b15e ("KVM: X86: Do the same ignore_msrs check for feature msrs")
> 
> I'll apply this for 6.8.  I think I'll also throw together a follow-up series to
> clean up some of this mess.  There's no good reason this code has to be so grossly
> fragile.

Thanks,
Mathias

