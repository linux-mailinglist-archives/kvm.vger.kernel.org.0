Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C735577BF55
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 19:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjHNRwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 13:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbjHNRw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 13:52:29 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E41172B
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:52:19 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id 006d021491bc7-56e0bd33797so1398597eaf.0
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1692035539; x=1692640339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uPVktipHR+zcbSodfTpb3XBmJmcoL0W6CfGs9OCLYNE=;
        b=mVDtQzd8MHNyxorFjlWbKe61eqmNhOA9pfMOqHFa7Ec/bADYHlcuoS5/OHt0VCnTOx
         NaJAl4w3FAiUFmZt6cu2m+AtARGcXFC94dOXLMn30mQ1+d+w/Alum0xRKCvtCIrrBgcu
         HeICg4DGbZ6hvV3HN6b73hJDu9i0bUCX2NLxgVIhDdYESPyR6olqbtV3wgWHw4jX+YRy
         +JYdx+NsrzhaJHbKOoJKfV0XDn7g9rRQFhCTowzdUxywaAY6E01N/gzjj/xHxqCOt0+V
         ZRuPyA7bnfzeQFUhQ3Y3NNo4pWWoME3TrkXJcE2OLQ+ef5M8EY1uidlLu8EGWprUK3oP
         rHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692035539; x=1692640339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPVktipHR+zcbSodfTpb3XBmJmcoL0W6CfGs9OCLYNE=;
        b=NWMH1JySHa/NAB6alyF/p0ZkCidQCGBJy7JofT1HRMu5pBvGe/x5rTMTOXZcmfT83s
         LY6cU+DcsllJZT6XU+TnZRLh2UUubQBjekxE7SCHXvYK1XXhWPBBeVA3Cpc2U0aFHikX
         SMAt2GX8gJD3Na6WJs7nD7DFt/1XXMWf82YGSAbPAXbHVf4G6X6yd6YBDF/F10cFwYCp
         W92SlPbqGD/149iFFCyrNOxIzdbJh02Y8SRSy2GBb/++kgZqoQ+uXOTcJXUPmE10xKR3
         fFXJ/CRWWkzH0iY86/nXy6hOBoJX55yBzm4dHnbqhWGx3awBz+8LQ9Jm8tqLSX3uE8AU
         8ZjA==
X-Gm-Message-State: AOJu0YyMxCwTnz6JMwok0wRIxwzRcBuX+OkKTR2SbRvgvam7u1Rjm8u4
        zKxcxMFAvMfwVnQuZ0VXNU7c1A==
X-Google-Smtp-Source: AGHT+IHOhOpWvPjOGvkcdFMoAbgFEcs4qtjnrZmuX8GY0VlauHTC8TNCRgC7r3FFsu0oet1AEAb/zQ==
X-Received: by 2002:a05:6358:8a7:b0:13a:4855:d8f0 with SMTP id m39-20020a05635808a700b0013a4855d8f0mr6962015rwj.5.1692035539024;
        Mon, 14 Aug 2023 10:52:19 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id w6-20020ac87186000000b00403e80cad67sm3256843qto.41.2023.08.14.10.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 10:52:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qVbjl-0070EN-Sw;
        Mon, 14 Aug 2023 14:52:17 -0300
Date:   Mon, 14 Aug 2023 14:52:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 4/4] vfio: use __aligned_u64 in struct
 vfio_device_ioeventfd
Message-ID: <ZNpp0Zrv1vMSDBUx@ziepe.ca>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-5-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809210248.2898981-5-stefanha@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 05:02:48PM -0400, Stefan Hajnoczi wrote:
> The memory layout of struct vfio_device_ioeventfd is
> architecture-dependent due to a u64 field and a struct size that is not
> a multiple of 8 bytes:
> - On x86_64 the struct size is padded to a multiple of 8 bytes.
> - On x32 the struct size is only a multiple of 4 bytes, not 8.
> - Other architectures may vary.
> 
> Use __aligned_u64 to make memory layout consistent. This reduces the
> chance of holes that result in an information leak and the chance that
> 32-bit userspace on a 64-bit kernel breakage.
> 
> This patch increases the struct size on x32 but this is safe because of
> the struct's argsz field. The kernel may grow the struct as long as it
> still supports smaller argsz values from userspace (e.g. applications
> compiled against older kernel headers).
> 
> The code that uses struct vfio_device_ioeventfd already works correctly
> when the struct size grows, so only the struct definition needs to be
> changed.
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  include/uapi/linux/vfio.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
