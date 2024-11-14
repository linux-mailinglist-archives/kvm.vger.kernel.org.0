Return-Path: <kvm+bounces-31874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F819C8FD7
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:32:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F30022830F9
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9AE218D637;
	Thu, 14 Nov 2024 16:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PtFsIjDT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD7118BC06
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601787; cv=none; b=nv5WYyg/cMW4W3g1wFSIy7Rg1OXKyieyMVd06WyjTiyCI+F/Q6HEvDJ3+7QNtVYqt7FvAhiPhTLSM3nGtWQFCKI9jKXvjmFDm8pEkEjo/S9QDC77USKcxgBv7+E6ZIlQEvJsGWYiXHVuEFpu6wUYiOo+U6Lb3dbfIP4B0oaWsQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601787; c=relaxed/simple;
	bh=y6nzprvn/q25Jsk8S9OzbKMDmmnqu+R2m005n9v55UY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fSirQeyvg7pT0js0THWbXMCiAFVLu5f8QF1DqMD/mb65VbcZaa2D5TtGTCqz5CzMCJ4qYoZwNO34qjh047uQoa2bAqTv4nq8yUPdte+HYYwwxpOmnx20mFiEo2O0rFQ7MNyl6DaGsKAoENwFqQpRz6QG2cfxbIt69ZF2/yFtyQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PtFsIjDT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731601784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PadUTfYfFxI6C6uoL4ucMl4kuWW45NqxULqNhu7tszE=;
	b=PtFsIjDTL2/WLgtm76SU9MZ5QUGt1mQYRnUJ0pUqXqonWvuJyc6u5an0E/M5IDwSUY5yx1
	Wsjk4XUitfcDKPlNUfm65D7dxmIN0a3xA0KT1Wb8tNrZAy1UKMk7kuAluxl3sblFj/wC88
	Ry192fnfW6XaYMB7Vgc+kw8pGOEHZGg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-ypG45NnpNpmBCToW2AlC6g-1; Thu, 14 Nov 2024 11:29:40 -0500
X-MC-Unique: ypG45NnpNpmBCToW2AlC6g-1
X-Mimecast-MFC-AGG-ID: ypG45NnpNpmBCToW2AlC6g
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d95264eb4so503810f8f.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:29:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601779; x=1732206579;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PadUTfYfFxI6C6uoL4ucMl4kuWW45NqxULqNhu7tszE=;
        b=wetlKoYIMyNBcCmE9sf3DxcqIVaG2/X6FDMaA0w+8dZINEbPrviAWinPUCFmNTmzf2
         bXJCmm/dbqSDDqFFsEl2zfPSLXF+E4b3NKJjBVckoQt7MA6ZQTtEjGO6bGj03OV/twys
         R+YWlczU1JS5uMCJzev5velIMYouvZCBhzTfCByYCDtsqV8WiE3ednM837odpDuBmmZR
         nhsP5ZgebAziiEppPhg8l6ZARA4rWnv5moei1NgVEefJwDMnTr3PNqzNPElAr3ozzk4w
         RJBt7/lqgqGA6Tz7z0D9WqqHIbej8kltktYWDPyGTzJrVoY+Xur4Di61aW8YpJgeQE+x
         bNpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfsGbmq8/Gy//jvBW0Ul3oAV5lqI+LJDyuEDBtb/sdf/gMvEgCcsK1lV4ttynsO0u6P/4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+FOzDHCLvLO27SsZSU0GLn8Pa2DyEcN9PpVTE/XyiFS8XcKWe
	Xx/D+RmwlI2aKeIcv+Im5RwGI506SRkCeV61D0uf53ePgeQ5fQ/Xi1gEbRd4OQ8WF1eAonkQTp/
	7MfQ6mcWn5+tmXFlrhzoqsUWa4HjDOpqcY63YMN8jtyix10y/1w==
X-Received: by 2002:a05:6000:1445:b0:381:f443:21cc with SMTP id ffacd0b85a97d-3820dee298emr5849434f8f.0.1731601779241;
        Thu, 14 Nov 2024 08:29:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFbEbVn2QODyfwYmc1GMH2dD+JlJSB7TOy9Z2fTCWx/pYzb8nRICqQrURO4y74MgD4LgtSVKw==
X-Received: by 2002:a05:6000:1445:b0:381:f443:21cc with SMTP id ffacd0b85a97d-3820dee298emr5849413f8f.0.1731601778876;
        Thu, 14 Nov 2024 08:29:38 -0800 (PST)
Received: from ?IPV6:2003:cb:c715:6600:a077:c7da:3362:6896? (p200300cbc7156600a077c7da33626896.dip0.t-ipconnect.de. [2003:cb:c715:6600:a077:c7da:3362:6896])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae16108sm1890712f8f.66.2024.11.14.08.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 08:29:37 -0800 (PST)
Message-ID: <723479f3-83d5-4d5e-bebb-ec9dbf273eb6@redhat.com>
Date: Thu, 14 Nov 2024 17:29:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
To: Ackerley Tng <ackerleytng@google.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org
References: <diqzmsieybwf.fsf@ackerleytng-ctop-specialist.c.googlers.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <diqzmsieybwf.fsf@ackerleytng-ctop-specialist.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.11.24 21:36, Ackerley Tng wrote:
> David Hildenbrand <david@redhat.com> writes:
> 
>> Ahoihoi,
>>
>> while talking to a bunch of folks at LPC about guest_memfd, it was
>> raised that there isn't really a place for people to discuss the
>> development of guest_memfd on a regular basis.
>>
>> There is a KVM upstream call, but guest_memfd is on its way of not being
>> guest_memfd specific ("library") and there is the bi-weekly MM alignment
>> call, but we're not going to hijack that meeting completely + a lot of
>> guest_memfd stuff doesn't need all the MM experts ;)
>>
>> So my proposal would be to have a bi-weekly meeting, to discuss ongoing
>> development of guest_memfd, in particular:
>>
>> (1) Organize development: (do we need 3 different implementation
>>       of mmap() support ? ;) )
>> (2) Discuss current progress and challenges
>> (3) Cover future ideas and directions
>> (4) Whatever else makes sense
>>
>> Topic-wise it's relatively clear: guest_memfd extensions were one of the
>> hot topics at LPC ;)
>>
>> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7),
>> starting Thursday next week (2024-10-17).
>>
>> We would be using Google Meet.
>>
>>
>> Thoughts?
> 
> We've been taking recordings of these meetings with attendees'
> permission and the recordings are kind of stuck in a Google drive
> now.
> 
> People interested in watching the recordings need to request access to
> the meetings.
> 
> I would like to make these recordings more public and lower
> administrative overheads of requesting/giving access by hosting the
> videos somewhere.
> 
> Does anyone have any suggestions/preferences on a video hosting service?
> 
> Otherwise I'll default to using YouTube since that's also where LPC and
> LSF/MM videos are hosted.

Makes sense to me, but I would like for them to only be detectable via 
link, not via the youtube search.

We could add links to the gdoc notes.

Let's discuss that today in the call real quick.

-- 
Cheers,

David / dhildenb


