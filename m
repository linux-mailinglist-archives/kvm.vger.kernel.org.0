Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6627E7BD1E3
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 04:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344793AbjJICQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 22:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjJICQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 22:16:48 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AB0A6;
        Sun,  8 Oct 2023 19:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+ikwgjd5P87YDm6DAAABio5shAHyVQAKb6s8sL0xDbs=; b=Yk5olfnstsZOt42gMU2pwbE+/P
        I73K9LJLvR4iEtJ/s5y6n4IQjaKIkM8cmRmZN5emSmm3iLZuSMvt2iV9C8CLbYqM0FrsfrFN8619w
        AxI4KUiKUrEXYmS1L+cn9CZ6K5vmv/rxoT3/ieUylhZOaN5ETEOkPAilQWB07G85GqGLj2IHdDyyX
        N7plTsm2uGwCra52CsvjmOJL5rZB0HiPquWOcLEbSnLrgaUIfTJHULMNC42LwL5EGtGkCw2LNQG78
        QtOHRQ6BkgSmfpTFKZ3h9aU1HUIcby3pj5GDHLq0sbSrH/GJUb7ygJ2jbrKPkPt/l4BlbIv19GpnO
        ZGJcC55Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpfp6-00H4BX-1x;
        Mon, 09 Oct 2023 02:16:44 +0000
Date:   Mon, 9 Oct 2023 03:16:44 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Message-ID: <20231009021644.GC800259@ZenIV>
References: <20230928180651.1525674-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928180651.1525674-1-pbonzini@redhat.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023 at 02:06:51PM -0400, Paolo Bonzini wrote:
> Use a run-of-the-mill anonymous inode, there is nothing useful
> being provided by kvm_gmem_fs.

> -	inode = alloc_anon_inode(mnt->mnt_sb);
> -	if (IS_ERR(inode))
> -		return PTR_ERR(inode);
> +	fd = get_unused_fd_flags(0);
> +	if (fd < 0)
> +		return fd;
>  
> -	err = security_inode_init_security_anon(inode, &qname, NULL);
> -	if (err)
> -		goto err_inode;
> +	gmem = kzalloc(sizeof(*gmem), GFP_KERNEL);
> +	if (!gmem) {
> +		err = -ENOMEM;
> +		goto err_fd;
> +	}
> +
> +	file = anon_inode_getfile(anon_name, &kvm_gmem_fops, gmem,
> +				  O_RDWR);

> +	inode = file->f_inode;
> +	WARN_ON(file->f_mapping != inode->i_mapping);
>  
>  	inode->i_private = (void *)(unsigned long)flags;
>  	inode->i_op = &kvm_gmem_iops;

That's very badly broken.  The whole point of anon_inode_getfile() is
that *ALL* resulting files share the same inode.  You are not allowed
to modify the damn thing.
