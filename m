Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514B05F14EA
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 23:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiI3Vb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 17:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiI3Vb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 17:31:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F94718CB30
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 14:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664573512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u99SFb2mm6IMO2C/mDjsVShY7ib8HgVHNq4m7TjUMlU=;
        b=is4Ec/N7Y2KZFLY5ROYxSVIlxZXpyWG1DB3xBBkpjx9MKPrBifwjC+NbAXZwljo7ID5HLI
        jKpsIBs5Ws8RAqJ6daIG1YCfmlIak7N6rH9USOZKZsna3yYio+WFbuQurKDPLEk4CQllAc
        simcdXY4+n/dxg8G+zcC+X/rTQeqv+w=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-283-q6Km0MQQMOqA9wLoBpKiow-1; Fri, 30 Sep 2022 17:31:51 -0400
X-MC-Unique: q6Km0MQQMOqA9wLoBpKiow-1
Received: by mail-io1-f71.google.com with SMTP id y187-20020a6bc8c4000000b006a4014e192fso3626547iof.21
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 14:31:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=u99SFb2mm6IMO2C/mDjsVShY7ib8HgVHNq4m7TjUMlU=;
        b=fQ2E7/EOspDrAciLVSuNNVzrPoBuvMwm2M3VMZfV/ShiTbBY/d5EpReeSyNbPcWl62
         VX+eZGu26uAm6+2LU3j4SSIp3PAvR4/+8v+U2q3cTIbdCDsqGrEBQpuH687a8bDF137a
         gRF69KqUX3DS1n+2IdsgwMwdzn7h6c3X7Pac3QeYQG9ytCVZKb+WSFW3cYaYcCAAbd1x
         fx6e3NJhTu5B7ZzeEHJ933QllNZer5CD6cb2kSIrFTXdNcrpWnZ97b/rh10uvyOe6Lhl
         JI36IG2tLHxHUlkHqpZpP7Vmhhqz5A7hXGX8Y1avOdm94u91+BKMfxgIriHGZl7KMA4F
         h0MA==
X-Gm-Message-State: ACrzQf0uPg4FMfPmVlIE704Dpl64bkbXpzBHNk07SLAm/FU1tFNmQ+/z
        C+wGnz8hLv6mIUdydGAEtju71CFr5m5aKLk7xWsMQESXHBVF/sYC4WDUCP2oOr25zsqJucN2L59
        DC0PE0k+9fgOB
X-Received: by 2002:a05:6638:3712:b0:35a:9c8a:698d with SMTP id k18-20020a056638371200b0035a9c8a698dmr5772787jav.151.1664573510566;
        Fri, 30 Sep 2022 14:31:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4VTcmsFBjypWqMFwP2pQez8YMxKnmnM54iEalnSS3t8MH21D5OVP8HPDXTGJs8BfLF5xZXKQ==
X-Received: by 2002:a05:6638:3712:b0:35a:9c8a:698d with SMTP id k18-20020a056638371200b0035a9c8a698dmr5772780jav.151.1664573510387;
        Fri, 30 Sep 2022 14:31:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f16-20020a056638169000b0035a578870a4sm1337172jat.129.2022.09.30.14.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 14:31:49 -0700 (PDT)
Date:   Fri, 30 Sep 2022 15:31:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: Re: simplify the mdev interface v8
Message-ID: <20220930153148.5eb8808e.alex.williamson@redhat.com>
In-Reply-To: <20220928121110.GA30738@lst.de>
References: <20220923092652.100656-1-hch@lst.de>
        <20220927140737.0b4c9a54.alex.williamson@redhat.com>
        <20220927155426.23f4b8e9.alex.williamson@redhat.com>
        <20220928121110.GA30738@lst.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Sep 2022 14:11:10 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Sep 27, 2022 at 03:54:26PM -0600, Alex Williamson wrote:
> > Oops, I had to drop this, I get a null pointer from gvt-g code:  
> 
> Ok, this is a stupid bug in the second patch in the series.  I did not
> hit it in my mdev testing as my script just uses the first type and
> thus never hits these, but as your trace showed mdevctl and once I
> used that I could reproduce it.  The fix for patch 2 is below, and
> the git tree at:
> 
>    git://git.infradead.org/users/hch/misc.git mvdev-lifetime
> 
> has been updated with that folded in and the recent reviews.
> 
> ---
> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
> index 1b67328c714f1..b0d5dafd013f4 100644
> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> @@ -123,7 +123,7 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
>  
>  		sprintf(gvt->types[i].name, "GVTg_V%u_%s",
>  			GRAPHICS_VER(gvt->gt->i915) == 8 ? 4 : 5, conf->name);
> -		gvt->types->conf = conf;
> +		gvt->types[i].conf = conf;
>  		gvt->types[i].avail_instance = min(low_avail / conf->low_mm,
>  						   high_avail / conf->high_mm);

Fix folded in, re-applied to vfio next branch for v6.1.  Thanks,

Alex

