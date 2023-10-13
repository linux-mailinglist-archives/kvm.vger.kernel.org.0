Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9027C8735
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 15:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjJMNvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 09:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjJMNvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 09:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A211D95
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 06:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697205041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B+Ghitg1zY89Jip2T1goMJnTgMi5VDf/XGEOeNsAVBs=;
        b=OUO1XZA79LQxc2cx7on/ay+wGJdkkm22oZ+sb/dYHNmYkG3M1lfANDOyiEqnXpyGm982MJ
        4u58AkLquwyoYVd0StbjooI8XHsdKjUzo4jxnq3rEuKaO3WsA1DpomwE3WsjRZvzsMVf7u
        5rzI7ZMdGIVjNrUypyOhPrGLi98WZFQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-ixW8JdNUNTm6Sq-VOFhKeA-1; Fri, 13 Oct 2023 09:50:30 -0400
X-MC-Unique: ixW8JdNUNTm6Sq-VOFhKeA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31f79595669so1467259f8f.0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 06:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697205029; x=1697809829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+Ghitg1zY89Jip2T1goMJnTgMi5VDf/XGEOeNsAVBs=;
        b=GatuXRT8eGM52HKwAr114bSHaHbs62kmmHIfRXq1xd/rb4U7mC8xQ1g4Q+CZGQCmTa
         kkT0SOdAHA6XvVrJ6TStUwM9C2RqaT5GXGcxKOHgkw2n8KJ56jikERtymtBYx/pYPjG2
         oIFdoRPe/8p6CMvAXdLuTej8o9ldc1PoH4G/1Jc6cQj/BzMY/br4B2qYFKM/j+mrFESp
         Obcbf7YX4AFrxsbZ2zub6bW0M8Y5S4s3BqLcmIuYsKOCpRIRJ+9rW7jFUpzcLF13xxJt
         wGzm1ywKZsuCoQ4RVapwwre+hj219tlyZLXnpo1JD0K1v9BgGOzKN7zkaKltTNjOQiNS
         KbLA==
X-Gm-Message-State: AOJu0YzA9lFO1r+SNQVy8BpsAv2ZF/mNK61zITWuYzIRWG/RZhUj6U2k
        4qx/hTMFkgl88M7PfyXhTzJK3mDZWiW4RAKHTPe/SJAhXCOGlYdejEtEs1+1jBYfFaVNpJ6rvU4
        x6WYI5gFHpXOb
X-Received: by 2002:adf:e412:0:b0:319:5234:5c92 with SMTP id g18-20020adfe412000000b0031952345c92mr120245wrm.35.1697205029099;
        Fri, 13 Oct 2023 06:50:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFy51rKDdAxtUym1VLRrNj6iWl5I9WPsUhrr6dkM69Wf9Z+UOFeOueRGKhYYJIybHTT8hScQQ==
X-Received: by 2002:adf:e412:0:b0:319:5234:5c92 with SMTP id g18-20020adfe412000000b0031952345c92mr120230wrm.35.1697205028759;
        Fri, 13 Oct 2023 06:50:28 -0700 (PDT)
Received: from redhat.com ([2a02:14f:175:cf7d:d542:c2ef:a65c:aaad])
        by smtp.gmail.com with ESMTPSA id q14-20020adfcb8e000000b003296b488961sm20135825wrh.31.2023.10.13.06.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 06:50:28 -0700 (PDT)
Date:   Fri, 13 Oct 2023 09:50:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231013094959-mutt-send-email-mst@kernel.org>
References: <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c75bb669-76fe-ef12-817e-2a8b5f0b317b@intel.com>
 <20231012132749.GK3952@nvidia.com>
 <840d4c6f-4150-4818-a66c-1dbe1474b4c6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <840d4c6f-4150-4818-a66c-1dbe1474b4c6@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 06:28:34PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 10/12/2023 9:27 PM, Jason Gunthorpe wrote:
> 
>     On Thu, Oct 12, 2023 at 06:29:47PM +0800, Zhu, Lingshan wrote:
> 
> 
>         sorry for the late reply, we have discussed this for weeks in virtio mailing
>         list. I have proposed a live migration solution which is a config space solution.
> 
>     I'm sorry that can't be a serious proposal - config space can't do
>     DMA, it is not suitable.
> 
> config space only controls the live migration process and config the related
> facilities.
> We don't use config space to transfer data.
> 
> The new added registers work like queue_enable or features.
> 
> For example, we use DMA to report dirty pages and MMIO to fetch the dirty data.
> 
> I remember in another thread you said:"you can't use DMA for any migration
> flows"
> 
> And I agree to that statement, so we use config space registers to control the
> flow.
> 
> Thanks,
> Zhu Lingshan
> 
> 
>     Jason
> 

If you are using dma then I don't see what's wrong with admin vq.
dma is all it does.

