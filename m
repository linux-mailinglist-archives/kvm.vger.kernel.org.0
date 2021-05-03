Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF49371784
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhECPIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhECPI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 11:08:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39E1C06174A;
        Mon,  3 May 2021 08:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kMx7dObqmiMRLKvCPPx5dZSO2/TSonq0GivO88n9Dnw=; b=RTzFX22TzavsuLNPyHWsd2y00w
        cF7Q/aaqJCVid9CI0gOoHuVkJsFTBbZj+lTPkVmRBQuzkNZYpJG9sXa/4C5amfoRCfYEaoMelXezF
        C0YeOyS2NPjqv9FtF+HlWKZgFNAC6y4cUT4Dth+3fQbFuNHOkJu3qze9TWiODLDmQVdOmH+q7Fnwe
        4VInMB/ACCoVu9GXHTNkiuuMBbcoDG8s/XN1fO8sY15E1lODTIA3YXke6rzgpeM5r3GSOHg4dLvuK
        Me1nm5M0fRzPZ9A2SFF0T9D0zvnBPeANCBMBIQX4m+RiZFxcbxM7QZpJnXNrmLIlNuqCtNrLMG0LX
        k3rHcIew==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ldaAH-00EBCq-9l; Mon, 03 May 2021 15:07:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DFF893001D0;
        Mon,  3 May 2021 17:07:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 61FAF2C1AAE0C; Mon,  3 May 2021 17:07:15 +0200 (CEST)
Date:   Mon, 3 May 2021 17:07:15 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 08/37] x86/sev: Split the physmap when
 adding the page in RMP table
Message-ID: <YJARo9vpAgb6VmLI@hirez.programming.kicks-ass.net>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-9-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430123822.13825-9-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:37:53AM -0500, Brijesh Singh wrote:

> This poses a challenge in the Linux memory model. The Linux kernel
> creates a direct mapping of all the physical memory -- referred to as
> the physmap. The physmap may contain a valid mapping of guest owned pages.
> During the page table walk, the host access may get into the situation where
> one of the pages within the large page is owned by the guest (i.e assigned
> bit is set in RMP). A write to a non-guest within the large page will
> raise an RMP violation. To workaround it, call set_memory_4k() to split
> the physmap before adding the page in the RMP table. This ensures that the
> pages added in the RMP table are used as 4K in the physmap.

What's an RMP violation and why are they a problem?

> The spliting of the physmap is a temporary solution until the kernel page
> fault handler is improved to split the kernel address on demand.

How is that an improvement? Fracturing the physmap sucks whichever way
around.

> One of the
> disadvtange of splitting is that eventually, it will end up breaking down
> the entire physmap unless its coalesce back to a large page. I am open to
> the suggestation on various approaches we could take to address this problem.

Have the hardware fracture the TLB entry internally?
