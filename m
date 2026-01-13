Return-Path: <kvm+bounces-67915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E1A4ED16EC1
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 07:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 108FA3038F40
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 06:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2CF369973;
	Tue, 13 Jan 2026 06:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1NApMXh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E3625F98B;
	Tue, 13 Jan 2026 06:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768287440; cv=none; b=NEyiNWhlAWiO4ff5D4DBFt7vgxAhAr2ba9/lmsVdVyODom92YHbRybC2ydzPqbBIDf1jkm1LytrcDJEjib1W+dXrJPt0TULTacmkWo1NBR2PDZM2RBUc7oHVRILFur+GjMKLWSG42+ktXgm2Zy+/NskhRaqi6Wkr01CCWICajSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768287440; c=relaxed/simple;
	bh=60SPyWB8vDd2rUgvHslTdiPd0EofSPJHlT4QUyPma6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+rAHihzGr0aZNgA0sy+gf/Jy3AJQJ8qq8zQApmyH6FD+Se6npwgH6uhqIxI3gdLSeu/ovZUPErZLWJwZFcLqS+xmxu8AkLf8aXXcj3bJCvnHci/koUtYNMWyyRbOJJIoqkVL/iP0FpcXAvZfmAK3SaqWkvY6ruV+pG4OFpqGwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1NApMXh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D12C116C6;
	Tue, 13 Jan 2026 06:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768287440;
	bh=60SPyWB8vDd2rUgvHslTdiPd0EofSPJHlT4QUyPma6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R1NApMXhnqwRdTk2bbAImX9NrjtIDbtzQx9IWe8no+TStcOX4nHWBNhBtEh+GTKfh
	 5D2bVETHk3k4qJ3TfhxNbgsDzI/0L7N9K5AjJ5ICcWGg61rv3Y+R7jL66oh0Suq20c
	 8ibdQVDTHWMXjBYyAHqG+dWbXUn3ynN5ePye7vIIG+VWbvicoe4q/j99LOhZgBjKP2
	 urczlgGE8vb5kkt9cvhYHL4DJkbBf/GmURlHuhpD78NJaytElj/4UwAT5yTfTkSnZY
	 EQclNoU14InQbSaOyIdaYIGps5fgK3GMHmyi1TJsMHNXkh66lxmk3y2lLgljPPwTfN
	 Lb2RJ8DPFS6dg==
Date: Tue, 13 Jan 2026 06:57:18 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
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
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v5 21/21] x86/pvlocks: Move paravirt spinlock functions
 into own header
Message-ID: <20260113065718.GD3099059@liuwe-devbox-debian-v2.local>
References: <20260105110520.21356-1-jgross@suse.com>
 <20260105110520.21356-22-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105110520.21356-22-jgross@suse.com>

On Mon, Jan 05, 2026 at 12:05:20PM +0100, Juergen Gross wrote:
> Instead of having the pv spinlock function definitions in paravirt.h,
> move them into the new header paravirt-spinlock.h.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> V2:
> - use new header instead of qspinlock.h
> - use dedicated pv_ops_lock array
> - move more paravirt related lock code
> V3:
> - hide native_pv_lock_init() with CONFIG_SMP (kernel test robot)
> V4:
> - don't reference pv_ops_lock without CONFIG_PARAVIRT_SPINLOCKS
>   (kernel test robot)
> V5:
> - move paravirt_set_cap() declaration into paravirt-base.h
>   (kernel test robot)
> ---
>  arch/x86/hyperv/hv_spinlock.c            |  10 +-

Acked-by: Wei Liu (Microsoft) <wei.liu@kernel.org

