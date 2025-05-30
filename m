Return-Path: <kvm+bounces-48080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCEAAC8827
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 08:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDFD91BC1860
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 06:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046651F875C;
	Fri, 30 May 2025 06:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NqJmBHPw"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A071FBE8A
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 06:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748585709; cv=none; b=jmN498w2HVUUuJne9+GEExdM9kwQ626mUfDEbc3HTLUnJqO48gxcuJP1MtIKyJsFI6zmSC3D/PQJoxLS6lW+vVS2e4SQOIcOpCgbfCsmhqwtbG0pRFiv8OYZ0vm1UblsCU62YvUfKy74kVlr3LWeKzxh7/cJX+TkhQHBAtcL8gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748585709; c=relaxed/simple;
	bh=XxHqngchfHC9/ddubGeE0V0/GXUvPn7a/Z95sIgFPLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVHpf0WsSHUvyry1kMHUlTWYgb+plx+i8v02Tb5mS0E33ansR22ik0hAXUeXRdX+IfFmVhZNusn0MSwbUSGjigMenE4bhWPmpUdUG2sCIOo3SzOZYdrKFXtfL8KQ7TV9BqebwH8qHHmSDTx0JGXMGcZ8kZYOdOraGBBOOC88eDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NqJmBHPw; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 30 May 2025 08:15:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748585704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dSky2u1Tg22aUpJN8gIK7pDNsy+9jUJcmFMKsgAMmuo=;
	b=NqJmBHPw3oFrdpYt5SAoh7grP0rQmHxJAoWjvQ3WkGREmukLKyUTZZ1fRkHfzJfJmHCfEN
	pLibTz8+WaXOSB63mRm2+oURIMJWr1cAJrLIZaHviTCrF88OYigJ+vyStd/2EpeK1uXP4n
	CqPeoFOVocpYgz1bdCUz4rNv4JeN71Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] runtime: Skip tests if the target
 "kernel" file doesn't exist
Message-ID: <20250530-4859709c9df9481d6897a818@orel>
References: <20250529205820.3790330-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250529205820.3790330-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 29, 2025 at 01:58:20PM -0700, Sean Christopherson wrote:
> Skip the test if its target kernel/test file isn't available so that
> skipping a test that isn't supported for a given config doesn't require
> manually flagging the testcase in unittests.cfg.  This fixes "failures"
> on x86 with CONFIG_EFI=y due to some tests not being built for EFI, but
> not being annotated in x86/unittests.cfg.
> 
> Alternatively, testcases could be marked noefi (or efi-only), but that'd
> require more manual effort, and there's no obvious advantage to doing so.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  scripts/runtime.bash | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index ee229631..a94d940d 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -150,6 +150,11 @@ function run()
>          done
>      fi
>  
> +    if [ ! -f "$kernel" ]; then
> +        print_result "SKIP" $testname "" "Test file '$kernel' not found";
> +        return 2;
> +    fi
> +

I see mkstandalone.sh already has something like this. There's still one
other place, though, which is print_testname(). Should we filter tests
from the listing that are missing their kernels?

Thanks,
drew

>      log=$(premature_failure) && {
>          skip=true
>          if [ "${CONFIG_EFI}" == "y" ]; then
> 
> base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
> -- 
> 2.49.0.1204.g71687c7c1d-goog
> 

