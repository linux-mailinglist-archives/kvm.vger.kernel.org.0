Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A151C45C8DC
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 16:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241850AbhKXPme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 10:42:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241758AbhKXPmd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 10:42:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637768363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2ZAQ9bYIpFW8w5nnJ2NX1dTFB2zcv9+w2ukWOWPCF5I=;
        b=VAlpX7IqzWtTm059kr65xTpzweeSwR5fXX1VFPaNKcDRLd38z2MkFrOzLEu7GVP1Y3YHnv
        PFTiDgUEpytoQRWWRA8gvhjcxbU1vnokkMB++Ng+NQHCFUgdvhqH8j3jESYfa0UFOjBAaM
        Ma1WRzojfx9ZHuXfQh3Rj0jTwqUbMyM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-1npDLHsWOwK3JEgNGmNWvQ-1; Wed, 24 Nov 2021 10:39:22 -0500
X-MC-Unique: 1npDLHsWOwK3JEgNGmNWvQ-1
Received: by mail-ed1-f70.google.com with SMTP id i19-20020a05640242d300b003e7d13ebeedso2722983edc.7
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 07:39:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ZAQ9bYIpFW8w5nnJ2NX1dTFB2zcv9+w2ukWOWPCF5I=;
        b=yjvDn1FYwkUnA7g3xhGOHHpY7ekVODjHKhRBuqLhQVTSVFBS/iQ5XJDgqfOkrUxcZg
         mziZ0qvTetpSLsacRqPrVd5VTH1UGR+82R3cqzk39kEpiuYtthYVEx9cjOnE9r5IpP++
         4Gh8zEtFapdlOOrAYuKth87V5FIKwcLI4HOPXmZkd/emvp2xcKgn2coysc+TAj1TJkm0
         5fsXKsoI8eyRy+JWprDHWiZefxU/kyZ8KtMvtlmeAAjHucX5AQXgDwzRj5y4wTnczdwi
         CIj1P3bJejn3J+4oF8uW3MfaaUhAqZqw2kTSpMWTWs+5TytsyYtzCDz6z/W4ICvWrsdK
         uJ4A==
X-Gm-Message-State: AOAM532QBnpbGoXkISlBVImwWpP0t/S8ZziOXEbYIhGkNYYqfzHgYV5A
        fOXoU2NQ+cwIAPwERjhsuYJCnN+b640U5Gx2BW6+OtXGa8H2GMEkofbHKE2Vh0gpfqTO387Tgcj
        YaNZp461eXTYE
X-Received: by 2002:a17:906:4bcf:: with SMTP id x15mr21211718ejv.273.1637768360443;
        Wed, 24 Nov 2021 07:39:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIoRH2WtnFT3cwBPr87hT88WyQOrA/0ZJYyfvukNGh+Cf3LGP/KgoKVcbcNm0UQ/svUQrL/A==
X-Received: by 2002:a17:906:4bcf:: with SMTP id x15mr21211655ejv.273.1637768360136;
        Wed, 24 Nov 2021 07:39:20 -0800 (PST)
Received: from steredhat (host-87-10-72-39.retail.telecomitalia.it. [87.10.72.39])
        by smtp.gmail.com with ESMTPSA id u16sm103149ejy.16.2021.11.24.07.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 07:39:19 -0800 (PST)
Date:   Wed, 24 Nov 2021 16:39:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Cindy Lu <lulu@redhat.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH V4 0/3] vDPA/ifcvf: enables Intel C5000X-PL virtio-blk
Message-ID: <CAGxU2F622pzZkh8WC7J+jGYu-_ozSDx1Tvvvtw-z52xwC3S38A@mail.gmail.com>
References: <20210419063326.3748-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419063326.3748-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhu,

On Mon, Apr 19, 2021 at 8:39 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This series enabled Intel FGPA SmartNIC C5000X-PL virtio-blk for vDPA.

Looking at the IFCVF upstream vDPA driver (with this series applied), it 
seems that there is still some cleaning to be done to support virtio-blk 
devices:

- ifcvf_vdpa_get_config() and ifcvf_vdpa_set_config() use
  `sizeof(struct virtio_net_config)` to check the inputs.
  This seems wrong for a virtio-blk device. Maybe we can set the config
  size for each device in ifcvf_vdpa_dev_add() and use that field to
  check the inputs. We can reuse the same field also in
  ifcvf_vdpa_get_config_size().

- Just for make the code more readable we should rename `net_cfg` field
  to `device_cfg`in `struct ifcvf_hw`.

What do you think?

Thanks,
Stefano

