Return-Path: <kvm+bounces-66069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D0ACECC35F4
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 14:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C22C7305F3B9
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 13:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB071348877;
	Tue, 16 Dec 2025 13:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/6CcZAu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD29F31E0EB;
	Tue, 16 Dec 2025 13:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765892940; cv=none; b=P+C4gJ4vJ4d7ELpgciDwvEc6RSNsedYv9eBI/8eRk92+N+3hM3Gd3i0WlpXFkIqC4CUZh8DwgW94kN+PvvMT5P+PcfQfH4yva14nQm2CJzsIfaF1BT9QfCoMJ7pIfhkj8ciVXLbQFmXn41jT3GllQon6wfUmglkwJwgpzqVvu6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765892940; c=relaxed/simple;
	bh=ENgGIlHWOI7j9oryiinlH9PuwlxwZFPAtyFI4Y4Ygjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/55y1bI7gp8oBPGGg9Hx/vBD4zJ9HijUtNQKawiAFjSan8o63XdoJIDzEso0eupr2nk7oDdbush8kAEvIdckcqomTpcBW3Qe3AhYMat2MvKBC7kHCVzGUqRnUjae9O21XGU7JnqaqdDfoQ1AClnzy4rCMGT4BcFicH2c4lYYSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/6CcZAu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A5DC4CEF1;
	Tue, 16 Dec 2025 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765892940;
	bh=ENgGIlHWOI7j9oryiinlH9PuwlxwZFPAtyFI4Y4Ygjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m/6CcZAuqci8q2SjaET3oYExJ5pIDzG6Bkyn9xx/jiXVDV8WBhO9pvXiR2VCyDMlJ
	 emucJpSeQwx5SJHGvWj3ddQOJu5Q4IUGGhmBK9Xrw1iQcs8BQyTsJzY68+xLDGPcWo
	 UTPttdG/15a2H1fpDb9ly8akJ+ncJkijB6d7fIUQVqxM+VX8iQsipyINC7FjrtdVkT
	 XoSSMnlcrtxgAcTz7t6uMJkcSKzInRgepKxiXP3eNJ01tvTMFIUz0rpXxYZA81e/BT
	 4cqROLpKbIdz4FufnE1FjO7Eylum1Ia/Gu4gURVn1g9V+Rm/7wjKcGGF2eD/Blqsph
	 Tz7xB1aE1TW3g==
Date: Tue, 16 Dec 2025 14:48:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
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
Message-ID: <aUFjRDqbfWMsXvvS@gmail.com>
References: <20251126162018.5676-1-jgross@suse.com>
 <aT5vtaefuHwLVsqy@gmail.com>
 <bff8626d-161e-4470-9cbd-7bbda6852ec3@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bff8626d-161e-4470-9cbd-7bbda6852ec3@suse.com>


* Jürgen Groß <jgross@suse.com> wrote:

> > CPUs anymore. Should it cause any regressions, it's easy to bisect to.
> > There's been enough changes around all these facilities that the
> > original timings are probably way off already, so we've just been
> > cargo-cult porting these to newer kernels essentially.
>
> Fine with me.
>
> Which path to removal of io_delay would you (and others) prefer?
>
> 1. Ripping it out immediately.

I'd just rip it out immediately, and see who complains. :-)

Whatever side effects it still may have, I very strongly doubt it has
anything to do with the original purpose of IO delays...

> In cases 2-4 I'd still like to have patch 1 of my series applied, as it will
> make paravirt rework easier.

Sure.

Thanks,

	Ingo


