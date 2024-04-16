Return-Path: <kvm+bounces-14892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2378A75F4
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE844B224AD
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91685A105;
	Tue, 16 Apr 2024 20:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ek8qv0Xw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7709338FA6
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 20:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713300810; cv=none; b=Dt0qbBtZ+hyhKCEtVe9i3PVToIcpP3dM7OgghJF+IcRNoQ7+D/bHxcfEQ7XdnEltHsHeLpU1tSIv3g2jdGljes5NzOP1B0hYB34nDDzH31hjDuBSUK3wSEu/GPgpckAVEwlF8HTB26aM5uqHQuYmKekGL7YspGiZymJj8jVpoUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713300810; c=relaxed/simple;
	bh=2VUPsNGTvaCb6MINiK02YsJin39zd+0ghPTKjVLVvio=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7JijoJ/eQknra6Cgp5AUk2r/9XxnvglKBjGhXe+sV5eJW5fn9FXu9v4THdcSbf73XnZtpf4OgB7xp0/EhUUuSVwB07AluHfLd7KO+BKFiAv7CuIB+Vl33ypfVpbaGDhnkNrVbdPmD51M4oAqa6sGkGG/8X/5mEdDU8KtD/Y0gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ek8qv0Xw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713300808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w0LXRE+t+WnC8kTK9JZPMPSEIrgpz4+A1T0TjLOgBQQ=;
	b=ek8qv0XwoHirUBXS8wXqJzrPcvW3O1AvWWJ0oCo8FFg/MPRmY5Pbgj+wjknc19UVGWZmOJ
	Hjq69Xkc2qwJBRr9w6f+jU5zMMrbXhOmlOyG8UOzg448pU5Y/9SZTvWcwKgt2kbSJpNoSo
	3fzPpWi1HFmRVkrJ9EavZqrDahPbUJw=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-Sf17_sQtPZqBlEVk6dZASw-1; Tue, 16 Apr 2024 16:53:27 -0400
X-MC-Unique: Sf17_sQtPZqBlEVk6dZASw-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2d9ebfd9170so43905871fa.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 13:53:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713300804; x=1713905604;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w0LXRE+t+WnC8kTK9JZPMPSEIrgpz4+A1T0TjLOgBQQ=;
        b=FE5S7Tvq9633z6IP/mUQiMm0753kzLiJJqUuVU/OpmC3IJ2HrzniHGEII9qeUaZOXP
         zSJXarKLjQNViZIwk85ypEAi42x5f+mqfGf3z1zpjTGH8oDDX35JY3Zd7hSof/z8Cx+X
         RTwL8GJV7BwgzIxm3t1JqE8Vt6XCdQ0m/KWMmM3i6qP4bt7YzQoY02yBFFnBquOaHLDr
         ZogMbzNvvQ9FHJl0bCTbScQcGnxjw+45j/V8hRzTdF8930hK3OTPf348SN/cyjyTGbgW
         46OjwHojUJ5ooiAyVUX+thpes7LUDyAgb6rREBVlbMWhlJE4m/+Hgg94l1lDiYRMjHbp
         oE7A==
X-Forwarded-Encrypted: i=1; AJvYcCWxJWrQXPuJpYqCMIdtHwxseFb9UUXuV8MefgSmN2PGZIz1vB3OPa+R8IOuZvXbsEeVYhhfTjk92wTwHUlgmBLdCwXm
X-Gm-Message-State: AOJu0YzECbG/NX70Y48FWYCvXQb+NThztDW2WJPdoueQrx9gW/pDUcoF
	WABgoUpXi1vX+PWBon7Mv2gI96IOjPXrrO29/R5T9Yz+lAnfTCTHb+ks8PMKAdDec6q0SL6t5a8
	wDZXw2VGqrRQ3oxPNOub3vLikQD2ln/24ZpRYX1baDFhWltA/1ZSCdMg1CA==
X-Received: by 2002:a2e:a545:0:b0:2d8:58b6:c10d with SMTP id e5-20020a2ea545000000b002d858b6c10dmr13647782ljn.18.1713300804428;
        Tue, 16 Apr 2024 13:53:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfasX2C9RXD1QxCmrRiZ9/PmkUafU+pu20xDYC6mW5MZk9tqlruDfwYXzlTcti9KVGP4yb7g==
X-Received: by 2002:a2e:a545:0:b0:2d8:58b6:c10d with SMTP id e5-20020a2ea545000000b002d858b6c10dmr13647771ljn.18.1713300804066;
        Tue, 16 Apr 2024 13:53:24 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.82.91])
        by smtp.googlemail.com with ESMTPSA id h6-20020a0564020e0600b0056fed5286b5sm6114425edh.55.2024.04.16.13.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 13:53:23 -0700 (PDT)
Message-ID: <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
Date: Tue, 16 Apr 2024 22:53:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, linux-kernel@vger.kernel.org
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/24 22:47, Boris Ostrovsky wrote:
> When a processor is running in SMM and receives INIT message the interrupt
> is left pending until SMM is exited. On the other hand, SIPI, which
> typically follows INIT, is discarded. This presents a problem since sender
> has no way of knowing that its SIPI has been dropped, which results in
> processor failing to come up.
> 
> Keeping the SIPI pending avoids this scenario.

This is incorrect - it's yet another ugly legacy facet of x86, but we 
have to live with it.  SIPI is discarded because the code is supposed to 
retry it if needed ("INIT-SIPI-SIPI").

The sender should set a flag as early as possible in the SIPI code so 
that it's clear that it was not received; and an extra SIPI is not a 
problem, it will be ignored anyway and will not cause trouble if there's 
a race.

What is the reproducer for this?

Paolo


