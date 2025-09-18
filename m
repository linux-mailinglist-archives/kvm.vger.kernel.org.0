Return-Path: <kvm+bounces-58031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F7EB85ED1
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FC393B1A66
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1862F314D31;
	Thu, 18 Sep 2025 16:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VgXD12Dp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37F330F80C
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758211960; cv=none; b=FTKVRdW1MWT1PgvyeI68NVT4A1FOTZPCXK0t0saxUjQLF+LY3IoqG2A4XztBmxxTvI+XrDumoGFHQXILp14szdFtNJn1XM62F+UK72s9KpyF9orGGJOFvqEVnwm5wydj60f4IT/bfvZ3Kx7tMTVsAkr5AemFJqugDGPsok2QO44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758211960; c=relaxed/simple;
	bh=3ChuK9dLT+j/JKhhXXw790DwdOdULGToKTA4biGxyaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHnX7qpMmRxzb5Ti6nBlhAIMXIG4u5tOFlU4VDhXFa6ECElYcSp4BGGK3KqXA3iMmaMLtLRI2QEU3YJ239h0AN/n0f4SE4oFcn/mtNzS7IhhqS6ZPppVd5OHXz2l8+2MggqcnOWd+Tsm++B8WT0/RldefwD3LzB1JUNgR8/ZKe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VgXD12Dp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758211956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GWkKglNyHyj28Yf+KWWRVKsP6YQNNJY7QhKMXW45eIw=;
	b=VgXD12DpGN+1XVTwwomy+lWTBgTg+uKNUOU0IptEAtjPoLX5f0Hct7d9Q3Ol2MZy4m3VzE
	jb6zGvd3KVZ3Nw/ea+Hxr4BEwBuUC8UuQKE+AUGTRuPC+c1Wah3eDMlZXDYgCShVk7TnwP
	dPrbEsftsVZMGm7YtGPlz/cRzMhc1qA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-AXyITbY3P7C0OUZ34aGLGw-1; Thu, 18 Sep 2025 12:12:34 -0400
X-MC-Unique: AXyITbY3P7C0OUZ34aGLGw-1
X-Mimecast-MFC-AGG-ID: AXyITbY3P7C0OUZ34aGLGw_1758211954
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso868380f8f.0
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 09:12:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758211953; x=1758816753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWkKglNyHyj28Yf+KWWRVKsP6YQNNJY7QhKMXW45eIw=;
        b=GGMp1GnHDFILC9ugC0awikrCV+kRwlL8HsKKngLwVEuQvZq6wNeWqKAtocmlTEIX7P
         SU3Ub1FWDwGHIo+RZiUD+HDCVFnW5Cgo0u1wby/R7cwwZlm0XeY8OgTVGKkePhTXJbE8
         dxBKtFAawlU4t+ZlT//Aw9sHzjnKbuIeqePbfECvaKSsS4YbS01ppefJGclNrkxIOZPv
         xEDwiVm0uSrI5LEOcz3lFnbF0EFp0XytI7zqs2uFmNsPa8YdVr7fwPPZ7BefPM0d8+9W
         oC3rqO1/oekNy19CQ/DIJvD9tvQ/nS6cZHQXNLD65v9zfgM3MGxt02AenuKgqKuHK/7f
         n7hw==
X-Forwarded-Encrypted: i=1; AJvYcCVlcETdYiN5E2xRAJ7eukuo73OKtk127zLbzRllAYYCyhRiGDoEdRrN1RzV6oQvKxtWfIw=@vger.kernel.org
X-Gm-Message-State: AOJu0YynYJ+gnxZg7a3kS/Pk1ap6xyj+2xJ1CymG9L44u8zV6PDCJJXr
	t2Ud04grl93rm6tJ8ceqt93VfN7CUymbiwxhUrkLnIFjgYQrG1HtlvDotKeE4NapZI/x3SirX/J
	XER+dwzCdq/nOasUookJRQEQoZQehAWd7OyYbJPsvE6wb5DBAfeD4Qb2TUW69Dg==
