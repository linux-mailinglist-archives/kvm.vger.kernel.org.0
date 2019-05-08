Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46CD717EA1
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbfEHQ6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 12:58:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48272 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbfEHQ6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 12:58:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=x2WuU/X5fa5tUVfwJobGS2HfWE2m292r4J/u47Wd82s=; b=WvagHzfkLT5uNstZZ33NzU8f4
        hVRF06AuCxJhAWvqiZKox4/2Nfevff1DInfGoORtzQW+kOTzEwOz2D0pN1WsVfq3c0szMFWAsntze
        flir9K6/Xz58geaWHO0lBGR8m/i0p8MjqeGp8pxnONpBNbMwqgXhj60gzgD/nNxjh1sUqYc7evbBi
        amGm5itevVi3gSAVbNmFKXK7tPwhMvTUfCrbQ99DOdeKj2WMEHulKQNkmG2v0IzJib2n4UwagtS2Q
        WJK03LVZfAXQ883EK+5tiBm397uUhr8ew+Rmmq5FzR7mmvyCV4pgMPI+POmu/zHUsi0bEK5DNuY7C
        chf1RE70Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hOPtm-00039J-A2; Wed, 08 May 2019 16:58:30 +0000
Date:   Wed, 8 May 2019 09:58:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 52/62] x86/mm: introduce common code for mem
 encryption
Message-ID: <20190508165830.GA11815@infradead.org>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-53-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-53-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:44:12PM +0300, Kirill A. Shutemov wrote:
> +EXPORT_SYMBOL_GPL(__mem_encrypt_dma_set);
> +
> +phys_addr_t __mem_encrypt_dma_clear(phys_addr_t paddr)
> +{
> +	if (sme_active())
> +		return __sme_clr(paddr);
> +
> +	return paddr & ~mktme_keyid_mask;
> +}
> +EXPORT_SYMBOL_GPL(__mem_encrypt_dma_clear);

In general nothing related to low-level dma address should ever
be exposed to modules.  What is your intended user for these two?
