Return-Path: <kvm+bounces-47756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A03CEAC4858
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 08:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86B2D16D084
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 06:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3051F4295;
	Tue, 27 May 2025 06:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=netfort.gr.jp header.i=@netfort.gr.jp header.b="ZoBZH1RI"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.netfort.gr.jp (mx2.netfort.gr.jp [153.126.132.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE331E521D;
	Tue, 27 May 2025 06:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=153.126.132.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748327021; cv=pass; b=NAS3BNtuR7c/4/6D2cnQ8FzRefFs/Gt3I6/RvdW6nCEAxguo+P48jzeDDH9KseoCCNIq362U2XebGSmxTkQDdruYOESyYkNwbCpCBgw/Q/EaY8qflwqV9T5WJztFJRGU/xekNmx0mZdQBCrZw1v2h1CVMLBx3Ap25MtfcaAhQb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748327021; c=relaxed/simple;
	bh=CJHT5aoQD6gtvBEzG34ODkvg0ZzrELWrqdqVCXDFzkw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kA0jLC1OHDlOU9OqkJDDFxwViEOhmRTBfyBwid/dHZeYuGJ9NHzmttJIGRj9kupwGqgzV/JBsR72J5dOCd7sMYuOrCB8Zl/Hyb7jkPf5N6cJF3n7OWfm5mf4jSY85nYo0iqMyub1Eb0KZEYztnM9fOS/1OyulfIx4b4b2awt1SQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=netfort.gr.jp; spf=pass smtp.mailfrom=netfort.gr.jp; dkim=pass (1024-bit key) header.d=netfort.gr.jp header.i=@netfort.gr.jp header.b=ZoBZH1RI; arc=pass smtp.client-ip=153.126.132.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=netfort.gr.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfort.gr.jp
Received: from zen.netfort.gr.jp (localhost [IPv6:::1])
	by mx2.netfort.gr.jp (Postfix) with ESMTP id C921A5FAD5;
	Tue, 27 May 2025 15:23:36 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfort.gr.jp;
	s=selector1; t=1748327017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6iNEbd+HAwzuNGwpKU4J/9K2iT1KrIlcm1U9kNUjI0w=;
	b=ZoBZH1RIusm0SNKot56Mx8PqYvQlSI4/M7Kq8CKVWwgMW0/SxiTQpMzOKPjSeRXy79dknE
	UoYUtl5hua2ShypukST8wiy6zpzpbYhOlIvHS9aWSY1FuosszU5635ZrrXHt7UMpaitctr
	g+MWjD/qxeHQ0CxIOverLGY3W9iGZig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=netfort.gr.jp;
	s=selector1; t=1748327017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6iNEbd+HAwzuNGwpKU4J/9K2iT1KrIlcm1U9kNUjI0w=;
	b=MaDoX4y8QbyYfcXQDwmz5ib1QKYyJQN5DiRipg2Rh2Wu4rWryHszf3z+lcmFL7+v9vzG2C
	SSWqtL7mQoREkTtD/bVV+qYmtOtx12jn7tCwf37mytIngATaRuo2sI2d466a7oJgwQd3If
	qzAccb+Feu3GC9HljUSMgG/CFxUiyEc=
ARC-Authentication-Results: i=1;
	mx2.netfort.gr.jp;
	none
ARC-Seal: i=1; s=selector1; d=netfort.gr.jp; t=1748327017; a=rsa-sha256;
	cv=none;
	b=vX8sQedGdYvsiNuqpr73j/i/4ayWlVXV5Dv+/PlieNZUhyffTZ938JFU0HW9oK3TTaV/jc
	P7E7kBizDjANR1/QWFU8DgIx4vWNo8t7nkpDRQUttcWN3Mvlfx4FjesCERDthK9ttm5BYS
	MO/rDcSZrahaMmf+bgOZm/QmJ7N5aaY=
Date: Tue, 27 May 2025 15:23:36 +0900
Message-ID: <87bjrea7x3.dancerj-dancer@netfort.gr.jp>
From: Junichi Uekawa <dancer@netfort.gr.jp>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: dancer@debian.org,
	mst@redhat.com,
	qemu-devel@nongnu.org,
	adelva@google.com,
	uekawa@chromium.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH] Fix comment for virtio-9p
In-Reply-To: <2636618a-5000-449a-bc2d-f7bf253bf26d@tls.msk.ru>
References: <20250527041123.840063-1-dancer@debian.org>
	<2636618a-5000-449a-bc2d-f7bf253bf26d@tls.msk.ru>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?ISO-8859-4?Q?Goj=F2?=) APEL-LB/10.8 EasyPG/1.0.0
 Emacs/28.2 (x86_64-pc-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII

On Tue, 27 May 2025 15:11:36 +0900,
Michael Tokarev wrote:
> 
> 27.05.2025 07:11, dancer@debian.org wrote:
> > From: Junichi Uekawa <uekawa@chromium.org>
> > 
> > virtio-9p is not a console protocol, it's a file sharing protocol. Seems
> > like an artifact of old copy-and-paste error.
> 
> > -#define VIRTIO_ID_9P			9 /* 9p virtio console */
> > +#define VIRTIO_ID_9P			9 /* virtio 9p */
> 
> While the old one was obviously wrong, I don't think the new
> wording makes much sense, since it merely repeats the name of
> the constant :)
> 
> How about "virtio 9p file sharing protocol" instead ? :)

Sounds better!

I also found another case, added to the follow-up.




