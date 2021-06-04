Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F22739BC10
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 17:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhFDPjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 11:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42117 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230034AbhFDPjp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 11:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622821078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pHiBAl8+vXrofNAjjOJ84eNcT7KcR0jKQ6aIcGHntvY=;
        b=C5Ko4dYu8z8LJKyyBGKChosP5gsdkhbehNnMIUD8EIobIwfLn1MkzvIEy9VgWkDRB8XU+D
        KtzBLQY9e2qpzuTS/WA5Tvli2/57w07i6za8xhBpFM5bEoZCGTn61yDybvWIDlGzwSi+Pv
        Klxzx1+5VR7t9nQyLLxhKalNtznZxdI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-BZhL65_XMdW84IlZ--0kjw-1; Fri, 04 Jun 2021 11:37:57 -0400
X-MC-Unique: BZhL65_XMdW84IlZ--0kjw-1
Received: by mail-il1-f199.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so6740463ilc.6
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 08:37:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pHiBAl8+vXrofNAjjOJ84eNcT7KcR0jKQ6aIcGHntvY=;
        b=q4ukwDaEZW4wuBNw4mhOe+gyajM1Wux+sVpQbOoVcmCCvu/decvG9Ya8+STgmQy8hd
         XjyXEIDnUf/RZvn92UCGgZcNzBgkyY3XcMSYdoheXiSUTFvedyZrtYgj1vg2i9g2pHlR
         h8ePjqXrTZHBxs7x2IVwukhhrroUkkCneXMVYQZ1AlPgzHEkX7+MlVfwWA425zQ2t7WI
         qwEBKCtITBKLj9sDNuieWpkOY17hytM34ZZTQageZu2WoPe7zMLEwPj5AAM3zIYi+maI
         gD2f/PA+uuc7rY54EOJyS91/YPX9hXpR1Iu5OEfHozYnw9uhu7SFjfw2bK6IvgZrukKi
         fGAg==
X-Gm-Message-State: AOAM531nljdmmvFBI/zkWII/qXtsDaXwBDGEtDTaUDPRskuxlletacSC
        kDFKI/Lx45FsW6q5O0nM8aPtsLCZp9B8iT1bXGWiCcdZ5LCT6AAs6VJMDSoBbFLRrSC80blGIGA
        qfjbdE0vSCWkL
X-Received: by 2002:a05:6638:183:: with SMTP id a3mr4732207jaq.47.1622821076890;
        Fri, 04 Jun 2021 08:37:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQxo+zfw3yLheApkfMNT19Kxv+RF4mWzeBkwzbgyKeWykIJlgSP3F1B+dw6s35/Bocj5BfPQ==
X-Received: by 2002:a05:6638:183:: with SMTP id a3mr4732182jaq.47.1622821076638;
        Fri, 04 Jun 2021 08:37:56 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id d2sm3775869ilu.60.2021.06.04.08.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 08:37:56 -0700 (PDT)
Date:   Fri, 4 Jun 2021 09:37:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604093755.1d660a47.alex.williamson@redhat.com>
In-Reply-To: <MWHPR11MB1886C4BC352DDE03B44070C08C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210602111117.026d4a26.alex.williamson@redhat.com>
        <20210602173510.GE1002214@nvidia.com>
        <20210602120111.5e5bcf93.alex.williamson@redhat.com>
        <20210602180925.GH1002214@nvidia.com>
        <20210602130053.615db578.alex.williamson@redhat.com>
        <20210602195404.GI1002214@nvidia.com>
        <20210602143734.72fb4fa4.alex.williamson@redhat.com>
        <20210602224536.GJ1002214@nvidia.com>
        <20210602205054.3505c9c3.alex.williamson@redhat.com>
        <MWHPR11MB1886DC8ECF5D56FE485D13D58C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210603124036.GU1002214@nvidia.com>
        <20210603144136.2b68c5c5.alex.williamson@redhat.com>
        <MWHPR11MB1886C4BC352DDE03B44070C08C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Jun 2021 09:19:50 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, June 4, 2021 4:42 AM
> >   
> > > 'qemu --allow-no-snoop' makes more sense to me  
> > 
> > I'd be tempted to attach it to the -device vfio-pci option, it's
> > specific drivers for specific devices that are going to want this and
> > those devices may not be permanently attached to the VM.  But I see in
> > the other thread you're trying to optimize IOMMU page table sharing.
> > 
> > There's a usability question in either case though and I'm not sure how
> > to get around it other than QEMU or the kernel knowing a list of
> > devices (explicit IDs or vendor+class) to select per device defaults.
> >   
> 
> "-device vfio-pci" is a per-device option, which implies that the
> no-snoop choice is given to the admin then no need to maintain 
> a fixed device list in Qemu?

I think we want to look at where we put it to have the best default
user experience.  For example the QEMU vfio-pci device option could use
on/off/auto semantics where auto is the default and QEMU maintains a
list of IDs or vendor/class configurations where we've determined the
"optimal" auto configuration.  Management tools could provide an
override, but we're imposing some pretty technical requirements for a
management tool to be able to come up with good per device defaults.
Seems like we should consolidate that technical decision in one place.
Thanks,

Alex

