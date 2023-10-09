Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68387BD1F1
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 04:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345004AbjJICWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 22:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbjJICWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 22:22:50 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA052A6;
        Sun,  8 Oct 2023 19:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YJzixU4eIlZHRpL2+qAy4fg7CpiblSinQhlg/vtOqpo=; b=TjP44acQFALYXM57eZX+1dpmVG
        yiFPDmWfDOWBQSC3aTN2DoZ2MRLuX28QXa21hK8rmxq0FzmrHA1XpSl3Sufx8fPQ/Ls2eLOQxoKi2
        IAhFcVScZjmz/JOWPBxV5IK7PT6ak2uuWnCIyBbD5pYQhlgSxVpjytMLe2a+ebyfl8k77su+97ZxW
        aUstEOrKbcaikE6E5P2SCGOxHQTCa3nk+0XEwK2FsZV7rZ9uQS1jVfY+o0umaoCSV5IhUe/ZpigJH
        6jcr30+Sh8PxmzhOgfFpG8hQAzhaPTPpM5WnQdS7P2y7ItfbEb2ENMOt2LTYedlNpmzisDFEWKccx
        dk71MtEA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpfuy-00H4HF-0r;
        Mon, 09 Oct 2023 02:22:48 +0000
Date:   Mon, 9 Oct 2023 03:22:48 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Message-ID: <20231009022248.GD800259@ZenIV>
References: <20230928180651.1525674-1-pbonzini@redhat.com>
 <169595365500.1386813.6579237770749312873.b4-ty@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169595365500.1386813.6579237770749312873.b4-ty@google.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023 at 07:22:16PM -0700, Sean Christopherson wrote:
> On Thu, 28 Sep 2023 14:06:51 -0400, Paolo Bonzini wrote:
> > Use a run-of-the-mill anonymous inode, there is nothing useful
> > being provided by kvm_gmem_fs.
> > 
> > 
> 
> Applied to kvm-x86 guest_memfd, thanks!
> 
> [1/1] kvm: guestmem: do not use a file system
>       https://github.com/kvm-x86/linux/commit/0f7e60a5f42a

Please, revert; this is completely broken.  anon_inode_getfile()
yields a file with the same ->f_inode every time it is called.

Again, ->f_inode of those things is shared to hell and back,
very much by design.  You can't modify its ->i_op or anything
other field, for that matter.  No information can be stored
in that thing - you are only allowed to use the object you've
passed via 'priv' argument.

NAKed-by: Al Viro <viro@zeniv.linux.org.uk>
