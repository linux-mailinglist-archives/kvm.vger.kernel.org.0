Return-Path: <kvm+bounces-13726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED04F899F66
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D868B21D83
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146D116F270;
	Fri,  5 Apr 2024 14:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tl+dsqvx"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B4F16F0EF
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712326668; cv=none; b=MDFZPBxZ7/TvqHN6fsVgPgHKdf4Nsg6WJ+qnPlHDR/u6KdpjxbQYqtHShUbDuNSq1M7muvHRZt4pZBQYUo9ev7I20DlA1mwvtVG2f1afbZRg52hqfAkEXQLQZtU9AEvKFavGOUgkmuKAzk1cbWOfl8P5PH39VG5yxB/tLpzbL8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712326668; c=relaxed/simple;
	bh=R0ZLdJVsrBk5k+x8D8om4leWpCwPagPZ43a3wzPFQHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u+twxfDwe8epHboBgD8w2McKtKoYYM/2vOwHPGj0P/ApxK52K8lmrSuRGydm87mQHbz9XJ2s9Lwix3dwyJ491ozDkWX9vcwFfzv28iyr3BV9HKlsVBzo12zLBx/Q+V1VeXpForpaPS6IwlsUSizZuObi2pwHcdU9HLWs8ZyL2vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tl+dsqvx; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:17:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712326664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZFNTgutA3vHipkSVU5HxpHR61gsE+oNdmE4mMKLzbMc=;
	b=Tl+dsqvxUCdF5XqzJyjj2P56JJGhBus3B04s9Cdo2RsF+X2FQEXxXlPBflwAaBEufxvf+j
	yhg1dy2uY6Vt0T20qr6jHr7zHsqvkOv1gMAUOsHI8Cu3sB5yd9NDXTBfobrS9w6pQJbwk/
	ynz14ElXGrkREqOGEc0csEYlKR/WsKU=
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
Subject: Re: [kvm-unit-tests RFC PATCH 05/17] shellcheck: Fix SC2006
Message-ID: <20240405-f5a043bb8fa1230ca636f62e@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-6-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-6-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:37PM +1000, Nicholas Piggin wrote:
>   SC2006 (style): Use $(...) notation instead of legacy backticks `...`.
> 
> No bug identified.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 6 +++---
>  scripts/runtime.bash  | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 472c31b08..f9d1fade9 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -271,16 +271,16 @@ do_migration ()
>  	qmp ${src_qmp} '"migrate", "arguments": { "uri": "unix:'${dst_incoming}'" }' > ${src_qmpout}
>  
>  	# Wait for the migration to complete
> -	migstatus=`qmp ${src_qmp} '"query-migrate"' | grep return`
> +	migstatus=$(qmp ${src_qmp} '"query-migrate"' | grep return)
>  	while ! grep -q '"completed"' <<<"$migstatus" ; do
>  		sleep 0.1
> -		if ! migstatus=`qmp ${src_qmp} '"query-migrate"'`; then
> +		if ! migstatus=$(qmp ${src_qmp} '"query-migrate"'); then
>  			echo "ERROR: Querying migration state failed." >&2
>  			echo > ${dst_infifo}
>  			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
>  			return 2
>  		fi
> -		migstatus=`grep return <<<"$migstatus"`
> +		migstatus=$(grep return <<<"$migstatus")
>  		if grep -q '"failed"' <<<"$migstatus"; then
>  			echo "ERROR: Migration failed." >&2
>  			echo > ${dst_infifo}
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 2d7ff5baa..f79c4e281 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -61,9 +61,9 @@ function print_result()
>      local reason="$4"
>  
>      if [ -z "$reason" ]; then
> -        echo "`$status` $testname $summary"
> +        echo "$($status) $testname $summary"
>      else
> -        echo "`$status` $testname ($reason)"
> +        echo "$($status) $testname ($reason)"
>      fi
>  }
>  
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

