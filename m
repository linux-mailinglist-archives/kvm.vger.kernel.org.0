Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4CF1B84D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfEMO1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:27:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:33359 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfEMO1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:27:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 07:27:43 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 13 May 2019 07:27:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 489FE2B1; Mon, 13 May 2019 17:27:39 +0300 (EEST)
Date:   Mon, 13 May 2019 17:27:39 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 03/62] mm/ksm: Do not merge pages with different
 KeyIDs
Message-ID: <20190513142739.7v3cnrnnnsdldcuc@black.fi.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-4-kirill.shutemov@linux.intel.com>
 <1697adad-6ae2-ea85-bab5-0144929ed2d9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1697adad-6ae2-ea85-bab5-0144929ed2d9@intel.com>
User-Agent: NeoMutt/20170714-126-deb55f (1.8.3)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 10, 2019 at 06:07:11PM +0000, Dave Hansen wrote:
> On 5/8/19 7:43 AM, Kirill A. Shutemov wrote:
> > KeyID indicates what key to use to encrypt and decrypt page's content.
> > Depending on the implementation a cipher text may be tied to physical
> > address of the page. It means that pages with an identical plain text
> > would appear different if KSM would look at a cipher text. It effectively
> > disables KSM for encrypted pages.
> > 
> > In addition, some implementations may not allow to read cipher text at all.
> > 
> > KSM compares plain text instead (transparently to KSM code).
> > 
> > But we still need to make sure that pages with identical plain text will
> > not be merged together if they are encrypted with different keys.
> > 
> > To make it work kernel only allows merging pages with the same KeyID.
> > The approach guarantees that the merged page can be read by all users.
> 
> I can't really parse this description.  Can I suggest replacement text?

Sure.

-- 
 Kirill A. Shutemov
