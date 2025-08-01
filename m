Return-Path: <kvm+bounces-53855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B141B18871
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 23:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20D38562CD7
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 21:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B67728D8EF;
	Fri,  1 Aug 2025 21:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Hk1SCEXa"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDF14207F;
	Fri,  1 Aug 2025 21:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754082083; cv=none; b=fKPE4QI6Srn19xR1VDMe3JbzGft7hYmnOaq3S9eLsm2gVZk05s/4KfXTFXGyI0EPzoHdWdwQem9KFTbjyb5kw9Ydv3QIqaA+KV4sN8tOy/EBCh0egmxJHiVNz3Xufr7j5giLJFIQ64WiRQLRXgfQvaMazRTfOXHDJI0oABKZTm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754082083; c=relaxed/simple;
	bh=PVeG3LcWV98xhs5CzZv3kX6ost9c8KHyZTHCcL+3rrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qh7HEEJvM9/u7t4T90n7z/KMr2Fa83GVuY/wenGE2D5kZ9o5dFoR6FxJUn5rlxclntN8T7wIS+DuCMDjQCpFMSPpfbECYYxqZJI2hfN0RTCucaY+XsItENZMuHY877nLGqq5z7Lq8CgAFhFrRQ5pM282j5x725IER4bcNWry8PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Hk1SCEXa; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=f4EUtpQvfD1GWjXjCaIBDDisUV6m4mX8lVb0bZq8pMw=; b=Hk1SCEXal1ou/150
	I+6mXB1y9B7k9Q+ydLpadDDD2e2UjgCFVqoCK/ULop1nwGYg6+meyRcdx9E2JDWrfMwNSGungqARM
	DQKxNDPjOGksuP3j6MIRlG0lxjzdPc8H/sgQeK6PF7hheyOj8vd5gJRveye1hOXa2DVcCd1TMsAaC
	EDD3hGCccHVa4iLuIIE9VB+qunPwNEkZB1uxmUcCV0y8FCD2fhbtxOwFgS7v7IscuD1OzAKLVTa1B
	wbog1jbONAgWuO7TmZtMaVwgerXHoTEpwTyTVViy28/Xc1gKjQdo0wwmwH4Yc1Ozr7N1d6rbJWUoX
	kQ7N6IEHDYyU7XSxMw==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1uhwsB-001mFM-00;
	Fri, 01 Aug 2025 21:01:03 +0000
Date: Fri, 1 Aug 2025 21:01:02 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, alok.a.tiwari@oracle.com,
	anders.roxell@linaro.org, dtatulea@nvidia.com, eperezma@redhat.com,
	eric.auger@redhat.com, jasowang@redhat.com, jonah.palmer@oracle.com,
	kraxel@redhat.com, leiyang@redhat.com, lulu@redhat.com,
	michael.christie@oracle.com, parav@nvidia.com,
	si-wei.liu@oracle.com, stable@vger.kernel.org,
	viresh.kumar@linaro.org, wangyuli@uniontech.com, will@kernel.org,
	wquan@redhat.com, xiaopei01@kylinos.cn
Subject: Re: [GIT PULL v2] virtio, vhost: features, fixes
Message-ID: <aI0rDljG8XYyiSvv@gallifrey>
References: <20250801091318-mutt-send-email-mst@kernel.org>
 <CAHk-=whgYijnRXoAxbYLsceWFWC8B8in17WOws5-ojsAkdrqTg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAHk-=whgYijnRXoAxbYLsceWFWC8B8in17WOws5-ojsAkdrqTg@mail.gmail.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-34-amd64 (x86_64)
X-Uptime: 20:59:29 up 96 days,  5:13,  2 users,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Fri, 1 Aug 2025 at 06:13, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> >         drop commits that I put in there by mistake. Sorry!
> 
> Not only does this mean they were all recently rebased, absolutely
> *NONE* of this has been in linux-next as fat as I can tell. Not in a
> rebased form _or_ in the pre-rebased form.

My notes say that I saw my two vhost: vringh  deadcode patches in -next
on 2025-07-17.

Dave

> So no. This is not acceptable, you can try again next time when you do
> it properly.
> 
>             Linus
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

