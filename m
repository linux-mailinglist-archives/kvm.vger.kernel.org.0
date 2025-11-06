Return-Path: <kvm+bounces-62229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22EF1C3CC5D
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 18:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C2AF625DA4
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 17:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE6234D937;
	Thu,  6 Nov 2025 17:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AHu8QXwK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E07346E43
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448904; cv=none; b=MezGPXqeMBcVPLlLbnxZXq3/A68MxmRVFOHkHs7ddh6ourQcKG9dRWJ3pN0ZD9qZB2lPgKfVig3ADbx9jnsvTlc0cHrFPK3RqOb3Z+Z/Zfl2+ljrul0P5Mv3/47D706TaB1vlBu0DPCHgnwjGD0mWah5G1KgFi3tuFjHkGTjhLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448904; c=relaxed/simple;
	bh=zOTaZMQBfTdrgEtVmwzmnPcqWwD6jnNQXB9lToGTo9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8xGV7Oh/3EdkEy15BdAcZp7QKnL0XbAPQbhBEDwPQMDBE9OoOqs/frJtSuWPibzXvso8ca/Jk+BNqZWDwVSSjyf0H5sFRsuqdaQR3coAjlAZr5Rd6s9BEQv3WM47XiFqegn+U8Q8o7el7axCpsWZPm07vHXEAS1j60GcTnLCwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AHu8QXwK; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-294fc62d7f4so11700445ad.2
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 09:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762448901; x=1763053701; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=igZsw+VHb3F2oODDk3y9EP32fa29hnEO+2WLrYTePMw=;
        b=AHu8QXwKjw38HXggmTzxfM6q5ZnxGTf1J6l2ocB4GWHtW+d8eTJQuugBfIjDcQQTio
         mewiGqy6TDesgSV+XPibsfXbn9GxKOtFAK6W6Y0lMytt8wuE5ZuXKGju/Aj+R65Uh3/g
         qpFJoAQOS/BZ6IhPvjMThCTwtZRiCu3X2XOLPBh4Tf6QhHoib39IfJZvCc5q8tBYlWGp
         Cw8UiLWtE9X4diz+vSqSDwFgZJd2qDyvAmzT+J2hG+mYOQIVt2ZA8Jlbze1GxrjjAbwK
         0pFDc8QkobPkug4JiwfpuPcqgIRWpWa9reou7+tLThJv9jNRqNc6D8xvpsY1U4/XtqQQ
         Qg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448901; x=1763053701;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=igZsw+VHb3F2oODDk3y9EP32fa29hnEO+2WLrYTePMw=;
        b=E9LGrxAbAfPi0ZFR1jjT5wi0DIObi/NllwQO1tLWUyHxvKFzUuEOsmbRIDIOzJW1CE
         n4JyFsWuYCGtvede7+frVVTnsaHD+piXu5RTio5P+wPe4uKJDwCjTaBF71e/+wIoZ0Et
         O6TOMMVpmN2GiQ0Xgf02MO+wBdkaIl28RjiFjjMbQYd5ShlNj9027KH8ZYL7Ia6ZiVcj
         qwv2p3J+FnBL1oqjXYvyfnuTCr2YmDua26h3clDvBGi1lfsqHBwwNTmyYf/gHVVP74Cq
         E51UIne2kVTZPAoMzU+bF+pzryH0DpV2hGDdaknfzSbHkOpOHGHfuiMXhH7nkAn3/K/O
         OYag==
X-Forwarded-Encrypted: i=1; AJvYcCVWSWBx8K1qSKcCjI4B/o88RAfFJaYSCK+6S8BkM0Vt5/tZAtR3zYHnnOxwykC1n1AOKE0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2S2HR8ZutglFldRRACPdE8mHGVHgrjvl8aboODddHvVMa9aN0
	2aIYpVFzYdosfPm6cEfN1SsO4Hn/1d+FGxGti6xZd0DoSPCx38H+qD9w3/Nww2UCQA==
