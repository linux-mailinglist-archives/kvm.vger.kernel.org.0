Return-Path: <kvm+bounces-64825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 640F1C8CED6
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:32:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E2883A11BD
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 06:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E53313295;
	Thu, 27 Nov 2025 06:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I2dp08s9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sQQJUms5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11EE2BDC09
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 06:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764225109; cv=none; b=t8oiz8P7AB2NLVuMwzJP9JxPqmiP9Fy5EKF64brFdOqfJh+2Ru0pPQevT0I6YCHujjiL3QVRj/3/CqGifHXNrS+31Z191Ycw2nvpNZ+7ku/9LRLmaHPOuRQz+VsWXuOm7BIeYFYy7s6NdDyLi/LYuHLBypsX9TajzhmKKK6TlWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764225109; c=relaxed/simple;
	bh=iogX3xSa4Ao8v9GCUKTEnMEzH4Cl34v0hHkamugQyEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOhswRLYUSlLAVwufaKNIKFIQGUAZE0MgHSoUnsRTVx8aPorVSYnE6wgEpEi8M0IHpQ7uk2mI6iOgJYI/lLv5CNSRJ4Sg9p8IDkXswPzzyMGokreqESqHNNdUoD4AZVlcDAElyVITTz+1PCK3s172kz4KZ3npQT+dsg8YiZic/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I2dp08s9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sQQJUms5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764225105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iTNP02ec2EQFhb0BUUIU5hF1KwMT2YSIi7cgt/pgdoc=;
	b=I2dp08s99RqJ/jVQ86gBo+tAO/0/c8Uclh5xVdviXr82SfTdDTI51NTZT9ets7aaapBbZe
	5deSvTqtp7CaQCwZaZojNFS2dKU1xoQa50ssB3bLuKVADpHV8G46Xdtj1qCdxBs5er/1Bs
	6YArS3YtzvCXLJdWbxhZMk5idskEg0E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-P2qss60zMjaE4tYQi2TBaQ-1; Thu, 27 Nov 2025 01:31:42 -0500
X-MC-Unique: P2qss60zMjaE4tYQi2TBaQ-1
X-Mimecast-MFC-AGG-ID: P2qss60zMjaE4tYQi2TBaQ_1764225101
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so2542405e9.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 22:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764225101; x=1764829901; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iTNP02ec2EQFhb0BUUIU5hF1KwMT2YSIi7cgt/pgdoc=;
        b=sQQJUms5dREIehGvJaGVpqRcIGoi86zORlgaqgUZhL1CP3f/4OAVKrYBOS/a9eB7ZR
         jQH1oFGkk1x0uOAjZ7Yi/E0+j88/1I7+IIQg34cAi4qG0AI7e8V0L1oRmOUBW93+RSvZ
         69Dgrdwg8wVfEmDl8E62VQtC3o8n42Uh8saS0bbbyuac70SG098+HVovU1KWu+mR/4mi
         2qsLr1fAczMam9EeHwbBTEgvApLwZxItI/92JepBripMbW4XjenTqTUhXahBVyTQeLXy
         D0nOqmKDd6/WmypJ0gs1z9GUxzBp+cIxhSv1YM5W6W6L8JHerbvoKXuPZYoGs7w8bG2E
         dXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764225101; x=1764829901;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iTNP02ec2EQFhb0BUUIU5hF1KwMT2YSIi7cgt/pgdoc=;
        b=Pv3nakLDJXKyhk8qo/NcAYch/QYPtLoL3wH0VTqrQZvTp1kkGSCMBoX0ffcORqQWYW
         DWU1LOdqwzNyZWB+mTF1fz9sfhUL5uVGY4lHVzgfvJNLQj+uiAfCMrCf5+apFtuP7tkt
         r74wtEQgEVmO0hTyA3CjDSVHRDLZZoy1AreHvvkEiMkNfpuL7EiWO6VQRND0r7Pwyb+5
         QKZIi1z8s+nS6xIzD0LtTQVy2KDtL6YQdYLGgayiF/d1cQNss9GSwAecodSZCtBA5B+h
         4EIyeUvFsY5Voa5lEpJON1u6ZO1Za0iPNcrjlpRjdw2KJ9zJmTiQQ5n530YcevmgdgPD
         l87Q==
