Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74117C0127
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbjJJQEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbjJJQEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:04:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4192B0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696953818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P+deqZTg535bR4HNi5vsiV2bgBuh6QmSGi99vJ4+UXs=;
        b=R+UoRlnOhh9Ld2Opj5nLW5AxFFKEb4Jqc3nhbA9WKw0ik6aakWCCODPOJs0HvviKWXsmyd
        zAuebEIxNksULzTMuqgZ0KADgRwPIaBdqM930Iq4JWULtUbCpmRuExGLZctkPCs17Pp04G
        Mt5ujtAXCH5BYNW5CVYSxJ7a+RaBQkM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-HM4on3p1P1eFSv9AoyQgXw-1; Tue, 10 Oct 2023 12:03:37 -0400
X-MC-Unique: HM4on3p1P1eFSv9AoyQgXw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-325a78c806eso3670746f8f.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:03:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696953816; x=1697558616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+deqZTg535bR4HNi5vsiV2bgBuh6QmSGi99vJ4+UXs=;
        b=Wt1Noy2g6hkiRvrg8D0H1P6QSei5LO7JEOlpXPPcuHCy9oVF8XTy7734WzbwHgFrWS
         clw7dUZvICJvv15Vq+x1iav5l0SkkaOCVUzQUY/d/hpBen2wmC5VOMwENlod5cdi4YV4
         X4sMU/0ygr2cnn6vfAEYSseoTnfpzn2vpsZCMHebeXl3sDY5LisPA6iiC71lfgBAHTld
         GXvyzZKcOkmqvPCbp0k43r5i6yWMkYNKwe0S8+v4i5Brf5E+qJtqAqToYLURLbr6zLgE
         CEzLfoNEE0L4Tjvg2lIhauFmDlGA+CM2ZdrpjDixaHJJ6FkFlU/9YLmfAof418CVPkE+
         JIkQ==
X-Gm-Message-State: AOJu0Yzl+wPzdiebGy38TJOzfOkL1+VoYLz2QxwNW5/O3K2EEMiEgynu
        FdBIuym2gLgAFhS1izU4g1SjLcpkgM53gLBy5CBHX68ReG0S3zxDq9s1d5S5uviT4d71foFb0Y2
        cDB3JT52ii1Yj
X-Received: by 2002:adf:ec83:0:b0:323:3346:7d51 with SMTP id z3-20020adfec83000000b0032333467d51mr15733203wrn.18.1696953816399;
        Tue, 10 Oct 2023 09:03:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOcjKGaMOeZZSsZZ/GsS4kBRlzVK2MGUeCU1BbYf2Jw03gcFg1F6hRkT1aSZutRdEwXBsM0A==
X-Received: by 2002:adf:ec83:0:b0:323:3346:7d51 with SMTP id z3-20020adfec83000000b0032333467d51mr15733182wrn.18.1696953816009;
        Tue, 10 Oct 2023 09:03:36 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id o28-20020adfa11c000000b0032cafeae7fasm2673135wro.34.2023.10.10.09.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 09:03:34 -0700 (PDT)
Date:   Tue, 10 Oct 2023 12:03:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        alex.williamson@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231010120158-mutt-send-email-mst@kernel.org>
References: <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010155937.GN3952@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 12:59:37PM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 10, 2023 at 11:14:56AM -0400, Michael S. Tsirkin wrote:
> 
> > I suggest 3 but call it on the VF. commands will switch to PF
> > internally as needed. For example, intel might be interested in exposing
> > admin commands through a memory BAR of VF itself.
> 
> FWIW, we have been pushing back on such things in VFIO, so it will
> have to be very carefully security justified.
> 
> Probably since that is not standard it should just live in under some
> intel-only vfio driver behavior, not in virtio land.
> 
> It is also costly to switch between pf/vf, it should not be done
> pointlessly on the fast path.
> 
> Jason

Currently, the switch seems to be just a cast of private data.
I am suggesting keeping that cast inside virtio. Why is that
expensive?

