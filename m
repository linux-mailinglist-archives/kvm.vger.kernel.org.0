Return-Path: <kvm+bounces-36616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9AA8A1CD86
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 19:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46C3E16328B
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 18:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE44155326;
	Sun, 26 Jan 2025 18:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RBeXJG/i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2782425A621
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 18:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737917671; cv=none; b=ruu+JmrvOl6PaBN4wwDxGm3bFrgP//6hCR41yOdg8W33mV+uQQPmMHj3ZdMuSwVQ+Wyd9BS+6SrdN4werUyQ6Dgo7W3Gj2IBA9C3SIyOP/0u48aplmbaXlS2xhxJMTNJJzHHFZzsB4JM0fqIn95ZIo4AINYkYqoui4CPI6rf9LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737917671; c=relaxed/simple;
	bh=/KJ2WR57RgY9ix+IO8WnnsLREauCRfKWo1RFd2c4s0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVDjANElTuycrl8j2ltvpOlSeMyqOez2VPYPXSdMbGa3/vPYlP0ydK6UOtWAZLaTi3S6uTswuA2JtLi7wpJfRHJMTwiCc6xzqUYg4eo0bH3rY6nUq2aK9oEpn2eXMg2OJEYDl0qpuHJRfqAWC+c8+MOFj6duX+F4mxJtBVGCv9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RBeXJG/i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737917667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EzKWJUEghtc+FP06WT0XMlvrjuwsm6QvFFkolqH7BJM=;
	b=RBeXJG/ioqnfLD+uiP7tpBpX1/O1KgtaZfOcZcJfWq+6+MaMN3QzKVpyzCMPcbnJwmzjh9
	fhUfKI6VR7i70Slt7HdHJdGhKSi71C7Uf0XrhVDk8PEp+kjgMrU5yc2yX0faNtrKtca3ym
	aOVIF+LnyU03GbXLcQU77zovFTX6oTk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-cQP7EJbCMp2ntNeygzTQMQ-1; Sun,
 26 Jan 2025 13:54:26 -0500
X-MC-Unique: cQP7EJbCMp2ntNeygzTQMQ-1
X-Mimecast-MFC-AGG-ID: cQP7EJbCMp2ntNeygzTQMQ
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A48781801F1A;
	Sun, 26 Jan 2025 18:54:24 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.224.72])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 9E56E1800268;
	Sun, 26 Jan 2025 18:54:21 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 26 Jan 2025 19:53:59 +0100 (CET)
Date: Sun, 26 Jan 2025 19:53:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
Message-ID: <20250126185354.GB28135@redhat.com>
References: <20250124163741.101568-1-pbonzini@redhat.com>
 <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com>
 <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 01/26, Linus Torvalds wrote:
>
> On Sun, 26 Jan 2025 at 06:21, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > Should we just add some flag to say "don't show this thread in this
> > > context"?
> >
> > Not sure I understand... Looking at is_single_threaded() above I guess
> > something like below should work (incomplete, in particular we need to
> > chang first_tid() as well).
>
> So yes, I was thinking something similar, but:
>
> > But a PF_HIDDEN sub-thread will still be visible via /proc/$pid_of_PF_HIDDEN
> >
> > > We obviously still want to see it for management purposes,
> > > so it's not like the thing should be entirely invisible,
> >
> > Can you explain?
>
> I was literally thinking that instead of a "hidden" flag, it would be
> a "self-hidden" flag.
>
> So if somebody _else_ (notably the sysadmin) does "ps" they see the
> kernel thread as a subthread.
>
> But when you look at your own /proc/self/task/ listing, you only see
> your own explicit threads. So that "is_singlethreaded()" logic works.

Got it...

I don't think we even need to detect the /proc/self/ or /proc/self-thread/
case, next_tid() can just check same_thread_group,

-	if (!(pos->flags & PF_HIDDEN)) {
+	if (!(pos->flags & PF_HIDDEN) || !same_thread_group(current, pos))) {

right ?

Oleg.


