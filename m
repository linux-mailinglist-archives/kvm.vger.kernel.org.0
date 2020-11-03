Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AED2A59BA
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 23:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgKCWJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 17:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730644AbgKCWJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 17:09:48 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEACAC061A49
        for <kvm@vger.kernel.org>; Tue,  3 Nov 2020 14:09:47 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id p93so20163842edd.7
        for <kvm@vger.kernel.org>; Tue, 03 Nov 2020 14:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WO1e+L++wPESWfr9nzOE54SCt7afrEsmsB9fEuoYvbI=;
        b=T+/A6+J62VDvQMKYPtVg2CtBW5xawhHVZqWOERIyixTczN4MfytqxhoJQJOcs2790L
         sj4ZJgiKijp3n63RZQtMlQ3es9rYo1weSDlwxcJm5Ag+lH4tps5I28z8LxvfwKmYtzJJ
         /7ODS6RyMh7GrhkYAYzKWrZUgtjo08ShY2d8lFIlqSiQY56zEC4lJ332rH1cpQ0Jikk9
         7t5YiToX4pGXA3cBIa8hr/lWANYeeU9HgWErCB0IiUFAAt6bSVSfurD3RBJy3BliIelp
         YL3WFMt/TsTNhYtMeHyiS4JaRXQkTDS7Em1++6Jk3gmVGF0kwFa501K00ou4nDd0zP9v
         pO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WO1e+L++wPESWfr9nzOE54SCt7afrEsmsB9fEuoYvbI=;
        b=SlGdRsKH6rCcALz9lBmkUwfGCmLB2rKNpTiy0QZhSAIR5Q+Ectu2wxqwC3pHYurVXS
         Ms3fTz+nIKnIfcQffR+bd1F8ZNEY7stVTzyv90dxK/M4gdrzJh2xt4t3fyPufNafnyt2
         alXEKOd482zGL2rhVacobCBdaUKXXW1p4KSHNtAud2c9b+rEtCJSszJZNFBBJMlBLqiB
         XFtreEdQL0QrnrPQuFKeL4bTkIbBWOCohPJPnksq7ZazKTW4Wzl7/4/2E7pi7obGagdn
         W3Q5Yr1wv2FJrNb9GmZbR5JRHD0d/BzAVMJgJvhjhI1jF+Zg/dSBjYtk2isaaGktbOZL
         GWUQ==
X-Gm-Message-State: AOAM530qosrUilosHN9qh7NdnasHsWw/fhoFL2KPr325wo8oObYGUME5
        9PQ7ZdUU8pC5Lemo9eJK+5n/utC5ZbZkIc0xymuGTFPEQ3M8Tg==
X-Google-Smtp-Source: ABdhPJz1NDE7PM2O7672wRWt1a0mL/+PL68eDdfq2Oj69hckQbQldL+V0lbGY3zFDyAcHIRlbnAQxlg/ZySh5dCl9Ns=
X-Received: by 2002:aa7:d843:: with SMTP id f3mr24583081eds.354.1604441386651;
 Tue, 03 Nov 2020 14:09:46 -0800 (PST)
MIME-Version: 1.0
References: <20201030100815.2269-12-daniel.vetter@ffwll.ch> <20201103212840.GA266427@bjorn-Precision-5520>
In-Reply-To: <20201103212840.GA266427@bjorn-Precision-5520>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 3 Nov 2020 14:09:35 -0800
Message-ID: <CAPcyv4jCGxWG0opLv4VzBRk5iLwu6CRse4DwF-otWkfXoGWe6A@mail.gmail.com>
Subject: Re: [PATCH v5 11/15] PCI: Obey iomem restrictions for procfs mmap
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 3, 2020 at 1:28 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Fri, Oct 30, 2020 at 11:08:11AM +0100, Daniel Vetter wrote:
> > There's three ways to access PCI BARs from userspace: /dev/mem, sysfs
> > files, and the old proc interface. Two check against
> > iomem_is_exclusive, proc never did. And with CONFIG_IO_STRICT_DEVMEM,
> > this starts to matter, since we don't want random userspace having
> > access to PCI BARs while a driver is loaded and using it.
> >
> > Fix this by adding the same iomem_is_exclusive() check we already have
> > on the sysfs side in pci_mmap_resource().
> >
> > References: 90a545e98126 ("restrict /dev/mem to idle io memory ranges")
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>
> This is OK with me but it looks like IORESOURCE_EXCLUSIVE is currently
> only used in a few places:
>
>   e1000_probe() calls pci_request_selected_regions_exclusive(),
>   ne_pci_probe() calls pci_request_regions_exclusive(),
>   vmbus_allocate_mmio() calls request_mem_region_exclusive()
>
> which raises the question of whether it's worth keeping
> IORESOURCE_EXCLUSIVE at all.  I'm totally fine with removing it
> completely.

Now that CONFIG_IO_STRICT_DEVMEM upgrades IORESOURCE_BUSY to
IORESOURCE_EXCLUSIVE semantics the latter has lost its meaning so I'd
be in favor of removing it as well.
