Return-Path: <kvm+bounces-13846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A3989B87E
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B7551F21D22
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA69F2C68C;
	Mon,  8 Apr 2024 07:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QW2M3V5X"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988B02BAF6
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 07:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712561685; cv=none; b=FeARcvyNSyHCqE88O/uB0x9QcimLKdO5NtXoLLQBFxi0mginu8xpcJIl+QYaiMdz9bxsFRdpx7kDzQzmZnNKfXPDmnzlqlU7h9k44tCT4KnZXUWqaA7fcPjhM6zz9nc1IY/0Ut7IG26KxLH8ga7C/qeRX5LonHzShWaASYKQodA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712561685; c=relaxed/simple;
	bh=mMUwQsISZ3FCjJWcZ6UWs3mYihezqlyVRuD1ROQxLmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhT3mdU7QFGL6y8TkYlY24CdDUz3CAa4MCs6MwatJGmYOoyxWqIQQ93TZCFdVyFko9pc1KxP2DLSGPyMieuIBUNDD6c/3dqVxyQSndDtC0+TAk871uSKh3StN/j/4ME1Fwz7dVHhyzUHY6AUY5rSvreJbj1MHzQo3vKTnWj1vp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QW2M3V5X; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 8 Apr 2024 09:34:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712561680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5jsUX7EP8Oi6cHnp1CX3FRa9IfBRQ/u9Wx/VAw8PMro=;
	b=QW2M3V5Xg44hm96pJLD+mUcAJHfhL35bCtMvGSe++4MaQ7ullSJE7KpKl6vu7EydQpP8c0
	Z4Yds0Vk11wQ2cJTNUPG5XqKbk9NpUGLXIOFpfEQ63rtaeo6w9oKPBELd6pIz/bJgu3Jiz
	uAsuDnse0XrrZrH0JmzoztkyzNe56qw=
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
Subject: Re: [RFC kvm-unit-tests PATCH v2 08/14] shellcheck: Fix SC2013
Message-ID: <20240408-840ece34e7b407365a18227d@orel>
References: <20240406123833.406488-1-npiggin@gmail.com>
 <20240406123833.406488-9-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240406123833.406488-9-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 06, 2024 at 10:38:17PM +1000, Nicholas Piggin wrote:
>   SC2013 (info): To read lines rather than words, pipe/redirect to a
>   'while read' loop.
> 
> Not a bug.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index cd75405c8..45ec8f57d 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -487,7 +487,7 @@ env_file ()
>  
>  	[ ! -f "$KVM_UNIT_TESTS_ENV_OLD" ] && return
>  
> -	for line in $(grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=' "$KVM_UNIT_TESTS_ENV_OLD"); do
> +	grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=' "$KVM_UNIT_TESTS_ENV_OLD" | while IFS= read -r line ; do
>  		var=${line%%=*}
>  		if ! grep -q "^$var=" $KVM_UNIT_TESTS_ENV; then
>  			eval export "$line"
> -- 
> 2.43.0
>

I already gave an r-b on this one. Here it is again,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

