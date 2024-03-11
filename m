Return-Path: <kvm+bounces-11550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 064608781B9
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDA601C20C16
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C546B40BEF;
	Mon, 11 Mar 2024 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjHO2Jcq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2E83FE20
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710167753; cv=none; b=lUzmTYKX2nzCIlXcxafYTJkdbx+/qd/5odQx0y0n/GxwUEYlqg64gz/gLi1uLyGg/IzXkUGKt1HaUiUMsw2wWHzQifKPnDI1C1Fg7h49wYrJp3pjPCSueJ0EtFl+etyKNuZvEXNfm7whnVcy/X1bMo9bBMWqM0k2CRi+82RHUD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710167753; c=relaxed/simple;
	bh=lkoiJTksbCZErFzuqOyx/HHT4scED6edeNDIRRJqW3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QKTXcTXIf1PJ8jeU4guhI/Plgu6aZoMIMD7T7tD5G5il7YZsm/Zcp4EWoZgLz4GZyTsTHfBYyx1+cYsR4eBU73xBRktbuOuyzoV6TeCs1Ul27sSp1REinX3HmMKX8LKLgzyAA+Dn7KER4tQpO66gUjoL7LenglVitSoBcSKq0fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjHO2Jcq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710167750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gvu+1wcrc5tjvaQFe51dGXMMu6HyGWiHl6X3cU+orKo=;
	b=WjHO2Jcqk2Dyoy57elIaya2sfE/9F2ss/beHGPLgohDSDDW7sG1t9BQ+zb+4nqzbm88Zca
	rnJiP3azd1DROGqwXUUy5xxRe6GQIL88Skdj/TQt+KEoy1K54CZVoGRGFvL3zL6xrFmIA7
	B3xto4eJedLhLWg0WCNBFBcBKX4MpJo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-aVL3Iu94N3mzZn5E2Pzdlw-1; Mon, 11 Mar 2024 10:35:48 -0400
X-MC-Unique: aVL3Iu94N3mzZn5E2Pzdlw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5686b900b82so87627a12.0
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710167748; x=1710772548;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvu+1wcrc5tjvaQFe51dGXMMu6HyGWiHl6X3cU+orKo=;
        b=VAcTIpBGLoAYANnBoHiNZJLZVfzW/e8hG5Ged1u8ZFzjbxhs8xEyZNmLahPMIkzhJr
         q0K6Q8MdZhOojEzc0rw+6wfZggNxiCZDYKPrgKNVyVSlSl/3qBwL+AiwnRaz0sE78wuh
         mVT+QSBXcqXDK4uwlPuD/sPICUB5QnWkuWrnlZkHboNT+UzzvZbVVKoChJbyrYaC4G/U
         DXwNyjXXsXZQQkDJxZX5O3ifSvSqKivjbNWF2qqIM97cSgbdxbwIytSLzIyjQ/46yvpk
         CH0NlCOJXKrht9IaTAYKStd7XlE/ZncNWp/lukyM0yCjK3/Znsc5HUaR+zIrkAj5JJ2Q
         m+LQ==
X-Gm-Message-State: AOJu0YyaSUSvE/NQiXzqfx6M7B9gm5cCHa5LpFbM6AnYhAty1CNaBbhT
	9br9WYpFWp+Bpft4ql26Xv+YFo2S2zRIH6zeioki3llEKJKS/97/83U0c7NDaL/TvEt5Q3+GVHc
	CeJX2iXE3XihCPEBNKeT9iwbVvIjflJ7xeVPnt8QTVIvbYh+I0g==
X-Received: by 2002:a50:aad8:0:b0:566:b09e:80c4 with SMTP id r24-20020a50aad8000000b00566b09e80c4mr4311263edc.19.1710167747867;
        Mon, 11 Mar 2024 07:35:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5GJzW1MwAKdVPFXr+4oz+4aIry982Z+VpDEim0ijtLOpgIU8EqBwrLd87kFd8GONzruz6pg==
X-Received: by 2002:a50:aad8:0:b0:566:b09e:80c4 with SMTP id r24-20020a50aad8000000b00566b09e80c4mr4311249edc.19.1710167747563;
        Mon, 11 Mar 2024 07:35:47 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id s23-20020aa7cb17000000b005676dc74568sm2965882edt.92.2024.03.11.07.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:35:46 -0700 (PDT)
Message-ID: <5e302bfa-19a8-4849-82d0-0adada3e8041@redhat.com>
Date: Mon, 11 Mar 2024 15:35:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM: x86: Selftests changes for 6.9
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240308223702.1350851-1-seanjc@google.com>
 <20240308223702.1350851-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240308223702.1350851-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/24 23:36, Sean Christopherson wrote:
> Add SEV(-ES) smoke tests, and start building out infrastructure to utilize the
> "core" selftests harness and TAP.  In addition to provide TAP output, using the
> infrastructure reduces boilerplate code and allows running all testscases in a
> test, even if a previous testcase fails (compared with today, where a testcase
> failure is terminal for the entire test).

Hmm, now I remember why I would have liked to include the AMD SEV 
changes in 6.9 --- because they get rid of the "subtype" case in selftests.

It's not a huge deal, it's just a nicer API, and anyway I'm not going to 
ask you to rebase on top of my changes; and you couldn't have known that 
when we talked about it last Wednesday, since the patches are for the 
moment closely guarded on my hard drive.

But it may still be a good reason to sneak those as well in the second 
week of the 6.9 merge window, though I'm not going to make a fuss if you 
disagree.

Paolo


