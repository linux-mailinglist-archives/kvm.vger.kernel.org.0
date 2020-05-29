Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45AB1E8B2F
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 00:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgE2WUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 18:20:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39255 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726943AbgE2WUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 18:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590790800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VApPujRUVX7cEh65SicFqJGyG5bmdkomZyrWPZ9YdFY=;
        b=ApPBEqg8aQv+YsQDWWDLIAracPWZ7WW5+RTsGYbCDdyhDZrfxAOCAwWIK1B83DnVqAow+P
        Y454MgaiPgVuGFwgN+mxidoDh9mMZBVI5PGmvA+DBF8GLmLy7Wmpp0z16406LGdjDunCIL
        t5M1Mk42c6cmNfmi0afzeX6BkfQV+JI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-J1-KAj-VPV6uqRB0g60qIg-1; Fri, 29 May 2020 18:19:56 -0400
X-MC-Unique: J1-KAj-VPV6uqRB0g60qIg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D10B0100A630;
        Fri, 29 May 2020 22:19:54 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 355FF62932;
        Fri, 29 May 2020 22:19:54 +0000 (UTC)
Date:   Fri, 29 May 2020 16:19:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     wu000273@umn.edu
Cc:     kjlu@umn.edu, Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Jike Song <jike.song@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/mdev: Fix reference count leak in
 add_mdev_supported_type.
Message-ID: <20200529161953.449ced87@x1.home>
In-Reply-To: <20200528020109.31664-1-wu000273@umn.edu>
References: <20200528020109.31664-1-wu000273@umn.edu>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 May 2020 21:01:09 -0500
wu000273@umn.edu wrote:

> From: Qiushi Wu <wu000273@umn.edu>
> 
> kobject_init_and_add() takes reference even when it fails.
> If this function returns an error, kobject_put() must be called to
> properly clean up the memory associated with the object. Thus,
> replace kfree() by kobject_put() to fix this issue. Previous
> commit "b8eb718348b8" fixed a similar problem.
> 
> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Qiushi Wu <wu000273@umn.edu>
> ---

Applied to vfio next branch for v5.8 with Connie's and Kirti's reviews.
Thanks,

Alex

>  drivers/vfio/mdev/mdev_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 8ad14e5c02bf..917fd84c1c6f 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -110,7 +110,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>  				   "%s-%s", dev_driver_string(parent->dev),
>  				   group->name);
>  	if (ret) {
> -		kfree(type);
> +		kobject_put(&type->kobj);
>  		return ERR_PTR(ret);
>  	}
>  

