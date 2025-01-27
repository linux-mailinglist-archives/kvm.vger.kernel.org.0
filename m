Return-Path: <kvm+bounces-36660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11198A1D7D3
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 15:10:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48D531886CFB
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 14:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19F61FE475;
	Mon, 27 Jan 2025 14:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JoidnUV/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559946FC5
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737987024; cv=none; b=GRGXiD8crQvJ98h2hcaIFtAkXrlrtTiz8XZPtGIPHh52d8P2Uqe6IhNJz72hcHVvmyHorQkMW8ckO02PcWH80hbKbX5bs3QnaJYpFIZVzxi95+xdpL8s0GQDLinRGu7woJBXtw/zXz6m6SUwYyTwhMHtv+xdOjHKkk46xVlMDK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737987024; c=relaxed/simple;
	bh=apM+5LkQPI28l1tU9B88fTSqOKwe/zXNYApVrJ04oUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljxJATwy4QbskY78b32qkaLy9Ukuq7QFYxY6O9BMNb3Pu6MCAUzDJaSpcf6RYAXmpIBv90M7sMdu3mJG99zaVzndVb+xdrfKD8Q+Uk8wXhwC2YxXOzRLRnnGdhv8FNn4NSYHSTSCk6ABG99YbZeQ9ZTuMkEr2MjV1GGnSQy+ngk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JoidnUV/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737987022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apM+5LkQPI28l1tU9B88fTSqOKwe/zXNYApVrJ04oUY=;
	b=JoidnUV/kEUDXcTLmIDL3gxstMu2eyj8/3TYP26oR/u1YNsUQqYYRcN8UXrTHsQOpNp1rh
	BRlhfBTH9R49s4esocCcR8l1bFgX2MWpb+Iz+dIlUghFRMz0R7igIFc6RggRI8cYfS0Kvd
	0h0/MxMBa34dGpSU7ZSEibNcB39zxaw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-kkw7-HHfM0W3Q99OiVHISQ-1; Mon,
 27 Jan 2025 09:10:20 -0500
X-MC-Unique: kkw7-HHfM0W3Q99OiVHISQ-1
X-Mimecast-MFC-AGG-ID: kkw7-HHfM0W3Q99OiVHISQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82DE1195605A;
	Mon, 27 Jan 2025 14:10:18 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.70])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 8B11730001BE;
	Mon, 27 Jan 2025 14:10:15 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 27 Jan 2025 15:09:52 +0100 (CET)
Date: Mon, 27 Jan 2025 15:09:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
Message-ID: <20250127140947.GA22160@redhat.com>
References: <20250124163741.101568-1-pbonzini@redhat.com>
 <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com>
 <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com>
 <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 01/26, Linus Torvalds wrote:
>
> On Sun, 26 Jan 2025 at 10:54, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I don't think we even need to detect the /proc/self/ or /proc/self-thread/
> > case, next_tid() can just check same_thread_group,
>
> That was my thinking yes.
>
> If we exclude them from /proc/*/task entirely, I'd worry that it would
> hide it from some management tool and be used for nefarious purposes

Agreed,

> (even if they then show up elsewhere that the tool wouldn't look at).

Even if we move them from /proc/*/task to /proc ?

Perhaps, I honestly do not know what will/can confuse userspace more.

> But as mentioned, maybe this is all more of a hack than what kvm now does.

I don't know. But I will be happy to make a patch if we have a consensus.

Oleg.


