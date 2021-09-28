Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8A341B84F
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 22:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242682AbhI1Uaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 16:30:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234794AbhI1Uaw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 16:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632860952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Px75PZplZbEMaaLvg/IKZKQmq+Fd+/Xi4N5X7tKeYOU=;
        b=ImWgttDYofD+RsRC+jkMU+UoWFiTfDACDAV2GEnw4DMTmypzhK0igLqN2bKIwYEtsyClOy
        jkh2N3zoPszniSDqw2/sRl1eG86qutP7h0tIzI6wL8vDOxART8C4/IwVOynfZe1+ZCcJxp
        lKRlHGh8Yxy1EOJxf8G0SMjUBrtAfp8=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-Vw_EfihCNfyznV2-tdv7tQ-1; Tue, 28 Sep 2021 16:29:11 -0400
X-MC-Unique: Vw_EfihCNfyznV2-tdv7tQ-1
Received: by mail-yb1-f197.google.com with SMTP id d81-20020a251d54000000b005b55772ca97so219979ybd.19
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 13:29:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Px75PZplZbEMaaLvg/IKZKQmq+Fd+/Xi4N5X7tKeYOU=;
        b=07mRfka6ozTRAU9iLj9zkOz8p2WqVxejExJdjLsefjpcZwSsBLT6+SUhJfennUtTzR
         CDQlS/MDM6L0tMBnsHDoB5T3gi59JX+r977ci9pQv6nqxyciviH0bYNRbKdwi3rjRskp
         QXCbQ/khxW9d1zW+3AL2eLf+tnfrH/PGZAoaE1B7rlJJgHAz/CXxMQ4wvydbA9Emi6w2
         MSDj3rfPFOPwLzj5YOLpeyAY+qcJBWcpMAYmIHj64iysV8GLmvOVWZ6s9xd//9YURyuI
         2ehqIUMNIr9OiD3NRVjd7LzUPPB25VyIWFG7+RVuxKMNm+WhrL3J9rZoNtW0CjPG5PKn
         ObMg==
X-Gm-Message-State: AOAM532OkgXumYb1KV93U3hUqkEi1WUos2fUfMM+jRizcdKjuhsaKXzR
        DAgujNvEdjMxCAZLJM6ATCs7omvbH+fX8fYJw7lCigNPWi/oIzVznGbG42sQ+bPPC8fjy6rEQr7
        2HTrKm5bbZAeX
X-Received: by 2002:a05:6830:314e:: with SMTP id c14mr6935946ots.37.1632860552497;
        Tue, 28 Sep 2021 13:22:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR8N6ivbHyTQeeTuTu5EyUCFoNeJ/uw+Yu3F+JZpS9o76cUotJSm8am7W0TX6GQTPc2NRTNg==
X-Received: by 2002:a05:6830:314e:: with SMTP id c14mr6935926ots.37.1632860552311;
        Tue, 28 Sep 2021 13:22:32 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id 21sm41504oix.1.2021.09.28.13.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 13:22:32 -0700 (PDT)
Date:   Tue, 28 Sep 2021 14:22:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 6/7] mlx5_vfio_pci: Expose migration commands
 over mlx5 device
Message-ID: <20210928142230.20b0153a.alex.williamson@redhat.com>
In-Reply-To: <7fc0cf0d76bb6df4679b55974959f5494e48f54d.1632305919.git.leonro@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
        <7fc0cf0d76bb6df4679b55974959f5494e48f54d.1632305919.git.leonro@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 13:38:55 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Yishai Hadas <yishaih@nvidia.com>
> 
> Expose migration commands over the device, it includes: suspend, resume,
> get vhca id, query/save/load state.
> 
> As part of this adds the APIs and data structure that are needed to
> manage the migration data.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5_vfio_pci_cmd.c | 358 +++++++++++++++++++++++++++
>  drivers/vfio/pci/mlx5_vfio_pci_cmd.h |  43 ++++
>  2 files changed, 401 insertions(+)
>  create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.c
>  create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.h

Should we set the precedent of a vendor sub-directory like we have
elsewhere?  Either way I'd like to see a MAINTAINERS file update for the
new driver.  Thanks,

Alex

