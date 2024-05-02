Return-Path: <kvm+bounces-16399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6DF38B9635
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 10:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D4C01F24A04
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 08:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D371B2E85A;
	Thu,  2 May 2024 08:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pa1zKq3H"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9FF2D045
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 08:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714637577; cv=none; b=Srkaqr976eKfaFXxAm+yGQB916182ZXkATepcwYLlaGHBf24/7yfqz6hW5cmDebc4n0/x0skiILjYcmAGiEl45QhuWp/L2CdIsIEROm7stkQz1EhCLKkH95gjs2Z5TSxd5C1rkOgtSPLLiGMOk+CGvKGhFJ4nSUkPbb/GVYHTzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714637577; c=relaxed/simple;
	bh=TR3FnC2XQLQk2Rb/Gmxahb2SbM8bPc1uVT2H1D+gSIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f44/Y/ESCBeVGKHmpBNR+SIeyAhzVjBFPbA5v4/l3cZI0HjMAIHgNOk6fS8injkckIUDp/PR/ClLtU2Spcr9iH8qnPv3jX+USYvZ6LxbxQrBr/0n3b2wb33+/1e1yQZvAbdy3JJk3jG75sO49A53DhWqUN+jWH7xgDpHJLu/DhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pa1zKq3H; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 2 May 2024 10:12:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714637573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1uKFvOuyhI8Wif3LnkCVMq1U4LOjcoLCFDlwXYp89GI=;
	b=Pa1zKq3HhQIBbzzCmOknO89qOFWc4kE6FUiHowe688JiawO5Th1/LRgkRdX1WG/DvjqPLv
	JX4TtJPxSoHRQmcob97KrCwLoK6hvSAzKnrOFuhfHB1mIKU788xWl0v2skzHPhiven+rm1
	8LJOAd0NiV/yKPioW466udQlqI6Q5Ys=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Ricardo Koller <ricarkol@google.com>, 
	rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 0/5] add shellcheck support
Message-ID: <20240502-0e53a1b2873fbb04cdd2840c@orel>
References: <20240501112938.931452-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501112938.931452-1-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 01, 2024 at 09:29:29PM GMT, Nicholas Piggin wrote:
> This is based on upstream directly now, not ahead of the powerpc
> series.
> 
> Since v2:
> - Rebased to upstream with some patches merged.
> - Just a few comment typos and small issues (e.g., quoting
>   `make shellcheck` in docs) that people picked up from the
>   last round.
> 
> `make shellcheck` passes with no warnings for me after this series.
> (You should be able to put patch 1 at the end without conflicts if
> you prefer to only introduce the shellcheck Makefile target when the
> tree is clean.)
> 
> Thanks,
> Nick
> 
> Nicholas Piggin (5):
>   Add initial shellcheck checking
>   shellcheck: Fix SC2155
>   shellcheck: Fix SC2124
>   shellcheck: Fix SC2294
>   shellcheck: Suppress various messages
> 
>  .shellcheckrc           | 30 ++++++++++++++++++++++++++++++
>  Makefile                |  4 ++++
>  README.md               |  3 +++
>  configure               |  2 ++
>  run_tests.sh            |  3 +++
>  scripts/arch-run.bash   | 33 ++++++++++++++++++++++++++-------
>  scripts/common.bash     |  5 ++++-
>  scripts/mkstandalone.sh |  2 ++
>  scripts/runtime.bash    |  6 +++++-
>  9 files changed, 79 insertions(+), 9 deletions(-)
>  create mode 100644 .shellcheckrc
> 
> -- 
> 2.43.0
>

Merged.

Thanks,
drew

