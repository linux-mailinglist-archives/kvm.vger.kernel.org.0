Return-Path: <kvm+bounces-67835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 249E4D15543
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 21:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 68339309955B
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 20:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C66D234FF71;
	Mon, 12 Jan 2026 20:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VeA5pHS2"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1437340277
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 20:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768251076; cv=none; b=UrpSk56WQfm2HRq7TxxcPobiU5e5+b2oOt3smUyB4JTtN4X9zP3kdBqcHCV4BjiIIYvOa2+eLsmUVw9D1W8gKzfIzypd20rYjK+m5aH19xXs9BJ4K42g4jUChfMZwi6T6NdKs9kUFg5bAspyDKoI4F1Yuz6N1ePMowwkZqxYSw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768251076; c=relaxed/simple;
	bh=YuDkX956QE9jMFS6QQQ8zsQ16gVMm0hDcPYedLwqd8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWHrrxB/e6NXaMQIlGKyM9NYItNLJIvnDZWo5To35W0iZbi1fUCI+SYUvDgN/ahxJStvWdp1Xwbn0LAJ70NSijAw5daFpv8vdDJgEqkHThz8qBo/XEdc/X+vXJ8LOOKp3PazpdKlGGUx2ggimaiXOeM4e3Ox2oJXQbf8S98pWs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VeA5pHS2; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Jan 2026 20:51:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768251072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hez6wLx+1nsSw3ONQ4m7AUcDfHy5oQqt95c20RFz0hw=;
	b=VeA5pHS2FLehUJn0j2yYztH0z6S0JYMhehyDZUSxuwqnPCTFSZc/wz0F9HrbnjMZxh5q3e
	ubouRHpGekIRAmBthya3aiH9OLPuBFEuGiOHgA7LCzqXYuuRmj8oGyp4+dbEx05Es39Os9
	R31aAZv1jyRqpBaA23jsPjPOIg45sqI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kevin Cheng <chengkev@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/5] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
Message-ID: <vmm7ywopj3jearmgibwi7sqq23aomskkgjv5zv5jyft7wxek6n@5kikxu6mfscl>
References: <20260112174535.3132800-1-chengkev@google.com>
 <20260112174535.3132800-4-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112174535.3132800-4-chengkev@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 12, 2026 at 05:45:33PM +0000, Kevin Cheng wrote:
> INVLPGA should cause a #UD when EFER.SVME is not set. Add a check to
> properly inject #UD when EFER.SVME=0.
> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/svm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 557c84a060fc6..92a2faff1ccc8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2306,6 +2306,9 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
>  	gva_t gva = kvm_rax_read(vcpu);
>  	u32 asid = kvm_rcx_read(vcpu);
>  
> +	if (nested_svm_check_permissions(vcpu))
> +		return 1;
> +
>  	/* FIXME: Handle an address size prefix. */
>  	if (!is_long_mode(vcpu))
>  		gva = (u32)gva;
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

