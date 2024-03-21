Return-Path: <kvm+bounces-12369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F1F8857B2
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 11:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AC051F23199
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 10:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D67557871;
	Thu, 21 Mar 2024 10:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvIPbY4h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D490E57304;
	Thu, 21 Mar 2024 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711018767; cv=none; b=FbQjG76yQQGoOKm+BYQAJdUYcvsJpOExkhMBkEytDTwFhWu+4VoK9dksF27MNu+ymDbJ9oDcjbfYx6Hfkmak/pBI7Wt6Rj5vfL04o6urh9m3Z8W5JRXuHsxcmakwKacK7cCCR5lF+RnMIJLSdoCtNnaGjo7QF6alRnGO8G6JxIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711018767; c=relaxed/simple;
	bh=SIT4t9WMLr2rFdZLU8jbRHOWoltdDcFzJeJ38E0d+hA=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:References:
	 In-Reply-To:Content-Type; b=urYQeL0Y6hb0+mRkriPvJDTB1ex+hLv8umouwYWJX6mj8vpPPfsgUPVqGq4vnQZUoY+cJjcBNhqxEp2W9pYRFOVlf0LMfuowCYRscyjTPlaUdGnBKXsKDHt5ZZzXfK2PAOv1rBeRCwb34Ogzg2qEKYlnqQl05NqDWgYPRv9Tg8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VvIPbY4h; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33ec7e38b84so494449f8f.1;
        Thu, 21 Mar 2024 03:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711018764; x=1711623564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eG4p8QA4YdJE1Wkel/7+Mo6QY3CJ0FlB+PUcD8ZNkIQ=;
        b=VvIPbY4hEEabnqRbqZ/uhwCbSudb/QcviBBL3LBpsxC4RTCN08NkZVBqy3Zx08mSdS
         qD4DrGZrG1UlEjykRRslMMzzFoNBTTqWEgEo65wp0waO4Rw/mDFTqEzBC8pM+c7hrAtb
         +CTgas/2KvHxKVsujcO/Hlu0CQgYEdqAef1+gGjDuBU9V/xBhQDyYFE8jPxfh5VRYJ9e
         dpcNH1mpHMFXdQdetJSGw9/HzA9/1U04+IOdvS4UHhbyKrYcgNBnhmZlC4o1PfccX9jT
         fQbJ5A31GJVwWAFR9xmMNgy4yQj33NKBrfh7khO3VCC16QP6ndCDhWDrud7OcgpaVoeW
         PprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711018764; x=1711623564;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eG4p8QA4YdJE1Wkel/7+Mo6QY3CJ0FlB+PUcD8ZNkIQ=;
        b=OcprizV5J+/hQZO0uphGp4JM0ypOEb1V0CyfN40TLnXkje+AeOA/oPzwj3WZSGAgM3
         RHUoaw79hG0vgFm7ywRSjkwU3h3DqwePru/RgZEbwMKwgaO0teJOqoALhYvCHn17f7Xg
         XMY1F/I5kHX+IhN7/eLxUqcecHgWo9OOgVEytdEPfZTspuz+EZ54c7Z6BnJQ/jAP5NXT
         W4iEjpgXnpwBWDp/Wz1w5kMLiyVZMajgMqfU4VAc5VS/v1qdOXqyu3ZwN5ATWuDeQB93
         XWX5U+s9GXVe+6aOSNOjgt/Avf5GOBwfOr42Gta1tp/d4CmDGXFW0U9yrcQK9uMT/5Q2
         pQKw==
X-Forwarded-Encrypted: i=1; AJvYcCWHtcMx53eGUWEUz+a0wXshJGMPJq4qamekDxR6o38x1aCb75+GLwXpxIEmJc4Zp8/npuvOI0j2KL9ruIfFdBiJWy461ZHOjJ97uo3rTRrWImW7WwKfC7HX3ihHyejwovpj
X-Gm-Message-State: AOJu0YzxCKdJZsW8A7jSOq5fFI6gxkUjGD+ZNX2I8Kup5ceFdG8c63Iz
	IZSidwEuV4MFxLHJxmk9hPs4oEJhZsANTnMbaXwjrqGpv2Gf+WcT
X-Google-Smtp-Source: AGHT+IHAfucBMR/fgcO1fEXQyOLquubuxMhuJm9CoIsojliCDoUVd8k1/7s/83dGuWDVgaK7pREGyw==
X-Received: by 2002:adf:ec89:0:b0:33e:afec:e7d8 with SMTP id z9-20020adfec89000000b0033eafece7d8mr1065470wrn.42.1711018764115;
        Thu, 21 Mar 2024 03:59:24 -0700 (PDT)
Received: from [192.168.16.136] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id b3-20020a05600010c300b0033e7b433498sm16944301wrx.111.2024.03.21.03.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Mar 2024 03:59:23 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <ad0ad0d3-5be0-447d-8c0b-6b77e763dad9@xen.org>
Date: Thu, 21 Mar 2024 10:59:22 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [syzbot] [kvm?] WARNING in __kvm_gpc_refresh
To: David Woodhouse <dwmw2@infradead.org>,
 syzbot <syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 syzkaller-bugs@googlegroups.com
References: <0000000000005fa5cc0613f1cebd@google.com>
 <b7561e6d6d357fcd8ec1a1257aaf2f97d971061c.camel@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <b7561e6d6d357fcd8ec1a1257aaf2f97d971061c.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/03/2024 21:25, David Woodhouse wrote:
> On Mon, 2024-03-18 at 09:25 -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    277100b3d5fe Merge tag 'block-6.9-20240315' of git://git.k..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17c96aa5180000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c6662240382da2
>> dashboard link: https://syzkaller.appspot.com/bug?extid=106a4f72b0474e1d1b33
>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14358231180000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=110ed231180000
>>
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-277100b3.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/6872e049b27c/vmlinux-277100b3.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/68ec7230df0f/bzImage-277100b3.xz
> 
> static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long uhva,
>                               unsigned long len)
> {
>          unsigned long page_offset;
>          bool unmap_old = false;
>          unsigned long old_uhva;
>          kvm_pfn_t old_pfn;
>          bool hva_change = false;
>          void *old_khva;
>          int ret;
> 
>          /* Either gpa or uhva must be valid, but not both */
>          if (WARN_ON_ONCE(kvm_is_error_gpa(gpa) == kvm_is_error_hva(uhva)))
>                  return -EINVAL;
> 
> Hm, that comment doesn't match the code. It says "not both", but the
> code also catches the "neither" case. I think the gpa is in %rbx and
> uhva is in %r12, so this is indeed the 'neither' case.
> 
> Is it expected that we can end up with a cache marked active, but with
> the address not valid? Maybe through a race condition with deactive? or
> more likely than that?
> 
> Paul, we should probably add ourselves to MAINTAINERS for pfncache.c
> 

Sorry, missed this. Yes, given the changes we've made, we ought to step up.

   Paul


