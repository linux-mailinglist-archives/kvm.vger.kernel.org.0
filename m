Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5627BEFD1
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 02:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379217AbjJJAhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 20:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379189AbjJJAht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 20:37:49 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3743AA4;
        Mon,  9 Oct 2023 17:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Yd8LtAUhil6gDxO7/Lkm05KcSXZOGIjG2k/iyrJTHVg=; b=DE60vF+HLqkpf9A7JBwAois7JV
        6ywwIeJ2n/D6CTnROrUZZ4Yhik8I7foIPFdHAJ+Uwwy2nJ7CUhEkhGqX7E6VJTqn3Zn/IQeE3xG01
        dz9iPU0GGfFmrpuki3FsRu4fcuw7aZhKMQ6XP3eF/jsRTwxL6NKk0MJzCnIi74CeJKbyxU44sUBSq
        CAYPICH6lhhsJL4Fz12dkDMDSWC7DGDEY5OBOccItP0ePmIZ/ghlIVuTMkhCOTI5wjNCWysvKU5g7
        n5ggTjUbITV01IWY4vljXOAPYnlHnbXQdJlYHdkn/4R3dor/Wgk75dVuSgUdcjIiJGVT/j0lDhR7o
        oltm2B4g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qq0ks-00HM47-21;
        Tue, 10 Oct 2023 00:37:46 +0000
Date:   Tue, 10 Oct 2023 01:37:46 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Message-ID: <20231010003746.GN800259@ZenIV>
References: <20230928180651.1525674-1-pbonzini@redhat.com>
 <169595365500.1386813.6579237770749312873.b4-ty@google.com>
 <20231009022248.GD800259@ZenIV>
 <ZSQO4fHaAxDkbGyz@google.com>
 <20231009200608.GJ800259@ZenIV>
 <ZSRgdgQe3fseEQpf@google.com>
 <20231009204037.GK800259@ZenIV>
 <ZSRwDItBbsn2IfWl@google.com>
 <20231010000910.GM800259@ZenIV>
 <ZSSaWPc5wjU9k1Kw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSSaWPc5wjU9k1Kw@google.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 05:27:04PM -0700, Sean Christopherson wrote:

> If the last reference is effectively held by guest_memfd, it would be:
> 
>   kvm_gmem_release(), a.k.a. file_operations.release()
>   |
>   -> kvm_put_kvm()
>      |
>      -> kvm_destroy_vm()
>         |
>         -> module_put(kvm_chardev_ops.owner);

... and now your thread gets preempted and loses CPU; before you get
it back, some joker calls delete_module(), and page of code containing
kvm_gmem_release() is unmapped.  Even though an address within that
page is stored as return address in a frame on your thread's stack.
That thread gets the timeslice again and proceeds to return into
unmapped page.  Oops...
