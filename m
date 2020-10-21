Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65309294FA7
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 17:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444122AbgJUPN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 11:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444116AbgJUPNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 11:13:55 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646BCC0613D5
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 08:13:55 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id p88so2320954qtd.12
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 08:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9cFTuFdatbaYuigk9l9CABG/jzUgOpY0t/i9Osy6B3k=;
        b=Dq8HyCXnjlFLiivieMejfqNvFko0IRtuvvtRMPLqBJU503Zw8AdmXj9PAYUvq+vrGw
         tLWr/P2KX0xliFL4v7zLPYR93TGo1limVOCOZFomvItA47uQ8nJhdHWU27ngiu6ooAYG
         WjN4a1HHzcaoYLAcnuo5e5/2eLC1r22+kDR6gTWfx0ZcGZTpX8rwEwqmUSs71ZqiLJX+
         OUQrP6EnxmCsgNh+3+fwOT/kOJSDKYJueSTL+OCpFozN4nNmHro2xix1p70w/08ytcHi
         qOQrid57zrk+FvzkIWYUgPoh4k6ET94WA33BXpQ3Dtpr1Jlt52u7OEBqAEPaddsrqv0i
         gSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9cFTuFdatbaYuigk9l9CABG/jzUgOpY0t/i9Osy6B3k=;
        b=XOL0bDQDFGvGaOuWzNVG45ycNbL6RyiOUyqBqlJt4EUJOoGk92onABAzU7JnsHGlQc
         0MawYTFbPYm7iTyIgEj00YimoHOY9hYk4UtfSHLxqPcM8DqXdA2j/fB7FAB+jko6ql5+
         py/pn3JDLE2nE78QeSNke3nqtqAYzWj4VV2LdCIaKZ+p+WjYYrkIXLkoF0aEi16qE/aT
         ETA8ebVH+4op+FroHc+Y/9rStlXtG7KSg7DvDWL8cP6oNHiEdYHUr+yr1h1fNDP3kBZi
         wf3ZPYUTBnNH3JSRZ9Mb3lTcq5X5/wHIpisu4MFSnQms/3VY1ui+aekVB5sbTyMTIw6E
         Wa+Q==
X-Gm-Message-State: AOAM532dlpJYo1YidvV5cQRhMEQPrO5JzMXlkq+Cxpxk249vFGroOnQj
        jg12CF8CNWKCgbzNYEcuUXXZmQWHfJ/grA==
X-Google-Smtp-Source: ABdhPJxKUYsuh5jtMPkvFgL62ClnoaVVE83XzZ8FQCHOArCd8sBp94Ul/GCOzlaoYcDR7rbZz0mkwQ==
X-Received: by 2002:ac8:8c7:: with SMTP id y7mr3515722qth.278.1603293234456;
        Wed, 21 Oct 2020 08:13:54 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id b14sm1405612qkn.123.2020.10.21.08.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 08:13:53 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kVFoG-003XHy-SZ; Wed, 21 Oct 2020 12:13:52 -0300
Date:   Wed, 21 Oct 2020 12:13:52 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.com>
Subject: Re: [PATCH v3 12/16] PCI: Obey iomem restrictions for procfs mmap
Message-ID: <20201021151352.GL36674@ziepe.ca>
References: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
 <20201021085655.1192025-13-daniel.vetter@ffwll.ch>
 <20201021125030.GK36674@ziepe.ca>
 <CAKMK7uEWe8CaT7zjcZ6dJAKHxtxtqzjVB35fCFviwhcnqksDfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEWe8CaT7zjcZ6dJAKHxtxtqzjVB35fCFviwhcnqksDfw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 04:42:11PM +0200, Daniel Vetter wrote:

> Uh yes. In drivers/gpu this isn't a problem because we only install
> ptes from the vm_ops->fault handler. So no races. And I don't think
> you can fix this otherwise through holding locks: mmap_sem we can't
> hold because before vma_link we don't even know which mm_struct is
> involved, so can't solve the race. Plus this would be worse that
> mm_take_all_locks used by mmu notifier. And the address_space
> i_mmap_lock is also no good since it's not held during the ->mmap
> callback, when we write the ptes. And the resource locks is even less
> useful, since we're not going to hold that at vma_link() time for
> sure.
> 
> Hence delaying the pte writes after the vma_link, which means ->fault
> time, looks like the only way to close this gap.

> Trouble is I have no idea how to do this cleanly ...

How about add a vm_ops callback 'install_pages'/'prefault_pages' ?

Call it after vm_link() - basically just move the remap_pfn, under
some other lock, into there.

Jason
