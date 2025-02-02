Return-Path: <kvm+bounces-37073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0216A24C5B
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 01:59:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43C6B3A5B20
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 00:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7169B17BD9;
	Sun,  2 Feb 2025 00:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QBZy3e/1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918F7DDBB
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 00:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738457929; cv=none; b=GdQTVMpJ1CiT23xNoTkiZJNGHV89i+SGOhnVLHaqeny47lYdaVDqnMyiDMAhYmLzav1LDc/4JdiNpZzBS5BoaMG4PzR20cKGK7hrE5R7KRxz+OV4KZbr4S0o6Tbe2BSvlX3V11vlO7dMH5VKmp5rbKk8yy6tHJgRGir4JyzPi20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738457929; c=relaxed/simple;
	bh=wTdxQSHNowLLmMobvaMcMprIsVZ+/hyqVnL+ii8pks8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HjI7xRe7UAJEVtMT9DVf6dQyHfvpDgwMdrJxkTc3S3Dsf9gVK6l3NOQ32UddTPRy0oXAT/J9ybsxSoe1MoT4r5jSWqtmfZUEnBx/onJNOmPUtraEhIL/yTMLEaPNKGPXKH9237bpc+UgXoSsUTtwGer4C39NRNObWz2+os5smHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QBZy3e/1; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aaec61d0f65so479591466b.1
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 16:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1738457926; x=1739062726; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0i2RBA9AG5RGJ2Y4fhUq4YhT8DGp5O3OFexnsh+308w=;
        b=QBZy3e/1EQGv5gUEtm/pZbPIW/2mikZ8l+LLIY0ItIoA7a0KjshBh2MARq+JNeKymu
         /TJHSywKjXlvfb9OJFn+ozVatQ8cWDcFqUGQBfi90TEkHw8ZxEi1oDew+CVTok60rXef
         vDtQXPRsKRjfXY2CEs2K3wDTofostoLfkdbcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738457926; x=1739062726;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0i2RBA9AG5RGJ2Y4fhUq4YhT8DGp5O3OFexnsh+308w=;
        b=Hc8UudmWt7mPvhHH1hUJACLzNpO+3dvV9CjJtwPrftGGPxMpQCQ3gYNjZZRCZDpzme
         NT23zujZ+83RZpKJZ8SdNWDsPgSUyP7OJcOBFWJS4uM1gWDsJDsrg45xNREHc8hjSdiX
         WjckUiGelVrnqqX1FLOpe5KkOrZrncqQtp1wUvrVN6NrV+QoLzTO9uqPojGb65Du9nvT
         R911imaQJgGTdE5FSKztYj06krN7rxZdLXirMLaNRrFETr/0JEO2NRCOzLU/4jRwrPk3
         BTBH2hEOyv/2DWRNsaWd/G/hSewCL5wgPGTqiu6WRL8ybeL2WvEKWriiXB38a5l0QPWQ
         kuMg==
X-Forwarded-Encrypted: i=1; AJvYcCU5KovNEYmtY2BAEgqHNWHiEAC7gTXPhANE5Ouk+udRIZ6zlZ4Hchlv3Kj15dm1qfph6VA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNw4/JcXpDGVgfHrhGtUMLUxkujq0fdY/cBNy6ndB4XOKDRK34
	fS9iW1/x8En9MEaHAbirVkO6SmJJ1vac4+SIcryx4Yodl/JGnzTIvk8Cue+x3ZKPLTis5XOObxn
	vNVl9KQ==
X-Gm-Gg: ASbGncv0IDlTEOVp5evMeau2mfs1blEXZ0NQjqnMm5Ob5JOEPbzAS//yzCIz4MipXzY
	YcN9WqAaEtEtswxy21zbxh2ZOQikhmv4yqO7dwXqaUSG0HZas0zmqTm7ooHk178eiOCaR84TFkB
	/iOqs1G8Irt1lFjL9Xs+Ik/XZfrl+jfjXm8lPZzkhI9DC0JsnyIoOxdgM3j3FYcFq5z5esw/FVO
	rNVgWqFpF46gO3WPCETC0SWHqdfIaczd/zPezB+SWPzrnxtDQtDfUKSu0MIEQV6BR3IyoMLjk5s
	/ACKtwrVCiQm+geW63xSW6DLK71a5sIvOtoctM0GXivnddJVNfYuMGHVlWlRcu6nRw==
X-Google-Smtp-Source: AGHT+IGJVhVmOXqaJpPvGTo5cc+8Cw66q8+93oixFsfBwfrRgyckQbBetCirxsQuJdlN2jkW1v+qpw==
X-Received: by 2002:a17:907:1610:b0:ab6:b8e6:d41b with SMTP id a640c23a62f3a-ab6cfceacacmr1881470066b.16.1738457925585;
        Sat, 01 Feb 2025 16:58:45 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47cf2aasm495264266b.45.2025.02.01.16.58.43
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 16:58:44 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5dc89df7eccso2465393a12.3
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 16:58:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWuvKyl9s5aYTkt/d9wK0B3HbCVfD4nmkS1YvtkmAkaSR+GIfwrHZTUl7AOwr99WDb+kgU=@vger.kernel.org
X-Received: by 2002:a05:6402:50ca:b0:5d9:a55:42ef with SMTP id
 4fb4d7f45d1cf-5dc5efc4586mr20023222a12.17.1738457922880; Sat, 01 Feb 2025
 16:58:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731684329.git.josef@toxicpanda.com> <9035b82cff08a3801cef3d06bbf2778b2e5a4dba.1731684329.git.josef@toxicpanda.com>
 <20250131121703.1e4d00a7.alex.williamson@redhat.com> <CAHk-=wjMPZ7htPTzxtF52-ZPShfFOQ4R-pHVxLO+pfOW5avC4Q@mail.gmail.com>
 <Z512mt1hmX5Jg7iH@x1.local> <20250201-legehennen-klopfen-2ab140dc0422@brauner>
In-Reply-To: <20250201-legehennen-klopfen-2ab140dc0422@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Feb 2025 16:58:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi2pThSVY=zhO=ZKxViBj5QCRX-=AS2+rVknQgJnHXDFg@mail.gmail.com>
X-Gm-Features: AWEUYZkrc1rbpsukghJrnBMXjfiiupnnm33djYsyEN114ENNjNC4tG_tthCj53k
Message-ID: <CAHk-=wi2pThSVY=zhO=ZKxViBj5QCRX-=AS2+rVknQgJnHXDFg@mail.gmail.com>
Subject: Re: [REGRESSION] Re: [PATCH v8 15/19] mm: don't allow huge faults for
 files with pre content watches
To: Christian Brauner <brauner@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, amir73il@gmail.com, viro@zeniv.linux.org.uk, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-ext4@vger.kernel.org, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 1 Feb 2025 at 06:38, Christian Brauner <brauner@kernel.org> wrote:
>
> Ok, but those "device fds" aren't really device fds in the sense that
> they are character fds. They are regular files afaict from:
>
> vfio_device_open_file(struct vfio_device *device)
>
> (Well, it's actually worse as anon_inode_getfile() files don't have any
> mode at all but that's beside the point.)?
>
> In any case, I think you're right that such files would (accidently?)
> qualify for content watches afaict. So at least that should probably get
> FMODE_NONOTIFY.

Hmm. Can we just make all anon_inodes do that? I don't think you can
sanely have pre-content watches on anon-inodes, since you can't really
have access to them to _set_ the content watch from outside anyway..

In fact, maybe do it in alloc_file_pseudo()?

Amir / Josef?

              Linus

