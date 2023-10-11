Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859A47C59BD
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 19:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbjJKRA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 13:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjJKRA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 13:00:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4D998
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 09:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697043577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5GbYfUjAH5Td6aPeboRpo17r0mDy+ld8mKJnmcV6AoE=;
        b=iWz+P3FJtJ4k6m7B4Zh/YAIKuhiozaskYEHXEwe03D6kEVHM/qfCj4aqTwAp+TyPE4a4yy
        o/4xA9zdDgGutakD67s+PMce+5aDi2GUasH/rcQKxCTrbNXvDjO0SUrTxVoQAJl6lsVnbD
        2Il3nNZIf/VpQQcn3Z1HCNoSBUwxDqk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-A7U7NCOJPlOzjSqqOjQtIA-1; Wed, 11 Oct 2023 12:59:36 -0400
X-MC-Unique: A7U7NCOJPlOzjSqqOjQtIA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32323283257so21976f8f.2
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 09:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697043575; x=1697648375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5GbYfUjAH5Td6aPeboRpo17r0mDy+ld8mKJnmcV6AoE=;
        b=QhwkFHJwAPebZCmcTyeP2QVWQH0PCIvTBcIMbG1oRj84OEOjkUIZEUbSrJceVMETB5
         YIFVS3m3eA1V++CRQF9OZZ4WIhPsmadgLCyU+N1Ahoh6NXXmDdkuJLv2+bVA3hrrAbkw
         tNuUg5ct9AivGO5nzJ32mzUOc1mwQ/bcRWMUPaoaCAYWoll/TqfowGLBfN8Rowfz5JU7
         OS4OaASM1w2AlfUEYEw3tmA/u3huj1pzdJ+sVO13cflDrE2/qIwVuTnKmbL3ayIofJXL
         VRrKgn42t2nFEM52aFeNizRax6rVMUZN8xpSVVlfEoj9B7xaVKSJfw/OmfhtYKwmq4Sd
         AwsQ==
X-Gm-Message-State: AOJu0YxagLgjaqn4p0/5eEj7gs2sMQT82oVxC9WZ9jDH7qAmNYCsVdpv
        5WkDw3FB5gPVYwdGODEC90DYrZ5e62V9VdzTXIo5DM81twlybC2ZF1gXTmrqiUckj2H8mVGyvZ/
        oZ24k2odfWm1U
X-Received: by 2002:adf:fc4c:0:b0:319:785a:fce0 with SMTP id e12-20020adffc4c000000b00319785afce0mr19279967wrs.26.1697043574867;
        Wed, 11 Oct 2023 09:59:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzyP3mneqxoCjoaVwVlX+/Yn8WcmOL9NWB8EnPdm+OZJhCgzQEYIYDMSGtTDUAjQGUu+JfyA==
X-Received: by 2002:adf:fc4c:0:b0:319:785a:fce0 with SMTP id e12-20020adffc4c000000b00319785afce0mr19279953wrs.26.1697043574531;
        Wed, 11 Oct 2023 09:59:34 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id s4-20020a5d6a84000000b00327bf4f2f14sm15982214wru.88.2023.10.11.09.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 09:59:32 -0700 (PDT)
Date:   Wed, 11 Oct 2023 12:59:30 -0400
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
Message-ID: <20231011125426-mutt-send-email-mst@kernel.org>
References: <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <ZSZAIl06akEvdExM@infradead.org>
 <20231011135709.GW3952@nvidia.com>
 <ZSaudclSEHDEsyDP@infradead.org>
 <20231011145810.GZ3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011145810.GZ3952@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 11:58:10AM -0300, Jason Gunthorpe wrote:
> Trying to put VFIO-only code in virtio is what causes all the
> issues. If you mis-design the API boundary everything will be painful,
> no matter where you put the code.

Are you implying the whole idea of adding these legacy virtio admin
commands to virtio spec was a design mistake?
It was nvidia guys who proposed it, so I'm surprised to hear you say this.

-- 
MST

