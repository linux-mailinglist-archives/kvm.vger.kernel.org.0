Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5DB67868B
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 20:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjAWTiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 14:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjAWTiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 14:38:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175173250F
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674502646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vWogAhmj1NvtjWCQKs+r5RRl21/4W7OFkx5SINebkk=;
        b=htwvFvDHjbcaURmolX68XCVE0P5ePiM1/1TuyX2C7Xazj1WOf/3dVeEmvAB0daiJBYeBwA
        qSUDWL9mBQu3ziCA/VRESlZoDqnN67Lm3lOpYIjK0H25FvhwHl5GHkinP04ob0a0U66/86
        rTMVO+ptXrMGSuqTHU6b6s6eLF5Mdik=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-311-XvJqs4ySPke185ev51NPbQ-1; Mon, 23 Jan 2023 14:37:25 -0500
X-MC-Unique: XvJqs4ySPke185ev51NPbQ-1
Received: by mail-io1-f72.google.com with SMTP id u1-20020a5d8181000000b006ee29a8c421so7592060ion.19
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:37:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vWogAhmj1NvtjWCQKs+r5RRl21/4W7OFkx5SINebkk=;
        b=ZfIuVTQ25/XbLIhKkW3aKbr1u4Tt/GUsxLTenziq9XNtgDB3GDRkmoMNzbiMFQW/4M
         k+RlNACigtlZSo4Lf7Jod1ewo1a0CR+hfAPPZt4aqbWxXpS1fO1Iqio4f+DdPIGvxscL
         dq4zlMKk6m72+vnU5xrTWU9C94Vj8adhLtzE7e6VClqsa1ag1GCyPhlqLAQ0cFyNvDkU
         owvr+rIQuFEMB6z0WX/w6ipakpl45aD6EdOEqIZ1tVLdTlsD3wX2lmuySSN/qo+F7PJd
         0z0ZaN/4CDj1w3UP5bWzd46FKLrshkkpyHUFkySZwN2mqaFufaoFPAbWEmtLyCNt1cKj
         R04Q==
X-Gm-Message-State: AFqh2krXfbfCTOHSE3b/qCVIKiV8Uij9B+mbfeU5yb3qEnGeRA2zFobk
        uYFyM1r97u2/1s9TBbx/+wkYxqVLCgdFPFnlHut8iREWw0NnePfL2DK0iwpF0RqY8HI674aQ+eI
        IGChk3yCouY/z
X-Received: by 2002:a6b:8ed5:0:b0:6dd:83b1:199b with SMTP id q204-20020a6b8ed5000000b006dd83b1199bmr18182832iod.16.1674502644418;
        Mon, 23 Jan 2023 11:37:24 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtu6Ly17bULQyFSGVLnyQUqC5oEfEglCgbjJ55TyAbA0Veuv1+y+vbu15OeDiLpyx1J/bGIWA==
X-Received: by 2002:a6b:8ed5:0:b0:6dd:83b1:199b with SMTP id q204-20020a6b8ed5000000b006dd83b1199bmr18182821iod.16.1674502644208;
        Mon, 23 Jan 2023 11:37:24 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v26-20020a056602059a00b00704c3128817sm7121378iox.43.2023.01.23.11.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 11:37:23 -0800 (PST)
Date:   Mon, 23 Jan 2023 12:37:03 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: misc mdev tidyups
Message-ID: <20230123123703.35074b2b.alex.williamson@redhat.com>
In-Reply-To: <20230110091009.474427-1-hch@lst.de>
References: <20230110091009.474427-1-hch@lst.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Jan 2023 10:10:05 +0100
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
> 
> this series tidies up the mdev Kconfig interaction and documentation a bit.
> 
> Diffstat:
>  Documentation/driver-api/vfio-mediated-device.rst |  108 ----------------------
>  Documentation/s390/vfio-ap.rst                    |    1 
>  arch/s390/Kconfig                                 |    6 -
>  arch/s390/configs/debug_defconfig                 |    1 
>  arch/s390/configs/defconfig                       |    1 
>  drivers/gpu/drm/i915/Kconfig                      |    2 
>  drivers/vfio/mdev/Kconfig                         |    8 -
>  samples/Kconfig                                   |   16 +--
>  samples/vfio-mdev/README.rst                      |  100 ++++++++++++++++++++
>  9 files changed, 115 insertions(+), 128 deletions(-)
> 

Applied to vfio next branch for v6.3.  Thanks,

Alex

