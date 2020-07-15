Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6D42208A5
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 11:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgGOJZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 05:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729672AbgGOJZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 05:25:22 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F65C061755;
        Wed, 15 Jul 2020 02:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dK8UwzUTgUNLePBN/9TrjpAB3tyGtmDfMqWT0SbBnEY=; b=SYThOw0DKQ59j+xOZ9e7s9giuM
        tDfpXRj67AxyxcDD/DruSpiV3lLLocgumIGHcor3cLJvMbB67U/P86WHzwLBDWnMM7/VE7d5DilUf
        4YM2HlWFCuP5zJIWETM4zuvR53OwsBKsLKMox2dndow+qB3qgoNDTu5XP018d/PmLoVEQc1+4SV8H
        EWEbQpfJpVa6/+Ui67qnx6GgCoPLKU0raNxCb0U6Ww2OCVdoVtagwaYzi4qgDr5u/1i9S5Ss2tK9y
        XIbatbd4Y1yNWkVo40PSHRKeEh/tlULCWSefU7V9Uf0In+2TOyvTgUB9j1R0/FONOEmAyGtW0Sf5P
        TNZ6ff8Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvdeu-0001jJ-Bk; Wed, 15 Jul 2020 09:25:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4FE7C305B23;
        Wed, 15 Jul 2020 11:24:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 438C6207A6655; Wed, 15 Jul 2020 11:24:56 +0200 (CEST)
Date:   Wed, 15 Jul 2020 11:24:56 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 00/75] x86: SEV-ES Guest Support
Message-ID: <20200715092456.GE10769@hirez.programming.kicks-ass.net>
References: <20200714120917.11253-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:02PM +0200, Joerg Roedel wrote:
> The #VC entry code now tries to pretend that the #VC handler does not
> use an IST stack by switching to the task stack if entered from
> user-mode or the SYSCALL entry path. When it is entered from
> kernel-mode it is doing its best to switch back to the interrupted
> stack. This is only possible if it is entered from a known and safe
> kernel stack (e.g. not the entry stack). If the previous stack is not
> safe to use the #VC handler switches to a fall-back stack and calls a
> special handler function which, as of now, just panics the system. For
> now this is safe as #VC exceptions only happen at know places which
> use a safe stack.
> 
> The use of the fall-back stack is necessary so that the special
> handler function can safely raise nested #VC exceptions, for
> example to print a panic message.

Can we get some more words -- preferably in actual code comments, on
when exactly #VC happens?

Because the only thing I remember is that #VC could happen on any memop,
but I also have vague memories of that being a later extention.