X-Gm-Gg: ASbGncsFtdg5Dm1xMwAdWj5Cs9c7QeXlmIHRSJoicUhdG+JUE5+TvESd6/+xhr2hAM9
	GSL7JS1hJuaYaIYB6BhhZWOKuL+xRTT5pBuKsSYWlAA2lZBsdfgtRXcfKYKcI+yaf9gDwkFQCCQ
	QtjFRvWPk6op8ICC3P7oix7t5b7pmhPoopV60KnVbFevE4xH72DY0PMetb/N6OHOvX8p9cVQI+T
	XhSP9Q+ZMlUw34Aft1h+EtlxZcl4jOmMuJWyfO46UoiMoX/6ihsi2zxIQdiT/21MCvWlul2Yc9e
	r92JzXKtAS1tE5MZhWyKXezZdl98l715KQw=
X-Received: by 2002:a05:6000:2411:b0:3eb:d906:e553 with SMTP id ffacd0b85a97d-3ecdfa59c2cmr6499604f8f.55.1758211953348;
        Thu, 18 Sep 2025 09:12:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQNjD7OmqbUX0lKdSCUxk8S1FFLIR2TIUSd05xm5nCE+NLCdpN93A3STkA7r0Jij+RWM8oVA==
X-Received: by 2002:a05:6000:2411:b0:3eb:d906:e553 with SMTP id ffacd0b85a97d-3ecdfa59c2cmr6499570f8f.55.1758211952931;
        Thu, 18 Sep 2025 09:12:32 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407d33sm4389523f8f.18.2025.09.18.09.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 09:12:32 -0700 (PDT)
Date: Thu, 18 Sep 2025 12:12:30 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Filip Hejsek <filip.hejsek@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, alok.a.tiwari@oracle.com,
	ashwini@wisig.com, hi@alyssa.is, maxbr@linux.ibm.com,
	zhangjiao2@cmss.chinamobile.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL v2] virtio,vhost: last minute fixes
Message-ID: <20250918121009-mutt-send-email-mst@kernel.org>
References: <20250918110946-mutt-send-email-mst@kernel.org>
 <869d0cd1576c2ea95a87d40e6ce49b97d62237c9.camel@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <869d0cd1576c2ea95a87d40e6ce49b97d62237c9.camel@gmail.com>

On Thu, Sep 18, 2025 at 05:45:05PM +0200, Filip Hejsek wrote:
> On Thu, 2025-09-18 at 11:09 -0400, Michael S. Tsirkin wrote:
> > Most notably this reverts a virtio console
> > change since we made it without considering compatibility
> > sufficiently.
> 
> It seems that we are not in agreement about whether it should be
> reverted or not. I think it should depend on whether the virtio spec
> maintainers are willing to change it to agree with the Linux
> implementation. I was under the impression that they aren't.

Ugh. OK I guess I'll drop this one too then.
That leaves nothing relevant for this pull request.


> I will quote some conversation from the patch thread.
> 
> Maximilian Immanuel Brandtner wrote:
> > On a related note, during the initial discussion of this changing the
> > virtio spec was proposed as well (as can be read from the commit mgs),
> > however at the time on the viritio mailing list people were resistent
> > to the idea of changing the virtio spec to conform to the kernel
> > implementation.
> > I don't really care if this discrepancy is fixed one way or the other,
> > but it should most definitely be fixed.
> 
> I wrote:
> > I'm of the same opinion, but if it is fixed on the kernel side, then
> > (assuming no device implementation with the wrong order exists) I think
> > maybe the fix should be backported to all widely used kernels. It seems
> > that the patch hasn't been backported to the longterm kernels [1],
> > which I think Debian kernels are based on.
> > 
> > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/drivers/char/virtio_console.c?h=v6.12.47
> 
> Maximilian Immanuel Brandtner wrote:
> > Then I guess the patch-set should be backported
> 
> After that, I sent a backport request to stable@. Maybe I should have
> waited some more time before doing that.
> 
> Anyway, I don't care which way this dilemma will be resolved, but the
> discussion is currently scattered among too many places and it's hard
> to determine what the consensus is.
> 
> Best regards,
> Filip Hejsek


