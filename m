Return-Path: <kvm+bounces-34177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B920A9F82EF
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 19:09:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BEC81884AE1
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 18:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FCB19E99E;
	Thu, 19 Dec 2024 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDv+JH7y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839C4199951;
	Thu, 19 Dec 2024 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734631736; cv=none; b=i8ZKyEkbZpYM/BQhmfFdBjauo5ysLgSp0xR8lFHsMsP8QF4L2GS98cyOYcpTS15MSJf5q+Se+L1uAw7Z8T6booqvajXiDnQ5fIl6PtQKsgpyc+6iD46xjcLdk4SbvdbL3qOhgjl+ze3CMbf8dYkPmiEWKBZYi5WkuHoMzViTyPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734631736; c=relaxed/simple;
	bh=cof4R3A2FL3C73jpAbnLoVqR3VbRLbPJnxzu25PX3NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLf2IBpG3k9W5ELsLqa4EYnPSQ7g/M5ytrxGj+oRfgmXnJc4gfiD0K8FMU6K/+53js5BJphrGt+d1d1dF+cO6QAagb0qC9F4qCMtiL8bucynLd8RrU1Yc//y0ARlK1hBHizx2ER0T9Z2ZOEYWDjPLVudr7enpX9zgF+OBI099pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDv+JH7y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE1CC4CECE;
	Thu, 19 Dec 2024 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734631736;
	bh=cof4R3A2FL3C73jpAbnLoVqR3VbRLbPJnxzu25PX3NI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KDv+JH7yHmdhFb3Em4IJjjKb4Ns6g4uRmyZUF/fBnwa1OuVoea4+TKVgbp0GFnOhY
	 roJ+dIGl4gZ9l0bRjvXRFBAR8aoLoDTD8ek31YkpyJRQYqq7o0bEAp9rmneEVuMtZE
	 J9Jzmx8jJ9cY+AZuvmzjrEf+//cGzsXvLwXrpQLhudk6VgAxvxKHpbPHDPVuiW3LCK
	 AshI2BElojDzxhq40wxE141E2Gj8h3qsyvaDd/LB5x3paLILWTjITpYuycsomvi1xI
	 7p2kgnHMVmb7dNnQIp9ElsmefLr11vshhbTE5SFom9U8lkjGAB5WPbUzZ3U61RLBNb
	 8s65v8n6dX7vw==
Date: Thu, 19 Dec 2024 11:08:53 -0700
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>,
	Luca Boccassi <bluca@debian.org>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
References: <20241108130737.126567-1-pbonzini@redhat.com>
 <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>

On Thu, Dec 19, 2024 at 06:42:09PM +0100, Paolo Bonzini wrote:
> On 12/19/24 18:32, Keith Busch wrote:
> > This appears to be causing a user space regression. The library
> > "minijail" is used by virtual machine manager "crossvm". crossvm uses
> > minijail to fork processes, but the library requires the process be
> > single threaded. Prior to this patch, the process was single threaded,
> > but this change creates a relationship from the kvm thread to the user
> > process that fails minijail's test.
> 
> Thanks for the report.
> 
> The minijail code has a flag that's documented like this:
> 
>     /// Disables the check that prevents forking in a multithreaded environment.
>     /// This is only safe if the child process calls exec immediately after
>     /// forking. The state of locks, and whether or not they will unlock
>     /// is undefined. Additionally, objects allocated on other threads that
>     /// expect to be dropped when those threads cease execution will not be
>     /// dropped.
>     /// Thus, nothing should be called that relies on shared synchronization
>     /// primitives referenced outside of the current thread. The safest
>     /// way to use this is to immediately exec in the child.
> 
> Is crosvm trying to do anything but exec?  If not, it should probably use the
> flag.

Good point, and I'm not sure right now. I don't think I know any crosvm
developer experts but I'm working on that to get a better explanation of
what's happening,

