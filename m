Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30C745E26
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfFNN2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 09:28:39 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45931 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbfFNN2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 09:28:38 -0400
Received: by mail-ed1-f65.google.com with SMTP id a14so3471966edv.12
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 06:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/bEFMtHnd0Lq4R6BgJaHDb9jSNJdzL1pBjuE2g5cik8=;
        b=voy0OQVzAPCvIAmwQgiYtlSleenOKuT/qpb01Z/+4pGuPKe1skxIJEkKDPpwS9HC3H
         d2duEeopfKNnnkQCjYrCgqImAQqW5bLMgwugLa222v0jda83+go22NOjY5PWaEnTSvyV
         KLhBwBJPS7SZJtXCtxB7OvQQqgSQ3kPKWmFUA1MJa9Wrfld0MCSAXdHUdWfClFnEwpgf
         sOPE6zcJmB0iiUGNc4akPixQ19M5SCYisvcVkA0vU6UsVVet+GzmRtabFV//WJ5mNMyj
         qJmJDuvP10aBanhB/RZD0uRXen4zbe9eWcwwuargF/sjpjd9dhGMdU11acHxnHjo9xUZ
         o5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/bEFMtHnd0Lq4R6BgJaHDb9jSNJdzL1pBjuE2g5cik8=;
        b=Hs7vgwVNqG+wtzP39nGbRamqVV2c5m292aDaw1gwwfqzMNTufjArnejwIdtGf88ZUD
         kL59ZkoCxulcUb92zPKP1vwp/0Mx5TaPEw8e/MwYJDxS9ETAjnjkZDA8nImmT3hdXHFt
         50UlC3cQ/g1nOGWHV+yvpTvlBWWw7oLj82SmSEBtLl7toOXmANLrM52ZDNgD1hYzrH85
         GlsretQZPTXlqe6PWHA14H4NBy0dICr/Un4BzEJwfdhv5SHxCqozumESwWzGhblZc6BT
         2bL0WCatai6RAcWgux9qdNGB+L5DpzVDv2XT55ykpehp/ItuDOkKo0AjlDOB5e82UaA7
         WUpw==
X-Gm-Message-State: APjAAAUrYzRxohkVTcrA7ny4cpbQ/MIdxeCyNlzbIB+QCUrDJaEuQpWJ
        4y2KR6xxK5YHPC4+mMbTJEf1Bg==
X-Google-Smtp-Source: APXvYqwTjBWiaWugHv92n/VOXJckmXdJ0ij79tTSCt3WN5QrjcsRYX/bfqnOjwWa25VDWFa14JeAyw==
X-Received: by 2002:a50:b178:: with SMTP id l53mr75879420edd.244.1560518916776;
        Fri, 14 Jun 2019 06:28:36 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id 34sm901697eds.5.2019.06.14.06.28.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 06:28:36 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 8857010086F; Fri, 14 Jun 2019 16:28:36 +0300 (+03)
Date:   Fri, 14 Jun 2019 16:28:36 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
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
Subject: Re: [PATCH, RFC 13/62] x86/mm: Add hooks to allocate and free
 encrypted pages
Message-ID: <20190614132836.spl6bmk2kkx65nfr@box>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-14-kirill.shutemov@linux.intel.com>
 <20190614093409.GX3436@hirez.programming.kicks-ass.net>
 <20190614110458.GN3463@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614110458.GN3463@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 14, 2019 at 01:04:58PM +0200, Peter Zijlstra wrote:
> On Fri, Jun 14, 2019 at 11:34:09AM +0200, Peter Zijlstra wrote:
> > On Wed, May 08, 2019 at 05:43:33PM +0300, Kirill A. Shutemov wrote:
> > 
> > > +		lookup_page_ext(page)->keyid = keyid;
> 
> > > +		lookup_page_ext(page)->keyid = 0;
> 
> Also, perhaps paranoid; but do we want something like:
> 
> static inline void page_set_keyid(struct page *page, int keyid)
> {
> 	/* ensure nothing creeps after changing the keyid */
> 	barrier();
> 	WRITE_ONCE(lookup_page_ext(page)->keyid, keyid);
> 	barrier();
> 	/* ensure nothing creeps before changing the keyid */
> }
> 
> And this is very much assuming there is no concurrency through the
> allocator locks.

There's no concurrency for this page: it has been off the free list, but
have not yet passed on to user. Nobody else sees the page before
allocation is finished.

And barriers/WRITE_ONCE() looks excessive to me. It's just yet another bit
of page's metadata and I don't see why it's has to be handled in a special
way.

Does it relax your paranoia? :P

-- 
 Kirill A. Shutemov
