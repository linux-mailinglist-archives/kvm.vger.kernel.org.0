Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D2066F2F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 14:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfGLMvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 08:51:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54928 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfGLMvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 08:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rwpolTjZGqbTjwkLH0mAAIVI9rPZBe7E59f4u4dvndk=; b=M2dP09VMp056HkHzjt4KD8h0P
        pj6x6MKN2KDyASTibms8pAubzJ1mr3Q41T5d9AbtwAdaZ7h5k8x3fIJL+eT7wXHVf4JC6fk9HXPkd
        Dl+vY4CxPI7HGeG5FRxCOoZOf+vS0SugPI9EnN3u5EEH+KgIrWyeM9oITXrkmbUl2JrcbiL8X0hip
        zWBcCskL2lMgRkYMZhT0e0cE6dgndhjznxtrzxudGf5lkhjjHKJGRS2R9TnhQ7woa9LpARKBL13k+
        6O5AuHeVjb4+jADAERfPyUCDygpN1T1I9gL6OaxZnhW7VPjq1virgpae/SjTED2hovlyYB1GQPs3X
        GHeANTbMQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hlv0v-0000Mt-GX; Fri, 12 Jul 2019 12:51:01 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BC3D4209772EE; Fri, 12 Jul 2019 14:50:59 +0200 (CEST)
Date:   Fri, 12 Jul 2019 14:50:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
Message-ID: <20190712125059.GP3419@hirez.programming.kicks-ass.net>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
 <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
 <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 01:56:44PM +0200, Alexandre Chartre wrote:

> I think that's precisely what makes ASI and PTI different and independent.
> PTI is just about switching between userland and kernel page-tables, while
> ASI is about switching page-table inside the kernel. You can have ASI without
> having PTI. You can also use ASI for kernel threads so for code that won't
> be triggered from userland and so which won't involve PTI.

PTI is not mapping         kernel space to avoid             speculation crap (meltdown).
ASI is not mapping part of kernel space to avoid (different) speculation crap (MDS).

See how very similar they are?

Furthermore, to recover SMT for userspace (under MDS) we not only need
core-scheduling but core-scheduling per address space. And ASI was
specifically designed to help mitigate the trainwreck just described.

By explicitly exposing (hopefully harmless) part of the kernel to MDS,
we reduce the part that needs core-scheduling and thus reduce the rate
the SMT siblngs need to sync up/schedule.

But looking at it that way, it makes no sense to retain 3 address
spaces, namely:

  user / kernel exposed / kernel private.

Specifically, it makes no sense to expose part of the kernel through MDS
but not through Meltdow. Therefore we can merge the user and kernel
exposed address spaces.

And then we've fully replaced PTI.

So no, they're not orthogonal.
