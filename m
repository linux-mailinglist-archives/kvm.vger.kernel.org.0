Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1894C538AF5
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 07:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244044AbiEaFkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 01:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244038AbiEaFkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 01:40:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A567B941B0
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 22:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653975638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g0/inTPXCkYCa8tPwUAmu5S5vMTpS/z+cw62yovLB+o=;
        b=LxSvOBjA2hxBOF5ewriXxPgQ8kPWVn3pN2x5WCqawoGDdo+gPk7C7234JQliQ/rTvnMnce
        I6KQ+fhnrvCX2oWm753RQiXGzbRsElnfmDzp8dgbFetJAJNCMUS7FB9EYqZOsCvm+RYXH4
        bltG5LozyLvKUuiRO3BrQsYitpOe1v4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-IPS2-KnOPJyycCfVV93K3g-1; Tue, 31 May 2022 01:40:35 -0400
X-MC-Unique: IPS2-KnOPJyycCfVV93K3g-1
Received: by mail-wm1-f72.google.com with SMTP id m10-20020a05600c3b0a00b003948b870a8dso848402wms.2
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 22:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=g0/inTPXCkYCa8tPwUAmu5S5vMTpS/z+cw62yovLB+o=;
        b=PDdXsw2v1IkmafsEYf97d1rkS1tG1ZEc6PkQvSyS3jIG00zsNNd2BLeHpANZDCjX+j
         5vaqGn8k+jHqaI+Na0hwqKaw4Z+jZVQ207eUF26x1aCh7DpV74P9kyaHMGZnW3QEpAjY
         TCxGg9R8J/x1Lzx8POUrs8qCCFseYJCxDoOabZkqeMpjnfUOJdjmu/tlQSH8/KeTp0bA
         v1SsQGefiQ/Pr8k2UkSa8b5zD7XaemozfTq+IW4gZeX2vNLhzTYrN33KJ3FBU1NcNWyk
         c7lGiFq2SKUYo3JKULUb1JkVH5lpAwdKpa65Hmkl6N9EKrjmey3IRZETCjQFgrRQj3wB
         ZfYg==
X-Gm-Message-State: AOAM530wLJyDVl0BFM9woN7S2yLStvTmVvoXOrReZWB3vhQYh0RO6+Sj
        Gax53aCEAdIxr1LKSoH+Mw2xH8lXOIrIPYt78Ht7wNoJtaIE4yKmG5d5ixQ7+tD8Vyp0S++TnE9
        PvbnU+2aH7vzY
X-Received: by 2002:a05:6000:2c8:b0:210:ddd:170c with SMTP id o8-20020a05600002c800b002100ddd170cmr19414113wry.338.1653975634516;
        Mon, 30 May 2022 22:40:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGl9FELIFTb9xFqXU89C9vQtydLRw+e/4/cFXIEETVgJhiweAwF7+L8FqRQddILAHWIYlsNg==
X-Received: by 2002:a05:6000:2c8:b0:210:ddd:170c with SMTP id o8-20020a05600002c800b002100ddd170cmr19414081wry.338.1653975634242;
        Mon, 30 May 2022 22:40:34 -0700 (PDT)
Received: from redhat.com ([2.52.157.68])
        by smtp.gmail.com with ESMTPSA id m3-20020a05600c3b0300b003942a244f2fsm1153615wms.8.2022.05.30.22.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 22:40:33 -0700 (PDT)
Date:   Tue, 31 May 2022 01:40:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
Message-ID: <20220531013913-mutt-send-email-mst@kernel.org>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org>
 <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 30, 2022 at 11:39:21AM +0800, Jason Wang wrote:
> On Fri, May 27, 2022 at 6:56 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, May 26, 2022 at 12:54:32PM +0000, Parav Pandit wrote:
> > >
> > >
> > > > From: Eugenio Pérez <eperezma@redhat.com>
> > > > Sent: Thursday, May 26, 2022 8:44 AM
> > >
> > > > Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> > > >
> > > > that backend feature and userspace can effectively stop the device.
> > > >
> > > >
> > > >
> > > > This is a must before get virtqueue indexes (base) for live migration,
> > > >
> > > > since the device could modify them after userland gets them. There are
> > > >
> > > > individual ways to perform that action for some devices
> > > >
> > > > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there
> > > > was no
> > > >
> > > > way to perform it for any vhost device (and, in particular, vhost-vdpa).
> > > >
> > > >
> > > >
> > > > After the return of ioctl with stop != 0, the device MUST finish any
> > > >
> > > > pending operations like in flight requests. It must also preserve all
> > > >
> > > > the necessary state (the virtqueue vring base plus the possible device
> > > >
> > > > specific states) that is required for restoring in the future. The
> > > >
> > > > device must not change its configuration after that point.
> > > >
> > > >
> > > >
> > > > After the return of ioctl with stop == 0, the device can continue
> > > >
> > > > processing buffers as long as typical conditions are met (vq is enabled,
> > > >
> > > > DRIVER_OK status bit is enabled, etc).
> > >
> > > Just to be clear, we are adding vdpa level new ioctl() that doesn’t map to any mechanism in the virtio spec.
> > >
> > > Why can't we use this ioctl() to indicate driver to start/stop the device instead of driving it through the driver_ok?
> > > This is in the context of other discussion we had in the LM series.
> >
> > If there's something in the spec that does this then let's use that.
> 
> Actually, we try to propose a independent feature here:
> 
> https://lists.oasis-open.org/archives/virtio-dev/202111/msg00020.html
> 
> Does it make sense to you?
> 
> Thanks

But I thought the LM patches are trying to replace all that?


> > Unfortunately the LM series seems to be stuck on moving
> > bits around with the admin virtqueue ...
> >
> > --
> > MST
> >

