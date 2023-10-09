Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC09D7BEBC7
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 22:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377975AbjJIUkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 16:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377954AbjJIUkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 16:40:41 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFD792;
        Mon,  9 Oct 2023 13:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HjONdBtljo/a1MPj3EhqmGSMzzsfAb0oqtURFjn7dm8=; b=GRDLoxGSItIgTce45CP56Y7xht
        gZuThDkzyn02LkUNf5bRoDUsgySnUJ9KuWstv/f7+AluRi5rzGqYv0ONlp8WJBZInf7WCdvI261o3
        1Lw6JPRqVaR0pncQhvk8bP3XQgRK9J+2ZlvrlnmzTIQqOg1lBDOMeM3w1sf5XxbSo+38MtAJAVcWH
        a+5c23kE2261YK5xUvnn4lpavACTM9QdU07kVNX5SJ5l5BFJhS4XN2H35+1fLwG4QJHAJYqHkDEQR
        ImQLTUwGicgthBa1XvWZ4rRlzkuNBZIwGSL5+Z7zzCloax93On7YjwAPoOmsibsEphoTE+veTn0kT
        8FvsiWGw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpx3N-00HIst-2h;
        Mon, 09 Oct 2023 20:40:37 +0000
Date:   Mon, 9 Oct 2023 21:40:37 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Message-ID: <20231009204037.GK800259@ZenIV>
References: <20230928180651.1525674-1-pbonzini@redhat.com>
 <169595365500.1386813.6579237770749312873.b4-ty@google.com>
 <20231009022248.GD800259@ZenIV>
 <ZSQO4fHaAxDkbGyz@google.com>
 <20231009200608.GJ800259@ZenIV>
 <ZSRgdgQe3fseEQpf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSRgdgQe3fseEQpf@google.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 01:20:06PM -0700, Sean Christopherson wrote:
> On Mon, Oct 09, 2023, Al Viro wrote:
> > On Mon, Oct 09, 2023 at 07:32:48AM -0700, Sean Christopherson wrote:
> > 
> > > Yeah, we found that out the hard way.  Is using the "secure" variant to get a
> > > per-file inode a sane approach, or is that abuse that's going to bite us too?
> > > 
> > > 	/*
> > > 	 * Use the so called "secure" variant, which creates a unique inode
> > > 	 * instead of reusing a single inode.  Each guest_memfd instance needs
> > > 	 * its own inode to track the size, flags, etc.
> > > 	 */
> > > 	file = anon_inode_getfile_secure(anon_name, &kvm_gmem_fops, gmem,
> > > 					 O_RDWR, NULL);
> > 
> > Umm...  Is there any chance that your call site will ever be in a module?
> > If not, you are probably OK with that variant.
> 
> Yes, this code can be compiled as a module.  I assume there issues with the inode
> outliving the module?

The entire file, actually...  If you are using that mechanism in a module, you
need to initialize kvm_gmem_fops.owner to THIS_MODULE; AFAICS, you don't have
that done.
