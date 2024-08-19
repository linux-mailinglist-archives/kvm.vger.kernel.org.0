Return-Path: <kvm+bounces-24556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A00F957749
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 00:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33B851F248DF
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 22:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C783B1DD395;
	Mon, 19 Aug 2024 22:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h2LIGvMl"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95471158D87
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 22:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724105754; cv=none; b=S6tf4qc6QDYdnB3dvmQX8MyNWdp4zizv2R9y9dTNiahXXahuI8gRFXaLIn/tXIL4v2XfmWYrema2hy4v8UWZBrTCVF+5eS+KUhIRNvmgoYzuKMLFDE8F/fpNDzhdBbkzGPRR3dyaqb/tGWfY+JPD/fBbywtE28f4lAZOHdhYZKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724105754; c=relaxed/simple;
	bh=dhmWgF5o+4TJBNnJucLoSqJJ0PWGuqjfVYw+EUWZHqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMoL2Sk734f40SqXw85hPBak0bdR+pllM8w5nKlMJfRor8r0QTLgPQ/jbvxraSY08eJWKGf1muDRe0eQT6TVhAImhm5BkNyej1Lf0pTL+qaheX1ZBfoq32Y2WLgaMUQ7q4Ll56aHk7XUphI1yVe6guVy/Fsm9h+o5epa6sQvqfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h2LIGvMl; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 19 Aug 2024 22:15:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724105750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gu8OxZt5OEjyJopGkCUwXelOpTcGPqYiU+pjfoBBknQ=;
	b=h2LIGvMl4WF+Y+S6+Iuotq2Ms73M4Y+MI8I8gS48xI2CWVCvyOryWI4PHfYvXo5Fq0GKXS
	20bl2ZJsoIkmBX9nOnnIOF66BlcH6RMMjZpK0W9+UtFj1GbHU3ALvv/xHmm/StjkMs7J+k
	NU/QwrJB+fAJZyO4cbgicp6YsecU5rc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	kernel@collabora.com, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Anup Patel <anup@brainfault.org>
Subject: Re: [PATCH v2] selftests: kvm: fix mkdir error when building for
 unsupported arch
Message-ID: <ZsPEEFvoGYjW3vfx@linux.dev>
References: <20240819093030.2864163-1-usama.anjum@collabora.com>
 <ZsNzzajqBkmuu5Xm@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsNzzajqBkmuu5Xm@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 19, 2024 at 09:33:17AM -0700, Sean Christopherson wrote:
> And other KVM maintainers, the big question is: if we do the above, would now be
> a decent time to bite the bullet and switch to the kernel's canonical arch paths,
> i.e. arm64, s390, and x86?  I feel like if we're ever going to get away from
> using aarch64, x86_64, and s390x, this is as about a good of an opportunity as
> we're going to get.

I'm pretty much indifferent on the matter, but I won't complain if you
send out a change for this.

-- 
Thanks,
Oliver

