Return-Path: <kvm+bounces-46930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0EDFABA88D
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 08:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 410F64A56A7
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 06:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64B71B87D5;
	Sat, 17 May 2025 06:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qvlrmp44"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A97156F5E;
	Sat, 17 May 2025 06:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747464489; cv=none; b=GQ73AqAGukQbZYFGW9yg8VQRfF/N6wR6knJ8BzvV8NeXVWN57D/o7YBegt9fDS9If3ZGQh8Ih6zP5YUQzgogr9LUfngBRN9KPd7GiqGcaOQiFOfFzQabQAor47liI+197ru+mhhYAe+goIqU6wS4C3g5ay7gY/G2L5AgDFvWZSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747464489; c=relaxed/simple;
	bh=Xw1uOWDTS8cJfWEwczX8etpCdiQEsuEKHcfBPRVFTtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idGdZ6z2mrAOKKwqqBzWgLB+7kqrbXU3skvh2bafobt3dXr5/GUHL1zPHLsn+hnjPmR2cnILZdTvkJ+uFMA8jP6CyjCP2KR2UqhV1VgQq7AsE9SDMVr2CXP9OPZGX1opMY6VvfLT9Th/HktmkNW3ZzusL+SrTRvUxm+Z6ukNuJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qvlrmp44; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36998C4CEE3;
	Sat, 17 May 2025 06:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747464488;
	bh=Xw1uOWDTS8cJfWEwczX8etpCdiQEsuEKHcfBPRVFTtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qvlrmp44LmwgRqENA39Oze/Bs+R2hEqseN6xlQcGTPbJlAys5KH5cdds5dga/aIbY
	 9FpW972Osi42vO9/SO6P1k+o0uma5cdC99pKTIdpavNEeWezfKsIAMxMOEvj2Wl0Lq
	 a8o9hbrnG0vHm/VaLx0lgHBA8iUSbd9oh9LvuHVvVAQfk50Dvyt3kuPBQiWMU49buG
	 bjoYQ2UaVCuTDQI6L8OlAmhG3R4BDHfMIZ7d2nKcKjwhY7Zzn/4jr99k0srAbCzzlG
	 wE/xZOmP1Y5Mjls4y9tCp9ie7LnDy8WTfyDgME4ecKDn5GRRm8RokWBVW3WlHs/Alj
	 K5n5sXFHvWLzQ==
Date: Sat, 17 May 2025 08:47:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kevin Loughlin <kevinloughlin@google.com>,
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v2 3/8] x86, lib: Drop the unused return value from
 wbinvd_on_all_cpus()
Message-ID: <aCgxEhLBLIK-qq11@gmail.com>
References: <20250516212833.2544737-1-seanjc@google.com>
 <20250516212833.2544737-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516212833.2544737-4-seanjc@google.com>


* Sean Christopherson <seanjc@google.com> wrote:

> Drop wbinvd_on_all_cpus()'s return value; both the "real" version and the
> stub always return '0', and none of the callers check the return.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/smp.h | 5 ++---
>  arch/x86/lib/cache-smp.c   | 3 +--
>  2 files changed, 3 insertions(+), 5 deletions(-)

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

