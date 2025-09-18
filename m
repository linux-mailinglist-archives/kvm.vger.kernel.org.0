Return-Path: <kvm+bounces-58032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CF914B85ED4
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 306EF7AF20D
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED701313D54;
	Thu, 18 Sep 2025 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6tF/S+1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AF6242D63
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 16:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758212072; cv=none; b=Fyo3A2LN+D8zOqiaFaifi5yFjbgc7O9Q4YgVbb3pY3x6AAfHKJoVA9P14V63om1fw0ZSh1lKrgUETqcwaCVpiqIScFdlzdK50KD74C1gztC7zzdlqaDu7+o2P17dSXFtR+Q+7jR/oiBPI4UXo1cP/ca/JhtMYLk64sWgymjU+k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758212072; c=relaxed/simple;
	bh=bmboGWdmYKGEjDqvYv1DVm9bs5qgX4S3Ny/0S2so/l4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l/eUZG5VUUUA1V/TsPdSO9T9iKWaAjxihdo4P1a5fRdAjxID7IvpkIT29allo6tTf4MGClAyj4PZC0NahXVh3Nk4x/WQeo3V9OvZqate8K64gAljany6J9Q4Pp7YlfXj6TES9adQYXhIckajp9g8MbgO8L8E76b9b8mkViVhWcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6tF/S+1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758212069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4F3hybZYhx1Ydbv1SoblmjPS3ZmGcfGwW98Zsh1rblI=;
	b=f6tF/S+1ZTa9D2ppr+4JssBn1v/5wiclLz1kaX+we1pe28ckicr3+Sj0J0XTrDL5yjZhAS
	YuSWRwLk+rN7GKd9uaYuYPFfcgIHn7TAWFNbUBPr29YUMlQnqHX2rvlXpMOlwjT5+y6van
	P6oxA02FFvKa2ttlaaSNee98dnMq90k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-lxuHrRa1N6CZ7e0nqWCcbA-1; Thu, 18 Sep 2025 12:14:28 -0400
X-MC-Unique: lxuHrRa1N6CZ7e0nqWCcbA-1
X-Mimecast-MFC-AGG-ID: lxuHrRa1N6CZ7e0nqWCcbA_1758212067
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3eb2c65e0d6so861189f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 09:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758212067; x=1758816867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4F3hybZYhx1Ydbv1SoblmjPS3ZmGcfGwW98Zsh1rblI=;
        b=Z2i1UiB0Jlc+siQi4yA+R78kQAEytpYxbccrCzNa5S+xCZTd0onMy0/fnbVaOFQYN9
         IKvg8N7w4e46AwYwNO5vh00PzCGQZtygFjKqLofv1skDgfojUS8qVI7Qq7DUOweLGTLX
         f7Y/vs+5RDsb2s5L4nNPFrpyzommI/yX4mNx32odTqoooPe+YJG7Uk8MfN40joO0E77A
         cgfv+XFuDhvVE9TAs5tgIxnWxSQ4hVF2OVjCQDV+vUKK9MWKGVZXyjxcuJhtSLbug0+6
         3QddEQxb+04QMWTKZzDTP9GJIVMMPfN3ifzN/EfpYn6heDWT3Vcy8eKkY00nB7HoGZMb
         owfw==
X-Gm-Message-State: AOJu0YwtRHKfvl01YHzM1uudsLxkClWpFgP/mhCYhhqvETqEaUYd8AMA
	dWNLu/uEF+J8l3ozuqcD1uKatryfLgvah/pAW9+fktV0AqLPLtJ8hoXphavp/k/dqdjebLJ1Qgf
	h3Km3x3XLT1H35svVIE7X09ALiLlL3d1MKqxMPrbQaIFzMaSN3NqBHw==
X-Gm-Gg: ASbGncsByi7NY2c31xq7SiBiMocIaqlFmWx+gb0SerZmYE/dpA3uLKKaI4kySlzYBHn
	kPxjgL663iCNVCEM76dLTsVDyR4RHGj3BRoTpwwlE/x2X3gODIKF3YyJDDJSK/8j8YgkCGwC58o
	j5ny+z66cD+sBmdftgZRLpdWG0NG45M0EWATsMES9etXa+qmLinkwBN8gsDi1zNYPHs0o6YVSjn
	wHPsz+g7VjVzCq4FccslCEDhWSaDeKR081qNjXK/lBoIkpkwuWRsA7bNbNxtpscEQAmMpsZuACx
	sybhNjSQmM6FynbnZtlUUQwH6C4xiSOPLy0=
X-Received: by 2002:a05:6000:2283:b0:3eb:df84:62e with SMTP id ffacd0b85a97d-3ecdf9b4972mr6994283f8f.3.1758212066827;
        Thu, 18 Sep 2025 09:14:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWuV5SNvbO5Tb9W3Xvg5a4aZyLEyh56k2xiIjkOqz9AqDLzlVKqyG0LIYCFPiIYi4OwFCHPQ==
X-Received: by 2002:a05:6000:2283:b0:3eb:df84:62e with SMTP id ffacd0b85a97d-3ecdf9b4972mr6994243f8f.3.1758212066373;
        Thu, 18 Sep 2025 09:14:26 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm4388197f8f.37.2025.09.18.09.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 09:14:25 -0700 (PDT)
Date: Thu, 18 Sep 2025 12:14:23 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alok.a.tiwari@oracle.com, ashwini@wisig.com, filip.hejsek@gmail.com,
	hi@alyssa.is, maxbr@linux.ibm.com, zhangjiao2@cmss.chinamobile.com
Subject: Re: [GIT PULL v2] virtio,vhost: last minute fixes
Message-ID: <20250918121248-mutt-send-email-mst@kernel.org>
References: <20250918110946-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918110946-mutt-send-email-mst@kernel.org>

OK and now Filip asked me to drop this too.
I am really batting 100x.
Linus pls ignore all this.
Very sorry.

I judge rest of patches here aren't important enough for a pull,
I will want for more patches to land and get tested.
Thanks!

On Thu, Sep 18, 2025 at 11:09:49AM -0400, Michael S. Tsirkin wrote:
> changes from v1:
> drop Sean's patches as an issue was found there.
> 
> The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c:
> 
>   Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to 1cedefff4a75baba48b9e4cfba8a6832005f89fe:
> 
>   virtio_config: clarify output parameters (2025-09-18 11:05:32 -0400)
> 
> ----------------------------------------------------------------
> virtio,vhost: last minute fixes
> 
> More small fixes. Most notably this reverts a virtio console
> change since we made it without considering compatibility
> sufficiently.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ----------------------------------------------------------------
> Alok Tiwari (1):
>       vhost-scsi: fix argument order in tport allocation error message
> 
> Alyssa Ross (1):
>       virtio_config: clarify output parameters
> 
> Ashwini Sahu (1):
>       uapi: vduse: fix typo in comment
> 
> Michael S. Tsirkin (1):
>       Revert "virtio_console: fix order of fields cols and rows"
> 
> zhang jiao (1):
>       vhost: vringh: Modify the return value check
> 
>  drivers/char/virtio_console.c |  2 +-
>  drivers/vhost/scsi.c          |  2 +-
>  drivers/vhost/vringh.c        |  7 ++++---
>  include/linux/virtio_config.h | 11 ++++++-----
>  include/uapi/linux/vduse.h    |  2 +-
>  5 files changed, 13 insertions(+), 11 deletions(-)


