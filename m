Return-Path: <kvm+bounces-43647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34012A935CF
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C95919E524C
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 10:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5178A270ECE;
	Fri, 18 Apr 2025 10:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DM4nsaEL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4642566E3
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 10:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744970835; cv=none; b=pNIVDMFVXyv4SB02WrZLlAQh7QSJF6gT6Xr26nXQDRoAJQYrrqwBXJttoJ8ZYapelcdhNl54/4j5dkkGoXBQTDOO3whk5t/a9ezsK1ahJCJq022KvGNYZBakKZ3PGdFBrhUJqaAUPbPmI6a2PKYNZh7QThJ1JeKZ24ilazDL9eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744970835; c=relaxed/simple;
	bh=9ztD5QEKbZyDUWbK+PqKwSOd4E+kH7gk1b2fzZmLKYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPFZ8RxcwyJERhVVRgTIWLrLUEroZIp6SCYGtUL5o660O8wQAuRsCxqMiyK5C9XIr/RzvS9QqM4dpskpSuNvrabYM6xL0OaXcz/LdXdzCwoy3WTmYe7PVbuVCpcTAprj/KvjzwHHPYcj4QjJMFPDANSuc+Buhjw0XflP/XMzsUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DM4nsaEL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744970832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9G5521K43w3dmM/mpU0zbZYMYOFcRmDMx1FAdvTmU0E=;
	b=DM4nsaELvbUsiW5LDf1CVtVmU8JhhYBhEGuY7l8j1eVP0tIgODsFd/E0vKBV15sDKfUKYp
	KzxNhxovRPJDzOxpB+bqf9m+73v143w4WI9OH/RnqEHS1Uwh0zkeriUt272vDtnCKE8LQ8
	G90pAT7E8ybD0OcBSuxfCPzp+q5BvGA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-BOcPiupLNpWFT2n0ParcCw-1; Fri, 18 Apr 2025 06:07:11 -0400
X-MC-Unique: BOcPiupLNpWFT2n0ParcCw-1
X-Mimecast-MFC-AGG-ID: BOcPiupLNpWFT2n0ParcCw_1744970830
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5e623fe6aa2so1784074a12.2
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 03:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744970830; x=1745575630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9G5521K43w3dmM/mpU0zbZYMYOFcRmDMx1FAdvTmU0E=;
        b=PlMHCcySdYHNsLM5Av5nheyH+ncP0F1CAnrEPPKfC5O9c48QaYP+QuS1w+kAlydzye
         IxC5uxTXYQ6evdb+T/ti0+PgXqFoibfLvyEo9y6sRc1fqcCckgB6LvNuRGfxHrOmWnY1
         Zog2KaWtX6SUMTUTdDlGAY9fzHjexr1uvyiOdexDm7Hdob79Ixua7h+0VazL+7fTHZgn
         A8X6J1cg3dvlrWilk1RywI3TxjN3S6hh5FMHOvpCSWgaP7gNvRwNzQ7dgo7r5LgA+n/l
         uP62f4H6wmo5+p6Grvsl9jaQMOJJEpgk1cyXmkAJ6W5Z4UdBFVkCeryWm9fMS4KtDvZ3
         tkxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbhv/c82YmLAEIrqXutGBIW0ir72hpDoHbUHKtsluyU/xAwHjlEImFaFHIXi0oG95VoZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKyNW2u6GmzkLPQYE5PYKtIC2LMVskb+K1EDreT5b1mkXVdlKW
	mh7ZSNrtIZdy7W8wJ4I460+DZFzYstvepXK4Txjv29WrLZXi27zGyoM+OVBXTAA4ccyMUXMjhhf
	3bH5NglxoXQaspBHDBCAw1fSvUBi1RBPtY6HCjbB2+BTPELGk4w==
