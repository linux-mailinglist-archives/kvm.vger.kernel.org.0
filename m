Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627853B465E
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhFYPKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:10:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231938AbhFYPKC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624633661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=70I67UUR2l1l5ABDLMfPTcfAZE4s0dqLocdRtDDYYyg=;
        b=WTP5nbX03MqLBRxU3lm1C/spQAj5MNrwD1J3U9DxXtQfSDVbwyfeWTyRk5iQGVTrxsMBTQ
        VFBU5jNq3oSbCdr2Q8ChYK8jmMtB7rG9rZdFKuvoLfmOstQE7JGrNL/cvxNi1j1YPrPoqr
        zonZsY4YWeQbWqwoiph1ZTy8zNOMMnE=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-Od0fbBeCP1i_4OA2eNbvfA-1; Fri, 25 Jun 2021 11:07:39 -0400
X-MC-Unique: Od0fbBeCP1i_4OA2eNbvfA-1
Received: by mail-il1-f200.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so6334861ilc.6
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=70I67UUR2l1l5ABDLMfPTcfAZE4s0dqLocdRtDDYYyg=;
        b=Y5NIlaHMmZ0byema7CtU2G3wc8GZLWS0ibOwjQHuro8VPOenbMlzDR/ACMhlMFXSH1
         3HTL5qz7BNA2SOOvCdBhvEIHLWH7s9e4xr5oyIPuEfTsNvpzsrlnfHe8yxPrMbiIefow
         ePtr7HgXiEzNjJV8zPMZBRgOgxrWVOcbofoRKDXWay+eSuO4ejtA6glkHDqqCa2A4Q2A
         fc3etTTZyVkk6E5gns9urm0GmnGhAuJstw5MjWtW2yTVZHAqN94vX/g7Lsayln8me66I
         IMdobwNFC0lVQebGq6pS4lOcV3/VlKckRrT6ew5tTfZEidxHok7TbGZESw16v0avz+nA
         BLRw==
X-Gm-Message-State: AOAM531J9wHiBmKKmxvOLoiD5NXxQsEI8F7ySqfCM/HOi/FErq9hMtAi
        Jq7QITPaQyog2Oh7S63lS8+//rCFAjGGH4FOWLccB6+ta6V4IKxTV3IhnOHPuebJm/WUd4Y1Ibe
        aBRuzmTri18u9
X-Received: by 2002:a92:dc48:: with SMTP id x8mr8064571ilq.213.1624633659372;
        Fri, 25 Jun 2021 08:07:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzpGY3nuZwWGP/ZTrCtcdh/ZWkEKTSZ3SIg6FE6AkkM/6zfnITXUACUg++3TwlCd8O5LjNxA==
X-Received: by 2002:a92:dc48:: with SMTP id x8mr8064559ilq.213.1624633659232;
        Fri, 25 Jun 2021 08:07:39 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id m13sm3367237iob.35.2021.06.25.08.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:07:38 -0700 (PDT)
Date:   Fri, 25 Jun 2021 09:07:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     bhelgaas@google.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, eric.auger@redhat.com,
        giovanni.cabiddu@intel.com, mjrosato@linux.ibm.com,
        jannh@google.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        schnelle@linux.ibm.com, minchan@kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org, jeyu@kernel.org,
        ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] vfio: export and make use of pci_dev_trylock()
Message-ID: <20210625090737.5a7549b3.alex.williamson@redhat.com>
In-Reply-To: <20210625090452.65474656.alex.williamson@redhat.com>
References: <20210623022824.308041-1-mcgrof@kernel.org>
        <20210625090452.65474656.alex.williamson@redhat.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Jun 2021 09:04:51 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 22 Jun 2021 19:28:22 -0700
> Luis Chamberlain <mcgrof@kernel.org> wrote:
> 
> > This v2 series addreses the changes requested by Bjorn, namely:
> > 
> >   - moved the new forward declarations next to pci_cfg_access_lock()
> >     as requested
> >   - modify the subject patch for the first PCI patch
> > 
> > Luis Chamberlain (2):
> >   PCI: Export pci_dev_trylock() and pci_dev_unlock()
> >   vfio: use the new pci_dev_trylock() helper to simplify try lock
> > 
> >  drivers/pci/pci.c           |  6 ++++--
> >  drivers/vfio/pci/vfio_pci.c | 11 ++++-------
> >  include/linux/pci.h         |  3 +++
> >  3 files changed, 11 insertions(+), 9 deletions(-)
> >   
> 
> Applied to vfio next branch for v5.14 with Bjorn's Ack, thanks!

(and Jason & Conny's R-b)

