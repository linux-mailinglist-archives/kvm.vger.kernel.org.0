Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9951F5EEF3C
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 09:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiI2HiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 03:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbiI2HiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 03:38:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835AF13941A
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 00:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664437102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EtU8HP1rRMHMXLmU+RcQMq0RJUO/qXYiXZjHcG/czQU=;
        b=HH8sLW+Kz593XUMgW1MQpn4WrCXXiCgNkJTYYdaLuYRF2oUYqaHQlcc7AlbeP1DN+mFLgA
        sB3bGelNrPfbZmgtUNxGJOeqca2p1Enan4iRN45GWTY5gBJMDFCT3s1aladWIlEKkJfacX
        TAbY6YzhYS0si3mqu+0SA+QAkO5LHps=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-292-VzL8aL7vMwWKxEJkTIykJA-1; Thu, 29 Sep 2022 03:38:21 -0400
X-MC-Unique: VzL8aL7vMwWKxEJkTIykJA-1
Received: by mail-wm1-f70.google.com with SMTP id y15-20020a1c4b0f000000b003b47578405aso163598wma.5
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 00:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=EtU8HP1rRMHMXLmU+RcQMq0RJUO/qXYiXZjHcG/czQU=;
        b=5JJxbAnthRmRQjUqdtzCT82+VqVcrzN9So3MDckvQ5oO0MPUXhTv9ggd2x/rCYbnmZ
         cqEKDBD+TeuWMEauoCBeLdNvnRcwF1ZjBEfWzwY0uQNxwMzjpyZyUxvi+t996o31fmCH
         kjvdWu/DCGWYz/8EjfnKA4ALCZUULx1Zn0xD25wYZWclOBde+p295yAQFa9MahAB4mMs
         wuGxgjEzYKf8wn8A4RLpP+DPSl926E/0l9spJ+n07lz1ts8NuDcIE1kshJPfV5IWVuae
         tKzJsE0wMa9TVT8zTETPX82LcGPHhj/7fjN8RZ5bZKnB/UhzgXomhw7pukp9GYQ6nf0N
         JTmQ==
X-Gm-Message-State: ACrzQf3LqAQ5Nm0vNaw5bPYWiq3LTzf1xa0GswvJTwjzSwLbMd5KGneg
        gGSGMzFH2aP/Zgk/+yShKEteLIKZEZ86BAtY7jY2uGO3prcN6yJwVu8g7q8SQ0yniNFoi1C5VBd
        DoK9o7SRQuznu
X-Received: by 2002:a05:600c:b47:b0:3b4:8604:410c with SMTP id k7-20020a05600c0b4700b003b48604410cmr1224701wmr.51.1664437099830;
        Thu, 29 Sep 2022 00:38:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5g6rBu5QPYx9aQ8mXAgqZl+RIeinGA8XoV5PQpBXrrGB5+Tr4uCc8Xa8taFU+6U5nEO1ZyHg==
X-Received: by 2002:a05:600c:b47:b0:3b4:8604:410c with SMTP id k7-20020a05600c0b4700b003b48604410cmr1224688wmr.51.1664437099556;
        Thu, 29 Sep 2022 00:38:19 -0700 (PDT)
Received: from redhat.com ([2.55.47.213])
        by smtp.gmail.com with ESMTPSA id z2-20020a05600c0a0200b003b48dac344esm3808228wmp.43.2022.09.29.00.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:38:19 -0700 (PDT)
Date:   Thu, 29 Sep 2022 03:38:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V3 0/6] Conditionally read fields in dev cfg space
Message-ID: <20220929033805-mutt-send-email-mst@kernel.org>
References: <20220929014555.112323-1-lingshan.zhu@intel.com>
 <896fe0b9-5da2-2bc6-0e46-219aa4b9f44f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <896fe0b9-5da2-2bc6-0e46-219aa4b9f44f@intel.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 29, 2022 at 03:23:46PM +0800, Zhu, Lingshan wrote:
> Hi Michael,
> 
> Jason starts his vacation this afternoon, and next week is our national
> holiday.
> He has acked 3 ~ 6 of this series before, and I have made improvements based
> on his comments.
> Do you have any comments on patches 1 and 2?


No, I'll merge for next.

> Thanks,
> Zhu Lingshan
> On 9/29/2022 9:45 AM, Zhu Lingshan wrote:
> > This series intends to read the fields in virtio-net device
> > configuration space conditionally on the feature bits,
> > this means:
> > 
> > MTU exists if VIRTIO_NET_F_MTU is set
> > MAC exists if VIRTIO_NET_F_NET is set
> > MQ exists if VIRTIO_NET_F_MQ or VIRTIO_NET_F_RSS is set.
> > 
> > This series report device features to userspace and invokes
> > vdpa_config_ops.get_config() rather than
> > vdpa_get_config_unlocked() to read the device config spcae,
> > so no races in vdpa_set_features_unlocked()
> > 
> > Thanks!
> > 
> > Changes form V2:
> > remove unnacessary checking for vdev->config->get_status (Jason)
> > 
> > Changes from V1:
> > 1)Better comments for VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,
> > only in the header file(Jason)
> > 2)Split original 3/4 into separate patches(Jason)
> > 3)Check FEATURES_OK for reporting driver features
> > in vdpa_dev_config_fill (Jason)
> > 4) Add iproute2 example for reporting device features
> > 
> > Zhu Lingshan (6):
> >    vDPA: allow userspace to query features of a vDPA device
> >    vDPA: only report driver features if FEATURES_OK is set
> >    vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's presence
> >    vDPA: check virtio device features to detect MQ
> >    vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
> >    vDPA: conditionally read MTU and MAC in dev cfg space
> > 
> >   drivers/vdpa/vdpa.c       | 68 ++++++++++++++++++++++++++++++---------
> >   include/uapi/linux/vdpa.h |  4 +++
> >   2 files changed, 56 insertions(+), 16 deletions(-)
> > 

