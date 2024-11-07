Return-Path: <kvm+bounces-31144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E09D9C0E1D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4562BB23282
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 18:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92AC621745B;
	Thu,  7 Nov 2024 18:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTwoAU7h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A936316419;
	Thu,  7 Nov 2024 18:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731005688; cv=none; b=IQWP1wcU26cFICS9SwQwuqyqzdjvdMa8ChS/KCvq19Pv1MNOw+0IUg4SY0xdBLzLc/HOCgAAt52iQ1g57Dyv+9cPf8qUGGpAE27ILr1TwvLjC1pDpNSAo8gBAXHZtRRn4XfcofrpZ8+aPS4S7HCfPjM2+FVGaDMtMJD4bISqEYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731005688; c=relaxed/simple;
	bh=MhCtJqMxCesP9UetCsJ3TB7513bZMiDxVKi77MUHvmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C1UStdIOw15SZwWN186PSEiDewMBujdDwXEzR4F6mYf0xg46UEB0OzcjH9be6IjejucMZc5eXrwYexIPpqO9VgqbwgEn6Wx24v1ugL3qz0CZWjga7kjafb1ZVth22QBiCc6CzjI/cBnFEa5VsZCVi7fG4itdFasAY6vIXPEymAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTwoAU7h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24081C4CECC;
	Thu,  7 Nov 2024 18:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731005688;
	bh=MhCtJqMxCesP9UetCsJ3TB7513bZMiDxVKi77MUHvmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KTwoAU7hfKTnCJkvgb//e6A5EICdebjw0RCS1bna2xXVZUfDSvLgLDw7fOaZG5r6z
	 mbi+Tt22FcAxPtRsJXdbxhCip1EJsA6zfPPmiQTW5DtqCteTrVrGbW+zesHMDB8uVq
	 ujiB4MUFD6PV99zsP1qwg/WeS2rwsgR5in4w6iAOVkuYVi4SnT1pIoXghVlCATKwqF
	 Yof03QLPdwGLBQDhJ2PmKZ87VgLJ4rjkeySioNdOwrodHMmUtp5dfeo+D/s8dOLtUL
	 7rKAQn4ThNQCU/3EkDrydMwhZbw3D947As6U2Pf7/gto3RYnZOmfT6zJCmOYYp/uvH
	 3QZ4HanGX8ReQ==
Date: Thu, 7 Nov 2024 08:54:47 -1000
From: Tejun Heo <tj@kernel.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Luca Boccassi <bluca@debian.org>,
	Roman Gushchin <roman.gushchin@linux.dev>, kvm@vger.kernel.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: cgroup2 freezer and kvm_vm_worker_thread()
Message-ID: <Zy0M9yv7xIiKB_Xi@slm.duckdns.org>
References: <ZyAnSAw34jwWicJl@slm.duckdns.org>
 <nlcen6mwyduof423wzfyf3gmvt77uqywzikby2gionpu4mz6za@635i633henks>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <nlcen6mwyduof423wzfyf3gmvt77uqywzikby2gionpu4mz6za@635i633henks>

Hello,

On Thu, Nov 07, 2024 at 07:05:46PM +0100, Michal Koutný wrote:
...
> I'd first ask why the kvm_vm_worker_thread needs to be in the KVM task's
> cgroup (and copy its priority at creation time but no later adjustments)?
> 
> If it can remain inside root cgroup (like any other good kthread) its
> job may be even chunked into periodic/deferred workqueue pieces with no
> kthread per KVM at all.

That'd be better but I suppose kvm wants them in the same cgroup for a
reason.

> If there are resource control/charging concerns, I was thinking about
> the approach of cloning from the KVM task and never returning to
> userspace, which I see you already discussed with PF_USER_WORKER (based
> on #1). All context would be regularly inherited and no migration would
> be needed.
> 
> (I remember issues with the kvm_vm_worker_thread surviving lifespan of
> KVM task and preventing removal of the cgroup. Not sure if that was only
> a race or there's real need for doing some cleanups on an exited task.)
> 
> As for #2, I'm not sure there's a good criterion for what to ignore.
> Here it could possibly be PF_KTHREAD or PF_NOFREEZE (I get the latter
> has purpose for system-wide (or v1) freezer). Generally, we can't tell
> what's the effect of thread's liveliness so it seems better to
> conservatively treat the cgroup as unfrozen.

It'd have to be a separate flag which explicitly says that the task is
exempt from cgroup2 freezer, so yeah, it'd be best if we can avoid this
option.

Thanks.

-- 
tejun

