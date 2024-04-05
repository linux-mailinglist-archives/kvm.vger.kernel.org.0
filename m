Return-Path: <kvm+bounces-13729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C61899FA7
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:28:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB2D51C228BD
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF91B16EC0A;
	Fri,  5 Apr 2024 14:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V7NkZbXi"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7430A16EBFD
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 14:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712327320; cv=none; b=g3dNgGfmsu3NGgxiYr/gVTWalsoUsFkpDkFoOnOIPqwYdssg9vZVaMSl+LNvXBzLGGFTW3yz0KdMrusYYputl+QH4kx98E+T3e1NQK/36tXCSbkzjflhchSAiyl0bGGZTPqeV+J779sfI9ZOfs/hLWnW7lAWDzK6BrwGPproOJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712327320; c=relaxed/simple;
	bh=bN2DMHYbvJqRhntVyJchx7L3hTpC+/Cji3a5u8mgFME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X75Zuf33pq8QtJMYDmuqA4cD9vgVP1wGgBmdKahXN9nV73wlZn2/rlHNbu5ond3IhCXOeF/SDW6isWX816j951Oolxg5hofy9+4pU0Ccmgv4G6fDxiZbDPt3BdRCMHSOMkpO+GigxH/pxElTaDaTmxbVP0JOpzfPruRPpCCf4iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V7NkZbXi; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Apr 2024 16:28:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712327316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nq9LUYKILBUisMc3+wAdFy7JC1ScOWxtCFJmt23nmpY=;
	b=V7NkZbXi+YKtn33jxKATbybfPKK8iuivwOAMpPxn0WczYxEaeh86Z0/K/XFWmuOLr8KJev
	GL2cWsGYqqg4H2Dgx3VAO+PBNIPtN3hIZOVwlmKUZP0iBXfyiJB1GqpIOJxjEz0xomuKDq
	6oPqnUaCPPToh3UFwar/XgpBu1PJR8I=
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
Subject: Re: [kvm-unit-tests RFC PATCH 08/17] shellcheck: Fix SC2119, SC2120
Message-ID: <20240405-6697565960bc4c4177ae865b@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-9-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-9-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:40PM +1000, Nicholas Piggin wrote:
>   SC2119 (info): Use is_pv "$@" if function's $1 should mean script's
>   $1.
> 
>   SC2120 (warning): is_pv references arguments, but none are ever
>   passed.
> 
> Could be a bug?

Looks like it to me.

> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  s390x/run | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/s390x/run b/s390x/run
> index e58fa4af9..34552c274 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -21,12 +21,12 @@ is_pv() {
>  	return 1
>  }
>  
> -if is_pv && [ "$ACCEL" = "tcg" ]; then
> +if is_pv "$@" && [ "$ACCEL" = "tcg" ]; then
>  	echo "Protected Virtualization isn't supported under TCG"
>  	exit 2
>  fi
>  
> -if is_pv && [ "$MIGRATION" = "yes" ]; then
> +if is_pv "$@" && [ "$MIGRATION" = "yes" ]; then
>  	echo "Migration isn't supported under Protected Virtualization"
>  	exit 2
>  fi
> @@ -34,12 +34,12 @@ fi
>  M='-machine s390-ccw-virtio'
>  M+=",accel=$ACCEL$ACCEL_PROPS"
>  
> -if is_pv; then
> +if is_pv "$@"; then
>  	M+=",confidential-guest-support=pv0"
>  fi
>  
>  command="$qemu -nodefaults -nographic $M"
> -if is_pv; then
> +if is_pv "$@"; then
>  	command+=" -object s390-pv-guest,id=pv0"
>  fi
>  command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