X-Gm-Gg: ASbGncuKefGaYXXSqP0hOZ6uCTNO76jubYOKwMgqZz+2vDKHNb0TUPrBYXB65uf//XK
	LcxnsNIxyP3omH5UQm9CkLtGf8G3xoG3KpRJkOVGIREGvvTXk/Y0GExeGM/Fm+Wk6k8iCuWPRwV
	0yniT9CK7koz7aFqq0dJu0SQsVFtxhKnf1iQRx4tLltm9UR4+6CHZf23aX/ffinbIhowOTaSBzV
	LPOfHh5KkS3qJf67KpvFVo6zdSoNfGXcYokhQg6JFsBk4HaWthnndKHfkhAsFGC1C/I0/yDpCX5
	1NyJqHrr2He8LtGU8HidBu66l73HEf5OL9Re8gaBYeoD//rI3hCkHJgPc5GoAPV1OAGi9oE3Kl4
	bcVEWbsVg4QJXLfsPfWz7O+S32i46o5hc8sUoOg5alwADctGCnQM5tq/R6g2lLUeJczQQgqfr7+
	/b/vbcYNW4Erf/373aCCMvJblrrFBUyjdphswGM/2ltSEoxY8Mx2G/
X-Google-Smtp-Source: AGHT+IFxnLQXa2QzBiKv9F+tRewohN2WBdVZFUDy9IUDgCpSgm1P/pWA5GujKa6Og8jVcirUq0QX6Q==
X-Received: by 2002:a17:902:e786:b0:295:570d:116e with SMTP id d9443c01a7336-297c045433bmr2165605ad.41.1762448900878;
        Thu, 06 Nov 2025 09:08:20 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650968235sm34095635ad.16.2025.11.06.09.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:08:20 -0800 (PST)
Date: Thu, 6 Nov 2025 17:08:15 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] vfio: selftests: Export vfio_pci_device functions
Message-ID: <aQzV_2DXwxNSQxVK@google.com>
References: <20251104003536.3601931-1-rananta@google.com>
 <20251104003536.3601931-3-rananta@google.com>
 <aQvu1c8Hb8i-JxXd@google.com>
 <CAJHc60ztBSSm4SUxxeJ-YULhdYuCHSprtns0xt_WVJPvgmtsBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60ztBSSm4SUxxeJ-YULhdYuCHSprtns0xt_WVJPvgmtsBA@mail.gmail.com>

On 2025-11-06 10:13 PM, Raghavendra Rao Ananta wrote:
> On Thu, Nov 6, 2025 at 6:12 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> > > Refactor and make the functions called under device initialization
> > > public. A later patch adds a test that calls these functions to validate
> > > the UAPI of SR-IOV devices. Opportunistically, to test the success
> > > and failure cases of the UAPI, split the functions dealing with
> > > VFIO_GROUP_GET_DEVICE_FD and VFIO_DEVICE_BIND_IOMMUFD into a core
> > > function and another one that asserts the ioctl. The former will be
> > > used for testing the SR-IOV UAPI, hence only export these.
> >
> > I have a series that separates the IOMMU initialization and fields from
> > struct vfio_pci_device. I suspect that will make what you are trying to
> > do a lot easier.
> >
> > https://lore.kernel.org/kvm/20251008232531.1152035-1-dmatlack@google.com/
> >
> Nice! I'll take a look at it. By the way, how do we normally deal with
> dependencies among series? Do we simply mention it in the
> cover-letter?

What I usually do is:

 - Mention in the cover letter that this series applies on top of
   another series, and provide a lore link to the exact series version
   it's on top of.

 - Upload your series (with the dependent series) somewhere pulic like
   GitHub so that it's easy for reviewers to check out your code without
   having to apply multiple different series of patches. Include a link
   to this in your cover letter too.

See this series from Vipin for an example of doing this:

  https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/

> > Can you take a look at it and see if it would simplifying things for
> > you? Reviews would be very appreciated if so :)
> Absolutely! Sorry, I have it on my TODO list to review the changes,
> but didn't get a chance. I'll get to it soon. Thanks for the reminder
> :)

Thanks!

