Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63DBC45C75
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 14:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfFNMPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 08:15:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38208 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfFNMPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 08:15:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4508jy29+aun7N2LGIzBHEHdPpOHU7DfASwN5eoEnJ0=; b=znSzzWUDWHtxTeSgjW/Fm4G9b
        I0fEYjCe6xbhDAdqQtncGNa7JPgPEedhGzQZEmkIJUL0jsptzXyvy/BM7k+T2GipSP5waiKTIz4cp
        FdK4P3MeaT9AODHnmT90Abzm+kAOhgPUSMxh5fFPrRDGUtSAlguTcAc6N/onnUBjsQCcgNm27oU7M
        oJC+jqsSKBHSg4/lQ5lvGNvKBDQa+ZYvQ2XYniMOnwc9/JiksBCPrd1dx0Z+MLEIcRMVIuGtFOSRI
        rSu0GIJ8PDZaiYJzZD9mXB6ZSPNeTG+fp/ksjm6PY/z69c2wRCwth07eu0Ff4g0l/rE9yCGsMPSuE
        GcTXZV0aQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbl6z-0007bG-Ai; Fri, 14 Jun 2019 12:15:17 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0A24120A29B57; Fri, 14 Jun 2019 14:15:15 +0200 (CEST)
Date:   Fri, 14 Jun 2019 14:15:14 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 00/62] Intel MKTME enabling
Message-ID: <20190614121514.GK3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:43:20PM +0300, Kirill A. Shutemov wrote:
> = Intro =
> 
> The patchset brings enabling of Intel Multi-Key Total Memory Encryption.
> It consists of changes into multiple subsystems:
> 
>  * Core MM: infrastructure for allocation pages, dealing with encrypted VMAs
>    and providing API setup encrypted mappings.

That wasn't eye-bleeding bad. With exception of the refcounting; that
looks like something that can easily go funny without people noticing.

>  * arch/x86: feature enumeration, program keys into hardware, setup
>    page table entries for encrypted pages and more.

That seemed incomplete (pageattr seems to be a giant hole).

>  * Key management service: setup and management of encryption keys.
>  * DMA/IOMMU: dealing with encrypted memory on IO side.

Just minor nits, someone else would have to look at this.

>  * KVM: interaction with virtualization side.

You really want to limit the damage random modules can do. They have no
business writing to the mktme variables.

>  * Documentation: description of APIs and usage examples.

Didn't bother with those; if the Changelogs are inadequate to make sense
of the patches documentation isn't the right place to fix things.

> The patchset is huge. This submission aims to give view to the full picture and
> get feedback on the overall design. The patchset will be split into more
> digestible pieces later.
> 
> Please review. Any feedback is welcome.

I still can't tell if this is worth the complexity :-/

Yes, there's a lot of words, but it doesn't mean anything to me, that
is, nothing here makes me want to build my kernel with this 'feature'
enabled.


