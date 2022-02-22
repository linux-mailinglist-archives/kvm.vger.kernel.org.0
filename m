Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ACA4BF33B
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 09:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiBVILj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 03:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiBVILi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 03:11:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA9BE151D0C
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 00:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645517473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G0GfwrcLD4lf4ANifuaF1OYMcDG4+GeX0AlNzDkoZxA=;
        b=h9ROzele10f/YWxkob4+Zes8X7Obqul5nO1tTSUm63YJOg8/R3iqziQTmsJDyY5cmR+TTC
        V6iKNy2PGsK++Rm36eGIyD2v/1IL8C9gSWVwlBkLZs4bGPGP7zieZMxtcEgQtTB9RTVu2T
        Ex8cJbvJe56cpg1rTE0ahZh4DnFS6YY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-g2Y-fP_XNPmdDAV6l6gQ2Q-1; Tue, 22 Feb 2022 03:11:11 -0500
X-MC-Unique: g2Y-fP_XNPmdDAV6l6gQ2Q-1
Received: by mail-qv1-f71.google.com with SMTP id c8-20020a0ce7c8000000b0042c12357076so20150045qvo.6
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 00:11:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G0GfwrcLD4lf4ANifuaF1OYMcDG4+GeX0AlNzDkoZxA=;
        b=rmAXfAFS0kO/1hoty16ogHDjLgGCJp3psI6s4mOM4HbI5UeUJ8BJSexgKmw3mKw/ps
         PGn46Uw1U2rvk45J5mzZa/CxJOm32Gml7YCKjdgY77xLwSgkx0S3k82OC9x79aFLjwGc
         XI+Ez81o2KqqKn73eMypnyVgJip3XNmLnPOpMC6B3XYflGWpy5ootjBhB4HS3uvDml0c
         aqoJAWMHwBhQ4WKH7PMrVF48Z/N9ISGKrYrY9WBRWVZzF83TUUMVcslg00NzmoScUEcI
         UTN3SkHRYcI7/MsEKnOpkl5EHINpy7D37NjF03rk1eQ4rqfAIhX7lbbUlyN2/YQvaxKE
         HnDA==
X-Gm-Message-State: AOAM530xCI+/S4MgyY53DmbZ1Bgr2w/ubVTIhQEYOg9F7O//N6enw22Z
        75pYpPactfhR40myew4OBBHwUH1ZblDAYTerVn8XDLHgcoMq1Vl8ulM/hu/86M3rkL7aYMTk1bb
        tkwbNgh8N0heN
X-Received: by 2002:a05:620a:3706:b0:648:afb4:5794 with SMTP id de6-20020a05620a370600b00648afb45794mr8516396qkb.433.1645517471387;
        Tue, 22 Feb 2022 00:11:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6pPGdI38EWvdExU9PjVYF+abcYYxcjPH+D5uHZtUns1W/zgUWgRUc58bwXKp5JDZUPsdCOQ==
X-Received: by 2002:a05:620a:3706:b0:648:afb4:5794 with SMTP id de6-20020a05620a370600b00648afb45794mr8516386qkb.433.1645517471142;
        Tue, 22 Feb 2022 00:11:11 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id n16sm5744274qkn.115.2022.02.22.00.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 00:11:10 -0800 (PST)
Date:   Tue, 22 Feb 2022 09:11:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, "Michael S. Tsirkin" <mst@redhat.com>,
        lkp@intel.com, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Asias He <asias@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <20220222081104.a2woahjgno2iv7yl@sgarzare-redhat>
References: <20220221114916.107045-1-sgarzare@redhat.com>
 <202202220707.AM3rKUcP-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202202220707.AM3rKUcP-lkp@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 08:30:17AM +0300, Dan Carpenter wrote:
>Hi Stefano,
>
>url:    https://github.com/0day-ci/linux/commits/Stefano-Garzarella/vhost-vsock-don-t-check-owner-in-vhost_vsock_stop-while-releasing/20220221-195038
>base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
>config: x86_64-randconfig-m031-20220221 (https://download.01.org/0day-ci/archive/20220222/202202220707.AM3rKUcP-lkp@intel.com/config)
>compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>
>If you fix the issue, kindly add following tag as appropriate
>Reported-by: kernel test robot <lkp@intel.com>
>Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>smatch warnings:
>drivers/vhost/vsock.c:655 vhost_vsock_stop() error: uninitialized symbol 'ret'.
>
>vim +/ret +655 drivers/vhost/vsock.c
>
>3ace84c91bfcde Stefano Garzarella 2022-02-21  632  static int vhost_vsock_stop(struct vhost_vsock *vsock, bool check_owner)
>433fc58e6bf2c8 Asias He           2016-07-28  633  {
>433fc58e6bf2c8 Asias He           2016-07-28  634  	size_t i;
>433fc58e6bf2c8 Asias He           2016-07-28  635  	int ret;
>433fc58e6bf2c8 Asias He           2016-07-28  636
>433fc58e6bf2c8 Asias He           2016-07-28  637  	mutex_lock(&vsock->dev.mutex);
>433fc58e6bf2c8 Asias He           2016-07-28  638
>3ace84c91bfcde Stefano Garzarella 2022-02-21  639  	if (check_owner) {
>433fc58e6bf2c8 Asias He           2016-07-28  640  		ret = vhost_dev_check_owner(&vsock->dev);
>433fc58e6bf2c8 Asias He           2016-07-28  641  		if (ret)
>433fc58e6bf2c8 Asias He           2016-07-28  642  			goto err;
>3ace84c91bfcde Stefano Garzarella 2022-02-21  643  	}
>
>"ret" not initialized on else path.

Oooops, I was testing with vhost_vsock_dev_release() where we don't 
check the ret value, but of course we need to initialize it to 0 for the 
vhost_vsock_dev_ioctl() use case.

I'll fix in the v2.

Thanks for the report,
Stefano

