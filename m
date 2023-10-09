Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACCC7BD1FB
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 04:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345006AbjJICf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 22:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjJICf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 22:35:57 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FB0A4;
        Sun,  8 Oct 2023 19:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MU7v5qu9yPgnI8R82udS5Goc2VlcNgXX+qckqeqZ3bk=; b=IfnSPLykY5r++NKkjhZPUlGZzv
        kzfVK3Z1XcTyVf44RHNahVP4B8zG/qFSONbonhjM8N7Zms1wb/cH9nloTEaJoADv+hVH1wVZK/A2R
        TQ1dG5bK//yRiqkIm26n2iYkqvw7zwbFOaFSexj0uM1XnQ7c3CoXB1cx8O4kUTxHtIGxHydHCrzYo
        a+u8Gx/dBFhzCLIL+hGeMdFxRKruCcG/KTvcQLOXRmlbbqK6Lm0UsngE6eqK3lRhfuc4gj+lhMQqP
        LW2eDxIpsaSvFe16PmtKqKOjr6IqT97opBin71WYYLvo7zL815yLIVOnKhkItSfoGb4fKIDkwOhuj
        fGj9fXXw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpg7e-00H4Rt-2s;
        Mon, 09 Oct 2023 02:35:54 +0000
Date:   Mon, 9 Oct 2023 03:35:54 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Message-ID: <20231009023554.GE800259@ZenIV>
References: <20230928180651.1525674-1-pbonzini@redhat.com>
 <169595365500.1386813.6579237770749312873.b4-ty@google.com>
 <20231009022248.GD800259@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009022248.GD800259@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 03:22:48AM +0100, Al Viro wrote:
> On Thu, Sep 28, 2023 at 07:22:16PM -0700, Sean Christopherson wrote:
> > On Thu, 28 Sep 2023 14:06:51 -0400, Paolo Bonzini wrote:
> > > Use a run-of-the-mill anonymous inode, there is nothing useful
> > > being provided by kvm_gmem_fs.
> > > 
> > > 
> > 
> > Applied to kvm-x86 guest_memfd, thanks!
> > 
> > [1/1] kvm: guestmem: do not use a file system
> >       https://github.com/kvm-x86/linux/commit/0f7e60a5f42a
> 
> Please, revert; this is completely broken.  anon_inode_getfile()
> yields a file with the same ->f_inode every time it is called.
> 
> Again, ->f_inode of those things is shared to hell and back,
> very much by design.  You can't modify its ->i_op or anything
> other field, for that matter.  No information can be stored
> in that thing - you are only allowed to use the object you've
> passed via 'priv' argument.

BTW, note that all those suckers will end up sharing the page
cache; looks like that's not what you want to get...

> NAKed-by: Al Viro <viro@zeniv.linux.org.uk>
