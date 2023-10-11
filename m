Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E117C5E41
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 22:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346890AbjJKUVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 16:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbjJKUVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 16:21:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E6393
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 13:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697055624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0YsRsJouzUJ/dnrS+pndtkgSFm0ftdvhFuS9Oam6h7o=;
        b=DfES14bR1PsNrHjqrklkqr/3TE5lBovJUT45Mkk3ZM1Peb2vhy5henqc0e4ASTco5roaQ0
        MY6b8qZy7yuBgzdRSXNC4EFGA75lHiKHkQu58ltWWKjOGpdezt2aG2DHlVDdFUlggAAy92
        zlzluPBYKnXrsfe2lUy+AnPv/ScD4oM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-zZLLNIY6NTG7oet-WihOTQ-1; Wed, 11 Oct 2023 16:20:23 -0400
X-MC-Unique: zZLLNIY6NTG7oet-WihOTQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-321f75cf2bdso105735f8f.2
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 13:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697055622; x=1697660422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0YsRsJouzUJ/dnrS+pndtkgSFm0ftdvhFuS9Oam6h7o=;
        b=i54FdDni0Lb8yyCpMSfIHRHqRPQE7PRjBxoSLoSsYLlkd022a6SVi3FIhcFQJ8de95
         0lfv4Ds6EUpIYw3vwa/EeQdTkjhNQY9DPMGkRpyt4mdxgzSSAbyjaxMxEdrOJP+Yv/cs
         Qmnx+Fzk1pUPbrxSKj4XeVhUglR/KhcO1u51hhHVsscdf958IXlfIwMv7WtjVrE3c1ny
         IdCdkj4G47s5Q8HbjZiatIN0h8JFDjWdh0sU/mEq/D8T12fPT3ecZNgCz46gPt5YloZ7
         sd4wXqSbSRG1Kts1gFJt3HaybxAiC5orh77UfIaSIF4necVuDrWkBz5Gk+nNnd5YshIR
         OMxw==
X-Gm-Message-State: AOJu0YwpMY2pL6avtq0rP38xVUyRPl516euyCWu7iHf4zMsIh55ojkeI
        zg4iDUG7+S2hx0+k4jqRPzB7Y49gtZAzC4tb+v/IsBNkVPQYAz/lEw/vsdv+0IOBkQnJLw7wfQJ
        t+Y/dNlgcdnZG
X-Received: by 2002:a5d:69d0:0:b0:31f:fa61:961d with SMTP id s16-20020a5d69d0000000b0031ffa61961dmr21085702wrw.63.1697055622337;
        Wed, 11 Oct 2023 13:20:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiTyuUP7E7CnT9V2Z71OJD0K9u5DZp2nC+aSD/NLEJ54Qtnm9hP+lqS4NcSc0EFQFG8Kpf1w==
X-Received: by 2002:a5d:69d0:0:b0:31f:fa61:961d with SMTP id s16-20020a5d69d0000000b0031ffa61961dmr21085675wrw.63.1697055622048;
        Wed, 11 Oct 2023 13:20:22 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d5407000000b00327df8fcbd9sm16437706wrv.9.2023.10.11.13.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 13:20:21 -0700 (PDT)
Date:   Wed, 11 Oct 2023 16:20:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011161935-mutt-send-email-mst@kernel.org>
References: <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <ZSZAIl06akEvdExM@infradead.org>
 <20231011135709.GW3952@nvidia.com>
 <ZSaudclSEHDEsyDP@infradead.org>
 <20231011145810.GZ3952@nvidia.com>
 <20231011125426-mutt-send-email-mst@kernel.org>
 <20231011171944.GA3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011171944.GA3952@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 02:19:44PM -0300, Jason Gunthorpe wrote:
> On Wed, Oct 11, 2023 at 12:59:30PM -0400, Michael S. Tsirkin wrote:
> > On Wed, Oct 11, 2023 at 11:58:10AM -0300, Jason Gunthorpe wrote:
> > > Trying to put VFIO-only code in virtio is what causes all the
> > > issues. If you mis-design the API boundary everything will be painful,
> > > no matter where you put the code.
> > 
> > Are you implying the whole idea of adding these legacy virtio admin
> > commands to virtio spec was a design mistake?
> 
> No, I'm saying again that trying to relocate all the vfio code into
> drivers/virtio is a mistake
> 
> Jason

Yea please don't. And by the same token, please do not put
implementations of virtio spec under drivers/vfio.

-- 
MST

