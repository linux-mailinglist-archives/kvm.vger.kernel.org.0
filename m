Return-Path: <kvm+bounces-36150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CC6A181FF
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A7F93AAEF2
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652111F428C;
	Tue, 21 Jan 2025 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xY8F3an6"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE5B3BBF2
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737477030; cv=none; b=OaDZav6WpzXYz6GOSAzYFN7PDArT2fGPPi/S1H4M4TmMwtsBpeJOPyVE18h+jzaloUKc1KbGRnftKaL4IAf1YZiLxA92F/UZTnFU2EA8gd8TMqw1u4KIHbxPiGtDs1ZdDinZ6BNGxsdIe58GvEHaAuGDGyEhRZeB/+L6NJseEQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737477030; c=relaxed/simple;
	bh=u8XKd19wBqMOBmQp8Sy/AWNogFU0MAF07u7Oivlk5l4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rF8DtACulinLqJqYy6QfHF42GvXhYYOrwlqFWOKsyGH8brEh+IMCKbmBhl/lL/v97PKin7g06BMB42DCtxWfoei43VVmNdndI6rbNGJW5RbOKc8JAN+GXo3JmVBiY/WCDlIeolVa27BeRrKyizYNGUUOixl/vNLCjPCdLpWdTr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xY8F3an6; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Jan 2025 17:30:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737477021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cCgssfmF7bQh08XnJwCfEdidZwB380Ri5cMen/pv4ro=;
	b=xY8F3an6zCEpk15gGynkafua9yyx97TTaOBTqWZmP6mBMpuavhwbnszC6x+BQY+pVarPUn
	9IvUfPiMo6ic2OurHPSlmvcdOVCeiJWpDOw+NbVIPLWLHem49eE1yCj7W3pRiH/N6rOqw+
	2K3BWGs0CUwO6E6xqSiFWrYvpeaqZh0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 09/18] scripts/runtime: Skip test when
 kvmtool and $accel is not KVM
Message-ID: <20250121-52d0e326cb9a3091229a7a77@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-10-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120164316.31473-10-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 20, 2025 at 04:43:07PM +0000, Alexandru Elisei wrote:
> kvmtool, unlike qemu, cannot emulate a different architecture than the
> host's, and as a result the only $accel parameter it can support is 'kvm'.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  scripts/runtime.bash | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index ee8a188b22ce..55d58eef9c7c 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -153,6 +153,11 @@ function run()
>          accel="$ACCEL"
>      fi
>  
> +    if [[ "$TARGET" = kvmtool ]] && [[ -n "$accel" ]] && [[ "$accel" != "kvm" ]]; then
> +        print_result "SKIP" $testname "" "kvmtool does not support $accel"
> +        return 2
> +    fi
> +
>      # check a file for a particular value before running a test
>      # the check line can contain multiple files to check separated by a space
>      # but each check parameter needs to be of the form <path>=<value>
> -- 
> 2.47.1

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

