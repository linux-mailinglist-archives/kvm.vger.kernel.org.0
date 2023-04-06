Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD166D9719
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 14:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbjDFMis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 08:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDFMir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 08:38:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366CF76A9;
        Thu,  6 Apr 2023 05:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6G0PeHjBucaMpcTqS+MbmLttXP4X+8vdHS54iSMHEkE=; b=pocCnMFjveWReclFnOvNIHXaFy
        3GrG9RU1yLbNQTlpqnucYYV6Vo765+4G1vrs+PrS2z6+TblszZYRJ0sAu9sAolqPHY8Tp8KAhAx4r
        oiWVOzNoX/o/MUudT1aKAAs0W8mSmuV5tz0uUB76tbxk8uF8Dc6OZ728w1kpE3i8o+u/GJAXDJYtC
        oVXXOKLTsGSCzdjzmTQbivx8VQ2VymC+L+sxhHMvJd6L4TX5oxAtAITYIbtut0ZzqL2LVmIkmxa2U
        3PUdMvlbPRNC9SfEdWT8zsC2K/IBJQQxdtLcWHsBft4T43Qj0OBiFHHMshHhOO5qBZIAb4+XkKIh5
        Vf6HDY5A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pkOsI-00HPw3-BW; Thu, 06 Apr 2023 12:37:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 11D04300194;
        Thu,  6 Apr 2023 14:37:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 903182CB641A9; Thu,  6 Apr 2023 14:37:55 +0200 (CEST)
Date:   Thu, 6 Apr 2023 14:37:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
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
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <20230406123755.GC392176@hirez.programming.kicks-ass.net>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <19035c40-e756-6efd-1c02-b09109fb44c1@intel.com>
 <CAJhGHyBHmC=UXr88GsykO9eUeqJZp59jrCH3ngkFiCxVBW2F3g@mail.gmail.com>
 <3591487f-96ae-3ab7-6ce7-e524a070c9e7@redhat.com>
 <20230406101254.GI386572@hirez.programming.kicks-ass.net>
 <26be2c81-9431-6b43-e3e9-52d7d184750e@kernel.org>
 <20230406104750.GA392176@hirez.programming.kicks-ass.net>
 <be836a4f-fc0f-bbcd-636d-4766fdd33c81@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be836a4f-fc0f-bbcd-636d-4766fdd33c81@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023 at 01:04:16PM +0200, Jiri Slaby wrote:

> Definitely it _can_ defeat the purpose and be heavily formatted.But it
> doesn't have to. It's like programming in perl.
> 
> What I had in mind was e.g. "DOC: TTY Struct Flags":
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/tty.h#n261

 * TTY_THROTTLED
 *	Driver input is throttled. The ldisc should call
 *	:c:member:`tty_driver.unthrottle()` in order to resume reception when
 *	it is ready to process more data (at threshold min).

That whole :c:member:'tty_driver.unthrottle()' is an abomination and
has no place in a comment.

> Resulting in:
> https://www.kernel.org/doc/html/latest/driver-api/tty/tty_struct.html#tty-struct-flags
> 
> Both the source and the result are quite readable, IMO. And the markup in
> the source is not mandatory, it's only for emphasizing and hyperlinks.
> 
> As I wrote, you can link the comment in the code. But definitely you don't
> have to, if you don't want. I like the linking in Documentation as I can put
> the pieces from various sources/headers together to one place and build a
> bigger picture.
> 
> > I really detest that whole RST thing, and my solution is to explicitly
> > not write kerneldoc, that way the doc generation stuff doesn't complain
> > and I don't get random drive by patches wrecking the perfectly readable
> > comment.
> 
> Sure. Rst _sources_ are not readable, IMO. Only generated man pages or html
> are.

But code comments are read in a text editor, not a browser. Hence all
the markup is counter productive.

Why would you go read something in a browser if you have the code right
there in a text editor?
