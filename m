Return-Path: <kvm+bounces-61028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B01C06F3C
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 17:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 342771C22461
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 15:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF96F326D53;
	Fri, 24 Oct 2025 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bbuIvqTB"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DE03AC1C;
	Fri, 24 Oct 2025 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761319506; cv=none; b=lvFv+OykCZ1IpI3yRfwDi8EoRg7qMA/+zHEKk8aW4Ff/jVrOLPik/cbXML3+ZG6FaKVnkcE9PRcILSia1CLkUCk3oXhpslp81nNUxg4OXwqSfudQt+WFZFksciKaBBS3mfUMe84mj3DneDOp2OnKFuEs8dR9YTVwHrDe3BBb5a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761319506; c=relaxed/simple;
	bh=Vikp2Dsv6hHz0e5gHsOzsNwkmyewcL+RLjq7WOJsQ7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiJvrj9253LTW//6X3iBf9TkMd9dtxucIe0lJNg2A/rt8lm/HZXRXyNucA5ACbI/eSB10DkYMtgGtAZ4Of1q/kPqZ3ZMNCyYavImSYbbJMcklCNkFEPq2KuFvpTd8T8Nz7WzOpTbbDfGOLiRiKZOQIdWnKv1TLmp5py2Ou+W1uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bbuIvqTB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=683wj7i/MFZD5/dz2o15L5hp3cHZstwJ4eheE1BVqu0=; b=bbuIvqTBULh7fEfeK0M2Tpg8Bt
	4Je4cjuXs1L17nIudFpri8HOJHBTapE1YbTb1H00VW6OLXuMmnrPO1MHDfmgTjfkOAfcvyFmpDDqD
	qajY+VTqzF6gKcwz4XfVYhu57+H0C545izS02bRJyOO5xvsKeJsbGvomWMR+ScvGa2GaZdat4fPcf
	Ua85bPPqA0vPXmumpgsaqx1Mq5xFeBAEZyiHvTFIZcUcBU7EXBjcof6WvOcyyafM6UJKnn1+YYfUs
	f2kQpO69JcqXzIjNUZuF+DMjhZN4fapNi1t2wPXALErCUNa9j6UYspI12OjdEEEOjm/Q8gvfB13L4
	ajBN+c6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCJf4-00000009npR-0Iv2;
	Fri, 24 Oct 2025 15:25:02 +0000
Date: Fri, 24 Oct 2025 08:25:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ramshankar Venkataraman <ramshankar.venkataraman@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] KVM: Re-export kvm_enable_virtualization() and
 kvm_disable_virtualization() as normal (global) exports rather than only to
 KVM's vendor modules
Message-ID: <aPuaTnIdexx8erS5@infradead.org>
References: <20250919003303.1355064-6-seanjc@google.com>
 <20251024123838.54976-1-ramshankar.venkataraman@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024123838.54976-1-ramshankar.venkataraman@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 24, 2025 at 06:08:38PM +0530, Ramshankar Venkataraman wrote:
> Starting with 6.12.0 (3efc57369a0ce8f76bf0804f7e673982384e4ac9) KVM modules
> enabled virtualization in hardware during module init rather than when the
> first VM is started. This meant that VirtualBox users had to manually
> unload/disable KVM modules in-order to use VirtualBox.
> 
> Starting with 6.16.0, kvm_enable_virtualization() and
> kvm_disable_virtualization() functions were exported. VirtualBox made use
> of these functions so our users did not need to unload/disable KVM kernel
> modules in-order to use VirtualBox. This made it possible to run KVM and
> VirtualBox side by side.

So?  We never export modules for out of tree drivers.  This should be
a reminder to the virtualbox project that they really should have
switched to using the kvm kernel code 10 years ago instead of wasting
time on their own buggy version.  They managed to get that memo on
other platforms the hard way, and maybe this is the final wink for
Linux for folks to understand.


