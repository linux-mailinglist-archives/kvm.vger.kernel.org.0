Return-Path: <kvm+bounces-31483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC24A9C4115
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1955D1C21889
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390051A01DD;
	Mon, 11 Nov 2024 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DSqpQdS2"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C8A19D060
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731335801; cv=none; b=lEy9IWVP0CPCJ0N4oWVubOy6QWWN9cCWNrh2BaziGZCQFsq7dT+YngDP9aOKLm/HTVTlyg+zFf8MWztJADJVY6W7C37dpuxs+t+Li888ngjO/eMCf3cAW9Cy4YGAVnX0ND4tKo+xZom8VRtjORFhi6KguPSSvXkkVZ3Tvafde+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731335801; c=relaxed/simple;
	bh=BgEbSiUac6O1D5seL5roohUodzRYnoEwlGaiK7zh38E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Av0YhuQWHtrLR7SvDueNJG/0DMbhmKb8yHafbNUheG8FsVoZ0MMrKk1NmTz171yvzxW/5HOL04FrjK3NvoOffS89Z7egdW5ckQuo99NaCV+iWropMMVlrlfCq/9G0QJZQSw9+5Ubkc2JDfwjCF9iKBGYQ+pnSsejJWKFgVmbnkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DSqpQdS2; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 15:36:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731335795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Ztg1inbkS6ohpfOuDyr1HStC9a1ufh4UIjr2qvS+r8=;
	b=DSqpQdS2PqwNdulU8LVmBa68LKlL+tRTJvsGbUg5Lbn5hGQ+kjw8HH9id9iigwvrpltube
	sc4mQ7s3ZoRLQpSvL/W1q2QcW0vmD2+P4r+SwquZ5QeGXeEyLO8e0Ult+/FMpsIjzPlR5P
	EGcnP44wUx6y0pZl5pehwqizuJIsHjw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: atishp@rivosinc.com, jamestiotio@gmail.com, alexandru.elisei@arm.com, 
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 0/3] lib/on-cpus: A couple of fixes
Message-ID: <20241111-ef3ba6e132792aaf8ad901f7@orel>
References: <20241031123948.320652-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031123948.320652-5-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 31, 2024 at 01:39:49PM +0100, Andrew Jones wrote:
> While creating riscv SBI HSM tests a couple strange on-cpus behaviors
> were observed. Fix 'em.
> 
> v2:
>  - Added patch for barrier after func() [Alex]
>  - Improved commit message for patch1 [Alex]
> 
> Andrew Jones (3):
>   lib/on-cpus: Correct and simplify synchronization
>   lib/on-cpus: Add barrier after func call
>   lib/on-cpus: Fix on_cpumask
> 
>  lib/cpumask.h | 14 +++++++++++++
>  lib/on-cpus.c | 56 ++++++++++++++++++++-------------------------------
>  2 files changed, 36 insertions(+), 34 deletions(-)
> 
> -- 
> 2.47.0
>

Merged to master through riscv/queue.

Thanks,
drew

