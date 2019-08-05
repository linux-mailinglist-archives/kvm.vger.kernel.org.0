Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB0668260E
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 22:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbfHEUaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 16:30:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:37312 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfHEUaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 16:30:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 13:30:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="198086880"
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by fmsmga004.fm.intel.com with ESMTP; 05 Aug 2019 13:30:15 -0700
Date:   Mon, 5 Aug 2019 13:31:02 -0700
From:   Alison Schofield <alison.schofield@intel.com>
To:     Ben Boeckel <mathstuf@gmail.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCHv2 25/59] keys/mktme: Preparse the MKTME key payload
Message-ID: <20190805203102.GA7592@alison-desk.jf.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
 <20190731150813.26289-26-kirill.shutemov@linux.intel.com>
 <20190805115819.GA31656@rotor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805115819.GA31656@rotor>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 05, 2019 at 07:58:19AM -0400, Ben Boeckel wrote:
> On Wed, Jul 31, 2019 at 18:07:39 +0300, Kirill A. Shutemov wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > +/* Make sure arguments are correct for the TYPE of key requested */
> > +static int mktme_check_options(u32 *payload, unsigned long token_mask,
> > +			       enum mktme_type type, enum mktme_alg alg)
> > +{
> > +	if (!token_mask)
> > +		return -EINVAL;
> > +
> > +	switch (type) {
> > +	case MKTME_TYPE_CPU:
> > +		if (test_bit(OPT_ALGORITHM, &token_mask))
> > +			*payload |= (1 << alg) << 8;
> > +		else
> > +			return -EINVAL;
> > +
> > +		*payload |= MKTME_KEYID_SET_KEY_RANDOM;
> > +		break;
> > +
> > +	case MKTME_TYPE_NO_ENCRYPT:
		if (test_bit(OPT_ALGORITHM, &token_mask))
			return -EINVAL;
> > +		*payload |= MKTME_KEYID_NO_ENCRYPT;
> > +		break;
> 
> The documentation states that for `type=no-encrypt`, algorithm must not
> be specified at all. Where is that checked?
> 
> --Ben
It's not currently checked, but should be. 
I'll add it as shown above.
Thanks for the review,
Alison

