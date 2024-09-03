Return-Path: <kvm+bounces-25722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2592D969694
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 10:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 583FA1C238E3
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6FB201266;
	Tue,  3 Sep 2024 08:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CU9O97hx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C831C1D6786;
	Tue,  3 Sep 2024 08:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725351049; cv=none; b=cxVXo9tMXJkfYmuuMWFs+G8bSN61sMNMCiyzuIEbGezkaPwJWxn/NQVLV1Z+wHJMmV+Kcd7ji/F8b/epf/ZA4n/zqqQFJ2azgA1f2YenpNoehmSgPRY/GdUtjIVJcQS1iYhTZHvN1yqT1HqIPVD0EjfFRs0UMjM58D01z38GRkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725351049; c=relaxed/simple;
	bh=jP6CX882VxUoMUs+GUcg6yOBw6YsE2JXPKi3ng1ReiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sv4BKFL/NlX6VNHTFxgm43XKpPz8mTHZdgWmjciqEyCsVeflE2WxKKVptWUvJOkAaNZFr06EEbwT66M2V/2TMB4YlVzcClGHjcDT5BEXUpa2wa99Nhn14Zb3gM/TyLZtZckjQDI08s0JybDDQD+QTOGobp7BQDwyKBckIFzVAwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CU9O97hx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593E8C4CEC5;
	Tue,  3 Sep 2024 08:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725351049;
	bh=jP6CX882VxUoMUs+GUcg6yOBw6YsE2JXPKi3ng1ReiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CU9O97hxiMgO7eIIqr5vC9vCZxkYczZLVMeONL0PqcVOq/kUmPFLybgYnWtqIw4Ci
	 6uQnRcCRtaee6+sq6Wv4C3huAa+0NeYcZdGDr3un03PxMHAiwNqh4q7rI9mGS46vkD
	 cf2CGqOQ3OK4ZjeLTj4ICaB2vwWCjQ5gEC9hPmf88Tz3ghDElRm2BJ5qxlpHOc0NHK
	 xQLNonEsrud1rVETW1SLTAYmnXJtnlj43AwPxu+djRVRw4r0w1V3hP2uliB683z5yo
	 L80DW8bBoiqVmSigdRGJfZar9F9lJXNybZXZQ2T2khUVElvnLBjsUw+OcfK4vHxmmc
	 bS2HxT5jhnzUQ==
Date: Tue, 3 Sep 2024 09:10:40 +0100
From: Will Deacon <will@kernel.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
	vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
	peterz@infradead.org, arnd@arndb.de, lenb@kernel.org,
	mark.rutland@arm.com, harisokn@amazon.com, mtosatti@redhat.com,
	sudeep.holla@arm.com, cl@gentwo.org, misono.tomohiro@fujitsu.com,
	maobibo@loongson.cn, joao.m.martins@oracle.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v7 07/10] arm64: define TIF_POLLING_NRFLAG
Message-ID: <20240903081040.GA12270@willie-the-truck>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
 <20240830222844.1601170-8-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830222844.1601170-8-ankur.a.arora@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Aug 30, 2024 at 03:28:41PM -0700, Ankur Arora wrote:
> From: Joao Martins <joao.m.martins@oracle.com>
> 
> Commit 842514849a61 ("arm64: Remove TIF_POLLING_NRFLAG") had removed
> TIF_POLLING_NRFLAG because arm64 only supported non-polled idling via
> cpu_do_idle().
> 
> To add support for polling via cpuidle-haltpoll, we want to use the
> standard poll_idle() interface, which sets TIF_POLLING_NRFLAG while
> polling.
> 
> Reuse the same bit to define TIF_POLLING_NRFLAG.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> Reviewed-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>  arch/arm64/include/asm/thread_info.h | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Will Deacon <will@kernel.org>

Will

