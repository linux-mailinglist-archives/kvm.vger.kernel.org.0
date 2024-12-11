Return-Path: <kvm+bounces-33476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7887B9EC601
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 08:53:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AD5D164419
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 07:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684AA1CBA02;
	Wed, 11 Dec 2024 07:53:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14B32451E2;
	Wed, 11 Dec 2024 07:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733903597; cv=none; b=uGMw2VBogmIzjNQH+uz6umBph8tOrsI/pMAAWnzq7n+rFcZTwYWMpNWf6Hhf2jcGHC7EAtBn1RQBq8cijcXgAuqCjbQzblrXVrdqF3zhjE7tCSnt3lXO6hfocD1gu3yCvnWHayj8f+1z0rd1TZ1IBLu+sjytjPUwQJUFE0zC8To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733903597; c=relaxed/simple;
	bh=wtv1PNb5q+Ix0UB+WDVjJZGzgbU7uOPG8O/vD5gSJKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1oU0OVrONZdkHmrQhm4zy3qMtJw67mOYJ1bVysGHi0nA+Ff4GfODkPJ3p7DxqHHIy1OUN5c1IIXyPjuiQO3ms5+ClKGEBKnRUv8oAlOMYKS40HkYuDOVO36PY1LgDaUPcP+TA7VPxpH8qB7DAjphGmFnK7Bb6PHqYhhL+1CpZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C54DC4CED2;
	Wed, 11 Dec 2024 07:53:17 +0000 (UTC)
Date: Tue, 10 Dec 2024 23:53:15 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>,
	Sean Christopherson <seanjc@google.com>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] x86/bugs: Add SRSO_USER_KERNEL_NO support
Message-ID: <20241211075315.grttcgu2ht2vuq5d@jpoimboe>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-2-bp@kernel.org>
 <20241210065331.ojnespi77no7kfqf@jpoimboe>
 <20241210153710.GJZ1hgJpVImYZq47Sv@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241210153710.GJZ1hgJpVImYZq47Sv@fat_crate.local>

On Tue, Dec 10, 2024 at 04:37:10PM +0100, Borislav Petkov wrote:
> > Also it doesn't really make sense to add a printk here as the mitigation
> > will be printed at the end of the function.
> 
> This is us letting the user know that we don't need Safe-RET anymore and we're
> falling back. But I'm not that hung up on that printk...

The printk makes sense when it's actually a fallback from
"spec_rstack_overflow=safe-ret", but if nothing was specified on the
cmdline, it's the default rather than a fallback.  In which case I think
the printk would be confusing.

-- 
Josh

