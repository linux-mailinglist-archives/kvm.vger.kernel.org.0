Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6895EB6F6
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 03:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiI0Bhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 21:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiI0Bhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 21:37:33 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F1462ABA;
        Mon, 26 Sep 2022 18:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=vbLNBWREc8wtlf35TvDhzeou8nr6dUnXb6dBOMvc06g=; b=kaGV37Bnln99lfAW9WZph2pwfv
        K19X/8D8T8P1RBTgkAn7Tu9aAYQmciUmULVgmVF5JbQMdZisU0y7lQCJd6pvo1VaqPU4HsRVcbpZG
        unmbi7ZcANIDzOq2RB+uHlU9MVEhs2X6ivUHUh/JaYjpv87SKoh3NxtzOPuon8eoX5mZBnwB9N7In
        8OStdU0+WP21ZztdICmv+Gh7ffHueKimwRceAET6jYZdnmCLjBY+8XFXzeSS0n2MTEgg26k1tM6/V
        QjkABOptIA6jKmaLrABwZsowq4JjdSbxRJW5BXUV7UqJ+YSH3HL32OrAbYkaEwg2QA7OkDoNfzrJZ
        41gt7ZWw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1oczXF-004Cic-34;
        Tue, 27 Sep 2022 01:37:22 +0000
Date:   Tue, 27 Sep 2022 02:37:21 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     tomorrow Wang =?utf-8?B?KOeOi+W+t+aYjik=?= <wangdeming@inspur.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: Use filp instead of fd
Message-ID: <YzJT0bzUz+ACo2vA@ZenIV>
References: <0d0817a2c6a8467e83b07c91f50511fa@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d0817a2c6a8467e83b07c91f50511fa@inspur.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 01:21:50AM +0000, tomorrow Wang (王德明) wrote:
> Hi
> 
> Why kvm_vfio_group_add use file.
>   
>   struct file *filp;
>   .....
>   filp = fget(fd);
> 
>   .....
>   kvg->file = filp;

This is why.  Note that you've slightly misquoted it - it's actually
either "stick into kvg->file" or "fput() it".

>   ......
>   fput(filp);

The reference we are getting here is non-transient one; it will be retained
in shared data structures after we return from function - hell, after we
return to userland.
