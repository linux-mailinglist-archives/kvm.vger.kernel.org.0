Return-Path: <kvm+bounces-34384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B83F9FD031
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 05:34:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A49E11883743
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 04:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6CF12A177;
	Fri, 27 Dec 2024 04:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Xstp4uhf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAC5442F
	for <kvm@vger.kernel.org>; Fri, 27 Dec 2024 04:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735274055; cv=none; b=PjoAVZor9aKtASqYgS/nGrhd67jPc9n73j7KHrVjDAcRResikBEZ0ABkOtPWjyrKovltD9IWyaX9bC32AmcrH/p4OzN0VT9hCcZOKuvOvxv6pTN4uWN7P13n6Jv4XfVQ2OCLhSdahSbfwACdByH7Tv/joAvRamohfF9NRLAXBn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735274055; c=relaxed/simple;
	bh=FVW7XNY64xuydDmLofP+sTKTUNUDp24hB/HXdgDSItk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m1RvIrMcEjf4ZqP2RJMIIXBU4fOQ+BoLo3eTmvNKYhh/0Kns3D6jWmEU2rhsuPopG4srTy/mRFmuq+EsvbzWbMbmds1zZJXHmnEpslOBvnbDUwm7Ol6xkIAKFhDQAJXN8T1wFMyxSFjSg0M7gWcBv0B8BGnyPAsm+0vsf8fETyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Xstp4uhf; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2ee51f8c47dso6531629a91.1
        for <kvm@vger.kernel.org>; Thu, 26 Dec 2024 20:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1735274053; x=1735878853; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hwCjjlIrKBk+YtuDMOqh5H8o6TB/HNBq181H/Zb/guw=;
        b=Xstp4uhfh13NkilnzVcowH4103wj2tYBtgE78Ll3pLRMwB6JCyZoKElGgUgo4pfupO
         uYwRll+Nnp+2oEtUV+lrT1tOLjaka5cchaR2KlxilAIfgJ8TTLtbcou4ENqmmCoHTQrE
         ReA4XGFR41vl0NIVSvGiXFV+KcyKC/dSbSff8Oed4BrNebgxPkRkBvghc7/IDKds7BWb
         vXVJrHG1dc1Q+fFX9M1r0dExRn4ONqlBbiS0dceMKREn8kCQz8scqOPcwECOsh6iy0JW
         I1YGRDEm8Xp0Nu2UR1KAChpvDJo88qLKy0278pfU809hQzYqzPCIeyK5/vQijsISmFwy
         nXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735274053; x=1735878853;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hwCjjlIrKBk+YtuDMOqh5H8o6TB/HNBq181H/Zb/guw=;
        b=ieDSGuN/RsB+vju9XEuyAwDRPAAg4Sxw1uThmPZeEPegOyMEGSDxx/mEICuCwm2xPK
         bWo/0dsQHrK06i6c5R1FD50tFE9vgElvFh0J2ShfKPsPD3Q73sgKjpmQpMZJ9ADXfmEu
         DpZnXItjaPHpRcuE4+FulqE2V6HV+edCthI6OmUir83uqzRsC9HKrzOZG29g0GoeLVdg
         sV5xwm/erZF2G9F/GzZostxoom0VHdeNkgAh/ssGQBkLXy7GPrYDqWRp/v07ObXxvqkg
         U0qAiZ4OMf0aP2l0M+tu0oXMKhr468HibjtizI1uGXXB8UOJOBD9qJMshLKBHdJ8GsLe
         yQ7w==
X-Forwarded-Encrypted: i=1; AJvYcCXi2+t8AurzVOta9hCZfdy48DetZ6B9CFSFW0CmxAEB++RReYoHbiewkBjTJBIyxp5w9FM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyaon8i7Xzw+jXVr61NEBSD0kGV7Il6qGRe3brDox77caIYC4FE
	EmqEKRfDBwNO2XeD2JAOvo1+GTkII1t0476CkZZEmLmhU+qAjyDCQXV1Z5cosUg=
X-Gm-Gg: ASbGncu8SwJCmNnKqEqEN1ZTS0NfmdGx+dBikAGd6I8rSGQB8E3ZnmxtEkBWhqYdqMF
	bLM/YXQm2ZqRIbsoom4fbfYqcnOtseMf4QmVhmfRE9v9U4a64uR8yk0LOC8BPRJmdfIVnS2Sq9d
	rtmioSh+X0mE80RXG0h1mPJc4TxWBWPTy6a+XpW6l4DU5JZaO8JMPvBypHAf3l9pjh9s1OMg5Fv
	pAe5SiKpr/oBjwARlf61k+Rp8G7oTFonEP2Nfk5UyaTiDbng+2wHc7OM5UgAHxILRy+0A==
