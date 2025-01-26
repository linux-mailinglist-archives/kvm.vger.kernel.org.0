Return-Path: <kvm+bounces-36617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A92CA1CDFA
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:04:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 747D6166BE9
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 19:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A716E1714D0;
	Sun, 26 Jan 2025 19:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qus9q7q6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5600B7DA6C
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737918274; cv=none; b=ZSzEgsr+hC/izRi7lFcU4uLQqKLz8GcEgp+zs8UE3o1nTcnXYSCLSeP4tJdEXReDcug5LWvIRVCcGLSNdsn4qT5g2m1ySDfbVqdqQqjfchCJ3VH9m61qgAuH3ov/OxfILD0Bjt28yH80/JKgZlc8WvxpS0lvO/lRnYzSnke79CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737918274; c=relaxed/simple;
	bh=OfhMQmVi9ajYGPKooiZu8+geF/qzt4wIbExr6JiovJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HkfPZMBEXFKIx9S+Y0ko1qeqndC/5QmRbj6D+Z7mLzyzRFn9UVyVSBnWAv0fl7x1NfBhRZdv3k7BLW1ZTaq6tMnE1kpsLg4MFNd9RZHOJ5Jj06jdwqxm9GsZjriiorMvYY1d5t2b+tYpGLsmt1u5nQFBlBpRMmAf6S0H37g3Tqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qus9q7q6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737918272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i8PmMpCHGx/VMuaEGT9fo4QjZu/A1gjnBy7YlRwJ3qA=;
	b=Qus9q7q6RCgjYBLoQonOH2trLaL7IxdVwSR4l6f/fYUP2b/MUmBYIHQSuk5pnwaMrCXVwb
	cz85pL4Z03lBEFmTZ5WbyvcFJ0RYtgYb8a+qlJgIQqOF5CMT7S+7MOIJQHfgc5+MZEWMFz
	VZOV08+coP/V8a8BW2uQ9DzN65fCQ8I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135-1UkySfpKO_ewyKqbCBZoUg-1; Sun,
 26 Jan 2025 14:04:27 -0500
X-MC-Unique: 1UkySfpKO_ewyKqbCBZoUg-1
X-Mimecast-MFC-AGG-ID: 1UkySfpKO_ewyKqbCBZoUg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D9E219560BB;
	Sun, 26 Jan 2025 19:04:26 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.224.72])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 2769D195608E;
	Sun, 26 Jan 2025 19:04:22 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 26 Jan 2025 20:04:00 +0100 (CET)
Date: Sun, 26 Jan 2025 20:03:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
Message-ID: <20250126190356.GC28135@redhat.com>
References: <20250124163741.101568-1-pbonzini@redhat.com>
 <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com>
 <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250126185354.GB28135@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 01/26, Oleg Nesterov wrote:
>
> On 01/26, Linus Torvalds wrote:
> >
> > I was literally thinking that instead of a "hidden" flag, it would be
> > a "self-hidden" flag.
> >
> > So if somebody _else_ (notably the sysadmin) does "ps" they see the
> > kernel thread as a subthread.
> >
> > But when you look at your own /proc/self/task/ listing, you only see
> > your own explicit threads. So that "is_singlethreaded()" logic works.
>
> Got it...
>
> I don't think we even need to detect the /proc/self/ or /proc/self-thread/
> case, next_tid() can just check same_thread_group,
>
> -	if (!(pos->flags & PF_HIDDEN)) {
> +	if (!(pos->flags & PF_HIDDEN) || !same_thread_group(current, pos))) {
>
> right ?

Or we can exclude them from /proc/whatever/task/ listing unconditionally,
and change next_tgid() to report them as if there are not sub-threads, iow
"ps ax" will show all the PF_HIDDEN tasks... I dunno.

Oleg.


