Return-Path: <kvm+bounces-19982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1830390EAB8
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 14:18:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96BC3B25A0B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 12:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347AF145324;
	Wed, 19 Jun 2024 12:17:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C11A13FD84;
	Wed, 19 Jun 2024 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718799441; cv=none; b=oLZkaT5I2VnDikuwdUxK/dewyI8dlfHnzEKVBpN0BdVoEaMO8fnzYhptBafy9yV/seUn+tRJknsUtu93lSyqv7CKP9/yIsZmMwj6efa/GRmNBU3GNhXM29nOrN3yJi+oaczWHGD3eDorpD1RDP+hhE/i0QhI70fAGvO9nhUcI7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718799441; c=relaxed/simple;
	bh=/UmQ/7T9QyLIP/83V0+8xsTLFB88h5IhU6qz1+7bvmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rvcJM8e5yyP/EfVfn4/pvcFhytrwHZeiTqlipHTu7QVqQbo8+Gcy1SE/6RQ+1xBDlrkUsqkD5qGm3yDGU7DIUXq+sIGDkvW98yiRoSbHHCV9+g+5QosguhO+CeKwalb5oY0UNbLNsvbXa+3X0ytfEpvxMFybuEv6lB+NEFlTLb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B3D1DA7;
	Wed, 19 Jun 2024 05:17:42 -0700 (PDT)
Received: from bogus (unknown [10.57.89.235])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D40A33F6A8;
	Wed, 19 Jun 2024 05:17:12 -0700 (PDT)
Date: Wed, 19 Jun 2024 13:17:11 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
	rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
	arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
	harisokn@amazon.com, joao.m.martins@oracle.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 8/9] arm64: support cpuidle-haltpoll
Message-ID: <20240619121711.jid3enfzak7vykyn@bogus>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-9-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430183730.561960-9-ankur.a.arora@oracle.com>

On Tue, Apr 30, 2024 at 11:37:29AM -0700, Ankur Arora wrote:
> Add architectural support for the cpuidle-haltpoll driver by defining
> arch_haltpoll_*(). Also select ARCH_HAS_OPTIMIZED_POLL since we have
> an optimized polling mechanism via smp_cond_load*().
> 
> Add the configuration option, ARCH_CPUIDLE_HALTPOLL to allow
> cpuidle-haltpoll to be selected.
> 
> Note that we limit cpuidle-haltpoll support to when the event-stream is
> available. This is necessary because polling via smp_cond_load_relaxed()
> uses WFE to wait for a store which might not happen for an prolonged
> period of time. So, ensure the event-stream is around to provide a
> terminating condition.
>

Currently the event stream is configured 10kHz(1 signal per 100uS IIRC).
But the information in the cpuidle states for exit latency and residency
is set to 0(as per drivers/cpuidle/poll_state.c). Will this not cause any
performance issues ?

-- 
Regards,
Sudeep

