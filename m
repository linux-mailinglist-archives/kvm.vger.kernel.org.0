Return-Path: <kvm+bounces-36097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6EEA17AA2
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 10:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B022B18818DC
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 09:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38EBC1E570B;
	Tue, 21 Jan 2025 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjjtbFSJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44935D2FB;
	Tue, 21 Jan 2025 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737453368; cv=none; b=mAaRNmdCRI/VfvuQWkfegRlmomQL0QAV/fGkT5RBqTUNBqIWp4Qr/7/Wnv8aBsYrlJyA9NuaLGwhHmT7bZKa0uAHsi2tZd/vuX/+mBlntNXFS6DXCI93ouBzqiMugE9jEn/NjYP9iXASD41bN6TTacG97mFemuww/MYSh3zYi+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737453368; c=relaxed/simple;
	bh=Pq6+SwYN8tMjuzLRzEFPjm2o64W9oXSHb9lfpnhWEXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUGfpnhEUTWlin2qFrZM5SsE8aeud+EzPgyn3RRBdfQUu8cRLe7hg0Vs1PD4oTzP830XxQsHdsNwyO6jdcNZrEzGBaF/JRINPv6Mxi5VMh0H7ewA33NcxxQLSZzHYvT+UvERV2JUHF+4FCpsH+54exONevy9WDM5al13FW+qKFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjjtbFSJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EB2C4CEE3;
	Tue, 21 Jan 2025 09:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737453367;
	bh=Pq6+SwYN8tMjuzLRzEFPjm2o64W9oXSHb9lfpnhWEXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RjjtbFSJ3q4X5KDw2bbNwJpHHR6tVsaEigmhBx7CUvGlwyG8YWW3UIFvplnr4pA3W
	 y3orh5kmcaegA+g3PTNh5A134cHBfONE7CeRwul2GKYdVLFSo2UthbU0S5Bf5yY3d6
	 rLV7ovzvhr6yXdrQMeacPxWEcnIuRFrOQRKNa/acD7/TcAacpIFa3FA1MRXNCVd8mZ
	 EkFnc5NU9KvNo0LK0NrRdrgsv1rcoJ4xEkWdw1PCwEw9DOwAsmzdM9qdcrtCi6Ltup
	 rAUK2Ji3HlQzqQ+pbMKL8R94rqwekU/I4n9ZAVn2Jj5OecZHqFjagGFl+qBdDiGVRG
	 MYaeqen2dAFfw==
Date: Tue, 21 Jan 2025 09:55:58 +0000
From: Will Deacon <will@kernel.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, catalin.marinas@arm.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
	daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
	lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
	mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
	maz@kernel.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
	zhenglifeng1@huawei.com, joao.m.martins@oracle.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v9 00/15] arm64: support poll_idle()
Message-ID: <20250121095558.GA20954@willie-the-truck>
References: <20241107190818.522639-1-ankur.a.arora@oracle.com>
 <8734hd89ze.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734hd89ze.fsf@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jan 20, 2025 at 01:13:25PM -0800, Ankur Arora wrote:
> 
> Ankur Arora <ankur.a.arora@oracle.com> writes:
> 
> > This patchset adds support for polling in idle via poll_idle() on
> > arm64.
> >
> > There are two main changes in this version:
> >
> > 1. rework the series to take Catalin Marinas' comments on the semantics
> >    of smp_cond_load_relaxed() (and how earlier versions of this
> >    series were abusing them) into account.
> 
> There was a recent series adding resilient spinlocks which might also have
> use for an smp_cond_load_{acquire,release}_timeout() interface.
> (https://lore.kernel.org/lkml/20250107192202.GA36003@noisy.programming.kicks-ass.net/)

Urgh, that reminds me that I need to go look at that...

Will