X-Forwarded-Encrypted: i=1; AJvYcCUuwzCE9wEAu1k6cMgrHmfT77+PrxRIBqTe9fgyqg3ZhWJ1v3tAyrtQJ7suyZ2H2sw0xR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdLOg8gFK24YMbzePk7xehkeEh/QyONKC4mtUrohANFT+kjpwB
	ALLIij7NmnFG+e+JywckS7muhZesgUuAvCVAm6r6rqIzv+OKH3XafvZcBBBJRcCr2gNRCv2dtHf
	fWSzolvliTFvjYymitns7qEDEfSdUWfeyXYc+7T+02fkUG4PV6iU9lA==
X-Gm-Gg: ASbGncvaAOnPB50kPlxQaOSIQ2iYHsiDfuy1zfS2gtGK1dHQiGZLH4OIS8vUR/jPWw7
	vUCmfue0LIfXm81DADPx9oQZYG4TLdJq3I3es2qwKPcVoMn+RV818hKD2yqyV3S5Sor5j2iLYcq
	bgqwTXW9pmRpLpmeg32B0MPK66jIQ8mk5ECIz0nWeT4oZziB0CB6WcPeW/cdNLNt4nJHAUHHYlw
	y0MT1cz82DMjtorW0PtfhELj80KLYTstVThsSFy763uR/NHysfuFGQTzl5rO3/FZRfqKKCUaM+Q
	42XxIvm55nRO4M7qaj3BBBvwrmrU6iibg88FYrjwArnJHwjJP98ucUlMYTqb/nxuR/90WjCrk8J
	i0dXVLKvjAS1XnWmA5NWZenXlGNuwzA==
X-Received: by 2002:a05:600c:358d:b0:477:55c9:c3ea with SMTP id 5b1f17b1804b1-477c01f0b32mr221886215e9.35.1764225100907;
        Wed, 26 Nov 2025 22:31:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEz3QdxbLT7pjNEA0+4issjfnX1wytvw1rWR9IPHXTXDwSvYj8EJcg5Kea3fFSq+htQYjsONA==
X-Received: by 2002:a05:600c:358d:b0:477:55c9:c3ea with SMTP id 5b1f17b1804b1-477c01f0b32mr221885885e9.35.1764225100423;
        Wed, 26 Nov 2025 22:31:40 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4791165b1fesm13552265e9.15.2025.11.26.22.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 22:31:39 -0800 (PST)
Date: Thu, 27 Nov 2025 01:31:36 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	Netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Borislav Petkov <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Drew Fustini <fustini@kernel.org>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Message-ID: <20251127013110-mutt-send-email-mst@kernel.org>
References: <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
 <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
 <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
 <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
 <61102cff-bb35-4fe4-af61-9fc31e3c65e0@app.fastmail.com>
 <02B0FDF1-41D4-4A7D-A57E-089D2B69CEF2@nutanix.com>
 <CACGkMEshKS84YBuqyEzYuuWJqUwGML4N+5Ev6owbiPHvogO=3Q@mail.gmail.com>
 <5EB2ED95-0BA3-4E71-8887-2FCAF002577C@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5EB2ED95-0BA3-4E71-8887-2FCAF002577C@nutanix.com>

