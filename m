Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDE37BEF78
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 02:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379131AbjJJAJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 20:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377918AbjJJAJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 20:09:13 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF463A4;
        Mon,  9 Oct 2023 17:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n9xu3Z/aqGuYgnlZo2/hESvC9ySythWvvumkFQkDfT0=; b=XIqUa65uMPROPoc4TABSmUZlQX
        HgrnM9BAh0IwmOaqbe9PO+nenWlwimlzXtYXOGsoLx6PpeJFi8rIt2/4XH1AoGFo1SxgOYDk1VWeg
        HQ77KAcQR+QCnqr2aUsBZe0indo6PmGBo4srGu1m2kblgCFQ9ZjX0BPbsiUAWdc2cPisI4T1FLo1q
        559gXGApBNxEXekxl5Cu5BUk0yeo2999kdjhEwsId8XxGoW8qIIZzbuj5n+guDBfUHZN5rXSZnpti
        RW00SDreI0ApchZ8/TuRyLsvdlzV6HNIq97UA7oJverC5ejAc8gmmdyJnVr1HZHDaen9UqirfZdg8
        Ata5QWjA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qq0JC-00HLiS-27;
        Tue, 10 Oct 2023 00:09:10 +0000
Date:   Tue, 10 Oct 2023 01:09:10 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Message-ID: <20231010000910.GM800259@ZenIV>
References: <20230928180651.1525674-1-pbonzini@redhat.com>
 <169595365500.1386813.6579237770749312873.b4-ty@google.com>
 <20231009022248.GD800259@ZenIV>
 <ZSQO4fHaAxDkbGyz@google.com>
 <20231009200608.GJ800259@ZenIV>
 <ZSRgdgQe3fseEQpf@google.com>
 <20231009204037.GK800259@ZenIV>
 <ZSRwDItBbsn2IfWl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSRwDItBbsn2IfWl@google.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 02:26:36PM -0700, Sean Christopherson wrote:
> On Mon, Oct 09, 2023, Al Viro wrote:
> > On Mon, Oct 09, 2023 at 01:20:06PM -0700, Sean Christopherson wrote:
> > > On Mon, Oct 09, 2023, Al Viro wrote:
> > > > On Mon, Oct 09, 2023 at 07:32:48AM -0700, Sean Christopherson wrote:
> > > > 
> > > > > Yeah, we found that out the hard way.  Is using the "secure" variant to get a
> > > > > per-file inode a sane approach, or is that abuse that's going to bite us too?
> > > > > 
> > > > > 	/*
> > > > > 	 * Use the so called "secure" variant, which creates a unique inode
> > > > > 	 * instead of reusing a single inode.  Each guest_memfd instance needs
> > > > > 	 * its own inode to track the size, flags, etc.
> > > > > 	 */
> > > > > 	file = anon_inode_getfile_secure(anon_name, &kvm_gmem_fops, gmem,
> > > > > 					 O_RDWR, NULL);
> > > > 
> > > > Umm...  Is there any chance that your call site will ever be in a module?
> > > > If not, you are probably OK with that variant.
> > > 
> > > Yes, this code can be compiled as a module.  I assume there issues with the inode
> > > outliving the module?
> > 
> > The entire file, actually...  If you are using that mechanism in a module, you
> > need to initialize kvm_gmem_fops.owner to THIS_MODULE; AFAICS, you don't have
> > that done.
> 
> Ah, that's handled indirectly handled by a chain of refcounted objects.  Every
> VM that KVM creates gets a reference to the module, and each guest_memfd instance
> gets a reference to its owning VM.

Umm... what's the usual call chain leading to final drop of refcount of that
module?
