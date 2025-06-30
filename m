Return-Path: <kvm+bounces-51076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01735AED666
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 10:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CED053B989B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1911423AB88;
	Mon, 30 Jun 2025 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPiTTIES"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE7623C504
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 07:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270306; cv=none; b=fijuex+VSBOVf15uDo+doZHGTLH4lvNrJvfqiChf50D7lxS3zLQetnOHB9xxnaNpwbRsRMy8kH9u8u1hVa52xrh0ri7piwsifvzXzA148Q5h3CoY3Db9YawSzJI5Bdo8vOlwPMthwHcKfZx14cMOyzOnwIQyYIz6bDtwILKMTD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270306; c=relaxed/simple;
	bh=cIWLQj7tWvL2O1cLTwZUfAKHg4ehQSOPXhaj0k60wmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EsZ8KKOkp50GBudroflKGWvD9B9/cSrbLhXXHBHRS+yBc0Ra0eyFbQ5q6oxjYxF1tGzNh9B2ZGNKx4zEpo20cO33jq6jsCRo3rbHb5f6G2dIBw9KDKoa1K+VKq2oa1WXaVsP1tw/3RjGUIWBP1UQa+pOW0gnHACznkEt4AFae34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPiTTIES; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751270303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgEWcWVX6y9scJKOQscqFoJ6thnfYTOA+0wFODJOjNQ=;
	b=jPiTTIESYLxu3FKAACaS7ZAMLqYv/KXKWigL3O0LCdb5wnqjj90vvn7VW1hvyMtN/1FJp5
	R868VUGIUpFRp7PYk3b0sS35UiIaoKZRVg1uXEjzGgDM2JZWc+RiP6Nguv8ij2oGEFNOeE
	YMXwqtQlLLMrGT7NXrYgLlAKsgwDQYA=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-JxoVz_RGPpWBVBralIJA5A-1; Mon, 30 Jun 2025 03:58:21 -0400
X-MC-Unique: JxoVz_RGPpWBVBralIJA5A-1
X-Mimecast-MFC-AGG-ID: JxoVz_RGPpWBVBralIJA5A_1751270301
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-70f92ed6c95so63918627b3.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 00:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751270301; x=1751875101;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZgEWcWVX6y9scJKOQscqFoJ6thnfYTOA+0wFODJOjNQ=;
        b=fb0ejhsXvgUIoIboIyfNdyqb2GQ0kb1t/OX+bcJmBWs9D8PECHL2ZhEwflUc+JAIBs
         fAXhwOeYxOQpOiEpc9QzRHxNRlKih+nwrzqXgTE0AFpLxX0gI+5fKAm2wXkyFHDpLKio
         X0JpF89danKHqNIYNVQfotfbS9y9LSpFvqA6YPFeUI8OrhMKy/KGvUiwIlLngV+P6elW
         oOeoXG9CzYdNnVM6aV2A9Tsu959chBNUfMqsZxIrszKbG7Oj47dUgN0Vv8qd0Hxrc2Ri
         gQ/Fz9RptfrJv9k4kE/5kJMH5YLDxJsfdirwvvARuZiOScR28tmDOveaiIuWRpOSNEGI
         SNYQ==
X-Forwarded-Encrypted: i=1; AJvYcCV04ePvSe+cmsINIfKIeJh1uB9Fe/b2lc16sECu0KnoUX8POTp3j5VIdTXJK8CDZPxinnc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcFwNYwUCNAvYh22XnBitILoTGlFbOnw4bPRRQI9i7OXDwsUXP
	mbeMttRIaDcth75RRRfUdDi9Vft8dUAdJwkaPRjgXXbxOlvmiW+xJfjVbZ4vV2TY8U5dcVLnCsg
	2nbLQ/Pth8/aYwrQ1Ik+edX7mLPGbtY8OgeWuHWqtOu4aHhBsKiah6Bu1OqiHDzwf88j1EMvC3E
	/ppUnCYdzYwWDcmh2FXDBrcjrVpZn4
X-Gm-Gg: ASbGnctpOKc6xBRD8S3jfAejwUVeoQ6JcvtZPKndwbAYgX9PeWO/Xt3UqEhIc2xv1/b
	ezgCWaWPD/OR19TeK6xGD5ST6gyziDPltk36M1Fe3IOzI6VmUUHgDpkG0kDqGgCSOFUOE4NSn6N
	M7T5hk2w==
X-Received: by 2002:a05:690c:388:b0:712:d7dd:e25a with SMTP id 00721157ae682-7151756eb18mr172064567b3.6.1751270300714;
        Mon, 30 Jun 2025 00:58:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9hk4iM8gEid0K715PQkHr7wTuzImJqjNS2fyvGLxyh0PAObiNySZ92qlNHU9LEDZn5W6cNeMfqE7U/ldpN9U=
