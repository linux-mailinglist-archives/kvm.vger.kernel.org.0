Return-Path: <kvm+bounces-12173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E784880454
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 19:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29597284884
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 18:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5654A3838F;
	Tue, 19 Mar 2024 18:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BRoPc4tz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC3B3612D
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871445; cv=none; b=gc8vOp+OkfOMkmnmwvMT8et8pkcWiBlDY3JB/YUn/5ISDOPkHYP4+AvXSX4LYeiT4bm+zksuLL/llWB31u7r5zsyy67urFzlwvapQ5EOjMzOQdbt6wIHufd77bMkS1y7GZEglo3qGDvklAmDXSbx4U5fyV/3nS73vDfs9CZ8Sbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871445; c=relaxed/simple;
	bh=DFh9J+u2qXCj6UQ58/J1xPY8J+BLfhUgqiTlzbpfEoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qF9KSATLYAtavQKcp+iemzhjShQRReuFC4TrrdDp7icJbEWJoW4nv8RP82DprEve8ZMFF51qEUHHVWu5dh3jFyZ3Fcq6+kucUUqAJky7nFIVGMH+NO0qOQIKIUVVwGYK/Gs3mTiYWN9UdOPRBxSSRNH9wvE7sYnJuLjZ9bAUojg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BRoPc4tz; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-513e14b2bd9so4185820e87.2
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 11:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710871441; x=1711476241; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EQCbsWamaqb8otc0jtHP79rNp7jzLPKKgSbrJldR67k=;
        b=BRoPc4tzcobW0IAJv7EXwvPJRWh3HeqcoOvaC88CmvvOzstUxQM9Rf16+pPbeVuW1V
         PwlqK4ByRcyByL6BEwQpaWaLKMwrvOM1Ax0ui3MjHXQ2wMydaxEhlteVCKP8YSsPEopq
         tgzrMfL2u4oRyDDvscMwSNJEwh4weK8GrLGyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871441; x=1711476241;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EQCbsWamaqb8otc0jtHP79rNp7jzLPKKgSbrJldR67k=;
        b=rVDIbCp42CeWHU6s5dlmjK9t0s6qGQTh+OVx2WNhjssRlHn5MgOp9yWn2gB7Vz1Le5
         OYjd8U2qhEzQg600AC+06w7lZmI9tqJcDBeqhmANFX8/FOVXcgaku7MCM0zckjYda7lW
         XIPnR3qs4cL5hqlP/2doMzQxrUy8SuSyhsPsDXlouoBiXYd1z9pT5k+NBKKXllwVRi6Y
         3QS27raB5YYjmyGhKuyZ83KoPisfwp72eUDEc0nUorjb7zu+2mJAGq4RhWhTBekNpr4D
         JhEPQVA46bR6dTBQQk3gwVhG8jiBNil5y9AqaBWdHmrxAs8BFyI44iLChm4RKbGQK0bZ
         gb9g==
X-Gm-Message-State: AOJu0Yx1MpYUEM0WVF/Qm85s63R0QYuCVv9/KlMYKMw9raSvfRCm8jBH
	cnnpQFPtOgZMTETcpCsCuMmZjP/iM2s/KJa0O3X2X4wSqSWr5AvcXeLmNoY5cDhqOhpBsUHXBp9
	//JB9Vw==
X-Google-Smtp-Source: AGHT+IG/WlPcCoquedmFnABC5aCOvq8uuwz0vW4BQKQk1PkCgQBjIo6YdREuHiz6l8v1fT59Xe4IzQ==
X-Received: by 2002:ac2:5042:0:b0:513:22f0:c3af with SMTP id a2-20020ac25042000000b0051322f0c3afmr12348841lfm.4.1710871441413;
        Tue, 19 Mar 2024 11:04:01 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id bx21-20020a170906a1d500b00a4655976025sm6279165ejb.82.2024.03.19.11.04.01
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 11:04:01 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a468226e135so530519566b.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 11:04:01 -0700 (PDT)
X-Received: by 2002:a17:906:1352:b0:a46:7ee2:f834 with SMTP id
 x18-20020a170906135200b00a467ee2f834mr9239613ejb.11.1710871440743; Tue, 19
 Mar 2024 11:04:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319034143-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240319034143-mutt-send-email-mst@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Mar 2024 11:03:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi363CLXBm=jB=eAtJQ18E-h4Vwrgmd6_7Q=DN+9u8z6w@mail.gmail.com>
Message-ID: <CAHk-=wi363CLXBm=jB=eAtJQ18E-h4Vwrgmd6_7Q=DN+9u8z6w@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: features, fixes
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alex.williamson@redhat.com, andrew@daynix.com, david@redhat.com, 
	dtatulea@nvidia.com, eperezma@redhat.com, feliu@nvidia.com, 
	gregkh@linuxfoundation.org, jasowang@redhat.com, jean-philippe@linaro.org, 
	jonah.palmer@oracle.com, leiyang@redhat.com, lingshan.zhu@intel.com, 
	maxime.coquelin@redhat.com, ricardo@marliere.net, shannon.nelson@amd.com, 
	stable@kernel.org, steven.sistare@oracle.com, suzuki.poulose@arm.com, 
	xuanzhuo@linux.alibaba.com, yishaih@nvidia.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 19 Mar 2024 at 00:41, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> virtio: features, fixes
>
> Per vq sizes in vdpa.
> Info query for block devices support in vdpa.
> DMA sync callbacks in vduse.
>
> Fixes, cleanups.

Grr. I thought the merge message was a bit too terse, but I let it slide.

But only after pushing it out do I notice that not only was the pull
request message overly terse, you had also rebased this all just
moments before sending the pull request and didn't even give a hit of
a reason for that.

So I missed that, and the merge is out now, but this was NOT OK.

Yes, rebasing happens. But last-minute rebasing needs to be explained,
not some kind of nasty surprise after-the-fact.

And that pull request explanation was really borderline even *without*
that issue.

                Linus

