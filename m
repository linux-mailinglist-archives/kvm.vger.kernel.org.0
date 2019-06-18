Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AB449CC5
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 11:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbfFRJNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 05:13:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44450 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbfFRJNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 05:13:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DWxebD/lbygK+SpH9wnfp4x77thiB2bg6Ri9elX25UY=; b=uDQHwhGWJGqiGNlXRpc+k6mqb
        T/OhF+fKkE9yW/1WzX5e5PKNLbvQaIEV8hjfnN19Gcy2xbw/eGs9cmZhzSw8M/dic5nZDgqvtKokl
        Z6IMT2orRt1vL693hdvgisFLg0TYANLGdUAijz81Pu4wz3x0lSGQAtPaTZFsOA3d0MjysgSP50m5E
        +nJQ6NHn87W710nEgSyxyCcyTiUu4cDdwAom6SIAGU5SekK6vxRPBlyjW5sJFJL7Mkjzt7B4keKc9
        AEvw9JywQnLYrUBl+qghSJmrCZU8ZheGjH9rfN0/npezev7TcMgM94jN8FuanvHBJWWzT4IP6ikYK
        aDaVJhvRA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdAAZ-0000dX-Pu; Tue, 18 Jun 2019 09:12:48 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7778620A3C471; Tue, 18 Jun 2019 11:12:46 +0200 (CEST)
Date:   Tue, 18 Jun 2019 11:12:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Linux-MM <linux-mm@kvack.org>, kvm list <kvm@vger.kernel.org>,
        keyrings@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call
 for MKTME
Message-ID: <20190618091246.GM3436@hirez.programming.kicks-ass.net>
References: <CALCETrVCdp4LyCasvGkc0+S6fvS+dna=_ytLdDPuD2xeAr5c-w@mail.gmail.com>
 <3c658cce-7b7e-7d45-59a0-e17dae986713@intel.com>
 <CALCETrUPSv4Xae3iO+2i_HecJLfx4mqFfmtfp+cwBdab8JUZrg@mail.gmail.com>
 <5cbfa2da-ba2e-ed91-d0e8-add67753fc12@intel.com>
 <CALCETrWFXSndmPH0OH4DVVrAyPEeKUUfNwo_9CxO-3xy9awq0g@mail.gmail.com>
 <1560816342.5187.63.camel@linux.intel.com>
 <CALCETrVcrPYUUVdgnPZojhJLgEhKv5gNqnT6u2nFVBAZprcs5g@mail.gmail.com>
 <1560821746.5187.82.camel@linux.intel.com>
 <CALCETrUrFTFGhRMuNLxD9G9=GsR6U-THWn4AtminR_HU-nBj+Q@mail.gmail.com>
 <1560824611.5187.100.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560824611.5187.100.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 18, 2019 at 02:23:31PM +1200, Kai Huang wrote:
> Assuming I am understanding the context correctly, yes from this perspective it seems having
> sys_encrypt is annoying, and having ENCRYPT_ME should be better. But Dave said "nobody is going to
> do what you suggest in the ptr1/ptr2 example"? 

You have to phrase that as: 'nobody who knows what he's doing is going
to do that', which leaves lots of people and fuzzers.

Murphy states that if it is possible, someone _will_ do it. And this
being something that causes severe data corruption on persistent
storage,...