X-Gm-Gg: ASbGncu543q6jObE2Cnz0Q0bxdCa36DHFPvIbiqglYJrzdJaZuH5VUJP7R+07fGiuKx
	pLnJQYpIXwbi4xMDNDSCIbuFd4H/WCg+WIe3VvJ685pyAtiHpzlSUWjo/BBstn/NM9deBTpbNeh
	FjE5uRc+O2ZiKmqkbnDCC02eddfMGDMISDN0jtNqYXrHogDDs487ZVzIRlAzRQ/SWUqT7Bf5RKQ
	rSj5DgBB+Cy/Jvtck/s5D9TYX80ln0iztMnNIkdwfRE8I57fSDwIRubOVdMdC2TwyZjiYJVW2ll
	CcEhslHAPOJ4H89KEA==
X-Received: by 2002:a05:6402:4407:b0:5e5:49af:411d with SMTP id 4fb4d7f45d1cf-5f6285460f7mr1805168a12.17.1744970830040;
        Fri, 18 Apr 2025 03:07:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTKd6NM4kSkW3Otx/O/66Pab50SH+6TRF4InR2WHUY4N/RGC6Eyk+ZoPTNIfSCaBgzl77j2Q==
X-Received: by 2002:a05:6402:4407:b0:5e5:49af:411d with SMTP id 4fb4d7f45d1cf-5f6285460f7mr1805127a12.17.1744970829477;
        Fri, 18 Apr 2025 03:07:09 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.130.214])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f625592cf4sm820284a12.36.2025.04.18.03.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 03:07:08 -0700 (PDT)
Date: Fri, 18 Apr 2025 12:07:01 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] vsock: Linger on unsent data
Message-ID: <baamf74wjdpk7ji3hmsyzjr6ngu52qq6au6gcnc5vahlacpenx@rccaffrt6vub>
References: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
 <20250407-vsock-linger-v1-1-1458038e3492@rbox.co>
 <22ad09e7-f2b3-48c3-9a6b-8a7b9fd935fe@redhat.com>
 <hu4kfdobwdhrvlm5egbbfzxjiyi6q32666hpdinywi2fd5kl5j@36dvktqp753a>
 <a3ed036f-5153-4d4c-bf71-70b060dd5b2f@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a3ed036f-5153-4d4c-bf71-70b060dd5b2f@rbox.co>

On Wed, Apr 16, 2025 at 02:36:52PM +0200, Michal Luczaj wrote:
>On 4/11/25 12:32, Stefano Garzarella wrote:
>> On Thu, Apr 10, 2025 at 12:51:48PM +0200, Paolo Abeni wrote:
>>> On 4/7/25 8:41 PM, Michal Luczaj wrote:
>>>> Change the behaviour of a lingering close(): instead of waiting for all
>>>> data to be consumed, block until data is considered sent, i.e. until worker
>>>> picks the packets and decrements virtio_vsock_sock::bytes_unsent down to 0.
>>>
>>> I think it should be better to expand the commit message explaining the
>>> rationale.
>
>Sure, will do.
>
>>>> Do linger on shutdown() just as well.
>>>
>>> Why? Generally speaking shutdown() is not supposed to block. I think you
>>> should omit this part.
>>
>> I thought the same, but discussing with Michal we discovered this on
>> socket(7) man page:
>>
>>    SO_LINGER
>>           Sets or gets the SO_LINGER option.  The argument is a
>>           linger structure.
>>
>>               struct linger {
>>                   int l_onoff;    /* linger active */
>>                   int l_linger;   /* how many seconds to linger for */
>>               };
>>
>>           When enabled, a close(2) or shutdown(2) will not return
>>           until all queued messages for the socket have been
>>           successfully sent or the linger timeout has been reached.
>>           Otherwise, the call returns immediately and the closing is
>>           done in the background.  When the socket is closed as part
>>           of exit(2), it always lingers in the background.
>>
>> In AF_VSOCK we supported SO_LINGER only on close(), but it seems that
>> shutdown must also do it from the manpage.
>
>Even though shutdown() lingering isn't universally implemented :/
>
>If I'm reading the code correctly, TCP lingers only on close(). So,
>following the man page on the one hand, mimicking TCP on the other?
>

If this is the case, I would say mimic TCP for now.

Thanks,
Stefano


