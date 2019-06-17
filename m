Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B554801E
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfFQLBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:01:44 -0400
Received: from mga04.intel.com ([192.55.52.120]:11211 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbfFQLBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:01:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 04:01:43 -0700
X-ExtLoop1: 1
Received: from khuang2-desk.gar.corp.intel.com ([10.255.91.82])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jun 2019 04:01:39 -0700
Message-ID: <1560769298.5187.16.camel@linux.intel.com>
Subject: Re: [PATCH, RFC 20/62] mm/page_ext: Export lookup_page_ext() symbol
From:   Kai Huang <kai.huang@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 17 Jun 2019 23:01:38 +1200
In-Reply-To: <20190617093054.GB3419@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
         <20190508144422.13171-21-kirill.shutemov@linux.intel.com>
         <20190614111259.GA3436@hirez.programming.kicks-ass.net>
         <20190614224443.qmqolaigu5wnf75p@box>
         <20190617093054.GB3419@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-06-17 at 11:30 +0200, Peter Zijlstra wrote:
> On Sat, Jun 15, 2019 at 01:44:43AM +0300, Kirill A. Shutemov wrote:
> > On Fri, Jun 14, 2019 at 01:12:59PM +0200, Peter Zijlstra wrote:
> > > On Wed, May 08, 2019 at 05:43:40PM +0300, Kirill A. Shutemov wrote:
> > > > page_keyid() is inline funcation that uses lookup_page_ext(). KVM is
> > > > going to use page_keyid() and since KVM can be built as a module
> > > > lookup_page_ext() has to be exported.
> > > 
> > > I _really_ hate having to export world+dog for KVM. This one might not
> > > be a real issue, but I itch every time I see an export for KVM these
> > > days.
> > 
> > Is there any better way? Do we need to invent EXPORT_SYMBOL_KVM()? :P
> 
> Or disallow KVM (or parts thereof) from being a module anymore.

For this particular symbol expose, I don't think its fair to blame KVM since the fundamental reason
is because page_keyid() (which calls lookup_page_ext()) being implemented as static inline function
in header file, so essentially having any other module who calls page_keyid() will trigger this
problem -- in fact IOMMU driver calls page_keyid() too so even w/o KVM lookup_page_ext() needs to be
exposed.

Thanks,
-Kai
