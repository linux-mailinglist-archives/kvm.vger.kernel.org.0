Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7245155EC5
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 20:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgBGTsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 14:48:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38341 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727009AbgBGTsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 14:48:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581104916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UvpPfUMiwANMI5u+GVArzdqSMKMh2UqZnM1jU2+L7ac=;
        b=FYRuzd+uelYpNIoGX/4Tns8boYkHajmxBP88q6wO0McUCXdQP3LFWha1QVTf5+dUtZQTnT
        eucZKFkxIlI3eczRC2RtLjoY8Go2tsBqw4wwa47Nxa7H4glTCB8cB8dulTuwoKtbAY1idI
        edvhOLAUhp97RbXmq9No72mcvRXcsPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-Eo6Q_iuiOjSVlqbPbVqE9w-1; Fri, 07 Feb 2020 14:48:34 -0500
X-MC-Unique: Eo6Q_iuiOjSVlqbPbVqE9w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CAC9805462;
        Fri,  7 Feb 2020 19:48:32 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCBB75C21A;
        Fri,  7 Feb 2020 19:48:31 +0000 (UTC)
Date:   Fri, 7 Feb 2020 12:48:31 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH v2 1/9] vfio/pci: split vfio_pci_device into public
 and private parts
Message-ID: <20200207124831.391d5f70@w520.home>
In-Reply-To: <20200131020956.27604-1-yan.y.zhao@intel.com>
References: <20200131020803.27519-1-yan.y.zhao@intel.com>
        <20200131020956.27604-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 21:09:56 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> split vfio_pci_device into two parts:
> (1) a public part,
>     including pdev, num_region, irq_type which are accessible from
>     outside of vfio.
> (2) a private part,
>     a pointer to vfio_pci_device_private, only accessible within vfio
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 209 +++++++++++++++-------------
>  drivers/vfio/pci/vfio_pci_config.c  | 157 +++++++++++----------
>  drivers/vfio/pci/vfio_pci_igd.c     |  16 +--
>  drivers/vfio/pci/vfio_pci_intrs.c   | 171 ++++++++++++-----------
>  drivers/vfio/pci/vfio_pci_nvlink2.c |  16 +--
>  drivers/vfio/pci/vfio_pci_private.h |   5 +-
>  drivers/vfio/pci/vfio_pci_rdwr.c    |  36 ++---
>  include/linux/vfio.h                |   7 +
>  8 files changed, 321 insertions(+), 296 deletions(-)

I think the typical solution to something like this would be...

struct vfio_pci_device {
	...
};

struct vfio_pci_device_private {
	struct vfio_pci_device vdev;
	...
};

External code would be able to work with the vfio_pci_device and
internal code would do a container_of() to get access to the private
fields.  What's done here is pretty ugly and not very cache friendly.
Thanks,

Alex

