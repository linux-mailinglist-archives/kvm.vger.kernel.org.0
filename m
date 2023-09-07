Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855427977CD
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjIGQdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbjIGQdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:33:43 -0400
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA992D73
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 09:33:12 -0700 (PDT)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-412195b1e9aso8293991cf.2
        for <kvm@vger.kernel.org>; Thu, 07 Sep 2023 09:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1694104280; x=1694709080; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KplJiPzBxNOpapXXXI8tqe4hm+W6bB0cw/mtgdg+JQc=;
        b=WBUtN2vsxA5EWJnh2YRWQQjsJ/PumR5AlOfcpBg8refDo6hbesrTTdJXvL/65SFXgc
         qcGlRrMCqvsUSZxw6UojKZxe0sIqAC2xBay3XHT3Z6EeNa6uHXhxQy23hQzXlkohOgbr
         U32z1lmlfXiK+b3T8j1YI4iIRnk5P6htMDSb0pd78kSC4Y3RWioDm8rNvCOIc7fr3Jwk
         V+cv9VYEMrFl+lnlcjoOf59LT+72enhHlamNrhj9iO8rHz7FcMpJSKMtQmoEoc47WJV5
         NYneX00WexqYGzXnECcDwtuXhYRruQ3kTi74JTQns137fWLgKyteYfmvGceMgOVuz7fS
         ZXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694104280; x=1694709080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KplJiPzBxNOpapXXXI8tqe4hm+W6bB0cw/mtgdg+JQc=;
        b=R+Dh84FsMePpF+jN0ionhv1Czj4KExjJcJbHrACe6TngQkNIj5qLQiFesePYq5aNOV
         FXh2V/4F6ZrhRWh/VqaDexuO8LO+9SfdQ7S4mCtgsrTll8PtTcdJhVLvxU425Kvriwv/
         x3FNk5L/b/otOQKCnZ66fNvN0vonaFnQ7KgtnrRmR0bNPeogjJ5QhSPRVQ1gmCP+ukOp
         aOkP4SfCAIc40V/r8D95zrVI4UdCa60pJ7igSog3qCqRhWP9frXrrB//zfoS4+tlAsEY
         wlu0vfQo7IKzBm/Txqbo2CK7AAxM2PVJC3U16UOn3BgAxjAn5lbLNLKyfR7IyUkWU76F
         jYzg==
X-Gm-Message-State: AOJu0YwDkcO5i90nA6BtJr7+vjkNWM1u4onXpFXYooc6zDKZVSXKKMhG
        XDK17FS3tDpl5nUK/pzm+8hmJErcGhOHnj6xMGM=
X-Google-Smtp-Source: AGHT+IGcYxYeHKIJTYTxIaKdKv42AR0cUYD5qydh4HN6EPxFKqkEbHOi+6fri8lZqsehxdUgDtzUfw==
X-Received: by 2002:a05:622a:15c1:b0:411:4d2b:67c1 with SMTP id d1-20020a05622a15c100b004114d2b67c1mr21548512qty.19.1694103930464;
        Thu, 07 Sep 2023 09:25:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-134-41-202-196.dhcp-dynamic.fibreop.ns.bellaliant.net. [134.41.202.196])
        by smtp.gmail.com with ESMTPSA id fj8-20020a05622a550800b004109d386323sm6255150qtb.66.2023.09.07.09.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 09:25:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qeHot-0017CW-Qm;
        Thu, 07 Sep 2023 13:25:27 -0300
Date:   Thu, 7 Sep 2023 13:25:27 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 2/3] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Message-ID: <ZPn5d8VFAo5PQmpj@ziepe.ca>
References: <20230829182720.331083-1-stefanha@redhat.com>
 <20230829182720.331083-3-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230829182720.331083-3-stefanha@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023 at 02:27:19PM -0400, Stefan Hajnoczi wrote:
> The memory layout of struct vfio_device_gfx_plane_info is
> architecture-dependent due to a u64 field and a struct size that is not
> a multiple of 8 bytes:
> - On x86_64 the struct size is padded to a multiple of 8 bytes.
> - On x32 the struct size is only a multiple of 4 bytes, not 8.
> - Other architectures may vary.
> 
> Use __aligned_u64 to make memory layout consistent. This reduces the
> chance of 32-bit userspace on a 64-bit kernel breakage.
> 
> This patch increases the struct size on x32 but this is safe because of
> the struct's argsz field. The kernel may grow the struct as long as it
> still supports smaller argsz values from userspace (e.g. applications
> compiled against older kernel headers).
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  include/uapi/linux/vfio.h        | 3 ++-
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 4 +++-
>  samples/vfio-mdev/mbochs.c       | 6 ++++--
>  samples/vfio-mdev/mdpy.c         | 4 +++-
>  4 files changed, 12 insertions(+), 5 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
