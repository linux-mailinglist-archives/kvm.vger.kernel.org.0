Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346B62614B8
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 18:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731939AbgIHQei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 12:34:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52002 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731436AbgIHQeR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 12:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599582856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cGbsX/FJObXX4YBouoES7lf5iOTDE5vymSl8SE+mxG0=;
        b=PfcB/16pTxs+cJe8E2hkpENRdRhrISFfH5+VrP8/jfa8mqVycVw4siIla5VUS//RnMXoHq
        lHrk8QJAJIT+kfbf32HKITJ6Isa4faPPRQs/5A/5C8OhQGz234tUMZ6MutKIO6UPGKqMof
        mi3ubvyiwLTP3NpFoxJ5v80UIeVumWg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-IfpywTPlNqad4nKFTExLaA-1; Tue, 08 Sep 2020 10:17:03 -0400
X-MC-Unique: IfpywTPlNqad4nKFTExLaA-1
Received: by mail-wr1-f71.google.com with SMTP id r15so6996992wrt.8
        for <kvm@vger.kernel.org>; Tue, 08 Sep 2020 07:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cGbsX/FJObXX4YBouoES7lf5iOTDE5vymSl8SE+mxG0=;
        b=Fp0pH428ZCZaUOnvz0B3ckd1zolY+P698IqJIp4+D57zsPZC4UUwfQTp8Kstzt3Juh
         UgLRB1nNE/ESepmvcrxp8Em+jD+xBe6s42H4svdta97XZFOSXB7o4/o8VlDg4jFDX00N
         RD1XzqwlEz3KD3JGeEJiM6EtNxqVour0Kk/ZE485IKO4e1YZgz5jJGBjK/4IpmvnDsn0
         ADJtvxUgg+/nU3WsDbmldq1nzhAv8NMO+BZaTafFn37GVp2TWuD6yWGGg7kvYCss0f8x
         T4T2XWeFmW4kMJqZ5+07LAQbAggI/OLPngcyQvjl063cB4wi+MMJKeh/8DW6B4dDyShJ
         mRWg==
X-Gm-Message-State: AOAM533d74FOOYB/VAO7Q47Sl8EfVtlAmnVDIusfUjz6rviVhCKD1awD
        ljlu/eM1Fu5BCm0s/RhbNEpmHZjzl2t6gZBGPabeZZt3eLAMe5e+qaJ1APBu9d5UzwaYmZWMOuK
        tzbywdNWvWQN7
X-Received: by 2002:a05:600c:2283:: with SMTP id 3mr4450614wmf.37.1599574622327;
        Tue, 08 Sep 2020 07:17:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxy7D775tAAMy+By64OwsXRHSGFwu87xaHXcz8utDT6nVrIQ1MHsq9D7+UOH4H77/ZKCANTdQ==
X-Received: by 2002:a05:600c:2283:: with SMTP id 3mr4450590wmf.37.1599574622080;
        Tue, 08 Sep 2020 07:17:02 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-218-236.inter.net.il. [80.230.218.236])
        by smtp.gmail.com with ESMTPSA id w7sm34151611wrm.92.2020.09.08.07.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 07:16:59 -0700 (PDT)
Date:   Tue, 8 Sep 2020 10:16:52 -0400
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
Subject: Re: [PATCH v5 0/4] Add a vhost RPMsg API
Message-ID: <20200908101617-mutt-send-email-mst@kernel.org>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 26, 2020 at 07:46:32PM +0200, Guennadi Liakhovetski wrote:
> Hi,
> 
> Next update:

OK could we get some acks from rpmsg folks on this please?
It's been quite a while, patchset is not huge.


> v5:
> - don't hard-code message layout
> 
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
>  drivers/vhost/rpmsg.c            | 373 +++++++++++++++++++++++++++++++
>  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
>  include/linux/virtio_rpmsg.h     |  83 +++++++
>  include/uapi/linux/rpmsg.h       |   3 +
>  include/uapi/linux/vhost.h       |   4 +-
>  9 files changed, 551 insertions(+), 80 deletions(-)
>  create mode 100644 drivers/vhost/rpmsg.c
>  create mode 100644 drivers/vhost/vhost_rpmsg.h
>  create mode 100644 include/linux/virtio_rpmsg.h
> 
> -- 
> 2.28.0