X-Received: by 2002:a05:690c:388:b0:712:d7dd:e25a with SMTP id
 00721157ae682-7151756eb18mr172064347b3.6.1751270300278; Mon, 30 Jun 2025
 00:58:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <gv5ovr6b4jsesqkrojp7xqd6ihgnxdycmohydbndligdjfrotz@bdauudix7zoq> <20250630075411.209928-1-niuxuewei.nxw@antgroup.com>
In-Reply-To: <20250630075411.209928-1-niuxuewei.nxw@antgroup.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Mon, 30 Jun 2025 09:58:07 +0200
X-Gm-Features: Ac12FXzM2abZAiLuWcV3HSuStmkPiQEYR_Hk5CCqlcO4nWGeNMcgQRF0jjd6Ui4
Message-ID: <CAGxU2F41qFrcTJdk3YeQMTwd0CP8nCqTCPpOn3ezQv=tPVx_WA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/3] vsock: Introduce SIOCINQ ioctl support
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: davem@davemloft.net, decui@microsoft.com, fupan.lfp@antgroup.com, 
	jasowang@redhat.com, kvm@vger.kernel.org, leonardi@redhat.com, 
	linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org, 
	niuxuewei.nxw@antgroup.com, pabeni@redhat.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 30 Jun 2025 at 09:54, Xuewei Niu <niuxuewei97@gmail.com> wrote:
>
> > On Mon, Jun 30, 2025 at 03:38:24PM +0800, Xuewei Niu wrote:
> > >Introduce SIOCINQ ioctl support for vsock, indicating the length of unread
> > >bytes.
> >
> > I think something went wrong with this version of the series, because I
> > don't see the patch introducing support for SIOCINQ ioctl in af_vsock.c,
> > or did I miss something?
>
> Oh yes. Since adding a patch for hyper-v, I forgot to update the `git
> format-patch` command...

I'd suggest using some tools like b4 or git-publish for the future:
- https://b4.docs.kernel.org/en/latest/contributor/overview.html
- https://github.com/stefanha/git-publish

>
> Please ignore this patchset and I'll resend a new one.

Please send a v5, so it's clear this version is outdated.

Thanks,
Stefano

>
> Thanks,
> Xuewei
>
> > >Similar with SIOCOUTQ ioctl, the information is transport-dependent.
> > >
> > >The first patch adds SIOCINQ ioctl support in AF_VSOCK.
> > >
> > >Thanks to @dexuan, the second patch is to fix the issue where hyper-v
> > >`hvs_stream_has_data()` doesn't return the readable bytes.
> > >
> > >The third patch wraps the ioctl into `ioctl_int()`, which implements a
> > >retry mechanism to prevent immediate failure.
> > >
> > >The last one adds two test cases to check the functionality. The changes
> > >have been tested, and the results are as expected.
> > >
> > >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> > >
> > >--
> > >
> > >v1->v2:
> > >https://lore.kernel.org/lkml/20250519070649.3063874-1-niuxuewei.nxw@antgroup.com/
> > >- Use net-next tree.
> > >- Reuse `rx_bytes` to count unread bytes.
> > >- Wrap ioctl syscall with an int pointer argument to implement a retry
> > >  mechanism.
> > >
> > >v2->v3:
> > >https://lore.kernel.org/netdev/20250613031152.1076725-1-niuxuewei.nxw@antgroup.com/
> > >- Update commit messages following the guidelines
> > >- Remove `unread_bytes` callback and reuse `vsock_stream_has_data()`
> > >- Move the tests to the end of array
> > >- Split the refactoring patch
> > >- Include <sys/ioctl.h> in the util.c
> > >
> > >v3->v4:
> > >https://lore.kernel.org/netdev/20250617045347.1233128-1-niuxuewei.nxw@antgroup.com/
> > >- Hyper-v `hvs_stream_has_data()` returns the readable bytes
> > >- Skip testing the null value for `actual` (int pointer)
> > >- Rename `ioctl_int()` to `vsock_ioctl_int()`
> > >- Fix a typo and a format issue in comments
> > >- Remove the `RECEIVED` barrier.
> > >- The return type of `vsock_ioctl_int()` has been changed to bool
> > >
> > >Xuewei Niu (3):
> > >  hv_sock: Return the readable bytes in hvs_stream_has_data()
> > >  test/vsock: Add retry mechanism to ioctl wrapper
> > >  test/vsock: Add ioctl SIOCINQ tests
> > >
> > > net/vmw_vsock/hyperv_transport.c | 16 +++++--
> > > tools/testing/vsock/util.c       | 32 +++++++++----
> > > tools/testing/vsock/util.h       |  1 +
> > > tools/testing/vsock/vsock_test.c | 80 ++++++++++++++++++++++++++++++++
> > > 4 files changed, 117 insertions(+), 12 deletions(-)
> > >
> > >--
> > >2.34.1
> > >
>


