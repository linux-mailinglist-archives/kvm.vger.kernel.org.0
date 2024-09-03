Return-Path: <kvm+bounces-25740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F28E8969F44
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:41:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BF0A1F22636
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 13:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C371BA27;
	Tue,  3 Sep 2024 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VEGgIH9t"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916FE1E505
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725370878; cv=none; b=PZgbzl+w3NrqQu9IPPJLz9lAL+9ohuhcDeOBpkyjMTbnwW99Pq+aA6rTd6Vb3TEREn0SzRIu2rbe4XczU6Rw/DIZsBt2OdZeg6jD+XgmOy17DKDT8EPd1GpG6vWopHkFm3DySqVg8Mo0ulPROtwUjoEhVbD4IX4SdGj5AZsrpMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725370878; c=relaxed/simple;
	bh=6wW0y21id/SInUbFCkzpY+B6MlTdRxEPQsw3XYU+Kug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ug/arl7mhtQU32WDFtjUVrNpglIlAjZT6zgVl0AwFXY/smb1p/bwnkLEWn/xoyGDA7T9SLN7leJSXGHkZKJZnB59IgK8hzHjNIiz1oGQuP4q+0NvStFQfMVzfViN+Ra/aqt2NdFdXH0X+4T7rM/RihWbz3r9EWKme114LbTRiJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VEGgIH9t; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Sep 2024 15:41:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725370874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=glt4B2vzl4X7P2c0GtJmYnZVbz8nQawNbRtox7tZILE=;
	b=VEGgIH9tV4NCuDNUpGAm5AOcJNtgSrVr662fQKe94OPM94fYjON1R6QEDqJiAskxKehevj
	gDGcdonQpZzCF4YrgFZoSs7wQZu7UaGVVddMCUwX1XJ6do+6GYoEXMZOiXj9QLuWc8u4PH
	UD54J39M3qqSodD+S8IiM/FaziR3SS0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 0/3] riscv: Improve on-cpu and IPI support
Message-ID: <20240903-97ba8bde2c3c7c1ca97d3bdc@orel>
References: <20240830101221.2202707-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830101221.2202707-5-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 30, 2024 at 12:12:22PM GMT, Andrew Jones wrote:
> The first two patches improve general library support for cpumasks and
> the on-cpus API. on-cpus can now take cpumasks for input. The last patch
> improves support for sending IPIs on riscv using the SBI IPI extension
> by supporting a nicer interface of cpuids and cpumasks.
> 
> Andrew Jones (3):
>   lib/cpumask: Fix and simplify a few functions
>   lib/on-cpus: Introduce on_cpumask and on_cpumask_async
>   riscv: Introduce SBI IPI convenience functions
> 
>  lib/cpumask.h       | 47 +++++++++++++++++----------------------------
>  lib/on-cpus.c       | 35 +++++++++++++++++++++++++--------
>  lib/on-cpus.h       |  3 +++
>  lib/riscv/asm/sbi.h |  3 +++
>  lib/riscv/sbi.c     | 43 +++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 94 insertions(+), 37 deletions(-)
> 
> -- 
> 2.45.2

Queued on riscv/sbi, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv%2Fsbi

