Return-Path: <kvm+bounces-17804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD838CA4DA
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:03:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDC232820EB
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC03137C49;
	Mon, 20 May 2024 23:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LEq7Whtv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1024501B
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 23:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716246197; cv=none; b=bSL3Eobi9g3zXUAhAzFm6WkmKzt/gBqst5Reybp10kw+mtBJsaXZezQHrSgExbQTNKHYNlgzo4ilsdltYO6jdyEodSMoAUmMweXWwyzsv76gYIbfNRdlw2r3OFLLbbijrnQo3ZKxi/fSXXIA0lScJRgobbPKrN9OKko9RLmIYV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716246197; c=relaxed/simple;
	bh=mugvv6GTjodKhKIZg1AglPimA8bMFie87VLuCIwMXKA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D3YTMuj1tFp+jEGcmGauftOfjF2IsbAmDPDREtiG+m6mcWRc/pZxj5DvypMsqQTbbZ800b/qYNxBaNieh3KjY+FwWhxZ36fgT/ZMAVb9pdylBZ0xR//PnTURwkFxtspq8I/rZrUUAzRNggL6zM6AmWKd/0egVY3PjKc8bFR3X8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LEq7Whtv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716246194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mcKWgmoG9CCcTrBbQPy1kCJWXglcuwtpryOOdLXdj5Q=;
	b=LEq7WhtvyBWlWtIliesZfiz178VY+vWZXDrXTN7CjmYEqyoblonTaImNSe2s5rt+va61x7
	qXHzYvjIB5Q+EjcC4LyZcFyInddsf4p6LGcan1E/5y69VMzlG0kIoZe2FpRtqouxs3Y2cw
	yOGl19n4yKSZqQoj1QqcH2aNAciZQOc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-rPqmX-jBMEar1ncbb41wxQ-1; Mon, 20 May 2024 19:03:13 -0400
X-MC-Unique: rPqmX-jBMEar1ncbb41wxQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7e1d6c70aeaso1056491239f.3
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 16:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716246192; x=1716850992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mcKWgmoG9CCcTrBbQPy1kCJWXglcuwtpryOOdLXdj5Q=;
        b=NAZa1n5E6ZT/1BaDIChDe6Qfo8u9sHVOtTcXPj65ATHGkjG25hmCnrzf2QV49X58kC
         i+3OoQqo7u0dKBXxNZM1DD9k0Av7AT1VDo7j59b4Po8daTtVErCE21VRhvOOBo+Jwtwi
         /fTaOI6kkJdJ2Uby16tIKiGRf9PU5+3Pp44H29dP0ullQgeReOQz3a2KftQl8BZdfH03
         F+uFEJ9uN4Hv6lrMvmKInvauEW6wOCXXUJei0LVMk+aaK7Gosvvacp7fN3hl6dIXrMiu
         zVoVUTS61coXJ3R+esdzpSprGMKx3oAgM5zXAi3QTWv33BmOUUxrdix7omg3rrD1Ktpr
         //Fw==
X-Gm-Message-State: AOJu0YwcT2Cz3i6Ar07NJRvCUis931+jbS4CqDpnoumvSYLXctbpND/T
	Hzg1e+EXdjdtnaP0bRxDBDAmt6lTzrH1oDIzhQhTOaEnsqCyZzZ9sH1uQWk4g+nI13LGS7M8Mav
	mMJ5RkqdczJCpvje8o/p574/nTr1JAaU/HBk/AXCFXfVHqK+Taw==
X-Received: by 2002:a6b:904:0:b0:7de:9519:8b43 with SMTP id ca18e2360f4ac-7e1b51a206cmr3407010939f.1.1716246192229;
        Mon, 20 May 2024 16:03:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGocXMF+FgVHb/xFLIP90ALn89HrQL5pIshnNgMRZC94oxAXWYPxaMFx907CCVGsNW1Ox+aUg==
X-Received: by 2002:a6b:904:0:b0:7de:9519:8b43 with SMTP id ca18e2360f4ac-7e1b51a206cmr3407009439f.1.1716246191902;
        Mon, 20 May 2024 16:03:11 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-489376fb1fcsm6672822173.165.2024.05.20.16.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 16:03:11 -0700 (PDT)
Date: Mon, 20 May 2024 17:03:09 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] VFIO updates for v6.10-rc1
Message-ID: <20240520170309.76b60123.alex.williamson@redhat.com>
In-Reply-To: <CAHk-=wiecagwwqGQerx35p+1e2jwjjEbXCphKjPO6Q97DrtYPQ@mail.gmail.com>
References: <20240520121223.5be06e39.alex.williamson@redhat.com>
	<CAHk-=wiecagwwqGQerx35p+1e2jwjjEbXCphKjPO6Q97DrtYPQ@mail.gmail.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 May 2024 15:05:26 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 20 May 2024 at 11:12, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > I've provided the simplified diffstat from a temporary merge branch to
> > avoid the noise of merging QAT dependencies from a branch provided by
> > Herbert.  
> 
> The diffstat looks good, but the merge itself sucks.
> 
> This is the totality of the "explanation" in the merge commit: "".
> 
> Yup. That's it. Nothing. Nada.
> 
> If you cannot explain *why* you merged a branch from some other tree,
> youi damn well shouldn't have done the merge in the first place.
> 
> Merge commits need explanations just like regular commits do. In fact,
> because there isn't some obvious diff attached to them, explanations
> are arguably even more needed.
> 
> I've pulled this, but dammit, why does this keep happening?

Sorry.  In my case I've looked through logs and I've seen bare merges in
the past and I guess I assumed the reasoning here would be more obvious.
Clearly that's wrong.  I'll do better.  Thanks,

Alex


