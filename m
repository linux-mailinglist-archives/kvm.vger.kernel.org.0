Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB10645B9E
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfFNLoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:44:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56532 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbfFNLoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=N2usWe+DF5bPKJZPBYT2JLd/gE3UHs5gaod0EYiWn0I=; b=RU+fVwU0SYHwiXwH3G6btplv7
        94vsmIFwwr6JKRMHE8Vhsf9s3IPtIBAKx3bYr8fllCl7dNM2KjaU2Ck39tgmbkvDsQj9tLDetB/7k
        n8pTUI9EtYfOM5vyiXCkqsn4+lCUBNvcqBpDENJ/5TSplSzFREpI++eQsfzY3W1GhxU1+D8KK3Csd
        ZdIXoyKpcc3MvU/d1a35GmWl6W15jux52vcYY18wyhJbBn9lte1Zdk9V2ot6MDtwmvqZUVEXBwifJ
        Rsc+A4k4vJUkGYzEbn4jotLhBC2vQkoiOPF6BiRXn6iIMcaaM+IXMl4ahCy7+hlaNyO0xvo6roEMl
        GU/cB+sbg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbkcs-0005tV-Fc; Fri, 14 Jun 2019 11:44:11 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D3C9020A15636; Fri, 14 Jun 2019 13:44:08 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:44:08 +0200
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
Subject: Re: [PATCH, RFC 44/62] x86/mm: Set KeyIDs in encrypted VMAs for MKTME
Message-ID: <20190614114408.GD3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-45-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-45-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:44:04PM +0300, Kirill A. Shutemov wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> MKTME architecture requires the KeyID to be placed in PTE bits 51:46.
> To create an encrypted VMA, place the KeyID in the upper bits of
> vm_page_prot that matches the position of those PTE bits.
> 
> When the VMA is assigned a KeyID it is always considered a KeyID
> change. The VMA is either going from not encrypted to encrypted,
> or from encrypted with any KeyID to encrypted with any other KeyID.
> To make the change safely, remove the user pages held by the VMA
> and unlink the VMA's anonymous chain.

This does not look like a transformation that preserves content; is
mprotect() still a suitable name?
