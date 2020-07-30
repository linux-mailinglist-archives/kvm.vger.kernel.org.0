Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA82B233652
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 18:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgG3QIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 12:08:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56605 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728452AbgG3QIk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 12:08:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596125319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qUqXLll+NefydSj//AgmT8C1K6WHp8sxKqjeN68cy/c=;
        b=P9Is4vT31V72vfeftlCYxg4ElT/PZqdeIhRNrDLXfh12ZGmDjwWXEGz2bFayvoz6IyLLrw
        UX5bpUYZD2XZ8xKTJnTJlLOf1x1lM5W24jXHBPk8Hr9huB6HdV2ObLTS+7GmJSUK95HFS/
        AZ+sJEgX6i0uFXlFDP7kaRbEAGjOtMo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-BdQB1nUEMg2C4-fuetlYtg-1; Thu, 30 Jul 2020 12:08:35 -0400
X-MC-Unique: BdQB1nUEMg2C4-fuetlYtg-1
Received: by mail-wm1-f71.google.com with SMTP id t26so2371708wmn.4
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 09:08:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qUqXLll+NefydSj//AgmT8C1K6WHp8sxKqjeN68cy/c=;
        b=nJ5TTAjH9Vk1eGwhwtCnGMa/yM/gUXbj0+t3LkafD2x6oUHul7GGS0xuk0RnUwElDg
         vwtyeHTgbsj2Gg3MAFc3lrr9zvRidCtGKLKD6BKLCNC1Ti63PRo+axh1cdjGmqHFyygB
         PMnaZcSEDq2fEFru3zggJy5NqMd/c3xZ9URCbyo8Sws5GSOpj/hyEDA0vLZAPevwuR0K
         bidSC0puIaAFNS7uZMzoWpzo9Oa1xWNvGuKqjfIDtridfkfuoqIGaFKjhm1EjyfbtDnA
         FsitRa700qY2jymnHC7EBMIEMVLfXLTpu7/RcvyOj9q2tovkd7pxukx7SYuFcxF15S3I
         yJLA==
X-Gm-Message-State: AOAM532kBmTtqz0uTyEb41nYvugtm5jYC7uZ8tpoOPl7cGXTy1yLtQr0
        RTjF4R3GEN0oApsxsn1xgiKO+79uKwiV6ild90YDMkAfJ3yw+SUrzsVOlPQ8R/7Ose0nkAqVx3+
        0TRmWrXzmGRk7
X-Received: by 2002:a1c:2095:: with SMTP id g143mr36497wmg.78.1596125314304;
        Thu, 30 Jul 2020 09:08:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8EEO1xnALZftyrn6Van6xavkoUdqm7ncbftjelxThfdJiLZtzyAchyb3bUf7eXUGwTaOiKg==
X-Received: by 2002:a1c:2095:: with SMTP id g143mr36424wmg.78.1596125313141;
        Thu, 30 Jul 2020 09:08:33 -0700 (PDT)
Received: from redhat.com (bzq-79-179-105-63.red.bezeqint.net. [79.179.105.63])
        by smtp.gmail.com with ESMTPSA id g7sm10167067wrv.82.2020.07.30.09.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 09:08:32 -0700 (PDT)
Date:   Thu, 30 Jul 2020 12:08:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v4 0/4] Add a vhost RPMsg API
Message-ID: <20200730120805-mutt-send-email-mst@kernel.org>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 05:09:23PM +0200, Guennadi Liakhovetski wrote:
> Hi,
> 
> Now that virtio-rpmsg endianness fixes have been merged we can 
> proceed with the next step.

Which tree is this for?


> v4:
> - add endianness conversions to comply with the VirtIO standard
> 
> v3:
> - address several checkpatch warnings
> - address comments from Mathieu Poirier
> 
> v2:
> - update patch #5 with a correct vhost_dev_init() prototype
> - drop patch #6 - it depends on a different patch, that is currently
>   an RFC
> - address comments from Pierre-Louis Bossart:
>   * remove "default n" from Kconfig
> 
> Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> cases. It can however also be used for virtualisation scenarios,
> e.g. when using KVM to run Linux on both the host and the guests.
> This patch set adds a wrapper API to facilitate writing vhost
> drivers for such RPMsg-based solutions. The first use case is an
> audio DSP virtualisation project, currently under development, ready
> for review and submission, available at
> https://github.com/thesofproject/linux/pull/1501/commits
> 
> Thanks
> Guennadi
> 
> Guennadi Liakhovetski (4):
>   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
>   rpmsg: move common structures and defines to headers
>   rpmsg: update documentation
>   vhost: add an RPMsg API
> 
>  Documentation/rpmsg.txt          |   6 +-
>  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
>  drivers/vhost/Kconfig            |   7 +
>  drivers/vhost/Makefile           |   3 +
>  drivers/vhost/rpmsg.c            | 375 +++++++++++++++++++++++++++++++
>  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
>  include/linux/virtio_rpmsg.h     |  83 +++++++
>  include/uapi/linux/rpmsg.h       |   3 +
>  include/uapi/linux/vhost.h       |   4 +-
>  9 files changed, 553 insertions(+), 80 deletions(-)
>  create mode 100644 drivers/vhost/rpmsg.c
>  create mode 100644 drivers/vhost/vhost_rpmsg.h
>  create mode 100644 include/linux/virtio_rpmsg.h
> 
> -- 
> 2.27.0

