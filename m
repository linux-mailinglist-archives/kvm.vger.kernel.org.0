Return-Path: <kvm+bounces-34187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2204B9F8889
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 00:31:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D51731638D2
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 23:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B35711DD529;
	Thu, 19 Dec 2024 23:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKBm8tn0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F6E14E2CF;
	Thu, 19 Dec 2024 23:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734651103; cv=none; b=LGcDUJD2gxBjnPRXihhwfETGrgohutCpH1FvJYqh7nQLHMYruIuZoDPgV8K4uZvHd1Aen+HhbI/xK7UvW43eW4Ft9AO6a3HDFAuSwQP6ekHh50XLxiX4Sm36cmn+N4eD0bDg9vQE3XLMPRju/t8SfpPNTA0tetjPO9DT+nRDwig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734651103; c=relaxed/simple;
	bh=AU2CVWuRs++1FqmY9wCE27mMOhiyZPeKHk1XZrig3UM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hFQEM6MiaQu0NkzvnIeBU+OCuSjcktwAvoghVlzSN7aNz5E0/WcGoCiJp9q18bZBCnmU3Z5NL6yfngGb6DLicMvBJph7V5ZdhcxeK+P1EesdyF0Ek27wRSU0o+6nyAq+BUUOkhVS5jHHVCEBQWTPgFGblTg3EFN4G3zMUHROO9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKBm8tn0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC8CC4CECE;
	Thu, 19 Dec 2024 23:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734651103;
	bh=AU2CVWuRs++1FqmY9wCE27mMOhiyZPeKHk1XZrig3UM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mKBm8tn0LtIFRN5SqSSTcRIWI+9CXNHNLISghGJRD/u0OcF3g49Y6g4NXFS9+9pxn
	 6dQFiR+WxwG9fxICpMMX+eepFqeIqU6oCNkqKTTQasKuVu8jh43/ysuNRdPP5IhKFy
	 NS6Z3B5QlovxgcymwUqPWZe+NRDxG7fYlaf3/7r66rPfPL1Yk6C/MoGYqS1I2IZNjQ
	 kBAH2Pczo0n6Xqifey1XQQKZa50Y5d27HnOXRYjy7AfHYhUI7LPrIa/QvF/EPTnsTB
	 eZ0rPN8bZQ4sG+rpx3JhdFWP6S5eiif3jIFfXASFr6/H1OWC5OhSc4tNfcCoLpFNGh
	 eTh76rgMQlffg==
Date: Thu, 19 Dec 2024 16:31:40 -0700
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>,
	Luca Boccassi <bluca@debian.org>, Jens Axboe <axboe@fb.com>,
	axboe@kernel.dk
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <Z2Ss3ALr5QgHo4UP@kbusch-mbp.dhcp.thefacebook.com>
References: <20241108130737.126567-1-pbonzini@redhat.com>
 <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z2Scxe34IR5jRfdd@kbusch-mbp.dhcp.thefacebook.com>
 <6b0c90e6-6b38-4ff3-8778-1857cd66c206@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b0c90e6-6b38-4ff3-8778-1857cd66c206@redhat.com>

On Thu, Dec 19, 2024 at 11:57:40PM +0100, Paolo Bonzini wrote:
> It could be as simple as this on the kernel side: [adding Jens for
> a first look]

Cc'ing his @kernel email; first message:

	https://lore.kernel.org/linux-kernel/20241108130737.126567-1-pbonzini@redhat.com/
 
> =============== 8< ===========
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: [PATCH] fs: proc: mark user and I/O workers as "kernel threads"
> 
> A Rust library called "minijail" is looking at procfs to check if
> the current task has multiple threads, and to prevent fork() if it
> does.  This is because fork() is in general ill-advised in
> multi-threaded programs, for example if another thread might have
> taken locks.
> 
> However, this attempt falls afoul of kernel threads that are children
> of the user process that they serve.  These are not a problem when
> forking, but they are still present in procfs.  The library should
> discard them, but there is currently no way for userspace to detect
> PF_USER_WORKER or PF_IO_WORKER threads.
> 
> The closest is the "Kthread" key in /proc/PID/task/TID/status.  Extend
> it instead of introducing another keyl tasks that are marked with
> PF_USER_WORKER or PF_IO_WORKER are not kthreads, but they are close
> enough for basically all intents and purposes.

Yes, this looks good to me. But I also would have thought the original
patch was safe too :). Hopefully nothing depends on the current value
for these... there is often something making it difficult to have nice
things.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 34a47fb0c57f..f702fb50c8ef 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -221,7 +221,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  #endif
>  	seq_putc(m, '\n');
> -	seq_printf(m, "Kthread:\t%c\n", p->flags & PF_KTHREAD ? '1' : '0');
> +	seq_printf(m, "Kthread:\t%c\n", p->flags & (PF_KTHREAD | PF_USER_WORKER | PF_IO_WORKER) ? '1' : '0');
>  }
>  void render_sigset_t(struct seq_file *m, const char *header,UBLK_U_IO_REGISTER_ZC_RING

