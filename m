Return-Path: <kvm+bounces-41075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB60A61513
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A08D883E57
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420E920296A;
	Fri, 14 Mar 2025 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bIueEY/b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED62A7081A
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 15:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741966496; cv=none; b=Ad4DHBNlAO9009uaxdo2dCX+473WH3drjCQaw+DjceQ6T4A1YBnTshXSoRnJnGZgNGPidSq9OD9iZTNYB9V1rBWJUKClvy2UNJUpEKhR9P7gfiAV/fXXZuJZODW/FpHL+ykHHxBAqn2rzEZvmXVBULnsihcOW2iOrRRF9UiMe9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741966496; c=relaxed/simple;
	bh=ufhNrf4TC4B1qsP2tLLhXQwR7ucshSA5pGUrOoXUcyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LufgQlq1v9P/CrwDtpe+ODXAZP3vWzu5x+iOYtELL2Nbh/hm7+XbOWpintehSXPKXaLt1URfcgg91i+eicOlJ9DaZEPhJ64fBUacl+lkSwq1XjYA64s8XJqwy57jdh/fLfC49dBmw79glmshrxLZq3lKiJDpWc/66iP+9G/vc5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bIueEY/b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741966493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3hf9EGY507xgOdKl5PqvUA6OV/20OWtgDQf4mTrf+oU=;
	b=bIueEY/bAtsxDe9s5eqBD+eEljOA60S5kg07LGSG+yC29XzfTQXH41ZcLbFrnR7DUM5nGY
	5Mq+aIYjfJqcRRyAtMDmphE871K//chn1klyIXo35+smZx/+5Z/MN7CsObvk0vo4aV2bd5
	ahZAY6XK5y2jVNAEMC+r6lY9aWi+99Q=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-cwu7lZcoOqCFwENHYGFVMg-1; Fri, 14 Mar 2025 11:34:52 -0400
X-MC-Unique: cwu7lZcoOqCFwENHYGFVMg-1
X-Mimecast-MFC-AGG-ID: cwu7lZcoOqCFwENHYGFVMg_1741966491
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ac27f00a8a5so208671166b.3
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:34:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741966491; x=1742571291;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3hf9EGY507xgOdKl5PqvUA6OV/20OWtgDQf4mTrf+oU=;
        b=xUc/jQLUQfbqNWDW/jeNMgz+kCcHt/6wJUQ6ZzSOpYtiG6xcO16V7GeMenLw6mnWdu
         F4Dm0w4xaTlER63q73mhRXUTfjcOutVqkAmJzhvyszIFj7j3bZfpCpFvWLumrAkVRkY/
         j0tm8dDJcVpebEnVtjDhlToZ7wteCwTv7KLI2hNqVbHD+lwyJzGq5fEo9mX0I51klXA6
         idsLOeDH9RGd2DIzNOEW9TNKBjZnAQvjKr+2vmwKdH7fvH3XzE53zCEAG9vWXh05dLU2
         w6+12jOTt+XFuQ9bO6KU8J2lYtdhdicPO5bx5KmAjzsM3QtDcCkbV7Mp4kZJ0njAaZlO
         sHHw==
X-Forwarded-Encrypted: i=1; AJvYcCVtxD/BI0HqdAdiZqDhCrKz61IkTcmtaFr1iTOkq5T7aVbJVU/V/2/gy7SISQdrxKczLbo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxic1AQmYuXgwhir5ggjYbYvSKcxjzhi1QGNhvSszFwTHS/+8nQ
	h93wVPPmkGVMYHTHF4xOY9tYsDPZvST5os+w2WjgR/wgzJddP/zjAI+0p0/+xVdSnKhR0QEvwbh
	zXAjflHaW8nlMAOrFFlxFEIKaBCoC5/QShw0HDKxMhsPb83dwNw==
X-Gm-Gg: ASbGnctvRpjJpTavy9kAn4cDcvRVqnBJTrmhqfI8eno+wzZXYhvKpfzPvRN6TLoxzNW
	4c8FSuwGpQDUn8+1UEJIzNg/A02CzkIw77xHB2pTvxGSvXT1mlI27d4SwS1bHROyoYIpGZDPLQa
	jy6trtEqrx51/j5UWM3+6Wo9SBxoKULi14Yq7ySG9KUWIK10RINlHmFgDPjtAVydoAOC1lk41Q9
	vBxvgDCBOxdDEKkcwrHdJm4/Hsg5BBvNX3JOef98V9AtANkCC8o+oA1VN4gClgO0Mc8GJiP84oJ
	Zs2+nLN/x1ChbWBJsCIQag==
X-Received: by 2002:a17:906:dc7:b0:ac3:777:ed75 with SMTP id a640c23a62f3a-ac3304df63emr329834366b.48.1741966491174;
        Fri, 14 Mar 2025 08:34:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpKyqwnoPXJe0Dx/GwMzgbMpYZse4OQz56GHWwIROHPr+IMN93fKgn+YH1Eqq+gJNtgkDWEg==
X-Received: by 2002:a17:906:dc7:b0:ac3:777:ed75 with SMTP id a640c23a62f3a-ac3304df63emr329831866b.48.1741966490713;
        Fri, 14 Mar 2025 08:34:50 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.122.167])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ac3146aef85sm237249166b.20.2025.03.14.08.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 08:34:49 -0700 (PDT)
Message-ID: <f10cef8c-107f-4eb6-87bc-3d704f663c3e@redhat.com>
Date: Fri, 14 Mar 2025 16:34:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Provide a capability to disable APERF/MPERF
 read intercepts
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250225004708.1001320-1-jmattson@google.com>
 <CALMp9eRHrEZX4-JWyGXNRvafU2dNbfa6ZjT5HhrDBYujGYEvaw@mail.gmail.com>
 <Z9Q2Tl50AjxpwAKG@google.com>
 <2fd1f956-3c6c-4d96-ad16-7c8a6803120c@redhat.com>
 <CALMp9eRYvPJ5quwa7Dr1GgjPpmZVm+6TM_fkhA6KbVAdMsGH7g@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <CALMp9eRYvPJ5quwa7Dr1GgjPpmZVm+6TM_fkhA6KbVAdMsGH7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/25 16:33, Jim Mattson wrote:
>> It would be simpler for userspace to be able to say "if the bit is there
>> then enable it and make it visible through CPUID".
> Good point. I'll take care of that in v2.
> 
> I feel like I am abandoning my principles with this patch, but as long
> as you and Sean are on-board, I will do what needs to be done.

True, but there's a time for that as well.  As long as it's not enabled 
by default, stuff like this (or even quirks that _are_ enabled by 
default) has its place.

Paolo