On Thu, Nov 27, 2025 at 03:11:57AM +0000, Jon Kohler wrote:
> 
> 
> > On Nov 26, 2025, at 8:08 PM, Jason Wang <jasowang@redhat.com> wrote:
> > 
> > On Thu, Nov 27, 2025 at 3:48 AM Jon Kohler <jon@nutanix.com> wrote:
> >> 
> >> 
> >>> On Nov 26, 2025, at 5:25 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >>> 
> >>> On Wed, Nov 26, 2025, at 07:04, Jason Wang wrote:
> >>>> On Wed, Nov 26, 2025 at 3:45 AM Jon Kohler <jon@nutanix.com> wrote:
> >>>>>> On Nov 19, 2025, at 8:57 PM, Jason Wang <jasowang@redhat.com> wrote:
> >>>>>> On Tue, Nov 18, 2025 at 1:35 AM Jon Kohler <jon@nutanix.com> wrote:
> >>>>> Same deal goes for __put_user() vs put_user by way of commit
> >>>>> e3aa6243434f ("ARM: 8795/1: spectre-v1.1: use put_user() for __put_user()”)
> >>>>> 
> >>>>> Looking at arch/arm/mm/Kconfig, there are a variety of scenarios
> >>>>> where CONFIG_CPU_SPECTRE will be enabled automagically. Looking at
> >>>>> commit 252309adc81f ("ARM: Make CONFIG_CPU_V7 valid for 32bit ARMv8 implementations")
> >>>>> it says that "ARMv8 is a superset of ARMv7", so I’d guess that just
> >>>>> about everything ARM would include this by default?
> >>> 
> >>> I think the more relevant commit is for 64-bit Arm here, but this does
> >>> the same thing, see 84624087dd7e ("arm64: uaccess: Don't bother
> >>> eliding access_ok checks in __{get, put}_user").
> >> 
> >> Ah! Right, this is definitely the important bit, as it makes it
> >> crystal clear that these are exactly the same thing. The current
> >> code is:
> >> #define get_user        __get_user
> >> #define put_user        __put_user
> >> 
> >> So, this patch changing from __* to regular versions is a no-op
> >> on arm side of the house, yea?
> >> 
> >>> I would think that if we change the __get_user() to get_user()
> >>> in this driver, the same should be done for the
> >>> __copy_{from,to}_user(), which similarly skips the access_ok()
> >>> check but not the PAN/SMAP handling.
> >> 
> >> Perhaps, thats a good call out. I’d file that under one battle
> >> at a time. Let’s get get/put user dusted first, then go down
> >> that road?
> >> 
> >>> In general, the access_ok()/__get_user()/__copy_from_user()
> >>> pattern isn't really helpful any more, as Linus already
> >>> explained. I can't tell from the vhost driver code whether
> >>> we can just drop the access_ok() here and use the plain
> >>> get_user()/copy_from_user(), or if it makes sense to move
> >>> to the newer user_access_begin()/unsafe_get_user()/
> >>> unsafe_copy_from_user()/user_access_end() and try optimize
> >>> out a few PAN/SMAP flips in the process.
> > 
> > Right, according to my testing in the past, PAN/SMAP is a killer for
> > small packet performance (PPS).
> 
> For sure, every little bit helps along that path
> 
> > 
> >> 
> >> In general, I think there are a few spots where we might be
> >> able to optimize (vhost_get_vq_desc perhaps?) as that gets
> >> called quite a bit and IIRC there are at least two flips
> >> in there that perhaps we could elide to one? An investigation
> >> for another day I think.
> > 
> > Did you mean trying to read descriptors in a batch, that would be
> > better and with IN_ORDER it would be even faster as a single (at most
> > two) copy_from_user() might work (without the need to use
> > user_access_begin()/user_access_end().
> 
> Yep. I haven’t fully thought through it, just a drive-by idea
> from looking at code for the recent work I’ve been doing, just
> scratching my head thinking there *must* be something we can do
> better there.
> 
> Basically on the get rx/tx bufs path as well as the
> vhost_add_used_and_signal_n path, I think we could cluster together
> some of the get/put users and copy to/from’s. Would take some
> massaging, but I think there is something there.
> 
> >> 
> >> Anyhow, with this info - Jason - is there anything else you
> >> can think of that we want to double click on?
> > 
> > Nope.
> > 
> > Thanks
> 
> Ok thanks. Perhaps we can land this in next and let it soak in,
> though, knock on wood, I don’t think there will be fallout
> (famous last words!) ?

Yea I'll put this in linux-next and we'll see what happens.


-- 
MST