X-Google-Smtp-Source: AGHT+IHbpgq5016PFvFeTeZ6RoKGAfu8Cv7iPr2JE4+A0XviJrDeYl5kAk/GomPB/LPyZ9Od5C0lCQ==
X-Received: by 2002:a17:90a:c2ce:b0:2ee:4513:f1d1 with SMTP id 98e67ed59e1d1-2f452eb24b8mr34814458a91.23.1735274053570;
        Thu, 26 Dec 2024 20:34:13 -0800 (PST)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4478a92absm14894900a91.44.2024.12.26.20.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2024 20:34:13 -0800 (PST)
Message-ID: <cd4a2384-33e9-4efd-915a-dd6fee752638@daynix.com>
Date: Fri, 27 Dec 2024 13:34:10 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost/net: Set num_buffers for virtio 1.0
To: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240915-v1-v1-1-f10d2cb5e759@daynix.com>
 <20241106035029-mutt-send-email-mst@kernel.org>
 <CACGkMEt0spn59oLyoCwcJDdLeYUEibePF7gppxdVX1YvmAr72Q@mail.gmail.com>
 <20241226064215-mutt-send-email-mst@kernel.org>
 <CACGkMEug-83KTBQjJBEKuYsVY86-mCSMpuGgj-BfcL=m2VFfvA@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CACGkMEug-83KTBQjJBEKuYsVY86-mCSMpuGgj-BfcL=m2VFfvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/12/27 10:29, Jason Wang wrote:
> 
> 
> On Thu, Dec 26, 2024 at 7:54 PM Michael S. Tsirkin <mst@redhat.com 
> <mailto:mst@redhat.com>> wrote:
> 
>     On Mon, Nov 11, 2024 at 09:27:45AM +0800, Jason Wang wrote:
>      > On Wed, Nov 6, 2024 at 4:54 PM Michael S. Tsirkin <mst@redhat.com
>     <mailto:mst@redhat.com>> wrote:
>      > >
>      > > On Sun, Sep 15, 2024 at 10:35:53AM +0900, Akihiko Odaki wrote:
>      > > > The specification says the device MUST set num_buffers to 1 if
>      > > > VIRTIO_NET_F_MRG_RXBUF has not been negotiated.
>      > > >
>      > > > Fixes: 41e3e42108bc ("vhost/net: enable virtio 1.0")
>      > > > Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com
>     <mailto:akihiko.odaki@daynix.com>>
>      > >
>      > > True, this is out of spec. But, qemu is also out of spec :(
>      > >
>      > > Given how many years this was out there, I wonder whether
>      > > we should just fix the spec, instead of changing now.
>      > >
>      > > Jason, what's your take?
>      >
>      > Fixing the spec (if you mean release the requirement) seems to be
>     less risky.
>      >
>      > Thanks
> 
>     I looked at the latest spec patch.
>     Issue is, if we relax the requirement in the spec,
>     it just might break some drivers.
> 
>     Something I did not realize at the time.
> 
>     Also, vhost just leaves it uninitialized so there really is no chance
>     some driver using vhost looks at it and assumes 0.
 > >
> So it also has no chance to assume it for anything specific value.

Theoretically, there could be a driver written according to the 
specification and tested with other device implementations that set 
num_buffers to one.

Practically, I will be surprised if there is such a driver in reality.

But I also see few reasons to relax the device requirement now; if we 
used to say it should be set to one and there is no better alternative 
value, why don't stick to one?

I sent v2 for the virtio-spec change that retains the device requirement 
so please tell me what you think about it:
https://lore.kernel.org/virtio-comment/20241227-reserved-v2-1-de9f9b0a808d@daynix.com/T/#u

> 
> 
>     There is another thing out of spec with vhost at the moment:
>     it is actually leaving this field in the buffer
>     uninitialized. Which is out of spec, length supplied by device
>     must be initialized by device.
> 
> 
> What do you mean by "length" here?
> 
> 
> 
>     We generally just ask everyone to follow spec.
> 
> 
> Spec can't cover all the behaviour, so there would be some leftovers.
> 
>        So now I'm inclined to fix
>     it, and make a corresponding qemu change.
> 
> 
>     Now, about how to fix it - besides a risk to non-VM workloads, I dislike
>     doing an extra copy to user into buffer. So maybe we should add an ioctl
>     to teach tun to set num bufs to 1.
>     This way userspace has control.
> 
> 
> I'm not sure I will get here. TUN has no knowledge of the mergeable 
> buffers if I understand it correctly.

I rather want QEMU and other vhost_net users automatically fixed instead 
of opting-in the fix.

The extra copy overhead can be almost eliminated if we initialize the 
field in TUN/TAP; they already writes other part of the header so we can 
simply add two bytes there. But I wonder if it's worthwhile.

Regards,
Akihiko Odaki

