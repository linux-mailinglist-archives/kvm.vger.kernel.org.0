Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8F64966E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 02:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfFRAs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 20:48:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:15204 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfFRAs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 20:48:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 17:48:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,386,1557212400"; 
   d="scan'208";a="185930070"
Received: from khuang2-desk.gar.corp.intel.com ([10.255.91.82])
  by fmsmga002.fm.intel.com with ESMTP; 17 Jun 2019 17:48:52 -0700
Message-ID: <1560818931.5187.70.camel@linux.intel.com>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call
 for MKTME
From:   Kai Huang <kai.huang@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kvm list <kvm@vger.kernel.org>,
        keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Tue, 18 Jun 2019 12:48:51 +1200
In-Reply-To: <d599b1d7-9455-3012-0115-96ddbad31833@intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
         <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
         <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
         <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
         <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
         <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
         <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
         <d599b1d7-9455-3012-0115-96ddbad31833@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
> > And another silly argument: if we had /dev/mktme, then we could
> > possibly get away with avoiding all the keyring stuff entirely.
> > Instead, you open /dev/mktme and you get your own key under the hook.
> > If you want two keys, you open /dev/mktme twice.  If you want some
> > other program to be able to see your memory, you pass it the fd.
> 
> We still like the keyring because it's one-stop-shopping as the place
> that *owns* the hardware KeyID slots.  Those are global resources and
> scream for a single global place to allocate and manage them.  The
> hardware slots also need to be shared between any anonymous and
> file-based users, no matter what the APIs for the anonymous side.

MKTME driver (who creates /dev/mktme) can also be the one-stop-shopping. I think whether to choose
keyring to manage MKTME key should be based on whether we need/should take advantage of existing key
retention service functionalities. For example, with key retention service we can
revoke/invalidate/set expiry for a key (not sure whether MKTME needs those although), and we have
several keyrings -- thread specific keyring, process specific keyring, user specific keyring, etc,
thus we can control who can/cannot find the key, etc. I think managing MKTME key in MKTME driver
doesn't have those advantages.

Thanks,
-Kai
