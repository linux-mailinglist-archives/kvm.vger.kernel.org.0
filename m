Return-Path: <kvm+bounces-23854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B53094EF24
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E7F51C20401
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA26017D366;
	Mon, 12 Aug 2024 14:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PGSOTE/I"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BB317C7D9
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723471645; cv=none; b=j0l4atm5rAs2S9nyuaGvdn8+JGoiwwPPsueGBqya2gjlhJ3GJtYP1fzCAE2MxgQJBLb6/TXQAE8u+xcc+6QDgQmimAsUdFbBjxw4c7VjbNWgs01arEhZx9gSCgS2ZuI59JYEZw/I7/uryQPM3vELhrZ39n/sKc2X6NDkym39dFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723471645; c=relaxed/simple;
	bh=x01d3+sJ5a1usBteHZL02fQdXB+bv8tq73Nzu5RNE2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FcGc+AWpk4j1tUfkVA7kqjtRtJ7PGadZzD3nVay1TRAF+KQ0ppyv1QQ1hGTyA9AI1PunAPPbbalImqsJdAu/eYWXNstIZucrtGxlvCJcsW46kEOdSfsEHQGX+0NOjZtLxnRWB7aPkzlq9LufZx3tvZLHSJ3DPUSRXrZ3baGFnoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PGSOTE/I; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Aug 2024 16:07:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723471638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v9IfCqzM3uwcXxWyUUX4SFnjA+IBy+T8wKmxuUKkfrQ=;
	b=PGSOTE/IaHK5ohxTULnGmNngHX4cQOiZpCHBhkl3wOkilcnHdiSbpx4c1Gzub5Jlkf2oed
	DyPgJ+9h+rnYl7Inj0wWCWC9OFD2/ltPMUqvCEx5muKQohezP0GRBB0FgRj1VV+U4edhun
	AqNftqkj1Y0hOHu0Qyx9kh/YirIvzqk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH v2 0/7] riscv: 32-bit should use
 phys_addr_t
Message-ID: <20240812-7d3025fd062de8ac975912db@orel>
References: <20240812134451.112498-9-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812134451.112498-9-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 12, 2024 at 03:44:52PM GMT, Andrew Jones wrote:
> For v2 not only do we use phys_addr_t where we should to allow unit tests
> to pretend like high words matter on rv32, but we actually get it to work
> by adding a few more patches. Some new DBCN tests will make use of it.
> 
> Andrew Jones (7):
>   riscv: Fix virt_to_phys again
>   riscv: setup: Apply VA_BASE check to rv64
>   riscv: Support up to 34-bit physical addresses on rv32, sort of
>   riscv: Track memory above 3G
>   riscv: mmu: Sanity check input physical addresses
>   riscv: Define and use PHYS_PAGE_MASK
>   riscv: mmu: Ensure order of PTE update and sfence
> 
>  lib/memregions.h    |  1 +
>  lib/riscv/asm/io.h  |  4 ++--
>  lib/riscv/asm/mmu.h |  3 +++
>  lib/riscv/mmu.c     | 45 +++++++++++++++++++++++++++++----------------
>  lib/riscv/setup.c   | 19 +++++++++++++------
>  lib/riscv/smp.c     |  7 ++++++-
>  6 files changed, 54 insertions(+), 25 deletions(-)
> 
> -- 
> 2.45.2
>

Queued on riscv/queue, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv%2Fqueue

drew

