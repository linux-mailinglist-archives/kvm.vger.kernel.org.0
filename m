Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3033BA7BE
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 10:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhGCIO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jul 2021 04:14:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229893AbhGCIO1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Jul 2021 04:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625299913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KNgXYIOgFk3/50sq9zIL4S0YcLBbQBv9LP1nNZa2JAA=;
        b=Is/0ClB5ELfAofWQMDsaxB3Kb/nK36FlRH+ZEQksYtN1iYzZEhCa91txECZEvXPM/BYrgC
        77wawFIYhKYRuu9/tFxSCaIW69s+HvY1Q4KSQco49rFgyXD1HljYwNbw9jhnMGkauVjN08
        s5RuufRHWPytaeGyAD4/TG58VzTWu2w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-NXxHjz_RMMCMYrALcL7VNw-1; Sat, 03 Jul 2021 04:11:51 -0400
X-MC-Unique: NXxHjz_RMMCMYrALcL7VNw-1
Received: by mail-wm1-f71.google.com with SMTP id u64-20020a1cdd430000b02901ed0109da5fso7484560wmg.4
        for <kvm@vger.kernel.org>; Sat, 03 Jul 2021 01:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KNgXYIOgFk3/50sq9zIL4S0YcLBbQBv9LP1nNZa2JAA=;
        b=ZjzCj6On0E+Z+AoLdQvhyuvEKNrVa0LqER2cgA9DeQaDwF1VWFGnKjZu+EeMcT3pPv
         upxyKZ/maZS3UZrpGekLAyj4uCxawjAmsjNAqgWXsjHJZyxHHxJd/EJfNeCBDM2IEWGZ
         qP26z8IhFwyR2JM0ZtAApQDdthS4/BWoPunpWNDnVCgogW0haoxfLtuJ71n0awfmw8oQ
         hFzqKw92buGCN3hfZKXvgXJWt/juLdFVufSvsQQQxw/jo2NxIynYtq3fcgPyObGzMHd4
         fp3wkjPVuoemmp6gSEGtTJeo4oa1SxJQWJZauHjXjJuCg6jZBS9kX3YVhTvLt3sEyFok
         Ro2w==
X-Gm-Message-State: AOAM533k0slY8cPVYdJkk2YtxRxtoShvLxW0r9HZsA7F/kwop6p6Vxsc
        iZ/FKX0xvSEr182RmCJBa0AMv3+d/tkcJ6ZRh6/ezk1ujX6tmrevH6Gcbruu7iFBrGLu1mBk0nV
        N6J5vs7H9WggG
X-Received: by 2002:a05:600c:296:: with SMTP id 22mr3824976wmk.17.1625299910359;
        Sat, 03 Jul 2021 01:11:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwK/iU/CBYEp+7S7mKEGeGippXEk01Zz5EGl2SiAx3okylS3s7KpViTuEX44OaCNPVpb3WcZg==
X-Received: by 2002:a05:600c:296:: with SMTP id 22mr3824967wmk.17.1625299910246;
        Sat, 03 Jul 2021 01:11:50 -0700 (PDT)
Received: from redhat.com ([2.55.4.39])
        by smtp.gmail.com with ESMTPSA id j37sm2822258wms.37.2021.07.03.01.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 01:11:48 -0700 (PDT)
Date:   Sat, 3 Jul 2021 04:11:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Gautam Dawar <gdawar.xilinx@gmail.com>, martinh@xilinx.com,
        hanand@xilinx.com, gdawar@xilinx.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: log warning message if vhost_vdpa_remove
 gets blocked
Message-ID: <20210703041124-mutt-send-email-mst@kernel.org>
References: <20210606132909.177640-1-gdawar.xilinx@gmail.com>
 <aa866c72-c3d9-9022-aa5b-b5a9fc9e946a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa866c72-c3d9-9022-aa5b-b5a9fc9e946a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 10:33:22PM +0800, Jason Wang wrote:
> 
> 在 2021/6/6 下午9:29, Gautam Dawar 写道:
> > From: Gautam Dawar <gdawar@xilinx.com>
> > 
> > If some module invokes vdpa_device_unregister (usually in the module
> > unload function) when the userspace app (eg. QEMU) which had opened
> > the vhost-vdpa character device is still running, vhost_vdpa_remove()
> > function will block indefinitely in call to wait_for_completion().
> > 
> > This causes the vdpa_device_unregister caller to hang and with a
> > usual side-effect of rmmod command not returning when this call
> > is in the module_exit function.
> > 
> > This patch converts the wait_for_completion call to its timeout based
> > counterpart (wait_for_completion_timeout) and also adds a warning
> > message to alert the user/administrator about this hang situation.
> > 
> > To eventually fix this problem, a mechanism will be required to let
> > vhost-vdpa module inform the userspace of this situation and
> > userspace will close the descriptor of vhost-vdpa char device.
> > This will enable vhost-vdpa to continue with graceful clean-up.
> > 
> > Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> > ---
> >   drivers/vhost/vdpa.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index bfa4c6ef554e..572b64d09b06 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -1091,7 +1091,11 @@ static void vhost_vdpa_remove(struct vdpa_device *vdpa)
> >   		opened = atomic_cmpxchg(&v->opened, 0, 1);
> >   		if (!opened)
> >   			break;
> > -		wait_for_completion(&v->completion);
> > +		wait_for_completion_timeout(&v->completion,
> > +					    msecs_to_jiffies(1000));
> > +		dev_warn_ratelimited(&v->dev,
> > +				     "%s waiting for /dev/%s to be closed\n",
> > +				     __func__, dev_name(&v->dev));

Can fill up the kernel log in this case ... dev_warn_once seems more
appropriate.

> >   	} while (1);
> >   	put_device(&v->dev);
> 
> 
> Acked-by: Jason Wang <jasowang@redhat.com>
> 

