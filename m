Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F5E510366
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348540AbiDZQiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 12:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiDZQiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 12:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 440EE205C5
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650990913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LfsfOstOihKjpZcpPA+lYDNuveMEExmShKa1N/TShik=;
        b=CzcatVpoHbnyg9FtQ1X6fi6qpL7UYv6tPq3r+lrDOlFGpIZ4RxQvf50GDWv6uyqT9n1dsK
        L3lHvj87nr5o2tiowytHuCGN3T2YrnFRU7qiLEi67pqNJC6ZEphBKhOifg0RyaG7Tsonm8
        umOVfZSZwul0EC2Xbzq8nE2FLjFyAiw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-vReuIY8RMgCr6VO7mTX3Jg-1; Tue, 26 Apr 2022 12:35:11 -0400
X-MC-Unique: vReuIY8RMgCr6VO7mTX3Jg-1
Received: by mail-io1-f72.google.com with SMTP id k2-20020a0566022a4200b00654c0f121a9so14590597iov.1
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LfsfOstOihKjpZcpPA+lYDNuveMEExmShKa1N/TShik=;
        b=Y5ZQRThM8VIjbL9aKOaVPqJOSkUEQDvGwxF0OrPBZwDTr8i96kq2IKpLTkGzm/8JPp
         67IAK3Rv/r/6CX5m2vgWy9O6jN2pZpT8Aiilfw0RQ+xCTpK5fGUdTz17oeuFu4QW8tcT
         4WKQhnBt/Pq/ipsao/LPSK8ZBqWX4krkh2ghZKgQfLxNFGR7i7bSA46W071+kcaPuiHe
         wdgfuvw/ZtJUNYN615hAjOYK91VV5TxqyH+ljWTiTQGFI2rwqz+NT/lAR90fzLXZxq/g
         5tdhXgr+W1hK969CUOPB1RlNViOXrW+ksTswxXZk1SXQPYi/O59XU5CzThe+EsmmBU3v
         2/tw==
X-Gm-Message-State: AOAM531tEy0V6mWVF8HS/U2mjLjMVPVrjrXyr6ZOJ01t6GYtqXFdVMME
        q58Z5uk3HPSMJ27myGHkXtTBVKFHc3h+sOd1XCpSS4rLWFw/GmHTzN2wb/T91XsKPFCMxu2D9pD
        mGhJmC2qrzz7k
X-Received: by 2002:a05:6e02:19c8:b0:2cd:6c70:1090 with SMTP id r8-20020a056e0219c800b002cd6c701090mr9792465ill.212.1650990909515;
        Tue, 26 Apr 2022 09:35:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxS/wvN70OT99iYPeBPbnWvoQ3P7FmUM0RaRI3UQnFPCLKb1fMCWp9FKCRoz5y2K67IFl9DgQ==
X-Received: by 2002:a05:6e02:19c8:b0:2cd:6c70:1090 with SMTP id r8-20020a056e0219c800b002cd6c701090mr9792439ill.212.1650990909065;
        Tue, 26 Apr 2022 09:35:09 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k22-20020a6b6f16000000b0065434014fd2sm9559873ioc.18.2022.04.26.09.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 09:35:08 -0700 (PDT)
Date:   Tue, 26 Apr 2022 10:35:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "chao.p.peng@intel.com" <chao.p.peng@intel.com>,
        "yi.y.sun@intel.com" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220426103507.5693a0ca.alex.williamson@redhat.com>
In-Reply-To: <4ac4956cfe344326a805966535c1dc43@huawei.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <4f920d463ebf414caa96419b625632d5@huawei.com>
        <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
        <4ac4956cfe344326a805966535c1dc43@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Apr 2022 12:43:35 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: Eric Auger [mailto:eric.auger@redhat.com]
> > Sent: 26 April 2022 12:45
> > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; Yi
> > Liu <yi.l.liu@intel.com>; alex.williamson@redhat.com; cohuck@redhat.com;
> > qemu-devel@nongnu.org
> > Cc: david@gibson.dropbear.id.au; thuth@redhat.com; farman@linux.ibm.com;
> > mjrosato@linux.ibm.com; akrowiak@linux.ibm.com; pasic@linux.ibm.com;
> > jjherne@linux.ibm.com; jasowang@redhat.com; kvm@vger.kernel.org;
> > jgg@nvidia.com; nicolinc@nvidia.com; eric.auger.pro@gmail.com;
> > kevin.tian@intel.com; chao.p.peng@intel.com; yi.y.sun@intel.com;
> > peterx@redhat.com; Zhangfei Gao <zhangfei.gao@linaro.org>
> > Subject: Re: [RFC 00/18] vfio: Adopt iommufd  
> 
> [...]
>  
> > >>  
> > https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com  
> > >> /
> > >> [2] https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6
> > >> [3] https://github.com/luxis1999/qemu/tree/qemu-for-5.17-rc6-vm-rfcv1  
> > > Hi,
> > >
> > > I had a go with the above branches on our ARM64 platform trying to  
> > pass-through  
> > > a VF dev, but Qemu reports an error as below,
> > >
> > > [    0.444728] hisi_sec2 0000:00:01.0: enabling device (0000 -> 0002)
> > > qemu-system-aarch64-iommufd: IOMMU_IOAS_MAP failed: Bad address
> > > qemu-system-aarch64-iommufd: vfio_container_dma_map(0xaaaafeb40ce0,  
> > 0x8000000000, 0x10000, 0xffffb40ef000) = -14 (Bad address)  
> > >
> > > I think this happens for the dev BAR addr range. I haven't debugged the  
> > kernel  
> > > yet to see where it actually reports that.  
> > Does it prevent your assigned device from working? I have such errors
> > too but this is a known issue. This is due to the fact P2P DMA is not
> > supported yet.
> >   
> 
> Yes, the basic tests all good so far. I am still not very clear how it works if
> the map() fails though. It looks like it fails in,
> 
> iommufd_ioas_map()
>   iopt_map_user_pages()
>    iopt_map_pages()
>    ..
>      pfn_reader_pin_pages()
> 
> So does it mean it just works because the page is resident()?

No, it just means that you're not triggering any accesses that require
peer-to-peer DMA support.  Any sort of test where the device is only
performing DMA to guest RAM, which is by far the standard use case,
will work fine.  This also doesn't affect vCPU access to BAR space.
It's only a failure of the mappings of the BAR space into the IOAS,
which is only used when a device tries to directly target another
device's BAR space via DMA.  Thanks,

Alex

