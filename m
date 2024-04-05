Return-Path: <kvm+bounces-13738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 623D289A009
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 188DD1F22B4F
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC4216F83E;
	Fri,  5 Apr 2024 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gJEPi+8c"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B871216F28C
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712328161; cv=none; b=nMtaFNcfW363IWEYXazySNveKDrUy9/lvJ4S3adi++/ss7a4Mqtlxs8zth8+NK1mD1kq3D6mRD38VvjMP+NUYZ7yMnXHMbj95fVoT69JLvvrzrWdF626rtOQn3hrc2720ezObJRtwUTmTaaNa72mun8AAFQVWz3K4/oB/1cxSBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712328161; c=relaxed/simple;
	bh=IBgLqZ3buoW3IdRadEfg19LCfS2zlDBoNVByQfz6mhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPX6Hq88+mbslP50sWTRZZLl0ei4HCDm5Eo6o/3wdefOzhe8ZGd7a6JgbimMO61EHuG7sYAa1UIHFTd9+PAXvDYZv+nQDQIl/FwrJP030so7rU8vVElM1cpmG0C5K87dCGEtNlmU0yf+cLHZAmW1h0Ir/WA+PJSOIwlxU/i3ZQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gJEPi+8c; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:42:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712328157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MtcQADxBXA1YhPpuZ7fmH3qMlXh/3dMUEIRBQ9SwmCw=;
	b=gJEPi+8cQKLjU7x3MMQHoNFtaKwz61gNAoQCnLPgjgrRqvnNyCapGWfbD4SlPswFdBxkOD
	sdmzbXkHO1tZ2+56b1t5cpLOcKoKIsuEJTs5uaNS31QkFWn9MTzM5x4rb64Gjc8GBjPfP5
	Qie3NDNKWKaC8D2zo5PfCQVSghaXbDY=
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
Subject: Re: [kvm-unit-tests RFC PATCH 16/17] shellcheck: Fix SC2153
Message-ID: <20240405-8c07ba91470a6bb355c3fdba@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-17-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-17-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:48PM +1000, Nicholas Piggin wrote:
>   SC2153 (info): Possible misspelling: ACCEL may not be assigned. Did
>   you mean accel?
> 
> Looks like a bug?

Agreed.

> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/s390x/func.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> index 6c75e89ae..fa47d0191 100644
> --- a/scripts/s390x/func.bash
> +++ b/scripts/s390x/func.bash
> @@ -21,7 +21,7 @@ function arch_cmd_s390x()
>  	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>  
>  	# run PV test case
> -	if [ "$ACCEL" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
> +	if [ "$accel" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
>  		return
>  	fi
>  	kernel=${kernel%.elf}.pv.bin
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

