Return-Path: <kvm+bounces-21240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6217B92C533
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 23:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E09811F22708
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 21:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACF5185607;
	Tue,  9 Jul 2024 21:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bSY++FDx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7289A187844
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 21:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720559614; cv=none; b=hll36sZM/M5wiA4AVU6DQ4QUxa07iXFYiqZLVz2KgB9/nU8tNIuBf0qDfApaM7iKS8U0lqwGH7CGAu79ykyXmu716jT0Yd+o9qZESm8X2a2ROx+jcKhbJMACXP5GCESAnWzqOfgGzrZjcuIPMCHoMpGP0Epf0RDpfTyF/hsI0Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720559614; c=relaxed/simple;
	bh=WATgZFT9uHYoBQqVzS5MxskqTvjDPhMOoJm7kTIzD6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y66QRVSIgmrDjUol81giIzGlR42EcHQXWqU7WuA8iSPvhD0BLt+zBOOKA9HO3f42FfEHQPHE0WwoTKqABYidzp2ISPnf1bdtBrjUOmkeICIOm5wXPihOoyOLvAPP1SziJYn7ndBKN3oeHCDBHSJj8Uen4suDyTwkAIOo78VclwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bSY++FDx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720559611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=muvzdtblV/Pdr4yNgZvkw9vrSYYURaFTG3NgiajP+Pw=;
	b=bSY++FDxTQFXMYdpXrHuaHAyIYyVMag1Dr5N3keBE1a8gulX8D6iPULPQhKN6KUYLInPd0
	xH1gZGFiL3u2dnAZTenZsFp2+MlwjxhzA0kXSHrE7zjfxig2U/Osl6sxy6sDEETH2nWzoH
	Y36l16TDZOj8b8lSS2eM3bOwCSy6OCQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-N-OjrlYzOF-BBpUjRV_yKw-1; Tue, 09 Jul 2024 17:13:29 -0400
X-MC-Unique: N-OjrlYzOF-BBpUjRV_yKw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-70af603db29so3586562b3a.3
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 14:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720559608; x=1721164408;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=muvzdtblV/Pdr4yNgZvkw9vrSYYURaFTG3NgiajP+Pw=;
        b=JEb0IEQMIjPUiGlPcAAjlY3SvV1fsbNJrh943BaNn/gpTIT9ugyMpK2wOpjv4BLlyv
         AXd7gbdRh4m5qZeJq6a/bn7lx0kF7XcVGA7FOWWiMfdu+vphO8XCfwP5JW/b9mQ/pMGh
         RxzW0jlSb9K6jMz7qY4CYfbIJv6ytvXCagh6fRnTvaIv8wDd2BrB/hIT27DWoEsj7pml
         NsTsawYrpF8p0XX7q8efs8AEbOZoZnaBxgVxqgtkV4xF1L4f3T1qdeZ+o3/Gli437D8s
         2n2J5NOIwvhSw0jnb3hNB/1e3WFbXC0oT+QK1f0eP7UMFoyupl83P8mGCi888xICRCBG
         bUtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlegBDVNNKGlIOQMrwf6f2q83H/gvQ7a0aW7eoZ311U1re1QHvXgArstfk6dqr1BKe1qrpDDG5RQRqPNoWPc/s0V0s
X-Gm-Message-State: AOJu0YwLpv2AkK9qCqd9/+ON82I9IQJ1crQWfai2XdBtz40APHEc2SRS
	4XPm/Z2PBfjL8rJkXULOy+Es6JEny87jSEjuf1SD6OFiWHlZl6dCA/zkhKnvvDcJAnJsSQ8ZDKP
	JnUMdpWhB6/OfPjVZPDgYFqGyc97k2m+Vy1xVJvvFjb22sCo86Q==
X-Received: by 2002:a05:6a20:c22:b0:1be:c88f:c60d with SMTP id adf61e73a8af0-1c2984d82d1mr2721163637.56.1720559608464;
        Tue, 09 Jul 2024 14:13:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjKrk0zZyquX0++cfLkFxfG6jz6dn5RLDqhkSPdbZSMNWq4ssGoVBep4JrbyTepRRnJeOnww==
X-Received: by 2002:a05:6a20:c22:b0:1be:c88f:c60d with SMTP id adf61e73a8af0-1c2984d82d1mr2721153637.56.1720559608048;
        Tue, 09 Jul 2024 14:13:28 -0700 (PDT)
Received: from [172.31.79.51] ([216.9.110.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a12fe4sm20538215ad.56.2024.07.09.14.13.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:13:27 -0700 (PDT)
Message-ID: <47ce1b10-e031-4ac1-b88f-9d4194533745@redhat.com>
Date: Tue, 9 Jul 2024 23:13:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 8/8] kvm: gmem: Allow restricted userspace mappings
To: Fuad Tabba <tabba@google.com>, Patrick Roy <roypat@amazon.co.uk>
Cc: seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org,
 dwmw@amazon.co.uk, rppt@kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 willy@infradead.org, graf@amazon.com, derekmn@amazon.com,
 kalyazin@amazon.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dmatlack@google.com, chao.p.peng@linux.intel.com,
 xmarcalx@amazon.co.uk
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-9-roypat@amazon.co.uk>
 <CA+EHjTynVpsqsudSVRgOBdNSP_XjdgKQkY_LwdqvPkpJAnAYKg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTynVpsqsudSVRgOBdNSP_XjdgKQkY_LwdqvPkpJAnAYKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09.07.24 16:48, Fuad Tabba wrote:
> Hi Patrick,
> 
> On Tue, Jul 9, 2024 at 2:21 PM Patrick Roy <roypat@amazon.co.uk> wrote:
>>
>> Allow mapping guest_memfd into userspace. Since AS_INACCESSIBLE is set
>> on the underlying address_space struct, no GUP of guest_memfd will be
>> possible.
> 
> This patch allows mapping guest_memfd() unconditionally. Even if it's
> not guppable, there are other reasons why you wouldn't want to allow
> this. Maybe a config flag to gate it? e.g.,


As discussed with Jason, maybe not the direction we want to take with 
guest_memfd.
If it's private memory, it shall not be mapped. Also not via magic 
config options.

We'll likely discuss some of that in the meeting MM tomorrow I guess 
(having both shared and private memory in guest_memfd).

Note that just from staring at this commit, I don't understand the 
motivation *why* we would want to do that.

-- 
Cheers,

David / dhildenb


