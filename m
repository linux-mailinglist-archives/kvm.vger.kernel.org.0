Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172DF1C6033
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 20:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgEESgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 14:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbgEESgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 14:36:32 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E4DC061A10
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 11:36:32 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c64so470270qkf.12
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 11:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eqlnqG0Hw3VMrzuvRcCdGu4ewQLAPeQsUkr54n/Ba44=;
        b=YxFtUSCKjaM3W/DhClEwL6MT2JsMzpVzLJW8cImgeavPLCOQmKCbaprWQUzSmTPxQt
         TkhFaSHthPlrIfE7m7euz3TWtITCCv70E6r59bQT/fbfkij9Qm61XrWixDwS6hJcre2K
         S0NhYhIAK1l0JSHO4yV4bsTJEynaLPmS9eVY9PkLpNN/lX1J38Psw3dkO3NQHPsKsBW3
         ZxSArF7+ab99cqFBi7Bsddjcr3DhUX6TUUjztYWBQyOW2oaAl9VXNvFTlA1ggWSvakhR
         eLXIR17oPrlMlKE/OjepKL2fjaxWqYGPxwOSkXs6D/dmOfSJINu+WIKyS5i7IZYdIGZq
         Qs6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eqlnqG0Hw3VMrzuvRcCdGu4ewQLAPeQsUkr54n/Ba44=;
        b=JHFd1eo/3rX3FT3hpqIKjL/FtPiyvV139DGI2Wdkiyw6HHQbmX+wx74DnlaKskhgWK
         SOp6WfaySdwyQZbPkbJ+noDqJqCG0CBEyPxEkLWSI4PBi2pmSmfDgQuAmou46O6WMk6x
         1guUu5y7M3QWUnWywcLIXTwbSSn+Uuz7OunfiUlQT4Rx/73txJ5SDqwbaGH6ajrQ24dH
         JKji/Y73v2/YsPinkzTnn554+glZBtq4tW2w5D3GhgYGdgSijv0j3ifbg4lbd7XZTZe5
         WS01g2+4szxy8WbyBKRVHPUTAtU4CBEkryIALrLWC8huPLE3eiwpdTvZqbBYYnIeZe/M
         ihhg==
X-Gm-Message-State: AGi0PuZMjR8qvzvHFxE5FQEsry51mKFqsWPo65hllPMMYvEMequ5f6xp
        VnD2GomdH9sNjeMh4BBVcYUGahuMmDw=
X-Google-Smtp-Source: APiQypJ7O8355ctgKfdq6OC10TRz+pU+Ntr4Qbbn9r6Z9ZCC2YPs9LO4Kx0pmGe6yNVVy3N4mhJfNQ==
X-Received: by 2002:a37:7904:: with SMTP id u4mr4789865qkc.297.1588703791311;
        Tue, 05 May 2020 11:36:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id g12sm2312319qtu.69.2020.05.05.11.36.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 May 2020 11:36:30 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jW2Qf-0007Sj-HD; Tue, 05 May 2020 15:36:29 -0300
Date:   Tue, 5 May 2020 15:36:29 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 3/3] vfio-pci: Invalidate mmaps and block MMIO access on
 disabled memory
Message-ID: <20200505183629.GF26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
 <158836917028.8433.13715345616117345453.stgit@gimli.home>
 <20200501234849.GQ26002@ziepe.ca>
 <20200504122643.52267e44@x1.home>
 <20200504184436.GZ26002@ziepe.ca>
 <20200504133552.3d00c77d@x1.home>
 <20200504200123.GA26002@ziepe.ca>
 <20200505111227.02ac9cee@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505111227.02ac9cee@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 11:12:27AM -0600, Alex Williamson wrote:
> 
> As noted in the comment, the fault handler can simply do:
> 
> mutex_lock(&vdev->vma_lock);
> down_read(&vdev->memory_lock);
> 
> This should be deadlock free now, so we can drop the retry handling

That does look like the right direction, because the memory_lock can
be done at the very end it means it doesn't need to be nested inside
mmap_sem

This is much cleaner!

Jason
