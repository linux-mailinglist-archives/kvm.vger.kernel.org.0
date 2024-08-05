Return-Path: <kvm+bounces-23298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6FE9486DE
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 03:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEEF72815BB
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C5B1EB44;
	Tue,  6 Aug 2024 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="QQ8tldQY"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEF59475;
	Tue,  6 Aug 2024 01:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722906218; cv=none; b=OncdVSGjfYi5K3gHPzPA9Oc/PeVQ9Pba3oKPog33BRFx52liSJRAlIiBLzXEzb2lVeBHYsu/O2Rm/lQa8V648jXCbXzHF0+jy7qhxd9d1QFzRSqde7Dl1XHeNPTXKpYtsdgtMXXz51j0DjKuoxX32n+vxSIO8TKY4KOYlC62eV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722906218; c=relaxed/simple;
	bh=mI9/CNrBD5qXZqkW6Ldkif5sH8/bXop/GckPD/gd55A=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZuCeJ+FdPyd9bPcDg0mBo9GEpGbC/fx0/xxqkPzEhRrZULw7W1I2MK4UeInaRjoO8Ra5b85qrr8mwUEJoq8DwNRgx4Bugq+1layBDGU5AnonlWo/4vAtPB3PsaDqvEg77abNYoQqDIJi/gE8gI32t3OZX4C5JHPRfl2VXR98aR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=QQ8tldQY; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1722899398;
	bh=mI9/CNrBD5qXZqkW6Ldkif5sH8/bXop/GckPD/gd55A=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=QQ8tldQYNuBdPn9xY6a20azTd0sdwHKhcR/eapjZTCzSNoTpabS307v8Ygb81en/Z
	 mat7wjips2JSHK5yyI2pW8jghlQzeBFDTfTZWLdjFQIsgQUURJF6S3GXi0afZPMc+Y
	 fSNRclbuyOYsljB1FCyCO8BjzSTlkteUdDh/grdY=
Received: by gentwo.org (Postfix, from userid 1003)
	id 1DF9840402; Mon,  5 Aug 2024 16:09:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 1AB86401CA;
	Mon,  5 Aug 2024 16:09:58 -0700 (PDT)
Date: Mon, 5 Aug 2024 16:09:58 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com, 
    vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org, 
    peterz@infradead.org, arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, 
    harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com, 
    misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com, 
    boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v6 02/10] cpuidle: rename ARCH_HAS_CPU_RELAX to
 ARCH_HAS_OPTIMIZED_POLL
In-Reply-To: <20240726201332.626395-3-ankur.a.arora@oracle.com>
Message-ID: <43b24caf-2ade-e229-21f4-8c01a47f37ed@gentwo.org>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com> <20240726201332.626395-3-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 26 Jul 2024, Ankur Arora wrote:

> However, recent changes in poll_idle() mean that a higher level
> primitive -- smp_cond_load_relaxed() is used for polling. This would
> in-turn use cpu_relax() or an architecture specific implementation.


Maybe explain here that smp_cond_load_relaxed will potentially wait for 
important events such as a cacheline changing. Thereby making the busy 
poll unnecessary and optimizing power use.


