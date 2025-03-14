Return-Path: <kvm+bounces-41016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE6AA606AB
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 01:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5BAF46057B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 00:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EBAB67F;
	Fri, 14 Mar 2025 00:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ejCHUc+L"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C26F4ED
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 00:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741913282; cv=none; b=FzTVQu+WC3uzhQABm0dxVK/ZvrSLijcdP1RGYP322wwzo4OU6/zGmy9F3fb/GOUF2Qlq132nEfotm2eQxrgUqde3YqveFgZbpaGRtiD2qnfvBvWMimu3+JsTevv70udczeHaAIZCS6mteEGKHRkhAtA4NCG1aC0Ak+i2DqU9yCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741913282; c=relaxed/simple;
	bh=RuHMdRVcHfXR5OWvzL7aYc70b51kBE+myy/vVjYK0Tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWrrFYHX1Wbh9LcnkDHbCFEdrqu7DBDmBg8UG1/6MGU6C+inCDQ1bNgwGLHBYl1R0Bh38//bsOjRvqBM8HWmhGlC/rrcuXPm1azxGQ1VIidcvPFvF36A/cU7G6EstekwFeYKES/LUx108KoKuCIdEs5SrBitTeV07OLpF/hBHPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ejCHUc+L; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Mar 2025 00:47:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741913267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Msbz5CdmnEjrtVx9C258prpnn00IRIPhQFSDM/5SfNE=;
	b=ejCHUc+LgIsG1VH232kvkNXW1X5Q1Tq+uqCwOR9XwLiz6dmwLzwFmtdYz1nQcE0oX0M3T0
	DKZmt4NJsvpOR2CnhTLt8NZ5PPSgiKz0I7xDNvlJcWhclXJN80+rUEEWNRzlsZMc6xFPjl
	EoLjOHoMIl9NsLtUjNyX/ba03RVZ+WE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] KVM: SVM: Use a single ASID per VM
Message-ID: <Z9N8rm3OSy6gH0Jh@google.com>
References: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
 <20250313215540.4171762-7-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313215540.4171762-7-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0f6426809e1b9..4c6664ba4048d 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -119,6 +119,7 @@ struct kvm_svm {
>  
>  	/* Struct members for AVIC */
>  	u32 avic_vm_id;
> +	unsigned int asid;

I couldn't have put this in a worse place if I was trying.

