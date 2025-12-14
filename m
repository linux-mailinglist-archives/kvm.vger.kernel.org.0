Return-Path: <kvm+bounces-65936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A33EDCBB7D1
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 09:05:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9105A3004CCA
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 08:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4EF2C0290;
	Sun, 14 Dec 2025 08:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kty6VVwz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40FE2609CC;
	Sun, 14 Dec 2025 08:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765699517; cv=none; b=K3Ad1BPogopym3/to1czJhe8+AzlbH9x1f8oATk9aRsrcOR3jgGSkXkdroDT5H5+7fED2HTf5W5kj+YrEJhK5LfleyPe9+RTWecfmKozlq38/11WjADQrNIN7lX/Zc/kKb82W/+KuV1XQffHMaw+q9+uYsSjM7KgYPI494Jn+lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765699517; c=relaxed/simple;
	bh=ihizdAs5xDOev8/N37y8juDMqohuVvatea37UyTaRi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=coAzTKlhyGaf9iurBjOf2YcFG1tIDZRAxvVQ5y0PIJRXEcTsHfT/j1znpNZ1lqfMyKBiIS4pKWxCy72vQpMJXZnMiOtc9aGvvGMs7gdQroeMfbqduoGwl8igRJYSnLTRpix5Q2VKvstKFeKyDyem3s+I6aJfM6vI0czfsQ3QyaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kty6VVwz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66711C4CEF1;
	Sun, 14 Dec 2025 08:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765699517;
	bh=ihizdAs5xDOev8/N37y8juDMqohuVvatea37UyTaRi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kty6VVwzTJtdeGkn/OL/sk2f7Vfnpv82H2rJ71SoVx5wLW/jb8lxm2RuFqMqpcEHB
	 9/ooTAhhdffBRwzl0rkjmLIVGEm8RBGaGHTqlxjBo6IhmNSozd/xIqpYfSV3HiEEuF
	 r9Ae5LH2yKrVwPDJsSlCF5IKvD6QnlpE6J1sYr19zntuAY/UyUwqETaiphNCCl6Fg0
	 OIfJqqcMaGaTZTfwoSpZdnCgyFEicpt76KiSaP7TH5N3yFXQRgkZp5SQtveJKUU8O8
	 qy/urqiNHzU11rrcFzoWeK/Trun7TjKtaJPlRq9DNhHOtzui8DMkvIIYEGKRnYClqr
	 1Dx2GzcDYarcA==
Date: Sun, 14 Dec 2025 09:05:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-hwmon@vger.kernel.org, linux-block@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org, Jean Delvare <jdelvare@suse.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Denis Efremov <efremov@linux.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] x86: Cleanups around slow_down_io()
Message-ID: <aT5vtaefuHwLVsqy@gmail.com>
References: <20251126162018.5676-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126162018.5676-1-jgross@suse.com>


* Juergen Gross <jgross@suse.com> wrote:

> While looking at paravirt cleanups I stumbled over slow_down_io() and
> the related REALLY_SLOW_IO define.
>
> Especially REALLY_SLOW_IO is a mess, which is proven by 2 completely
> wrong use cases.
>
> Do several cleanups, resulting in a deletion of REALLY_SLOW_IO and the
> io_delay() paravirt function hook.
>
> Patches 2 and 3 are not changing any functionality, but maybe they
> should? As the potential bug has been present for more than a decade
> now, I went with just deleting the useless "#define REALLY_SLOW_IO".
> The alternative would be to do something similar as in patch 5.
>
> Juergen Gross (5):
>   x86/paravirt: Replace io_delay() hook with a bool
>   hwmon/lm78: Drop REALLY_SLOW_IO setting
>   hwmon/w83781d: Drop REALLY_SLOW_IO setting
>   block/floppy: Don't use REALLY_SLOW_IO for delays
>   x86/io: Remove REALLY_SLOW_IO handling
>
>  arch/x86/include/asm/floppy.h         | 27 ++++++++++++++++++++++-----
>  arch/x86/include/asm/io.h             | 12 +++++-------
>  arch/x86/include/asm/paravirt.h       | 11 +----------
>  arch/x86/include/asm/paravirt_types.h |  3 +--
>  arch/x86/kernel/cpu/vmware.c          |  2 +-
>  arch/x86/kernel/kvm.c                 |  8 +-------
>  arch/x86/kernel/paravirt.c            |  3 +--
>  arch/x86/xen/enlighten_pv.c           |  6 +-----
>  drivers/block/floppy.c                |  2 --
>  drivers/hwmon/lm78.c                  |  5 +++--
>  drivers/hwmon/w83781d.c               |  5 +++--
>  11 files changed, 39 insertions(+), 45 deletions(-)

I think we should get rid of *all* io_delay hacks, they might have been
relevant in the days of i386 systems, but we don't even support i386
CPUs anymore. Should it cause any regressions, it's easy to bisect to.
There's been enough changes around all these facilities that the
original timings are probably way off already, so we've just been
cargo-cult porting these to newer kernels essentially.

Thanks,

	Ingo

