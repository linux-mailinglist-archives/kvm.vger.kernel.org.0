Return-Path: <kvm+bounces-13724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAFF5899F54
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED5C21C22202
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA725171079;
	Fri,  5 Apr 2024 14:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bE/xGnuN"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4079116FF4B
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712326527; cv=none; b=EuGV04gmHJRms+gEoW/j8U37pfMpEb6cvlIYR6u0Cb0Ht1TbDKkUow2UUo2KDxSkW7ALwZR/Ad8ZkA2uYNHyNHTscpt7iigEWa6HLOdWqw8mPpbSecTIL07WKHPlPdoY9090Or7ZJrNmt7IsV4M32g8fVCVy8TaqgiUxh9jrgH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712326527; c=relaxed/simple;
	bh=9eBT8v2ALZ3bSfHtoXVXdy3DbzEo1bzKw1uu2uq2X3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2/6wU3Kz7dAV2EokcWjTE52RMfk5Y0mvh1Cn7D+iKgNo4Y4zSu7PqGw7eRXenmRRZMVz6J2bkY6yYPq7v1YmfMYKIVxK9oFk10p2I3vEMjW6QXSJknI7oLoMotda1jOXfRS/QCvPJqQ6bV5idk1+SI2qk0P1Jaeg74k0Bkj8lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bE/xGnuN; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:15:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712326523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UejSghS38G+58uo0cj1QB6zU9X75lNc3bmWF7kf9KOQ=;
	b=bE/xGnuNpcGqqJoLLAfPa4kH7tEgERXwMyZTg6twZZgx3qZvhcr7c68b21a+C3//Tz3kj5
	k9+hlHgTwMIPhSzyRMU81Np4qWdwAmGZ2HgEkqZK0F9s68eIenk6nUSRS4dt3QLKUJGGUU
	H6A0uuZcZJXuYdVixMqVs+XjaRtfWes=
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
Subject: Re: [kvm-unit-tests RFC PATCH 03/17] shellcheck: Fix SC2295
Message-ID: <20240405-3c86b0d830a56cd1f5aa89de@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-4-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-4-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:35PM +1000, Nicholas Piggin wrote:
>   SC2295 (info): Expansions inside ${..} need to be quoted separately,
>   otherwise they match as patterns.
> 
> Doesn't appear to be a bug since the match string does not include
> patterns.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  run_tests.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 9067e529e..116188e92 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -99,7 +99,7 @@ else
>          local testname="$1"
>          CR=$'\r'
>          while read -r line; do
> -            line="${line%$CR}"
> +            line="${line%"$CR"}"
>              case "${line:0:4}" in
>                  PASS)
>                      echo "ok TEST_NUMBER - ${testname}: ${line#??????}" >&3
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

