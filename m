Return-Path: <kvm+bounces-34170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F20C09F81FB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 18:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D1A0162998
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 17:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F98198A31;
	Thu, 19 Dec 2024 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GCJry71W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696FD18A6B2;
	Thu, 19 Dec 2024 17:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629580; cv=none; b=NBcQsurGWglxxRFK/ldrdhIAf9HUHtxgH64xrJaek1+if4N9bgLCrjZi8Bw/46/s4anp3f1i9Mo7u6iGdR9RVpyL+eugeZNhezp4l6kwCUcBhIZvseLvrQ/S+OVKABQmMLIWafK9B+zSzsQmV+ceY2LBdJwrEzonVI/piC2o1Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629580; c=relaxed/simple;
	bh=sCYtPikF4BO4xbppbOyS/lXXODlXmI78hNRPUzYeoic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewYEH3OHsNaQetSqHbh2VQrECuf4yqcNA2sfAfmiKC33vXph394H9WafOB3UrMWeM6YBUKFYphCqteEIxMJkaAGw8WvtLL/Ycp1NzsbfP1arUD8GmvUGxce0T9X9qYE8WiCQn+wKWIWh5MuedRZ8Vd/VbSAbIT2UTAQ9F0U/KJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GCJry71W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7BBC4CECE;
	Thu, 19 Dec 2024 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629580;
	bh=sCYtPikF4BO4xbppbOyS/lXXODlXmI78hNRPUzYeoic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GCJry71WMa1vuNY7yKqDwdzlHLQIGjN26WTsvllh2DRE/7n6fBtvaJpStobEh7a9X
	 ao+PZqXv1e2SRm8Y6ig+F5yO1iGhN2jfLu/mO40EbRDI+brWAzH5akEzJpGDIAUTTC
	 niB3fIbbvFRKHdKmO8+fW+/xM5UsYL9J95g33RY/heTSMrQGbjYc/ewMbA+9yXcTTB
	 o2pIOdgX8S34W37O2V0hEuvEp8ricxh2vYhRN8I6/5AU9LpxAtB5CMxNawfmhILcdc
	 IuN7UkV5HKMAw1Mf3UTz5AHqviBVoUGS6G9tb3b/mfFWPjqW7ulJ4is3KDJkvC+3jX
	 9DOBX5H/Q1giA==
Date: Thu, 19 Dec 2024 10:32:57 -0700
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>,
	Luca Boccassi <bluca@debian.org>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
References: <20241108130737.126567-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108130737.126567-1-pbonzini@redhat.com>

On Fri, Nov 08, 2024 at 08:07:37AM -0500, Paolo Bonzini wrote:
> Since the worker kthread is tied to a user process, it's better if
> it behaves similarly to user tasks as much as possible, including
> being able to send SIGSTOP and SIGCONT.  In fact, vhost_task is all
> that kvm_vm_create_worker_thread() wanted to be and more: not only it
> inherits the userspace process's cgroups, it has other niceties like
> being parented properly in the process tree.  Use it instead of the
> homegrown alternative.

This appears to be causing a user space regression. The library
"minijail" is used by virtual machine manager "crossvm". crossvm uses
minijail to fork processes, but the library requires the process be
single threaded. Prior to this patch, the process was single threaded,
but this change creates a relationship from the kvm thread to the user
process that fails minijail's test.

For reference, here's the affected library function reporting this
behavior change:

  https://github.com/google/minijail/blob/main/rust/minijail/src/lib.rs#L987

Reverting the patch makes it work again.

Fwiw, I think the single threaded check may be misguided, but just doing
my due diligence to report the user space interaction.

