Return-Path: <kvm+bounces-13719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E28E899EDD
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 15:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC0A92831B0
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 13:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5938016D9D0;
	Fri,  5 Apr 2024 13:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IoYJPoi0"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D216D9C7
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 13:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712325563; cv=none; b=jf8UxiuF54sasrZJ00OLYvjmSMDggKjfOkB61I+oUKzs3375SNItaj9vV7X0wdOXJAyWL4bSlN948J7JENDwyY+RcS8LxQtyHTtZrauasco9BrrU6lyIg7ZYUGli+M/zSHxC9bf3blX91VnOzek9YlSCLjhr3XLWbLKh/v8T/g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712325563; c=relaxed/simple;
	bh=4XLS0rq6izIRaRgceQ0GX/l4V0ZzhDGRBl8KjoQCv1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8Q3ndXePq1RbND2T9vJFl398gSG6ApoiULpoDg6EwFiJRDGWlvbtnm9SNZgQQCyYaIrAM6EwOgXbqX0ZRf3rlUbUlcIEGl6Qx/5+07r2ZIUyAXQKvI/4UjgZI/ySfAd28JSzue+01rabojrcmPWx1wChYyvmGxoMnwOW8v2o2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IoYJPoi0; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 15:59:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712325559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0LGCxJo2e6ztj7xm+eeWNgiP8C9O8q6U3aglumrUQj4=;
	b=IoYJPoi0M2ZT/ptqBymtJtBWfIQSQijqLK9xkDt+NMSivicre5g2p88jTlrKUd30MOzCt2
	679b+aShBO+NK9CS8VTlqA/i3JeccFE9O5KlUUQYwxdjkOgjwnHd4CJRFOoB1308KkmSly
	BiieO9JulNYjRqENoYIAeAVc22Jm0l8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Nadav Amit <namit@vmware.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Ricardo Koller <ricarkol@google.com>, rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC PATCH 00/17] add shellcheck support
Message-ID: <20240405-20fbe979a00acc8b9d161936@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:32PM +1000, Nicholas Piggin wrote:
> I foolishly promised Andrew I would look into shellcheck, so here
> it is.

Thanks! I hope you only felt foolish since it was recently April
Fool's day, though.

> 
> https://gitlab.com/npiggin/kvm-unit-tests/-/tree/powerpc?ref_type=heads
> 
> This is on top of the "v8 migration, powerpc improvements" series. For
> now the patches are a bit raw but it does get down to zero[*] shellcheck
> warnings while still passing gitlab CI.
> 
> [*] Modulo the relatively few cases where they're disabled or
> suppressed.
> 
> I'd like comments about what should be enabled and disabled? There are
> quite a lot of options. Lots of changes don't fix real bugs AFAIKS, so
> there's some taste involved.

Yes, Bash is like that. We should probably eventually have a Bash style
guide as well as shellcheck and then tune shellcheck to the guide as
best we can.

> 
> Could possibly be a couple of bugs, including in s390x specific. Any
> review of those to confirm or deny bug is appreciated. I haven't tried
> to create reproducers for them.
> 
> I added a quick comment on each one whether it looks like a bug or
> harmless but I'm not a bash guru so could easily be wrong. I would
> possibly pull any real bug fixes to the front of the series and describe
> them as proper fix patches, and leave the other style / non-bugfixes in
> the brief format.  shellcheck has a very good wiki explaining each issue
> so there is not much point in rehashing that in the changelog.
> 
> One big thing kept disabled for now is the double-quoting to prevent
> globbing and splitting warning that is disabled. That touches a lot of
> code and we're very inconsistent about quoting variables today, but it's
> not completely trivial because there are quite a lot of places that does
> rely on splitting for invoking commands with arguments. That would need
> some rework to avoid sprinkling a lot of warning suppressions around.
> Possibly consistently using arrays for argument lists would be the best
> solution?

Yes, switching to arrays and using double-quoting would be good, but we
can leave it for follow-on work after a first round of shellcheck
integration.

Thanks,
drew

> 
> Thanks,
> Nick
> 
> Nicholas Piggin (17):
>   Add initial shellcheck checking
>   shellcheck: Fix SC2223
>   shellcheck: Fix SC2295
>   shellcheck: Fix SC2094
>   shellcheck: Fix SC2006
>   shellcheck: Fix SC2155
>   shellcheck: Fix SC2235
>   shellcheck: Fix SC2119, SC2120
>   shellcheck: Fix SC2143
>   shellcheck: Fix SC2013
>   shellcheck: Fix SC2145
>   shellcheck: Fix SC2124
>   shellcheck: Fix SC2294
>   shellcheck: Fix SC2178
>   shellcheck: Fix SC2048
>   shellcheck: Fix SC2153
>   shellcheck: Suppress various messages
> 
>  .shellcheckrc           | 32 +++++++++++++++++++++++++
>  Makefile                |  4 ++++
>  README.md               |  2 ++
>  arm/efi/run             |  4 ++--
>  riscv/efi/run           |  4 ++--
>  run_tests.sh            | 11 +++++----
>  s390x/run               |  8 +++----
>  scripts/arch-run.bash   | 52 ++++++++++++++++++++++++++++-------------
>  scripts/common.bash     |  5 +++-
>  scripts/mkstandalone.sh |  4 +++-
>  scripts/runtime.bash    | 14 +++++++----
>  scripts/s390x/func.bash |  2 +-
>  12 files changed, 106 insertions(+), 36 deletions(-)
>  create mode 100644 .shellcheckrc
> 
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

