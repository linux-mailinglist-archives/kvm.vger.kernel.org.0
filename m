Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A49C7AA09F
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjIUUnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjIUUnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:43:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C43F72407
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695327393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=saWUZSrGIUgLKbATr2AiGYIolUiT02alWb7IzP9TXk0=;
        b=LTVgp9sE2J6UL9tBxInCGR6SSUnGGpyLZJsj5wGPhonDBePDefULEBGcTcmQ7zLGvSKAI4
        i1AmLuo+OU2H/u1s4LLimJObaRlW2iY9vO50X3HNm6jUHbkht35tKAcIR2iERzvuUv5eQL
        Ju0MJEEQb0roNioSnwR4H4zdZCZM4jM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-Y0RmtcGdMyih5Jg8g_TfDQ-1; Thu, 21 Sep 2023 16:16:31 -0400
X-MC-Unique: Y0RmtcGdMyih5Jg8g_TfDQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9a1cf3e6c04so104787666b.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695327390; x=1695932190;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=saWUZSrGIUgLKbATr2AiGYIolUiT02alWb7IzP9TXk0=;
        b=oJYjyxK7TJojiOzqCR4ePbs8Wffep31uMdwJMZnDaSaT+QKAV9+NmJAndSrzEhB9+p
         WE+P6dxrhaZsjM/p+GBmH1eJnLvl9p+nL8hrBJlp7mbpWOTIhW2WQ+0WgqpMghMiMBer
         Zee0ZQ5uAIt7VZRrET67xQs8KtFWdGuvWdulcXh+NzNdDnQOmGW8I3hmOPxu8JhAfDex
         eGWLDNa9GO2jFhiIllsX+5HFb0h4XhuuxJInkNVmrDp+KhBvpwsihUuzs/ofpNoGltzr
         ybJZvJOvXrs7jvJlEOmG6rHNZTOBvthPtCUVZUKpbPHpNW4wmtROx38AiDpUe0rrT9Y3
         3AMw==
X-Gm-Message-State: AOJu0Yx/ReAPFc9gHWBjAW2snc0oA/4X/KojWz+HuAlSMwrsBNXU7OUF
        R3dNtMLr1tmBPuqkHz3vK6KV2X192MxfvE0ml4RTGLBWl9F+GmvuW+LgiduwLYjlfr3xLYTZZo/
        SS0kzq722SnpW
X-Received: by 2002:a17:906:2112:b0:9ae:46c7:90fe with SMTP id 18-20020a170906211200b009ae46c790femr4601438ejt.72.1695327390494;
        Thu, 21 Sep 2023 13:16:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGkqXZayrmqEI+6vajAalt0bMQCUu66YrBGYtF+rfYkKFS9tp0WSXzHgpz2lWhey55wX1zpw==
X-Received: by 2002:a17:906:2112:b0:9ae:46c7:90fe with SMTP id 18-20020a170906211200b009ae46c790femr4601417ejt.72.1695327390172;
        Thu, 21 Sep 2023 13:16:30 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id rh27-20020a17090720fb00b0099b6becb107sm1543511ejb.95.2023.09.21.13.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 13:16:29 -0700 (PDT)
Date:   Thu, 21 Sep 2023 16:16:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921155834-mutt-send-email-mst@kernel.org>
References: <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921195345.GZ13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 04:53:45PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 03:34:03PM -0400, Michael S. Tsirkin wrote:
> 
> > that's easy/practical.  If instead VDPA gives the same speed with just
> > shadow vq then keeping this hack in vfio seems like less of a problem.
> > Finally if VDPA is faster then maybe you will reconsider using it ;)
> 
> It is not all about the speed.
> 
> VDPA presents another large and complex software stack in the
> hypervisor that can be eliminated by simply using VFIO.

If all you want is passing through your card to guest
then yes this can be addressed "by simply using VFIO".

And let me give you a simple example just from this patchset:
it assumes guest uses MSIX and just breaks if it doesn't.
As VDPA emulates it can emulate INT#x for guest while doing MSI
on the host side. Yea modern guests use MSIX but this is about legacy
yes?


> VFIO is
> already required for other scenarios.

Required ... by some people? Most VMs I run don't use anything
outside of virtio.

> This is about reducing complexity, reducing attack surface and
> increasing maintainability of the hypervisor environment.
> 
> Jason

Generally you get better security if you don't let guests poke at
hardware when they don't have to. But sure, matter of preference -
use VFIO, it's great. I am worried about the specific patchset though.
It seems to deal with emulating virtio which seems more like a vdpa
thing. If you start adding virtio emulation to vfio then won't
you just end up with another vdpa? And if no why not?
And I don't buy the "we already invested in this vfio based solution",
sorry - that's not a reason upstream has to maintain it.

-- 
MST

