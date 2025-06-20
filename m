Return-Path: <kvm+bounces-50161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B51FAE22CE
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 21:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E36C7AA5D9
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236DF224B02;
	Fri, 20 Jun 2025 19:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W42T7MNl"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB77330E82F
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 19:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750447736; cv=none; b=GRmFKFLfEw8IwzVhx2w6qoE60vprPqcwu23kkLAqtOCFnqKWRopz9tkZ5hD4n+8knZArCjCGv7yrbGZDy+SM4vqxZLVaQDgYWhJq70P4spo92z1BAK6b6n0w/LDL5n6dXe4PVRMj+mLTj3h1v1VWilMrKr5+dbG3r7VuSOODins=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750447736; c=relaxed/simple;
	bh=DrZw3DT7Kllwn6vq1+VE3kts+TAHt/nlr3suzeS8pgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jT+lORZbSV4M3P3HG3A6kTczZIkcx9sW2qI5dao1V3e+Y1sxw/BteStPO+swQT2DkIMgAqXD/CyMOo42A7lfJa8oJBNHG3DrU4COv2wX/0pYNRmEOi8eTK+6U0+AQfSTa5917shUSmYdVnS31CvhcdfJcw4HI5y6/dLt3xTtQzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W42T7MNl; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 20 Jun 2025 12:27:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750447730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NgldqAkN4EcKf+iDJigOAF1MecbzOvfvyTrQTD43eRc=;
	b=W42T7MNlvzs/y0GgOq0jyWHLLYVFWnXTLt8ehslxEORhH363LQ3I2EKnyY/lcXJ7TuYCCP
	/ddoesoS1z3+FzcQtRf+UEyi/ryVP6PVmtH1LVq3QA7cCZuxX6dbA5NubQaX4Y9lVNRphf
	Jqn5Jzz8vxkhz8VXmNt/f9dhM/LssW8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
Message-ID: <aFW2NISX0q11sop1@linux.dev>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-4-seanjc@google.com>
 <86tt4lcgs3.wl-maz@kernel.org>
 <aErlezuoFJ8u0ue-@google.com>
 <aEyOcJJsys9mm_Xs@linux.dev>
 <aFWY2LTVIxz5rfhh@google.com>
 <aFWtB6Vmn9MnfkEi@linux.dev>
 <aFWws7h3L-iN52sF@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFWws7h3L-iN52sF@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 12:04:19PM -0700, Sean Christopherson wrote:
> On Fri, Jun 20, 2025, Oliver Upton wrote:
> > Can you just send it out as a standalone patch? It's only tangientally
> > related to the truckload of x86 stuff
> 
> The issue is that "KVM: Don't WARN if updating IRQ bypass route fails" directly
> depends on both this patch

Eh? At worst we break bisection for the warn, which I'm sure we manage
to commit similar high crimes on the regular.

> If I post it as a standalone patch, could you/Marc put it into a stable topic
> branch based on kvm/master? (kvm/master now has patch 1, yay!)  Then I can create
> a topic branch for this mountain of stuff based on the arm64 topic branch.

Ok, how about making the arm64 piece patch 1 in your series and you take
the whole pile. If we need it, I'll bug you for a ref that only has the
first change.

That ok?

Thanks,
Oliver

