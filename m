Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BC55EA940
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiIZOz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 10:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiIZOyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 10:54:52 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB104CFE;
        Mon, 26 Sep 2022 06:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wZ7mbwj+DEHYqlCMeVhDbwi0zz1pLcHzRXAZl3GYD0Q=; b=RifdWi9ao0Te+Zy9Sqnw+4Sp1m
        vtWp92ykZNxYv4HSrD1eKaqE91qsY2CbnMox4IO8LccWEeMc/ecqWbyXvNoNUuIodClfdHO18GiNs
        FAXHg+Egzykr9ME2la0UcSJnB3nab+AEwdhlBho0iLpUfKGSrLL4pitmr5r66AhzxN7Qo1m7khRXw
        shK0DHi1ugQlOPh5Lubk48j9l4BrwvKDd8TOAiXU6uHsMUbMAPRL2vFeqCGjDrEiPuY5tCvCmAQkd
        QsHZ2LL7WKybaK4CuB87UY947Pjdg6JkpDDTYqV0ZJXM8FLH7nNOUp7dte5Z/nsGCN9QGtH2D5yAq
        AekLe20A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1oco5U-0040Q0-2J;
        Mon, 26 Sep 2022 13:23:56 +0000
Date:   Mon, 26 Sep 2022 14:23:56 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Deming Wang <wangdeming@inspur.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Use filp instead of fd
Message-ID: <YzGn7JkKsgNtmxiU@ZenIV>
References: <20220926065407.2389-1-wangdeming@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926065407.2389-1-wangdeming@inspur.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022 at 02:54:07AM -0400, Deming Wang wrote:
> The function of kvm_vfio_group_set_spapr_tce and kvm_vfio_group_del
> use fd indirectly.But,it only be used for fd.file. So,we can directly
> use the struct of file instead.
> 
> Signed-off-by: Deming Wang <wangdeming@inspur.com>

NAK.  fget() is for the cases when we must keep the reference across the
syscall boundary/pass to another thread/etc.

If fdget() is applicable, it's a better alternative.  And I would suggest
you to look at the generated code - it pretty much turns into
	struct file *file;
	int need_fput;

	r = __fdget(fd);
	need_fput = r & 3;
	r &= ~3;
	file = (struct file *)r;

	....

	if (unlikely(need_fput))
		fput(file);

Note that we are *not* actually passing a structure out of a function, etc. -
fdget() is inlined and out-of-line part returns unsigned long.  Lower two bits
carry flags, the rest - file pointer.  Rearrangement into struct fd is done
in the caller and compiler manages to dissolve that struct into a couple of
local variables.

Incidentally, pretty much the only thing in struct fd besides struct file pointer
is that "have we failed to skip bumping the reference count?" flag.  Between
fdget() and fdput() only the file pointer is used - in all users.  fdput()
uses the flag to decide whether it needs to bother with refcount at all.
