Return-Path: <kvm+bounces-67100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47110CF742E
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 09:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B18A830471BD
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 08:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB501325494;
	Tue,  6 Jan 2026 07:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jw29zZzF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LeDenq8S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F8325488
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 07:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767686245; cv=none; b=NoAm0o/dO+Ycr8f/mYcgpArQQWHTlAWrRob/OCHURdHEjnlClcOiPcIJClPcvF8oTsvlPalHgFBabHpSci6CEU+PVZecVjGySPIgNaVdBBLhbdYdAJb3GEdDZ0577sUsxJX518v4hhgoUcODZL46p6Nr22ymRXs+g7/iCgG2s68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767686245; c=relaxed/simple;
	bh=2dfXE3T5FZ6K7+lqEmh5QGLTAful/RxL5/OXaLyX+Qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1iXZzoDHzSBAqP/6YvHUuFX0Q/F/Spg4fVlkXVmuNaJLD2egED3EzELL1sXbRRlVeQwOfpdScONo7CoLZ1XrPX8n1bwlvgtgIIOOshuBAbuFasgR09sfNeYEhSEGnBSIuYRGaG44YYIoYA9cKc3vTNae7DO39s99w4myZUilu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jw29zZzF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LeDenq8S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767686240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I4TYkMIrp7AW9u8pmueM8oRPi406uK0ebNKTuLEzFRw=;
	b=Jw29zZzFglG919JgI7i0xklQ2oObYZyc5leVLnIfHti9CJweJNPNRzG8C5PabdVmP4/3fY
	M+7UoQk0lJjSmBkBb7s9m1F/B8AYBTpQLUP/nNuyP4dtnrpMhO1TRrPHTSZfGnUDm1nqke
	v82l+dtoQG1lYYlghba+tsFch4GvB/Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-lOraJm4uMXC9-xyaob-Msw-1; Tue, 06 Jan 2026 02:57:18 -0500
X-MC-Unique: lOraJm4uMXC9-xyaob-Msw-1
X-Mimecast-MFC-AGG-ID: lOraJm4uMXC9-xyaob-Msw_1767686238
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477771366cbso4987175e9.0
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 23:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767686237; x=1768291037; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I4TYkMIrp7AW9u8pmueM8oRPi406uK0ebNKTuLEzFRw=;
        b=LeDenq8S5nv1p5lbaG6bd7qQ738zFIig+xqeNByShq94AUmv6LVa9pKSf9J1W5Rvyp
         a4bTksPldxgUqtTtC3rXjxeQHKFhiLku4vgmYc9HxnpTLP59/URIqLJO9V00xk0mypr2
         lAAYI8KGC1JW4u9BdcckgkMZjVkbidLQPY/AciyE/XdkY8aGcIpOs8W57Qzbf07TZZTG
         Awn1QX64ukazoBaBWNdki2gL8VgOqTxh5NiZD7j8r+6gi1TQNDHg7i8JZVv8RXXO+v/D
         +ZD0joO/4c/Cv65l7kfapujl4m6N+i+k0xozFpjQIi82BEqVNieCIo11+WtDdJSlvFpL
         KJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767686237; x=1768291037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4TYkMIrp7AW9u8pmueM8oRPi406uK0ebNKTuLEzFRw=;
        b=OldphlTJ00kUgWGMQII6XMQZUENkpUJxOQLWJZhxl8huxNIY+bM5iI6uyXxQYJ1/8y
         rcEfZ/sxFhvmnGcSkpooJ2zXMhWGVu4H+y5MZG24TQ+qHiT887JvXIKLixFkU6aUKWE1
         jKvXcyUo9Agw7wf8MKwFlKcayazHu2Q7HTcg9zADJ6IOxvIqzjN1+KXhJ4zRRwxqpnKf
         hHRcVixRH+Xey+yZE/6RPJDhrS0iAcmDAaHnXQC1l00HDqHQ99Ygd+bXcqmukUr4iO/u
         5VvxIE2Dt1rkV8fE3Y0qPsT4eNJvyvRKwyYmzvvG2Rd9z88ligVA2G+1Xen1p/X9nHz4
         W4Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWVr7BAMSglK9Xxe2kYLuU45FzWPk/8DjT3LWu0O46yBy4535M9epC92dvFidxru/qoxCg=@vger.kernel.org
