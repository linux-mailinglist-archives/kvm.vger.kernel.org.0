Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB51E3B201F
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 20:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhFWSTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 14:19:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFWSTX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 14:19:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624472224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zsnnWPBw158ioKHOEvs2KKkgeu539ulBwP58qKPdjxw=;
        b=ZXLaZ5Fsmga8OximBd+2rCCTqY/6vcsJ4hqegM4Fna1X3tYB1goe+zrA4OP9xhlLqahvZC
        +x/VGFlId7tBr8dSLmlJHBZb1J3nZvRiylBh+k7bomidXRSmUzqHrZwMlGd9nalz1aKopv
        DrG+qXJFiT3legUgmzfczbmyF8QML/0=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-ASxg5Cw2MX2Je7u10X8GvA-1; Wed, 23 Jun 2021 14:17:03 -0400
X-MC-Unique: ASxg5Cw2MX2Je7u10X8GvA-1
Received: by mail-ot1-f72.google.com with SMTP id l18-20020a9d70920000b029044977534021so1794282otj.12
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 11:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsnnWPBw158ioKHOEvs2KKkgeu539ulBwP58qKPdjxw=;
        b=uRYscjdJ5Wrzn7S9RefyJ0Z1OcPZXqhUeSwoZcD+X2hQNK+HCKng/TtzVNk8Twd/OT
         dz5our5WeStrf396CGqiSBMPlDwflwsKMHWm0KdjZH0S4+gCphwGI2O/Rh+Mh1z9yLEU
         ZMQzthol6mowA1BnV19j5JsA5Y7zBD2zwiEjbZo1QkAJtDUbWRCzEM+2WRg8bKugpnve
         xOKaBOVM2uRq+Y6AqeiE1hXB2C5idRC3ROG0qIQybYCszwNfJVa19WetIXAgjdAtUDzO
         DccJe341mQmBOrRx8+O6y7kkkEG49NgtseZ1zh8c/1HfbNV6/vRDeThv2Sj7XzzReifB
         7MsQ==
X-Gm-Message-State: AOAM5338biAaTS6M+0+i+2nu0cNzjQRKB7LhPk72sFWPqEiMzlWxxPQu
        5J3W7hecWibFB++wuH+w8DYfCjU3kJ9UoSaRJlnKxG5SQ9esfG7LyDQgrggoAiAiAhwcsij4eV/
        RlQrYW1GFN62p
X-Received: by 2002:a54:4706:: with SMTP id k6mr888676oik.61.1624472222519;
        Wed, 23 Jun 2021 11:17:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL0YKbaTtBpyfI6uxPnb987mGgVkN6qd0BiEd/xyLXC74Z3rr1q+2jYxVhnQLadq7/gCiFPw==
X-Received: by 2002:a54:4706:: with SMTP id k6mr888659oik.61.1624472222401;
        Wed, 23 Jun 2021 11:17:02 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id e5sm102607oou.27.2021.06.23.11.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 11:17:02 -0700 (PDT)
Date:   Wed, 23 Jun 2021 12:17:00 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>, bhelgaas@google.com
Cc:     cohuck@redhat.com, jgg@ziepe.ca, kevin.tian@intel.com,
        eric.auger@redhat.com, giovanni.cabiddu@intel.com,
        mjrosato@linux.ibm.com, jannh@google.com, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, schnelle@linux.ibm.com,
        minchan@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, axboe@kernel.dk,
        mbenes@suse.com, jpoimboe@redhat.com, tglx@linutronix.de,
        keescook@chromium.org, jikos@kernel.org, rostedt@goodmis.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] vfio: export and make use of pci_dev_trylock()
Message-ID: <20210623121700.4725e22f.alex.williamson@redhat.com>
In-Reply-To: <20210623022824.308041-1-mcgrof@kernel.org>
References: <20210623022824.308041-1-mcgrof@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
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

Looks ok to me and I assume by Bjorn's Ack that he's expecting it to go
through my tree.  I'll give a bit of time to note otherwise if that's
not the case.  Thanks,

Alex

> Luis Chamberlain (2):
>   PCI: Export pci_dev_trylock() and pci_dev_unlock()
>   vfio: use the new pci_dev_trylock() helper to simplify try lock
> 
>  drivers/pci/pci.c           |  6 ++++--
>  drivers/vfio/pci/vfio_pci.c | 11 ++++-------
>  include/linux/pci.h         |  3 +++
>  3 files changed, 11 insertions(+), 9 deletions(-)
> 

