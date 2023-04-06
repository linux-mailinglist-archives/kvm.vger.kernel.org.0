Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2226D93C0
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 12:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbjDFKNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 06:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjDFKNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 06:13:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34EA1BEE;
        Thu,  6 Apr 2023 03:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CkCmdI68hl7tqOYPVxzlTuZiemQmaaXkA5K7G5Zo23g=; b=bLBR8k/fiimH18GdvAK15UFk2n
        RdbZtfnnmrpjkx3/efwT2ilztUUfLNu7O05bZEkagyZ7dm43Daqk1db6i9NxH7qqc+9jmuyW4LBWI
        u8EOPfr0ht52oBOwc0MncaH2CmcA5YYHdfH+9uuFONUoSViH6Zf/sYRg0I23vn8TPdzMocULRxivE
        oIh0CJauUv/acqC6Jo+Ww2/2sn1wkeFvvv6kbTRU8PzApzUNiNCfQPW6q5EK8CNAX1xaX2MPxuAeV
        yzygMk1HuHFY4+rojbbqGz9p40RUwPF1u6hDjA37hYoJj96Ib9ftqJaBJ174AAmptbOhUkSfl9iQD
        PlSr+s+g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pkMby-00AUhW-0c;
        Thu, 06 Apr 2023 10:12:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C919C300194;
        Thu,  6 Apr 2023 12:12:54 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4E4D720B6A7D6; Thu,  6 Apr 2023 12:12:54 +0200 (CEST)
Date:   Thu, 6 Apr 2023 12:12:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org
Subject: Re: [RFC PATCH 0/7] x86/entry: Atomic statck switching for IST
Message-ID: <20230406101254.GI386572@hirez.programming.kicks-ass.net>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <19035c40-e756-6efd-1c02-b09109fb44c1@intel.com>
 <CAJhGHyBHmC=UXr88GsykO9eUeqJZp59jrCH3ngkFiCxVBW2F3g@mail.gmail.com>
 <3591487f-96ae-3ab7-6ce7-e524a070c9e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3591487f-96ae-3ab7-6ce7-e524a070c9e7@redhat.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 07:03:45PM +0200, Paolo Bonzini wrote:
> On 4/4/23 05:17, Lai Jiangshan wrote:
> > The cover letter has 800+ lines of comments.  About 100-300 lines
> > of comments will be moved into the code which would make the diffstat
> > not so appealing.
> 
> Removing assembly from arch/x86/entry/ and adding English to Documentation/?
> That's _even more_ appealing. :)

I *much* prefer in-code comments to random gibberish that's instantly
out of date squirreled away somewhere in an unreadable format in
Documentation/
