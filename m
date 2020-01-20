Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFE7142A61
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 13:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgATMRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 07:17:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51334 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726958AbgATMRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 07:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579522657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8L+ILVTS7iEVpEf9FQ7Niyp0BU3VQIiebmcN8SzOcl8=;
        b=Q8jJfz8kyQyUMTq+IqvBSU4xbhlSH9LCcDAIZk5+hsFJTxy9yMXVXtc0X/wvSkx+ykf66Q
        ttNo9gVr8SXSpg3wS/nySmKhQEqoIUSAVzraxC/kXD8JBTvYO2H/vDUGf32YfZJhNU2vRM
        uXaJUloQwg1Pf7GxPEsxVZJDV9WTUDs=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-0F_-xcQDOQSV35bnbG0xnw-1; Mon, 20 Jan 2020 07:17:36 -0500
X-MC-Unique: 0F_-xcQDOQSV35bnbG0xnw-1
Received: by mail-qt1-f198.google.com with SMTP id m8so21013203qta.20
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 04:17:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8L+ILVTS7iEVpEf9FQ7Niyp0BU3VQIiebmcN8SzOcl8=;
        b=r3eDLOjl6IBuDty9mN7yPBH2p633Euo2O0Zwyh5PR5eyr2Po/ScOhJsc3p/7amf/bY
         1Fly3fLTe8p3dJ/PjK3/MtePmvmXhWQ/S62266FPMdHPM73G3iP60R8aT+Au8O591IJW
         UVlrLNFyokM1aZfTJuevE5aeoE+YYSdL0UxR8HOB3PvrQzfiDwHC1rINGMC6/vIJXHHx
         ptb0rbcM7joi17RU3acfAeSo66T6wjtaqBSD1sYkwxY9Eurw/LO+LZFaxySKBJZnRzWj
         VAEs0vmPWbD4TU2vqINgFAyfqP/N5RhhT5uroxRCI5CCkAa6qCW273STf2mIWl1M262C
         GUUQ==
X-Gm-Message-State: APjAAAWUEipMNQBL+QE+HFrZfMgn315etk6e/lUtON/v+yaMBWYlUCYW
        XM5fEyD2/MB3RM4aI3WzGGSGY2GZCGyK9ZNGrk4RceTuSRJrjVtYHUHEKfmNvaul37khqXJQCrh
        wXv+C1R6X4EDX
X-Received: by 2002:ac8:784:: with SMTP id l4mr19850108qth.286.1579522656239;
        Mon, 20 Jan 2020 04:17:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNA60FKJeMn0/BVl0tQjIyzqQrUvdMi0GrHZyiN0uIGAcUXWQkWAFroQqD7gDCIK6n3lBLSQ==
X-Received: by 2002:ac8:784:: with SMTP id l4mr19850095qth.286.1579522655996;
        Mon, 20 Jan 2020 04:17:35 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id y26sm17884235qtc.94.2020.01.20.04.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 04:17:34 -0800 (PST)
Date:   Mon, 20 Jan 2020 07:17:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Message-ID: <20200120071406-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200116152209.GH20978@mellanox.com>
 <03cfbcc2-fef0-c9d8-0b08-798b2a293b8c@redhat.com>
 <20200117135435.GU20978@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117135435.GU20978@mellanox.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 17, 2020 at 01:54:42PM +0000, Jason Gunthorpe wrote:
> > 1) "virtio" vs "vhost", I implemented matching method for this in mdev
> > series, but it looks unnecessary for vDPA device driver to know about this.
> > Anyway we can use sysfs driver bind/unbind to switch drivers
> > 2) virtio device id and vendor id. I'm not sure we need this consider the
> > two drivers so far (virtio/vhost) are all bus drivers.
> 
> As we seem to be contemplating some dynamic creation of vdpa devices I
> think upon creation time it should be specified what mode they should
> run it and then all driver binding and autoloading should happen
> automatically. Telling the user to bind/unbind is a very poor
> experience.

Maybe but OTOH it's an existing interface. I think we can reasonably
start with bind/unbind and then add ability to specify
the mode later. bind/unbind come from core so they will be
maintained anyway.
-- 
MST

