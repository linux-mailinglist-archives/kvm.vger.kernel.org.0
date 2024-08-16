Return-Path: <kvm+bounces-24454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E24A955336
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:16:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33FBD1F22545
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 22:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40D4145341;
	Fri, 16 Aug 2024 22:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mQ0ktfPa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1EEBA33;
	Fri, 16 Aug 2024 22:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723846573; cv=none; b=FR7Ul1wHQnr50arOkXjji0D2P/EpaMvuh6M+zxxPsWO6nZWMx5NsTgOW2Q1uif8fNREwKP1w5voyfT3LmmGdSvyHrirXuL2/yoHxdk0rsU9tup4LSUDneoPZiT5MbEbehaTqBsP295WnJcXoO6ENbBdn8vGWzbXnL6te0NKCdLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723846573; c=relaxed/simple;
	bh=M+NRfJND15DgXXHSYtlJHCFyMUTY/cbt4gOqY0fSQKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMCcQ8NnVH3TCsYEPXOxu0Uajxz3BeHT45RqU5hmVua6/HGMfclm6QYajA6oKNqY76+AZkmZg87iqNrABbwf+DWRF42XbBdVOrgKe7zMvZv8qjGzfTfXsdjfHyYJ0amQAiC9PaKMIDoYwm4yFc6vNnHVvzFG6JnLfq3Qsdbuhbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=mQ0ktfPa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF1FC32782;
	Fri, 16 Aug 2024 22:16:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mQ0ktfPa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1723846569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S0q5my1Gxzq5sbks3fTcsMFKFgho8smshyrb0IyHeLE=;
	b=mQ0ktfPaKJsESX8PGs+iJxyLhHMGhfX7ELVZWdMlnGzpmLCL5qUJa0seVqE5J/uuPZV7IL
	2Kb+ri7T0cvXYDAm6nzX/fHuKW++B9UzLHgg5VE3YFOetb4/pXxYKgCu8OaOtV9HBcbV1e
	bL+me1+63vABwBzimD/a1Rz4d3ze6Yc=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1169246f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 16 Aug 2024 22:16:08 +0000 (UTC)
Date: Fri, 16 Aug 2024 22:16:03 +0000
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Sean Christopherson <seanjc@google.com>
Cc: syzbot <syzbot+0dc211bc2adb944e1fd6@syzkaller.appspotmail.com>,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com,
	syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Subject: Re: [syzbot] [kvm?] general protection fault in get_work_pool (2)
Message-ID: <Zr_Po5Rj7wsDj_BX@zx2c4.com>
References: <0000000000006eb03a061b20c079@google.com>
 <Zr-ZY8HSGfVuoQpl@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zr-ZY8HSGfVuoQpl@google.com>

On Fri, Aug 16, 2024 at 11:24:35AM -0700, Sean Christopherson wrote:
> On Mon, Jun 17, 2024, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16f23146980000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=81c0d76ceef02b39
> > dashboard link: https://syzkaller.appspot.com/bug?extid=0dc211bc2adb944e1fd6
> > compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> > userspace arch: i386
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2ccbdf43.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/13cdb5bfbafa/vmlinux-2ccbdf43.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/7a14f5d07f81/bzImage-2ccbdf43.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+0dc211bc2adb944e1fd6@syzkaller.appspotmail.com
> 
> See https://lore.kernel.org/all/Zr-Ydj8FBpiqmY_c@google.com for an explanation.
> 
> #syz invalid

Oh. Thanks very much for following up on this. I spent some time puzzling
over it and didn't find a wireguard bug. Glad that turned out to be so.

Jason

