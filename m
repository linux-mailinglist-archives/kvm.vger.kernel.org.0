Return-Path: <kvm+bounces-43401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBFEFA8B2B1
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 09:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78A6F1899A96
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 07:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8522922E414;
	Wed, 16 Apr 2025 07:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V6ESEMQL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9726C189B9D;
	Wed, 16 Apr 2025 07:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744789919; cv=none; b=Nkl8+HoFcB8bMqDo0iS+It4gIAgoebvBOEK9ST3KpsLZAdeO95GkWfrsQlgrKN7L43wtO34mQgmVdG8sWqj8OBaz2upxBpi/7S2o0r1Gq7nlQzkMLibBhQBnkfz/Ns7r+YlvwW3BAaakYknZFUnw0vWj7Srzt1pUnIBDz9koZt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744789919; c=relaxed/simple;
	bh=iLOvCfHAlkl2qqlJ2x0ADYafFrSh4AKEbA4z06zylDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JT2SlWTkFl+7Z0e1tsU29H9NyjwxLvJLCzq1TiB0cptbf0RTKxE09tUtoQ7jhigW2vrYYcLicjN1cXq2dqRCnXtsbFRTTwMYgodeIMKILxQ3eZSI8cgdzavrHeqSHhYuDIzFbq1VxsKZgfVnadni693y0qrm1Lz/rBj4WKrU9gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V6ESEMQL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D5EC4CEE9;
	Wed, 16 Apr 2025 07:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744789919;
	bh=iLOvCfHAlkl2qqlJ2x0ADYafFrSh4AKEbA4z06zylDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V6ESEMQLt+0taO4/Ie3NZ0+cQyX6mhGocswhyaFyACEDvXDIzhQGzVKIZFdWfr+54
	 AJYH/jMu7t1K5H1Ajgo7XDOjV/lITEXcrzttJagShpyrQSXK4ZkH2XZDcAX5SFOcbU
	 2+HZpqxN9gyfWKnxqyS6+7H3XwjPSQOTHcpa87GFIoFaCgBO5t3UDuUdouG3REE93g
	 x+cd/NSh3FQAFdx4K+xqqj7syyG9js7QC2QUmmeH1eAus8LE3JGvICdMkZ6W5vQt+y
	 ztoellq8oR4pUh2xuhvYn0MGroaTPgpbRoUbvmnlNkxrJAO4m1bZL+hcOFv8rfGIVQ
	 2PAw602YCZq7w==
Date: Wed, 16 Apr 2025 09:51:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-tip-commits@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
	Andy Shevchenko <andy@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/e820: Discard high memory that can't be
 addressed by 32-bit systems
Message-ID: <Z_9hmdMTP3wpB3Cc@gmail.com>
References: <20250413080858.743221-1-rppt@kernel.org>
 <174453620439.31282.5525507256376485910.tip-bot2@tip-bot2>
 <a641e123-be70-41ab-b0ce-6710d7fd0c2d@intel.com>
 <Z_4ISTuGo8VmZt9X@kernel.org>
 <c811f662-79fd-4db1-b4e1-74a869d9a4f1@intel.com>
 <Z_9ZblhCgEeTgGQ8@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z_9ZblhCgEeTgGQ8@gmail.com>


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Dave Hansen <dave.hansen@intel.com> wrote:
> 
> > On 4/15/25 00:18, Mike Rapoport wrote:
> > >> How about we reuse 'MAX_NONPAE_PFN' like this:
> > >>
> > >> 	if (IS_ENABLED(CONFIG_X86_32))
> > >> 		memblock_remove(PFN_PHYS(MAX_NONPAE_PFN), -1);
> > >>
> > >> Would that make the connection more obvious?
> > > Yes, that's better. Here's the updated patch:
> > 
> > Looks, great. Thanks for the update and the quick turnaround on the
> > first one after the bug report!
> > 
> > Tested-by: Dave Hansen <dave.hansen@intel.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> 
> I've amended the fix in tip:x86/urgent accordingly and added your tags, 
> thanks!

So I had to apply the fix below as well, due to this build failure on 
x86-defconfig:

  arch/x86/kernel/e820.c:1307:42: error: ‘MAX_NONPAE_PFN’ undeclared (first use in this function); did you mean ‘MAX_DMA_PFN’?

IS_ENABLED(CONFIG_X86_32) can only be used when the code is 
syntactically correct on !CONFIG_X86_32 kernels too - which it wasn't.

So I went for the straightforward #ifdef block instead.

Thanks,

	Ingo

===========>
 arch/x86/kernel/e820.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index de6238886cb2..c984be8ee060 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1299,13 +1299,14 @@ void __init e820__memblock_setup(void)
 		memblock_add(entry->addr, entry->size);
 	}
 
+#ifdef CONFIG_X86_32
 	/*
 	 * Discard memory above 4GB because 32-bit systems are limited to 4GB
 	 * of memory even with HIGHMEM.
 	 */
-	if (IS_ENABLED(CONFIG_X86_32))
-		memblock_remove(PFN_PHYS(MAX_NONPAE_PFN), -1);
+	memblock_remove(PFN_PHYS(MAX_NONPAE_PFN), -1);
+#endif
 
 	/* Throw away partial pages: */
 	memblock_trim_memory(PAGE_SIZE);

