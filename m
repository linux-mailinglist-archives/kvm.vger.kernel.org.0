Return-Path: <kvm+bounces-13733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E627C899FEB
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23A1D1C23366
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86BCA16F289;
	Fri,  5 Apr 2024 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m2BhjFEn"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141F643170
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712327847; cv=none; b=X/uhhmTAxi3ujm5ewfmH9NcFX8+GSNNLky3lZ92SJPNTHPeyM+qK0gZqypIrpflWWR5LQ3rmwLos0583ZExzWWvDqfQgL8FDYoGzTZsjVjFW0uOXZUSZ7CwCh7bi8JAS811Nr9/EO0zI4eB09DOLNvd5LL5KxI7HjC7m7aHqPfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712327847; c=relaxed/simple;
	bh=/wcWZfFTiGu0tCXlgx2oIrJgnfV8soEbXGw3qrBZZDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vGaQWI+duM/qQHeA1jz6awOaUfdSrrjcCKPJD7w0mtJYSwuPAkJBAO3lWhF283EczDtL98byulaHx9u4qBTriZq0aNGq6zEwpG9T3mX3eoINm5lw4+q/fiR+3nC7PcvLF7Fj2JP5GG5Om9uwxtgZtulx7bCUe1Lfm9OAzKx1KV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m2BhjFEn; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:37:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712327843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+l9DctPtgtgSbeq5u1EB7dvhVT4XihzBexxkuU1IA1I=;
	b=m2BhjFEnJDmwOMix6wW+LuD82KtyIXSY3tTmCsVZj0C+E6iqB2MMh/rPrzsJxgIXKKqAUE
	dMbCPhBG7mg7zFq0iKR3MW9pWAc8QMxRLy4toWhiQy64JZaLozGPFl6VBvy0thdno7bSYr
	zf3e+iUbFMdfrpfKlU6Y56DNCqIXtPw=
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
Subject: Re: [kvm-unit-tests RFC PATCH 12/17] shellcheck: Fix SC2124
Message-ID: <20240405-a4a05544ec40a07744144d61@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-13-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-13-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:44PM +1000, Nicholas Piggin wrote:
>   SC2124 (warning): Assigning an array to a string! Assign as array, or
>   use * instead of @ to concatenate.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index e5750cb98..89a496014 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -150,7 +150,7 @@ run_migration ()
>  		return 77
>  	fi
>  
> -	migcmdline=$@
> +	migcmdline=("$@")
>  
>  	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
>  	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${src_infifo} ${dst_infifo}' RETURN EXIT
> @@ -179,7 +179,7 @@ run_migration ()
>  	exec {src_infifo_fd}<>${src_infifo}
>  	exec {dst_infifo_fd}<>${dst_infifo}
>  
> -	eval "$migcmdline" \
> +	eval "${migcmdline[@]}" \
>  		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
>  		-mon chardev=mon,mode=control \
>  		< ${src_infifo} > ${src_outfifo} &
> @@ -219,7 +219,7 @@ run_migration ()
>  
>  do_migration ()
>  {
> -	eval "$migcmdline" \
> +	eval "${migcmdline[@]}" \
>  		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
>  		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
>  		< ${dst_infifo} > ${dst_outfifo} &
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