X-Gm-Message-State: AOJu0YydrLoBMZwBxI/et3ikEKXXIhjJ1D9QzoYHLTBXBhlBTrQcT8HW
	SKq0sUpewsP5PAgpi2eiFHBJCjMQ2Myl3YKUYzcjro4OEq8b/L+gzIg47DqUG+pg032SxcUDln4
	RgJ2QHrQr1XopWgVxDkrU/xP4cWJU2kUVBp8CTR0JgyMwpfPGUPYrKg==
X-Gm-Gg: AY/fxX6H+bNZYYwab8Tv6nplRlyrnv4h32rdU7nSbLVwOjbh9ZCs4MUey2cxfAveBlg
	g5XoXKx18oouSllg+qN2CXYxLdIwXHkNA7tAawzdcmtriKK8xv1izNvPYGOH4fuvefVjmNEmagp
	EPozTXTZSumaVNmW8kB7uHaN83xf4V5KV93QA9Vc8iMnselQW7TWKUCikz9/B3p8fTVC1hcZpao
	2jPX/GUhXZ6J7Xx6KBXjL225hC6by9m1da+vThm8qcFQNA7KNI9OFsUj9Fx+WCCrD7BTqcS/pgW
	lUEZtHTSN5MLQumMv5Jw7gKHJUZkWTQJNkDccc247efLgVfP0x/fjYilIc8Fwo+up4tfurYZHFW
	TNxeN8mIkK9hu5NiC8FkV3jQGyw4zwgL7Qg==
X-Received: by 2002:a05:600c:444d:b0:46e:32d4:46a1 with SMTP id 5b1f17b1804b1-47d7f09ca36mr23148215e9.22.1767686237595;
        Mon, 05 Jan 2026 23:57:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHkOtxCvNvgEtYJhHLldkg64fSo56Dqfda5jX1IeA0WMV+CtMRCrIRIjLAWwju8ZN5FopMEIQ==
X-Received: by 2002:a05:600c:444d:b0:46e:32d4:46a1 with SMTP id 5b1f17b1804b1-47d7f09ca36mr23148085e9.22.1767686237184;
        Mon, 05 Jan 2026 23:57:17 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f65d9f0sm28518895e9.12.2026.01.05.23.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 23:57:16 -0800 (PST)
Date: Tue, 6 Jan 2026 02:57:14 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+a9528028ab4ca83e8bac@syzkaller.appspotmail.com>,
	eperezma@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
Subject: Re: [syzbot] INFO: task hung in vhost_worker_killed (2)
Message-ID: <20260106024033-mutt-send-email-mst@kernel.org>
References: <695b796e.050a0220.1c9965.002a.GAE@google.com>
 <20260106014632.2007-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106014632.2007-1-hdanton@sina.com>

On Tue, Jan 06, 2026 at 09:46:30AM +0800, Hillf Danton wrote:
> > taking vq mutex in a kill handler is probably not wise.
> > we should have a separate lock just for handling worker
> > assignment.
> > 
> Better not before showing us the root cause of the hung to
> avoid adding a blind lock.

Well I think it's pretty clear but the issue is that just another lock
is not enough, we have bigger problems with this mutex.

It's held around userspace accesses so if the vhost thread gets into
uninterruptible sleep holding that, a userspace thread trying to take it
with mutex_lock will be uninterruptible.

So it propagates the uninterruptible status between vhost and a
userspace thread.

It's not a new issue but the new(ish) thread management APIs make
it more visible.

Here it's the kill handler that got hung but it's not really limited
to that, any ioctl can do that, and I do not want to add another
lock on data path.

-- 
MST


