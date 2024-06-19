Return-Path: <kvm+bounces-19930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D35B90E4CA
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 09:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF7A71C20BDB
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 07:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973047710F;
	Wed, 19 Jun 2024 07:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bZx2slsE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C8F74061
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 07:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718783100; cv=none; b=LjiO7tysuuuE/PUwwWL2RtGVrLZfir85ouRQoSfJxplRtfJxLMunl3TcSzpdGDwm2qWy2nctCjy9olcZuVf6Q8q9dPfK1qNQQu0davPbXWgvHTWy3N+9eULRQmG2axwXRLoj/kBoyxbgcf9+Nr7Y+8LcCR6J5lHOBwdrI/uPQu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718783100; c=relaxed/simple;
	bh=1oc3EUjXf2FE7HTtYyxE48DznTCuMAXge6TPWXMnk+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DI/mUkVaKrjaDy0YGCIPrQftMjAtAZVrmwuDW4pnHJlanPeJtFUQhie4Kor4ViBlKaQg013fDMcY6JjxkaPt9QTEt/qjj+8sfuTyc5rVRMc54876vhVO4Z56YST8pOMXQxPvze3V78+evLsonePe/9zkP9O2Uilk1F1phRs4jf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bZx2slsE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718783098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cux+7kpeF5VekvynNts7C8PD9JNm/gwxEni9kpJP52o=;
	b=bZx2slsEJfZGjjjAeqfll3M8piqZO+4qB4owbjuMNa6Mj/f0ckdlKBzQrj87hd99SH7UJe
	ZPoVhicQIoxwBHea2hTUOsKiGm9cL082Ld9IyBZhVKLrbG5jGcVTjd9wvWY432lzjHlk4Z
	a39F/wWLtM3e+QIpxmm+T/DhCo9WNYw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-mMGDOHntNvekukZwBVsR-Q-1; Wed, 19 Jun 2024 03:44:56 -0400
X-MC-Unique: mMGDOHntNvekukZwBVsR-Q-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-43fb0603968so84462211cf.3
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 00:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718783096; x=1719387896;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cux+7kpeF5VekvynNts7C8PD9JNm/gwxEni9kpJP52o=;
        b=eVpJFDNEEMce9ZSoOkinbk7LAAjADseWjdj6niViwQdoc8uwqx1l7yC32jXixvOh7s
         JS6JSmDdjh0c+/rGhr1VZEaaTLcpUpMBEuTj/F5BUPF8wWIMM8Y3w202M3soOrzS4SZL
         eP5D59rH/8sdyoMYdvK3/H4gOhHVnLXdq8rnSaEYkDmWKSlCZMchIhpyjBCDWpu9+I6B
         Ph4Qi631Y9By8cVKeuvCCzPu3BVr/8/I9nUlmg+KbnbPyA9cFLAMUC204F+MuM+vOd1E
         nmHwMXJ/vjkN7kAs3tyPKJGyqekt2dqTqmTYV6S26drC7m+IKNp/1T2LH5qKBMrL4zL9
         QAxg==
X-Forwarded-Encrypted: i=1; AJvYcCVkrTF6VVULaKixt3fqbdf7RnTdFZEd1nHVk4AE62XO0+lICAExW2W71a4DfAjvKfoZq39vOsbRjcP3TyXwHN1o6dZN
X-Gm-Message-State: AOJu0Yz6Fi+g1QkAMz/jOrNDoO52d6ssq//cwk35hiZukh4Qp3fSm+Cj
	C1xbG53ldOlAcZyS8tcPb8ehMjwwP3ZLVUHERu54/xrTvoBVjQ0Ct/igmv1SFuk4iRzvW/pIN9d
	15kxzdGaOb1mBbDmZVVVDqMA6cz8yckQxzXvg8ASNM/bUrzM+gBvvx2eviA==
X-Received: by 2002:ac8:57d3:0:b0:440:6115:ad4e with SMTP id d75a77b69052e-444a79a3f7bmr21193071cf.2.1718783096199;
        Wed, 19 Jun 2024 00:44:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcxqq0o8C85U9HuQX4IFUydnWTkzgMyKM6sXiKxNpXRMrzfTIduQgbllbt8qse8+Y24u4jfQ==
X-Received: by 2002:ac8:57d3:0:b0:440:6115:ad4e with SMTP id d75a77b69052e-444a79a3f7bmr21192981cf.2.1718783095894;
        Wed, 19 Jun 2024 00:44:55 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-117.web.vodafone.de. [109.43.178.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-441ef50497dsm63345601cf.36.2024.06.19.00.44.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 00:44:55 -0700 (PDT)
Message-ID: <a0b16c1f-2cb1-4899-aa49-50e9e0001818@redhat.com>
Date: Wed, 19 Jun 2024 09:44:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v10 15/15] powerpc/gitlab-ci: Enable more
 tests with Fedora 40
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240612052322.218726-1-npiggin@gmail.com>
 <20240612052322.218726-16-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240612052322.218726-16-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2024 07.23, Nicholas Piggin wrote:
> With Fedora 40 (QEMU 8.2), more tests can be enabled.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   .gitlab-ci.yml        |  2 +-
>   powerpc/unittests.cfg | 17 ++++++++---------
>   2 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index ffb3767ec..ee14330a3 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -110,7 +110,7 @@ build-ppc64le:
>    extends: .intree_template
>    image: fedora:40
>    script:
> - - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
> + - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat jq

Please mention the addition of jq in the patch description (why it is needed).

  Thanks,
   Thomas




