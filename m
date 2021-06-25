Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901243B464D
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhFYPHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:07:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231950AbhFYPHR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624633496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=orhFcVG1MGfwHWjH/fTT6Go2RQIksRFTwjLRhmT/3hw=;
        b=QtWWQOiAtyDbjjWDZFg+xoCyXM8jaN3dpbdL30rBdySyranjjprftfvwCYQYYvQyBf3aZX
        3k0mh4CfgjzvGIIBXJM2oaSVz48k+r7fTOUuMPtdmWre2YRtVSoW3mf7x+19KFNceqSHN6
        SjKpsU5yBrIZmrdUl2lhuhRBksZxw2s=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-7Al7v-InNW6sKeWp5JTPGg-1; Fri, 25 Jun 2021 11:04:54 -0400
X-MC-Unique: 7Al7v-InNW6sKeWp5JTPGg-1
Received: by mail-io1-f70.google.com with SMTP id e24-20020a5d8e180000b02904dd8a55bbd7so7191348iod.12
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=orhFcVG1MGfwHWjH/fTT6Go2RQIksRFTwjLRhmT/3hw=;
        b=tl+kQJyVYRPlVmTgYZWYUAma5uBxYpWxYgpmPQdsiI+49HnEh95h25mec76ElKLTLN
         MDVjGmNfyu9RoZMyVjGn16NhHrRsyMOnf5v5QJTMSbstp5j8uRVPugBpzEXTBYHFiVVw
         qf3MtSSMQpqmsJxUqJqE8+u65piW9kATc4uCsoqHJb6U2pZqrAooabQkVoxoXx8lPR3T
         6lW22l+dUSCSBK7DziR/XST2sfP/F9EFtCWUqSy/payPgU43A9hq90I2rx+CFAc/L0oq
         yvwGLypghpy4EaY57y9NHiy+/SnHqPjY+qpQ0Vs1fnERN0H8WOEeJewYV4X/xT2pmaQx
         XcdA==
X-Gm-Message-State: AOAM530ms7XJzShd7VfSurN3M8UgckNhWP9wMchCF80nrk5OVPvvLMWB
        60m9bKNRUbaqq5+1q7jJF3M1hs5zpwY45+JpoT5hXwcjKA4BpxLIuJIt+ySVnxADgcE9Frm0DYK
        JHYDldfIXedAl
X-Received: by 2002:a02:a99e:: with SMTP id q30mr9857355jam.69.1624633494314;
        Fri, 25 Jun 2021 08:04:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYvbFfAcxRLHUHXohN+O9jy6GPQekGuKcwjY7hFxQZ6CQzhObIbZVnZpOn59v+E7YfDtNaBQ==
X-Received: by 2002:a02:a99e:: with SMTP id q30mr9857343jam.69.1624633494192;
        Fri, 25 Jun 2021 08:04:54 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id b23sm3437974ior.4.2021.06.25.08.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:04:53 -0700 (PDT)
Date:   Fri, 25 Jun 2021 09:04:51 -0600
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
Message-ID: <20210625090452.65474656.alex.williamson@redhat.com>
In-Reply-To: <20210623022824.308041-1-mcgrof@kernel.org>
References: <20210623022824.308041-1-mcgrof@kernel.org>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Jun 2021 19:28:22 -0700
Luis Chamberlain <mcgrof@kernel.org> wrote:

> This v2 series addreses the changes requested by Bjorn, namely:
> 
>   - moved the new forward declarations next to pci_cfg_access_lock()
>     as requested
>   - modify the subject patch for the first PCI patch
> 
> Luis Chamberlain (2):
>   PCI: Export pci_dev_trylock() and pci_dev_unlock()
>   vfio: use the new pci_dev_trylock() helper to simplify try lock
> 
>  drivers/pci/pci.c           |  6 ++++--
>  drivers/vfio/pci/vfio_pci.c | 11 ++++-------
>  include/linux/pci.h         |  3 +++
>  3 files changed, 11 insertions(+), 9 deletions(-)
> 

Applied to vfio next branch for v5.14 with Bjorn's Ack, thanks!

Alex

